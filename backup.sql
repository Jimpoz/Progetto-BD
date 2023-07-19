PGDMP         ,                 {           Progetto_BD    15.1    15.1 (    7           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            8           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            9           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            :           1262    16398    Progetto_BD    DATABASE     �   CREATE DATABASE "Progetto_BD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "Progetto_BD";
                postgres    false            �            1259    16530    Appelli    TABLE     �   CREATE TABLE public."Appelli" (
    "idS" integer NOT NULL,
    voto integer,
    stato_superamento boolean,
    "idP" character varying(100)
);
    DROP TABLE public."Appelli";
       public         heap    postgres    false            �            1259    16440    _alembic_tmp_Appelli    TABLE     �   CREATE TABLE public."_alembic_tmp_Appelli" (
    "idS" integer NOT NULL,
    "idE" character varying(100) NOT NULL,
    voto integer,
    stato_superamento boolean
);
 *   DROP TABLE public."_alembic_tmp_Appelli";
       public         heap    postgres    false            �            1259    16409    alembic_version    TABLE     X   CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);
 #   DROP TABLE public.alembic_version;
       public         heap    postgres    false            �            1259    16491    creazione_esame    TABLE     �   CREATE TABLE public.creazione_esame (
    "idD" character varying(100) NOT NULL,
    "idE" character varying(100) NOT NULL,
    ruolo_docente character varying(100)
);
 #   DROP TABLE public.creazione_esame;
       public         heap    postgres    false            �            1259    16414    docente    TABLE     �   CREATE TABLE public.docente (
    "idD" character varying(100) NOT NULL,
    nome character varying(100),
    cognome character varying(100),
    email character varying(100),
    password character varying(200)
);
    DROP TABLE public.docente;
       public         heap    postgres    false            �            1259    16430    esame    TABLE     �   CREATE TABLE public.esame (
    "idE" character varying(100) NOT NULL,
    nome character varying(100),
    anno_accademico character varying(100),
    cfu integer
);
    DROP TABLE public.esame;
       public         heap    postgres    false            �            1259    16513    prova    TABLE     e  CREATE TABLE public.prova (
    "idP" character varying(100) NOT NULL,
    tipo_voto character varying(100),
    "idE" character varying(100),
    tipo_prova character varying(8),
    nome_prova character varying(100),
    "idD" character varying(100),
    data date,
    data_scadenza date,
    ora_prova character varying(100),
    percentuale integer
);
    DROP TABLE public.prova;
       public         heap    postgres    false            �            1259    16476    registrazione_esame    TABLE     �   CREATE TABLE public.registrazione_esame (
    "idS" integer NOT NULL,
    "idE" character varying(100) NOT NULL,
    voto integer,
    data_superamento date
);
 '   DROP TABLE public.registrazione_esame;
       public         heap    postgres    false            �            1259    16435    studente    TABLE     �   CREATE TABLE public.studente (
    "idS" integer NOT NULL,
    nome character varying(100),
    cognome character varying(100)
);
    DROP TABLE public.studente;
       public         heap    postgres    false            4          0    16530    Appelli 
   TABLE DATA           J   COPY public."Appelli" ("idS", voto, stato_superamento, "idP") FROM stdin;
    public          postgres    false    222   B1       0          0    16440    _alembic_tmp_Appelli 
   TABLE DATA           W   COPY public."_alembic_tmp_Appelli" ("idS", "idE", voto, stato_superamento) FROM stdin;
    public          postgres    false    218   _1       ,          0    16409    alembic_version 
   TABLE DATA           6   COPY public.alembic_version (version_num) FROM stdin;
    public          postgres    false    214   |1       2          0    16491    creazione_esame 
   TABLE DATA           F   COPY public.creazione_esame ("idD", "idE", ruolo_docente) FROM stdin;
    public          postgres    false    220   �1       -          0    16414    docente 
   TABLE DATA           H   COPY public.docente ("idD", nome, cognome, email, password) FROM stdin;
    public          postgres    false    215   �1       .          0    16430    esame 
   TABLE DATA           B   COPY public.esame ("idE", nome, anno_accademico, cfu) FROM stdin;
    public          postgres    false    216   z2       3          0    16513    prova 
   TABLE DATA           �   COPY public.prova ("idP", tipo_voto, "idE", tipo_prova, nome_prova, "idD", data, data_scadenza, ora_prova, percentuale) FROM stdin;
    public          postgres    false    221   �2       1          0    16476    registrazione_esame 
   TABLE DATA           S   COPY public.registrazione_esame ("idS", "idE", voto, data_superamento) FROM stdin;
    public          postgres    false    219   �2       /          0    16435    studente 
   TABLE DATA           8   COPY public.studente ("idS", nome, cognome) FROM stdin;
    public          postgres    false    217   �2       �           2606    16413 #   alembic_version alembic_version_pkc 
   CONSTRAINT     j   ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);
 M   ALTER TABLE ONLY public.alembic_version DROP CONSTRAINT alembic_version_pkc;
       public            postgres    false    214            �           2606    16495 $   creazione_esame creazione_esame_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.creazione_esame
    ADD CONSTRAINT creazione_esame_pkey PRIMARY KEY ("idD", "idE");
 N   ALTER TABLE ONLY public.creazione_esame DROP CONSTRAINT creazione_esame_pkey;
       public            postgres    false    220    220            �           2606    16422    docente docente_email_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.docente
    ADD CONSTRAINT docente_email_key UNIQUE (email);
 C   ALTER TABLE ONLY public.docente DROP CONSTRAINT docente_email_key;
       public            postgres    false    215            �           2606    16420    docente docente_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.docente
    ADD CONSTRAINT docente_pkey PRIMARY KEY ("idD");
 >   ALTER TABLE ONLY public.docente DROP CONSTRAINT docente_pkey;
       public            postgres    false    215            �           2606    16434    esame esame_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.esame
    ADD CONSTRAINT esame_pkey PRIMARY KEY ("idE");
 :   ALTER TABLE ONLY public.esame DROP CONSTRAINT esame_pkey;
       public            postgres    false    216            �           2606    16519    prova prova_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.prova
    ADD CONSTRAINT prova_pkey PRIMARY KEY ("idP");
 :   ALTER TABLE ONLY public.prova DROP CONSTRAINT prova_pkey;
       public            postgres    false    221            �           2606    16480 ,   registrazione_esame registrazione_esame_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_pkey PRIMARY KEY ("idS", "idE");
 V   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_pkey;
       public            postgres    false    219    219            �           2606    16439    studente studente_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT studente_pkey PRIMARY KEY ("idS");
 @   ALTER TABLE ONLY public.studente DROP CONSTRAINT studente_pkey;
       public            postgres    false    217            �           2606    16538    Appelli Appelli_idP_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public."Appelli"
    ADD CONSTRAINT "Appelli_idP_fkey" FOREIGN KEY ("idP") REFERENCES public.prova("idP");
 F   ALTER TABLE ONLY public."Appelli" DROP CONSTRAINT "Appelli_idP_fkey";
       public          postgres    false    221    222    3219            �           2606    16533    Appelli Appelli_idS_fkey    FK CONSTRAINT        ALTER TABLE ONLY public."Appelli"
    ADD CONSTRAINT "Appelli_idS_fkey" FOREIGN KEY ("idS") REFERENCES public.studente("idS");
 F   ALTER TABLE ONLY public."Appelli" DROP CONSTRAINT "Appelli_idS_fkey";
       public          postgres    false    217    222    3213            �           2606    16496 (   creazione_esame creazione_esame_idD_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.creazione_esame
    ADD CONSTRAINT "creazione_esame_idD_fkey" FOREIGN KEY ("idD") REFERENCES public.docente("idD");
 T   ALTER TABLE ONLY public.creazione_esame DROP CONSTRAINT "creazione_esame_idD_fkey";
       public          postgres    false    215    3209    220            �           2606    16501 (   creazione_esame creazione_esame_idE_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.creazione_esame
    ADD CONSTRAINT "creazione_esame_idE_fkey" FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 T   ALTER TABLE ONLY public.creazione_esame DROP CONSTRAINT "creazione_esame_idE_fkey";
       public          postgres    false    216    3211    220            �           2606    16443 )   _alembic_tmp_Appelli fk_appelli_idE_esame    FK CONSTRAINT     �   ALTER TABLE ONLY public."_alembic_tmp_Appelli"
    ADD CONSTRAINT "fk_appelli_idE_esame" FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 W   ALTER TABLE ONLY public."_alembic_tmp_Appelli" DROP CONSTRAINT "fk_appelli_idE_esame";
       public          postgres    false    3211    218    216            �           2606    16448 ,   _alembic_tmp_Appelli fk_appelli_idS_studente    FK CONSTRAINT     �   ALTER TABLE ONLY public."_alembic_tmp_Appelli"
    ADD CONSTRAINT "fk_appelli_idS_studente" FOREIGN KEY ("idS") REFERENCES public.studente("idS");
 Z   ALTER TABLE ONLY public."_alembic_tmp_Appelli" DROP CONSTRAINT "fk_appelli_idS_studente";
       public          postgres    false    218    217    3213            �           2606    16520    prova prova_idD_fkey    FK CONSTRAINT     x   ALTER TABLE ONLY public.prova
    ADD CONSTRAINT "prova_idD_fkey" FOREIGN KEY ("idD") REFERENCES public.docente("idD");
 @   ALTER TABLE ONLY public.prova DROP CONSTRAINT "prova_idD_fkey";
       public          postgres    false    215    221    3209            �           2606    16525    prova prova_idE_fkey    FK CONSTRAINT     v   ALTER TABLE ONLY public.prova
    ADD CONSTRAINT "prova_idE_fkey" FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 @   ALTER TABLE ONLY public.prova DROP CONSTRAINT "prova_idE_fkey";
       public          postgres    false    221    216    3211            �           2606    16481 0   registrazione_esame registrazione_esame_idE_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT "registrazione_esame_idE_fkey" FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 \   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT "registrazione_esame_idE_fkey";
       public          postgres    false    219    3211    216            �           2606    16486 0   registrazione_esame registrazione_esame_idS_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT "registrazione_esame_idS_fkey" FOREIGN KEY ("idS") REFERENCES public.studente("idS");
 \   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT "registrazione_esame_idS_fkey";
       public          postgres    false    3213    217    219            4      x������ � �      0      x������ � �      ,      x�3IIMII25L113����� 1nC      2      x������ � �      -   �   x�%�;�@D��i%��ݤ�� :D��X P@��u�c%FS�ỳq]G���[(�ٔb][v����u�6�_�8���DU������G�M����3��KP�Ǔ q\���p[V��������ƨ�TjD(�8/M@o�S�F;�J0��=G��iA~��<�2�6)      .   +   x�s1000�tr�Tp"�ON###} a�ih����� ��X      3      x������ � �      1      x������ � �      /   �   x��1�0��+x��Ʈ)��H��"�YNVr9�$���$H[��l�Py����a1���譭�����Z�e�ֆ`�M���L2g�Ƨc�֓���PSx����V��('�f:��yY�Z􎮢�=u�7��1�7,�     