pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ECR_REPO   = "842746302447.dkr.ecr.ap-south-1.amazonaws.com/formfill-app"
        IMAGE_TAG  = "latest"
        CLUSTER    = "eks-cluster"
        NAMESPACE  = "frontend"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/vinunnithan/Formfillapp1.git',
                credentialsId: 'github-creds'
            }
        }

        stage('Build Maven') {
            steps {
                sh '/opt/maven/bin/mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t formfill-app:${IMAGE_TAG} .
                docker tag formfill-app:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
                '''
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh '''
                export TRIVY_CACHE_DIR=/var/lib/jenkins/trivy-cache
                export TMPDIR=/var/lib/jenkins/tmp
		mkdir -p $TRIVY_CACHE_DIR
		mkdir -p $TMPDIR
		trivy image \
		--cache-dir $TRIVY_CACHE_DIR \
		--skip-db-update \
		--exit-code 1 \
		--severity HIGH,CRITICAL \
		formfill-app:${IMAGE_TAG}
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region ${AWS_REGION} | \
                docker login --username AWS --password-stdin ${ECR_REPO}
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh 'docker push ${ECR_REPO}:${IMAGE_TAG}'
            }
        }

        stage('Configure kubeconfig') {
            steps {
                sh '''
                aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER}
                kubectl get nodes
                '''
            }
        }

        stage('Deploy using Helm') {
            steps {
                sh '''
                helm upgrade --install formfillapp ./helm/formfill-app \
                --namespace ${NAMESPACE} \
                --set image.repository=${ECR_REPO} \
                --set image.tag=${IMAGE_TAG}
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                kubectl get pods -n ${NAMESPACE}
                kubectl get svc -n ${NAMESPACE}
                kubectl get ingress -n ${NAMESPACE}
                '''
            }
        }
    }
}
