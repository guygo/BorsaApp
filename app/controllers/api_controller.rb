class ApiController < ApplicationController
  def index


  end

  def ShareByName
    @id= ShareService.getShareByname(params['name'])

  end
end
