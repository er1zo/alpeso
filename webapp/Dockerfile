# Use the official PHP image
FROM php:7.4-cli

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY index.php /var/www/html

# Expose port 8089 for the app
EXPOSE 8089

# Run PHP's built-in server and listen on port 8089
CMD ["php", "-S", "0.0.0.0:8089", "-t", "/var/www/html"]