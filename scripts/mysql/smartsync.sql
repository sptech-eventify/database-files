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
-- taxa conversao visitas em fracao escala  (calculo back)
-- categorias (lista categoria, qtd)
-- taxa contratos cancelados (calculo back)

-- grafico de barras de todos eventos 
-- clientes que fecharam 0 / 1 / 2 / 3 ou mais (calculo back, retorna lista)
-- Uso do formulário dinâmico
