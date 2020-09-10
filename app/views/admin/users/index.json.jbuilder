# Used by search_select input
json.array!(@users) do |user|
  json.extract! user, :id, :full_name
end
