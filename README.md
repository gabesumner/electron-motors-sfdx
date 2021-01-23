# Electron Motors Salesforce Platform Demo

This is an end-to-end Salesforce Platform demo based on a fictitious company called Electron Motors.

## Installation Instructions

Get your own private clone of this demo in a 30-day scratch org by [CLICKING HERE](https://hosted-scratch.herokuapp.com/launch?template=https://github.com/gabesumner/electron-motors-sfdx).

Or manually clone this demo using the instructions below.

1. Clone the repository:

```
git clone https://github.com/gabesumner/electron-motors-sfdx
cd electron-motors-sfdx
```

2. Install **shane-sfdx-plugins** (if you don't already have it)

  ```
  sfdx plugins:install shane-sfdx-plugins
  ```

3. Install **sfdx-migration-automatic** (if you don't already have it)

  ```
  sfdx plugins:install sfdx-migration-automatic
  ```


4. Run the startup script

  ```
  sh orgInit.sh
  ```