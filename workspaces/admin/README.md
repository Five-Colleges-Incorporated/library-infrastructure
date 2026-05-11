# Library Admin Workspace

## Setup

This is a hybrid workspace which touches all DigitalOcean teams.
It manages buckets, access keys, domains, and projects across all teams.
DigitalOcean doesn't actually allow programatically managing users/roles but that management would go here.

### Infrastructure Setup

In the `libraries-global` team manually:
1. In the  `first-project` project and `nyc3` region
    1. Create a Bucket with the name `fclib-admn-infrastructure-5c-state-XX`
    1. Create a Bucket with the name `fclib-admn-infrastructure-5c-state-XX-accesslogs`
1. Create an Access Key with Full Access with the name `5c.tfadmin-<semester>.<year>`
1. Create a Personal Access Token (PAT) with the following scopes:
    1. actions:read
    1. cdn:all
    1. domain:all
    1. project:all
    1. regions:read
    1. sizes:read
    1. spaces:all
    1. spaces_key:all
1. Set bucket versioning, lifecycle, and logging policies for the using aws-cli

```sh
aws configure

aws s3api put-bucket-logging \
    --endpoint https://nyc3.digitaloceanspaces.com \
    --bucket fclib-admn-infrastructure-5c-state-01 \
    --bucket-logging-status '{
      "LoggingEnabled":
      {
        "TargetBucket": "fclib-admn-infrastructure-5c-state-01-accesslogs",
        "TargetPrefix": "fclib-admn-infrastructure-5c-state-01/"
      }
    }'

aws s3api put-bucket-versioning \
  --endpoint=https://nyc3.digitaloceanspaces.com \
  --bucket fclib-admn-infrastructure-5c-state-01 \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-lifecycle-configuration \
  --endpoint https://nyc3.digitaloceanspaces.com \
  --bucket fclib-admn-infrastructure-5c-state-01 \
  --lifecycle-configuration '{
    "Rules": [
      {
        "ID": "expire-delete-markers",
        "Status": "Enabled",
        "Filter": {},
        "Expiration": { "ExpiredObjectDeleteMarker": true }
      },
      {
        "ID": "expire-noncurrent-versions",
        "Status": "Enabled",
        "Filter": {},
        "NoncurrentVersionExpiration": { "NoncurrentDays": 365 }
      },
      {
        "ID": "abort-multipart-uploads",
        "Status": "Enabled",
        "Filter": {},
        "AbortIncompleteMultipartUpload": { "DaysAfterInitiation": 1 }
      }
    ]
  }'

aws s3api put-bucket-lifecycle-configuration \
  --endpoint https://nyc3.digitaloceanspaces.com \
  --bucket fclib-admn-infrastructure-5c-state-01-accesslogs \
  --lifecycle-configuration '{
    "Rules": [
      {
        "ID": "expire-logs",
        "Status": "Enabled",
        "Filter": {},
        "Expiration": { "Days": 365 }
      },
      {
        "ID": "abort-multipart-uploads",
        "Status": "Enabled",
        "Filter": {},
        "AbortIncompleteMultipartUpload": { "DaysAfterInitiation": 1 }
      }
    ]
  }'
```

For the `libraries-production` and `libraries-development` teams manually create a PAT with the following scopes:
1. domain:all
1. project:all

### Running OpenTofu

Set the following environment variables to the `libraries-global` values
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `SPACES_ACCESS_KEY_ID`
* `SPACES_SECRET_ACCESS_KEY`
* `DIGITAL_OCEAN_ACCESS_TOKEN`
* `SOPS_AGE_KEY`

See the [DigitalOcean Provider](https://search.opentofu.org/provider/opentofu/digitalocean/latest)
and [S3 backend](https://opentofu.org/docs/language/settings/backends/s3/#credentials-and-shared-configuration)
documentation for other authentication options.

The state must have been encrypted with your age key as an recipient.
See [tofu-age-encryption](https://github.com/josh/tofu-age-encryption) for more age configuration options.

Also, set any additional PATs using `TF_VAR_<TEAM>_DIGITAL_OCEAN_ACCESS_TOKEN`.
