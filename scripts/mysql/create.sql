DROP DATABASE IF EXISTS eventify;

SET SESSION sql_mode = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
-- -----------------------------------------------------
-- Schema eventify
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema eventify
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `eventify` DEFAULT CHARACTER SET utf8 ;
USE `eventify` ; -- PREVENÇÃO DE ERRO

-- -----------------------------------------------------
-- Table `eventify`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(128) NOT NULL,
  `email` VARCHAR(256) NOT NULL,
  `senha` VARCHAR(256) NOT NULL,
  `tipo_usuario` INT(3) UNSIGNED NOT NULL,
  `is_ativo` TINYINT UNSIGNED NOT NULL,
  `is_banido` TINYINT UNSIGNED NULL,
  `cpf` CHAR(11) NULL,
  `data_criacao` DATETIME NULL,
  `imagem` VARCHAR(256) NULL,
  `ultimo_login` DATETIME NULL,
  PRIMARY KEY (`id`))
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
  `cidade` VARCHAR(64) NULL,
  `uf` CHAR(2) NOT NULL,
  `cep` CHAR(8) NOT NULL,
  `latitude` DECIMAL(8,6) NOT NULL,
  `longitude` DECIMAL(8,6) NOT NULL,
  `data_criacao` DATETIME NULL,
  `is_ativo` TINYINT UNSIGNED NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`buffet`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`buffet` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(128) NOT NULL,
  `descricao` VARCHAR(512) NOT NULL,
  `tamanho` INT NOT NULL,
  `preco_medio_diaria` DECIMAL(8,2) NOT NULL,
  `qtd_pessoas` INT UNSIGNED NOT NULL,
  `caminho_comprovante` VARCHAR(256) NULL,
  `residencia_comprovada` TINYINT NOT NULL,
  `is_visivel` TINYINT NOT NULL,
  `data_criacao` DATETIME NULL,
  `id_usuario` INT NOT NULL,
  `id_endereco` INT NOT NULL,
  PRIMARY KEY (`id`),
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

CREATE UNIQUE INDEX `buffet_comprovante_residencia_UNIQUE` ON `eventify`.`buffet` (`caminho_comprovante` ASC) VISIBLE;

CREATE INDEX `fk_buffet_usuario1_idx` ON `eventify`.`buffet` (`id_usuario` ASC) VISIBLE;

CREATE INDEX `fk_buffet_endereco1_idx` ON `eventify`.`buffet` (`id_endereco` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`mensagem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`mensagem` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `mensagem` TEXT(512) NOT NULL,
  `mandado_por` TINYINT NULL,
  `data` DATETIME NOT NULL,
  `id_usuario` INT NOT NULL,
  `id_buffet` INT NOT NULL,
  PRIMARY KEY (`id`),
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

CREATE INDEX `fk_mensagem_usuario1_idx` ON `eventify`.`mensagem` (`id_usuario` ASC) VISIBLE;

CREATE INDEX `fk_mensagem_buffet1_idx` ON `eventify`.`mensagem` (`id_buffet` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`agenda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`agenda` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data` DATETIME NOT NULL,
  `is_ativo` TINYINT UNSIGNED NULL,
  `id_buffet` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_reserva_residencias1`
    FOREIGN KEY (`id_buffet`)
    REFERENCES `eventify`.`buffet` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_reserva_residencias1_idx` ON `eventify`.`agenda` (`id_buffet` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`faixa_etaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`faixa_etaria` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(16) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `descricao_UNIQUE` ON `eventify`.`faixa_etaria` (`descricao` ASC) VISIBLE;


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
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `descricao_UNIQUE` ON `eventify`.`servico` (`descricao` ASC) VISIBLE;


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
  `avaliacao` TEXT(512) NULL,
  `nota` DOUBLE(2,1) NULL,
  `status` INT(8) NULL,
  `motivo_nao_aceito` TEXT(512) NULL,
  `is_formulario_dinamico` BIT NULL,
  `data_criacao` DATETIME NULL,
  `id_buffet` INT NOT NULL,
  `id_contratante` INT NOT NULL,
  `id_pagamento` INT NULL,
  PRIMARY KEY (`id`),
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
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_evento_buffet1_idx` ON `eventify`.`evento` (`id_buffet` ASC) VISIBLE;

CREATE INDEX `fk_evento_usuario1_idx` ON `eventify`.`evento` (`id_contratante` ASC) VISIBLE;

CREATE INDEX `fk_evento_pagamento1_idx` ON `eventify`.`evento` (`id_pagamento` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`buffet_faixa_etaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`buffet_faixa_etaria` (
  `id_buffet` INT NOT NULL,
  `id_faixa_etaria` INT NOT NULL,
  PRIMARY KEY (`id_buffet`, `id_faixa_etaria`),
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

CREATE INDEX `fk_buffet_has_faixa_etaria_faixa_etaria1_idx` ON `eventify`.`buffet_faixa_etaria` (`id_faixa_etaria` ASC) VISIBLE;

CREATE INDEX `fk_buffet_has_faixa_etaria_buffet1_idx` ON `eventify`.`buffet_faixa_etaria` (`id_buffet` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`buffet_tipo_evento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`buffet_tipo_evento` (
  `id_buffet` INT NOT NULL,
  `id_tipo_evento` INT NOT NULL,
  PRIMARY KEY (`id_buffet`, `id_tipo_evento`),
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

CREATE INDEX `fk_buffet_has_tipo_evento_tipo_evento1_idx` ON `eventify`.`buffet_tipo_evento` (`id_tipo_evento` ASC) VISIBLE;

CREATE INDEX `fk_buffet_has_tipo_evento_buffet1_idx` ON `eventify`.`buffet_tipo_evento` (`id_buffet` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`buffet_servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`buffet_servico` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_buffet` INT NOT NULL,
  `id_servico` INT NOT NULL,
  PRIMARY KEY (`id`, `id_buffet`, `id_servico`),
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

CREATE INDEX `fk_buffet_has_servico_servico1_idx` ON `eventify`.`buffet_servico` (`id_servico` ASC) VISIBLE;

CREATE INDEX `fk_buffet_has_servico_buffet1_idx` ON `eventify`.`buffet_servico` (`id_buffet` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`imagem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`imagem` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `caminho` VARCHAR(256) NULL,
  `nome` VARCHAR(128) NULL,
  `tipo` VARCHAR(4) NULL,
  `is_ativo` TINYINT NULL,
  `data_upload` DATETIME NULL,
  `id_buffet` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_imagem_buffet1`
    FOREIGN KEY (`id_buffet`)
    REFERENCES `eventify`.`buffet` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_imagem_buffet1_idx` ON `eventify`.`imagem` (`id_buffet` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`notificacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`notificacao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` TEXT(512) NULL,
  `data_criacao` DATETIME NULL,
  `id_usuario` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_notificacao_usuario1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `eventify`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_notificacao_usuario1_idx` ON `eventify`.`notificacao` (`id_usuario` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`imagem_chat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`imagem_chat` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `caminho` VARCHAR(256) NOT NULL,
  `nome` VARCHAR(128) NOT NULL,
  `tipo` VARCHAR(4) NOT NULL,
  `is_ativo` TINYINT NOT NULL,
  `data_upload` DATETIME NOT NULL,
  `id_mensagem` INT NOT NULL,
  PRIMARY KEY (`id`, `id_mensagem`),
  CONSTRAINT `fk_imagem_chat_mensagem1`
    FOREIGN KEY (`id_mensagem`)
    REFERENCES `eventify`.`mensagem` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_imagem_chat_mensagem1_idx` ON `eventify`.`imagem_chat` (`id_mensagem` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`pagina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`pagina` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(63) NOT NULL,
  `uri` VARCHAR(63) NOT NULL,
  `id_buffet` INT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_pagina_buffet1`
    FOREIGN KEY (`id_buffet`)
    REFERENCES `eventify`.`buffet` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_pagina_buffet1_idx` ON `eventify`.`pagina` (`id_buffet` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`acesso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`acesso` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_criacao` DATETIME NULL,
  `id_pagina` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_log_de_acesso_pagina1`
    FOREIGN KEY (`id_pagina`)
    REFERENCES `eventify`.`pagina` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_log_de_acesso_pagina1_idx` ON `eventify`.`acesso` (`id_pagina` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`bucket`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`bucket` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(64) NULL,
  `is_visivel` TINYINT NULL,
  `id_buffet_servico` INT NOT NULL,
  `id_evento` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_bucket_buffet_servico1`
    FOREIGN KEY (`id_buffet_servico`)
    REFERENCES `eventify`.`buffet_servico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_bucket_evento1`
    FOREIGN KEY (`id_evento`)
    REFERENCES `eventify`.`evento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_bucket_buffet_servico1_idx` ON `eventify`.`bucket` (`id_buffet_servico` ASC) VISIBLE;

CREATE INDEX `fk_bucket_evento1_idx` ON `eventify`.`bucket` (`id_evento` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`tarefa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`tarefa` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(64) NULL,
  `descricao` VARCHAR(256) NULL,
  `fibonacci` INT NULL,
  `status` INT NULL,
  `horas_estimada` INT NULL,
  `data_estimada` DATE NULL,
  `data_criacao` DATETIME NULL,
  `data_conclusao` DATETIME NULL,
  `is_visivel` TINYINT NULL,
  `id_tarefa` INT NULL,
  `id_bucket` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_tarefa_tarefa1`
	FOREIGN KEY (`id_tarefa`)
	REFERENCES `eventify`.`tarefa`(`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tarefa_bucket1`
    FOREIGN KEY (`id_bucket`)
    REFERENCES `eventify`.`bucket` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_tarefa_bucket1_idx` ON `eventify`.`tarefa` (`id_bucket` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`nivel_acesso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`nivel_acesso` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(64) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`funcionario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(128) NULL,
  `cpf` CHAR(11) NULL,
  `email` VARCHAR(256) NULL,
  `senha` VARCHAR(256) NULL,
  `telefone` CHAR(14) NULL,
  `imagem` VARCHAR(256) NULL,
  `salario` DECIMAL(8,2) NULL,
  `dia_pagamento` INT NULL,
  `is_visivel` TINYINT NULL,
  `data_criacao` DATETIME NULL,
  `id_nivel_acesso` INT NOT NULL,
  `id_empregador` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_funcionario_nivel_acesso1`
    FOREIGN KEY (`id_nivel_acesso`)
    REFERENCES `eventify`.`nivel_acesso` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_funcionario_usuario1`
    FOREIGN KEY (`id_empregador`)
    REFERENCES `eventify`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
INSERT_METHOD = LAST;

CREATE INDEX `fk_funcionario_nivel_acesso1_idx` ON `eventify`.`funcionario` (`id_nivel_acesso` ASC) VISIBLE;

CREATE INDEX `fk_funcionario_usuario1_idx` ON `eventify`.`funcionario` (`id_empregador` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`comentario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`comentario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `mensagem` VARCHAR(512) NULL,
  `data_criacao` DATETIME NULL,
  `is_visivel` TINYINT NULL,
  `id_funcionario` INT NULL,
  `id_usuario` INT NULL,
  `id_tarefa` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_comentario_tarefa1`
    FOREIGN KEY (`id_tarefa`)
    REFERENCES `eventify`.`tarefa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comentario_funcionario1`
    FOREIGN KEY (`id_funcionario`)
    REFERENCES `eventify`.`funcionario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comentario_usuario1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `eventify`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_comentario_tarefa1_idx` ON `eventify`.`comentario` (`id_tarefa` ASC) VISIBLE;

CREATE INDEX `fk_comentario_funcionario1_idx` ON `eventify`.`comentario` (`id_funcionario` ASC) VISIBLE;

CREATE INDEX `fk_comentario_usuario1_idx` ON `eventify`.`comentario` (`id_usuario` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`executor_tarefa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`executor_tarefa` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tempo_executado` INT NULL,
  `data_criacao` DATETIME NULL,
  `is_removido` TINYINT NULL,
  `id_tarefa` INT NOT NULL,
  `id_executor_funcionario` INT NULL,
  `id_executor_usuario` INT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_usuario_has_tarefa_tarefa1`
    FOREIGN KEY (`id_tarefa`)
    REFERENCES `eventify`.`tarefa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_tarefa_funcionario1`
    FOREIGN KEY (`id_executor_funcionario`)
    REFERENCES `eventify`.`funcionario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_executor_tarefa_usuario1`
    FOREIGN KEY (`id_executor_usuario`)
    REFERENCES `eventify`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_usuario_has_tarefa_tarefa1_idx` ON `eventify`.`executor_tarefa` (`id_tarefa` ASC) VISIBLE;

CREATE INDEX `fk_usuario_tarefa_funcionario1_idx` ON `eventify`.`executor_tarefa` (`id_executor_funcionario` ASC) VISIBLE;

CREATE INDEX `fk_executor_tarefa_usuario1_idx` ON `eventify`.`executor_tarefa` (`id_executor_usuario` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`transacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`transacao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `valor` DECIMAL(9,2) NULL,
  `referente` VARCHAR(64) NULL,
  `is_visivel` TINYINT NULL,
  `data_criacao` DATETIME NULL,
  `is_gasto` TINYINT(1) NULL,
  `id_buffet` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_transacoes_buffet1`
    FOREIGN KEY (`id_buffet`)
    REFERENCES `eventify`.`buffet` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_transacoes_buffet1_idx` ON `eventify`.`transacao` (`id_buffet` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`funcionalidade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`funcionalidade` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nome` VARCHAR(64) NOT NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `eventify`.`visualizacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`visualizacao` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `data_criacao` DATETIME NULL,
  `id_funcionalidade` INT NOT NULL,
  `id_buffet` INT NOT NULL,
  CONSTRAINT `fk_visualizacao_funcionalidade1`
    FOREIGN KEY (`id_funcionalidade`)
    REFERENCES `eventify`.`funcionalidade` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_visualizacao_buffet1`
    FOREIGN KEY (`id_buffet`)
    REFERENCES `eventify`.`buffet` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_visualizacao_funcionalidade1_idx` ON `eventify`.`visualizacao` (`id_funcionalidade` ASC) VISIBLE;

CREATE INDEX `fk_visualizacao_buffet1_idx` ON `eventify`.`visualizacao` (`id_buffet` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`acao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`acao` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(64) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `eventify`.`log_tarefa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`log_tarefa` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `valor` VARCHAR(1024) NULL,
  `data_criacao` DATETIME NULL,
  `id_funcionario` INT NULL,
  `id_usuario` INT NULL,
  `id_tarefa` INT NOT NULL,
  `id_acao` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_log_tarefa_acao1`
    FOREIGN KEY (`id_acao`)
    REFERENCES `eventify`.`acao` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_log_tarefa_tarefa1`
    FOREIGN KEY (`id_tarefa`)
    REFERENCES `eventify`.`tarefa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_log_tarefa_funcionario1`
    FOREIGN KEY (`id_funcionario`)
    REFERENCES `eventify`.`funcionario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_log_tarefa_usuario1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `eventify`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_log_tarefa_acao1_idx` ON `eventify`.`log_tarefa` (`id_acao` ASC) VISIBLE;

CREATE INDEX `fk_log_tarefa_tarefa1_idx` ON `eventify`.`log_tarefa` (`id_tarefa` ASC) VISIBLE;

CREATE INDEX `fk_log_tarefa_funcionario1_idx` ON `eventify`.`log_tarefa` (`id_funcionario` ASC) VISIBLE;

CREATE INDEX `fk_log_tarefa_usuario1_idx` ON `eventify`.`log_tarefa` (`id_usuario` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`log_acesso_tarefa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`log_acesso_tarefa` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_criacao` DATETIME NULL,
  `id_tarefa` INT NOT NULL,
  `id_funcionario` INT NULL,
  `id_usuario` INT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_log_acesso_tarefa_tarefa1`
    FOREIGN KEY (`id_tarefa`)
    REFERENCES `eventify`.`tarefa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_log_acesso_tarefa_funcionario1`
    FOREIGN KEY (`id_funcionario`)
    REFERENCES `eventify`.`funcionario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_log_acesso_tarefa_usuario1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `eventify`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_log_acesso_tarefa_tarefa1_idx` ON `eventify`.`log_acesso_tarefa` (`id_tarefa` ASC) VISIBLE;

CREATE INDEX `fk_log_acesso_tarefa_funcionario1_idx` ON `eventify`.`log_acesso_tarefa` (`id_funcionario` ASC) VISIBLE;

CREATE INDEX `fk_log_acesso_tarefa_usuario1_idx` ON `eventify`.`log_acesso_tarefa` (`id_usuario` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `eventify`.`flag_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `eventify`.`flag_log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_criacao` DATETIME NULL,
  `is_visivel` TINYINT NULL,
  `id_funcionario` INT NULL,
  `id_usuario` INT NULL,
  `id_tarefa` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_flag_log_funcionario1`
    FOREIGN KEY (`id_funcionario`)
    REFERENCES `eventify`.`funcionario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flag_log_usuario1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `eventify`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flag_log_tarefa1`
    FOREIGN KEY (`id_tarefa`)
    REFERENCES `eventify`.`tarefa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_flag_log_funcionario1_idx` ON `eventify`.`flag_log` (`id_funcionario` ASC) VISIBLE;

CREATE INDEX `fk_flag_log_usuario1_idx` ON `eventify`.`flag_log` (`id_usuario` ASC) VISIBLE;

CREATE INDEX `fk_flag_log_tarefa1_idx` ON `eventify`.`flag_log` (`id_tarefa` ASC) VISIBLE;