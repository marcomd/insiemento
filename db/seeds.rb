# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
default_password = Rails.application.credentials.seed.dig(:default_password)
if AdminUser.count == 0
  AdminUser.create!(email: 'admin@insiemento.io',
                    password: default_password,
                    password_confirmation: default_password)
end

generic_user_names = %w(user1 user2 user3 user4 user5 user6 user7)

if Course.count == 0
  c_zumba=Course.create!(name: 'Zumba',
                         description: 'L''allenamento più divertente in assoluto. Balla al ritmo di musiche energetiche insieme a gente fantastica e brucia una tonnellata di calorie divertendoti.',
                         start_booking_hours: 48,
                         end_booking_minutes: 90,
                         state: :active,
  )
  c_yoga=Course.create!(name: 'Yoga',
                         description: 'Lo Yoga porta equilibrio e calma, oltre che benessere fisico e mentale.',
                         start_booking_hours: 96,
                         end_booking_minutes: 360,
                         state: :active,
                         )
  c_pilates=Course.create!(name: 'Pilates',
                        description: 'Il pilates è una ginnastica funzionale, posturale e globale basata sul riequilibrio di corpo e mente, che agisce sulla consapevolezza del proprio corpo, sulla forza e sulla flessibilità insegnando a dare maggiore armonia e fluidità nei movimenti.',
                        start_booking_hours: 24,
                        end_booking_minutes: 60,
                        state: :active,
                        )
  puts "Courses: #{Course.count}"
else
  c_zumba, c_yoga = Course.all
end

if Trainer.count == 0
  t_miguel=Trainer.create!(firstname: 'Miguel', lastname: 'Dos Santos', nickname: 'El Nino', state: :active,
                           bio: "Un caliente ballerino brasiliano, tra i tre più grandi ballerini italiani di zumba di tutti i tempi.")
  t_jenny=Trainer.create!(firstname: 'Jennifer', lastname: 'Santorini', nickname: 'Saint', state: :active,
                          bio: "Percorso accademico completato negli states, eletta Miss chiappe d'oro 2019, con lei è vivamente consigliata una bombola di ossigeno!")
  t_sandy=Trainer.create!(firstname: 'Sandy', lastname: 'Marton', nickname: 'Sese', state: :active,
                         bio: "È un artista in grado di interpretare la musica e tradurla attraverso il linguaggio del corpo.")
  puts "Trainers: #{Trainer.count}"
else
  t_miguel, t_jenny, t_sandy = Trainer.all
end

if User.count == 0
  u_stefania=User.new(firstname: 'Stefania', lastname: 'Rossini', email: 'stefania@insiemento.io',
                          birthdate: '1990-05-25', gender: 'F', state: :active, phone: '3391122333',
                          password: default_password,
                          password_confirmation: default_password)
  u_stefania.skip_confirmation!
  u_stefania.save!
  u_marco=User.new(firstname: 'Marco', lastname: 'Tonelli', email: 'marco@insiemento.io',
                       birthdate: '1995-06-15', gender: 'M', state: :active, phone: '3354455666',
                       password: default_password,
                       password_confirmation: default_password)
  u_marco.skip_confirmation!
  u_marco.save!
  u_linda=User.new(firstname: 'Linda', lastname: 'Sacco', email: 'linda@insiemento.io',
                   birthdate: '2000-01-12', gender: 'F', state: :active, phone: '3382244666',
                   password: default_password,
                   password_confirmation: default_password)
  u_linda.skip_confirmation!
  u_linda.save!
  generic_user_names.each do |name|
    user=User.new(firstname: name.capitalize, lastname: 'Generic', email: "#{name}@insiemento.io",
                     birthdate: '2000-01-12', gender: 'M', state: :active, phone: '3382244666',
                     password: default_password,
                     password_confirmation: default_password)
    user.skip_confirmation!
    user.save!
  end
  puts "Users: #{User.count}"
else
  u_stefania, u_marco, u_linda = User.all
end

if Room.count == 0
  r_small=Room.create!(name: 'Piccola', max_attendees: 10, state: :active,)
  r_middle=Room.create!(name: 'Media', max_attendees: 20, state: :active,)
  r_large=Room.create!(name: 'Grande', max_attendees: 30, state: :active,)
  puts "Rooms: #{Room.count}"
else
  r_small, r_middle, r_large = Room.all
end

if CourseSchedule.count == 0
  course_event_attributes = []
  [1,2,3,4,5,6,0].each do |event_day|
    course_event_attributes << {course_id: c_zumba.id, room_id: r_small.id, trainer_id: t_miguel.id, event_day: event_day, event_time: '7:00', state: :active}
    course_event_attributes << {course_id: c_zumba.id, room_id: r_middle.id, trainer_id: t_miguel.id, event_day: event_day, event_time: '10:00', state: :active}
    course_event_attributes << {course_id: c_zumba.id, room_id: r_large.id, trainer_id: t_miguel.id, event_day: event_day, event_time: '13:00', state: :active}
    course_event_attributes << {course_id: c_yoga.id, room_id: r_small.id, trainer_id: t_jenny.id, event_day: event_day, event_time: '14:30', state: :active}
    course_event_attributes << {course_id: c_yoga.id, room_id: r_middle.id, trainer_id: t_jenny.id, event_day: event_day, event_time: '16:30', state: :active}
    course_event_attributes << {course_id: c_yoga.id, room_id: r_large.id, trainer_id: t_jenny.id, event_day: event_day, event_time: '18:30', state: :active}
    course_event_attributes << {course_id: c_pilates.id, room_id: r_large.id, trainer_id: t_sandy.id, event_day: event_day, event_time: '21:00', state: :active}
  end
  CourseSchedule.create!(course_event_attributes)
  puts "CourseSchedules: #{CourseSchedule.count}"
end

# Calculate next monday date
starting_date = Time.zone.today
# starting_date = Date.parse('monday')
# delta = starting_date > Time.zone.today ? 0 : 7
# starting_date = starting_date + delta

if CourseEvent.count == 0
  # CourseSchedule.all.each do |cs|
  #   ce=CourseEvent.create!(course_id: cs.course.id,
  #                       room_id: cs.room_id,
  #                       trainer_id: cs.trainer_id,
  #                       course_schedule_id: cs.id,
  #                       event_date: cs.next_event_datetime(starting_date),
  #                       state: cs.state)
  #   starting_date = ce.event_date.to_date
  # end
  # puts "CourseEvents: #{CourseEvent.count}"
  ScheduleService.call(starting_date: Date.parse('2020-02-01'))
  puts "CourseEvents: #{CourseEvent.count}"
end

if Attendee.count == 0
  Attendee.create!(course_event_id:  1, user_id: u_stefania.id)
  Attendee.create!(course_event_id:  1, user_id: u_marco.id)
  Attendee.create!(course_event_id:  1, user_id: u_linda.id)
  generic_user_names.each do |name|
    user=User.find_by_email("#{name}@insiemento.io")
    Attendee.create!(course_event_id:  1, user_id: user.id)
  end

  Attendee.create!(course_event_id:  2, user_id: u_stefania.id)
  Attendee.create!(course_event_id:  2, user_id: u_marco.id)

  Attendee.create!(course_event_id:  3, user_id: u_stefania.id)
  Attendee.create!(course_event_id:  4, user_id: u_stefania.id)
  Attendee.create!(course_event_id:  5, user_id: u_stefania.id)

  puts "Attendees: #{Attendee.count}"
end