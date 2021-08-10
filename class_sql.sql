create table countries
(
    id   bigserial not null
        constraint countries_pk
            primary key,
    name text      not null
);

create table movies
(
    id bigserial not null
        constraint movies_pk primary key,
    title        text                       not null,
    release_date timestamp,
    price        double precision default 0 not null,
    country_id   bigint
        constraint movies_countries_id_fk
            references countries
);

create or replace function sp_get_movies_price_range(out min_price double precision,
    out max_price double precision, out avg_price double precision)
    language plpgsql as $$
    begin
        max_price :=  (select max(price) from movies);
        min_price :=  (select min(price) from movies);
        avg_price :=  (select avg(price) from movies);
    end;
    $$;
    
insert into countries (name) values('ISRAEL');
insert into countries (name) values('USA');
insert into countries (name) values('JAPAN');
insert into countries (name) values('ENGLAND');
insert into countries (name) values('TAIWAN');

insert into movies (title, release_date, price, country_id)
values ('batman returns', '2020-12-16 20:21:30.500000', 49.5, 3);
insert into movies (title, release_date, price, country_id)
values ('find nemo', '2010-09-06 11:20:10.500000', 31.2, 5);
insert into movies (title, release_date, price, country_id)
values ('givat halfon', '1984-01-03 09:01:10.500000', 12.9, 1);
insert into movies (title, release_date, price, country_id)
values ('naoko ogigami', '2001-04-02 14:01:10.500000', 89.1, 5);

select * from movies
join countries c on movies.country_id = c.id;

select * from movies
where movies.price = (select max(price) from movies);

create or replace function sp_get_movies_price_range(out min_price double precision,
    out max_price double precision, out avg_price double precision)
    language plpgsql as $$
    begin
        max_price :=  (select max(price) from movies);
        min_price :=  (select min(price) from movies);
        avg_price :=  (select avg(price) from movies);
    end;
    $$;

create or replace function sp_get_movies_price_range_bp(out min_price double precision,
    out max_price double precision, out avg_price double precision)
    language plpgsql as $$
    begin
        select min(price), max(price), avg(price)::numeric(5, 2)
        into min_price, max_price, avg_price
        from movies;
    end;
    $$;
    
select * from sp_get_movies_price_range();
select * from sp_get_movies_price_range_bp();

create or replace function sp_get_most_expansive_movie_name(out movie_name text)
    language plpgsql as $$
    declare
        max_price double precision := 0;
    begin
        select max(price) into max_price
        from movies;

        select movies.title into movie_name
        from movies where movies.price = max_price
        limit 1;
    end;
    $$;

select * from sp_get_most_expansive_movie_name();

create or replace function sp_count_movies_countries() returns bigint
    language plpgsql as $$
    declare
        count_movies bigint := 0;
        count_countries bigint := 0;
    begin
        select count(*) into count_movies
        from movies;

        select count(*) into count_countries
        from countries;

        return count_movies + count_countries;
    end;
    $$;

select * from sp_count_movies_countries();


