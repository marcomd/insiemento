# CHANGELOG

# v0.36.2 20/08/2020

- ScheduleService now selects CourseSchedule ordered by date and time
  - The query that selects course schedule did not apply any sorting and if they were placed in random order, 
    for example Monday, then Friday then again Monday, the week of creation of the events progressed and 
    it was not what was expected.

# v0.36.1 19/08/2020

- Fixed CourseSchedule next_event_datetime that now considers time zone

# v0.36.0 18/08/2020

- Inhibited user cancellation of the reservation when too late
  - Prevent the cancellation of the reservation close to the start time of the event

# v0.35.0 18/08/2020

- Improved the gym management in the admin ui
  - All forms now show only data of the admin user's organization

# v0.34.0 18/08/2020

- Fixed many relationships between models in the admin ui and other minor fixes
  - Admin users section can now update firstname and lastname
  - Fixed organization's default value
  - Destroying resources with a foreign key now generate errors shown in the admin ui

# v0.33.1 17/08/2020

- Fixed error message on the frontend due to recent updates on the backend 

# v0.33.0 17/08/2020

- Added custom images, contacts and social to homepage
  - Added the possibility to load the main image used by background in the hero section in the homepage
  - Added the new section "Carousel" to the homepage which shows a variable number of images
  - Added the new section "Business info" to the homepage to show a bio, contacts and urls to socials
  - All the new informations has been added to the admin ui as well
  - Added the possibility to disable the bookability's check

# v0.32.0 14/08/2020

- Improved user booking for course events
  - It now uses the course booking parameters and it is possible inhibit users from booking before or after the 
    time window
- Added a footer in the homepage with a summary and the privacy section

# v0.31.0 13/08/2020

- Fixed course events list
  - Now only course events of the current organization are fetched

# v0.30.3 09/08/2020

- Fixed the domain used in the url included in the email for the account confirmation and in the reset password
  - Now the url use the domain or subdomain of the user's organization. Previously it was always the main domain.

# v0.30.2 08/08/2020

- Removed dependent nullify on relationships user -> orders, it was useless due to the foreign key. Atm orders must be
  deleted manually before remove a user
- Renamed host to insiemento.com

# v0.30.1 08/08/2020

- Updated node to 12.x

# v0.30.0 08/08/2020

- Updated ruby to 2.6.6 and other gems

# v0.29.0 08/08/2020

- Improved admin ui for scheduling management
  - Now it is possible to suspend and reactivate individual course schedules, when they are in suspended state 
    the event is not generated for the following week.
  - Disabled the access to the store in the sidebar until it will fixed and more tested  

# v0.28.4 08/08/2020

- Fixed models relationships and fixed course scheduler job
  - Now it is possible to delete an organization with all its stuff
  - Now you can delete a course schedule but use it carefully, it will delete all course events related to it!
  - Now only active course schedule will create a new course event

# v0.28.3 07/08/2020

- Added redis url to sidekiq config 

# v0.28.2 07/08/2020

- Added sidekiq configuration

# v0.28.1 07/08/2020

- Fixed organization homepage attributes name
  - Fixed the storext attributes name in the organization model
  - Fixed names used by the admin ui and by the frontend

# v0.28.0 02/08/2020 4h

- Standard hompage and registration
  - The application controller now selects organization by uuid in the query string. 
  - The application mailer, that previously retrieve the organization by the ENV, now retrieve it bye the user with the new rules.
  - The registration controller now sign up users in the current organization
  - Now the standard homepage (insiemento.com) does not show registration and login button. The login and the sidebar
    in the header was removed as well. Other minor fixes.
  - Cleaned session js which now simply return response, the vue component do the rest

# v0.27.4 31/07/2020

- Replace the host param with domains in the config yaml
  - In the config file the param host has been replaced with an array of domains. The current_organization in the
    application controller now use this new param to retrieve the organization custom attributes. 

# v0.27.3 31/07/2020

- Fixed standard domains management

# v0.27.2 30/07/2020

- Fixed root path
  - Removed index.html from public folder

# v0.27.1 28/07/2020

- Minor fixes

# v0.27.0 27/07/2020

- Added homepage customization for each organizations
  - Now each organization can customize its own homepage from the admin UI
  - Added a new json field to organization with which customize the homepage
  - Added a new array of json with which define features to show in the homepage
  - Added uuid to organization
  - Current organization is now set by domain as well

# v0.26.0 23/07/2020

- Homepage changes dynamically according to the organization
  - Homepage changes dynamically according to the current organization. This is set by env variable or bu subdomain.
    If organization is not set, the insiemento homepage is shown.
  - New insiemento logo with size 100 and default color shown in the homepage when no organization is set
  - Application controller now set organization by the subdomain in the request

# v0.25.0 22/07/2020

- Updated several gems and js package
  - updated rails to 6.0.3.2
  - updated rack to 2.2.3
  - updated loadash to 4.17.19

# v0.24.0 22/07/2020 1,5h

- Improved homepage
  - Now the homepage is composed of various sections to better illustrate the characteristics of the project and offer better results for marketing
  - New logo
  - Other little improvements

# v0.23.0 19/07/2020 0,5h

- Added medical certificate management
  - Added medical certificate attachment to user
  - Added medical certificate expire at to user
  - Updated the admin UI

# v0.22.0 07/06/2020 0,5h

- Improved seed which now creates events on the next week
- Course events controller now also applies a filter on the event date

# v0.21.0 07/06/2020 1h

- Improved user calendar with real subscribed events

# v0.20.0 02/06/2020 1,5h

- Users UI improved with a calendar
  - The list of course events has been moved to a dedicated "Courses" section, also available in the side menu.
  - The dashboard now only shows a calendar with your appointments (to be completed with real data)
  - Little improvements to several API output

# v0.19.1 02/06/2020

- Updated many gems
  - rails from 6.0.2.2 to 6.0.3.1
  - activeadmin from 2.6 to 2.7
  - kaminari and other

# v0.19.0 22/05/2020 12h

- Backend
  - Added STI subclasses to Payment, each one to manage their own type:
    - StripePayment currently the focus is on this. After creation stripe service is called to create the payment intent
     and to store the response in a new field. The most importand data is the client secret to confirm the payment.
    - PaypalPayment coming soon
    - BankTransferPayment coming soon
  - Added two new fields to payment: type to manage sti and external_service_response to store the output json from the
    called service.
  - Added the payment to the order json
  - Added the custom json validator
  - Updated the seed to fill the payment with a fake stripe response
- Frontend
  - Added the payment section with multiple choice: Stripe, Paypal and bank transfer (but these last two are disabled atm)
  - Added the plugin vue-stripe-elements-plus to pay order with stripe and accept credit card
  - Updated vuetify to 2.2.29

# v0.18.0 09/05/2020 1h

- Added snackbar component to show instant message
- Fixed a bug in the order checkout
- Updated vuetify from 2.2.18 to 2.2.27 and vuex from 3.1.3 to 3.3.0 

# v0.17.2 09/05/2020

- Added docker support

# v0.17.1 28/04/2020

- Fix to payment controller

# v0.17.0 27/04/2020 20h

- Added orders management to users UI
  - Frontend
    - Added the products management:
      - The list view where you can select products
      - The show view to get the product details and to add it to the cart. Multiple products can be added to cart.
      - Added the vuex module product to interact with the api and added the mixin to share the code
    - Added the orders management: 
      - The show view that provides an order summary and allows you to set the "start on" date
  - Backend
    - Added the order controller with the json view   
    - Added the product controller with the json view   
    - Added the payment controller (to be completed...)
    - Added the stripe gem and its configuration

# v0.16.4 13/04/2020 0h

- Removed organization's logo thumbnail since vips image processing is not currently available on heroku

# v0.16.3 13/04/2020 0h

- Several little improvements
  - Customized minicolors javascript and removed coffeescript gem

# v0.16.2 12/04/2020 0h

- Several bugfixes

# v0.16.1 12/04/2020 0h

- Added S3 configuration 

# v0.16.0 12/04/2020 1h

- Admin UI
  - Now is possible to load the organization logo
  - Added image processing with vips
  - In the organization form, color pickers have been added to allow you to choose the hue
  - Added two new sections under diagnostic for root admins to manage attachments:
    - Active storage attachments
    - Active storage blobs
- User UI
  - Fixed icon on the alert message popup
  - The logo shown is the one loaded from the admin interface
  
# v0.15.0 11/04/2020 1,5h

- Added new resource "OrderProduct"
  - Added the new resource order product that replace habtm relation. Now an order has many products through many order
    products
- Improved admin UI
  - Added tabs to order form. In one tab products management has been added. 
- Updated the order.set_amounts! method and the way it is used
- Improved dependent destroy to many models
- Updated ability and specs

# v0.14.0 05/04/2020 0,5h

- Improved all money fields management
  - The money management is now delegated to money gem that was already present but not used

# v0.13.0 05/04/2020 2,5h

- Improved orders and payments management
  - Improved admin UI with customized forms and with nested inputs to manage some resources
  - Fixed a bug in the order class, now updated payment update the parent order
  - Fixed the ability to manage create for all resources. Previously this operation was inhibited
  - Improved and fixed payment specs
  
# v0.12.0 05/04/2020 1,5h

- Completed orders and payments management
  - Subscriptions are now created after the order is completed (which means paid)
  - Added a date `start_on` on the order to specify when subscriptions have to start from
  - Improved specs

# v0.11.0 04/04/2020 11h

- Added orders and payments
  - An order can have many products (many to many) and many payments (one to many. 
  - When the amount to pay is equal to the amount payed, the order is completed. Next step will be to create 
    subscriptions from purchased products after an order has been completed.
  - Added the two new resources and several improvements to the Admin UI
- Improved spec with shoulda, factory bot and VCR
- Updated seed with new resources

# v0.10.1 28/03/2020 0h

- Little improvement to admin UI and updated circleci configuration 
  - Added firstname and lastname to admin user management
  - Added dm:migrate after deploy on master branch

# v0.10.0 22/03/2020 1h

- Improved admin UI users management
  - Users, in the admin UI, has now a custom view with on the right the list of active subscriptions
  - Subscriptions can now be associated to user by dynamic search
- Added activeadmin addons to the project  
- Several little improvements

# v0.9.0 22/03/2020 0,5h

- Improved admin UI management #3
  - Added new fields to admin users: firstname, lastname, trackable fields (sign in date and ip)
  - Added roles of admin users to the form only available for root admin users

# v0.8.1 21/03/2020 0,5h

- Updated many node modules

# v0.8.0 21/03/2020 0,5h

- Improved admin UI management #2
  - Fixed the ability's bug: defined the method current ability in the application controller
  - Customized the section to manage users 
- Updated several gems: Rails to 6.0.2.2, pg to 1.2.3, cancancan to 3.1

# v0.7.0 14/03/2020 10h

- Improved admin UI management
  - Added roles to admin users
    - With root role: admin can manage all resources of all organizations
    - With manager or accountant role: admins can manage only their organization, any other organizations are hidden
    - Added rules to the ability class to manage authorizations.
      Unfortunately, a bug was found that forced an escamotage to obtain the desired result. 
      The ability class is instantiated twice, the second without passing the admin user which effectively prevents
      from applying the rules. The trick is to store the admin user of the previous instance in a class variable. 
      I added a technical debt in order to find a definitive solution. 
  - Improved all index of all resources, some form and some show
    - Many views have been customized, from the activeadmin default to a tailored view
    - Filters have been customized with different solutions for root and non root admin users
  - Added categories, products and subscriptions relation to organization
  - Added many relationship methods (categories, courses etc.) to admin user to show the organization data depending on
    the role
  - Improved localization
    - Admin UI now accept params `locale` in the query string to change the default language
    - All resources which have the state now show localized names
    - Course schedule now shows a localized day of the week 
- Improved favicon
  - Added favicon to backend UI and added a gray favicon for non production environment
- Updated activeadmin from 2.6 to 2.6.1
  - Updated also related gems 
- Several minor improvements

# v0.6.2 13/03/2020 0,5h

- Fixed a bug in the subscription list
- Improved courses list which now preload category

# v0.6.1 13/03/2020 0,5h

- Emails are now sent with organization domain
  - Previously were sent with the insiemento domain. In the future this may be a feature based on the organization's fee

# v0.6.0 07/03/2020 5h

- Added new models to manage products:
  - Categories: courses and subscriptions classification, which means what the user can attendee
  - Products: things a user can buy to extend his attending
  - Subscriptions: when a user buys a subscription product, this grant him access to courses
- Added new models management to admin UI  
- Added category reference to course, course_schedule and course_event model  
- Updated seed:
  - Added a second organization
  - Added categories, products and subscriptions
- Added subscription validation to attendee model
  - Before create an attendee now a validation check on subscription is performed. The user must have an active
    subscription of the same category. 

# v0.5.1 01/03/2020 0,5h

- Fixed registration
  - Now users are created with current organization attributes
- When users unsubscribes courses which never subscribed now a message is shown. It is a situation we would avoid but
  now backend manages it correctly.   

# v0.5.0 29/02/2020 4h 60h

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