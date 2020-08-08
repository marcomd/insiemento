FROM ruby:2.6.6-buster

# Install nodejs and yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y nodejs yarn \
    && gem install bundler --no-doc
#postgresql-client

# Create the application folder
RUN mkdir /insiemento

# Change to the application's directory
WORKDIR /insiemento

# Copying these files as an independent step, followed by bundle install, means that the project gems do not need
# to be rebuilt every time you make changes to your application code.
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install --check-files

# Copy the rest of the application
COPY . ./

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

#EXPOSE 3100

# Start the main process.
ENTRYPOINT ["entrypoint.sh"]