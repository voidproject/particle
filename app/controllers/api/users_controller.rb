class Api::UsersController < ApplicationController

  def add_user
    @user = User.find_or_create_by(key: params[:key])
    render template: '/api/user'
  end

  def get_users
    @users = User.all
    render template: '/api/users'
  end

  def get_user
    @user = User.find_by(key: params[:key])
    if @user
      render template: '/api/user'
    else
      render json: {user: nil}
    end
  end

  def get_user_messages
    @user = User.find_by(pubkey: params[:token])
    @posts = Message.where(author: params[:key], msgtype: 'post', blocked: false).order('id desc')
    render template: '/api/posts'
  end

  def has_follow
    contact = Contact.find_by(source: params[:source], target: params[:target])
    render json: {following: !!contact}
  end

end
