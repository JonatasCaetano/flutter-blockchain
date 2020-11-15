import 'package:crypto/crypto.dart';
import 'dart:convert';

class Blockchain {
  List<Map<String, dynamic>> chain = List();

//Primeiro bloco
  Blockchain(int proofs, int previous_hash) {
    this.create_block(proofs, previous_hash);
  }

//Criar novos blocos
  Map<String, dynamic> create_block(proofs, previous_hash) {
    Map<String, dynamic> block = {
      'index': (this.chain.length + 1),
      'timestamp': DateTime.now().toString(),
      'proof': proofs,
      'previous_hash': previous_hash.toString()
    };
    print('------------------------------');
    print('Bloco criado com sucesso');

    this.chain.add(block);

    return block;
  }

//Retornar o penultimo bloco
  Map<String, dynamic> get_previous_block() {
    int penultimoIndex = this.chain.length - 1;
    return this.chain[penultimoIndex];
  }

//Minerar novo bloco
  int proof_of_work(previous_proof) {
    int new_proof = 1;
    bool check_proof = false;

    while (check_proof == false) {
      String tentativa =
          ((new_proof * new_proof) - (previous_proof * previous_proof))
              .toString();
      var bytes = utf8.encode(tentativa);
      var hash_operation = sha256.convert(bytes).toString();

      if (hash_operation.startsWith('0000')) {
        check_proof = true;
        print('Hash final: ' + hash_operation);
      } else {
        print('------------------------------------');
        print(new_proof.toString());
        print(hash_operation);
        new_proof += 1;
      }
    }

    return new_proof;
  }

  String hash(Map<String, dynamic> bloco) {
    String hash = bloco.toString();
    var bytes = utf8.encode(hash);
    var hash_operation = sha256.convert(bytes).toString();
    return hash_operation;
  }

  bool is_chain_valid(List<Map<String, dynamic>> chain) {
    var previous_block = chain[0];
    var block_index = 1;
    while (block_index < chain.length) {
      var block = chain[block_index];
      var previous_hash = this.hash(previous_block);
      if (block['previous_hash'] != previous_hash) {
        return false;
      } else {
        var previous_proof = previous_block['proof'];
        var proof = block['proof'];
        String tentativa =
            ((proof * proof) - (previous_proof * previous_proof)).toString();
        var bytes = utf8.encode(tentativa);
        var hash_operation = sha256.convert(bytes).toString();
        if (!hash_operation.startsWith('0000')) {
          return false;
        }
      }
      previous_block = block;
      block_index += 1;
    }
    return true;
  }
}
