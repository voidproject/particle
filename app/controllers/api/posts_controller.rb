class Api::PostsController < ApplicationController

  def show
    p params[:id]
    @user = User.find_by(pubkey: params[:token])
    @post = Message.find_by(key: params[:id])
    render template: '/api/post'
  end

  def index
    @user = User.find_by(pubkey: params[:token])
    @posts = Message.where(root: nil, blocked: false).order('id desc')
    if params[:pubkey]
      @posts = @posts.where(author: params[:pubkey])
    end
    if params[:since]
      @posts = @posts.where("id > ?", params[:since])
    end
    render template: '/api/posts'
  end

  def likes
    @user = User.find_by(pubkey: params[:pubkey])
    @likes = Vote.where(source: params[:pubkey]).pluck(:target)
    @posts = Message.where(key: likes, msgtype: 'post').order('id desc')
    render template: '/api/posts'
  end

  def channel
    @user = User.find_by(pubkey: params[:token])
    @posts = Message.where(channel: params[:channel]).order('id desc').page(params[:page])
    render template: '/api/posts'
  end

  def channels
    render json: { channels: Message.pluck(:channel).uniq.select {|x| x.present? } }
  end

end
