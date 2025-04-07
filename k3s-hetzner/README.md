To generate API tokens for Hetzner services, follow the steps corresponding to the specific service you intend to use:

**1. Hetzner Cloud API:**

The Hetzner Cloud API allows you to manage cloud resources such as servers, volumes, and load balancers. To create an API token:

1. **Access Your Project:**
   - Log in to the [Hetzner Cloud Console](https://console.hetzner.cloud/).
   - Select the project for which you want to generate the API token.

2. **Navigate to Security Settings:**
   - In the left-hand menu, click on **'Security'**.

3. **Generate API Token:**
   - In the top menu, select the **'API Tokens'** tab.
   - Click on **'Generate API Token'**.
   - Provide a description for the token to identify its purpose.
   - Choose the desired permission level:
     - **Read**: Allows only GET requests.
     - **Read & Write**: Allows GET, POST, PUT, and DELETE requests.
   - Click **'Generate'**.

4. **Copy and Store the Token:**
   - The newly generated token will be displayed. **Ensure you copy and securely store it**, as it won't be shown again.

*Note:* Each API token is project-specific and cannot be used across multiple projects. citeturn0search0

**2. Install hetzner-k3:**

wget https://github.com/vitobotta/hetzner-k3s/releases/download/v2.2.7/hetzner-k3s-linux-amd64
chmod +x hetzner-k3s-linux-amd64
sudo mv hetzner-k3s-linux-amd64 /usr/local/bin/hetzner-k3s

**3. Run: **

HCLOUD_TOKEN=mySecretToken hetzner-k3s create --config ./cluster-config.yaml

**4. Delete: **

hetzner-k3s delete --config cluster-config.yaml