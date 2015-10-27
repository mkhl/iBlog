# iBlog

[![Build Status](https://travis-ci.org/innoq/iBlog.svg?branch=master)](https://travis-ci.org/innoq/iBlog)

Simple internal blogging/PPP solution, originally developed by @stilkov and @pgh.
iBlog is currently maintained by @mjansing.

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

## Interface to the rest of the world

### Auth

iBlog will look for (and blindly trust) the `REMOTE_USER`
HTTP header.  The content of this header is the name of the user
doing the particular request.  It is assumed that iBlog is
deployed behind some reverse proxy that duely authenticates
users, sets this header, and makes sure nobody from the outside
can set it.  If a request hits iBlog without `REMOTE_USER` set, the
hard-coded username `guest` is used, which is convenient for
local testing on a development machine.

### Naveed

iBlog provides Atom feeds for its content.  Some folks prefer
email (or short text messages or whatever), in particular, when
some new comment appears regarding some discussion they took part
in earlier.

iBlog does not send out such notifications itself, but leaves that job
to [Naveed](https://github.com/innoq/naveed) (or any other service
presenting the same interface as explained below).

Whenever a new comment appears, iBlog checks whether the
environment variable `IBLOG_NAVEED_URI` and `IBLOG_NAVEED_TOKEN`
both exist.  When one of them doesn't, nothing happens and all is
well (which may be what you want in your development environment
if you're up to different things).  If both do exist, a POST is
attempted to the `IBLOG_NAVEED_URI` (assumed to be HTTPS (or, if
you must, HTTP)).  That POST has headers (among others)

    Content-Type: application/x-www-form-urlencoded
    Authorization: Bearer xxx

(where xxx is replaced with the `IBLOG_NAVEED_TOKEN` content) and
the content form has the text field `sender`, one or more
`recipient`, a `subject` and, finally, a `body`.  If you can't
already guess what those are, let us mention that `sender` and
`recipient` are whatever iBlog received in the `REMOTE_USER`
headers (it's Naveed's job to figure out actual contact points).

During unavailability of the Naveed service, update notifications
are lost.
