json.auth_token @auth_token
json.set!('user') do
  json.partial! 'api/ui/v1/users/user', user: @user
end
