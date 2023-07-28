DELIMITER //

CREATE PROCEDURE sp_kpi_conversao_de_visitantes(IN ultimos_meses INT)
BEGIN
	DECLARE data_referencia DATE;
    SET data_referencia = CURDATE() - INTERVAL IFNULL(ultimos_meses, 240) MONTH;
    
	SELECT registro.qtd_cadastrados , log.qtd_visitantes
	FROM 
		(SELECT 
			COUNT(id) qtd_cadastrados 
        FROM 
			eventify.usuario
        WHERE 
			usuario.data_criacao >= data_referencia) registro,
		(SELECT 
			COUNT(id) qtd_visitantes 
        FROM 
			eventify.acesso
        WHERE 
			acesso.id_pagina = 1
			AND acesso.data_criacao >= data_referencia) log;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE sp_kpi_precisao_do_formulario(IN ultimos_meses INT)
BEGIN
    DECLARE data_referencia DATE;
    SET data_referencia = CURDATE() - INTERVAL IFNULL(ultimos_meses, 240) MONTH;
    
	SELECT tratado.qtd qtd_contratos_formulario_dinamico, COUNT(registro.id) qtd_contratos_total 
    FROM 
		(SELECT 
			COUNT(id) qtd
		FROM 
			eventify.evento 
		WHERE 
			evento.is_formulario_dinamico
			AND evento.status = 5 
			OR evento.status = 6
			AND data >= data_referencia) tratado, eventify.evento registro;
END //

DELIMITER ;
    

DELIMITER //

CREATE PROCEDURE sp_kpi_conversao_de_reservas(IN ultimos_meses INT)
BEGIN
	DECLARE data_referencia DATE;
    SET data_referencia = CURDATE() - INTERVAL IFNULL(ultimos_meses, 240) MONTH;

	SELECT qtd_orcamentos_fechados, qtd_orcamentos_totais
    FROM
		(SELECT 
			COUNT(id) qtd_orcamentos_fechados
		FROM 
			eventify.evento
		WHERE evento.status = 5 
			OR evento.status = 6
			AND data_criacao >= data_referencia) fechados,
		(SELECT COUNT(id) qtd_orcamentos_totais
        FROM eventify.evento
        WHERE data_criacao >= data_referencia) totais;
		
END //

DELIMITER ;


SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER //

CREATE FUNCTION traduz_mes(mes VARCHAR(63)) RETURNS VARCHAR(63)
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


DELIMITER //

CREATE PROCEDURE sp_churn(IN ultimos_meses INT)
BEGIN
    DECLARE data_referencia DATE;
    SET data_referencia = DATE_SUB(CURDATE(), INTERVAL ultimos_meses MONTH);

    SELECT 
        traduz_mes(DATE_FORMAT(data_criacao, '%M')) AS mes,
        COUNT(CASE WHEN tipo_usuario = 2 AND data_criacao >= data_referencia THEN id END) AS prop_entraram,
        COUNT(CASE WHEN tipo_usuario = 2 AND ultimo_login < DATE_ADD(data_criacao, INTERVAL 2 MONTH) THEN id END) AS prop_sairam,
        COUNT(CASE WHEN tipo_usuario = 1 AND data_criacao >= data_referencia THEN id END) AS contr_entraram,
        COUNT(CASE WHEN tipo_usuario = 1 AND ultimo_login < DATE_ADD(data_criacao, INTERVAL 2 MONTH)  THEN id END) AS contr_sairam
    FROM 
        eventify.usuario 
    WHERE 
        (tipo_usuario = 1 OR tipo_usuario = 2) 
        AND (data_criacao >= data_referencia OR ultimo_login < data_referencia)
    GROUP BY 
        YEAR(data_criacao),
        MONTH(data_criacao)
    ORDER BY 
        YEAR(data_criacao),
        MONTH(data_criacao);
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE sp_log_paginas(IN ultimos_meses INT, IN id_pag INT)
BEGIN
    DECLARE data_referencia DATE;
    SET data_referencia = DATE_SUB(CURDATE(), INTERVAL ultimos_meses MONTH);
    
	SELECT 
		traduz_mes(DATE_FORMAT(data_criacao, '%M')) AS mes,
		COUNT(id) total_entraram
	FROM
		acesso
	WHERE
		acesso.data_criacao > DATE_SUB(data_criacao, INTERVAL 6 MONTH)
		AND acesso.id_pagina = id_pag
	GROUP BY
		MONTH(acesso.data_criacao);

END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE sp_retencao_usuarios_retidos(IN ultimos_meses INT)
BEGIN
    DECLARE data_referencia DATE;
    SET data_referencia = DATE_SUB(CURDATE(), INTERVAL ultimos_meses MONTH);
    
	SELECT
		traduz_mes(DATE_FORMAT(data_criacao, '%M')) AS mes,
		COUNT(id) total_retidos
	FROM
		usuario
	WHERE
		usuario.data_criacao > data_referencia
	GROUP BY 
		MONTH(usuario.data_criacao);

END //

DELIMITER ;



DELIMITER //

CREATE PROCEDURE sp_retencao_buffets_retidos(IN ultimos_meses INT)
BEGIN
    DECLARE data_referencia DATE;
    SET data_referencia = DATE_SUB(CURDATE(), INTERVAL ultimos_meses MONTH);
    
	SELECT
		traduz_mes(DATE_FORMAT(data_criacao, '%M')) AS mes,
		COUNT(id) total_retidos
	FROM
		buffet
	WHERE
		buffet.data_criacao > data_referencia
	GROUP BY 
		MONTH(buffet.data_criacao);
END //

DELIMITER ;



DELIMITER //

CREATE PROCEDURE sp_retencao_formularios_retidos(IN ultimos_meses INT)
BEGIN
    DECLARE data_referencia DATE;
    SET data_referencia = DATE_SUB(CURDATE(), INTERVAL ultimos_meses MONTH);
    
	SELECT
		traduz_mes(DATE_FORMAT(data_criacao, '%M')) AS mes,
		COUNT(id) total_retidos
	FROM
		evento
	WHERE
		evento.data_criacao > data_referencia
        AND evento.is_formulario_dinamico
	GROUP BY 
		MONTH(evento.data_criacao);
END //

DELIMITER ;




DELIMITER //

CREATE PROCEDURE sp_kpi_abandono_reserva(IN ultimos_meses INT, IN id_buf INT)
BEGIN
    DECLARE data_referencia DATE;
    SET data_referencia = DATE_SUB(CURDATE(), INTERVAL ultimos_meses MONTH);
    
	SELECT
		ab.abandonos,
		tot.total
	FROM
		(SELECT
			COUNT(id) abandonos
		FROM 
			evento
		WHERE
			status = 4
            AND id_buffet = id_buf
            AND data_criacao > data_referencia) ab,
		(SELECT
			COUNT(id) total
		FROM
			evento
		WHERE
			id_buffet = id_buf
            AND data_criacao > data_referencia
            AND status != 7) tot;
END //

DELIMITER ;



DELIMITER //

CREATE PROCEDURE sp_kpi_satisfacao(IN ultimos_meses INT, IN id_buf INT)
BEGIN
    DECLARE data_referencia DATE;
    SET data_referencia = DATE_SUB(CURDATE(), INTERVAL ultimos_meses MONTH);
    
	SELECT
		(ROUND(media, 1) * 2) media,
		total
	FROM
		(SELECT
			AVG(nota) media
		FROM 
			evento
		WHERE
			status = 6
            AND id_buffet = id_buf
            AND data_criacao > data_referencia) nt,
		(SELECT
			COUNT(nota) total
		FROM
			evento
		WHERE
			id_buffet = id_buf
            AND data_criacao > data_referencia
            AND status = 6) tot;
END //

DELIMITER ;




DELIMITER //

CREATE PROCEDURE sp_kpi_movimentacao_financeira(IN ultimos_meses INT, IN id_buf INT)
BEGIN
    DECLARE data_referencia DATE;
    SET data_referencia = DATE_SUB(CURDATE(), INTERVAL ultimos_meses MONTH);
    
	SELECT
		ROUND(valor_total, 2) movimentacao,
        total
	FROM
		(SELECT
			SUM(preco) valor_total
		FROM 
			evento
		WHERE
			status = 6
            AND id_buffet = id_buf
            AND data_criacao > data_referencia) nt,
		(SELECT
			COUNT(id) total
		FROM
			evento
		WHERE
			id_buffet = id_buf
            AND data_criacao > data_referencia
            AND status = 6) tot;
END //

DELIMITER ;




DELIMITER //

CREATE PROCEDURE sp_avaliacoes_buffet(IN ultimos_meses INT, IN id_buf INT)
BEGIN
    DECLARE data_referencia DATE;
    SET data_referencia = DATE_SUB(CURDATE(), INTERVAL ultimos_meses MONTH);
    
	SELECT DISTINCT
    usuario.nome,
    evento.nota,
    evento.avaliacao,
    evento.data
FROM
    evento
RIGHT JOIN
    usuario ON evento.id_contratante = usuario.id
WHERE
    evento.id_buffet = id_buf
    AND evento.data_criacao > data_referencia
    AND evento.status = 6;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE sp_dados_do_buffet(IN ultimos_meses INT, IN id_buf INT)
BEGIN
    DECLARE data_referencia DATE;
    SET data_referencia = DATE_SUB(CURDATE(), INTERVAL ultimos_meses MONTH);

    SELECT 
        traduz_mes(DATE_FORMAT(data, '%M')) AS mes,
        qtd_eventos,
        faturamento
    FROM 
		(SELECT 
			COUNT(id) qtd_eventos, SUM(preco) faturamento, data
		FROM
			evento
		WHERE
			evento.id_buffet = id_buf
			AND evento.status = 6
            AND data > data_referencia
		GROUP BY MONTH(data)) sub
		GROUP BY
			MONTH(data);
END //

DELIMITER ;



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


CREATE VIEW vw_buffet_info AS (
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

CREATE VIEW vw_buffet_pesquisa AS
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

CREATE VIEW vw_notas_buffet AS
SELECT id_buffet, ROUND(AVG(nota), 1) nota
FROM
	eventify.evento
GROUP BY id_buffet ORDER BY id_buffet;

-- ------- VALIDAÇÕES ---------------
CALL eventify.sp_avaliacoes_buffet(6, 1);
CALL eventify.sp_churn(6);
CALL eventify.sp_dados_do_buffet(6, 1);
CALL eventify.sp_kpi_abandono_reserva(6, 1);
CALL eventify.sp_kpi_conversao_de_reservas(6);
CALL eventify.sp_kpi_conversao_de_visitantes(6);
CALL eventify.sp_kpi_movimentacao_financeira(6, 1);
CALL eventify.sp_kpi_precisao_do_formulario(6);
CALL eventify.sp_kpi_satisfacao(6, 1);
CALL eventify.sp_log_paginas(6, 1);
CALL eventify.sp_retencao_buffets_retidos(6);
CALL eventify.sp_retencao_formularios_retidos(6);
CALL eventify.sp_retencao_usuarios_retidos(6);
SELECT eventify.haversine(-23.550520, -46.633308, -23.957410, -46.328250);
SELECT eventify.haversine(-23.550520, -46.633308, -30.034632, -30.034632);
SELECT * FROM eventify.vw_buffet_info WHERE tipos_evento LIKE '%casamento%';
SELECT * FROM eventify.vw_buffet_pesquisa;
SELECT * FROM eventify.vw_notas_buffet;
-- ------- VALIDAÇÕES ---------------
	SELECT descricao FROM tipo_evento ORDER BY descricao ASC;
/*
DROP PROCEDURE sp_avaliacoes_buffet;
DROP PROCEDURE sp_churn;
DROP PROCEDURE sp_dados_do_buffet;
DROP PROCEDURE sp_kpi_abandono_reserva;
DROP PROCEDURE sp_kpi_conversao_de_reservas;
DROP PROCEDURE sp_kpi_conversao_de_visitantes;
DROP PROCEDURE sp_kpi_movimentacao_financeira;
DROP PROCEDURE sp_kpi_precisao_do_formulario;
DROP PROCEDURE sp_kpi_satisfacao;
DROP PROCEDURE sp_log_paginas;
DROP PROCEDURE sp_retencao_buffets_retidos;
DROP PROCEDURE sp_retencao_formularios_retidos;
DROP PROCEDURE sp_retencao_usuarios_retidos;
DROP FUNCTION traduz_mes;
*/
