PGDMP     )    %                {           Progetto_BD    15.1    15.1 #    2           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    voto double precision,
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
    public          postgres    false    217   *       /          0    17085    alembic_version 
   TABLE DATA           6   COPY public.alembic_version (version_num) FROM stdin;
    public          postgres    false    221   �*       (          0    16992    docente 
   TABLE DATA           H   COPY public.docente ("idD", nome, cognome, email, password) FROM stdin;
    public          postgres    false    214   �*       *          0    17006    esame 
   TABLE DATA           B   COPY public.esame ("idE", nome, anno_accademico, cfu) FROM stdin;
    public          postgres    false    216   i,       .          0    17067    prova 
   TABLE DATA           �   COPY public.prova ("idP", tipo_voto, "idE", tipo_prova, nome_prova, "idD", data, data_scadenza, ora_prova, percentuale) FROM stdin;
    public          postgres    false    220   �,       ,          0    17043    registrazione_esame 
   TABLE DATA           S   COPY public.registrazione_esame ("idS", "idE", voto, data_superamento) FROM stdin;
    public          postgres    false    218   S.       )          0    17001    studente 
   TABLE DATA           8   COPY public.studente ("idS", nome, cognome) FROM stdin;
    public          postgres    false    215   �.       �           2606    17124    Appelli Appelli_pkey 
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
 	�����@��wwA�b�a \���M�J���rZ`sJ� ��/�      +   �   x�ݑ9�@ ��+���7�z����fG� ���E�2]��4Oф�����)��Ll�Уl~�awDD���ݯ�Z)�&p�u��i*(^���嵵��N���η �s�2/S�Z{CP�)�ji�Sg��hqm�%|�^�N��eՊJ      /      x�K1N40L32MN5O����� .�;      (   ~  x���=nTA���SPl;��Þq��HH��!B4������;�
r���A�t�Ɩe7?���e�+�	�F��G�}`�A-��2�O:ϲ�{>Ik��_?�7�?���a�:���0��mm�t��t�zv�dw�>����v|G���'�*Jt��;k���kR�;���3d����P�HKh�)�`s39�3^�T
I+��^���A�l�ÅL�r��\��Ϩ�~���ͻ��w�����Qb�9PɠQ�D6L	DA91�4%���V��5vvD7���k�<9��II����r�ޱ}m��d� ��Ӵ.uZ��w������1�z��/��]]�D������MQ�8#� �����Hrs�����ط49�Z��������      *   J   x�s1000�tr�Tp"�ON###} a�ih���k`ln����������E}� :�      .   �  x����j�0��~�Yf4�,��a	��IL�^lE�@������R�n�����`챤���@D�Ջ��i��Ev>����ATM��]��*���:>e3�+��vm5g,(���)-�[4���]�<�JH���sK�B��0�'�?��ݦ﷢^�n˄s���׬��f}�������r�]����霕#�@��_�W'i��F2.H�B�T�$�rZ�﮿�r�PI�J x������7�x��]������|=aVH��eq�2Y���%|2^�k\]��iS�pZZ'�!�8W)��f�z2�.J)���*~A��MR%�Iul�yT	k�v+�`�HP��m=�z�B�f���-�#�e�8E:�A����d���u�      ,   =   x�]ɱ� �����&��Y!e���ĵ's��(c�`�`�T=�"�Z=���?�}L�!      )   �   x����0E�ׯ����vv�����@\�/�D^P�^H�t�ɍ������'�@�L��*j���c�0���XY�ż��:e�NC�ԥWb]gY��q}v~;�_�
��Gl�E��qx�r�_��,��U��h���,�     