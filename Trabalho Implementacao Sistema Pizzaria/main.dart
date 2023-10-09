import 'dart:io';


void main() {
  var pizzas = <Pizza>[]; // Lista para armazenar as pizzas cadastradas
  var pedido = <Pedido>[]; // Lista para armazenar as pizzas do pedido
  carregarDados(pizzas, pedido);
  while (true) {
    print("Menu:");
    print("1) Cadastrar pizza");
    print("2) Listar pizzas cadastradas");
    print("3) Editar pizza");
    print("4) Remover pizza");
    print("5) Fazer pedido");
    print("6) Listar");
    print("7) Sair");
    print("Escolha uma opção: ");

    var opcao = int.tryParse(stdin.readLineSync() ?? '');

    if (opcao == null) {
      print("Opção inválida. Por favor, escolha uma opção válida.");
      continue;
    }

    switch (opcao) {
      case 1:
        cadastrarPizza(pizzas);
        break;
      case 2:
        listarPizzas(pizzas);
        break;
      case 3:
        editarPizza(pizzas);
        break;
      case 4:
        removerPizza(pizzas);
        break;
      case 5:
        fazerPedido(pizzas, pedido);
        break;
      case 6:
        listarPedidos(pedido);
        break;
      case 7:
        salvarDados(pizzas, pedido); // Salva os dados ao sair do programa
        print("Saindo do programa.");
        return;
      default:
        print("Opção inválida. Por favor, escolha uma opção válida.");
    }
  }
}

class Pizza {
  int codigo;
  String sabor;
  double preco;

  Pizza(this.codigo, this.sabor, this.preco);
  
}
class Pedido {
  int codigo;
  DateTime data;
  List<Pizza> pizzas;

  Pedido(this.codigo, this.data, this.pizzas);
}

void carregarDados(List<Pizza> pizzas, List<Pedido> pedidos) {
  try {
    final file = File('dados.txt');

    if (file.existsSync()) {
      final lines = file.readAsLinesSync();

      for (var line in lines) {
        final parts = line.split(',');
        if (parts.length == 4) {
          final tipo = parts[0];
          final codigo = int.tryParse(parts[1]);
          final sabor = parts[2];
          final preco = double.tryParse(parts[3]);

          if (codigo != null && preco != null) {
            if (tipo == 'Pizza') {
              pizzas.add(Pizza(codigo, sabor, preco));
            } else if (tipo == 'Pedido') {
              final codigoPedido = codigo;
              final dataPedido = DateTime.now(); // Supondo que a data seja a data atual
              final pizzasPedido = pedidos.where((pedido) => pedido.codigo == codigo).map((pedido) => pedido.pizzas).expand((pizzas) => pizzas).toList();
              pedidos.add(Pedido(codigoPedido, dataPedido, pizzasPedido));
            }
          }
        }
      }
    }
  } catch (e) {
    print("Erro ao carregar dados: $e");
  }
}

void salvarDados(List<Pizza> pizzas, List<Pedido> pedidos) {
  try {
    final file = File('dados.txt');
    file.writeAsStringSync('');

    for (var pizza in pizzas) {
      file.writeAsStringSync('Pizza,${pizza.codigo},${pizza.sabor},${pizza.preco}\n', mode: FileMode.append);
    }

    for (var pedido in pedidos) {
      for (var pizza in pedido.pizzas) {
        file.writeAsStringSync('Pedido,${pedido.codigo},${pedido.data},${pizza.sabor},${pizza.preco}\n', mode: FileMode.append);
      }
    }
  } catch (e) {
    print("Erro ao salvar dados: $e");
  }
}
void listarPedidos(List<Pedido> pedidos) {
  if (pedidos.isEmpty) {
    print("Nenhum pedido realizado.");
    return;
  }

  for (var pedido in pedidos) {
    print("Código do Pedido: ${pedido.codigo}");
    print("Data do Pedido: ${pedido.data}");
    print("Pizzas:");

    for (var pizza in pedido.pizzas) {
      print(" - Sabor: ${pizza.sabor}, Preço: ${pizza.preco}");
    }

    var valorTotal = pedido.pizzas.map((pizza) => pizza.preco).reduce((a, b) => a + b);

    print("Valor Total do Pedido: $valorTotal");
    print("---------");
  }
}
void cadastrarPizza(List<Pizza> pizzas) {
  print("Digite o código da pizza: ");
  var codigo = int.tryParse(stdin.readLineSync() ?? '');

  print("Digite o sabor da pizza: ");
  var sabor = stdin.readLineSync() ?? '';

  print("Digite o preço da pizza: ");
  var preco = double.tryParse(stdin.readLineSync() ?? '');

  if (codigo != null && sabor.isNotEmpty && preco != null) {
    var novaPizza = Pizza(codigo, sabor, preco);
    pizzas.add(novaPizza);
    print("Pizza cadastrada com sucesso!");
  } else {
    print("Dados inválidos. A pizza não foi cadastrada.");
  }
}

void listarPizzas(List<Pizza> pizzas) {
  if (pizzas.isEmpty) {
    print("Nenhuma pizza cadastrada.");
  } else {
    print("Pizzas cadastradas:");
    for (var pizza in pizzas) {
      print("Código: ${pizza.codigo}, Sabor: ${pizza.sabor}, Preço: ${pizza.preco}");
    }
  }
}

void editarPizza(List<Pizza> pizzas) {
  if (pizzas.isEmpty) {
    print("Nenhuma pizza cadastrada para editar.");
    return;
  }

  print("Digite o código da pizza que deseja editar: ");
  var codigoEditar = int.tryParse(stdin.readLineSync() ?? '');

  var pizzaParaEditarIndex = pizzas.indexWhere((pizza) => pizza.codigo == codigoEditar);

  if (pizzaParaEditarIndex == -1) {
    print("Pizza não encontrada.");
    return;
  }

  var pizzaParaEditar = pizzas[pizzaParaEditarIndex];
  
  print("Pizza encontrada: Código: ${pizzaParaEditar.codigo}, Sabor: ${pizzaParaEditar.sabor}, Preço: ${pizzaParaEditar.preco}");
  print("O que deseja editar?");
  print("1) Nome");
  print("2) Preço");
  print("3) Cancelar");
  print("Escolha uma opção: ");

  var opcaoEditar = int.tryParse(stdin.readLineSync() ?? '');

  switch (opcaoEditar) {
    case 1:
      print("Digite o novo nome da pizza: ");
      var novoNome = stdin.readLineSync() ?? '';
      pizzaParaEditar.sabor = novoNome;
      print("Nome da pizza atualizado com sucesso!");
      break;
    case 2:
      print("Digite o novo preço da pizza: ");
      var novoPreco = double.tryParse(stdin.readLineSync() ?? '');
      pizzaParaEditar.preco = novoPreco!;
      print("Preço da pizza atualizado com sucesso!");
      break;
    case 3:
      print("Edição cancelada.");
      break;
    default:
      print("Opção inválida. Nenhuma edição realizada.");
  }
}


void removerPizza(List<Pizza> pizzas) {
  if (pizzas.isEmpty) {
    print("Nenhuma pizza cadastrada para remover.");
    return;
  }

  print("Pizzas cadastradas:");
  for (var i = 0; i < pizzas.length; i++) {
    print("Código: ${pizzas[i].codigo}, Sabor: ${pizzas[i].sabor}, Preço: ${pizzas[i].preco}");
  }

  print("Digite o código da pizza que deseja remover: ");
  var codigoRemover = int.tryParse(stdin.readLineSync() ?? '');

  var pizzaParaRemoverIndex = pizzas.indexWhere((pizza) => pizza.codigo == codigoRemover);

  if (pizzaParaRemoverIndex == -1) {
    print("Pizza não encontrada.");
    return;
  }

  var pizzaRemovida = pizzas.removeAt(pizzaParaRemoverIndex);
  print("Pizza removida com sucesso: Código: ${pizzaRemovida.codigo}, Sabor: ${pizzaRemovida.sabor}, Preço: ${pizzaRemovida.preco}");
}


void fazerPedido(List<Pizza> pizzas, List<Pedido> pedidos) {
  if (pizzas.isEmpty) {
    print("Nenhuma pizza cadastrada para fazer o pedido.");
    return;
  }

  print("Pizzas cadastradas:");
  for (var pizza in pizzas) {
    print("Código: ${pizza.codigo}, Sabor: ${pizza.sabor}, Preço: ${pizza.preco}");
  }

  var valorTotal = 0.0;
  var pizzasEscolhidas = <Pizza>[]; // Lista para armazenar as pizzas escolhidas para este pedido

  while (true) {
    print("Digite o código da pizza que deseja incluir no pedido (0 para encerrar): ");
    var codigoPedido = int.tryParse(stdin.readLineSync() ?? '');

    if (codigoPedido == null) {
      print("Código inválido. Por favor, digite um código válido.");
      continue;
    }

    if (codigoPedido == 0) {
      break; // Encerra o pedido quando o código for 0
    }

    var pizzaIndex = pizzas.indexWhere((pizza) => pizza.codigo == codigoPedido);

    if (pizzaIndex == -1) {
      print("Pizza não encontrada. Por favor, digite um código válido.");
      continue;
    }

    var pizzaEscolhida = pizzas[pizzaIndex];
    pizzasEscolhidas.add(pizzaEscolhida); // Adiciona a pizza à lista de pizzas escolhidas para este pedido
    valorTotal += pizzaEscolhida.preco;
  }

  if (pizzasEscolhidas.isEmpty) {
    print("Nenhum pedido realizado.");
  } else {
    // Gere um código único para o pedido (pode ser um valor simplesmente incrementado)
    var codigoPedido = pedidos.length + 1;
    var dataPedido = DateTime.now(); // Data atual

    // Crie o objeto Pedido com as pizzas escolhidas e adicione-o à lista de pedidos
    var pedido = Pedido(codigoPedido, dataPedido, pizzasEscolhidas);
    pedidos.add(pedido);

    // Imprima os detalhes do pedido
    print("Pedido $codigoPedido realizado em $dataPedido:");
    for (var pizza in pizzasEscolhidas) {
      print("Pizza: ${pizza.sabor}, Preço: ${pizza.preco}");
    }
    print("Valor total do pedido: $valorTotal");
  }
}

