Day 8 Assignment: TicketHub Event Ticketing System Design
1. Requirements

TicketHub is an online ticketing platform where users can browse concerts and events, view available seats, reserve seats, make payments and access purchased tickets.

The system must handle normal daily traffic as well as large numbers of users trying to purchase tickets during popular concert sales.

Functional Requirements

The system should allow users to:

Register and log in to their accounts.
Browse available concerts and events.
View event details, dates, venues and ticket prices.
View available and unavailable seats.
Temporarily hold seats before completing payment.
Purchase tickets using a payment service.
View their purchased tickets and booking history.
Receive booking confirmations after successful payment.
Non-Functional Requirements
Performance: Event pages and seat availability should load quickly, preferably within 300 milliseconds under normal conditions.
Scalability: The system should support millions of registered users and handle large traffic spikes during popular ticket sales.
Reliability: The platform should remain available during busy ticket sales.
Correctness: Two users must never successfully purchase the same seat.
Security: User accounts and payment information must be protected.
Fairness: Users should be processed through a controlled waiting queue during extremely busy sales.
Consistency: Seat availability and completed bookings must remain accurate across the system.
2. Traffic Estimates
Given Information
Registered users: 2 million.
Normal daily visitors: 50,000.
Pages viewed per visitor: 10.
Normal daily ticket sales: 5,000.
Big sale visitors: 200,000.
Available seats for a popular concert: 20,000.
Big sale duration: 10 minutes.
Normal Traffic Calculations

Daily page views:

50,000 × 10 = 500,000 page views per day.

Using approximately 100,000 seconds per day:

500,000 ÷ 100,000 = 5 page views per second.

Normal ticket sales per second:

5,000 ÷ 100,000 = 0.05 tickets per second.

Therefore, normal traffic is approximately 5 page views per second, with 5,000 tickets sold daily.

Big Sale Traffic Calculations

During a popular concert sale, 200,000 people attempt to purchase tickets within 10 minutes.

10 minutes = 600 seconds.

Purchase attempts per second:

200,000 ÷ 600 = 333.33 people per second.

Therefore, approximately 333 people arrive each second during the big sale.

Seat Competition

There are only 20,000 available seats for 200,000 interested people.

200,000 ÷ 20,000 = 10 people competing for each seat on average.

Only 10% of interested users can obtain tickets.

Normal Traffic vs Big Sale
Measurement	Normal Day	Big Sale
Visitors	50,000/day	200,000/10 min
Average page views per second	5	At least 333 user arrivals/second
Tickets available	Not specified	20,000
Ticket sales	5,000/day	Maximum 20,000

The big sale creates a much higher demand for the system.

TicketHub must use a waiting queue, caching, load balancing and database transactions to manage this traffic safely.

3. API Design

The TicketHub API allows users to browse events, view seats, reserve tickets, pay and view their purchased tickets.

Base URL:

https://api.tickethub.com

Endpoint 1: Browse Events
Method: GET
Path: /events
Description: Retrieves a list of available concerts and events.
Success Status: 200 OK.
Request Body: Not required.
Endpoint 2: View Event Details
Method: GET
Path: /events/{event_id}
Description: Retrieves information about a specific event, including its venue, date and ticket prices.
Success Status: 200 OK.
Request Body: Not required.
Endpoint 3: View Available Seats
Method: GET
Path: /events/{event_id}/seats
Description: Retrieves the seats for an event and their current availability.
Success Status: 200 OK.
Request Body: Not required.
Endpoint 4: Hold a Seat
Method: POST
Path: /events/{event_id}/holds
Description: Temporarily reserves an available seat for a user while they complete payment.
Success Status: 201 Created.

Example request body:

json
{
    "seat_id": 105,
    "user_id": 25
}


A seat hold expires after a limited period, for example 10 minutes.

If another user already holds or has purchased the seat, the request is rejected.

Endpoint 5: Make Payment
Method: POST
Path: /orders/{order_id}/payments
Description: Processes payment for a held seat and confirms the booking after successful payment verification.
Success Status: 200 OK.

Example request body:

json
{
    "payment_method": "card",
    "payment_reference": "PAY123456"
}


Payment requests should use an idempotency key to prevent duplicate charges when users retry requests.

Endpoint 6: View My Tickets
Method: GET
Path: /users/me/tickets
Description: Retrieves all tickets purchased by the authenticated user.
Success Status: 200 OK.
Request Body: Not required.
API Error Responses
400 Bad Request: The user sends invalid information, such as a missing seat ID.
404 Not Found: The requested event, seat or order does not exist.
409 Conflict: The requested seat has already been held or purchased by another user.
4. Database Design

TicketHub will use a relational SQL database because ticket purchases require reliable transactions, relationships and constraints.

The main tables are users, events, seats, orders and order_items.

4.1 Users Table

Stores information about registered users.

Fields:

user_id: Primary key.
name: User's full name.
email: User's email address, which must be unique.
password_hash: Securely stored password hash.
created_at: Account creation date.
4.2 Events Table

Stores information about concerts and other events.

Fields:

event_id: Primary key.
event_name: Name of the event.
venue: Event location.
event_date: Date and time of the event.
ticket_price: Ticket price.
status: Event status.
4.3 Seats Table

Stores the seats available for each event.

Fields:

seat_id: Primary key.
event_id: Foreign key referencing events.
seat_number: Seat identification number.
status: Available, held or sold.

The combination of event_id and seat_number must be unique.

This prevents duplicate seat records within the same event.

4.4 Orders Table

Stores ticket purchase orders.

Fields:

order_id: Primary key.
user_id: Foreign key referencing users.
total_amount: Total order amount.
payment_status: Pending, paid or failed.
created_at: Order creation date.
4.5 Order_Items Table

Stores the individual seats associated with an order.

Fields:

order_item_id: Primary key.
order_id: Foreign key referencing orders.
seat_id: Foreign key referencing seats.
price: Price paid for the seat.

The seat_id must also have a UNIQUE constraint for confirmed purchases.

This prevents a seat from being sold in multiple orders.

Table Relationships

Users and Orders: One-to-Many

One user can create many orders, but each order belongs to one user.

Events and Seats: One-to-Many

One event has many seats, but each seat belongs to one event.

Orders and Order_Items: One-to-Many

One order can contain multiple ticket items, but each ticket item belongs to one order.

Seats and Orders: Many-to-Many over time

An order can contain multiple seats, and a seat may be associated with different attempted orders over time, but it can only have one confirmed purchase.

The order_items table connects orders and seats.

5. Preventing Double Booking

Preventing two people from purchasing the same seat is one of the most important requirements of TicketHub.

The system will use database transactions, unique constraints and temporary seat holds.

Step 1: User Requests a Seat

A user selects a seat and sends a request to hold it.

Step 2: Check Seat Availability

The application checks whether the seat is available.

Step 3: Start a Database Transaction

The database starts a transaction and checks and updates the seat status atomically.

For example:

sql
BEGIN TRANSACTION;

UPDATE seats
SET status = 'held'
WHERE seat_id = 105
AND status = 'available';

COMMIT;


The application must check the number of affected rows.

If zero rows were updated, the seat was no longer available and the hold must fail.

Step 4: Create a Temporary Hold

The system records the user and the expiration time of the hold.

For example, a hold may last 10 minutes.

Step 5: Process Payment

The user completes payment while the seat is held.

Step 6: Confirm the Purchase

After successful payment verification, the system changes the seat status to sold and records the confirmed order item.

Step 7: Release Expired Holds

If payment is not completed before the hold expires, the system releases the seat so another user can purchase it.

Database Protection

The system also uses a UNIQUE constraint on order_items.seat_id for confirmed purchases.

This ensures that the same seat cannot appear in two successful orders.

Database transactions ensure that competing requests cannot both successfully claim the same available seat.

The payment process should also use idempotency keys so repeated payment requests do not create duplicate charges.

6. System Architecture
Architecture Diagram

The following diagram shows how the TicketHub system works.

text
                  USERS / WEB APP
                         |
                         |
                        CDN
                         |
                         |
                   LOAD BALANCER
                         |
                         |
                    APP SERVERS
                         |
          +--------------+--------------+
          |              |              |
       REDIS          DATABASE       WAITING QUEUE
       CACHE           PRIMARY       (BIG SALES)
                         |                |
                    READ REPLICA      APP SERVERS
                         |
                    SEAT AND ORDER
                      RECORDS

                    PAYMENT GATEWAY
                         |
                    PAYMENT SERVICE
                         |
                    DATABASE UPDATE

Architecture Components

1. CDN (Content Delivery Network)

Delivers static files such as event images, banners, CSS and JavaScript from servers close to users.

2. Load Balancer

Distributes incoming requests across multiple app servers to prevent individual servers from becoming overloaded.

3. App Servers

Handle authentication, event browsing, seat selection, order creation and payment coordination.

4. Redis Cache

Stores frequently accessed information such as event details and cached seat availability to reduce database queries.

The cache must not be treated as the final authority for seat availability.

5. Primary Database

Stores users, events, seats, orders and confirmed purchases while enforcing database constraints and transactions.

6. Read Replica

Handles read queries such as browsing events and retrieving event information, reducing the workload on the primary database.

7. Waiting Queue

Controls traffic during popular concert sales by placing users in an orderly waiting line and releasing them into the purchasing process at a controlled rate.

8. Payment Gateway

Processes payments securely and communicates payment results to the TicketHub application.

How the Architecture Handles a Big Sale

When 200,000 people attempt to purchase 20,000 tickets within 10 minutes, the system must protect the database from overwhelming traffic.

The waiting queue controls the number of users entering the purchase process.

The load balancer distributes requests across multiple app servers.

The CDN serves static content without requiring every request to reach the application servers.

Redis reduces repeated database reads.

The primary database uses transactions and unique constraints to prevent duplicate seat purchases.

Read replicas handle browsing queries while the primary database focuses on important writes.

This architecture helps TicketHub remain responsive and protects the accuracy of ticket bookings during high-demand events.

7. Trade-offs
Trade-off 1: Waiting Queue vs Immediate Access

A waiting queue controls traffic and reduces pressure on the system during popular ticket sales.

However, users must wait before they can purchase tickets, which may create frustration.

The system also needs a fair queueing mechanism to prevent users from bypassing the line.

Trade-off 2: Caching vs Data Consistency

Redis improves performance by storing frequently requested event and seat information.

However, cached information can become outdated when another user purchases a seat.

The database must remain the final authority when confirming seat availability.

Trade-off 3: Seat Holds vs Ticket Availability

Temporary seat holds give users time to complete payment and prevent other users from purchasing the same seat.

However, some seats may remain unavailable while users delay payment.

Expired holds must be released automatically.

Trade-off 4: Read Replicas vs Data Consistency

Read replicas improve performance by handling browsing requests separately from the primary database.

However, replication delays may cause users to see outdated seat information.

Final seat reservations and purchases must always be checked against the primary database.

8. Conclusion

TicketHub requires a scalable and reliable architecture because it handles millions of registered users and potentially very high traffic during popular concert sales.

The design uses a CDN, load balancer, multiple application servers, Redis cache, SQL database, read replicas and a waiting queue.

Database transactions, temporary seat holds and unique constraints prevent two users from successfully purchasing the same seat.

The proposed architecture balances performance, reliability, fairness and data consistency while allowing TicketHub to grow as the number of users and events increases.