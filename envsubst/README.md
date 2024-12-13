### Step-by-Step Plan for Migration with Adjustments

---

### **Step 1: Prepare the New Project Files**
1. **Identify Files to Be Migrated**:
   - The new project contains:
     - `envsubst-plugin` directory with files (`Dockerfile`, `application.yaml`, `plugin.yaml`, `values.yaml`).
     - `kustomize` directory with:
       - `base` files (`deployment.yaml`, `kustomization.yaml`, `service.yaml`).
       - `overlays` for `development` and `production`.

2. **Understand Integration Points**:
   - You want to integrate the new project into `exercise/kustomize/base` as a new folder while maintaining overlays for `dev` and `prod`.

---

### **Step 2: Copy the Base Files**
1. **Create a New Directory for the Plugin**:
   - In the `exercise/kustomize/base` directory, create a folder named `envsubst`.
   - Example:
     ```bash
     mkdir -p exercise/kustomize/base/envsubst
     ```

2. **Copy the Base Files**:
   - Copy the following files into `exercise/kustomize/base/envsubst`:
     - `deployment.yaml`
     - `service.yaml`
     - `kustomization.yaml`
   - Command:
     ```bash
     cp ~/temp/argocd-plugins-app/kustomize/base/* exercise/kustomize/base/envsubst/
     ```

---

### **Step 3: Integrate Overlays**
1. **Update `exercise/kustomize/overlays`**:
   - Create new directories for the `envsubst` under both `dev` and `prod` overlays.
   - Commands:
     ```bash
     mkdir -p exercise/kustomize/overlays/dev/envsubst
     mkdir -p exercise/kustomize/overlays/prod/envsubst
     ```

2. **Copy Overlay Files**:
   - For `development`:
     - Copy `deployment-patch.yaml`, `env-vars.env`, and `kustomization.yaml` into `exercise/kustomize/overlays/dev/envsubst`.
     ```bash
     cp ~/temp/argocd-plugins-app/kustomize/overlays/development/* exercise/kustomize/overlays/dev/envsubst/
     ```
   - For `production`:
     - Copy `env-vars.env` and `kustomize.yaml` into `exercise/kustomize/overlays/prod/envsubst`.
     ```bash
     cp ~/temp/argocd-plugins-app/kustomize/overlays/production/* exercise/kustomize/overlays/prod/envsubst/
     ```

---

### **Step 4: Update Parent Overlays**
1. **Update `dev` Overlay `kustomization.yaml`**:
   - Add a reference to the new plugin:
     ```yaml
     resources:
        - ../../base/nginx
        - ../../base/caddy
        - ../../base/envsubst
        - ./envsubst
     ```
   - File: `exercise/kustomize/overlays/dev/kustomization.yaml`.

2. **Update `prod` Overlay `kustomization.yaml`**:
   - Add a similar reference:
     ```yaml
     resources:
        - ../../base/nginx
        - ../../base/caddy
        - ../../base/envsubst
        - ./envsubst
     ```
   - File: `exercise/kustomize/overlays/prod/kustomization.yaml`.

---

### **Step 5: Integrate `envsubst-plugin`**
1. **Place the `envsubst-plugin` Directory**:
   - Move the `envsubst-plugin` directory from the temporary project (`argocd-plugins-app`) into a logical place within your project structure. For example:
     ```bash
     mv ~/temp/argocd-plugins-app/envsubst-plugin exercise/envsubst
     ```

2. **Retain All Plugin Files**:
   - Keep the `Dockerfile`, `plugin.yaml`, `values.yaml`, and `application.yaml` inside `exercise/envsubst-plugin`.

3. **Purpose of These Files**:
   - These files define and configure the plugin. They are necessary for setting up the Argo CD plugin functionality.
   - Example:
     - `Dockerfile`: To build the plugin image.
     - `plugin.yaml`: Defines plugin behavior.
     - `application.yaml`: Contains specific application-level configuration for the plugin.

---

### **Step 6: Set Up the Argo CD Application YAML**
1. **Create the Argo CD YAML File**:
   - Place it in `exercise/argo-cd` with the name `envsubst.yaml` (or another descriptive name).
   - Example `envsubst.yaml` file:
     ```yaml
     apiVersion: argoproj.io/v1alpha1
     kind: Application
     metadata:
       name: envsubst
       namespace: argo-cd
     spec:
       destination:
         server: https://kubernetes.default.svc
         namespace: argo-cd
       source:
         repoURL: 'https://github.com/marwiesing/GitOps_Argo_CD.git'
         path: kustomize/overlays/dev # Change to prod for production
         targetRevision: main
       project: default
       syncPolicy:
         automated: 
           selfHeal: true
           prune: true
     ```

2. **Update the `path` Field**:
   - Use `kustomize/overlays/dev` for development deployments.
   - Use `kustomize/overlays/prod` for production deployments.

3. **Add the File to Git**:
   - Stage and commit the new Argo CD YAML file to your repository:
     ```bash
     git add exercise/argo-cd/envsubst.yaml
     git commit -m "Add Argo CD configuration for envsubst plugin"
     git push
     ```

---

### **Step 7: Validate the Configuration**
1. **Validate the Overlays**:
   - Test the `dev` overlay:
     ```bash
     kustomize build exercise/kustomize/overlays/dev
     ```
   - Test the `prod` overlay:
     ```bash
     kustomize build exercise/kustomize/overlays/prod
     ```

2. **Deploy Using Argo CD**:
   - Apply the `envsubst.yaml` Argo CD application:
     ```bash
     kubectl apply -f exercise/argo-cd/envsubst.yaml
     ```

3. **Check Deployment**:
   - Verify the deployment in Argo CD UI.
   - Ensure the manifests are correctly generated with the `envsubst` variables.

---

### **Step 8: Update Documentation**
1. **Document Changes**:
   - Add instructions in `exercise/README.md` explaining the integration of `envsubst`:
     - Purpose.
     - Directory structure.
     - Deployment commands.

2. **Example Deployment Workflow**:
   - Include commands for switching environments (e.g., dev to prod).

---

### **Final Notes**
Both **Step 5** and **Step 6** are required. The plugin files from Step 5 must remain in place because they are crucial for defining the plugin functionality. Step 6 integrates the plugin with Argo CD for deployment.

---

This plan ensures all required files are in place, and your project remains cleanly organized and fully operational.



### **4. Reapply Changes**
1. Validate the Helm chart:
   ```bash
   helm upgrade argo-cd argo/argo-cd -n argo-cd -f envsubst/values.yaml --dry-run
   ```

2. If the dry-run succeeds, apply the upgrade:
   ```bash
   helm upgrade argo-cd argo/argo-cd -n argo-cd -f envsubst/values.yaml
   ```

---

### **2. Immediate Recovery Steps**

#### Roll Back to a Previous Working State
To restore the system, rollback to the last working Helm release:
```bash
helm rollback argo-cd 0 -n argo-cd
```
### **Final Recovery**
Rollback the release to stabilize your environment if necessary:
```bash
helm rollback argo-cd 0 -n argo-cd
```