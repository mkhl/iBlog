# iBlog

Simple internal blogging/PPP solution, originally developed by the masters of disasters, PG & ST (@stilkov}. 
iBlog is currently maintained by robertg (@mrreynolds).

https://wiki.innoq.com/display/innoq/iBlog

## Getting Started

* create `config/database.yml` based on `config/database.template.yml` or
  `config/database.template_sqlite.yml`
* set up database: `bundle exec rake db:drop db:create db:migrate db:seed`
* launch server: `rails server`

## Contributing

Please use pull requests.
