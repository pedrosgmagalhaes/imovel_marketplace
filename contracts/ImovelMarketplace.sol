// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ImovelMarketplace {
    struct Imovel {
        address payable owner;  // Modifique aqui
        uint256 preco;
        bool isForSale;
        uint256 aluguelPorDia;
        uint256 alugadoAte;
    }

    mapping(uint256 => Imovel) public imoveis;
    uint256 public nextImovelId = 0;

    event ImovelListado(uint256 id, uint256 preco);
    event ImovelComprado(uint256 id, address novoOwner);
    event ImovelAlugado(uint256 id, address locatario, uint256 duracao);

    function listarImovel(uint256 preco, uint256 aluguelPorDia) public {
        imoveis[nextImovelId] = Imovel({
            owner: payable(msg.sender),  // E aqui
            preco: preco,
            isForSale: true,
            aluguelPorDia: aluguelPorDia,
            alugadoAte: block.timestamp
        });

        emit ImovelListado(nextImovelId, preco);
        nextImovelId++;
    } 

    function comprarImovel(uint256 id) public payable {
        require(id < nextImovelId, "Imovel nao encontrado");
        require(imoveis[id].isForSale, "Imovel nao esta a venda");
        require(msg.value == imoveis[id].preco, "Valor enviado incorreto");
        
        imoveis[id].owner.transfer(msg.value);
        imoveis[id].owner = payable(msg.sender);  // E aqui
        imoveis[id].isForSale = false;

        emit ImovelComprado(id, msg.sender);
    }

    function alugarImovel(uint256 id, uint256 dias) public payable {
        require(id < nextImovelId, "Imovel nao encontrado.");
        require(block.timestamp > imoveis[id].alugadoAte, "Imovel ja esta alugado.");
        require(msg.value == dias * imoveis[id].aluguelPorDia, "Valor de aluguel incorreto.");

        imoveis[id].owner.transfer(msg.value);
        imoveis[id].alugadoAte = block.timestamp + (dias * 1 days);

        emit ImovelAlugado(id, msg.sender, dias);
    }

    function alterarPreco(uint256 id, uint256 novoPreco) public {
        require(imoveis[id].owner == msg.sender, "Somente o proprietario pode alterar o preco.");
        imoveis[id].preco = novoPreco;
        imoveis[id].isForSale = true;
    }

    function retirarDaVenda(uint256 id) public {
        require(imoveis[id].owner == msg.sender, "Somente o proprietario pode retirar da venda.");
        imoveis[id].isForSale = false;
    }
}
