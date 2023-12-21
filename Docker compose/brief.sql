--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 16.0

-- Started on 2023-12-20 15:29:07

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: thomas
--

CREATE ROLE "User" WITH LOGIN PASSWORD 'mdp';

ALTER SCHEMA public OWNER TO thomas;

--
-- TOC entry 3392 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: thomas
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 235 (class 1255 OID 32786)
-- Name: film_real(character varying); Type: FUNCTION; Schema: public; Owner: thomas
--

CREATE FUNCTION public.film_real(nom character varying) RETURNS TABLE(titre character varying)
    LANGUAGE sql
    AS $$
SELECT titre 
FROM public."Realise" r
INNER JOIN public."Realisateur" re
ON r.id_realisateur = re.id_realisateur
INNER JOIN public."Film" f
ON f.id_film = r.id_film
where nom_real = nom
$$;


ALTER FUNCTION public.film_real(nom character varying) OWNER TO thomas;

--
-- TOC entry 234 (class 1255 OID 24600)
-- Name: log_users(); Type: FUNCTION; Schema: public; Owner: thomas
--

CREATE FUNCTION public.log_users() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
old_last VARCHAR(255);
new_last VARCHAR(255);
old_first VARCHAR(255);
new_first VARCHAR(255);
old_email VARCHAR(255);
new_email VARCHAR(255);
old_password VARCHAR(255);
new_password VARCHAR(255);
old_role VARCHAR(255);
new_role VARCHAR(255);

BEGIN old_last := OLD.nom_utilisateur;
new_last := NEW.nom_utilisateur;
old_first := OLD.prenom_utilisateur;
new_first := NEW.prenom_utilisateur;
old_email := OLD.email;
new_email := NEW.email;
old_password := OLD.mdp;
new_password := NEW.mdp;
old_role := OLD.role_utilisateur;
new_role := NEW.role_utilisateur;

-- Insert into Log table if there is a change in the value
IF old_last IS DISTINCT
FROM
    new_last THEN
INSERT INTO
    Public."Log" (id_utilisateur, valeur_modifie, ancienne_valeur, nouvel_valeur)
VALUES
    (NEW.id_utilisateur, 'nom_utilisateur', old_last, new_last);
END IF;

IF old_first IS DISTINCT
FROM
    new_first THEN
INSERT INTO
    Public."Log" (id_utilisateur, valeur_modifie, ancienne_valeur, nouvel_valeur)
VALUES
    (NEW.id_utilisateur, 'prenom_utilisateur', old_first, new_first);
END IF;

IF old_email IS DISTINCT
FROM
    new_email THEN
INSERT INTO
    Public."Log" (id_utilisateur, valeur_modifie, ancienne_valeur, nouvel_valeur)
VALUES
    (NEW.id_utilisateur, 'email', old_email, new_email);
END IF;

IF old_password IS DISTINCT
FROM
    new_password THEN
INSERT INTO
    Public."Log" (id_utilisateur, valeur_modifie, ancienne_valeur, nouvel_valeur)
VALUES
    (NEW.id_utilisateur, 'mdp', old_password, new_password);
END IF;

IF old_role IS DISTINCT
FROM
    new_role THEN
INSERT INTO
    Public."Log" (id_utilisateur, valeur_modifie, ancienne_valeur, nouvel_valeur)
VALUES
    (NEW.id_utilisateur, 'role_utilisateur', old_role, new_role);

END IF;

RETURN NEW;

END;$$;


ALTER FUNCTION public.log_users() OWNER TO thomas;

--
-- TOC entry 222 (class 1255 OID 24583)
-- Name: update_date_modif(); Type: FUNCTION; Schema: public; Owner: thomas
--

CREATE FUNCTION public.update_date_modif() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.date_modif := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_date_modif() OWNER TO thomas;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 16412)
-- Name: Acteur; Type: TABLE; Schema: public; Owner: thomas
--

CREATE TABLE public."Acteur" (
    id_acteur integer NOT NULL,
    nom_acteur character varying(50) NOT NULL,
    prenom_acteur character varying(50) NOT NULL,
    date_naissance date NOT NULL,
    date_ajout_acteur date DEFAULT now() NOT NULL,
    date_modif timestamp(0) without time zone
);


ALTER TABLE public."Acteur" OWNER TO thomas;

--
-- TOC entry 219 (class 1259 OID 24587)
-- Name: Acteur_id_acteur_seq; Type: SEQUENCE; Schema: public; Owner: thomas
--

ALTER TABLE public."Acteur" ALTER COLUMN id_acteur ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Acteur_id_acteur_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 217 (class 1259 OID 16440)
-- Name: Aime; Type: TABLE; Schema: public; Owner: thomas
--

CREATE TABLE public."Aime" (
    id_film integer NOT NULL,
    id_utilisateur integer NOT NULL
);


ALTER TABLE public."Aime" OWNER TO thomas;

--
-- TOC entry 210 (class 1259 OID 16386)
-- Name: Film; Type: TABLE; Schema: public; Owner: thomas
--

CREATE TABLE public."Film" (
    id_film integer NOT NULL,
    titre character varying(50) NOT NULL,
    duree integer NOT NULL,
    annee integer NOT NULL,
    date_ajout_film date DEFAULT now() NOT NULL,
    date_modif timestamp(0) without time zone
);


ALTER TABLE public."Film" OWNER TO thomas;

--
-- TOC entry 209 (class 1259 OID 16385)
-- Name: Film_id_film_seq; Type: SEQUENCE; Schema: public; Owner: thomas
--

ALTER TABLE public."Film" ALTER COLUMN id_film ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Film_id_film_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 215 (class 1259 OID 16418)
-- Name: Joue; Type: TABLE; Schema: public; Owner: thomas
--

CREATE TABLE public."Joue" (
    id_acteur integer NOT NULL,
    id_film integer NOT NULL,
    role character varying(50) NOT NULL
);


ALTER TABLE public."Joue" OWNER TO thomas;

--
-- TOC entry 218 (class 1259 OID 16455)
-- Name: Log; Type: TABLE; Schema: public; Owner: thomas
--

CREATE TABLE public."Log" (
    id_log integer NOT NULL,
    id_utilisateur integer NOT NULL,
    valeur_modifie character varying(50) NOT NULL,
    ancienne_valeur character varying(50) NOT NULL,
    nouvel_valeur character varying(50) NOT NULL,
    date_ajout_log timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."Log" OWNER TO thomas;

--
-- TOC entry 221 (class 1259 OID 24603)
-- Name: Log_id_log_seq; Type: SEQUENCE; Schema: public; Owner: thomas
--

ALTER TABLE public."Log" ALTER COLUMN id_log ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Log_id_log_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 212 (class 1259 OID 16392)
-- Name: Realisateur; Type: TABLE; Schema: public; Owner: thomas
--

CREATE TABLE public."Realisateur" (
    id_realisateur integer NOT NULL,
    nom_real character varying(50) NOT NULL,
    prenom_real character varying(50) NOT NULL,
    date_ajout_real date DEFAULT now() NOT NULL,
    date_modif timestamp(0) without time zone
);


ALTER TABLE public."Realisateur" OWNER TO thomas;

--
-- TOC entry 211 (class 1259 OID 16391)
-- Name: Realisateur_id_realisateur_seq; Type: SEQUENCE; Schema: public; Owner: thomas
--

ALTER TABLE public."Realisateur" ALTER COLUMN id_realisateur ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Realisateur_id_realisateur_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 213 (class 1259 OID 16397)
-- Name: Realise; Type: TABLE; Schema: public; Owner: thomas
--

CREATE TABLE public."Realise" (
    id_film integer NOT NULL,
    id_realisateur integer NOT NULL
);


ALTER TABLE public."Realise" OWNER TO thomas;

--
-- TOC entry 216 (class 1259 OID 16433)
-- Name: Utilisateur; Type: TABLE; Schema: public; Owner: thomas
--

CREATE TABLE public."Utilisateur" (
    id_utilisateur integer NOT NULL,
    nom_utilisateur character varying(50) NOT NULL,
    prenom_utilisateur character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    mdp character varying(50) NOT NULL,
    role_utilisateur character varying(50) NOT NULL,
    date_ajout_utilisateur date DEFAULT now() NOT NULL
);


ALTER TABLE public."Utilisateur" OWNER TO thomas;

--
-- TOC entry 220 (class 1259 OID 24602)
-- Name: Utilisateur_id_utilisateur_seq; Type: SEQUENCE; Schema: public; Owner: thomas
--

ALTER TABLE public."Utilisateur" ALTER COLUMN id_utilisateur ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Utilisateur_id_utilisateur_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3379 (class 0 OID 16412)
-- Dependencies: 214
-- Data for Name: Acteur; Type: TABLE DATA; Schema: public; Owner: thomas
--

COPY public."Acteur" (id_acteur, nom_acteur, prenom_acteur, date_naissance, date_ajout_acteur, date_modif) FROM stdin;
2	nom	zde	2000-10-12	2023-12-19	\N
1	Nom6	prenom	2000-12-06	2023-12-19	2023-12-19 11:25:07
\.


--
-- TOC entry 3382 (class 0 OID 16440)
-- Dependencies: 217
-- Data for Name: Aime; Type: TABLE DATA; Schema: public; Owner: thomas
--

COPY public."Aime" (id_film, id_utilisateur) FROM stdin;
\.


--
-- TOC entry 3375 (class 0 OID 16386)
-- Dependencies: 210
-- Data for Name: Film; Type: TABLE DATA; Schema: public; Owner: thomas
--

COPY public."Film" (id_film, titre, duree, annee, date_ajout_film, date_modif) FROM stdin;
1	film	123	1234	2023-12-19	\N
2	film2	123	1456	2023-12-19	\N
3	titre42	98	2222	2023-12-19	2023-12-19 14:50:55
\.


--
-- TOC entry 3380 (class 0 OID 16418)
-- Dependencies: 215
-- Data for Name: Joue; Type: TABLE DATA; Schema: public; Owner: thomas
--

COPY public."Joue" (id_acteur, id_film, role) FROM stdin;
1	1	role
\.


--
-- TOC entry 3383 (class 0 OID 16455)
-- Dependencies: 218
-- Data for Name: Log; Type: TABLE DATA; Schema: public; Owner: thomas
--

COPY public."Log" (id_log, id_utilisateur, valeur_modifie, ancienne_valeur, nouvel_valeur, date_ajout_log) FROM stdin;
1	1	nom_utilisateur	nom	nom2	2023-12-19 00:00:00
2	1	nom_utilisateur	nom2	nom3	2023-12-19 13:06:26
3	1	prenom_utilisateur	prenom	prenom2	2023-12-19 13:06:26
\.


--
-- TOC entry 3377 (class 0 OID 16392)
-- Dependencies: 212
-- Data for Name: Realisateur; Type: TABLE DATA; Schema: public; Owner: thomas
--

COPY public."Realisateur" (id_realisateur, nom_real, prenom_real, date_ajout_real, date_modif) FROM stdin;
1	nom	prenom	2023-12-20	\N
2	nom2	prenom2	2023-12-20	\N
\.


--
-- TOC entry 3378 (class 0 OID 16397)
-- Dependencies: 213
-- Data for Name: Realise; Type: TABLE DATA; Schema: public; Owner: thomas
--

COPY public."Realise" (id_film, id_realisateur) FROM stdin;
1	1
2	2
2	1
\.


--
-- TOC entry 3381 (class 0 OID 16433)
-- Dependencies: 216
-- Data for Name: Utilisateur; Type: TABLE DATA; Schema: public; Owner: thomas
--

COPY public."Utilisateur" (id_utilisateur, nom_utilisateur, prenom_utilisateur, email, mdp, role_utilisateur, date_ajout_utilisateur) FROM stdin;
1	nom3	prenom2	email	mdp	role	2023-12-19
\.


--
-- TOC entry 3402 (class 0 OID 0)
-- Dependencies: 219
-- Name: Acteur_id_acteur_seq; Type: SEQUENCE SET; Schema: public; Owner: thomas
--

SELECT pg_catalog.setval('public."Acteur_id_acteur_seq"', 3, true);


--
-- TOC entry 3403 (class 0 OID 0)
-- Dependencies: 209
-- Name: Film_id_film_seq; Type: SEQUENCE SET; Schema: public; Owner: thomas
--

SELECT pg_catalog.setval('public."Film_id_film_seq"', 3, true);


--
-- TOC entry 3404 (class 0 OID 0)
-- Dependencies: 221
-- Name: Log_id_log_seq; Type: SEQUENCE SET; Schema: public; Owner: thomas
--

SELECT pg_catalog.setval('public."Log_id_log_seq"', 3, true);


--
-- TOC entry 3405 (class 0 OID 0)
-- Dependencies: 211
-- Name: Realisateur_id_realisateur_seq; Type: SEQUENCE SET; Schema: public; Owner: thomas
--

SELECT pg_catalog.setval('public."Realisateur_id_realisateur_seq"', 2, true);


--
-- TOC entry 3406 (class 0 OID 0)
-- Dependencies: 220
-- Name: Utilisateur_id_utilisateur_seq; Type: SEQUENCE SET; Schema: public; Owner: thomas
--

SELECT pg_catalog.setval('public."Utilisateur_id_utilisateur_seq"', 1, true);


--
-- TOC entry 3213 (class 2606 OID 16417)
-- Name: Acteur Acteur_pkey; Type: CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Acteur"
    ADD CONSTRAINT "Acteur_pkey" PRIMARY KEY (id_acteur);


--
-- TOC entry 3221 (class 2606 OID 16444)
-- Name: Aime Aime_pkey; Type: CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Aime"
    ADD CONSTRAINT "Aime_pkey" PRIMARY KEY (id_film, id_utilisateur);


--
-- TOC entry 3207 (class 2606 OID 16390)
-- Name: Film Film_pkey; Type: CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Film"
    ADD CONSTRAINT "Film_pkey" PRIMARY KEY (id_film);


--
-- TOC entry 3215 (class 2606 OID 16422)
-- Name: Joue Joue_pkey; Type: CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Joue"
    ADD CONSTRAINT "Joue_pkey" PRIMARY KEY (id_acteur, id_film);


--
-- TOC entry 3223 (class 2606 OID 16459)
-- Name: Log Log_pkey; Type: CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Log"
    ADD CONSTRAINT "Log_pkey" PRIMARY KEY (id_log);


--
-- TOC entry 3209 (class 2606 OID 16396)
-- Name: Realisateur Realisateur_pkey; Type: CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Realisateur"
    ADD CONSTRAINT "Realisateur_pkey" PRIMARY KEY (id_realisateur);


--
-- TOC entry 3211 (class 2606 OID 16401)
-- Name: Realise Realise_pkey; Type: CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Realise"
    ADD CONSTRAINT "Realise_pkey" PRIMARY KEY (id_film, id_realisateur);


--
-- TOC entry 3217 (class 2606 OID 16439)
-- Name: Utilisateur Utilisateur_email_key; Type: CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Utilisateur"
    ADD CONSTRAINT "Utilisateur_email_key" UNIQUE (email);


--
-- TOC entry 3219 (class 2606 OID 16437)
-- Name: Utilisateur Utilisateur_pkey; Type: CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Utilisateur"
    ADD CONSTRAINT "Utilisateur_pkey" PRIMARY KEY (id_utilisateur);


--
-- TOC entry 3234 (class 2620 OID 24601)
-- Name: Utilisateur log_changes; Type: TRIGGER; Schema: public; Owner: thomas
--

CREATE TRIGGER log_changes AFTER UPDATE ON public."Utilisateur" FOR EACH ROW EXECUTE FUNCTION public.log_users();


--
-- TOC entry 3233 (class 2620 OID 24584)
-- Name: Acteur modif_acteur_modif; Type: TRIGGER; Schema: public; Owner: thomas
--

CREATE TRIGGER modif_acteur_modif BEFORE UPDATE ON public."Acteur" FOR EACH ROW EXECUTE FUNCTION public.update_date_modif();


--
-- TOC entry 3231 (class 2620 OID 24585)
-- Name: Film update_film_modif; Type: TRIGGER; Schema: public; Owner: thomas
--

CREATE TRIGGER update_film_modif BEFORE UPDATE ON public."Film" FOR EACH ROW EXECUTE FUNCTION public.update_date_modif();


--
-- TOC entry 3232 (class 2620 OID 24586)
-- Name: Realisateur update_real_modif; Type: TRIGGER; Schema: public; Owner: thomas
--

CREATE TRIGGER update_real_modif BEFORE UPDATE ON public."Realisateur" FOR EACH ROW EXECUTE FUNCTION public.update_date_modif();


--
-- TOC entry 3228 (class 2606 OID 16445)
-- Name: Aime Aime_id_film_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Aime"
    ADD CONSTRAINT "Aime_id_film_fkey" FOREIGN KEY (id_film) REFERENCES public."Film"(id_film);


--
-- TOC entry 3229 (class 2606 OID 16450)
-- Name: Aime Aime_id_utilisateur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Aime"
    ADD CONSTRAINT "Aime_id_utilisateur_fkey" FOREIGN KEY (id_utilisateur) REFERENCES public."Utilisateur"(id_utilisateur);


--
-- TOC entry 3226 (class 2606 OID 16423)
-- Name: Joue Joue_id_acteur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Joue"
    ADD CONSTRAINT "Joue_id_acteur_fkey" FOREIGN KEY (id_acteur) REFERENCES public."Acteur"(id_acteur);


--
-- TOC entry 3227 (class 2606 OID 16428)
-- Name: Joue Joue_id_film_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Joue"
    ADD CONSTRAINT "Joue_id_film_fkey" FOREIGN KEY (id_film) REFERENCES public."Film"(id_film);


--
-- TOC entry 3230 (class 2606 OID 16460)
-- Name: Log Log_id_utilisateur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Log"
    ADD CONSTRAINT "Log_id_utilisateur_fkey" FOREIGN KEY (id_utilisateur) REFERENCES public."Utilisateur"(id_utilisateur);


--
-- TOC entry 3224 (class 2606 OID 16402)
-- Name: Realise Realise_id_film_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Realise"
    ADD CONSTRAINT "Realise_id_film_fkey" FOREIGN KEY (id_film) REFERENCES public."Film"(id_film);


--
-- TOC entry 3225 (class 2606 OID 16407)
-- Name: Realise Realise_id_realisateur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: thomas
--

ALTER TABLE ONLY public."Realise"
    ADD CONSTRAINT "Realise_id_realisateur_fkey" FOREIGN KEY (id_realisateur) REFERENCES public."Realisateur"(id_realisateur);


--
-- TOC entry 3393 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: thomas
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE "Acteur"; Type: ACL; Schema: public; Owner: thomas
--

GRANT SELECT ON TABLE public."Acteur" TO "User";


--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE "Aime"; Type: ACL; Schema: public; Owner: thomas
--

GRANT SELECT ON TABLE public."Aime" TO "User";


--
-- TOC entry 3396 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE "Film"; Type: ACL; Schema: public; Owner: thomas
--

GRANT SELECT ON TABLE public."Film" TO "User";


--
-- TOC entry 3397 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE "Joue"; Type: ACL; Schema: public; Owner: thomas
--

GRANT SELECT ON TABLE public."Joue" TO "User";


--
-- TOC entry 3398 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE "Log"; Type: ACL; Schema: public; Owner: thomas
--

GRANT SELECT ON TABLE public."Log" TO "User";


--
-- TOC entry 3399 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE "Realisateur"; Type: ACL; Schema: public; Owner: thomas
--

GRANT SELECT ON TABLE public."Realisateur" TO "User";


--
-- TOC entry 3400 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE "Realise"; Type: ACL; Schema: public; Owner: thomas
--

GRANT SELECT ON TABLE public."Realise" TO "User";


--
-- TOC entry 3401 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE "Utilisateur"; Type: ACL; Schema: public; Owner: thomas
--

GRANT SELECT ON TABLE public."Utilisateur" TO "User";


-- Completed on 2023-12-20 15:29:07

--
-- PostgreSQL database dump complete
--

