install.packages("lubridate") 
library(lubridate)

# x days from assigned date
diff <- make_difftime(days=150)
as.interval(diff, ymd("2018-05-02"))

update(date,year=2010, month=1,day=3)
update(date,year=2010, month=13,day=3)
update(date,minute=10,second=3)

# determine what day it is (Line 39)
x <- as.Date("2009-09-02")
wday(x)
yday(x)

wday(ymd(180502))

wday(ymd(180502), label =TRUE, abbr=FALSE)

wday(ymd(180502)+days(-2:3), label=TRUE, abbr=FALSE)

duration(1.5,"days")
duration("2D, 2H, 2M, 2S")

#Was it a leap year?
leap_year(2008)

# create objects of a class date
make_datetime(year = 1999, month=12, day=22, hour = c(10,11))
x <- seq.Date(as.Date("2009-08-02"),by="year", length.out = 2)
x


# Pretty dates ------------------------------------------------------------

pretty_dates(x,12)

pretty_dates(x,4)

# create time stamps
M <- ymd_hms("2018=05=01 10:00:00", tz="America/New_York") + weeks(0:6)
stamp("May 1, 2018")(M)
meeting <- stamp("Meet with Carol Tuesday May 1, 2018 at 10:00")
meeting(M)


# Turkey day picking ------------------------------------------------------

date <- ymd("2019-01-01")
month(date) <- 11
wday(date,label=TRUE)
date <- date+days(6)
date+weeks(3)
