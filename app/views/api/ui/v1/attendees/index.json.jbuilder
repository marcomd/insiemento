json.array!(@attendees) do |attendee|
  json.partial!('api/ui/v1/attendees/attendee', attendee:)
end
