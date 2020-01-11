# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if AdminUser.count == 0
  AdminUser.create!(email: 'admin@insiemento.com', password: 'abcd1234!', password_confirmation: 'abcd1234!') if Rails.env.development?
end

if Course.count == 0
  c_zumba=Course.create!(name: 'Zumba',
                         description: "L'allenamento più divertente in assoluto. Balla al ritmo di musiche energetiche insieme a gente fantastica e brucia una tonnellata di calorie divertendoti.",
                         start_booking_hours: 48,
                         end_booking_minutes: 90,
  )
else
  c_zumba, c_other = Course.all
end

if Trainer.count == 0
  t_miguel=Trainer.create!(firstname: 'Miguel', lastname: 'Dos Santos', nickname: 'El Nino', bio: "Un caliente ballerino brasiliano, tra i tre più grandi ballerini italiani di zumba di tutti i tempi.")
  t_jenny=Trainer.create!(firstname: 'Jennifer', lastname: 'Santorini', nickname: 'Saint', bio: "Percorso accademico completato negli states, eletta Miss chiappe d'oro 2019, con lei è vivamente consigliata una bombola di ossigeno!")
else
  t_miguel, t_jenny = Trainer.all
end

if User.count == 0
  u_stefania=User.create!(firstname: 'Stefania', lastname: 'Rossini', email: 'stefania@insiemento.io', birtdate: '1990-05-25', gender: 'F')
  u_marco=User.create!(firstname: 'Marco', lastname: 'Tonelli', email: 'marco@insiemento.io', birtdate: '1995-06-15', gender: 'M')
else
  u_stefania, u_marco = User.all
end

if Room.count == 0
  r_small=Room.create!(name: 'Piccola', max_attendees: 10)
  r_middle=Room.create!(name: 'Media', max_attendees: 20)
  r_large=Room.create!(name: 'Media', max_attendees: 30)
else
  r_small, r_middle, r_large = Room.all
end

if .count == 0
  cs_zumba_monday_morning=CourseSchedule.create!(course_id: c_zumba.id, room_id: r_small.id, trainer_id: t_miguel.id, event_day: 1, event_time: '7:00')
  cs_zumba_monday_afternoon=CourseSchedule.create!(course_id: c_zumba.id, room_id: r_middle.id, trainer_id: t_jenny.id, event_day: 1, event_time: '14:30')
end

if CourseEvent.count == 0
  CourseSchedule.all do |cs|
    CourseEvent.create!(course_id: cs.course.id,
                        room_id: cs.room_id,
                        trainer_id: cs.trainer_id,
                        course_schedule_id: cs.id,
                        event_date: cs.next_event_datetime)
  end


end

if Attendee.count == 0
  CourseEvent.all do |ce|
    Attendee.create!(course_event_id: ce.id, user_id: u_stefania.id)
  end
end