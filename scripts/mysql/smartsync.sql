use eventify;

CREATE OR REPLACE VIEW vw_faturamento_buffet AS (
SELECT 
	b.id, 
    SUM(e.preco) faturamento_evento
FROM
	buffet b
JOIN
	evento e ON e.id_buffet = b.id
WHERE
	e.status = 6
GROUP BY b.id ORDER BY id
);


CREATE OR REPLACE VIEW vw_gastos_buffet AS (
SELECT 
	b.id, 
    SUM(t.valor) gasto_evento
FROM
	buffet b
JOIN
	transacao t ON t.id_buffet = b.id
GROUP BY b.id ORDER BY id);


-- buffetsSemVisitas (15) (lista)
CREATE OR REPLACE VIEW vw_buffet_15_sem_visitas AS (
SELECT
    b.id,
    MAX(a.data_criacao) AS data_mais_atual
FROM
    acesso a
JOIN
    pagina p ON p.id = a.id_pagina
JOIN
    buffet b ON b.id = p.id_buffet
GROUP BY
    b.id
HAVING 
    data_mais_atual <= CURDATE() - INTERVAL 15 DAY);


-- taxa conversao visitas em fracao escala  (calculo back)
-- categorias (lista categoria, qtd)
-- taxa contratos cancelados (calculo back)

-- grafico de barras de todos eventos 
-- clientes que fecharam 0 / 1 / 2 / 3 ou mais (calculo back, retorna lista)
-- Uso do formulário dinâmico
