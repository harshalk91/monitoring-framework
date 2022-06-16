from flask import Flask, request
from python_terraform import *
import requests
import json
import logging
import os

app = Flask(__name__)

# logging.basicConfig(
#     filename="terraform-workflow",
#     filemode='a',
#     level=logging.DEBUG,
#     format='%(asctime)s.%(msecs)03d %(levelname)s %(module)s - %(funcName)s: %(message)s',
#     datefmt='%Y-%m-%d %H:%M:%S',
# )
# logging.info("Started...")
# logger = logging.getLogger(__name__)

# logger.debug("Opening service directory mapping")
with open(os.path.abspath(os.getcwd()) + "/service_directory_mapping.json", 'r') as dir_mapping:
    dir_mapping_file = dir_mapping.read()


def tf_initialize(directory_path):
    tf = Terraform(working_dir=directory_path)
    os.chdir(directory_path)
    return_code, stdout, stderr = tf.init()
    if stderr:
        # logger.debug(stderr)
        raise ValueError('Terraform Initialization Failed at {}'.format(directory_path))
    return stdout


def tf_plan(directory_path):
    tf = Terraform(working_dir=directory_path)
    os.chdir(directory_path)
    return_code, stdout, stderr = tf.plan()
    if stderr:
        # logger.debug(stderr)
        raise ValueError('Terraform Plan Failed at {}'.format(directory_path))
    return stdout


def msg_process(msg, tstamp):
    js = json.loads(msg)
    # logger.debug(js)

    # if js['source'] == 'aws.ec2':
    #     tf_init = tf_initialize(dir_mapping_file['ec2'])
    #     logger.debug(tf_init)
    #     print(tf_init)
    #
    #     plan = tf_plan(dir_mapping_file['ec2'])
    #     logger.debug(plan)
    #     print(plan)


@app.route('/', methods=['GET', 'POST', 'PUT'])
def sns():
    # AWS sends JSON with text/plain mimetype
    try:
        my_dict = request.data.decode('utf8').replace("'", '"')
        print(my_dict)
    except:
        pass

    print(request.headers)
    hdr = request.headers.get('X-Amz-Sns-Message-Type')
    print(hdr)
    # subscribe to the SNS topic
    if hdr == 'SubscriptionConfirmation' and 'SubscribeURL' in js:
        r = requests.get(js['SubscribeURL'])

    if hdr == 'Notification':
        msg_process(js['Message'])

    return 'OK\n'


if __name__ == '__main__':
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=True
    )
