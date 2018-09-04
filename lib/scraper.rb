require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    index_page = Nokogiri::HTML(html)

    index_page.css(".student-card").collect do |student_card|
      hash = {
        :name => student_card.css("h4.student-name").text,
        :location => student_card.css("p.student-location").text,
        :profile_url => student_card.css("a").attr("href").value
      }

    end
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile = Nokogiri::HTML(html)

    profile_hash = {
      :profile_quote => profile.css('div.profile-quote').text,
      :bio => profile.css('div.description-holder p').text,
    }

    profile.css('.social-icon-container a').each do |social|

      if(social.attr('href').include?('twitter') == true)
        profile_hash[:twitter] = social.attr('href')
      end

      if (social.attr('href').include?('github') == true)
        profile_hash[:github] = social.attr('href')
      end

      if (social.attr('href').include?('linkedin') == true)
        profile_hash[:linkedin] = social.attr('href')
      end

      if (social.children.attr('src').value == "../assets/img/rss-icon.png")
        profile_hash[:blog] = social.attr('href')
      end


    end

    profile_hash
    
  end

end
