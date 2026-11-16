
// Store loaded users in an array
let users = [];

// Select HTML elements
const loadButton = document.getElementById("load-users");
const filterInput = document.getElementById("filter-input");
const statusMessage = document.getElementById("status");
const usersList = document.getElementById("users-list");

// Function to display users
function renderUsers(list) {
    // Clear the previous list
    usersList.innerHTML = "";

    // Check if there are no matching users
    if (list.length === 0) {
        statusMessage.textContent = "No users match your filter.";
        return;
    }

    // Display each user
    list.forEach(user => {
        const li = document.createElement("li");

        const name = document.createElement("h3");
        name.textContent = user.name;

        const email = document.createElement("p");
        email.textContent = `Email: ${user.email}`;

        const city = document.createElement("p");
        city.textContent = `City: ${user.address.city}`;

        const company = document.createElement("p");
        company.textContent = `Company: ${user.company.name}`;

        li.appendChild(name);
        li.appendChild(email);
        li.appendChild(city);
        li.appendChild(company);

        usersList.appendChild(li);
    });
}

// Async function to load users
async function loadUsers() {
    loadButton.disabled = true;
    statusMessage.textContent = "Loading users...";
    usersList.innerHTML = "";

    try {
        const response = await fetch(
            "https://jsonplaceholder.typicode.com/users"
        );

        // Check if the request was successful
        if (!response.ok) {
            throw new Error("Failed to fetch users.");
        }

        // Convert response into JSON
        users = await response.json();

        // Display all users
        renderUsers(users);

        statusMessage.textContent = `Successfully loaded ${users.length} users.`;

    } catch (error) {
        statusMessage.textContent = "Error loading users. Please try again.";
        console.error("Error:", error);

    } finally {
        // Re-enable the button
        loadButton.disabled = false;
    }
}

// Load users when button is clicked
loadButton.addEventListener("click", loadUsers);

// Filter users when input changes
filterInput.addEventListener("input", () => {
    const searchText = filterInput.value.toLowerCase();

    const filteredUsers = users.filter(user =>
        user.name.toLowerCase().includes(searchText)
    );

    renderUsers(filteredUsers);

    if (filteredUsers.length > 0) {
        statusMessage.textContent =
            `Found ${filteredUsers.length} matching user(s).`;
    }
});
