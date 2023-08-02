PGDMP                         {           Progetto_BD_FINALE    15.1    15.1 I    p           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            q           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            r           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            s           1262    25432    Progetto_BD_FINALE    DATABASE     v   CREATE DATABASE "Progetto_BD_FINALE" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';
 $   DROP DATABASE "Progetto_BD_FINALE";
                postgres    false            `           1247    25434 
   tipo_prova    TYPE     e   CREATE TYPE public.tipo_prova AS ENUM (
    'scritto',
    'orale',
    'pratico',
    'completo'
);
    DROP TYPE public.tipo_prova;
       public          postgres    false            �            1255    25443    Deny_Delete_Test_Done()    FUNCTION     ^  CREATE FUNCTION public."Deny_Delete_Test_Done"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS ( SELECT *
                FROM registrazione_esame re JOIN prova p ON re."idE"=p."idE" JOIN old_table o ON o."idP"=p."idP"
                ))
        THEN INSERT INTO prova(idP,tipo_voto,idE,tipo_prova,nome_prova,idD,data,data_scadenza,ora_prova,percentuale)
        VALUES(old_table.idP,old_table.tipo_voto,old_table.idE,old_table.tipo_prova,old_table.nome_prova,old_table.idD,old_table.data,old_table.data_scadenza,old_table.ora_prova,old_table.percentuale);
	END IF;
	RETURN NEW;
END$$;
 0   DROP FUNCTION public."Deny_Delete_Test_Done"();
       public          postgres    false            �            1255    25444    Deny_Delete_Verbalized_Exam()    FUNCTION     �  CREATE FUNCTION public."Deny_Delete_Verbalized_Exam"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS ( SELECT *
                FROM registrazione_esame re JOIN old_table o ON re."idE" = o."idE"
                ))
        THEN INSERT INTO esame(idE,nome,anno_accademico,cfu)
        VALUES(old_table.idE,old_table.nome,old_table.anno_accademico,old_table.cfu);
    END IF;
	RETURN NEW;
END$$;
 6   DROP FUNCTION public."Deny_Delete_Verbalized_Exam"();
       public          postgres    false            �            1255    25445 !   Deny_Double_Test_Different_Exam()    FUNCTION     #  CREATE FUNCTION public."Deny_Double_Test_Different_Exam"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS ( SELECT *
                FROM prova p
                WHERE new."idP"=p."idP" AND new."idE"<>p."idE"))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 :   DROP FUNCTION public."Deny_Double_Test_Different_Exam"();
       public          postgres    false            �            1255    25446    Deny_Insert_Double_Date_Test()    FUNCTION       CREATE FUNCTION public."Deny_Insert_Double_Date_Test"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS ( SELECT *
                FROM prova
                WHERE new."idP"<>"idP" AND new."data"="data"))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 7   DROP FUNCTION public."Deny_Insert_Double_Date_Test"();
       public          postgres    false            �            1255    25447    Is_Exam_Double()    FUNCTION     �   CREATE FUNCTION public."Is_Exam_Double"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS(SELECT *
                FROM esame e
                WHERE new."nome"=e."nome"))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 )   DROP FUNCTION public."Is_Exam_Double"();
       public          postgres    false            �            1255    25448    Is_Passed()    FUNCTION       CREATE FUNCTION public."Is_Passed"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF FALSE=ANY(SELECT p.stato_superamento
                 FROM prova p
                 WHERE new."idE"==p."idE")
        THEN RETURN NULL;
	END IF;
	RETURN NEW;
END
$$;
 $   DROP FUNCTION public."Is_Passed"();
       public          postgres    false            �            1255    25449    Is_Replaced()    FUNCTION     �  CREATE FUNCTION public."Is_Replaced"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(new."idP" IN ( SELECT "idP"
                    FROM "Appelli")
        AND new."idS"=( SELECT "idS"
                      FROM "Appelli"
                      WHERE "idP"=new."idP"))
        THEN
        UPDATE "Appelli"
        SET "voto"=new."voto", "stato_superamento"=new."stato_superamento"
        WHERE "idP"=new."idP" AND "idS"=new."idS";
    END IF;
    RETURN NEW;
END$$;
 &   DROP FUNCTION public."Is_Replaced"();
       public          postgres    false            �            1255    25450    Is_Test_Double()    FUNCTION       CREATE FUNCTION public."Is_Test_Double"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS(SELECT *
                FROM prova p
                WHERE new."nome_prova"=p."nome_prova"))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 )   DROP FUNCTION public."Is_Test_Double"();
       public          postgres    false            �            1255    25451 
   Is_Valid()    FUNCTION       CREATE FUNCTION public."Is_Valid"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF( GETDATE()> ANY (SELECT p.data_scadenza   
                        FROM prova p
                        WHERE new."idE"==p."idE"))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 #   DROP FUNCTION public."Is_Valid"();
       public          postgres    false            �            1255    25452    Passed_First_Test()    FUNCTION     <  CREATE FUNCTION public."Passed_First_Test"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS ( SELECT *
                FROM "Appelli" a JOIN prova p ON a."idP"=p."idP"
                WHERE a."stato_superamento"=FALSE AND p."idP"=( SELECT p1."idP"
                                                            FROM "Appelli" a1 JOIN prova p1 ON a1."idP"=p1."idP"
                                                            WHERE p1."idP"=p."idP" AND p1."data"<>p."data" AND a1."idS"=a."idS")))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 ,   DROP FUNCTION public."Passed_First_Test"();
       public          postgres    false            �            1255    25453    Secure_Only_One()    FUNCTION       CREATE FUNCTION public."Secure_Only_One"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS(SELECT *
              FROM "Appelli" a
              WHERE new."idS"=a."idS" AND new."idP"=a."idP"))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 *   DROP FUNCTION public."Secure_Only_One"();
       public          postgres    false            �            1255    25454    iscrizione_seconda_prova()    FUNCTION     �  CREATE FUNCTION public.iscrizione_seconda_prova() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF '%SECONDA PROVA%' IN (SELECT nome_prova
							FROM prova
							WHERE "idP" = new."idP")
	AND new."idS" IN (SELECT a."idS"
		FROM "Appelli" a JOIN prova p ON a."idP" = p."idP"
		WHERE p.nome_prova LIKE '%PRIMA PROVA%' AND a.stato_superamento = false)
	THEN RETURN NULL;
	END IF;
	RETURN NEW;
END;$$;
 1   DROP FUNCTION public.iscrizione_seconda_prova();
       public          postgres    false            �            1255    25455    prova_is_Sufficiente()    FUNCTION     �  CREATE FUNCTION public."prova_is_Sufficiente"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF EXISTS (
		SELECT *
		FROM "Appelli" a JOIN prova p ON a."idP" = p."idP"
		WHERE a."voto" >= p."sufficienza" AND a."idP" = NEW."idP"
	) THEN
		UPDATE "Appelli"
		SET "stato_superamento"=TRUE
		WHERE "idP"=NEW."idP";
	ELSE
		UPDATE "Appelli"
		SET "stato_superamento"=FALSE
		WHERE "idP"=NEW."idP";
	END IF;

	RETURN NEW;
END;$$;
 /   DROP FUNCTION public."prova_is_Sufficiente"();
       public          postgres    false            �            1255    25456    save_history_esame()    FUNCTION     �  CREATE FUNCTION public.save_history_esame() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE
    current_year INTEGER := EXTRACT(YEAR FROM NOW());
    first_year_str TEXT;
    second_year_str TEXT;
    first_year INTEGER;
    second_year INTEGER;
BEGIN
    first_year_str := SUBSTRING(anno_accademico FROM 1 FOR 4);
    second_year_str := SUBSTRING(anno_accademico FROM 6);
    first_year := CAST(first_year_str AS INTEGER);
    second_year := CAST(second_year_str AS INTEGER);

    IF second_year IS NOT NULL AND current_year > second_year THEN
        INSERT INTO esame_audit SELECT * FROM esame WHERE "idE" = NEW."idE";
        DELETE FROM esame WHERE "idE" = NEW."idE";
    END IF;

    RETURN NEW;
END;$$;
 +   DROP FUNCTION public.save_history_esame();
       public          postgres    false            �            1255    25457    save_history_prove()    FUNCTION     6  CREATE FUNCTION public.save_history_prove() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    DECLARE
        current_year INTEGER := EXTRACT(YEAR FROM NOW());

    DECLARE
        prova_year INTEGER;
    BEGIN
        SELECT EXTRACT(YEAR FROM NEW.data) INTO prova_year
        FROM prova WHERE prova."idP" = NEW."idP";
    END;

    IF prova_year IS NOT NULL AND current_year > prova_year THEN
        INSERT INTO prova_audit SELECT * FROM prova WHERE "idP" = NEW."idP";
        DELETE FROM prova WHERE "idP" = NEW."idP";
    END IF;

    RETURN NEW;
END;$$;
 +   DROP FUNCTION public.save_history_prove();
       public          postgres    false            �            1255    25458    seconda_prova_ins()    FUNCTION     E  CREATE FUNCTION public.seconda_prova_ins() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF new.stato_superamento is false and new."idP" = ( SELECT "idP"
	  													FROM prova
	  													WHERE nome_prova LIKE '%SECONDA PROVA%')
	THEN 	INSERT INTO "Appelli_audit" (idS, voto, stato_superamento, "idP")
            VALUES (NEW.idS, NEW.voto, NEW.stato_superamento, NEW."idP");
			INSERT INTO "Appelli_audit" (idS, voto, stato_superamento, "idP")
            VALUES (OLD.idS, OLD.voto, OLD.stato_superamento, OLD."idP");
			RETURN NULL;
	END IF;
	RETURN NEW;
END;$$;
 *   DROP FUNCTION public.seconda_prova_ins();
       public          postgres    false            �            1259    25459    Appelli    TABLE     �   CREATE TABLE public."Appelli" (
    "idS" integer NOT NULL,
    voto double precision,
    stato_superamento boolean,
    "idP" character varying(100) NOT NULL
);
    DROP TABLE public."Appelli";
       public         heap    postgres    false            �            1259    25462    Appelli_audit    TABLE     �   CREATE TABLE public."Appelli_audit" (
    "idP" character varying(100) NOT NULL,
    "idS" integer NOT NULL,
    voto double precision,
    stato_superamento boolean
);
 #   DROP TABLE public."Appelli_audit";
       public         heap    postgres    false            �            1259    25465    Creazione_esame    TABLE     �   CREATE TABLE public."Creazione_esame" (
    "idD" character(200) NOT NULL,
    "idE" character varying(100) NOT NULL,
    ruolo_docente character varying
);
 %   DROP TABLE public."Creazione_esame";
       public         heap    postgres    false            �            1259    25470    alembic_version    TABLE     X   CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);
 #   DROP TABLE public.alembic_version;
       public         heap    postgres    false            �            1259    25473    creazione_esame_audit    TABLE     �   CREATE TABLE public.creazione_esame_audit (
    "idD" character varying(200),
    "idE" character varying(100),
    ruolo_docente character varying(100)
);
 )   DROP TABLE public.creazione_esame_audit;
       public         heap    postgres    false            �            1259    25476    docente    TABLE     �   CREATE TABLE public.docente (
    "idD" character(200) NOT NULL,
    nome character varying(100),
    cognome character varying(100),
    email character varying(100),
    password character varying(200)
);
    DROP TABLE public.docente;
       public         heap    postgres    false            �            1259    25481    esame    TABLE     �   CREATE TABLE public.esame (
    "idE" character varying(100) NOT NULL,
    nome character varying(100),
    anno_accademico character varying(100),
    cfu integer
);
    DROP TABLE public.esame;
       public         heap    postgres    false            �            1259    25484    esame_audit    TABLE     �   CREATE TABLE public.esame_audit (
    "idD" character varying(200),
    nome character varying(100),
    anno_accademico character varying(100),
    cfu integer
);
    DROP TABLE public.esame_audit;
       public         heap    postgres    false            �            1259    25487    prova    TABLE     o  CREATE TABLE public.prova (
    "idP" character varying(100) NOT NULL,
    tipo_voto character varying(100),
    "idE" character varying(100),
    tipo_prova character varying(8),
    nome_prova character varying(100),
    "idD" character(200),
    data date,
    data_scadenza date,
    ora_prova character varying(100),
    peso integer,
    sufficienza integer
);
    DROP TABLE public.prova;
       public         heap    postgres    false            �            1259    25492    prova_audit    TABLE     n  CREATE TABLE public.prova_audit (
    "idP" character varying(100),
    tipo_voto character varying(100),
    "idE" character varying(100),
    tipo_prova character varying(100),
    nome_prova character varying(100),
    "idD" character(200),
    data date,
    data_scadenza date,
    ora_prova character varying(100),
    peso integer,
    sufficienza integer
);
    DROP TABLE public.prova_audit;
       public         heap    postgres    false            �            1259    25497    registrazione_esame    TABLE     �   CREATE TABLE public.registrazione_esame (
    "idS" integer NOT NULL,
    "idE" character varying(100) NOT NULL,
    voto double precision,
    data_superamento date
);
 '   DROP TABLE public.registrazione_esame;
       public         heap    postgres    false            �            1259    25500    studente    TABLE     �   CREATE TABLE public.studente (
    "idS" integer NOT NULL,
    nome character varying(100),
    cognome character varying(100)
);
    DROP TABLE public.studente;
       public         heap    postgres    false            b          0    25459    Appelli 
   TABLE DATA           J   COPY public."Appelli" ("idS", voto, stato_superamento, "idP") FROM stdin;
    public          postgres    false    214   �n       c          0    25462    Appelli_audit 
   TABLE DATA           P   COPY public."Appelli_audit" ("idP", "idS", voto, stato_superamento) FROM stdin;
    public          postgres    false    215   �n       d          0    25465    Creazione_esame 
   TABLE DATA           H   COPY public."Creazione_esame" ("idD", "idE", ruolo_docente) FROM stdin;
    public          postgres    false    216   �o       e          0    25470    alembic_version 
   TABLE DATA           6   COPY public.alembic_version (version_num) FROM stdin;
    public          postgres    false    217   �p       f          0    25473    creazione_esame_audit 
   TABLE DATA           L   COPY public.creazione_esame_audit ("idD", "idE", ruolo_docente) FROM stdin;
    public          postgres    false    218   �p       g          0    25476    docente 
   TABLE DATA           H   COPY public.docente ("idD", nome, cognome, email, password) FROM stdin;
    public          postgres    false    219   �p       h          0    25481    esame 
   TABLE DATA           B   COPY public.esame ("idE", nome, anno_accademico, cfu) FROM stdin;
    public          postgres    false    220   �r       i          0    25484    esame_audit 
   TABLE DATA           H   COPY public.esame_audit ("idD", nome, anno_accademico, cfu) FROM stdin;
    public          postgres    false    221   Ss       j          0    25487    prova 
   TABLE DATA           �   COPY public.prova ("idP", tipo_voto, "idE", tipo_prova, nome_prova, "idD", data, data_scadenza, ora_prova, peso, sufficienza) FROM stdin;
    public          postgres    false    222   ps       k          0    25492    prova_audit 
   TABLE DATA           �   COPY public.prova_audit ("idP", tipo_voto, "idE", tipo_prova, nome_prova, "idD", data, data_scadenza, ora_prova, peso, sufficienza) FROM stdin;
    public          postgres    false    223   �u       l          0    25497    registrazione_esame 
   TABLE DATA           S   COPY public.registrazione_esame ("idS", "idE", voto, data_superamento) FROM stdin;
    public          postgres    false    224   �u       m          0    25500    studente 
   TABLE DATA           8   COPY public.studente ("idS", nome, cognome) FROM stdin;
    public          postgres    false    225   3v       �           2606    25504    Appelli Appelli_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."Appelli"
    ADD CONSTRAINT "Appelli_pkey" PRIMARY KEY ("idP", "idS");
 B   ALTER TABLE ONLY public."Appelli" DROP CONSTRAINT "Appelli_pkey";
       public            postgres    false    214    214            �           2606    25506 #   alembic_version alembic_version_pkc 
   CONSTRAINT     j   ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);
 M   ALTER TABLE ONLY public.alembic_version DROP CONSTRAINT alembic_version_pkc;
       public            postgres    false    217            �           2606    25508 $   Creazione_esame creazione_esame_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_pkey PRIMARY KEY ("idD", "idE");
 P   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_pkey;
       public            postgres    false    216    216            �           2606    25510    docente docente_email_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.docente
    ADD CONSTRAINT docente_email_key UNIQUE (email);
 C   ALTER TABLE ONLY public.docente DROP CONSTRAINT docente_email_key;
       public            postgres    false    219            �           2606    25512    docente docente_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.docente
    ADD CONSTRAINT docente_pkey PRIMARY KEY ("idD");
 >   ALTER TABLE ONLY public.docente DROP CONSTRAINT docente_pkey;
       public            postgres    false    219            �           2606    25514    esame esame_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.esame
    ADD CONSTRAINT esame_pkey PRIMARY KEY ("idE");
 :   ALTER TABLE ONLY public.esame DROP CONSTRAINT esame_pkey;
       public            postgres    false    220            �           2606    25516    prova prova_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.prova
    ADD CONSTRAINT prova_pkey PRIMARY KEY ("idP");
 :   ALTER TABLE ONLY public.prova DROP CONSTRAINT prova_pkey;
       public            postgres    false    222            �           2606    25518 ,   registrazione_esame registrazione_esame_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_pkey PRIMARY KEY ("idS", "idE");
 V   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_pkey;
       public            postgres    false    224    224            �           2606    25520    studente studente_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT studente_pkey PRIMARY KEY ("idS");
 @   ALTER TABLE ONLY public.studente DROP CONSTRAINT studente_pkey;
       public            postgres    false    225            �           2620    25521    prova Delete_Test_Done    TRIGGER     �   CREATE TRIGGER "Delete_Test_Done" AFTER DELETE ON public.prova REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION public."Deny_Delete_Test_Done"();
 1   DROP TRIGGER "Delete_Test_Done" ON public.prova;
       public          postgres    false    222    226            �           2620    25522    esame Delete_Verbalized_Exam    TRIGGER     �   CREATE TRIGGER "Delete_Verbalized_Exam" AFTER DELETE ON public.esame REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION public."Deny_Delete_Verbalized_Exam"();
 7   DROP TRIGGER "Delete_Verbalized_Exam" ON public.esame;
       public          postgres    false    220    227            �           2620    25523    prova Double_Date_Test    TRIGGER     �   CREATE TRIGGER "Double_Date_Test" BEFORE INSERT ON public.prova FOR EACH ROW EXECUTE FUNCTION public."Deny_Insert_Double_Date_Test"();
 1   DROP TRIGGER "Double_Date_Test" ON public.prova;
       public          postgres    false    229    222            �           2620    25524    esame Double_Exam_Name    TRIGGER     �   CREATE TRIGGER "Double_Exam_Name" BEFORE INSERT OR UPDATE ON public.esame FOR EACH ROW EXECUTE FUNCTION public."Is_Exam_Double"();
 1   DROP TRIGGER "Double_Exam_Name" ON public.esame;
       public          postgres    false    230    220            �           2620    25525     prova Double_Test_Different_Exam    TRIGGER     �   CREATE TRIGGER "Double_Test_Different_Exam" BEFORE INSERT OR UPDATE ON public.prova FOR EACH ROW EXECUTE FUNCTION public."Deny_Double_Test_Different_Exam"();
 ;   DROP TRIGGER "Double_Test_Different_Exam" ON public.prova;
       public          postgres    false    228    222            �           2620    25526    prova Double_Test_Name    TRIGGER     �   CREATE TRIGGER "Double_Test_Name" BEFORE INSERT OR UPDATE ON public.prova FOR EACH ROW EXECUTE FUNCTION public."Is_Test_Double"();
 1   DROP TRIGGER "Double_Test_Name" ON public.prova;
       public          postgres    false    233    222            �           2620    25527    Appelli First_Test    TRIGGER     �   CREATE TRIGGER "First_Test" BEFORE INSERT OR UPDATE ON public."Appelli" FOR EACH ROW EXECUTE FUNCTION public."Passed_First_Test"();

ALTER TABLE public."Appelli" DISABLE TRIGGER "First_Test";
 /   DROP TRIGGER "First_Test" ON public."Appelli";
       public          postgres    false    235    214            �           2620    25528    Appelli Only_One    TRIGGER     v   CREATE TRIGGER "Only_One" BEFORE INSERT ON public."Appelli" FOR EACH ROW EXECUTE FUNCTION public."Secure_Only_One"();
 -   DROP TRIGGER "Only_One" ON public."Appelli";
       public          postgres    false    214    236            �           2620    25529    registrazione_esame Passed    TRIGGER     �   CREATE TRIGGER "Passed" BEFORE INSERT ON public.registrazione_esame FOR EACH ROW EXECUTE FUNCTION public."Is_Passed"();

ALTER TABLE public.registrazione_esame DISABLE TRIGGER "Passed";
 5   DROP TRIGGER "Passed" ON public.registrazione_esame;
       public          postgres    false    231    224            �           2620    25530    Appelli Sostitution    TRIGGER     �   CREATE TRIGGER "Sostitution" AFTER INSERT OR UPDATE ON public."Appelli" FOR EACH STATEMENT EXECUTE FUNCTION public."Is_Replaced"();

ALTER TABLE public."Appelli" DISABLE TRIGGER "Sostitution";
 0   DROP TRIGGER "Sostitution" ON public."Appelli";
       public          postgres    false    232    214            �           2620    25560    Appelli Sufficiente    TRIGGER     �   CREATE TRIGGER "Sufficiente" BEFORE INSERT OR UPDATE ON public."Appelli" FOR EACH ROW EXECUTE FUNCTION public."prova_is_Sufficiente"();
 0   DROP TRIGGER "Sufficiente" ON public."Appelli";
       public          postgres    false    241    214            �           2620    25532    registrazione_esame Valid    TRIGGER     �   CREATE TRIGGER "Valid" BEFORE INSERT ON public.registrazione_esame FOR EACH ROW EXECUTE FUNCTION public."Is_Valid"();

ALTER TABLE public.registrazione_esame DISABLE TRIGGER "Valid";
 4   DROP TRIGGER "Valid" ON public.registrazione_esame;
       public          postgres    false    224    234            �           2620    25533    prova save_history    TRIGGER     �   CREATE TRIGGER save_history BEFORE UPDATE OF "idP", tipo_voto, "idE", tipo_prova, nome_prova, "idD", data, data_scadenza, ora_prova, peso, sufficienza ON public.prova FOR EACH ROW EXECUTE FUNCTION public.save_history_prove();
 +   DROP TRIGGER save_history ON public.prova;
       public          postgres    false    222    239    222    222    222    222    222    222    222    222    222    222    222            �           2620    25534    esame save_history_esami    TRIGGER     �   CREATE TRIGGER save_history_esami BEFORE UPDATE OF "idE", nome, anno_accademico, cfu ON public.esame FOR EACH ROW EXECUTE FUNCTION public.save_history_esame();
 1   DROP TRIGGER save_history_esami ON public.esame;
       public          postgres    false    238    220    220    220    220    220            �           2606    25535    Appelli Appelli_idP_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public."Appelli"
    ADD CONSTRAINT "Appelli_idP_fkey" FOREIGN KEY ("idP") REFERENCES public.prova("idP");
 F   ALTER TABLE ONLY public."Appelli" DROP CONSTRAINT "Appelli_idP_fkey";
       public          postgres    false    214    222    3516            �           2606    25540 (   Creazione_esame creazione_esame_idd_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_idd_fkey FOREIGN KEY ("idD") REFERENCES public.docente("idD");
 T   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_idd_fkey;
       public          postgres    false    216    3512    219            �           2606    25545 (   Creazione_esame creazione_esame_ide_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_ide_fkey FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 T   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_ide_fkey;
       public          postgres    false    216    220    3514            �           2606    25550 0   registrazione_esame registrazione_esame_ide_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_ide_fkey FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 Z   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_ide_fkey;
       public          postgres    false    3514    224    220            �           2606    25555 0   registrazione_esame registrazione_esame_ids_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_ids_fkey FOREIGN KEY ("idS") REFERENCES public.studente("idS");
 Z   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_ids_fkey;
       public          postgres    false    3520    225    224            b   D   x���0�05�44�,�t101W0
ಀZ��Ab��憜F�`A]csg� �#�=... T�U      c   �   x���M� ���)z3@�M�FC�,]��?�Z`�����ϛ�AJ�w8s�F����]�����R@����;�޻Nݿ�(re��LX3�AT@&�y��R�"Yh�@].���+Y����MƷ��pn�!���Z2@G;�M���O��`(������)�q��������(�4�)G!���      d   �   x�ݔ;NCAE��*�#{���5��((i��( )a��P��Eyw��\[Gre��b�B�ॲ81��rx|FD=<���:��3���ڲ�j �t)��F�֨��}M~Ѷx맏��1�U.����9�5� 0kj�}1g�[��&l?���g��Sd��i@�+ϲB9��J��g����>?Ȇ�x���R�1���      e      x�K1N40L32MN5O����� .�;      f      x������ � �      g   �  x�Ք�N[A���>E����w̪�J��P+B����x�.!$!�<Mߥ/�D���q6���ͧ#SV�L�pa6!��$��a|`�A-�{�&�ldY��}�ZE��t��~�����Ӄqۭ�U��p�Sҡ#h���K������C�ӛ����D� �ȃ�D�Y�\��c-�9A)�ar��2El�&t��J&�yxmx/Q�m�U�7ݱL�k@�M��>Cuq���-/?����0��*E���:h�ɦ�1�((G�Z�ƨ)W@�BE�;��=���DO��hb�llg�z�ؾ6����"��tӝ�4����y���a��t�����3"�Ě���UQ�8!2q��sD I�Y��@csitV1��nw��Ė�TOF���Օf%�o����v�Gu.�q��ݾ<�3�������tqrzry?�IF�g3@t�Z�� C���=_UΑs���)�o���8���0+&�      h   �   x�m�K
�0D��)t���m���A�`+�B����~`���<&%X�+�Cl
���0y��Da��e�5�]Q�[;̎&���������CM.��	����f.��*Mj�bnU���J��.v��x��ȟg�� �-�      i      x������ � �      j   9  x�ݖ�n�@F��S�L5w��;�i�dc�IU6��RbW���0��v�t������}w��
�!C�����~�zD�2�ѱ>lO�=��d�,_}��a�#	1��`�%�V����Ԅ�md�w
�1�8��p�E{d�����QA(���;���e��� iG�t~��(0զ��pň�\cʚh��j8g>�{�3=&�e3�a�q�T]qj��¤j'�*N��Z"�F��qM��\X���g����#0��|FEK�;&��Ա������z�$��c�K�Z���2[���U_�u�������Ĥ�&��/j����gz��5wk�f�O	�	�N�\ ��%�	<��M����ٍ��u]����Ye|���TB2�K�\Y����GSx�3��L��%�"_RR���O���|�����U�a��(J0��5k������j��;�ԥ��_|b������~J�A���FHϓaO^�u�D�'�8��(�a:ǋ8��$}���4�pW�;����
t���bvk��������p����x]�E���ޢ^Iu��Sܭ��ӗ ~�W�      k      x������ � �      l   M   x�]ɻ�0�������gJ��EB������ S2�Jܝ��Ҿ9:�I�_��0���ؼ�u��sc��;�      m   �   x����0E�ׯ����vv�����@\�/�D^P�^H�t�ɍ������'�@�L��*j���c�0���XY�ż��:e�NC�ԥWb]gY��q}v~;�_�
��Gl�E��qx�r�_��,��U��h���,�     