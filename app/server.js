const express = require("express")
const helmet = require("helmet")
const morgan = require("morgan")
const promClient = require("prom-client")

const app = express()

// --------------------------------------------------
// Configuration
// --------------------------------------------------

const PORT = process.env.PORT || 8080
const SERVICE_NAME = process.env.SERVICE_NAME || "springboot-service"
const NODE_ENV = process.env.NODE_ENV || "production"

// --------------------------------------------------
// Security Middleware
// --------------------------------------------------

app.use(helmet())

// --------------------------------------------------
// Logging
// --------------------------------------------------

app.use(morgan("combined"))

// --------------------------------------------------
// Metrics Setup
// --------------------------------------------------

const register = new promClient.Registry()

promClient.collectDefaultMetrics({
  register
})

const httpRequestCounter = new promClient.Counter({
  name: "http_requests_total",
  help: "Total HTTP Requests",
  labelNames: ["method", "route", "status"]
})

register.registerMetric(httpRequestCounter)

// --------------------------------------------------
// Request Parsing
// --------------------------------------------------

app.use(express.json())

// --------------------------------------------------
// Health Endpoints (Required for Kubernetes Probes)
// --------------------------------------------------

let isReady = true

app.get("/health/live", (req, res) => {
  res.status(200).json({
    status: "UP"
  })
})

app.get("/health/ready", (req, res) => {

  if (isReady) {
    return res.status(200).json({
      status: "READY"
    })
  }

  res.status(500).json({
    status: "NOT_READY"
  })
})

// --------------------------------------------------
// Metrics Endpoint (Prometheus)
// --------------------------------------------------

app.get("/metrics", async (req, res) => {

  res.set("Content-Type", register.contentType)

  res.end(await register.metrics())
})

// --------------------------------------------------
// Example Business Endpoint
// --------------------------------------------------

app.get("/api/v1/orders", (req, res) => {

  httpRequestCounter.inc({
    method: req.method,
    route: "/api/v1/orders",
    status: 200
  })

  res.json({
    message: "Orders fetched successfully",
    service: SERVICE_NAME,
    environment: NODE_ENV
  })
})

// --------------------------------------------------
// Error Handler
// --------------------------------------------------

app.use((err, req, res, next) => {

  console.error("Unhandled Error:", err)

  res.status(500).json({
    error: "Internal Server Error"
  })
})

// --------------------------------------------------
// Graceful Shutdown (Critical for Kubernetes)
// --------------------------------------------------

const server = app.listen(PORT, () => {

  console.log(`Service ${SERVICE_NAME} running on port ${PORT}`)
})

const shutdown = () => {

  console.log("Shutdown signal received")

  isReady = false

  server.close(() => {
    console.log("HTTP server closed")
    process.exit(0)
  })

  setTimeout(() => {
    process.exit(1)
  }, 10000)
}

process.on("SIGTERM", shutdown)
process.on("SIGINT", shutdown)