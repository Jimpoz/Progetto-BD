PGDMP         (                {           Progetto_BD    15.1    15.1                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16398    Progetto_BD    DATABASE     �   CREATE DATABASE "Progetto_BD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "Progetto_BD";
                postgres    false            �            1259    16440    _alembic_tmp_Appelli    TABLE     �   CREATE TABLE public."_alembic_tmp_Appelli" (
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
       public         heap    postgres    false            �            1259    16414    docente    TABLE     �   CREATE TABLE public.docente (
    "idD" character varying(100) NOT NULL,
    nome character varying(100),
    cognome character varying(100),
    email character varying(100),
    password character varying(100)
);
    DROP TABLE public.docente;
       public         heap    postgres    false            �            1259    16430    esame    TABLE     �   CREATE TABLE public.esame (
    "idE" character varying(100) NOT NULL,
    nome character varying(100),
    anno_accademico character varying(100),
    cfu integer
);
    DROP TABLE public.esame;
       public         heap    postgres    false            �            1259    16435    studente    TABLE     �   CREATE TABLE public.studente (
    "idS" integer NOT NULL,
    nome character varying(100),
    cognome character varying(100)
);
    DROP TABLE public.studente;
       public         heap    postgres    false                      0    16440    _alembic_tmp_Appelli 
   TABLE DATA           W   COPY public."_alembic_tmp_Appelli" ("idS", "idE", voto, stato_superamento) FROM stdin;
    public          postgres    false    218   3                 0    16409    alembic_version 
   TABLE DATA           6   COPY public.alembic_version (version_num) FROM stdin;
    public          postgres    false    214   P                 0    16414    docente 
   TABLE DATA           H   COPY public.docente ("idD", nome, cognome, email, password) FROM stdin;
    public          postgres    false    215   z                 0    16430    esame 
   TABLE DATA           B   COPY public.esame ("idE", nome, anno_accademico, cfu) FROM stdin;
    public          postgres    false    216   �                 0    16435    studente 
   TABLE DATA           8   COPY public.studente ("idS", nome, cognome) FROM stdin;
    public          postgres    false    217   �       u           2606    16413 #   alembic_version alembic_version_pkc 
   CONSTRAINT     j   ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);
 M   ALTER TABLE ONLY public.alembic_version DROP CONSTRAINT alembic_version_pkc;
       public            postgres    false    214            w           2606    16422    docente docente_email_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.docente
    ADD CONSTRAINT docente_email_key UNIQUE (email);
 C   ALTER TABLE ONLY public.docente DROP CONSTRAINT docente_email_key;
       public            postgres    false    215            y           2606    16420    docente docente_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.docente
    ADD CONSTRAINT docente_pkey PRIMARY KEY ("idD");
 >   ALTER TABLE ONLY public.docente DROP CONSTRAINT docente_pkey;
       public            postgres    false    215            {           2606    16434    esame esame_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.esame
    ADD CONSTRAINT esame_pkey PRIMARY KEY ("idE");
 :   ALTER TABLE ONLY public.esame DROP CONSTRAINT esame_pkey;
       public            postgres    false    216            }           2606    16439    studente studente_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT studente_pkey PRIMARY KEY ("idS");
 @   ALTER TABLE ONLY public.studente DROP CONSTRAINT studente_pkey;
       public            postgres    false    217            ~           2606    16443 )   _alembic_tmp_Appelli fk_appelli_idE_esame    FK CONSTRAINT     �   ALTER TABLE ONLY public."_alembic_tmp_Appelli"
    ADD CONSTRAINT "fk_appelli_idE_esame" FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 W   ALTER TABLE ONLY public."_alembic_tmp_Appelli" DROP CONSTRAINT "fk_appelli_idE_esame";
       public          postgres    false    216    218    3195                       2606    16448 ,   _alembic_tmp_Appelli fk_appelli_idS_studente    FK CONSTRAINT     �   ALTER TABLE ONLY public."_alembic_tmp_Appelli"
    ADD CONSTRAINT "fk_appelli_idS_studente" FOREIGN KEY ("idS") REFERENCES public.studente("idS");
 Z   ALTER TABLE ONLY public."_alembic_tmp_Appelli" DROP CONSTRAINT "fk_appelli_idS_studente";
       public          postgres    false    218    217    3197                  x������ � �            x�3IIMII25L113����� 1nC            x������ � �         J   x�s�5000�tr�Tp"�ON###} a�ih��Taln����������E}� Jj�         �   x��1�0��+x��Ʈ)��H��"�YNVr9�$���$H[��l�Py����a1���譭�����Z�e�ֆ`�M���L2g�Ƨc�֓���PSx����V��('�f:��yY�Z􎮢�=u�7��1�7,�     