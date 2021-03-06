# anthro 0.9.4

## General

* Handling of age information is improved and loss of information from
  converting from age in days to age in months or vice verse is reduced.
* Some code improvements.

## Bugfix

* Fixed a bug where, observations where erroneously removed from prevalence
  computation. This happens if age in months was supplied, then values
  `> 59.992` months were considered `> 1826` days. Now anything above
  `60.009` months is considered `> 1826` days and thus excluded.

# anthro 0.9.3

## General

* Internal code improvements.

## Bugfix

* Z-scores are now only computed for `age < 60 months` instead of `age <= 60 months`.
* Z-scores for wfl were previously also computed when `age >= 60 months` and `<= 1856 days`.

# anthro 0.9.2

* Age in days is now rounded half to even (e.g. 730.5 days = 731) before joining
  the data with the reference values. This is in line with previous
  implementations and in particularly relevant for data points with
  age exactly 24 months. Previously the example above was converted to 730 days and with
  this release it is converted to 731 days (#17).
* The cleaned `measure` and `sex` variables are now part of the output
  data.frame of `anthro_zscores` (#20, #24).
* Removed `covr` from suggests dependencies.
* Fixed a typo in the docs (#15).

# anthro 0.9.1

* Initial release of the package.
