DROP PROCEDURE IF EXISTS eventitask.sp_tasks;

DELIMITER //
CREATE PROCEDURE eventitask.sp_tasks(IN tipo_tempo VARCHAR(4), IN valor INT)
BEGIN
    DECLARE data_limite DATE;
    
    IF tipo_tempo = 'dia' THEN
        SET data_limite = DATE_SUB(CURDATE(), INTERVAL valor DAY);
    ELSEIF tipo_tempo = 'mês' THEN
        SET data_limite = DATE_SUB(CURDATE(), INTERVAL valor MONTH);
    ELSE
        SET data_limite = DATE_SUB(CUR_DATE(), INTERVAL valor YEAR);
    END IF;
    
    SELECT
		b.id board_id,
		b.name board_name,
        s.id section_id,
        s.name section_name,
        u.name user_name,
        u.img user_image,
        t.id task_id,
        t.name task_name,
		DATE(t.date_creation) date_creation,
        t.data_estimada conclusion_date,
        t.fibonacci
    FROM
        eventitask.task t
    INNER JOIN
        eventitask.user_task ut ON t.id = ut.task_id
    INNER JOIN
		eventitask.user u ON ut.user_id = u.id
	INNER JOIN
        eventitask.section s ON t.section_id = s.id
    INNER JOIN
        eventitask.board b ON s.board_id = b.id
    WHERE
        t.data_estimada >= data_limite;
END //
DELIMITER ;

CALL eventitask.sp_tasks('dia', 5);