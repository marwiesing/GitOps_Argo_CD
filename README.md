# GitOps_Argo_CD
---

### **Steps to Move a Submodule**

1. **Move the Submodule Directory**
   ```bash
   mv section04_Argo_CD/exercise/ exercise
   ```

2. **Update the `.gitmodules` File**
   Open `.gitmodules` in a text editor and update the `path` field for the submodule:
   ```bash
   vi .gitmodules
   ```
   Change the path:
   ```text
   [submodule "exercise"]
       path = exercise
       url = git@github.com:marwiesing/GitOps_Argo_CD.git
   ```

3. **Deinitialize the Submodule**

   Deinitialize the submodule to ensure a clean slate. This will remove the submodule's reference from the Git configuration.

   ```bash
   git submodule deinit -f section04_Argo_CD/exercise
   ```

   This command ensures that the submodule is no longer initialized and its cached data is removed from the repository.

4. **Remove the Old Submodule Directory**

   You need to delete the old submodule directory to ensure that no old files are left behind:

   ```bash
   rm -rf section04_Argo_CD/exercise
   ```

   This step removes the submodule's files from the old location.

5. **Fix the Worktree Path**

   Git stores submodule-specific information in a separate directory under `.git/modules/`. After you’ve deinitialized and removed the submodule, you'll need to update the submodule’s path in this configuration to reflect the new location.

   Edit the configuration file for the submodule:

   ```bash
   vi .git/modules/exercise/config
   ```

   In this file, you should find a line like this:

   ```ini
   worktree = ../../../section04_Argo_CD/exercise
   ```

   Change it to the new submodule path:

   ```ini
   worktree = ../../exercise
   ```

   This ensures that Git points to the correct location of the submodule after it has been moved.

6. **Re-add the Submodule**

   At this point, you’ll need to re-add the submodule. If Git detects that the submodule already exists in the index, use the `--force` flag to overwrite it and avoid conflicts:

   ```bash
   git submodule add --force git@github.com:marwiesing/GitOps_Argo_CD.git exercise
   ```

   Without the `--force` option, Git will complain that the submodule already exists in the index. The `--force` flag forces Git to overwrite the existing reference and re-add the submodule at the new location.

7. **Update Git Configuration**
   Update Git's internal configuration to reflect the new path:
   ```bash
   git submodule sync
   git submodule update --init --recursive
   ```

4. **Remove Old Submodule Reference**
   Remove the old submodule reference from `.git/config`:
   ```bash
   git config --remove-section submodule.section04_Argo_CD/exercise
   ```

5. **Stage and Commit Changes**
   Stage the updated `.gitmodules` file and the submodule move:
   ```bash
   git add .gitmodules
   git add exercise
   git commit -m "Moved submodule exercise to the parent directory"
   ```

6. **Verify the Changes**
   Confirm that the submodule now points to the new location:
   ```bash
   git submodule status
   ```

---

### Troubleshooting Common Issues:

1. **Submodule Already Exists in Index**:
   - **Problem**: When trying to re-add the submodule, Git may show an error stating that the submodule already exists in the index.
   - **Solution**: Use the `--force` flag to overwrite the existing submodule reference:
     ```bash
     git submodule add --force git@github.com:marwiesing/GitOps_Argo_CD.git exercise
     ```

2. **No URL Found for Submodule**:
   - **Problem**: You may encounter an error like "No URL found for submodule path" when running `git submodule update`.
   - **Solution**: This error occurs if the `.gitmodules` file is missing the URL or is not synchronized. Ensure the `.gitmodules` file has the correct path and URL for the submodule, then run:
     ```bash
     git submodule sync
     ```

3. **Leftover Files or Incorrect Worktree Path**:
   - **Problem**: Sometimes, leftover files or an incorrect worktree path can cause issues with the submodule. 
   - **Solution**: Ensure that the worktree path is correctly updated in the `.git/modules/exercise/config` file, and remove any old references or files. Update the path as follows:
     ```ini
     worktree = ../../exercise
     ```
---

### **Why These Steps Are Necessary?**
1. Moving the submodule folder (`mv`) only changes the directory structure.  
2. Updating `.gitmodules` informs Git about the new location of the submodule.  
3. Running `git submodule sync` ensures that Git uses the updated path.  
4. Removing the old section from `.git/config` prevents conflicts or misalignment.  

---

### **Final State**
After following these steps, your submodule will be moved successfully to the new location, and Git will recognize the updated path.

---
---

#### To generate a GitHub Personal Access Token for Argo CD:

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

```bash
$ git checkout -b feature/increase-replicas
Switched to a new branch 'feature/increase-replicas'

$ vim manifests/nginx-deployment.yaml

$ git add manifests/nginx-deployment.yaml
warning: in the working copy of 'manifests/nginx-deployment.yaml', LF will be replaced by CRLF the next time Git touches it

$ git commit -m "Increases the replica count"
[feature/increase-replicas 3fe6999] Increases the replica count
 1 file changed, 1 insertion(+), 1 deletion(-)

$ git push origin feature/increase-replicas
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

$ argocd app sync nginx
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

$ k get pods
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-5f89844fc9-7c54p   1/1     Running   0          20m
nginx-deployment-5f89844fc9-98685   1/1     Running   0          2m14s
nginx-deployment-5f89844fc9-nmjwv   1/1     Running   0          20m
nginx-deployment-5f89844fc9-px6fb   1/1     Running   0          2m14s
nginx-deployment-5f89844fc9-rtmx7   1/1     Running   0          2m14s
nginx-deployment-5f89844fc9-zhrjz   1/1     Running   0          20m

$ k get rs
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-5f89844fc9   6         6         6       20m

$ git branch
* feature/increase-replicas
  main

$ git checkout  main
M       README.md
Switched to branch 'main'
Your branch is up to date with 'origin/main'.

$ git merge feature/increase-replicas
Merge made by the 'ort' strategy.
 manifests/nginx-deployment.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```