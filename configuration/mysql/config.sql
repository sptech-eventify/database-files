GRANT INSERT, SELECT, UPDATE, DELETE ON eventify.* TO 'backend_eventify'@'%';

GRANT EXECUTE ON PROCEDURE eventify.sp_avaliacoes_buffet TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_churn TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_dados_do_buffet TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_kpi_abandono_reserva TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_kpi_conversao_de_reservas TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_kpi_conversao_de_visitantes TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_kpi_movimentacao_financeira TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_kpi_precisao_do_formulario TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_kpi_satisfacao TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_log_paginas TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_retencao_buffets_retidos TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_retencao_formularios_retidos TO 'backend_eventify'@'%';
GRANT EXECUTE ON PROCEDURE eventify.sp_retencao_usuarios_retidos TO 'backend_eventify'@'%';

FLUSH PRIVILEGES;

