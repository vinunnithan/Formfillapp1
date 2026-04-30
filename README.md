This project demonstrates an end-to-end DevOps pipeline for deploying a Java web application on AWS 
It includes:

* CI/CD automation with Jenkins
* Containerization using Docker
* Security image scanning using Trivy
* Deployment to AWS EKS (Fargate)
* Monitoring basic logs and alerting
* Helm-based Kubernetes deployments

---

## Architecture

```
Developer → GitHub → Jenkins Pipeline → Docker Build → Trivy Scan → Amazon ECR → EKS (Fargate) → AWS ALB → End User
                                              ↓
                                      CloudWatch Monitoring
```

 Prerequisites

Make sure the following are installed:

* AWS CLI
* kubectl
* eksctl
* Docker
* Helm
* Jenkins
* Java 21
* Maven

---

## Tech Stack

| Category   | Tools Used                    |
| ---------- | ----------------------------- |
| Cloud      | AWS EKS (Fargate), ECR, ALB   |
| CI/CD      | Jenkins                       |
| Container  | Docker                        |
| Build Tool | Maven                         |
| Deployment | Helm                          |
| Security   | Trivy                         |
| Monitoring | CloudWatch Container Insights |
| Language   | Java (WAR - Tomcat based app) |

---

📦 Application Details

* Java web application packaged as a **WAR file**
* Built using Maven
* Deployed on Apache Tomcat (inside Docker container)

---

🔄 CI/CD Pipeline Flow

1. Code Checkout from GitHub
2. Build Application using Maven
3. Build Docker Image
4. Security Scan using Trivy

    Fails build if HIGH/CRITICAL vulnerabilities found
5. Push Image to Amazon ECR
6. Deploy to EKS using Helm
7. Verify Deployment using kubectl

---

🔐 Security (Trivy Integration)

Integrated Trivy into Jenkins pipeline
Scans Docker images before pushing to ECR
Pipeline fails if vulnerabilities detected:

```
--severity HIGH,CRITICAL
--exit-code 1
```

---

☸️ Kubernetes Deployment

* EKS cluster created using `eksctl`using cluster.yaml file configuration
* Running on AWS Fargate (serverless compute)
* Namespaces used:

  * frontend → Application
  * kube-system → System components
 

🌐 Ingress

* AWS Load Balancer Controller used
* Internet-facing ALB created
* Application exposed via Loadbalancer DNS

--

Setup & Deployment

1 Build Application

```bash
mvn clean package 

---
2 Build Docker Image

```bash
docker build -t formfill-app:latest .
```

---

3️ Run Trivy Scan

```bash
trivy image --severity HIGH,CRITICAL formfill-app:latest
```


4.Push to ECR

```bash
docker tag formfill-app:latest <ECR_REPO>:latest
docker push <ECR_REPO>:latest
```
 5.Deploy using Helm

```bash
helm upgrade --install formfillapp ./helm/formfill-app \
--namespace frontend
```

---
6. Verify Deployment

```bash
kubectl get pods -n frontend
kubectl get svc -n frontend
kubectl get ingress -n frontend
```


 Key things achieved

✔ Fully automated CI/CD pipeline
✔ Secure image scanning with Trivy
✔ Serverless Kubernetes using Fargate
✔ ALB-based application exposure
✔ Centralized monitoring with CloudWatch
✔ Helm-based deployment (production-ready approach)



 Notes

This project is built as a Proof of Concept to demonstrate real-world DevOps practices using AWS and Kubernetes
