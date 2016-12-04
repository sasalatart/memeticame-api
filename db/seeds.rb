# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = User.create!(name: 'Memeticame',
                     phone_number: '55555555',
                     password: 'napoleon',
                     password_confirmation: 'napoleon')

User.create!(name: 'sasalatart',
             phone_number: '987654321',
             password: 'napoleon',
             password_confirmation: 'napoleon')

User.create!(name: 'Giovanni',
             phone_number: '933333333',
             password: 'napoleon',
             password_confirmation: 'napoleon')

User.create!(name: 'saoliva',
             phone_number: '922222222',
             password: 'napoleon',
             password_confirmation: 'napoleon')

def create_image(path)
  image_file = File.new(path)
  ActionDispatch::Http::UploadedFile.new(
    filename: File.basename(image_file),
    tempfile: image_file,
    type: MIME::Types.type_for(path).first.content_type
  )
end

def create_text_memes(dir, category, owner)
  dir.each do |meme_with_text|
    meme = Meme.create!(
      category: category,
      owner: owner, image: create_image(meme_with_text),
      name: File.basename(meme_with_text, File.extname(meme_with_text)),
    )

    meme.ratings << Rating.create!(meme: meme, user: owner, value: 5 * rand())
  end
end

plain_memes = Dir["#{Rails.root}/db/seed_files/memes_blank/*"]
plain_memes.each { |plain_meme| PlainMeme.create!(image: create_image(plain_meme)) }

public_channel = Channel.new(name: 'Public Channel', owner: admin)
public_others_category = Category.new(name: 'Others')
public_channel.categories << public_others_category
public_channel.save!

cai_channel = Channel.new(name: 'CAi', owner: admin)
cai_gala_category = Category.new(name: 'Gala')
cai_channel.categories << cai_gala_category
cai_channel.save!

quickdeli_channel = Channel.new(name: 'PUC Memes From Quickdeli', owner: admin)
quickdeli_banner_category = Category.new(name: 'Banner')
quickdeli_feuc_category = Category.new(name: 'FEUC')
quickdeli_generic_category = Category.new(name: 'Generic')
quickdeli_channel.categories << [quickdeli_banner_category, quickdeli_feuc_category, quickdeli_generic_category]
quickdeli_channel.save!

cai_gala_dir = Dir["#{Rails.root}/db/seed_files/memes_with_text/cai/gala/*"]
create_text_memes(cai_gala_dir, cai_gala_category, admin)

public_others_dir = Dir["#{Rails.root}/db/seed_files/memes_with_text/public/others/*"]
create_text_memes(public_others_dir, public_others_category, admin)

quickdeli_banner_dir = Dir["#{Rails.root}/db/seed_files/memes_with_text/quickdeli/banner/*"]
create_text_memes(quickdeli_banner_dir, quickdeli_banner_category, admin)

quickdeli_feuc_dir = Dir["#{Rails.root}/db/seed_files/memes_with_text/quickdeli/feuc/*"]
create_text_memes(quickdeli_feuc_dir, quickdeli_feuc_category, admin)

quickdeli_generic_dir = Dir["#{Rails.root}/db/seed_files/memes_with_text/quickdeli/generic/*"]
create_text_memes(quickdeli_generic_dir, quickdeli_generic_category, admin)
