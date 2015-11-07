# Frepl

Frepl (Fortran REPL) is an experimental ruby-based REPL for Fortran,
that I wrote because I was trying to learn Fortran, and I find the feedback
loop you get with a REPL makes learning a language much easier and more
enjoyable.

You don't need to know ruby to use Frepl, but you do need to have ruby (at least version 2)
installed.

There are a lot of deficiencies with this code, namely:

* Only knows how to classify/parse a limited set of Fortran.
* IO is severely hampered; basically you can't do the I part.
I have some ideas about how to sort of accomplish this but
they are half-baked and convoluted. Also I'm not sure this is
even really that important.
* Parsing is pretty dumb. It uses complicated and somewhat opaque regexes in places
where a real lexer/parser approach might be more appropriate, though might also be
overkill.

## Project plans

See issue tracker.

## Known issues

* Frepl is only able to correctly classify a subset of legal Fortran. At the same time,
Frepl will also happily accept some illegal Fortran, and wait for the compiler to tell you
about the problem. The UX here is not great.
* When specifying parameter and dimension in a declaration, parameter must currently come first,
e.g. `integer, parameter, dimension(:) :: a`.
* only `do... end do` loops are supported
* no support for labels; hence, no GOTO and its ilk

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

### Redefine a function, change the type of a variable, etc.

```
> integer :: a = 1
> a = 3
           3
> real a
> a = 5
   5.00000000
> integer function sum(a, b)
>   integer, intent(in) :: a, b
>   sum = a + b
>   end function
> write(*,*) sum(1,2)
           3
> real function sum(a, b, c)
>   real, intent(in) :: a, b, c
>   sum = a + b + c
>   end function
> write(*,*) sum(1.0,2.9,3.4)
   7.30000019
>
```

### Undo the last statement

Type `f:z` (z as in cmd+z for undo). Handy when you made an error, e.g.

```
> integer :: a =3
> real :: b
> b = 'fo'
frepl_out.f90:5.4:

b = 'fo'
    1
Error: Can't convert CHARACTER(1) to REAL(4) at (1)

> f:z
> b = 3.4
   3.40000010
>
```

You can see some repl commands by typing `f:help`. Not much going on there, currently.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/frepl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
