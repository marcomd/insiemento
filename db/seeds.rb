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

if Organization.count == 0
  o_dance = Organization.create(name: 'Fitness center', payoff: 'Run, Jump, Burn!',
                                email: 'support@fitness.io', phone: '0211223344',
                                domain: 'fitness.io', state: :active,
                                theme: {
                                  dark_mode: false,
                                  header_dark_mode: false,
                                  header_background_color: '#ffffff',
                                  primary_color: '#ff008d',
                                  secondary_color: '#424242',
                                  accent_color: '#ff008d',
                                  info_color: '#2196f3',
                                  success_color: '#4caf50',
                                  error_color: '#b71c1c',
                                  warning_color: '#ffc107',
                                }
  )
  o_swim = Organization.create(name: 'Swimming pool', payoff: 'Water and fun!',
                                email: 'support@swim.io', phone: '0233445566',
                                domain: 'swim.io', state: :active,
                                theme: {
                                    dark_mode: false,
                                    header_dark_mode: false,
                                    header_background_color: '#ffffff',
                                    primary_color: '#00ff8d',
                                    secondary_color: '#424242',
                                    accent_color: '#00ff8d',
                                    info_color: '#2196f3',
                                    success_color: '#4caf50',
                                    error_color: '#b71c1c',
                                    warning_color: '#ffc107',
                                }
  )
else
  o_dance, o_swim = Organization.all
end

if Category.count == 0
  ca_fitness = Category.create!(organization: o_dance,  name: 'Palestra',)
  ca_spa     = Category.create!(organization: o_dance,  name: 'Spa',)
  ca_swim    = Category.create!(organization: o_swim,   name: 'Piscina',)
  puts "Categories: #{Category.count}"
else
  ca_fitness, ca_spa, ca_swim = Category.all
end

if Course.count == 0
  c_zumba=Course.create!(name: 'Zumba',
                         description: 'L''allenamento più divertente in assoluto. Balla al ritmo di musiche energetiche insieme a gente fantastica e brucia una tonnellata di calorie divertendoti.',
                         start_booking_hours: 48,
                         end_booking_minutes: 90,
                         state: :active,
                         organization: o_dance,
                         category: ca_fitness,
  )
  c_yoga=Course.create!(name: 'Yoga',
                         description: 'Lo Yoga porta equilibrio e calma, oltre che benessere fisico e mentale.',
                         start_booking_hours: 96,
                         end_booking_minutes: 360,
                         state: :active,
                         organization: o_dance,
                         category: ca_fitness,
                         )
  c_pilates=Course.create!(name: 'Pilates',
                          description: 'Il pilates è una ginnastica funzionale, posturale e globale basata sul riequilibrio di corpo e mente, che agisce sulla consapevolezza del proprio corpo, sulla forza e sulla flessibilità insegnando a dare maggiore armonia e fluidità nei movimenti.',
                          start_booking_hours: 24,
                          end_booking_minutes: 60,
                          state: :active,
                          organization: o_dance,
                          category: ca_fitness,
                        )
  c_spa=Course.create!(name: 'Pilates',
                           description: 'Il pilates è una ginnastica funzionale, posturale e globale basata sul riequilibrio di corpo e mente, che agisce sulla consapevolezza del proprio corpo, sulla forza e sulla flessibilità insegnando a dare maggiore armonia e fluidità nei movimenti.',
                           start_booking_hours: 24,
                           end_booking_minutes: 60,
                           state: :active,
                           organization: o_dance,
                           category: ca_spa,
                           )
  c_aqua_gym=Course.create!(name: 'Acqua Gym',
                           description: 'Aiuta a dimagrire proponendo una ginnastica completa, mirata a tonificare braccia, addome, gambe e glutei.  Il corso in acqua bassa è adatto a tutte le età grazie alla mancanza di gravità in acqua. Dinamico e divertente che porta in acqua semplici coreografie a ritmo di musica contemporanea.',
                           start_booking_hours: 24,
                           end_booking_minutes: 60,
                           state: :active,
                           organization: o_swim,
                           category: ca_swim,
                           )
  puts "Courses: #{Course.count}"
else
  c_zumba, c_yoga, c_pilates, c_aqua_gym = Course.all
end

if Trainer.count == 0
  t_miguel=Trainer.create!(firstname: 'Miguel', lastname: 'Dos Santos', nickname: 'El Nino', state: :active, organization: o_dance,
                           bio: "Un caliente ballerino brasiliano, tra i tre più grandi ballerini italiani di zumba di tutti i tempi.")
  t_jenny=Trainer.create!(firstname: 'Jennifer', lastname: 'Santorini', nickname: 'Saint', state: :active, organization: o_dance,
                          bio: "Percorso accademico completato negli states, eletta Miss chiappe d'oro 2019, con lei è vivamente consigliata una bombola di ossigeno!")
  t_sandy=Trainer.create!(firstname: 'Sandy', lastname: 'Marton', nickname: 'Sese', state: :active, organization: o_dance,
                         bio: "È un artista in grado di interpretare la musica e tradurla attraverso il linguaggio del corpo.")
  t_ana=Trainer.create!(firstname: 'Anita', lastname: 'Mena', nickname: 'Ana', state: :active, organization: o_swim,
                          bio: "Ottima preparazione atletica e dispone di una certa predisposizione all’insegnamento. Conoscenza delle tecniche avanzate del nuoto, ascolta, stimola e motiva i suoi atleti.")
  puts "Trainers: #{Trainer.count}"
else
  t_miguel, t_jenny, t_sandy, t_ana = Trainer.all
end

generic_user_names = %w(user1 user2 user3 user4 user5 user6 user7)
generic_lastname = 'Generic'

if User.count == 0
  u_stefania=User.new(firstname: 'Stefania', lastname: 'Rossini', email: "stefania@#{o_dance.domain}",
                      organization: o_dance,
                      birthdate: '1990-05-25', gender: 'F', state: :active, phone: '3391122333',
                      password: default_password,
                      password_confirmation: default_password)
  u_stefania.skip_confirmation!
  u_stefania.save!
  u_marco=User.new(firstname: 'Marco', lastname: 'Tonelli', email: "marco@#{o_dance.domain}",
                   organization: o_dance,
                   birthdate: '1995-06-15', gender: 'M', state: :active, phone: '3354455555',
                   password: default_password,
                   password_confirmation: default_password)
  u_marco.skip_confirmation!
  u_marco.save!
  u_linda=User.new(firstname: 'Linda', lastname: 'Sacco', email: "linda@#{o_dance.domain}",
                   organization: o_dance,
                   birthdate: '2000-01-12', gender: 'F', state: :active, phone: '3382244333',
                   password: default_password,
                   password_confirmation: default_password)
  u_linda.skip_confirmation!
  u_linda.save!
  u_paolo=User.new(firstname: 'Paolo', lastname: 'Paolotto', email: "paolo@#{o_dance.domain}",
                   organization: o_dance,
                   birthdate: '1990-10-04', gender: 'M', state: :active, phone: '3382244444',
                   password: default_password,
                   password_confirmation: default_password)
  u_paolo.skip_confirmation!
  u_paolo.save!
  u_elena=User.new(firstname: 'Elena', lastname: 'Elica', email: "elena@#{o_dance.domain}",
                   organization: o_dance,
                   birthdate: '2001-10-04', gender: 'F', state: :active, phone: '3301020300',
                   password: default_password,
                   password_confirmation: default_password)
  u_elena.skip_confirmation!
  u_elena.save!
  u_pina=User.new(firstname: 'Pina', lastname: 'Pesce', email: "pina@#{o_swim.domain}",
                   organization: o_swim,
                   birthdate: '1985-05-10', gender: 'F', state: :active, phone: '3331122333',
                   password: default_password,
                   password_confirmation: default_password)
  u_paolo.skip_confirmation!
  u_paolo.save!
  generic_user_names.each do |name|
    user=User.new(firstname: name.capitalize, lastname: generic_lastname, email: "#{name}@#{o_dance.domain}",
                  organization: o_dance,
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

generic_users = User.where(lastname: generic_lastname)

if Room.count == 0
  r_small =Room.create!(organization: o_dance, name: 'Piccola', max_attendees: 10, state: :active,)
  r_middle=Room.create!(organization: o_dance, name: 'Media',   max_attendees: 20, state: :active,)
  r_large =Room.create!(organization: o_dance, name: 'Grande',  max_attendees: 30, state: :active,)
  r_swim_small =Room.create!(organization: o_swim, name: 'Piccola',  max_attendees: 25, state: :active,)
  r_swim_large =Room.create!(organization: o_swim, name: 'Grande',  max_attendees: 50, state: :active,)
  puts "Rooms: #{Room.count}"
else
  r_small, r_middle, r_large, r_swim_small, r_swim_large = Room.all
end

if CourseSchedule.count == 0
  course_event_attributes = []
  [1,2,3,4,5,6,0].each do |event_day|
    course_event_attributes << {organization: o_dance, course: c_zumba   , category: c_zumba.category   , room: r_small     , trainer: t_miguel, event_day: event_day, event_time:  '7:00', state: :active}
    course_event_attributes << {organization: o_dance, course: c_zumba   , category: c_zumba.category   , room: r_middle    , trainer: t_miguel, event_day: event_day, event_time: '10:00', state: :active}
    course_event_attributes << {organization: o_dance, course: c_zumba   , category: c_zumba.category   , room: r_large     , trainer: t_miguel, event_day: event_day, event_time: '13:00', state: :active}
    course_event_attributes << {organization: o_dance, course: c_yoga    , category: c_yoga.category    , room: r_small     , trainer: t_jenny , event_day: event_day, event_time: '14:30', state: :active}
    course_event_attributes << {organization: o_dance, course: c_yoga    , category: c_yoga.category    , room: r_middle    , trainer: t_jenny , event_day: event_day, event_time: '16:30', state: :active}
    course_event_attributes << {organization: o_dance, course: c_yoga    , category: c_yoga.category    , room: r_large     , trainer: t_jenny , event_day: event_day, event_time: '18:30', state: :active}
    course_event_attributes << {organization: o_dance, course: c_pilates , category: c_pilates.category , room: r_large     , trainer: t_sandy , event_day: event_day, event_time: '21:00', state: :active}

    course_event_attributes << {organization: o_dance, course: c_spa     , category: c_spa.category     , room: r_large     , trainer: t_sandy , event_day: event_day, event_time: '10:00', state: :active}

    course_event_attributes << {organization: o_swim , course: c_aqua_gym, category: c_aqua_gym.category, room: r_swim_small, trainer: t_ana   , event_day: event_day, event_time: '13:00', state: :active}
    course_event_attributes << {organization: o_swim , course: c_aqua_gym, category: c_aqua_gym.category, room: r_swim_large, trainer: t_ana   , event_day: event_day, event_time: '20:00', state: :active}
  end
  CourseSchedule.create!(course_event_attributes)
  puts "CourseSchedules: #{CourseSchedule.count}"
end

if CourseEvent.count == 0
  ScheduleService.call(starting_date: Date.parse('2020-02-01'))
  puts "CourseEvents: #{CourseEvent.count}"
end

if Product.count == 0
  p_fitness_try   = Product.create!(organization: o_dance, category: ca_fitness, price_cents: 0,     days: 15 , name: 'Periodo di prova'           ,   )
  p_fitness_month = Product.create!(organization: o_dance, category: ca_fitness, price_cents: 1900,  days: 30 , name: 'Abbonamento mensile fitness',   )
  p_fitness_year  = Product.create!(organization: o_dance, category: ca_fitness, price_cents: 19900, days: 365, name: 'Abbonamento annuale fitness',   )
  p_spa_day       = Product.create!(organization: o_dance, category: ca_spa    , price_cents: 2900,  days: 1  , name: 'Entrata singola spa'        ,   )
  p_spa_month     = Product.create!(organization: o_dance, category: ca_spa    , price_cents: 14900, days: 30 , name: 'Abbonamento mensile spa'    ,   )
  p_swim_month    = Product.create!(organization: o_swim , category: ca_swim   , price_cents: 4900,  days: 30 , name: 'Abbonamento mensile piscina',   )
  p_swim_year     = Product.create!(organization: o_swim , category: ca_swim   , price_cents: 53900, days: 365, name: 'Abbonamento annuale piscina',   )
  puts "Products: #{Product.count}"
else
  p_fitness_try, p_fitness_month, p_fitness_year, p_spa_day, p_spa_month, p_swim_month, p_swim_year = Product.all
end

if Subscription.count == 0
  subscription_attributes = []
  # Redeemed active subscriptions...
  subscription_attributes << { organization: o_dance, category: p_fitness_year.category , product: p_fitness_year , user: u_stefania, start_on: Time.zone.today, end_on: Time.zone.today + p_fitness_year.days  }
  subscription_attributes << { organization: o_dance, category: p_spa_month.category    , product: p_spa_month    , user: u_stefania, start_on: Time.zone.today, end_on: Time.zone.today + p_spa_month.days     }
  subscription_attributes << { organization: o_dance, category: p_fitness_month.category, product: p_fitness_month, user: u_marco,    start_on: Time.zone.today, end_on: Time.zone.today + p_fitness_month.days }
  subscription_attributes << { organization: o_dance, category: p_fitness_month.category, product: p_fitness_month, user: u_linda,    start_on: Time.zone.today, end_on: Time.zone.today + p_fitness_month.days }
  subscription_attributes << { organization: o_dance, category: p_fitness_try.category  , product: p_fitness_try  , user: u_paolo,    start_on: Time.zone.today, end_on: Time.zone.today + p_fitness_try.days   }
  generic_users.each do |user|
    subscription_attributes << { organization: o_dance, category: p_fitness_try.category, product: p_fitness_try  , user: user,    start_on: Time.zone.today, end_on: Time.zone.today + p_fitness_try.days }
  end
  # Free subscription codes...
  5.times do
    subscription_attributes << { organization: o_dance, category: p_fitness_month.category, product: p_fitness_month, user: nil, start_on: nil, end_on: nil }
  end
  Subscription.create!(subscription_attributes)
  puts "Subscriptions: #{Subscription.count}"
end

if Attendee.count == 0
  Attendee.create!(course_event_id:  1, user_id: u_stefania.id)
  Attendee.create!(course_event_id:  1, user_id: u_marco.id)
  Attendee.create!(course_event_id:  1, user_id: u_linda.id)

  generic_users.each do |user|
    Attendee.create!(course_event_id:  1, user_id: user.id)
  end

  Attendee.create!(course_event_id:  2, user_id: u_stefania.id)
  Attendee.create!(course_event_id:  2, user_id: u_marco.id)

  Attendee.create!(course_event_id:  3, user_id: u_stefania.id)
  Attendee.create!(course_event_id:  4, user_id: u_stefania.id)
  Attendee.create!(course_event_id:  5, user_id: u_stefania.id)

  puts "Attendees: #{Attendee.count}"
end