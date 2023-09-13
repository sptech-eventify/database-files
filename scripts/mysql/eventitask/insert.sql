INSERT INTO usuario (name, email, password, img) VALUES 
	("Vitor Gonçalves", "vitor@gmail.com", "$2b$10$LC/5qzu7vlhsHGxlHOCZ7uznDtgBgXDlUCBLIn.3EWn1kksAxTs9e", "https://static.wikia.nocookie.net/b5d5755b-8483-49b1-90b0-7d9fbec0dfb7/scale-to-width/755"),
	("Leonardo Vasconcelos", "leonardo.paulino@sptech.school","$2b$10$LC/5qzu7vlhsHGxlHOCZ7uznDtgBgXDlUCBLIn.3EWn1kksAxTs9e", "https://i.ytimg.com/vi/Xs9JWj3xu2Y/hqdefault.jpg"),
    ("Victor Hugo", "victor.nascimento@sptech.school", "$2b$10$LC/5qzu7vlhsHGxlHOCZ7uznDtgBgXDlUCBLIn.3EWn1kksAxTs9e", "https://i.ytimg.com/vi/IgXS2ocIxbM/maxresdefault.jpg"),
    ("Brayan Coelho", "brayan.aquino@sptech.school","$2b$10$LC/5qzu7vlhsHGxlHOCZ7uznDtgBgXDlUCBLIn.3EWn1kksAxTs9e", "https://i.kym-cdn.com/photos/images/newsfeed/002/440/418/06a"),
    ("Guilherme Henrique", "guilherme.dias@sptech.school", "$2b$10$LC/5qzu7vlhsHGxlHOCZ7uznDtgBgXDlUCBLIn.3EWn1kksAxTs9e","https://steamuserimages-a.akamaihd.net/ugc/1023950687176926290/46C553EA9308B8A863AC764E59F29C46ACA865DF/?imw=637&imh=358&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=true");

INSERT INTO board (name) VALUES 
	("Front End"), 
    ("Back End");

INSERT INTO section (board_id, name, color) values 
	(1, "Sprint 1", "bg-emerald-400");

INSERT INTO task (section_id, name, description, priority, fibonacci, status, time, data_estimada) VALUES 
	(1, "Tela de Login", "tela de login para autenticar o usuario atraves do jwt", 0,3,0,0, DATE(CURRENT_TIMESTAMP())),
	(1, "JWT", "autenticacao", 0,3,0,0, DATE(CURRENT_TIMESTAMP()));

INSERT INTO tag (name) VALUES 
	("front end"),
	("back end"),
    ("qa"),
    ("devops");

UPDATE task SET STATUS = 1 WHERE id = 2;