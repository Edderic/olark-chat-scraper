require 'capybara'
require 'capybara/poltergeist'

class OlarkChatScraper
  include Capybara::DSL

  def initialize
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end

    Capybara.javascript_driver = :chrome
    # Capybara.default_driver = :poltergeist
    # Capybara.default_driver = :selenium
  end

  def download_all
    visit "https://olark.com"

    click_on 'Login'
    fill_in "username", with: ENV['OLARK_USERNAME']
    fill_in "password", with: ENV['OLARK_PASSWORD']
    click_on "Log in"

    click_on "View all Chat Transcripts"

    page.all('.transcript-list .transcript').each do |t|
      t.click
      page.find('#show-convo-details').click
      visitor_email_dt = page.find("#convo-details dt", text: "Visitor Email")
      puts visitor_email_dt.find('+dd').text()
      # sleep 1
      # visitor_email = page.execute_script("$('dt:contains("Visitor Email") + dd').text()")
      # sleep 1
      # useful features
      #
      # chat_started_on
      # transcript_id
      # visitor_location
      # visitor_name
      # is_offline_message
      # visitor_browser
      # visitor_chat_message
      #
      # time_zone_difference, relative to us?
      sleep 1
    end
  end
end

OlarkChatScraper.new.download_all
