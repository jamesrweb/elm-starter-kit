# elm-starter-kit

⚡ A batteries included starter kit for elm projects.

## Setup

### Development

To setup the local environment you can run `pnpm dev:setup` to install all local project dependencies and setup local ssl certificates.

### Production

In production there are no extra steps to take, just be sure your site has an SSL key and certificate configured and linked via the `SSL_KEY_PATH` and `SSL_CERT_PATH` environment variables in the backend `.env` file or environment generally.

## Running the application

### Development

To run the application locally, you can run `pnpm dev` which will simultaniously run the frontend elm application, backend api, the project tests in watch mode and linting in watch mode.

### Production

To run the application in production, you can run `pnpm start` which will build the project, minify assets and then run the application.
