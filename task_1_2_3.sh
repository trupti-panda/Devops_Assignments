#!/bin/bash
sudo su -
yum update -y
yum install -y jq 

#Get V1 and V2 token
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
#Get instance id
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
#get instance private id
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)
#Get the Region
REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)
#Get host name
NAME=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$INSTANCE_ID" \
       --query "Reservations[0].Instances[0].Tags[?Key=='Name'].Value" --output text)
[ -z "$NAME" ] && NAME="server1"

#Set host name
hostnamectl set-hostname "$NAME"


#Install Apache
yum install httpd -y
systemctl enable httpd
echo "HI, Welcome to $NAME" >/var/www/html/index.html
systemctl restart httpd

#Get the Private Route 53 hosted zone name
DNS_NAME=$(aws route53 list-hosted-zones-by-name  --query "HostedZones[*].Name" | grep "dvstech.com" | cut -d ',' -f1 | cut -d '"' -f2)

#Get Hosted Zone ID
HZ=$(aws route53 list-hosted-zones-by-name --dns-name "$DNS_NAME" --region "$REGION" --query "HostedZones[0].Id" --output text | cut -d'/' -f3)

#Create a JSon file to create record
cat <<EOF > /tmp/route_53.json
 {
     "Comment": "Creating a record in a private hosted zone",
     "Changes": [
         {
             "Action": "CREATE",
             "ResourceRecordSet": {
                 "Name":  "$NAME.$DNS_NAME",
                 "Type": "A",
                 "TTL": 300,
                 "ResourceRecords": [
                     {
                         "Value": "$PRIVATE_IP"
                     }
                 ]
             }
         }
     ]
 }
EOF
 
#Create a json file with record information
aws route53 change-resource-record-sets --region "$REGION" --hosted-zone-id "$HZ" --change-batch file:///tmp/route_53.json

 
