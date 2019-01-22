# Electron Motors Salesforce Platform Demo

This is an end-to-end Lightning Platform demo based on a fictitious company called Electron Motors.

## Installation Instructions

1. Clone the repository:

```
git clone https://github.com/gabesumner/electron-motors-sfdx
cd electron-motors-sfdx
```

2. Create a scratch org and provide it with an alias (ebikes):

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