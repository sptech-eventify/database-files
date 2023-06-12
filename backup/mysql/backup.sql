-- -----------------------------------------------------
-- Schema eventify
-- -----------------------------------------------------
DROP DATABASE IF EXISTS eventify;
CREATE SCHEMA IF NOT EXISTS `eventify` DEFAULT CHARACTER SET utf8 ;
USE `eventify` ;

-- -----------------------------------------------------
-- Table `eventify`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(64) NOT NULL,
  `email` VARCHAR(256) NOT NULL,
  `senha` VARCHAR(256) NOT NULL,
  `tipo_usuario` INT(3) UNSIGNED NOT NULL,
  `is_ativo` TINYINT UNSIGNED NOT NULL,
  `is_banido` TINYINT UNSIGNED NULL,
  `cpf` CHAR(11) NULL,
  `foto` VARCHAR(255) NULL,
  `data_criacao` DATETIME NULL,
  `ultimo_login` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`endereco` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `is_validado` TINYINT NULL,
  `logradouro` VARCHAR(64) NOT NULL,
  `numero` INT NULL,
  `bairro` VARCHAR(32) NOT NULL,
  `cidade` VARCHAR(63) NULL,
  `uf` CHAR(2) NOT NULL,
  `cep` CHAR(8) NOT NULL,
  `latitude` DECIMAL(8,6) NOT NULL,
  `longitude` DECIMAL(8,6) NOT NULL,
  `data_criacao` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`buffet`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`buffet` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(123) NOT NULL,
  `descricao` VARCHAR(511) NOT NULL,
  `tamanho` INT NOT NULL,
  `preco_medio_diaria` DECIMAL(6,2) NOT NULL,
  `qtd_pessoas` INT UNSIGNED NOT NULL,
  `caminho_comprovante` VARCHAR(64) NULL,
  `residencia_comprovada` TINYINT NOT NULL,
  `is_visivel` TINYINT NOT NULL,
  `data_criacao` DATETIME NULL,
  `id_usuario` INT NOT NULL,
  `id_endereco` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_buffet_usuario1_idx` (`id_usuario` ASC) VISIBLE,
  INDEX `fk_buffet_endereco1_idx` (`id_endereco` ASC) VISIBLE,
  CONSTRAINT `fk_buffet_usuario1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `eventify`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_buffet_endereco1`
    FOREIGN KEY (`id_endereco`)
    REFERENCES `eventify`.`endereco` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`mensagem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`mensagem` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `mensagem` VARCHAR(511) NOT NULL,
  `mandado_por` TINYINT NULL,
  `data` DATETIME NOT NULL,
  `id_usuario` INT NOT NULL,
  `id_buffet` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_mensagem_usuario1_idx` (`id_usuario` ASC) VISIBLE,
  INDEX `fk_mensagem_buffet1_idx` (`id_buffet` ASC) VISIBLE,
  CONSTRAINT `fk_mensagem_usuario1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `eventify`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_mensagem_buffet1`
    FOREIGN KEY (`id_buffet`)
    REFERENCES `eventify`.`buffet` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`agenda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`agenda` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data` DATETIME NOT NULL,
  `id_buffet` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_reserva_residencias1_idx` (`id_buffet` ASC) VISIBLE,
  CONSTRAINT `fk_reserva_residencias1`
    FOREIGN KEY (`id_buffet`)
    REFERENCES `eventify`.`buffet` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`faixa_etaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`faixa_etaria` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(16) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `descricao_UNIQUE` (`descricao` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`tipo_evento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`tipo_evento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(16) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`servico` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(16) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `descricao_UNIQUE` (`descricao` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`pagamento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `is_pago_contrato` TINYINT NOT NULL,
  `data_pago` DATETIME NOT NULL,
  `is_pago_buffet` TINYINT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`evento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`evento` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data` DATETIME NULL,
  `preco` DECIMAL(6,2) NULL,
  `avaliacao` VARCHAR(511) NULL,
  `nota` DOUBLE(2,1) NULL,
  `status` INT(8) NULL,
  `motivo_nao_aceito` VARCHAR(511) NULL,
  `is_formulario_dinamico` BIT NULL,
  `data_criacao` DATETIME NULL,
  `id_buffet` INT NOT NULL,
  `id_contratante` INT NOT NULL,
  `id_pagamento` INT NULL,
  INDEX `fk_evento_buffet1_idx` (`id_buffet` ASC) VISIBLE,
  UNIQUE INDEX `fk_evento_pagamento1_idx` (`id`, `id_pagamento`) VISIBLE,
  INDEX `fk_evento_usuario1_idx` (`id_contratante` ASC) VISIBLE,
  CONSTRAINT `fk_evento_buffet1`
    FOREIGN KEY (`id_buffet`)
    REFERENCES `eventify`.`buffet` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_evento_usuario1`
    FOREIGN KEY (`id_contratante`)
    REFERENCES `eventify`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_evento_pagamento1`
    FOREIGN KEY (`id_pagamento`)
    REFERENCES `eventify`.`pagamento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `eventify`.`buffet_faixa_etaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`buffet_faixa_etaria` (
  `id_buffet` INT NOT NULL,
  `id_faixa_etaria` INT NOT NULL,
  PRIMARY KEY (`id_buffet`, `id_faixa_etaria`),
  INDEX `fk_buffet_has_faixa_etaria_faixa_etaria1_idx` (`id_faixa_etaria` ASC) VISIBLE,
  INDEX `fk_buffet_has_faixa_etaria_buffet1_idx` (`id_buffet` ASC) VISIBLE,
  CONSTRAINT `fk_buffet_has_faixa_etaria_buffet1`
    FOREIGN KEY (`id_buffet`)
    REFERENCES `eventify`.`buffet` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_buffet_has_faixa_etaria_faixa_etaria1`
    FOREIGN KEY (`id_faixa_etaria`)
    REFERENCES `eventify`.`faixa_etaria` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`buffet_tipo_evento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`buffet_tipo_evento` (
  `id_buffet` INT NOT NULL,
  `id_tipo_evento` INT NOT NULL,
  PRIMARY KEY (`id_buffet`, `id_tipo_evento`),
  INDEX `fk_buffet_has_tipo_evento_tipo_evento1_idx` (`id_tipo_evento` ASC) VISIBLE,
  INDEX `fk_buffet_has_tipo_evento_buffet1_idx` (`id_buffet` ASC) VISIBLE,
  CONSTRAINT `fk_buffet_has_tipo_evento_buffet1`
    FOREIGN KEY (`id_buffet`)
    REFERENCES `eventify`.`buffet` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_buffet_has_tipo_evento_tipo_evento1`
    FOREIGN KEY (`id_tipo_evento`)
    REFERENCES `eventify`.`tipo_evento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`buffet_servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`buffet_servico` (
  `id_buffet` INT NOT NULL,
  `id_servico` INT NOT NULL,
  PRIMARY KEY (`id_buffet`, `id_servico`),
  INDEX `fk_buffet_has_servico_servico1_idx` (`id_servico` ASC) VISIBLE,
  INDEX `fk_buffet_has_servico_buffet1_idx` (`id_buffet` ASC) VISIBLE,
  CONSTRAINT `fk_buffet_has_servico_buffet1`
    FOREIGN KEY (`id_buffet`)
    REFERENCES `eventify`.`buffet` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_buffet_has_servico_servico1`
    FOREIGN KEY (`id_servico`)
    REFERENCES `eventify`.`servico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`imagem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`imagem` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `caminho` VARCHAR(255) NULL,
  `nome` VARCHAR(255) NULL,
  `tipo` VARCHAR(4) NULL,
  `is_ativo` TINYINT NULL,
  `data_upload` DATETIME NULL,
  `id_buffet` INT NOT NULL,
  INDEX `fk_imagem_buffet1_idx` (`id_buffet` ASC) VISIBLE,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_imagem_buffet1`
    FOREIGN KEY (`id_buffet`)
    REFERENCES `eventify`.`buffet` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`notificacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`notificacao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(511) NULL,
  `data_criacao` DATETIME NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_notificacao_usuario1_idx` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_notificacao_usuario1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `eventify`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`imagem_chat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`imagem_chat` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `caminho` VARCHAR(256) NOT NULL,
  `nome` VARCHAR(32) NOT NULL,
  `tipo` VARCHAR(4) NOT NULL,
  `is_ativo` TINYINT NOT NULL,
  `data_upload` DATETIME NOT NULL,
  `id_mensagem` INT NOT NULL,
  PRIMARY KEY (`id`, `id_mensagem`),
  INDEX `fk_imagem_chat_mensagem1_idx` (`id_mensagem` ASC) VISIBLE,
  CONSTRAINT `fk_imagem_chat_mensagem1`
    FOREIGN KEY (`id_mensagem`)
    REFERENCES `eventify`.`mensagem` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`pagina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`pagina` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(63) NOT NULL,
  `uri` VARCHAR(63) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`acesso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`acesso` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_criacao` DATETIME NOT NULL,
  `id_pagina` INT NOT NULL,
  PRIMARY KEY (`id`),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_log_de_acesso_pagina1_idx` (`id_pagina` ASC) VISIBLE,
  CONSTRAINT `fk_log_de_acesso_pagina1`
    FOREIGN KEY (`id_pagina`)
    REFERENCES `eventify`.`pagina` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE eventify;

-- APENAS EXECUTE CASO VOCÊ NÃO TENHA O USUÁRIO NO SEU BANCO
-- CREATE USER 'backend_eventify'@'%' IDENTIFIED BY 'evenCCD834E1tify';

-- APENAS EXECUTE CASO VOCÊ TENHA UTILIZADO O SCRIPT COM AS PERMISSÕES ANTIGAS ALTER
-- OU TENHA DELETADO / ADICIONADO NOVAS TABELAS
-- REVOKE ALL PRIVILEGES ON eventify.* FROM 'backend_eventify'@'%';

GRANT INSERT, SELECT, UPDATE, DELETE ON eventify.* TO 'backend_eventify'@'%';

FLUSH PRIVILEGES;

USE eventify;

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
    IFNULL(ROUND(AVG(evento.nota), 1), 0) nota_media,
    GROUP_CONCAT(DISTINCT CONCAT(imagem.caminho, imagem.nome, '.', imagem.tipo) SEPARATOR ',') caminho
FROM
	eventify.buffet
LEFT JOIN eventify.evento 
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

GRANT EXECUTE ON PROCEDURE eventify.sp_avaliacoes_buffet TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_churn TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_dados_do_buffet TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_kpi_abandono_reserva TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_kpi_conversao_de_reservas TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_kpi_conversao_de_visitantes TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_kpi_movimentacao_financeira TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_kpi_precisao_do_formulario TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_kpi_satisfacao TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_log_paginas TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_retencao_buffets_retidos TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_retencao_formularios_retidos TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_retencao_usuarios_retidos TO 'backend_eventify'@'%';

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
CALL eventify.sp_log_paginas(6, 3);
CALL eventify.sp_retencao_buffets_retidos(6);
CALL eventify.sp_retencao_formularios_retidos(6);
CALL eventify.sp_retencao_usuarios_retidos(6);
SELECT eventify.haversine(-23.550520, -46.633308, -23.957410, -46.328250);
SELECT eventify.haversine(-23.550520, -46.633308, -30.034632, -30.034632);
SELECT * FROM eventify.vw_buffet_info;
SELECT * FROM eventify.vw_buffet_pesquisa;
SELECT * FROM eventify.vw_notas_buffet;

-- ------- VALIDAÇÕES ---------------
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
DROP FUNCTION haversine;
DROP VIEW vw_buffet_info;
DROP VIEW vw_buffet_pesquisa;
DROP VIEW vw_notas_buffet;
*/

-- Proprietários de Dezembro
INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login, foto) VALUE
('João Silva', 'joao.silva@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '12345678901', '2022-12-01 09:15:00', '2023-01-15 18:30:00', 
'https://sm.askmen.com/askmen_in/article/f/facebook-p/facebook-profile-picture-affects-chances-of-gettin_fr3n.jpg');

INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES
('Leonardo Vasconcelos', 'leonardo.paulino@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '98765432109', '2022-12-12 14:20:00', '2022-12-15 21:45:00'),
('Pedro Oliveira', 'pedro.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '23456789012', '2022-12-11 10:10:00', '2023-03-16 08:00:00'),
('Ana Souza', 'ana.souza@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2022-12-02 13:25:00', '2023-05-16 12:30:00'),
('Carlos Silva', 'carlos.silva@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '09876543210', '2022-12-03 11:35:00', '2023-01-16 09:45:00'),
('Juliana Oliveira', 'juliana.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '34567890123', '2022-12-04 16:50:00', '2023-04-17 14:15:00'),
('Fernando Santos', 'fernando.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '56789012345', '2022-12-05 12:40:00', '2022-12-17 18:30:00'),
('Mariana Souza', 'mariana.souza@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '87654321098', '2022-12-06 15:55:00', '2022-12-18 07:30:00'),
('Rafaela Silva', 'rafaela.silva@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '32109876543', '2022-12-07 09:25:00', '2023-03-20 10:45:00'),
('Gustavas Oliveira', 'gustaas.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '67894523456', '2022-12-08 14:00:00', '2023-04-19 16:00:00'),
('Camila Santos', 'camila.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '21098765432', '2022-12-09 10:55:00', '2022-12-19 20:15:00'),
('Lucas Souza', 'lucas.souza@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '43210987654', '2022-12-10 13:10:00', '2022-12-20 11:30:00'),
('Amanda Silva', 'amanda.silva@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2022-12-13 15:30:00', '2022-12-20 14:45:00');


-- Proprietários de Janeiro
INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES
('Roberto Oliveira', 'roberto.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '87654321098', '2023-01-14 10:20:00', '2023-01-21 09:00:00'),
('Isabela Santos', 'isabela.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '09876543210', '2023-01-15 13:35:00', '2023-01-21 12:15:00'),
('Marcelo Souza', 'marcelo.souza@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '32109876543', '2023-01-16 08:05:00', '2023-04-22 17:30:00'),
('Patrícia Silva', 'patricia.silva@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '54321098765', '2023-01-17 11:20:00', '2023-01-22 20:45:00'),
('Ricardo Oliveira', 'ricardo.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '76543210987', '2023-01-18 09:10:00', '2023-03-23 14:00:00'),
('Laura Santos', 'laura.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '10987654321', '2023-01-19 12:25:00', '2023-01-23 18:15:00'),
('Vitor Souza', 'vitor.souza@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '43210987654', '2023-01-20 15:40:00', '2023-05-24 07:30:00'),
('Cristina Silva', 'cristina.silva@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2023-01-21 10:30:00', '2023-05-24 10:45:00'),
('Carlos Santos', 'carlos.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '34567890123', '2023-01-01 16:45:00', '2023-01-16 15:15:00'),
('Fernanda Lima', 'fernanda.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '54321678901', '2023-01-02 11:30:00', '2023-01-16 09:45:00'),
('Gustavo Ferreira', 'gustavo.ferreira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2023-01-03 09:15:00', '2023-01-17 18:30:00'),
('Patrícia Costa', 'patricia.costa@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '09876543210', '2023-01-04 14:20:00', '2023-02-18 21:45:00'),
('Lucas Carvalho', 'lucas.carvalho@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '21098765432', '2023-01-05 10:10:00', '2023-01-19 08:00:00'),
('Amanda Rodrigues', 'amanda.rodrigues@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '32109876543', '2023-01-06 13:25:00', '2023-01-20 12:30:00'),
('Rafaela Almeida', 'rafaela.almeida@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '43210987654', '2023-01-07 11:35:00', '2023-01-21 09:45:00'),
('Mariana Costa', 'mariana.costa@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '54321098765', '2023-01-08 16:50:00', '2023-01-22 14:15:00'),
('José Santos', 'jose.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2023-01-09 12:40:00', '2023-02-23 18:30:00'),
('Laura Fernandes', 'laura.fernandes@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '76543210987', '2023-01-10 15:55:00', '2023-01-24 07:30:00');


-- Proprietários de Fevereiro
INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES
('Pedro Alves', 'pedro.alves@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '87654321098', '2023-02-11 09:25:00', '2023-02-25 10:45:00'),
('Camila Rodrigues', 'camila.rodrigues@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '98765432109', '2023-02-12 14:00:00', '2023-02-26 16:00:00'),
('Ricardo Lima', 'ricardo.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '10987654321', '2023-02-13 10:50:00', '2023-02-27 20:15:00'),
('Aline Oliveira', 'aline.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '12345678901', '2023-02-14 12:05:00', '2023-03-28 07:30:00'),
('Juliana Silva', 'juliana.silva@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '23456789012', '2023-02-15 15:20:00', '2023-02-27 10:45:00'),
('Gustavo Almeida', 'gustavo.almeida@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '34567890123', '2023-02-16 11:10:00', '2023-02-27 14:00:00'),
('Letícia Souza', 'leticia.souza@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '45678901234', '2023-02-17 14:25:00', '2023-03-01 18:15:00'),
('Fernando Santastico', 'fernando.santastico@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '56789012345', '2023-02-18 09:55:00', '2023-03-02 07:30:00'),
('Carolina Costa', 'carolina.costa@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '67890123456', '2023-02-19 12:10:00', '2023-02-25 10:45:00'),
('André Oliveira', 'andre.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '78901234567', '2023-02-20 15:25:00', '2023-02-26 14:00:00'),
('Amanda Alves', 'amanda.alves@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '89012345678', '2023-02-21 13:15:00', '2023-05-22 18:15:00'),
('Fernando Souza', 'fernando.souza@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '90123456789', '2023-02-22 10:30:00', '2023-03-06 07:30:00'),
('Rafaela Lima', 'rafaela.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '01234567890', '2023-02-23 14:45:00', '2023-03-07 10:45:00');


-- Proprietários de Março
INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES
('Rafaela Costa', 'rafaela.costa@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '43210987654', '2023-03-01 17:20:00', '2023-03-16 14:00:00'),
('José Almeida', 'jose.almeida@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '32109876543', '2023-03-02 08:40:00', '2023-03-16 10:30:00'),
('Mariana Oliveira', 'mariana.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '21098765432', '2023-03-03 12:05:00', '2023-03-16 13:45:00'),
('Ana Clara', 'ana.clara@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '10987654321', '2023-03-04 15:15:00', '2023-03-16 17:30:00'),
('Lucas Santos', 'lucas.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '98765432109', '2023-03-05 09:30:00', '2023-04-17 18:30:00'),
('Carolina Souza', 'carolina.souza@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '87654321098', '2023-03-06 13:45:00', '2023-03-18 21:45:00'),
('Pedro Rodrigues', 'pedro.rodrigues@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '76543210987', '2023-03-07 10:10:00', '2023-03-19 08:00:00'),
('Isabela Lima', 'isabela.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2023-03-08 13:25:00', '2023-03-20 12:30:00'),
('Gustavo Oliveira', 'gustavo.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '54321098765', '2023-03-09 11:35:00', '2023-03-21 09:45:00'),
('Amanda Almeida', 'amanda.almeida@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '43210987654', '2023-03-10 16:50:00', '2023-03-22 14:15:00'),
('Rafael Silva', 'rafael.silva@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '32109876543', '2023-03-11 12:40:00', '2023-03-23 18:30:00'),
('Fernanda Costa', 'fernanda.costa@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '21098765432', '2023-03-12 15:55:00', '2023-03-24 21:45:00');


-- Proprietários de Abril
INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES
('Henrique Santos', 'henrique.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '10987654321', '2023-04-13 09:05:00', '2023-05-25 08:00:00'),
('Larissa Oliveira', 'larissa.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '09876543210', '2023-04-14 12:20:00', '2023-04-26 12:30:00'),
('Mateus Rodrigues', 'mateus.rodrigues@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '98765432109', '2023-04-15 10:30:00', '2023-04-27 16:45:00'),
('Laura Lima', 'laura.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '87654321098', '2023-03-16 14:45:00', '2023-04-16 19:00:00'),
('Guilherme Souza', 'guilherme.souza@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '76543210987', '2023-04-17 11:00:00', '2023-04-18 08:15:00'),
('Camila Oliveira', 'camila.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2023-04-18 15:15:00', '2023-05-16 11:30:00'),
('Leonardo Santos', 'leonardo.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '54321098765', '2023-04-19 12:30:00', '2023-04-20 14:45:00'),
('Juliana Rodrigues', 'juliana.rodrigues@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '43210987654', '2023-04-20 09:45:00', '2023-05-16 18:00:00'),
('Gabriel Lima', 'gabriel.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '32109876543', '2023-04-21 14:00:00', '2023-04-22 09:15:00'),
('Letícia Costa', 'leticia.costa@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '21098765432', '2023-04-22 11:15:00', '2023-04-23 12:30:00');


-- Proprietários de Maio
INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES
('Mariana Sol', 'mariana.sol@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '09876543210', '2023-05-17 12:45:00', '2023-05-16 11:15:00'),
('Pedro Alvaro', 'pedro.alvaro@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '98765432109', '2023-05-18 16:00:00', '2023-05-16 13:30:00'),
('Camila Lima', 'camila.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '87654321098', '2023-05-19 09:15:00', '2023-05-16 15:45:00'),
('Gustavo Martins', 'gustavo.martins@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '76543210987', '2023-05-20 12:30:00', '2023-05-16 09:00:00'),
('Ana Oliveira', 'ana.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2023-05-21 15:45:00', '2023-05-16 11:15:00'),
('Rodrigo Santos', 'rodrigo.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '54321098765', '2023-05-22 09:00:00', '2023-05-16 13:30:00'),
('Carolina Rodrigues', 'carolina.rodrigues@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '43210987654', '2023-05-23 12:15:00', '2023-05-16 15:45:00'),
('Bruno Ferreira', 'bruno.ferreira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '32109876543', '2023-05-24 15:30:00', '2023-05-16 18:00:00'),
('Letícia Martins', 'leticia.martins@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '21098765432', '2023-05-25 08:45:00', '2023-05-16 09:15:00'),
('Vitor Oliveira', 'vitor.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '10987654321', '2023-05-26 12:00:00', '2023-05-16 11:30:00'),
('Gabriela Souza', 'gabriela.souza@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '09876543210', '2023-05-27 15:15:00', '2023-05-16 13:45:00'),
('Lucas Mend', 'lucas.mend@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '98765432109', '2023-05-28 08:30:00', '2023-05-16 16:00:00'),
('Gustavo Sol', 'gustavo.sol@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '87654321098', '2023-05-29 11:45:00', '2023-05-16 09:15:00'),
('Isabela Rodrigue', 'isabela.rodrigue@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '76543210987', '2023-05-30 15:00:00', '2023-05-16 11:30:00'),
('Rodrigo Santino', 'rodrigo.santino@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2023-05-01 10:00:00', '2023-05-16 11:30:00'),
('Laura Almeida', 'laura.almeida@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '54321098765', '2023-05-02 13:15:00', '2023-05-16 14:45:00'),
('Felipe Lima', 'felipe.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '43210987654', '2023-05-03 16:30:00', '2023-05-16 18:00:00'),
('Ana Rodrigues', 'ana.rodrigues@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '32109876543', '2023-05-04 09:45:00', '2023-05-16 09:15:00'),
('Gabriela Silva', 'gabriela.silva@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '21098765432', '2023-05-05 13:00:00', '2023-05-16 12:30:00'),
('Rafael Oliveira', 'rafael.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '10987654321', '2023-05-06 16:15:00', '2023-05-16 15:45:00'),
('Isabella Fernandes', 'isabella.fernandes@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '09876543210', '2023-05-07 09:30:00', '2023-05-16 09:00:00'),
('Lucas Martins', 'lucas.martins@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '98765432109', '2023-05-08 12:45:00', '2023-05-16 11:15:00'),
('Mariana Sousa', 'mariana.sousa@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '87654321098', '2023-05-09 16:00:00', '2023-05-16 13:30:00'),
('Guilherme Santos', 'guilherme.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '76543210987', '2023-05-10 09:15:00', '2023-05-16 15:45:00'),
('Camila Oliveiras', 'camila.oliveiras@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2023-05-11 12:30:00', '2023-05-16 09:00:00'),
('Fernando Limao', 'fernando.limao@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '54321098765', '2023-05-12 15:45:00', '2023-05-16 11:15:00'),
('Larissa Ferreira', 'larissa.ferreira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '43210987654', '2023-05-13 09:00:00', '2023-05-16 13:30:00'),
('Pedro Almeida', 'pedro.almeida@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '32109876543', '2023-05-14 12:15:00', '2023-05-16 15:45:00'),
('Vitória Santos', 'vitoria.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '21098765432', '2023-05-15 15:30:00', '2023-05-16 09:00:00'),
('Ricardo Rodrigues', 'ricardo.rodrigues@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '10987654321', '2023-05-16 09:45:00', '2023-05-16 11:15:00'),
('Amanda Silvas', 'amanda.silvas@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '09876543210', '2023-05-17 13:00:00', '2023-05-16 13:30:00'),
('Thiago Oliveira', 'thiago.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '98765432109', '2023-05-18 16:15:00', '2023-05-16 15:45:00'),
('Carolina Fernandes', 'carolina.fernandes@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '87654321098', '2023-05-19 09:30:00', '2023-05-16 09:00:00'),
('Gustavo Santos', 'gustavo.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '76543210987', '2023-05-20 12:45:00', '2023-05-16 11:15:00'),
('Larissa Lima', 'larissa.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2023-05-21 16:00:00', '2023-05-16 13:30:00'),
('Vinicius Ferreira', 'vinicius.ferreira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '54321098765', '2023-05-22 09:15:00', '2023-05-16 15:45:00');


-- Contratantes de Dezembro
INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login, foto) VALUE
('Isabela Martins', 'isabela.martins@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2022-12-23 12:30:00', '2023-01-16 09:00:00',
'https://t4.ftcdn.net/jpg/03/30/25/97/360_F_330259751_tGPEAq5F5bjxkkliGrb97X2HhtXBDc9x.jpg');

INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES
('Felipe Sousa', 'felipe.sousa@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2022-12-24 15:45:00', '2022-12-28 11:15:00'),
('Mariana Silva', 'mariana.silva@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2022-12-25 09:00:00', '2022-12-28 13:30:00'),
('Rafael Almeida', 'rafael.almeida@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2022-12-26 12:15:00', '2022-12-28 15:45:00'),
('Gabriel Rodrigues', 'gabriel.rodrigues@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '09876543210', '2022-12-27 15:30:00', '2022-12-28 09:00:00'),
('Ana Santos', 'ana.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2022-12-28 09:45:00', '2022-12-28 11:15:00'),
('Gustavo Lima', 'gustavo.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2022-12-01 13:00:00', '2023-02-16 13:30:00'),
('Carolina Oliveira', 'carolina.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2022-12-30 16:15:00', '2022-12-31 15:45:00'),
('Rafaela Oliveira', 'rafaela.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2022-12-13 09:05:00', '2022-12-28 13:30:00'),
('Isabel Santos', 'isabel.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2022-12-14 12:20:00', '2022-12-16 15:45:00'),
('Matheus Almeida', 'matheus.almeida@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2022-12-16 15:35:00', '2022-12-16 17:00:00'),
('Juliana Lima', 'juliana.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '09876543210', '2022-12-17 10:50:00', '2022-12-28 15:30:00'),
('Lucas Ferreira', 'lucas.ferreira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2022-12-18 13:05:00', '2022-12-21 17:15:00'),
('Maria Oliveira', 'maria.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2022-12-19 09:20:00', '2023-03-24 13:30:00'),
('Pedro Sousa', 'pedro.sousa@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2022-12-20 12:35:00', '2022-12-21 15:45:00'),
('Camila Rodrigo', 'camila.rodrigo@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2022-12-21 15:50:00', '2022-12-22 17:00:00'),
('Thiago Ferreira', 'thiago.ferreira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2022-12-22 11:05:00', '2022-12-25 15:30:00'),
('Amanda Martins', 'amanda.martins@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2022-12-23 14:20:00', '2022-12-26 17:15:00'),
('Gabriel Santos', 'gabriel.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2022-12-24 09:35:00', '2022-12-28 13:30:00'),
('Ana Lima', 'ana.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2022-12-25 12:50:00', '2022-12-28 15:45:00'),
('Gustavo Alm', 'gustavo.alm@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2022-12-26 16:05:00', '2022-12-29 17:00:00'),
('Carol Oliveira', 'carol.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '09876543210', '2022-12-27 10:20:00', '2023-01-16 15:30:00'),
('Ricardo Rodrigua', 'ricardo.rodrigua@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2022-12-28 13:35:00', '2022-12-28 17:15:00'),
('Julia Oliveira', 'julia.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2022-12-29 09:50:00', '2022-12-30 13:30:00'),
('Marcelo Sousa', 'marcelo.sousa@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2022-12-30 13:05:00', '2022-12-31 15:45:00'),
('Laura Martins', 'laura.martins@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2022-12-31 10:20:00', '2023-04-16 17:00:00'),
('Felipe Ferreira', 'felipe.ferreira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2022-12-01 14:35:00', '2022-12-16 15:30:00'),
('Mariana Santo', 'mariana.santo@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2022-12-02 09:50:00', '2022-12-16 17:15:00'),
('Rodrigo Lima', 'rodrigo.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2022-12-03 13:05:00', '2022-12-16 13:30:00');


-- Contratantes de Janeiro
INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES
('Gabriela Almeida', 'gabriela.almeida@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '21098765432', '2023-01-04 16:20:00', '2023-01-16 15:45:00'),
('Lucas Santo', 'lucas.santo@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '10987654321', '2023-01-05 10:35:00', '2023-01-16 17:00:00'),
('Isabella Oliveira', 'isabella.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '09876543210', '2023-01-06 13:50:00', '2023-01-16 15:30:00'),
('Mateus Sousa', 'mateus.sousa@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '98765432109', '2023-01-07 09:05:00', '2023-01-16 17:15:00'),
('Juliana Martines', 'juliana.martines@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '87654321098', '2023-01-08 12:20:00', '2023-02-16 13:30:00'),
('Pedro Lima', 'pedro.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '76543210987', '2023-01-09 15:35:00', '2023-01-16 15:45:00'),
('Camila Almeida', 'camila.almeida@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2023-01-10 10:50:00', '2023-01-16 17:00:00'),
('Thiago Ferrier', 'thiago.ferriera@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '54321098765', '2023-01-11 14:05:00', '2023-02-16 15:30:00'),
('Amanda Santos', 'amanda.santos@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '43210987654', '2023-01-12 09:20:00', '2023-01-16 17:15:00'),
('Gabriel Lins', 'gabriel.lins@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '32109876543', '2023-01-13 12:35:00', '2023-05-16 13:30:00'),
('Ana Almeida', 'ana.almeida@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '21098765432', '2023-01-14 15:50:00', '2023-01-16 15:45:00'),
('Lucas Rodrigues', 'lucas.rodrigues@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '10987654321', '2023-01-15 11:05:00', '2023-01-16 17:00:00'),
('Isabela Oliveira', 'isabela.oliveira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '09876543210', '2023-01-16 14:20:00', '2023-01-16 15:30:00'),
('Mateus Souli', 'mateus.souli@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '98765432109', '2023-01-17 09:35:00', '2023-01-30 17:15:00'),
('Juliana Martina', 'juliana.martina@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '87654321098', '2023-01-18 12:50:00', '2023-02-16 13:30:00'),
('Pedri Lima', 'pedri.lima@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '76543210987', '2023-01-19 16:05:00', '2023-01-30 15:45:00'),
('Camila Almaida', 'camila.almaida@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2023-01-20 10:20:00', '2023-01-30 17:00:00'),
('Thiagui Ferreira', 'thiagui.ferreira@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '54321098765', '2023-01-21 13:35:00', '2023-01-30 15:30:00'),
('Amanda Klein Santos', 'amanda.klein@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '43210987654', '2023-01-22 09:50:00', '2023-01-30 17:15:00'),
('Gabriel Limae', 'gabriel.limae@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '32109876543', '2023-01-23 13:05:00', '2023-01-30 13:30:00'),
('Ana Almeida', 'ana.almeideiros@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '21098765432', '2023-01-24 16:20:00', '2023-02-16 15:45:00'),
('Lucas Rodrigues', 'lucas.rodrigues1@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '10987654321', '2023-01-25 11:35:00', '2023-01-30 17:00:00'),
('Isabela Oliveira', 'isabela.oliveira3@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '09876543210', '2023-01-26 14:50:00', '2023-01-30 15:30:00'),
('Mateus Souza', 'mateus.souza_as@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '98765432109', '2023-01-27 09:05:00', '2023-01-30 17:15:00'),
('Juliana Martin', 'juliana.martin@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '87654321098', '2023-01-28 12:20:00', '2023-01-30 13:30:00'),
('Pedro Lima', 'pedro.lima@hotmail.com', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '76543210987', '2023-01-29 15:35:00', '2023-01-30 15:45:00'),
('Camila Almeida', 'camila.almeida@outlook.com', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '65432109876', '2023-01-30 10:50:00', '2023-01-30 17:00:00'),
('Thiago Ferreira', 'thiago.ferreira@gmail.com', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '54321098765', '2023-01-31 14:05:00', '2023-02-16 15:30:00'),
('Amanda Santos', 'amanda.santos@ferg.com', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '43210987654', '2023-01-01 09:20:00', '2023-01-16 17:15:00'),
('Gabriel Lima', 'gabriel.lima@gmail.com', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 2, 1, 0, '32109876543', '2023-01-02 12:35:00', '2023-02-16 13:30:00');


-- Contratantes de Fevereiro
INSERT INTO eventify.usuario (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES
('Rafael Oliveira', 'rafael.oliveira61582@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2023-02-01 10:10:00', '2023-04-25 17:15:00'),
('Camila Lima', 'camila.lima45387@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2023-02-02 13:25:00', '2023-02-05 15:45:00'),
('Mariana Santos', 'mariana.santos10856@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2023-02-03 11:40:00', '2023-02-26 09:30:00'),
('Rodrigo Silva', 'rodrigo.silva81476@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2023-02-04 09:15:00', '2023-02-27 14:20:00'),
('Fernanda Almeida', 'fernanda.almeida16423@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2023-02-05 14:35:00', '2023-02-27 10:05:00'),
('Pedro Sousa', 'pedro.sousa30982@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2023-02-01 17:50:00', '2023-02-27 13:40:00'),
('Amanda Castro', 'amanda.castro21435@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2023-02-07 09:55:00', '2023-02-27 16:30:00'),
('Lucas Fernandes', 'lucas.fernandes94762@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2023-02-08 15:20:00', '2023-02-27 11:15:00'),
('Carolina Oliveira', 'carolina.oliveira84035@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2023-02-09 11:30:00', '2023-02-27 14:45:00'),
('Bruno Costa', 'bruno.costa95361@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2023-02-10 08:45:00', '2023-02-27 09:30:00'),
('Larissa Rodrigues', 'larissa.rodrigues24786@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2023-02-01 13:05:00', '2023-02-01 15:15:00'),
('Thiago Pereira', 'thiago.pereira86597@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2023-02-12 16:25:00', '2023-02-28 12:00:00'),
('Beatriz Santos', 'beatriz.santos37459@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2023-02-01 10:40:00', '2023-02-27 17:45:00'),
('Gustavo Silva', 'gustavo.silva68105@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2023-02-01 09:15:00', '2023-04-27 14:30:00'),
('Laura Castro', 'laura.castro19683@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2023-02-15 14:35:00', '2023-02-27 10:05:00'),
('Rafaela Lima', 'rafaela.lima60237@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2023-02-16 17:50:00', '2023-02-27 13:40:00'),
('Diego Fernandes', 'diego.fernandes91278@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2023-02-01 09:55:00', '2023-02-27 16:30:00'),
('Juliana Costa', 'juliana.costa72914@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2023-02-18 15:20:00', '2023-02-27 11:15:00'),
('Renato Oliveira', 'renato.oliveira45362@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2023-02-01 11:30:00', '2023-04-27 14:45:00'),
('Carla Mendes', 'carla.mendes17385@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2023-02-20 08:45:00', '2023-02-28 09:30:00'),
('Marcela Rodrigues', 'marcela.rodrigues29176@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2023-02-01 13:05:00', '2023-02-10 15:15:00'),
('Ricardo Santos', 'ricardo.santos91645@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2023-02-01 16:25:00', '2023-02-27 12:00:00'),
('Ana Costa', 'ana.costa74829@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2023-02-02 10:40:00', '2023-02-11 17:45:00'),
('Fernando Almeida', 'fernando.almeida59014@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2023-02-02 09:15:00', '2023-02-27 14:30:00'),
('Luisa Fernandes', 'luisa.fernandes82417@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2023-02-02 14:35:00', '2023-02-27 10:05:00'),
('Bruna Oliveira', 'bruna.oliveira15823@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2023-02-02 17:50:00', '2023-04-27 13:40:00'),
('Marcos Lima', 'marcos.lima64789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2023-02-02 09:55:00', '2023-02-03 16:30:00'),
('Isabela Castro', 'isabela.castro98651@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2023-02-02 15:20:00', '2023-02-04 11:15:00'),
('Henrique Mendes', 'henrique.mendes26537@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2023-02-02 11:30:00', '2023-02-05 14:45:00'),
('Natália Rodrigues', 'natalia.rodrigues19357@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2023-02-02 08:45:00', '2023-02-06 09:30:00');


-- Contratantes de Março
INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES
('Pedro Sousa', 'pedro.sousa84659@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2023-03-01 15:05:00', '2023-03-31 18:15:00'),
('Amanda Rodrigues', 'amanda.rodrigues90724@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2023-03-02 10:15:00', '2023-03-31 17:00:00'),
('Gustavo Oliveira', 'gustavo.oliveira46528@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2023-03-03 12:25:00', '2023-03-31 13:30:00'),
('Maria Silva', 'maria.silva29375@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2023-03-04 09:35:00', '2023-03-31 15:45:00'),
('Carlos Costa', 'carlos.costa37081@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2023-03-05 14:45:00', '2023-03-31 11:30:00'),
('Juliana Santos', 'juliana.santos68047@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2023-03-06 11:55:00', '2023-03-31 14:00:00'),
('Lucas Almeida', 'lucas.almeida52783@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2023-03-07 16:05:00', '2023-03-31 16:15:00'),
('Camila Lima', 'camila.lima65019@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2023-03-08 13:15:00', '2023-03-31 09:45:00'),
('Mariana Ferreira', 'mariana.ferreira92634@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2023-03-09 10:25:00', '2023-03-31 12:30:00'),
('Diego Rodrigues', 'diego.rodrigues37490@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2023-03-10 15:35:00', '2023-03-31 14:45:00'),
('Ana Oliveira', 'ana.oliveira56834@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2023-03-11 12:45:00', '2023-03-31 17:00:00'),
('Fernando Costa', 'fernando.costa29184@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2023-03-12 09:55:00', '2023-03-31 11:30:00'),
('Patricia Santos', 'patricia.santos74960@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2023-03-13 15:05:00', '2023-03-31 15:00:00'),
('Rafaela Almeida', 'rafaela.almeida43725@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2023-03-14 10:15:00', '2023-03-31 18:15:00'),
('Bruno Silva', 'bruno.silva90541@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2023-03-15 12:25:00', '2023-03-31 14:30:00'),
('Carla Lima', 'carla.lima23896@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2023-03-16 09:35:00', '2023-03-31 17:45:00'),
('Lucas Rodrigues', 'lucas.rodrigues65102@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2023-03-17 14:45:00', '2023-03-31 10:30:00'),
('Isabella Costa', 'isabella.costa20738@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2023-03-18 11:55:00', '2023-03-31 13:00:00'),
('Matheus Santos', 'matheus.santos59473@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2023-03-19 17:05:00', '2023-03-31 16:15:00'),
('Laura Oliveira', 'laura.oliveira17108@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2023-03-20 14:15:00', '2023-03-31 09:45:00'),
('Gabriel Almeida', 'gabriel.almeida58834@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2023-03-21 11:25:00', '2023-03-31 12:30:00'),
('Manuela Lima', 'manuela.lima96379@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2023-03-22 16:35:00', '2023-03-31 14:45:00'),
('Pedro Ferreira', 'pedro.ferreira24015@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2023-03-23 13:45:00', '2023-03-31 11:30:00'),
('Amanda Oliveira', 'amanda.oliveira52741@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2023-03-24 10:55:00', '2023-03-31 14:00:00'),
('Guilherme Costa', 'guilherme.costa89467@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2023-03-25 16:05:00', '2023-03-31 16:15:00'),
('Camila Santos', 'camila.santos37183@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2023-03-26 13:15:00', '2023-03-31 09:45:00'),
('Rafaela Lima', 'rafaela.lima64829@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2023-03-27 10:25:00', '2023-03-31 12:30:00'),
('Lucas Rodrigues', 'lucas.rodrigues91354@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2023-03-28 15:35:00', '2023-03-31 14:45:00'),
('Isabella Oliveira', 'isabella.oliveira29017@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2023-03-29 12:45:00', '2023-03-31 17:00:00'),
('Matheus Costa', 'matheus.costa67742@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2023-03-30 09:55:00', '2023-03-31 13:30:00'),
('Laura Lima', 'laura.lima38478@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2023-03-31 15:05:00', '2023-03-31 15:45:00'),
('Gabriel Ferreira', 'gabriel.ferreira12567@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2023-03-01 12:15:00', '2023-03-31 18:00:00'),
('Manuela Almeida', 'manuela.almeida34276@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2023-03-02 09:25:00', '2023-03-31 15:30:00'),
('Pedro Oliveira', 'pedro.oliveira61327@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2023-03-03 14:35:00', '2023-03-31 17:45:00'),
('Amanda Lima', 'amanda.lima89021@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2023-03-04 11:45:00', '2023-03-31 10:30:00'),
('Guilherme Rodrigues', 'guilherme.rodrigues16754@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2023-03-05 16:55:00', '2023-03-31 13:00:00'),
('Camila Costa', 'camila.costa52439@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2023-03-06 14:05:00', '2023-03-31 16:15:00'),
('Rafaela Santos', 'rafaela.santos90182@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2023-03-07 11:15:00', '2023-03-31 09:45:00'),
('Lucas Oliveira', 'lucas.oliveira27859@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2023-03-08 16:25:00', '2023-03-31 12:30:00'),
('Isabella Almeida', 'isabella.almeida64586@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2023-03-09 13:35:00', '2023-03-31 14:45:00'),
('Matheus Lima', 'matheus.lima91213@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2023-03-10 10:45:00', '2023-03-31 11:30:00'),
('Laura Ferreira', 'laura.ferreira18950@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2023-03-11 07:55:00', '2023-03-31 14:00:00'),
('Gabriel Almeida', 'gabriel.almeida45687@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2023-03-12 13:05:00', '2023-03-31 16:15:00'),
('Manuela Oliveira', 'manuela.oliveira73324@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2023-03-13 10:15:00', '2023-03-31 09:45:00'),
('Pedro Lima', 'pedro.lima00032@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2023-03-14 15:25:00', '2023-03-31 12:30:00'),
('Amanda Ferreira', 'amanda.ferreira37759@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2023-03-15 12:35:00', '2023-03-31 14:45:00'),
('Guilherme Almeida', 'guilherme.almeida64486@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2023-03-16 09:45:00', '2023-03-31 17:00:00'),
('Camila Rodrigues', 'camila.rodrigues91173@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2023-03-17 14:55:00', '2023-03-31 13:30:00'),
('Rafaela Costa', 'rafaela.costa28800@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2023-03-18 12:05:00', '2023-03-31 15:45:00'),
('Lucas Almeida', 'lucas.almeida55527@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2023-03-19 09:15:00', '2023-03-31 18:00:00'),
('Isabella Oliveira', 'isabella.oliveira82254@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2023-03-20 14:25:00', '2023-03-31 15:30:00'),
('Matheus Lima', 'matheus.lima49981@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2023-03-21 11:35:00', '2023-03-31 10:30:00'),
('Laura Ferreira', 'laura.ferreira76608@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2023-03-22 16:45:00', '2023-03-31 13:00:00'),
('Gabriel Almeida', 'gabriel.almeida03335@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2023-03-23 13:55:00', '2023-03-31 15:15:00'),
('Manuela Oliveira', 'manuela.oliveira30062@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2023-03-24 11:05:00', '2023-03-31 11:30:00'),
('Pedro Lima', 'pedro.lima67789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2023-03-25 08:15:00', '2023-03-31 14:45:00'),
('Amanda Ferreira', 'amanda.ferreira94416@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2023-03-26 13:25:00', '2023-03-31 17:00:00'),
('Guilherme Almeida', 'guilherme.almeida21143@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2023-03-27 10:35:00', '2023-03-31 13:30:00'),
('Camila Rodrigues', 'camila.rodrigues58870@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2023-03-28 15:45:00', '2023-03-31 15:45:00'),
('Rafaela Costa', 'rafaela.costa86597@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2023-03-01 12:55:00', '2023-03-31 18:00:00'),
('Lucas Almeida', 'lucas.almeida13224@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2023-03-02 10:05:00', '2023-03-31 15:30:00'),
('Isabella Oliveira', 'isabella.oliveira40951@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2023-03-03 15:15:00', '2023-03-31 10:30:00'),
('Matheus Lima', 'matheus.lima68678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2023-03-04 12:25:00', '2023-03-31 13:00:00'),
('Laura Ferreira', 'laura.ferreira96305@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2023-03-05 09:35:00', '2023-03-31 16:15:00'),
('Gabriel Almeida', 'gabriel.almeida23032@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2023-03-06 14:45:00', '2023-03-31 09:45:00'),
('Manuela Oliveira', 'manuela.oliveira50759@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2023-03-07 11:55:00', '2023-03-31 12:30:00'),
('Pedro Lima', 'pedro.lima78486@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '21098765432', '2023-03-08 09:05:00', '2023-03-31 14:45:00'),
('Amanda Ferreira', 'amanda.ferreira06113@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '10987654321', '2023-03-09 14:15:00', '2023-03-31 11:30:00'),
('Guilherme Almeida', 'guilherme.almeida32840@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '98765432109', '2023-03-10 11:25:00', '2023-03-31 14:00:00'),
('Camila Rodrigues', 'camila.rodrigues60567@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '87654321098', '2023-03-11 08:35:00', '2023-03-31 16:15:00'),
('Rafaela Costa', 'rafaela.costa88294@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '76543210987', '2023-03-12 13:45:00', '2023-03-31 13:45:00'),
('Lucas Almeida', 'lucas.almeida15921@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '65432109876', '2023-03-13 10:55:00', '2023-03-31 17:00:00'),
('Isabella Oliveira', 'isabella.oliveira43648@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '54321098765', '2023-03-14 08:05:00', '2023-03-31 13:30:00'),
('Matheus Lima', 'matheus.lima71375@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '43210987654', '2023-03-15 13:15:00', '2023-03-31 15:45:00'),
('Laura Ferreira', 'laura.ferreira99002@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '32109876543', '2023-03-16 10:25:00', '2023-03-31 18:00:00');


-- Contratantes de Abril
INSERT INTO eventify.usuario (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES
('João Silva', 'joao.silva12346@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-04-00 09:00:00', '2023-04-30 15:30:00'),
('Maria Santos', 'maria.santos6780@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-04-00 12:00:00', '2023-04-30 16:45:00'),
('Pedro Oliveira', 'pedro.oliveira23456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-04-00 15:00:00', '2023-04-30 18:00:00'),
('Ana Lima', 'ana.lima34567@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-04-00 09:30:00', '2023-04-30 12:15:00'),
('Carlos Costa', 'carlos.costa4678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-04-00 12:30:00', '2023-04-30 15:30:00'),
('Mariana Sousa', 'mariana.sousa56789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-04-00 15:45:00', '2023-04-30 16:45:00'),
('José Almeida', 'jose.almeida67890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-04-00 09:00:00', '2023-04-30 18:00:00'),
('Fernanda Lima', 'fernanda.lima78901@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-04-00 12:00:00', '2023-04-30 12:15:00'),
('André Ferreira', 'andre.ferreira89012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-04-00 15:00:00', '2023-04-30 15:30:00'),
('Carolina Rodrigues', 'carolina.rodrigues90123@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-04-10 09:30:00', '2023-04-30 16:45:00'),
('Bruno Silva', 'bruno.silva01234@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-04-10 12:30:00', '2023-04-30 12:15:00'),
('Amanda Santos', 'amanda.santos12345@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-04-10 15:45:00', '2023-04-30 15:30:00'),
('Guilherme Oliveira', 'guilherme.oliveira23456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-04-10 09:00:00', '2023-04-30 18:00:00'),
('Laura Lima', 'laura.lima34567@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-04-10 12:00:00', '2023-04-30 12:15:00'),
('Lucas Costa', 'lucas.costa4512678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-04-10 15:00:00', '2023-04-30 15:30:00'),
('Isabela Sousa', 'isabela.sousa56789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-04-10 09:30:00', '2023-04-30 16:45:00'),
('Thiago Almeida', 'thiago.almeida67890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-04-10 12:30:00', '2023-04-30 18:00:00'),
('Juliana Lima', 'juliana.lima78901@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-04-10 15:45:00', '2023-04-30 12:15:00'),
('Rafael Ferreira', 'rafael.ferreira89012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-04-10 09:00:00', '2023-04-30 15:30:00'),
('Fernanda Rodrigues', 'fernanda.rodrigues90123@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-04-20 12:00:00', '2023-04-30 16:45:00'),
('Diego Silva', 'diego.silva01234@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-04-20 15:00:00', '2023-04-30 18:00:00'),
('Carla Santos', 'carla.santos12345@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-04-20 09:30:00', '2023-04-30 12:15:00'),
('Lucas Oliveira', 'lucas.oliveira23456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-04-20 12:30:00', '2023-04-30 15:30:00'),
('Amanda Lima', 'amanda.lima34567@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-04-20 15:00:00', '2023-04-30 16:45:00'),
('Mariana Costa', 'mariana.costa45678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-04-20 09:30:00', '2023-04-30 18:00:00'),
('Gustavo Sousa', 'gustavo.sousa56789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-04-20 12:00:00', '2023-04-30 12:15:00'),
('Ana Costa', 'ana.costa78901@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-04-20 15:45:00', '2023-04-30 18:00:00'),
('Gabriel Santos', 'gabriel.santos89012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-04-20 09:00:00', '2023-04-30 12:15:00'),
('Isabella Oliveira', 'isabella.oliveira90123@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-04-20 12:00:00', '2023-04-30 15:30:00'),
('Rafaela Rodrigues', 'rafaela.rodrigues01234@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-04-30 15:00:00', '2023-04-30 16:45:00'),
('Leonardo Lima', 'leonardo.lima12345@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-04-30 09:30:00', '2023-04-30 18:00:00'),
('Mariana Ferreira', 'mariana.ferreira23456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-04-00 12:30:00', '2023-04-30 12:15:00'),
('Felipe Silva', 'felipe.silva34567@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-04-00 15:45:00', '2023-04-30 15:30:00'),
('Laura Santos', 'laura.santos45678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-04-00 09:00:00', '2023-04-30 16:45:00'),
('Ricardo Oliveira', 'ricardo.oliveira56789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-04-00 12:00:00', '2023-04-30 18:00:00'),
('Juliana Costa', 'juliana.costa67890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-04-00 15:00:00', '2023-04-30 12:15:00'),
('Lucas Mendes', 'lucas.mendes78901@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-04-00 09:30:00', '2023-04-30 15:30:00'),
('Gustavo Sousa', 'gustavo.sousa89012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-04-00 12:45:00', '2023-04-30 16:45:00'),
('Isabela Rodrigues', 'isabela.rodrigues90123@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-04-00 15:00:00', '2023-04-30 18:00:00'),
('Ricardo Ferreira', 'ricardo.ferreira01234@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-04-00 09:15:00', '2023-04-30 12:15:00'),
('Juliana Martins', 'juliana.martins12345@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-04-10 12:30:00', '2023-04-30 15:30:00');


-- Contratantes de Maio
INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES
('Paulo Oliveira', 'paulo.oliveira23456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-05-01 15:45:00', '2023-05-31 16:45:00'),
('Camila Lima', 'camila.lima34567@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-05-01 09:00:00', '2023-05-31 18:00:00'),
('Bruno Sousa', 'bruno.sousa45678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-05-01 12:15:00', '2023-05-31 12:15:00'),
('Mariana Ferreira', 'mariana.ferreira56789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-05-01 15:30:00', '2023-05-31 15:30:00'),
('Pedro Sousa', 'pedro.sousa67890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-05-01 09:45:00', '2023-05-31 16:45:00'),
('Amanda Rodrigues', 'amanda.rodrigues78901@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-05-01 13:00:00', '2023-05-31 18:00:00'),
('Gabriel Lima', 'gabriel.lima89012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-05-01 16:15:00', '2023-05-31 09:00:00'),
('Maria Sousa', 'maria.sousa90123@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-05-01 09:30:00', '2023-05-31 12:15:00'),
('Fernando Ferreira', 'fernando.ferreira01234@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-05-01 12:45:00', '2023-05-31 15:30:00'),
('Carolina Martins', 'carolina.martins12345@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-05-01 16:00:00', '2023-05-31 16:45:00'),
('Gustavo Oliveira', 'gustavo.oliveira23456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-05-01 09:15:00', '2023-05-31 18:00:00'),
('Isabela Lima', 'isabela.lima34567@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-05-01 12:30:00', '2023-05-31 09:15:00'),
('Rafaela Rodrigues', 'rafaela.rodrigues45678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-05-01 15:45:00', '2023-05-31 12:30:00'),
('Henrique Sousa', 'henrique.sousa56789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-05-01 09:00:00', '2023-05-31 15:45:00'),
('Laura Ferreira', 'laura.ferreira67890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-05-01 12:15:00', '2023-05-31 16:00:00'),
('João Silva', 'joao.silva1245@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-05-01 09:00:00', '2023-05-31 15:30:00'),
('Maria Santos', 'maria.santos67890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-05-01 12:00:00', '2023-05-31 16:45:00'),
('Pedro Oliveira', 'pedro.oliveira2456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-05-01 15:00:00', '2023-05-31 18:00:00'),
('Ana Lima', 'ana.lima3457@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-05-01 09:30:00', '2023-05-31 12:15:00'),
('Carlos Costa', 'carlos.costa45678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-05-01 12:30:00', '2023-05-31 15:30:00'),
('Mariana Sousa', 'mariana.sousa789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-05-01 15:45:00', '2023-05-31 16:45:00'),
('José Almeida', 'jose.almeida67889890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-05-01 09:00:00', '2023-05-31 18:00:00'),
('Fernanda Lima', 'fernanda.lima7891201@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-05-01 12:00:00', '2023-05-31 12:15:00'),
('André Ferreira', 'andre.ferreira8912012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-05-01 15:00:00', '2023-05-31 15:30:00'),
('Carolina Rodrigues', 'carolina.rodrigues9120123@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-05-01 09:30:00', '2023-05-31 16:45:00'),
('Bruno Silva', 'bruno.silva0123124@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-05-01 12:30:00', '2023-05-31 12:15:00'),
('Amanda Santos', 'amanda.santos1221345@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-05-01 15:45:00', '2023-05-31 15:30:00'),
('Guilherme Oliveira', 'guilherme.oliveira2123456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-05-01 09:00:00', '2023-05-31 18:00:00'),
('Laura Lima', 'laura.lima3456427@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-05-01 12:00:00', '2023-05-31 12:15:00'),
('Lucas Costa', 'lucas.costa45678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-05-01 15:00:00', '2023-05-31 15:30:00'),
('Isabela Sousa', 'isabela.sousa5136789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-05-01 09:30:00', '2023-05-31 16:45:00'),
('Thiago Almeida', 'thiago.almeida6731890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-05-01 12:30:00', '2023-05-31 18:00:00'),
('Juliana Lima', 'juliana.lima7890311@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-05-01 15:45:00', '2023-05-31 12:15:00'),
('Rafael Ferreira', 'rafael.ferreira382129012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-05-01 09:00:00', '2023-05-31 15:30:00'),
('Fernanda Rodrigues', 'fernanda.rodrigues9120123@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-05-01 12:00:00', '2023-05-31 16:45:00'),
('Diego Silva', 'diego.silva1201234@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-05-01 15:00:00', '2023-05-31 18:00:00'),
('Carla Santos', 'carla.santos1122345@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-05-01 09:30:00', '2023-05-31 12:15:00'),
('Lucas Oliveira', 'lucas.oliveira234456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-05-01 12:30:00', '2023-05-31 15:30:00'),
('Amanda Lima', 'amanda.lima345267@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-05-01 15:00:00', '2023-05-31 16:45:00'),
('Mariana Costa', 'mariana.costa451678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-05-01 09:30:00', '2023-05-31 18:00:00'),
('Gustavo Sousa', 'gustavo.sousa561789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-05-01 12:00:00', '2023-05-31 12:15:00'),
('Ana Costa', 'ana.costa783901@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-05-01 15:45:00', '2023-05-31 18:00:00'),
('Gabriel Santos', 'gabriel.santos894012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-05-01 09:00:00', '2023-05-31 12:15:00'),
('Isabella Oliveira', 'isabella.oliveira904123@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-05-01 12:00:00', '2023-05-31 15:30:00'),
('Rafaela Rodrigues', 'rafaela.rodrigues012534@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-05-01 15:00:00', '2023-05-31 16:45:00'),
('Leonardo Lima', 'leonardo.lima123465@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-05-01 09:30:00', '2023-05-31 18:00:00'),
('Mariana Ferreira', 'mariana.ferreira234256@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-05-01 12:30:00', '2023-05-31 12:15:00'),
('Felipe Silva', 'felipe.silva345167@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-05-01 15:45:00', '2023-05-31 15:30:00'),
('Laura Santos', 'laura.santos4532678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-05-01 09:00:00', '2023-05-31 16:45:00'),
('Ricardo Oliveira', 'ricardo.oliveira5672189@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-05-01 12:00:00', '2023-05-31 18:00:00'),
('Juliana Costa', 'juliana.costa6217890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-05-01 15:00:00', '2023-05-31 12:15:00'),
('Lucas Mendes', 'lucas.mendes7812901@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-05-01 09:30:00', '2023-05-31 15:30:00'),
('Gustavo Sousa', 'gustavo.sousa8912012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-05-01 12:45:00', '2023-05-31 16:45:00'),
('Isabela Rodrigues', 'isabela.rodrigues9021123@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-05-01 15:00:00', '2023-05-31 18:00:00'),
('Ricardo Ferreira', 'ricardo.ferreira0121234@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-05-01 09:15:00', '2023-05-31 12:15:00'),
('Juliana Martins', 'juliana.martins1223345@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-05-01 12:30:00', '2023-05-31 15:30:00'),
('Paulo Oliveira', 'paulo.oliveira2423456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-05-01 15:45:00', '2023-05-31 16:45:00'),
('Camila Lima', 'camila.lima3452367@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-05-01 09:00:00', '2023-05-31 18:00:00'),
('Bruno Sousa', 'bruno.sousa4562378@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-05-01 12:15:00', '2023-05-31 12:15:00'),
('Mariana Ferreira', 'mariana.ferreira5678239@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-05-01 15:30:00', '2023-05-31 15:30:00'),
('Pedro Sousa', 'pedro.sousa6723890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-05-01 09:45:00', '2023-05-31 16:45:00'),
('Carlos Santos', 'carlos.santos7890231@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-05-01 16:30:00', '2023-05-31 09:15:00'),
('Mariana Silva', 'mariana.silva8924012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-05-01 09:45:00', '2023-05-31 12:30:00'),
('Ricardo Almeida', 'ricardo.almeida91230123@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-05-01 13:00:00', '2023-05-31 15:45:00'),
('Ana Costa', 'ana.costa01231234@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-05-01 16:15:00', '2023-05-31 16:00:00'),
('Paulo Lima', 'paulo.lima12344145@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-05-01 09:30:00', '2023-05-31 18:15:00'),
('Camila Oliveira', 'camila.oliveira2336456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-05-01 12:45:00', '2023-05-31 09:30:00'),
('Lucas Sousa', 'lucas.sousa37644567@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-05-01 16:00:00', '2023-05-31 12:45:00'),
('Isabela Martins', 'isabela.martins45457678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-05-01 09:15:00', '2023-05-31 15:00:00'),
('Gustavo Ferreira', 'gustavo.ferreira56745789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-05-01 12:30:00', '2023-05-31 16:15:00'),
('Juliana Oliveira', 'juliana.oliveira69767890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-05-01 15:45:00', '2023-05-31 09:30:00'),
('Fernando Santos', 'fernando.santos78945701@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-05-01 09:00:00', '2023-05-31 12:45:00'),
('Mariana Silva', 'mariana.silva4589012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-05-01 12:15:00', '2023-05-31 16:00:00'),
('Ricardo Almeida', 'ricardo.almeida9012543@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-05-01 16:30:00', '2023-05-31 09:15:00'),
('Ana Costa', 'ana.costa0451234@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-05-01 09:45:00', '2023-05-31 12:30:00'),
('Paulo Lima', 'paulo.lima1235445@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-05-01 13:00:00', '2023-05-31 15:45:00'),
('Camila Oliveira', 'camila.oliveira2673456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-05-01 16:15:00', '2023-05-31 16:00:00'),
('Lucas Sousa', 'lucas.sousa34565467@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-05-01 09:30:00', '2023-05-31 18:15:00'),
('Isabela Martins', 'isabela.martins4465678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-05-01 12:45:00', '2023-05-31 09:30:00'),
('Gustavo Ferreira', 'gustavo.ferreira6556789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-05-01 16:00:00', '2023-05-31 12:45:00'),
('Juliana Oliveira', 'juliana.oliveira6867890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-05-01 09:15:00', '2023-05-31 15:00:00'),
('Fernando Santos', 'fernando.santos7890341@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-05-01 12:30:00', '2023-05-31 16:15:00'),
('Mariana Silva', 'mariana.silva89012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-05-01 15:45:00', '2023-05-31 09:30:00'),
('Ricardo Almeida', 'ricardo.almeida9110123@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-05-01 09:00:00', '2023-05-31 12:45:00'),
('Ana Costa', 'ana.costa01234@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-05-01 12:15:00', '2023-05-31 16:00:00'),
('Paulo Lima', 'paulo.lima12345@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-05-01 15:30:00', '2023-05-31 09:15:00'),
('Camila Oliveira', 'camila.oliveira23456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-05-01 16:45:00', '2023-05-31 12:30:00'),
('Lucas Sousa', 'lucas.sousa1234567@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-05-01 10:00:00', '2023-05-31 15:45:00'),
('Isabela Martins', 'isabela.martins4325678@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-05-01 13:15:00', '2023-05-31 16:00:00'),
('Gustavo Ferreira', 'gustavo.ferreira5236789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-05-01 16:30:00', '2023-05-31 09:30:00'),
('Juliana Oliveira', 'juliana.oliveira6237890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-05-01 09:45:00', '2023-05-31 12:45:00'),
('Fernando Santos', 'fernando.santos7892301@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-05-01 13:00:00', '2023-05-31 16:00:00'),
('Mariana Silva', 'mariana.silva8904312@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-05-01 16:15:00', '2023-05-31 09:15:00'),
('Ricardo Almeida', 'ricardo.almeida9043123@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '90123456789', '2023-05-01 09:30:00', '2023-05-31 12:30:00'),
('Ana Costa', 'ana.costa0123434@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '01234567890', '2023-05-01 12:45:00', '2023-05-31 15:45:00'),
('Paulo Lima', 'paulo.lima1253345@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '12345678901', '2023-05-01 16:00:00', '2023-05-31 16:00:00'),
('Camila Oliveira', 'camila.oliveira2365456@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '23456789012', '2023-05-01 09:15:00', '2023-05-31 18:15:00'),
('Lucas Sousa', 'lucas.sousa3544567@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '34567890123', '2023-05-01 12:30:00', '2023-05-31 09:30:00'),
('Isabela Martins', 'isabela.martins4563478@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '45678901234', '2023-05-01 15:45:00', '2023-05-31 12:45:00'),
('Gustavo Ferreira', 'gustavo.ferreira5634789@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '56789012345', '2023-05-01 09:00:00', '2023-05-31 16:00:00'),
('Juliana Oliveira', 'juliana.oliveira6437890@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '67890123456', '2023-05-01 12:15:00', '2023-05-31 09:15:00'),
('Fernando Santos', 'fernando.santos7894301@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '78901234567', '2023-05-01 15:30:00', '2023-05-31 12:30:00'),
('Mariana Silva', 'mariana.silva8943012@sptech.school', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 1, 1, 0, '89012345678', '2023-05-01 16:45:00', '2023-05-31 15:45:00');


INSERT INTO eventify.usuario (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login, foto) VALUE
('Administrador', 'admin@eventify.com', '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC', 3, 1, 0, '09876543210', '2022-12-01 10:40:00', '2023-05-20 17:45:00',
'https://avatars.githubusercontent.com/u/125686648?s=400&u=a59fc408f866db42661576c2fdc4e3fbac915a41&v=4');


INSERT INTO `eventify`.`faixa_etaria` (descricao) VALUES
('1 a 5 anos'),
('6 a 10 anos'),
('11 a 15 anos'),
('16 a 20 anos'),
('21 a 25 anos'),
('26 a 30 anos'),
('31 a 35 anos'),
('36 a 40 anos'),
('41 a 49 anos'),
('50 anos ou mais');


INSERT INTO `eventify`.`tipo_evento` (descricao) VALUES
('Casamento'),
('Aniversário'),
('Empresarial'),
('Happy Hour'),
('Comemoração'),
('Infantil'),
('Outros');


INSERT INTO `eventify`.`servico` (descricao) VALUES
('Comida'),
('Decoração'),
('Música'),
('Garçom'),
('Segurança'),
('Limpeza'),
('Estacionamento'),
('Fotografia');


INSERT INTO eventify.pagina (nome, uri) VALUES
('cadastro de usuário', '/cadastro'),
('cadastro de buffet', '/proprietario/adicionar-buffet'),
('formulário dinâmico', '/contratante');


-- --------------------- BUFFET 1 ---------------------
INSERT INTO `eventify`.`endereco` (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua Augusta', 123, 'Consolação', 'São Paulo', 'SP', '01304001', -23.554279, -46.653040, '2023-03-02 16:30:49');

INSERT INTO `eventify`.`buffet` (`nome`, `descricao`, `tamanho`, `preco_medio_diaria`, `qtd_pessoas`, `caminho_comprovante`, `residencia_comprovada`, `is_visivel`, `data_criacao`, `id_usuario`, `id_endereco`) VALUES
('Buffet do Chef', 
'O Buffet do Chef é a escolha perfeita para os amantes da alta gastronomia. Com um cardápio cuidadosamente elaborado pelo renomado chef da casa, cada prato é uma obra de arte culinária que encanta os 
paladares mais exigentes. Com uma equipe de profissionais dedicados e apaixonados pela arte da cozinha, o Buffet do Chef oferece uma experiência gastronômica única em cada evento. Dos coquetéis sofisticados aos 
jantares requintados.', 500, 2500.00, 200, 'caminho/comprovante1.jpg', 1, 1, '2022-12-01 09:15:00', 1, 1);

INSERT INTO `eventify`.`mensagem` (mensagem, mandado_por, data, id_usuario, id_buffet) VALUES
('Olá, gostaria de solicitar um orçamento para um evento corporativo que acontecerá em São Paulo no próximo mês. Podem me enviar mais informações?', 0, '2023-05-16 10:30:00', 103, 1),
('Prezado cliente, agradecemos pelo contato. Claro, podemos enviar todas as informações necessárias. Por favor, nos informe a data e a quantidade de convidados para que possamos preparar o orçamento.', 1, '2023-05-16 11:15:00', 103, 1),
('Certo. Como podemos prosseguir para fechar contrato para que eu realize este evento?', 0, '2023-05-16 10:30:00', 103, 1),
('Na plataforma da Eventify, basta você apertar no botão de Pedir Orçamento e podemos negociar!', 1, '2023-05-16 11:15:00', 103, 1);

INSERT INTO `eventify`.`buffet_faixa_etaria` (`id_buffet`, `id_faixa_etaria`) VALUES
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10);


INSERT INTO `eventify`.`buffet_tipo_evento` (`id_buffet`, `id_tipo_evento`) VALUES
(1, 1),
(1, 3),
(1, 2),
(1, 5);

INSERT INTO `eventify`.`buffet_servico` (`id_buffet`, `id_servico`) VALUES
(1, 1),
(1, 3),
(1, 4),
(1, 5);

INSERT INTO `eventify`.`pagamento` (is_pago_contrato, data_pago, is_pago_buffet) VALUES 
(1, '2023-01-18 00:00:00', 1),
(1, '2023-01-28 00:00:00', 1),
(1, '2023-02-11 00:00:00', 1),
(1, '2023-02-15 00:00:00', 1),
(1, '2023-02-21 00:00:00', 1),
(1, '2023-02-28 00:00:00', 1),
(1, '2023-03-06 00:00:00', 1),
(1, '2023-03-07 00:00:00', 1),
(1, '2023-03-08 00:00:00', 1),
(1, '2023-03-14 00:00:00', 1),
(1, '2023-03-31 00:00:00', 1),
(1, '2023-04-02 00:00:00', 1),
(1, '2023-04-03 00:00:00', 1),
(1, '2023-04-30 00:00:00', 1),
(1, '2023-05-08 00:00:00', 1),
(1, '2023-05-14 00:00:00', 1),
(1, '2023-05-16 00:00:00', 1),
(1, '2023-05-22 00:00:00', 1),
(1, '2023-06-07 00:00:00', 1),
(1, '2023-06-20 00:00:00', 0),
(1, '2023-06-30 00:00:00', 0);

INSERT INTO `eventify`.`evento` (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES 
('2023-01-18 00:00:00', 1500.00, 'O buffet foi incrível! A variedade de pratos e sabores surpreendeu a todos.', 4.5, 6, NULL, 1, 1, '2022-12-01 09:00:00', 162, 1),
('2023-01-28 00:00:00', 2000.00, 'A qualidade da comida do buffet é impecável. Os ingredientes frescos fazem toda a diferença.', 4.8, 6, NULL, 0, 1, '2022-12-02 14:30:00', 165, 2),
('2023-01-28 00:00:00', 2000.00, NULL, NULL, 7, NULL, 0, 1, '2022-12-02 14:30:00', 165, NULL),
('2023-01-28 00:00:00', 2000.00, NULL, NULL, 2, 'Contratante não queria mais fazer o evento', 0, 1, '2022-12-02 14:30:00', 164, NULL),
('2023-02-11 00:00:00', 3000.50, 'O atendimento no buffet foi excepcional. A equipe foi atenciosa e prestativa o tempo todo.', 4.2, 6, NULL, 1, 1, '2022-12-12 18:45:00', 182, 3),
('2023-02-15 00:00:00', 3500.00, 'O buffet oferece opções para todos os gostos. Desde pratos tradicionais até opções vegetarianas e veganas.', 4.5, 6, NULL, 1, 1, '2022-12-16 09:00:00', 189, 4),
('2023-02-21 00:00:00', 2457.70, 'Os pratos do buffet são verdadeiras obras de arte. A apresentação é impecável e convidativa.', 4.9, 6, NULL, 0, 1, '2023-01-02 14:30:00', 178, 5),
('2023-01-28 00:00:00', 2000.00, NULL, NULL, 4, 'Buffet não servia o tipo de prato que eu gosto.', 0, 1, '2022-12-02 14:30:00', 191, NULL),
('2023-01-28 00:00:00', 2000.00, NULL, NULL, 4, 'Buffet orçou um valor maior que o esperado', 0, 1, '2022-12-02 14:30:00', 193, NULL),
('2023-02-28 00:00:00', 1800.50, 'Recomendo o buffet para eventos especiais. Eles sabem como tornar a experiência gastronômica memorável.', 3.7, 6, NULL, 1, 1, '2023-01-03 18:45:00', 194, 6),
('2023-03-06 00:00:00', 1500.31, 'O buffet superou minhas expectativas. A comida estava deliciosa e bem temperada.', 4.8, 6, NULL, 1, 1, '2023-02-01 09:00:00', 201, 7),
('2023-03-07 00:00:00', 2010.10, 'O cardápio do buffet é diversificado e sofisticado. Um verdadeiro banquete para os paladares mais exigentes.', 4.8, 6, NULL, 0, 1, '2023-02-02 14:30:00', 200, 8),
('2023-03-08 00:00:00', 1840.50, 'O buffet tem uma seleção incrível de sobremesas. É impossível resistir a tantas opções doces.', 4.2, 6, NULL, 1, 1, '2023-02-03 18:45:00', 202, 9),
('2023-03-14 00:00:00', 1215.00, 'O serviço do buffet é eficiente e ágil. Os pratos são servidos sempre na temperatura certa.', 4.5, 6, NULL, 1, 1, '2023-02-01 09:00:00', 205, 10),
('2023-03-25 00:00:00', 2000.00, NULL, NULL, 7, NULL, 0, 1, '2023-02-01 14:30:00', 208, NULL),
('2023-03-31 00:00:00', 2003.00, 'O buffet se preocupa com os detalhes. A decoração das mesas e do ambiente estava impecável.', 4.8, 6, NULL, 0, 1, '2023-02-02 14:30:00', 210, 11),
('2023-04-02 00:00:00', 1800.50, 'Fiquei encantado com a criatividade dos pratos do buffet. Cada um tinha um toque especial e único.', 4.2, 6, NULL, 1, 1, '2023-03-03 18:45:00', 219, 12),
('2023-04-03 00:00:00', 1502.00, 'O buffet oferece uma experiência gastronômica completa. Desde entradas até sobremesas, tudo é perfeito.', 4.5, 6, NULL, 1, 1, '2023-03-01 09:00:00', 221, 13),
('2023-04-28 00:00:00', 2000.00, NULL, NULL, 7, NULL, 0, 1, '2023-06-01 14:30:00', 226, NULL),
('2023-04-30 00:00:00', 2001.00, 'Os pratos do buffet são preparados com ingredientes frescos e de alta qualidade. Isso faz toda a diferença no sabor.', 4.8, 6, NULL, 0, 1, '2023-03-02 14:30:00', 224, 14),
('2023-05-08 00:00:00', 1800.50, 'O buffet tem opções saudáveis e saborosas. É possível aproveitar a comida sem abrir mão da alimentação equilibrada.', 4.2, 6, NULL, 1, 1, '2023-03-03 18:45:00', 222, 15),
('2023-05-14 00:00:00', 1500.00, 'A equipe do buffet é extremamente profissional e bem treinada. O serviço foi impecável do início ao fim.', 4.5, 6, NULL, 1, 1, '2023-04-01 09:00:00', 223, 16),
('2023-05-16 00:00:00', 2021.74, 'O buffet possui uma grande variedade de pratos internacionais. É como viajar pelo mundo através da gastronomia.', 4.8, 6, NULL, 0, 1, '2023-04-02 14:30:00', 225, 17),
('2023-05-22 00:00:00', 1811.50, 'Os pratos do buffet são servidos em porções generosas. Ninguém sai com fome de lá!', 4.2, 6, NULL, 1, 1, '2023-04-03 18:45:00', 227, 18),
('2023-05-27 00:00:00', 1500.00, NULL, NULL, 4, NULL, 1, 1, '2023-04-01 09:00:00', 230, NULL),
('2023-06-09 00:00:00', 2000.00, NULL, NULL, 5, NULL, 0, 1, '2023-04-07 14:30:00', 231, 19),
('2023-06-20 00:00:00', 1800.50, NULL, NULL, 5, NULL, 1, 1, '2023-04-17 18:45:00', 233, 20),
('2023-06-30 00:00:00', 1500.00, NULL, NULL, 5, NULL, 1, 1, '2023-05-01 09:00:00', 236, 21);

INSERT INTO agenda (data, id_buffet) VALUES
('2023-01-18 00:00:00', 1),
('2023-01-28 00:00:00', 1),
('2023-02-11 00:00:00', 1),
('2023-02-13 00:00:00', 1),
('2023-02-15 00:00:00', 1),
('2023-02-21 00:00:00', 1),
('2023-02-25 00:00:00', 1),
('2023-02-28 00:00:00', 1),
('2023-03-06 00:00:00', 1),
('2023-03-07 00:00:00', 1),
('2023-03-08 00:00:00', 1),
('2023-03-14 00:00:00', 1),
('2023-03-15 00:00:00', 1),
('2023-03-31 00:00:00', 1),
('2023-04-02 00:00:00', 1),
('2023-04-03 00:00:00', 1),
('2023-04-13 00:00:00', 1),
('2023-04-30 00:00:00', 1),
('2023-05-08 00:00:00', 1),
('2023-05-14 00:00:00', 1),
('2023-05-16 00:00:00', 1),
('2023-05-22 00:00:00', 1),
('2023-05-24 00:00:00', 1),
('2023-06-09 00:00:00', 1),
('2023-06-20 00:00:00', 1),
('2023-06-30 00:00:00', 1);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://focusgreece.com/wp-content/uploads/2018/08/', 'Matsuhisa-Mykonos-2', 'jpg', 1, NOW(), 1),
    ('https://res.cloudinary.com/tf-lab/image/upload/w_600,h_337,c_fill,q_auto,f_auto/restaurant/32e83838-cb16-48f3-b7c8-95af3463f597/', '8ee54cfc-5f54-4658-aec9-cd9c0a91c8a1', 'jpg', 1, NOW(), 1),
    ('https://betterbankside.co.uk/wp-content/uploads/2019/03/', 'Bar_01', 'jpg', 1, NOW(), 1);
-- --------------------------------------------------	


-- OUTROS BUFFETS ------------------------------------------------

INSERT INTO `eventify`.`endereco` (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua Augusta', 123, 'Consolação', 'São Paulo', 'SP', '01304001', -23.554279, -46.653040, '2023-03-02 16:30:49'),
(1, 'Avenida Paulista', 1000, 'Bela Vista', 'São Paulo', 'SP', '01310100', -23.561399, -46.655105, '2023-03-20 16:30:49'),
(1, 'Rua da Consolação', 456, 'Consolação', 'São Paulo', 'SP', '01302000', -23.549970, -46.652924, '2023-03-24 16:30:49'),
(1, 'Rua da Consolação', 789, 'Consolação', 'São Paulo', 'SP', '01301000', -23.549543, -46.650378, '2023-04-02 16:30:49'),
(1, 'Avenida Brigadeiro Faria Lima', 1234, 'Pinheiros', 'São Paulo', 'SP', '05426100', -23.566439, -46.692738, '2023-04-06 16:30:49'),
(1, 'Rua Oscar Freire', 987, 'Jardins', 'São Paulo', 'SP', '01426001', -23.562314, -46.669154, '2023-04-12 16:30:49'),
(1, 'Rua 25 de Março', 100, 'Centro', 'São Paulo', 'SP', '01021000', -23.541489, -46.629487, '2023-04-13 16:30:49'),
(1, 'Rua José Paulino', 500, 'Bom Retiro', 'São Paulo', 'SP', '01120000', -23.525881, -46.638017, '2023-04-22 16:30:49'),
(1, 'Rua da Glória', 300, 'Liberdade', 'São Paulo', 'SP', '01510000', -23.557740, -46.629382, '2023-04-27 16:30:49'),
(1, 'Rua Santa Ifigênia', 200, 'Santa Ifigênia', 'São Paulo', 'SP', '01207000', -23.540925, -46.641287, '2023-05-02 16:30:49'),
(1, 'Rua Barão de Itapetininga', 150, 'República', 'São Paulo', 'SP', '01042001', -23.545713, -46.641983, '2023-05-05 16:30:49'),
(1, 'Avenida São João', 789, 'Centro', 'São Paulo', 'SP', '01035000', -23.542311, -46.641599, '2023-05-06 16:30:49'),
(1, 'Rua 7 de Abril', 600, 'República', 'São Paulo', 'SP', '01044000', -23.542419, -46.642343, '2023-05-11 16:30:49'),
(1, 'Rua Xavier de Toledo', 100, 'República', 'São Paulo', 'SP', '01048000', -23.541948, -46.643729, '2023-05-12 16:30:49'),
(1, 'Avenida Ipiranga', 123, 'República', 'São Paulo', 'SP', '01046918', -23.543514, -46.642233, '2023-05-13 16:30:49'),
(1, 'Avenida dos Autonomistas', 700, 'Centro', 'Osasco', 'SP', '01044000', -23.5340334, -46.7858787, '2023-05-14 16:30:49'),
(1, 'Avenida Cruzeiro do Sul', 100, 'Centro', 'Osasco', 'SP', '01048000', -23.5162521, -46.7830584, '2023-05-16 16:30:49'),
(1, 'Avenida Maria Campos', 123, 'Centro', 'Osasco', 'SP', '01046918', -23.5344027, -46.7757176, '2023-05-18 16:30:49');


INSERT INTO `eventify`.`buffet` (`nome`, `descricao`, `tamanho`, `preco_medio_diaria`, `qtd_pessoas`, `caminho_comprovante`, `residencia_comprovada`, `is_visivel`, `data_criacao`, `id_usuario`, `id_endereco`) VALUES
('Buffet Vice Feeling', 'Sinta-se na Califórnia dos anos 80', 500, 2500.00, 200, 'caminho/comprovante19.jpg', 1, 1, '2022-12-01 09:15:00', 1, 19),
('Sabor e Arte Buffet', 'Buffet especializado em eventos corporativos', 300, 1800.00, 150, 'caminho/comprovante2.jpg', 1, 1, '2022-12-27 14:20:00', 2, 2),
('Delícias da Vovó', 'Buffet com cardápio tradicional caseiro', 400, 1500.00, 180, 'caminho/comprovante3.jpg', 1, 1, '2022-12-30 10:10:00', 3, 3),
('Buffet Festivo', 'Buffet com opções para festas de aniversário', 200, 1200.00, 100, 'caminho/comprovante4.jpg', 1, 1, '2023-01-02 13:25:00', 4, 4),
('Sabores Exóticos', 'Buffet com pratos de culinária internacional', 600, 2800.00, 250, 'caminho/comprovante5.jpg', 1, 1, '2023-01-05 16:45:00', 5, 5),
('Buffet da Praia', 'Buffet especializado em eventos na praia', 350, 2000.00, 120, 'caminho/comprovante6.jpg', 1, 1, '2023-01-03 11:30:00', 6, 6),
('Festas Divertidas', 'Buffet com opções temáticas para festas infantis', 250, 1500.00, 80, 'caminho/comprovante7.jpg', 1, 1, '2023-02-07 17:20:00', 6, 7),
('Buffet dos Sonhos', 'Buffet premium com serviço de alto padrão', 800, 5000.00, 400, 'caminho/comprovante8.jpg', 1, 1, '2023-02-04 08:40:00', 7, 8),
('Sabor da Roça', 'Buffet com comidas típicas da culinária caipira', 350, 1800.00, 120, 'caminho/comprovante9.jpg', 1, 1,'2023-02-06 12:05:00', 8, 9),
('Buffet Tropical', 'Buffet com opções de pratos tropicais e frutas frescas', 300, 1600.00, 100, 'caminho/comprovante10.jpg', 1, 1, '2023-03-09 15:15:00', 8, 10),
('Festa dos Sabores', 'Buffet com variedade de pratos para festas de casamento', 500, 3000.00, 200, 'caminho/comprovante11.jpg', 1, 1, '2023-03-10 10:30:00', 8, 11),
('Sabor Oriental', 'Buffet com pratos da culinária asiática', 400, 2200.00, 150, 'caminho/comprovante12.jpg', 1, 1,  '2023-03-12 14:50:00', 9, 12),
('Buffet da Alegria', 'O Buffet da Alegria oferece uma experiência incrível em festas e eventos. Nossa equipe dedicada está pronta para proporcionar momentos inesquecíveis para você e seus convidados. Contamos com um cardápio variado, decoração temática e atividades divertidas para crianças.', 500, 3000.00, 100, NULL, 1, 1,  '2023-04-11 09:30:00',10, 3),
('Buffet Encantado', 'O Buffet Encantado é perfeito para tornar o seu evento mágico e encantador. Com decorações temáticas, cardápio variado e uma equipe de profissionais qualificados, garantimos que seu evento será inesquecível.', 400, 2500.00, 80, NULL, 1, 1, '2023-04-14 13:55:00', 11, 4),
('Buffet Mania', 'Realize o seu sonho com o Buffet dos Sonhos. Oferecemos um cardápio diversificado, decoração personalizada e uma equipe dedicada em tornar seu evento especial. Seja qual for a ocasião, estamos prontos para fazer parte desse momento único.', 300, 2000.00, 50, NULL, 1, 1, '2023-04-13 10:25:00',12, 5),
('Festa & Cia', 'O Buffet Festivo é a escolha perfeita para festas animadas e cheias de diversão. Contamos com uma equipe de animadores, brinquedos infláveis, música e uma variedade de comidas deliciosas. Garanta a alegria dos seus convidados com o Buffet Festivo.', 600, 3500.00, 120, NULL, 1, 1, '2023-04-14 13:55:00',13, 6),
('Buffet dos Sabores', 'O Buffet dos Sabores é especializado em oferecer uma experiência gastronômica única. Nossos pratos são preparados com ingredientes frescos e selecionados, proporcionando um sabor inigualável. Surpreenda seus convidados com o Buffet dos Sabores.', 400, 2800.00, 100, NULL, 1, 1, '2023-05-14 13:55:00', 14, 7),
('Buffet Mágico', 'O Buffet Mágico transforma seu evento em um verdadeiro espetáculo. Com shows de mágica, palhaços e brincadeiras interativas, garantimos a diversão de crianças e adultos. Conte com o Buffet Mágico para criar momentos memoráveis.', 500, 3200.00, 80, NULL, 1, 1, '2023-05-14 13:55:00', 15, 8);


INSERT INTO `eventify`.`mensagem` (mensagem, mandado_por, data, id_usuario, id_buffet) VALUES
('Olá, gostaria de solicitar um orçamento para um evento corporativo que acontecerá em São Paulo no próximo mês. Podem me enviar mais informações?', 0, '2023-05-16 10:30:00', 28, 19),
('Prezado cliente, agradecemos pelo contato. Claro, podemos enviar todas as informações necessárias. Por favor, nos informe a data e a quantidade de convidados para que possamos preparar o orçamento.', 1, '2023-05-16 11:15:00', 28, 1),
('Olá! Gostaria de saber se vocês têm disponibilidade para o dia 15 de junho para um casamento íntimo. Seriam aproximadamente 50 convidados. Aguardo retorno.', 0, '2023-05-16 14:20:00', 29, 2),
('Bom dia! Agradecemos o seu contato. Sim, temos disponibilidade para a data mencionada. Vamos enviar todas as informações para o seu e-mail. Fique atento(a) à sua caixa de entrada.', 1, '2023-05-16 14:35:00', 29, 2),
('Olá, estou interessado em contratar os serviços de buffet para um aniversário de 18 anos. Seriam cerca de 80 pessoas. Vocês poderiam me enviar um orçamento?', 0, '2023-05-16 16:40:00', 30, 3),
('Olá! Com certeza, podemos enviar o orçamento. Para isso, precisamos de algumas informações adicionais, como a data e o local do evento. Assim, poderemos preparar um orçamento personalizado para você. Aguardamos seu retorno.', 1, '2023-05-16 17:10:00', 30, 3),
('Boa tarde, gostaria de agendar uma degustação para conhecer melhor o cardápio antes de fechar o contrato. Vocês possuem disponibilidade?', 0, '2023-05-17 09:25:00', 31, 4),
('Olá! Com certeza, podemos agendar uma degustação. Por favor, nos informe algumas opções de datas e horários que sejam convenientes para você, e faremos o possível para atender sua solicitação.', 1, '2023-05-17 09:45:00', 31, 4),
('Olá, estou organizando um evento corporativo e gostaria de saber se vocês oferecem serviços de decoração também, além do buffet.', 0, '2023-05-18 14:30:00', 32, 5),
('Olá! Sim, oferecemos serviços de decoração também. Tem s opções personalizadas de acordo com o estilo e as preferências do seu evento. Podemos enviar mais informações sobre os pacotes de decoração disponíveis. Aguardamos seu retorno.', 1, '2023-05-18 15:00:00', 32, 5),
('Olá, gostaria de solicitar um orçamento para um casamento que acontecerá em novembro. Vocês têm disponibilidade?', 0, '2023-05-19 11:30:00', 33, 6),
('Olá! Claro, podemos fornecer um orçamento para o seu casamento em novembro. Por favor, nos informe a data exata e a quantidade de convidados para que possamos enviar as informações detalhadas.', 1, '2023-05-19 12:00:00', 33, 6),
('Boa tarde, estou interessado em contratar um serviço de buffet para um evento corporativo. Seriam cerca de 100 pessoas. Gostaria de saber quais são as opções de cardápio disponíveis.', 0, '2023-05-19 14:45:00', 34, 7),
('Olá! Temos várias opções de cardápio disponíveis para eventos corporativos. Podemos enviar o nosso menu completo com todas as opções. Por favor, nos informe seu e-mail para que possamos enviar as informações.', 1, '2023-05-19 15:15:00', 34, 7),
('Olá, estou planejando um evento de aniversário para minha filha de 10 anos. Gostaria de saber se vocês oferecem serviços de entretenimento para crianças.', 0, '2023-05-20 09:30:00', 35, 8),
('Olá! Sim, oferecemos serviços de entretenimento para crianças em eventos. Temos opções de recreação, palhaços, pintura facial e muito mais. Podemos enviar mais informações sobre os serviços disponíveis. Aguardamos seu retorno.', 1, '2023-05-20 10:00:00', 35, 8),
('Bom dia, estou planejando um jantar de gala para arrecadar fundos para uma instituição de caridade. Gostaria de saber se vocês oferecem serviços de catering para esse tipo de evento.', 0, '2023-05-20 14:30:00', 36, 9),
('Olá! Sim, oferecemos serviços de catering para eventos beneficentes. Podemos preparar um cardápio sofisticado de acordo com suas necessidades e ajudar a tornar o evento um sucesso. Aguardamos seu contato.', 1, '2023-05-20 15:00:00', 36, 9),
('Olá, gostaria de agendar uma visita ao local do evento para discutir os detalhes e ver as instalações. Vocês têm disponibilidade?', 0, '2023-05-21 10:15:00', 37, 10),
('Olá! Com certeza, podemos agendar uma visita ao local do evento. Por favor, nos informe algumas opções de datas e horários que sejam convenientes para você, e faremos o possível para agendar a visita. Aguardamos seu retorno.', 1, '2023-05-21 10:45:00', 37, 10),
('Olá, gostaria de solicitar um orçamento para um casamento que acontecerá em novembro. Vocês têm disponibilidade?', 0, '2023-05-19 11:30:00', 33, 6),
('Olá! Claro, podemos fornecer um orçamento para o seu casamento em novembro. Por favor, nos informe a data exata e a quantidade de convidados para que possamos enviar as informações detalhadas.', 1, '2023-05-19 12:00:00', 33, 6),
('Boa tarde, estou interessado em contratar um serviço de buffet para um evento corporativo. Seriam cerca de 100 pessoas. Gostaria de saber quais são as opções de cardápio disponíveis.', 0, '2023-05-19 14:45:00', 34, 7),
('Olá! Temos várias opções de cardápio disponíveis para eventos corporativos. Podemos enviar o nosso menu completo com todas as opções. Por favor, nos informe seu e-mail para que possamos enviar as informações.', 1, '2023-05-19 15:15:00', 34, 7),
('Olá, estou planejando um evento de aniversário para minha filha de 10 anos. Gostaria de saber se vocês oferecem serviços de entretenimento para crianças.', 0, '2023-05-20 09:30:00', 35, 8),
('Olá! Sim, oferecemos serviços de entretenimento para crianças em eventos. Temos opções de recreação, palhaços, pintura facial e muito mais. Podemos enviar mais informações sobre os serviços disponíveis. Aguardamos seu retorno.', 1, '2023-05-20 10:00:00', 35, 8),
('Bom dia, estou planejando um jantar de gala para arrecadar fundos para uma instituição de caridade. Gostaria de saber se vocês oferecem serviços de catering para esse tipo de evento.', 0, '2023-05-20 14:30:00', 36, 9),
('Olá! Sim, oferecemos serviços de catering para eventos beneficentes. Podemos preparar um cardápio sofisticado de acordo com suas necessidades e ajudar a tornar o evento um sucesso. Aguardamos seu contato.', 1, '2023-05-20 15:00:00', 36, 9),
('Olá, gostaria de agendar uma visita ao local do evento para discutir os detalhes e ver as instalações. Vocês têm disponibilidade?', 0, '2023-05-21 10:15:00', 37, 10),
('Olá! Com certeza, podemos agendar uma visita ao local do evento. Por favor, nos informe algumas opções de datas e horários que sejam convenientes para você, e faremos o possível para agendar a visita. Aguardamos seu retorno.', 1, '2023-05-21 10:45:00', 37, 10),
('Olá, gostaria de obter informações sobre os serviços de buffet para um casamento. Poderiam me enviar opções de cardápio e valores?', 0, '2023-05-24 14:30:00', 43, 16),
('Olá! Claro, podemos enviar todas as informações sobre os serviços de buffet. Vamos preparar um pacote personalizado para o seu casamento. Em breve você receberá todas as opções e valores. Aguarde.', 1, '2023-05-24 15:00:00', 43, 16),
('Boa tarde, estou organizando uma festa de aniversário para meu filho e gostaria de contratar os serviços de buffet infantil. Vocês têm disponibilidade para a data e podem me enviar um orçamento?', 0, '2023-05-25 09:45:00', 44, 17),
('Olá! Temos disponibilidade para a data da festa de aniversário. Vamos preparar um orçamento com opções de buffet infantil para você. Em breve, enviaremos por e-mail todas as informações. Obrigado pelo contato.', 1, '2023-05-25 10:15:00', 44, 17),
('Olá, estou interessado em contratar os serviços de buffet para um evento empresarial. Gostaria de saber se vocês oferecem opções de menu vegetariano.', 0, '2023-05-26 11:00:00', 45, 18),
('Olá! Sim, oferecemos opções de menu vegetariano em nosso buffet. Podemos preparar um cardápio personalizado de acordo com as suas preferências e restrições alimentares. Enviamos mais informações por e-mail. Aguardamos seu retorno.', 1, '2023-05-26 11:30:00', 45, 18),
('Bom dia! Gostaria de solicitar um orçamento para um evento corporativo que acontecerá em nosso escritório. Vocês têm disponibilidade para a data?', 0, '2023-05-27 09:30:00', 46, 1),
('Olá! Sim, temos disponibilidade para a data do evento corporativo em seu escritório. Vamos preparar um orçamento personalizado com todos os detalhes. Em breve, você receberá por e-mail todas as informações. Obrigado pelo contato.', 1, '2023-05-27 10:00:00', 46, 1),
('Olá, estou interessado em contratar os serviços de buffet para uma festa de formatura. Seriam aproximadamente 100 convidados. Poderiam me enviar um orçamento?', 0, '2023-05-27 14:30:00', 47, 2),
('Olá! Com certeza, podemos enviar o orçamento para a festa de formatura. Por favor, nos informe a data e o local do evento para que possamos preparar uma proposta personalizada. Aguardamos seu retorno.', 1, '2023-05-27 15:00:00', 47, 2);


INSERT INTO `eventify`.`buffet_faixa_etaria` (`id_buffet`, `id_faixa_etaria`) VALUES
(19, 1),
(19, 2),
(19, 3),
(2, 4),
(2, 5),
(3, 3),
(3, 6),
(3, 7),
(4, 6),
(5, 8),
(5, 9),
(6, 4),
(6, 7),
(7, 7),
(7, 10),
(8, 1),
(8, 5),
(9, 6),
(9, 9),
(10, 4),
(10, 9),
(11, 1),
(11, 8),
(12, 3),
(12, 9),
(13, 6),
(13, 10),
(14, 4),
(14, 10),
(15, 5),
(15, 6),
(15, 7),
(15, 8),
(16, 1),
(16, 2),
(16, 3),
(16, 4),
(17, 7),
(17, 8),
(17, 9),
(17, 10),
(18, 6),
(18, 7),
(18, 8),
(18, 9),
(18, 10);


INSERT INTO `eventify`.`buffet_tipo_evento` (`id_buffet`, `id_tipo_evento`) VALUES
(19, 1),
(2, 3),
(2, 4),
(3, 2),
(4, 2),
(5, 3),
(6, 2),
(6, 6),
(7, 6),
(8, 1),
(8, 2),
(9, 3),
(10, 2),
(10, 4),
(11, 1),
(12, 3),
(13, 6),
(13, 7),
(14, 4),
(14, 5),
(15, 6),
(15, 7),
(16, 6),
(16, 7),
(17, 6),
(17, 7),
(18, 6),
(18, 7);


INSERT INTO `eventify`.`buffet_servico` (`id_buffet`, `id_servico`) VALUES
(19, 1),
(19, 2),
(19, 3),
(2, 2),
(2, 4),
(2, 6),
(3, 1),
(3, 3),
(4, 1),
(4, 5),
(5, 1),
(5, 3),
(5, 7),
(6, 2),
(6, 6),
(7, 1),
(7, 6),
(8, 1),
(8, 4),
(8, 5),
(9, 1),
(9, 3),
(9, 6),
(10, 1),
(10, 3),
(10, 7),
(11, 2),
(11, 3),
(11, 6),
(12, 1),
(12, 3),
(12, 4),
(13, 1),
(13, 3),
(13, 6),
(13, 7),
(14, 1),
(14, 3),
(14, 6),
(14, 7),
(15, 1),
(15, 3),
(15, 4),
(15, 5),
(16, 1),
(16, 3),
(16, 4),
(16, 5),
(17, 1),
(17, 3),
(17, 4),
(17, 5),
(18, 1),
(18, 3),
(18, 4),
(18, 5);


INSERT INTO `eventify`.`pagamento` (is_pago_contrato, data_pago, is_pago_buffet)
VALUES (1, '2023-01-19 10:00:00', 1),
       (1, '2023-01-20 14:30:00', 1),
       (1, '2023-01-21 18:45:00', 1),
       (1, '2023-01-22 09:15:00', 1),
       (1, '2023-01-23 16:20:00', 1),
       (1, '2023-01-24 11:30:00', 1),
       (1, '2023-01-25 13:45:00', 1),
       (1, '2023-01-26 19:00:00', 1),
       (1, '2023-01-27 15:10:00', 1),
       (1, '2023-01-28 12:20:00', 1),
       (1, '2023-01-11 10:00:00', 1),
       (1, '2023-01-12 14:30:00', 1),
       (1, '2023-01-13 18:45:00', 1),
       (1, '2023-01-14 09:15:00', 1),
       (1, '2023-01-15 16:20:00', 1),
       (1, '2023-01-16 11:30:00', 1),
       (1, '2023-01-17 13:45:00', 1),
       (1, '2023-01-18 19:00:00', 1),
       (1, '2023-01-19 15:10:00', 1),
       (1, '2023-01-20 12:20:00', 1),
       (1, '2023-01-11 10:00:00', 1),
       (1, '2023-01-12 14:30:00', 1),
       (1, '2023-01-13 18:45:00', 1),
       (1, '2023-01-14 09:15:00', 1),
       (1, '2023-01-15 16:20:00', 1),
       (1, '2023-01-16 11:30:00', 1),
       (1, '2023-01-17 13:45:00', 1),
       (1, '2023-02-18 19:00:00', 1),
       (1, '2023-02-19 15:10:00', 1),
       (1, '2023-02-20 12:20:00', 1),
       (1, '2023-02-11 10:00:00', 1),
       (1, '2023-02-12 14:30:00', 1),
       (1, '2023-02-13 18:45:00', 1),
       (1, '2023-02-14 09:15:00', 1),
       (1, '2023-02-15 16:20:00', 1),
       (1, '2023-02-16 11:30:00', 1),
       (1, '2023-02-17 13:45:00', 1),
       (1, '2023-02-18 19:00:00', 1),
       (1, '2023-02-19 15:10:00', 1),
       (1, '2023-02-20 12:20:00', 1),
       (1, '2023-02-11 10:00:00', 1),
       (1, '2023-03-12 14:30:00', 1),
       (1, '2023-03-13 18:45:00', 1),
       (1, '2023-03-14 09:15:00', 1),
       (1, '2023-03-15 16:20:00', 1),
       (1, '2023-03-16 11:30:00', 1),
       (1, '2023-03-17 13:45:00', 1),
       (1, '2023-03-18 19:00:00', 1),
       (1, '2023-03-19 15:10:00', 1),
       (1, '2023-03-20 12:20:00', 1),
       (1, '2023-03-11 10:00:00', 1),
       (1, '2023-03-12 14:30:00', 1),
       (1, '2023-03-13 18:45:00', 1),
       (1, '2023-03-14 09:15:00', 1),
       (1, '2023-03-15 16:20:00', 1),
       (1, '2023-03-16 11:30:00', 1),
       (1, '2023-03-17 13:45:00', 1),
       (1, '2023-03-18 19:00:00', 0),
       (1, '2023-04-19 15:10:00', 0),
       (1, '2023-04-20 12:20:00', 0),
       (1, '2023-04-11 10:00:00', 0),
       (1, '2023-04-12 14:30:00', 0),
       (1, '2023-04-13 18:45:00', 0),
       (1, '2023-04-14 09:15:00', 0),
       (1, '2023-04-15 16:20:00', 0),
       (1, '2023-04-16 11:30:00', 0),
       (1, '2023-04-17 13:45:00', 0),
       (1, '2023-04-18 19:00:00', 0),
       (1, '2023-04-19 15:10:00', 0),
       (1, '2023-04-20 12:20:00', 0),
       (1, '2023-04-11 10:00:00', 0),
       (1, '2023-04-12 14:30:00', 0),
       (1, '2023-04-13 18:45:00', 0),
       (1, '2023-04-14 09:15:00', 0),
       (1, '2023-04-15 16:20:00', 0),
       (1, '2023-04-16 11:30:00', 0),
       (1, '2023-04-17 13:45:00', 0),
       (1, '2023-04-18 19:00:00', 0),
       (1, '2023-04-19 15:10:00', 0),
       (1, '2023-01-20 12:20:00', 0),
       (1, '2023-05-01 10:30:00', 0),
       (1, '2023-05-02 15:45:00', 0),
       (1, '2023-05-03 11:00:00', 0),
       (1, '2023-05-04 16:15:00', 0),
       (1, '2023-05-05 12:30:00', 0),
       (1, '2023-05-06 17:45:00', 0),
       (1, '2023-05-07 14:00:00', 0),
       (1, '2023-05-08 09:15:00', 0),
       (1, '2023-05-09 14:30:00', 0),
       (1, '2023-05-10 10:45:00', 0),
       (1, '2023-05-11 16:00:00', 0),
       (1, '2023-05-12 11:15:00', 0),
       (1, '2023-05-13 16:30:00', 0),
       (1, '2023-05-14 12:45:00', 0),
       (1, '2023-05-15 18:00:00', 0),
       (1, '2023-05-16 13:15:00', 0),
       (1, '2023-05-17 09:30:00', 0),
       (1, '2023-05-18 14:45:00', 0),
       (1, '2023-05-19 10:00:00', 0),
       (1, '2023-05-20 15:15:00', 0);
       

INSERT INTO `eventify`.`evento` (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento)
VALUES 
('2023-02-02 14:30:00', 2000.00, 'Evento incrível!', 4.8, 6, NULL, 0, 1, '2023-01-02 14:30:00', 103, 2),
('2023-02-03 18:45:00', 1800.50, 'Gostei bastante!', 4.2, 6, NULL, 1, 1, '2023-01-03 18:45:00', 105, 3),
('2023-02-04 11:15:00', 1200.00, 'Superou minhas expectativas!', 4.9, 1, NULL, 0, 8, '2023-01-04 11:15:00', 234, 4),
('2023-02-05 16:30:00', 3000.00, 'Maravilhoso evento!', 4.7, 6, NULL, 1, 15, '2023-01-05 16:30:00', 236, 5),
('2023-02-06 10:45:00', 2500.00, 'Adorei tudo!', 4.6, 6, NULL, 0, 18, '2023-01-06 10:45:00', 238, 6),
('2023-02-07 13:30:00', 1750.50, 'Muito bom!', 4.3, 6, NULL, 1, 7, '2023-01-07 13:30:00', 240, 7),
('2023-02-08 19:15:00', 1900.00, 'Evento top!', 4.8, 6, NULL, 0, 11, '2023-01-08 19:15:00', 242, 8),
('2023-02-09 15:00:00', 2200.50, 'Recomendo!', 4.4, 6, NULL, 1, 14, '2023-01-09 15:00:00', 244, 9),
('2023-02-10 12:30:00', 1700.00, 'Excelente!', 4.9, 6, NULL, 0, 17, '2023-01-10 12:30:00', 246, 10),
('2023-02-01 09:00:00', 1800.00, 'Evento sensacional!', 4.7, 6, NULL, 1, 6, '2023-01-01 09:00:00', 229, 11),
('2023-02-02 14:30:00', 2100.00, 'Muito bem organizado!', 4.8, 6, NULL, 0, 9, '2023-01-02 14:30:00', 231, 12),
('2023-02-03 18:45:00', 1950.50, 'Ótima experiência!', 4.6, 6, NULL, 1, 13, '2023-01-03 18:45:00', 233, 13),
('2023-02-04 11:15:00', 1300.00, 'Recomendo fortemente!', 4.9, 6, NULL, 0, 7, '2023-01-04 11:15:00', 235, 14),
('2023-02-05 16:30:00', 2800.00, 'Não poderia ser melhor!', 4.8, 6, NULL, 1, 16, '2023-01-05 16:30:00', 237, 15),
('2023-02-06 10:45:00', 2400.00, 'Tudo perfeito!', 4.7, 6, NULL, 0, 17, '2023-01-06 10:45:00', 239, 16),
('2023-02-07 13:30:00', 1650.50, 'Incrível!', 4.5, 6, NULL, 1, 8, '2023-01-07 13:30:00', 241, 17),
('2023-02-08 19:15:00', 2000.00, 'Fantástico evento!', 4.9, 6, NULL, 0, 12, '2023-01-08 19:15:00', 243, 18),
('2023-02-09 15:00:00', 2300.50, 'Adorei cada momento!', 4.5, 6, NULL, 1, 15, '2023-01-09 15:00:00', 245, 19),
('2023-02-10 12:45:00', 1750.00, 'Superou minhas expectativas!', 4.6, 6, NULL, 0, 18, '2023-01-10 12:45:00', 247, 20),
('2023-02-01 09:00:00', 1800.00, 'Evento sensacional!', 4.7, 6, NULL, 1, 6, '2023-01-01 09:00:00', 103, 21),
('2023-02-02 14:30:00', 2100.00, 'Muito bem organizado!', 4.8, 6, NULL, 0, 9, '2023-01-02 14:30:00', 231, 22),
('2023-03-03 18:45:00', 1950.50, 'Ótima experiência!', 4.6, 6, NULL, 1, 13, '2023-01-03 18:45:00', 233, 23),
('2023-03-04 11:15:00', 1300.00, 'Recomendo fortemente!', 4.9, 6, NULL, 0, 7, '2023-01-04 11:15:00', 235, 24),
('2023-03-05 16:30:00', 2800.00, 'Não poderia ser melhor!', 4.8, 6, NULL, 1, 16, '2023-01-05 16:30:00', 237, 25),
('2023-03-06 10:45:00', 2400.00, 'Tudo perfeito!', 4.7, 6, NULL, 0, 17, '2023-01-06 10:45:00', 239, 26),
('2023-03-07 13:30:00', 1650.50, 'Incrível!', 4.5, 6, NULL, 1, 8, '2023-01-07 13:30:00', 241, 27),
('2023-03-08 19:15:00', 2000.00, 'Fantástico evento!', 4.9, 6, NULL, 0, 12, '2023-01-08 19:15:00', 243, 28),
('2023-03-09 15:00:00', 2300.50, 'Adorei cada momento!', 4.5, 6, NULL, 1, 15, '2023-01-09 15:00:00', 245, 29),
('2023-03-10 12:45:00', 1750.00, 'Superou minhas expectativas!', 4.6, 6, NULL, 0, 18, '2023-01-10 12:45:00', 103, 30),
('2023-03-01 09:00:00', 1800.00, 'Evento incrível!', 4.7, 6, NULL, 1, 11, '2023-01-01 09:00:00', 230, 31),
('2023-03-02 14:30:00', 2100.00, 'Melhor evento da cidade!', 4.8, 6, NULL, 0, 14, '2023-01-02 14:30:00', 232, 32),
('2023-03-03 18:45:00', 1950.50, 'Surpreendente!', 4.6, 6, NULL, 1, 8, '2023-01-03 18:45:00', 234, 33),
('2023-03-04 11:15:00', 1300.00, 'Não poderia ser melhor!', 4.9, 6, NULL, 0, 16, '2023-01-04 11:15:00', 236, 34),
('2023-03-05 16:30:00', 2800.00, 'Experiência única!', 4.8, 6, NULL, 1, 17, '2023-01-05 16:30:00', 238, 35),
('2023-04-06 10:45:00', 2400.00, 'Evento memorável!', 4.7, 6, NULL, 0, 9, '2023-01-06 10:45:00', 240, 36),
('2023-04-07 13:30:00', 1650.50, 'Incrível organização!', 4.5, 6, NULL, 1, 13, '2023-01-07 13:30:00', 242, 37),
('2023-04-08 19:15:00', 2000.00, 'Fantástico evento!', 4.9, 6, NULL, 0, 6, '2023-01-08 19:15:00', 244, 38),
('2023-04-09 15:00:00', 2300.50, 'Momentos inesquecíveis!', 4.5, 6, NULL, 1, 15, '2023-01-09 15:00:00', 246, 39),
('2023-04-10 12:30:00', 1750.00, 'Superou todas as expectativas!', 4.6, 6, NULL, 0, 18, '2023-01-10 12:30:00', 248, 40),
('2023-04-01 09:00:00', 1800.00, 'Evento incrível!', 4.7, 6, NULL, 1, 12, '2023-01-01 09:00:00', 231, 41),
('2023-04-02 14:30:00', 2100.00, 'Melhor evento da cidade!', 4.8, 6, NULL, 0, 15, '2023-01-02 14:30:00', 233, 42),
('2023-04-03 18:45:00', 1950.50, 'Surpreendente!', 4.6, 6, NULL, 1, 9, '2023-01-03 18:45:00', 235, 43),
('2023-04-04 11:15:00', 1300.00, 'Não poderia ser melhor!', 4.9, 6, NULL, 0, 17, '2023-01-04 11:15:00', 237, 44),
('2023-04-05 16:30:00', 2800.00, 'Experiência única!', 4.8, 6, NULL, 1, 18, '2023-01-05 16:30:00', 239, 45),
('2023-04-06 10:45:00', 2400.00, 'Evento memorável!', 4.7, 6, NULL, 0, 10, '2023-01-06 10:45:00', 241, 46),
('2023-04-07 13:30:00', 1650.50, 'Incrível organização!', 4.5, 6, NULL, 1, 14, '2023-01-07 13:30:00', 243, 47),
('2023-04-08 19:15:00', 2000.00, 'Fantástico evento!', 4.9, 6, NULL, 0, 7, '2023-01-08 19:15:00', 245, 48),
('2023-05-09 15:00:00', 2300.50, 'Momentos inesquecíveis!', 4.5, 6, NULL, 1, 16, '2023-01-09 15:00:00', 247, 49),
('2023-05-10 12:45:00', 1750.00, 'Adorei cada detalhe!', 4.6, 6, NULL, 0, 11, '2023-01-10 12:45:00', 249, 50),
('2023-05-01 09:00:00', 1800.00, 'Evento incrível!', 4.7, 6, NULL, 1, 12, '2023-01-01 09:00:00', 231, 41),
('2023-05-02 14:30:00', 2100.00, 'Melhor evento da cidade!', 4.8, 6, NULL, 0, 15, '2023-01-02 14:30:00', 233, 42),
('2023-05-03 18:45:00', 1950.50, 'Surpreendente!', 4.6, 6, NULL, 1, 9, '2023-01-03 18:45:00', 235, 43),
('2023-05-04 11:15:00', 1300.00, 'Não poderia ser melhor!', 4.9, 6, NULL, 0, 17, '2023-01-04 11:15:00', 237, 44),
('2023-05-05 16:30:00', 2800.00, 'Experiência única!', 4.8, 6, NULL, 1, 18, '2023-01-05 16:30:00', 239, 45),
('2023-05-06 10:45:00', 2400.00, 'Evento memorável!', 4.7, 6, NULL, 0, 10, '2023-01-06 10:45:00', 241, 46),
('2023-05-07 13:30:00', 1650.50, 'Incrível organização!', 4.5, 6, NULL, 1, 14, '2023-01-07 13:30:00', 243, 47),
('2023-05-08 19:15:00', 2000.00, 'Fantástico evento!', 4.9, 6, NULL, 0, 7, '2023-01-08 19:15:00', 245, 48),
('2023-05-09 15:00:00', 2300.50, 'Momentos inesquecíveis!', 4.5, 6, NULL, 1, 16, '2023-01-09 15:00:00', 247, 49),
('2023-05-10 12:45:00', 1750.00, 'Adorei cada detalhe!', 4.6, 6, NULL, 0, 11, '2023-01-10 12:45:00', 249, 50),
('2023-05-01 09:00:00', 1800.00, NULL, NULL, 5, NULL, 1, 15, '2023-01-01 09:00:00', 233, 61),
('2023-06-02 14:30:00', 2100.00, NULL, NULL, 5, NULL, 0, 18, '2023-01-02 14:30:00', 235, 62),
('2023-06-03 18:45:00', 1950.50, NULL, NULL, 5, NULL, 1, 10, '2023-01-03 18:45:00', 237, 63),
('2023-06-04 11:15:00', 1300.00, NULL, NULL, 5, NULL, 0, 12, '2023-01-04 11:15:00', 239, 64),
('2023-06-05 16:30:00', 2800.00, NULL, NULL, 5, NULL, 1, 14, '2023-01-05 16:30:00', 241, 65),
('2023-06-06 10:45:00', 2400.00, NULL, NULL, 5, NULL, 0, 17, '2023-01-06 10:45:00', 243, 66),
('2023-06-07 13:30:00', 1650.50, NULL, NULL, 5, NULL, 1, 9, '2023-01-07 13:30:00', 245, 67),
('2023-06-08 19:15:00', 2000.00, NULL, NULL, 5, NULL, 0, 11, '2023-02-08 19:15:00', 247, 68),
('2023-06-09 15:00:00', 2300.50, NULL, NULL, 5, NULL, 1, 13, '2023-02-09 15:00:00', 249, 69),
('2023-06-10 12:45:00', 1750.00, NULL, NULL, 5, NULL, 0, 15, '2023-02-10 12:45:00', 251, 70),
('2024-06-01 09:00:00', 1800.00, NULL, NULL, 5, NULL, 1, 15, '2024-02-01 09:00:00', 233, 71),
('2024-06-02 14:30:00', 2100.00, NULL, NULL, 5, NULL, 0, 18, '2024-02-02 14:30:00', 235, 72),
('2024-06-03 18:45:00', 1950.50, NULL, NULL, 5, NULL, 1, 10, '2024-02-03 18:45:00', 237, 73),
('2024-06-04 11:15:00', 1300.00, NULL, NULL, 5, NULL, 0, 12, '2024-02-04 11:15:00', 239, 74),
('2024-07-05 16:30:00', 2800.00, NULL, NULL, 5, NULL, 1, 17, '2024-02-05 16:30:00', 241, 75),
('2024-07-06 09:45:00', 1750.00, NULL, NULL, 5, NULL, 0, 11, '2024-02-06 09:45:00', 243, 76),
('2024-07-07 13:00:00', 2200.50, NULL, NULL, 5, NULL, 1, 14, '2024-02-07 13:00:00', 245, 77),
('2024-07-08 10:30:00', 1500.00, NULL, NULL, 5, NULL, 0, 16, '2024-02-08 10:30:00', 247, 78),
('2024-07-09 14:45:00', 1900.00, NULL, NULL, 5, NULL, 1, 13, '2024-02-09 14:45:00', 249, 79),
('2024-07-10 18:00:00', 2050.50, NULL, NULL, 5, NULL, 0, 10, '2024-02-10 18:00:00', 251, 80),
('2024-07-11 11:30:00', 1200.00, NULL, NULL, 5, NULL, 1, 18, '2024-02-11 11:30:00', 253, 81),
('2024-07-12 16:45:00', 2600.00, NULL, NULL, 5, NULL, 0, 11, '2024-02-12 16:45:00', 255, 82),
('2024-07-13 10:15:00', 1650.00, NULL, NULL, 5, NULL, 1, 15, '2024-02-13 10:15:00', 257, 83),
('2024-07-14 13:30:00', 2100.50, NULL, NULL, 5, NULL, 0, 12, '2024-02-14 13:30:00', 259, 84),
('2024-07-15 09:45:00', 1450.00, NULL, NULL, 5, NULL, 1, 16, '2024-02-15 09:45:00', 261, 85),
('2024-07-16 14:00:00', 1850.50, NULL, NULL, 5, NULL, 0, 13, '2024-02-16 14:00:00', 263, 86),
('2024-07-17 18:15:00', 2000.00, NULL, NULL, 5, NULL, 1, 10, '2024-02-17 18:15:00', 265, 87),
('2024-08-18 11:45:00', 1100.00, NULL, NULL, 5, NULL, 0, 17, '2024-02-18 11:45:00', 228, 88),
('2024-08-19 17:00:00', 2500.00, NULL, NULL, 5, NULL, 1, 14, '2024-02-19 17:00:00', 230, 89),
('2024-08-20 10:30:00', 1600.00, NULL, NULL, 5, NULL, 0, 11, '2024-02-20 10:30:00', 232, 90),
('2024-08-21 14:45:00', 1950.00, NULL, NULL, 5, NULL, 1, 18, '2024-02-21 14:45:00', 234, 91),
('2024-08-22 18:00:00', 2200.50, NULL, NULL, 5, NULL, 0, 15, '2024-02-22 18:00:00', 236, 92),
('2024-08-23 11:30:00', 1350.00, NULL, NULL, 5, NULL, 1, 13, '2024-02-23 11:30:00', 238, 93),
('2024-08-24 15:45:00', 1800.00, NULL, NULL, 5, NULL, 0, 12, '2024-02-24 15:45:00', 240, 94),
('2024-08-25 09:15:00', 2050.50, NULL, NULL, 5, NULL, 1, 16, '2024-02-25 09:15:00', 242, 95),
('2024-08-26 13:30:00', 1250.00, NULL, NULL, 5, NULL, 0, 10, '2024-02-26 13:30:00', 244, 96),
('2024-08-27 10:00:00', 2450.00, NULL, NULL, 5, NULL, 1, 11, '2024-02-27 10:00:00', 103, 97),
('2024-08-28 14:15:00', 1550.50, NULL, NULL, 5, NULL, 0, 14, '2024-02-28 14:15:00', 248, 98),
('2024-08-29 17:30:00', 1900.00, NULL, NULL, 5, NULL, 1, 17, '2024-02-29 17:30:00', 250, 99),
('2024-08-30 11:45:00', 2250.50, NULL, NULL, 5, NULL, 0, 15, '2024-02-27 11:45:00', 252, 100);
       

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento)
VALUES
        ('2023-09-01 10:00:00', NULL, NULL, NULL, 2, 'Local indisponível', 1, 19, '2023-04-01 10:00:00', 228, NULL),
        ('2023-09-02 15:30:00', NULL, NULL, NULL, 2, 'Conflito de horários', 1, 2, '2023-04-02 15:30:00', 229, NULL),
        ('2023-09-03 11:30:00', NULL, NULL, NULL, 2, 'Fornecedores não confirmaram', 1, 3, '2023-04-03 11:30:00', 230, NULL),
        ('2023-09-04 16:00:00', NULL, NULL, NULL, 2, 'Decoração não disponível', 1, 4, '2023-04-04 16:00:00', 231, NULL),
        ('2023-09-05 12:15:00', NULL, NULL, NULL, 2, 'Serviço de som não confirmado', 1, 5, '2023-04-05 12:15:00', 232, NULL),
        ('2023-09-06 17:30:00', NULL, NULL, NULL, 2, 'Buffet sem disponibilidade', 1, 6, '2023-04-06 17:30:00', 233, NULL),
        ('2023-09-07 14:30:00', NULL, NULL, NULL, 4, 'Problemas com a decoração', 1, 7, '2023-04-07 14:30:00', 234, NULL),
        ('2023-09-08 09:45:00', NULL, NULL, NULL, 4, 'Falta de confirmação do DJ', 1, 8, '2023-04-08 09:45:00', 235, NULL),
        ('2023-09-09 14:00:00', NULL, NULL, NULL, 4, 'Indisponibilidade do fotógrafo', 1, 9, '2023-04-09 14:00:00', 236, NULL),
        ('2023-09-10 10:15:00', NULL, NULL, NULL, 4, 'Problemas com o bolo', 1, 10, '2023-04-10 10:15:00', 237, NULL),
        ('2023-09-11 15:45:00', NULL, NULL, NULL, 4, 'Falta de confirmação dos músicos', 1, 11, '2023-04-11 15:45:00', 238, NULL),
        ('2023-09-12 11:00:00', NULL, NULL, NULL, 4, 'Problemas com os convites', 1, 12, '2023-04-12 11:00:00', 239, NULL),
        ('2023-09-13 16:15:00', NULL, NULL, NULL, 4, 'Falta de confirmação dos garçons', 1, 13, '2023-04-13 16:15:00', 240, NULL),
        ('2023-09-15 17:45:00', NULL, NULL, NULL, 4, 'Problemas com a iluminação', 1, 14, '2023-04-15 17:45:00', 241, NULL),
        ('2023-09-16 14:15:00', NULL, NULL, NULL, 4, 'Buffet não atende às restrições alimentares', 1, 15, '2023-04-16 14:15:00', 242, NULL),
        ('2023-09-17 10:30:00', NULL, NULL, NULL, 4, 'Falta de confirmação do serviço de valet', 1, 16, '2023-04-17 10:30:00', 243, NULL),
        ('2023-09-18 15:00:00', NULL, NULL, NULL, 4, 'Problemas com o transporte dos convidados', 1, 17, '2023-04-18 15:00:00', 244, NULL),
        ('2023-09-19 11:30:00', NULL, NULL, NULL, 4, 'Conflito com outro evento', 1, 18, '2023-04-19 11:30:00', 245, NULL),
        ('2023-09-20 16:45:00', NULL, NULL, NULL, 4, 'Falta de confirmação do local', 1, 12, '2023-04-20 16:45:00', 103, NULL),
        ('2023-09-21 13:00:00', NULL, NULL, NULL, 4, 'Problemas com a limpeza do local', 1, 17, '2023-04-21 13:00:00', 247, NULL);


INSERT INTO evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento)
VALUES
        ('2023-09-01 10:00:00', NULL, NULL, NULL, 1, NULL, 0, 19, '2023-06-01 10:00:00', 228, NULL),
        ('2023-09-02 15:30:00', NULL, NULL, NULL, 1, NULL, 0, 2, '2023-06-02 15:30:00', 229, NULL),
        ('2023-09-03 11:30:00', NULL, NULL, NULL, 1, NULL, 0, 3, '2023-06-03 11:30:00', 230, NULL),
        ('2023-09-04 16:00:00', NULL, NULL, NULL, 1, NULL, 0, 4, '2023-06-04 16:00:00', 31, NULL),
        ('2023-09-05 12:15:00', NULL, NULL, NULL, 1, NULL, 0, 5, '2023-06-05 12:15:00', 232, NULL),
        ('2023-09-06 17:30:00', NULL, NULL, NULL, 1, NULL, 0, 6, '2023-06-06 17:30:00', 233, NULL),
        ('2023-09-07 14:30:00', NULL, NULL, NULL, 1, NULL, 0, 7, '2023-06-07 14:30:00', 234, NULL),
        ('2023-09-08 09:45:00', NULL, NULL, NULL, 1, NULL, 0, 8, '2023-06-08 09:45:00', 235, NULL),
        ('2023-09-09 14:00:00', NULL, NULL, NULL, 1, NULL, 0, 9, '2023-06-09 14:00:00', 236, NULL),
        ('2023-09-10 10:15:00', NULL, NULL, NULL, 1, NULL, 0, 10, '2023-06-10 10:15:00', 103, NULL);
        

INSERT INTO evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento)
VALUES
        ('2023-09-11 15:45:00', NULL, NULL, NULL, 3, NULL, 0, 11, '2023-06-11 15:45:00', 138, NULL),
        ('2023-09-12 11:00:00', NULL, NULL, NULL, 3, NULL, 0, 12, '2023-06-12 11:00:00', 139, NULL),
        ('2023-09-13 16:15:00', NULL, NULL, NULL, 3, NULL, 0, 13, '2023-06-13 16:15:00', 340, NULL),
        ('2023-09-15 17:45:00', NULL, NULL, NULL, 3, NULL, 0, 14, '2023-06-15 17:45:00', 120, NULL),
        ('2023-09-16 14:15:00', NULL, NULL, NULL, 3, NULL, 0, 15, '2023-06-16 14:15:00', 119, NULL),
        ('2023-09-17 10:30:00', NULL, NULL, NULL, 3, NULL, 0, 16, '2023-06-17 10:30:00', 107, NULL),
        ('2023-09-18 15:00:00', NULL, NULL, NULL, 3, NULL, 0, 17, '2023-06-18 15:00:00', 108, NULL),
        ('2023-09-19 11:30:00', NULL, NULL, NULL, 3, NULL, 0, 19, '2023-06-19 11:30:00', 105, NULL),
        ('2023-09-20 16:45:00', NULL, NULL, NULL, 3, NULL, 0, 19, '2023-06-20 16:45:00', 104, NULL),
        ('2023-09-21 13:00:00', NULL, NULL, NULL, 3, NULL, 0, 19, '2023-06-21 13:00:00', 103, NULL);


INSERT INTO evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento)
VALUES
    ('2023-09-01 10:00:00', NULL, NULL, NULL, 7, NULL, 0, 19, '2023-06-01 10:00:00', 165, NULL),
    ('2023-09-02 15:30:00', NULL, NULL, NULL, 7, NULL, 0, 2, '2023-06-02 15:30:00', 166, NULL),
    ('2023-09-03 11:30:00', NULL, NULL, NULL, 7, NULL, 0, 3, '2023-06-03 11:30:00', 167, NULL),
    ('2023-09-04 16:00:00', NULL, NULL, NULL, 7, NULL, 0, 4, '2023-06-04 16:00:00', 168, NULL),
    ('2023-09-05 12:15:00', NULL, NULL, NULL, 7, NULL, 0, 5, '2023-06-05 12:15:00', 200, NULL),
    ('2023-09-06 17:30:00', NULL, NULL, NULL, 7, NULL, 0, 6, '2023-06-06 17:30:00', 103, NULL),
    ('2023-09-07 14:30:00', NULL, NULL, NULL, 7, NULL, 0, 7, '2023-06-07 14:30:00', 203, NULL),
    ('2023-09-08 09:45:00', NULL, NULL, NULL, 7, NULL, 0, 8, '2023-06-08 09:45:00', 205, NULL),
    ('2023-09-09 14:00:00', NULL, NULL, NULL, 7, NULL, 0, 9, '2023-06-09 14:00:00', 207, NULL),
    ('2023-09-10 10:15:00', NULL, NULL, NULL, 7, NULL, 0, 10, '2023-06-10 10:15:00', 103, NULL);
    

INSERT INTO agenda (data, id_buffet)
VALUES
    ('2023-02-01 09:00:00', 5),
    ('2023-02-02 14:30:00', 10),
    ('2023-02-03 18:45:00', 12),
    ('2023-02-04 11:15:00', 8),
    ('2023-02-05 16:30:00', 15),
    ('2023-02-06 10:45:00', 18),
    ('2023-02-07 13:30:00', 7),
    ('2023-02-08 19:15:00', 11),
    ('2023-02-09 15:00:00', 14),
    ('2023-02-10 12:30:00', 17),
    ('2023-02-01 09:00:00', 6),
    ('2023-02-02 14:30:00', 9),
    ('2023-02-03 18:45:00', 13),
    ('2023-02-04 11:15:00', 7),
    ('2023-02-05 16:30:00', 16),
    ('2023-02-06 10:45:00', 17),
    ('2023-02-07 13:30:00', 8),
    ('2023-02-08 19:15:00', 12),
    ('2023-02-09 15:00:00', 15),
    ('2023-02-10 12:45:00', 18),
    ('2023-02-01 09:00:00', 6),
    ('2023-02-02 14:30:00', 9),
    ('2023-03-03 18:45:00', 13),
    ('2023-03-04 11:15:00', 7),
    ('2023-03-05 16:30:00', 16),
    ('2023-03-06 10:45:00', 17),
    ('2023-03-07 13:30:00', 8),
    ('2023-03-08 19:15:00', 12),
    ('2023-03-09 15:00:00', 15),
    ('2023-03-10 12:45:00', 18),
    ('2023-03-01 09:00:00', 11),
    ('2023-03-02 14:30:00', 14),
    ('2023-03-03 18:45:00', 8),
    ('2023-03-04 11:15:00', 16),
    ('2023-03-05 16:30:00', 17),
    ('2023-04-06 10:45:00', 9),
    ('2023-04-07 13:30:00', 13),
    ('2023-04-08 19:15:00', 6),
    ('2023-04-09 15:00:00', 15),
    ('2023-04-10 12:30:00', 18),
    ('2023-04-01 09:00:00', 12),
    ('2023-04-02 14:30:00', 15),
    ('2023-04-03 18:45:00', 9),
    ('2023-04-04 11:15:00', 17),
    ('2023-04-05 16:30:00', 18),
    ('2023-04-06 10:45:00', 10),
    ('2023-04-07 13:30:00', 14),
    ('2023-04-08 19:15:00', 7),
    ('2023-05-09 15:00:00', 16),
    ('2023-05-10 12:45:00', 11),
    ('2023-05-01 09:00:00', 12),
    ('2023-05-02 14:30:00', 15),
    ('2023-05-03 18:45:00', 9),
    ('2023-05-04 11:15:00', 17),
    ('2023-05-05 16:30:00', 18),
    ('2023-05-06 10:45:00', 10),
    ('2023-05-07 13:30:00', 14),
    ('2023-05-08 19:15:00', 7),
    ('2023-05-09 15:00:00', 16),
    ('2023-05-10 12:45:00', 11),
    ('2023-05-01 09:00:00', 15),
    ('2023-06-02 14:30:00', 18),
    ('2023-06-03 18:45:00', 10),
    ('2023-06-04 11:15:00', 12),
    ('2023-06-05 16:30:00', 14),
    ('2023-06-06 10:45:00', 17),
    ('2023-06-07 13:30:00', 9),
    ('2023-06-08 19:15:00', 11),
    ('2023-06-09 15:00:00', 13),
    ('2023-06-10 12:45:00', 15),
    ('2024-06-01 09:00:00', 15),
    ('2024-06-02 14:30:00', 18),
    ('2024-06-03 18:45:00', 10),
    ('2024-06-04 11:15:00', 12),
    ('2024-07-05 16:30:00', 17),
    ('2024-07-06 09:45:00', 11),
    ('2024-07-07 13:00:00', 14),
    ('2024-07-08 10:30:00', 16),
    ('2024-07-09 14:45:00', 13),
    ('2024-07-10 18:00:00', 10),
    ('2024-07-11 11:30:00', 18),
    ('2024-07-12 16:45:00', 11),
    ('2024-07-13 10:15:00', 15),
    ('2024-07-14 13:30:00', 12),
    ('2024-07-15 09:45:00', 16),
    ('2024-07-16 14:00:00', 13),
    ('2024-07-17 18:15:00', 10),
    ('2024-08-18 11:45:00', 17),
    ('2024-08-19 17:00:00', 14),
    ('2024-08-20 10:30:00', 11),
    ('2024-08-21 14:45:00', 18),
    ('2024-08-22 18:00:00', 15),
    ('2024-08-23 11:30:00', 13),
    ('2024-08-24 15:45:00', 12),
    ('2024-08-25 09:15:00', 16),
    ('2024-08-26 13:30:00', 10),
    ('2024-08-27 10:00:00', 11),
    ('2024-08-28 14:15:00', 14),
    ('2024-08-29 17:30:00', 17),
    ('2024-08-30 11:45:00', 15);


INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet)
VALUES
('https://as2.ftcdn.net/v2/jpg/02/55/34/89/', '1000_F_255348958_9OPPRsAiorOEju9PiYBZ8vDKoUzFI3iI', 'jpg', 1, '2023-05-19 10:00:00', 19),
('https://as2.ftcdn.net/v2/jpg/00/93/66/49/', '500_F_93664925_T8Jli2LQKkRfllSe8NtQ1jM8SlTYj8h2', 'jpg', 1, '2023-05-20 22:00:00', 19),
('https://t3.ftcdn.net/jpg/00/51/68/68/', '360_F_51686853_HrFFFO2n3J4SsyW424iPZesJBm0XfEin', 'jpg', 1, '2023-05-20 04:00:00', 19),


('https://media-cdn.tripadvisor.com/media/photo-s/07/6e/b1/92/', 'amari-palm-reef-koh-samui', 'jpg', 1, '2023-05-19 11:00:00', 2),
('https://img.freepik.com/fotos-premium/', 'mesa-de-buffet-a-beira-mar-com-salada-fresca-e-pao_677754-4360', 'jpg', 1, '2023-05-20 23:00:00', 2),
('https://www.makelifelovely.com/wp-content/uploads/2017/06/', 'Blue-and-turquoise-candy-buffet-at-beach-wedding', 'jpg', 1, '2023-05-20 05:00:00', 2),

('https://www.sistemabuffet.com.br/wp-content/uploads/2018/09/', 'como-calcular-a-quantidade-de-comida-ideal-para-evento', 'jpg', 1, '2023-05-19 12:00:00', 3),
('https://howtostartanllc.com/images/business-ideas/business-idea-images/', 'buffet', 'jpg', 1, '2023-05-21 00:00:00', 3),
('https://as2.ftcdn.net/v2/jpg/00/41/73/01/', '1000_F_41730102_2l4JCeOf3Yzsh70KwuDT8AvKiUKf2AGv', 'jpg', 1, '2023-05-20 06:00:00', 3),

('https://cdn0.casamentos.com.br/vendor/0490/3_2/640/jpg/', 'dsc08765_13_220490', 'webp', 1, '2023-05-19 13:00:00', 4),
('https://cdn0.casamentos.com.br/vendor/0490/original/960/jpg/', 'dsc08791_13_220490', 'webp', 1, '2023-05-21 01:00:00', 4),
('https://cdn0.casamentos.com.br/vendor/0490/original/960/jpg/', 'dsc08822_13_220490', 'webp', 1, '2023-05-20 07:00:00', 4),

('https://media-cdn.tripadvisor.com/media/attractions-splice-spp-720x480/0a/07/09/', '50', 'jpg', 1, '2023-05-19 14:00:00', 5),
('https://media-cdn.tripadvisor.com/media/attractions-splice-spp-720x480/0a/cf/64/', '40', 'jpg', 1, '2023-05-20 08:00:00', 5),

('https://www.aceitosim.com.br/wp-content/uploads/2016/11/', 'buffet-de-casamento', 'jpg', 1, '2023-05-19 15:00:00', 6),
('https://sitiosaojorge.com.br/wp-content/uploads/2022/09/', 'buffet-de-comida-para-festas-e-eventos-1080x720', 'webp', 1, '2023-05-20 09:00:00', 6),

('https://www.zankyou.com.br/images/card-main/85a/3b70/550/475/w/234065/-/', '1588602783', 'jpg', 1, '2023-05-19 16:00:00', 7),
('https://asset1.zankyou.com/images/wervice-card-big/9d4/ed8c/1050/800/w/234065/-/', '1588602718', 'jpg', 1, '2023-05-20 10:00:00', 7),

('https://festaemagiabuffet.com.br/pt-br/img/', 'festa-magia-fachada', 'jpg', 1, '2023-05-19 17:00:00', 8),
('https://festaemagiabuffet.com.br/pt-br/img/', 'galeria-18', 'jpg', 1, '2023-05-20 11:00:00', 8),

('http://universodossonhos.com.br/wp-content/uploads/2017/05/', 'IMG_4178-1', 'jpg', 1, '2023-05-19 18:00:00', 9),
('http://universodossonhos.com.br/wp-content/uploads/2017/09/', 'D12', 'jpg', 1, '2023-05-20 12:00:00', 9),

('https://media-cdn.tripadvisor.com/media/photo-s/1b/b5/0f/b2/', 'buffet-comida-mineira', 'jpg', 1, '2023-05-19 19:00:00', 10),
('https://media-cdn.tripadvisor.com/media/photo-s/1b/b5/0f/8b/', 'varandao', 'jpg', 1, '2023-05-20 13:00:00', 10),

('https://cdn0.casamentos.com.br/vendor/5488/3_2/960/jpg/', '544795-385430584837997-715269306-n_13_125488', 'jpeg', 1, '2023-05-19 20:00:00', 11),
('https://cdn0.casamentos.com.br/vendor/5488/3_2/960/jpg/', '10402627-707440209303698-2270627783616839729-n_13_125488', 'jpeg', 1, '2023-05-20 14:00:00', 11),

('https://cdn0.casamentos.com.br/vendor/3469/original/960/jpg/', '4m3a8990_13_103469-166904524573338', 'webp', 1, '2023-05-19 21:00:00', 12),
('https://cdn0.casamentos.com.br/vendor/3469/original/960/jpg/', '4m3a7599_13_103469-168012115267059', 'webp', 1, '2023-05-20 15:00:00', 12),

('https://www.buffetmorenos.com.br/blog/wp-content/uploads/2016/03/', 'SDP_3361-300x200', 'jpg', 1, '2023-05-19 22:00:00', 13),
('https://www.buffetmorenos.com.br/blog/wp-content/uploads/2016/03/', 'SDP_3361-300x200', 'jpg', 1, '2023-05-20 16:00:00', 13),

('https://buffetalegriaecia.com.br/wp-content/uploads/2020/06/', 'B81945BB-1FD7-4AE7-9A97-F2341DFE7FA0-39F8E5D3-6122-4BDA-9D24-4FE2B987DE64-400x284', 'jpg', 1, '2023-05-19 23:00:00', 14),
('https://buffetalegriaecia.com.br/wp-content/uploads/2020/06/', 'WhatsApp-Image-2020-06-30-at-11.08.32-2', 'jpeg', 1, '2023-05-20 17:00:00', 14),

('https://www.buffets.net.br/imgempresas/', 'buffet-castelinho-encantado-3041-iWGu', 'jpg', 1, '2023-05-20 00:00:00', 15),
('https://www.buffets.net.br/imgempresas/', 'buffet-castelinho-encantado-3041-6jDv', 'jpg', 1, '2023-05-20 18:00:00', 15),

('https://buffetvirofesta.com.br/wp-content/uploads/2022/10/', 'IMG-20221008-WA0113-760x428', 'jpg', 1, '2023-05-20 19:00:00', 16),

('https://i0.wp.com/grupobisutti.com.br/wp-content/uploads/2022/10/', '2022-09-20-Boulevard-JK_030_@rafaelcruz_fotografia-scaled', 'jpeg', 1, '2023-05-20 02:00:00', 17),
('https://i0.wp.com/grupobisutti.com.br/wp-content/uploads/2020/01/', 'festa-pietra-quintela', 'jpg', 1, '2023-05-20 20:00:00', 17),

('https://buffetalegriaecia.com.br/wp-content/uploads/2018/10/', 'buffet-infantil', 'png', 1, '2023-05-20 03:00:00', 18),
('https://horamania.com.br/wp-content/uploads/2019/09/', 'salao-de-festa-sitio-cercado-hora-mania-e1570494731311', 'jpg', 1, '2023-05-20 21:00:00', 18);


-- Buffet 20 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida Goethe', 100, 'Rio Branco', 'Porto Alegre', 'RS', '90430001', -30.023100, -51.203790, '2023-03-02 16:30:49');

INSERT INTO `eventify`.`buffet` (`nome`, `descricao`, `tamanho`, `preco_medio_diaria`, `qtd_pessoas`, `caminho_comprovante`, `residencia_comprovada`, `is_visivel`, `data_criacao`, `id_usuario`, `id_endereco`) VALUES
('Buffet Jaques De Paul', 'O melhor buffet gourmet que você já viu!', 500, 3000.00, 400, 'caminho/comprovante20.jpg', 1, 1, '2022-12-01 09:15:00', 20, 20);

INSERT INTO `eventify`.`mensagem` (mensagem, mandado_por, data, id_usuario, id_buffet) VALUES
('Olá, preciso fazer um aniversário?', 0, '2023-05-16 10:30:00', 103, 20),
('Okay, como você deseja?', 1, '2023-05-16 11:15:00', 103, 20),
('Muitas bexigas?', 0, '2023-05-16 10:30:00', 103, 20),
('O que achou do atendimento?', 1, '2023-05-16 11:15:00', 103, 20);

INSERT INTO `eventify`.`buffet_faixa_etaria` (`id_buffet`, `id_faixa_etaria`) VALUES
(20, 5),
(20, 8),
(20, 9),
(20, 10);

INSERT INTO `eventify`.`buffet_tipo_evento` (`id_buffet`, `id_tipo_evento`) VALUES
(20, 1),
(20, 3),
(20, 4),
(20, 5);

INSERT INTO `eventify`.`buffet_servico` (`id_buffet`, `id_servico`) VALUES
(20, 1),
(20, 3),
(20, 4),
(20, 6);

INSERT INTO `eventify`.`pagamento` (is_pago_contrato, data_pago, is_pago_buffet) VALUES 
(1, '2023-01-18 00:00:00', 1),
(1, '2023-01-28 00:00:00', 1);

INSERT INTO `eventify`.`evento` (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES 
('2023-01-18 00:00:00', 1500.00, 'Maravilho! Minha filha adorou o aniversário..', 5, 6, NULL, 1, 20, '2022-12-01 09:00:00', 163, 122),
('2023-01-28 00:00:00', 2000.00, 'A melhor casa de culinária do Rio Grande do Sul!', 4.8, 6, NULL, 0, 20, '2022-12-02 14:30:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://www.bastidoresdatv.com.br/wp-content/uploads/2015/11/', 'Cozinha-sob-press%C3%A3o', 'jpg', 1, NOW(), 20);


-- Buffet 21 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua São Paulo', 200, 'Centro', 'São Paulo', 'SP', '01001000', -23.550520, -46.633308, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Aromas e Sabores', 'Deliciosas opções de comida para todos os gostos!', 400, 2500.00, 300, '', 1, 1, '2023-06-04 12:00:00', 21, 21);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(21, 5),
(21, 7),
(21, 8),
(21, 9);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(21, 1),
(21, 2),
(21, 4),
(21, 6);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(21, 1),
(21, 3),
(21, 4),
(21, 7);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 1800.00, 'Ótimo atendimento e comida deliciosa!', 4.5, 6, NULL, 1, 21, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2200.00, 'Festa incrível, todos os convidados adoraram!', 4.9, 6, NULL, 0, 21, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/3469/3_2/640/jpg/', '4m3a8990_13_103469-166904524573338', 'webp', 1, NOW(), 21);


-- Buffet 22 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida Paulista', 1500, 'Bela Vista', 'São Paulo', 'SP', '01310000', -23.564830, -46.652640, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Sabores da Terra', 'Comida típica e regional para eventos especiais!', 600, 3500.00, 500, '', 1, 1, '2023-06-04 12:00:00', 22, 22);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(22, 2),
(22, 3),
(22, 4),
(22, 6);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(22, 1),
(22, 3),
(22, 5),
(22, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(22, 2),
(22, 3),
(22, 5),
(22, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2000.00, 'Excelente serviço e decoração impecável!', 4.7, 6, NULL, 1, 22, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2800.00, 'Festa perfeita, tudo saiu como planejado!', 5, 6, NULL, 0, 22, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://www.afrikanhouse.com.br/images/palavras-chaves/', 'melhor-buffet-casamento-sao-paulo', 'jpg', 1, NOW(), 22);

-- Buffet 23 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua da Paz', 150, 'Centro', 'Curitiba', 'PR', '80060000', -25.429720, -49.267150, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Delícias da Terra', 'Sabores autênticos para momentos especiais!', 400, 3200.00, 250, '', 1, 1, '2023-06-04 12:00:00', 23, 23);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(23, 4),
(23, 6),
(23, 8),
(23, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(23, 2),
(23, 3),
(23, 5),
(23, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(23, 1),
(23, 4),
(23, 6),
(23, 7);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2800.00, 'Serviço de alta qualidade, recomendo!', 4.8, 6, NULL, 1, 23, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 3500.00, 'Tudo perfeito, os convidados adoraram!', 5, 6, NULL, 0, 23, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://lejour.com.br/wp-content/uploads/2021/11/', 'cedrom-casamento-intimista', 'jpg', 1, NOW(), 23);
    
-- Buffet 24 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida Central', 500, 'Centro', 'Fortaleza', 'CE', '60000000', -3.731862, -38.526670, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Mar Azul', 'Uma explosão de sabores para seu evento!', 300, 2800.00, 200, '', 1, 1, '2023-06-04 12:00:00', 24, 24);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(24, 3),
(24, 6),
(24, 8),
(24, 9);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(24, 1),
(24, 4),
(24, 6),
(24, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(24, 1),
(24, 3),
(24, 5),
(24, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2400.00, 'Comida deliciosa e equipe super atenciosa!', 4.9, 6, NULL, 1, 24, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 3200.00, 'Festa incrível, todos os convidados elogiaram!', 5, 6, NULL, 0, 24, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://lejour.com.br/wp-content/uploads/2021/10/', 'espaco-jardim-leopoldina', 'jpg', 1, NOW(), 24);
    
-- Buffet 25 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua das Flores', 200, 'Centro', 'Salvador', 'BA', '40000000', -12.978490, -38.499220, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Tropical', 'Sabores exóticos para seu evento!', 400, 3000.00, 250, '', 1, 1, '2023-06-04 12:00:00', 25, 25);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(25, 4),
(25, 6),
(25, 9),
(25, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(25, 2),
(25, 4),
(25, 5),
(25, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(25, 1),
(25, 4),
(25, 7),
(25, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2700.00, 'Foi tudo perfeito, superou minhas expectativas!', 4.7, 6, NULL, 1, 25, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 3500.00, 'Equipe muito profissional, recomendo!', 4.9, 6, NULL, 0, 25, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://lejour.com.br/wp-content/uploads/2021/07/', 'villa-glam-1', 'jpg', 1, NOW(), 25);
    
-- Buffet 26 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida Paulista', 1000, 'Bela Vista', 'São Paulo', 'SP', '01310000', -23.563370, -46.654830, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Glamour', 'Experiência única para seu evento especial!', 600, 4000.00, 300, '', 1, 1, '2023-06-04 12:00:00', 26, 26);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(26, 5),
(26, 8),
(26, 9),
(26, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(26, 1),
(26, 3),
(26, 4),
(26, 5);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(26, 1),
(26, 3),
(26, 4),
(26, 6);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 3800.00, 'Tudo perfeito, recomendo fortemente!', 4.8, 6, NULL, 1, 26, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 4500.00, 'Uma festa dos sonhos, obrigado!', 5, 6, NULL, 0, 26, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://lejour.com.br/wp-content/uploads/2021/11/', 'espaco-armazem', 'jpg', 1, NOW(), 26);
    
-- Buffet 27 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua Barão do Rio Branco', 500, 'Centro', 'Belo Horizonte', 'MG', '30140010', -19.922330, -43.940230, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Elegância', 'O toque de requinte que seu evento merece!', 400, 3500.00, 200, '', 1, 1, '2023-06-04 12:00:00', 27, 27);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(27, 3),
(27, 4),
(27, 5),
(27, 7);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(27, 1),
(27, 2),
(27, 3),
(27, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(27, 1),
(27, 2),
(27, 4),
(27, 5);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2800.00, 'Excelente serviço, recomendo!', 4.9, 6, NULL, 1, 27, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 3200.00, 'Festa incrível, todos adoraram!', 4.7, 6, NULL, 0, 27, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://lejour.com.br/wp-content/uploads/2021/07/', 'kaza-fendi', 'jpg', 1, NOW(), 27);
    
-- Buffet 28 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida Paulista', 1234, 'Bela Vista', 'São Paulo', 'SP', '01310000', -23.563370, -46.654830, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Dourado', 'Um toque de elegância e sofisticação para seu evento!', 800, 5000.00, 500, '', 1, 1, '2023-06-04 12:00:00', 28, 28);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(28, 6),
(28, 8),
(28, 9),
(28, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(28, 2),
(28, 3),
(28, 4),
(28, 6);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(28, 1),
(28, 3),
(28, 4),
(28, 6);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 4800.00, 'Simplesmente perfeito! Recomendo a todos.', 4.9, 6, NULL, 1, 28, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 5500.00, 'Melhor buffet que já contratei, nota 10!', 5, 6, NULL, 0, 28, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://lejour.com.br/wp-content/uploads/2021/10/', 'espaco-infinitto', 'jpg', 1, NOW(), 28);
    
-- Buffet 29 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida Brigadeiro Faria Lima', 1500, 'Jardim Paulistano', 'São Paulo', 'SP', '01451000', -23.581360, -46.686810, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Charme', 'Um toque de charme para tornar seu evento inesquecível!', 300, 2500.00, 150, '', 1, 1, '2023-06-04 12:00:00', 29, 29);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(29, 1),
(29, 3),
(29, 4),
(29, 5);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(29, 3),
(29, 4),
(29, 5),
(29, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(29, 1),
(29, 3),
(29, 4),
(29, 5);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 1800.00, 'Serviço impecável, superou minhas expectativas!', 4.7, 6, NULL, 1, 29, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2200.00, 'Festa linda e organizada, recomendo!', 4.8, 6, NULL, 0, 29, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://lejour.com.br/wp-content/uploads/2021/10/', 'casa-lucci-casamento-larissa-e-paulo', 'jpg', 1, NOW(), 29);
    
-- Buffet 30 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua da Praia', 500, 'Centro', 'Florianópolis', 'SC', '88010970', -27.596911, -48.549176, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Praia Dourada', 'Sinta o clima praiano em seu evento!', 200, 1800.00, 100, '', 1, 1, '2023-06-04 12:00:00', 30, 30);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(30, 3),
(30, 6),
(30, 7),
(30, 8);


INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(30, 2),
(30, 4),
(30, 5),
(30, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(30, 1),
(30, 2),
(30, 4),
(30, 7);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 1200.00, 'Ótimo atendimento e comida deliciosa!', 4.5, 6, NULL, 1, 30, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 1500.00, 'Adoramos o ambiente e a decoração!', 4.6, 6, NULL, 0, 30, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://lejour.com.br/wp-content/uploads/2021/11/', 'espaco-zabeu2', 'jpg', 1, NOW(), 30);
    
-- Buffet 31 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida Paulista', 1500, 'Bela Vista', 'São Paulo', 'SP', '01310200', -23.562754, -46.654590, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Paulista Eventos', 'A sofisticação da Avenida Paulista em seu evento!', 300, 2500.00, 200, '', 1, 1, '2023-06-04 12:00:00', 31, 31);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(31, 5),
(31, 8),
(31, 9),
(31, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(31, 1),
(31, 3),
(31, 5),
(31, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(31, 1),
(31, 3),
(31, 6),
(31, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2200.00, 'Excelente serviço e ambiente incrível!', 4.9, 6, NULL, 1, 31, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 1800.00, 'Festa perfeita, todos adoraram!', 4.8, 6, NULL, 0, 31, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://lejour.com.br/wp-content/uploads/2021/11/', 'estacao-840', 'jpg', 1, NOW(), 31);

-- Buffet 32 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida Boa Viagem', 1000, 'Boa Viagem', 'Recife', 'PE', '51011000', -8.120838, -34.901586, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Recife Mar', 'O sabor do Nordeste em seu evento!', 250, 2000.00, 150, '', 1, 1, '2023-06-04 12:00:00', 32, 32);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(32, 6),
(32, 7),
(32, 8),
(32, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(32, 2),
(32, 4),
(32, 6),
(32, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(32, 1),
(32, 3),
(32, 4),
(32, 6);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 1900.00, 'Comida típica deliciosa e atendimento impecável!', 4.7, 6, NULL, 1, 32, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2200.00, 'Festa incrível, tudo perfeito!', 4.9, 6, NULL, 0, 32, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/9753/3_2/320/jpeg/', 'whatsapp-image-2023-03-17-at-16-48-01-1_13_379753-167909515633840', 'webp', 1, NOW(), 32);
    
-- Buffet 33 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua das Flores', 300, 'Centro', 'Curitiba', 'PR', '80010140', -25.428954, -49.271662, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Flores Fest', 'Alegria e sabor em seu evento!', 150, 1500.00, 80, '', 1, 1, '2023-06-04 12:00:00', 33, 33);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(33, 1),
(33, 2),
(33, 3),
(33, 4);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(33, 2),
(33, 6),
(33, 7),
(33, 1);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(33, 1),
(33, 2),
(33, 4),
(33, 5);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 1300.00, 'Buffet maravilhoso, recomendo!', 4.3, 6, NULL, 1, 33, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 1600.00, 'Comida deliciosa e atendimento excelente!', 4.5, 6, NULL, 0, 33, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/7539/3_2/320/jpg/', 'img-1147_13_87539-160996397526758', 'webp', 1, NOW(), 33);
    
-- Buffet 34 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua das Palmeiras', 500, 'Jardim Botânico', 'Brasília', 'DF', '70000000', -15.797176, -47.877074, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Brasília Palace', 'Sofisticação e sabor na capital do Brasil!', 200, 1800.00, 120, '', 1, 1, '2023-06-04 12:00:00', 34, 34);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(34, 5),
(34, 7),
(34, 8),
(34, 9);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(34, 1),
(34, 3),
(34, 4),
(34, 5);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(34, 1),
(34, 3),
(34, 6),
(34, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2000.00, 'Evento memorável, todos adoraram!', 4.9, 6, NULL, 1, 34, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 1800.00, 'Festa impecável, serviço de alta qualidade!', 4.8, 6, NULL, 0, 34, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/1833/3_2/320/jpg/', 'sem-titulo111_13_121833-168548084885418', 'webp', 1, NOW(), 34);
    
-- Buffet 35 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida das Palmas', 800, 'Centro', 'Palmas', 'TO', '77000000', -10.1689, -48.3327, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Palmas Fest', 'Sabores que encantam, momentos que marcam!', 250, 2500.00, 150, '', 1, 1, '2023-06-04 12:00:00', 35, 35);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(35, 3),
(35, 5),
(35, 7),
(35, 9);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(35, 2),
(35, 4),
(35, 6),
(35, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(35, 2),
(35, 4),
(35, 6),
(35, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2800.00, 'Momento único e inesquecível, recomendo!', 4.7, 6, NULL, 1, 35, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2600.00, 'Equipe dedicada e comida deliciosa!', 4.6, 6, NULL, 0, 35, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/7428/3_2/320/jpg/', 'zaf-9756_13_67428-162863272481756', 'webp', 1, NOW(), 35);
    
-- Buffet 36 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua das Gaivotas', 600, 'Praia da Costa', 'Vila Velha', 'ES', '29101050', -20.337230, -40.290299, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Costa Gastronômica', 'Experiência incrível para o seu paladar!', 180, 1700.00, 100, '', 1, 1, '2023-06-04 12:00:00', 36, 36);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(36, 2),
(36, 5),
(36, 8),
(36, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(36, 1),
(36, 4),
(36, 5),
(36, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(36, 1),
(36, 4),
(36, 6),
(36, 7);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 1900.00, 'Buffet excepcional, recomendo a todos!', 4.8, 6, NULL, 1, 36, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2100.00, 'Serviço impecável, todos elogiaram!', 4.7, 6, NULL, 0, 36, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/8480/3_2/320/jpg/', 'dsc-9900_13_158480-1551897007', 'webp', 1, NOW(), 36);
    
-- Buffet 37 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua das Flores', 200, 'Centro', 'Campinas', 'SP', '13010080', -22.908622, -47.062912, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Flor de Sabor', 'Uma explosão de sabores para encantar seu paladar!', 250, 2500.00, 150, '', 1, 1, '2023-06-04 12:00:00', 37, 37);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(37, 3),
(37, 5),
(37, 7),
(37, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(37, 2),
(37, 4),
(37, 6),
(37, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(37, 2),
(37, 4),
(37, 6),
(37, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2800.00, 'Momento único e inesquecível, recomendo!', 4.7, 6, NULL, 1, 37, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2600.00, 'Equipe dedicada e comida deliciosa!', 4.6, 6, NULL, 0, 37, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/9054/3_2/320/jpg/', 'mzf01894_13_309054-165420352399904', 'webp', 1, NOW(), 37);
    
-- Buffet 38 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida Central', 500, 'Centro', 'Curitiba', 'PR', '80060100', -25.432607, -49.274746, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Central Festas', 'Celebre momentos especiais com requinte e sofisticação!', 400, 3500.00, 250, '', 1, 1, '2023-06-04 12:00:00', 38, 38);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(38, 4),
(38, 7),
(38, 8),
(38, 9);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(38, 1),
(38, 3),
(38, 4),
(38, 5);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(38, 1),
(38, 3),
(38, 5),
(38, 7);
    
INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 4000.00, 'Serviço impecável, recomendo a todos!', 4.9, 6, NULL, 1, 38, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 3800.00, 'Comida deliciosa e atendimento de primeira!', 4.8, 6, NULL, 0, 38, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/6744/3_2/320/jpg/', 'img-6177-2_13_326744-165419254058615', 'webp', 1, NOW(), 38);
    
-- Buffet 39 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua Principal', 300, 'Centro', 'Salvador', 'BA', '40020040', -12.970718, -38.504643, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Tropical', 'Sabores tropicais para surpreender seus convidados!', 300, 3000.00, 200, '', 1, 1, '2023-06-04 12:00:00', 39, 39);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(39, 3),
(39, 6),
(39, 8),
(39, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(39, 1),
(39, 2),
(39, 4),
(39, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(39, 1),
(39, 2),
(39, 4),
(39, 6);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 3500.00, 'Comida maravilhosa, todos elogiaram!', 4.7, 6, NULL, 1, 39, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 3200.00, 'Festa incrível, buffet de primeira qualidade!', 4.6, 6, NULL, 0, 39, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/1299/3_2/320/jpeg/', 'whatsapp-image-2022-10-27-at-19-51-21-1_13_371299-166696436994653', 'webp', 1, NOW(), 39);
    
-- Buffet 40 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida dos Sabores', 100, 'Jardim', 'Belo Horizonte', 'MG', '30140050', -19.924987, -43.940248, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Jardim dos Sabores', 'Uma explosão de sabores para encantar seu paladar!', 400, 3500.00, 250, '', 1, 1, '2023-06-04 12:00:00', 40, 40);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(40, 4),
(40, 7),
(40, 8),
(40, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(40, 1),
(40, 3),
(40, 4),
(40, 5);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(40, 1),
(40, 3),
(40, 5),
(40, 7);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 4000.00, 'Serviço impecável, recomendo a todos!', 4.9, 6, NULL, 1, 40, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 3800.00, 'Comida deliciosa e atendimento de primeira!', 4.8, 6, NULL, 0, 40, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/1311/3_2/320/jpg/', 'novobuffet-109-de-199_13_371311-166698329736971', 'webp', 1, NOW(), 40);
    
-- Buffet 41 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua das Delícias', 100, 'Centro', 'São Paulo', 'SP', '01001000', -23.550520, -46.633308, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Delícias Paulistas', 'Sabores autênticos da culinária paulista para sua festa!', 300, 2500.00, 150, '', 1, 1, '2023-06-04 12:00:00', 41, 41);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(41, 1),
(41, 2),
(41, 3),
(41, 5);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(41, 2),
(41, 3),
(41, 5),
(41, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(41, 1),
(41, 4),
(41, 6),
(41, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2800.00, 'Festa incrível com comida saborosa!', 4.7, 6, NULL, 1, 41, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2600.00, 'Serviço de qualidade e ótimo atendimento!', 4.6, 6, NULL, 0, 41, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/1604/3_2/320/jpeg/', 'f373d5a6-67d4-4245-9f2e-a3952240b1ff_13_111604-167032813913962', 'webp', 1, NOW(), 41);

-- Buffet 42 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua dos Sabores', 200, 'Jardim Botânico', 'Curitiba', 'PR', '80060000', -25.433835, -49.287244, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Curitiba Gourmet', 'Sabor e requinte para eventos especiais!', 400, 3500.00, 200, '', 1, 1, '2023-06-04 12:00:00', 42, 42);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(42, 3),
(42, 5),
(42, 7),
(42, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(42, 1),
(42, 4),
(42, 6),
(42, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(42, 1),
(42, 2),
(42, 5),
(42, 7);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 3200.00, 'Serviço de primeira qualidade e comida maravilhosa!', 4.9, 6, NULL, 1, 42, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2900.00, 'Tudo perfeito! Adoramos a festa!', 4.8, 6, NULL, 0, 42, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/3101/3_2/320/jpg/', '1597ea66-fd05-44bd-a645-b0186d9fe85b_13_123101-163287889588080', 'webp', 1, NOW(), 42);

-- Buffet 43 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida dos Sabores', 300, 'Boa Viagem', 'Recife', 'PE', '51021000', -8.127114, -34.899980, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Recife Encantado', 'Sabor e encanto em cada detalhe!', 350, 2800.00, 180, '', 1, 1, '2023-06-04 12:00:00', 43, 43);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(43, 1),
(43, 3),
(43, 6),
(43, 9);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(43, 1),
(43, 2),
(43, 5),
(43, 6);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(43, 1),
(43, 4),
(43, 6),
(43, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2600.00, 'Buffet incrível e atendimento impecável!', 4.7, 6, NULL, 1, 43, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2400.00, 'Adoramos tudo! Foi uma festa maravilhosa!', 4.6, 6, NULL, 0, 43, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/8513/3_2/320/jpg/', 'img-20180816-wa0130_13_68513', 'webp', 1, NOW(), 43);

-- Buffet 44 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua dos Sabores', 400, 'Centro', 'Belo Horizonte', 'MG', '30170110', -19.925717, -43.948622, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Mineirinho Gourmet', 'Sabores autênticos da culinária mineira!', 450, 3200.00, 250, '', 1, 1, '2023-06-04 12:00:00', 44, 44);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(44, 2),
(44, 5),
(44, 7),
(44, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(44, 1),
(44, 4),
(44, 5),
(44, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(44, 1),
(44, 2),
(44, 5),
(44, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 3000.00, 'Festa incrível com comida saborosa!', 4.9, 6, NULL, 1, 44, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2800.00, 'Serviço de qualidade e ótimo atendimento!', 4.8, 6, NULL, 0, 44, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/7080/3_2/320/jpg/', 'doces-delicias_13_347080-167542924770997', 'webp', 1, NOW(), 44);

-- Buffet 45 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida das Flores', 150, 'Jardim das Rosas', 'São Paulo', 'SP', '04505040', -23.582581, -46.682126, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Floral Garden', 'Uma explosão de sabores em meio a um belo jardim!', 400, 2800.00, 200, '', 1, 1, '2023-06-04 12:00:00', 45, 45);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(45, 1),
(45, 4),
(45, 7),
(45, 9);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(45, 2),
(45, 3),
(45, 5),
(45, 6);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(45, 1),
(45, 3),
(45, 6),
(45, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2500.00, 'Buffet encantador em meio a um ambiente florido!', 4.7, 6, NULL, 1, 45, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2300.00, 'Comida deliciosa e atendimento impecável!', 4.6, 6, NULL, 0, 45, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/5927/3_2/320/jpg/', '33_13_255927-166930175236968', 'webp', 1, NOW(), 45);

-- Buffet 46 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua dos Sabores', 100, 'Centro', 'Salvador', 'BA', '40060055', -12.971598, -38.501853, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Sabor Bahia', 'A culinária baiana em um buffet de dar água na boca!', 300, 2500.00, 150, '', 1, 1, '2023-06-04 12:00:00', 46, 46);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(46, 2),
(46, 5),
(46, 8),
(46, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(46, 1),
(46, 4),
(46, 6),
(46, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(46, 2),
(46, 3),
(46, 4),
(46, 7);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2200.00, 'Sabores autênticos da Bahia em um buffet de qualidade!', 4.5, 6, NULL, 1, 46, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2000.00, 'Buffet saboroso e serviço excelente!', 4.4, 6, NULL, 0, 46, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/2965/3_2/320/jpeg/', 'whatsapp-image-2023-04-13-at-16-14-13-1-copia_13_372965-168312793761063', 'webp', 1, NOW(), 46);

-- Buffet 47 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua dos Vinhos', 200, 'Vila Gastronômica', 'Bento Gonçalves', 'RS', '95700000', -29.165771, -51.516347, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Vinhos e Sabores', 'A harmonização perfeita entre vinhos e deliciosas iguarias!', 500, 3000.00, 250, '', 1, 1, '2023-06-04 12:00:00', 47, 47);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(47, 1),
(47, 4),
(47, 6),
(47, 9);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(47, 1),
(47, 3),
(47, 4),
(47, 5);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(47, 1),
(47, 2),
(47, 4),
(47, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 3500.00, 'Uma experiência gastronômica única com vinhos selecionados!', 4.9, 6, NULL, 1, 47, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 3200.00, 'Buffet incrível com opções de vinhos de alta qualidade!', 4.8, 6, NULL, 0, 47, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/1238/3_2/320/jpg/', 'file-1681575424941_13_161238-168157542721698', 'webp', 1, NOW(), 47);

-- Buffet 48 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Avenida das Estrelas', 500, 'Centro', 'Florianópolis', 'SC', '88020000', -27.594900, -48.551199, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Estrelas do Mar', 'Sabores maravilhosos em um buffet com vista para o mar!', 350, 2200.00, 180, '', 1, 1, '2023-06-04 12:00:00', 48, 48);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(48, 2),
(48, 5),
(48, 7),
(48, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(48, 2),
(48, 3),
(48, 5),
(48, 6);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(48, 1),
(48, 3),
(48, 6),
(48, 7);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2000.00, 'Um buffet sofisticado com uma vista deslumbrante!', 4.6, 6, NULL, 1, 48, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 1800.00, 'Comida deliciosa e ambiente encantador!', 4.5, 6, NULL, 0, 48, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/3097/3_2/320/jpg/', 'file-1624172001252_13_273097-162417201293447', 'webp', 1, NOW(), 48);

-- Buffet 49 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua dos Sabores', 150, 'Centro', 'Brasília', 'DF', '70000000', -15.799830, -47.864560, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Sabores da Capital', 'Descubra os melhores sabores da cidade em nosso buffet!', 300, 1800.00, 150, '', 1, 1, '2023-06-04 12:00:00', 49, 49);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(49, 1),
(49, 4),
(49, 6),
(49, 9);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(49, 1),
(49, 3),
(49, 5),
(49, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(49, 1),
(49, 3),
(49, 5),
(49, 6);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2500.00, 'Um buffet com uma variedade incrível de sabores!', 4.9, 6, NULL, 1, 49, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 2200.00, 'Sabores únicos em um ambiente aconchegante!', 4.8, 6, NULL, 0, 49, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/4467/3_2/320/jpg/', '36428584-829016263975095-6061754023659175936-n_13_2322-168560934591433', 'webp', 1, NOW(), 49);

-- Buffet 50 ----------------------
INSERT INTO eventify.endereco (is_validado, logradouro, numero, bairro, cidade, uf, cep, latitude, longitude, data_criacao) VALUES
(1, 'Rua das Flores', 100, 'Centro', 'Florianópolis', 'SC', '88000000', -27.595377, -48.548849, '2023-06-04 12:00:00');

INSERT INTO eventify.buffet (nome, descricao, tamanho, preco_medio_diaria, qtd_pessoas, caminho_comprovante, residencia_comprovada, is_visivel, data_criacao, id_usuario, id_endereco) VALUES
('Buffet Flor de Lis', 'Opções requintadas e saborosas para eventos especiais!', 300, 2800.00, 200, '', 1, 1, '2023-06-04 12:00:00', 50, 50);

INSERT INTO eventify.buffet_faixa_etaria (id_buffet, id_faixa_etaria) VALUES
(50, 3),
(50, 6),
(50, 8),
(50, 10);

INSERT INTO eventify.buffet_tipo_evento (id_buffet, id_tipo_evento) VALUES
(50, 1),
(50, 4),
(50, 6),
(50, 7);

INSERT INTO eventify.buffet_servico (id_buffet, id_servico) VALUES
(50, 1),
(50, 3),
(50, 6),
(50, 8);

INSERT INTO eventify.pagamento (is_pago_contrato, data_pago, is_pago_buffet) VALUES
(1, '2023-06-04 12:00:00', 1),
(1, '2023-06-04 12:00:00', 1);

INSERT INTO eventify.evento (data, preco, avaliacao, nota, status, motivo_nao_aceito, is_formulario_dinamico, id_buffet, data_criacao, id_contratante, id_pagamento) VALUES
('2023-06-04 12:00:00', 2500.00, 'Atendimento impecável e comida deliciosa!', 4.9, 6, NULL, 1, 50, '2023-06-04 12:00:00', 163, 122),
('2023-06-04 12:00:00', 3200.00, 'Festa dos sonhos, recomendo a todos!', 5, 6, NULL, 0, 50, '2023-06-04 12:00:00', 164, 123);

INSERT INTO imagem (caminho, nome, tipo, is_ativo, data_upload, id_buffet) VALUES
    ('https://cdn0.casamentos.com.br/vendor/6791/3_2/320/jpeg/', 'img-9396_13_376791-167649419675723', 'webp', 1, NOW(), 50);
    
    
    INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-11-30 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-11-30 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-11-30 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-11-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-11-30 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-11-30 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-11-30 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-11-30 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-11-30 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-11-30 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-01 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-02 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-03 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-04 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-05 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-06 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-07 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-08 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-09 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-10 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-11 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-12 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-13 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-14 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-15 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-16 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-17 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-18 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-19 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-20 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-21 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-22 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-23 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 16:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-24 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-25 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-26 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-27 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-28 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 16:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 14:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-29 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-30 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2022-12-31 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-01 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-02 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-03 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-04 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-05 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-06 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-07 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-08 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-09 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 16:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 14:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-10 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-11 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-12 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-13 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-14 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 14:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-15 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-16 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-17 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-18 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-19 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-20 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-21 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-22 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-23 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-24 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-25 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-26 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-27 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-28 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-29 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-01-31 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-01 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-02 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-03 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-04 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-05 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-06 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-07 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-08 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-10 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-11 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-12 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-13 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-14 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-15 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-16 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-17 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-18 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-19 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-20 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-21 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-22 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-23 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-24 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-25 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-26 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-27 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-02-28 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-01 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 16:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-02 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-03 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-04 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-05 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 14:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-07 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-08 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-09 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 16:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 14:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-10 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-11 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-12 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-13 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-14 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-15 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-16 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-17 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-18 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-19 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-20 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-21 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-22 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-23 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-24 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 16:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 14:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-25 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 14:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-26 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-27 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-28 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-29 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-30 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-03-31 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-01 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-02 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-03 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-04 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-05 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-06 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-07 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-08 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-09 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-10 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-11 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-12 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-13 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 16:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 14:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-14 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-15 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-16 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-17 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 21:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 16:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-18 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-19 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-20 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-21 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-22 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-23 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-24 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-25 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 07:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-26 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-27 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-28 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-29 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 18:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 17:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 16:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 15:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-04-30 19:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 16:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 14:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-01 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 16:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 14:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 10:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 09:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 08:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 04:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 03:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 02:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 01:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 00:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 23:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 22:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 21:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-02 20:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 16:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 14:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 10:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 09:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 08:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 07:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 20:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 19:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 18:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 17:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 16:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 15:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 14:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 13:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 12:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 11:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 06:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 05:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 04:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 03:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 02:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 01:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 00:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 23:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 22:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 21:00:00', 3);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 14:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 13:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 12:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 11:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 10:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 09:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 08:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 07:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 06:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 05:00:00', 1);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 20:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 19:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 18:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 17:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 16:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 15:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 14:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 13:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 12:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 11:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 06:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 05:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 04:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 03:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 02:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 01:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-04 00:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 23:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 22:00:00', 2);
INSERT INTO acesso (data_criacao, id_pagina) VALUES ('2023-05-03 21:00:00', 2);