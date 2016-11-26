* ************************************************************************
* https://github.com/evpu
* Collapsing Survey Data to Preserve Variable and Value Labels (Stata)
* 
* This program collapses survey data (e.g. public opinion) while creating variable labels
* It deals with special characters in labels (like ' and ")
* and problems when Stata "label list" command does not see value labels.
* Sample dataset provides an illustrative example.
* 
* Package required:
* ssc install labutil2
* ************************************************************************

clear all
macro drop _all
cd "your_directory"

ssc install labutil2

* Sample dataset: load and encode all string variables.
* (as they are typically presented in public opinion data in Stata)
import delimited "input.csv", clear
encode input_response, generate(response)
encode input_gender, generate(gender)
label var response "Do you love seaweed?"


* Specifiy in locals variables of interest. For extract_what and collapse_on can list several variables
local extract_what "response"
local collapse_on "location gender"
local weights weight


* ************************************************************************

* create lists of variables to be extracted with "_*" at the end
foreach var of varlist `extract_what' {
	local star "`star' `var'_*" 
}
local star "`=trim("`star'")'" 


* create dummy variables
* and store labels and value labels in memory
foreach var of varlist `extract_what' {

	xi i.`var', noomit

	*correct error with value labels having names of other variables
		labellist `var'
		if "`r(_lblname)'" != "`r(varlist)'" {
			label copy `r(_lblname)' `r(varlist)', replace
		}

	* store value labels
	foreach var2 of varlist _I`var'* {
		* store labels for later
		local temp1 : variable label `var2'
		local temp2 = strpos("`temp1'","=")
		local temp3 = substr("`temp1'", `temp2'+2, .)
		local l_`=substr("`var2'", 3, .)': label `var' `temp3'
		* correct errors in code when " in label text is causing problems
		local l_`=substr("`var2'", 3, .)' = subinstr(`"`l_`=substr("`var2'", 3, .)''"', char(34),  "", .)
		* correct errors in code when ' in label text is causing problems
		local l_`=substr("`var2'", 3, .)' = subinstr("`l_`=substr("`var2'", 3, .)''","'"," ",.)
		* rename variable (drop prefix)
		rename `var2' `=substr("`var2'", 3, .)'
	}
	* store general variable labels
	local temp4: variable label `var'
	* correct errors in code when " in label text is causing problems
	local l_`var' = subinstr(`"`temp4'"', char(34),  "", .)
	* correct errors in code when ' in label text is causing problems
	local l_`var' = subinstr("`l_`var''","'"," ",.)
}


* COLLAPSE
keep `star' `collapse_on' `weights' 
collapse `star' [pw = `weights'], by(`collapse_on')


* Assign labels
foreach var of varlist `star' {
	* this is in case the original variable name already had an _ (eg name_1)
	local temp5 = strpos(subinstr("`var'", "_", "!", 1), "_")
	if strpos(subinstr("`var'", "_", "!", 1), "_")==0 {
		local temp5 = strpos("`var'","_")
	}
	local temp6 = substr("`var'", 1, `temp5'-1)
	label variable `var' "`=substr("`l_`temp6''", 1, 60)': `l_`var''"
}

* ************************************************************************

export delimited using "output.csv", replace
