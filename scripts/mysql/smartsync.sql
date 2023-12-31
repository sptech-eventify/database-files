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
GROUP BY b.id ORDER BY id
);

-- buffetsSemVisitas (15) (lista)
CREATE OR REPLACE VIEW vw_buffet_15_sem_visitas AS (
SELECT
    b.id,
    b.nome,
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
    data_mais_atual <= CURDATE() - INTERVAL 15 DAY
);


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


CREATE OR REPLACE VIEW vw_contratantes_consumo AS (
SELECT
    u.id AS id_usuario,
    u.nome AS nome_usuario,
    COUNT(e.id) AS quantidade_eventos
FROM
    usuario u
LEFT JOIN
    evento e ON u.id = e.id_contratante
WHERE
    u.tipo_usuario = 1
GROUP BY
    u.id, u.nome
);

-- Uso do formulário dinâmico
CREATE OR REPLACE VIEW vw_grafico AS (
SELECT
    YEAR(data) AS ano,
    MONTH(data) AS mes,
    traduz_mes(MONTHNAME(data)) mes_traduzido,
    COUNT(CASE WHEN tipo = 'cadastro' THEN 1 END) AS cadastros,
    COUNT(CASE WHEN tipo = 'churn' THEN 1 END) AS churn
FROM (
    SELECT
        id,
        data_criacao AS data,
        'cadastro' AS tipo
    FROM
        usuario
    UNION ALL
    SELECT
        id,
        ultimo_login AS data,
        'churn' AS tipo
    FROM
        usuario
    WHERE
        ultimo_login IS NOT NULL AND DATEDIFF(CURDATE(), ultimo_login) > 90
) AS dados
GROUP BY
    ano, mes
);


CREATE OR REPLACE VIEW vw_ultimas_7_dias AS (
SELECT 
	COUNT(id)
FROM 
	usuario 
WHERE 
	data_criacao > DATE_SUB(NOW(), INTERVAL 7 DAY) OR ultimo_login > DATE_SUB(NOW(), INTERVAL 90 DAY)
);

CREATE OR REPLACE VIEW vw_ultimas_90_dias AS (
SELECT 
	COUNT(id)
FROM 
	usuario 
WHERE 
	data_criacao > DATE_SUB(NOW(), INTERVAL 90 DAY) OR ultimo_login > DATE_SUB(NOW(), INTERVAL 180 DAY)
);

CREATE OR REPLACE VIEW vw_retencao_usuario AS (
SELECT 
	COUNT(id)
FROM 
	usuario 
WHERE 
	data_criacao > DATE_SUB(NOW(), INTERVAL 120 DAY) OR ultimo_login > DATE_SUB(NOW(), INTERVAL 120 DAY)
);


CREATE OR REPLACE VIEW vw_curiosidades_usuario AS (
SELECT
    tipo_usuario,
    COUNT(*) AS quantidade,
    (COUNT(*) / (SELECT COUNT(*) FROM usuario)) * 100 AS porcentagem
FROM
    usuario
WHERE
    tipo_usuario IN (1, 2)
GROUP BY
    tipo_usuario
);

CREATE OR REPLACE VIEW vw_usuarios_sem_eventos AS (
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
HAVING
	qtd_eventos = 0
);

CREATE OR REPLACE VIEW vw_formulario_dinamico_consumo AS (
SELECT 
	traduz_mes(MONTHNAME(data_criacao)) nome_mes,
	COUNT(a.id)
FROM
	pagina p
JOIN
	acesso a ON a.id_pagina = p.id
WHERE
	p.id = 3
GROUP BY nome_mes, p.id
);

CREATE OR REPLACE VIEW vw_uso_formulario_dinamico AS (
SELECT
    SUM(CASE WHEN is_formulario_dinamico = 1 THEN 1 ELSE 0 END) AS eventos_com_formulario,
    SUM(CASE WHEN is_formulario_dinamico = 0 THEN 1 ELSE 0 END) AS eventos_sem_formulario,
    COUNT(*) AS total_eventos,
    (SUM(CASE WHEN is_formulario_dinamico = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS porcentagem_com_formulario
FROM
    evento
);

CREATE OR REPLACE VIEW vw_utilizacao_formulario AS (
SELECT
    COUNT(DISTINCT CASE WHEN eventos_com_formulario > 0 THEN id_contratante END) AS usuarios_com_formulario,
    COUNT(DISTINCT CASE WHEN eventos_sem_formulario > 0 THEN id_contratante END) AS usuarios_sem_formulario,
    COUNT(DISTINCT id_contratante) AS total_usuarios,
    (COUNT(DISTINCT CASE WHEN eventos_com_formulario > 0 THEN id_contratante END) / COUNT(DISTINCT id_contratante)) * 100 AS porcentagem_com_formulario
FROM (
    SELECT
        id_contratante,
        MAX(is_formulario_dinamico) AS eventos_com_formulario,
        MAX(1 - is_formulario_dinamico) AS eventos_sem_formulario
    FROM
        evento
    GROUP BY
        id_contratante
) AS eventos_por_usuario
);


