# Stage 1 — Build React app
FROM node:20 AS build
WORKDIR /app

ARG CF_API_TOKEN
ARG CF_ACCOUNT_ID
ARG CF_PAGES_PROJECT_NAME

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2 — Deploy directly from Docker build
# Set environment variables for Wrangler
ENV CLOUDFLARE_API_TOKEN=$CF_API_TOKEN
ENV CLOUDFLARE_ACCOUNT_ID=$CF_ACCOUNT_ID

RUN npm install -g wrangler@3 && \
    echo "🚀 Deploying to Cloudflare Pages..." && \
    wrangler pages deploy ./build \
      --project-name=$CF_PAGES_PROJECT_NAME
