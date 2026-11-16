
# Library Books REST API Design

## Introduction

This document describes a REST API for managing books in a library system.

The API allows users to retrieve, create, update, delete, and search for books by author.

Base URL:

`https://api.library.com`

## 1. List All Books

- **Method:** GET
- **Path:** `/books`
- **Description:** Retrieves a list of all books available in the library.
- **Success Status Code:** 200 OK
- **Example Request Body:** Not required.

## 2. Get a Single Book

- **Method:** GET
- **Path:** `/books/{id}`
- **Description:** Retrieves details of a specific book using its ID.
- **Success Status Code:** 200 OK
- **Example Request Body:** Not required.

## 3. Create a New Book

- **Method:** POST
- **Path:** `/books`
- **Description:** Adds a new book to the library.
- **Success Status Code:** 201 Created

### Example Request Body

```json
{
    "title": "Things Fall Apart",
    "author": "Chinua Achebe",
    "year": 1958,
    "genre": "Fiction"
}
```

## 4. Update a Book

- **Method:** PUT
- **Path:** `/books/{id}`
- **Description:** Updates the details of an existing book using its ID.
- **Success Status Code:** 200 OK

### Example Request Body

```json
{
    "title": "Things Fall Apart",
    "author": "Chinua Achebe",
    "year": 1958,
    "genre": "Historical Fiction"
}
```

## 5. Delete a Book

- **Method:** DELETE
- **Path:** `/books/{id}`
- **Description:** Deletes a specific book from the library using its ID.
- **Success Status Code:** 204 No Content
- **Example Request Body:** Not required.

## 6. List Books by Author

- **Method:** GET
- **Path:** `/books?author=Chinua Achebe`
- **Description:** Retrieves all books written by a specific author using a query parameter.
- **Success Status Code:** 200 OK
- **Example Request Body:** Not required.

## Error Responses

### 400 Bad Request

- **Description:** The request contains invalid data or missing required fields.
- **Example:** A user tries to create a book without providing its title.

### 404 Not Found

- **Description:** The requested resource does not exist.
- **Example:** A user tries to retrieve `/books/100` when book ID 100 does not exist.

## Conclusion

This REST API provides the basic operations needed to manage a library's books.

It supports retrieving, creating, updating, deleting, and searching for books by author.
