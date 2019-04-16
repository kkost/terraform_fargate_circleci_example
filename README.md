# About

I was unable to find a working, whole, end-to-end example of this on the interwebs. So I made one.  

Use Terraform to deploy infrastructure for AWS Fargate and use CircleCI to deploy to said infrastructure.  

Creates these resources in AWS:  
- VPC (subnets, security groups, routes, internet gateway)  
- ALB (listener and target group)  
- ECS (cluster, task definition)  
- ECR repo  
- IAM roles  

WARNINGS:
- Running `terraform apply` with these templates will cost some money. I've attempted to keep the resources used to a bare minimum while still being functional.  
- This does not use a private subnet, elastic IPs, or NAT gateways like most of the examples out there (which may be pertinent for resource isolation/etc)  
- Running `terraform destroy` isn't clean (yet). See TODO section below  

```
cd terraform
cp terraform.tfvars.dist terraform.tfvars
vim terraform.tfvars  # add your aws access/secret keys. terraform.tfvars is .gitignore'd
terraform init
terraform apply  # outputs elb cname
cd ..
# add project in CircleCI
# add environment variables (AWS_ACCOUNT_ID, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION, AWS_RESOURCE_NAME_PREFIX) to CircleCI project settings
# (hackhackhack)
git add .
git commit -m "hail eris!"
git push
# wait for cci and aws hamsters to turn some wheels
curl http://<alb_cname>/
```

TODO:  
- figure out why destroying isn't clean (may need to manually stop ECS tasks and deregister task definitions?? also manually delete security group?)  
- abstract more stuff to variables  
- add comments/descriptions  
- access logs/etc  
- health checks  
- tags  
- another version of this using EKS
