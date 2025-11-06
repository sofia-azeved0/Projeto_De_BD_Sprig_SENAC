USE mydb;

-- FUNÇÕES:

-- 1. Mostra o custo médio estimado de todas as rotas
SELECT fnCustoMedioRotas() AS 'Custo Médio de Rotas';

-- 2. Calcula o espaço disponível no armazém 1
SELECT fnCapacidadeDisponivel(1) AS 'Capacidade Disponível (Armazém 1)';

-- 3. Calcula dias de atraso entre duas datas
SELECT fnDiasAtraso('2025-10-01','2025-10-05') AS 'Dias de Atraso';

-- 4. Retorna total de entregas de um motorista específico (ex: motorista 1)
SELECT fnTotalEntregasMotorista(1) AS 'Total de Entregas (Motorista 1)';

-- 5. Retorna total de lotes com status “Em Estoque”
SELECT fnTotalLotesEstoque() AS 'Lotes em Estoque';

-- 6. Calcula o percentual de entregas já concluídas
SELECT CONCAT(fnPercentualEntregasConcluidas(), '%') AS 'Percentual Entregas Concluídas';

-- 7. Retorna o tempo médio das rotas em horas
SELECT fnTempoMedioRotas() AS 'Tempo Médio das Rotas (horas)';

-- PROCEDURES:

-- 8. Insere novo fornecedor de teste
CALL spInserirFornecedor('00.000.000/0001-99', 'Fornecedor Teste SP');
SELECT * FROM Fornecedor ORDER BY idFornecedor DESC LIMIT 3;

-- 9. Atualiza nome de fornecedor (ex: ID 1)
CALL spAtualizarFornecedor(1, 'Agro Sertão Atualizado');
SELECT * FROM Fornecedor WHERE idFornecedor = 1;

-- 10. Exclui fornecedor de teste inserido
CALL spDeletarFornecedor(21);
SELECT COUNT(*) AS 'Qtd Após Exclusão' FROM Fornecedor WHERE idFornecedor = 21;

-- 11. Conta entregas agrupadas por status
CALL spContarEntregasPorStatus();

-- 12. Mostra as entregas que estão em atraso
CALL spBuscarEntregasAtrasadas();

-- 13. Mostra capacidade total, ocupação e espaço disponível de cada armazém
CALL spRelatorioCapacidade();

-- 14. Mostra relatório detalhado das entregas com custo e distância
CALL spRelatorioEntregas();

-- 15 Desempenho do motorista detalhado 
CALL spDesempenhoMotoristas();

