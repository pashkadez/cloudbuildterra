        gcloud auth application-default login
        gcloud builds submit . --config=cloudbuild.yaml # in builder/
        gcloud builds submit . --config=cloudbuild.yaml --substitutions=_BUCKET='pashatestbucket1763' --timeout=2000
        gcloud builds submit . --config=clouddestroy.yaml --substitutions=_BUCKET='pashatestbucket1763' --timeout=2000