require_relative '../app'
require 'rspec'
require 'rack/test'

describe 'Application' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'show start page' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'saves message to db' do
    expect {
      post('/link', {message: 'hello'})
    }.to change(Message, :count).by(1)
  end

  it 'shows message' do
    message = Message.build_message({message: 'hello'})
    get("/message/#{message.safe_link}")
    expect(last_response.body).to include('hello')
  end

  it 'shows message only once with destruction option 1 visit' do
    message = Message.build_message({message: 'hello'})
    get("/message/#{message.safe_link}")
    expect(last_response.body).to include('hello')

    get("/message/#{message.safe_link}")
    expect(last_response.body).to include('Sorry but we can\'t find your message')
  end

  it 'shows message not only once with destruction option 10 visit' do
    message = Message.build_message({message: 'hello', destroy_option: '10_visit'})
    get("/message/#{message.safe_link}")
    expect(last_response.body).to include('hello')

    get("/message/#{message.safe_link}")
    expect(last_response.body).to include('hello')
  end

  it 'shows message not only once with destruction option 1 hour' do
    message = Message.build_message({message: 'hello', destroy_option: '1_hour'})
    get("/message/#{message.safe_link}")
    expect(last_response.body).to include('hello')

    get("/message/#{message.safe_link}")
    expect(last_response.body).to include('hello')
  end

  it 'shows message only 1 hour with destruction option 1 hour' do
    message = Message.build_message({message: 'hello', destroy_option: '1_hour'})
    get("/message/#{message.safe_link}")
    expect(last_response.body).to include('hello')

    message.max_date = DateTime.now - 2.hours
    message.save
    get("/message/#{message.safe_link}")
    expect(last_response.body).to include('Sorry but we can\'t find your message')
  end
end