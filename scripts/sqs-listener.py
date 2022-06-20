import json
import time
from pprint import pprint
import boto3
from python_terraform import *
import os

sqs = boto3.resource("sqs", region_name='us-east-1')
queue = sqs.get_queue_by_name(QueueName="monitoring-queue")

# Opening service directory mapping
with open(os.path.abspath(os.getcwd()) + "/service_directory_mapping.json", 'r') as dir_mapping:
    dir_mapping_file = json.loads(dir_mapping.read())


# Initialization
def tf_initialize(directory_path, id):
    tf = Terraform(working_dir=directory_path)
    os.chdir(directory_path)
    return_code, stdout, stderr = tf.cmd("init -reconfigure -backend-config key=monitoring-framework/{}.tf".format(id))
    if stderr:
        raise ValueError('Terraform Initialization Failed at {}'.format(str(directory_path)))
    return "Terraform initialization is successful"


# Apply
def tf_apply(directory_path, parameter_key, tag):
    tf = Terraform(working_dir=directory_path)
    os.chdir(directory_path)
    return_code, stdout, stderr = tf.cmd("apply -var={}={} -auto-approve".format(parameter_key, tag))
    if stderr:
        print(stderr)
        raise ValueError('Terraform Apply Failed at {}'.format(str(directory_path)))
    return stdout


# Destroy
def tf_destroy(directory_path, parameter_key, tag):
    tf = Terraform(working_dir=directory_path)
    os.chdir(directory_path)
    return_code, stdout, stderr = tf.cmd(
        "destroy -auto-approve -var={}={}".format(parameter_key, tag))
    pprint(stdout)
    if stderr:
        print(stderr)
        raise ValueError('Terraform Destroy Failed at {}'.format(str(directory_path)))
    return stdout


# Processing the message
def process_message(message_body):
    msg = json.loads(message_body)
    if msg['source'] == 'aws.ec2':
        print("Message received. Type - EC2. Instance id - {}, State - {}", format(msg['detail']['instance-id'],
                                                                                   msg['detail']['state']))
        tf_init = tf_initialize(dir_mapping_file['aws.ec2'], msg['detail']['instance-id'])
        print(tf_init)
        if msg['detail']['state'] == 'running':
            pprint("{} - {}".format(msg['detail']['instance-id'], msg['detail']['state']))
            apply = tf_apply(dir_mapping_file['aws.ec2'], "instance-id", tag=msg['detail']['instance-id'])
            print(apply)

        if msg['detail']['state'] == 'stopping':
            pprint("{} - {}".format(msg['detail']['instance-id'], msg['detail']['state']))
            target = "aws_cloudwatch_metric_alarm.metric-alarm"
            destroy = tf_destroy(dir_mapping_file['aws.ec2'], "instance-id", tag=msg['detail']['instance-id'])
            print(destroy)

    if msg['source'] == 'aws.s3':
        print("Message received. Type - S3. Bucket Name - {}, State - {}".format(
            msg['detail']['requestParameters']['bucketName'],
            msg['detail']['eventName']))
        tf_init = tf_initialize(dir_mapping_file['aws.s3'], msg['detail']['requestParameters']['bucketName'])
        print(tf_init)

        if msg['detail']['eventName'] == "CreateBucket":
            pprint("{} - {}".format(msg['detail']['requestParameters']['bucketName'], msg['detail']['eventName']))
            apply = tf_apply(dir_mapping_file['aws.s3'], "bucket_name",
                             tag=msg['detail']['requestParameters']['bucketName'])
            print(apply)
        if msg['detail']['eventName'] == "DeleteBucket":
            destroy = tf_destroy(dir_mapping_file['aws.s3'], "bucket_name",
                                 tag=msg['detail']['requestParameters']['bucketName'])
            print(destroy)


if __name__ == "__main__":
    while True:
        messages = queue.receive_messages()
        print("Waiting for messages")
        for message in messages:
            process_message(message.body)
            message.delete()
        time.sleep(1)
