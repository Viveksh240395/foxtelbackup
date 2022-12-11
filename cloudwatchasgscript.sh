[root@nonp-uxjump-01 opt]# cat Core.sh
# 1) Get instance id and name tag
TOKEN=`curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`



INSTANCE_ID=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/instance-id`



INSTANCE_NAME=`aws ec2 describe-instances --instance-ids $INSTANCE_ID --region ap-southeast-2 --query "Reservations[].Instances[].[Tags[?Key=='Name'].Value[]]" --output text`

ASG_NAME=`aws ec2 describe-instances --instance-ids $INSTANCE_ID --region ap-southeast-2 --query "Reservations[].Instances[].[Tags[?Key=='aws:autoscaling:groupName'].Value[]]" --output text`

IMAGE_ID=`aws ec2 describe-instances --instance-ids $INSTANCE_ID --region ap-southeast-2 --query "Reservations[].Instances[].ImageId" --output text`

PRIMARY_PRIVATE_IP_ADDRESS=`aws ec2 describe-instances --instance-ids $INSTANCE_ID --region ap-southeast-2 --query "Reservations[].Instances[].PrivateIpAddress" --output text`


# 2) all alarm defined..

aws cloudwatch put-metric-alarm --region ap-southeast-2 ${DRYRUN}\
    --alarm-name "${INSTANCE_ID}-cpu"\
    --alarm-description "Alarm when CPU exceeds ${CPU_USAGE}%"\
    --actions-enabled\
    --ok-actions "arn:aws:sns:ap-southeast-2:666761109297:Prod-Core"\
    --alarm-actions "arn:aws:sns:ap-southeast-2:666761109297:Prod-Core"\
    --metric-name CPUUtilization\
    --namespace AWS/EC2\
    --statistic Average\
    --dimensions  Name=InstanceId,Value=${INSTANCE_ID}\
    --period 300\
    --threshold 90\
    --comparison-operator GreaterThanThreshold\
    --evaluation-periods 2\
    --unit Percent

aws cloudwatch put-metric-alarm --region ap-southeast-2 ${DRYRUN}\
    --alarm-name "${INSTANCE_ID}-RootFSalarm"\
    --alarm-description "Alarm when FS exceeds 90%"\
    --actions-enabled\
    --ok-actions "arn:aws:sns:ap-southeast-2:666761109297:Prod-Core"\
    --alarm-actions "arn:aws:sns:ap-southeast-2:666761109297:Prod-Core"\
    --metric-name disk_used_percent\
    --namespace CWAgent\
    --statistic Average\
    --dimensions  Name=InstanceId,Value=${INSTANCE_ID} Name=AutoScalingGroupName,Value=${ASG_NAME} Name=ImageId,Value=${IMAGE_ID} Name=InstanceType,Value=r5.xlarge Name=path,Value=/ Name=device,Value=nvme0n1p2 Name=fstype,Value=xfs\
    --period 300\
    --threshold 90\
    --comparison-operator GreaterThanThreshold\
    --evaluation-periods 2

aws cloudwatch put-metric-alarm --region ap-southeast-2 ${DRYRUN}\
    --alarm-name "${INSTANCE_ID}-VarlogAlarm"\
    --alarm-description "Alarm when FS exceeds 90%"\
    --actions-enabled\
    --ok-actions "arn:aws:sns:ap-southeast-2:666761109297:Prod-Core"\
    --alarm-actions "arn:aws:sns:ap-southeast-2:666761109297:Prod-Core"\
    --metric-name disk_used_percent\
    --namespace CWAgent\
    --statistic Average\
    --dimensions  Name=InstanceId,Value=${INSTANCE_ID} Name=AutoScalingGroupName,Value=${ASG_NAME} Name=ImageId,Value=${IMAGE_ID} Name=InstanceType,Value=r5.xlarge Name=path,Value=/var/log Name=device,Value=mapper/Foxtel_vg-Foxtel_var_log Name=fstype,Value=xfs\
    --period 300\
    --threshold 90\
    --comparison-operator GreaterThanThreshold\
    --evaluation-periods 2

aws cloudwatch put-metric-alarm --region ap-southeast-2 ${DRYRUN}\
    --alarm-name "${INSTANCE_ID}-OracleFSalarm"\
    --alarm-description "Alarm when FS exceeds 90%"\
    --actions-enabled\
    --ok-actions "arn:aws:sns:ap-southeast-2:666761109297:Prod-Core"\
    --alarm-actions "arn:aws:sns:ap-southeast-2:666761109297:Prod-Core"\
    --metric-name disk_used_percent\
    --namespace CWAgent\
    --statistic Average\
    --dimensions  Name=InstanceId,Value=${INSTANCE_ID} Name=AutoScalingGroupName,Value=${ASG_NAME} Name=ImageId,Value=${IMAGE_ID} Name=InstanceType,Value=r5.xlarge Name=path,Value=/u01/app/oracle Name=device,Value=mapper/Foxtel_vg-Oracle Name=fstype,Value=xfs\
    --period 300\
    --threshold 90\
    --comparison-operator GreaterThanThreshold\
    --evaluation-periods 2

aws cloudwatch put-metric-alarm --region ap-southeast-2 ${DRYRUN}\
    --alarm-name "${INSTANCE_ID}-Memory"\
    --alarm-description "Alarm when mem exceeds 90%"\
    --actions-enabled\
    --ok-actions "arn:aws:sns:ap-southeast-2:666761109297:Prod-Core"\
    --alarm-actions "arn:aws:sns:ap-southeast-2:666761109297:Prod-Core"\
    --metric-name mem_used_percent\
    --namespace CWAgent\
    --statistic Average\
    --dimensions  Name=InstanceId,Value=${INSTANCE_ID} Name=AutoScalingGroupName,Value=${ASG_NAME} Name=ImageId,Value=${IMAGE_ID} Name=InstanceType,Value=r5.xlarge\
    --period 300\
    --threshold 90\
    --comparison-operator GreaterThanThreshold\
    --evaluation-periods 2

aws cloudwatch put-metric-alarm --region ap-southeast-2 ${DRYRUN}\
    --alarm-name "${INSTANCE_ID}-StagingFSalarm"\
    --alarm-description "Alarm when FS exceeds 90%"\
    --actions-enabled\
    --ok-actions "arn:aws:sns:ap-southeast-2:666761109297:Prod-Core"\
    --alarm-actions "arn:aws:sns:ap-southeast-2:666761109297:Prod-Core"\
    --metric-name disk_used_percent\
    --namespace CWAgent\
    --statistic Average\
    --dimensions  Name=InstanceId,Value=${INSTANCE_ID} Name=AutoScalingGroupName,Value=${ASG_NAME} Name=ImageId,Value=${IMAGE_ID} Name=InstanceType,Value=r5.xlarge Name=path,Value=/opt/staging Name=device,Value=mapper/Foxtel_vg-staging Name=fstype,Value=xfs\
    --period 300\
    --threshold 90\
    --comparison-operator GreaterThanThreshold\
    --evaluation-periods 2
[root@nonp-uxjump-01 opt]
