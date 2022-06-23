---
title: "RubricSheet"
author: "Peter Bradley"
date: "6/23/2022"
output: pdf_document
---



## Core Competency Scoring Rubric


### Collaboration - COLL4

**COL4 Conflict Resolution**: Collaboration – COL2 Facilitate Others – Students engages team members in ways that facilitate their contributions to meetings by both constructively building upon or synthesizing the contributions of others as well as noticing when someone is not participating and inviting them to engage.


```r
rubricTable <- data.frame("Level"=c("#### 4 - Advanced\n\nAdvanced performances exceed the expectations for Ferris graduates. This work shows an effective and well-developed response to the learning outcome. These students represent the strongest fraction of our graduates.",
					 "#### 3 - Proficient\n\nProficient performances meet the expectations for Ferris graduates. This work demonstrates a sufficient response to the learning outcome with regard to scope and accuracy. All students are expected to attain this level of ability by graduation.",
					 "#### 2 - Progressing\n\nDeveloping performances approach the expectations for Ferris graduates. Although this work is more accomplished than that of novices, the scope and accuracy of the response does not yet satisfactorily address the learning outcome. This should be true of most first and second year students.",
					 "#### 1 - Beginning\n\nBeginning performances do not meet the expectations for Ferris graduates. This work exhibits a novice level of ability with regard to addressing the learning outcome. This is the expected skill level for our incoming first year students",
					 "#### 0 - Unsatisfactory\n\nUnsatisfactory performances neither meet the expectations for Ferris graduates nor those for incoming freshmen. This work exhibits profound deficiencies and/or is incomplete."),
		   "Description"=c(myCompetencyDF[myrow,]$value4, myCompetencyDF[myrow,]$value3, myCompetencyDF[myrow,]$value2, myCompetencyDF[myrow,]$value1, myCompetencyDF[myrow,]$value0))

kable(rubricTable)
```

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Level </th>
   <th style="text-align:left;"> Description </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> #### 4 - Advanced

Advanced performances exceed the expectations for Ferris graduates. This work shows an effective and well-developed response to the learning outcome. These students represent the strongest fraction of our graduates. </td>
   <td style="text-align:left;"> Advanced: Addresses destructive conflict directly and constructively, helping to manage/resolve it in a way that strengthens overall team cohesiveness and future effectiveness. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> #### 3 - Proficient

Proficient performances meet the expectations for Ferris graduates. This work demonstrates a sufficient response to the learning outcome with regard to scope and accuracy. All students are expected to attain this level of ability by graduation. </td>
   <td style="text-align:left;"> Proficient: Identifies and acknowledges conflict and stays engaged with it. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> #### 2 - Progressing

Developing performances approach the expectations for Ferris graduates. Although this work is more accomplished than that of novices, the scope and accuracy of the response does not yet satisfactorily address the learning outcome. This should be true of most first and second year students. </td>
   <td style="text-align:left;"> Progressing: Redirecting focus toward common ground, toward task at hand (away from conflict). </td>
  </tr>
  <tr>
   <td style="text-align:left;"> #### 1 - Beginning

Beginning performances do not meet the expectations for Ferris graduates. This work exhibits a novice level of ability with regard to addressing the learning outcome. This is the expected skill level for our incoming first year students </td>
   <td style="text-align:left;"> Beginning: Passively accepts alternate viewpoints/ideas/opinions. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> #### 0 - Unsatisfactory

Unsatisfactory performances neither meet the expectations for Ferris graduates nor those for incoming freshmen. This work exhibits profound deficiencies and/or is incomplete. </td>
   <td style="text-align:left;"> Unsatisfactory: Does not help to manage or resolve conflict within the group. </td>
  </tr>
</tbody>
</table>
