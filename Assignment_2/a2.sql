--COMP9311 POSTGRESQL
--Written by Chen Hao 
--z5102446

-- Q1
create or replace view Q1(Name, Country) as 
select c.name, c.country
from company c
where c.country != 'Australia';



-- Q2
create or replace view Q2_1(Code, Count) as 
select code, count(code)
from executive
group by code;

create or replace view Q2(Code) as
select e.code 
from executive e, Q2_1 q
where e.code = q.code and q.count >= 6;



-- Q3
create or replace view Q3(Name) as
select name
from company c1, category c2
where c1.code = c2.code and c2.sector = 'Technology';



-- Q4
create or replace view Q4(Sector, Number) as
select sector, count(distinct industry)
from category
group by sector;



-- Q5
create or replace view Q5(Name) as
select distinct e.person
from executive e, category c
where e.code = c.code and c.sector = 'Technology';



-- Q6
create or replace view Q6(Name) as
select c1.name 
from company c1, category c2 
where C1.Code = C2.Code and c2.sector = 'Services' and c1.country = 'Australia' and c1.zip ~ '^2';



-- Q7
create or replace view Q7_1("Date") as
select distinct min("Date")
from asx;

create or replace view Q7_2("Date", Code, Volume, PrevPrice, Price, Change, Gain) as
select "Date", code, volume, 
lag (Price, 1, null) over (partition by Code order by "Date") as PrevPrice,
price,
(Price - lag (Price, 1, null) over (partition by Code order by "Date")) as Change, 
(Price - lag (Price, 1, null) over (partition by Code order by "Date")) / lag (Price, 1, null) over (partition by Code order by "Date") * 100 as Gain
from asx a ;

create or replace view Q7("Date", Code, Volume, PrevPrice, Price, Change, Gain) as
select "Date", code, volume, prevprice, price, change, gain
from Q7_2 
where "Date" != (select "Date" from Q7_1); 



-- Q8
create or replace view Q8_1("Date", Volume) as
select "Date", max(volume)
from asx
group by "Date";

create or replace view Q8("Date", Code, Volume) as
select q."Date", a.code, q.volume
from asx a, Q8_1 q
where a."Date" = q."Date" and a.volume = q.volume
order by "Date", Code;



-- Q9
create or replace view Q9_1(Industry, Number) as 
select industry, count(sector)
from category
group by industry;

create or replace view Q9(Sector, Industry, Number) as
select distinct c.Sector, q.Industry, q.Number
from category c, Q9_1 q
where c.Industry = q.Industry 
order by c.Sector, q.Industry;



-- Q10: 
create or replace view Q10_1(Industry, Count) as
select industry, count(industry)
from category
group by industry;

create or replace view Q10(Code, Industry) as
select c.code, q.industry
from category c, Q10_1 q
where c.industry = q.industry and q.count = 1;



-- Q11
create or replace view Q11_1(Sector, Number) as
select sector, count(sector)
from category
group by sector;

create or replace view Q11_2 (Code, AvgcompanyRating) as
select code, avg(star)
from rating
group by code;

create or replace view Q11_3 (Sector, Code, AvgcompanyRating) as
select q1.sector, q2.code, q2.AvgcompanyRating
from category c, Q11_1 q1, Q11_2 q2
where c.sector = q1.sector and c.code = q2.code;

create or replace view Q11(Sector, AvgRating) as 
select distinct sector, avg(AvgcompanyRating)
from Q11_3
group by sector
order by avg(AvgcompanyRating) desc;



-- Q12
create or replace view Q12_1(Person, Count) as
select person, count(person)
from executive
group by person;

create or replace view Q12(Name) as
select person 
from Q12_1
where count > 1;



-- Q13
create or replace view Q13_1 (Sector, Count) as
select sector, count(code)
from category
group by sector;

create or replace view Q13_2(Sector, code) as
select q.sector, c1.code
from Q13_1 q, company c1, category c2
where q.sector = c2.sector and c1.code = c2.code and c1.country != 'Australia';

create or replace view Q13 (Code, Name, Address, Zip, Sector) as
select c1.code, c2.name, c2.address, c2.zip, c1.sector
from category c1, company c2
where c1.code = c2.code and c2.Country = 'Australia' and c1.sector not in (select sector from Q13_2);



-- Q14
create or replace view Q14_begin (BeginDate, Code) as
select min("Date"), code
from asx
group by code;

create or replace view Q14_end (EndDate, Code) as
select max("Date"), code
from asx
group by code;

create or replace view Q14_Beginprice (BeginPrice, Code) as
select a.price, a.code
from asx a, Q14_begin q
where a.Code = q.Code and a."Date" = q.BeginDate;

create or replace view Q14_Endprice (EndPrice, Code) as
select a.price, a.code
from asx a, Q14_end q
where a.code = q.code and a."Date" = q.EndDate;


create or replace view Q14(Code, BeginPrice, EndPrice, Change, Gain) as
select distinct a.code, b.BeginPrice, e.EndPrice, (e.EndPrice - b.BeginPrice), (e.EndPrice - b.BeginPrice)/b.BeginPrice * 100 
from asx a, Q14_BeginPrice b, Q14_EndPrice e
where a.code = e.code and a.code = b.code
order by (e.EndPrice - b.BeginPrice)/b.BeginPrice * 100 desc, a.code;



-- Q15
create or replace view Q15_1("Date", Code, Volume, PrevPrice, Price, Change, Gain) as
select "Date", code, volume, prevprice, price, change, gain
from Q7_2 
where "Date" != (select "Date" from Q7_1); 

create or replace view Q15_2(Code,AvgPrice,MinPrice, MaxPrice) as
select code, avg(Price), min(Price), max(Price)
from asx a 
group by Code;

create or replace view Q15_3(Code, AvgDayGain, MinDayGain, MaxDayGain) as
select code, Sum(gain)/count(gain), min(Gain), max(Gain)
from Q15_1
group by Code;

create or replace view Q15(Code, MinPrice, AvgPrice, MaxPrice, MinDayGain, AvgDayGain, MaxDayGain) as
select distinct q1.code, q2.MinPrice, q2.AvgPrice, q2.MaxPrice, q3.MinDayGain, q3.AvgDayGain, q3.MaxDayGain
from Q15_1 q1, Q15_2 q2, Q15_3 q3
where q1.code= q2.code and q2.code =q3.code;



-- Q16

-- create funtion trigger1()
create or replace function trigger1() returns trigger as $$
declare
        number_of_count int;
begin
    number_of_count := count(code) from executive where person = new.person;
    if number_of_count > 1
    then raise exception 'Invalid! This person is already in serivces!';
    end if;
return new;
end;
$$ language plpgsql;


--create trigger Q16
create trigger Q16
after insert or update on executive
for each row
execute procedure trigger1();



-- Q17
create or replace view Q17_1(Sector, Count) as
select sector, count(code)
from category
group by sector;


create or replace view Q17_2("Date", code, gain, sector, count) as
select q2."Date", q2.code, q2.gain, q1.sector, q1.count
from Q17_1 q1, Q7 q2, category c
where q1.sector = c.sector and q2.code = c.code;


-- create funtion trigger2()
create or replace function trigger2() returns trigger as $$

declare
        new_gain float;
        max_gain float;
        min_gain float;
begin
        new_gain := gain from Q17_2 where ("Date" = new."Date") and (code = new.code);
        max_gain := max(gain) from Q17_2 where sector = (select distinct sector from Q17_2 q where q.code = new.code);
        min_gain := min(gain) from Q17_2 where sector = (select distinct sector from Q17_2 q where q.code = new.code);
        
	if new_gain > max_gain
    then update rating set star = 5 
	where code = new.code;
    end if;
	
	if new_gain < min_gain
    then update rating set star = 1 
	where code = new.code;
    end if;
	
	if new_gain = max_gain
    then update rating set star = 5 
	where code = (select distinct code 
			     from Q17_2 q 
			     where gain = (select gain from Q17_2 where "Date" = new."Date" and code = new.code) 
	and sector = (select distinct sector from Q17_2 q where q.code = new.code));        
    end if;

    if new_gain = min_gain
    then update rating set star = 1 
	where code = (select distinct code 
	             from Q17_2 q 
		         where gain = (select gain from Q17_2 where "Date" = new."Date" and code = new.code) 
	and sector = (select distinct sector from Q17_2 q where q.code = new.code));        
    end if;

return new;
end;
$$ language plpgsql;


--create trigger Q17
create trigger Q17
after insert or update on asx
for each row
execute procedure trigger2();



-- Q18

-- create funtion trigger3()
create or replace function trigger3() returns trigger as $$
begin 
insert into asxlog values(now(), old."Date", old.code, old.volume, old.price);
return new;
end;
$$ language plpgsql;


--create trigger Q18
create trigger Q18
after update on asx
for each row
execute procedure trigger3();
