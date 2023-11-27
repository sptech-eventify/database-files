import os
import random
import datetime

if not os.path.exists("gerados"):
    os.makedirs("gerados")

arquivo = open("gerados/datas2.txt", "w")

data_inicial = datetime.datetime(2023, 10, 25, 0, 0, 0)
data_final = datetime.datetime(2023, 12, 6, 23, 59, 59)

qtd_datas = 7484

for i in range(qtd_datas):
    data_aleatoria = data_inicial + (data_final - data_inicial) * random.random()
    arquivo.write(data_aleatoria.strftime("('" + "%Y-%m-%d %H:%M:%S'") + ", " + str(random.randint(1,3)) + ", 1),\n")


arquivo.close()