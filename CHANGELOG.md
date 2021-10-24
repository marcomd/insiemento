# CHANGELOG

# v1.25.1 24/10/2021

- Bugfix course event broadcasting and other improvements
  - Now course event view update current object only if it is the same one propagated
  - Now course event subscription lock the object before update it
  - If subscription fails, the message is set according to subscribe param (true shows a message, false shows another
    message)

# v1.25.0 16/10/2021

- Deadline to cancel booking, best image selection and others improvements
  - The deadline by which a user can cancel the booking is now shown in the course event detail
  - The course event image is now selected based on best relevance and not by precise name  
  - Updated mdi/font icon set
  - Several improvements and bug fixes

# v1.24.0 10/10/2021

- Inhibition of booking due to a missed attendance
  - UpdateCourseEventsJob now update event state after 70 minutes to let the trainer to update presences, previously 
    was 15
  - New resource Penalty to configure penalties to assign to users that miss booked event. It is possible to set 
    the category to be inhibited and if the course is present, the inhibition will be restricted to this only.
  - New resource UserPenalty to inhibit users to book a new event until the end of the penalty
  - New PenaltyService and PenaltyJob which creates user penalties each time an attendee is missed
  - Added the index event_date to course_events table and now returned events are sorted by event date. Previously, they
    were sorted by id and any events entered manually after scheduling were shown in the wrong chronological order
  - Reservations are now inhibited if the user has an active penalty

# v1.23.0 25/09/2021

- Replaced dayjs with moment

# v1.22.0 21/09/2021

- Updated rails from 6.1.3 to 6.1.4 and other gems

# v1.21.4 21/09/2021

- Fixed a bug that occurred during registration
- Added viewed state to user document

# v1.21.3 29/05/2021

- Updated websocket configuration

# v1.21.2 23/05/2021

- Updated websocket configuration and many javascript plugins

# v1.21.1 23/05/2021

- Updated websocket configuration

# v1.21.0 23/05/2021

- Added websocket connection to provide server feedbacks in realtime
  - Now frontend connects to the server also by websocket action cable. This speed up data retrieving but over all
    it makes possible to broadcasting updates made by other users.
  - In the course event show page now you get, in real time, updates on attendees
  - Updated rails from 6.1.3.1 to 6.1.3.2
  - Updated puma from 5.2.2 to 5.3.2

# v1.20.3 18/04/2021

- Forced ssl for production environment

# v1.20.2 17/04/2021

- Updated a system file

# v1.20.1 17/04/2021

- Updated javascript plugins

# v1.20.0 17/04/2021

- Updated rails and other gems
  - Updated rails from 6.1.3 to 6.1.3.1
  - Updated nokogiri, marcel and other gems

# v1.19.0 15/03/2021

- Updated rails and puma
  - Updated rails from 6.1.2.1 to 6.1.3
  - Updated puma from 5.2.1 to 5.2.2
  - Executed active storage migrations
- In the profile, the birthdate selection starts with the year 

# v1.18.0 14/02/2021

- Customized the dashboard and other little improvements
  - Added users with expiring medical certificate
  - Added a line chart with the incoming expiring medical certificate
  - Added a column chart to show last registered users

# v1.17.0 13/02/2021

- Updated rails to 6.1

# v1.16.0 13/02/2021

- Updated many gems:
  - activeadmin from 2.8 to 2.9
  - puma from 5.1 to 5.2
  - nokogiri from 1.10 to 1.11
  - prawn from 2.3 to 2.4
  - sidekiq from 6.0 to 6.1
  - ... and many others

# v1.15.0 13/02/2021

- Replaced moment.js with dayjs

# v1.14.0 13/02/2021

- Updated many javascript plugins

# v1.13.0 03/01/2021

- Updated ruby to 2.7 and several gems
  - Updated ruby from 2.6.6 to 2.7.2
  - Updated puma from 5.0.4 to 5.1.1
  - Other minor updates

# v1.12.2 31/12/2020

- Several minor fixes on otp service api call

# v1.12.1 09/11/2020

- List items now are correctly updated without move their position in the list

# v1.12.0 31/10/2020

- Updated node, rails and many other gems
  - Updated node version from 12.18 to 14.15
  - Updated rails from 6.0.3.3 to 6.0.3.4
  - Updated puma from 4.3.5 to 5.0.4
  - Updated redis from 4.2.1 to 4.2.2
  - Updated activeadmin from 2.8.0 to 2.8.1
  - Updated warden from 1.2.8 to 1.2.9 and devise from 4.7.2 to 4.7.3

# v1.11.0 31/10/2020

- Improved the events generation
  - Added uniqueness validation on event time on CourseSchedule module. This avoid duplicated schedulations on the same
    event that will broke the event generation.
  - Organization separation on the schedule service. It now creates events for each organization and if something goes
    wrong only the current organization is affected.
  - Other little improvements

# v1.10.1 25/10/2020

- Improved authentication which now returns server errors
  - On the backend was improved authentication controller to show error messages from server
  - On the frontend was improved alert component to properly show array of messages

# v1.10.0 15/10/2020

- Added news management on backend and frontend
  - Added new resources "News" to show users any kind of information.
    - expire_on to set an expiration date after that state pass to expired
    - state: to manage news to show, only active state are shown
    - type: determine icon and color
    - dark style: set to true to use the color as background with white text
    - public: set to true to show on the homepage
    - private: set to true to show on the private user ui, after login
  - New section news on the homepage
  - The user ui show news on dashboard
  - New job to change news state to expired

# v1.09.2 05/10/2020

- Fixed some validations on edit profile
  - Fixed a bug on edit profile which didn't allow to continue without child data. Furthermore, numeric validation
    on phone number was added. Added numeric and length validations on phone number on user model on the backend as well 

# v1.09.1 01/10/2020

- Improved user document section in the admin ui
  - Added title and body to edit form
  - Added a new method to user document model to format child birthdate
  - Added the new method has_minor_child? to user model

# v1.09.0 01/10/2020

- Added child data to user
  - Now a parent or a guardian can insert data of its child, only one child for each user is allowed. If a user has
    more children he must create one account for each one. He can use email aliases to use the same email address.

# v1.08.1 30/09/2020

- Fixed email availability
  - Fixed a bug on a wrong exception type raised
  - Email availability now accepts address with a + like gmail aliases. To allow this email address is now escaped

# v1.08.0 29/09/2020

- Profile completion component, email availability and other improvements
  - Removed red asterisks for required fields since material design does not expect to show them
  - New component for profile completion alert which now is shown on course events list as well
  - SignUp form now check email availability
  - Other little improvements

# v1.07.0 27/09/2020

- Updated several javascript plugin

# v1.06.0 27/09/2020

- Pagination and other improvements
  - Course events and products list now save list options (page and per page items) on vuex to set them when user returns
  - Fixed two course images
  - Dashboard now propone a button to go to course events list when no one was selected
  - Search vuex params moved from layout module to course event and product (now both use a separate param)
- Added spring-commands-rspec to boost rspec boot  

# v1.05.0 23/09/2020

- Improved booking button in the course event detail
  - Now booking button is green to subscribe and red to unsubscribe

# v1.04.0 21/09/2020

- An admin can now impersonate a user on the frontend
  - Added a new link in the admin ui. Clicking on it, a new window will be opened with that user logged in the user ui.
    The token is valid for one hour. It is useful when an admin has to reply to a report of a user in need of failure.
- Little improvements in the user profile

# v1.03.0 20/09/2020

- Added attendees count to course events index in the admin ui
- It is no longer possible to booking on suspended courses (unsubscribing is still allowed) and closed as well

# v1.02.0 20/09/2020

- Suspended course events now are shown in the booking list on the users ui
  - When a course event is suspended (state to suspended) now a red chip in the course events list is shown
- Improved performance on course events list by adding a counter cache for the attendees count
- Removed sidekiq_options in ScheduleJob in order to find the cause for the NotImplementedError issue 

# v1.01.0 20/09/2020

- Updated terms and conditions, privacy and cookie policy
  - Added the cookie policy page
  - Updated content and improved pages to show content that now use a layout component
  - Each page show info of the related organization

# v1.00.0 17/09/2020

- The software has been in use for two weeks in production and can be considered stable so the major version
  increase to 1! Yeah (trumpet sounds)
- Two improvements on the admin ui
  - User details in the admin ui shows now not ended subscriptions as well
  - Added recurring attribute to user document param

# v0.59.2 16/09/2020

- Smtp switched to smtp2go

# v0.59.1 15/09/2020

- Gmail raises some weird errors in production, go back to sendgrid

# v0.59.0 15/09/2020

- Changed smtp from sendgrid to gmail due to rejected emails
  - Sendgrid is unreliable, icloud mail server rejected many emails due to listing in spamhaus SBL. 
    https://www.spamhaus.org/query/ip/50.31.49.42
    Some Sendgrid IP pools are blacklisted and when we send email from one of these it may be blocked, apple do it.
    SendGrid is unable to move account to a new IP pool. The way to do that is to get a dedicated IP on a Pro or higher plan. 
    https://sendgrid.com/docs/glossary/deny-list/

# v0.58.0 14/09/2020

- New UpdateUsersJob, course events closed 15 minutes later, updated schedulation times
  - New job to update user every day, it fires a query for each user but only if it have to be updated. This because
    the logic to update state is on the model. This may be changed in the future. 
  - The job which update course events state now leave events active for 15 more minutes, this allows the auditor 
    to update the attendance list from the user interface
  - Course events are now created on saturday 12.30pm
  - User documents are now created multiple times in the day hours

# v0.57.1 14/09/2020

- Fixed yarn.lock

# v0.57.0 14/09/2020

- Many improvements to user ui
  - Clicking on events in the calendar the course event list card is now shown
  - Added many new images for courses: gag, kangoo jumps, lab, street, total body etc.
  - The course event full card now show you the course image in the background
  - Removed nickname from trainer name, it now display only full name
  - Updated vuetify from 2.2.32 to 2.3.10

# v0.56.0 13/09/2020

- Added batch actions to resend user documents that have had an error

# v0.55.2 13/09/2020

- Changed active admin options
  - csv use now semicolon separator
- Updated several javascript plugins
- Fixed a bug in the user callback on the phone field

# v0.55.1 13/09/2020

- Fixed yarn.lock and updated several javascript plugin

# v0.55.0 13/09/2020

- User data are now better formatted and cleaned
  - email is now stripped, phone removed from blank spaces, first name and last name are now titleized

# v0.54.2 13/09/2020

- Fixed course event booking spec

# v0.54.1 13/09/2020

- Applied trim on email in the signup form and in the edit profile
- Updated vue to 2.6.12 

# v0.54.0 12/09/2020

- UserDocumentsManagerService selects user with completed profile
  - It is mandatory user had phone number in order to send user document to otp service for remote signing

# v0.53.0 12/09/2020

- UserDocumentsManagerService selects no ended subscriptions
  - UserDocumentsManagerService now selects users with a subscription ending in the future in new or active state
  - Added birthdate in the users section on the admin ui

# v0.52.0 12/09/2020

- Improved users section in the admin ui
  - Added the three state scopes to filter immediately the users list
  - Improved the insiemento homepage with the affiliate's url

# v0.51.0 12/09/2020

- Added analytics tag to each organization

# v0.50.1 12/09/2020

- Fixed birthdate validation on profile's edit

# v0.50.0 12/09/2020

- Now the check of the active subscription for the attendance to courses is performed on the date of the event.
  Previously it was done on the booking date.
- Updated active admin to 2.8.0

# v0.49.0 12/09/2020

- Terms and conditions, many improvements to user UI
  - Added new page Terms and conditions
  - Added a new checkbox in signup form to accept terms and conditions
  - Added profile completition alert shown if some data are missing
  - Added age validation in the profile completition
  - Improved english localization, some tags were missing
  - Improved subscriptions and attendees list in the profile section

# v0.48.0 11/09/2020

- Added sign checksum on user document and several fixes on admin ui
  - Added new field "sign checksum" on user document model
  - User document controller now update the new field. This is set by a callback from the external sign service and 
    it is used to inquiry the sign and check details
  - Added index on first and last name fields on the users table
  - Several fixes on admin ui: 
    - removed descriptions from list due to row too high
    - users are now searched by first/last name (previously was by email) and their full name is displayed
    - subscription form now filter products list by the selected category

# v0.47.0 09/09/2020

- New relationships "trainer" to user, added presence to attendee and audit actions
  - Backend
    - Added trainer id to user which it is now linked to trainer. This could also be considered as new role 
      act to audit course events. Using user resource allow us to reuse the login and the ui created for users.
    - Added the new field "presence" to attendee model
    - Added attendees list and audit action to course events controller
    - Added a new attendees section to admin ui to provide a history of partecipations and also presence in real time
  - Frontend
    - A user with a trainer can now show the list of attendance and audit them with the presence  

# v0.46.2 07/09/2020

- Fixed otpservice configuration

# v0.46.1 06/09/2020

- Fixed ScheduleJob spec

# v0.46.0 06/09/2020

- Improved self certification management, admin ui and other improvements
  - Added expire date and uuid to user document. Uuid is necessary to receive a callback from external service, to
    update the state
  - Added UserDocumentsManagerService to create user documents from active document and to change state to expired documents 
  - Added UserDocumentsManagerJob scheduled every morning
  - Added UserDocumentsController to receive external callback
  - The user's state now changes properly during saving, the state depends on active subscriptions
  - Fixed a bug in the create course events job (ScheduleJob)

# v0.45.1 30/08/2020

- Fixed a sidekiq issue
  - An error NoMethodError: undefined method `request_uri' for #<URI::Generic /api/v1/authenticate> was generated 
    due to the wrong parameter name "otpservice.host"

# v0.45.0 28/08/2020

- Added self certification management
  - Due to legal purpose, users must certificate they are covid free. Added two new resources:
    - UserDocumentModel: it contains the text of the document
    - UserDocument: it manages the document sendings to users through the external otp service
  - New service OtpService to allow users to sign document remotely
  - Several improvements to code, seeds and specs

# v0.44.2 27/08/2020

- Fixed smtp authentication
  - Added new smtp user and password inside credentials

# v0.44.1 27/08/2020

- Fixed a problem accessing the logo to attach to the email

# v0.44.0 27/08/2020

- Added internal email generation and switch to this from sendgrid
  - Added a new customized layout for confirmation and reset password email, this email are now generated internally
  - Emails have now organization's logo and colors

# v0.43.0 27/08/2020

- Added the footer in the homepage

# v0.42.1 26/08/2020

- Fixed the logo url in the meta tag

# v0.42.0 26/08/2020

- SEO attributes improved, analystics and other
  - Now each organization has its own attributes in order to correctly index the home page
  - Added google analytics
  - Other little improvements 

# v0.41.0 26/08/2020

- Added UpdateCourseEventJob and other improvements
  - Added new job UpdateCourseEventJob to close expired course events, every half hour
  - Added simplecov to check and monitor the coverage percentage
  - Added index to two course event fields: state and event date 
  - Relationship between SystemLog and Organization now is optional 

# v0.40.0 25/08/2020

- Added description to room, course event improvements on the frontend
  - Added new field description to room model, updated admin ui
  - Improved the user's ui with two tooltip showing the room's description and the trainer's bio
  - Fixed the search on the course event list, after the last update it does not found trainer anymore
  - Fixed the layout of the course event list view, now it shows the search on small display as well. Furthermore,
    the alignment was also fixed.
  - Improved returned json data, now includes only needed fields. Many fields, like created_at, on related resources
    like course, room etc, was removed to make json data lean. 
  - Other little improvements

# v0.39.0 25/08/2020

- Added new subscription info section
  - Backend
    - New subscription's routes and new controller
    - Little improvements to admin ui: added course events scopes
    - New method set_organization in the base controller 
  - Frontend  
    - New components used in the user profile that show the list of subscriptions with the main information
    - New subscription's module to use new api endpoint
    - Moved into the "pages" folder all components used in the router

# v0.38.0 22/08/2020

- Fixes and improvements to the frontend
  - Fixed reload bug in the course event list
    - Fixed the bug removind the double row in the router. Now after reload in the course event list, the view is still the
      same. Previously the view was switched with the dashboard.
  - Fixed a little bug in the show course event that wrote a error log: the component was shown before the data were ready
  - Added the course description in the course event show
  - Improved the trainer name shown in the course events list and in the show

# v0.37.2 22/08/2020

- Added validations to product and subscription

# v0.37.1 22/08/2020

- Improved products definition on the seed

# v0.37.0 22/08/2020

- Added new product / subscription types to manage pay-as-you-go as well as fee mode
  - Added type to products and subscriptions. It define types among the following: trial, consumption and fee.  
    Defined a method type s well. It returns a class with which manage specific task.
  - Added new relationship, one subscription to many attendees, used to count each attendee to course event
  - Added the logic to manage consumption products: pre-purchased accesses scaled at each access

# v0.36.4 20/08/2020

- Now get_user_domain return www + domain
  - The confirmation link on email sent by Sendgrid now has the correct url with www

# v0.36.3 20/08/2020

- Fixed the seed and two specs due to the last update on CourseSchedule ordered selection

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

- Standard homepage and registration
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