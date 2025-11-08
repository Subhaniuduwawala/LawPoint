# LawPoint

Full-stack lawyer directory application with user authentication: React (Vite) frontend + Node/Express backend + MongoDB. Frontend served on port 3000, backend on 4000. The stack is fully dockerized and can be run with docker-compose.

## Features

- 🔐 User authentication (signup/login) with JWT
- 👨‍⚖️ Lawyer directory with CRUD operations
- 📱 Responsive React UI with Vite dev server
- 🗄️ MongoDB database with Mongoose ODM
- 🐳 Docker support for easy deployment
- 🔒 Password hashing with bcrypt
- 🛡️ Protected API routes with JWT middleware

## Project structure

- **backend/** - Express API, MongoDB models, auth middleware, Dockerfile
- **frontend/** - React + Vite app with routing and auth context, Dockerfile (multi-stage)
- **docker-compose.yml** - orchestrates mongo, backend, frontend services
- **start-dev.bat** - Windows batch script to start both servers locally
- **build-images.ps1** - PowerShell script to build and tag Docker images

## Requirements

- **For local development:** Node.js 18+ and npm, MongoDB installed and running
- **For Docker:** Docker and docker-compose installed

## Quick Start (Local Development - Recommended)

The fastest way to get started is to run both servers locally:

1. **Make sure MongoDB is running** (should already be installed as a Windows service)
2. **Double-click `start-dev.bat`** in the project root

This will open two terminal windows:
- Backend server on http://localhost:4000
- Frontend dev server on http://localhost:3000

3. **Open your browser** to http://localhost:3000
4. **Create an account** on the signup page
5. Start adding lawyers!

### Manual Local Setup

If you prefer to start servers manually:

**Terminal 1 - Backend:**
```powershell
cd backend
npm install
node server.js
```

**Terminal 2 - Frontend:**
```powershell
cd frontend
npm install
npm run dev
```

## Run with Docker

1. Open PowerShell in the project root (where `docker-compose.yml` is).
2. Build and start the services:

```powershell
docker compose up --build
```

This will:
- start MongoDB and expose it on localhost:27017
- start backend on http://localhost:4000
- build and start frontend on http://localhost:3000

To run in detached mode:

```powershell
docker compose up --build -d
```

To stop and remove containers:

```powershell
docker compose down
```

## Run locally without Docker (development)

### Backend

1. Install dependencies and seed data:

```powershell
cd backend
npm install
npm run seed
```

2. Start the backend (ensure MongoDB is running locally at mongodb://localhost:27017):

```powershell
$env:MONGO_URI = "mongodb://localhost:27017/lawpoint"; $env:PORT=4000; node server.js
```

### Frontend

1. Install dependencies:

```powershell
cd frontend
npm install
```

2. Start the Vite dev server (proxies /api to backend at localhost:4000):

```powershell
npm run dev
```

The dev server will start at http://localhost:3000

## API Endpoints

### Authentication
- `POST /api/auth/signup` — Create new user account (JSON: `{ email, password, name }`)
- `POST /api/auth/login` — Login and get JWT token (JSON: `{ email, password }`)
- `GET /api/auth/me` — Get current user info (requires JWT token)

### Lawyers
- `GET /api/health` — Health check endpoint
- `GET /api/lawyers` — List all lawyers (public)
- `POST /api/lawyers` — Create a lawyer (requires authentication, JSON: `{ name, specialty, location }`)

### Using Protected Endpoints

To access protected endpoints, include the JWT token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

## Seed Data

The backend includes a seed script that populates sample lawyers:

```powershell
cd backend
npm run seed
```

Sample lawyers include:
- Sarah Johnson (Corporate Law, New York)
- Michael Chen (Criminal Defense, Los Angeles)
- Emily Rodriguez (Family Law, Chicago)
- David Park (Immigration Law, Miami)
- Lisa Thompson (Real Estate Law, Boston)

## Database Notes

- The app uses MongoDB running as a Windows service on localhost:27017
- Database name: `lawpoint`
- Collections: `users`, `lawyers`
- If MongoDB is not available, the backend falls back to in-memory storage (data lost on restart)
- User passwords are automatically hashed using bcrypt before saving

## Building and Pushing Docker Images

### Build images locally

```powershell
docker build -t yourusername/lawpoint-backend:latest ./backend
docker build -t yourusername/lawpoint-frontend:latest ./frontend
```

Or use the provided script (edit `$DOCKER_USER` variable first):

```powershell
.\build-images.ps1
```

### Push to Docker Hub

```powershell
docker login
docker push yourusername/lawpoint-backend:latest
docker push yourusername/lawpoint-frontend:latest
```

## Troubleshooting

### Backend won't start
- Ensure MongoDB service is running: `Get-Service MongoDB`
- Check if port 4000 is already in use: `netstat -ano | findstr :4000`
- Check MongoDB connection: `Test-NetConnection localhost -Port 27017`

### Frontend can't connect to backend
- Make sure backend is running on port 4000
- Check Vite proxy configuration in `frontend/vite.config.js`
- Test backend directly: `Invoke-RestMethod http://localhost:4000/api/health`

### Authentication not working
- Clear browser localStorage and cookies
- Check JWT token in browser DevTools → Application → Local Storage
- Verify JWT_SECRET environment variable is set (or using default)

## Technology Stack

**Backend:**
- Node.js & Express.js
- MongoDB & Mongoose
- JWT (jsonwebtoken)
- bcrypt for password hashing
- CORS enabled

**Frontend:**
- React 18
- Vite (build tool)
- React Router (routing)
- Axios (HTTP client)
- Context API (state management)

**DevOps:**
- Docker & Docker Compose
- nginx (frontend production server)
- Multi-stage builds for optimized images
