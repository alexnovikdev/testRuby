require 'open-uri'
require 'nokogiri'
require 'csv'
require 'rubygems'
require 'mechanize'

print "Введите имя файла для записи: "
filename = gets.strip.to_s + ".csv"


# категория файла ввиде url
 url = 'http://www.petsonic.com/es/perros/snacks-y-huesos-perro'
# url = 'http://www.petsonic.com/es/perros/comida-humeda'

agent = Mechanize.new
page = agent.get(url)
form = page.form_with(:class => 'showall pull-left')
page = agent.submit(form)

=begin
puts html = open(url)
=end
doc = Nokogiri::HTML(page.body)



weight = ''
price_old = ''
price_kg = ''
productName = ''
imageUrl = ''


doc.css(".product_img_link").each do |product|

  htmlInside = open(product["href"])
  docInside = Nokogiri::HTML(htmlInside)

  docInside.css(".attribute_labels_lists").each do |element|
    element.css("input[type = 'radio']").each do |item|
      if item["checked"] == 'checked'
        weight =  element.css(".attribute_name").text.strip
        price_old =  element.css(".attribute_old_price").text.strip
        price_kg =  element.css(".attribute_price").text.strip
      end
    end
  end

  productName = docInside.css('#bigpic')[0]['title'] + " - " + weight
  imageUrl =  docInside.css('#bigpic')[0]['src']

  CSV.open(filename, "a") do |wr|
    wr << [productName, price_kg, imageUrl]
  end
end

# implemented with XPath

=begin
doc.xpath(".//*[@class='product_img_link']").each do |product|

  htmlInside = open(product["href"])
  docInside = Nokogiri::HTML(htmlInside)

  docInside.xpath(".//*[@class='attribute_labels_lists']").each do |element|
    element.xpath(".//*[@type='radio']").each do |item|
      if item["checked"] == 'checked'
        weight =  element.xpath(".//*[@class='attribute_name']").text.strip
        price_old =  element.xpath(".//*[@class='attribute_old_price']").text.strip
        price_kg =  element.xpath(".//*[@class='attribute_price']").text.strip
      end
    end
  end

  productName = docInside.xpath(".//*[@id='bigpic']/@title").to_s + " - " + weight
  imageUrl =  docInside.xpath(".//*[@id='bigpic']/@src")

  CSV.open(filename, "a") do |wr|
    wr << [productName, price_kg, imageUrl]
  end

end
=end