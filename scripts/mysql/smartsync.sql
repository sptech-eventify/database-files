use eventify;

SELECT * FROM buffet;


SELECT b.id, SUM(preco) FROM evento e join buffet b on b.id = e.id_buffet
WHERE e.status = 6
GROUP BY b.id;

SELECT b.id, SUM(valor) FROM transacao t join buffet b on b.id = t.id_buffet
WHERE t.is_gasto = 1
GROUP BY b.id;


SELECT * FROM transacao;

