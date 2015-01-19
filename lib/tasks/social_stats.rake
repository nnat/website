require 'rss'
require 'net/http'

desc "Invite all non invited Leads to register on CB"

task social_stats: :environment do
  
  stats = SocialStats.new

  stats.add_blog_posts!

  stats.fetch_facebook_stats!
  
  stats.output_in_console

end


class SocialStats

  attr_accessor :stats

  def initialize
    self.stats = [ new_stats_entry('Site', 'Homepage', 'http://www.risebox.co'),
              new_stats_entry('Site', 'Comment ca marche', 'http://www.risebox.co/fr/comment-ca-marche')
            ]
  end

  def add_blog_posts!
    rss_page = Net::HTTP.get(URI.parse('http://blog.risebox.co/rss/'))
    feed   = RSS::Parser.parse(rss_page)
    feed.items.each do |item|
      self.stats = self.stats + [new_stats_entry('Blog', item.title, item.link)]
    end
  end

  def fetch_facebook_stats!
    self.stats.each do |entry|
      url = "http://graph.facebook.com/fql?q=SELECT%20url,%20normalized_url,%20share_count,%20like_count,%20comment_count,%20total_count,%20commentsbox_count,%20comments_fbid,%20click_count%20FROM%20link_stat%20WHERE%20url=%27#{entry[:url]}%27" 
      result = JSON.parse(Net::HTTP.get(URI.parse(url)))['data'][0]
      entry[:facebook][:total]    = result['total_count']
      entry[:facebook][:shares]   = result['share_count']
      entry[:facebook][:likes]    = result['like_count']
      entry[:facebook][:comments] = result['comment_count']
    end
  end

  def fetch_twitter_stats!
    #TODO
  end

  def output_in_console
    self.stats.each do |entry|
      puts shell_format(entry)
    end
  end

private

  def new_stats_entry site, title, url
    return {site: site, title: title, url: url, facebook: {total: 0, shares: 0, likes: 0, comments: 0}, twitter: {tweets: 0}}
  end

  def shell_format entry
    fb = entry[:facebook]
    "#{entry[:site]} - #{entry[:title]} - Fb: #{fb[:total]} (lik: #{fb[:likes]}, sha: #{fb[:shares]}, com: #{fb[:comments]})"
  end

end


