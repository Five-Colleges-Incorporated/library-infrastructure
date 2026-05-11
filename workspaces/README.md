# Workspaces

## DigitalOcean Teams

Five Colleges Libraries have three DigitalOcean teams.
1. libraries-global
1. libraries-production
1. libraries-development


The global team only contains Spaces Buckets and Access Keys.
No other team has Buckets or Access Keys.
The reason for this is that $5/month Spaces subscriptions are per team.
An additional reason is that DigitalOcean does not have fine-grained Bucket permissions
that can be assigned to team members. By isolating the Buckets and Access Keys
this allows wide access to the DigitalOcean console in the Production and Development team
while still keeping the bucket contents secure.
Only DigitalOcean "owners" have access to this workspace.

The production team contains both Production and Sandbox resources.
Sandbox applications are Production applications as they are used by Library staff for testing.
Not all applications have a sandbox version.

The development team is where developers have wide permissions to build/destroy/test infrastructure and application changes.
To save costs, infrastructure in this team is ephemeral and should be torn down during non-business hours.

## Terraform Workspaces

The admin workspaces manages Spaces Buckets and Access Keys in the libraries-global workspace.
It also manages projects and DNS across all three DigitalOcean teams.

The production and sandbox workspaces manage production and sanbox applications in the `libraries-production` team.
Developers have read-only access to these workspaces and can run Terraform plans but not applies.

The development workspace manages development applications in the libraries-development team.
Developers can run terraform plans and applies in this workspace.
