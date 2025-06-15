# Bitcoin Wallet API

A robust RESTful API for user management, JWT authentication, and USD/BTC transactions.

## Requirements
- Ruby 3.4+
- Rails 8+
- PostgreSQL
- Bundler$$

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/mazc1995/bitcoint_transfer.git
   cd bitcoint_transfer
   ```
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Set up the database:
   ```bash
   rails db:create db:migrate db:seed
   ```
4. (Optional) Start the server:
   ```bash
   rails server
   ```

## Authentication
- The API uses JWT for stateless authentication.
- Register via `/api/v1/register` and log in via `/api/v1/login` to obtain a JWT.
- Include the token in the `Authorization` header as `Bearer <token>` for all protected endpoints.

## Main Endpoints

### Authentication
- `POST /api/v1/register` — User registration
- `POST /api/v1/login` — User login

#### Example: Register

**Request**
```json
{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```
**Response (201 Created)**
```json
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "balance_usd": 0.0,
    "balance_btc": 0.0
  },
  "token": "<jwt_token>"
}
```
**Response (422 Unprocessable Entity)**
```json
{
  "errors": ["Email has already been taken"]
}
```

#### Example: Login

**Request**
```json
{
  "email": "john.doe@example.com",
  "password": "password123"
}
```
**Response (200 OK)**
```json
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "balance_usd": 0.0,
    "balance_btc": 0.0
  },
  "token": "<jwt_token>"
}
```
**Response (401 Unauthorized)**
```json
{
  "error": "Invalid email or password"
}
```

### Transactions
- `GET /api/v1/users/:user_id/transactions` — Retrieve all transactions for the authenticated user
- `POST /api/v1/users/:user_id/transactions` — Create a USD/BTC transaction
- `GET /api/v1/users/:user_id/transactions/:id` — Retrieve transaction details

#### Example: Create Transaction

**Request**
```json
{
  "from_currency": "usd",
  "to_currency": "bitcoin",
  "amount_from": 100.0
}
```
**Response (201 Created)**
```json
{
  "id": 1,
  "user_id": 1,
  "from_currency": "usd",
  "to_currency": "bitcoin",
  "amount_from": 100.0,
  "amount_to": 0.002,
  "price_reference": 50000.0,
  "status": "completed",
  "created_at": "2024-06-12T12:34:56Z",
  "updated_at": "2024-06-12T12:34:56Z"
}
```
**Response (422 Unprocessable Entity)**
```json
{
  "error": "Invalid currency pair. Only USD to BTC and BTC to USD are supported. | user_id: 1 | transaction_id: "
}
```
**Response (401 Unauthorized)**
```json
{
  "error": "Unauthorized"
}
```
**Response (403 Forbidden)**
```json
{
  "error": "Forbidden"
}
```

#### Example: Get All Transactions

**Response (200 OK)**
```json
[
  {
    "id": 1,
    "user_id": 1,
    "from_currency": "usd",
    "to_currency": "bitcoin",
    "amount_from": 100.0,
    "amount_to": 0.002,
    "price_reference": 50000.0,
    "status": "completed",
    "created_at": "2024-06-12T12:34:56Z",
    "updated_at": "2024-06-12T12:34:56Z"
  },
  {
    "id": 2,
    "user_id": 1,
    "from_currency": "bitcoin",
    "to_currency": "usd",
    "amount_from": 0.001,
    "amount_to": 50.0,
    "price_reference": 50000.0,
    "status": "completed",
    "created_at": "2024-06-12T12:35:56Z",
    "updated_at": "2024-06-12T12:35:56Z"
  }
]
```

#### Example: Get Transaction by ID

**Response (200 OK)**
```json
{
  "id": 1,
  "user_id": 1,
  "from_currency": "usd",
  "to_currency": "bitcoin",
  "amount_from": 100.0,
  "amount_to": 0.002,
  "price_reference": 50000.0,
  "status": "completed",
  "created_at": "2024-06-12T12:34:56Z",
  "updated_at": "2024-06-12T12:34:56Z"
}
```
**Response (404 Not Found)**
```json
{
  "status": 404,
  "error": "Transaction not found | user_id: 1 | transaction_id: 999"
}
```

### Currencies
- `GET /api/v1/currencies/btc_price` — Get the current BTC price (source: Coingecko)

#### Example: Get BTC Price

**Response (200 OK)**
```json
{
  "usd_btc_price": 50000.0
}
```
**Response (502 Bad Gateway)**
```json
{
  "error": "Error fetching BTC price"
}
```

### External Transactions
- `POST /api/v1/users/:user_id/external_transactions` — Create an external transaction (deposit or withdraw between USD and external funds)

## API Documentation (Swagger)
- Access `/api-docs` for interactive API documentation via Swagger UI.
- Use the "Authorize" button to input your JWT and test protected endpoints.

## Testing
- Run the full test suite with:
  ```bash
  bundle exec rspec
  ```
- Test coverage is consistently above 99%.

## Serialization and Data Formatting
- USD amounts are serialized as floating-point numbers with two decimal places.
- BTC amounts are serialized as floating-point numbers with eight decimal places.
- All monetary values and prices are returned as numeric types, not strings, to facilitate precise client-side processing.

## Security and Authorization
- The API enforces strict resource-level authorization using Pundit policies.
- Users can only access or create transactions associated with their own user account; cross-user access is strictly forbidden.
- Protected endpoints require a valid JWT; unauthorized requests receive a 401 status, and forbidden actions receive a 403 status.

## Additional Notes
- BTC price data is fetched in real-time from the Coingecko API.
- The system is designed for extensibility, supporting future integration of additional currencies and features.

## External Transactions

This feature allows users to deposit or withdraw funds between their USD balance and an external source (e.g., cash, bank transfer, etc).

- **Deposit**: `from_currency: 'external', to_currency: 'usd'`
- **Withdraw**: `from_currency: 'usd', to_currency: 'external'`
- **Only these currency pairs are allowed.**

### Endpoint

`POST /api/v1/users/:user_id/external_transactions`

#### Required parameters (in the body):

- `from_currency` (`'usd'` or `'external'`)
- `to_currency` (`'usd'` or `'external'`)
- `amount_from` (float, must be positive)

#### Example request

```json
{
  "from_currency": "external",
  "to_currency": "usd",
  "amount_from": 50.0
}
```

#### Example successful response (`201 Created`)

```json
{
  "id": 123,
  "user_id": 1,
  "from_currency": "external",
  "to_currency": "usd",
  "amount_from": 50.0,
  "amount_to": 50.0,
  "price_reference": 1.0,
  "status": "completed",
  "created_at": "2024-06-12T12:34:56Z",
  "updated_at": "2024-06-12T12:34:56Z"
}
```

#### Validations and errors

- Only the pairs: `['external', 'usd']` and `['usd', 'external']` are allowed.
- The amount must be greater than zero.
- If the currency pair is invalid or the amount is not positive, a `422 Unprocessable Entity` error is returned with a descriptive message.
- JWT authentication is required.

#### Notes

- The user's USD balance is automatically updated according to the operation type.
- See the Swagger documentation at `/api-docs` for more details and interactive testing.

---

For further details, refer to the Swagger documentation and the comprehensive test suite included in the repository.
