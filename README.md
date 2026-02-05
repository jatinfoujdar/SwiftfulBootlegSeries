# Golang Backend Authentication Analysis

This document provides a detailed breakdown of the authentication system implemented in this repository. It follows a structured 5-step explanation format for each major component.

---

## 1. Signup Handler (controllers.Signup)

### Step 1 – High-level overview  
The Signup handler is responsible for registering new users into the system. It takes user details (Name, Email, Password, etc.), ensures the password is safe by scrambling it, and saves the new user record into the MongoDB database.

### Step 2 – Basic structure  
- **Request parsing / binding**: Uses Gin's `ShouldBindJSON` to map incoming JSON data to a Go struct.
- **Input validation**: Enforces rules like "email must be valid" and "password must be at least 8 characters" using struct tags.
- **Password hashing**: Uses the `bcrypt` library to turn the plain-text password into a secure, irreversible hash.
- **Database access**: Uses the MongoDB Go driver to insert the user record into the "users" collection.
- **Response handling**: Returns a `201 Created` status on success or appropriate error messages on failure.

### Step 3 – Detailed flow  
1. **JSON Binding**: The function first tries to fit the incoming request data into a temporary `body` struct. If the user sent bad data (like a missing email), it stops and returns an error.
2. **Default Values**: If no `UserType` is provided, it defaults the new user to "USER".
3. **Password Scrambling**: It calls `bcrypt.GenerateFromPassword`. This is critical because we never store "real" passwords in our database—only the scrambled versions.
4. **User Object Creation**: It builds a `models.User` object, generating a unique `ID` (ObjectID) and setting the `CreatedAt` timestamp.
5. **Database Insertion**: It uses `userCollection.InsertOne` to save the data.
6. **Error Check**: If the database says the email already exists (`IsDuplicateKeyError`), it sends a specific message back to the user.
7. **Success**: If everything worked, it sends a JSON message saying "User created successfully".

### Step 4 – Requirements mapping  
- **Input validation**: Satisfied by `binding:"required,email,min=8"` tags.
- **Security**: Satisfied by using `bcrypt` for password hashing.
- **Error handling**: Handles both validation errors and database duplicate errors specifically.

### Step 5 – Improvements (optional)
- **Email Normalization**: Convert emails to lowercase before saving to prevent duplicate accounts (e.g., Test@me.com and test@me.com).
- **Sanitization**: Ensure the `Name` field doesn't contain malicious scripts or excessive whitespace.

---

## 2. Login Handler (controllers.Login)

### Step 1 – High-level overview  
The Login handler verifies a user's identity. If the user provides a correct email and password, the system issues a "digital key" (JWT token) that the user can use for future requests instead of typing their password every time.

### Step 2 – Basic structure  
- **Request parsing**: Binds the login credentials (Email, Password) from JSON.
- **Database access**: Queries MongoDB to find the user by their email address.
- **Password comparison**: Uses `bcrypt.CompareHashAndPassword` to compare the typed password with the scrambled one in the database.
- **Token generation**: Calls the helper to create a signed Access Token and a Refresh Token.
- **Response handling**: Returns the tokens and basic user info to the client on success.

### Step 3 – Detailed flow  
1. **Validation**: Checks that the user provided an email and a password.
2. **User Search**: Looks into the "users" collection for the record matching the email. If not found, it returns "email or password is incorrect" (vague message for better security).
3. **Password Match**: It takes the plain password the user just typed and the "shredded" hash from the database. If they don't match, it returns an error.
4. **Token Wizardry**: It generates two tokens:
   - **Access Token**: Short-lived (24h) for making requests.
   - **Refresh Token**: Long-lived (7 days) for getting a new access token later.
5. **Final Output**: Sends the tokens back to the user's phone or browser.

### Step 4 – Requirements mapping  
- **Authentication logic**: Core logic is implemented via email lookup and password comparison.
- **Security (Security Check)**: Uses `bcrypt` for comparison, ensuring the system never sees the real password during the database check.
- **Error handling**: Uses generic "incorrect email/password" messages to avoid revealing whether an email exists or not.

### Step 5 – Improvements (optional)
- **Rate Limiting**: Prevent "Brute Force" attacks where a hacker tries thousands of passwords in a few seconds.
- **Audit Logs**: Record when a user logged in for security monitoring.

---

## 3. Token Generation & Validation (handler.authHelper.go)

### Step 1 – High-level overview  
This module is the "Wizard" of the app. It creates and verifies the digital Membership Cards (JWTs) that represent a user's logged-in session.

### Step 2 – Basic structure  
- **SignedDetails Struct**: Defines what internal info is hidden inside the token (Email, UID, UserType).
- **GenerateAllTokens**: Logic for creating two tokens (Access and Refresh) with different expiration dates.
- **ValidateToken**: Logic for checking if a token is real, expired, or faked.
- **Secret Key**: Uses an environment variable `JWT_SECRET` as the "ink" to sign the cards.

### Step 3 – Detailed flow  
1. **GenerateAllTokens**:
   - Creates a "Claim" set (the info inside the token).
   - Sets a 24-hour expiration for the main token.
   - Uses `jwt.NewWithClaims` and the `SECRET_KEY` to create a signed string.
2. **ValidateToken**:
   - Takes a token string from a user.
   - Tries to "un-sign" it using the same `SECRET_KEY`.
   - If the signature is wrong, or the time has passed current `time.Now()`, it declares the token invalid or expired.

### Step 4 – Requirements mapping  
- **Token Safety**: Uses HMAC-SHA256 (`HS256`) signing method, which is standard for safe token signatures.
- **Information hiding**: Includes `RegisteredClaims` (like expiration time) to handle session duration.

### Step 5 – Improvements (optional)
- **Rotation**: Implementing logic to "blacklist" stolen tokens.
- **Asymmetric Keys**: Using RSA/EDDSA keys if the app grows, so only one server can sign but many can verify.

---

## 4. Authentication Middleware (middleware.Authenticate)

### Step 1 – High-level overview  
The Middleware is the "Security Guard" sitting at the entrance of protected rooms (URLs). It checks every visitor for a valid Membership Card (Token) before letting them through.

### Step 2 – Basic structure  
- **Header Extraction**: Looks for a field called `token` in the incoming request headers.
- **Token Validation**: Sends that token to the `ValidateToken` wizard.
- **Context Injection**: If the token is good, it extracts the user's Email, UID, etc., and stores them in the Gin "Context" for the next function to use.
- **Request Blocking**: If anything is wrong, it immediately calls `Abort()` to stop the request.

### Step 3 – Detailed flow  
1. **Header Check**: First, it tries to grab the `token` string. If it's missing, it returns `401 Unauthorized`.
2. **Validation**: It calls the `ValidateToken` helper. If the helper says the token is expired or fake, the Guard stops the request right there.
3. **Information Passing**: If validated, it extracts the `Email`, `Name`, and `UID` from the token and puts them into the `c` (Context) variable.
4. **Pass-through**: It calls `c.Next()`, which tells the app "This user is okay, let them into the page they asked for."

### Step 4 – Requirements mapping  
- **Authorization checks**: It ensures that only users with a valid token can reach the controllers behind it.
- **Identity management**: By putting user info into the Context, it allows the actual API functions to know *who* is making the request without looking at the DB again.

### Step 5 – Improvements (optional)
- **Bearer Prefix**: Standard APIs usually use `Authorization: Bearer <token>` instead of just `token`.
- **Role Check**: Adding logic to check if a user is an "ADMIN" or a "USER" before letting them into specific rooms.
