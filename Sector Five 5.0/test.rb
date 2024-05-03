require "httparty"

posturl = 'https://086d12a8-13e1-4a3c-aa70-a6c2ece29e2b-asia-south1.apps.astra.datastax.com/api/rest/v2/schemas/keyspaces/helloworld/tables'

res = HTTParty.post(posturl,:data => {"name"=>"rest_example_products","columnDefinitions"=> [{"name"=>"id",'typeDefinition'=>'uuid'}]}, :header => {'content-type' => 'application/json',"x-cassandra-token" => "AstraCS:sBueZOocpUYnJFqnGEqKZmGK:5260b11fc3e9fe1b5e93ed6674c5ca9b653c7724ab43e56f2b62ea59004f3dd3"})
puts res