use v6.c;
unit class Date::Calendar::Hijri::Names:ver<0.0.2>:auth<zef:jforget>:api<0>;

my @month-names = ( "Muharram"
                  , "Safar"
                  , "Rabi` al-Awal"
                  , "Rabi` al-Thaani"
                  , "Jumaada al-Awal"
                  , "Jumaada al-Thaani"
                  , "Rajab"
                  , "Sha`ban"
                  , "Ramadan"
                  , "Shawwal"
                  , "Thu al-Qi`dah"
                  , "Thu al-Hijjah"

);

my @month-abbr = < Muh Saf R.A R.T J.A J.T
                   Raj Sha Ram Shw Qid Hij >
;
my @day-names = ( "Yaum al-Ahad"
                , "Yaum al-Ithnain"
                , "Yaum al-Thulatha"
                , "Yaum al-Arbi'a"
                , "Yaum al-Khamees"
                , "Yaum al-Jumma"
                , "Yaum al-Sabt"
);

my @day-abbr = < Ahd Ith Thl Arb Kha Jum Sab >;

our sub month-name(Int:D $month --> Str) {
  return @month-names[$month - 1];
}

our sub month-abbr(Int:D $month --> Str) {
  return @month-abbr[$month - 1];
}

our sub day-name(Int:D $day7 --> Str) {
  return @day-names[$day7];
}

our sub day-abbr(Int:D $day7 --> Str) {
  return @day-abbr[$day7];
}


=begin pod

=head1 NAME

Date::Calendar::Hijri::Names - string values for the Hijri calendar

=head1 SYNOPSIS

=begin code :lang<perl6>

use Date::Calendar::Hijri;

=end code

=head1 DESCRIPTION

Date::Calendar::Hijri::Names  is a  utility  module, providing  string
values for the main module Date::Calendar::Hijri.

=head1 SOURCES

The names and abbreviations come from
L<https://api.kde.org/4.14-api/kdelibs-apidocs/kdecore/html/kcalendarsystemislamiccivil_8cpp_source.html>

Since the KDE version number will change, you should rather use a search engine:
L<https://html.duckduckgo.com/html?q=calendarsystemislamiccivil%20KDElibs>

=head1 SEE ALSO

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

=head2 Internet

L<Claus Tøndering's FAQ|https://www.tondering.dk/claus/cal/islamic.php>.

L<https://www.funaba.org/cc>

L<https://en.wikipedia.org/wiki/Islamic_calendar>

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2021, 2024 Jean Forget, all rights reserved

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
