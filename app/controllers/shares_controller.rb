



class SharesController < ApplicationController

  def index
    @list=Share.all

  end

  def create

    beginingDate=params['Share']['StartingDate']
    endingDate=params['Share']['EndingDate']

    sh=Share.find( params['Share']['Share_id'])
    @data=ShareService.GetShareData(sh.ShareSerial,sh.CompanySerial,beginingDate,endingDate).to_json
    @name=sh.name.to_json
    #respond html page and script for ajax call
     respond_to {|format|
      format.html{redirect_to share_url}
      format.js
     }
  end



end
