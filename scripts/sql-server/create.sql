-- Schema eventify
USE master;

CREATE DATABASE eventify;
GO

USE eventify;
GO

-- Table eventify.usuario
CREATE TABLE usuario (
  id INT IDENTITY(1,1) NOT NULL,
  nome VARCHAR(64) NOT NULL,
  email VARCHAR(256) NOT NULL,
  senha VARCHAR(256) NOT NULL,
  tipo_usuario INT NOT NULL,
  is_ativo TINYINT NOT NULL,
  is_banido TINYINT NULL,
  cpf CHAR(11) NULL,
  foto VARCHAR(255) NULL,
  data_criacao DATETIME NULL,
  ultimo_login DATETIME NULL,
  PRIMARY KEY (id),
  CONSTRAINT usuario_id_UNIQUE UNIQUE (id),
  CONSTRAINT usuario_email_UNIQUE UNIQUE (email)
);
GO

-- Table eventify.endereco
CREATE TABLE endereco (
  id INT IDENTITY(1,1) NOT NULL,
  is_validado TINYINT NULL,
  logradouro VARCHAR(64) NOT NULL,
  numero INT NULL,
  bairro VARCHAR(32) NOT NULL,
  cidade VARCHAR(63) NULL,
  uf CHAR(2) NOT NULL,
  cep CHAR(8) NOT NULL,
  latitude DECIMAL(8,6) NOT NULL,
  longitude DECIMAL(8,6) NOT NULL,
  data_criacao DATETIME NULL,
  PRIMARY KEY (id),
  CONSTRAINT endereco_id_UNIQUE UNIQUE (id)
);
GO

-- Table eventify.buffet
CREATE TABLE buffet (
  id INT IDENTITY(1,1) NOT NULL,
  nome VARCHAR(123) NOT NULL,
  descricao VARCHAR(511) NOT NULL,
  tamanho INT NOT NULL,
  preco_medio_diaria DECIMAL(6,2) NOT NULL,
  qtd_pessoas INT NOT NULL,
  caminho_comprovante VARCHAR(64) NULL,
  residencia_comprovada TINYINT NOT NULL,
  is_visivel TINYINT NOT NULL,
  data_criacao DATETIME NULL,
  id_usuario INT NOT NULL,
  id_endereco INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT buffet_id_UNIQUE UNIQUE (id),
  CONSTRAINT fk_buffet_usuario1
    FOREIGN KEY (id_usuario)
    REFERENCES usuario (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_buffet_endereco1
    FOREIGN KEY (id_endereco)
    REFERENCES endereco (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO

-- Table eventify.mensagem
CREATE TABLE mensagem (
  id INT IDENTITY(1,1) NOT NULL,
  mensagem VARCHAR(511) NOT NULL,
  mandado_por TINYINT NULL,
  data DATETIME NOT NULL,
  id_usuario INT NOT NULL,
  id_buffet INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT mensagem_id_UNIQUE UNIQUE (id),
  CONSTRAINT fk_mensagem_usuario1
    FOREIGN KEY (id_usuario)
    REFERENCES usuario (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_mensagem_buffet1
    FOREIGN KEY (id_buffet)
    REFERENCES buffet (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO

-- Table eventify.agenda
CREATE TABLE agenda (
  id INT IDENTITY(1,1) NOT NULL,
  data DATETIME NOT NULL,
  id_buffet INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT agenda_id_UNIQUE UNIQUE (id),
  CONSTRAINT fk_reserva_residencias1
    FOREIGN KEY (id_buffet)
    REFERENCES buffet (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO

-- Table eventify.faixa_etaria
CREATE TABLE faixa_etaria (
  id INT IDENTITY(1,1) NOT NULL,
  descricao VARCHAR(16) NULL,
  PRIMARY KEY (id),
  CONSTRAINT faixa_etaria_descricao_UNIQUE UNIQUE (descricao)
);
GO

-- Table eventify.tipo_evento
CREATE TABLE tipo_evento (
  id INT IDENTITY(1,1) NOT NULL,
  descricao VARCHAR(16) NULL,
  PRIMARY KEY (id)
);
GO

-- Table eventify.servico
CREATE TABLE servico (
  id INT IDENTITY(1,1) NOT NULL,
  descricao VARCHAR(16) NULL,
  PRIMARY KEY (id),
  CONSTRAINT servico_descricao_UNIQUE UNIQUE (descricao)
);
GO

-- Table eventify.pagamento
CREATE TABLE pagamento (
  id INT IDENTITY(1,1) NOT NULL,
  is_pago_contrato TINYINT NOT NULL,
  data_pago DATETIME NOT NULL,
  is_pago_buffet TINYINT NOT NULL,
  PRIMARY KEY (id)
);
GO

-- Table eventify.evento
CREATE TABLE evento (
  id INT IDENTITY(1,1) NOT NULL,
  data DATETIME NULL,
  preco DECIMAL(6,2) NULL,
  avaliacao VARCHAR(511) NULL,
  nota FLOAT NULL,
  status INT NULL,
  motivo_nao_aceito VARCHAR(511) NULL,
  is_formulario_dinamico BIT NULL,
  data_criacao DATETIME NULL,
  id_buffet INT NOT NULL,
  id_contratante INT NOT NULL,
  id_pagamento INT NULL,
  PRIMARY KEY (id),
  CONSTRAINT evento_id_UNIQUE UNIQUE (id),
  CONSTRAINT fk_evento_buffet1
    FOREIGN KEY (id_buffet)
    REFERENCES buffet (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_evento_usuario1
    FOREIGN KEY (id_contratante)
    REFERENCES usuario (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_evento_pagamento1
    FOREIGN KEY (id_pagamento)
    REFERENCES pagamento (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO

-- Table eventify.buffet_faixa_etaria
CREATE TABLE buffet_faixa_etaria (
  id_buffet INT NOT NULL,
  id_faixa_etaria INT NOT NULL,
  PRIMARY KEY (id_buffet, id_faixa_etaria),
  CONSTRAINT fk_buffet_has_faixa_etaria_buffet1
    FOREIGN KEY (id_buffet)
    REFERENCES buffet (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_buffet_has_faixa_etaria_faixa_etaria1
    FOREIGN KEY (id_faixa_etaria)
    REFERENCES faixa_etaria (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO

-- Table eventify.buffet_tipo_evento
CREATE TABLE buffet_tipo_evento (
  id_buffet INT NOT NULL,
  id_tipo_evento INT NOT NULL,
  PRIMARY KEY (id_buffet, id_tipo_evento),
  CONSTRAINT fk_buffet_has_tipo_evento_buffet1
    FOREIGN KEY (id_buffet)
    REFERENCES buffet (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_buffet_has_tipo_evento_tipo_evento1
    FOREIGN KEY (id_tipo_evento)
    REFERENCES tipo_evento (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO

-- Table eventify.buffet_servico
CREATE TABLE buffet_servico (
  id_buffet INT NOT NULL,
  id_servico INT NOT NULL,
  PRIMARY KEY (id_buffet, id_servico),
  CONSTRAINT fk_buffet_has_servico_buffet1
    FOREIGN KEY (id_buffet)
    REFERENCES buffet (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_buffet_has_servico_servico1
    FOREIGN KEY (id_servico)
    REFERENCES servico (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO

-- Table eventify.imagem
CREATE TABLE imagem (
  id INT IDENTITY(1,1) NOT NULL,
  caminho VARCHAR(255) NULL,
  nome VARCHAR(255) NULL,
  tipo VARCHAR(4) NULL,
  is_ativo TINYINT NULL,
  data_upload DATETIME NULL,
  id_buffet INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_imagem_buffet1
    FOREIGN KEY (id_buffet)
    REFERENCES buffet (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO

-- Table eventify.notificacao
CREATE TABLE notificacao (
  id INT IDENTITY(1,1) NOT NULL,
  descricao VARCHAR(511) NULL,
  data_criacao DATETIME NULL,
  id_usuario INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_notificacao_usuario1
    FOREIGN KEY (id_usuario)
    REFERENCES usuario (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO

-- Table eventify.imagem_chat
CREATE TABLE imagem_chat (
  id INT IDENTITY(1,1) NOT NULL,
  caminho VARCHAR(256) NOT NULL,
  nome VARCHAR(32) NOT NULL,
  tipo VARCHAR(4) NOT NULL,
  is_ativo TINYINT NOT NULL,
  data_upload DATETIME NOT NULL,
  id_mensagem INT NOT NULL,
  PRIMARY KEY (id, id_mensagem),
  CONSTRAINT fk_imagem_chat_mensagem1
    FOREIGN KEY (id_mensagem)
    REFERENCES mensagem (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO

-- Table eventify.pagina
CREATE TABLE pagina (
  id INT IDENTITY(1,1) NOT NULL,
  nome VARCHAR(63) NOT NULL,
  uri VARCHAR(63) NOT NULL,
  PRIMARY KEY (id)
);
GO

-- Table eventify.acesso
CREATE TABLE acesso (
  id INT IDENTITY(1,1) NOT NULL,
  data_criacao DATETIME NOT NULL,
  id_pagina INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT acesso_id_UNIQUE UNIQUE (id),
  CONSTRAINT fk_log_de_acesso_pagina1
    FOREIGN KEY (id_pagina)
    REFERENCES pagina (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
GO

USE eventify;
GO