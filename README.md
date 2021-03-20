# gcp_infrastructure
This project aims to create a managed [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine/?utm_source=google&utm_medium=cpc&utm_campaign=japac-NZ-all-en-dr-bkws-all-all-trial-e-dr-1009882&utm_content=text-ad-none-none-DEV_c-CRE_273996458580-ADGP_Hybrid%20%7C%20BKWS%20-%20EXA%20%7C%20Txt%20~%20Containers%20~%20Kubernetes%20Engine_Kubernetes-kubernetes%20engine-KWID_43700033867247300-kwd-369526655975&userloc_1011038-network_g&utm_term=KW_google%20kubernetes%20engine&gclid=CK-Q4Mn1_u4CFVHojgodg9IGWQ) service in order to Test or use in real world scenario. This kubernetes engine will have a single multi purpose node pool that will be entirely managed by GKE(automatic kubernetes version upgrades and auto repairs).

[Terraform](https://www.terraform.io/) is an open-source infrastructure as code software tool that allows you to write your infrastructure in a declarative form, plan it against your cloud infrastructure provider([gcp](https://cloud.google.com/gcp/?utm_source=google&utm_medium=cpc&utm_campaign=japac-NZ-all-en-dr-bkws-all-all-trial-e-dr-1009882&utm_content=text-ad-none-none-DEV_c-CRE_498991269773-ADGP_Hybrid%20%7C%20BKWS%20-%20EXA%20%7C%20Txt%20~%20GCP%20~%20General%20_%20Core%20Brand-KWID_43700060691921453-kwd-6458750523-userloc_1011038&utm_term=KW_google%20cloud-ST_google%20cloud&gclid=CNWvm7n7_u4CFQzljgodrgMLgQ), [aws](https://aws.amazon.com/?nc2=h_lg), [azure](https://azure.microsoft.com/en-us/)) and apply your non destructive changes. This means that in case we need a new environment(Test or staging) we can easily replicate our infrastructure.

## Tools Requirements
* [Download and install terraform](https://www.terraform.io/downloads.html)
* [Install google cloud sdk](https://cloud.google.com/sdk/docs/install)
* [Initialize google cloud sdk](https://cloud.google.com/sdk/docs/initializing)
* [Install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

# Initial setup
First of all we need a google cloud account in order to be able to execute any terraform code against it.
Fortunately you can go to [google cloud](https://cloud.google.com/) and claim your $300 free credit so you can try all the resources available on it.

Login to your account and head to Iam&Admin and create a new service account(terraform) with "Owner" as a role, this means that we will allow terraform account to manage our Infrastructure. we will also need to generate a key for our recently created account, name it terraform_account.json and download it. Beware to not add it to your repository since it gives fool control of your infrastructure.

Create a [bucket](https://cloud.google.com/storage/docs/creating-buckets) (example name: terraform-remote-bucket) to hold your [terraform remote state](https://www.terraform.io/docs/language/state/remote.html) in order to share it with your teammates.

we will need to add versioning to our bucket as recommended by terraform and to achieve that we will rely on gsutil tool provided by the gcloud sdk.

```bash
> gsutil versioning set on gs://terraform-remote-bucket
```

verify if command was successful:
```bash
> gsutil versioning get gs://terraform-remote-bucket
```

## variables

### Input
| Name  | Value | Description |
| ------------- | ------------- | ------------- |
|project| gcp-playground-project | The default project to manage resources in|
|region| region |Region where our cluster will be created |
|machine_type| n1-standard-1 |The name of a Google Compute Engine machine type used for pod instances|
|app_subnet|"10.1.0.0/20"| app subnet cidr|
|vpc_name|"test-gke-k8s-vpc-cluster"| vpc name|
|db_instance_type|"db-f1-micro"|The name of a Google Compute Engine machine type used for the database|
|postgres_dbname|"geolocations"| dbname to be set in the config map and used as env variable in applications|

### Output 
| Name  |  Description |
| ------------- | ------------- |
|project_id|project id|
|k8s_account_id|kubernetes account id|
|terraform_account_id|terraform account id|
|ci_cd_account_id| ci/cd account id|
|vpc_id|vpc id|
|app-subnet| app subnet self link|


## Initialize terraform project
```bash
> terraform init
```

## Plan terraform project
```bash
> terraform plan -lock=true -out=out.plan -var-file=environments/production.tfvars
```
This command will create the plan file with name out.plan that can be used in the next step.

## Apply changes
```bash
> terraform apply out.plan
```
