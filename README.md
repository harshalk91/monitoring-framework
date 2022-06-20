# monitoring-framework

## Architecture

![Monitoring Framework](Diagrams/Monitoring-Framework.png)

# Detailed Flow
1. User/Service Account Create/Delete resources in AWS Cloud
2. AWS Event bridge rule gets invoked whenever resource is created/deleted
3. AWS Event rule adds a message in SQS Target Queue.
4. SQS Listener(Python Script) polls for message from SQS Queue
5. After receiving message from SQS Queue, script checks for below values
   1. Resource Type. Example. EC2, S3
   2. Event Type - Creation/Deletion
6. Once script identifies these two values, it proceeds with either 
   1. Cloudwatch Alarms Creation - When event type is Create
   2. Cloudwatch Alarm Deletion -  When event type is Delete
7. Once Cloudwatch alarms are created or deleted, the message gets deleted from the queue. 