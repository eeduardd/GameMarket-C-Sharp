--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.24
-- Dumped by pg_dump version 9.5.24

-- Started on 2021-10-12 08:47:54

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12355)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2175 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 190 (class 1255 OID 41095)
-- Name: Final_Price(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."Final_Price"(id_a integer) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
DECLARE
  summ double precision;  sdisc double precision;
  apr INTEGER;  id_g INTEGER;
  disc INTEGER;   seb double precision;
  per INTEGER;  cnt INTEGER;
  sd INTEGER;  tmp double precision;
BEGIN
  summ:=0;
  SELECT INTO sd b.summ_discount FROM buyers b, accounts a WHERE (b.buyer_id=a.buyer_id) and (a.account_id=id_a);
  SELECT INTO sdisc, apr a.discount_on_shipping, a.price_of_shipping FROM accounts a WHERE (a.account_id=id_a);
  FOR id_g, disc, cnt IN SELECT r.goods_id, r.discount, r.reteil_count FROM reteil r WHERE (r.account_id=id_a) LOOP
      SELECT INTO seb, per   g.price_of_last_delivery, g.percent_of_price_increasing FROM goods g WHERE (g.goods_id=id_g);
      tmp:=(seb+ seb*per/100)*cnt;
      summ:=summ + tmp - tmp*disc/100;
    END LOOP;
    summ:=summ-summ*sd/100;
    summ:=summ+apr-apr*sdisc/100;
    RETURN summ; 
END;
$$;


ALTER FUNCTION public."Final_Price"(id_a integer) OWNER TO postgres;

--
-- TOC entry 203 (class 1255 OID 41096)
-- Name: OrdersHistory(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."OrdersHistory"(b_id integer, OUT "Name" character varying, OUT "BuyedCount" integer, OUT "DateOfBuy" date) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
DECLARE
 a_id INTEGER;
 r_id INTEGER;
BEGIN
 FOR a_id IN SELECT a.account_id FROM accounts a WHERE a.buyer_id="b_id" LOOP
  FOR r_id,"BuyedCount", "DateOfBuy" IN SELECT r.goods_id,  r.reteil_count, r.date_of_reteil FROM reteil r
  WHERE r.account_id=a_id LOOP
   SELECT INTO "Name" g.name FROM goods g WHERE g.goods_id=r_id;
  RETURN NEXT;
  END LOOP;
  END LOOP;
END;
$$;


ALTER FUNCTION public."OrdersHistory"(b_id integer, OUT "Name" character varying, OUT "BuyedCount" integer, OUT "DateOfBuy" date) OWNER TO postgres;

--
-- TOC entry 204 (class 1255 OID 41098)
-- Name: PercentOfUsingShiping(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."PercentOfUsingShiping"(OUT "Type_of_shiping" character varying, OUT "Percentage" double precision) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
DECLARE
  cnt1 INTEGER;
  cnt2 INTEGER;
  cnt3 INTEGER;
  summ DOUBLE PRECISION;
BEGIN
    SELECT INTO cnt1 COUNT(a.type_of_shipping) FROM accounts a WHERE (upper(a.type_of_shipping)=upper('Авиапочта'));
    SELECT INTO cnt2 COUNT(a.type_of_shipping) FROM accounts a WHERE (upper(a.type_of_shipping)=upper('Наземная почта'));
    SELECT INTO cnt3 COUNT(a.type_of_shipping) FROM accounts a WHERE (upper(a.type_of_shipping)=upper('Курьер'));

  summ:=cnt1+cnt2+cnt3;
   "Type_of_shiping":='Авиапочта';
   "Percentage":=100*cnt1/summ;
  RETURN NEXT;
   "Type_of_shiping":='Наземная почта';
   "Percentage":=100*cnt2/summ;
  RETURN NEXT;
   "Type_of_shiping":='Курьер';
   "Percentage":=100*cnt3/summ;
  RETURN NEXT;
END;
$$;


ALTER FUNCTION public."PercentOfUsingShiping"(OUT "Type_of_shiping" character varying, OUT "Percentage" double precision) OWNER TO postgres;

--
-- TOC entry 205 (class 1255 OID 41099)
-- Name: Profit(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."Profit"("Begin_Date" date, "End_Date" date, OUT "Cost" double precision, OUT "Proceeds" double precision, OUT "Profits" double precision) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
DECLARE
  summ double precision;  id_g INTEGER;
  id_a INTEGER;  disc INTEGER; 
  seb double precision;  per INTEGER;
  cnt INTEGER;  sd INTEGER;
  tmp double precision;  tmp2 double precision;
BEGIN
  IF "Begin_Date"<"End_Date" THEN
  "Proceeds":=0; 
  "Cost":=0;
  FOR id_a IN SELECT a.account_id FROM accounts a LOOP 
     summ:=0;
     tmp2:=0;
  SELECT INTO sd b.summ_discount FROM buyers b, accounts a WHERE (b.buyer_id=a.buyer_id) and (a.account_id=id_a);
     FOR id_g, disc, cnt IN SELECT r.goods_id, r.discount, r.reteil_count FROM reteil r WHERE (r.account_id=id_a) and (r.date_of_reteil BETWEEN "Begin_Date" and "End_Date") LOOP
      SELECT INTO seb, per   g.price_of_last_delivery, g.percent_of_price_increasing FROM goods g WHERE (g.goods_id=id_g);
      tmp2:=tmp2 + seb*cnt;
      tmp:=(seb+ seb*per/100)*cnt;
      summ:=summ + tmp - tmp*disc/100;
    END LOOP;
    summ:=summ-summ*sd/100;
    "Cost":="Cost"+tmp2;
    "Proceeds":="Proceeds"+summ;
 END LOOP;
  "Profits":="Proceeds" - "Cost";
    RETURN NEXT; 
   ELSE
  RAISE EXCEPTION 'Начальная дата не может быть больше конечной!';
  END IF;
END;
$$;


ALTER FUNCTION public."Profit"("Begin_Date" date, "End_Date" date, OUT "Cost" double precision, OUT "Proceeds" double precision, OUT "Profits" double precision) OWNER TO postgres;

--
-- TOC entry 206 (class 1255 OID 41100)
-- Name: Salary(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."Salary"(OUT "LastName" character varying, OUT "Post" character varying, OUT "Salary" double precision, OUT "Salary_Plus_Wage_Rate" double precision) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
DECLARE
  summ double precision;  id_g INTEGER;
  id_a INTEGER;  id_ss INTEGER;
  disc INTEGER;   seb double precision;
  per INTEGER;  cnt INTEGER;
  wr INTEGER;  tmp double precision;
  nname varchar;
BEGIN 
FOR id_ss, "LastName", "Post", "Salary", wr IN SELECT ss.employee_id, ss.last_name, ss.post, ss.salary, ss.wage_rate FROM shop_staff ss LOOP 
 summ:=0;
  FOR id_a  IN SELECT a.account_id FROM accounts a WHERE (a.employee_id=id_ss) LOOP    
   FOR id_g, disc, cnt IN SELECT r.goods_id, r.discount, r.reteil_count FROM reteil r WHERE (r.account_id=id_a) LOOP
      SELECT INTO seb, per g.price_of_last_delivery, g.percent_of_price_increasing FROM goods g WHERE (g.goods_id=id_g);
      summ:=summ + (seb+ seb*per/100)*cnt;
    END LOOP;
    END LOOP;
    "Salary_Plus_Wage_Rate":="Salary"+ summ*wr/100;
     RETURN NEXT;
    END LOOP;
END;
$$;


ALTER FUNCTION public."Salary"(OUT "LastName" character varying, OUT "Post" character varying, OUT "Salary" double precision, OUT "Salary_Plus_Wage_Rate" double precision) OWNER TO postgres;

--
-- TOC entry 207 (class 1255 OID 41101)
-- Name: Search(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."Search"(whattofind character varying, OUT id integer, OUT "Name" character varying, OUT "Developer" character varying, OUT "Publisher" character varying, OUT "Price" double precision) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$
BEGIN
 FOR "id", "Name", "Developer", "Publisher", "Price" IN SELECT g.goods_id,  g.name, g.developer, g.publisher, (g.price_of_last_delivery+g.price_of_last_delivery*g.percent_of_price_increasing/100), g.count_at_storehouse 
   FROM goods g WHERE ( (lower(g.name) LIKE lower('%' || whattofind || '%')) or 
  (lower(g.developer) LIKE lower('%' || whattofind || '%')) or (lower(g.publisher) LIKE lower('%' || whattofind || '%')) ) AND (g.count_at_storehouse<>0) LOOP
 RETURN NEXT;
 END LOOP;
END;
$$;


ALTER FUNCTION public."Search"(whattofind character varying, OUT id integer, OUT "Name" character varying, OUT "Developer" character varying, OUT "Publisher" character varying, OUT "Price" double precision) OWNER TO postgres;

--
-- TOC entry 213 (class 1255 OID 41097)
-- Name: TopBuyer(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."TopBuyer"(OUT "Lname" character varying, OUT "Total" double precision) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
  summ double precision; id_g INTEGER;
  id_a INTEGER; id_b INTEGER;  disc INTEGER; 
  seb double precision; per INTEGER;
  cnt INTEGER;  tmp double precision;
  nname varchar;
BEGIN
"Total":=0;
FOR id_b, nname IN SELECT b.buyer_id, b.last_name FROM buyers b LOOP 
 summ:=0;
  FOR id_a  IN SELECT a.account_id FROM accounts a WHERE (a.buyer_id=id_b) LOOP    
   FOR id_g, disc, cnt IN SELECT r.goods_id, r.discount, r.reteil_count FROM reteil r WHERE (r.account_id=id_a) LOOP
      SELECT INTO seb, per g.price_of_last_delivery, g.percent_of_price_increasing FROM goods g WHERE (g.goods_id=id_g);
      tmp:=(seb+ seb*per/100)*cnt;
      summ:=summ + tmp - tmp*disc/100;
   END LOOP;
  END LOOP;
    if summ>"Total" then   
    "Total":=summ;
    "Lname":=nname;
    end if;
    END LOOP;
END;
$$;


ALTER FUNCTION public."TopBuyer"(OUT "Lname" character varying, OUT "Total" double precision) OWNER TO postgres;

--
-- TOC entry 208 (class 1255 OID 41102)
-- Name: TopGood(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."TopGood"(OUT "NameOfGood" character varying, OUT "SellingCount" integer) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
  g_id INTEGER;
  gname VARCHAR;
  cnt INTEGER;
  cntSumm INTEGER;
BEGIN
  "SellingCount":=0;
  FOR g_id, gname IN SELECT g.goods_id, g.name FROM goods g LOOP
   cntSumm:=0;
    FOR cnt IN SELECT r.reteil_count FROM reteil r WHERE (r.goods_id=g_id) LOOP
     cntSumm:=cntSumm+cnt;
    END LOOP;
     IF cntSumm>"SellingCount" THEN
      "SellingCount":=cntSumm;
      "NameOfGood":=gname;
     END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION public."TopGood"(OUT "NameOfGood" character varying, OUT "SellingCount" integer) OWNER TO postgres;

--
-- TOC entry 212 (class 1255 OID 41103)
-- Name: Top_Seller(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."Top_Seller"(OUT "Name" character varying, OUT "Selled" integer) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
  id_s INTEGER;
  cnt INTEGER;
  sname VARCHAR;
BEGIN
 "Selled":=0;
  FOR id_s, sname IN SELECT ss.employee_id, ss.last_name FROM shop_staff ss LOOP
   SELECT INTO cnt COUNT(a.account_id) FROM accounts a WHERE (a.employee_id=id_s);
   IF cnt>"Selled" THEN
    "Selled":=cnt;
    "Name":=sname;
   END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION public."Top_Seller"(OUT "Name" character varying, OUT "Selled" integer) OWNER TO postgres;

--
-- TOC entry 209 (class 1255 OID 41104)
-- Name: cons_date_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cons_date_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    If NEW.consignment_date>now() THEN
           RAISE EXCEPTION 'Введенная дата больше текущей!';
           end if;
           RETURN new;
END;
$$;


ALTER FUNCTION public.cons_date_check() OWNER TO postgres;

--
-- TOC entry 189 (class 1255 OID 41106)
-- Name: dateSending(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."dateSending"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   UPDATE accounts SET date_of_sending=NEW.date_of_reteil+5
    WHERE (accounts.account_id=NEW.account_id);            
    RETURN NEW;
END;
$$;


ALTER FUNCTION public."dateSending"() OWNER TO postgres;

--
-- TOC entry 210 (class 1255 OID 41105)
-- Name: goods_works(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.goods_works() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 UPDATE goods SET count_at_storehouse=count_at_storehouse+NEW.goods_count
 FROM consignment
 WHERE (goods.goods_id=NEW.goods_id);
 UPDATE goods SET price_of_last_delivery=NEW.delivery_price
 FROM consignment
 WHERE (goods.goods_id=NEW.goods_id);
  RETURN new;
END;
$$;


ALTER FUNCTION public.goods_works() OWNER TO postgres;

--
-- TOC entry 211 (class 1255 OID 41107)
-- Name: reteil_works(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.reteil_works() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
cnt INTEGER;
BEGIN
 SELECT into cnt g.count_at_storehouse FROM goods g WHERE (g.goods_id=NEW.goods_id);
IF NEW.reteil_count<=cnt THEN
  UPDATE goods SET count_at_storehouse=count_at_storehouse-NEW.reteil_count
 FROM reteil
 WHERE (goods.goods_id=NEW.goods_id);
 RETURN NEW;
END IF;
IF NEW.reteil_count>cnt THEN
 RAISE EXCEPTION 'На складе нет такого количества данного товара на продажу!';
 END IF;
END;
$$;


ALTER FUNCTION public.reteil_works() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 182 (class 1259 OID 41114)
-- Name: goods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.goods (
    goods_id numeric NOT NULL,
    developer character varying(25),
    name character varying(25),
    publisher character varying(25),
    description text,
    percent_of_price_increasing integer,
    count_at_storehouse numeric,
    price_of_last_delivery double precision,
    date_of_release date,
    image character varying(50)
);


ALTER TABLE public.goods OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 41138)
-- Name: reteil; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reteil (
    reteil_id numeric NOT NULL,
    account_id numeric NOT NULL,
    reteil_count integer,
    discount integer,
    goods_id numeric NOT NULL,
    date_of_reteil date
);


ALTER TABLE public.reteil OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 41150)
-- Name: Unclaimed_Goods; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public."Unclaimed_Goods" AS
 SELECT g.name,
    g.count_at_storehouse,
    max(r.date_of_reteil) AS date_of_last_reteil
   FROM public.goods g,
    public.reteil r
  WHERE ((g.goods_id = r.goods_id) AND ((( SELECT max(r_1.date_of_reteil) AS max
           FROM public.reteil r_1
          WHERE (g.goods_id = r_1.goods_id)) + 30) <= now()))
  GROUP BY g.name, g.count_at_storehouse;


ALTER TABLE public."Unclaimed_Goods" OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 41132)
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    account_id numeric NOT NULL,
    buyer_id numeric NOT NULL,
    date_of_sending date,
    discount_of_shipping integer,
    employee_id numeric NOT NULL,
    type_of_shipping character varying(30),
    price_of_shipping double precision
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 41120)
-- Name: buyers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.buyers (
    buyer_id numeric NOT NULL,
    last_name character varying(20),
    first_name character varying(20),
    third_name character varying(20),
    login character varying(20),
    password character varying(20),
    email character varying(20),
    webmoney_account_number character varying(20),
    home_address character varying(100),
    phone character varying(12),
    summ_discount integer
);


ALTER TABLE public.buyers OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 41144)
-- Name: consignment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consignment (
    consignment_id numeric NOT NULL,
    consignment_date date,
    vendor_id numeric NOT NULL,
    goods_count integer,
    delivery_price double precision,
    goods_id numeric NOT NULL
);


ALTER TABLE public.consignment OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 41126)
-- Name: shop_staff; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shop_staff (
    employee_id numeric NOT NULL,
    last_name character varying(20),
    first_name character varying(20),
    third_name character varying(20),
    login character varying(20),
    password character varying(20),
    post character varying(20),
    email character varying(20),
    webmoney_account_number character varying(20),
    home_address character varying(100),
    phone character varying(12),
    wage_rate numeric,
    salary double precision
);


ALTER TABLE public.shop_staff OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 41108)
-- Name: vendor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendor (
    vendor_id numeric NOT NULL,
    vendor_name character varying(30),
    address character varying(100),
    phone character varying(12),
    email character varying(20),
    webmoney_account_number character varying(20)
);


ALTER TABLE public.vendor OWNER TO postgres;

--
-- TOC entry 2164 (class 0 OID 41132)
-- Dependencies: 185
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (account_id, buyer_id, date_of_sending, discount_of_shipping, employee_id, type_of_shipping, price_of_shipping) FROM stdin;
2	2	2006-09-10	15	2	AIRPLANE	345
3	3	2005-10-20	12	3	SHIP	420
1	1	2001-01-06	10	1	CAR	500
4	4	2000-05-03	13	4	GRAVE	250
\.


--
-- TOC entry 2162 (class 0 OID 41120)
-- Dependencies: 183
-- Data for Name: buyers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.buyers (buyer_id, last_name, first_name, third_name, login, password, email, webmoney_account_number, home_address, phone, summ_discount) FROM stdin;
3	Сапожков	Кирилл	Александрович	Kirill	qertyy	kirill@mail.ru	432579235	Москва	89105865643	5
4	Шамахов	Андрей	Александрович	du_hast	qwerty	du_hast@mail.ru	4647658434	Иркутск	89505674322	1
2	Семигузов	Егор	Юрьевич	yES	qwerty	yes777es@mail.ru	487203103	Иркутс	89508564567	5
5	Маслов	Евгений	Леонидович	Arman	qwerty	arman@mail.ru	865345234	Иркутск	89105873489	0
\.


--
-- TOC entry 2166 (class 0 OID 41144)
-- Dependencies: 187
-- Data for Name: consignment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consignment (consignment_id, consignment_date, vendor_id, goods_count, delivery_price, goods_id) FROM stdin;
1	2000-08-12	1	500	233	1
2	2007-04-05	2	300	567	2
3	2005-10-25	3	3	434	3
4	2009-07-19	4	323	234	4
\.


--
-- TOC entry 2161 (class 0 OID 41114)
-- Dependencies: 182
-- Data for Name: goods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.goods (goods_id, developer, name, publisher, description, percent_of_price_increasing, count_at_storehouse, price_of_last_delivery, date_of_release, image) FROM stdin;
2	rockstar	GTA	bla	14.03.2004	45646	368	567	2010-02-23	\N
3	steam	dota	valve	05.01.2000	1200	525	434	2005-06-23	\N
1	microsoft	minecraft	java	12.4.2009	5500	1066	233	2015-03-14	\N
4	broser	CS	asdf	13.04.2008	3434	448	234	2002-02-02	\N
\.


--
-- TOC entry 2165 (class 0 OID 41138)
-- Dependencies: 186
-- Data for Name: reteil; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reteil (reteil_id, account_id, reteil_count, discount, goods_id, date_of_reteil) FROM stdin;
1	23	63	135	1	2001-02-12
2	12	55	210	2	2002-06-15
3	77	23	10	3	2000-10-10
4	1	1	1	1	2001-01-01
\.


--
-- TOC entry 2163 (class 0 OID 41126)
-- Dependencies: 184
-- Data for Name: shop_staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shop_staff (employee_id, last_name, first_name, third_name, login, password, post, email, webmoney_account_number, home_address, phone, wage_rate, salary) FROM stdin;
1	Балабанова	Юлия	Игоревна	asder	rtyuio	Руководитель	julia@mail.ru	8906564738	г.Донской	89506345689	4	1
2	Иванов	Иван	Иванович	123wert	132sdf	Работник	DHqw@mail.ru	8564562345	г.Кимовск	89565775675	3	2
3	Лавров	Олег	Михайлович	1вап234	цукеав123	Работник	dsfg@mail.ru	8945690455	г.Новомосковск	84563456456	2	3
4	Шишков	Влад	Владимирович	qqq	www	Менеджер	werw@mail.ru	8954567458	г.Москва	89678567330	5	4
\.


--
-- TOC entry 2160 (class 0 OID 41108)
-- Dependencies: 181
-- Data for Name: vendor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendor (vendor_id, vendor_name, address, phone, email, webmoney_account_number) FROM stdin;
3	lock	Тульская область город Донской д.Победы 5	+54653364	jh@mail.ru	N/43356
2	bla26	Тульская область город Донской д.Лаваша 3	+44523455	m@mail.ru	N/16654
1	sf21	Тульская область город Донской д.Футболино 6	+12313132	s@maill.ru	N/12323
4	sdss	Тульская область город Донской д.Полино 24	+12312312	sfghs@mail.ru	N/67865
\.


--
-- TOC entry 2036 (class 2606 OID 41163)
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- TOC entry 2032 (class 2606 OID 41159)
-- Name: buyers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buyers
    ADD CONSTRAINT buyers_pkey PRIMARY KEY (buyer_id);


--
-- TOC entry 2040 (class 2606 OID 41167)
-- Name: consignment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consignment
    ADD CONSTRAINT consignment_pkey PRIMARY KEY (consignment_id);


--
-- TOC entry 2030 (class 2606 OID 41157)
-- Name: goods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.goods
    ADD CONSTRAINT goods_pkey PRIMARY KEY (goods_id);


--
-- TOC entry 2038 (class 2606 OID 41165)
-- Name: reteil_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reteil
    ADD CONSTRAINT reteil_pkey PRIMARY KEY (reteil_id);


--
-- TOC entry 2034 (class 2606 OID 41161)
-- Name: shop_staff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shop_staff
    ADD CONSTRAINT shop_staff_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 2028 (class 2606 OID 41155)
-- Name: vendor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendor
    ADD CONSTRAINT vendor_pkey PRIMARY KEY (vendor_id);


--
-- TOC entry 2043 (class 2620 OID 41168)
-- Name: consigment_date_check; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consigment_date_check BEFORE INSERT OR UPDATE ON public.consignment FOR EACH ROW EXECUTE PROCEDURE public.cons_date_check();


--
-- TOC entry 2044 (class 2620 OID 41169)
-- Name: goods_update_from_consig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER goods_update_from_consig AFTER INSERT ON public.consignment FOR EACH ROW EXECUTE PROCEDURE public.goods_works();


--
-- TOC entry 2041 (class 2620 OID 41170)
-- Name: reteil_dateSending; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "reteil_dateSending" AFTER INSERT ON public.reteil FOR EACH ROW EXECUTE PROCEDURE public."dateSending"();


--
-- TOC entry 2042 (class 2620 OID 41171)
-- Name: reteil_update_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER reteil_update_count BEFORE INSERT ON public.reteil FOR EACH ROW EXECUTE PROCEDURE public.reteil_works();


--
-- TOC entry 2174 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2021-10-12 08:47:55

--
-- PostgreSQL database dump complete
--

