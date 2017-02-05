require 'open-uri'
require 'nokogiri'
require 'csv'

url = 'http://www.petsonic.com/es/perros/snacks-y-huesos-perro/galletas-granja-para-perro'
# url = 'http://www.petsonic.com/es/perros/snacks-y-huesos-perro/estrellita-tiernas-de-salmon-para-perro'
# url = 'http://www.petsonic.com/es/perros/juguetes-y-ocio-perro/pelotas-y-lanzaderas/kong-air-ii'

html = open(url)
doc = Nokogiri::HTML(html)

wieght = ''
price_old = ''
price_kg = ''

doc.css(".attribute_labels_lists").each do |element|
  element.css("input[type = 'radio']").each do |item|
      if item["checked"] == 'checked'
        wieght =  element.css(".attribute_name").text.strip
        price_old =  element.css(".attribute_old_price").text.strip
        price_kg =  element.css(".attribute_price").text.strip
      end
  end
end

productName = doc.css('#bigpic')[0]['title'] + " - " + wieght
imageUrl =  doc.css('#bigpic')[0]['src']

# implements with XPath

=begin
doc.xpath(".//*[@class='attribute_labels_lists']").each do |element|
  element.xpath(".//*[@type='radio']").each do |item|
    if item["checked"] == 'checked'
      wieght =  element.xpath(".//*[@class='attribute_name']").text.strip
      price_old =  element.xpath(".//*[@class='attribute_old_price']").text.strip
      price_kg =  element.xpath(".//*[@class='attribute_price']").text.strip
    end
  end
end

productName = doc.xpath(".//*[@id='bigpic']/@title").to_s + " - " + wieght
imageUrl =  doc.xpath(".//*[@id='bigpic']/@src")
=end

CSV.open("data.csv", "w") do |wr|
  wr << [productName, price_kg, imageUrl]
end