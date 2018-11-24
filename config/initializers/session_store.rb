# frozen_string_literal: true

Rails.application.config.session_store :cookie_store,
                                       key: '_reg_session',
                                       expire_after: 30.minutes
