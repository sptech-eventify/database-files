-- SELECT PARA DETERMINAR OS BOARDS DO BUFFET
/*
SELECT bs.id id_board, s.descricao servico
FROM eventify.buffet_servico bs 
JOIN eventify.buffet b ON bs.id_buffet = b.id
JOIN eventify.servico s ON bs.id_servico = s.id
WHERE b.id = ${idBuffet} ORDER BY servico ASC;
*/

SELECT 
	b.id id_buffet,
    bs.id id_buffet_servico,
    bck.id id_bucket,
    t.*
FROM buffet b 
JOIN buffet_servico bs ON bs.id_buffet = b.id
JOIN bucket bck ON bck.id_buffet_servico = bs.id
JOIN tarefa t ON t.id_bucket = bck.id
WHERE b.id = 1 AND t.is_visivel = 1;


SELECT c.id, c.nome, e.data FROM eventify.evento e JOIN eventify.usuario c ON c.id = e.id_contratante WHERE id_buffet = 1 AND data > NOW() ORDER BY data ASC;


SELECT NOW();

SELECT * FROM eventify.buffet_servico WHERE id_buffet = 1;



SELECT DISTINCT nome_servico, id_servico FROM vw_secoes WHERE id_buffet = 1 AND id_evento = 274;