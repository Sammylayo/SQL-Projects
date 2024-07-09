--View the tables
select *
from ProjectPortfolio..AmazonPersonalDetails person
join ProjectPortfolio..AmazonAccountInfo acc
on acc.[User ID] = person.[User ID]




--Change the Date of Birth, Membership start and end date to the proper date format
select cast([Date of Birth] as date), [Date of Birth]
from ProjectPortfolio..AmazonPersonalDetails

alter table ProjectPortfolio..AmazonPersonalDetails
add [Date of Birth converted] date, add [Membership Start Date Converted] date, [Membership End Date Converted] date

update ProjectPortfolio..AmazonPersonalDetails
set [Date of Birth Converted] = cast([Date of Birth] as date)

update ProjectPortfolio..AmazonPersonalDetails
set [Membership End Date Converted] = cast([Membership End Date] as date)

update ProjectPortfolio..AmazonPersonalDetails
set [Membership Start Date Converted] = cast([Membership Start Date] as date)




--To confirm the username is correctly stated from the email address
with EmailCTE as(
select Username, [Email Address], substring([Email Address], 1, CHARINDEX('@', [Email Address]) - 1) as [Username revamped]
from ProjectPortfolio..AmazonPersonalDetails)
select *
from EmailCTE
where Username <> [Username revamped] --the results are similar so we can ignore the two that are different




--Trying to do the above using parsename
with EmailCTE as(
select Username, [Email Address], parsename(Replace([Email Address], '@', '.'), 3) as [Username revamped]
from ProjectPortfolio..AmazonPersonalDetails)
select *
from EmailCTE
where Username <> [Username revamped] --same result as above




--Age of users
select datediff(year, [Date of Birth converted], getdate()) as Age
from ProjectPortfolio..AmazonPersonalDetails

alter table ProjectPortfolio..AmazonPersonalDetails
add Age int

update ProjectPortfolio..AmazonPersonalDetails
set Age = datediff(year, [Date of Birth converted], getdate()) --Now we have a more useful data Age that can be used in visualizations




--Lets Make the age on an interval basis which will further aid the visualization
--Lets get the maximum and minimum ages firstly
select min(Age) as AgeMin, max(Age) as AgeMax
from ProjectPortfolio..AmazonPersonalDetails person
join ProjectPortfolio..AmazonAccountInfo acc
on acc.[User ID] = person.[User ID]

select Age,
case
	when Age between 18 and 25 then 'Youth'
	when Age between 26 and 50 then 'Adult'
	when Age > 50 then 'Elder'
	end as AgeInterval
from ProjectPortfolio..AmazonPersonalDetails person
join ProjectPortfolio..AmazonAccountInfo acc
on acc.[User ID] = person.[User ID]

alter table ProjectPortfolio..AmazonPersonalDetails
add AgeInterval nvarchar(150)

update ProjectPortfolio..AmazonPersonalDetails
set AgeInterval = case
	when Age between 18 and 25 then 'Youth'
	when Age between 26 and 50 then 'Adult'
	when Age > 50 then 'Elder'
	end




--Lets get the duration of membership for each user
select datediff(month, [Membership Start Date Converted], [Membership End Date Converted]) as [Membership Duration]
from ProjectPortfolio..AmazonPersonalDetails

alter table ProjectPortfolio..AmazonPersonalDetails
add [Membership Duration] int

update ProjectPortfolio..AmazonPersonalDetails
set [Membership Duration] = datediff(month, [Membership Start Date Converted], [Membership End Date Converted])





--Lets see how many people are actually giving amazon a high rating
select count([Feedback/Ratings])
from ProjectPortfolio..AmazonAccountInfo
where [Feedback/Ratings] > 4.0

select (convert(float, (select count([Feedback/Ratings])
	from ProjectPortfolio..AmazonAccountInfo
	where [Feedback/Ratings] > 4.0))/convert(float, (select count([Feedback/Ratings])
	from ProjectPortfolio..AmazonAccountInfo))) * 100
from ProjectPortfolio..AmazonAccountInfo





--Total amount of locations involved in the survey
select count(distinct(person.Location))
from ProjectPortfolio..AmazonPersonalDetails person
join ProjectPortfolio..AmazonAccountInfo acc
on acc.[User ID] = person.[User ID]





--Locations with high ratings and the amount of high ratings made
select person.Location, count([Feedback/Ratings]) HighRatings
from ProjectPortfolio..AmazonPersonalDetails person
join ProjectPortfolio..AmazonAccountInfo acc
on acc.[User ID] = person.[User ID]
	where [Feedback/Ratings] > 4.5
	group by person.Location
	order by HighRatings desc




--Movie Genres with high ratings and the amount of high ratings made
select [Favorite Genres], count([Feedback/Ratings]) HighRatings
from ProjectPortfolio..AmazonPersonalDetails person
join ProjectPortfolio..AmazonAccountInfo acc
on acc.[User ID] = person.[User ID]
	where [Feedback/Ratings] > 4.5
	group by [Favorite Genres]
	order by HighRatings desc

	 


--Locations with high Customer Support Interactions
select person.Location, count([Customer Support Interactions]) Interactions
from ProjectPortfolio..AmazonPersonalDetails person
join ProjectPortfolio..AmazonAccountInfo acc
on acc.[User ID] = person.[User ID]
	where [Customer Support Interactions] > 7
	group by person.Location
	order by Interactions desc




--Lets see the average Feedback/Rating and Customer support interactions
select avg([Feedback/Ratings]) as AvgRating, avg([Customer Support Interactions]) as AvgInteration
from ProjectPortfolio..AmazonPersonalDetails person
join ProjectPortfolio..AmazonAccountInfo acc
on acc.[User ID] = person.[User ID]




--Lets find out the various Genres, puchase products, Payment methods and Devices used
select Distinct([Favorite Genres])
from ProjectPortfolio..AmazonAccountInfo 

select Distinct([Purchase History])
from ProjectPortfolio..AmazonAccountInfo 

select Distinct([Payment Information])
from ProjectPortfolio..AmazonAccountInfo 

select Distinct([Devices Used])
from ProjectPortfolio..AmazonAccountInfo 




--How frequently is Amazon used
select [Usage Frequency] ,count([Usage Frequency])
from ProjectPortfolio..AmazonPersonalDetails person
join ProjectPortfolio..AmazonAccountInfo acc
on acc.[User ID] = person.[User ID]
	group by [Usage Frequency]




--Now we know the various Genres, lets see the amount of male and females that watch particular genres
select Gender, count([Favorite Genres])
from ProjectPortfolio..AmazonPersonalDetails person
join ProjectPortfolio..AmazonAccountInfo acc
on acc.[User ID] = person.[User ID]
	where [Favorite Genres] = 'Action'
	group by Gender




--Time to remove the column not needed in our visualization analysis
--Date of Birth, Membership start and end Date
alter table ProjectPortfolio..AmazonPersonalDetails
drop column [Date of Birth], [Membership Start Date], [Membership End Date]


select *
from ProjectPortfolio..AmazonPersonalDetails person
join ProjectPortfolio..AmazonAccountInfo acc
on acc.[User ID] = person.[User ID]



--We can remove the email since its just an extension of the username
alter table ProjectPortfolio..AmazonPersonalDetails
drop column [Email Address]