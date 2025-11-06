USE mydb;

-- 1️ Função: Custo médio geral das rotas
-- Retorna o custo médio de todas as rotas cadastradas.

DELIMITER $$
CREATE FUNCTION fnCustoMedioRotas()
RETURNS DECIMAL(8,2) DETERMINISTIC
BEGIN
    DECLARE media DECIMAL(8,2);
    SELECT AVG(custo_estimado) INTO media FROM Rota;
    RETURN IFNULL(media, 0);
END $$
DELIMITER $$

-- 2️ Função: Capacidade disponível de um armazém
-- Subtrai o total de lotes armazenados da capacidade total.

DELIMITER $$
CREATE FUNCTION fnCapacidadeDisponivel(p_armazem INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE ocupado INT DEFAULT 0;
    DECLARE total INT DEFAULT 0;
    SELECT IFNULL(SUM(quantidade),0) INTO ocupado FROM Lote WHERE fk_armazem = p_armazem;
    SELECT capacidade_total INTO total FROM Armazem WHERE idArmazem = p_armazem;
    RETURN total - ocupado;
END$$
DELIMITER $$

-- 3️ Função: Dias de atraso entre datas

DELIMITER $$
CREATE FUNCTION fnDiasAtraso(dataPrevista DATE, dataEntrega DATE)
RETURNS INT DETERMINISTIC
BEGIN
    RETURN DATEDIFF(dataEntrega, dataPrevista);
END$$
DELIMITER $$

-- 4️ Função: Total de entregas feitas por um motorista

DELIMITER $$
CREATE FUNCTION fnTotalEntregasMotorista(idMotorista INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Entregas e
    JOIN Rota r ON e.fk_rota = r.idRota
    WHERE r.fk_motorista = idMotorista;
    RETURN IFNULL(total,0);
END$$
DELIMITER $$

-- 5️ Função: Total de lotes em estoque

DELIMITER $$
CREATE FUNCTION fnTotalLotesEstoque()
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Lote WHERE status = 'Em Estoque';
    RETURN total;
END$$
DELIMITER $$

-- 6️ Função: Percentual de entregas concluídas

DELIMITER $$
CREATE FUNCTION fnPercentualEntregasConcluidas()
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE total INT;
    DECLARE concluidas INT;
    SELECT COUNT(*) INTO total FROM Entregas;
    SELECT COUNT(*) INTO concluidas FROM Entregas WHERE status = 'Entregue';
    RETURN ROUND((concluidas / total) * 100, 2);
END$$
DELIMITER $$

-- 7️ Função: Calcula tempo médio (horas) das rotas

DELIMITER $$
CREATE FUNCTION fnTempoMedioRotas()
RETURNS DECIMAL(6,2) DETERMINISTIC
BEGIN
    DECLARE media DECIMAL(6,2);
    SELECT AVG(tempo_estimado) INTO media FROM Rota;
    RETURN IFNULL(media,0);
END$$
DELIMITER $$

-- 8️ Procedure: Inserir novo fornecedor

DELIMITER $$
CREATE PROCEDURE spInserirFornecedor(p_cnpj VARCHAR(18), p_nome VARCHAR(45))
BEGIN
    INSERT INTO Fornecedor (cnpj, nome) VALUES (p_cnpj, p_nome);
END$$
DELIMITER $$

-- 9️ Procedure: Atualizar nome do fornecedor

DELIMITER $$
CREATE PROCEDURE spAtualizarFornecedor(p_id INT, p_nome VARCHAR(45))
BEGIN
    UPDATE Fornecedor SET nome = p_nome WHERE idFornecedor = p_id;
END$$
DELIMITER $$ 

-- 10 Procedure: Deletar fornecedor

DELIMITER $$
CREATE PROCEDURE spDeletarFornecedor(p_id INT)
BEGIN
    DELETE FROM Fornecedor WHERE idFornecedor = p_id;
END$$
DELIMITER $$

-- 11️ Procedure: Contar entregas por status

DELIMITER $$
CREATE PROCEDURE spContarEntregasPorStatus()
BEGIN
    SELECT status AS 'Status da Entrega', COUNT(*) AS 'Total'
    FROM Entregas
    GROUP BY status;
END$$
DELIMITER $$

-- 12️ Procedure: Buscar entregas atrasadas

DELIMITER $$
CREATE PROCEDURE spBuscarEntregasAtrasadas()
BEGIN
    SELECT 
        e.idEntregas AS 'Entrega',
        d.nome_destino AS 'Destino',
        e.data_prevista AS 'Data Prevista',
        e.data_entrega AS 'Data Entrega',
        fnDiasAtraso(e.data_prevista, e.data_entrega) AS 'Dias de Atraso'
    FROM Entregas e
    JOIN Destino d ON e.fk_destino = d.idDestino
    WHERE e.status = 'Atraso';
END$$
DELIMITER $$

-- 13️ Procedure: Relatório de capacidade dos armazéns

DELIMITER $$
CREATE PROCEDURE spRelatorioCapacidade()
BEGIN
    SELECT 
        a.idArmazem,
        a.nome AS 'Armazém',
        a.capacidade_total AS 'Capacidade Total',
        IFNULL(SUM(l.quantidade),0) AS 'Ocupado',
        fnCapacidadeDisponivel(a.idArmazem) AS 'Disponível'
    FROM Armazem a
    LEFT JOIN Lote l ON l.fk_armazem = a.idArmazem
    GROUP BY a.idArmazem;
END$$
DELIMITER $$

-- 14️ Procedure: Relatório geral de entregas

DELIMITER $$
CREATE PROCEDURE spRelatorioEntregas()
BEGIN
    SELECT 
        e.idEntregas AS 'Entrega',
        d.nome_destino AS 'Destino',
        e.status,
        fnDiasAtraso(e.data_prevista, e.data_entrega) AS 'Dias Atraso',
        r.distancia_total AS 'Distância (km)',
        CONCAT('R$ ', FORMAT(r.custo_estimado,2,'de_DE')) AS 'Custo'
    FROM Entregas e
    JOIN Destino d ON e.fk_destino = d.idDestino
    JOIN Rota r ON e.fk_rota = r.idRota;
END$$
DELIMITER $$

-- 15️ Procedure: Relatório de motoristas e desempenho

DELIMITER $$
CREATE PROCEDURE spDesempenhoMotoristas()
BEGIN
    SELECT 
        m.idMotorista,
        m.nome AS 'Motorista',
        fnTotalEntregasMotorista(m.idMotorista) AS 'Entregas Realizadas',
        COUNT(DISTINCT r.idRota) AS 'Rotas Percorridas',
        ROUND(AVG(r.distancia_total),2) AS 'Distância Média (km)',
        ROUND(AVG(r.custo_estimado),2) AS 'Custo Médio (R$)'
    FROM Motorista m
    LEFT JOIN Rota r ON r.fk_motorista = m.idMotorista
    LEFT JOIN Entregas e ON e.fk_rota = r.idRota
    GROUP BY m.idMotorista;
END$$
DELIMITER ;