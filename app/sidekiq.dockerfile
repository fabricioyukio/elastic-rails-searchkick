# Dockerfile.rails
FROM ruby:3.2.2

RUN apt-get update -qq
RUN apt-get install -y nodejs postgresql-client yarn yarnpkg npm cron nano
WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/Gemfile
COPY Gemfile.lock /usr/src/app/Gemfile.lock
RUN gem update --system 3.4.12
# RUN gem update bundler
# RUN bundle exec css:install:bootstrap
# RUN bundle exec javascript:install:esbuild
RUN bundle check || bundle install
RUN bundle update
# RUN chmod +x ./entrypoints/sidekiq-entrypoint.sh
# Using here because my schedule is empty. Can be ignored
RUN bundle exec wheneverize

RUN bundle exec whenever -w
# ENTRYPOINT [ "./entrypoints/sidekiq-entrypoint.sh" ]

CMD [ "bundle", "exec", "sidekiq", "-r", "./config/boot.rb" ]
# RUN npm install -g npm@latest
# RUN npm -g i yarn
# RUN rails assets:precompile

EXPOSE 3000
