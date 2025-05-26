# Shazam du Vin

A wine recognition application based on Flutter.

## Project Structure

- **front-end**: Flutter mobile application
- **shazam-du-vin_back**: Flask backend API

## Backend Deployment

### Using Docker Compose

We provide a Docker Compose configuration that can start the complete backend environment (Flask + MongoDB) with a single command:

1. Make sure Docker and Docker Compose are installed

2. Set AWS environment variables (for image processing and OCR functionality):
   ```bash
   export AWS_ACCESS_KEY_ID=your_aws_key
   export AWS_SECRET_ACCESS_KEY=your_aws_secret
   ```

3. Start services:
   ```bash
   docker-compose up -d
   ```

4. Stop services:
   ```bash
   docker-compose down
   ```

### Manual Deployment

If you want to run the backend service separately:

```bash
cd shazam-du-vin_back
docker build -t shazamvin_backend:v1.0.0 .
docker run --rm --name shazamvin_back -p 5000:5000 shazamvin_backend:v1.0.0
```

#### Installing MongoDB Docker Image and Configuration

Use these commands to install and run the official MongoDB Docker image:

```bash
docker pull mongo
docker run --rm --name mongodb -p 27017:27017 id_of_container/name_of_container
```

To get the IP address of your MongoDB container, use:

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' id_of_container/name_of_container
```

If you're setting up the services separately (without Docker Compose), you'll need to modify the MongoDB connection string in `MongoAPI.py`. Change:

```python
self.client = MongoClient("mongodb://mongodb:27017/")
```

to:

```python
self.client = MongoClient("mongodb://your_mongodb_container_ip:27017/")
```

## Frontend Deployment

The APK is available on Git. Simply download it and run it on your Android device.

And if you use the APK on Git, to ensure the connection between the application and back-end, use this command.

```cmd
adb reverse tcp:5000 tcp:5000
```