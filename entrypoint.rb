require "openai"
require "dotenv/load"
require "pry"
require_relative "app/open_ai_client"
require_relative "app/submission"
require_relative "app/pupilfirst_api"
require_relative "app/reviewer"

OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_ACCESS_TOKEN")
  config.organization_id = ENV.fetch("OPENAI_ORGANIZATION_ID", "") # Optional.
end

def generate_response
  retries = 0
  generate_response = OpenAIClient.new.ask

  case generate_response[:function_name]
  when "create_grading"
    PupilfirstAPI::Grader.new.grade(generate_response[:args])
  when "create_feedback"
    PupilfirstAPI::Grader.new.add_feedback(generate_response[:args])
  else
    raise "Unknown response from OpenAI: #{generate_response}"
  end
rescue => e
  retries += 1
  if retries <= 1
    puts "Attempting retry #{retries} due to error: #{e.message}."
    retry
  else
    puts "Max retries reached. Exiting."
    raise e
  end
end

generate_response
