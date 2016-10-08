require 'sinatra'
require 'sinatra/activerecord'
require_relative '../environments'

class Message < ActiveRecord::Base

  def self.build_message(params)
    link = SecureRandom.urlsafe_base64
    hash = {:safe_link => link, :text => AesEncryptDecrypt.encryption(params[:message])}
    add_destroy_option(hash, params)
    Message.create(hash)
  end

  def self.find_message_text(link)
    delete_expired
    message = find_by(safe_link: link)
    if message
      if message.max_count > 0
        message.max_count -= 1
        message.save
      end

      return message.text
    end

    nil
  end

  def self.delete_expired
    where(max_count: 0).delete_all
    where('max_date < ?', DateTime.now).delete_all
  end

  before_create :set_default_values

  def set_default_values
    self.max_count = -1 if self.max_count == nil
    self.max_date = DateTime.new(9999, 12, 31) if self.max_date == nil
  end

  private

  def self.add_destroy_option(hash, params)
    case params[:destroy_option]
      when '1_hour'
        hash[:max_date] = DateTime.now + 1.hour
      when '1_day'
        hash[:max_date] = DateTime.now + 1.day
      when '10_visit'
        hash[:max_count] = 10
      else
        hash[:max_count] = 1
    end
  end
end