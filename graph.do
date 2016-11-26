* ************************************************************************
* https://github.com/evpu
* Collapsing Survey Data to Preserve Variable and Value Labels (Stata)
* Sample graph using output data
* ************************************************************************

clear all
macro drop _all
cd "your_directory"

import delimited "output.csv", clear

* Rescale % of respondents who chose response_1 ("Hate seaweed") and response_2 ("Love seaweed")
replace response_1 = response_1 * 100
replace response_2 = response_2 * 100

* What is the simple average (across location and gender) for response_1 and response_2
sum response_1, meanonly
local mean_response_1 = r(mean)
di "`mean_response_1'"

sum response_2, meanonly
local mean_response_2 = r(mean)
di "`mean_response_2'"

* Basic graph specifications
local options graphregion(c(white) lw(thick) lc(white)) legend(region(lw(thick) lc(white))) ylabel(, angle(0) nogrid)

* Graph of response_1 and response_2 over location and gender with added lines for the averages
graph bar response_1 response_2, over(gender) over(location) `options' legend(order(1 "Hate Seaweed" 2 "Love seaweed") col(1) symx(8) ring(0) pos(11)) blabel(bar, pos(inside) format(%5.0f) c(white) size(medsmall)) bar(1, color(eltblue)) bar(2, color(navy))  yline(`mean_response_1', lc(eltblue) lw(medthick) lpattern(dash))  yline(`mean_response_2', lc(navy) lw(medthick) lpattern(dash))

* Add the averages to the axis
gr_edit .scaleaxis.add_ticks `=round(`mean_response_1')', custom tickset(major) editstyle(tickstyle(textstyle(color(black))) tickstyle(textgap(2)) tickstyle(show_ticks(no)))

gr_edit scaleaxis.add_ticks `=round(`mean_response_2')', custom tickset(major) editstyle(tickstyle(textstyle(color(black))) tickstyle(textgap(2)) tickstyle(show_ticks(no)))

graph export "seaweed.png", replace height(800)
