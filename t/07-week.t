#
# Checking the week-related attributes
#
use v6.c;
use Test;
use Date::Calendar::Hijri;

my @tests = test-data;
plan 2 × @tests.elems;

for @tests -> $test {
  my ($y, $m, $d, $doy, $iso) = $test;
  my Date::Calendar::Hijri $d-hij .= new(year => $y, month => $m, day => $d);
  is($d-hij.day-of-year          , $doy);
  is($d-hij.strftime('%G-W%V-%u'), $iso);
}

done-testing;

sub test-data {
  return (
              # 1438 begins on Yaum al-Ithnain
              (1437, 12, 25, 350, '1437-W50-4') # ... Yaum al-Arbi'a 25 Thu al-Hijjah 1437
            , (1437, 12, 26, 351, '1437-W50-5') #     Yaum al-Khamees 26 Thu al-Hijjah 1437
            , (1437, 12, 27, 352, '1437-W50-6') #     Yaum al-Jumma 27 Thu al-Hijjah 1437
            , (1437, 12, 28, 353, '1437-W50-7') # ^^^ Yaum al-Sabt 28 Thu al-Hijjah 1437
            , (1437, 12, 29, 354, '1438-W01-1') # vvv Yaum al-Ahad 29 Thu al-Hijjah 1437
            , (1438,  1,  1,   1, '1438-W01-2') #     Yaum al-Ithnain 01 Muharram 1438
            , (1438,  1,  2,   2, '1438-W01-3') #     Yaum al-Thulatha 02 Muharram 1438
            , (1438,  1,  3,   3, '1438-W01-4') # ... Yaum al-Arbi'a 03 Muharram 1438
            , (1438,  1,  4,   4, '1438-W01-5') #     Yaum al-Khamees 04 Muharram 1438
            , (1438,  1,  5,   5, '1438-W01-6') #     Yaum al-Jumma 05 Muharram 1438
            , (1438,  1,  6,   6, '1438-W01-7') # ^^^ Yaum al-Sabt 06 Muharram 1438
              # 1439 begins on Yaum al-Jumma
            , (1438, 12, 25, 350, '1438-W51-1') # vvv Yaum al-Ahad 25 Thu al-Hijjah 1438
            , (1438, 12, 26, 351, '1438-W51-2') #     Yaum al-Ithnain 26 Thu al-Hijjah 1438
            , (1438, 12, 27, 352, '1438-W51-3') #     Yaum al-Thulatha 27 Thu al-Hijjah 1438
            , (1438, 12, 28, 353, '1438-W51-4') # ... Yaum al-Arbi'a 28 Thu al-Hijjah 1438
            , (1438, 12, 29, 354, '1438-W51-5') #     Yaum al-Khamees 29 Thu al-Hijjah 1438
            , (1439,  1,  1,   1, '1438-W51-6') #     Yaum al-Jumma 01 Muharram 1439
            , (1439,  1,  2,   2, '1438-W51-7') # ^^^ Yaum al-Sabt 02 Muharram 1439
            , (1439,  1,  3,   3, '1439-W01-1') # vvv Yaum al-Ahad 03 Muharram 1439
            , (1439,  1,  4,   4, '1439-W01-2') #     Yaum al-Ithnain 04 Muharram 1439
            , (1439,  1,  5,   5, '1439-W01-3') #     Yaum al-Thulatha 05 Muharram 1439
            , (1439,  1,  6,   6, '1439-W01-4') # ... Yaum al-Arbi'a 06 Muharram 1439
              # 1440 begins on Yaum al-Arbi'a
            , (1439, 12, 25, 350, '1439-W50-5') #     Yaum al-Khamees 25 Thu al-Hijjah 1439
            , (1439, 12, 26, 351, '1439-W50-6') #     Yaum al-Jumma 26 Thu al-Hijjah 1439
            , (1439, 12, 27, 352, '1439-W50-7') # ^^^ Yaum al-Sabt 27 Thu al-Hijjah 1439
            , (1439, 12, 28, 353, '1440-W01-1') # vvv Yaum al-Ahad 28 Thu al-Hijjah 1439
            , (1439, 12, 29, 354, '1440-W01-2') #     Yaum al-Ithnain 29 Thu al-Hijjah 1439
            , (1439, 12, 30, 355, '1440-W01-3') #     Yaum al-Thulatha 30 Thu al-Hijjah 1439
            , (1440,  1,  1,   1, '1440-W01-4') # ... Yaum al-Arbi'a 01 Muharram 1440
            , (1440,  1,  2,   2, '1440-W01-5') #     Yaum al-Khamees 02 Muharram 1440
            , (1440,  1,  3,   3, '1440-W01-6') #     Yaum al-Jumma 03 Muharram 1440
            , (1440,  1,  4,   4, '1440-W01-7') # ^^^ Yaum al-Sabt 04 Muharram 1440
            , (1440,  1,  5,   5, '1440-W02-1') # vvv Yaum al-Ahad 05 Muharram 1440
            , (1440,  1,  6,   6, '1440-W02-2') #     Yaum al-Ithnain 06 Muharram 1440
              # 1441 begins on Yaum al-Ahad
            , (1440, 12, 25, 350, '1440-W51-3') #     Yaum al-Thulatha 25 Thu al-Hijjah 1440
            , (1440, 12, 26, 351, '1440-W51-4') # ... Yaum al-Arbi'a 26 Thu al-Hijjah 1440
            , (1440, 12, 27, 352, '1440-W51-5') #     Yaum al-Khamees 27 Thu al-Hijjah 1440
            , (1440, 12, 28, 353, '1440-W51-6') #     Yaum al-Jumma 28 Thu al-Hijjah 1440
            , (1440, 12, 29, 354, '1440-W51-7') # ^^^ Yaum al-Sabt 29 Thu al-Hijjah 1440
            , (1441,  1,  1,   1, '1441-W01-1') # vvv Yaum al-Ahad 01 Muharram 1441
            , (1441,  1,  2,   2, '1441-W01-2') #     Yaum al-Ithnain 02 Muharram 1441
            , (1441,  1,  3,   3, '1441-W01-3') #     Yaum al-Thulatha 03 Muharram 1441
            , (1441,  1,  4,   4, '1441-W01-4') # ... Yaum al-Arbi'a 04 Muharram 1441
            , (1441,  1,  5,   5, '1441-W01-5') #     Yaum al-Khamees 05 Muharram 1441
            , (1441,  1,  6,   6, '1441-W01-6') #     Yaum al-Jumma 06 Muharram 1441
              # 1442 begins on Yaum al-Khamees
            , (1441, 12, 25, 350, '1441-W50-7') # ^^^ Yaum al-Sabt 25 Thu al-Hijjah 1441
            , (1441, 12, 26, 351, '1441-W51-1') # vvv Yaum al-Ahad 26 Thu al-Hijjah 1441
            , (1441, 12, 27, 352, '1441-W51-2') #     Yaum al-Ithnain 27 Thu al-Hijjah 1441
            , (1441, 12, 28, 353, '1441-W51-3') #     Yaum al-Thulatha 28 Thu al-Hijjah 1441
            , (1441, 12, 29, 354, '1441-W51-4') # ... Yaum al-Arbi'a 29 Thu al-Hijjah 1441
            , (1442,  1,  1,   1, '1441-W51-5') #     Yaum al-Khamees 01 Muharram 1442
            , (1442,  1,  2,   2, '1441-W51-6') #     Yaum al-Jumma 02 Muharram 1442
            , (1442,  1,  3,   3, '1441-W51-7') # ^^^ Yaum al-Sabt 03 Muharram 1442
            , (1442,  1,  4,   4, '1442-W01-1') # vvv Yaum al-Ahad 04 Muharram 1442
            , (1442,  1,  5,   5, '1442-W01-2') #     Yaum al-Ithnain 05 Muharram 1442
            , (1442,  1,  6,   6, '1442-W01-3') #     Yaum al-Thulatha 06 Muharram 1442
              # 1443 begins on Yaum al-Thulatha
            , (1442, 12, 25, 350, '1442-W50-4') # ... Yaum al-Arbi'a 25 Thu al-Hijjah 1442
            , (1442, 12, 26, 351, '1442-W50-5') #     Yaum al-Khamees 26 Thu al-Hijjah 1442
            , (1442, 12, 27, 352, '1442-W50-6') #     Yaum al-Jumma 27 Thu al-Hijjah 1442
            , (1442, 12, 28, 353, '1442-W50-7') # ^^^ Yaum al-Sabt 28 Thu al-Hijjah 1442
            , (1442, 12, 29, 354, '1443-W01-1') # vvv Yaum al-Ahad 29 Thu al-Hijjah 1442
            , (1442, 12, 30, 355, '1443-W01-2') #     Yaum al-Ithnain 30 Thu al-Hijjah 1442
            , (1443,  1,  1,   1, '1443-W01-3') #     Yaum al-Thulatha 01 Muharram 1443
            , (1443,  1,  2,   2, '1443-W01-4') # ... Yaum al-Arbi'a 02 Muharram 1443
            , (1443,  1,  3,   3, '1443-W01-5') #     Yaum al-Khamees 03 Muharram 1443
            , (1443,  1,  4,   4, '1443-W01-6') #     Yaum al-Jumma 04 Muharram 1443
            , (1443,  1,  5,   5, '1443-W01-7') # ^^^ Yaum al-Sabt 05 Muharram 1443
            , (1443,  1,  6,   6, '1443-W02-1') # vvv Yaum al-Ahad 06 Muharram 1443
              # 1444 begins on Yaum al-Sabt
            , (1443, 12, 25, 350, '1443-W51-2') #     Yaum al-Ithnain 25 Thu al-Hijjah 1443
            , (1443, 12, 26, 351, '1443-W51-3') #     Yaum al-Thulatha 26 Thu al-Hijjah 1443
            , (1443, 12, 27, 352, '1443-W51-4') # ... Yaum al-Arbi'a 27 Thu al-Hijjah 1443
            , (1443, 12, 28, 353, '1443-W51-5') #     Yaum al-Khamees 28 Thu al-Hijjah 1443
            , (1443, 12, 29, 354, '1443-W51-6') #     Yaum al-Jumma 29 Thu al-Hijjah 1443
            , (1444,  1,  1,   1, '1443-W51-7') # ^^^ Yaum al-Sabt 01 Muharram 1444
            , (1444,  1,  2,   2, '1444-W01-1') # vvv Yaum al-Ahad 02 Muharram 1444
            , (1444,  1,  3,   3, '1444-W01-2') #     Yaum al-Ithnain 03 Muharram 1444
            , (1444,  1,  4,   4, '1444-W01-3') #     Yaum al-Thulatha 04 Muharram 1444
            , (1444,  1,  5,   5, '1444-W01-4') # ... Yaum al-Arbi'a 05 Muharram 1444
            , (1444,  1,  6,   6, '1444-W01-5') #     Yaum al-Khamees 06 Muharram 1444
              # 1445 begins on Yaum al-Arbi'a
            , (1444, 12, 25, 350, '1444-W50-6') #     Yaum al-Jumma 25 Thu al-Hijjah 1444
            , (1444, 12, 26, 351, '1444-W50-7') # ^^^ Yaum al-Sabt 26 Thu al-Hijjah 1444
            , (1444, 12, 27, 352, '1445-W01-1') # vvv Yaum al-Ahad 27 Thu al-Hijjah 1444
            , (1444, 12, 28, 353, '1445-W01-2') #     Yaum al-Ithnain 28 Thu al-Hijjah 1444
            , (1444, 12, 29, 354, '1445-W01-3') #     Yaum al-Thulatha 29 Thu al-Hijjah 1444
            , (1445,  1,  1,   1, '1445-W01-4') # ... Yaum al-Arbi'a 01 Muharram 1445
            , (1445,  1,  2,   2, '1445-W01-5') #     Yaum al-Khamees 02 Muharram 1445
            , (1445,  1,  3,   3, '1445-W01-6') #     Yaum al-Jumma 03 Muharram 1445
            , (1445,  1,  4,   4, '1445-W01-7') # ^^^ Yaum al-Sabt 04 Muharram 1445
            , (1445,  1,  5,   5, '1445-W02-1') # vvv Yaum al-Ahad 05 Muharram 1445
            , (1445,  1,  6,   6, '1445-W02-2') #     Yaum al-Ithnain 06 Muharram 1445
              # 1446 begins on Yaum al-Ithnain
            , (1445, 12, 25, 350, '1445-W51-3') #     Yaum al-Thulatha 25 Thu al-Hijjah 1445
            , (1445, 12, 26, 351, '1445-W51-4') # ... Yaum al-Arbi'a 26 Thu al-Hijjah 1445
            , (1445, 12, 27, 352, '1445-W51-5') #     Yaum al-Khamees 27 Thu al-Hijjah 1445
            , (1445, 12, 28, 353, '1445-W51-6') #     Yaum al-Jumma 28 Thu al-Hijjah 1445
            , (1445, 12, 29, 354, '1445-W51-7') # ^^^ Yaum al-Sabt 29 Thu al-Hijjah 1445
            , (1445, 12, 30, 355, '1446-W01-1') # vvv Yaum al-Ahad 30 Thu al-Hijjah 1445
            , (1446,  1,  1,   1, '1446-W01-2') #     Yaum al-Ithnain 01 Muharram 1446
            , (1446,  1,  2,   2, '1446-W01-3') #     Yaum al-Thulatha 02 Muharram 1446
            , (1446,  1,  3,   3, '1446-W01-4') # ... Yaum al-Arbi'a 03 Muharram 1446
            , (1446,  1,  4,   4, '1446-W01-5') #     Yaum al-Khamees 04 Muharram 1446
            , (1446,  1,  5,   5, '1446-W01-6') #     Yaum al-Jumma 05 Muharram 1446
            , (1446,  1,  6,   6, '1446-W01-7') # ^^^ Yaum al-Sabt 06 Muharram 1446
              # 1447 begins on Yaum al-Jumma
            , (1446, 12, 25, 350, '1446-W51-1') # vvv Yaum al-Ahad 25 Thu al-Hijjah 1446
            , (1446, 12, 26, 351, '1446-W51-2') #     Yaum al-Ithnain 26 Thu al-Hijjah 1446
            , (1446, 12, 27, 352, '1446-W51-3') #     Yaum al-Thulatha 27 Thu al-Hijjah 1446
            , (1446, 12, 28, 353, '1446-W51-4') # ... Yaum al-Arbi'a 28 Thu al-Hijjah 1446
            , (1446, 12, 29, 354, '1446-W51-5') #     Yaum al-Khamees 29 Thu al-Hijjah 1446
            , (1447,  1,  1,   1, '1446-W51-6') #     Yaum al-Jumma 01 Muharram 1447
            , (1447,  1,  2,   2, '1446-W51-7') # ^^^ Yaum al-Sabt 02 Muharram 1447
            , (1447,  1,  3,   3, '1447-W01-1') # vvv Yaum al-Ahad 03 Muharram 1447
            , (1447,  1,  4,   4, '1447-W01-2') #     Yaum al-Ithnain 04 Muharram 1447
            , (1447,  1,  5,   5, '1447-W01-3') #     Yaum al-Thulatha 05 Muharram 1447
            , (1447,  1,  6,   6, '1447-W01-4') # ... Yaum al-Arbi'a 06 Muharram 1447
            );
}
