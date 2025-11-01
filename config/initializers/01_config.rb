
Rails.application.configure do
  config.author      = 'Generic Author'
  config.author_home = 'http://www.heroku.com/'
  config.twitter_id  = '@isaiaspina'
  config.facebook_id = '297759137246012'
  config.site_url    = 'reg.herokuapp.com'

  config.default_url = 'https://reg.herokuapp.com'
  config.mailer_from_addr = 'Registro <registro@google.com>'
  config.letsencrypt = nil
end
