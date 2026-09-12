--
-- PostgreSQL database dump
--

\restrict 9Jt55Q602vjH679ndyCkuMX6ytHinIsVwYTsOtkuJXCfdlq1NOs4psOkKDmL7uv

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: admin_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.admin_status_enum AS ENUM (
    'ACTIVE',
    'ON_LEAVE',
    'SUSPENDED'
);


ALTER TYPE public.admin_status_enum OWNER TO postgres;

--
-- Name: application_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.application_status_enum AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);


ALTER TYPE public.application_status_enum OWNER TO postgres;

--
-- Name: assignment_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.assignment_status_enum AS ENUM (
    'ACTIVE',
    'COMPLETED',
    'CANCELLED'
);


ALTER TYPE public.assignment_status_enum OWNER TO postgres;

--
-- Name: crisis_severity_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.crisis_severity_enum AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH',
    'CRITICAL'
);


ALTER TYPE public.crisis_severity_enum OWNER TO postgres;

--
-- Name: crisis_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.crisis_status_enum AS ENUM (
    'ACTIVE',
    'CONTAINED',
    'RESOLVED'
);


ALTER TYPE public.crisis_status_enum OWNER TO postgres;

--
-- Name: donation_call_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.donation_call_status_enum AS ENUM (
    'OPEN',
    'CLOSED'
);


ALTER TYPE public.donation_call_status_enum OWNER TO postgres;

--
-- Name: donation_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.donation_status_enum AS ENUM (
    'INITIATED',
    'PAID',
    'FAILED'
);


ALTER TYPE public.donation_status_enum OWNER TO postgres;

--
-- Name: otp_purpose_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.otp_purpose_enum AS ENUM (
    'SIGNUP',
    'LOGIN'
);


ALTER TYPE public.otp_purpose_enum OWNER TO postgres;

--
-- Name: payment_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_status_enum AS ENUM (
    'SUCCESS',
    'FAILED'
);


ALTER TYPE public.payment_status_enum OWNER TO postgres;

--
-- Name: user_role_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role_enum AS ENUM (
    'ADMIN',
    'NGO',
    'VOLUNTEER',
    'DONOR'
);


ALTER TYPE public.user_role_enum OWNER TO postgres;

--
-- Name: volunteer_call_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.volunteer_call_status_enum AS ENUM (
    'OPEN',
    'CLOSED'
);


ALTER TYPE public.volunteer_call_status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    id integer NOT NULL,
    "fullName" character varying(60) NOT NULL,
    phone bigint NOT NULL,
    city character varying(40) NOT NULL,
    age integer NOT NULL,
    status public.admin_status_enum NOT NULL,
    "userId" integer,
    "profileImage" character varying(255)
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_id_seq OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_id_seq OWNED BY public.admin.id;


--
-- Name: announcement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.announcement (
    id integer NOT NULL,
    title character varying(120) NOT NULL,
    body text NOT NULL,
    "isUrgent" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "adminId" integer
);


ALTER TABLE public.announcement OWNER TO postgres;

--
-- Name: announcement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.announcement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.announcement_id_seq OWNER TO postgres;

--
-- Name: announcement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.announcement_id_seq OWNED BY public.announcement.id;


--
-- Name: announcement_recipient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.announcement_recipient (
    "announcementId" integer NOT NULL,
    "userId" integer NOT NULL
);


ALTER TABLE public.announcement_recipient OWNER TO postgres;

--
-- Name: application; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application (
    id integer NOT NULL,
    message character varying(300) NOT NULL,
    status public.application_status_enum DEFAULT 'PENDING'::public.application_status_enum NOT NULL,
    "appliedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "volunteerId" integer,
    "volunteerCallId" integer
);


ALTER TABLE public.application OWNER TO postgres;

--
-- Name: application_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.application_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.application_id_seq OWNER TO postgres;

--
-- Name: application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.application_id_seq OWNED BY public.application.id;


--
-- Name: assignment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assignment (
    id integer NOT NULL,
    "roleTitle" character varying(60) NOT NULL,
    status public.assignment_status_enum DEFAULT 'ACTIVE'::public.assignment_status_enum NOT NULL,
    "assignedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "applicationId" integer,
    "ngoId" integer
);


ALTER TABLE public.assignment OWNER TO postgres;

--
-- Name: assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.assignment_id_seq OWNER TO postgres;

--
-- Name: assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assignment_id_seq OWNED BY public.assignment.id;


--
-- Name: crisis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crisis (
    id integer NOT NULL,
    title character varying(120) NOT NULL,
    description text NOT NULL,
    category character varying(40) NOT NULL,
    severity public.crisis_severity_enum NOT NULL,
    status public.crisis_status_enum DEFAULT 'ACTIVE'::public.crisis_status_enum NOT NULL,
    city character varying(40) NOT NULL,
    "declaredAt" timestamp without time zone DEFAULT now() NOT NULL,
    "declaredByAdminId" integer
);


ALTER TABLE public.crisis OWNER TO postgres;

--
-- Name: crisis_follow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crisis_follow (
    "donorId" integer NOT NULL,
    "crisisId" integer NOT NULL
);


ALTER TABLE public.crisis_follow OWNER TO postgres;

--
-- Name: crisis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.crisis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.crisis_id_seq OWNER TO postgres;

--
-- Name: crisis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.crisis_id_seq OWNED BY public.crisis.id;


--
-- Name: crisis_participation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crisis_participation (
    "ngoId" integer NOT NULL,
    "crisisId" integer NOT NULL
);


ALTER TABLE public.crisis_participation OWNER TO postgres;

--
-- Name: donation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donation (
    id integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    message character varying(200) NOT NULL,
    status public.donation_status_enum DEFAULT 'INITIATED'::public.donation_status_enum NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "donorId" integer,
    "donationCallId" integer
);


ALTER TABLE public.donation OWNER TO postgres;

--
-- Name: donation_call; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donation_call (
    id integer NOT NULL,
    title character varying(120) NOT NULL,
    description text NOT NULL,
    "targetAmount" numeric(12,2) NOT NULL,
    "raisedAmount" numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    status public.donation_call_status_enum DEFAULT 'OPEN'::public.donation_call_status_enum NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "ngoId" integer,
    "crisisId" integer
);


ALTER TABLE public.donation_call OWNER TO postgres;

--
-- Name: donation_call_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.donation_call_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donation_call_id_seq OWNER TO postgres;

--
-- Name: donation_call_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.donation_call_id_seq OWNED BY public.donation_call.id;


--
-- Name: donation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.donation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donation_id_seq OWNER TO postgres;

--
-- Name: donation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.donation_id_seq OWNED BY public.donation.id;


--
-- Name: donor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donor (
    id integer NOT NULL,
    "uniqueId" character varying(150) NOT NULL,
    "fullName" character varying(60) NOT NULL,
    city character varying(40) NOT NULL,
    country character varying(30) DEFAULT 'Unknown'::character varying NOT NULL,
    "joiningDate" timestamp without time zone DEFAULT now() NOT NULL,
    "userId" integer,
    "profileImage" character varying(255)
);


ALTER TABLE public.donor OWNER TO postgres;

--
-- Name: donor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.donor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.donor_id_seq OWNER TO postgres;

--
-- Name: donor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.donor_id_seq OWNED BY public.donor.id;


--
-- Name: ngo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ngo (
    id integer NOT NULL,
    "orgName" character varying(100) NOT NULL,
    "regNumber" character varying(60) NOT NULL,
    "fullName" character varying(60),
    phone character varying(11) NOT NULL,
    city character varying(40) NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "userId" integer,
    "profileImage" character varying(255)
);


ALTER TABLE public.ngo OWNER TO postgres;

--
-- Name: ngo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ngo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ngo_id_seq OWNER TO postgres;

--
-- Name: ngo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ngo_id_seq OWNED BY public.ngo.id;


--
-- Name: otp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp (
    id integer NOT NULL,
    "codeHash" character varying(200) NOT NULL,
    purpose public.otp_purpose_enum NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "isUsed" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "userId" integer
);


ALTER TABLE public.otp OWNER TO postgres;

--
-- Name: otp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.otp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.otp_id_seq OWNER TO postgres;

--
-- Name: otp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.otp_id_seq OWNED BY public.otp.id;


--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    id integer NOT NULL,
    "cardLast4" character varying(4) NOT NULL,
    status public.payment_status_enum NOT NULL,
    "attemptedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "donationId" integer
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_id_seq OWNER TO postgres;

--
-- Name: payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_id_seq OWNED BY public.payment.id;


--
-- Name: receipt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt (
    id integer NOT NULL,
    "receiptNo" character varying(40) NOT NULL,
    amount numeric(12,2) NOT NULL,
    "issuedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "paymentId" integer
);


ALTER TABLE public.receipt OWNER TO postgres;

--
-- Name: receipt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.receipt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.receipt_id_seq OWNER TO postgres;

--
-- Name: receipt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.receipt_id_seq OWNED BY public.receipt.id;


--
-- Name: skill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skill (
    id integer NOT NULL,
    name character varying(40) NOT NULL
);


ALTER TABLE public.skill OWNER TO postgres;

--
-- Name: skill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skill_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skill_id_seq OWNER TO postgres;

--
-- Name: skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skill_id_seq OWNED BY public.skill.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    email character varying(100) NOT NULL,
    "passwordHash" character varying(200) NOT NULL,
    role public.user_role_enum NOT NULL,
    "isVerified" boolean DEFAULT false NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: volunteer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.volunteer (
    id integer NOT NULL,
    username character varying(40) NOT NULL,
    "fullName" character varying(60) NOT NULL,
    phone bigint NOT NULL,
    city character varying(40) NOT NULL,
    "isAvailable" boolean DEFAULT true NOT NULL,
    "totalHours" integer DEFAULT 0 NOT NULL,
    "userId" integer,
    "profileImage" character varying(255),
    email character varying(255),
    password character varying(255)
);


ALTER TABLE public.volunteer OWNER TO postgres;

--
-- Name: volunteer_call; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.volunteer_call (
    id integer NOT NULL,
    title character varying(120) NOT NULL,
    description text NOT NULL,
    slots integer NOT NULL,
    status public.volunteer_call_status_enum DEFAULT 'OPEN'::public.volunteer_call_status_enum NOT NULL,
    city character varying(40) NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "ngoId" integer,
    "crisisId" integer
);


ALTER TABLE public.volunteer_call OWNER TO postgres;

--
-- Name: volunteer_call_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.volunteer_call_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.volunteer_call_id_seq OWNER TO postgres;

--
-- Name: volunteer_call_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.volunteer_call_id_seq OWNED BY public.volunteer_call.id;


--
-- Name: volunteer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.volunteer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.volunteer_id_seq OWNER TO postgres;

--
-- Name: volunteer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.volunteer_id_seq OWNED BY public.volunteer.id;


--
-- Name: volunteer_skill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.volunteer_skill (
    "volunteerId" integer NOT NULL,
    "skillId" integer NOT NULL
);


ALTER TABLE public.volunteer_skill OWNER TO postgres;

--
-- Name: work_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.work_log (
    id integer NOT NULL,
    hours integer NOT NULL,
    note character varying(300) NOT NULL,
    "loggedAt" timestamp without time zone DEFAULT now() NOT NULL,
    "assignmentId" integer
);


ALTER TABLE public.work_log OWNER TO postgres;

--
-- Name: work_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_log_id_seq OWNER TO postgres;

--
-- Name: work_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.work_log_id_seq OWNED BY public.work_log.id;


--
-- Name: admin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin ALTER COLUMN id SET DEFAULT nextval('public.admin_id_seq'::regclass);


--
-- Name: announcement id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcement ALTER COLUMN id SET DEFAULT nextval('public.announcement_id_seq'::regclass);


--
-- Name: application id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application ALTER COLUMN id SET DEFAULT nextval('public.application_id_seq'::regclass);


--
-- Name: assignment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment ALTER COLUMN id SET DEFAULT nextval('public.assignment_id_seq'::regclass);


--
-- Name: crisis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crisis ALTER COLUMN id SET DEFAULT nextval('public.crisis_id_seq'::regclass);


--
-- Name: donation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation ALTER COLUMN id SET DEFAULT nextval('public.donation_id_seq'::regclass);


--
-- Name: donation_call id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation_call ALTER COLUMN id SET DEFAULT nextval('public.donation_call_id_seq'::regclass);


--
-- Name: donor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donor ALTER COLUMN id SET DEFAULT nextval('public.donor_id_seq'::regclass);


--
-- Name: ngo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ngo ALTER COLUMN id SET DEFAULT nextval('public.ngo_id_seq'::regclass);


--
-- Name: otp id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp ALTER COLUMN id SET DEFAULT nextval('public.otp_id_seq'::regclass);


--
-- Name: payment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment ALTER COLUMN id SET DEFAULT nextval('public.payment_id_seq'::regclass);


--
-- Name: receipt id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt ALTER COLUMN id SET DEFAULT nextval('public.receipt_id_seq'::regclass);


--
-- Name: skill id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skill ALTER COLUMN id SET DEFAULT nextval('public.skill_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: volunteer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer ALTER COLUMN id SET DEFAULT nextval('public.volunteer_id_seq'::regclass);


--
-- Name: volunteer_call id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_call ALTER COLUMN id SET DEFAULT nextval('public.volunteer_call_id_seq'::regclass);


--
-- Name: work_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_log ALTER COLUMN id SET DEFAULT nextval('public.work_log_id_seq'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (id, "fullName", phone, city, age, status, "userId", "profileImage") FROM stdin;
1	Test Admin	1712345600	Dhaka	30	ACTIVE	9	\N
\.


--
-- Data for Name: announcement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcement (id, title, body, "isUrgent", "createdAt", "adminId") FROM stdin;
\.


--
-- Data for Name: announcement_recipient; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcement_recipient ("announcementId", "userId") FROM stdin;
\.


--
-- Data for Name: application; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application (id, message, status, "appliedAt", "volunteerId", "volunteerCallId") FROM stdin;
1	I have first-aid experience	APPROVED	2026-08-01 01:23:25.708035	1	1
2	I can help with logistics	REJECTED	2026-08-01 01:23:25.708035	1	1
3	I would like to help with relief distribution	APPROVED	2026-08-30 21:13:30.60576	3	5
4	I have relevant field experience and would like to help	APPROVED	2026-09-07 07:13:35.401808	1	6
5	I am available on weekends and have first-aid training	PENDING	2026-09-07 07:25:46.913082	2	6
6	test	PENDING	2026-09-12 11:25:57.340351	5	7
\.


--
-- Data for Name: assignment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assignment (id, "roleTitle", status, "assignedAt", "applicationId", "ngoId") FROM stdin;
1	Flood relief volunteers (updated)	COMPLETED	2026-08-01 01:24:21.868557	1	5
2	Flood Relief Volunteers Needed	ACTIVE	2026-08-30 21:13:42.17231	3	7
3	test	ACTIVE	2026-09-07 07:13:54.043888	4	12
\.


--
-- Data for Name: crisis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crisis (id, title, description, category, severity, status, city, "declaredAt", "declaredByAdminId") FROM stdin;
1	Flood in Dhaka	Severe monsoon flooding across low-lying areas of Dhaka.	Flood	HIGH	ACTIVE	Dhaka	2026-07-31 03:20:03.901552	\N
2	Cyclone Alert Chittagong	Category 3 cyclone approaching the Chittagong coast.	Cyclone	CRITICAL	ACTIVE	Chittagong	2026-07-31 03:20:03.901552	\N
3	Landslide in Sylhet	Hillside collapse after continuous rainfall.	Landslide	MEDIUM	CONTAINED	Sylhet	2026-07-31 03:20:03.901552	\N
4	Flood in Sylhet	Severe flooding affecting thousands	Flood	HIGH	ACTIVE	Sylhet	2026-08-30 21:08:22.720472	1
\.


--
-- Data for Name: crisis_follow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crisis_follow ("donorId", "crisisId") FROM stdin;
\.


--
-- Data for Name: crisis_participation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crisis_participation ("ngoId", "crisisId") FROM stdin;
5	2
6	1
6	2
7	4
12	1
23	1
\.


--
-- Data for Name: donation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donation (id, amount, message, status, "createdAt", "donorId", "donationCallId") FROM stdin;
1	5000.00	Happy to help with the flood relief	PAID	2026-09-07 07:12:58.581897	2	4
2	500.00	test	PAID	2026-09-12 11:25:57.34729	3	5
\.


--
-- Data for Name: donation_call; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donation_call (id, title, description, "targetAmount", "raisedAmount", status, "createdAt", "ngoId", "crisisId") FROM stdin;
2	Cyclone fund	Emergency supplies	75000.50	0.00	OPEN	2026-08-01 00:44:36.898397	5	2
1	Flood relief fund	Food, shelter, medicine	50000.00	0.00	CLOSED	2026-08-01 00:44:36.81483	5	1
4	test	Test	30000.00	5000.00	OPEN	2026-09-07 05:06:40.235947	12	1
5	Flood relief fund	Emergency funds for flood-affected families in Dhaka.	50000.00	500.00	OPEN	2026-09-12 11:24:40.939264	23	1
\.


--
-- Data for Name: donor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donor (id, "uniqueId", "fullName", city, country, "joiningDate", "userId", "profileImage") FROM stdin;
1	DONOR-1788743562	Jane Doe	Dhaka	Bangladesh	2026-09-07 07:12:42.345216	27	\N
2	DONOR-1788743570	Jane Doe	Dhaka	Bangladesh	2026-09-07 07:12:49.62452	28	\N
3	DEMO-DONOR-1789190757	XYZ Donor	Dhaka	Bangladesh	2026-09-12 11:25:57.342807	32	\N
\.


--
-- Data for Name: ngo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ngo (id, "orgName", "regNumber", "fullName", phone, city, "isActive", "userId", "profileImage") FROM stdin;
1	Relief Corps	REG-2026-001	\N	1712345678	Dhaka	t	1	\N
2	Relief Corps	REG-2026-001	\N	1712345678	Dhaka	t	2	\N
3	Hope Foundation	REG-2026-002	\N	1812345678	Chittagong	t	3	\N
4	Test Aid Org	REG-2026-003	\N	1912345678	Sylhet	t	4	\N
5	Zero Test Org Renamed	REG-2026-004B	Rezwoan Khan	01911223344	Khulna	t	5	/uploads/ngo/1785589333665-642565126.png
6	Relief	REG-2026-001	\N	01712345678	Dhaka	t	7	\N
7	Test Relief Org	REG-001	\N	01712345678	Dhaka	t	8	\N
8	Test Relief Org	NGO-TEST-001	\N	01700000099	Dhaka	t	12	\N
9	Home	NGO-TEST-000	\N	01643751861	Rajbari	t	13	\N
10	Home	NGO-TEST-000	\N	01643751861	Rajbari	t	14	\N
11	OTP Fix Test Org	REG-OTPFIX-01	\N	01712345678	Dhaka	t	15	\N
12	Home	NGO-TEST-000	\N	01643751861	Rajbari	t	16	\N
13	Test Org	REG-1788541706	\N	01712345678	Dhaka	t	17	\N
14	Role Test	REG-ROLE-1	\N	01712345678	Dhaka	t	19	\N
15	UI Test Org	UITEST-0001	\N	01700000099	Dhaka	t	20	\N
16	UI Test Org 2	UITEST-0002	\N	01700000098	Dhaka	t	21	\N
17	UI Test Org 3	UITEST-0003	\N	01700000097	Dhaka	t	22	\N
18	UI Test Org 5	UITEST-0005	\N	01700000095	Dhaka	t	23	\N
19	UI Test Org 7	UITEST-0007	\N	01700000093	Dhaka	t	24	\N
20	Debug Org	DEBUG-0001	\N	01700000091	Dhaka	t	25	\N
21	UI Test Org 9	UITEST-0009	\N	01700000089	Dhaka	t	26	\N
22	CrisisConnect Relief Foundation	NGO-2024-T2	\N	01700000099	Dhaka	t	29	\N
23	Demo Relief Org	REG-DEMO-001	\N	01700000000	Dhaka	t	30	\N
\.


--
-- Data for Name: otp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.otp (id, "codeHash", purpose, "expiresAt", "isUsed", "createdAt", "userId") FROM stdin;
1	$2b$10$tJFBt3m7/5IuuKfn1Imz7OuRJjL5J4qINuS.6PBMgXqSwlaNtQQXq	SIGNUP	2026-07-30 20:21:42.133	f	2026-07-30 20:11:42.135591	1
2	$2b$10$QanJDaL2MfQMO7fQVYpRYO.GqPS0WEVUtlWdHzzaRz2rqpIOA73Gy	SIGNUP	2026-07-30 20:26:22.487	f	2026-07-30 20:16:22.488639	2
3	$2b$10$lKtAGJJV0WZokyL5nTes2uiIFbWYupkSKWqnDBQQtCrRyx/8pHYS2	SIGNUP	2026-07-30 20:40:50.994	f	2026-07-30 20:30:50.997408	2
4	$2b$10$aaDCnajUC.sTh6uslynov.7YvQCV088aOG/Otr6lrAN.T8pAFz.8y	SIGNUP	2026-07-30 20:41:16.368	f	2026-07-30 20:31:16.369852	3
5	$2b$10$WmAzJWIC7LFJumeVtEdWl.ZXdORJlVR4oUFxhOQCwo3rv1cO5hode	SIGNUP	2026-07-30 20:49:49.927	f	2026-07-30 20:39:49.928037	2
6	$2b$10$rFZ0KupSmAOwQN44ZPlmUeFS/Q6DPQ9zZKviNZR/2OObcJe7QyvU2	SIGNUP	2026-07-30 20:56:41.866	t	2026-07-30 20:46:41.868738	1
7	$2b$10$25LFrPDS13LnD6pUzPIp/OxYRGS4hWh4kpMZilBBT.nmx/C9Er1UC	SIGNUP	2026-07-30 21:01:10.479	t	2026-07-30 20:51:10.480886	4
8	$2b$10$Mxh3DxyuaPLKQtGEmzv0VO4dP0X/7u0fUNxD1tavEQpFLiXxDjA8W	LOGIN	2026-07-30 21:02:07.633	t	2026-07-30 20:52:07.635049	4
9	$2b$10$ILpI3C0nxy6BfMv.zWzTVuYZ7VRYO7sc19.C8pDrPRN2iu4kklIcC	SIGNUP	2026-07-31 03:30:32.91	t	2026-07-31 03:20:32.911683	5
10	$2b$10$CXPdJ/Ge8x6UifaZpipLtOU2WYSLEBlWadhvHD9u8a6brgqGIlQfC	LOGIN	2026-07-31 03:31:40.281	f	2026-07-31 03:21:40.281913	5
11	$2b$10$NwEG5cwXU0UglzIjcB.zhOYJPgGW5PkolR675eyMwpqNNdb6T6nWu	SIGNUP	2026-08-03 02:43:11.536	t	2026-08-03 02:33:11.538621	7
12	$2b$10$C7dBWNeHts8DDvgFZMSQLeMriAUXAK4TDrPCm7efIZH0zbM0BhrsO	LOGIN	2026-08-03 02:45:21.803	t	2026-08-03 02:35:21.804569	7
36	$2b$10$tHEfbzAA9zm0NIM/VGFS0.nMwip36uW0ZbLU.qROOgEqadzNUVy/e	SIGNUP	2026-09-12 11:32:21.342	t	2026-09-12 11:22:21.344868	30
13	$2b$10$caFaHuaoQ4T9pKVb82OMs.58dcur4XUnE5NU9ttKEfHpDcmHgyo8a	SIGNUP	2026-08-30 21:16:02.313	t	2026-08-30 21:06:02.316108	8
14	$2b$10$CfQqvPc6ENTjUvILYjUvm.ebj4JdknaaFZih3LDdDzrvYvnvdv2se	LOGIN	2026-08-30 21:17:17.989	t	2026-08-30 21:07:17.990886	8
37	$2b$10$JiM7/YL/acB51i7tZkBvp.cXDJVGR9T73zFOwwN9vh3192ooAegKS	LOGIN	2026-09-12 11:33:10.893	t	2026-09-12 11:23:10.896203	30
15	$2b$10$XMI/wVFru3IBLymusH0aM.y7lkp42Bu5FctS/4qA0lATTFp9O/DWG	SIGNUP	2026-08-30 21:17:53.141	t	2026-08-30 21:07:53.143561	9
16	$2b$10$2Cb8bLDY.pkdxISH06srJOGVhOSoh0n1/eEpqNrJr3DD5d2r1nrTy	LOGIN	2026-08-30 21:18:04.251	t	2026-08-30 21:08:04.252605	9
17	$2b$10$M6WFXTfdVMfsui527fy/Uu7a09V1VD4wiihM9bZiZ.wX.KHGIi1b6	SIGNUP	2026-08-30 21:22:38.331	t	2026-08-30 21:12:38.332066	11
18	$2b$10$7m4qdVYbX43OE9J0QGwxB.DDZqNzb9rgwEOghE1tiuf0qIuoJ2Lc.	LOGIN	2026-08-30 21:22:48.749	t	2026-08-30 21:12:48.750377	11
19	$2b$10$RI2bLj0PaWAJM3myx8tAq..SnJazLXrosIeWcvdCIGtoxTZe1yuHG	SIGNUP	2026-08-30 22:13:57.757	f	2026-08-30 22:03:57.758228	12
20	$2b$10$62gpZVoarzGJ3K91kV9bPuWfOyBmMwc4xkvqxVqogahypu4Yf/Psa	LOGIN	2026-08-30 22:24:39.982	f	2026-08-30 22:14:39.983356	12
21	$2b$10$UtpibMU69haZ3QGg3fpoquusNTzn5pXUgjkF4q3FtMzvVNILis6fq	SIGNUP	2026-09-01 20:35:05.567	f	2026-09-01 20:25:05.569019	13
22	$2b$10$8/rYg9.A2YWdRLYkWuE9g.4C.sroQQQoK.J9YAPR4A5aNPC4BtlXS	SIGNUP	2026-09-01 20:35:48.285	f	2026-09-01 20:25:48.286492	14
23	$2b$10$1nOw.EPARdc/YULF2lt4zO83osJnKrS2pRVAQa1tOXEGQq/F8PfNW	SIGNUP	2026-09-04 23:18:27.195	f	2026-09-04 23:08:27.19689	17
24	$2b$10$wTeo2StQ8XUFlUjDPi0Z.OdS6wF1YMuZRe29oge8O/jnMSDCRsGi2	SIGNUP	2026-09-04 23:18:31.099	f	2026-09-04 23:08:31.10072	18
25	$2b$10$qfxxCk8Hoxirn6MeXzf5KuSjWcg7e7zO6hI41B31bsuTfxZZnpxRm	SIGNUP	2026-09-04 23:18:44.333	f	2026-09-04 23:08:44.335097	19
26	$2b$10$XWawMuvpLq87w/QqKdet.ePBGzG2xGBpXiToHhi0uOO.Fos1f3PIq	SIGNUP	2026-09-07 03:21:16.946	f	2026-09-07 03:11:16.947386	20
27	$2b$10$eQhc8ls5.UJ/QyuyHgfm8e.aChyT9kfjixVup/VghbSkRXFbqqJCu	SIGNUP	2026-09-07 04:04:15.003	f	2026-09-07 03:54:15.004473	21
28	$2b$10$6X5bpl0rrPFoFi17MU/95.oqf6T4b3tBfMSNq9BeuneLT7h34zIFO	SIGNUP	2026-09-07 04:09:23.587	f	2026-09-07 03:59:23.587745	22
29	$2b$10$wX1cbnHmyEfPWS2veDNuGuaH3fDN5nq3U1V5LhEK15MBxQ9EoW5U.	SIGNUP	2026-09-07 04:11:44.18	f	2026-09-07 04:01:44.180931	23
30	$2b$10$EnO6KNwZhYX1.wluJaFLmOMrnrs25CLgXo2IT08LaZitMMz9JXbrC	SIGNUP	2026-09-07 04:50:35.184	f	2026-09-07 04:40:35.185066	24
31	$2b$10$aEBvzhxLbY8f/nSmp0nZ2eTUIRk.45AG77LuZS01n88sksX0epnJ2	SIGNUP	2026-09-07 04:53:16.78	f	2026-09-07 04:43:16.782221	25
32	$2b$10$cICsHBCA2k4QcoTO7.vWquvmQ85Oe/hZgnuzqjtCa/YKRMAv9yTfy	SIGNUP	2026-09-07 04:57:03.104	f	2026-09-07 04:47:03.105802	26
33	$2b$10$C.4cioXvL2rHi0LX7eFxO.F76klF2QjnZ8AE2s/3kcZ/pFT2V1n8u	LOGIN	2026-09-07 05:01:24.49	t	2026-09-07 04:51:24.49166	16
34	$2b$10$90Qk7Wnp7XLBpX.oMvI4je/Ey2M9mpt2lLnalJ3qDF4XYsGHocE9a	SIGNUP	2026-09-08 01:25:46.92	t	2026-09-08 01:15:46.921258	29
35	$2b$10$e6FZ1zlu4TTubrtXvG7YKeiyuNyCh9giFhB1k43DgtqoqHquRfMdq	LOGIN	2026-09-08 01:26:52.89	t	2026-09-08 01:16:52.890938	29
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (id, "cardLast4", status, "attemptedAt", "donationId") FROM stdin;
\.


--
-- Data for Name: receipt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receipt (id, "receiptNo", amount, "issuedAt", "paymentId") FROM stdin;
\.


--
-- Data for Name: skill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skill (id, name) FROM stdin;
1	first aid
2	logistics
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, email, "passwordHash", role, "isVerified", "isActive", "createdAt") FROM stdin;
2	reezzrex+ngotest@gmail.com	$2b$10$.ZiVmnF2h0EuNRCTDi9aeOaWxP29GGLhYpQp7SfhMP4J..jbT372C	NGO	f	t	2026-07-30 20:16:22.411422
3	reezzrex+ngotest2@gmail.com	$2b$10$ddNWa.BbnCZR6KFUc4dhFOkyBhsR4BCHsk6Mn2BXV95CS9qNfLDv2	NGO	f	t	2026-07-30 20:31:16.296939
1	frezwoan+testcc@gmail.com	$2b$10$zduFcHzZLF7SDAm0ztqDUudJ1jYmVcgYNYUBuBr8GwwHqDEIc1rr6	NGO	t	t	2026-07-30 20:11:42.064376
4	frezwoan+ngo2@gmail.com	$2b$10$UwzBTSsGWVLbIxxDR0r/uesFjqJchrikI65MHYOjPB/hn0eKAUncG	NGO	t	t	2026-07-30 20:51:10.426202
5	frezwoan+phone1@gmail.com	$2b$10$AyFC9.aet2i1xmnMZ46.4.7sRARtAeLFS0dcfrJZffl9es8thmtBu	NGO	t	t	2026-07-31 03:20:32.848129
6	frezwoan+vol1@gmail.com	$2b$10$dKJ7aPVFa4jmz1v6fYPqWOsjVrxOlbXSuM9wB399NHPH1jQ1wguQO	VOLUNTEER	t	t	2026-08-01 01:23:25.696194
7	frezwoan+test@gmail.com	$2b$10$U7vaSrpqOfXHJcFsfAelB.xNtbIocxQQ0gGzqIJSL4iwWQRbfaIAK	NGO	t	t	2026-08-03 02:33:11.324656
8	testngo@example.com	$2b$10$TdsWKwgSm3EZSyH4ROAORexvx7oaaH3Mwn71rwrqJXsF0MmplP8EO	NGO	t	t	2026-08-30 21:06:02.236215
9	testadmin@example.com	$2b$10$kKKrWQd2qDLuIQ5ut/mXXOogFeBePwmvT7QQ7B3KeYbUWnmtZmKIO	ADMIN	t	t	2026-08-30 21:07:53.067667
10	testvolunteer@gmail.com	$2b$10$sUz817PNuDqhYLHlJuFi..TP/U22JupWjYfbsDzks5ghOsW.DQHyO	VOLUNTEER	t	t	2026-08-30 21:09:11.285351
11	testvolunteer2@gmail.com	$2b$10$93oUghyNnbP6Yj.Uy.mXceSZaVdMXaV3b8RY8J3wTlzVbkvCGhNgq	VOLUNTEER	t	t	2026-08-30 21:12:38.234364
12	chrometest1@example.com	$2b$10$vfPyOAw4zYuuf.f9hpKU4eNk8CTsHBJdRpT0Qj8GN72Hweznalo5S	NGO	t	t	2026-08-30 22:03:57.674352
13	frezwoan+ngoTest@gmail.com	$2b$10$xSeFman4GJRQsdob2yZTIe9F0zQxZo9mm.udmwWdrqTylvAIlTIh.	NGO	f	t	2026-09-01 20:25:05.487169
14	frezwoan+adfasdfasdf@gmail.com	$2b$10$dY5RMIPenKhMNiE0.f/76OwmlytkMZLAtwnkpDy62BUkNS/WnhXwG	NGO	f	t	2026-09-01 20:25:48.215514
15	otpfixtest1@example.com	$2b$10$7bHQPuoSTk0MeqxbfxrQGOGMBYxp0MVilQ9MwruQRp0wZvRS9hS6a	NGO	t	t	2026-09-01 20:56:39.377093
16	frezwoan+cri@gmail.com	$2b$10$slSP6dcvZH6cWwV5SRE17evK/her3I7Wml3bq0tSixXr1LMN7Y3yi	NGO	t	t	2026-09-02 03:46:59.436979
17	otprestoretest1788541706@example.com	$2b$10$phSMyW96UJ9/pmsRbcppU.AwDraELRhUogt67uly7NrKRPwhuEyGm	NGO	f	t	2026-09-04 23:08:27.127481
18	voltest1788541706@gmail.com	$2b$10$ok4sF7m01TNGu.jJ76hON.14DEUTez5OTrFPNv.hMwTIppVcrBhKm	VOLUNTEER	f	t	2026-09-04 23:08:31.042082
19	roletest1@example.com	$2b$10$tpc8ti6ddW5u9UUs8o.9.O.ls2vf7gvn/qy3BYk7qpMVfvEfFjZzy	NGO	f	t	2026-09-04 23:08:44.274184
20	frezwoan+ngouitest2@gmail.com	$2b$10$Sy3CPoa/4b0nkyjqmRfzGenMInO.zr4fk3SDlEXABphCghjViLih.	NGO	f	t	2026-09-07 03:11:16.887733
21	frezwoan+ngouitest3@gmail.com	$2b$10$mSig19tbXF.QBRBR.lBclOW1/WzI8ljGx8zeV8aPQcmd44JNrPPg2	NGO	f	t	2026-09-07 03:54:14.937393
22	frezwoan+ngouitest4@gmail.com	$2b$10$AXXLOjxOeN4PRWBqW4aE9.HPQCANUWxm2jZ6.JlcvhC1s7fAk8xi6	NGO	f	t	2026-09-07 03:59:23.53211
23	frezwoan+ngouitest6@gmail.com	$2b$10$yW9twhZpUVOTMBh0fJDI8OtspyyI2e3TxP6ytSuwT0N8T18TcDSd.	NGO	f	t	2026-09-07 04:01:44.126352
24	frezwoan@gmail.com	$2b$10$bmF46PC7QRqfLyIMpii2ludzK7A1YcL6UQKLgoWlf9572z2Kkvml6	NGO	f	t	2026-09-07 04:40:35.129362
25	debugtest001@gmail.com	$2b$10$9dZzvbG6sMO1KRNHldQJSuWwMR32GJbH6UXShfzO38KX/t0wDHdja	NGO	f	t	2026-09-07 04:43:16.722724
26	frezwoan+ngofixed@gmail.com	$2b$10$zdpbQF/yiNxgff6KFNsW3enx2IyDLTOFJt1vRai5xI9AGMnohW6eq	NGO	f	t	2026-09-07 04:47:03.042409
27	test.donor.1788743562@example.com	TEST_DATA_NO_REAL_LOGIN	DONOR	t	t	2026-09-07 07:12:42.345216
28	test.donor.1788743570@example.com	TEST_DATA_NO_REAL_LOGIN	DONOR	t	t	2026-09-07 07:12:49.62452
29	frezwoan+task2@gmail.com	$2b$10$HWdoyrsu/4Iw6C4If2xko.cDn90Ntvqo5wmP0PLEbHI7sJkxjQC5O	NGO	t	t	2026-09-08 01:15:46.828641
30	demo.ngo.sirdemo@example.com	$2b$10$YCoSrc9U7lOAE9U0nSHLxOtSOdzYxTxTm496klrDJr7ekhiaZ4SMC	NGO	t	t	2026-09-12 11:22:21.243557
31	demo.volunteer.1789190757@example.com	TEST_DATA_NO_REAL_LOGIN	VOLUNTEER	t	t	2026-09-12 11:25:57.323414
32	demo.donor.1789190757@example.com	TEST_DATA_NO_REAL_LOGIN	DONOR	t	t	2026-09-12 11:25:57.342807
\.


--
-- Data for Name: volunteer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.volunteer (id, username, "fullName", phone, city, "isAvailable", "totalHours", "userId", "profileImage", email, password) FROM stdin;
1	ayesha_r	Ayesha Rahman	1712000001	Dhaka	t	0	6	\N	\N	\N
2	test_vol_1	Test Volunteer	1712345699	Sylhet	t	0	10	\N	\N	\N
3	test_vol_2	Test Volunteer Two	1712345688	Sylhet	t	4	11	\N	\N	\N
4	voltest1788541706	Vol Test	1712345678	Dhaka	t	0	18	\N	voltest1788541706@gmail.com	$2b$10$ok4sF7m01TNGu.jJ76hON.14DEUTez5OTrFPNv.hMwTIppVcrBhKm
5	demo_volunteer_1789190757	ABC Volunteer	1700000000	Dhaka	t	0	31	\N	demo.volunteer.1789190757@example.com	TEST_DATA_NO_REAL_LOGIN
\.


--
-- Data for Name: volunteer_call; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.volunteer_call (id, title, description, slots, status, city, "createdAt", "ngoId", "crisisId") FROM stdin;
1	Flood relief volunteers (updated)	Now also medical aid	30	CLOSED	Dhaka	2026-08-01 00:43:34.373243	5	1
5	Flood Relief Volunteers Needed	Need volunteers to distribute food and water	5	OPEN	Sylhet	2026-08-30 21:08:51.099829	7	4
6	test	Test	3	OPEN	Dhaka	2026-09-07 05:06:18.673159	12	1
7	Flood Relief Volunteers Needed	Help distribute relief supplies to flood-affected families in Dhaka.	20	OPEN	Dhaka	2026-09-12 11:24:21.011526	23	1
\.


--
-- Data for Name: volunteer_skill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.volunteer_skill ("volunteerId", "skillId") FROM stdin;
1	1
1	2
\.


--
-- Data for Name: work_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.work_log (id, hours, note, "loggedAt", "assignmentId") FROM stdin;
1	4	Distributed food packages	2026-08-30 21:14:20.192664	2
\.


--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_id_seq', 1, true);


--
-- Name: announcement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.announcement_id_seq', 1, false);


--
-- Name: application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.application_id_seq', 6, true);


--
-- Name: assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.assignment_id_seq', 3, true);


--
-- Name: crisis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crisis_id_seq', 4, true);


--
-- Name: donation_call_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.donation_call_id_seq', 5, true);


--
-- Name: donation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.donation_id_seq', 2, true);


--
-- Name: donor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.donor_id_seq', 3, true);


--
-- Name: ngo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ngo_id_seq', 23, true);


--
-- Name: otp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.otp_id_seq', 37, true);


--
-- Name: payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_id_seq', 1, false);


--
-- Name: receipt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receipt_id_seq', 1, false);


--
-- Name: skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skill_id_seq', 2, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 32, true);


--
-- Name: volunteer_call_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.volunteer_call_id_seq', 7, true);


--
-- Name: volunteer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.volunteer_id_seq', 5, true);


--
-- Name: work_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_log_id_seq', 1, true);


--
-- Name: crisis_follow PK_22b38c11fd7f9441bdbb32d6f5f; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crisis_follow
    ADD CONSTRAINT "PK_22b38c11fd7f9441bdbb32d6f5f" PRIMARY KEY ("donorId", "crisisId");


--
-- Name: donation PK_25fb5a541964bc5cfc18fb13a82; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation
    ADD CONSTRAINT "PK_25fb5a541964bc5cfc18fb13a82" PRIMARY KEY (id);


--
-- Name: otp PK_32556d9d7b22031d7d0e1fd6723; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp
    ADD CONSTRAINT "PK_32556d9d7b22031d7d0e1fd6723" PRIMARY KEY (id);


--
-- Name: crisis PK_41ae40298d25cee7111828d06f9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crisis
    ADD CONSTRAINT "PK_41ae40298d25cee7111828d06f9" PRIMARY KEY (id);


--
-- Name: assignment PK_43c2f5a3859f54cedafb270f37e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment
    ADD CONSTRAINT "PK_43c2f5a3859f54cedafb270f37e" PRIMARY KEY (id);


--
-- Name: donation_call PK_49b8a5a8594518ba80ef57d6e8b; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation_call
    ADD CONSTRAINT "PK_49b8a5a8594518ba80ef57d6e8b" PRIMARY KEY (id);


--
-- Name: donor PK_51f7b00d1120f7130b69f8a3a46; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donor
    ADD CONSTRAINT "PK_51f7b00d1120f7130b69f8a3a46" PRIMARY KEY (id);


--
-- Name: application PK_569e0c3e863ebdf5f2408ee1670; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT "PK_569e0c3e863ebdf5f2408ee1670" PRIMARY KEY (id);


--
-- Name: work_log PK_65e2816b0d0876024e3754656b9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_log
    ADD CONSTRAINT "PK_65e2816b0d0876024e3754656b9" PRIMARY KEY (id);


--
-- Name: volunteer PK_76924da1998b3e07025e04c4d3c; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer
    ADD CONSTRAINT "PK_76924da1998b3e07025e04c4d3c" PRIMARY KEY (id);


--
-- Name: crisis_participation PK_7b4cc9b24623d0ce627cccb01ee; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crisis_participation
    ADD CONSTRAINT "PK_7b4cc9b24623d0ce627cccb01ee" PRIMARY KEY ("ngoId", "crisisId");


--
-- Name: skill PK_a0d33334424e64fb78dc3ce7196; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skill
    ADD CONSTRAINT "PK_a0d33334424e64fb78dc3ce7196" PRIMARY KEY (id);


--
-- Name: receipt PK_b4b9ec7d164235fbba023da9832; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt
    ADD CONSTRAINT "PK_b4b9ec7d164235fbba023da9832" PRIMARY KEY (id);


--
-- Name: user PK_cace4a159ff9f2512dd42373760; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY (id);


--
-- Name: announcement_recipient PK_cfead0baad3e161cf91439a1a62; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcement_recipient
    ADD CONSTRAINT "PK_cfead0baad3e161cf91439a1a62" PRIMARY KEY ("announcementId", "userId");


--
-- Name: ngo PK_da3e13acb48ce5a2e7146f71a25; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ngo
    ADD CONSTRAINT "PK_da3e13acb48ce5a2e7146f71a25" PRIMARY KEY (id);


--
-- Name: admin PK_e032310bcef831fb83101899b10; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT "PK_e032310bcef831fb83101899b10" PRIMARY KEY (id);


--
-- Name: announcement PK_e0ef0550174fd1099a308fd18a0; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcement
    ADD CONSTRAINT "PK_e0ef0550174fd1099a308fd18a0" PRIMARY KEY (id);


--
-- Name: volunteer_skill PK_f12182db994e600190d6b48b8bc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_skill
    ADD CONSTRAINT "PK_f12182db994e600190d6b48b8bc" PRIMARY KEY ("volunteerId", "skillId");


--
-- Name: volunteer_call PK_f344c2c1e3f75264f3dabb43ad1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_call
    ADD CONSTRAINT "PK_f344c2c1e3f75264f3dabb43ad1" PRIMARY KEY (id);


--
-- Name: payment PK_fcaec7df5adf9cac408c686b2ab; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT "PK_fcaec7df5adf9cac408c686b2ab" PRIMARY KEY (id);


--
-- Name: donor REL_1066cb3fd61d250765bba26acc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donor
    ADD CONSTRAINT "REL_1066cb3fd61d250765bba26acc" UNIQUE ("userId");


--
-- Name: receipt REL_3d1ed14396424884ea1f7c3ee9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt
    ADD CONSTRAINT "REL_3d1ed14396424884ea1f7c3ee9" UNIQUE ("paymentId");


--
-- Name: ngo REL_3f595bb12db865d7e37fbf8aec; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ngo
    ADD CONSTRAINT "REL_3f595bb12db865d7e37fbf8aec" UNIQUE ("userId");


--
-- Name: volunteer REL_b448933d82c256ea1addbca731; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer
    ADD CONSTRAINT "REL_b448933d82c256ea1addbca731" UNIQUE ("userId");


--
-- Name: payment REL_bc16d7c930014d8e3694fb1a20; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT "REL_bc16d7c930014d8e3694fb1a20" UNIQUE ("donationId");


--
-- Name: assignment REL_f272559e93859f6f8761285bbf; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment
    ADD CONSTRAINT "REL_f272559e93859f6f8761285bbf" UNIQUE ("applicationId");


--
-- Name: admin REL_f8a889c4362d78f056960ca6da; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT "REL_f8a889c4362d78f056960ca6da" UNIQUE ("userId");


--
-- Name: skill UQ_0f49a593960360f6f85b692aca8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skill
    ADD CONSTRAINT "UQ_0f49a593960360f6f85b692aca8" UNIQUE (name);


--
-- Name: volunteer UQ_842c8cfb6ffbaa7693e30724385; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer
    ADD CONSTRAINT "UQ_842c8cfb6ffbaa7693e30724385" UNIQUE (username);


--
-- Name: receipt UQ_9c1d2d394a589df29ea86a36edd; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt
    ADD CONSTRAINT "UQ_9c1d2d394a589df29ea86a36edd" UNIQUE ("receiptNo");


--
-- Name: volunteer UQ_d9fe0a3ae27744ad7521e1ba4a5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer
    ADD CONSTRAINT "UQ_d9fe0a3ae27744ad7521e1ba4a5" UNIQUE (email);


--
-- Name: user UQ_e12875dfb3b1d92d7d7c5377e22; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "UQ_e12875dfb3b1d92d7d7c5377e22" UNIQUE (email);


--
-- Name: IDX_0d9f44ec170042c77e2324aedb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_0d9f44ec170042c77e2324aedb" ON public.crisis_follow USING btree ("crisisId");


--
-- Name: IDX_39bdffff35e97de8dc0dc7096a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_39bdffff35e97de8dc0dc7096a" ON public.crisis_follow USING btree ("donorId");


--
-- Name: IDX_7380797ab7b580352a9527d929; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_7380797ab7b580352a9527d929" ON public.crisis_participation USING btree ("ngoId");


--
-- Name: IDX_7e0c54b9ff69a9c57d9707d558; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_7e0c54b9ff69a9c57d9707d558" ON public.volunteer_skill USING btree ("skillId");


--
-- Name: IDX_ae8d4a1fc6f028c31e5a094239; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_ae8d4a1fc6f028c31e5a094239" ON public.announcement_recipient USING btree ("userId");


--
-- Name: IDX_d08802c808c64c4e771bb35a7d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_d08802c808c64c4e771bb35a7d" ON public.announcement_recipient USING btree ("announcementId");


--
-- Name: IDX_f9dbeb6fc718b25fc7ca053ab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_f9dbeb6fc718b25fc7ca053ab0" ON public.crisis_participation USING btree ("crisisId");


--
-- Name: IDX_fe5cdba5cefc50c0ded2aa1dad; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fe5cdba5cefc50c0ded2aa1dad" ON public.volunteer_skill USING btree ("volunteerId");


--
-- Name: crisis_follow FK_0d9f44ec170042c77e2324aedb1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crisis_follow
    ADD CONSTRAINT "FK_0d9f44ec170042c77e2324aedb1" FOREIGN KEY ("crisisId") REFERENCES public.crisis(id);


--
-- Name: donor FK_1066cb3fd61d250765bba26accb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donor
    ADD CONSTRAINT "FK_1066cb3fd61d250765bba26accb" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: announcement FK_390a8dccfc6adcd5ad7391b81e4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcement
    ADD CONSTRAINT "FK_390a8dccfc6adcd5ad7391b81e4" FOREIGN KEY ("adminId") REFERENCES public.admin(id);


--
-- Name: crisis_follow FK_39bdffff35e97de8dc0dc7096a0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crisis_follow
    ADD CONSTRAINT "FK_39bdffff35e97de8dc0dc7096a0" FOREIGN KEY ("donorId") REFERENCES public.donor(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: receipt FK_3d1ed14396424884ea1f7c3ee91; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt
    ADD CONSTRAINT "FK_3d1ed14396424884ea1f7c3ee91" FOREIGN KEY ("paymentId") REFERENCES public.payment(id);


--
-- Name: ngo FK_3f595bb12db865d7e37fbf8aecb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ngo
    ADD CONSTRAINT "FK_3f595bb12db865d7e37fbf8aecb" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: donation FK_4270be6abda43b0f63bfb068d1a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation
    ADD CONSTRAINT "FK_4270be6abda43b0f63bfb068d1a" FOREIGN KEY ("donationCallId") REFERENCES public.donation_call(id);


--
-- Name: crisis FK_46cdc6033199fe21fbc9be37ee5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crisis
    ADD CONSTRAINT "FK_46cdc6033199fe21fbc9be37ee5" FOREIGN KEY ("declaredByAdminId") REFERENCES public.admin(id);


--
-- Name: donation FK_5f345add82fd6c572f306449cb7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation
    ADD CONSTRAINT "FK_5f345add82fd6c572f306449cb7" FOREIGN KEY ("donorId") REFERENCES public.donor(id);


--
-- Name: crisis_participation FK_7380797ab7b580352a9527d9293; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crisis_participation
    ADD CONSTRAINT "FK_7380797ab7b580352a9527d9293" FOREIGN KEY ("ngoId") REFERENCES public.ngo(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: volunteer_call FK_742e3e2ff29348d027121b6cb34; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_call
    ADD CONSTRAINT "FK_742e3e2ff29348d027121b6cb34" FOREIGN KEY ("crisisId") REFERENCES public.crisis(id);


--
-- Name: volunteer_skill FK_7e0c54b9ff69a9c57d9707d5582; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_skill
    ADD CONSTRAINT "FK_7e0c54b9ff69a9c57d9707d5582" FOREIGN KEY ("skillId") REFERENCES public.skill(id);


--
-- Name: assignment FK_90a1ad93f4dcd7fb5a9393b67b2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment
    ADD CONSTRAINT "FK_90a1ad93f4dcd7fb5a9393b67b2" FOREIGN KEY ("ngoId") REFERENCES public.ngo(id);


--
-- Name: announcement_recipient FK_ae8d4a1fc6f028c31e5a094239c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcement_recipient
    ADD CONSTRAINT "FK_ae8d4a1fc6f028c31e5a094239c" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: volunteer FK_b448933d82c256ea1addbca731f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer
    ADD CONSTRAINT "FK_b448933d82c256ea1addbca731f" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: payment FK_bc16d7c930014d8e3694fb1a20f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT "FK_bc16d7c930014d8e3694fb1a20f" FOREIGN KEY ("donationId") REFERENCES public.donation(id);


--
-- Name: donation_call FK_be063798d540e5bf9a0cd2f49b2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation_call
    ADD CONSTRAINT "FK_be063798d540e5bf9a0cd2f49b2" FOREIGN KEY ("ngoId") REFERENCES public.ngo(id);


--
-- Name: work_log FK_be1acab27b0d762daafd0711313; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_log
    ADD CONSTRAINT "FK_be1acab27b0d762daafd0711313" FOREIGN KEY ("assignmentId") REFERENCES public.assignment(id);


--
-- Name: donation_call FK_c96cec31e5797433ff4dc229350; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donation_call
    ADD CONSTRAINT "FK_c96cec31e5797433ff4dc229350" FOREIGN KEY ("crisisId") REFERENCES public.crisis(id);


--
-- Name: volunteer_call FK_cb7476bd429342ff21ae7cbb5ed; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_call
    ADD CONSTRAINT "FK_cb7476bd429342ff21ae7cbb5ed" FOREIGN KEY ("ngoId") REFERENCES public.ngo(id);


--
-- Name: application FK_cc59f90459d858a6d203eef6ae7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT "FK_cc59f90459d858a6d203eef6ae7" FOREIGN KEY ("volunteerId") REFERENCES public.volunteer(id);


--
-- Name: announcement_recipient FK_d08802c808c64c4e771bb35a7d7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcement_recipient
    ADD CONSTRAINT "FK_d08802c808c64c4e771bb35a7d7" FOREIGN KEY ("announcementId") REFERENCES public.announcement(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application FK_da7db8aa99e4bd7720e3e00d75b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT "FK_da7db8aa99e4bd7720e3e00d75b" FOREIGN KEY ("volunteerCallId") REFERENCES public.volunteer_call(id);


--
-- Name: otp FK_db724db1bc3d94ad5ba38518433; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp
    ADD CONSTRAINT "FK_db724db1bc3d94ad5ba38518433" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: assignment FK_f272559e93859f6f8761285bbf0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment
    ADD CONSTRAINT "FK_f272559e93859f6f8761285bbf0" FOREIGN KEY ("applicationId") REFERENCES public.application(id);


--
-- Name: admin FK_f8a889c4362d78f056960ca6dad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT "FK_f8a889c4362d78f056960ca6dad" FOREIGN KEY ("userId") REFERENCES public."user"(id);


--
-- Name: crisis_participation FK_f9dbeb6fc718b25fc7ca053ab01; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crisis_participation
    ADD CONSTRAINT "FK_f9dbeb6fc718b25fc7ca053ab01" FOREIGN KEY ("crisisId") REFERENCES public.crisis(id);


--
-- Name: volunteer_skill FK_fe5cdba5cefc50c0ded2aa1dad3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_skill
    ADD CONSTRAINT "FK_fe5cdba5cefc50c0ded2aa1dad3" FOREIGN KEY ("volunteerId") REFERENCES public.volunteer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 9Jt55Q602vjH679ndyCkuMX6ytHinIsVwYTsOtkuJXCfdlq1NOs4psOkKDmL7uv

