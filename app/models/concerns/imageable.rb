module Imageable
  extend ActiveSupport::Concern

  included do
    has_attached_file :image,
                      styles: { original: '640x480>', thumb: '150x150>' },
                      convert_options: { display: '-quality 90 -strip' },
                      dependent: :destroy

    validates_attachment_presence :image
    validates_attachment_content_type :image, content_type: /\Aimage/
  end

  def build_base64_image(image_params)
    base64 = "data:#{image_params[:mime_type]};base64,#{image_params[:base64]}"
    image = Paperclip.io_adapters.for(base64)
    image.content_type = image_params[:mime_type]
    image.original_filename = "#{image_params[:name]}.#{image_params[:mime_type].split('/').last}"
    self.image = image
  end
end
