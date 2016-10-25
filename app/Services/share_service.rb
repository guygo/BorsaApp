
require 'csv'
require 'open-uri'
require 'uri'
require 'watir'


class ShareService

#get Share object by given name
  def  self.getShareByname(name)

    share=Share.find_by(:name =>name)
    if(!share.nil? )

     return share.as_json(only:[:name, :ShareSerial, :CompanySerial] )
    else
     return "no shares"
    end
  end


#get data of share by share id and company id
  def self.GetShareData(shareid,companyid,startDate,endDate)

    OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
    OpenURI::Buffer.const_set 'StringMax', 0
    csvdata=[]
    url= "http://www.tase.co.il/_layouts/Tase/ManagementPages/Export.aspx?sn=none&GridId=128&AddCol=1&Lang=he-IL&ct=1&oid=#{shareid}&ot=1&cp=8&cf=0&cv=0&cl=0&cgt=1&dfrom=#{startDate}&dto=#{endDate}&CmpID=#{companyid}&subT=0&ExportType=3"
    puts url
    encoded_url = URI.encode(url)
    uri=URI.parse(encoded_url)
    x=0
    file=open(uri)

    quote_chars = %w(" | ~ ^ & *)
    CSV.foreach(file,encoding: "iso-8859-1:UTF-8",:quote_char => "|") do |row|
      x+=1
      if(row.to_s.include?(','))

        csvdata.push(row)

#javascript:customWindowOpen('/_layouts/Tase/ManagementPages/Export.aspx?tbl=0&Columns=AddColColumnsHistory&Titles=AddColTitlesHistory&sn=dsHistory&enumTblType=GridHistorydaily&ExportType=3', '_blank', 'scrollbars=yes; toolbar=yes; menubar=yes; resizable=yes', 800, 450);return false;
      end

    end

    rownum=0
    shares=[]
    keys = ["Date","Price","change","Turnover"]
    csvdata.each{|values|
      i=0
      if(rownum==0)
        rownum+=1
      else

        sharehash=Hash.new
        values.each{ |value|
          sharehash[keys[i]] = value
          i+=1
        }
        shares.push(sharehash)
      end



    }

    return shares
  end
end

