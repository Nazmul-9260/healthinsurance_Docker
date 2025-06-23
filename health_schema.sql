--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Ubuntu 16.8-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.8 (Ubuntu 16.8-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: healthinsurance; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA healthinsurance;


ALTER SCHEMA healthinsurance OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cronjob_lastsync_time; Type: TABLE; Schema: healthinsurance; Owner: qsoft
--

CREATE TABLE healthinsurance.cronjob_lastsync_time (
    id integer NOT NULL,
    branchcode character varying,
    lastsynctime character varying
);


ALTER TABLE healthinsurance.cronjob_lastsync_time OWNER TO qsoft;

--
-- Name: TABLE cronjob_lastsync_time; Type: COMMENT; Schema: healthinsurance; Owner: qsoft
--

COMMENT ON TABLE healthinsurance.cronjob_lastsync_time IS 'Cron Job Last Sync Time';


--
-- Name: cronjob_lastsync_time_id_seq; Type: SEQUENCE; Schema: healthinsurance; Owner: qsoft
--

CREATE SEQUENCE healthinsurance.cronjob_lastsync_time_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE healthinsurance.cronjob_lastsync_time_id_seq OWNER TO qsoft;

--
-- Name: cronjob_lastsync_time_id_seq; Type: SEQUENCE OWNED BY; Schema: healthinsurance; Owner: qsoft
--

ALTER SEQUENCE healthinsurance.cronjob_lastsync_time_id_seq OWNED BY healthinsurance.cronjob_lastsync_time.id;


--
-- Name: health_category; Type: TABLE; Schema: healthinsurance; Owner: qsoft
--

CREATE TABLE healthinsurance.health_category (
    id integer NOT NULL,
    category_id smallint,
    category_name character varying(30),
    updated_at character varying(30) DEFAULT now()
);


ALTER TABLE healthinsurance.health_category OWNER TO qsoft;

--
-- Name: TABLE health_category; Type: COMMENT; Schema: healthinsurance; Owner: qsoft
--

COMMENT ON TABLE healthinsurance.health_category IS 'Category Table';


--
-- Name: health_category_id_seq; Type: SEQUENCE; Schema: healthinsurance; Owner: qsoft
--

CREATE SEQUENCE healthinsurance.health_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE healthinsurance.health_category_id_seq OWNER TO qsoft;

--
-- Name: health_category_id_seq; Type: SEQUENCE OWNED BY; Schema: healthinsurance; Owner: qsoft
--

ALTER SEQUENCE healthinsurance.health_category_id_seq OWNED BY healthinsurance.health_category.id;


--
-- Name: health_claim_status; Type: TABLE; Schema: healthinsurance; Owner: qsoft
--

CREATE TABLE healthinsurance.health_claim_status (
    id integer NOT NULL,
    claim_status_id smallint,
    claim_status_name character varying(15),
    updated_at character varying(30) DEFAULT now()
);


ALTER TABLE healthinsurance.health_claim_status OWNER TO qsoft;

--
-- Name: TABLE health_claim_status; Type: COMMENT; Schema: healthinsurance; Owner: qsoft
--

COMMENT ON TABLE healthinsurance.health_claim_status IS 'Claim Status';


--
-- Name: health_claim_status_id_seq; Type: SEQUENCE; Schema: healthinsurance; Owner: qsoft
--

CREATE SEQUENCE healthinsurance.health_claim_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE healthinsurance.health_claim_status_id_seq OWNER TO qsoft;

--
-- Name: health_claim_status_id_seq; Type: SEQUENCE OWNED BY; Schema: healthinsurance; Owner: qsoft
--

ALTER SEQUENCE healthinsurance.health_claim_status_id_seq OWNED BY healthinsurance.health_claim_status.id;


--
-- Name: health_configurations; Type: TABLE; Schema: healthinsurance; Owner: qsoft
--

CREATE TABLE healthinsurance.health_configurations (
    id integer NOT NULL,
    insurance_policy_id integer,
    title character varying(255),
    premium_amount_total numeric(10,2),
    premium_installment_amount numeric(10,2),
    insurance_product_id integer,
    policy_tenure integer,
    policy_name character varying(255),
    policy_description text,
    policy_type character varying(50),
    min_age integer,
    max_age integer,
    gender character varying(10),
    premium_grace_period integer,
    claim_day_difference integer,
    frequency character varying(20),
    project_code character varying(50),
    ipd numeric(10,2),
    ipd_accommodation_limit numeric(10,2),
    opd numeric(10,2),
    natural_death numeric(10,2),
    accidental_death numeric(10,2),
    organ_loss numeric(10,2),
    permanent_total_disability numeric(10,2),
    permanent_partial_disability numeric(10,2),
    cesarean_delivery numeric(10,2),
    sum_insured numeric(10,2),
    updated_at timestamp without time zone DEFAULT now(),
    created_at timestamp without time zone
);


ALTER TABLE healthinsurance.health_configurations OWNER TO qsoft;

--
-- Name: health_configurations_id_seq; Type: SEQUENCE; Schema: healthinsurance; Owner: qsoft
--

CREATE SEQUENCE healthinsurance.health_configurations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE healthinsurance.health_configurations_id_seq OWNER TO qsoft;

--
-- Name: health_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: healthinsurance; Owner: qsoft
--

ALTER SEQUENCE healthinsurance.health_configurations_id_seq OWNED BY healthinsurance.health_configurations.id;


--
-- Name: health_insurance; Type: TABLE; Schema: healthinsurance; Owner: qsoft
--

CREATE TABLE healthinsurance.health_insurance (
    id integer NOT NULL,
    branchcode character varying(4),
    cono character varying(8),
    orgno character varying(6),
    orgmemno character varying(10),
    enrolment_id uuid,
    any_disease boolean,
    insurance_policy_id smallint,
    insurance_type_id smallint,
    category_id smallint,
    premium_amnt smallint,
    insurance_tenure smallint,
    insurance_policy_no character varying(50),
    nominee_name character varying(100),
    nominee_phone_no character varying(15),
    nominee_birthdate date,
    nominee_typeof_card_id smallint,
    nominee_card_id character varying(20),
    nominee_relation_id smallint,
    status smallint,
    created_at timestamp without time zone DEFAULT now(),
    updated_at character varying(30) DEFAULT now(),
    erp_member_id character varying(10),
    project_code smallint,
    contact_no character varying(20),
    nominee_id_front character varying,
    nominee_id_back character varying,
    card_issue_country character varying(64) DEFAULT 'Bangladesh'::character varying,
    card_issue_date date,
    card_expiry_date date,
    remarks text,
    member_name character varying(100)
);


ALTER TABLE healthinsurance.health_insurance OWNER TO qsoft;

--
-- Name: TABLE health_insurance; Type: COMMENT; Schema: healthinsurance; Owner: qsoft
--

COMMENT ON TABLE healthinsurance.health_insurance IS 'Health Insurance';


--
-- Name: health_insurance_erp_error_messages; Type: TABLE; Schema: healthinsurance; Owner: qsoft
--

CREATE TABLE healthinsurance.health_insurance_erp_error_messages (
    id integer NOT NULL,
    error_code character varying(10),
    error_english character varying,
    error_bangla character varying,
    created_at timestamp without time zone DEFAULT now(),
    updated_at character varying(30)
);


ALTER TABLE healthinsurance.health_insurance_erp_error_messages OWNER TO qsoft;

--
-- Name: TABLE health_insurance_erp_error_messages; Type: COMMENT; Schema: healthinsurance; Owner: qsoft
--

COMMENT ON TABLE healthinsurance.health_insurance_erp_error_messages IS 'health insurance erp server error messages';


--
-- Name: health_insurance_erp_error_messages_id_seq; Type: SEQUENCE; Schema: healthinsurance; Owner: qsoft
--

CREATE SEQUENCE healthinsurance.health_insurance_erp_error_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE healthinsurance.health_insurance_erp_error_messages_id_seq OWNER TO qsoft;

--
-- Name: health_insurance_erp_error_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: healthinsurance; Owner: qsoft
--

ALTER SEQUENCE healthinsurance.health_insurance_erp_error_messages_id_seq OWNED BY healthinsurance.health_insurance_erp_error_messages.id;


--
-- Name: health_insurance_id_seq; Type: SEQUENCE; Schema: healthinsurance; Owner: qsoft
--

CREATE SEQUENCE healthinsurance.health_insurance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE healthinsurance.health_insurance_id_seq OWNER TO qsoft;

--
-- Name: health_insurance_id_seq; Type: SEQUENCE OWNED BY; Schema: healthinsurance; Owner: qsoft
--

ALTER SEQUENCE healthinsurance.health_insurance_id_seq OWNED BY healthinsurance.health_insurance.id;


--
-- Name: health_insurance_products; Type: TABLE; Schema: healthinsurance; Owner: qsoft
--

CREATE TABLE healthinsurance.health_insurance_products (
    id integer NOT NULL,
    product_id smallint,
    product_name character varying(50),
    updated_at character varying(30) DEFAULT now()
);


ALTER TABLE healthinsurance.health_insurance_products OWNER TO qsoft;

--
-- Name: TABLE health_insurance_products; Type: COMMENT; Schema: healthinsurance; Owner: qsoft
--

COMMENT ON TABLE healthinsurance.health_insurance_products IS 'Health Insurance Product Table';


--
-- Name: health_insurance_products_id_seq; Type: SEQUENCE; Schema: healthinsurance; Owner: qsoft
--

CREATE SEQUENCE healthinsurance.health_insurance_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE healthinsurance.health_insurance_products_id_seq OWNER TO qsoft;

--
-- Name: health_insurance_products_id_seq; Type: SEQUENCE OWNED BY; Schema: healthinsurance; Owner: qsoft
--

ALTER SEQUENCE healthinsurance.health_insurance_products_id_seq OWNED BY healthinsurance.health_insurance_products.id;


--
-- Name: health_insurance_status; Type: TABLE; Schema: healthinsurance; Owner: qsoft
--

CREATE TABLE healthinsurance.health_insurance_status (
    id integer NOT NULL,
    status_id smallint,
    status_name character varying(15),
    updated_at character varying(30) DEFAULT now()
);


ALTER TABLE healthinsurance.health_insurance_status OWNER TO qsoft;

--
-- Name: TABLE health_insurance_status; Type: COMMENT; Schema: healthinsurance; Owner: qsoft
--

COMMENT ON TABLE healthinsurance.health_insurance_status IS 'Status';


--
-- Name: health_insurance_status_id_seq; Type: SEQUENCE; Schema: healthinsurance; Owner: qsoft
--

CREATE SEQUENCE healthinsurance.health_insurance_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE healthinsurance.health_insurance_status_id_seq OWNER TO qsoft;

--
-- Name: health_insurance_status_id_seq; Type: SEQUENCE OWNED BY; Schema: healthinsurance; Owner: qsoft
--

ALTER SEQUENCE healthinsurance.health_insurance_status_id_seq OWNED BY healthinsurance.health_insurance_status.id;


--
-- Name: oauth2; Type: TABLE; Schema: healthinsurance; Owner: qsoft
--

CREATE TABLE healthinsurance.oauth2 (
    id integer NOT NULL,
    expires_time character varying(255),
    expires_in character varying,
    access_token text
);


ALTER TABLE healthinsurance.oauth2 OWNER TO qsoft;

--
-- Name: oauth2_id_seq; Type: SEQUENCE; Schema: healthinsurance; Owner: qsoft
--

CREATE SEQUENCE healthinsurance.oauth2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE healthinsurance.oauth2_id_seq OWNER TO qsoft;

--
-- Name: oauth2_id_seq; Type: SEQUENCE OWNED BY; Schema: healthinsurance; Owner: qsoft
--

ALTER SEQUENCE healthinsurance.oauth2_id_seq OWNED BY healthinsurance.oauth2.id;


--
-- Name: payload_data; Type: TABLE; Schema: healthinsurance; Owner: qsoft
--

CREATE TABLE healthinsurance.payload_data (
    id integer NOT NULL,
    data_id integer,
    data_name character varying(50),
    data_type character varying(50),
    status integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    "data_nameBn" character varying(255)
);


ALTER TABLE healthinsurance.payload_data OWNER TO qsoft;

--
-- Name: payload_data_id_seq; Type: SEQUENCE; Schema: healthinsurance; Owner: qsoft
--

CREATE SEQUENCE healthinsurance.payload_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE healthinsurance.payload_data_id_seq OWNER TO qsoft;

--
-- Name: payload_data_id_seq; Type: SEQUENCE OWNED BY; Schema: healthinsurance; Owner: qsoft
--

ALTER SEQUENCE healthinsurance.payload_data_id_seq OWNED BY healthinsurance.payload_data.id;


--
-- Name: server_url; Type: TABLE; Schema: healthinsurance; Owner: qsoft
--

CREATE TABLE healthinsurance.server_url (
    id integer NOT NULL,
    url text,
    server_status smallint,
    status smallint,
    maintenance_status smallint,
    maintenance_message text,
    stopversion smallint,
    url2 text,
    server_url text
);


ALTER TABLE healthinsurance.server_url OWNER TO qsoft;

--
-- Name: TABLE server_url; Type: COMMENT; Schema: healthinsurance; Owner: qsoft
--

COMMENT ON TABLE healthinsurance.server_url IS 'Server URL';


--
-- Name: server_url_id_seq; Type: SEQUENCE; Schema: healthinsurance; Owner: qsoft
--

CREATE SEQUENCE healthinsurance.server_url_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE healthinsurance.server_url_id_seq OWNER TO qsoft;

--
-- Name: server_url_id_seq; Type: SEQUENCE OWNED BY; Schema: healthinsurance; Owner: qsoft
--

ALTER SEQUENCE healthinsurance.server_url_id_seq OWNED BY healthinsurance.server_url.id;


--
-- Name: cronjob_lastsync_time id; Type: DEFAULT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.cronjob_lastsync_time ALTER COLUMN id SET DEFAULT nextval('healthinsurance.cronjob_lastsync_time_id_seq'::regclass);


--
-- Name: health_category id; Type: DEFAULT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_category ALTER COLUMN id SET DEFAULT nextval('healthinsurance.health_category_id_seq'::regclass);


--
-- Name: health_claim_status id; Type: DEFAULT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_claim_status ALTER COLUMN id SET DEFAULT nextval('healthinsurance.health_claim_status_id_seq'::regclass);


--
-- Name: health_configurations id; Type: DEFAULT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_configurations ALTER COLUMN id SET DEFAULT nextval('healthinsurance.health_configurations_id_seq'::regclass);


--
-- Name: health_insurance id; Type: DEFAULT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_insurance ALTER COLUMN id SET DEFAULT nextval('healthinsurance.health_insurance_id_seq'::regclass);


--
-- Name: health_insurance_erp_error_messages id; Type: DEFAULT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_insurance_erp_error_messages ALTER COLUMN id SET DEFAULT nextval('healthinsurance.health_insurance_erp_error_messages_id_seq'::regclass);


--
-- Name: health_insurance_products id; Type: DEFAULT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_insurance_products ALTER COLUMN id SET DEFAULT nextval('healthinsurance.health_insurance_products_id_seq'::regclass);


--
-- Name: health_insurance_status id; Type: DEFAULT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_insurance_status ALTER COLUMN id SET DEFAULT nextval('healthinsurance.health_insurance_status_id_seq'::regclass);


--
-- Name: oauth2 id; Type: DEFAULT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.oauth2 ALTER COLUMN id SET DEFAULT nextval('healthinsurance.oauth2_id_seq'::regclass);


--
-- Name: payload_data id; Type: DEFAULT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.payload_data ALTER COLUMN id SET DEFAULT nextval('healthinsurance.payload_data_id_seq'::regclass);


--
-- Name: server_url id; Type: DEFAULT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.server_url ALTER COLUMN id SET DEFAULT nextval('healthinsurance.server_url_id_seq'::regclass);


--
-- Data for Name: cronjob_lastsync_time; Type: TABLE DATA; Schema: healthinsurance; Owner: qsoft
--

INSERT INTO healthinsurance.cronjob_lastsync_time VALUES (1, '0605', '2025-04-09 14:40:01');
INSERT INTO healthinsurance.cronjob_lastsync_time VALUES (2, '0641', '2025-04-25 01:20:03');


--
-- Data for Name: health_category; Type: TABLE DATA; Schema: healthinsurance; Owner: qsoft
--

INSERT INTO healthinsurance.health_category VALUES (4, 103, 'Shurokha-CAT-1', '2024-09-28 12:00:51');
INSERT INTO healthinsurance.health_category VALUES (5, 104, 'Shurokha-CAT-2', '2024-09-28 12:01:00');
INSERT INTO healthinsurance.health_category VALUES (6, 54, 'Shurokha-CAT-3', '2024-09-28 12:01:09');
INSERT INTO healthinsurance.health_category VALUES (1, 52, 'Momota-CAT-1', '2024-09-30 00:00:00');
INSERT INTO healthinsurance.health_category VALUES (2, 102, 'Momota-CAT-2', '2024-09-30 00:00:00');
INSERT INTO healthinsurance.health_category VALUES (3, 53, 'Momota-CAT-3', '2024-09-30 00:00:00');


--
-- Data for Name: health_claim_status; Type: TABLE DATA; Schema: healthinsurance; Owner: qsoft
--

INSERT INTO healthinsurance.health_claim_status VALUES (4, 4, 'Setttled', '2024-09-30 00:00:00');
INSERT INTO healthinsurance.health_claim_status VALUES (3, 3, 'Rejected', '2024-09-30 00:00:00');
INSERT INTO healthinsurance.health_claim_status VALUES (2, 2, 'Approved', '2024-09-30 00:00:00');
INSERT INTO healthinsurance.health_claim_status VALUES (1, 1, 'Claimed', '2024-09-30 00:00:00');


--
-- Data for Name: health_configurations; Type: TABLE DATA; Schema: healthinsurance; Owner: qsoft
--

INSERT INTO healthinsurance.health_configurations VALUES (1, 52, 'Momota-CAT-1', 680.00, 680.00, 1, 12, 'Momota Shastho Bima', 'Momota Shastho Bima', 'Maternity', 18, 39, 'FEMALE', 30, 0, 'SINGLE', NULL, 5500.00, 3500.00, 1000.00, 20000.00, 30000.00, 20000.00, 20000.00, 0.00, 10000.00, 70000.00, '2024-10-03 11:12:45.465043', NULL);
INSERT INTO healthinsurance.health_configurations VALUES (2, 53, 'Momota-CAT-3', 1180.00, 1180.00, 1, 12, 'Momota Shastho Bima', 'Momota Shastho Bima', 'Maternity', 18, 39, 'FEMALE', 30, 0, 'SINGLE', NULL, 15000.00, 10000.00, 2000.00, 20000.00, 40000.00, 20000.00, 20000.00, 0.00, 18000.00, 105000.00, '2024-10-03 11:12:45.465043', NULL);
INSERT INTO healthinsurance.health_configurations VALUES (3, 54, 'Shurokha-CAT-3', 1200.00, 1200.00, 2, 12, 'Shurokha Shastho Bima', 'Shurokha Shastho Bima', 'Universal', 18, 64, 'BOTH', 30, 0, 'SINGLE', NULL, 20000.00, 10000.00, 2000.00, 50000.00, 75000.00, 0.00, 50000.00, 25000.00, 0.00, 157000.00, '2024-10-03 11:12:45.465043', NULL);
INSERT INTO healthinsurance.health_configurations VALUES (4, 102, 'Momota-CAT-2', 980.00, 980.00, 1, 12, 'Momota Shastho Bima', 'Momota Shastho Bima', 'Maternity', 18, 39, 'FEMALE', 30, 0, 'SINGLE', NULL, 10000.00, 5000.00, 1500.00, 20000.00, 40000.00, 20000.00, 20000.00, 0.00, 15000.00, 91500.00, '2024-10-03 11:12:45.465043', NULL);
INSERT INTO healthinsurance.health_configurations VALUES (5, 103, 'Shurokha-CAT-1', 700.00, 700.00, 2, 12, 'Shurokha Shastho Bima', 'Shurokha Shastho Bima', 'Universal', 18, 64, 'BOTH', 30, 0, 'SINGLE', NULL, 6000.00, 4000.00, 1000.00, 40000.00, 60000.00, 0.00, 40000.00, 20000.00, 0.00, 111000.00, '2024-10-03 11:12:45.465043', NULL);
INSERT INTO healthinsurance.health_configurations VALUES (6, 104, 'Shurokha-CAT-2', 1000.00, 1000.00, 2, 12, 'Shurokha Shastho Bima', 'Shurokha Shastho Bima', 'Universal', 18, 64, 'BOTH', 30, 0, 'SINGLE', NULL, 12000.00, 8000.00, 1500.00, 50000.00, 75000.00, 0.00, 50000.00, 25000.00, 0.00, 146500.00, '2024-10-03 11:12:45.465043', NULL);


--
-- Data for Name: health_insurance; Type: TABLE DATA; Schema: healthinsurance; Owner: qsoft
--

INSERT INTO healthinsurance.health_insurance VALUES (35, '0605', '00128779', '2222', '12', '81059a74-4a69-4bc1-bf9a-92b299edb6ad', false, 2, 1, 103, 700, 12, '1319SC1445846620031-0', 'nomitest', '01976484679', '1996-04-08', 5, '9464518487', 7, 1, '2025-04-08 12:35:16.870734', '2025-04-08 16:32:10', '34144889', 15, '01976464878', '1744094116_IMG_২০২৫০৪০৮_১২৩৫০৩৬১১.jpg', '1744094116_IMG_২০২৫০৪০৮_১২৩৫১২৫৯৫.jpg', '', NULL, NULL, NULL, 'Mst. Halena');
INSERT INTO healthinsurance.health_insurance VALUES (47, '0641', '01553352', '5143', '34', '357bf496-0857-47cd-8b24-cf86b8121564', false, 2, 1, 103, 700, 12, '1319SC1733983769675-0', 'MD Abdul Kadir', '01676796548', '1981-08-27', 5, '1491340251', 13, 2, '2025-04-09 13:48:35.340309', '2025-04-25 01:20:03', '53591853', 15, '01610423039', '1744184915_IMG_২০২৫০৪০৯_১৩৪৭৩৩৮৩১.jpg', '1744184915_IMG_২০২৫০৪০৯_১৩৪৮২৩২৫৩.jpg', '', NULL, NULL, NULL, 'Nazma');
INSERT INTO healthinsurance.health_insurance VALUES (33, '0605', '00128779', '2291', '20', 'fe296e95-b9a2-4532-9fed-7f97f743d342', false, 1, 1, 53, 1180, 12, '1324MC3236178995194-0', 'test nominee ', '01794645458', '1991-04-08', 1, '79461648074839657', 7, 3, '2025-04-08 12:22:08.887497', '2025-04-08 16:32:10', '34144710', 15, '01794654848', '1744093328_IMG_২০২৫০৪০৮_১২২১১১৮৪২.jpg', '1744093328_IMG_২০২৫০৪০৮_১২২১৩১২৫৯.jpg', '', NULL, NULL, 'send', 'Kalpona Akter');
INSERT INTO healthinsurance.health_insurance VALUES (30, '0605', '00172700', '5220', '1', '8daaaa10-0e34-47d0-89c5-86088bbf4844', false, 2, 1, 104, 1000, 12, NULL, 'test ', '01745885558', '1997-03-20', 5, '9638855588', 7, 1, '2025-03-20 11:26:06.67733', '2025-03-20 11:30:11', '43552348', 15, '01745888888', '1742448366_IMG_২০২৫০৩২০_১১২৫২৪৬৮৮.jpg', '1742448366_IMG_২০২৫০৩২০_১১২৫২৯৩৬৭.jpg', '', NULL, NULL, 'chk', 'Anjuman Ara Dipa');
INSERT INTO healthinsurance.health_insurance VALUES (31, '0605', '00172700', '2035', '124', '11704ffb-cb12-48e0-bc27-77a5acbd89f1', false, 2, 1, 103, 700, 12, NULL, 'test ', '01400000000', '1989-03-20', 5, '9658888888', 6, 5, '2025-03-20 15:14:35.28548', '2025-03-20 15:14:35', '34147887', 15, '01700000000', '1742462075_IMG_২০২৫০৩২০_১৫১৪২১৮৬৪.jpg', '1742462075_IMG_২০২৫০৩২০_১৫১৪২৮৫৯৩.jpg', '', NULL, NULL, NULL, 'Khorsheda');
INSERT INTO healthinsurance.health_insurance VALUES (32, '0605', '00277774', '2085', '54', '9ef0e159-debc-448f-b679-bc5b787c0466', false, 2, 1, 104, 1000, 12, NULL, 'test', '01788888888', '2003-03-24', 3, 'RTr456688', 9, 7, '2025-03-24 14:49:45.777456', '2025-03-24 15:16:08', '34147011', 15, '01785888888', '1742806185_IMG_২০২৫০৩২৪_১৪৪৯৩২৯৭৮.jpg', '1742806185_IMG_২০২৫০৩২৪_১৪৪৯৩৯৫১৯.jpg', 'Bangladesh', '2005-03-24', '2029-03-24', 'দজ', 'Ambia');
INSERT INTO healthinsurance.health_insurance VALUES (40, '0641', '00258741', '2165', '2221', '4e80e930-8e9f-497a-905d-785b4ac70d90', false, 2, 1, 54, 1200, 12, '1321SC3891448247915-0', 'test', '01794354884', '1997-04-08', 5, '7964877884', 7, 3, '2025-04-08 13:04:23.57918', '2025-04-08 17:00:17', '51527928', 15, '01797964646', '1744095863_IMG_২০২৫০৪০৮_১৩০৪১৪৯৫৬.jpg', '1744095863_IMG_২০২৫০৪০৮_১৩০৪২০৪৮১.jpg', '', NULL, NULL, NULL, 'SUFIA');
INSERT INTO healthinsurance.health_insurance VALUES (34, '0605', '00128779', '5357', '13', 'ca57e95e-582a-4b56-977b-2eb11b4117b7', false, 2, 1, 54, 1200, 12, NULL, 'testnomi', '01948464887', '1996-04-08', 5, '4634548784', 7, 7, '2025-04-08 12:27:33.792784', '2025-04-08 12:30:02', '46092205', 15, '01976164848', '1744093653_IMG_২০২৫০৪০৮_১২২৭২০২৭৮.jpg', '1744093653_IMG_২০২৫০৪০৮_১২২৭৩০৩০৭.jpg', '', NULL, NULL, 'rejected', 'MSS AYASA BEGUM');
INSERT INTO healthinsurance.health_insurance VALUES (46, '0641', '00258741', '5007', '13', '596af440-d52c-4511-8278-7600b51c7a88', false, 2, 1, 103, 700, 12, '1319SC1191248152472-0', 'Md Malek', '01720118526', '1979-04-02', 5, '5504861856', 13, 2, '2025-04-09 13:33:20.644948', '2025-04-25 01:20:03', '35169161', 15, '01922819703', '1744184000_IMG_২০২৫০৪০৯_১৩৩২১৪৭৮৭.jpg', '1744184000_IMG_২০২৫০৪০৯_১৩৩২৩২১২০.jpg', '', NULL, NULL, NULL, 'Selina');
INSERT INTO healthinsurance.health_insurance VALUES (36, '0641', '00258741', '2034', '41', '176e0652-8e1a-4893-ad69-fa0fa9400843', false, 1, 1, 52, 680, 12, NULL, 'test', '01975545878', '1999-04-08', 2, '74850050825817458', 6, 5, '2025-04-08 12:52:55.113388', '2025-04-08 12:52:55', '35167732', 15, '01976454254', '1744095175_IMG_২০২৫০৪০৮_১২৫২৪২৭১৫.jpg', '1744095175_IMG_২০২৫০৪০৮_১২৫২৫০২৩১.jpg', '', NULL, NULL, NULL, 'Selina');
INSERT INTO healthinsurance.health_insurance VALUES (41, '0641', '00258741', '1003', '38', '1bef7c01-39f6-4102-ab45-8be0348b331c', false, 2, 1, 104, 1000, 12, NULL, 'sds', '01795664234', '1995-04-08', 5, '9656634967', 5, 5, '2025-04-08 17:14:55.431796', '2025-04-08 17:14:55', '35167011', 15, '01765464314', '1744110895_IMG_২০২৫০৪০৮_১৭১৪৪০৬৪৮.jpg', '1744110895_IMG_২০২৫০৪০৮_১৭১৪৪৯৭৩৮.jpg', '', NULL, NULL, NULL, 'Poulto');
INSERT INTO healthinsurance.health_insurance VALUES (37, '0641', '00258741', '2178', '447', 'f6d58c71-8793-4970-8001-ee91d1919a47', false, 2, 1, 104, 1000, 12, NULL, 'test', '01975642887', '1993-04-08', 5, '4182935040', 7, 7, '2025-04-08 12:53:56.021399', '2025-04-08 12:56:29', '35168667', 15, '01762550048', '1744095236_IMG_২০২৫০৪০৮_১২৫৩৪৭২৫৫.jpg', '1744095236_IMG_২০২৫০৪০৮_১২৫৩৫২১৪২.jpg', '', NULL, NULL, 'rejected', 'Jorina');
INSERT INTO healthinsurance.health_insurance VALUES (38, '0641', '00258741', '2231', '72', '7182b415-ef7e-4634-b65e-8f8052e84972', false, 1, 1, 53, 1180, 12, NULL, 'test', '01357869877', '1994-04-08', 5, '8785074561', 7, 5, '2025-04-08 12:55:08.51932', '2025-04-08 12:57:27', '35169451', 15, '01397597707', '1744095308_IMG_২০২৫০৪০৮_১২৫৪৫৬৫৩৮.jpg', '1744095308_IMG_২০২৫০৪০৮_১২৫৫০৫০৫৫.jpg', '', NULL, NULL, 'send', 'Firoja');
INSERT INTO healthinsurance.health_insurance VALUES (39, '0641', '00258741', '5007', '62', '0c06293c-8bea-4373-9c51-1cc475413111', false, 2, 1, 54, 1200, 12, NULL, 'test', '01916757899', '1996-04-08', 5, '4758609028', 7, 5, '2025-04-08 13:00:02.468467', '2025-04-08 13:00:02', '47160520', 15, '01917584507', '1744095602_IMG_২০২৫০৪০৮_১২৫৯৪৯৩১৮.jpg', '1744095602_IMG_২০২৫০৪০৮_১২৫৯৫৬৮৯৫.jpg', '', NULL, NULL, NULL, 'Mst RIMA AKTER');
INSERT INTO healthinsurance.health_insurance VALUES (45, '0641', '00258741', '2315', '345', '538eccc4-acb7-4d0c-8f42-73644a0a16dd', false, 1, 1, 102, 980, 12, NULL, 'test', '01762255556', '1999-04-09', 5, '4858595055', 7, 5, '2025-04-09 11:25:20.809198', '2025-04-09 11:25:20', '35171114', 15, '01792480059', '1744176320_IMG_২০২৫০৪০৯_১১২৫০১৭৯৯.jpg', '1744176320_IMG_২০২৫০৪০৯_১১২৫১১০৫১.jpg', '', NULL, NULL, NULL, 'Zannatul Mawa');
INSERT INTO healthinsurance.health_insurance VALUES (43, '0641', '00258741', '2006', '64', '440f27af-4898-4e46-8a07-824dbe3ae788', false, 2, 1, 103, 700, 12, NULL, 'aaa', '01765646416', '1995-04-08', 5, '9689563469', 5, 5, '2025-04-08 17:21:33.955499', '2025-04-08 17:21:33', '35167163', 15, '01796464646', '1744111293_IMG_২০২৫০৪০৮_১৭২১২৫৮৪৭.jpg', '1744111293_IMG_২০২৫০৪০৮_১৭২১৩১২২৭.jpg', '', NULL, NULL, NULL, 'Sukur Banu');
INSERT INTO healthinsurance.health_insurance VALUES (42, '0641', '00258741', '2165', '2221', 'b1a445d3-bb6c-443b-9602-66e203923bff', false, 2, 1, 104, 1000, 12, '1320SC233547877587-0', 'sdsd', '01761646464', '1995-04-08', 5, '4988523646', 5, 3, '2025-04-08 17:19:24.426765', '2025-04-25 01:20:03', '51527928', 15, '01794646463', '1744111164_IMG_২০২৫০৪০৮_১৭১৯১৪৮১৮.jpg', '1744111164_IMG_২০২৫০৪০৮_১৭১৯২০৩২৬.jpg', '', NULL, NULL, NULL, 'SUFIA');
INSERT INTO healthinsurance.health_insurance VALUES (49, '0641', '00265379', '5080', '24', '7fdd1a02-ff0d-4e69-a2f4-da9f551fd297', false, 2, 1, 103, 700, 12, '1319SC1898359524014-0', 'MD Suhal', '01762315570', '1981-03-18', 5, '1491403471', 13, 2, '2025-04-09 14:23:39.593655', '2025-04-25 01:20:03', '46226782', 15, '01985754685', '1744187019_IMG_২০২৫০৪০৯_১৪২২৪০৯১৭.jpg', '1744187019_IMG_২০২৫০৪০৯_১৪২২৫৮৯২৫.jpg', '', NULL, NULL, NULL, 'RENU BEGUM');
INSERT INTO healthinsurance.health_insurance VALUES (48, '0641', '00265379', '5080', '2', 'a0c92e08-46d8-4be0-afb0-2435fd75f454', false, 2, 1, 103, 700, 12, '1319SC115997172277-0', 'MD Sujon Mia', '01929484953', '1987-01-12', 5, '9570703513', 18, 2, '2025-04-09 14:18:34.421965', '2025-04-25 01:20:03', '35172274', 15, '01929532421', '1744186714_IMG_২০২৫০৪০৯_১৪১৭৪৪৪০০.jpg', '1744186714_IMG_২০২৫০৪০৯_১৪১৮০৮৯২৪.jpg', '', NULL, NULL, NULL, 'Aklima');
INSERT INTO healthinsurance.health_insurance VALUES (50, '0641', '00251358', '2316', '332', 'eec23e1d-77d0-4845-a35b-5aed5ec40ac6', false, 2, 1, 103, 700, 12, NULL, 'Md Abul Basar', '01611027906', '1959-02-01', 5, '9103875929', 13, 7, '2025-04-09 15:17:27.667579', '2025-04-09 15:21:44', '35171205', 15, '01929565563', '1744190247_IMG_২০২৫০৪০৯_১৪৩০১৬৮১৯.jpg', '1744190247_IMG_২০২৫০৪০৯_১৪৩০৩৩৬৩৯.jpg', '', NULL, NULL, 'nomlni aqe over', 'Rahima Begum');
INSERT INTO healthinsurance.health_insurance VALUES (44, '0641', '00258741', '2165', '35', '5886bd20-edf2-4e2f-b4d2-126e60951f32', false, 2, 1, 103, 700, 12, '1319SC1637904566460-0', 'test', '01917542845', '1996-04-09', 5, '7200808564', 7, 3, '2025-04-09 10:50:29.335544', '2025-04-25 01:20:03', '35168341', 15, '01765458470', '1744174229_IMG_২০২৫০৪০৯_১০৫০১৭৫০৬.jpg', '1744174229_IMG_২০২৫০৪০৯_১০৫০২৫৯৮৯.jpg', '', NULL, NULL, NULL, 'China Ahmed ');
INSERT INTO healthinsurance.health_insurance VALUES (51, '0641', '00095993', '5157', '6', '73eb5d36-786d-42e4-8d82-5061a36557b2', false, 1, 1, 53, 1180, 12, '1324MC3135483382958-0', 'Nazma Begum', '01674650814', '1977-10-09', 5, '6853754619', 14, 2, '2025-04-09 15:18:28.269823', '2025-04-25 01:20:03', '51849389', 15, '01611186544', '1744190308_IMG_২০২৫০৪০৯_১৫১৭৪৯৩২৯.jpg', '1744190308_IMG_২০২৫০৪০৯_১৫১৮০৩৩০৭.jpg', '', NULL, NULL, NULL, 'Ismat Ara Ishita ');


--
-- Data for Name: health_insurance_erp_error_messages; Type: TABLE DATA; Schema: healthinsurance; Owner: qsoft
--

INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (1, 'H-101', 'Project code cannot be null', 'প্রজেক্ট কোড খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (2, 'H-102', 'Vo code cannot be null', 'ভিও কোড খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (3, 'H-103', 'Member Id can not be null', 'সদস্য নম্বর খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (4, 'H-104', 'Vo is not active or invalid VO code', 'ভিও কোড ভুল অথবা ভিও কোড একটিভ নেই', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (5, 'H-105', 'Nominee Identification number is required', 'নমিনি পরিচয়পত্র নম্বর আবশ্যক', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (6, 'H-106', 'Member mobileNo cannot be null', 'সদস্যের মোবাইল নম্বর খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (7, 'H-107', 'Member cannot subscribe. Member has another policy active', 'সদস্যকে পলিসি দেওয়া যাচ্ছে না, সদস্যের একটিভ একটি পলিসি বিদ্যমান আছে ', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (8, 'H-108', 'Nominee name cannot be null', 'নমিনির নাম খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (9, 'H-109', 'Nominee dateOfBirth cannot be null', 'নমিনির জন্ম তারিখ খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (10, 'H-110', 'Nominee relationshipId cannot be null', 'সদস্যের  সাথে নমিনির সম্পর্ক খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (11, 'H-111', 'Nominee mobileNo cannot be null', 'নমিনির মোবাইল নম্বর খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (12, 'H-112', 'Nominee mobileNo is Invalid', 'নমিনির মোবাইল নম্বর ভুল প্রদান করা হয়েছে', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (13, 'H-113', 'Nominee national Id length must be 17', 'নমিনির জাতীয় পরিচয়পত্রের নম্বর অবশ্যই ১৭ ডিজিটের হতে হবে', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (14, 'H-114', 'Nominee birth certificate length must be 17', 'নমিনির জন্ম নিবন্ধন নম্বর অবশ্যই ১৭ ডিজিটের হতে হবে', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (15, 'H-115', 'Nominee passport length must be 9', 'নমিনির পাসপোর্ট নম্বর অবশ্যই ৯ ডিজিটের হতে হবে', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (16, 'H-116', 'Nominee smart card id length must be 10', 'নমিনির স্মার্ট আইডি নম্বর অবশ্যই ১০ ডিজিটের হতে হবে', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (17, 'H-117', 'Member''s age is outside the range allowed by this product', 'সদস্যের বয়স স্বাস্থ্য বিমা গ্রহণের বয়সসীমার মধ্যে নেই', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (18, 'H-118', 'Buffer Id must be unique!', 'বাফার আইডি অবশ্যই ইউনিক হতে হবে', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (19, 'H-119', 'Invalid branch code', 'ব্রাঞ্চ কোডটি সঠিক নয়', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (20, 'H-120', 'ERP member not found', 'ইআরপি সদস্য নম্বর পাওয়া যাচ্ছে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (21, 'H-121', 'Policy id is not valid', 'পলিসি আইডিটি সঠিক নয়', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (22, 'H-122', 'Member branch code does not match with provided branch code!', 'সদস্যের ব্রাঞ্চ কোডটি প্রদত্ত ব্রাঞ্চ কোডের সাথে মিলছে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (23, 'H-123', 'Member reference number does not match with ERP!', 'সদস্যের রেফারেন্স নম্বর ইআরপি-এর সাথে মিলছে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (24, 'H-124', 'Application date cannot be greater than business date', 'বিমা আবেদনের তারিখ সিস্টেমের তারিখের চেয়ে বেশি হতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (25, 'H-125', 'Member mobile No is Invalid', 'সদস্যর মোবাইল নম্বরটি সঠিক নয়', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (26, 'H-126', 'AssignPo pin does not match with ERP member po pin', 'এসাইন পিও-এর পিনটি ইআরপি সদস্যের পিও পিনের সাথে মিলছে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (27, 'H-127', 'Invalid or inactive project', 'প্রজেক্টের তথ্য সঠিক নয় অথবা একটিভ নয়', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (28, 'H-128', 'Project is not a valid for micro health insurance project', 'প্রকল্পটি নির্ভাবনা স্বাস্থ্য বিমা প্রকল্পের জন্য বৈধ নয়', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (29, 'H-129', 'Product id is not valid', 'প্রোডাক্ট আইডি বৈধ নয়', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (30, 'H-130', 'Selected product and policy are not correctly mapped!', 'সিলেক্টেড প্রোডাক্ট এবং পলিসি সঠিকভাবে ম্যাপ করা হয়নি', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (31, 'H-131', 'Member has no id card. Please add in member profile!', 'সদস্যের পরিচয়পত্র নেই, অনুগ্রহ করে মেম্বার প্রোফাইলে পরিচয়পত্র আপডেট করুন', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (32, 'H-132', 'Invalid Po pin/ Po is not available at this branch', 'পিও-এর পিন/ পিও-এর তথ্য ব্রাঞ্চে বিদ্যমান নেই', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (33, 'H-133', 'Nominee is over maximum age allowed by this product', 'নমিনির বয়স স্বাস্থ্য বিমা গ্রহণের সর্বোচ্চ বয়সসীমার ঊর্ধে', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (34, 'H-134', 'Nominee is under minimum age allowed by this product', 'নমিনির বয়স স্বাস্থ্য বিমা গ্রহণের নুন্যতম বয়সসীমার নিচে', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (35, 'H-135', 'Member gender is not allowed by this product', 'GENDER VALIDATION IS NOT REQUIRED', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (36, 'H-136', 'Only Female members are allowed to subscribe this policy', 'শুধুমাত্র নারী সদস্য এই বিমা পলিসি গ্রহণ করতে পারবেন', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (37, 'H-137', 'Male Member is not allowed to subscribe insurance more than once', 'পুরুষ সদস্য একসাথে একাধিক বিমা পলিসি গ্রহণ করতে পারবেন না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (38, 'H-138', 'Female Member is not allowed to subscribe insurance more than twice', 'নারী সদস্য একসাথে দুইটার বেশি বিমা পলিসি গ্রহণ করতে পারবেন না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (39, 'H-139', 'AssignedPo Pin can not be null', 'এসাইন পিও-এর পিন খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (40, 'H-140', 'Insurance Enrollment Buffer Id can not be null', 'ইন্স্যুরেন্স এনরোলমেন্ট বাফার আইডি খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (41, 'H-141', 'Insurance Policy Id can not be null', 'ইন্স্যুরেন্স পলিসি আইডি খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (42, 'H-142', 'Insurance Product Id can not be null', 'ইন্স্যুরেন্স প্রোডাক্ট আইডি খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);
INSERT INTO healthinsurance.health_insurance_erp_error_messages VALUES (43, 'H-143', 'Application date can not be null', 'বিমা আবেদনের তারিখ খালি থাকতে পারবে না', '2025-04-27 10:33:40.727274', NULL);


--
-- Data for Name: health_insurance_products; Type: TABLE DATA; Schema: healthinsurance; Owner: qsoft
--

INSERT INTO healthinsurance.health_insurance_products VALUES (1, 1, 'Momota Shastho Bima', '2024-09-30 00:00:00');
INSERT INTO healthinsurance.health_insurance_products VALUES (2, 2, 'Shurokha Shastho Bima', '2024-09-30 00:00:00');


--
-- Data for Name: health_insurance_status; Type: TABLE DATA; Schema: healthinsurance; Owner: qsoft
--

INSERT INTO healthinsurance.health_insurance_status VALUES (1, 1, 'ERP Pending', '2024-10-02 00:00:00');
INSERT INTO healthinsurance.health_insurance_status VALUES (2, 2, 'ERP Approved', '2024-10-02 00:00:00');
INSERT INTO healthinsurance.health_insurance_status VALUES (3, 3, 'ERP Rejected', '2024-10-02 00:00:00');
INSERT INTO healthinsurance.health_insurance_status VALUES (5, 5, 'BM Pending', '2024-10-02 10:34:43.738671+06');
INSERT INTO healthinsurance.health_insurance_status VALUES (6, 6, 'BM Sendback', '2024-10-02 10:35:01.605472+06');
INSERT INTO healthinsurance.health_insurance_status VALUES (7, 7, 'BM Rejected', '2024-10-02 10:35:16.314812+06');


--
-- Data for Name: oauth2; Type: TABLE DATA; Schema: healthinsurance; Owner: qsoft
--

INSERT INTO healthinsurance.oauth2 VALUES (104, '2025-05-05 15:45:36', '2025-05-05 14:45:36', 'hZmT9sQajAZzL8pn9992SMsV2XLjnCgssKsQm2OkNNeOG8mQ893Bu1Ird2QtEWq0dTe7KJDbU3k2o2LkxpxJ9Wluc3VyYW5jZS5icmFjLm5ldCRfJXp4Y3Zibm1wb2l1eXRycSFAOTg3NjUxMjM0JipRQVpXU1hFRENAJSNfUVdFUlRZVUlPUCFAIzk2NDUzMjEqJiQlbGtqaGdmZHNh');


--
-- Data for Name: payload_data; Type: TABLE DATA; Schema: healthinsurance; Owner: qsoft
--

INSERT INTO healthinsurance.payload_data VALUES (1, 1, 'Birth Certificate', 'cardTypeId', 1, '2021-10-02 01:45:45.553194', 'জন্ম নিবন্ধন সনদ (১৭ সংখ্যা)');
INSERT INTO healthinsurance.payload_data VALUES (2, 2, 'National ID', 'cardTypeId', 1, '2021-10-02 01:46:53.79474', 'জাতীয় পরিচয়পত্র (১৭ সংখ্যা)');
INSERT INTO healthinsurance.payload_data VALUES (3, 3, 'Passport', 'cardTypeId', 1, '2021-10-02 01:48:18.729516', 'পাসপোর্ট');
INSERT INTO healthinsurance.payload_data VALUES (4, 1, 'Pre-Primary', 'educationId', 1, '2021-08-31 15:19:38.457518', 'প্রাক-প্রাথমিক');
INSERT INTO healthinsurance.payload_data VALUES (5, 2, 'Primary', 'educationId', 1, '2021-08-31 15:19:43.238499', 'প্রাথমিক');
INSERT INTO healthinsurance.payload_data VALUES (6, 3, 'Secondary', 'educationId', 1, '2021-08-31 15:21:39.167361', 'মাধ্যমিক');
INSERT INTO healthinsurance.payload_data VALUES (7, 4, 'Higher Secondary', 'educationId', 1, '2021-08-31 15:21:46.646071', 'উচ্চ মাধ্যমিক');
INSERT INTO healthinsurance.payload_data VALUES (8, 5, 'Graduation', 'educationId', 1, '2021-08-31 15:21:51.612942', 'স্নাতক');
INSERT INTO healthinsurance.payload_data VALUES (9, 6, 'Post Graduation', 'educationId', 1, '2021-08-31 15:21:56.103393', 'স্নাতকোত্তর');
INSERT INTO healthinsurance.payload_data VALUES (10, 7, 'Others', 'educationId', 1, '2021-08-31 15:22:00.214003', 'অন্যান্য');
INSERT INTO healthinsurance.payload_data VALUES (11, 1, 'Male', 'genderId', 1, '2021-08-31 15:22:04.837378', 'পুরুষ');
INSERT INTO healthinsurance.payload_data VALUES (18, 2, 'House Wife', 'occupationId', 1, '2021-08-31 15:26:18.600014', 'গৃহিণী');
INSERT INTO healthinsurance.payload_data VALUES (12, 2, 'Female', 'genderId', 1, '2021-08-31 15:22:10.172038', 'নারী');
INSERT INTO healthinsurance.payload_data VALUES (19, 6, 'Business', 'occupationId', 1, '2021-08-31 15:26:24.135968', 'ব্যবসা');
INSERT INTO healthinsurance.payload_data VALUES (14, 2, 'Married', 'maritalStatusId', 1, '2021-08-31 15:25:17.693137', 'বিবাহিত');
INSERT INTO healthinsurance.payload_data VALUES (21, 8, 'Self-employed', 'occupationId', 1, '2021-08-31 15:28:20.811405', 'ক্ষুদ্র ব্যবসা');
INSERT INTO healthinsurance.payload_data VALUES (20, 7, 'Others', 'occupationId', 1, '2021-08-31 15:28:06.186946', 'অন্যান্য');
INSERT INTO healthinsurance.payload_data VALUES (22, 9, 'Service', 'occupationId', 1, '2021-08-31 15:28:25.893319', 'চাকুরী');
INSERT INTO healthinsurance.payload_data VALUES (23, 10, 'Agriculture', 'occupationId', 1, '2021-08-31 15:28:31.564832', 'কৃষি');
INSERT INTO healthinsurance.payload_data VALUES (24, 1, 'Aunty', 'relationshipId', 1, '2021-08-31 15:28:39.358229', 'খালা');
INSERT INTO healthinsurance.payload_data VALUES (25, 2, 'Brother', 'relationshipId', 1, '2021-08-31 15:28:43.118227', 'ভাই');
INSERT INTO healthinsurance.payload_data VALUES (27, 4, 'Colleague', 'relationshipId', 1, '2021-08-31 15:28:54.911174', 'সহকর্মী');
INSERT INTO healthinsurance.payload_data VALUES (28, 5, 'Cousin', 'relationshipId', 1, '2021-08-31 15:29:01.569021', 'চাচাতো ভাই/বোন');
INSERT INTO healthinsurance.payload_data VALUES (29, 6, 'Daughter', 'relationshipId', 1, '2021-08-31 15:29:08.732604', 'কন্যা');
INSERT INTO healthinsurance.payload_data VALUES (30, 7, 'Father', 'relationshipId', 1, '2021-08-31 15:29:19.228806', 'পিতা');
INSERT INTO healthinsurance.payload_data VALUES (31, 8, 'Father-In-Law', 'relationshipId', 1, '2021-08-31 15:29:31.898497', 'শ্বশুর');
INSERT INTO healthinsurance.payload_data VALUES (32, 9, 'Grand Father', 'relationshipId', 1, '2021-08-31 15:33:24.922234', 'দাদা');
INSERT INTO healthinsurance.payload_data VALUES (33, 10, 'Grand Mother', 'relationshipId', 1, '2021-08-31 15:33:34.34179', 'দাদি');
INSERT INTO healthinsurance.payload_data VALUES (34, 11, 'GrandSister', 'relationshipId', 1, '2021-08-31 15:33:38.365013', 'নাতনী');
INSERT INTO healthinsurance.payload_data VALUES (35, 12, 'Grand Son', 'relationshipId', 1, '2021-08-31 15:33:43.589816', 'নাতি');
INSERT INTO healthinsurance.payload_data VALUES (36, 13, 'Husband', 'relationshipId', 1, '2021-08-31 15:33:48.759647', 'স্বামী');
INSERT INTO healthinsurance.payload_data VALUES (37, 14, 'Mother', 'relationshipId', 1, '2021-08-31 15:33:54.81231', 'মাতা');
INSERT INTO healthinsurance.payload_data VALUES (38, 15, 'Mother-In-Law', 'relationshipId', 1, '2021-08-31 15:34:00.150851', 'শাশুড়ি');
INSERT INTO healthinsurance.payload_data VALUES (39, 16, 'Sister', 'relationshipId', 1, '2021-08-31 15:34:04.340803', 'বোন');
INSERT INTO healthinsurance.payload_data VALUES (40, 17, 'Sister-In-Law', 'relationshipId', 1, '2021-08-31 15:34:09.958397', 'শালী');
INSERT INTO healthinsurance.payload_data VALUES (41, 18, 'Son', 'relationshipId', 1, '2021-08-31 15:34:16.026317', 'ছেলে');
INSERT INTO healthinsurance.payload_data VALUES (42, 19, 'Son-In-Law', 'relationshipId', 1, '2021-08-31 15:34:21.199054', 'জামাই');
INSERT INTO healthinsurance.payload_data VALUES (44, 21, 'Uncle', 'relationshipId', 1, '2021-08-31 15:34:30.270023', 'চাচা');
INSERT INTO healthinsurance.payload_data VALUES (45, 22, 'Unknown', 'relationshipId', 1, '2021-08-31 15:34:33.527643', 'অজানা');
INSERT INTO healthinsurance.payload_data VALUES (46, 23, 'Wife', 'relationshipId', 1, '2021-08-31 15:34:50.754848', 'স্ত্রী');
INSERT INTO healthinsurance.payload_data VALUES (47, 24, 'Niece', 'relationshipId', 1, '2021-08-31 15:34:56.156289', 'ভাতিজি');
INSERT INTO healthinsurance.payload_data VALUES (51, 1, 'Cash', 'modeOfPaymentId', 1, '2021-10-02 02:30:25.916686', 'নগদ');
INSERT INTO healthinsurance.payload_data VALUES (52, 2, 'Bank', 'modeOfPaymentId', 1, '2021-10-02 02:31:10.400488', 'ব্যাংক');
INSERT INTO healthinsurance.payload_data VALUES (53, 1, 'Pending', 'loanProposalStatusId', 1, '2021-10-02 02:32:31.182431', 'বিচারাধীন');
INSERT INTO healthinsurance.payload_data VALUES (54, 2, 'Approved', 'loanProposalStatusId', 1, '2021-10-02 02:33:08.729888', 'অনুমোদিত');
INSERT INTO healthinsurance.payload_data VALUES (55, 3, 'Rejected', 'loanProposalStatusId', 1, '2021-10-02 02:33:34.396918', 'প্রত্যাখ্যাত');
INSERT INTO healthinsurance.payload_data VALUES (56, 4, 'Disbursed', 'loanProposalStatusId', 1, '2021-10-02 02:34:18.526014', 'বিতরণ করা হয়েছে');
INSERT INTO healthinsurance.payload_data VALUES (57, 4, 'Driving License', 'cardTypeId', 1, '2021-10-26 06:37:21.651234', 'ড্রাইভিং লাইসেন্স');
INSERT INTO healthinsurance.payload_data VALUES (58, 1, 'Self', 'primaryEarner', 1, '2021-11-06 06:37:00', 'নিজে');
INSERT INTO healthinsurance.payload_data VALUES (60, 3, 'Father', 'primaryEarner', 1, '2021-11-06 06:37:00', 'পিতা');
INSERT INTO healthinsurance.payload_data VALUES (61, 4, 'Mother', 'primaryEarner', 1, '2021-11-06 06:37:00', 'মাতা');
INSERT INTO healthinsurance.payload_data VALUES (62, 5, 'Children', 'primaryEarner', 1, '2021-11-06 06:37:00', 'ছেলে/মেয়ে');
INSERT INTO healthinsurance.payload_data VALUES (50, 5, 'Smart Card', 'cardTypeId', 1, '2021-10-02 01:53:22.885626', 'স্মার্ট কার্ড (১০ সংখ্যা)');
INSERT INTO healthinsurance.payload_data VALUES (59, 2, 'Spouse', 'primaryEarner', 1, '2021-11-06 06:37:00', 'স্বামী');
INSERT INTO healthinsurance.payload_data VALUES (63, 6, 'Others', 'primaryEarner', 1, '2021-11-06 06:37:00', 'অন্যান্য');
INSERT INTO healthinsurance.payload_data VALUES (43, 20, 'Spouse', 'relationshipId', 1, '2021-08-31 15:34:24.931037', 'স্বামী');
INSERT INTO healthinsurance.payload_data VALUES (15, 3, 'Single', 'maritalStatusId', 1, '2021-08-31 15:25:59.959161', 'সিঙ্গেল');
INSERT INTO healthinsurance.payload_data VALUES (26, 3, 'Brother-In-Law', 'relationshipId', 1, '2021-08-31 15:28:48.400236', 'শ্যালক');


--
-- Data for Name: server_url; Type: TABLE DATA; Schema: healthinsurance; Owner: qsoft
--

INSERT INTO healthinsurance.server_url VALUES (4, 'https://env37.erp.bracits.net/node/scapir/', 3, 0, 0, '', 0, 'https://bracapitesting.brac.net/healthinsurance/v1/', 'http://scmtest.brac.net/healthinsurance_dabi_pre/');
INSERT INTO healthinsurance.server_url VALUES (2, 'https://env26.erp.bracits.net/node/scapir/', 3, 0, 0, '', 0, 'https://env26.erp.bracits.net/smart-mf/healthinsurance/v1/', 'http://scmtest.brac.net/healthinsurance_dabi_pre/');
INSERT INTO healthinsurance.server_url VALUES (5, 'https://erpstaging.brac.net/node/scapir/', 3, 0, 0, '', 0, 'https://erpstaging.brac.net/api/healthinsurance/v1/', 'http://scmtest.brac.net/healthinsurance_dabi_pre/');
INSERT INTO healthinsurance.server_url VALUES (1, 'https://bracapitesting.brac.net/node/scapir/', 3, 0, 0, 'This is Test Message', 0, 'https://bracapitesting.brac.net/healthinsurance/v1/', 'http://scmtest.brac.net/healthinsurance_dabi_pre/');
INSERT INTO healthinsurance.server_url VALUES (3, 'https://erp.brac.net/node/scapir/', 1, 1, 0, '', 0, 'https://erp.brac.net/api/healthinsurance/v1/', 'http://scmtest.brac.net/healthinsurance_dabi_pre/');


--
-- Name: cronjob_lastsync_time_id_seq; Type: SEQUENCE SET; Schema: healthinsurance; Owner: qsoft
--

SELECT pg_catalog.setval('healthinsurance.cronjob_lastsync_time_id_seq', 2, true);


--
-- Name: health_category_id_seq; Type: SEQUENCE SET; Schema: healthinsurance; Owner: qsoft
--

SELECT pg_catalog.setval('healthinsurance.health_category_id_seq', 6, true);


--
-- Name: health_claim_status_id_seq; Type: SEQUENCE SET; Schema: healthinsurance; Owner: qsoft
--

SELECT pg_catalog.setval('healthinsurance.health_claim_status_id_seq', 4, true);


--
-- Name: health_configurations_id_seq; Type: SEQUENCE SET; Schema: healthinsurance; Owner: qsoft
--

SELECT pg_catalog.setval('healthinsurance.health_configurations_id_seq', 6, true);


--
-- Name: health_insurance_erp_error_messages_id_seq; Type: SEQUENCE SET; Schema: healthinsurance; Owner: qsoft
--

SELECT pg_catalog.setval('healthinsurance.health_insurance_erp_error_messages_id_seq', 45, true);


--
-- Name: health_insurance_id_seq; Type: SEQUENCE SET; Schema: healthinsurance; Owner: qsoft
--

SELECT pg_catalog.setval('healthinsurance.health_insurance_id_seq', 51, true);


--
-- Name: health_insurance_products_id_seq; Type: SEQUENCE SET; Schema: healthinsurance; Owner: qsoft
--

SELECT pg_catalog.setval('healthinsurance.health_insurance_products_id_seq', 2, true);


--
-- Name: health_insurance_status_id_seq; Type: SEQUENCE SET; Schema: healthinsurance; Owner: qsoft
--

SELECT pg_catalog.setval('healthinsurance.health_insurance_status_id_seq', 7, true);


--
-- Name: oauth2_id_seq; Type: SEQUENCE SET; Schema: healthinsurance; Owner: qsoft
--

SELECT pg_catalog.setval('healthinsurance.oauth2_id_seq', 104, true);


--
-- Name: payload_data_id_seq; Type: SEQUENCE SET; Schema: healthinsurance; Owner: qsoft
--

SELECT pg_catalog.setval('healthinsurance.payload_data_id_seq', 65, true);


--
-- Name: server_url_id_seq; Type: SEQUENCE SET; Schema: healthinsurance; Owner: qsoft
--

SELECT pg_catalog.setval('healthinsurance.server_url_id_seq', 5, true);


--
-- Name: cronjob_lastsync_time cronjob_lastsync_time_pkey; Type: CONSTRAINT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.cronjob_lastsync_time
    ADD CONSTRAINT cronjob_lastsync_time_pkey PRIMARY KEY (id);


--
-- Name: health_category health_category_pkey; Type: CONSTRAINT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_category
    ADD CONSTRAINT health_category_pkey PRIMARY KEY (id);


--
-- Name: health_claim_status health_claim_status_pkey; Type: CONSTRAINT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_claim_status
    ADD CONSTRAINT health_claim_status_pkey PRIMARY KEY (id);


--
-- Name: health_configurations health_configurations_pkey; Type: CONSTRAINT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_configurations
    ADD CONSTRAINT health_configurations_pkey PRIMARY KEY (id);


--
-- Name: health_insurance_erp_error_messages health_insurance_erp_error_messages_pkey; Type: CONSTRAINT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_insurance_erp_error_messages
    ADD CONSTRAINT health_insurance_erp_error_messages_pkey PRIMARY KEY (id);


--
-- Name: health_insurance health_insurance_pkey; Type: CONSTRAINT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_insurance
    ADD CONSTRAINT health_insurance_pkey PRIMARY KEY (id);


--
-- Name: health_insurance_products health_insurance_products_pkey; Type: CONSTRAINT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_insurance_products
    ADD CONSTRAINT health_insurance_products_pkey PRIMARY KEY (id);


--
-- Name: health_insurance_status health_insurance_status_pkey; Type: CONSTRAINT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.health_insurance_status
    ADD CONSTRAINT health_insurance_status_pkey PRIMARY KEY (id);


--
-- Name: oauth2 oauth2_pkey; Type: CONSTRAINT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.oauth2
    ADD CONSTRAINT oauth2_pkey PRIMARY KEY (id);


--
-- Name: payload_data payload_data_pkey; Type: CONSTRAINT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.payload_data
    ADD CONSTRAINT payload_data_pkey PRIMARY KEY (id);


--
-- Name: server_url server_url_pkey; Type: CONSTRAINT; Schema: healthinsurance; Owner: qsoft
--

ALTER TABLE ONLY healthinsurance.server_url
    ADD CONSTRAINT server_url_pkey PRIMARY KEY (id);


--
-- Name: SCHEMA healthinsurance; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA healthinsurance TO qsoft;


--
-- PostgreSQL database dump complete
--

