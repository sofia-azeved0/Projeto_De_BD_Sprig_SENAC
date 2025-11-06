USE mydb;

-- Visualizar entregas realizadas
SELECT * 
FROM vw_entregas_realizadas
ORDER BY data_entrega DESC;

-- Visualizar entregas em rota ou atrasadas
SELECT * 
FROM vw_entregas_pendentes
ORDER BY data_prevista ASC;

-- Verificar lotes em estoque e gestores responsáveis
SELECT * 
FROM vw_lotes_em_estoque
ORDER BY nome_armazem;

-- Analisar ocupação dos armazéns (% de capacidade)
SELECT * 
FROM vw_ocupacao_armazem
ORDER BY percentual_ocupacao DESC;

-- Consultar fornecedores e quantidade total de lotes entregues
SELECT * 
FROM vw_fornecedores_lotes
ORDER BY total_lotes DESC;

-- Consultar rotas e custos médios estimados
SELECT * 
FROM vw_custos_rotas
ORDER BY data_saida DESC;

-- Ver motoristas e os veículos que dirigem
SELECT * 
FROM vw_motoristas_veiculos
ORDER BY motorista;

-- Ranking de destinos mais atendidos
SELECT * 
FROM vw_destinos_mais_atendidos
ORDER BY total_entregas DESC;

-- Quantidade de usuários por perfil (Gestor, Técnico, Agricultor)
SELECT * 
FROM vw_usuarios_por_perfil;

-- Total de entregas realizadas por motorista
SELECT * 
FROM vw_entregas_por_motorista
ORDER BY total_entregas DESC;

-- Total de entregas por armazém de origem
SELECT * 
FROM vw_entregas_por_armazem
ORDER BY total_entregas DESC;

-- Lotes prestes a vencer (até 30 dias de validade)
SELECT * 
FROM vw_lotes_prestes_vencer
ORDER BY dias_para_vencer ASC;
