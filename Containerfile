### Build stage
FROM node:22.16.0-alpine3.22 AS builder

# Set working directory
WORKDIR /app

# Install pnpm
RUN corepack enable

# Copy package files and install them
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

# Copy source files and build the app
COPY ./src ./src
COPY ./static ./static
COPY ./.svelte-kit ./.svelte-kit
COPY svelte.config.js tsconfig.json vite.config.ts ./
RUN pnpm build

### Runtime stage
FROM node:22.16.0-alpine3.22

# Set working directory
WORKDIR /app

# Copy production dependencies
COPY --from=builder /app/package.json /app/pnpm-lock.yaml ./
RUN corepack enable && pnpm install --prod --frozen-lockfile

# Copy build output from builder stage
COPY --from=builder /app/build ./build

# Expose port
ENV PORT=3000
EXPOSE 3000

# Run as non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Command to run application
CMD ["node", "build/index.js"]
