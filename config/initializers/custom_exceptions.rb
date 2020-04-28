module Api
  # To catch custom exception
  class ConflictError < StandardError; end
  class BadRequestError < StandardError; end
end
