# TODO: Fill this Dockerfile in during Block 6
# Hints:
#   Base image: ubuntu:24.04
#   WORKDIR: /app
#   COPY the greet script
#   RUN chmod +x greet
#   Set ENV defaults for GREETING and NAME
#   CMD to run the script


# Base Image
FROM ubuntu:24.04

# Set the working directory
WORKDIR /app

# Copy the script from host into the container
COPY greet .

# Make the script executable
RUN chmod +x greet 

# Set some env variables
ENV GREETING=Hello
ENV NAME=Word

# Default command to run on start
CMD ["./greet"]
