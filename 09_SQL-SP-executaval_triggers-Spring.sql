USE mydb;

-- Teste 1 (Sucesso): Inserir um novo usuário com CPF válido.
-- A trigger trg_valida_cpf_usuario_insert permitirá a inserção.
INSERT INTO Usuario (cpf, regiao_atuacao, email, nome, perfil, senha) 
VALUES ('11122233300', 'Agreste', 'novo.gestor@sprig.com', 'Novo Gestor', 'Gestor', 'senha111');
SELECT * FROM Usuario WHERE cpf = '11122233300'; -- Verificando a inserção

-- Teste 2 (Sucesso): Inserir um novo fornecedor com CNPJ válido.
-- A trigger trg_valida_cnpj_fornecedor_insert permitirá a inserção.
INSERT INTO Fornecedor (cnpj, nome) 
VALUES ('11.222.333/0001-44', 'Novo Fornecedor Teste');
SELECT * FROM Fornecedor WHERE cnpj = '11.222.333/0001-44'; -- Verificando a inserção

-- Teste 3 (Sucesso): Excluir um armazém que não possui lotes.
-- Primeiro, criamos um armazém novo e depois o excluímos para provar que a trigger funciona.
INSERT INTO Armazem (capacidade_total, nome, fk_endereco, responsavel) VALUES (1000, 'Armazém Temporário', 1, '12345678901');
SET @id_armazem_temp = LAST_INSERT_ID();
DELETE FROM Armazem WHERE idArmazem = @id_armazem_temp; -- Esta operação será bem-sucedida.
SELECT * FROM Armazem WHERE idArmazem = @id_armazem_temp; -- Verificando (deve retornar vazio)

-- Teste 4 (Sucesso): Inserir uma entrega e verificar a atualização no lote.
-- A trigger trg_atualiza_quantidade_lote_apos_entrega será acionada.
-- Verificando a quantidade ANTES da entrega:
SELECT quantidade FROM Lote WHERE idLote = 2; -- Quantidade original: 300
-- Inserindo uma entrega válida:
INSERT INTO Entregas (data_prevista, quantidade_entregue, status, fk_lote, fk_rota, fk_destino) 
VALUES ('2025-12-01', 50, 'Em rota', 2, 2, 2);
-- Verificando a quantidade DEPOIS da entrega (deve ser 250):
SELECT quantidade FROM Lote WHERE idLote = 2;

-- Teste 5 (Sucesso): Inserir uma entrega com quantidade válida (menor que o estoque).
-- A trigger trg_valida_quantidade_entrega permitirá a operação.
INSERT INTO Entregas (data_prevista, quantidade_entregue, status, fk_lote, fk_rota, fk_destino) 
VALUES ('2025-12-02', 100, 'Em rota', 4, 4, 4);
SELECT * FROM Entregas WHERE fk_lote = 4 AND quantidade_entregue = 100; -- Verificando

-- Teste 6 (Sucesso): Associar um veículo a um motorista que está livre.
-- A trigger trg_valida_associacao_veiculo_motorista permitirá a operação.
-- Criando um novo motorista livre:
INSERT INTO Motorista (nome, cnh) VALUES ('Motorista Livre', '111222333');
SET @id_motorista_livre = LAST_INSERT_ID();
-- Associando a um veículo:
INSERT INTO Veiculo_Motorista (fk_veiculo, fk_motorista) VALUES (17, @id_motorista_livre);
SELECT * FROM Veiculo_Motorista WHERE fk_motorista = @id_motorista_livre; -- Verificando

-- Teste 7 (Sucesso): Inserir um lote com data de validade futura.
-- A trigger trg_valida_data_validade_lote permitirá a inserção.
INSERT INTO Lote (quantidade, validade, data_recebimento, numero_lote, especie, status, qrcode, fk_fornecedor, fk_armazem) 
VALUES (200, '2027-01-01 00:00:00', CURDATE(), 9998, 'Semente Futura', 'Em Estoque', 'QR-9998', 1, 1);
SELECT * FROM Lote WHERE numero_lote = 9998; -- Verificando

-- Teste 8 (Sucesso): Excluir um motorista sem rotas associadas.
-- A trigger trg_impede_delete_motorista_com_rotas permitirá a exclusão.
-- Criando um motorista temporário sem rotas:
INSERT INTO Motorista (nome, cnh) VALUES ('Motorista Temporário', '444555666');
SET @id_motorista_temp = LAST_INSERT_ID();
DELETE FROM Motorista WHERE idMotorista = @id_motorista_temp; -- Operação bem-sucedida.
SELECT * FROM Motorista WHERE idMotorista = @id_motorista_temp; -- Verificando (deve retornar vazio)

-- Teste 9 (Sucesso): Atualizar o status de um veículo que não está em uma rota ativa.
-- A trigger trg_valida_status_veiculo_em_rota permitirá a atualização.
UPDATE Veiculo SET status = 'Manutenção' WHERE idVeiculo = 10; -- Sucesso
SELECT * FROM Veiculo WHERE idVeiculo = 10; -- Verificando o novo status

-- Teste 10 (Sucesso): Inserir um usuário "Técnico" em qualquer região.
-- A trigger trg_valida_regiao_gestor não se aplica a perfis que não sejam "Gestor".
INSERT INTO Usuario (cpf, regiao_atuacao, email, nome, perfil, senha) 
VALUES ('44455566600', 'Sertão', 'tecnico.sertao@sprig.com', 'Tecnico Sertão', 'Técnico', 'senha444');
SELECT * FROM Usuario WHERE cpf = '44455566600'; -- Verificando

-- Teste 11 (Sucesso): Criar uma rota com data de saída válida (hoje ou no futuro).
-- A trigger trg_valida_data_saida_rota permitirá a inserção.
INSERT INTO Rota (data_saida, distancia_total, tempo_estimado, custo_estimado, fk_motorista, armazem_origem) 
VALUES (CURDATE(), 150.0, 4.0, 500.00, 10, 5);
SELECT * FROM Rota WHERE fk_motorista = 10 AND data_saida = CURDATE(); -- Verificando

-- Teste 12 (Sucesso): Excluir um destino que não está associado a nenhuma entrega.
-- A trigger trg_impede_delete_destino_em_entrega permitirá a exclusão.
-- Criando um destino temporário:
INSERT INTO Endereco_Destino (cep, rua, numero) VALUES ('55290-999', 'Rua Teste', 999);
SET @id_endereco_temp = LAST_INSERT_ID();
INSERT INTO Destino (latitude, longitude, nome_destino, tipo, fk_endereco) VALUES (-8.88, -36.49, 'Destino Temporário', 'Comunidade', @id_endereco_temp);
SET @id_destino_temp = LAST_INSERT_ID();
DELETE FROM Destino WHERE idDestino = @id_destino_temp; -- Operação bem-sucedida.
SELECT * FROM Destino WHERE idDestino = @id_destino_temp; -- Verificando (deve retornar vazio)
