# Olark Chat Web Scraper

## About

At this moment, Olark does not let us download chat transcriptsall at once. This scraper will download all the chats ever made, so that we could do analysis on the raw chat data. Running the script will create a CSV, where a row represents a chat message.

## Installation

1. clone this repo.

2. Make sure you have bundler installed

```
$ gem install bundler
```

3. Install the necessary ruby gems.

```
$ bundle install
```

4. Define `OLARK_USERNAME` and `OLARK_PASSWORD` in your `.bash_profile`

```
export OLARK_USERNAME=some_username
export OLARK_PASSWORD=some_password
```

5. Source your changes:

```
$ source ~/.bash_profile
```

6. Run the script:

```
ruby olark_chat_scraper.rb
```
