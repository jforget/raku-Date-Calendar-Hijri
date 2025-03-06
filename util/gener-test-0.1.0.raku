#!/usr/bin/env raku
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
# Générer les données de test pour 08-conv-old.rakutest et 09-conv-new.rakutest
#

use v6.d;
use Date::Calendar::Strftime:ver<0.1.0>;
use Date::Calendar::Aztec;
use Date::Calendar::Aztec::Cortes;
use Date::Calendar::Bahai;
use Date::Calendar::Bahai::Astronomical;
use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;
use Date::Calendar::Hebrew;
use Date::Calendar::Hijri;
use Date::Calendar::Gregorian;
use Date::Calendar::FrenchRevolutionary;
use Date::Calendar::FrenchRevolutionary::Arithmetic;
use Date::Calendar::FrenchRevolutionary::Astronomical;
use Date::Calendar::Julian;
use Date::Calendar::Julian::AUC;
use Date::Calendar::Maya;
use Date::Calendar::Maya::Astronomical;
use Date::Calendar::Maya::Spinden;
use Date::Calendar::Persian;
use Date::Calendar::Persian::Astronomical;

my %class =   a0 => 'Date::Calendar::Aztec'
            , a1 => 'Date::Calendar::Aztec::Cortes'
            , ba => 'Date::Calendar::Bahai'
            , be => 'Date::Calendar::Bahai::Astronomical'
            , gr => 'Date::Calendar::Gregorian'
            , co => 'Date::Calendar::Coptic'
            , et => 'Date::Calendar::Ethiopic'
            , fr => 'Date::Calendar::FrenchRevolutionary'
            , fa => 'Date::Calendar::FrenchRevolutionary::Arithmetic'
            , fe => 'Date::Calendar::FrenchRevolutionary::Astronomical'
            , he => 'Date::Calendar::Hebrew'
            , hi => 'Date::Calendar::Hijri'
            , jl => 'Date::Calendar::Julian'
            , jc => 'Date::Calendar::Julian::AUC'
            , m0 => 'Date::Calendar::Maya'
            , m1 => 'Date::Calendar::Maya::Astronomical'
            , m2 => 'Date::Calendar::Maya::Spinden'
            , pe => 'Date::Calendar::Persian'
            , pa => 'Date::Calendar::Persian::Astronomical'
            ;
my %midnight = ba => False
             , be => False
             , co => False
             , et => False
             , fr => True
             , fa => True
             , fe => True
             , gr => True
             , he => False
             , hi => False
             , jl => True
             , jc => True
             , pe => True
             , pa => True
             ;

my @new-maya;
my @new-others;

say '08-conv-coptic-old.rakutest, @data-others (and then @data-greg)';
gener-others('ba', 1444,  8,  3);
gener-others('be', 1444, 10,  1);
gener-others('co', 1444,  7, 23);
gener-others('et', 1440,  1, 16);
gener-others('fr', 1442,  3, 18);
gener-others('fa', 1444,  7, 27);
gener-others('fe', 1441,  4,  8);
gener-others('gr', 1444, 10, 24);
gener-others('he', 1445, 12, 17);
gener-others('jl', 1443,  6,  4);
gener-others('jc', 1444,  8, 18);
gener-others('pe', 1445, 10,  9);
gener-others('pa', 1444, 11, 17);
say '-' x 50;
say '08-conv-coptic-old.rakutest, @data-maya';
gener-maya('m0', 1444, 11, 13);
gener-maya('m1', 1440,  7, 14);
gener-maya('m2', 1443,  3,  4);
gener-maya('a0', 1442, 10, 25);
gener-maya('a1', 1441,  5, 24);
say '-' x 50;
say '09-conv-coptic-new.rakutest, @data-to-do and @data';
say @new-others.join("");
say '-' x 50;
say '09-conv-coptic-new.rakutest, @data-maya';
say @new-maya.join("");

sub gener-others($key, $year, $month, $day) {
  my Date::Calendar::Hijri $dh1 .= new(year => $year, month => $month, day => $day);
  my Date::Calendar::Hijri $dh0 .= new-from-daycount($dh1.daycount - 1);
  my     $d0  = $dh0.to-date(%class{$key});
  my     $d1  = $dh1.to-date(%class{$key});
  my Str $s0  = $d0 .strftime('"%A %d %b %Y"');
  my Str $s1  = $d1 .strftime('"%A %d %b %Y"');
  my Str $sh0 = $dh0.strftime('"%a %d %b %Y ☼"');
  my Str $sh1 = $dh1.strftime('"%a %d %b %Y ☼"');
  my Str $gr0 = $dh0.to-date.gist;
  my Str $gr1 = $dh1.to-date.gist;
  my Int $lg-s1 = 30;
  my Int $lg-sh = 19;
  if $s0 .chars < $lg-s1 { $s0  ~= ' ' x ($lg-s1 - $s0 .chars); }
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $sh0.chars < $lg-sh { $sh0 ~= ' ' x ($lg-sh - $sh0.chars); }
  if $sh1.chars < $lg-sh { $sh1 ~= ' ' x ($lg-sh - $sh1.chars); }
  my Str $day-x   = sprintf("%2d", $day);
  my Str $month-x = sprintf("%2d", $month);
  print qq:to<EOF>;
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s0, $sh0, "$gr0 shift to previous day")
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s1, $sh1, "$gr1 shift to daylight")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sh1, "$gr1 no problem")
  EOF

  $s0         = $d0 .strftime("%A %d %b %Y");
  $s1         = $d1 .strftime("%A %d %b %Y");
  my Str $sh  = $dh1.strftime("%a %d %b %Y");
  my Int $lg = 26;
  my Str $w0 = ''; if $s0.chars < $lg { $w0 = ' ' x ($lg - $s0.chars); }
  my Str $w1 = ''; if $s1.chars < $lg { $w1 = ' ' x ($lg - $s1.chars); }
  if %midnight{$key} {
    push @new-others, qq:to<EOF>;
       , ($year, $month-x, $day-x, after-sunset,   '$key', "$s0 ☽"$w0, "$sh ☽", "Gregorian: $gr0")
       , ($year, $month-x, $day-x, before-sunrise, '$key', "$s1 ☾"$w1, "$sh ☾", "Gregorian: $gr1")
       , ($year, $month-x, $day-x, daylight,       '$key', "$s1 ☼"$w1, "$sh ☼", "Gregorian: $gr1")
    EOF
  }
  else {
    push @new-others, qq:to<EOF>;
       , ($year, $month-x, $day-x, after-sunset,   '$key', "$s1 ☽"$w1, "$sh ☽", "Gregorian: $gr0")
       , ($year, $month-x, $day-x, before-sunrise, '$key', "$s1 ☾"$w1, "$sh ☾", "Gregorian: $gr1")
       , ($year, $month-x, $day-x, daylight,       '$key', "$s1 ☼"$w1, "$sh ☼", "Gregorian: $gr1")
    EOF
  }
}

sub gener-maya($key, $year, $month, $day) {
  my Date::Calendar::Hijri $dh1  .= new(year => $year, month => $month, day => $day);
  my Date::Calendar::Hijri $dh0 .= new-from-daycount($dh1.daycount - 1);
  my Date::Calendar::Hijri $dh2 .= new-from-daycount($dh1.daycount + 1);
  my Str $sh1 = $dh1 .strftime('"%a %d %b %Y ☼"');
  my Str $sh0 = $dh0.strftime('"%a %d %b %Y ☼"');
  my     $d0  = $dh0.to-date(%class{$key});
  my     $d1  = $dh1.to-date(%class{$key});
  my Str $s0  = $d0 .strftime('"%e %B %V %A"');
  my Str $s1  = $d1 .strftime('"%e %B %V %A"');
  my Str $l1  = $d0 .strftime( '%e %B ') ~ $d1.strftime( '%V %A');
  my Str $gr0 = $dh0.to-date.gist;
  my Str $gr1 = $dh1.to-date.gist;
  my Int $lg-s1 = 24;
  my Int $lg-sh = 19;
  if $s0 .chars < $lg-s1 { $s0  ~= ' ' x ($lg-s1 - $s0 .chars); }
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $sh0.chars < $lg-sh { $sh0 ~= ' ' x ($lg-sh - $sh0.chars); }
  if $sh1.chars < $lg-sh { $sh1 ~= ' ' x ($lg-sh - $sh1.chars); }
  my Str $day-x   = sprintf("%2d", $day);
  my Str $month-x = sprintf("%2d", $month);
  print qq:to<EOF>;
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s0, $sh0, "$gr0 shift to the previous date, wrong clerical date, should be $l1")
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s1, $sh1, "$gr1 wrong intermediate date, should be $l1")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sh1, "$gr1 no problem")
  EOF

  my Str $shz = $dh1.strftime('"%a %d %b %Y ☽"');
  $sh0        = $dh1.strftime('"%a %d %b %Y ☾"');
  $sh1        = $dh1.strftime('"%a %d %b %Y ☼"');
  $s0         = $d0 .strftime('"%e %B ') ~ $d1.strftime('%V %A"');
  $s1         = $d1 .strftime('"%e %B %V %A"');
  $lg-s1 = 20;
  if $s0 .chars < $lg-s1 { $s0  ~= ' ' x ($lg-s1 - $s0 .chars); }
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $shz.chars < $lg-sh { $shz ~= ' ' x ($lg-sh - $shz.chars); }
  if $sh0.chars < $lg-sh { $sh0 ~= ' ' x ($lg-sh - $sh0.chars); }
  if $sh1.chars < $lg-sh { $sh1 ~= ' ' x ($lg-sh - $sh1.chars); }
  push @new-maya, qq:to<EOF>;
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s0, $shz, "Gregorian: $gr0")
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s0, $sh0, "Gregorian: $gr1")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sh1, "Gregorian: $gr1")
  EOF
}

=begin pod

=head1 NAME

gener-test-0.1.0.raku -- Generation of test data

=head1 SYNOPSIS

  raku gener-test-0.1.0.raku > /tmp/test-data

copy-paste from /tmp/test-data to the tests scripts.

=head1 DESCRIPTION

This  program  uses  the  various  C<Date::Calendar::>R<xxx>  classes,
version 0.0.x and  API 0, to generate test data  for version 0.1.0 and
API 1 of the modules for the Hijri calendar. After the test
data  are generated,  check  them with  another  source (the  calendar
functions in Emacs, some websites, some Android apps). Please remember
that the other  sources do not care about sunset  (and sunrise for the
civil Maya  and Aztec calendars)  and that  you will have  to mentally
shift the results before the comparison.

And after  the data are  checked, copy-paste  the lines into  the test
scripts
C<08-conv-coptic-old.rakutest>,
and C<09-conv-ethiopic-new.rakutest>,
as described in the label just above the data lines.

=head2 Maya (and Aztec) dates

Just cut-and-paste  the lines into  the C<@data-maya> variable  of the
proper test file. Erase the comma in the first pasted line.

=head2 Other dates, test file for old conversions

Cut and past  the lines into the C<@data> variable  of the proper test
file.  Then,  from  this  variable,  select  the  lines  dealing  with
Gregorian dates,  cut-and-paste them into the  C<@data-greg> variable.
At the  end of  each line  dealing with  a Gregorian  date, add  a 9th
element,  which  is  the  Gregorian date  in  C<'YYYY-MM-DD'>  format.
Lastly, cut (and do not paste) the lines for the Hijri calendar (which
cannot be simultaneously version 0.0.2 and version 0.1.0).

Remove the first comma in the C<@data-greg> and C<@data> variables.

=head2 Other dates, test file for new conversions

Cut and past  the lines into the C<@data> variable  of the proper test
file. Erase the comma at the beginning of the first line of C<@data>.

All computed  dates are daylight  dates. So  it does not  matter which
version  and API  are  such  and such  classes.  Daylight dates  gives
exactly the  same results with version  0.1.0 / API 1  as with version
0.0.x / API 0.

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2024, 2025 Jean Forget, all rights reserved

This program is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
