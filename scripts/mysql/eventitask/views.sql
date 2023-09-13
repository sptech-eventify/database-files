CREATE VIEW vw_sections_task_resp AS
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
    
CREATE VIEW vw_message_user AS
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
    