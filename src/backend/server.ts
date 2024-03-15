import fs from "fs";
import path, { join } from "path";
import http from "http";
import https from "https";
import express, { NextFunction, Request, Response } from "express";
import cors from "cors";
import { fileURLToPath } from "url";
import { router as api } from "./routers/api/index";
import morgan from "morgan";
import helmet from "helmet";
import cookieParser from "cookie-parser";
import openAPISpecGenerator, {
  SPEC_OUTPUT_FILE_BEHAVIOR,
} from "express-oas-generator";

const fileName = fileURLToPath(import.meta.url);
const directoryName = path.dirname(fileName);
const rootDirectory = path.join(directoryName, "..", "..");
const distDirectory = path.join(rootDirectory, "dist");
const entrypoint = path.join(distDirectory, "index.html");
const sslKey =
  path.join(directoryName, "key.pem") ?? process.env["SSL_KEY_PATH"];
const sslCert =
  path.join(directoryName, "cert.pem") ?? process.env["SSL_CERT_PATH"];

if (!fs.existsSync(sslKey) || !fs.existsSync(sslCert)) {
  throw new Error("A valid SSL key and cert path must be provided.");
}

const privateKey = fs.readFileSync(sslKey, "utf8");
const certificate = fs.readFileSync(sslCert, "utf8");
const app = express();
const httpServer = http.createServer(app);
const httpsServer = https.createServer(
  { key: privateKey, cert: certificate },
  app,
);

app.disable("x-powered-by");

openAPISpecGenerator.handleResponses(app, {
  specOutputFileBehavior: SPEC_OUTPUT_FILE_BEHAVIOR.RECREATE,
  specOutputPath: join(distDirectory, "oas.json"),
  alwaysServeDocs: true,
  swaggerDocumentOptions: {
    customSiteTitle: process.env["SITE_TITLE"],
  },
});

app.use(helmet());
app.use(cors());
app.use(cookieParser());
app.use(express.json());
app.use(morgan("tiny"));
app.use(express.static(distDirectory));

app.use("/api", api);
app.get("*", (request: Request, response: Response, next: NextFunction) => {
  if (request.url.includes("api-docs") || request.url.includes("api-spec")) {
    return next();
  }

  return response.sendFile(entrypoint);
});

openAPISpecGenerator.handleRequests();

app.use(
  (
    error: Error,
    _request: Request,
    response: Response,
    _next: NextFunction,
  ) => {
    return response.status(400).send(error.message);
  },
);

const HTTP_PORT = 80;
const HTTPS_PORT = 443;

httpServer.listen(HTTP_PORT, () => {
  console.log(`Listening for HTTP traffic at: http://localhost:${HTTP_PORT}`);
});

httpsServer.listen(HTTPS_PORT, () => {
  console.log(
    `Listening for HTTPS traffic at: https://localhost:${HTTPS_PORT}`,
  );
});
