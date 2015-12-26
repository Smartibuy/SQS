require 'aws-sdk'
require './config/config_env.rb'

# create credentials
aws_access = Aws::Credentials.new(AWS_KEY_SETTING['AWS_ACCESS_KEY_ID'], AWS_KEY_SETTING['AWS_SECRET_ACCESS_KEY'])

# are credentials set?
puts aws_access.set?

# create the sqs object
sqs = Aws::SQS::Client.new(
  region: AWS_KEY_SETTING['AWS_REGION'],
  credentials: aws_access,
)

# data set array of hashes
group_name = [
  { 'name': '清交二手大拍賣XD', 'id': '817620721658179' }
]

#Send message
group_name.each do |msg|
  sqs.send_message({
    queue_url: AWS_KEY_SETTING['QUEUE_URL'],
    message_body: msg[:name],
    delay_seconds: 1,
    message_attributes: {
      "id" => {
        string_value: msg[:id], data_type: "String"
      }
    }
  })
end
