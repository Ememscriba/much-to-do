# Much To Do - StartTech Full Stack Application

## Live Infrastructure
All infrastructure runs on AWS us-east-1.

## Repository Links
- Application: https://github.com/Ememscriba/much-to-do
- Infrastructure: https://github.com/Ememscriba/starttech-infra

## AWS Details
- Account ID: 954692413962
- Region: us-east-1
- Load Balancer: starttech-alb-986580528.us-east-1.elb.amazonaws.com
- S3 Bucket: starttech-frontend-f466916d

## CI/CD Pipelines
- Frontend pipeline deploys React to S3
- Backend pipeline builds Docker image and deploys to EC2

## Infrastructure
Built with Terraform. See starttech-infra repo for full details.
