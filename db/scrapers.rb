require 'open-uri'
require 'nokogiri'
require 'watir'

class Scrape
    def scrape_url
        url = "https://www.trip.com/hotels/list?city=30&countryId=1&checkin=2022/01/02&checkout=2022/01/03&optionId=30&optionType=City&directSearch=0&display=Shenzhen&crn=1&adult=1&children=0&searchBoxArg=t&travelPurpose=0&ctm_ref=ix_sb_dl&domestic=1"

        doc = Watir::Browser.new 

        doc.goto(url)

        js_doc = doc.element(css: "#meta-real-price").wait_until(&:present?)
        full_doc = Nokogiri::HTML(js_doc.inner_html)
        price = full_doc.css('#meta-real-price')
        return price
    end
end
