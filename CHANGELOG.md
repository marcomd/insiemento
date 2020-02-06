# CHANGELOG

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