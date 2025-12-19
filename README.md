# DIO Token (ERC20)

Este repositório contém a implementação de um **token ERC20 simples em Solidity**, desenvolvido com fins **educacionais**, demonstrando os principais conceitos do padrão ERC20.

O contrato implementa manualmente a interface ERC20, sem uso de bibliotecas externas como OpenZeppelin, facilitando o entendimento do funcionamento interno de um token.

---

# Características do Token

.Nome: DIO TOKEN 
.Símbolo: DIO 
.Decimais: 18 
.Supply Inicial: 10 DIO 
.Padrão: ERC20 
.Solidity: ^0.8.0 

 > O supply inicial é definido como `10 ether`, o que equivale a **10 tokens considerando 18 casas decimais**.

---

# Estrutura do Contrato

O contrato é dividido em duas partes principais:

# Interface `IERC20`

Define as funções e eventos obrigatórios do padrão ERC20:

- `totalSupply()`
- `balanceOf()`
- `transfer()`
- `approve()`
- `allowance()`
- `transferFrom()`

Eventos:
- `Transfer`
- `Approval`

---

# Contrato `DIOToken`

Implementa a interface `IERC20`, contendo:

- Controle de saldos
- Sistema de permissões (allowance)
- Emissão do supply inicial
- Funções de transferência e aprovação

---

# Funcionamento do Contrato

# Deploy
Ao fazer o deploy do contrato:
- Todo o supply inicial é atribuído ao endereço que realizou o deploy (`msg.sender`).

# Transferência de Tokens
```solidity
transfer(address receiver, uint256 amount)

