-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8;
USE `mydb`;

CREATE TABLE IF NOT EXISTS `Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `cnpj` VARCHAR(18) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idFornecedor`),
  UNIQUE INDEX `cnpj_UNIQUE` (`cnpj` ASC)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Usuario` (
  `cpf` VARCHAR(14) NOT NULL,
  `regiao_atuacao` VARCHAR(45) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `nome` VARCHAR(100) NOT NULL,
  `perfil` ENUM("Gestor", "Técnico", "Agricultor") NOT NULL,
  `senha` VARCHAR(8) NOT NULL,
  PRIMARY KEY (`cpf`),
  UNIQUE INDEX `cpf_UNIQUE` (`cpf` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `senha_UNIQUE` (`senha` ASC)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Relatorio` (
  `idRelatorio` INT NOT NULL AUTO_INCREMENT,
  `periodo_inicio` DATETIME NOT NULL,
  `periodo_fim` DATETIME NOT NULL,
  `total_entregas` INT NOT NULL,
  `tempo_medio` DECIMAL(5,2) NOT NULL,
  `volume_total` DECIMAL(10,2) NOT NULL,
  `custo_medio` DECIMAL(8,2) NOT NULL,
  `fk_usuario` VARCHAR(14) NULL,
  PRIMARY KEY (`idRelatorio`),
  INDEX `idx_relatorio_usuario` (`fk_usuario` ASC),
  CONSTRAINT `fk_relatorio_usuario`
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `Usuario` (`cpf`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabela Veiculo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Veiculo` (
  `idVeiculo` INT NOT NULL AUTO_INCREMENT,
  `placa` VARCHAR(7) NOT NULL,
  `modelo` VARCHAR(45) NOT NULL,
  `capacidade` INT NOT NULL,
  `status` ENUM("Ativo", "Manutenção") NOT NULL,
  PRIMARY KEY (`idVeiculo`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Endereco_Destino` (
  `idEndereco` INT NOT NULL AUTO_INCREMENT,
  `cep` VARCHAR(9) NOT NULL,
  `rua` VARCHAR(100) NOT NULL,
  `numero` INT NOT NULL,
  PRIMARY KEY (`idEndereco`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Destino` (
  `idDestino` INT NOT NULL AUTO_INCREMENT,
  `latitude` DECIMAL(10,6) NOT NULL,
  `longitude` DECIMAL(10,6) NOT NULL,
  `nome_destino` VARCHAR(100) NOT NULL,
  `tipo` ENUM("Associação", "Agricultor", "Comunidade") NOT NULL,
  `fk_endereco` INT NOT NULL,
  PRIMARY KEY (`idDestino`),
  INDEX `idx_destino_endereco` (`fk_endereco` ASC),
  CONSTRAINT `fk_destino_endereco`
    FOREIGN KEY (`fk_endereco`)
    REFERENCES `Endereco_Destino` (`idEndereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Endereco_Armazem` (
  `idEndereco` INT NOT NULL AUTO_INCREMENT,
  `cep` VARCHAR(9) NOT NULL,
  `rua` VARCHAR(100) NOT NULL,
  `numero` INT NOT NULL,
  PRIMARY KEY (`idEndereco`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Armazem` (
  `idArmazem` INT NOT NULL AUTO_INCREMENT,
  `capacidade_total` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `fk_endereco` INT NOT NULL,
  `responsavel` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`idArmazem`),
  INDEX `idx_armazem_endereco` (`fk_endereco` ASC),
  INDEX `idx_armazem_responsavel` (`responsavel` ASC),
  CONSTRAINT `fk_armazem_endereco`
    FOREIGN KEY (`fk_endereco`)
    REFERENCES `Endereco_Armazem` (`idEndereco`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_armazem_usuario`
    FOREIGN KEY (`responsavel`)
    REFERENCES `Usuario` (`cpf`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Lote` (
  `idLote` INT NOT NULL AUTO_INCREMENT,
  `quantidade` INT NOT NULL,
  `validade` DATETIME NOT NULL,
  `data_recebimento` DATE NULL,
  `numero_lote` INT NOT NULL,
  `especie` VARCHAR(45) NOT NULL,
  `status` ENUM("Em Estoque", "Em Rota", "Entregue") NOT NULL,
  `qrcode` VARCHAR(255) NOT NULL,
  `fk_fornecedor` INT NOT NULL,
  `fk_armazem` INT NOT NULL,
  PRIMARY KEY (`idLote`),
  INDEX `idx_lote_fornecedor` (`fk_fornecedor` ASC),
  INDEX `idx_lote_armazem` (`fk_armazem` ASC),
  CONSTRAINT `fk_lote_fornecedor`
    FOREIGN KEY (`fk_fornecedor`)
    REFERENCES `Fornecedor` (`idFornecedor`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_lote_armazem`
    FOREIGN KEY (`fk_armazem`)
    REFERENCES `Armazem` (`idArmazem`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Motorista` (
  `idMotorista` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `cnh` VARCHAR(9) NOT NULL,
  PRIMARY KEY (`idMotorista`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Rota` (
  `idRota` INT NOT NULL AUTO_INCREMENT,
  `data_saida` DATE NOT NULL,
  `data_retorno` DATE NULL,
  `distancia_total` DOUBLE NOT NULL,
  `tempo_estimado` DOUBLE NOT NULL,
  `custo_estimado` DECIMAL(5,2) NOT NULL,
  `fk_motorista` INT NOT NULL,
  `armazem_origem` INT NOT NULL,
  PRIMARY KEY (`idRota`),
  INDEX `idx_rota_motorista` (`fk_motorista` ASC),
  INDEX `idx_rota_armazem` (`armazem_origem` ASC),
  CONSTRAINT `fk_rota_motorista`
    FOREIGN KEY (`fk_motorista`)
    REFERENCES `Motorista` (`idMotorista`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rota_armazem`
    FOREIGN KEY (`armazem_origem`)
    REFERENCES `Armazem` (`idArmazem`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Entregas` (
  `idEntregas` INT NOT NULL AUTO_INCREMENT,
  `data_prevista` DATE NOT NULL,
  `data_entrega` DATE NULL,
  `quantidade_entregue` INT NOT NULL,
  `status` ENUM("Em rota", "Entregue", "Atraso") NOT NULL,
  `fk_lote` INT NOT NULL,
  `fk_rota` INT NOT NULL,
  `fk_destino` INT NOT NULL,
  PRIMARY KEY (`idEntregas`),
  INDEX `idx_entregas_lote` (`fk_lote` ASC),
  INDEX `idx_entregas_rota` (`fk_rota` ASC),
  INDEX `idx_entregas_destino` (`fk_destino` ASC),
  CONSTRAINT `fk_entregas_lote`
    FOREIGN KEY (`fk_lote`)
    REFERENCES `Lote` (`idLote`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_entregas_rota`
    FOREIGN KEY (`fk_rota`)
    REFERENCES `Rota` (`idRota`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_entregas_destino`
    FOREIGN KEY (`fk_destino`)
    REFERENCES `Destino` (`idDestino`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Endereco_Fornecedor` (
  `idEndereco` INT NOT NULL AUTO_INCREMENT,
  `cep` VARCHAR(9) NOT NULL,
  `rua` VARCHAR(100) NOT NULL,
  `numero` INT NOT NULL,
  `fk_fornecedor` INT NOT NULL,
  PRIMARY KEY (`idEndereco`),
  INDEX `idx_endereco_fornecedor` (`fk_fornecedor` ASC),
  CONSTRAINT `fk_endereco_fornecedor`
    FOREIGN KEY (`fk_fornecedor`)
    REFERENCES `Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Telefone_Usuario` (
  `idTelefone` INT NOT NULL AUTO_INCREMENT,
  `telefone` VARCHAR(14) NOT NULL,
  `fk_usuario` VARCHAR(14) NOT NULL,
  PRIMARY KEY (`idTelefone`),
  INDEX `idx_telefone_usuario` (`fk_usuario` ASC),
  CONSTRAINT `fk_telefone_usuario`
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `Usuario` (`cpf`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Telefone_Motorista` (
  `idTelefone` INT NOT NULL AUTO_INCREMENT,
  `telefone` VARCHAR(14) NOT NULL,
  `fk_motorista` INT NOT NULL,
  PRIMARY KEY (`idTelefone`),
  INDEX `idx_telefone_motorista` (`fk_motorista` ASC),
  CONSTRAINT `fk_telefone_motorista`
    FOREIGN KEY (`fk_motorista`)
    REFERENCES `Motorista` (`idMotorista`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Telefone_Fornecedor` (
  `idTelefone` INT NOT NULL AUTO_INCREMENT,
  `telefone` VARCHAR(14) NOT NULL,
  `fk_fornecedor` INT NOT NULL,
  PRIMARY KEY (`idTelefone`),
  INDEX `idx_telefone_fornecedor` (`fk_fornecedor` ASC),
  CONSTRAINT `fk_telefone_fornecedor`
    FOREIGN KEY (`fk_fornecedor`)
    REFERENCES `Fornecedor` (`idFornecedor`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Veiculo_Motorista` (
  `idVeiculo_Motorista` INT NOT NULL AUTO_INCREMENT,
  `fk_veiculo` INT NOT NULL,
  `fk_motorista` INT NOT NULL,
  PRIMARY KEY (`idVeiculo_Motorista`),
  INDEX `idx_vm_veiculo` (`fk_veiculo` ASC),
  INDEX `idx_vm_motorista` (`fk_motorista` ASC),
  CONSTRAINT `fk_vm_veiculo`
    FOREIGN KEY (`fk_veiculo`)
    REFERENCES `Veiculo` (`idVeiculo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_vm_motorista`
    FOREIGN KEY (`fk_motorista`)
    REFERENCES `Motorista` (`idMotorista`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

