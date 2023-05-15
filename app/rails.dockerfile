# Dockerfile.rails
FROM ruby:3.2.2

RUN apt-get update -qq
RUN apt-get install -y nodejs postgresql-client yarn yarnpkg npm redis
WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock
RUN gem update --system 3.4.13
# RUN bundle exec css:install:bootstrap
# RUN bundle exec javascript:install:esbuild

RUN bundle check || bundle install
RUN bundle update
# RUN npm install -g npm@latest
# RUN npm -g i yarn
RUN rails assets:precompile

EXPOSE 3000

# Configure the main process to run when running the image

# YARN!!!
# COPY package.json yarn.lock ./
# RUN yarn install --check-files
# Run a shell
# CMD ["/bin/sh"]