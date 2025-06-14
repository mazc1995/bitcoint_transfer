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

### Transactions
- `GET /api/v1/users/:user_id/transactions` — Retrieve all transactions for the authenticated user
- `POST /api/v1/users/:user_id/transactions` — Create a USD/BTC transaction
- `GET /api/v1/users/:user_id/transactions/:id` — Retrieve transaction details

### Currencies
- `GET /api/v1/currencies/btc_price` — Get the current BTC price (source: Coingecko)

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

---

For further details, refer to the Swagger documentation and the comprehensive test suite included in the repository.
