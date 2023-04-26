require_relative "application"
app_environment_variables = File.join(
  Rails.root, "config", "app_environment_variables.#{Rails.env}.rb"
)
load(app_environment_variables) if File.exist?(app_environment_variables)

Rails.application.initialize!
