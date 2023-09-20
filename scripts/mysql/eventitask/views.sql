USE eventitask;

CREATE OR REPLACE VIEW eventitask.vw_sections_task_resp AS
    SELECT 
        b.id,
        b.name,
        s.id section_id,
        s.name section_name,
        s.color,
        t.id task_id,
        t.name task_name,
        t.description,
        t.priority,
        t.fibonacci,
        t.status,
        t.time,
        t.data_estimada,
        GROUP_CONCAT(distinct tg.id) tags_id,
        GROUP_CONCAT(distinct tg.name) tags,
        COUNT(tt.id) subtask_id,
        GROUP_CONCAT(tt.status) subtasks_status,
        GROUP_CONCAT(distinct u.img) responsaveis,
        GROUP_CONCAT(distinct u.id) responsaveis_id
    FROM
        board b
            LEFT JOIN
        section s ON s.board_id = b.id
            LEFT JOIN
        task t ON t.section_id = s.id
            LEFT JOIN
        task tt ON tt.task_id = t.id
            LEFT JOIN
        user_task ut ON ut.task_id = t.id
            LEFT JOIN
        user u ON u.id = ut.user_id
			LEFT JOIN
		tag_task tk on tk.task_id = t.id
			LEFT JOIN
		tag tg on tg.id = tk.tag_id
    GROUP BY b.id, t.id, s.id order by s.id;

    
CREATE OR REPLACE VIEW eventitask.vw_message_user AS
    SELECT 
        m.task_id,
        m.id,
        m.message,
        u.id user_id,
        u.name,
        u.img,
        m.time
    FROM
        comment m
            LEFT JOIN
        user u ON u.id = m.user_id
    GROUP BY m.id
    ORDER BY m.id;


CREATE OR REPLACE VIEW eventitask.vw_avg_board_by_section AS
SELECT
    b.name board_name,
    s.name section_name,
    COALESCE(TRUNCATE(AVG(t.time), 0)) media_tempo
FROM
    board b
    LEFT JOIN section s ON s.board_id = b.id
    LEFT JOIN task t ON t.section_id = s.id
WHERE
    b.name IN ('Front-end', 'Back-end', 'Teórico e Outros')
GROUP BY
    b.name, s.name;

    
CREATE OR REPLACE VIEW eventitask.vw_expected_time_to_conclusion AS
SELECT
    b.name board_name,
    s.name section_name,
    SUM(t.time) tempo_total_secao,
    SUM(t.time) - IFNULL(SUM(CASE WHEN t.status = 2 THEN t.time ELSE 0 END), 0) tempo_faltante,
    CURDATE() + INTERVAL CEIL((SUM(t.time) - IFNULL(SUM(CASE WHEN t.status = 2 THEN t.time ELSE 0 END), 0)) / 4) DAY data_estimada
FROM
    board b
    LEFT JOIN section s ON s.board_id = b.id
    LEFT JOIN task t ON t.section_id = s.id
GROUP BY
    b.name, s.name;


CREATE OR REPLACE VIEW eventitask.vw_kpi_distribution_tasks AS
	SELECT u.name user, 
    COUNT(ut.task_id) qtd_tasks
FROM user u
	LEFT JOIN user_task ut ON u.id = ut.user_id
	LEFT JOIN task t ON ut.task_id = t.id
	LEFT JOIN section s ON t.section_id = s.id
GROUP BY u.name;


CREATE OR REPLACE VIEW eventitask.vw_user_task_summary AS
SELECT
    u.name user,
    COUNT(ut.task_id) task_count,
    IFNULL(AVG(t.time), 0) avg_time_hours,
    MAX(t.data_estimada) estimated_completion_date
FROM user u
LEFT JOIN user_task ut ON u.id = ut.user_id
LEFT JOIN task t ON ut.task_id = t.id
GROUP BY u.id;


CREATE OR REPLACE VIEW eventitask.vw_task_logs AS
SELECT
    a.id log_id,
    t.name task_name,
    u.name changed_by_user,
    a.type_change change_type,
    a.old_value old_task_value,
    a.new_value new_task_value,
    a.change_time change_time
FROM
    eventitask.audit a
JOIN
    eventitask.task t ON a.table_name = 'task' AND a.column_name = 'status' AND CAST(a.old_value AS SIGNED) <> CAST(a.new_value AS SIGNED)
JOIN
    eventitask.user u ON a.changed_by = u.id
ORDER BY
    a.change_time DESC;


CREATE OR REPLACE VIEW eventitask.vw_sections_progress AS
SELECT
    b.name board,
    s.name name,
    IFNULL((SUM(t.status = 2) / NULLIF(COUNT(t.id), 0)) * 100, 0) percent
FROM
    eventitask.board b
LEFT JOIN
    eventitask.section s ON b.id = s.board_id
LEFT JOIN
    eventitask.task t ON s.id = t.section_id
GROUP BY
    b.id, s.id
ORDER BY
    b.name, s.name;


CREATE OR REPLACE VIEW eventitask.vw_area_progress AS
SELECT
	b.name board,
    sc.name section,
	t.name task,
    DATE(t.data_estimada) day,
    CASE
        WHEN t.status = 0 THEN 'pendente'
        WHEN t.status = 1 THEN 'em desenvolvimento'
        WHEN t.status = 2 THEN 'concluído'
        ELSE 'desconhecido'
    END AS 'status',
    u.name
FROM
    eventitask.task t
JOIN eventitask.user_task ut ON t.id = ut.task_id
JOIN eventitask.user u ON u.id = ut.user_id
JOIN eventitask.section sc ON t.section_id = sc.id
JOIN eventitask.board b ON sc.board_id = b.id
WHERE
    t.status = 2
    AND DATE(t.data_estimada) BETWEEN CURDATE() - INTERVAL 6 DAY AND CURDATE()
GROUP BY
    day
ORDER BY
    day;


CREATE OR REPLACE VIEW eventitask.tarefas_gerais AS
SELECT
    t.id task_id,
    t.name task_name,
    t.description task_description,
    t.priority task_priority,
    t.fibonacci task_fibonacci,
    CASE
        WHEN t.status = 0 THEN 'pendente'
        WHEN t.status = 1 THEN 'em desenvolvimento'
        WHEN t.status = 2 THEN 'concluído'
        ELSE 'desconhecido'
    END task_status,
    t.time task_time,
    t.data_estimada task_data_estimada,
    s.id section_id,
    s.name section_name,
    b.id board_id,
    b.name board_name,
    u.id created_by_user_id,
    u.name created_by_user_name,
    ut.user_id allocated_to_user_id,
    cu.name allocated_to_user_name,
    c.id comment_id,
    c.message comment_message,
    c.time comment_time,
    tc.name tag_name
FROM
    eventitask.task t
LEFT JOIN
    eventitask.section s ON t.section_id = s.id
LEFT JOIN
    eventitask.board b ON s.board_id = b.id
LEFT JOIN
    eventitask.user u ON t.created_by = u.id
LEFT JOIN
    eventitask.user_task ut ON t.id = ut.task_id
LEFT JOIN
    eventitask.user cu ON ut.user_id = cu.id
LEFT JOIN
    eventitask.comment c ON t.id = c.task_id
LEFT JOIN
    eventitask.tag_task tt ON t.id = tt.task_id
LEFT JOIN
    eventitask.tag tc ON tt.tag_id = tc.id;


CREATE OR REPLACE VIEW eventitask.vw_avg_board_by_board AS
SELECT
    b.name board_name,
    COALESCE(TRUNCATE(AVG(t.time), 0)) media_tempo
FROM
    board b
    LEFT JOIN section s ON s.board_id = b.id
    LEFT JOIN task t ON t.section_id = s.id
WHERE
    b.name IN ('Front-end', 'Back-end', 'Teórico e Outros')
GROUP BY
    b.name;

    
CREATE OR REPLACE VIEW eventitask.vw_expected_time_to_conclusion_board AS
SELECT
    b.name board_name,
    SUM(t.time) tempo_total_secao,
    SUM(t.time) - IFNULL(SUM(CASE WHEN t.status = 2 THEN t.time ELSE 0 END), 0) tempo_faltante,
    CURDATE() + INTERVAL CEIL((SUM(t.time) - IFNULL(SUM(CASE WHEN t.status = 2 THEN t.time ELSE 0 END), 0)) / 4) DAY data_estimada
FROM
    board b
    LEFT JOIN section s ON s.board_id = b.id
    LEFT JOIN task t ON t.section_id = s.id
GROUP BY
    b.name;
    

CREATE VIEW tasks_board AS
SELECT 
    b.id board_id,
    b.name board_name,
    s.id section_id,
    s.name section_name,
    s.color section_color,
    t.id task_id,
    t.name task_name,
    t.description task_description,
    t.priority task_priority,
    t.fibonacci task_fibonacci,
    t.status task_status,
    t.time task_time,
    t.time_estimado task_time_estimado,
    t.data_estimada task_data_estimada,
    GROUP_CONCAT(DISTINCT u.id) u_resp
FROM board b
JOIN section s ON b.id = s.board_id
JOIN task t ON s.id = t.section_id
JOIN user_task tu on t.id = tu.task_id
JOIN user u on u.id = tu.user_id
GROUP BY b.id, s.id, t.id;


CREATE VIEW vw_section_view_by_board AS
SELECT
    b.id as board_id,
    s.id as section_id,
    s.name as section_name,
    s.color,
    SUM(CASE WHEN t.status = 2 THEN 1 ELSE 0 END) as tasks_completed,
    COUNT(t.id) as total_tasks,
    (SUM(CASE WHEN t.status = 2 THEN 1 ELSE 0 END) / COUNT(t.id)) * 100 as completion_percentage
FROM board b
JOIN section s on s.board_id = b.id
LEFT JOIN task t on t.section_id = s.id
GROUP BY b.id, s.id, s.name;





-- POS


USE eventitask;

CREATE OR REPLACE VIEW eventitask.vw_sections_task_resp AS
    SELECT 
        b.id,
        b.name,
        s.id AS section_id,
        s.name AS section_name,
        s.color,
        t.id AS task_id,
        t.name AS task_name,
        t.description,
        t.priority,
        t.fibonacci,
        t.status,
        t.time,
        t.data_estimada,
        GROUP_CONCAT(distinct tg.id) as tags_id,
        GROUP_CONCAT(distinct tg.name) as tags,
        COUNT(tt.id) AS subtask_id,
        GROUP_CONCAT(tt.status) as subtasks_status,
        GROUP_CONCAT(distinct u.img) AS responsaveis,
        GROUP_CONCAT(distinct u.id) AS responsaveis_id
    FROM
        board AS b
            LEFT JOIN
        section AS s ON s.board_id = b.id
            LEFT JOIN
        task AS t ON t.section_id = s.id
            LEFT JOIN
        task AS tt ON tt.task_id = t.id
            LEFT JOIN
        user_task AS ut ON ut.task_id = t.id
            LEFT JOIN
        user AS u ON u.id = ut.user_id
			LEFT JOIN
		tag_task as tk on tk.task_id = t.id
			LEFT JOIN
		tag as tg on tg.id = tk.tag_id
    GROUP BY b.id, t.id, s.id order by s.id;

    
CREATE OR REPLACE VIEW eventitask.vw_message_user AS
    SELECT 
        m.task_id,
        m.id,
        m.message,
        u.id AS user_id,
        u.name,
        u.img,
        m.time
    FROM
        comment AS m
            LEFT JOIN
        user AS u ON u.id = m.user_id
    GROUP BY m.id
    ORDER BY m.id;


CREATE OR REPLACE VIEW eventitask.vw_avg_board_by_section AS
SELECT
    b.name AS board_name,
    s.name AS section_name,
    COALESCE(TRUNCATE(AVG(t.time), 0)) AS media_tempo
FROM
    board b
    LEFT JOIN section s ON s.board_id = b.id
    LEFT JOIN task t ON t.section_id = s.id
WHERE
    b.name IN ('Front-end', 'Back-end', 'Teórico e Outros')
GROUP BY
    b.name, s.name;

    
CREATE OR REPLACE VIEW eventitask.vw_expected_time_to_conclusion AS
SELECT
    b.name AS board_name,
    s.name AS section_name,
    SUM(t.time) AS tempo_total_secao,
    SUM(t.time) - IFNULL(SUM(CASE WHEN t.status = 2 THEN t.time ELSE 0 END), 0) AS tempo_faltante,
    CURDATE() + INTERVAL CEIL((SUM(t.time) - IFNULL(SUM(CASE WHEN t.status = 2 THEN t.time ELSE 0 END), 0)) / 4) DAY AS data_estimada
FROM
    board b
    LEFT JOIN section s ON s.board_id = b.id
    LEFT JOIN task t ON t.section_id = s.id
GROUP BY
    b.name, s.name;


CREATE OR REPLACE VIEW eventitask.vw_kpi_distribution_tasks AS
	SELECT b.id as board_id, u.name user, COUNT(ut.task_id) 'qtd_tasks'
FROM user u
	LEFT JOIN user_task ut ON u.id = ut.user_id
	LEFT JOIN task t ON ut.task_id = t.id
	LEFT JOIN section s ON t.section_id = s.id
	LEFT JOIN board b on s.board_id = b.id
GROUP BY u.name, b.id;


CREATE OR REPLACE VIEW eventitask.vw_user_task_summary AS
SELECT
    u.name 'user',
    COUNT(ut.task_id) task_count,
    IFNULL(AVG(t.time), 0) AS avg_time_hours,
    MAX(t.data_estimada) estimated_completion_date
FROM user u
LEFT JOIN user_task ut ON u.id = ut.user_id
LEFT JOIN task t ON ut.task_id = t.id
GROUP BY u.id;


CREATE OR REPLACE VIEW eventitask.vw_task_logs AS
SELECT
    a.id log_id,
    t.name task_name,
    u.name changed_by_user,
    a.type_change change_type,
    a.old_value old_task_value,
    a.new_value new_task_value,
    a.change_time change_time
FROM
    eventitask.audit AS a
JOIN
    eventitask.task AS t ON a.table_name = 'task' AND a.column_name = 'status' AND CAST(a.old_value AS SIGNED) <> CAST(a.new_value AS SIGNED)
JOIN
    eventitask.user AS u ON a.changed_by = u.id
ORDER BY
    a.change_time DESC;


CREATE OR REPLACE VIEW eventitask.vw_sections_progress AS
SELECT
    b.name board,
    s.name name,
    IFNULL((SUM(t.status = 2) / NULLIF(COUNT(t.id), 0)) * 100, 0) percent
FROM
    eventitask.board AS b
LEFT JOIN
    eventitask.section AS s ON b.id = s.board_id
LEFT JOIN
    eventitask.task AS t ON s.id = t.section_id
GROUP BY
    b.id, s.id
ORDER BY
    b.name, s.name;


CREATE OR REPLACE VIEW eventitask.vw_area_progress AS
SELECT
	b.name board,
    sc.name section,
	t.name task,
    DATE(t.data_estimada) day,
    CASE
        WHEN t.status = 0 THEN 'pendente'
        WHEN t.status = 1 THEN 'em desenvolvimento'
        WHEN t.status = 2 THEN 'concluído'
        ELSE 'desconhecido'
    END AS 'status',
    u.name
FROM
    eventitask.task t
JOIN eventitask.user_task ut ON t.id = ut.task_id
JOIN eventitask.user u ON u.id = ut.user_id
JOIN eventitask.section sc ON t.section_id = sc.id
JOIN eventitask.board b ON sc.board_id = b.id
WHERE
    t.status = 2
    AND DATE(t.data_estimada) BETWEEN CURDATE() - INTERVAL 6 DAY AND CURDATE()
GROUP BY
    day
ORDER BY
    day;


CREATE OR REPLACE VIEW eventitask.tarefas_gerais AS
SELECT
    t.id AS task_id,
    t.name AS task_name,
    t.description AS task_description,
    t.priority AS task_priority,
    t.fibonacci AS task_fibonacci,
    CASE
        WHEN t.status = 0 THEN 'pendente'
        WHEN t.status = 1 THEN 'em desenvolvimento'
        WHEN t.status = 2 THEN 'concluído'
        ELSE 'desconhecido'
    END AS task_status,
    t.time AS task_time,
    t.data_estimada AS task_data_estimada,
    s.id AS section_id,
    s.name AS section_name,
    b.id AS board_id,
    b.name AS board_name,
    u.id AS created_by_user_id,
    u.name AS created_by_user_name,
    ut.user_id AS allocated_to_user_id,
    cu.name AS allocated_to_user_name,
    c.id AS comment_id,
    c.message AS comment_message,
    c.time AS comment_time,
    tc.name AS tag_name
FROM
    eventitask.task AS t
LEFT JOIN
    eventitask.section AS s ON t.section_id = s.id
LEFT JOIN
    eventitask.board AS b ON s.board_id = b.id
LEFT JOIN
    eventitask.user AS u ON t.created_by = u.id
LEFT JOIN
    eventitask.user_task AS ut ON t.id = ut.task_id
LEFT JOIN
    eventitask.user AS cu ON ut.user_id = cu.id
LEFT JOIN
    eventitask.comment AS c ON t.id = c.task_id
LEFT JOIN
    eventitask.tag_task AS tt ON t.id = tt.task_id
LEFT JOIN
    eventitask.tag AS tc ON tt.tag_id = tc.id;

CREATE OR REPLACE VIEW tasks_board AS
SELECT 
    b.id AS board_id,
    b.name AS board_name,
    s.id AS section_id,
    s.name AS section_name,
    s.color AS section_color,
    t.id AS task_id,
    t.name AS task_name,
    t.description AS task_description,
    t.priority AS task_priority,
    t.fibonacci AS task_fibonacci,
    t.status AS task_status,
    t.time AS task_time,
    t.time_estimado AS task_time_estimado,
    t.data_estimada AS task_data_estimada,
    group_concat(distinct u.id) as u_resp
FROM board b
JOIN section s ON b.id = s.board_id
JOIN task t ON s.id = t.section_id
JOIN user_task tu on t.id = tu.task_id
JOIN user u on u.id = tu.user_id
GROUP BY b.id, s.id, t.id;

CREATE OR REPLACE VIEW section_view_by_board AS
SELECT
    b.id as board_id,
    s.id as section_id,
    s.name as section_name,
    s.color,
    SUM(CASE WHEN t.status = 2 THEN 1 ELSE 0 END) as tasks_completed,
    COUNT(t.id) as total_tasks,
    (SUM(CASE WHEN t.status = 2 THEN 1 ELSE 0 END) / COUNT(t.id)) * 100 as completion_percentage
FROM board b
JOIN section s on s.board_id = b.id
LEFT JOIN task t on t.section_id = s.id
GROUP BY b.id, s.id, s.name;

CREATE OR REPLACE VIEW eventitask.vw_avg_board_by_board AS
SELECT
    b.id as board_id,
    b.name board_name,
    COALESCE(TRUNCATE(AVG(t.time), 0)) media_tempo
FROM
    board b
    LEFT JOIN section s ON s.board_id = b.id
    LEFT JOIN task t ON t.section_id = s.id
WHERE
    b.name IN ('Front-end', 'Back-end', 'Teórico e Outros')
GROUP BY
    b.id;

    
CREATE OR REPLACE VIEW eventitask.vw_expected_time_to_conclusion_board AS
SELECT
    b.id as board_id,
    b.name board_name,
    SUM(t.time) tempo_total_secao,
    SUM(t.time) - IFNULL(SUM(CASE WHEN t.status = 2 THEN t.time ELSE 0 END), 0) tempo_faltante,
    CURDATE() + INTERVAL CEIL((SUM(t.time) - IFNULL(SUM(CASE WHEN t.status = 2 THEN t.time ELSE 0 END), 0)) / 4) DAY data_estimada
FROM
    board b
    LEFT JOIN section s ON s.board_id = b.id
    LEFT JOIN task t ON t.section_id = s.id
GROUP BY
    b.id;