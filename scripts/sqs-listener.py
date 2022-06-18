import json
import time
from pprint import pprint
import boto3
from python_terraform import *
import os

sqs = boto3.resource("sqs", region_name='us-east-1')
queue = sqs.get_queue_by_name(QueueName="monitoring-queue")

# logger.debug("Opening service directory mapping")
with open(os.path.abspath(os.getcwd()) + "/service_directory_mapping.json", 'r') as dir_mapping:
    dir_mapping_file = json.loads(dir_mapping.read())


def tf_initialize(directory_path):
    tf = Terraform(working_dir=directory_path)
    os.chdir(directory_path)
    return_code, stdout, stderr = tf.init()
    if stderr:
        raise ValueError('Terraform Initialization Failed at {}'.format(str(directory_path)))
    return "Terraform initialization is successful"


def tf_plan(directory_path, tag):
    tf = Terraform(working_dir=directory_path)
    os.chdir(directory_path)
    return_code, stdout, stderr = tf.cmd("plan -var=instance_id={}".format(tag))
    if stderr:
        raise ValueError('Terraform Plan Failed at {}'.format(str(directory_path)))
    return "Terraform plan is successful"


def tf_apply(directory_path, tag):
    tf = Terraform(working_dir=directory_path)
    os.chdir(directory_path)
    return_code, stdout, stderr = tf.cmd("apply -var=instance_id={} -auto-approve".format(tag))
    if stderr:
        raise ValueError('Terraform Apply Failed at {}'.format(str(directory_path)))
    return stdout


def tf_destroy(directory_path, tag, target):
    tf = Terraform(working_dir=directory_path)
    os.chdir(directory_path)
    return_code, stdout, stderr = tf.cmd("apply -destroy -auto-approve -target={} -var=instance_id={}".format(target, tag))
    pprint(stdout)
    if stderr:
        print(stderr)
        raise ValueError('Terraform Destroy Failed at {}'.format(str(directory_path)))
    return stdout


def process_message(message_body):
    msg = json.loads(message_body)
    if msg['source'] == 'aws.ec2':
        tf_init = tf_initialize(dir_mapping_file['aws.ec2'])
        print(tf_init)
        plan = tf_plan(dir_mapping_file['aws.ec2'], tag=msg['detail']['instance-id'])
        print(plan)
        apply = tf_apply(dir_mapping_file['aws.ec2'], tag=msg['detail']['instance-id'])
        print(apply)
        if msg['detail']['state'] == 'stopping':
            target = "aws_cloudwatch_metric_alarm.metric-alarm"
            destroy = tf_destroy(dir_mapping_file['aws.ec2'], tag=msg['detail']['instance-id'], target=target)
            print(destroy)
    return "ok\n"


if __name__ == "__main__":
    while True:
        messages = queue.receive_messages()
        print("Waiting for messages")
        for message in messages:
            process_message(message.body)
            message.delete()
