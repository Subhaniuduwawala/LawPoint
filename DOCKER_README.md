# LawPoint Docker Images

Full-stack lawyer directory application with user authentication.

## Quick Start

```bash
# Pull images
docker pull subhaniuduwawala/lawpoint-backend:latest
docker pull subhaniuduwawala/lawpoint-frontend:latest

# Run with docker-compose
git clone https://github.com/Subhaniuduwawala/LawPoint.git
cd LawPoint
docker compose up
```

Then open: http://localhost:3000

## What's Included

- **Frontend**: React + Vite app with authentication (port 3000)
- **Backend**: Node.js + Express API with JWT auth (port 4000)
- **Database**: MongoDB (port 27017)

## Features

- ✅ User signup and login with JWT authentication
- ✅ Password hashing with bcrypt
- ✅ Lawyer directory CRUD operations
- ✅ Protected routes
- ✅ Responsive UI
- ✅ MongoDB persistence

## Environment Variables

### Backend
- `PORT` - Server port (default: 4000)
- `MONGO_URI` - MongoDB connection string (default: mongodb://mongo:27017/lawpoint)
- `JWT_SECRET` - Secret key for JWT tokens

### Frontend
- `VITE_API_URL` - Backend API URL (default: /api)

## Manual Run

### Backend
```bash
docker run -p 4000:4000 \
  -e MONGO_URI=mongodb://host.docker.internal:27017/lawpoint \
  subhaniuduwawala/lawpoint-backend:latest
```

### Frontend
```bash
docker run -p 3000:80 subhaniuduwawala/lawpoint-frontend:latest
```

## Tech Stack

**Backend:**
- Node.js + Express.js
- MongoDB + Mongoose
- JWT authentication
- bcrypt password hashing

**Frontend:**
- React 18
- Vite
- React Router
- Axios

## Source Code

GitHub: https://github.com/Subhaniuduwawala/LawPoint

## License

MIT
