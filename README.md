# Frepl

Frepl (Fortran REPL) is an experimental ruby-based REPL for Fortran,
that I wrote because I was trying to learn Fortran, and I find the feedback
loop you get with a REPL makes learning a language much easier and more
enjoyable.

You don't need to know ruby to use Frepl, but you do need to have ruby (at least version 2)
installed.

There are a lot of deficiencies with this code, namely:

* Only knows how to classify/parse a limited set of Fortran
* IO is severely hampered; basically you can't do the I part.
I have some ideas about how to sort of accomplish this but
they are half-baked and convoluted. Also I'm not sure this is
even really that important.
* Parsing is pretty dumb. I think a real lexer/parser approach is not 
appropriate here, but there are definitely better ways to do what I'm doing.

## Project plans

See issue tracker.

## Installation

Add this line to your application's Gemfile:

    gem 'frepl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install frepl

## Usage

You should be able to run `frepl` from the command line after having installed the gem.

Alternatively, if you have the source code, you can run `rake console` from the gem folder.

You will get a prompt, and you can just start typing Fortran, type `q` to quit.

```
> integer :: a = 1
> integer, dimension(:), allocatable :: b
> allocate(b(0:4))
> b = [1,2,3,4]
> write(*,*) a * b
           1           2           3           4
> q
```

You can see some repl commands by typing `f:help`. Not much going on there, currently.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/frepl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
