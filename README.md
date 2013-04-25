# iBlog

Simple internal blogging/PPP solution, originally developed by @stilkov and @pgh.
iBlog is currently maintained by @mrreynolds.

## Security note

Authors have full control of the HTML of their
individual blog post. There is no protection
against, e.g.,
[CSRF](http://en.wikipedia.org/wiki/Cross-site_request_forgery)
attacks. If you don't trust your authors, don't use this software.

## Getting Started

* create `config/database.yml` based on `config/database.template.yml` or
  `config/database.template_sqlite.yml`
* set up database: `bundle exec rake db:drop db:create db:migrate db:seed`
* launch server: `rails server`

## Contributing

Please use pull requests.
