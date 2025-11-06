use mydb;

-- Listar todos os armazéns e os nomes de seus responsáveis (gestor) 
SELECT 
a.nome AS nome_armazem, a.capacidade_total, e.rua AS rua_armazem, e.cep AS cep_armazem, u.nome AS responsavel, u.email, u.perfil
FROM Armazem a
JOIN Usuario u ON a.responsavel = u.cpf
JOIN Endereco_Armazem e ON a.fk_endereco = e.idEndereco
WHERE u.perfil = 'Gestor';

-- Exibir o nome dos motoristas e os veículos que cada um dirige
SELECT m.nome AS motorista, v.modelo AS veiculo, v.placa
FROM Veiculo_Motorista vm
JOIN Motorista m ON vm.fk_motorista = m.idMotorista
JOIN Veiculo v ON vm.fk_veiculo = v.idVeiculo;

-- Mostrar todas as entregas realizadas e o nome do destino.
SELECT e.idEntregas, e.data_entrega, e.quantidade_entregue, d.nome_destino, d.tipo
FROM Entregas e
JOIN Destino d ON e.fk_destino = d.idDestino
WHERE e.status = 'Entregue';

-- Exibir os lotes e os nomes dos fornecedores correspondentes.
SELECT l.numero_lote, l.especie, l.quantidade, f.nome AS fornecedor
FROM Lote l
JOIN Fornecedor f ON l.fk_fornecedor = f.idFornecedor;

-- Listar os armazéns e quantos lotes cada um possui.
SELECT a.nome AS armazem, COUNT(l.idLote) AS total_lotes
FROM Armazem a
LEFT JOIN Lote l ON l.fk_armazem = a.idArmazem
GROUP BY a.nome;

-- Mostrar os motoristas e a quantidade de rotas realizadas por cada um.
SELECT m.nome AS motorista, COUNT(r.idRota) AS total_rotas
FROM Motorista m
LEFT JOIN Rota r ON m.idMotorista = r.fk_motorista
GROUP BY m.nome;

-- Exibir todas as rotas com o nome do armazém de origem e o motorista responsável.
SELECT r.idRota, a.nome AS armazem_origem, m.nome AS motorista, r.data_saida, r.data_retorno
FROM Rota r
JOIN Armazem a ON r.armazem_origem = a.idArmazem
JOIN Motorista m ON r.fk_motorista = m.idMotorista;

-- Mostrar os veículos em manutenção e seus motoristas;
SELECT v.modelo, v.placa, m.nome AS motorista
FROM Veiculo v
JOIN Veiculo_Motorista vm ON v.idVeiculo = vm.fk_veiculo
JOIN Motorista m ON vm.fk_motorista = m.idMotorista
WHERE v.status = 'Manutenção';

-- Listar os fornecedores e seus respectivos endereços.
SELECT f.nome AS fornecedor, ef.rua, ef.numero, ef.cep
FROM Fornecedor f
JOIN Endereco_Fornecedor ef ON f.idFornecedor = ef.fk_fornecedor;

-- Exibir o total de entregas por status.
SELECT status, COUNT(*) AS total
FROM Entregas
GROUP BY status;

-- Mostrar o nome dos usuários e o total de relatórios que elaboraram.
SELECT u.nome, COUNT(r.idRelatorio) AS total_relatorios
FROM Usuario u
LEFT JOIN Relatorio r ON r.fk_usuario = u.cpf
GROUP BY u.nome;

-- Exibir as entregas em atraso com o nome do motorista responsável pela rota.
SELECT e.idEntregas, d.nome_destino, m.nome AS motorista, r.data_saida, e.status
FROM Entregas e
JOIN Rota r ON e.fk_rota = r.idRota
JOIN Motorista m ON r.fk_motorista = m.idMotorista
JOIN Destino d ON e.fk_destino = d.idDestino
WHERE e.status = 'Atraso';

-- Mostrar os lotes com validade até o fim de 2025.
SELECT numero_lote, especie, validade, 
(SELECT nome FROM Fornecedor f WHERE f.idFornecedor = l.fk_fornecedor) AS fornecedor
FROM Lote l
WHERE validade < '2026-01-01';

-- Listar os telefones de cada motorista.
SELECT m.nome, t.telefone
FROM Motorista m
JOIN Telefone_Motorista t ON m.idMotorista = t.fk_motorista;

-- Exibir o total de volume entregue por rota.
SELECT r.idRota, SUM(e.quantidade_entregue) AS volume_total
FROM Entregas e
JOIN Rota r ON e.fk_rota = r.idRota
GROUP BY r.idRota;

-- Encontrar o nome dos armazéns que possuem lotes “Em Rota”.
SELECT DISTINCT a.nome
FROM Armazem a
JOIN Lote l ON l.fk_armazem = a.idArmazem
WHERE l.status = 'Em Rota';

-- Listar as comunidades (destinos) e quantas entregas cada uma recebeu.
SELECT d.nome_destino, COUNT(e.idEntregas) AS total_entregas
FROM Destino d
LEFT JOIN Entregas e ON e.fk_destino = d.idDestino
WHERE d.tipo = 'Comunidade'
GROUP BY d.nome_destino;

-- Mostrar o nome do motorista e o veículo de maior capacidade que ele dirige.
SELECT m.nome, v.modelo, v.capacidade
FROM Motorista m
JOIN Veiculo_Motorista vm ON m.idMotorista = vm.fk_motorista
JOIN Veiculo v ON vm.fk_veiculo = v.idVeiculo
WHERE v.capacidade = (
    SELECT MAX(v2.capacidade) FROM Veiculo v2 
    JOIN Veiculo_Motorista vm2 ON vm2.fk_veiculo = v2.idVeiculo 
    WHERE vm2.fk_motorista = m.idMotorista
);

-- Mostrar os nomes dos motoristas que já participaram de rotas com custo acima de 500.
SELECT DISTINCT m.nome
FROM Motorista m
JOIN Rota r ON r.fk_motorista = m.idMotorista
WHERE r.custo_estimado > 500;

-- Exibir os armazéns com mais de 2 lotes em estoque.
SELECT a.nome, COUNT(l.idLote) AS total_em_estoque
FROM Armazem a
JOIN Lote l ON a.idArmazem = l.fk_armazem
WHERE l.status = 'Em Estoque'
GROUP BY a.nome
HAVING COUNT(l.idLote) > 1;



