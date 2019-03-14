# Electron Motors Salesforce Platform Demo

This is an end-to-end Lightning Platform demo based on a fictitious company called Electron Motors.

## Installation Instructions

1. Clone the repository:

```
git clone https://github.com/gabesumner/electron-motors-sfdx
cd electron-motors-sfdx
```

2. Create a scratch org and provide it with an alias:

  ```
  sfdx force:org:create -s -f config/project-scratch-def.json -a electron
  ```

3. Push the app to your scratch org:

  ```
  sfdx force:source:push
  ```

4. Assign the **electron** permission set to the default user:

  ```
  sfdx force:user:permset:assign -n electron
  ```

5. Open the scratch org:

  ```
  sfdx force:org:open
  ```

6. In **Setup**, under **Themes and Branding**, activate the **Electron Motors** theme.

7. Use the **App Launcher** and click **Demo Control Panel**.

8. Use the buttons to generate Accounts, Contacts, and Vehicles.

9. Go to **Setup** then **All Communities** click **Builder** for the **Electron Motors Website** and click **Publish**.

10. Use the **App Launcher**, click **Sales**, then navigate to **Vehicles**.

### Communities Setup

Complete these steps if you want to involve Communities in your demo.

1. Visit **Setup -> Users -> Roles** and create a new **Administrator** role.

2. Visit **Setup -> Users -> Users**, edit your account, then assign your new role to your account.

3. Visit **Setup -> Security -> Login Access Policies** and enable the **Administrators Can Log in as Any User** setting.

4. Visit the Contact who will represent your buyer and click **Enable Customer User**.

5. On the same Contact click **Login to Community as User**.

