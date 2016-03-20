--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: issues; Type: TABLE; Schema: public; Owner: jack; Tablespace: 
--

CREATE TABLE issues (
    id integer NOT NULL,
    title character varying NOT NULL,
    image_url character varying,
    description character varying,
    release_date date,
    writers character varying,
    artist character varying,
    publisher character varying
);


ALTER TABLE issues OWNER TO jack;

--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: public; Owner: jack
--

CREATE SEQUENCE issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE issues_id_seq OWNER TO jack;

--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jack
--

ALTER SEQUENCE issues_id_seq OWNED BY issues.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: jack; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE schema_migrations OWNER TO jack;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: jack
--

ALTER TABLE ONLY issues ALTER COLUMN id SET DEFAULT nextval('issues_id_seq'::regclass);


--
-- Name: issues_pkey; Type: CONSTRAINT; Schema: public; Owner: jack; Tablespace: 
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: index_issues_on_title; Type: INDEX; Schema: public; Owner: jack; Tablespace: 
--

CREATE UNIQUE INDEX index_issues_on_title ON issues USING btree (title);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: jack; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

