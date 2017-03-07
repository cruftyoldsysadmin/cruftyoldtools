#!/usr/local/bin/ruby
#
require 'json'
require 'httpclient'

counter   = 0
instances = {}
query     = { :apikey => 'APIKEYHERE' }
threads   = []

# Evaluates JSON structure embedded in a string and returns a hash
def json_eval(obj)
  return JSON.parse(eval(obj.body.to_json))
end

# Sets up the HTTP connection with HTTPClient
client = HTTPClient.new(:base_url=> 'https://api.stackdriver.com/v0.2/instances')

# Iterates over hash of all instances in Stackdriver
json_eval(client.get('',query))['data'].each do |instance|
  id = instance['id']

  # Queries stackdriver for the maintenance status of each instance, multi-threaded for speed
  threads<<Thread.new(instance) do |u|
    inst=json_eval(client.get("instances/#{id}/maintenance",query))['data']

    if inst['maintenance']
      instances[id] = inst
    end

  end
end

# Wait for all threads to finish
threads.each(&:join)

instances.each do |k,v|

  msg = "Instance #{k} is in maintence mode "

  if v['reason']
    msg.concat("because: #{v['reason']}")
  else
    msg.concat("for no good reason,")
  end

  if v['schedule']['expires_epoch']
    epoch=DateTime.strptime(v['schedule']['expires_epoch'].to_s, '%s')
    msg.concat(" and will expire at #{epoch}.")
  else
    msg.concat(" and will be until the end of time!")
  end

  puts msg

end
