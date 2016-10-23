require 'watir'
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'thread'
require 'thwait'
require 'csv'

class Seeder



    def self.CreareDataForDB
      if(Share.count==0)
        SeedShares()
        SeedShareData()

        return
      end
     puts "db is already created"


    end

    #fill database with essential data (shares,prices and more)
    #run with rake db:seed
    def SeedShares
      #patah of file in server
      filename = Dir[File.join(Rails.root, 'app', 'csv',"stocks.csv")][0]
       CSV.foreach(filename).drop(1){|row|
       Share.create(name:row[0],ShareSerial:row[1],CompanySerial:row[2])

       }
    end

    #run browser object to scan borsa page and generate data in db
    def WebReader(browser,share)

      if(!share.CompanySerial.nil?&&!share.ShareSerial.nil?)

        browser.goto "http://www.tase.co.il/Eng/General/Company/Pages/companyHistoryData.aspx?companyID="+share.CompanySerial+"&subDataType=0&shareID="+share.ShareSerial rescue notok=true
        sleep 10
        browser.input(value:'rbPeriod3').click
        sleep 1
        browser.input(value:"Display Data").click
        sleep 2
        doc=Nokogiri::HTML.parse(browser.html)

        tbody=nil
        doc.css('.gridHeader').each{|val|
          x=val.at_css('.titleGridRegNoB')
          if x.text=="Date"
            tbody=val.parent
          end
        }

        titles=[:Date, :AdjustedClosingPrice, :ClosingPrice, :Change, :OpeningPrice, :BasePrice, :High, :Low, :CapitalListedforTrading, :MarketCap, :Turnover, :Volume, :Trans, :ExType, :ExCoefficient, :IndexAdjustedNoofShares, :IndexAdjustedFreeFloatRate, :LastIANSUpdate]
        index =0
        data=[]
        hash=Hash.new
        tbody.css('tr').drop(1).each{|val|
          val.css('td').each{|item|

            if index%titles.count==0
              index=0
              if !hash.empty?
                data.push(hash)
              end
              hash=Hash.new
            end
            if item!="\u00A0"
              if !item.text.include?("%")&&!item.text.include?("/")
                if item.text.include?(",")
                  string = item.text.gsub(/[\s,]/ ,"")
                  hash[titles[index]]=string.to_f
                else
                  hash[titles[index]]=item.text.to_f

                end
              else
                hash[titles[index]]=item.text
              end
            else
              hash[titles[index]]=""

            end
            index+=1
          }
        }
        share.share_values.update(data)

        browser.close
      end

    end
    def SeedShareData
      Watir.driver = 'webdriver'
      Watir.load_driver
      Selenium::WebDriver::PhantomJS.path = Dir[File.join(Rails.root, 'lib', 'assets',"phantomjs.exe")][0]

      Thread.abort_on_exception=true
        threads = []
        # Set the path to phantomjs.exe
        notok=true
        threadid=0
        allShare=Share.all
        # Now you can use :phantomjs as the browser type
        allShare.each{|share|

          threadid+=1
          switches = ['--proxy=localhost:9000'+threadid.to_s]
          browser = Watir::Browser.new  :phantomjs, :args=> switches
          threads<< Thread.new(browser,share){|browser,share|

            WebReader(browser,share)
         }

          threadid+=1
          #make sure the that the web isn't overloading
          if(threadid%8==0)
            ThreadsWait.all_waits(*threads)
            threads=[]
          end
        }
    end

  private :WebReader,:SeedShares,:SeedShareData

end
Seeder.CreareDataForDB


