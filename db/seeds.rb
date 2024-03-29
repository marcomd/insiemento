###                READ CAREFULLY BEFORE UPDATE                    ###
# This seed is used by specs, don't change the order of items creation
# and execute all specs after each changement
######################################################################

default_password = Rails.application.credentials.seed.dig(:default_password)
default_root_admin_password = Rails.application.credentials.seed.dig(:default_root_admin_password)
default_admin_password = Rails.application.credentials.seed.dig(:default_admin_password)
stripe_new_payment_response = {
  id: 'pi_1GmIPWFBKMhSCxMuij0bwJMo',
  object: 'payment_intent',
  last_payment_error: nil,
  livemode: false,
  next_action: nil,
  status: 'requires_payment_method',
  amount: 34_800,
  amount_capturable: 0,
  amount_received: 0,
  application: nil,
  application_fee_amount: nil,
  canceled_at: nil,
  cancellation_reason: nil,
  capture_method: 'automatic',
  charges: {
    object: 'list',
    data: [],
    has_more: false,
    total_count: 0,
    url: '/v1/charges?payment_intent=pi_1GmIPWFBKMhSCxMuij0bwJMo'
  },
  client_secret: 'pi_1GmIPWFBKMhSCxMuij0bwJMo_secret_WjkzuGJuFtmioE1hzl0UXbv3v',
  confirmation_method: 'automatic',
  created: 1_590_321_274,
  currency: 'eur',
  customer: nil,
  description: nil,
  invoice: nil,
  metadata: {
    integration_check: 'accept_a_payment'
  },
  on_behalf_of: nil,
  payment_method: nil,
  payment_method_options: {
    card: {
      installments: nil,
      request_three_d_secure: 'automatic'
    }
  },
  payment_method_types: [
    'card'
  ],
  receipt_email: nil,
  review: nil,
  setup_future_usage: nil,
  shipping: nil,
  source: nil,
  statement_descriptor: nil,
  statement_descriptor_suffix: nil,
  transfer_data: nil,
  transfer_group: nil
}.to_json
stripe_complete_payment_response = {
  "id": 'pi_1GhHl2FBKMhSCxMuyVwwkSam',
  "object": 'payment_intent',
  "last_payment_error": nil,
  "livemode": false,
  "next_action": nil,
  "status": 'succeeded',
  "amount": 1099,
  "amount_capturable": 0,
  "amount_received": 1099,
  "application": nil,
  "application_fee_amount": nil,
  "canceled_at": nil,
  "cancellation_reason": nil,
  "capture_method": 'automatic',
  "charges": {
    "object": 'list',
    "data": [
      {
        "id": 'ch_1Gm4MwFBKMhSCxMu9Y5EiVMn',
        "object": 'charge',
        "amount": 1099,
        "amount_refunded": 0,
        "application": nil,
        "application_fee": nil,
        "application_fee_amount": nil,
        "balance_transaction": 'txn_1Gm4MwFBKMhSCxMuJN7NTprq',
        "billing_details": {
          "address": {
            "city": nil,
            "country": nil,
            "line1": nil,
            "line2": nil,
            "postal_code": '20000',
            "state": nil
          },
          "email": nil,
          "name": nil,
          "phone": nil
        },
        "calculated_statement_descriptor": 'Stripe',
        "captured": true,
        "created": 1_590_267_298,
        "currency": 'eur',
        "customer": nil,
        "description": nil,
        "destination": nil,
        "dispute": nil,
        "disputed": false,
        "failure_code": nil,
        "failure_message": nil,
        "fraud_details": {
        },
        "invoice": nil,
        "livemode": false,
        "metadata": {
          "integration_check": 'accept_a_payment'
        },
        "on_behalf_of": nil,
        "order": nil,
        "outcome": {
          "network_status": 'approved_by_network',
          "reason": nil,
          "risk_level": 'normal',
          "risk_score": 10,
          "seller_message": 'Payment complete.',
          "type": 'authorized'
        },
        "paid": true,
        "payment_intent": 'pi_1GhHl2FBKMhSCxMuyVwwkSam',
        "payment_method": 'pm_1Gm4MvFBKMhSCxMuDgjTtu5r',
        "payment_method_details": {
          "card": {
            "brand": 'visa',
            "checks": {
              "address_line1_check": nil,
              "address_postal_code_check": 'pass',
              "cvc_check": 'pass'
            },
            "country": 'US',
            "exp_month": 12,
            "exp_year": 2022,
            "fingerprint": 'yFQ5vw8ZmbnfkVDr',
            "funding": 'credit',
            "installments": nil,
            "last4": '4242',
            "network": 'visa',
            "three_d_secure": nil,
            "wallet": nil
          },
          "type": 'card'
        },
        "receipt_email": nil,
        "receipt_number": nil,
        "receipt_url": 'https://pay.stripe.com/receipts/acct_1GUH4FFBKMhSCxMu/ch_1Gm4MwFBKMhSCxMu9Y5EiVMn/rcpt_HKjq5XrX7X3L9PfcwDuNtEFRqw1XdIM',
        "refunded": false,
        "refunds": {
          "object": 'list',
          "data": [],
          "has_more": false,
          "total_count": 0,
          "url": '/v1/charges/ch_1Gm4MwFBKMhSCxMu9Y5EiVMn/refunds'
        },
        "review": nil,
        "shipping": nil,
        "source": nil,
        "source_transfer": nil,
        "statement_descriptor": nil,
        "statement_descriptor_suffix": nil,
        "status": 'succeeded',
        "transfer_data": nil,
        "transfer_group": nil
      }
    ],
    "has_more": false,
    "total_count": 1,
    "url": '/v1/charges?payment_intent=pi_1GhHl2FBKMhSCxMuyVwwkSam'
  },
  "client_secret": 'pi_1GhHl2FBKMhSCxMuyVwwkSam_secret_5RgBVLZL3CblZUEG4kbOjQavk',
  "confirmation_method": 'automatic',
  "created": 1_589_127_124,
  "currency": 'eur',
  "customer": nil,
  "description": nil,
  "invoice": nil,
  "metadata": {
    "integration_check": 'accept_a_payment'
  },
  "on_behalf_of": nil,
  "payment_method": 'pm_1Gm4MvFBKMhSCxMuDgjTtu5r',
  "payment_method_options": {
    "card": {
      "installments": nil,
      "request_three_d_secure": 'automatic'
    }
  },
  "payment_method_types": [
    'card'
  ],
  "receipt_email": nil,
  "review": nil,
  "setup_future_usage": nil,
  "shipping": nil,
  "source": nil,
  "statement_descriptor": nil,
  "statement_descriptor_suffix": nil,
  "transfer_data": nil,
  "transfer_group": nil
}.to_json

if Organization.count == 0
  o_fitness = Organization.create(name: 'Fitness center', payoff: 'Run, Jump, Burn!',
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
                                    warning_color: '#ffc107'
                                  })
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
                                 warning_color: '#ffc107'
                               })
else
  o_fitness, o_swim = Organization.all
end

if AdminUser.count == 0
  admin_user = AdminUser.new(email: 'admin@insiemento.io',
                             password: default_root_admin_password,
                             password_confirmation: default_root_admin_password,
                             firstname: 'Admin', lastname: 'Platform')
  admin_user.roles = ['root']
  admin_user.save!

  # Create admins with different roles for each organization
  Organization.all.each do |organization|
    %w[manager accountant].each do |role|
      admin_user = AdminUser.new(email: "#{role}@#{organization.domain}",
                                 organization: organization,
                                 password: default_admin_password,
                                 password_confirmation: default_admin_password,
                                 firstname: role.capitalize, lastname: organization.name)
      admin_user.roles = [role]
      admin_user.save!
    end
  end

  puts "AdminUser: #{AdminUser.count}"
end

if Category.count == 0
  ca_fitness = Category.create!(organization: o_fitness,  name: 'Fitness')
  ca_spa     = Category.create!(organization: o_fitness,  name: 'Spa')
  ca_swim    = Category.create!(organization: o_swim, name: 'Aquagym')
  puts "Categories: #{Category.count}"
else
  ca_fitness, ca_spa, ca_swim = Category.all
end

if Course.count == 0
  c_zumba = Course.create!(name: 'Zumba',
                           description: 'L''allenamento più divertente in assoluto. Balla al ritmo di musiche energetiche insieme a gente fantastica e brucia una tonnellata di calorie divertendoti.',
                           start_booking_hours: 170,
                           end_booking_minutes: 90,
                           state: :active,
                           organization: o_fitness,
                           category: ca_fitness)
  c_yoga = Course.create!(name: 'Yoga',
                          description: 'Lo Yoga porta equilibrio e calma, oltre che benessere fisico e mentale.',
                          start_booking_hours: 96,
                          end_booking_minutes: 360,
                          state: :active,
                          organization: o_fitness,
                          category: ca_fitness)
  c_pilates = Course.create!(name: 'Pilates',
                             description: 'Il pilates è una ginnastica funzionale, posturale e globale basata sul riequilibrio di corpo e mente, che agisce sulla consapevolezza del proprio corpo, sulla forza e sulla flessibilità insegnando a dare maggiore armonia e fluidità nei movimenti.',
                             start_booking_hours: 24,
                             end_booking_minutes: 60,
                             state: :active,
                             organization: o_fitness,
                             category: ca_fitness)
  c_spa = Course.create!(name: 'Relax',
                         description: 'Il nostro corso Relax mostra le tecniche per sfruttare al massimo i trattamenti del nostrop centro, per un totale benessere. Lasciati coccolare dagli esperti della nostra struttura.',
                         start_booking_hours: 24,
                         end_booking_minutes: 60,
                         state: :active,
                         organization: o_fitness,
                         category: ca_spa)
  c_aqua_gym = Course.create!(name: 'Acqua Gym',
                              description: 'Aiuta a dimagrire proponendo una ginnastica completa, mirata a tonificare braccia, addome, gambe e glutei.  Il corso in acqua bassa è adatto a tutte le età grazie alla mancanza di gravità in acqua. Dinamico e divertente che porta in acqua semplici coreografie a ritmo di musica contemporanea.',
                              start_booking_hours: 24,
                              end_booking_minutes: 60,
                              state: :active,
                              organization: o_swim,
                              category: ca_swim)
  puts "Courses: #{Course.count}"
else
  c_zumba, c_yoga, c_pilates, c_aqua_gym = Course.all
end

if Trainer.count == 0
  t_miguel = Trainer.create!(firstname: 'Miguel', lastname: 'Dos Santos', nickname: 'El Nino', state: :active, organization: o_fitness,
                             bio: 'Un caliente ballerino brasiliano, tra i tre più grandi ballerini italiani di zumba di tutti i tempi.')
  t_jenny = Trainer.create!(firstname: 'Jennifer', lastname: 'Santorini', nickname: 'Saint', state: :active, organization: o_fitness,
                            bio: "Percorso accademico completato negli states, eletta Miss chiappe d'oro 2019, con lei è vivamente consigliata una bombola di ossigeno!")
  t_sandy = Trainer.create!(firstname: 'Sandy', lastname: 'Marton', nickname: 'Sese', state: :active, organization: o_fitness,
                            bio: 'È un artista in grado di interpretare la musica e tradurla attraverso il linguaggio del corpo.')
  t_ana = Trainer.create!(firstname: 'Anita', lastname: 'Mena', nickname: 'Ana', state: :active, organization: o_swim,
                          bio: 'Ottima preparazione atletica e dispone di una certa predisposizione all’insegnamento. Conoscenza delle tecniche avanzate del nuoto, ascolta, stimola e motiva i suoi atleti.')
  puts "Trainers: #{Trainer.count}"
else
  t_miguel, t_jenny, t_sandy, t_ana = Trainer.all
end

generic_user_names = %w[user1 user2 user3 user4 user5 user6 user7]
generic_lastname = 'Generic'

if User.count == 0
  u_stefy = User.new(firstname: 'Stefania', lastname: 'Rossini', email: "stefania@#{o_fitness.domain}",
                     organization: o_fitness,
                     birthdate: '1990-05-25', gender: 'F', phone: '3391122333',
                     password: default_password,
                     password_confirmation: default_password)
  u_stefy.skip_confirmation!
  u_stefy.save!

  u_marco = User.new(firstname: 'Marco', lastname: 'Tonelli', email: "marco@#{o_fitness.domain}",
                     organization: o_fitness,
                     birthdate: '1995-06-15', gender: 'M', phone: '3354455555',
                     password: default_password,
                     password_confirmation: default_password)
  u_marco.skip_confirmation!
  u_marco.save!

  u_linda = User.new(firstname: 'Linda', lastname: 'Sacco', email: "linda@#{o_fitness.domain}",
                     organization: o_fitness,
                     birthdate: '2000-01-12', gender: 'F', phone: '3382244333',
                     password: default_password,
                     password_confirmation: default_password)
  u_linda.skip_confirmation!
  u_linda.save!

  u_paolo = User.new(firstname: 'Paolo', lastname: 'Paolotto', email: "paolo@#{o_fitness.domain}",
                     organization: o_fitness,
                     birthdate: '1990-10-04', gender: 'M', phone: '3382244444',
                     password: default_password,
                     password_confirmation: default_password)
  u_paolo.skip_confirmation!
  u_paolo.save!

  u_elena = User.new(firstname: 'Elena', lastname: 'Elica', email: "elena@#{o_fitness.domain}",
                     organization: o_fitness,
                     birthdate: '2001-10-04', gender: 'F', phone: '3301020300',
                     password: default_password,
                     password_confirmation: default_password)
  u_elena.skip_confirmation!
  u_elena.save!

  u_pina = User.new(firstname: 'Pina', lastname: 'Pesce', email: "pina@#{o_swim.domain}",
                    organization: o_swim,
                    birthdate: '1985-05-10', gender: 'F', phone: '3331122333',
                    password: default_password,
                    password_confirmation: default_password)
  u_pina.skip_confirmation!
  u_pina.save!

  generic_user_names.each do |name|
    user = User.new(firstname: name.capitalize, lastname: generic_lastname, email: "#{name}@#{o_fitness.domain}",
                    organization: o_fitness,
                    birthdate: '2000-01-12', gender: 'M', phone: '3382244666',
                    password: default_password,
                    password_confirmation: default_password)
    user.skip_confirmation!
    user.save!
  end
  puts "Users: #{User.count}"
else
  u_stefy, u_marco, u_linda = User.all
end

generic_users = User.where(lastname: generic_lastname)

if Room.count == 0
  r_small      = Room.create!(organization: o_fitness, name: 'Piccola', description: 'La nostra magnifica sala, ben attrezzata e che può ospitare fino a 10 persone', max_attendees: 10, state: :active)
  r_middle     = Room.create!(organization: o_fitness, name: 'Media', description: 'La nostra magnifica sala, ben attrezzata e che può ospitare fino a 20 persone', max_attendees: 20, state: :active)
  r_large      = Room.create!(organization: o_fitness, name: 'Grande', description: 'La nostra magnifica sala, ben attrezzata e che può ospitare fino a 30 persone', max_attendees: 30, state: :active)
  r_swim_small = Room.create!(organization: o_swim, name: 'Piccola', description: 'La nostra magnifica sala, ben attrezzata e che può ospitare fino a 25 persone', max_attendees: 25, state: :active)
  r_swim_large = Room.create!(organization: o_swim, name: 'Grande', description: 'La nostra magnifica sala, ben attrezzata e che può ospitare fino a 50 persone', max_attendees: 50, state: :active)
  puts "Rooms: #{Room.count}"
else
  r_small, r_middle, r_large, r_swim_small, r_swim_large = Room.all
end

if CourseSchedule.count == 0
  course_event_attributes = []
  [1, 2, 3, 4, 5, 6, 0].each do |event_day|
    course_event_attributes << { organization: o_fitness, course: c_zumba, category: c_zumba.category, room: r_small, trainer: t_miguel, event_day: event_day, event_time: '7:00', state: :active }
    course_event_attributes << { organization: o_fitness, course: c_zumba, category: c_zumba.category, room: r_middle, trainer: t_miguel, event_day: event_day, event_time: '10:00', state: :active }
    course_event_attributes << { organization: o_fitness, course: c_zumba, category: c_zumba.category, room: r_large, trainer: t_miguel, event_day: event_day, event_time: '13:00', state: :active }
    course_event_attributes << { organization: o_fitness, course: c_yoga, category: c_yoga.category, room: r_small, trainer: t_jenny, event_day: event_day, event_time: '14:30', state: :active }
    course_event_attributes << { organization: o_fitness, course: c_yoga, category: c_yoga.category, room: r_middle, trainer: t_jenny, event_day: event_day, event_time: '16:30', state: :active }
    course_event_attributes << { organization: o_fitness, course: c_yoga, category: c_yoga.category, room: r_large, trainer: t_jenny, event_day: event_day, event_time: '18:30', state: :active }
    course_event_attributes << { organization: o_fitness, course: c_pilates, category: c_pilates.category, room: r_large, trainer: t_sandy, event_day: event_day, event_time: '21:00', state: :active }

    course_event_attributes << { organization: o_fitness, course: c_spa, category: c_spa.category, room: r_large, trainer: t_sandy, event_day: event_day, event_time: '10:00', state: :active }

    course_event_attributes << { organization: o_swim, course: c_aqua_gym, category: c_aqua_gym.category, room: r_swim_small, trainer: t_ana, event_day: event_day, event_time: '13:00', state: :active }
    course_event_attributes << { organization: o_swim, course: c_aqua_gym, category: c_aqua_gym.category, room: r_swim_large, trainer: t_ana, event_day: event_day, event_time: '20:00', state: :active }
  end
  CourseSchedule.create!(course_event_attributes)
  puts "CourseSchedules: #{CourseSchedule.count}"
end

if CourseEvent.count == 0
  ScheduleService.call(starting_date: Date.today)
  puts "CourseEvents: #{CourseEvent.count}"
end

if Product.count == 0
  p_fitness_try   = Product.create!(organization: o_fitness, category: ca_fitness, product_type: :trial, state: :active, price_cents: 0, days: 15, max_accesses_number: 1, name: 'Periodo di prova', description: 'A description...')
  p_fitness_month = Product.create!(organization: o_fitness, category: ca_fitness, product_type: :fee, state: :active, price_cents: 19_00, days: 30, max_accesses_number: nil, name: 'Abbonamento mensile fitness', description: 'A description...')
  p_fitness_year  = Product.create!(organization: o_fitness, category: ca_fitness, product_type: :fee, state: :active, price_cents: 199_00, days: 365, max_accesses_number: nil, name: 'Abbonamento annuale fitness', description: 'A description...')
  p_spa_single    = Product.create!(organization: o_fitness, category: ca_spa, product_type: :consumption, state: :active, price_cents: 29_00, days: 30, max_accesses_number: 1, name: 'Entrata singola spa', description: 'A description...')
  p_spa_month     = Product.create!(organization: o_fitness, category: ca_spa, product_type: :fee, state: :active, price_cents: 149_00, days: 30, max_accesses_number: nil, name: 'Abbonamento mensile spa', description: 'A description...')
  p_swim_month    = Product.create!(organization: o_swim, category: ca_swim, product_type: :fee, state: :active, price_cents: 49_00, days: 30, max_accesses_number: nil, name: 'Abbonamento mensile aquagym', description: 'A description...')
  p_swim_year     = Product.create!(organization: o_swim, category: ca_swim, product_type: :fee, state: :active, price_cents: 539_00, days: 365, max_accesses_number: nil, name: 'Abbonamento annuale aquagym', description: 'A description...')
  p_swim_single   = Product.create!(organization: o_swim, category: ca_swim, product_type: :consumption, state: :active, price_cents: 11_00, days: 30, max_accesses_number: 1, name: 'Entrata singola aquagym', description: 'A description...')
  p_swim_ten      = Product.create!(organization: o_swim, category: ca_swim, product_type: :consumption, state: :active, price_cents: 100_00, days: 90, max_accesses_number: 10, name: 'Carnet dieci entrate aquagym', description: 'A description...')
  p_fitness_ten   = Product.create!(organization: o_fitness, category: ca_fitness, product_type: :consumption, state: :active, price_cents: 24_00, days: 60, max_accesses_number: 10, name: 'Carnet dieci entrate fitness', description: 'A description...')
  p_spa_ten       = Product.create!(organization: o_fitness, category: ca_spa, product_type: :consumption, state: :active, price_cents: 149_00, days: 90, max_accesses_number: 10, name: 'Carnet dieci entrate spa', description: 'A description...')
  puts "Products: #{Product.count}"
else
  p_fitness_try, p_fitness_month, p_fitness_year, p_spa_single, p_spa_month, p_swim_month, p_swim_year = Product.all
end

if Order.count == 0
  ord_stefy  = Order.create!(organization: o_fitness, user: u_stefy, start_on: Time.zone.today, products: [p_fitness_year, p_spa_ten])
  ord_paolo  = Order.create!(organization: o_fitness, user: u_paolo, start_on: Time.zone.today, products: [p_fitness_month])
  ord_elena  = Order.create!(organization: o_fitness, user: u_elena, start_on: Time.zone.today, products: [p_fitness_month])
  puts "Orders: #{Order.count}"
else
  ord_stefy, ord_paolo, ord_elena = Order.all
end

if Payment.count == 0
  pay_stefy  = StripePayment.create!(organization: o_fitness, user: u_stefy, order: ord_stefy, source: :frontend, state: :confirmed, amount_cents: 34_800, external_service_response: stripe_complete_payment_response)
  pay_paolo  = StripePayment.create!(organization: o_fitness, user: u_paolo, order: ord_paolo, source: :frontend, state: :just_made, amount_cents: 1900, external_service_response: stripe_new_payment_response)
  puts "Payments: #{Payment.count}"

  # Subscriptions are created after the payment is created but these simulate an admin creation
  subscription_attributes = []
  # Redeemed active subscriptions...
  # subscription_attributes << { organization: o_fitness, category: p_fitness_year.category , product: p_fitness_year , user: u_stefy, start_on: ord_stefy.start_on, end_on: Time.zone.today + p_fitness_year.days, order: ord_stefy  }
  # subscription_attributes << { organization: o_fitness, category: p_spa_month.category    , product: p_spa_month    , user: u_stefy, start_on: ord_stefy.start_on, end_on: Time.zone.today + p_spa_month.days   , order: ord_stefy  }
  subscription_attributes << { organization: o_fitness, category: p_fitness_month.category, product: p_fitness_month, user: u_marco, state: :active, start_on: Time.zone.yesterday }
  subscription_attributes << { organization: o_fitness, category: p_fitness_month.category, product: p_fitness_ten, user: u_linda, state: :active, start_on: Time.zone.yesterday }
  subscription_attributes << { organization: o_fitness, category: p_fitness_try.category, product: p_fitness_try, user: u_paolo, state: :active, start_on: Time.zone.yesterday }
  # Add subscription to generic users to allow them to attendee course event
  generic_users.each do |user|
    subscription_attributes << { organization: o_fitness, category: p_fitness_try.category, product: p_fitness_try, user: user, state: :active, start_on: Time.zone.yesterday }
  end
  # Free subscription codes...
  5.times do
    subscription_attributes << { organization: o_fitness, category: p_fitness_month.category, product: p_fitness_month, user: nil, start_on: nil, end_on: nil }
  end
  Subscription.create!(subscription_attributes)
  puts "Subscriptions: #{Subscription.count}"
else
  pay_stefy, pay_paolo = Payment.all
end

if Attendee.count == 0
  Attendee.new(course_event_id:  1, user_id: u_stefy.id, disable_bookability_checks: true).save!
  Attendee.new(course_event_id:  1, user_id: u_marco.id, disable_bookability_checks: true).save!
  Attendee.new(course_event_id:  1, user_id: u_linda.id, disable_bookability_checks: true).save!

  generic_users.each do |user|
    Attendee.new(course_event_id: 1, user_id: user.id, disable_bookability_checks: true).save!
  end

  Attendee.new(course_event_id:  2, user_id: u_stefy.id, disable_bookability_checks: true).save!
  Attendee.new(course_event_id:  2, user_id: u_marco.id, disable_bookability_checks: true).save!
  Attendee.new(course_event_id:  3, user_id: u_stefy.id, disable_bookability_checks: true).save!
  Attendee.new(course_event_id:  4, user_id: u_stefy.id, disable_bookability_checks: true).save!
  Attendee.new(course_event_id:  6, user_id: u_stefy.id, disable_bookability_checks: true).save!

  puts "Attendees: #{Attendee.count}"
end

if UserDocumentModel.count == 0
  body = <<~'TEXT'
    DICHIARAZIONE SULLE CONDIZIONI DI SALUTE (AUTODICHIARAZIONE AI SENSI DELL’ART. 47 D.P.R. N. 445/2000)
    
    Il sottoscritto #{user.firstname} #{user.lastname} nato il #{birthdate}
    Tel #{user.phone} email #{user.email}
    
    
    DICHIARA SOTTO LA PROPRIA RESPONSABILITÀ
    
    a) di essere a conoscenza delle misure di contenimento del contagio vigenti;
    b) che il figlio o un convivente dello stesso all’interno del nucleo familiare non è o non è stato COVID-19
    positivo accertato ovvero è stato COVID 19 positivo accertato e dichiarato guarito a seguito di duplice
    tampone negativo;
    c) che il figlio o un convivente dello stesso all’interno del nucleo familiare non è stato sottoposto alla misura
    della quarantena o isolamento domiciliare negli ultimi 14 giorni;
    d) che il figlio o un convivente dello stesso all’interno del nucleo familiare non ha avuto negli ultimi 14 giorni
    contatti con soggetti risultati positivi al COVID-19 o con una persona con temperatura corporea superiore ai
    37,5°C o con sintomatologia respiratoria, per quanto di propria conoscenza;
    e) che il figlio o un convivente dello stesso all’interno del nucleo familiare non ha presentato negli ultimi 3
    giorni sintomi influenzali (tosse, febbre superiore a 37,5°) e che in caso di insorgere degli stessi nel minore
    durante l’allenamento sarà propria cura provvedere a riportarlo tempestivamente presso il proprio domicilio;
    f) di essere a conoscenza delle sanzioni previste dal combinato disposto dell’art. 2 del D.L. 33 del 16 maggio
    2020 e del DPCM 11 giugno 2020.
    
    San Giuliano Mil.se, #{today}      In fede _________________________
    
    Il presente modulo sarà conservato da #{organization.name} nel rispetto della normativa sulla
    tutela dei dati personali, fino al termine dello stato di emergenza sanitaria.
  TEXT

  doc_covid = UserDocumentModel.create!(organization_id: o_fitness.id, title: 'Autocertificazione Covid', body: body, validity_days: 14, recurring: true)
  puts "UserDocumentModel: #{UserDocumentModel.count}"
else
  doc_covid, other = UserDocumentModel.all
end

if UserDocument.count == 0
  user_document_attributes = []
  user_document_attributes << { organization_id: doc_covid.organization_id, user_document_model_id: doc_covid.id, user_id: u_stefy.id, state: :exported, title: doc_covid.title, body: doc_covid.body }
  user_document_attributes << { organization_id: doc_covid.organization_id, user_document_model_id: doc_covid.id, user_id: u_marco.id, state: :exporting, title: doc_covid.title, body: doc_covid.body }
  user_document_attributes << { organization_id: doc_covid.organization_id, user_document_model_id: doc_covid.id, user_id: u_linda.id, state: :draft, title: doc_covid.title, body: doc_covid.body, uuid: 'b085520f-abe1-48f3-9587-6568af775216' }

  UserDocument.create!(user_document_attributes)
  puts "UserDocument: #{UserDocument.count}"
end

if News.count == 0
  news_attributes = []
  news_attributes << { organization_id: o_fitness.id, news_type: :info, title: 'Nuovo corso Brasilian Fitness!', body: 'Siamo lieti di annunciare che abbiamo aggiunto al palinsesto il nuovo corso, divertente e adatto a tutti, provalo!', expire_on: 1.month.ago, state: :expired }
  news_attributes << { organization_id: o_fitness.id, news_type: :warning, title: 'Smarrito mazzo di chiavi', body: 'Chiunque lo avesse trovato è pregato di consegnarlo in segreteria, grazie!', expire_on: 2.weeks.from_now }
  news_attributes << { organization_id: o_fitness.id, news_type: :success, title: 'Obiettivo raggiunto!', body: 'Grazie a tutti per aver consentito il raggiungimento di questo straordinario risultato!', expire_on: 2.weeks.from_now, state: :active }

  News.create!(news_attributes)
  puts "News: #{News.count}"
end
