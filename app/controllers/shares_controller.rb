


#manage Rest api for share db
class SharesController < ApplicationController

  def index
    @list=Share.all

  end

  def create

     sh=Share.find( params['Share']['Share_id'])
     @data=ShareService.GetShareData(sh.ShareSerial,sh.CompanySerial).to_json
     @name=sh.name.to_json
     #respond html page and script for ajax call
     respond_to {|format|
      format.html{redirect_to share_url}
      format.js
     }
  end

  def show

  end

end
