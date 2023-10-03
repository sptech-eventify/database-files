-- SELECT PARA DETERMINAR OS BOARDS DO BUFFET
/*
SELECT bs.id id_board, s.descricao servico
FROM eventify.buffet_servico bs 
JOIN eventify.buffet b ON bs.id_buffet = b.id
JOIN eventify.servico s ON bs.id_servico = s.id
WHERE b.id = ${idBuffet} ORDER BY servico ASC;
*/

-- Inserção de tarefas

