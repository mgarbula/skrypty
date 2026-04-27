#!/usr/bin/env ruby

require 'nokogiri'
require 'httparty'
require 'uri'

class EmpikCrawler
  include HTTParty
  base_uri 'https://empik.pl'

  def crawl(search_term)
    puts "Searching for: #{search_term}"

    encoded_term = URI.encode_www_form_component(search_term)
    url = "/szukaj/produkt?q=#{encoded_term}"

    puts "Fetching search results..."
    response = self.class.get(url, headers: @headers, follow_redirects: true)

    puts "Response code: #{response.code}"

    if response.code == 200
      doc = Nokogiri::HTML(response.body)
      products = doc.css('div[class="search-list-item  js-reco-product js-energyclass-product ta-product-tile"]')

      if products.empty?
        puts "Products not found"
      else
        puts "Found #{products.length} products"
        products.each do |product|
          title = product.css('h2').text.strip
          price = product.css('.price').text.strip
          product_url = product.at_css('a.seoTitle')['href']
          full_product_url = URI.join('https://empik.pl', product_url).to_s
          puts "Title: #{title}"
          puts "Price: #{price}"
          puts "URL: #{full_product_url}"
          puts "---"
        end
      end
    else
      puts "Failed to fetch page: HTTP #{response.code}"
    end
  end
end

if ARGV.length > 0
  crawler = EmpikCrawler.new
  crawler.crawl(ARGV[0])
else
  puts "Usage: ruby crawler.rb <search_term>"
end
