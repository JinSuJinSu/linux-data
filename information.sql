USE sakila;
show tables;

select count(*) from language;
select * from language;

select count(*) from film;
select * from film where language_id=1;
select count(*) from film where original_language_id is null;

select distinct special_features from film;

select * from actor;

select count(*) from film_actor;

select distinct actor_id from film_actor;

select * from film_actor where actor_id=23;

select * from category;

select count(*) from inventory;

-- 1번째 문제
-- 고객별 지불 금액의 총합을 구하라(customer_id, 총금액)
select customer.customer_id, sum(payment.amount) as 'total money'
from customer
inner join payment
on customer.customer_id = payment.customer_id
group by customer.customer_id
order by customer.customer_id;

select customer_id as '고객ID', sum(amount) as '총금액'
from payment
group by customer_id
order by sum(amount) desc;

-- 2번째 문제
-- 1번 쿼리에 고객ID 대신 고객의 first name, last name을 출력하시오
select concat(customer.first_name,' ',customer.last_name) as '고객명',
sum(payment.amount) as '총금액'
from customer
inner join payment
on customer.customer_id = payment.customer_id
group by payment.customer_id
order by sum(payment.amount) desc;

-- 3번째 문제
-- 고객 ID별 총 대여 수를 출력
select customer_id as '고객ID', count(customer_id) as '총 대여수'
from rental
group by customer_id
order by count(customer_id) desc;

-- 4번째 문제
-- 3번 쿼리에서 고객 ID대신 first_name, last_name을 출력
select concat(customer.first_name,' ',customer.last_name) as '고객명',
count(rental.customer_id) as '총 대여수'
from customer
inner join rental
on customer.customer_id = rental.customer_id
group by rental.customer_id
order by count(rental.customer_id) desc;

-- 5번째 문제
-- action분야 영화의 다음 속성들을 출력하시오
-- 필름번호, 제목, 설명, 분야, 발매년도, 언어
select film.film_id as "필름번호", film.title as "제목", film.description as "설명",
category.name as "분야", film.release_year as "발매년도", language.name as "언어"
from film
inner join language
on language.language_id = film.language_id
inner join film_category
on film.film_id = film_category.film_id
inner join category
on film_category.category_id = category.category_id
where category.name='action';


-- 6번째 문제
-- 출연작이 많은 순으로 배우의 first_name, last_name, 작품수를 출력하세요
select actor.actor_id, concat(actor.first_name,' ',actor.last_name) as '배우명',
count(film_actor.actor_id) as '작품수'
from actor
inner join film_actor
on actor.actor_id = film_actor.actor_id
group by film_actor.actor_id
order by count(film_actor.actor_id) desc;

-- 7번째 문제
-- MARY KEITEL의 출연작을 영화제목 오름차순으로 출력하시오
-- first_name, last_name, 영화제목, 출시일, 대여 비용

select actor.first_name as "성", actor.last_name as "이름", film.title as "영화 제목",
film.release_year as "출시일", film.rental_rate as "대여 비용"
from actor
inner join film_actor
on actor.actor_id = film_actor.actor_id
inner join film
on film.film_id = film_actor.film_id
where actor.first_name='MARY' and actor.last_name='KEITEL'
order by film.title;

-- 8번째 문제
-- 배우의 R등급 영화 작품 수를 카운트하여 가장 많은 작품수를 가지는 배우부터 출력하시오
-- actor_id, first_name, last_name, 'R'등급 작품 수

select actor.actor_id as "배우 ID", actor.first_name as "성", 
actor.last_name as "이름", count(film.title) as "R등급 개수"
from actor
inner join film_actor
on actor.actor_id = film_actor.actor_id
inner join film
on film.film_id = film_actor.film_id
where film.rating='R'
group by actor.actor_id
order by count(film.rating) desc;

-- 9번째 문제
-- R등급 영화에 출연한 적이 없는 배우의 first_name, last_name, 출연영화제목, 출시년도
-- 출시일 순으로 출력하시오

select actor.first_name as "성", actor.last_name as "이름",
film.title as "영화 제목",film.release_year as '출시 년도'
from actor
inner join film_actor
on actor.actor_id = film_actor.actor_id
inner join film
on film.film_id = film_actor.film_id
where actor.actor_id not in (select actor.actor_id from actor
							inner join film_actor
							on actor.actor_id = film_actor.actor_id
							inner join film
							on film.film_id = film_actor.film_id
                            where film.rating='R')													
order by film.release_year desc;

-- 10번째 문제
-- 영화 'AGENT TRUMAN'을 보유하고 있는 매장의 정보를 아래와 같이 출력함
-- 영화제목, 매장ID, 매장staff first_name, 매장staff last_name, 매장의 address, address2,
-- distrtict, city, country, 해당 타이틀 보유수량

select film.title, store.store_id, staff.first_name, staff.last_name,
address.address, address.address2, address.district, city.city, country.country,
count(film.title) as "보유 수량"
from film
inner join inventory
on film.film_id = inventory.film_id
inner join store
on store.store_id = inventory.store_id
inner join address
on address.address_id = store.address_id
inner join staff
on store.store_id = staff.store_id
inner join city
on address.city_id = city.city_id
inner join country
on city.country_id = country.country_id
where film.title='AGENT TRUMAN'
group by film.title, store.store_id, staff.first_name, staff.last_name,
address.address, address.address2, address.district, city.city, country.country;

-- 11번째 문제
-- 영화 'AGENT TRUMAN'을 보유하고 있는 매장의 정보와 해당 타이틀의 대여 정보를(대여 정보가 없을 경우에는 관련 컬럼은 null 처리)
-- 어래와 같이 출력함
-- 영화제목, 매장ID, 인벤토리ID, 매장의 address, address2, distrtict, city, country
-- 대여 일자, 회수일자, 대여 고객의 first_name, last_name

select film.title, store.store_id, inventory.inventory_id,
address.address, address.address2, address.district, city.city, country.country,
rental.rental_date, rental.return_date, customer.first_name, customer.last_name
from film
inner join inventory
on film.film_id = inventory.film_id
inner join store
on store.store_id = inventory.store_id
inner join address
on address.address_id = store.address_id
inner join city
on address.city_id = city.city_id
inner join country
on city.country_id = country.country_id
left outer join rental
on inventory.inventory_id = rental.inventory_id
inner join customer
on rental.customer_id = customer.customer_id
where film.title='AGENT TRUMAN';

-- 12번째 문제
-- 대여된 영화 타이틀과 대여회수를 출력하시오(대여 회수 내림차순)
select film.title as "영화제목", count(rental.rental_date) as "대여 회수"
from film
inner join inventory
on film.film_id = inventory.film_id
inner join rental
on inventory.inventory_id = rental.inventory_id
group by film.title
order by count(rental.rental_date) desc;

-- 13번째 문제
-- 고객의 지불정보를 총지불금액 내림차순, 다음과 같이 출력하시오
-- 고객의 first_name, last_name, 총지불금액, 고객의 주소 address, address2, district, city, country
select customer.first_name, customer.last_name, sum(payment.amount) as "총지불금액",
address.address, address.address2, address.district, city.city, country.country
from customer
inner join address
on customer.address_id = address.address_id
inner join city
on address.city_id = city.city_id
inner join country
on city.country_id = country.country_id
inner join rental
on customer.customer_id = rental.customer_id
inner join payment
on rental.rental_id = payment.rental_id
group by customer.customer_id
order by sum(payment.amount) desc;


-- 14번째 문제
-- 총 지불 금액별 고객 등급을 출력하고자 한다. 등급 구분과 출력 컬럼은 다음과 같다.
-- A : 총 지불금액이 200 이상
-- B : 총 지불금액이 200미만 100이상
-- C : 총 지불금액이 100 미만
-- 고객의 first_name, last_name, 총지불금액, 등급을 총 지불금액이 많은 고객부터
select customer.first_name, customer.last_name, sum(payment.amount) as "총지불금액",
    case
    when (sum(payment.amount)>=200) then 'A'
    when (sum(payment.amount)>=100 and sum(payment.amount)<200) then 'B'
    else 'C'
    end as '등급'
from customer
inner join rental
on customer.customer_id = rental.customer_id
inner join payment
on rental.rental_id = payment.rental_id
group by customer.customer_id
order by sum(payment.amount) desc;

-- 15번째 문제
-- DVD 대여 후 아직 반납하지 않은 고객정보를 다음의 정보로 출력한다.(case 문 사용)
-- 영화 타이틀, 인벤토리ID, 매장ID, 고객의 frist_name, last_name, 대여일자, 고객등급
select film.title, inventory.inventory_id, inventory.store_id,
customer.first_name, customer.last_name, rental.rental_date,
    case
    when (sum(payment.amount)>=200) then 'A'
    when (sum(payment.amount)>=100 and sum(payment.amount)<200) then 'B'
    else 'C'
    end as '등급', sum(payment.amount)
from rental
inner join customer
on rental.customer_id = customer.customer_id
inner join inventory
on inventory.inventory_id = rental.inventory_id
inner join film
on film.film_id = inventory.film_id
inner join store
on inventory.store_id = store.store_id
inner join payment
on customer.customer_id = payment.customer_id
where rental.return_date is null
group by film.title, inventory.inventory_id, inventory.store_id,
customer.first_name, customer.last_name, rental.rental_date;


-- 16번째 문제
-- 2005-08-01부터 2005-08-15 사이, canada(country) Alberta(district) 주에서
-- 대여한 영화의 타이틀 정보를 아래와 같이 출력하시오
-- 대여일, 영화 타이틀, 인벤토리ID, 매장ID, 매장 전체 주소
select rental.rental_date, film.title, inventory.inventory_id,
store.store_id, address.address, address.address2, address.district,
city.city, country.country
from film
inner join inventory
on film.film_id = inventory.film_id
inner join store
on inventory.store_id = store.store_id
inner join address
on store.address_id = address.address_id
inner join city
on address.city_id = city.city_id
inner join country
on city.country_id = country.country_id
inner join rental
on rental.inventory_id = inventory.inventory_id
where country.country = 'Canada'
and address.district='Alberta'
and date(rental.rental_date)>="2005-08-01"
and date(rental.rental_date)<="2005-08-15"
order by rental.rental_date;


-- 17번째 문제
-- 도시별 'Horror'영화 대여정보를 알고자 한다. 도시와 대여수를 출력하라.
-- 대여수 내림차순, 도시명 오름차순으로 정렬하시오
select city.city, count(rental.rental_id) as "대여수"
from rental
inner join customer
on customer.customer_id = rental.customer_id
inner join address
on customer.address_id = address.address_id
inner join city
on address.city_id = city.city_id
inner join inventory
on rental.inventory_id = inventory.inventory_id
inner join film
on film.film_id = inventory.film_id
inner join film_category
on film.film_id = film_category.film_id
inner join category
on film_category.category_id = category.category_id
where category.name = 'Horror'
group by city.city
order by count(rental.rental_id) desc, city.city;


-- 18번째 문제
-- 각 store별 총 대여금액을 출력하시오
-- store_id, 총 대여금액
select store.store_id, sum(payment.amount) as "총 대여금액"
from store
inner join inventory
on store.store_id = inventory.store_id
inner join rental
on inventory.inventory_id = rental.inventory_id
inner join payment
on rental.rental_id = payment.rental_id
group by store.store_id;

-- 19번째 문제
-- 대여된 영화 중 대여기간이 연체된 건을 다음의 정보를 조회하시오
-- 영화타이틀, 인벤토리id, 대여일, 반납일, 기준대여기간, 실제대여기간
-- 아직 반납이 되지 않은 경우 실제 대여기간 컬럼에 unknown 출력
select film.title, inventory.inventory_id, rental.rental_date,
rental.return_date, film.rental_duration as "기준대여기간",
datediff(rental.return_date, rental.rental_date) as "실제대여기간"
from rental
inner join inventory
on rental.inventory_id = inventory.inventory_id
inner join film
on inventory.film_id = film.film_id
where datediff(rental.return_date, rental.rental_date)>film.rental_duration;

select film.title, inventory.inventory_id, rental.rental_date,
rental.return_date, film.rental_duration as "기준대여기간",
case
	when rental.return_date is null then 'unknown'
	else datediff(rental.return_date, rental.rental_date)
    end as "실제대여기간"
from rental
inner join inventory
on rental.inventory_id = inventory.inventory_id
inner join film
on inventory.film_id = film.film_id
where datediff(rental.return_date, rental.rental_date)>film.rental_duration
or rental.return_date is null;

-- 20번째 문제
-- 고객별 연체 건수가 많은 수부터 출력하시오(고객 first_name, last_name, 연체건수)
select customer.first_name, customer.last_name, count(rental.rental_id)
from customer
inner join rental
on customer.customer_id = rental.customer_id
inner join inventory
on rental.inventory_id = inventory.inventory_id
inner join film
on inventory.film_id = film.film_id
where datediff(rental.return_date, rental.rental_date)>film.rental_duration
or rental.return_date is null
group by customer.first_name, customer.last_name
order by count(rental.rental_id) desc;

-- 21번째 문제
-- 대여 횟수 상위 5위 고객이 대여한 영화의 title을 알파벳순으로 출력
-- 고객이름(first,last), 영화제목, 총 대여수
select customer.first_name, customer.last_name,
film.title, count(rental.rental_id) as "총 대여수"
from customer
inner join rental
on customer.customer_id = rental.customer_id
inner join payment
on rental.rental_id = payment.rental_id
inner join inventory
on rental.inventory_id = inventory.inventory_id
inner join film
on inventory.film_id = film.film_id
where customer.customer_id in (
						select * from(
						select customer.customer_id
						from customer
						inner join rental
						on customer.customer_id = rental.customer_id
                        group by customer.customer_id
                        order by count(rental.rental_id) desc
                        limit 5)as temp)
group by customer.first_name, customer.last_name, film.title, rental.rental_id
order by film.title;

-- 22번째 문제
-- 배우 'WALTER TORN' 보다 출연작이 많은 배우의 정보를
-- 배우 이름(first_name, last_name), 출연작 타이틀, 작품 출시일 출력하시오
-- 정렬 순서(배우 ID, 타이틀, 출시일)
select actor.actor_id, actor.first_name, actor.last_name,
film.title, film.release_year
from actor
inner join film_actor
on actor.actor_id = film_actor.actor_id
inner join film
on film_actor.film_id = film.film_id
where actor.actor_id in ( select actor.actor_id
						from film
						inner join film_actor
						on film_actor.film_id = film.film_id
						inner join actor
						on actor.actor_id = film_actor.actor_id
						group by actor.actor_id
						having count(film.film_id) > (select count(film.film_id)
														from film
														inner join film_actor
														on film_actor.film_id = film.film_id
														inner join actor
														on actor.actor_id = film_actor.actor_id
														where actor.first_name = 'WALTER'
														and actor.last_name = 'TORN'))
order by actor.actor_id, film.title, film.release_year;

