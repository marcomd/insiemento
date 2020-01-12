class User < ApplicationRecord



  STATES = { just_made: 10, active: 20, suspended: 30}
  enum state: STATES

end
