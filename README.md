# Frepl

Frepl (Fortran REPL) is an experimental ruby-based REPL for Fortran,
that I wrote because I was trying to learn Fortran, and I find the feedback
loop you get with a REPL makes learning a language much easier and more
enjoyable.

There are a lot of deficiencies with this code, namely:

* Only knows how to classify/parse a limited set of Fortran
* IO is severely hampered; basically you can't do the I part.
I have some ideas about how to sort of accomplish this but
they are half-baked and convoluted. Also I'm not sure this is
even really that important.
* Parsing is pretty dumb. I think a real lexer/parser approach is not 
appropriate here, but there are definitely better ways to do what I'm doing.

## Project plans

* needs a `/bin` file
* needs tests (probably will have to define a way of simulating readline input)
* redefining a function or subroutine doesn't work yet
* users should be able to change the type of a variable
* custom type parsing probably doesn't work right now
* can't use modules; not sure how important this is

## Installation

Add this line to your application's Gemfile:

    gem 'frepl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install frepl

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/frepl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
