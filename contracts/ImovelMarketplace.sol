// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ImovelMarketplace {
    
    // Estrutura para representar um Imóvel no marketplace.
    struct Imovel {
        address payable owner;        // Proprietário do imóvel.
        uint256 preco;                // Preço do imóvel para venda.
        bool isForSale;               // Status de venda: verdadeiro se estiver à venda, falso caso contrário.
        uint256 aluguelPorDia;        // Preço do aluguel por dia.
        uint256 alugadoAte;           // Data de término do aluguel atual.
    }

    // Mapeia cada ID de imóvel para um Imovel. 
    mapping(uint256 => Imovel) public imoveis;

    // ID para o próximo imóvel a ser listado.
    uint256 public nextImovelId = 0;

    // Eventos para logar ações importantes no contrato.
    event ImovelListado(uint256 id, uint256 preco);
    event ImovelComprado(uint256 id, address novoOwner);
    event ImovelAlugado(uint256 id, address locatario, uint256 duracao);

    // Lista um novo imóvel para venda no marketplace.
    function listarImovel(uint256 preco, uint256 aluguelPorDia) public {
        imoveis[nextImovelId] = Imovel({
            owner: payable(msg.sender),
            preco: preco,
            isForSale: true,
            aluguelPorDia: aluguelPorDia,
            alugadoAte: block.timestamp
        });

        emit ImovelListado(nextImovelId, preco);
        nextImovelId++;
    } 

    // Permite a compra de um imóvel listado.
    function comprarImovel(uint256 id) public payable {
        require(id < nextImovelId, "Imovel nao encontrado");
        require(imoveis[id].isForSale, "Imovel nao esta a venda");
        require(msg.value == imoveis[id].preco, "Valor enviado incorreto");
        
        imoveis[id].owner.transfer(msg.value);
        imoveis[id].owner = payable(msg.sender);
        imoveis[id].isForSale = false;

        emit ImovelComprado(id, msg.sender);
    }

    // Permite o aluguel de um imóvel.
    function alugarImovel(uint256 id, uint256 dias) public payable {
        require(id < nextImovelId, "Imovel nao encontrado.");
        require(block.timestamp > imoveis[id].alugadoAte, "Imovel ja esta alugado.");
        require(msg.value == dias * imoveis[id].aluguelPorDia, "Valor de aluguel incorreto.");

        imoveis[id].owner.transfer(msg.value);
        imoveis[id].alugadoAte = block.timestamp + (dias * 1 days);

        emit ImovelAlugado(id, msg.sender, dias);
    }

    // Permite que o proprietário de um imóvel altere o preço de venda.
    function alterarPreco(uint256 id, uint256 novoPreco) public {
        require(imoveis[id].owner == msg.sender, "Somente o proprietario pode alterar o preco.");
        imoveis[id].preco = novoPreco;
        imoveis[id].isForSale = true;
    }

    // Permite que o proprietário retire o imóvel da venda.
    function retirarDaVenda(uint256 id) public {
        require(imoveis[id].owner == msg.sender, "Somente o proprietario pode retirar da venda.");
        imoveis[id].isForSale = false;
    }

    // Função para receber pagamentos no contrato.
    receive() external payable {}

}
