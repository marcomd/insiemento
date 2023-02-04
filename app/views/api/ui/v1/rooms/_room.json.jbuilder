json.ignore_nil!

json.extract!(room, :id, :name, :description, :max_attendees)
