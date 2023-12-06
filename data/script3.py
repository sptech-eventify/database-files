import random
from datetime import datetime, timedelta

def generate_random_cpf():
    return ''.join(random.choices('0123456789', k=11))

def generate_random_datetime(start_date, end_date):
    time_delta = end_date - start_date
    random_days = random.randint(0, time_delta.days)
    return start_date + timedelta(days=random_days)

def generate_random_email():
    domains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'sptech.school']
    return f"{random.randint(1000, 9999)}_{random.randint(10000, 99999)}@{random.choice(domains)}"

def generate_insert_command(name, email, password, type_user, is_active, is_banned, cpf, creation_date, last_login):
    return  f"('{name}', '{email}', '{password}', {type_user}, {is_active}, {is_banned}, '{cpf}', '{creation_date}', '{last_login}'),"

# Informações iniciais
start_date = datetime(2023, 5, 1, 0, 0, 0)
end_date = datetime(2023, 12, 5, 23, 59, 59)
password_hash = '$2a$10$0/TKTGxdREbWaWjWYhwf6e9P1fPOAMMNqEnZgOG95jnSkHSfkkIrC'

print("INSERT INTO `eventify`.`usuario` (nome, email, senha, tipo_usuario, is_ativo, is_banido, cpf, data_criacao, ultimo_login) VALUES \n")

# Gerar e inserir 80 usuários
for user_id in range(2, 400):  # Começando de 2 para evitar duplicatas com os três usuários já inseridos
    name = f'User {user_id}'
    email = generate_random_email()
    cpf = generate_random_cpf()
    creation_date = generate_random_datetime(start_date, end_date).strftime('%Y-%m-%d %H:%M:%S')
    last_login = creation_date  # Último login igual à data de criação
    sql_command = generate_insert_command(name, email, password_hash, 1, 1, 0, cpf, creation_date, last_login)
    print(sql_command)