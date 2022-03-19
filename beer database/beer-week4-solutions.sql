-- Q16: Which bar is most popular?
select bar
from popularity
where ndrinkers = (
    select max(ndrinkers)
    from popularity
)

-- Q17: Which bar is most expensive?
create or replace view AvgPrice(bar, avgprice)
as
select
    bar,
    avg(price)
from sells
group by bar;

select bar
from AvgPrice
where avgprice = (
    select max(avgprice)
    from AvgPrice
);

-- Q18: Price of cheapest beer at each bar?
select
    s1.beer,
    s1.bar,
    s1.price
from sells s1
where s1.price = (
    select min(s2.price)
    from sells s2
    where s1.bar = s2.bar
)

-- Q19: Which beers are sold at all bars?
select s1.beer
from sells s1
where
    (select count(*) from bars)
    =
    (select count(*) from sells s2 where s1.beer = s2.beer)

select distinct s.beer
from sells s1
where not exist
    (select name from bars)
    except
    (select bar from sells where beer = s1.beer)
);