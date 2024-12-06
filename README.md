# GitOps_Argo_CD_1

```bash
mwiesing@workstation:~/udemy/agroCD$ cp -r section03_Workflow/helm/ section04_Agro_CD/exercise01/
mwiesing@workstation:~/udemy/agroCD$ cp -r section03_Workflow/manifests/ section04_Agro_CD/exercise01/
mwiesing@workstation:~/udemy/agroCD$ cp -r section03_Workflow/kustomize/ section04_Agro_CD/exercise01/
```

To generate a GitHub Personal Access Token for Argo CD:

Go to your GitHub account settings.
Navigate to Developer settings.
Select Personal access tokens.
Click on Generate new token.
Provide a name for the token (e.g., Argo CD).
Select the necessary scopes, such as repo and write:packages for repository access and package management.
Click on Generate token.
Copy and store the token securely as it will be shown only once.
Use this token when configuring Argo CD to authenticate with GitHub.


#### Git always fun:

mwiesing@workstation:~/udemy/agroCD/section04_Agro_CD/exercise01$ git checkout -b feature/increase-replicas
Switched to a new branch 'feature/increase-replicas'
mwiesing@workstation:~/udemy/agroCD/section04_Agro_CD/exercise01$ vim manifests/nginx-deployment.yaml
mwiesing@workstation:~/udemy/agroCD/section04_Agro_CD/exercise01$ git add manifests/nginx-deployment.yaml
warning: in the working copy of 'manifests/nginx-deployment.yaml', LF will be replaced by CRLF the next time Git touches it
mwiesing@workstation:~/udemy/agroCD/section04_Agro_CD/exercise01$ git commit -m "Increases the replica count"
[feature/increase-replicas 3fe6999] Increases the replica count
 1 file changed, 1 insertion(+), 1 deletion(-)
mwiesing@workstation:~/udemy/agroCD/section04_Agro_CD/exercise01$ git push origin feature/increase-replicas
Enter passphrase for key '/home/mwiesing/.ssh/id_ed25519':
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 24 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 396 bytes | 396.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
remote: This repository moved. Please use the new location:
remote:   git@github.com:marwiesing/GitOps_Argo_CD_1.git
remote:
remote: Create a pull request for 'feature/increase-replicas' on GitHub by visiting:
remote:      https://github.com/marwiesing/GitOps_Argo_CD_1/pull/new/feature/increase-replicas
remote:
To github.com:marwiesing/GitOps_Agro_CD_1.git
 * [new branch]      feature/increase-replicas -> feature/increase-replicas
mwiesing@workstation:~/udemy/agroCD/section04_Agro_CD/exercise01$ argocd app sync nginx
WARN[0000] Failed to invoke grpc call. Use flag --grpc-web in grpc calls. To avoid this warning message, use flag --grpc-web.
TIMESTAMP                  GROUP        KIND   NAMESPACE                  NAME    STATUS   HEALTH        HOOK  MESSAGE
2024-12-06T11:02:15+01:00            Service     default         nginx-service    Synced  Healthy
2024-12-06T11:02:15+01:00   apps  Deployment     default      nginx-deployment    Synced  Healthy
2024-12-06T11:02:15+01:00            Service     default         nginx-service    Synced  Healthy              service/nginx-service unchanged
2024-12-06T11:02:15+01:00   apps  Deployment     default      nginx-deployment    Synced  Healthy              deployment.apps/nginx-deployment unchanged

Name:               argo-cd/nginx
Project:            default
Server:             https://kubernetes.default.svc
Namespace:          default
URL:                https://argocd.example.com/applications/nginx
Source:
- Repo:             https://github.com/marwiesing/GitOps_Argo_CD_1
  Target:           main
  Path:             manifests
SyncWindow:         Sync Allowed
Sync Policy:        Automated (Prune)
Sync Status:        Synced to main (1d31b19)
Health Status:      Healthy

Operation:          Sync
Sync Revision:      1d31b19c67ed958c0d6482a62762a864d08204b9
Phase:              Succeeded
Start:              2024-12-06 11:02:15 +0100 CET
Finished:           2024-12-06 11:02:15 +0100 CET
Duration:           0s
Message:            successfully synced (all tasks run)

GROUP  KIND        NAMESPACE  NAME              STATUS  HEALTH   HOOK  MESSAGE
       Service     default    nginx-service     Synced  Healthy        service/nginx-service unchanged
apps   Deployment  default    nginx-deployment  Synced  Healthy        deployment.apps/nginx-deployment unchanged
mwiesing@workstation:~/udemy/agroCD/section04_Agro_CD/exercise01$ k get pods
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-5f89844fc9-7c54p   1/1     Running   0          20m
nginx-deployment-5f89844fc9-98685   1/1     Running   0          2m14s
nginx-deployment-5f89844fc9-nmjwv   1/1     Running   0          20m
nginx-deployment-5f89844fc9-px6fb   1/1     Running   0          2m14s
nginx-deployment-5f89844fc9-rtmx7   1/1     Running   0          2m14s
nginx-deployment-5f89844fc9-zhrjz   1/1     Running   0          20m
mwiesing@workstation:~/udemy/agroCD/section04_Agro_CD/exercise01$ k get rs
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-5f89844fc9   6         6         6       20m
mwiesing@workstation:~/udemy/agroCD/section04_Agro_CD/exercise01$ git branch
* feature/increase-replicas
  main
mwiesing@workstation:~/udemy/agroCD/section04_Agro_CD/exercise01$ git checkout  main
M       README.md
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
mwiesing@workstation:~/udemy/agroCD/section04_Agro_CD/exercise01$ git merge feature/increase-replicas
Merge made by the 'ort' strategy.
 manifests/nginx-deployment.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)