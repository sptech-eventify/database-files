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
    ORDER BY data ASC;
END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE eventify.sp_proximo_evento(IN buffet_id INT)
BEGIN
	SELECT 
		u.nome, e.data
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
