-- ----------------------------------------------------
-- User rest-api
-- ----------------------------------------------------
CREATE USER 'backend_eventify'@'%' IDENTIFIED BY 'evenCCD834E1tify';
GRANT INSERT, SELECT, UPDATE, DELETE ON eventify.* TO 'backend_eventify'@'%';
FLUSH PRIVILEGES;

-- APENAS EXECUTE CASO VOCÊ TENHA UTILIZADO O SCRIPT COM AS PERMISSÕES ANTIGAS ALTER
-- OU TENHA DELETADO / ADICIONADO NOVAS TABELAS
-- REVOKE ALL PRIVILEGES ON eventify.* FROM 'backend_eventify'@'%';

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
  `is_ativo` TINYINT UNSIGNED NOT NULL DEFAULT 1,
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
  `numero` VARCHAR(16) NULL,
  `bairro` VARCHAR(32) NOT NULL,
  `cidade` VARCHAR(63) NULL,
  `uf` CHAR(2) NOT NULL,
  `cep` CHAR(8) NOT NULL,
  `latitude` DECIMAL(8,6) NOT NULL,
  `longitude` DECIMAL(8,6) NOT NULL,
  `data_criacao` DATETIME NULL,
  `is_ativo` TINYINT UNSIGNED NOT NULL DEFAULT 1,
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
  `is_ativo` TINYINT UNSIGNED NOT NULL DEFAULT 1,
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
  `preco` DECIMAL(8,2) NULL,
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
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_log_de_acesso_pagina1_idx` (`id_pagina` ASC) VISIBLE,
  CONSTRAINT `fk_log_de_acesso_pagina1`
    FOREIGN KEY (`id_pagina`)
    REFERENCES `eventify`.`pagina` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;