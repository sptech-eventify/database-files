import random
import datetime
import os

if not os.path.exists("gerados"):
    os.makedirs("gerados")

arquivo = open("gerados/datas.txt", "w")

data_inicial = datetime.datetime(2023, 10, 25, 0, 0, 0)
data_final = datetime.datetime(2023, 12, 6, 23, 59, 59)

qtd_datas = 1487

for i in range(qtd_datas):
    data_aleatoria = data_inicial + (data_final - data_inicial) * random.random()
    arquivo.write(data_aleatoria.strftime("('" + "%Y-%m-%d %H:%M:%S'") + ", 4),\n")


arquivo.close()