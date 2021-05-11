# frozen_string_literal: true

require "jwt"

class Auth
  ALG = "HS256"
  HMAC_SECRET = Rails.application.credentials.secret_key_base # Rails Cookies sign key

  class << self
    def generate_jwt(data = {})
      header = {
        alg: ALG,
        typ: "JWT"
      }

      payload = {
        iat: Time.now.to_i,
        jti: SecureRandom.uuid,
        payload: data
      }

      JWT.encode(payload, HMAC_SECRET, ALG, header)
    end

    def decode_jwt(jwt, just_data: true)
      jwt_options = {
        verify_expiration: true,
        algorithm: "HS256"
      }.freeze

      data = JWT.decode(jwt, HMAC_SECRET, true, jwt_options).first

      just_data ? data["payload"] : data
    rescue JWT::DecodeError => e
      Rails.logger.debug "Validate jwt: Failed - #{e.message}"
      raise
    end
  end
end
