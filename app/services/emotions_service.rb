require 'dropbox_sdk'

module EmotionsService
  module_function

  def to_dropbox(base64, mime_type)
    extension = mime_type.split('/').last
    file_name = "#{(0...25).map { ('a'..'z').to_a[rand(26)] }.join}.#{extension}"

    f_path = File.join('public/system/temp/', file_name)
    FileUtils.mkdir_p(File.dirname(f_path))

    File.open(f_path, 'wb') do |f|
      f.write(Base64.decode64(base64))
      f.fsync
    end

    client = DropboxClient.new(Rails.application.secrets.dropbox_access_token)
    client.put_file("/Public/#{file_name}", open(f_path))

    file_name
  end

  def query_emotions(file_name)
    uri = URI('https://api.projectoxford.ai/emotion/v1.0/recognize')
    uri.query = URI.encode_www_form({})

    user_id = Rails.application.secrets.dropbox_user_id
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    request['Ocp-Apim-Subscription-Key'] = Rails.application.secrets.emotions_preview_key
    request.body = { url: "https://dl.dropboxusercontent.com/u/#{user_id}/#{file_name}" }.to_json

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    response
  end
end
