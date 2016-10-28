module Api
  module V1
    class SharesController<ApplicationController
        respond_to :json
        def index
          respond_with Share.all
        end
        def show
          respond_with Share.find_by(params[:name])
        end
    end
  end
end