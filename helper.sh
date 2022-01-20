set -e

PROJECT_ID=$(gcloud config get-value project)
NOTRANDOM=${RANDOM}
DIR=${PWD}
CB_SA_ID=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")@cloudbuild.gserviceaccount.com

echo "Slack webhook URL(must be stated):"
read SLACK_WH
if [ -z "$SLACK_WH" ]
then
    echo "Missing value!"; exit $ERRCODE;
fi
cat << EOF > SLACK_WH.txt
${SLACK_WH}
EOF

echo "secret(default if not stated):"
read secret
if [ -z ${secret} ]
  then
    secret="devops116kv"
fi
cat << EOF > secret.txt
${secret}
EOF

echo "Bucket name(default if not stated):"
read BUCKET
if [ -z ${BUCKET} ]
  then
    BUCKET="devops116kv-test-bucket"
fi
TERRAFORM_BUCKET="${BUCKET}-${NOTRANDOM}"

echo "Service account name(default if not stated):"
read SERVICE_ACCOUNT_ID
if [ -z ${SERVICE_ACCOUNT_ID} ]
  then
    SERVICE_ACCOUNT_ID="serv-acc"
fi


SA_ID="${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com"

echo "Enabling required API's"
gcloud services enable \
  cloudresourcemanager.googleapis.com \
  --project ${PROJECT_ID}

gcloud services enable \
  iam.googleapis.com \
  --project ${PROJECT_ID}

gcloud services enable \
  admin.googleapis.com \
  --project ${PROJECT_ID}

gcloud services enable \
  compute.googleapis.com \
  --project ${PROJECT_ID}

gcloud services enable \
  cloudkms.googleapis.com \
  --project ${PROJECT_ID}

gcloud services enable \
  cloudbuild.googleapis.com \
  --project ${PROJECT_ID}

gcloud services enable \
  sqladmin.googleapis.com \
  --project ${PROJECT_ID}

gcloud services enable \
  servicenetworking.googleapis.com \
    --project=${PROJECT_ID}

gcloud services enable \
  container.googleapis.com \
    --project=${PROJECT_ID}

gcloud services enable \
  secretmanager.googleapis.com \
    --project=${PROJECT_ID}

gsutil mb -p ${PROJECT_ID} -c regional -l "europe-central2" gs://${TERRAFORM_BUCKET}
gsutil versioning set on gs://${TERRAFORM_BUCKET}

gcloud iam service-accounts create ${SERVICE_ACCOUNT_ID} \
    --description="SAcc" \
    --display-name="SAcc" \
    --project=${PROJECT_ID} 

gcloud iam service-accounts keys create ${DIR}/sa-private-key.json \
    --iam-account=${SA_ID}

echo "Adding role roles/storage.admin..."
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=serviceAccount:${SA_ID} \
    --role="roles/storage.admin"


echo "Adding role roles/compute.networkAdmin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/compute.networkAdmin" \
  --user-output-enabled false

echo "Adding role roles/resourcemanager.projectIamAdmin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/resourcemanager.projectIamAdmin" \
  --user-output-enabled false

echo "Adding role roles/compute.storageAdmin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/compute.storageAdmin" \
  --user-output-enabled false

echo "Adding role roles/iam.securityAdmin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/iam.securityAdmin" \
  --user-output-enabled false

echo "Adding role roles/compute.admin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/compute.admin" \
  --user-output-enabled false

echo "Adding role roles/container.serviceAgent..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/container.serviceAgent" \
  --user-output-enabled false

echo "Adding role roles/secretmanager.admin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/secretmanager.admin" \
  --user-output-enabled false

echo "Adding role roles/cloudsql.admin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/cloudsql.admin" \
  --user-output-enabled false

echo "Adding cloudbuild roles..."

echo "Adding role roles/storage.admin..."
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member=serviceAccount:${CB_SA_ID} \
    --role="roles/storage.admin"


echo "Adding role roles/compute.networkAdmin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${CB_SA_ID}" \
  --role="roles/compute.networkAdmin" \
  --user-output-enabled false

echo "Adding role roles/resourcemanager.projectIamAdmin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${CB_SA_ID}" \
  --role="roles/resourcemanager.projectIamAdmin" \
  --user-output-enabled false

echo "Adding role roles/compute.storageAdmin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${CB_SA_ID}" \
  --role="roles/compute.storageAdmin" \
  --user-output-enabled false

echo "Adding role roles/iam.securityAdmin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${CB_SA_ID}" \
  --role="roles/iam.securityAdmin" \
  --user-output-enabled false

echo "Adding role roles/compute.admin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${CB_SA_ID}" \
  --role="roles/compute.admin" \
  --user-output-enabled false

echo "Adding role roles/container.serviceAgent..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${CB_SA_ID}" \
  --role="roles/container.serviceAgent" \
  --user-output-enabled false

echo "Adding role roles/secretmanager.admin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${CB_SA_ID}" \
  --role="roles/secretmanager.admin" \
  --user-output-enabled false

echo "Adding role roles/cloudsql.admin..."
gcloud projects add-iam-policy-binding \
  "${PROJECT_ID}" \
  --member="serviceAccount:${CB_SA_ID}" \
  --role="roles/cloudsql.admin" \
  --user-output-enabled false


gcloud secrets create slack_wh --data-file=SLACK_WH.txt
gcloud secrets create db_pass --data-file=secret.txt
gcloud secrets create sa_cred --data-file=sa-private-key.json
rm sa-private-key.json
rm secret.txt
rm SLACK_WH.txt

echo "Creating envvars.sh"
cat << EOF > envvars.sh
export TF_VAR_project=$PROJECT_ID
export TF_VAR_bucket=$TERRAFORM_BUCKET
EOF

export TF_VAR_bucket=$TERRAFORM_BUCKET
export TF_VAR_project=$PROJECT_ID
export JENKINS_USER_ID=admin
export JENKINS_API_TOKEN=abc1234ffe4a

(cd builder_terra && gcloud builds submit . --config=cloudbuild.yaml)
(cd jnlp_docker && gcloud builds submit . --config=cloudbuild.yaml)
(gcloud builds submit . --config=cloudbuild.yaml --substitutions=_BUCKET=${TERRAFORM_BUCKET} --timeout=2000)

terraform init -backend-config=bucket=$TF_VAR_bucket

gcloud container clusters get-credentials terraform-built --zone europe-central2-b --project $TF_VAR_project
kubectl cp jobs jenkins/jenkins-0:/var/jenkins_home

echo "java -jar jenkins-cli.jar -s http://jenkins_ip:8080 -auth admin:${secret} reload-configuration"