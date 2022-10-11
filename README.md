# Guusto
Guusto project

This project is to deploy java-based merchant-service and shopping-service applications in an eks kubernetes cluster with infrastructure provisioned using Terraform.

# Step One: Cloning the bitbucket repo into Github
Create a directory Guusto on the local
On the local, run the git clone <url> to clone the repo into your github account.
  Check the files including the pom.xml
  Create the deployment and k8s-eks-aws folders in this same directory.
  
  # Step Two: Creating the docker images
  Create a Dockerfile which is used in building an application image. Since the application is a java application that creates a .jar artifact, we used Maven as our build image. 
  The Docker file contains instructions to use maven as a base image and then copies the the pom.xml and src files to build an artiifact. 
  Then use dependencies from this artifact along with an image from alphine to create a new image for the merchant and shopping applications 
  To build the image in the local repo, run the following commands on a docker server on Ubuntu
  docker build - t <nameofImage>:Tag . e.g. docker build -t genedemo/merchant:1 .
                                      docker build -t genedemo/shopping:1 .
  The image is then used to to Run the container in detachable mode,
  docker run -d -p 8081:8081 genedemo/merchant:1 #(-d = detachable mode -p = port forwarding)
  docker run -d -p 8082:8082 genedemo/shopping:1
  
  Push the image to a public registry (Note: you may be required to authenticate in docker) This will allow for developers to be able to pull the image directly to their local repo
  docker push <ImageName>:Tag  e.g. docker push genedemo/merchant:1
                                  docker push genedemo/shopping:1
  
  # Step Three: Creating a docker-compose file
  
  Create a docker-compose.yml file for the merchant and shopping services application. This generates the manifest files
    Run kompose convert 
    to convert the docker-compose.yml file into the corresponding deployment.yml, service.yml and cicdnetwork-networkpolicy.yml files.
  
  These files are used to deploy the corresponding applications in the eks cluster using
    kubectl apply -f <NameofDeployment>,<NameofService>,<NameofNetworkPolicy>  #(This stage is done only after the eks infrastructure has been provisioned as in Step 3 below)
  
  # Step Four: Provision an AWS Kubernetes cluster (eks) using Terraform
  
  Navigate to the Terraform manifest file k8s-eks-aws, and run Terraform init, Terraform validate, Terraform Plan, Terraform Apply
    terraform apply --auto-approve will provision the entire infrastructure by automating the process.
  
  Two outputs are generated which will be used to copy the kubeconfig file from kubernetes.
    Run the following to copy the kubeconfig file
    aws eks update-kubeconfig --name main-vpc-cluster --region us-east-1 #(Enure that your AWS CLI is running the latest version)
    This copies the kubeconfig from aws to the local repo which allows for the ability to run your k8s CLI (kubectl)
  
  To check running pods, run the following command
    kubectl get pods
  
  Deploy the application to the eks cluster using
    kubectl apply -f <NameofDeployment>,<NameofService>,<NameofNetworkPolicy>
  
  To check for running deployments, run the following command
    kubectl get deployments
  
  # Step Five: Push all the working folders to GitHub
  From the local environment, run the following commands to push the work unto GitHub
    git add .
    git commit -am "message"
    git remote add origin <urlofGitHubRepo>
    git branch -M main
    git push -u origin main
  
  
  
