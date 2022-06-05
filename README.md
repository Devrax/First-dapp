# first_dapp

## How to run

First install truffle `npm install -g truffle`, once installed, download and installed [ganache](https://trufflesuite.com/ganache/)(MacOS my case), run **ganache** and select the "Quickstart" button.

![lol](./assets/Ganache-home.png 'Ganache Home')

![lol](./assets/Ganache-accounts.png 'Ganache accounts')

After that, go to the folder directory **./lib/contract_linking.dart** and replace the private key and set the *_rpcUrl* and *wsUrl* with your own, and later go to the root directory to find the **truffle-config.js** and set the *host* property with same value as the *_wsUrl* and *_rpcUrl*.

Runs `truffle migrate` and later `flutter run`, just wait until compiling is done and compare with the preview below

![lol](./assets/preview.gif 'App working')
