USE mydb;

-- 1. Trigger para validar o CPF do usuário antes de inserir
DELIMITER //
CREATE TRIGGER trg_valida_cpf_usuario_insert
BEFORE INSERT ON Usuario
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.cpf) != 11 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O CPF deve ter 11 dígitos.';
    END IF;
END;
//
DELIMITER ;

-- 2. Trigger para validar o CNPJ do fornecedor antes de inserir
DELIMITER //
CREATE TRIGGER trg_valida_cnpj_fornecedor_insert
BEFORE INSERT ON Fornecedor
FOR EACH ROW
BEGIN
    IF LENGTH(REPLACE(REPLACE(REPLACE(NEW.cnpj, '.', ''), '-', ''), '/', '')) != 14 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O CNPJ deve ter 14 dígitos.';
    END IF;
END;
//
DELIMITER ;

-- 3. Trigger para impedir a exclusão de um armazém com lotes associados
DELIMITER //
CREATE TRIGGER trg_impede_delete_armazem_com_lotes
BEFORE DELETE ON Armazem
FOR EACH ROW
BEGIN
    DECLARE num_lotes INT;
    SELECT COUNT(*) INTO num_lotes FROM Lote WHERE fk_armazem = OLD.idArmazem;
    IF num_lotes > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível excluir um armazém que possui lotes associados.';
    END IF;
END;
//
DELIMITER ;

-- 4. Trigger para atualizar a quantidade do lote após uma entrega
DELIMITER //
CREATE TRIGGER trg_atualiza_quantidade_lote_apos_entrega
AFTER INSERT ON Entregas
FOR EACH ROW
BEGIN
    UPDATE Lote
    SET quantidade = quantidade - NEW.quantidade_entregue
    WHERE idLote = NEW.fk_lote;
END;
//
DELIMITER ;

-- 5. Trigger para impedir a inserção de uma entrega com quantidade maior que a do lote
DELIMITER //
CREATE TRIGGER trg_valida_quantidade_entrega
BEFORE INSERT ON Entregas
FOR EACH ROW
BEGIN
    DECLARE qtd_lote INT;
    SELECT quantidade INTO qtd_lote FROM Lote WHERE idLote = NEW.fk_lote;
    IF NEW.quantidade_entregue > qtd_lote THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A quantidade a ser entregue não pode ser maior que a quantidade em estoque no lote.';
    END IF;
END;
//
DELIMITER ;

-- 6. Trigger para impedir a associação de um motorista a mais de um veículo ativo
DELIMITER //
CREATE TRIGGER trg_valida_associacao_veiculo_motorista
BEFORE INSERT ON Veiculo_Motorista
FOR EACH ROW
BEGIN
    DECLARE num_veiculos INT;
    SELECT COUNT(*) INTO num_veiculos FROM Veiculo_Motorista WHERE fk_motorista = NEW.fk_motorista;
    IF num_veiculos > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Este motorista já está associado a um veículo.';
    END IF;
END;
//
DELIMITER ;

-- 7. Trigger para impedir a inserção de um lote com data de validade vencida
DELIMITER //
CREATE TRIGGER trg_valida_data_validade_lote
BEFORE INSERT ON Lote
FOR EACH ROW
BEGIN
    IF NEW.validade < NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível inserir um lote com data de validade vencida.';
    END IF;
END;
//
DELIMITER ;

-- 8. Trigger para impedir a exclusão de um motorista com rotas associadas
DELIMITER //
CREATE TRIGGER trg_impede_delete_motorista_com_rotas
BEFORE DELETE ON Motorista
FOR EACH ROW
BEGIN
    DECLARE num_rotas INT;
    SELECT COUNT(*) INTO num_rotas FROM Rota WHERE fk_motorista = OLD.idMotorista;
    IF num_rotas > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível excluir um motorista que possui rotas associadas.';
    END IF;
END;
//
DELIMITER ;

-- 9. Trigger para impedir a atualização do status de um veículo para "Manutenção" se ele estiver em uma rota ativa
DELIMITER //
CREATE TRIGGER trg_valida_status_veiculo_em_rota
BEFORE UPDATE ON Veiculo
FOR EACH ROW
BEGIN
    DECLARE em_rota INT;
    SELECT COUNT(*) INTO em_rota
    FROM Rota r
    JOIN Veiculo_Motorista vm ON r.fk_motorista = vm.fk_motorista
    WHERE vm.fk_veiculo = NEW.idVeiculo AND r.data_retorno IS NULL;

    IF NEW.status = 'Manutenção' AND em_rota > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível colocar em manutenção um veículo que está em uma rota ativa.';
    END IF;
END;
//
DELIMITER ;

-- 10. Trigger para impedir a inserção de um usuário com perfil "Gestor" que não seja da região "Agreste"
DELIMITER //
CREATE TRIGGER trg_valida_regiao_gestor
BEFORE INSERT ON Usuario
FOR EACH ROW
BEGIN
    IF NEW.perfil = 'Gestor' AND NEW.regiao_atuacao != 'Agreste' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Gestores devem atuar na região do Agreste.';
    END IF;
END;
//
DELIMITER ;

-- 11. Trigger para impedir a criação de uma rota com data de saída anterior à data atual
DELIMITER //
CREATE TRIGGER trg_valida_data_saida_rota
BEFORE INSERT ON Rota
FOR EACH ROW
BEGIN
    IF NEW.data_saida < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data de saída da rota não pode ser anterior à data atual.';
    END IF;
END;
//
DELIMITER ;

-- 12. Trigger para impedir a exclusão de um destino que esteja em uma entrega
DELIMITER //
CREATE TRIGGER trg_impede_delete_destino_em_entrega
BEFORE DELETE ON Destino
FOR EACH ROW
BEGIN
    DECLARE num_entregas INT;
    SELECT COUNT(*) INTO num_entregas FROM Entregas WHERE fk_destino = OLD.idDestino;
    IF num_entregas > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível excluir um destino que está associado a uma entrega.';
    END IF;
END;
//
DELIMITER ;
