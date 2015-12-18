require 'csv'
require 'capybara'
require 'capybara/poltergeist'

class OlarkChatScraper
  include Capybara::DSL

  def initialize
    Capybara.default_driver = :selenium
  end

  def chat_ids
    visit "https://olark.com"

    click_on 'Login'
    fill_in "username", with: ENV['OLARK_USERNAME']
    fill_in "password", with: ENV['OLARK_PASSWORD']
    click_on "Log in"

    click_on "View all Chat Transcripts"

    all_chat_ids = []

    loop do
      ids = page.all('.transcript-list a[href*="/transcripts/show/"]').map do |t|
        id = t[:href].scan(/(?<=\/transcripts\/show\/)\w+/)
      end

      all_chat_ids << ids

      click_on 'Next Page'
      break unless page.has_content?("Next Page")
    end

    all_chat_ids.flatten!
  end

  def download_all
    f = CSV.open('olark_chat_messages', 'w')
    f << message_features

    chat_ids.each do |id|
      visit "https://olark.com/transcripts/show/#{id}"
      page.find('#show-convo-details').click

      features_dictionary = conversation_features.inject({}) do |dict, val|
        dict[val] = get_definition(val)
        dict
      end

      page.all('tr[class*="_msg"]').each_with_index do |msg, index|
        author = msg.find('.author').text()
        message = msg.find('.message').text()
        features_dictionary['author'] = author
        features_dictionary['message'] = message
        features_dictionary['position'] = index

        f << rowify(features_dictionary)
      end
    end

    f.close()
  end

  private

  def rowify(feat_dict)
    message_features.inject([]) do |row, feature|
      row << feat_dict[feature]
    end
  end

  def message_features
    conversation_features | ['author', 'message', 'position']
  end

  def conversation_features
    ["Visitor State",
     "Is dialog?",
     "Operator Usernames",
     "Visitor Email",
     "Visitor Operating System",
     "Visitor Browser",
     "Is Offline Message?",
     "Visitor Country Code",
     "Visitor ISP",
     "Visitor IP Address",
     "Referring URL",
     "Start Time",
     "Group Title",
     "Word Count",
     "Visitor Country",
     "Created At",
     "Conversation ID",
     "Visitor ID",
     "Visitor Browser Version",
     "Visitor Organization",
     "Tags",
     "Operator Display Names",
     "Visitor City",
     "Visitor Name",
     "Transcript ID",
     "Operator IDs",
     "Chat started on",
     "Integration Urls",
     "Visitor Longitude",
     "Is Offline Message",
     "Visitor Location",
     "End Time",
     "Visitor Latitude",
     "Visitor Phone"]
  end

  def get_definition(def_tag)
    page.evaluate_script("$('dt:contains(\"#{def_tag}\") + dd').text()")
  end
end

OlarkChatScraper.new.download_all
