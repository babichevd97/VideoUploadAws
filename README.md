# VideoUploadAws
## Pre-requisites
To run this project you will need followings:
* Docker
* Terraform 
* AWS account

## Project Description
On example of simple image (IMG_0376.JPG), file devision to chunks and back-stitching it to original format is shown
Logic is similar:
- Run python microservice, that will split image to bytes, upload it to S3 and send SQS message to first queue.
- After SQS message is received, an lambda-code (src/lambda.py) is executed. As a result, image is restored and put to S3. New message is sent to another queue

## Project Structure
- **src** - source code of lambda microservice and all needed pip dependencies
- **modules** - terraform modules, that create all essential resources
- **main** - terraform should be runned from it

## Usage
### Terraform
- Init terraform
```bash
terraform init
```
- Configure your credentials via aws-cli (you will need an account). It is done inside provider section (shared_credentials_files)
- Plan changes
```bash
terraform plan
```
- In case you are saticfied with everything, create your infrastructure. **For easing the process, all S3 are created with public access!!! Keep that in mind**
```bash
terraform apply
```
Your infrastructure is ready!

### Docker
Before start, check src code (ChunksUpload.py). It uses pre-defined values, but you can change them, if needed
Now you can start you microservice. 
```bash
docker build -t flask-app .
docker run -p 8181:8181 flask-app
```

To split image (given in the repo) and upload it in chunks to S3, run command:
```bash
curl -X POST -F "file=@IMG_0376.JPG" http://localhost:8181/uploadChunks  
```

To send SQS-message, run command:
```bash
curl -X GET http://localhost:8181/stitch 
```

After that, you can check your CloudWatch logs and queue logs, to make sure everything worked as expected