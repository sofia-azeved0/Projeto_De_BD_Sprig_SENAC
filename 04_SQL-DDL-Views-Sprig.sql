USE mydb;

-- Relatório de Entregas Realizadas 
CREATE OR REPLACE VIEW vw_entregas_realizadas AS
SELECT 
    e.idEntregas,
    e.data_entrega,
    e.quantidade_entregue,
    e.status,
    d.nome_destino,
    d.tipo AS tipo_destino,
    r.idRota,
    m.nome AS motorista
FROM Entregas e
JOIN Destino d ON e.fk_destino = d.idDestino
JOIN Rota r ON e.fk_rota = r.idRota
JOIN Motorista m ON r.fk_motorista = m.idMotorista
WHERE e.status = 'Entregue';

-- Entregas em Rota ou Atrasadas
CREATE OR REPLACE VIEW vw_entregas_pendentes AS
SELECT 
    e.idEntregas,
    e.data_prevista,
    e.status,
    d.nome_destino,
    d.tipo,
    r.idRota,
    v.placa AS veiculo
FROM Entregas e
JOIN Destino d ON e.fk_destino = d.idDestino
JOIN Rota r ON e.fk_rota = r.idRota
JOIN Veiculo_Motorista vm ON r.fk_motorista = vm.fk_motorista
JOIN Veiculo v ON vm.fk_veiculo = v.idVeiculo
WHERE e.status IN ('Em rota', 'Atraso');

-- Lotes em Estoque por Armazém
CREATE OR REPLACE VIEW vw_lotes_em_estoque AS
SELECT 
    l.idLote,
    l.numero_lote,
    l.especie,
    l.quantidade,
    a.nome AS nome_armazem,
    u.nome AS responsavel
FROM Lote l
JOIN Armazem a ON l.fk_armazem = a.idArmazem
JOIN Usuario u ON a.responsavel = u.cpf
WHERE l.status = 'Em Estoque';

-- Volume Total e Capacidade de Cada Armazém
CREATE OR REPLACE VIEW vw_ocupacao_armazem AS
SELECT 
    a.idArmazem,
    a.nome AS nome_armazem,
    a.capacidade_total,
    COALESCE(SUM(l.quantidade), 0) AS volume_armazenado,
    ROUND((COALESCE(SUM(l.quantidade), 0) / a.capacidade_total) * 100, 2) AS percentual_ocupacao
FROM Armazem a
LEFT JOIN Lote l ON l.fk_armazem = a.idArmazem
GROUP BY a.idArmazem;

-- Relatório de Fornecedores e Seus Lotes
CREATE OR REPLACE VIEW vw_fornecedores_lotes AS
SELECT 
    f.idFornecedor,
    f.nome AS fornecedor,
    f.cnpj,
    COUNT(l.idLote) AS total_lotes,
    SUM(l.quantidade) AS total_quantidade
FROM Fornecedor f
LEFT JOIN Lote l ON l.fk_fornecedor = f.idFornecedor
GROUP BY f.idFornecedor;

-- Rotas e Custos Médios
CREATE OR REPLACE VIEW vw_custos_rotas AS
SELECT 
    r.idRota,
    r.data_saida,
    r.data_retorno,
    r.distancia_total,
    r.tempo_estimado,
    r.custo_estimado,
    m.nome AS motorista,
    a.nome AS armazem_origem
FROM Rota r
JOIN Motorista m ON r.fk_motorista = m.idMotorista
JOIN Armazem a ON r.armazem_origem = a.idArmazem;

-- Motoristas e Veículos Vinculados
CREATE OR REPLACE VIEW vw_motoristas_veiculos AS
SELECT 
    m.idMotorista,
    m.nome AS motorista,
    m.cnh,
    v.placa,
    v.modelo,
    v.status AS status_veiculo
FROM Motorista m
JOIN Veiculo_Motorista vm ON m.idMotorista = vm.fk_motorista
JOIN Veiculo v ON vm.fk_veiculo = v.idVeiculo;

-- Destinos Mais Atendidos (Ranking)
CREATE OR REPLACE VIEW vw_destinos_mais_atendidos AS
SELECT 
    d.idDestino,
    d.nome_destino,
    d.tipo,
    COUNT(e.idEntregas) AS total_entregas
FROM Entregas e
JOIN Destino d ON e.fk_destino = d.idDestino
WHERE e.status = 'Entregue'
GROUP BY d.idDestino
ORDER BY total_entregas DESC;

-- Relatório de Usuários por Perfil
CREATE OR REPLACE VIEW vw_usuarios_por_perfil AS
SELECT 
    perfil,
    COUNT(*) AS total_usuarios
FROM Usuario
GROUP BY perfil;

-- Relatório de Entregas por Motorista
CREATE OR REPLACE VIEW vw_entregas_por_motorista AS
SELECT 
    m.nome AS motorista,
    COUNT(e.idEntregas) AS total_entregas,
    SUM(e.quantidade_entregue) AS total_quantidade
FROM Entregas e
JOIN Rota r ON e.fk_rota = r.idRota
JOIN Motorista m ON r.fk_motorista = m.idMotorista
GROUP BY m.idMotorista;

--  Entregas por Armazém de Origem
CREATE OR REPLACE VIEW vw_entregas_por_armazem AS
SELECT 
    a.nome AS armazem,
    COUNT(e.idEntregas) AS total_entregas,
    SUM(e.quantidade_entregue) AS total_quantidade
FROM Entregas e
JOIN Rota r ON e.fk_rota = r.idRota
JOIN Armazem a ON r.armazem_origem = a.idArmazem
GROUP BY a.idArmazem;

-- Lotes Prestes a Vencer
CREATE OR REPLACE VIEW vw_lotes_prestes_vencer AS
SELECT 
    l.idLote,
    l.numero_lote,
    l.especie,
    l.validade,
    DATEDIFF(l.validade, CURDATE()) AS dias_para_vencer,
    a.nome AS armazem
FROM Lote l
JOIN Armazem a ON l.fk_armazem = a.idArmazem
WHERE l.status = 'Em Estoque'
  AND DATEDIFF(l.validade, CURDATE()) <= 30;
