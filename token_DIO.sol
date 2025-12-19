// SPDX-License-Identifier: MIT
// Identificador da licença do contrato 
pragma solidity ^0.8.0;

// Interface padrão ERC20
// Define quais funções e eventos um token ERC20 deve ter
interface IERC20 {

    // ===== GETTERS =====

    // Retorna o total de tokens emitidos
    function totalSupply() external view returns (uint256);

    // Retorna o saldo de um endereço específico
    function balanceOf(address acount) external view returns (uint256);

    // Retorna o valor que um spender pode gastar em nome do owner
    function allowance(address owner, address spender) external view returns (uint256);

    // ===== FUNÇÕES =====

    // Transfere tokens do remetente para outro endereço
    function transfer(address recipient, uint256 amount) external returns (bool);

    // Autoriza um endereço a gastar tokens em nome do dono
    function approve(address spender, uint256 amount) external returns (bool);

    // Transfere tokens usando uma autorização prévia (approve)
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // ===== EVENTOS =====

    // Emitido sempre que ocorre uma transferência de tokens
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Emitido quando uma autorização (approve) é criada ou alterada
    event Approval(address indexed owner, address indexed spender, uint256);
}

// Implementação do token ERC20
contract DIOToken is IERC20 {

    // Nome do token
    string public constant name = "DIO TOKEN";

    // Símbolo do token
    string public constant symbol = "DIO";

    // Quantidade de casas decimais (padrão ERC20)
    uint256 public constant decimals = 18;

    // Mapeia endereço => saldo de tokens
    mapping(address => uint256) balances;

    // Mapeia owner => (spender => quantidade autorizada)
    mapping(address => mapping(address => uint256)) allowed;

    // Total de tokens emitidos (10 tokens com 18 casas decimais)
    uint256 totalSupply_ = 10 ether;

    // Construtor do contrato
    // Executado apenas uma vez, no deploy
    constructor () {
        // Atribui todo o supply inicial ao criador do contrato
        balances[msg.sender] = totalSupply_;
    }

    // Retorna o total de tokens
    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    // Retorna o saldo de um endereço
    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    // Transfere tokens do remetente para outro endereço
    function transfer(address receiver, uint256 numTokens) public override returns (bool) {

        // Garante que o remetente tem saldo suficiente
        require(numTokens <= balances[msg.sender], "Saldo insuficiente");

        // Diminui o saldo do remetente
        balances[msg.sender] = balances[msg.sender] - numTokens;

        // Aumenta o saldo do destinatário
        balances[receiver] = balances[receiver] + numTokens;

        // Emite o evento de transferência
        emit Transfer(msg.sender, receiver, numTokens);

        return true;
    }

    // Autoriza um endereço a gastar tokens do remetente
    function approve(address delegate, uint256 numTokens) public override returns (bool) {

        // Define a quantidade que o delegate pode gastar
        allowed[msg.sender][delegate] = numTokens;

        // Emite o evento de aprovação
        emit Approval(msg.sender, delegate, numTokens);

        return true;
    }

    // Retorna quanto um delegate pode gastar em nome do owner
    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    // Transfere tokens usando uma autorização (approve)
    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {

        // Verifica se o owner tem saldo suficiente
        require(numTokens <= balances[owner], "Saldo insuficiente");

        // Verifica se o caller tem autorização suficiente
        require(numTokens <= allowed[owner][msg.sender], "Allowance insuficiente");

        // Reduz o saldo do owner
        balances[owner] = balances[owner] - numTokens;

        // Atualiza a allowance do spender
        allowed[owner][msg.sender] = allowed[owner][msg.sender] + numTokens;

        // Aumenta o saldo do comprador
        balances[buyer] = balances[buyer] + numTokens;

        // Emite evento de transferência
        emit Transfer(owner, buyer, numTokens);

        return true;
    }
}
