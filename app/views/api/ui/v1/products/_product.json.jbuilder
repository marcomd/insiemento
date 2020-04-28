json.ignore_nil!

json.extract! product, :id, :name, :description, :days
json.category_name product.category.name
json.price product.price.to_f

# json.set!('users') do
#   json.array! course_event.users do |user|
#     json.partial! 'api/ui/v1/users/user', user: user
#   end if course_event.users.present?
# end
