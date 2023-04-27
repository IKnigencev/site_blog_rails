FROM ruby:3.1.2-slim

WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN apt-get install ruby-full build-essential
RUN gem update --system
RUN apt-get update -y && bundle install


CMD bundle exec rails s -b 0.0.0.0 -p 3000
