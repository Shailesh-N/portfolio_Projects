--checking the dataset
select *
from netflix$


--looking at shows that have a rating level 
select *
from netflix$
where ratingLevel is not null 


--we can see that there are null values in the user rating
select * 
from netflix$
where ratingLevel is not null and [user rating score] is not null


-- sorting the names of shows in alphabetical order
select * 
from netflix$
where ratingLevel is not null and [user rating score] is not null
order by title 


--grouping the shows/movies by their rating
select rating, count(title) as total_movies
from netflix$
--where ratingLevel is not null and [user rating score] is not null 
group by rating

--grouping the titles by year of release
select [release year], count(title) as total_movies
from netflix$
where ratingLevel is not null and [user rating score] is not null 
group by [release year]
order by [release year] 


--looking at avg user rating of shows with respect to their ratings
select rating,avg([user rating score]) as avg_rating
from netflix$
where  [user rating score] is not null 
group by rating 
order by [avg_rating] desc

-- looking for specific conditions for ex. shows released in 2016 with user rating score above 80
select title,rating,[user rating score],[release year]
from netflix$
where [user rating score] >= 80 and [release year] = 2016 and ratingLevel is not null and [user rating score] is not null
group by title,rating,[user rating score],[release year]
order by [user rating score] desc
