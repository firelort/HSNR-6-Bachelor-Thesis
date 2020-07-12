-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.2
-- PostgreSQL version: 12.0
-- Project Site: pgmodeler.io
-- Model Author: ---


-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: postgres | type: DATABASE --
-- -- DROP DATABASE IF EXISTS postgres;
-- CREATE DATABASE postgres
-- 	ENCODING = 'UTF8'
-- 	LC_COLLATE = 'en_US.utf8'
-- 	LC_CTYPE = 'en_US.utf8'
-- 	TABLESPACE = pg_default
-- 	OWNER = postgres;
-- -- ddl-end --
-- COMMENT ON DATABASE postgres IS E'default administrative connection database';
-- -- ddl-end --
-- 

-- object: public.alembic_version | type: TABLE --
-- DROP TABLE IF EXISTS public.alembic_version CASCADE;
CREATE TABLE public.alembic_version (
	version_num character varying(32) NOT NULL,
	CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)

);
-- ddl-end --
-- ALTER TABLE public.alembic_version OWNER TO postgres;
-- ddl-end --

-- object: public.backups_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.backups_id_seq CASCADE;
CREATE SEQUENCE public.backups_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
-- ALTER SEQUENCE public.backups_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.backups | type: TABLE --
-- DROP TABLE IF EXISTS public.backups CASCADE;
CREATE TABLE public.backups (
	id integer NOT NULL DEFAULT nextval('public.backups_id_seq'::regclass),
	created_at timestamp with time zone NOT NULL DEFAULT now(),
	data json NOT NULL,
	CONSTRAINT pk_backups PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.backups OWNER TO postgres;
-- ddl-end --

-- object: public.flagshop_packages_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.flagshop_packages_id_seq CASCADE;
CREATE SEQUENCE public.flagshop_packages_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
-- ALTER SEQUENCE public.flagshop_packages_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.flagshop_packages | type: TABLE --
-- DROP TABLE IF EXISTS public.flagshop_packages CASCADE;
CREATE TABLE public.flagshop_packages (
	id integer NOT NULL DEFAULT nextval('public.flagshop_packages_id_seq'::regclass),
	name character varying NOT NULL,
	price integer NOT NULL,
	flag_count integer NOT NULL,
	CONSTRAINT pk_flagshop_packages PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.flagshop_packages OWNER TO postgres;
-- ddl-end --

-- object: public.groups_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.groups_id_seq CASCADE;
CREATE SEQUENCE public.groups_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
-- ALTER SEQUENCE public.groups_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.groups | type: TABLE --
-- DROP TABLE IF EXISTS public.groups CASCADE;
CREATE TABLE public.groups (
	id integer NOT NULL DEFAULT nextval('public.groups_id_seq'::regclass),
	name cidr NOT NULL,
	token character varying NOT NULL,
	CONSTRAINT pk_groups PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.groups OWNER TO postgres;
-- ddl-end --

-- object: ix_groups_name | type: INDEX --
-- DROP INDEX IF EXISTS public.ix_groups_name CASCADE;
CREATE UNIQUE INDEX ix_groups_name ON public.groups
	USING btree
	(
	  name
	)
	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: public.services_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.services_id_seq CASCADE;
CREATE SEQUENCE public.services_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
-- ALTER SEQUENCE public.services_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.services | type: TABLE --
-- DROP TABLE IF EXISTS public.services CASCADE;
CREATE TABLE public.services (
	id integer NOT NULL DEFAULT nextval('public.services_id_seq'::regclass),
	name character varying NOT NULL,
	public_name character varying NOT NULL,
	weight smallint NOT NULL,
	active boolean NOT NULL,
	CONSTRAINT pk_services PRIMARY KEY (id),
	CONSTRAINT uq_services_public_name UNIQUE (public_name)

);
-- ddl-end --
-- ALTER TABLE public.services OWNER TO postgres;
-- ddl-end --

-- object: ix_services_name | type: INDEX --
-- DROP INDEX IF EXISTS public.ix_services_name CASCADE;
CREATE UNIQUE INDEX ix_services_name ON public.services
	USING btree
	(
	  name
	)
	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: public.userrole | type: TYPE --
-- DROP TYPE IF EXISTS public.userrole CASCADE;
CREATE TYPE public.userrole AS
 ENUM ('admin','supervisor','player');
-- ddl-end --
-- ALTER TYPE public.userrole OWNER TO postgres;
-- ddl-end --

-- object: public.users_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.users_id_seq CASCADE;
CREATE SEQUENCE public.users_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
-- ALTER SEQUENCE public.users_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.users | type: TABLE --
-- DROP TABLE IF EXISTS public.users CASCADE;
CREATE TABLE public.users (
	id integer NOT NULL DEFAULT nextval('public.users_id_seq'::regclass),
	name character varying NOT NULL,
	password character varying NOT NULL,
	role public.userrole NOT NULL,
	CONSTRAINT pk_users PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.users OWNER TO postgres;
-- ddl-end --

-- object: ix_users_name | type: INDEX --
-- DROP INDEX IF EXISTS public.ix_users_name CASCADE;
CREATE UNIQUE INDEX ix_users_name ON public.users
	USING btree
	(
	  name
	)
	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: public.flagusage | type: TYPE --
-- DROP TYPE IF EXISTS public.flagusage CASCADE;
CREATE TYPE public.flagusage AS
 ENUM ('on_client','flagshop_registration','flagshop_buy');
-- ddl-end --
-- ALTER TYPE public.flagusage OWNER TO postgres;
-- ddl-end --

-- object: public.flags | type: TABLE --
-- DROP TABLE IF EXISTS public.flags CASCADE;
CREATE TABLE public.flags (
	flag_value character varying NOT NULL,
	usage public.flagusage NOT NULL,
	group_id integer NOT NULL,
	already_bought boolean NOT NULL DEFAULT false,
	CONSTRAINT pk_flags PRIMARY KEY (flag_value)

);
-- ddl-end --
-- ALTER TABLE public.flags OWNER TO postgres;
-- ddl-end --

-- object: public.flagshop_user | type: TABLE --
-- DROP TABLE IF EXISTS public.flagshop_user CASCADE;
CREATE TABLE public.flagshop_user (
	name character varying NOT NULL,
	password character varying NOT NULL,
	group_id integer NOT NULL,
	CONSTRAINT pk_flagshop_user PRIMARY KEY (name,group_id)

);
-- ddl-end --
-- ALTER TABLE public.flagshop_user OWNER TO postgres;
-- ddl-end --

-- object: public.group_members | type: TABLE --
-- DROP TABLE IF EXISTS public.group_members CASCADE;
CREATE TABLE public.group_members (
	alias_ip cidr NOT NULL,
	group_id integer NOT NULL,
	CONSTRAINT pk_group_members PRIMARY KEY (alias_ip)

);
-- ddl-end --
-- ALTER TABLE public.group_members OWNER TO postgres;
-- ddl-end --

-- object: public.flags_submitted | type: TABLE --
-- DROP TABLE IF EXISTS public.flags_submitted CASCADE;
CREATE TABLE public.flags_submitted (
	group_id integer NOT NULL,
	flag_value character varying NOT NULL,
	"timestamp" timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT pk_flags_submitted PRIMARY KEY (group_id,flag_value)

);
-- ddl-end --
-- ALTER TABLE public.flags_submitted OWNER TO postgres;
-- ddl-end --

-- object: public.discover_points | type: VIEW --
-- DROP VIEW IF EXISTS public.discover_points CASCADE;
CREATE VIEW public.discover_points
AS 

SELECT flags_submitted.group_id,
    count(flags_submitted.flag_value) AS points
   FROM (flags_submitted
     JOIN flags ON (((flags_submitted.flag_value)::text = (flags.flag_value)::text)))
  WHERE (flags_submitted.group_id = flags.group_id)
  GROUP BY flags_submitted.group_id;
-- ddl-end --
-- ALTER VIEW public.discover_points OWNER TO postgres;
-- ddl-end --

-- object: public.offence_points | type: VIEW --
-- DROP VIEW IF EXISTS public.offence_points CASCADE;
CREATE VIEW public.offence_points
AS 

SELECT flags_submitted.group_id,
    count(flags_submitted.flag_value) AS points
   FROM (flags_submitted
     JOIN flags ON (((flags_submitted.flag_value)::text = (flags.flag_value)::text)))
  WHERE (flags_submitted.group_id <> flags.group_id)
  GROUP BY flags_submitted.group_id;
-- ddl-end --
-- ALTER VIEW public.offence_points OWNER TO postgres;
-- ddl-end --

-- object: public.defence_points | type: VIEW --
-- DROP VIEW IF EXISTS public.defence_points CASCADE;
CREATE VIEW public.defence_points
AS 

SELECT flags.group_id,
    count(DISTINCT flags.flag_value) AS points
   FROM (flags
     JOIN flags_submitted ON (((flags.flag_value)::text = (flags_submitted.flag_value)::text)))
  WHERE (flags.group_id <> flags_submitted.group_id)
  GROUP BY flags.group_id;
-- ddl-end --
-- ALTER VIEW public.defence_points OWNER TO postgres;
-- ddl-end --

-- object: public.penalties_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.penalties_id_seq CASCADE;
CREATE SEQUENCE public.penalties_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
-- ALTER SEQUENCE public.penalties_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.penalties | type: TABLE --
-- DROP TABLE IF EXISTS public.penalties CASCADE;
CREATE TABLE public.penalties (
	id integer NOT NULL DEFAULT nextval('public.penalties_id_seq'::regclass),
	reason character varying NOT NULL,
	points integer NOT NULL,
	group_id integer NOT NULL,
	user_id integer,
	"timestamp" timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT pk_penalties PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.penalties OWNER TO postgres;
-- ddl-end --

-- object: public.groups_bought_flagshop_packages | type: TABLE --
-- DROP TABLE IF EXISTS public.groups_bought_flagshop_packages CASCADE;
CREATE TABLE public.groups_bought_flagshop_packages (
	price_paid integer NOT NULL,
	group_id integer NOT NULL,
	flagshop_packages_id integer NOT NULL,
	CONSTRAINT pk_groups_bought_flagshop_packages PRIMARY KEY (group_id,flagshop_packages_id)

);
-- ddl-end --
-- ALTER TABLE public.groups_bought_flagshop_packages OWNER TO postgres;
-- ddl-end --

-- object: public.group_service_status | type: TABLE --
-- DROP TABLE IF EXISTS public.group_service_status CASCADE;
CREATE TABLE public.group_service_status (
	scan_count integer NOT NULL,
	online_count integer NOT NULL,
	was_online boolean NOT NULL,
	last_scan timestamp with time zone NOT NULL DEFAULT now(),
	group_id integer NOT NULL,
	service_id integer NOT NULL,
	CONSTRAINT pk_group_service_status PRIMARY KEY (group_id,service_id)

);
-- ddl-end --
-- ALTER TABLE public.group_service_status OWNER TO postgres;
-- ddl-end --

-- object: public.challenges_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.challenges_id_seq CASCADE;
CREATE SEQUENCE public.challenges_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
-- ALTER SEQUENCE public.challenges_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.challenges | type: TABLE --
-- DROP TABLE IF EXISTS public.challenges CASCADE;
CREATE TABLE public.challenges (
	id integer NOT NULL DEFAULT nextval('public.challenges_id_seq'::regclass),
	name character varying NOT NULL,
	hint character varying NOT NULL,
	password character varying NOT NULL,
	points integer NOT NULL,
	path character varying NOT NULL,
	CONSTRAINT pk_challenges PRIMARY KEY (id),
	CONSTRAINT uq_challenges_name UNIQUE (name),
	CONSTRAINT uq_challenges_path UNIQUE (path)

);
-- ddl-end --
-- ALTER TABLE public.challenges OWNER TO postgres;
-- ddl-end --

-- object: public.group_has_challenges | type: TABLE --
-- DROP TABLE IF EXISTS public.group_has_challenges CASCADE;
CREATE TABLE public.group_has_challenges (
	solved boolean NOT NULL DEFAULT false,
	started_at timestamp with time zone NOT NULL DEFAULT now(),
	solved_at timestamp with time zone,
	group_id integer NOT NULL,
	challenges_id integer NOT NULL,
	CONSTRAINT pk_group_has_challenges PRIMARY KEY (group_id,challenges_id)

);
-- ddl-end --
-- ALTER TABLE public.group_has_challenges OWNER TO postgres;
-- ddl-end --

-- object: public.logaction | type: TYPE --
-- DROP TYPE IF EXISTS public.logaction CASCADE;
CREATE TYPE public.logaction AS
 ENUM ('game_created','game_started','game_paused','game_resumed','gametime_changed','game_ended','scanner_started','scanner_stopped','scanner_report','gameclient_registered','gameclient_deleted','associate_registered','associate_deleted','flags_generated','flag_submitted','penalty_issued','flagshop_user_registered','flagshop_purchase','challenge_started','challenge_finished','admin_info');
-- ddl-end --
-- ALTER TYPE public.logaction OWNER TO postgres;
-- ddl-end --

-- object: public.logs_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.logs_id_seq CASCADE;
CREATE SEQUENCE public.logs_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
-- ALTER SEQUENCE public.logs_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.logs | type: TABLE --
-- DROP TABLE IF EXISTS public.logs CASCADE;
CREATE TABLE public.logs (
	id integer NOT NULL DEFAULT nextval('public.logs_id_seq'::regclass),
	action public.logaction NOT NULL,
	data json NOT NULL,
	created_at timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT pk_logs PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.logs OWNER TO postgres;
-- ddl-end --

-- object: public.logs_old_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.logs_old_id_seq CASCADE;
CREATE SEQUENCE public.logs_old_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
-- ALTER SEQUENCE public.logs_old_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.logs_old | type: TABLE --
-- DROP TABLE IF EXISTS public.logs_old CASCADE;
CREATE TABLE public.logs_old (
	id integer NOT NULL DEFAULT nextval('public.logs_old_id_seq'::regclass),
	action public.logaction NOT NULL,
	data json NOT NULL,
	created_at timestamp with time zone NOT NULL DEFAULT now(),
	CONSTRAINT pk_logs_old PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.logs_old OWNER TO postgres;
-- ddl-end --

-- object: public.notes_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.notes_id_seq CASCADE;
CREATE SEQUENCE public.notes_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
-- ALTER SEQUENCE public.notes_id_seq OWNER TO postgres;
-- ddl-end --

-- object: public.notes | type: TABLE --
-- DROP TABLE IF EXISTS public.notes CASCADE;
CREATE TABLE public.notes (
	id integer NOT NULL DEFAULT nextval('public.notes_id_seq'::regclass),
	title character varying NOT NULL,
	text character varying NOT NULL,
	CONSTRAINT pk_notes PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.notes OWNER TO postgres;
-- ddl-end --

-- object: public.settings | type: TABLE --
-- DROP TABLE IF EXISTS public.settings CASCADE;
CREATE TABLE public.settings (
	key character varying NOT NULL,
	value character varying NOT NULL,
	CONSTRAINT pk_settings PRIMARY KEY (key)

);
-- ddl-end --
-- ALTER TABLE public.settings OWNER TO postgres;
-- ddl-end --

-- object: public.challenge_points | type: VIEW --
-- DROP VIEW IF EXISTS public.challenge_points CASCADE;
CREATE VIEW public.challenge_points
AS 

SELECT group_has_challenges.group_id,
    sum(challenges.points) AS total_points
   FROM (group_has_challenges
     JOIN challenges ON ((group_has_challenges.challenges_id = challenges.id)))
  WHERE (group_has_challenges.solved = true)
  GROUP BY group_has_challenges.group_id;
-- ddl-end --
-- ALTER VIEW public.challenge_points OWNER TO postgres;
-- ddl-end --

-- object: public.flagshop_points | type: VIEW --
-- DROP VIEW IF EXISTS public.flagshop_points CASCADE;
CREATE VIEW public.flagshop_points
AS 

SELECT groups_bought_flagshop_packages.group_id,
    sum(groups_bought_flagshop_packages.price_paid) AS points_spend
   FROM groups_bought_flagshop_packages
  GROUP BY groups_bought_flagshop_packages.group_id;
-- ddl-end --
-- ALTER VIEW public.flagshop_points OWNER TO postgres;
-- ddl-end --

-- object: public.penalty_points | type: VIEW --
-- DROP VIEW IF EXISTS public.penalty_points CASCADE;
CREATE VIEW public.penalty_points
AS 

SELECT penalties.group_id,
    sum(penalties.points) AS total_penalty
   FROM penalties
  GROUP BY penalties.group_id;
-- ddl-end --
-- ALTER VIEW public.penalty_points OWNER TO postgres;
-- ddl-end --

-- object: public.group_service_points | type: VIEW --
-- DROP VIEW IF EXISTS public.group_service_points CASCADE;
CREATE VIEW public.group_service_points
AS 

SELECT group_service_status.group_id,
    group_service_status.service_id,
    (abs(round((((group_service_status.online_count - group_service_status.scan_count) / COALESCE((services.weight)::integer, 1)))::double precision)))::smallint AS service_points,
    (round((COALESCE(((100 / group_service_status.scan_count) * group_service_status.online_count), 0))::double precision))::smallint AS service_percentage
   FROM (group_service_status
     JOIN services ON ((group_service_status.service_id = services.id)));
-- ddl-end --
-- ALTER VIEW public.group_service_points OWNER TO postgres;
-- ddl-end --

-- object: public.group_service_online_status | type: VIEW --
-- DROP VIEW IF EXISTS public.group_service_online_status CASCADE;
CREATE VIEW public.group_service_online_status
AS 

SELECT group_service_status.group_id,
    group_service_status.service_id,
    group_service_status.was_online
   FROM group_service_status;
-- ddl-end --
-- ALTER VIEW public.group_service_online_status OWNER TO postgres;
-- ddl-end --

-- object: public.total_points | type: VIEW --
-- DROP VIEW IF EXISTS public.total_points CASCADE;
CREATE VIEW public.total_points
AS 

SELECT grp.id,
    grp.name,
    (COALESCE(cha.total_points, ((0)::smallint)::bigint))::smallint AS challenge_points,
    (COALESCE(dis.points, ((0)::smallint)::bigint))::smallint AS discover_points,
    (COALESCE(ofe.points, ((0)::smallint)::bigint))::smallint AS offence_points,
    (COALESCE(def.points, ((0)::smallint)::bigint))::smallint AS defence_points,
    (COALESCE(tmp.service_points, ((0)::smallint)::bigint))::smallint AS service_points,
    (COALESCE(fla.points_spend, ((0)::smallint)::bigint))::smallint AS flagsshop_points,
    (COALESCE(pen.total_penalty, ((0)::smallint)::bigint))::smallint AS penalty_points,
    (((((((COALESCE(cha.total_points, ((0)::smallint)::bigint))::smallint + (COALESCE(dis.points, ((0)::smallint)::bigint))::smallint) + (COALESCE(ofe.points, ((0)::smallint)::bigint))::smallint) - (COALESCE(def.points, ((0)::smallint)::bigint))::smallint) - (COALESCE(tmp.service_points, ((0)::smallint)::bigint))::smallint) - (COALESCE(fla.points_spend, ((0)::smallint)::bigint))::smallint) - (COALESCE(pen.total_penalty, ((0)::smallint)::bigint))::smallint) AS total_points
   FROM (((((((groups grp
     LEFT JOIN challenge_points cha ON ((grp.id = cha.group_id)))
     LEFT JOIN discover_points dis ON ((grp.id = dis.group_id)))
     LEFT JOIN offence_points ofe ON ((grp.id = ofe.group_id)))
     LEFT JOIN defence_points def ON ((grp.id = def.group_id)))
     LEFT JOIN flagshop_points fla ON ((grp.id = fla.group_id)))
     LEFT JOIN penalty_points pen ON ((grp.id = pen.group_id)))
     JOIN ( SELECT grp_1.id,
            sum(gsp.service_points) AS service_points
           FROM (groups grp_1
             LEFT JOIN group_service_points gsp ON ((grp_1.id = gsp.group_id)))
          GROUP BY grp_1.id) tmp ON ((grp.id = tmp.id)));
-- ddl-end --
-- ALTER VIEW public.total_points OWNER TO postgres;
-- ddl-end --

-- object: fk_flags_group_id_groups | type: CONSTRAINT --
-- ALTER TABLE public.flags DROP CONSTRAINT IF EXISTS fk_flags_group_id_groups CASCADE;
ALTER TABLE public.flags ADD CONSTRAINT fk_flags_group_id_groups FOREIGN KEY (group_id)
REFERENCES public.groups (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_flagshop_user_group_id_groups | type: CONSTRAINT --
-- ALTER TABLE public.flagshop_user DROP CONSTRAINT IF EXISTS fk_flagshop_user_group_id_groups CASCADE;
ALTER TABLE public.flagshop_user ADD CONSTRAINT fk_flagshop_user_group_id_groups FOREIGN KEY (group_id)
REFERENCES public.groups (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_group_members_group_id_groups | type: CONSTRAINT --
-- ALTER TABLE public.group_members DROP CONSTRAINT IF EXISTS fk_group_members_group_id_groups CASCADE;
ALTER TABLE public.group_members ADD CONSTRAINT fk_group_members_group_id_groups FOREIGN KEY (group_id)
REFERENCES public.groups (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_flags_submitted_flag_value_flags | type: CONSTRAINT --
-- ALTER TABLE public.flags_submitted DROP CONSTRAINT IF EXISTS fk_flags_submitted_flag_value_flags CASCADE;
ALTER TABLE public.flags_submitted ADD CONSTRAINT fk_flags_submitted_flag_value_flags FOREIGN KEY (flag_value)
REFERENCES public.flags (flag_value) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_flags_submitted_group_id_groups | type: CONSTRAINT --
-- ALTER TABLE public.flags_submitted DROP CONSTRAINT IF EXISTS fk_flags_submitted_group_id_groups CASCADE;
ALTER TABLE public.flags_submitted ADD CONSTRAINT fk_flags_submitted_group_id_groups FOREIGN KEY (group_id)
REFERENCES public.groups (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_penalties_group_id_groups | type: CONSTRAINT --
-- ALTER TABLE public.penalties DROP CONSTRAINT IF EXISTS fk_penalties_group_id_groups CASCADE;
ALTER TABLE public.penalties ADD CONSTRAINT fk_penalties_group_id_groups FOREIGN KEY (group_id)
REFERENCES public.groups (id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_penalties_user_id_users | type: CONSTRAINT --
-- ALTER TABLE public.penalties DROP CONSTRAINT IF EXISTS fk_penalties_user_id_users CASCADE;
ALTER TABLE public.penalties ADD CONSTRAINT fk_penalties_user_id_users FOREIGN KEY (user_id)
REFERENCES public.users (id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_groups_bought_flagshop_packages_flagshop_packages_id_7b97 | type: CONSTRAINT --
-- ALTER TABLE public.groups_bought_flagshop_packages DROP CONSTRAINT IF EXISTS fk_groups_bought_flagshop_packages_flagshop_packages_id_7b97 CASCADE;
ALTER TABLE public.groups_bought_flagshop_packages ADD CONSTRAINT fk_groups_bought_flagshop_packages_flagshop_packages_id_7b97 FOREIGN KEY (flagshop_packages_id)
REFERENCES public.flagshop_packages (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_groups_bought_flagshop_packages_group_id_groups | type: CONSTRAINT --
-- ALTER TABLE public.groups_bought_flagshop_packages DROP CONSTRAINT IF EXISTS fk_groups_bought_flagshop_packages_group_id_groups CASCADE;
ALTER TABLE public.groups_bought_flagshop_packages ADD CONSTRAINT fk_groups_bought_flagshop_packages_group_id_groups FOREIGN KEY (group_id)
REFERENCES public.groups (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_group_service_status_group_id_groups | type: CONSTRAINT --
-- ALTER TABLE public.group_service_status DROP CONSTRAINT IF EXISTS fk_group_service_status_group_id_groups CASCADE;
ALTER TABLE public.group_service_status ADD CONSTRAINT fk_group_service_status_group_id_groups FOREIGN KEY (group_id)
REFERENCES public.groups (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_group_service_status_service_id_services | type: CONSTRAINT --
-- ALTER TABLE public.group_service_status DROP CONSTRAINT IF EXISTS fk_group_service_status_service_id_services CASCADE;
ALTER TABLE public.group_service_status ADD CONSTRAINT fk_group_service_status_service_id_services FOREIGN KEY (service_id)
REFERENCES public.services (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_group_has_challenges_challenges_id_challenges | type: CONSTRAINT --
-- ALTER TABLE public.group_has_challenges DROP CONSTRAINT IF EXISTS fk_group_has_challenges_challenges_id_challenges CASCADE;
ALTER TABLE public.group_has_challenges ADD CONSTRAINT fk_group_has_challenges_challenges_id_challenges FOREIGN KEY (challenges_id)
REFERENCES public.challenges (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fk_group_has_challenges_group_id_groups | type: CONSTRAINT --
-- ALTER TABLE public.group_has_challenges DROP CONSTRAINT IF EXISTS fk_group_has_challenges_group_id_groups CASCADE;
ALTER TABLE public.group_has_challenges ADD CONSTRAINT fk_group_has_challenges_group_id_groups FOREIGN KEY (group_id)
REFERENCES public.groups (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


