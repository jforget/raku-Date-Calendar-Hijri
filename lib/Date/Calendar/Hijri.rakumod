# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Strftime;
use Date::Calendar::Hijri::Names;
use Date::Calendar::Strftime;

unit class Date::Calendar::Hijri:ver<0.1.0>:auth<zef:jforget>:api<1>
      does Date::Calendar::Strftime;

has Int $.year  where { $_ ≥ 1 };
has Int $.month where { 1 ≤ $_ ≤ 12 };
has Int $.day   where { 1 ≤ $_ ≤ 30 };
has Int $.daycount;
has Int $.daypart where { before-sunrise() ≤ $_ ≤ after-sunset() };
has Int $.day-of-year;
has Int $.day-of-week;
has Int $.week-number;
has Int $.week-year;

method BUILD(Int:D :$year, Int:D :$month, Int:D :$day, Int :$daypart = daylight()) {
  $._chek-build-args($year, $month, $day);
  $._build-from-args($year, $month, $day, $daypart);
}

method _chek-build-args(Int $year, Int $month, Int $day) {
  unless 1 ≤ $month ≤ 12 {
    X::OutOfRange.new(:what<Month>, :got($month), :range<1..12>).throw;
  }
  my $limit =  month-days($year, $month);
  unless 1 ≤ $day ≤ $limit {
    X::OutOfRange.new(:what<Day>, :got($day), :range("1..$limit for this month and this year")).throw;
  }
}

# See "la Saga des Calendriers", page 155
#                                                   -1
# The "$g" functions are actually the "fₙ⁻¹" (or  "f  " functions, but I am not sure how to create raku identifiers with superscripts.
#                                                   n
my ($f0, $g0) = make-fct(     1,  1,         -1);
my ($f1, $g1) = make-fct(   325, 11,       -320);
my ($f2, $g2) = make-fct(10_631, 30, 58_442_583);

method _build-from-args(Int $year, Int $month, Int $day, Int $daypart) {
  $!year    = $year;
  $!month   = $month;
  $!day     = $day;
  $!daypart = $daypart;

  # computing derived attributes
  my Int $daycount   = $f2($year) + $f1($month) + $f0($day) - jd-to-mjd();
  my Int $dow        = 1 + ($daycount + 3) % 7;
  # The JD (*un*modified Julian Day) for 1 Muharram same year is
  # $f2($year) + $f1( 1 ) + $f0( 1 )
  # but $f1( 1 ) == $f0( 1 ) == 0, so the JD of 1 Muharram is simply $f2($year).
  # By subtracting it from the formula for the computed day, there are $nb days
  # between 1 Muharram and the target day, where $nb == $f1($month) + $f0($day).
  # Add 1 and you have the day-of-year value.
  my Int $doy        = 1 + $f1($month) + $f0($day);
  if $daypart == after-sunset() {
    # after computing $doy and $dow, not before!
    --$daycount;
  }

  # storing derived attributes
  $!day-of-year = $doy;
  $!day-of-week = $dow;
  $!daycount    = $daycount;

  # computing week-related derived attributes
  my Int $doy-arbi'a = $doy - $dow + 4; # day-of-year value for the nearest Yaum al-Arbi'a / Wednesday
  my Int $week-year  = $year;
  if $doy-arbi'a ≤ 0 {
    -- $week-year;
    $doy       += year-days($week-year);
    $doy-arbi'a = $doy - $dow + 4;
  }
  else {
    my $year-length = year-days($week-year);
    if $doy-arbi'a > $year-length {
      $doy       -= $year-length;
      $doy-arbi'a = $doy - $dow + 4;
      ++ $week-year;
    }
  }
  my Int $week-number = ($doy-arbi'a / 7).ceiling;

  # storing week-related derived attributes
  $!week-number = $week-number;
  $!week-year   = $week-year;
}


method gist {
  sprintf("%04d-%02d-%02d", $.year, $.month, $.day);
}

method month-name {
  Date::Calendar::Hijri::Names::month-name($.month);
}

method month-abbr {
  Date::Calendar::Hijri::Names::month-abbr($.month);
}

method day-name {
  Date::Calendar::Hijri::Names::day-name($.day-of-week - 1);
}

method day-abbr {
  Date::Calendar::Hijri::Names::day-abbr($.day-of-week - 1);
}

method new-from-date($date) {
  $.new-from-daycount($date.daycount, daypart => $date.?daypart // daylight);
}

method new-from-daycount(Int $count is copy, Int :$daypart = daylight) {
  if $daypart == after-sunset() {
    ++$count;
  }
  # See "la Saga des Calendriers", page 155
  my Int $JJ     = $count + jd-to-mjd();
  my Int $yyyy   = $g2($JJ);
  my Int $R2     = $JJ - $f2($yyyy);
  my Int $mm     = $g1($R2);
  my Int $R1     = $R2 - $f1($mm);
  my Int $dd     = $g0($R1);
  $.new(year => $yyyy, month => $mm, day => $dd, daypart => $daypart);
}

method to-date($class = 'Date') {
  # See "Learning Perl 6" page 177
  my $d = ::($class).new-from-daycount($.daycount, daypart => $.daypart);
  return $d;
}

sub month-days(Int $year, Int $month --> Int) {
 return 29 if $month ==  2 | 4 | 6 | 8 | 10;
 return 29 if $month == 12 && ! is-leap($year);
 return 30;
}

sub year-days(Int $year --> Int) {
 return 355 if is-leap($year);
 return 354;
}

sub is-leap(Int $year --> Any) {
  return True if $year % 30 == 2 | 5 | 7 | 10 | 13 | 16 | 18 | 21 | 24 | 26 | 29;
  return False;
}

# See "la Saga des Calendriers", page 155
sub make-fct(int $a, int $b, int $c) {
  my $f = sub (int $x) { (($a × $x + $c         ).Rat / $b).floor };
  my $g = sub (int $x) { (($b × $x + $b - 1 - $c).Rat / $a).floor };
  return $f, $g;
}

sub jd-to-mjd {
  2_400_001;
}


=begin pod

=head1 NAME

Date::Calendar::Hijri - Arithmetic variant of the Hijri calendar

=head1 SYNOPSIS

Converting a Gregorian date (e.g. 7th February 2021) into Hijri

=begin code :lang<raku>

use Date::Calendar::Hijri;
my Date $dt-greg;
my Date::Calendar::Hijri $dt-hijri;

$dt-greg  .= new(2021, 2, 7);
$dt-hijri .= new-from-date($dt-greg);

say $dt-hijri;
# --> 1442-06-24
say $dt-hijri.strftime("%A %d %B %Y");
# --> Yaum al-Ahad 24 Jumaada al-Thaani 1442

=end code

Converting a Hijri date (e.g. 1 Muharram 1443) into Gregorian

=begin code :lang<raku>

use Date::Calendar::Hijri;
my Date::Calendar::Hijri $dt-hijri;
my Date $dt-greg;

$dt-hijri .= new(year => 1443, month => 1, day => 1);
$dt-greg   = $dt-hijri.to-date;

say $dt-greg;
# --> 2021-08-10

=end code

=head1 DESCRIPTION

The real Hijri calendar is  an observational calendar. That means that
calendar events, such as switching from a month to the next, depend of
the observation  of some  astronomical events,  such as  observing the
moon crescent after a new moon.  But there is an unofficial arithmetic
variant, which differs from the real one by one or two days.

Date::Calendar::Hijri is a class  representing dates in the arithmetic
variant of the  Hijri calendar. It allows you to  convert a Hijri date
into Gregorian (or possibly other) calendar and the other way.

=head1 METHODS

=head2 Constructors

=head3 new

Create an Hijri date by giving the year, month and day numbers.

=head3 new-from-date

Build an  Hijri date  by cloning  an object  from another  class. This
other   class    can   be    the   core    class   C<Date>    or   any
C<Date::Calendar::>R<xxx> class with a C<daycount> method.

=head3 new-from-daycount

Build an Hijri date from the Modified Julian Day number.

=head2 Accessors

=head3 gist

Gives a short string representing the date, in C<YYYY-MM-DD> format.

=head3 year, month, day

The numbers defining the date.

=head3 month-name

The month of the date, as a string.

=head3 month-abbr

The month of the  date, as a 3-char string.

=head3 day-name

The name of the day within the week.

=head3 daycount

Convert  the date  to Modified  Julian Day  Number (a  day-only scheme
based on 17 November 1858).

=head3 day-of-week

The number of the day within the  week (1 for Sunday / Yaum al-Ahad, 7
for Saturday / Yaum al-Sabt).

=head3 week-number

The number of the week within the year, 1 to 50 or 1 to 51. Similar to
the "ISO  date" as defined  for Gregorian date.  Week number 1  is the
Sun→Sat span that contains the first Wednesday / Yaum al-Arbi'a of the
year,  week number  2 is  the Sun→Sat  span that  contains the  second
Wednesday / Yaum al-Arbi'a of the year and so on.

=head3 week-year

Mostly similar  to the C<year>  attribute. Yet,  the last days  of the
year  and  the  first  days  of the  following  year  can  be  sort-of
transferred  to the  other year.  The C<week-year>  attribute reflects
this transfer. While  the real year always begins on  1st Muharram and
ends on the 29th or 30th Thu al-Hijjah, the C<week-year> always begins
on  Sunday /  Yaum  al-Ahad and  it  always ends  on  Saturday /  Yaum
al-Sabt.

=head3 day-of-year

How many  days since  the beginning of  the year. 1  to 354  on normal
years, 1 to 355 on leap years.

=head2 Other Methods

=head3 to-date

Clones  the   date  into   a  core  class   C<Date>  object   or  some
C<Date::Calendar::>R<xxx> compatible calendar  class. The target class
name is given  as a positional parameter. This  parameter is optional,
the default value is C<"Date"> for the Gregorian calendar.

To convert a date from a  calendar to another, you have two conversion
styles,  a "push"  conversion and  a "pull"  conversion. For  example,
while converting "11  Thu al-Qi`dah 1440" to  the French Revolutionary
calendar, you can code:

=begin code :lang<perl6>

use Date::Calendar::Hijri;
use Date::Calendar::FrenchRevolutionary;

my  Date::Calendar::Hijri               $d-orig;
my  Date::Calendar::FrenchRevolutionary $d-dest-push;
my  Date::Calendar::FrenchRevolutionary $d-dest-pull;

$d-orig .= new(year  => 1440
             , month =>   11
             , day   =>   11);
$d-dest-push  = $d-orig.to-date("Date::Calendar::FrenchRevolutionary");
$d-dest-pull .= new-from-date($d-orig);

=end code

When converting  I<from> the core  class C<Date>, use the  pull style.
When converting I<to> the core class C<Date>, use the push style. When
converting from  any class other  than the  core class C<Date>  to any
other  class other  than the  core class  C<Date>, use  the style  you
prefer. For the Gregorian calendar, instead of the core class C<Date>,
you can use the  child class C<Date::Calendar::Gregorian> which allows
both push and pull styles.

=head3 strftime

This method is  very similar to the homonymous functions  you can find
in several  languages (C, shell, etc).  It also takes some  ideas from
C<printf>-similar functions. For example

=begin code :lang<perl6>

$df.strftime("%04d blah blah blah %-25B")

=end code

will give  the day number  padded on  the left with  2 or 3  zeroes to
produce a 4-digit substring, plus the substring C<" blah blah blah ">,
plus the month name, padded on the right with enough spaces to produce
a 25-char substring. Thus, the whole  string will be at least 42 chars
long. By  the way, you  can drop the  "at least" mention,  because the
longest month name  is 17-char long, so the padding  will always occur
and will always include at least 8 spaces.

A C<strftime> specifier consists of:

=item A percent sign,

=item An  optional minus sign, to  indicate on which side  the padding
occurs. If the minus sign is present, the value is aligned to the left
and the padding spaces are added to the right. If it is not there, the
value is aligned to the right and the padding chars (spaces or zeroes)
are added to the left.

=item  An  optional  zero  digit,  to  choose  the  padding  char  for
right-aligned values.  If the  zero char is  present, padding  is done
with zeroes. Else, it is done wih spaces.

=item An  optional length, which  specifies the minimum length  of the
result substring.

=item  An optional  C<"E">  or  C<"O"> modifier.  On  some older  UNIX
system,  these  were used  to  give  the I<extended>  or  I<localized>
version  of  the date  attribute.  Here,  they rather  give  alternate
variants of the date attribute. Not used with the Hijri calendar.

=item A mandatory type code.

The allowed type codes are:

=defn %A

The full day of week name.

=defn %b

The abbreviated month name.

=defn %B

The full month name.

=defn %d

The day of the month as a decimal number (range 01 to 30).

=defn %e

Like C<%d>, the  day of the month  as a decimal number,  but a leading
zero is replaced by a space.

=defn %f

The month as a decimal number (1  to 12). Unlike C<%m>, a leading zero
is replaced by a space.

=defn %F

Equivalent to %Y-%m-%d (the ISO 8601 date format)

=defn %G

The "week year"  as a decimal number. Mostly similar  to C<%Y>, but it
may differ  on the very  first days  of the year  or on the  very last
days. Analogous to the year number  in the so-called "ISO date" format
for Gregorian dates.

=defn %j

The day of the year as a decimal number (range 001 to 355).

=defn %m

The month as a two-digit decimal  number (range 01 to 12), including a
leading zero if necessary.

=defn %n

A newline character.

=defn %t

A tab character.

=defn %u

The day of week as a 1..7 number.

=defn %V

The week  number as defined above,  similar to the week  number in the
so-called "ISO date" format for Gregorian dates.

=defn %Y

The year as a decimal number.

=defn %%

A literal `%' character.


=head1 PROBLEMS AND KNOWN BUGS

As already stated, this module does not give the real Hijri dates, but
dates from a variant calendar  which follows closely, but imperfectly,
the Hijri calendar.

The  conversions are  valid before  sunset. It  is up  to the  user to
assert the  need of  incrementing the Hijri  date or  decrementing the
Gregorian date if the time of day is in the evening after sunset.

The month  names and  the day  names are  transcribed from  the Arabic
script  to  the Latin  script.  There  are  several methods  for  this
transcription.  So  the names  in  this  module  may differ  from  the
transcribed names you find in other places.

=head1 SEE ALSO

=head2 Raku Software

L<Date::Calendar::Strftime|https://raku.land/zef:jforget/Date::Calendar::Strftime>
or L<https://github.com/jforget/raku-Date-Calendar-Strftime>

L<Date::Calendar::Gregorian|https://raku.land/zef:jforget/Date::Calendar::Gregorian>
or L<https://github.com/jforget/raku-Date-Calendar-Gregorian>

L<Date::Calendar::Julian|https://raku.land/zef:jforget/Date::Calendar::Julian>
or L<https://github.com/jforget/raku-Date-Calendar-Julian>

L<Date::Calendar::Hebrew|https://raku.land/zef:jforget/Date::Calendar::Hebrew>
or L<https://github.com/jforget/raku-Date-Calendar-Hebrew>

L<Date::Calendar::CopticEthiopic|https://raku.land/zef:jforget/Date::Calendar::CopticEthiopic>
or L<https://github.com/jforget/raku-Date-Calendar-CopticEthiopic>

L<Date::Calendar::MayaAztec|https://raku.land/zef:jforget/Date::Calendar::MayaAztec>
or L<https://github.com/jforget/raku-Date-Calendar-MayaAztec>

L<Date::Calendar::FrenchRevolutionary|https://raku.land/zef:jforget/Date::Calendar::FrenchRevolutionary>
or L<https://github.com/jforget/raku-Date-Calendar-FrenchRevolutionary>

L<Date::Calendar::Persian|https://raku.land/zef:jforget/Date::Calendar::Persian>
or L<https://github.com/jforget/raku-Date-Calendar-Persian>

L<Date::Calendar::Bahai|https://raku.land/zef:jforget/Date::Calendar::Bahai>
or L<https://github.com/jforget/raku-Date-Calendar-Bahai>

=head2 Perl 5 Software

L<Date::Hijri|https://metacpan.org/pod/Date::Hijri>

L<DateTime|https://metacpan.org/pod/DateTime>

L<DateTime::Calendar::Hijri|https://metacpan.org/pod/DateTime::Calendar::Hijri>

L<Date::Hijri::Simple|https://metacpan.org/pod/Date::Hijri::Simple>

L<Date::Converter|https://metacpan.org/pod/Date::Converter>

=head2 Other Software

date(1), strftime(3)

C<calendar/cal-islam.el>  in emacs  or xemacs.

CALENDRICA 4.0 -- Common Lisp, which can be download in the "Resources" section of
L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>
(Actually, I have used the 3.0 version which is not longer available)

L<https://api.kde.org/4.14-api/kdelibs-apidocs/kdecore/html/kcalendarsystemislamiccivil_8cpp_source.html>
Since the KDE version number will change, you should rather use a search engine:
L<https://html.duckduckgo.com/html?q=calendarsystemislamiccivil%20KDElibs>

=head2 Books

Calendrical Calculations (Third or Fourth Edition) by Nachum Dershowitz and
Edward M. Reingold, Cambridge University Press, see
L<http://www.calendarists.com>
or L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>.

I<La saga des calendriers>, by Jean Lefort, published by I<Belin> (I<Pour la Science>), ISBN 2-90929-003-5
See L<https://www.belin-editeur.com/la-saga-des-calendriers>

=head2 Internet

L<Claus Tøndering's FAQ|https://www.tondering.dk/claus/cal/islamic.php>.

L<https://www.funaba.org/cc>

L<https://en.wikipedia.org/wiki/Islamic_calendar>

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright 2021, 2024 (c) Jean Forget, all rights reserved

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
