require 'sinatra'
require_relative 'models/message'
require_relative 'helpers/aes_encrypt_decrypt'

get '/' do
  erb :index
end

post '/link' do
  @message = Message.build_message(params)

  erb :link
end

get '/message/:str' do
  @result = Message.find_message_text(params[:str])
  @result = AesEncryptDecrypt.decryption(@result) if @result

  erb :message
end