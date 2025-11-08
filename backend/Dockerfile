FROM node:18-alpine
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json* ./
RUN npm install --production --silent

# Copy source
COPY . .

EXPOSE 4000

ENV PORT=4000

CMD ["node", "server.js"]
