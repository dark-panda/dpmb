
class HomeController < ApplicationController
  include ApplicationHelper

  def index
    if params[:files].present?
      if params[:files].length > 1
        zip = $LIBRARY.zip(params[:files])
        path = params[:path].split('/').last
        send_data(zip.read, filename: "#{path}.zip", type: Mime[:zip])
      elsif params[:files].length == 1
        send_single_file(params[:files].first)
      end
    elsif $LIBRARY.public_file?(params[:path])
      send_single_file(params[:path])
    end
  end

  private

    def send_single_file(path)
      return unless $LIBRARY.public_file?(path)

      file = $LIBRARY.file(path)
      send_file($LIBRARY.local_path(path), type: file.file_type)
    end
end
