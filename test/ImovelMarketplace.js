const { expect } = require("chai");

describe("ImovelMarketplace", function() {
    let imovelMarketplace;
    let owner;
    let buyer;
    let renter;

    beforeEach(async function() {
        const ImovelMarketplace = await ethers.getContractFactory("ImovelMarketplace");
        [owner, buyer, renter] = await ethers.getSigners();
        imovelMarketplace = await ImovelMarketplace.deploy();
    });

    describe("Listagem de imoveis", function() {
        it("Deve permitir listar um imovel", async function() {
            await imovelMarketplace.listarImovel(1000, 10);
            const imovel = await imovelMarketplace.imoveis(0);
            expect(imovel.owner).to.equal(owner.address);
            expect(imovel.preco).to.equal(1000);
            expect(imovel.isForSale).to.be.true;
        });
    });

    describe("Compra de imoveis", function() {
        beforeEach(async function() {
            await imovelMarketplace.listarImovel(1000, 10);
        });

        it("Deve permitir comprar um imovel", async function() {
            await buyer.sendTransaction({ to: imovelMarketplace.address, value: 1000 });
            await imovelMarketplace.connect(buyer).comprarImovel(0);
            const imovel = await imovelMarketplace.imoveis(0);
            expect(imovel.owner).to.equal(buyer.address);
            expect(imovel.isForSale).to.be.false;
        });

        it("Nao deve permitir comprar um imovel nao listado", async function() {
            await expect(imovelMarketplace.connect(buyer).comprarImovel(1)).to.be.revertedWith("Imovel nao encontrado");
        });
    });

    describe("Aluguel de imoveis", function() {
        beforeEach(async function() {
            await imovelMarketplace.listarImovel(1000, 10);
        });

        it("Deve permitir alugar um imovel", async function() {
            await renter.sendTransaction({ to: imovelMarketplace.address, value: 10 });
            await imovelMarketplace.connect(renter).alugarImovel(0, 1);
            const imovel = await imovelMarketplace.imoveis(0);
            expect(imovel.alugadoAte).to.be.above(await ethers.provider.getBlockNumber());
        });
    });

    describe("Alterar preco", function() {
        beforeEach(async function() {
            await imovelMarketplace.listarImovel(1000, 10);
        });

        it("Deve permitir que o proprietario altere o preco", async function() {
            await imovelMarketplace.alterarPreco(0, 1500);
            const imovel = await imovelMarketplace.imoveis(0);
            expect(imovel.preco).to.equal(1500);
        });

        it("Nao deve permitir que nao proprietarios alterem o preco", async function() {
            await expect(imovelMarketplace.connect(buyer).alterarPreco(0, 1500)).to.be.revertedWith("Somente o proprietario pode alterar o preco.");
        });
    });

    describe("Retirar da venda", function() {
        beforeEach(async function() {
            await imovelMarketplace.listarImovel(1000, 10);
        });

        it("Deve permitir que o proprietario retire da venda", async function() {
            await imovelMarketplace.retirarDaVenda(0);
            const imovel = await imovelMarketplace.imoveis(0);
            expect(imovel.isForSale).to.be.false;
        });

        it("Nao deve permitir que nao proprietarios retirem da venda", async function() {
            await expect(imovelMarketplace.connect(buyer).retirarDaVenda(0)).to.be.revertedWith("Somente o proprietario pode retirar da venda.");
        });
    });
});
