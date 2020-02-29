# CHANGELOG

# v0.5.0 28/02/2020 4h 60h

- Added organizations management
  - Added organization model and added this relation to all existing models
    The theme attribute is a jsonb type field and this is used to customize the frontend UI from the backend UI.
  - Added the current organization callback to application controller, set it by ENV.
    In this way we can set an organization for each instance and this is the first step through the multi tenant management.
  - Updated SendgridService to accept organization param
  - Updated the frontend to use new organization attributes

# v0.4.1 28/02/2020

- Updated nokogiri from 1.10.7 to 1.10.8

# v0.4.0 28/02/2020 1h

- Added ScheduleJob to create next week events
- Added sidekiq cron and sidekiq status gem
- Added sidekiq configuration

# v0.3.0 25/02/2020 2h

- New ScheduleService to create course events weekly

# v0.2.0 24/02/2020

- Added CircleCI configuration, removed TravisCI

# v0.1.0 22/02/2020

- Added readme and travis configuration

# v0.0.26 22/02/2020 3h

- Backend
  - Added max attendee validation
  - Configured rspec
  - Improved seed with new cases
- Frontend
  - Course events list now shows a new chip when it is full
  - Course event show button is disabled when it is full 

# v0.0.25 19/02/2020 0,5h

- Fixed reset password
  - Now it sends the email with the reset password link

# v0.0.24 16/02/2020 0,5h

- Fixed a bug when the user registered with an email address with some uppercase characters

# v0.0.23 15/02/2020 2h

- Improved CourseSchedule next_event_date
  - Now accept a date as params as it use it to return the next week date
  - Added the CourseSchedule model spec. Seed is loaded before the suite to access uses cases
- Seed now creates scheduling starting from the current date

# v0.0.22 15/02/2020 1,5h

- Improved the course selection in the dashboard page
  - Now list of courses is built dinamically
  - Search text field now is shown only stating from small display and up
- Added new data to the seed
  - new course Pilates with relative image
  - a new trainer and new schedules 
- Improved course events table visualization on small display
- Fixed a bug in the course event module, now it retrieves only events with active state
- Other little improvements

# v0.0.21 15/02/2020 0,5h

- Added a course selection on top of the events table
  - Added a select above the table linked to search with which you can select the course from a static list

# v0.0.20 11/02/2020 0,5h

- Added contact label on sidebar and it is also improved: it sets a subject depending on current page. 
  On course event page the subject includes its data otherwise a generic subject is used.

# v0.0.19 11/02/2020 0,5h

- Several minor fixes

# v0.0.18 11/02/2020 0h 44h

- Changed the host configuration when delivering emails
- Added handlebars gem

# v0.0.17 11/02/2020 1h

- Improved admin ui
  - Resources lists are now optimized (eager loading)
  - Customized course event list and show

# v0.0.16 08/02/2020 3h

- Added search text field to course event table
  - You can filter rows with the new search text field. Notice that filter is persisted so if you navigate then come 
    back, it will be retrieved from vuex. 
- Completed profile section
- Customized default vuetify colors:
  - Entry point with style parameters in app/views/users/index.html.erb which you can customize colors and dark mode 

# v0.0.15 06/02/2020 1h

- Several fixes
  - Fixed JsonWebToken: secret token now is obtained from credentials
  - Fixed confirmation url used in the confirmation email
  - Fixed password controller

# v0.0.14 06/02/2020 4h

- Sending email account confirmation and password reset via sendgrid
  - New mailer to create the json with the necessary data for the mailmerge to be executed through the external service
    Register to app.sendgrid.com and get your apikey, write it into the app credential `rails credentials:edit`
    Create your template and put down the {{ variables }}: firstname, application_name and link_url
- New entity system log

# v0.0.13 01/02/2020 3h

- Frontend
  - Improved event card lite
    - Fixed an image issue, now it remains inside the card and it has a max height
    - Image now is shown dinamically depending on the course, zumba is the default image. Added yoga image.
    - Reduced the informations on the card
  - Added a button in the show course event to go back to the dashboard
  - Course events table now show only one row on mobile
- Backend
  - Added italian localization
  - Added more elements to seeds
  - Other little improvements

# v0.0.12 30/01/2020 1h

- Added new column subscribed to course events table
- Course events cards list now shows only subscribed events

# v0.0.11 29/01/2020 2h

- Added course events table to the dashboard to show all course events. The cards list will be turned into a selection
  list. Backend is ready, course events must be filtered with a computed.

# v0.0.10 25/01/2020 2,5h

- Added Course event show page which shows more details and where user can subscribes the course event
- Added new endpoint to subscribe / unsubscribe a course event

# v0.0.9 21/01/2020 2h

- Backend
  - Added course events API (controller methods and views)
- Frontend
  - Added course event module to store

# v0.0.8 20/01/2020 0,5h

- Fixed password validations on user model
- Added sass-loader dependency

# v0.0.7 18/01/2020 1,5h Bug

- Found a workaround for a rails bug including a ActiveSupport::Concern module
 - After the module JWTAuthenticable was included, the before action authenticate_request was not executed and
   the variabel current_user was not set.
 - Fixed AuthorizeApiRequest to work with user model
 - Several little fixes

# v0.0.6 18/01/2020 0,5h

- User Ui
  - Fixed sign up form and show profile view
- Backend
  - Added smtp configuration to development env

# v0.0.5 18/01/2020 1h

- Backend
  - Added validations to user model
  - Fixed an issue on registration controller: removed protect_from_forgery with: :null_session
  - Fixed typo birtdate on user model
  - Several improvements

# v0.0.4 18/01/2020 2h

- Backend
  - Added capability to use accepted language from the header
  - Added phone field to user
  - Fixed password issue for user set by the seed
  - Fixed labels from locales
 
# v0.0.3 17/01/2020 3h

- Fix a conflict with devise 4.7 and a custom class AuthenticateUser, it was renamed to AuthenticateApiUser
- Several fixes to api controllers and json views
- Customized Activeadmin with a brand new footer
- Added a config costant for the whole project
- Logo was down resized 

# v0.0.2 16/01/2020 4h

- Start customization vuetify
  - Signup form now manages only project fields. Login form is already ok.
  - Customized logo and favicon

# v0.0.1 14/01/2020 6h

- Added vue frontend. It compiles but it does not work yet

# v0.0.0 12/01/2020 2h

- New relationships between course schedules. Relation has_and_belongs_to has been removed
- Added Attendees uniqueness validation to avoid multiple subscriptions 
- Fixed a bug in the seed, now events and attendees are created

# v0.0.0 11/01/2020 4h

- Added state to each models
- Added main resources
- Added activeadmin
- Initial commit