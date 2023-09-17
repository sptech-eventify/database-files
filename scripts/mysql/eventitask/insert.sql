INSERT INTO usuario (name, email, password, img) VALUES 
    ('Brayan Coelho', 'brayan.aquino@sptech.school','$2b$10$LC/5qzu7vlhsHGxlHOCZ7uznDtgBgXDlUCBLIn.3EWn1kksAxTs9e', 'https://i.kym-cdn.com/photos/images/newsfeed/002/440/418/06a'),
	('Guilherme Henrique', 'guilherme.dias@sptech.school', '$2b$10$LC/5qzu7vlhsHGxlHOCZ7uznDtgBgXDlUCBLIn.3EWn1kksAxTs9e', 'https://avatars.githubusercontent.com/u/99812860?v=4'),
	('Helder Davidson', 'helder.alvarenga@sptech.school', '$2b$10$LC/5qzu7vlhsHGxlHOCZ7uznDtgBgXDlUCBLIn.3EWn1kksAxTs9e',  'https://avatars.githubusercontent.com/u/70406114?v=4'),
    ('Leonardo Vasconcelos', 'leonardo.paulino@sptech.school', '$2b$10$LC/5qzu7vlhsHGxlHOCZ7uznDtgBgXDlUCBLIn.3EWn1kksAxTs9e', 'https://avatars.githubusercontent.com/u/70069239?v=4'),
    ('Victor Hugo', 'victor.nascimento@sptech.school', '$2b$10$LC/5qzu7vlhsHGxlHOCZ7uznDtgBgXDlUCBLIn.3EWn1kksAxTs9e', 'https://avatars.githubusercontent.com/u/99813230?v=4'),
	('Vitor Gonçalves', 'vitor@gmail.com', '$2b$10$LC/5qzu7vlhsHGxlHOCZ7uznDtgBgXDlUCBLIn.3EWn1kksAxTs9e', 'https://avatars.githubusercontent.com/u/70069239?v=4');

INSERT INTO board (name) VALUES 
	("Front-end"), 
    ("Back-end"),
    ("Teórico e Outros");

INSERT INTO section (board_id, name, color) VALUES
	(1, "Sprint 1", "bg-emerald-400"),
    (2, "Sprint 1", "bg-emerald-400"),
    (3, "Sprint 1", "bg-emerald-400");
    
INSERT INTO task (section_id, name, description, priority, fibonacci, status, time, data_estimada) VALUES 
	(1, "Tela de Login", "Tela de login para autenticar o usuario atraves do jwt.", 0, 3, 0, 2, DATE(CURRENT_TIMESTAMP())),
	(1, "JWT", "Autenticação.", 0, 3, 0, 4, DATE(CURRENT_TIMESTAMP())),
    (2, "Componente de Buffet", "Criar componente de buffet estilizado para visualização pública.", 0, 3, 0, 8, DATE(CURRENT_TIMESTAMP())),
	(2, "Mascara de dinheiro", "Criar mascara de dinheiro para inputs necessários.", 0, 3, 0, 4, DATE(CURRENT_TIMESTAMP())),
    (3, "Documentação", "Reformatar, adaptar e desenvolver novos textos para o embasamento do projeto.", 0, 3, 0, 5, DATE(CURRENT_TIMESTAMP())),
	(3, "Modelagem", "Entregar o diagrama de banco de dados de acordo com o escopo fechado do projeto.", 0, 3 ,0, 4, DATE(CURRENT_TIMESTAMP()));

INSERT INTO user_task VALUES
	(1, 1),
    (2, 2),
	(1, 2),
    (3, 3),
    (4, 3),
    (4, 4),
    (5, 1),
    (5, 5),
    (6, 6);

INSERT INTO tag (name) VALUES 
	("front end"),
	("back end"),
    ("qa"),
    ("devops");

UPDATE task SET STATUS = 1 WHERE id = 2;