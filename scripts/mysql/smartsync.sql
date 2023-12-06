use eventify;

SELECT * FROM buffet;


SELECT b.id, SUM(preco) FROM evento e join buffet b on b.id = e.id_buffet
WHERE e.status = 6
GROUP BY b.id;


