# -*- encoding: utf-8; indent-tabs-mode: nil -*-

use Date::Calendar::Strftime;
use Date::Calendar::Hijri::Names;
unit class Date::Calendar::Hijri:ver<0.0.1>:auth<cpan:JFORGET>
      does Date::Calendar::Strftime;

has Int $.year  where { $_ ≥ 1 };
has Int $.month where { 1 ≤ $_ ≤ 12 };
has Int $.day   where { 1 ≤ $_ ≤ 30 };
has Int $.daycount;
has Int $.day-of-year;
has Int $.day-of-week;
has Int $.week-number;
has Int $.week-year;

method BUILD(Int:D :$year, Int:D :$month, Int:D :$day) {
  $._chek-build-args($year, $month, $day);
  $._build-from-args($year, $month, $day);
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
my ($f0, $g0) = make-fct(     1,  1,         -1);
my ($f1, $g1) = make-fct(   325, 11,       -320);
my ($f2, $g2) = make-fct(10_631, 30, 58_442_583);

method _build-from-args(Int $year, Int $month, Int $day) {
  $!year   = $year;
  $!month  = $month;
  $!day    = $day;

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

  # storing derived attributes
  $!day-of-year = $doy;
  $!day-of-week = $dow;
  $!daycount    = $daycount;

  # computing week-related derived attributes TODO
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
$dt-greg   = $dt-hijri->to-date;

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


=head1 PROBLEMS AND KNOWN BUGS

As already stated, this module does not give the real Hijri dates, but
dates from a variant calendar  which follows closely, but imperfectly,
the Hijri calendar.

The  conversions are  valid before  sunset. It  is up  to the  user to
assert the  need of  incrementing the Hijri  date or  decrementing the
Gregorian date if the time of day is in the evening after sunset.

=head1 SEE ALSO

=head2 Raku Software

L<Date::Calendar::Strftime>
or L<https://github.com/jforget/raku-Date-Calendar-Strftime>

L<Date::Calendar::Gregorian>
or L<https://github.com/jforget/raku-Date-Calendar-Gregorian>

L<Date::Calendar::Julian>
or L<https://github.com/jforget/raku-Date-Calendar-Julian>

L<Date::Calendar::Hebrew>
or L<https://github.com/jforget/raku-Date-Calendar-Hebrew>

L<Date::Calendar::CopticEthiopic>
or L<https://github.com/jforget/raku-Date-Calendar-CopticEthiopic>

L<Date::Calendar::MayaAztec>
or L<https://github.com/jforget/raku-Date-Calendar-MayaAztec>

L<Date::Calendar::FrenchRevolutionary>
or L<https://github.com/jforget/raku-Date-Calendar-FrenchRevolutionary>

=head2 Perl 5 Software

L<Date::Hijri>

L<DateTime>

L<DateTime::Calendar::Hijri>

L<Date::Hijri::Simple>

L<Date::Converter>

=head2 Other Software

date(1), strftime(3)

F<calendar/cal-islam.el>  in emacs  or xemacs.

CALENDRICA 4.0 -- Common Lisp, which can be download in the "Resources" section of
L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>
(Actually, I have used the 3.0 version which is not longer available)

=head2 Books

Calendrical Calculations (Third or Fourth Edition) by Nachum Dershowitz and
Edward M. Reingold, Cambridge University Press, see
L<http://www.calendarists.com>
or L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>.

I<La saga des calendriers>, by Jean Lefort, published by I<Belin> (I<Pour la Science>), ISBN 2-90929-003-5
See L<https://www.belin-editeur.com/la-saga-des-calendriers>

=head1 AUTHOR

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2021 (c) Jean Forget, all rights reserved

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
