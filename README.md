# Collapsing Survey Data to Preserve Variable and Value Labels
Survey or public opinion data in raw format comes at the individual respondent level. In Stata, typically each response variable corresponds to a particular question (as a sample example, a question like "Do you love seaweed?") where possible answers are codded numerically with assigned value labels. For example: 

    1 Hate seaweed
    2 Love seaweed
    3 Replied: "Indifferent"
    4 Replied: "Refuse to answer
    5 What's that?

When dealing with this data, one would often want to collapse it to some aggregate level. For instance, to obtain the average responses for a given country. This is easy to do by hand for a couple of variables.

However, when the number of variables becomes large and all of them have different value labels, code in "collapse survey data.do" will help to streamline the process and resolve a number of issues.

First and foremost, it collapses variables to the desired level of aggregation (in the sample example, by location and by gender) using appropriate population weights (since a poll is just a small sample of the population, typically weights are used to make this sample more consistent with the general population characteristics by assigning more weight to some respondents and less to others). The code also keeps the variable labels (i.e. the description of the variables) and the value labels (description of possible responses) and assigns them to the newly created aggregate variables. In the sample example, variable responce_1 has label "Do you love seaweed?: Hate seaweed", etc.

The code relies on the ssc package "labutil2", which helps to resolve occasional problems when several variables are using the same value labels (in this case Stata command "label list" might return empty result). And helps to manage special characters (" and ') in variable and value labels.

For more information on how to work with public opinion data in Stata, see: http://www.stata.com/manuals13/svy.pdf

## Seaweed in Atlantis and Proxima b
As an illustrative example, file "input.csv" has some fictional data from Atlantis and Proxima b where respondents were asked whether they love seaweed. Some peculiar trends can be observed when considering the breakdown by gender. In Atlantis men seem to be strongly in favor of seaweed with 39% of the respondents replying that they love it, while only 17% said that they hate it. Women in Atlantis seems to be rather ambivalent about this delicious food with 27% of the respondents saying that they hate it and 21% saying the opposite. Proxima b appears to be a world of large contrasts. While 46% of women profess their love for seaweed, 63% of men say they absolutely hate it. Overall, a simple average of responses across the two locations and genders indicates a slightly greater preference towards seaweed with 35% on average loving it and 30% hating it.

![Seaweed in Atlantis and Proxima b, by Gender](https://raw.githubusercontent.com/evpu/Collapsing-Survey-Data-Stata/master/seaweed.png)
