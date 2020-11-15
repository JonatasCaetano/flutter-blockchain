import 'block_chain.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    home: BlockChainTela(),
  ));
}

class BlockChainTela extends StatefulWidget {
  @override
  _BlockChainTelaState createState() => _BlockChainTelaState();
}

class _BlockChainTelaState extends State<BlockChainTela> {
  Blockchain blockchain;
  bool validade;

  @override
  void initState() {
    super.initState();
    blockchain = Blockchain(1, 0);
    print('tamanho do chain: ' + blockchain.chain.length.toString());
    print('bloco criado: ' + blockchain.chain[0].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blockchain'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: blockchain.chain.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'index: ' +
                                    blockchain.chain[index]['index'].toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'timestamp: ' +
                                    blockchain.chain[index]['timestamp']
                                        .toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'proof: ' +
                                    blockchain.chain[index]['proof'].toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'previous_hash: ' +
                                    blockchain.chain[index]['previous_hash']
                                        .toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    })),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  //minera novo bloco
                  IconButton(
                      icon: Icon(
                        Icons.monetization_on,
                        size: 50,
                      ),
                      onPressed: () {
                        setState(() {
                          Map<String, dynamic> previous_block =
                              blockchain.get_previous_block();
                          int previous_proof = previous_block['proof'];
                          int proof = blockchain.proof_of_work(previous_proof);
                          var previous_hash = blockchain.hash(previous_block);
                          Map<String, dynamic> bloco =
                              blockchain.create_block(proof, previous_hash);
                          print(bloco.values);
                        });
                      }),

                  //valida os blocos
                  IconButton(
                      icon: Icon(
                        Icons.check_circle_outline,
                        size: 50,
                      ),
                      onPressed: () {
                        setState(() {
                          validade =
                              blockchain.is_chain_valid(blockchain.chain);
                        });
                        print('o blockchain é : ' + validade.toString());
                      }),

                  Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                    ),
                    child: Text(validade == null
                        ? " "
                        : validade == false
                            ? 'Blockchain falso'
                            : 'Blockchain Verdadeiro'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
