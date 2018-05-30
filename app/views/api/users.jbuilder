json.users @users do |user|
  json.partial! '/api/user', user: user
end
