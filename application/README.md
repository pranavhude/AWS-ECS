# ECS DevOps Practical Test – Sample Application

This is a minimal containerized application used to demonstrate
deployment on Amazon ECS (EC2 launch type).

## Application Details
- Web Server: Nginx
- Port: 80
- Container Type: Stateless
- Purpose: Infrastructure & DevOps demonstration

## How it Works
- Static HTML page served via Nginx
- Container image stored in Amazon ECR / DockerHub
- Deployed as an ECS Service behind an Application Load Balancer

## Why This App
The goal of this test is infrastructure automation, security,
monitoring, and ECS configuration — not application complexity.

This app keeps things simple while proving:
- ECS task execution
- ALB routing
- Logging to CloudWatch
- Secrets injection capability
