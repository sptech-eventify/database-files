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
CREATE OR REPLACE VIEW vw_fracao_evento_acesso AS (
SELECT
    b.id,
    b.nome,
    (
        SELECT COUNT(*)
        FROM evento e
        WHERE e.id_buffet = b.id AND e.status = 6
    ) AS qtd_eventos,
    (
        SELECT COUNT(*)
        FROM pagina p
        JOIN acesso a ON a.id_pagina = p.id
        WHERE p.id_buffet = b.id
    ) AS qtd_acessos
FROM
    buffet b
);


CREATE OR REPLACE VIEW vw_categorias_qtd AS (
SELECT
    te.descricao AS tipo_evento,
    COUNT(*) AS quantidade
FROM
    buffet_tipo_evento bt
JOIN
    tipo_evento te ON bt.id_tipo_evento = te.id
GROUP BY
    te.id
);


-- taxa contratos cancelados (calculo back)
CREATE OR REPLACE VIEW vw_fracao_evento_cancelado_acesso AS (
SELECT
    b.id,
    b.nome,
    (
        SELECT COUNT(*)
        FROM evento e
        WHERE e.id_buffet = b.id AND e.status = 4 OR e.status = 7
    ) AS qtd_eventos_negados_e_cancelados,
    (
        SELECT COUNT(*)
        FROM evento e
        WHERE e.id_buffet = b.id AND e.status = 6 OR e.status = 5
    ) AS qtd_eventos_realizados_e_confirmados
FROM
    buffet b
);


CREATE OR REPLACE VIEW vw_contratantes_consumo AS (
SELECT
	u.id,
	u.nome,
    COUNT(e.id) qtd_eventos
FROM
	usuario u
JOIN
	evento e ON e.id_contratante = u.id    
WHERE
	u.tipo_usuario = 1
GROUP BY u.id
);


-- Uso do formulário dinâmico
CREATE OR REPLACE VIEW vw_grafico AS (
SELECT
    traduz_mes(MONTHNAME(data_criacao)) nome_mes,
    COUNT(*) quantidade_acessos
FROM
    acesso
WHERE
    id_pagina = 4
GROUP BY
    nome_mes
ORDER BY
    MONTH(data_criacao)
);


CREATE OR REPLACE VIEW vw_ultimas_7_dias AS (
SELECT 
	COUNT(id)
FROM 
	usuario 
WHERE 
	data_criacao > DATE_SUB(NOW(), INTERVAL 7 DAY)
);
