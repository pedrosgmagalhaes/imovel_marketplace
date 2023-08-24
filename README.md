# Imovel Marketplace

Um contrato inteligente Ethereum para listar, comprar e alugar imóveis.

## Sobre

O `ImovelMarketplace` é um contrato inteligente desenvolvido em Solidity para o Ethereum que permite que os usuários listem imóveis para venda ou aluguel, comprem imóveis ou aluguem por um determinado número de dias.

## Características

- Listar um imóvel com preço de venda e aluguel por dia.
- Comprar um imóvel listado.
- Alugar um imóvel por um número específico de dias.
- Alterar o preço de um imóvel.
- Retirar um imóvel da venda.

## Funções Principais

### listarImovel(uint256 preco, uint256 aluguelPorDia)

Permite ao usuário listar um imóvel com um preço de venda e aluguel por dia.

### comprarImovel(uint256 id)

Permite a um usuário comprar um imóvel, transferindo a propriedade para ele.

### alugarImovel(uint256 id, uint256 dias)

Permite a um usuário alugar um imóvel por um número específico de dias.

### alterarPreco(uint256 id, uint256 novoPreco)

Permite ao proprietário de um imóvel alterar seu preço de venda.

### retirarDaVenda(uint256 id)

Permite ao proprietário de um imóvel retirá-lo da venda.

## Como Começar

1. Clone este repositório.
2. Instale as dependências com `npm install`.
3. Configure seu `secrets.json` com sua chave privada e Infura Project ID.
4. Compile os contratos com `npx hardhat compile`.
5. Execute os testes com `npx hardhat test`.
6. Implante na rede Goerli com `npx hardhat run scripts/deploy.js --network goerli`.

## Licença

Este projeto está licenciado sob a licença MIT.
