# Dockerfile.rails
FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock
RUN gem update --system 3.4.12
RUN bundle check || bundle install
RUN bundle update

EXPOSE 3000

# Configure the main process to run when running the image

# YARN!!!
# COPY package.json yarn.lock ./
# RUN yarn install --check-files
# Run a shell
# CMD ["/bin/sh"]