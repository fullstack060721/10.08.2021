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


