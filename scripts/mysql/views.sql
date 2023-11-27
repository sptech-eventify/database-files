SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

CREATE OR REPLACE VIEW eventify.vw_kpi_conversao_de_visitantes AS
SELECT 
    (SELECT COUNT(id) FROM eventify.usuario WHERE usuario.data_criacao >= CURDATE() - INTERVAL 240 MONTH) AS qtd_cadastrados,
    (SELECT COUNT(id) FROM eventify.acesso WHERE acesso.id_pagina = 1 AND acesso.data_criacao >= CURDATE() - INTERVAL 240 MONTH) AS qtd_visitantes;

CREATE OR REPLACE VIEW eventify.vw_kpi_precisao_do_formulario AS
SELECT 
    (SELECT COUNT(id) FROM eventify.evento WHERE evento.is_formulario_dinamico AND (evento.status = 5 OR evento.status = 6) AND data >= CURDATE() - INTERVAL 240 MONTH) AS qtd_contratos_formulario_dinamico,
    COUNT(id) AS qtd_contratos_total
FROM eventify.evento;

CREATE OR REPLACE VIEW eventify.vw_kpi_conversao_de_reservas AS
SELECT 
    (SELECT COUNT(id) FROM eventify.evento WHERE (evento.status = 5 OR evento.status = 6) AND data_criacao >= CURDATE() - INTERVAL 240 MONTH) AS qtd_orcamentos_fechados,
    (SELECT COUNT(id) FROM eventify.evento WHERE data_criacao >= CURDATE() - INTERVAL 240 MONTH) AS qtd_orcamentos_totais;

SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS eventify.traduz_mes;
DELIMITER //

CREATE FUNCTION eventify.traduz_mes(mes VARCHAR(63)) RETURNS VARCHAR(63)
BEGIN
    CASE mes
        WHEN 'January' THEN RETURN 'Janeiro';
        WHEN 'February' THEN RETURN 'Fevereiro';
        WHEN 'March' THEN RETURN 'Março';
        WHEN 'April' THEN RETURN 'Abril';
        WHEN 'May' THEN RETURN 'Maio';
        WHEN 'June' THEN RETURN 'Junho';
        WHEN 'July' THEN RETURN 'Julho';
        WHEN 'August' THEN RETURN 'Agosto';
        WHEN 'September' THEN RETURN 'Setembro';
        WHEN 'October' THEN RETURN 'Outubro';
        WHEN 'November' THEN RETURN 'Novembro';
        WHEN 'December' THEN RETURN 'Dezembro';
        ELSE RETURN mes;
    END CASE;
END //

DELIMITER ;



CREATE OR REPLACE VIEW eventify.vw_churn AS
SELECT 
    traduz_mes(DATE_FORMAT(data_criacao, '%M')) AS mes,
    COUNT(CASE WHEN tipo_usuario = 2 THEN id END) AS prop_entraram,
    COUNT(CASE WHEN tipo_usuario = 2 AND ultimo_login < DATE_ADD(data_criacao, INTERVAL 2 MONTH) THEN id END) AS prop_sairam,
    COUNT(CASE WHEN tipo_usuario = 1 THEN id END) AS contr_entraram,
    COUNT(CASE WHEN tipo_usuario = 1 AND ultimo_login < DATE_ADD(data_criacao, INTERVAL 2 MONTH)  THEN id END) AS contr_sairam
FROM 
    eventify.usuario 
WHERE 
    tipo_usuario IN (1, 2)
GROUP BY 
    YEAR(data_criacao),
    MONTH(data_criacao)
ORDER BY 
    YEAR(data_criacao),
    MONTH(data_criacao);


CREATE OR REPLACE VIEW vw_log_paginas AS
SELECT 
    id_pagina,
    traduz_mes(DATE_FORMAT(data_criacao, '%M')) AS mes,
    COUNT(id) AS total_entraram
FROM 
    acesso
WHERE 
    data_criacao > DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY 
    id_pagina,
    YEAR(data_criacao),
    MONTH(data_criacao);


CREATE OR REPLACE VIEW vw_retencao_usuarios_retidos AS
SELECT 
    traduz_mes(DATE_FORMAT(data_criacao, '%M')) AS mes,
    COUNT(id) AS total_retidos
FROM 
    usuario
GROUP BY 
    YEAR(data_criacao),
    MONTH(data_criacao);


CREATE OR REPLACE VIEW eventify.vw_retencao_buffets_retidos AS
SELECT 
    traduz_mes(DATE_FORMAT(data_criacao, '%M')) AS mes,
    COUNT(id) AS total_retidos
FROM 
    buffet
GROUP BY 
    YEAR(data_criacao),
    MONTH(data_criacao);


CREATE OR REPLACE VIEW eventify.vw_retencao_formularios_retidos AS
SELECT 
    traduz_mes(DATE_FORMAT(data_criacao, '%M')) AS mes,
    COUNT(id) AS total_retidos
FROM 
    evento
WHERE 
    evento.is_formulario_dinamico
GROUP BY 
    YEAR(data_criacao),
    MONTH(data_criacao);


CREATE OR REPLACE VIEW eventify.vw_kpi_abandono_reserva AS
SELECT 
    id_buffet,
    SUM(CASE WHEN status = 4 THEN 1 ELSE 0 END) AS abandonos,
    SUM(CASE WHEN status != 7 THEN 1 ELSE 0 END) AS total
FROM 
    evento
GROUP BY 
    id_buffet;


CREATE OR REPLACE VIEW eventify.vw_kpi_satisfacao AS
SELECT 
    id_buffet,
    ROUND(AVG(CASE WHEN status = 6 THEN nota END), 1) * 2 AS media,
    SUM(CASE WHEN status = 6 THEN 1 ELSE 0 END) AS total
FROM 
    evento
GROUP BY 
    id_buffet;
    

CREATE OR REPLACE VIEW eventify.vw_kpi_movimentacao_financeira AS
SELECT 
    id_buffet,
    ROUND(SUM(CASE WHEN status = 6 THEN preco END), 2) AS movimentacao,
    SUM(CASE WHEN status = 6 THEN 1 ELSE 0 END) AS total
FROM 
    evento
GROUP BY 
    id_buffet;


CREATE OR REPLACE VIEW eventify.vw_avaliacoes_buffet AS
SELECT 
    usuario.nome,
    evento.nota,
    evento.avaliacao,
    evento.data,
    evento.id_buffet
FROM 
    evento
RIGHT JOIN
    usuario ON evento.id_contratante = usuario.id
WHERE
    evento.status = 6;


CREATE OR REPLACE VIEW eventify.vw_dados_do_buffet AS
SELECT 
    traduz_mes(DATE_FORMAT(data, '%M')) AS mes,
    COUNT(id) AS qtd_eventos, 
    SUM(preco) AS faturamento, 
    id_buffet
FROM
    evento
WHERE
    status = 6
GROUP BY 
    id_buffet,
    YEAR(data),
    MONTH(data);


DROP FUNCTION IF EXISTS eventify.haversine;
DELIMITER //

CREATE FUNCTION eventify.haversine(
    lat1 DOUBLE,
    lon1 DOUBLE,
    lat2 DOUBLE,
    lon2 DOUBLE
) RETURNS DOUBLE
BEGIN
    DECLARE radius DOUBLE DEFAULT 6371;
    DECLARE dLat DOUBLE;
    DECLARE dLon DOUBLE;
    DECLARE a DOUBLE;
    DECLARE c DOUBLE;
    DECLARE distance DOUBLE;

    SET dLat = RADIANS(lat2 - lat1);
    SET dLon = RADIANS(lon2 - lon1);

    SET a = SIN(dLat / 2) * SIN(dLat / 2) +
            COS(RADIANS(lat1)) * COS(RADIANS(lat2)) *
            SIN(dLon / 2) * SIN(dLon / 2);

    SET c = 2 * ATAN2(SQRT(a), SQRT(1 - a));

    SET distance = radius * c;

    RETURN distance;
END //

DELIMITER ;


CREATE OR REPLACE VIEW eventify.vw_buffet_info AS (
SELECT 
	buffet.id,
	GROUP_CONCAT(DISTINCT tipo_evento.descricao SEPARATOR ",") tipos_evento,
    buffet.nome,
    buffet.preco_medio_diaria,
    ROUND(AVG(evento.nota), 1) nota_media,
    GROUP_CONCAT(DISTINCT CONCAT(imagem.caminho, '/', imagem.nome, '.', imagem.tipo) SEPARATOR ',') caminho
FROM
	eventify.buffet
JOIN eventify.evento 
	ON evento.id_buffet = buffet.id
JOIN eventify.buffet_tipo_evento 
	ON buffet_tipo_evento.id_buffet = buffet.id
JOIN eventify.tipo_evento 
	ON tipo_evento.id = buffet_tipo_evento.id_tipo_evento
JOIN eventify.imagem 
	ON imagem.id_buffet = buffet.id
GROUP BY buffet.nome
);


CREATE OR REPLACE VIEW eventify.vw_buffet_pesquisa AS
SELECT 
	buffet.*, sub.nota nota 
FROM
	eventify.buffet
INNER JOIN (
	SELECT 
		id_buffet, ROUND(AVG(nota), 1) nota
	FROM
			eventify.evento
	GROUP BY id_buffet ORDER BY id_buffet) AS sub 
ON buffet.id = sub.id_buffet
ORDER BY buffet.id;


CREATE OR REPLACE VIEW vw_notas_buffet AS
SELECT 
	id_buffet, ROUND(AVG(nota), 1) nota
FROM
	eventify.evento
GROUP BY 
	id_buffet 
    ORDER BY id_buffet;
    

CREATE OR REPLACE VIEW eventify.vw_eventos_ontem AS 
SELECT 
	e.id, e.data, preco, e.id_buffet, e.id_contratante 
FROM 
	eventify.evento e
WHERE 
	DATE(data) = DATE_SUB(CURDATE(), INTERVAL 1 DAY) AND status = 6;
    

DELIMITER //
CREATE PROCEDURE eventify.sp_transacoes(IN buffet_id INT)
BEGIN
    SELECT
		u.nome pagante,
        u.cpf cpf,
        u.email email,
        t.valor valor,
        t.is_gasto is_gasto,
        IFNULL(t.referente, 'Não Registrada') AS motivo,
        IFNULL(t.data_criacao, 'Não Registrada') AS data
    FROM
        transacao t
	JOIN buffet b ON b.id = t.id_buffet
    JOIN usuario u ON u.id = b.id_usuario
    WHERE
        t.id_buffet = buffet_id
    UNION ALL
    SELECT
		u.nome pagante,
        u.cpf cpf,
        u.email email,
        f.salario AS valor,
        1 AS is_gasto,
        CONCAT('Salário do funcionário (', f.nome, ')') motivo,
        DATE_FORMAT(DATE_ADD(DATE_FORMAT(f.data_criacao, CONCAT('%Y-%m-0', f.dia_pagamento)), INTERVAL m.months MONTH), '%Y-%m-%d 00:00:00') AS data
    FROM
        eventify.funcionario f
    CROSS JOIN (
        SELECT 0 AS months
        UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
        UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8
        UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12
    ) AS m
    JOIN eventify.usuario u ON u.id = f.id_empregador
    JOIN eventify.buffet b ON b.id_usuario = u.id
    WHERE
        f.is_visivel = 1
        AND f.data_criacao <= CURDATE()
        AND DATE_ADD(DATE_FORMAT(f.data_criacao, '%Y-%m-01'), INTERVAL m.months MONTH) <= CURDATE()
        AND b.id = buffet_id
    UNION ALL
    SELECT
		c.nome pagante,
        c.cpf cpf,
        c.email email,
        e.preco AS valor,
        0 AS is_gasto,
        CONCAT('Pagamento do Evento (', c.nome, ')') motivo,
        p.data_pago data
    FROM
        pagamento p
    JOIN
        evento e ON p.id = e.id_pagamento
	JOIN
		usuario c ON c.id = e.id_contratante
    WHERE
        e.id_buffet = buffet_id
        AND e.status = 6
    ORDER BY data;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE eventify.sp_atividades(IN buffet_id INT)
BEGIN
	SELECT
		'1' id,
		'Pagamento' nome,
        t.referente descricao,
        t.data_criacao data
    FROM
        transacao t
	JOIN buffet b ON b.id = t.id_buffet
    JOIN usuario u ON u.id = b.id_usuario
    WHERE
        t.id_buffet = buffet_id
    UNION ALL
    SELECT
		'1' id,
		'Pagamento' nome,
        CONCAT('Salário do funcionário (', f.nome, ')') descricao,
        DATE_FORMAT(DATE_ADD(DATE_FORMAT(f.data_criacao, CONCAT('%Y-%m-0', f.dia_pagamento)), INTERVAL m.months MONTH), '%Y-%m-%d 00:00:00') data
    FROM
        eventify.funcionario f
    CROSS JOIN (
        SELECT 0 AS months
        UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
        UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8
        UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12
    ) AS m
    JOIN eventify.usuario u ON u.id = f.id_empregador
    JOIN eventify.buffet b ON b.id_usuario = u.id
    WHERE
        f.is_visivel = 1
        AND f.data_criacao <= CURDATE()
        AND DATE_ADD(DATE_FORMAT(f.data_criacao, '%Y-%m-01'), INTERVAL m.months MONTH) <= CURDATE()
        AND b.id = buffet_id
    UNION ALL
    SELECT
		'1' id,
		'Pagamento' nome,
        CONCAT('Pagamento do Evento (', c.nome, ')') descricao,
        p.data_pago data
    FROM
        pagamento p
    JOIN
        evento e ON e.id_pagamento = p.id 
	JOIN
		usuario c ON c.id = e.id_contratante
    WHERE
        e.id_buffet = buffet_id
        AND e.status = 6
	UNION ALL
    SELECT
		'3' id,
        'Tarefa Concluída' nome,
        CONCAT(t.nome, ': ', t.descricao) descricao,
        t.data_conclusao data
    FROM
        tarefa t
	JOIN
		bucket b ON b.id = t.id_bucket
	JOIN
		buffet_servico bs ON bs.id = b.id_buffet_servico
	JOIN
		buffet bf ON bf.id = bs.id_buffet
    WHERE
        bf.id = buffet_id
        AND t.status = 3
	UNION ALL
    SELECT
		'4' id,
        'Tarefa Atrasada' nome,
        CONCAT(t.nome, ': ', t.descricao) descricao,
        CONCAT(t.data_estimada, ' 00:00:00') data
    FROM
        tarefa t
	JOIN
		bucket b ON b.id = t.id_bucket
	JOIN
		buffet_servico bs ON bs.id = b.id_buffet_servico
	JOIN
		buffet bf ON bf.id = bs.id_buffet
    WHERE
        bf.id = 1
        AND NOW() > data_estimada
	UNION ALL
    SELECT
		'5' id,
        'Mensagem' nome,
        CONCAT(u.nome, ': ', m.mensagem) descricao,
        m.data
    FROM
        mensagem m
	JOIN
		usuario u
    WHERE
        m.mandado_por = 0
        AND m.id_buffet = buffet_id
    ORDER BY data ASC
    LIMIT 20;
END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE eventify.sp_proximo_evento(IN buffet_id INT)
BEGIN
	SELECT 
		e.id,
        u.nome, 
        e.data
	FROM 
		buffet b 
    JOIN
		evento e ON e.id_buffet = b.id
	JOIN
		usuario u ON u.id = e.id_contratante
	WHERE b.id = buffet_id
    AND e.data >= NOW()
    ORDER BY data ASC
    LIMIT 1;
END //
DELIMITER ;




CREATE OR REPLACE VIEW eventify.vw_acessos_buffet AS (
SELECT
    id_buffet,
    ano,
    mes,
    mes_n,
    COUNT(id) qtd_acesso
FROM (
    SELECT
        p.id_buffet,
        DATE_FORMAT(a.data_criacao, '%Y') ano,
        TRADUZ_MES(DATE_FORMAT(a.data_criacao, '%M')) mes,
        DATE_FORMAT(a.data_criacao, '%m') mes_n,
        a.id
    FROM 
        eventify.pagina p
    JOIN 
        eventify.acesso a ON a.id_pagina = p.id
    JOIN
        eventify.buffet b ON p.id_buffet = b.id
    WHERE
        a.data_criacao >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
) subquery
GROUP BY
    id_buffet, ano, mes, mes_n
ORDER BY
    id_buffet, ano, mes_n ASC
);


CREATE OR REPLACE VIEW eventify.vw_visualizacoes_buffet AS (
SELECT
    v.id_buffet,
    DATE_FORMAT(v.data_criacao, '%Y') AS ano,
    TRADUZ_MES(DATE_FORMAT(v.data_criacao, '%M')) AS mes,
    DATE_FORMAT(v.data_criacao, '%m') AS mes_n,
    COUNT(v.id) AS qtd_visualizacoes
FROM
	eventify.visualizacao v
JOIN
	eventify.buffet b ON b.id = v.id_buffet
WHERE
	v.data_criacao >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
GROUP BY
	v.id_buffet, ano, mes, mes_n
ORDER BY
	v.id_buffet, ano, mes_n
);



CREATE OR REPLACE VIEW eventify.vw_avaliacoes_buffet AS (
SELECT
    e.id_buffet,
    DATE_FORMAT(e.data, '%Y') AS ano,
    TRADUZ_MES(DATE_FORMAT(e.data, '%M')) AS mes,
    DATE_FORMAT(e.data, '%m') AS mes_n,
    COUNT(e.id) AS qtd_visualizacoes
FROM
	eventify.evento e
JOIN
	eventify.buffet b ON b.id = e.id_buffet
WHERE
	e.data >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
    AND e.status = 6
GROUP BY
	e.id_buffet, ano, mes, mes_n
ORDER BY
	e.id_buffet, ano, mes_n
);



CREATE OR REPLACE VIEW eventify.vw_info_eventos AS (
	SELECT 
		b.id id_buffet,
		c.nome,
		c.cpf,
		c.email,
		e.data,
        e.preco,
        CASE
			WHEN e.status = 1 THEN 'Orçando'
			WHEN e.status = 2 THEN 'Recusado pelo Buffet'
			WHEN e.status = 3 THEN 'Orçado'
			WHEN e.status = 4 THEN 'Recusado pelo Contratante'
			WHEN e.status = 5 THEN 'Reservado'
			WHEN e.status = 6 THEN 'Realizado'
			WHEN e.status = 7 THEN 'Cancelado'
			ELSE 'Status Desconhecido'
		END AS status,
		e.data_criacao data_pedido,
        e.id id_evento
	FROM 
		eventify.buffet b
	JOIN
		eventify.evento e ON e.id_buffet = b.id
	JOIN
		eventify.usuario c ON c.id = e.id_contratante
	ORDER BY
		e.data_criacao DESC
);


CREATE OR REPLACE VIEW eventify.vw_tarefas_proximas AS (
SELECT 
	t.id id_tarefa,
    b.id id_buffet,
	t.nome nome_tarefa,
    t.descricao descricao_tarefa,
    t.data_estimada data_estimada_tarefa,
    e.data data_evento,
    c.nome nome_contratante
FROM 
	tarefa t
JOIN
	bucket bu ON bu.id = t.id_bucket
JOIN
	buffet_servico bs ON bs.id = bu.id_buffet_servico
JOIN
	buffet b ON b.id = bs.id_buffet
JOIN
	evento e ON e.id = bu.id_evento
JOIN
	usuario c ON c.id = e.id_contratante
WHERE
	e.status = 5
ORDER BY data_estimada ASC LIMIT 3
);

CREATE OR REPLACE VIEW eventify.vw_tarefas_proximas_responsaveis AS (
SELECT 
	t.id id_tarefa,
    b.id id_buffet,
	t.nome nome_tarefa,
    t.descricao descricao_tarefa,
    t.data_estimada data_estimada_tarefa,
    e.data data_evento,
    c.nome nome_contratante,
    COALESCE(f.nome, executor_prop.nome) nome_executor
FROM 
	tarefa t
JOIN
	bucket bu ON bu.id = t.id_bucket
JOIN
	buffet_servico bs ON bs.id = bu.id_buffet_servico
JOIN
	buffet b ON b.id = bs.id_buffet
JOIN
	evento e ON e.id = bu.id_evento
JOIN
	usuario c ON c.id = e.id_contratante
JOIN
	executor_tarefa et ON et.id_tarefa = t.id
JOIN
	usuario executor_prop ON executor_prop.id = et.id_executor_funcionario
JOIN
	funcionario f ON et.id_executor_funcionario = f.id
WHERE
	e.status = 5
ORDER BY data_estimada
);


DELIMITER //
CREATE PROCEDURE eventify.sp_info_status(IN buffet_id INT)
BEGIN
    SELECT 
        subquery.status,
        subquery.quantidade,
        CASE
            WHEN subquery.status = 1 THEN 'Orçando'
            WHEN subquery.status = 2 THEN 'Recusado pelo Buffet'
            WHEN subquery.status = 3 THEN 'Orçado'
            WHEN subquery.status = 4 THEN 'Recusado pelo Contratante'
            WHEN subquery.status = 5 THEN 'Reservado'
            WHEN subquery.status = 6 THEN 'Realizado'
            WHEN subquery.status = 7 THEN 'Cancelado'
            ELSE 'Status Desconhecido'
        END AS status_traduzido,
        buffet.id AS id_buffet
    FROM 
        (SELECT 
            e.status,
            COUNT(e.id) AS quantidade
        FROM 
            eventify.buffet b
        JOIN
            eventify.evento e ON e.id_buffet = b.id
        WHERE 
            b.id = buffet_id
        GROUP BY
            e.status) AS subquery
    LEFT JOIN
        eventify.buffet buffet ON buffet.id = buffet_id
	ORDER BY status;
END //
DELIMITER ;



CREATE VIEW eventify.vw_contratos AS (
SELECT
	b.id id_buffet,
	c.nome,
    e.preco,
    e.data,
    e.status
FROM
	evento e
JOIN
    buffet b ON b.id = e.id_buffet
JOIN
	usuario c ON c.id = e.id_contratante
);



CREATE VIEW eventify.vw_calendario AS (
	SELECT
		b.id,
        e.data,
        e.preco,
        c.nome
	FROM
		buffet b
	JOIN
		evento e ON e.id_buffet = b.id
	JOIN
		usuario c ON c.id = e.id_contratante
	WHERE
		e.status = 6
);


CREATE VIEW vw_comparar_seis_meses AS (
SELECT TRADUZ_MES(MONTHNAME(data)) periodo, SUM(preco) renda
FROM evento
WHERE status = 6
AND YEAR(data) = YEAR(CURRENT_DATE())
AND MONTH(data) = MONTH(CURRENT_DATE())

UNION

SELECT TRADUZ_MES(MONTHNAME(data)) periodo, SUM(preco) renda
FROM evento
WHERE status = 6
AND YEAR(data) = YEAR(CURRENT_DATE() - INTERVAL 1 MONTH)
AND MONTH(data) = MONTH(CURRENT_DATE() - INTERVAL 1 MONTH)

UNION

SELECT TRADUZ_MES(MONTHNAME(data)) periodo, SUM(preco) renda
FROM evento
WHERE status = 6
AND YEAR(data) = YEAR(CURRENT_DATE() - INTERVAL 2 MONTH)
AND MONTH(data) = MONTH(CURRENT_DATE() - INTERVAL 2 MONTH)

UNION

SELECT TRADUZ_MES(MONTHNAME(data)) periodo, SUM(preco) renda
FROM evento
WHERE status = 6
AND YEAR(data) = YEAR(CURRENT_DATE() - INTERVAL 3 MONTH)
AND MONTH(data) = MONTH(CURRENT_DATE() - INTERVAL 3 MONTH)

UNION

SELECT TRADUZ_MES(MONTHNAME(data)) periodo, SUM(preco) renda
FROM evento
WHERE status = 6
AND YEAR(data) = YEAR(CURRENT_DATE() - INTERVAL 4 MONTH)
AND MONTH(data) = MONTH(CURRENT_DATE() - INTERVAL 4 MONTH)

UNION

SELECT TRADUZ_MES(MONTHNAME(data)) periodo, SUM(preco) renda
FROM evento
WHERE status = 6
AND YEAR(data) = YEAR(CURRENT_DATE() - INTERVAL 5 MONTH)
AND MONTH(data) = MONTH(CURRENT_DATE() - INTERVAL 5 MONTH));



CREATE OR REPLACE VIEW eventify.vw_avaliacoes_buffet_smart_sync AS (
SELECT
    id_buffet,
    ano,
    mes,
    mes_n,
    COUNT(id) qtd_acesso
FROM (
    SELECT
        e.id_buffet,
        DATE_FORMAT(e.data, '%Y') ano,
        TRADUZ_MES(DATE_FORMAT(e.data, '%M')) mes,
        DATE_FORMAT(e.data, '%m') mes_n,
        e.id
    FROM 
        eventify.evento e 
	JOIN
        eventify.buffet b ON e.id_buffet = b.id
    WHERE
        e.data >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
) subquery
GROUP BY
    id_buffet, ano, mes, mes_n
ORDER BY
    id_buffet, ano, mes_n ASC
);



CREATE OR REPLACE VIEW eventify.vw_eventos_por_secao AS ( 
SELECT 
	b.id id_buffet,
    bs.id id_buffet_servico,
    bck.id_evento,
    t.*
FROM 
	buffet b 
JOIN 
	buffet_servico bs ON bs.id_buffet = b.id
JOIN 
	bucket bck ON bck.id_buffet_servico = bs.id
JOIN 
	tarefa t ON t.id_bucket = bck.id
WHERE 
	t.is_visivel = 1
);



CREATE OR REPLACE VIEW eventify.vw_secoes AS (
SELECT 
	bs.id_buffet id_buffet,
    bck.id_evento id_evento,
    s.id id_servico,
    bck.id id_bucket,
    s.descricao nome_servico
FROM 
	buffet_servico bs
JOIN 
	bucket bck ON bck.id_buffet_servico = bs.id
JOIN
	servico s ON bs.id_servico = s.id
);


CREATE OR REPLACE VIEW eventify.vw_qtd_tarefas_status_eventos AS (
SELECT
    e.id AS id_evento,
    COUNT(CASE WHEN t.status = 3 THEN 1 END) AS tarefas_realizadas,
    COUNT(CASE WHEN t.status = 1 THEN 1 END) AS tarefas_pendentes,
    COUNT(CASE WHEN t.status = 2 THEN 1 END) AS tarefas_em_andamento
FROM
    evento e
    LEFT JOIN bucket b ON e.id = b.id_evento
    LEFT JOIN tarefa t ON b.id = t.id_bucket
GROUP BY
    e.id
);


CREATE OR REPLACE VIEW vw_listagem_proximos_eventos AS (
SELECT 
	ev.id_buffet,
	us.nome cliente,
    ev.id,
    ev.data,
    ev.status,
    vw.tarefas_realizadas,
    vw.tarefas_pendentes,
    vw.tarefas_em_andamento
FROM
	evento ev
JOIN
	usuario us ON us.id = ev.id_contratante
JOIN
	vw_qtd_tarefas_status_eventos vw ON vw.id_evento = ev.id
WHERE
	ev.status = 5
);



CREATE OR REPLACE VIEW eventify.vw_avaliacoes_buffet_usuario AS(
SELECT 
    usuario.nome,
    evento.nota,
    evento.avaliacao,
    evento.data,
    evento.id_buffet
FROM 
    evento
RIGHT JOIN
    usuario ON evento.id_contratante = usuario.id
WHERE
    evento.status = 6
);


CREATE OR REPLACE VIEW vw_flag_log_tarefa AS (
SELECT 
	bs.id id_secao,
    flog.id id_log,
    tsk.id id_tarefa,
    flog.data_criacao data_criacao_log,
    flog.id_funcionario,
    flog.id_usuario
FROM
	buffet_servico bs
JOIN
	bucket bck ON bck.id_buffet_servico = bs.id
JOIN
	tarefa tsk ON tsk.id_bucket = bck.id
JOIN
	flag_log flog ON flog.id_tarefa = tsk.id
LEFT JOIN
	funcionario fnc ON fnc.id = flog.id_funcionario
LEFT JOIN
	usuario us ON us.id = flog.id_funcionario
WHERE 
	bck.is_visivel = 1 AND 
    tsk.is_visivel = 1 AND 
    flog.is_visivel = 1
);

CREATE OR REPLACE VIEW vw_tarefas_por_usuario AS (
SELECT
	us.id id_usuario,
    fnc.id id_funcionario,
	tsk.*
FROM
	tarefa tsk
JOIN
	executor_tarefa ex ON ex.id_tarefa = tsk.id
LEFT JOIN
	usuario us ON us.id = ex.id_executor_usuario
LEFT JOIN
	funcionario fnc ON fnc.id = ex.id_executor_funcionario
);


CREATE OR REPLACE VIEW eventify.vw_qtd_tarefas_status_eventos_paginavel AS (
SELECT
    e.id AS id_evento,
    e.data,
    COUNT(CASE WHEN t.status = 3 THEN 1 END) AS tarefas_realizadas,
    COUNT(CASE WHEN t.status = 1 THEN 1 END) AS tarefas_pendentes,
    COUNT(CASE WHEN t.status = 2 THEN 1 END) AS tarefas_em_andamento,
    MAX(t.data_estimada)
FROM
    evento e
    LEFT JOIN bucket b ON e.id = b.id_evento
    LEFT JOIN tarefa t ON b.id = t.id_bucket
WHERE
	e.status = 5
GROUP BY
    e.id
);


CREATE OR REPLACE VIEW vw_status_eventos AS (
    SELECT
        id_buffet,
        id_evento,
        nome_cliente,
        data_evento,
        MAX(data_estimada) data_estimada,
        CAST(COUNT(CASE WHEN status = 3 THEN 1 END) AS SIGNED) AS tarefas_realizadas,
        CAST(COUNT(CASE WHEN status = 1 THEN 1 END) AS SIGNED) AS tarefas_pendentes,
        CAST(COUNT(CASE WHEN status = 2 THEN 1 END) AS SIGNED) AS tarefas_em_andamento
    FROM (
        SELECT
            bf.id id_buffet,
            evt.id id_evento,
            usr.nome nome_cliente,
            evt.data data_evento,
            tsk.data_estimada,
            tsk.status
        FROM
            buffet bf
        JOIN
            evento evt ON evt.id_buffet = bf.id
        JOIN 
            usuario usr ON usr.id = evt.id_contratante
        LEFT JOIN
            buffet_servico bs ON bs.id_buffet = bf.id
        JOIN
            bucket bck ON bck.id_buffet_servico = bs.id AND bck.id_evento = evt.id
        LEFT JOIN
            tarefa tsk ON tsk.id_bucket = bck.id
        WHERE
            evt.status = 5
    ) AS subconsulta
    GROUP BY id_evento
    ORDER BY data_evento
    LIMIT 5
);



SELECT * FROM vw_status_eventos;