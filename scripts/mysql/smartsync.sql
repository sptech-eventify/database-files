-- SELECT PARA DETERMINAR OS BOARDS DO BUFFET
/*
SELECT bs.id id_board, s.descricao servico
FROM eventify.buffet_servico bs 
JOIN eventify.buffet b ON bs.id_buffet = b.id
JOIN eventify.servico s ON bs.id_servico = s.id
WHERE b.id = ${idBuffet} ORDER BY servico ASC;
*/

SELECT bs.id id_buffet_servico, s.descricao servico
FROM eventify.buffet_servico bs 
JOIN eventify.buffet b ON bs.id_buffet = b.id
JOIN eventify.servico s ON bs.id_servico = s.id
WHERE b.id = 1 ORDER BY servico ASC;


SELECT c.id, c.nome, e.data FROM eventify.evento e JOIN eventify.usuario c ON c.id = e.id_contratante WHERE id_buffet = 1 AND data > NOW() ORDER BY data ASC;


SELECT NOW();

SELECT * 
FROM buffet b
JOIN transacao AS