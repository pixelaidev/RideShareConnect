# --- Stage 1: Build the application ---
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything and restore
COPY . .
RUN dotnet restore

# Build & publish for production
RUN dotnet publish -c Release -o /app/publish --no-restore

# --- Stage 2: Run the application ---
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy published files
COPY --from=build /app/publish .

# Expose port for Render
EXPOSE 8080

# IMPORTANT: Render sets PORT env var, so bind to 0.0.0.0
ENV ASPNETCORE_URLS=http://0.0.0.0:8080

ENTRYPOINT ["dotnet", "RideShareConnect.dll"]
