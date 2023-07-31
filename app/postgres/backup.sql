PGDMP                          {           Progetto_BD    15.1    15.1 G    b           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            c           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            d           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            e           1262    17188    Progetto_BD    DATABASE     �   CREATE DATABASE "Progetto_BD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "Progetto_BD";
                postgres    false            ^           1247    17190 
   tipo_prova    TYPE     e   CREATE TYPE public.tipo_prova AS ENUM (
    'scritto',
    'orale',
    'pratico',
    'completo'
);
    DROP TYPE public.tipo_prova;
       public          postgres    false            �            1255    17199    Deny_Delete_Test_Done()    FUNCTION     E  CREATE FUNCTION public."Deny_Delete_Test_Done"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS ( SELECT *
                FROM registrazione_esame re JOIN prova p ON re.idE=p.idE
                WHERE old_table.idP=p.idP))
        THEN INSERT INTO prova(idP,tipo_voto,idE,tipo_prova,nome_prova,idD,data,data_scadenza,ora_prova,percentuale)
        VALUES(old_table.idP,old_table.tipo_voto,old_table.idE,old_table.tipo_prova,old_table.nome_prova,old_table.idD,old_table.data,old_table.data_scadenza,old_table.ora_prova,old_table.percentuale);
    END IF;
END$$;
 0   DROP FUNCTION public."Deny_Delete_Test_Done"();
       public          postgres    false            �            1255    17200    Deny_Delete_Verbalized_Exam()    FUNCTION     }  CREATE FUNCTION public."Deny_Delete_Verbalized_Exam"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS ( SELECT *
                FROM registrazione_esame
                WHERE old_table.idE=idE))
        THEN INSERT INTO esame(idE,nome,anno_accademico,cfu)
        VALUES(old_table.idE,old_table.nome,old_table.anno_accademico,old_table.cfu);
    END IF;
END$$;
 6   DROP FUNCTION public."Deny_Delete_Verbalized_Exam"();
       public          postgres    false            �            1255    17201 !   Deny_Double_Test_Different_Exam()    FUNCTION       CREATE FUNCTION public."Deny_Double_Test_Different_Exam"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS ( SELECT *
                FROM prova p
                WHERE new.idP=p.idP AND new.idE<>p.idE))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 :   DROP FUNCTION public."Deny_Double_Test_Different_Exam"();
       public          postgres    false            �            1255    17202    Deny_Insert_Double_Date_Test()    FUNCTION     $  CREATE FUNCTION public."Deny_Insert_Double_Date_Test"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS ( SELECT *
                FROM prova
                WHERE new.idS=idS AND new.idP<>idP AND new.data=data))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 7   DROP FUNCTION public."Deny_Insert_Double_Date_Test"();
       public          postgres    false            �            1255    17203    Is_Exam_Double()    FUNCTION     �   CREATE FUNCTION public."Is_Exam_Double"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS(SELECT *
                FROM esame e
                WHERE new.nome=e.nome))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 )   DROP FUNCTION public."Is_Exam_Double"();
       public          postgres    false            �            1255    17204    Is_Passed()    FUNCTION     �   CREATE FUNCTION public."Is_Passed"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF FALSE=ANY(SELECT stato_superamento
                 FROM prova p
                 WHERE new.idE==p.idE)
        THEN RETURN NULL;
	END IF;
	RETURN NEW;
END
$$;
 $   DROP FUNCTION public."Is_Passed"();
       public          postgres    false            �            1255    17205    Is_Replaced()    FUNCTION     �  CREATE FUNCTION public."Is_Replaced"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(new.idP IN ( SELECT idP
                    FROM Appelli)
        AND new.idS=( SELECT idS
                      FROM Appelli
                      WHERE idP=new.idP))
        THEN
        UPDATE Appelli
        SET voto=new.voto, stato_superamento=new.stato_superamento
        WHERE idP=new.idP AND idS=new.idS;
    END IF;
    RETURN NEW;
END$$;
 &   DROP FUNCTION public."Is_Replaced"();
       public          postgres    false            �            1255    17206    Is_Test_Double()    FUNCTION       CREATE FUNCTION public."Is_Test_Double"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS(SELECT *
                FROM prova p
                WHERE new.nome_prova=p.nome_prova))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 )   DROP FUNCTION public."Is_Test_Double"();
       public          postgres    false            �            1255    17207 
   Is_Valid()    FUNCTION       CREATE FUNCTION public."Is_Valid"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF( GETDATE()> ANY (SELECT p.data_scadenza   
                        FROM prova p
                        WHERE new.idE==p.idE))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 #   DROP FUNCTION public."Is_Valid"();
       public          postgres    false            �            1255    17208    Passed_First_Test()    FUNCTION       CREATE FUNCTION public."Passed_First_Test"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS ( SELECT *
                FROM Appelli a JOIN prova p ON a.idP=p.idP
                WHERE a.stato_superamento=FALSE AND p.idP=( SELECT p1.idP
                                                            FROM Appelli a1 JOIN prova p1 ON a1.idP=p1.idP
                                                            WHERE p1.idP=p.idP AND p1.date<>p.date AND a1.idS=a.idS)))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 ,   DROP FUNCTION public."Passed_First_Test"();
       public          postgres    false            �            1255    17209    Secure_Only_One()    FUNCTION       CREATE FUNCTION public."Secure_Only_One"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(EXISTS(SELECT *
              FROM Appelli a
              WHERE new.idS=a.idS AND new.idP=a.idP))
        THEN RETURN NULL;
    END IF;
    RETURN NEW;
END$$;
 *   DROP FUNCTION public."Secure_Only_One"();
       public          postgres    false            �            1255    17308    prova_is_Sufficiente()    FUNCTION     U  CREATE FUNCTION public."prova_is_Sufficiente"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF EXISTS (
		SELECT p.idP
		FROM Appelli a
		JOIN prova p ON a.idP = p.idP
		WHERE a.voto >= p.sufficienza AND a.idP = NEW.idP
	) THEN
		NEW.stato_superamento := TRUE;
	ELSE
		NEW.stato_superamento := FALSE;
	END IF;

	RETURN NEW;
END;$$;
 /   DROP FUNCTION public."prova_is_Sufficiente"();
       public          postgres    false            �            1255    17313    save_history_esame()    FUNCTION     �  CREATE FUNCTION public.save_history_esame() RETURNS trigger
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
       public          postgres    false            �            1255    17311    save_history_prove()    FUNCTION     6  CREATE FUNCTION public.save_history_prove() RETURNS trigger
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
       public          postgres    false            �            1259    17210    Appelli    TABLE     �   CREATE TABLE public."Appelli" (
    "idS" integer NOT NULL,
    voto double precision,
    stato_superamento boolean,
    "idP" character varying(100) NOT NULL
);
    DROP TABLE public."Appelli";
       public         heap    postgres    false            �            1259    17213    Appelli_audit    TABLE     �   CREATE TABLE public."Appelli_audit" (
    "idP" character varying(100) NOT NULL,
    "idS" integer NOT NULL,
    voto double precision,
    stato_superamento boolean
);
 #   DROP TABLE public."Appelli_audit";
       public         heap    postgres    false            �            1259    17216    Creazione_esame    TABLE     �   CREATE TABLE public."Creazione_esame" (
    "idD" character(200) NOT NULL,
    "idE" character varying(100) NOT NULL,
    ruolo_docente character varying
);
 %   DROP TABLE public."Creazione_esame";
       public         heap    postgres    false            �            1259    17221    alembic_version    TABLE     X   CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);
 #   DROP TABLE public.alembic_version;
       public         heap    postgres    false            �            1259    17224    creazione_esame_audit    TABLE     �   CREATE TABLE public.creazione_esame_audit (
    "idD" character varying(200),
    "idE" character varying(100),
    ruolo_docente character varying(100)
);
 )   DROP TABLE public.creazione_esame_audit;
       public         heap    postgres    false            �            1259    17227    docente    TABLE     �   CREATE TABLE public.docente (
    "idD" character(200) NOT NULL,
    nome character varying(100),
    cognome character varying(100),
    email character varying(100),
    password character varying(200)
);
    DROP TABLE public.docente;
       public         heap    postgres    false            �            1259    17232    esame    TABLE     �   CREATE TABLE public.esame (
    "idE" character varying(100) NOT NULL,
    nome character varying(100),
    anno_accademico character varying(100),
    cfu integer
);
    DROP TABLE public.esame;
       public         heap    postgres    false            �            1259    17235    esame_audit    TABLE     �   CREATE TABLE public.esame_audit (
    "idD" character varying(200),
    nome character varying(100),
    anno_accademico character varying(100),
    cfu integer
);
    DROP TABLE public.esame_audit;
       public         heap    postgres    false            �            1259    17238    prova    TABLE     o  CREATE TABLE public.prova (
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
       public         heap    postgres    false            �            1259    17243    prova_audit    TABLE     n  CREATE TABLE public.prova_audit (
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
       public         heap    postgres    false            �            1259    17248    registrazione_esame    TABLE     �   CREATE TABLE public.registrazione_esame (
    "idS" integer NOT NULL,
    "idE" character varying(100) NOT NULL,
    voto double precision,
    data_superamento date
);
 '   DROP TABLE public.registrazione_esame;
       public         heap    postgres    false            �            1259    17251    studente    TABLE     �   CREATE TABLE public.studente (
    "idS" integer NOT NULL,
    nome character varying(100),
    cognome character varying(100)
);
    DROP TABLE public.studente;
       public         heap    postgres    false            T          0    17210    Appelli 
   TABLE DATA           J   COPY public."Appelli" ("idS", voto, stato_superamento, "idP") FROM stdin;
    public          postgres    false    214   1g       U          0    17213    Appelli_audit 
   TABLE DATA           P   COPY public."Appelli_audit" ("idP", "idS", voto, stato_superamento) FROM stdin;
    public          postgres    false    215   �g       V          0    17216    Creazione_esame 
   TABLE DATA           H   COPY public."Creazione_esame" ("idD", "idE", ruolo_docente) FROM stdin;
    public          postgres    false    216   9h       W          0    17221    alembic_version 
   TABLE DATA           6   COPY public.alembic_version (version_num) FROM stdin;
    public          postgres    false    217   i       X          0    17224    creazione_esame_audit 
   TABLE DATA           L   COPY public.creazione_esame_audit ("idD", "idE", ruolo_docente) FROM stdin;
    public          postgres    false    218   +i       Y          0    17227    docente 
   TABLE DATA           H   COPY public.docente ("idD", nome, cognome, email, password) FROM stdin;
    public          postgres    false    219   Hi       Z          0    17232    esame 
   TABLE DATA           B   COPY public.esame ("idE", nome, anno_accademico, cfu) FROM stdin;
    public          postgres    false    220   7k       [          0    17235    esame_audit 
   TABLE DATA           H   COPY public.esame_audit ("idD", nome, anno_accademico, cfu) FROM stdin;
    public          postgres    false    221   �k       \          0    17238    prova 
   TABLE DATA           �   COPY public.prova ("idP", tipo_voto, "idE", tipo_prova, nome_prova, "idD", data, data_scadenza, ora_prova, peso, sufficienza) FROM stdin;
    public          postgres    false    222   �k       ]          0    17243    prova_audit 
   TABLE DATA           �   COPY public.prova_audit ("idP", tipo_voto, "idE", tipo_prova, nome_prova, "idD", data, data_scadenza, ora_prova, peso, sufficienza) FROM stdin;
    public          postgres    false    223   �m       ^          0    17248    registrazione_esame 
   TABLE DATA           S   COPY public.registrazione_esame ("idS", "idE", voto, data_superamento) FROM stdin;
    public          postgres    false    224   �m       _          0    17251    studente 
   TABLE DATA           8   COPY public.studente ("idS", nome, cognome) FROM stdin;
    public          postgres    false    225   3n       �           2606    17255    Appelli Appelli_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."Appelli"
    ADD CONSTRAINT "Appelli_pkey" PRIMARY KEY ("idP", "idS");
 B   ALTER TABLE ONLY public."Appelli" DROP CONSTRAINT "Appelli_pkey";
       public            postgres    false    214    214            �           2606    17257 #   alembic_version alembic_version_pkc 
   CONSTRAINT     j   ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);
 M   ALTER TABLE ONLY public.alembic_version DROP CONSTRAINT alembic_version_pkc;
       public            postgres    false    217            �           2606    17259 $   Creazione_esame creazione_esame_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_pkey PRIMARY KEY ("idD", "idE");
 P   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_pkey;
       public            postgres    false    216    216            �           2606    17261    docente docente_email_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.docente
    ADD CONSTRAINT docente_email_key UNIQUE (email);
 C   ALTER TABLE ONLY public.docente DROP CONSTRAINT docente_email_key;
       public            postgres    false    219            �           2606    17263    docente docente_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.docente
    ADD CONSTRAINT docente_pkey PRIMARY KEY ("idD");
 >   ALTER TABLE ONLY public.docente DROP CONSTRAINT docente_pkey;
       public            postgres    false    219            �           2606    17265    esame esame_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.esame
    ADD CONSTRAINT esame_pkey PRIMARY KEY ("idE");
 :   ALTER TABLE ONLY public.esame DROP CONSTRAINT esame_pkey;
       public            postgres    false    220            �           2606    17267    prova prova_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.prova
    ADD CONSTRAINT prova_pkey PRIMARY KEY ("idP");
 :   ALTER TABLE ONLY public.prova DROP CONSTRAINT prova_pkey;
       public            postgres    false    222            �           2606    17269 ,   registrazione_esame registrazione_esame_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_pkey PRIMARY KEY ("idS", "idE");
 V   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_pkey;
       public            postgres    false    224    224            �           2606    17271    studente studente_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT studente_pkey PRIMARY KEY ("idS");
 @   ALTER TABLE ONLY public.studente DROP CONSTRAINT studente_pkey;
       public            postgres    false    225            �           2620    17272    prova Delete_Test_Done    TRIGGER     �   CREATE TRIGGER "Delete_Test_Done" AFTER DELETE ON public.prova REFERENCING OLD TABLE AS old_table FOR EACH STATEMENT EXECUTE FUNCTION public."Deny_Delete_Test_Done"();
 1   DROP TRIGGER "Delete_Test_Done" ON public.prova;
       public          postgres    false    226    222            �           2620    17273    esame Delete_Verbalized_Exam    TRIGGER     �   CREATE TRIGGER "Delete_Verbalized_Exam" AFTER DELETE ON public.esame FOR EACH STATEMENT EXECUTE FUNCTION public."Deny_Delete_Verbalized_Exam"();
 7   DROP TRIGGER "Delete_Verbalized_Exam" ON public.esame;
       public          postgres    false    220    227            �           2620    17274    prova Double_Date_Test    TRIGGER     �   CREATE TRIGGER "Double_Date_Test" BEFORE INSERT ON public.prova FOR EACH ROW EXECUTE FUNCTION public."Deny_Insert_Double_Date_Test"();
 1   DROP TRIGGER "Double_Date_Test" ON public.prova;
       public          postgres    false    229    222            �           2620    17275    esame Double_Exam_Name    TRIGGER     �   CREATE TRIGGER "Double_Exam_Name" BEFORE INSERT OR UPDATE ON public.esame FOR EACH ROW EXECUTE FUNCTION public."Is_Exam_Double"();
 1   DROP TRIGGER "Double_Exam_Name" ON public.esame;
       public          postgres    false    230    220            �           2620    17276     prova Double_Test_Different_Exam    TRIGGER     �   CREATE TRIGGER "Double_Test_Different_Exam" BEFORE INSERT OR UPDATE ON public.prova FOR EACH ROW EXECUTE FUNCTION public."Deny_Double_Test_Different_Exam"();
 ;   DROP TRIGGER "Double_Test_Different_Exam" ON public.prova;
       public          postgres    false    228    222            �           2620    17277    prova Double_Test_Name    TRIGGER     �   CREATE TRIGGER "Double_Test_Name" BEFORE INSERT OR UPDATE ON public.prova FOR EACH ROW EXECUTE FUNCTION public."Is_Test_Double"();
 1   DROP TRIGGER "Double_Test_Name" ON public.prova;
       public          postgres    false    233    222            �           2620    17278    Appelli First_Test    TRIGGER     �   CREATE TRIGGER "First_Test" BEFORE INSERT OR UPDATE ON public."Appelli" FOR EACH ROW EXECUTE FUNCTION public."Passed_First_Test"();
 /   DROP TRIGGER "First_Test" ON public."Appelli";
       public          postgres    false    235    214            �           2620    17279    Appelli Only_One    TRIGGER     v   CREATE TRIGGER "Only_One" BEFORE INSERT ON public."Appelli" FOR EACH ROW EXECUTE FUNCTION public."Secure_Only_One"();
 -   DROP TRIGGER "Only_One" ON public."Appelli";
       public          postgres    false    236    214            �           2620    17280    registrazione_esame Passed    TRIGGER     x   CREATE TRIGGER "Passed" BEFORE INSERT ON public.registrazione_esame FOR EACH ROW EXECUTE FUNCTION public."Is_Passed"();
 5   DROP TRIGGER "Passed" ON public.registrazione_esame;
       public          postgres    false    231    224            �           2620    17281    Appelli Sostitution    TRIGGER     �   CREATE TRIGGER "Sostitution" AFTER INSERT OR UPDATE ON public."Appelli" FOR EACH STATEMENT EXECUTE FUNCTION public."Is_Replaced"();
 0   DROP TRIGGER "Sostitution" ON public."Appelli";
       public          postgres    false    232    214            �           2620    17310    Appelli Sufficiente    TRIGGER     �   CREATE TRIGGER "Sufficiente" BEFORE INSERT OR UPDATE OF stato_superamento ON public."Appelli" FOR EACH ROW EXECUTE FUNCTION public."prova_is_Sufficiente"();
 0   DROP TRIGGER "Sufficiente" ON public."Appelli";
       public          postgres    false    237    214    214            �           2620    17282    registrazione_esame Valid    TRIGGER     v   CREATE TRIGGER "Valid" BEFORE INSERT ON public.registrazione_esame FOR EACH ROW EXECUTE FUNCTION public."Is_Valid"();
 4   DROP TRIGGER "Valid" ON public.registrazione_esame;
       public          postgres    false    224    234            �           2620    17312    prova save_history    TRIGGER     �   CREATE TRIGGER save_history BEFORE UPDATE OF "idP", tipo_voto, "idE", tipo_prova, nome_prova, "idD", data, data_scadenza, ora_prova, peso, sufficienza ON public.prova FOR EACH ROW EXECUTE FUNCTION public.save_history_prove();
 +   DROP TRIGGER save_history ON public.prova;
       public          postgres    false    222    238    222    222    222    222    222    222    222    222    222    222    222            �           2620    17314    esame save_history_esami    TRIGGER     �   CREATE TRIGGER save_history_esami BEFORE UPDATE OF "idE", nome, anno_accademico, cfu ON public.esame FOR EACH ROW EXECUTE FUNCTION public.save_history_esame();
 1   DROP TRIGGER save_history_esami ON public.esame;
       public          postgres    false    220    220    220    220    250    220            �           2606    17283    Appelli Appelli_idP_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public."Appelli"
    ADD CONSTRAINT "Appelli_idP_fkey" FOREIGN KEY ("idP") REFERENCES public.prova("idP");
 F   ALTER TABLE ONLY public."Appelli" DROP CONSTRAINT "Appelli_idP_fkey";
       public          postgres    false    3246    214    222            �           2606    17288 (   Creazione_esame creazione_esame_idd_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_idd_fkey FOREIGN KEY ("idD") REFERENCES public.docente("idD");
 T   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_idd_fkey;
       public          postgres    false    216    219    3242            �           2606    17293 (   Creazione_esame creazione_esame_ide_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_ide_fkey FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 T   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_ide_fkey;
       public          postgres    false    3244    216    220            �           2606    17298 0   registrazione_esame registrazione_esame_ide_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_ide_fkey FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 Z   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_ide_fkey;
       public          postgres    false    224    3244    220            �           2606    17303 0   registrazione_esame registrazione_esame_ids_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_ids_fkey FOREIGN KEY ("idS") REFERENCES public.studente("idS");
 Z   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_ids_fkey;
       public          postgres    false    3250    225    224            T   `   x���0326�42�,�t�5000Sp���q�粀JZ I����@$�ML8-�$�`�FHaSFY���8���jH�.4%F��� %0$�      U   �   x�u�;�0��9E/P�G�x�*P����p�JhiIW����Gġ�f��Rx�X�1]�e,	,x2x.��tKI�ܾ�\]��3�M�X|�p۹"���A����v��+�`�hM6���~����s��{R�      V   �   x�ݒ=��1kr
.`�Ďc��+mAI�G� $��bX}%�9�<͓�9��0�Q�9�\�-z�����QV����n��Z�fp�mB㜀*��.u��n�WxN��c���|O1@*�L�����$	)�j�P�`o�(Y|��+�o{4c�-�5��"	�;�2��Ӆ�S�!��^6�oBw�v��      W      x�K1N40L32MN5O����� .�;      X      x������ � �      Y   �  x�Ք�N[A���>E����w̪�J��P+B����x�.!$!�<Mߥ/�D���q6���ͧ#SV�L�pa6!��$��a|`�A-�{�&�ldY��}�ZE��t��~�����Ӄqۭ�U��p�Sҡ#h���K������C�ӛ����D� �ȃ�D�Y�\��c-�9A)�ar��2El�&t��J&�yxmx/Q�m�U�7ݱL�k@�M��>Cuq���-/?����0��*E���:h�ɦ�1�((G�Z�ƨ)W@�BE�;��=���DO��hb�llg�z�ؾ6����"��tӝ�4����y���a��t�����3"�Ě���UQ�8!2q��sD I�Y��@csitV1��nw��Ė�TOF���Օf%�o����v�Gu.�q��ݾ<�3�������tqrzry?�IF�g3@t�Z�� C���=_UΑs���)�o���8���0+&�      Z   \   x�s1000�tr�Tp"�ON###} a�ih���k`ln����������U����������'�PWS͸b���� �O      [      x������ � �      \   �  x�ݖ�n�@F���nu��;JP�d��,�n ��֖l��;`ˍ�&�(��fut��I+�&��/��&jvۗKÐ�����xܱ��IT����N��y2Ϙt� �X� H�Z��k�y-��>�b� 4 ���~�#��B�fi(��x�����a�k����*K��^a��l�n��$
��-������>�[ֈ��3��Ey�&2'D��S?�&�zENpk�@ڵ��N!	���lr@�%\21ʞTp��,R������;:�����.��}J��b�U�;V}MVy����/�'&U0��~�*j��=Ku�)�[S7�|J��Htv�(�^�TO�T׬���̫EeѪ*���̦�N�o�t}e�hX�`�cV��n_���qO˶���*�N��\M�TD��׭���|4�����N���G��B�+�HEb�NX���Ͻ!ԘbD�R}*�y��]W%?��:ݯ���_"&yi�_f��oPZ�      ]      x������ � �      ^   C   x�]˱�@�z��8^�m�����LF��J��6g�$<h^F��p0�x��ѿY����CUL��      _   �   x����0E�ׯ����vv�����@\�/�D^P�^H�t�ɍ������'�@�L��*j���c�0���XY�ż��:e�NC�ԥWb]gY��q}v~;�_�
��Gl�E��qx�r�_��,��U��h���,�     