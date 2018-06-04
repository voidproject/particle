class Api::PostsController < ApplicationController

  def get_message
    @user = User.find_by(pubkey: params[:token])
    @post = Message.find_by(key: params[:key])
    render template: '/api/post'
  end

  def get_messages_by_root
    @user = User.find_by(pubkey: params[:token])
    @posts = Message.where(root: params[:key], blocked: false, msgtype: 'post').includes(:user).order('id desc')
    render template: '/api/posts'
  end

  def get_home_feed
    @posts = Message.where(root: nil, blocked: false, msgtype: 'post').includes(:user).order('id desc').limit(20)
    if params[:pubkey]
      @posts = @posts.where(author: params[:pubkey])
    end
    if params[:since]
      @posts = @posts.where("id < ?", params[:since])
    end

    render template: '/api/posts'
  end

  def likes
    @user = User.find_by(pubkey: params[:pubkey])
    @likes = Vote.where(source: params[:pubkey]).pluck(:target)
    @posts = Message.where(key: likes, blocked: false, msgtype: 'post').includes(:user).order('id desc').limit(20)
    render template: '/api/posts'
  end

  def get_channel_messages
    @user = User.find_by(pubkey: params[:token])
    @posts = Message.where(channel: params[:channel], blocked: false, msgtype: 'post').includes(:user).order('id desc').limit(20)
    if params[:since]
      @posts = @posts.where("id < ?", params[:since])
    end
    render template: '/api/posts'
  end

  def get_channels
    render json: { channels: Message.pluck(:channel).uniq.select {|x| x.present? } }
  end

  def add
    message = JSON.parse(params[:message], :symbolize_names => true)
    message = add_message(message)
    @post = message
    render template: '/api/post'
  end

end
