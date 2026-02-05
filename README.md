# Go Backend Learning Journey: Project Explanation

This document explains this project from a beginner to an advanced level, focusing strictly on the code found in this repository.

---

## Chapter 1 – What This Project Is
- **Problem Solved**: This backend provides a secure system for users to create accounts (Signup) and prove their identity (Login).
- **Type of App**: It is a RESTful API (Application Programming Interface) focused on Authentication and User Management.
- **Request Flow**: 
  1. A user (Client) sends a request (like an Email and Password).
  2. The Server processes it.
  3. The Server sends back a response (like a Success message or a Security Token).

---

## Chapter 2 – Go Project Basics
- **`main.go`**: Located in `cmd/api/main.go`, this is the entry point. When you start the app, Go looks for this file first.
- **Application Startup**: The app starts by loading environment variables and then initializing the web server.
- **Dependencies**: The `go.mod` file tracks external libraries (like Gin for the web server and MongoDB for the database).
- **Configuration**: Managed via a `.env` file. We use the `initializers` package to load these "secrets" so they aren't hardcoded in our logic.

---

## Chapter 3 – First Running Example (Hello World Level)
- **Simplest Endpoint**: The `/health` route in `main.go`.
- **How it works**: It is the most basic function that returns a simple "status: ok" message.
- **Verification**: You can run the project using `go run cmd/api/main.go` and visit `http://localhost:8080/health` in your browser. If you see "ok", the server is alive!

---

## Chapter 4 – Router & Server Setup
- **HTTP Server**: Created in `main.go`. It listens for incoming traffic on a specific port (usually 8080).
- **Framework**: This project uses **Gin**, a high-performance web framework for Go.
- **Route Registration**: Routes are grouped (like `AuthRoutes` and `UserRoutes`) and connected to the main router in `main.go`.
- **Handling Requests**: The router directs a URL (like `/users/signup`) to a specific function (a "Handler") that knows what to do.

---

## Chapter 5 – Health Check Route (`/health`)
- **Importance**: Monitoring tools and Load Balancers use this to check if the server is healthy. If it stops responding, they know the server is down.
- **Definition**: Defined directly in `main.go`:
  ```go
  router.GET("/health", func(c *gin.Context) {
      c.JSON(200, gin.H{"status": "ok"})
  })
  ```
- **Flow**: Request comes in -> Function runs immediately -> Returns a `200 OK` status and a JSON message.

---

## Chapter 6 – Request Handling Basics
- **Reading Data**: The app uses `c.ShouldBindJSON` to read data sent in the request body (like a user's name).
- **Writing Responses**: The app uses `c.JSON()` to send data back in a structured format that mobile apps or websites can easily read.
- **Status Codes**:
  - `200 OK`: Success.
  - `201 Created`: Successfully created a new item (like a user).
  - `400 Bad Request`: User sent invalid data.
  - `401 Unauthorized`: Security failure (bad password or token).
  - `500 Internal Error`: Something broke in the server's code.

---

## Chapter 7 – Authentication Overview
- **Type**: This project uses **JWT (JSON Web Token)** authentication.
- **Auth Flow**:
  1. **Signup**: User registers with a password.
  2. **Login**: User provides email/password. Server sends back a Token.
  3. **Protected Access**: User sends that Token in the header for every request to private routes.

---

## Chapter 8 – Code Deep Dive (Step-by-Step)

### 8.1 - Database Connection (`internal/config/databaseConnection.go`)
- **Step 1 - High-level**: Establish a permanent bridge to your MongoDB database.
- **Step 2 - Structure**: Env reading -> Connection options -> Client creation -> Pinging.
- **Step 3 - Detailed**: Reads `MONGO_URI` -> Sets a 10s connection timeout -> Calls `mongo.Connect` -> Runs a "Ping" to verify the database is actually reachable.
- **Step 4 - Mapping**: Matches Connectivity and Configuration requirements.
- **Step 5 - Improvements**: Using a connection pool or a singleton pattern to prevent accidental multiple connections.

### 8.2 - User Model (`internal/models/userModel.go`)
- **Step 1 - High-level**: Defines the "Blueprint" for what a user looks like.
- **Step 2 - Structure**: Struct definition -> BSON tags (for DB) -> JSON tags (for API) -> Validation tags.
- **Step 3 - Detailed**: Uses `primitive.ObjectID` for unique DB keys -> Uses `binding` tags to force valid emails and minimum password length.
- **Step 4 - Mapping**: Matches Data Integrity and Input Validation.
- **Step 5 - Improvements**: Adding `omitempty` to fields you don't always want to show, like password.

### 8.3 - Signup Handler (`controllers.Signup`)
- **Step 1 - High-level**: Registers new members and secures their passwords.
- **Step 2 - Structure**: JSON Binding -> Defaulting Role -> Bcrypt Hashing -> Database Insert.
- **Step 3 - Detailed**: Maps request to `body` -> Sets `UserType` to "USER" if blank -> Uses `bcrypt` for safety -> Handles duplicate email errors from MongoDB.
- **Step 4 - Mapping**: Matches Validation, Security (Hashing), and Error Handling.

### 8.4 - Login Handler (`controllers.Login`)
- **Step 1 - High-level**: Checks identity and hands out Session Tokens.
- **Step 2 - Structure**: Input binding -> User lookup -> Password comparison -> Token generation.
- **Step 3 - Detailed**: Finds user by email -> Compares typed password to hashed password -> If successful, generates an Access and Refresh token.
- **Step 4 - Mapping**: Matches Authentication and Token Security.

### 8.5 - User Retrieval (`controllers.GetUser` & `controllers.GetUsers`)
- **Step 1 - High-level**: Allows the app to fetch information about one or all users.
- **Step 2 - Structure**: Param parsing (for single user) -> Database query (`Find` / `FindOne`) -> JSON response.
- **Step 3 - Detailed**: `GetUser` converts string ID to MongoDB ObjectID -> `GetUsers` uses a Cursor to loop through all results in the database.
- **Step 4 - Mapping**: Matches Data Retrieval and Authorization (since these are protected by the Guard).
- **Step 5 - Improvements**: Pagination (showing 10 users at a time) to prevent lag if you have millions of users.

### 8.6 - Token Helper (`handler.GenerateAllTokens`)
- **Step 1 - High-level**: The "Wizard" that signs and verifies your digital keys.
- **Step 2 - Structure**: Claim Creation -> Secret Key Signing -> Token Validation checks.
- **Step 3 - Detailed**: Creates payload (Email, UID) -> Signs with `JWT_SECRET` -> `ValidateToken` checks if the "stamp" is real.
- **Step 4 - Mapping**: Matches Cryptographic Security and Session Management.

---

## Chapter 9 – Middleware & Security
- **Auth Middleware**: (`middleware.Authenticate`) The security guard that checks for the `token` header before letting anyone into `/users` routes.
- **Token Validation**: Uses the helper to see if the token is faked or expired.
- **Context Injection**: Saves the user's ID into the "Context" so other functions know exactly *who* is making the request.

---

## Chapter 10 – Routing Structure
- **`internal/routes/authRouter.go`**: Handles the public "Front Door" (Signup and Login).
- **`internal/routes/userRouter.go`**: Handles the internal "Members Only" area (Getting user details). It automatically uses the `Authenticate` guard.

---

## Chapter 11 – Error Handling Strategy
- **Consistent Responses**: Every error is sent back as a JSON object `{"error": "message"}`.
- **Status Mapping**: Uses correct HTTP codes (401 for bad passwords, 400 for bad input, 500 for server issues).

---

## Chapter 12 – How to Extend This Project
- **New Features**: Add a model -> Create a controller -> Link a route.
- **Adding Admin Routes**: You can update the Middleware to check the `user_type` claim and see if the user is an "ADMIN".

---
*Status: 100% Coverage of Project Files*
