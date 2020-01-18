# CHANGELOG

# V0.0.3 17/01/2020 3h

- Fix a conflict with devise 4.7 and a custom class AuthenticateUser, it was renamed to AuthenticateApiUser
- Several fixes to api controllers and json views
- Customized Activeadmin with a brand new footer
- Added a config costant for the whole project
- Logo was down resized 

# V0.0.2 16/01/2020 4h

- Start customization vuetify
  - Signup form now manages only project fields. Login form is already ok.
  - Customized logo and favicon

# V0.0.1 14/01/2020 6h

- Added vue frontend. It compiles but it does not work yet

# V0.0.0 12/01/2020 2h

- New relationships between course schedules. Relation has_and_belongs_to has been removed
- Added Attendees uniqueness validation to avoid multiple subscriptions 
- Fixed a bug in the seed, now events and attendees are created

# V0.0.0 11/01/2020 4h

- Added state to each models
- Added main resources
- Added activeadmin
- Initial commit