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
        usuario AS u ON u.id = ut.user_id
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
        usuario AS u ON u.id = m.user_id
    GROUP BY m.id
    ORDER BY m.id;


CREATE OR REPLACE VIEW eventitask.avg_board_by_section AS
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

    
CREATE VIEW expected_time_to_conclusion AS
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




-- CREATE VIEW log_tarefas AS
SELECT
    t.id AS task_id,
    t.name AS nome_tarefa,
    t.description AS descricao_tarefa,
    CASE
        WHEN t.status = 2 THEN 'Concluída'
        ELSE 'Não Concluída'
    END AS status_tarefa,
    t.data_estimada AS data_estimada_conclusao,
    u.name AS responsavel
FROM
    task t
    LEFT JOIN usuario u ON t.task_id = u.id
    JOIN user_task ut ON ut.task_id = t.task_id;

