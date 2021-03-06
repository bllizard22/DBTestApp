import datetime
import json
import sys
import random
from uptime import uptime

from flask import Flask, render_template, request

'''Записываем данные в файл'''
def edit_config(text):
    with open('data.json', 'r') as file:
        file_d = file.read()
    '''Считываем имеющиеся данные'''
    data = json.loads(file_d)

    '''Записываем новые'''
    data['name'] = text['name']
    data['email'] = text['email']
    data['phone'] = text['phone']
    with open('data.json', 'w') as file:
        json.dump(data, file, indent=2)


'''Получаем время компьютера'''
def get_time():
    current = datetime.datetime.now().timestamp()
    current_time = datetime.datetime.fromtimestamp(current).strftime('%Y-%m-%d %H:%M:%S')
    print(current_time)
    return current_time


def start_http(host_ip, host_port):

    with open('data.json', 'r') as file:
        file_d = file.read()
    data = json.loads(file_d)
    host_ip = host_ip
    host_http_port = host_port
    app = Flask(__name__, template_folder='templates')

    '''Основная страница сервера'''
    @app.route("/")
    def home():
        duration = str(datetime.timedelta(seconds=uptime()))[:-7].split(" ")
        return f"home GET Connected OK\n Time: {get_time()}"

    '''Выполняется при нажатии кнопки "Сохранить"'''
    @app.route('/', methods=['POST'])
    def wait_time_post():
        # headers = request.headers
        # print(headers)
        '''Получение тела запроса'''
        body = request.get_json(force=True)
        print(body)

        '''Чтение имеющегося файла-базы'''
        with open('data.json', 'r') as file:
            data_json = json.load(file)

        try:
            user_id = body['user_id']
            new_user = {'name': body['name'],
                        'email': body['email'],
                        'phone': body['phone']}
            new_record = {user_id: new_user}

            try:
                data_json[user_id] = new_user
            except:
                '''Печать неизвестных ошибок'''
                print(sys.exc_info()[0])

            print("Full doc:\n", data_json)

            '''Записываем обратно в файл'''
            with open('data.json', 'w') as file:
                json.dump(data_json, file, indent=2)
        except:
            print(sys.exc_info()[0])
            user_id = "no user data"
            new_user = {'name': "no_name",
                        'email': "no_email",
                        'phone': "no_phone"}

        '''Отвечаем приложению'''
        return f"POST. Status OK\nemail: {new_user['email']}\nUID: {user_id}"

    # '''Внесение изменений в конфиг-файл'''
    # @app.route("/config")
    # def config():
    #     duration = str(datetime.timedelta(seconds=uptime()))[:-7].split(" ")
    #     if len(duration) == 1:
    #         time = duration[0]
    #     else:
    #         days = duration[0]
    #         time = duration[2]
    #     return  f"config GET Connected OK\n Time: {get_time()}"
    #
    # '''Выполняется при нажатии кнопки "Сохранить настройки"'''
    # @app.route('/config', methods=['POST'])
    # def update_config_post():
    #     '''Обработка параметров для записи в конфиг'''
    #     '''Изменяем основные параметры в конфиге на значения
    #         из формы со страницы /config'''
    #     if request.form['master_pass'] == '1991':
    #         if request.form['host_ip'] != '':
    #             data['ip_adress'] = request.form['host_ip'].replace(',', '.')
    #
    #         if request.form['http_port'] != '':
    #             data['http_port'] = request.form['http_port']
    #
    #         with open('data.json', 'w') as file:
    #             json.dump(data, file, indent=2)
    #
    #     '''Выводим сообщение о'''
    #     duration = str(datetime.timedelta(seconds=uptime()))[:-7].split(" ")
    #     days = '0'
    #     if len(duration) == 1:
    #         time = duration[0]
    #     else:
    #         days = duration[0]
    #         time = duration[2]
    #
    #     return  f"config POST Connected OK\n Time: {get_time()}"

    app.run(host=host_ip, port=host_http_port)


if __name__ == "__main__":
    # start_http('', 127)
    start_http('10.101.63.45', 5027)