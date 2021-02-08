unit class Date::Calendar::Hijri:ver<0.0.1>;


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

=head1 AUTHOR

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2021 (c) Jean Forget, all rights reserved

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
