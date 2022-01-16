helper.sh will use your gcloud cli's current login and project, so the first thing to do is:

        gcloud auth application-default login

You clone repo and start the script:

        git clone https://github.com/pashkadez/cloudbuildterra.git
        sudo chown username cloudbuildterra -R
        cd cloudbuildterra
        ./helper.sh

The script will:
- enable APIs
- create service account and its key
- create bucket for terraform state and enable versioning for it
- add cloud build and newly created service account to roles
- create Secret Manager's secrets
- build all needed images to gcr.io with Cloud Build
- apply terraform configuration in Cloud Build
- export variables needed for local terraform init and apply

Terraform config will:
- create cluster with single node
- deploy production grade jenkins with Helm
- render variables.yaml from template