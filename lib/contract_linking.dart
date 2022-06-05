import 'package:flutter/material.dart';

class ContractLinking extends ChangeNotifier {
    final String _rpcUrl = "http://10.2.2.0:7545";
    final String _wsUrl = "ws://127.2.2.0:7545";
    final String _privateKey = "ad78250aeccf3310fcacc2eca673918b8d722587701ebbe1712bfc0c16f9b580";

    Web3Client _client;
    bool isLoading = true;

    String _abiCode;
    EthereumAddress _contractAddress;

    Credentials _credentials;

    DeployedContract _contract;
    ContractFunction _yourName;
    ContractFunction _setName;

    String deployedName;

    ContractLinking() {
        initialSetup();
    }

    initialSetup() async {
        _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
            return IOWebSocketChannel.connect(_wsUrl).cast<String>();
        });

        await getAbi();
        await getCredentials();
        await getDeployedContract();
    }

    Future<void> getAbi() async {
        String abiStringFile = await rootBundle.loadString("src/artifacts/HelloWorld.json");
        var jsonAbi = jsonDecode(abiStringFile);
        _abiCode = jsonEncode(jsonAbi["abi"]);

        _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
    }

    Future<void> getCredentials() async {
        _credentials = await _client.credentialsFromPrivateKey(_privateKey);
    }

    Future<void> getDeployedContract() async {
        _contract = DeployedContract(ContractAbi.fromJson(_abiCode, "HelloWorld"), _contractAddress);
        _yourName = _contract.function("yourName");
        _setName = _contract.function("setName");
        getName();
    }

    getName() async {
        var currentName = await _client.call(contratc: _contract, function: _yourName, params: []);
        deployedName = currentName.toString();
        isLoading = false;
        notifyListeners();
    }

    setName(String nameToSet) async {
        isLoading = true;
        notifyListeners();
        await _client.sendTransaction(
            _credentials,
            Transaction.callContract(contract: _contract, function: _setName, parameters: [nameToSet])
        );
        getName();
    }

}