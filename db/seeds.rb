# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def create_plain_meme(path)
  image_file = File.new(path)
  ActionDispatch::Http::UploadedFile.new(
    filename: File.basename(image_file),
    tempfile: image_file,
    type: MIME::Types.type_for(path).first.content_type
  )
end

plain_memes = Dir["#{Rails.root}/db/seed_files/*"]
plain_memes.each { |plain_meme| PlainMeme.create!(image: create_plain_meme(plain_meme)) }
