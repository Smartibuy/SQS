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

# Receiving messages
resp = sqs.receive_message({
  queue_url: AWS_KEY_SETTING['QUEUE_URL'], # required
  attribute_names: ["All"],
  message_attribute_names: ["id"],
  max_number_of_messages: 10,
  visibility_timeout: 1,
  wait_time_seconds: 1,
})

# Show messages. resp.messages is an array object.
resp.messages.each do |msg|
  puts msg.body
  puts msg.message_attributes['id'].string_value
  # delete the message
  sqs.delete_message({
    queue_url: AWS_KEY_SETTING['QUEUE_URL'],
    receipt_handle: msg.receipt_handle
    })
end
