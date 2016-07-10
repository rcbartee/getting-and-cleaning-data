## CodeBook for tidy.txt

[tidy.txt](tidy.txt) (named such to represent the goal of the course) is
a data set derived from the accelerometer data extracted from Samsung
Galaxy S smartphones found here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


Refer to their documentation for a description of the original data set.
What follows is a description of how tidy.txt was derived from that
data, with all differences noted.

#### Features

Features from features.txt are brought into tidy.txt as columns.  We
are interested only in the features that represent an average or a
standard deviation.  To that end, they are filtered through a regular
expression that matches all features that contain Mean, mean, Std, or
Std:

    [Mm]ean|[Ss]td
    
All "special" characters are replaced by '.'.  Multiple special
characters in a row are replaced by a single dot.  Special characters
at the end of the name are simply removed. Here are some
examples:

  - tBodyAcc-mean()-X becomes tBodyAcc.mean.X
  - angle(X,gravityMean) becomes angle.X.gravityMean


#### Activities

Activities in tidy.txt are represented by their descriptive name
(activity.name) instead of their id.  There are no transformations
applied to the name.


#### Subjects

Subjects in tidy.txt are represented by their id (subject.id).  You will
notice that subject names are not provided in the original data set.

#### Feature measurement values

The feature values in tidy.txt are an aggregated mean by activity and
subject.  That is, multiple measurements by any subject made for each
activity are all averaged together to shorten the number of
observations.


#### tidy.txt Construction

The original data set has two sub folders (test and train) with similar
structures.  In each folder the subject, X, and Y data sets are combined
by column into a single data set.  The features from features.txt are
used for column names in the X data sets.  After they are all combined,
the test and train data sets look like:

    > str(test)
    'data.frame':	2947 obs. of  563 variables:
     $ subject.id                          : int  2 2 2 2 2 2 2 2 2 2 ...
     $ activity.id                         : int  5 5 5 5 5 5 5 5 5 5 ...
     $ tBodyAcc.mean...X                   : num  0.257 0.286 0.275 0.27 0.275 ...
     $ tBodyAcc.mean...Y                   : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
     $ tBodyAcc.mean...Z                   : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
     ... etc

You will notice that feature names are not yet fully transformed as
described above.

From here the test and train data sets are row combined so that all
subjects are represented now in a single data set.

activity.names later replace activity.id as defined above.

With the original data sets all combined into a single one, the mean
aggregate by activity name and subject is applied so that the final
tidy.txt data set looks like:

    > str(tidy)
    'data.frame':	180 obs. of  88 variables:
     $ activity.name                      : Factor w/ 6 levels "LAYING","SITTING",..: 1 2 3 4 5 6 1 2 3 4 ...
     $ subject.id                         : int  1 1 1 1 1 1 2 2 2 2 ...
     $ tBodyAcc.mean.X                    : num  0.222 0.261 0.279 0.277 0.289 ...
     $ tBodyAcc.mean.Y                    : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
     $ tBodyAcc.mean.Z                    : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
     etc... 
     