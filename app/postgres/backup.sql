PGDMP     (    .                {           Progetto_BD    15.1    15.1 #    2           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            3           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            4           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            5           1262    16991    Progetto_BD    DATABASE     �   CREATE DATABASE "Progetto_BD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "Progetto_BD";
                postgres    false            R           1247    17012 
   tipo_prova    TYPE     e   CREATE TYPE public.tipo_prova AS ENUM (
    'scritto',
    'orale',
    'pratico',
    'completo'
);
    DROP TYPE public.tipo_prova;
       public          postgres    false            �            1259    17058    Appelli    TABLE     �   CREATE TABLE public."Appelli" (
    "idS" integer NOT NULL,
    voto integer,
    stato_superamento boolean,
    "idP" character varying(100) NOT NULL
);
    DROP TABLE public."Appelli";
       public         heap    postgres    false            �            1259    17026    Creazione_esame    TABLE     �   CREATE TABLE public."Creazione_esame" (
    "idD" character(200) NOT NULL,
    "idE" character varying(100) NOT NULL,
    ruolo_docente character varying
);
 %   DROP TABLE public."Creazione_esame";
       public         heap    postgres    false            �            1259    17085    alembic_version    TABLE     X   CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);
 #   DROP TABLE public.alembic_version;
       public         heap    postgres    false            �            1259    16992    docente    TABLE     �   CREATE TABLE public.docente (
    "idD" character(200) NOT NULL,
    nome character varying(100),
    cognome character varying(100),
    email character varying(100),
    password character varying(200)
);
    DROP TABLE public.docente;
       public         heap    postgres    false            �            1259    17006    esame    TABLE     �   CREATE TABLE public.esame (
    "idE" character varying(100) NOT NULL,
    nome character varying(100),
    anno_accademico character varying(100),
    cfu integer
);
    DROP TABLE public.esame;
       public         heap    postgres    false            �            1259    17067    prova    TABLE     ]  CREATE TABLE public.prova (
    "idP" character varying(100) NOT NULL,
    tipo_voto character varying(100),
    "idE" character varying(100),
    tipo_prova character varying(8),
    nome_prova character varying(100),
    "idD" character(200),
    data date,
    data_scadenza date,
    ora_prova character varying(100),
    percentuale integer
);
    DROP TABLE public.prova;
       public         heap    postgres    false            �            1259    17043    registrazione_esame    TABLE     �   CREATE TABLE public.registrazione_esame (
    "idS" integer NOT NULL,
    "idE" character varying(100) NOT NULL,
    voto integer,
    data_superamento date
);
 '   DROP TABLE public.registrazione_esame;
       public         heap    postgres    false            �            1259    17001    studente    TABLE     �   CREATE TABLE public.studente (
    "idS" integer NOT NULL,
    nome character varying(100),
    cognome character varying(100)
);
    DROP TABLE public.studente;
       public         heap    postgres    false            -          0    17058    Appelli 
   TABLE DATA           J   COPY public."Appelli" ("idS", voto, stato_superamento, "idP") FROM stdin;
    public          postgres    false    219   �)       +          0    17026    Creazione_esame 
   TABLE DATA           H   COPY public."Creazione_esame" ("idD", "idE", ruolo_docente) FROM stdin;
    public          postgres    false    217   �)       /          0    17085    alembic_version 
   TABLE DATA           6   COPY public.alembic_version (version_num) FROM stdin;
    public          postgres    false    221   �*       (          0    16992    docente 
   TABLE DATA           H   COPY public.docente ("idD", nome, cognome, email, password) FROM stdin;
    public          postgres    false    214   �*       *          0    17006    esame 
   TABLE DATA           B   COPY public.esame ("idE", nome, anno_accademico, cfu) FROM stdin;
    public          postgres    false    216   �+       .          0    17067    prova 
   TABLE DATA           �   COPY public.prova ("idP", tipo_voto, "idE", tipo_prova, nome_prova, "idD", data, data_scadenza, ora_prova, percentuale) FROM stdin;
    public          postgres    false    220   ,       ,          0    17043    registrazione_esame 
   TABLE DATA           S   COPY public.registrazione_esame ("idS", "idE", voto, data_superamento) FROM stdin;
    public          postgres    false    218   O-       )          0    17001    studente 
   TABLE DATA           8   COPY public.studente ("idS", nome, cognome) FROM stdin;
    public          postgres    false    215   �-       �           2606    17124    Appelli Appelli_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."Appelli"
    ADD CONSTRAINT "Appelli_pkey" PRIMARY KEY ("idP", "idS");
 B   ALTER TABLE ONLY public."Appelli" DROP CONSTRAINT "Appelli_pkey";
       public            postgres    false    219    219            �           2606    17089 #   alembic_version alembic_version_pkc 
   CONSTRAINT     j   ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);
 M   ALTER TABLE ONLY public.alembic_version DROP CONSTRAINT alembic_version_pkc;
       public            postgres    false    221            �           2606    17105 $   Creazione_esame creazione_esame_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_pkey PRIMARY KEY ("idD", "idE");
 P   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_pkey;
       public            postgres    false    217    217            �           2606    17000    docente docente_email_key 
   CONSTRAINT     U   ALTER TABLE ONLY public.docente
    ADD CONSTRAINT docente_email_key UNIQUE (email);
 C   ALTER TABLE ONLY public.docente DROP CONSTRAINT docente_email_key;
       public            postgres    false    214            �           2606    17091    docente docente_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.docente
    ADD CONSTRAINT docente_pkey PRIMARY KEY ("idD");
 >   ALTER TABLE ONLY public.docente DROP CONSTRAINT docente_pkey;
       public            postgres    false    214            �           2606    17010    esame esame_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.esame
    ADD CONSTRAINT esame_pkey PRIMARY KEY ("idE");
 :   ALTER TABLE ONLY public.esame DROP CONSTRAINT esame_pkey;
       public            postgres    false    216            �           2606    17075    prova prova_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.prova
    ADD CONSTRAINT prova_pkey PRIMARY KEY ("idP");
 :   ALTER TABLE ONLY public.prova DROP CONSTRAINT prova_pkey;
       public            postgres    false    220            �           2606    17047 ,   registrazione_esame registrazione_esame_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_pkey PRIMARY KEY ("idS", "idE");
 V   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_pkey;
       public            postgres    false    218    218            �           2606    17005    studente studente_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.studente
    ADD CONSTRAINT studente_pkey PRIMARY KEY ("idS");
 @   ALTER TABLE ONLY public.studente DROP CONSTRAINT studente_pkey;
       public            postgres    false    215            �           2606    17076    Appelli Appelli_idP_fkey    FK CONSTRAINT     |   ALTER TABLE ONLY public."Appelli"
    ADD CONSTRAINT "Appelli_idP_fkey" FOREIGN KEY ("idP") REFERENCES public.prova("idP");
 F   ALTER TABLE ONLY public."Appelli" DROP CONSTRAINT "Appelli_idP_fkey";
       public          postgres    false    3218    219    220            �           2606    17106 (   Creazione_esame creazione_esame_idd_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_idd_fkey FOREIGN KEY ("idD") REFERENCES public.docente("idD");
 T   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_idd_fkey;
       public          postgres    false    3206    214    217            �           2606    17038 (   Creazione_esame creazione_esame_ide_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_ide_fkey FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 T   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_ide_fkey;
       public          postgres    false    217    3210    216            �           2606    17053 0   registrazione_esame registrazione_esame_ide_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_ide_fkey FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 Z   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_ide_fkey;
       public          postgres    false    218    216    3210            �           2606    17048 0   registrazione_esame registrazione_esame_ids_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_ids_fkey FOREIGN KEY ("idS") REFERENCES public.studente("idS");
 Z   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_ids_fkey;
       public          postgres    false    218    3208    215            -   f   x���0�05�42�,�t�5000Sp���q�粰0371�4�D�4
 	�����@��wwA�b�a \���M�J���rZ`sJ� ��/�      +   s   x��ϱ1@��<9�q��j$
J�q$
@:�_T�t�7���Q�JF��mT�+j��5e�$�?��g"����:��
`w��
�JCN}b�r�l$a.6��:���c����� �qvE�      /      x�K1N40L32MN5O����� .�;      (     x��лJCA������H�a�6��ʘB�Q"6����'���i|_���v����f��**D��T�`i����L���ܕ=7�\+������s�����[�d�84۴*�L�'6'ah�����l9�H��ތ���`EW�l�{�9Jh������ap�E,%H��`0l]��5z%�Q9��J�eP8#���75w��m��_�4�6}��?�.�/W;�.�7�>,N�����$�9�ɐ"�}��B�|-Nb���*x��E|	���}�m����      *   +   x�s1000�tr�Tp"�ON###} a�ih����� ��X      .   2  x���_K�0 ���S����_��ծHa�e+{_�,��:���7�sE�'q�.�=����D�a�.o�.Y�����������~�.��~�u1�Kk���8�c��v�J�A4�]cu��(��q�0�א82����!�NNT}&t�C?�{V��U:�l����t���;�L[��hfg�xA�DFEB�H���w�ى�Sh =�HH&�L�T�K�M�����e�̩�8p�P$x�3VV��e��<�;��G�wxο0+���D��*��ކO(6?W�e��S(�p�%JMZ~b�_A�Pd       ,   )   x���0�05�t1000�42�4202�54�50����� i��      )   �   x����0E�ׯ����vv�����@\�/�D^P�^H�t�ɍ������'�@�L��*j���c�0���XY�ż��:e�NC�ԥWb]gY��q}v~;�_�
��Gl�E��qx�r�_��,��U��h���,�     