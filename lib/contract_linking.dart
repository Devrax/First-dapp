import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:dart_web3/dart_web3.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
    final String _rpcUrl = "http://192.168.1.26:7545";
    final String _wsUrl = "ws://192.168.1.26:7545";
    final String _privateKey = "427786dda73dad3849636cf31fcaca5083a69a23428f4146a86e6f00544497cb";

    late Web3Client _client;
    bool isLoading = true;

    late String _abiCode;
    late EthereumAddress _contractAddress;

    late Credentials _credentials;

    late DeployedContract _contract;
    late ContractFunction _yourName;
    late ContractFunction _setName;

    String? deployedName;

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

    Future<void> getName() async {
        var currentName = await _client.call(contract: _contract, function: _yourName, params: []);
        deployedName = currentName[0];
        isLoading = false;
        notifyListeners();
    }

    Future<void> setName(String nameToSet) async {
        isLoading = true;
        notifyListeners();
        await _client.sendTransaction(
            _credentials,
            Transaction.callContract(contract: _contract, function: _setName, parameters: [nameToSet])
        );
        getName();
    }

}