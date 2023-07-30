PGDMP     ,                    {           Progetto_BD    15.1    15.1 &    9           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            :           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            ;           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            <           1262    16991    Progetto_BD    DATABASE     �   CREATE DATABASE "Progetto_BD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "Progetto_BD";
                postgres    false            S           1247    17012 
   tipo_prova    TYPE     e   CREATE TYPE public.tipo_prova AS ENUM (
    'scritto',
    'orale',
    'pratico',
    'completo'
);
    DROP TYPE public.tipo_prova;
       public          postgres    false            �            1259    17058    Appelli    TABLE     �   CREATE TABLE public."Appelli" (
    "idS" integer NOT NULL,
    voto double precision,
    stato_superamento boolean,
    "idP" character varying(100) NOT NULL
);
    DROP TABLE public."Appelli";
       public         heap    postgres    false            �            1259    17142    Appelli_audit    TABLE     �   CREATE TABLE public."Appelli_audit" (
    "idP" character varying(100) NOT NULL,
    "idS" integer NOT NULL,
    voto double precision,
    stato_superamento boolean
);
 #   DROP TABLE public."Appelli_audit";
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
       public         heap    postgres    false            �            1259    17067    prova    TABLE     o  CREATE TABLE public.prova (
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
       public         heap    postgres    false            3          0    17058    Appelli 
   TABLE DATA           J   COPY public."Appelli" ("idS", voto, stato_superamento, "idP") FROM stdin;
    public          postgres    false    219   O-       6          0    17142    Appelli_audit 
   TABLE DATA           P   COPY public."Appelli_audit" ("idP", "idS", voto, stato_superamento) FROM stdin;
    public          postgres    false    222   �-       1          0    17026    Creazione_esame 
   TABLE DATA           H   COPY public."Creazione_esame" ("idD", "idE", ruolo_docente) FROM stdin;
    public          postgres    false    217   J.       5          0    17085    alembic_version 
   TABLE DATA           6   COPY public.alembic_version (version_num) FROM stdin;
    public          postgres    false    221   /       .          0    16992    docente 
   TABLE DATA           H   COPY public.docente ("idD", nome, cognome, email, password) FROM stdin;
    public          postgres    false    214   </       0          0    17006    esame 
   TABLE DATA           B   COPY public.esame ("idE", nome, anno_accademico, cfu) FROM stdin;
    public          postgres    false    216   +1       4          0    17067    prova 
   TABLE DATA           �   COPY public.prova ("idP", tipo_voto, "idE", tipo_prova, nome_prova, "idD", data, data_scadenza, ora_prova, peso, sufficienza) FROM stdin;
    public          postgres    false    220   �1       2          0    17043    registrazione_esame 
   TABLE DATA           S   COPY public.registrazione_esame ("idS", "idE", voto, data_superamento) FROM stdin;
    public          postgres    false    218   v3       /          0    17001    studente 
   TABLE DATA           8   COPY public.studente ("idS", nome, cognome) FROM stdin;
    public          postgres    false    215   �3       �           2606    17124    Appelli Appelli_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public."Appelli"
    ADD CONSTRAINT "Appelli_pkey" PRIMARY KEY ("idP", "idS");
 B   ALTER TABLE ONLY public."Appelli" DROP CONSTRAINT "Appelli_pkey";
       public            postgres    false    219    219            �           2606    17089 #   alembic_version alembic_version_pkc 
   CONSTRAINT     j   ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);
 M   ALTER TABLE ONLY public.alembic_version DROP CONSTRAINT alembic_version_pkc;
       public            postgres    false    221            �           2606    17146     Appelli_audit appelli_audit_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public."Appelli_audit"
    ADD CONSTRAINT appelli_audit_pkey PRIMARY KEY ("idP", "idS");
 L   ALTER TABLE ONLY public."Appelli_audit" DROP CONSTRAINT appelli_audit_pkey;
       public            postgres    false    222    222            �           2606    17105 $   Creazione_esame creazione_esame_pkey 
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
       public          postgres    false    220    219    3222            �           2606    17106 (   Creazione_esame creazione_esame_idd_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_idd_fkey FOREIGN KEY ("idD") REFERENCES public.docente("idD");
 T   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_idd_fkey;
       public          postgres    false    214    217    3210            �           2606    17038 (   Creazione_esame creazione_esame_ide_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_ide_fkey FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 T   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_ide_fkey;
       public          postgres    false    3214    216    217            �           2606    17053 0   registrazione_esame registrazione_esame_ide_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_ide_fkey FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 Z   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_ide_fkey;
       public          postgres    false    3214    218    216            �           2606    17048 0   registrazione_esame registrazione_esame_ids_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_ids_fkey FOREIGN KEY ("idS") REFERENCES public.studente("idS");
 Z   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_ids_fkey;
       public          postgres    false    218    215    3212            3   _   x���0326�42�,�t�5000Sp���q�粀JZ I����@$�ML8-�$�`�FHaS�F���r�`w�$L��q0W� V�)�      6   |   x�s�5000S0ര0�05�44�L�r�
;������sZ���rZp��%���]CB���a�FFPycs�F��4[�s�"�#4�I���4®�!#,��%M�	
�oc���� �&?@      1   �   x�ݒ=��1kr
.`�Ďc��+mAI�G� $��bX}%�9�<͓�9��0�Q�9�\�-z�����QV����n��Z�fp�mB㜀*��.u��n�WxN��c���|O1@*�L�����$	)�j�P�`o�(Y|��+�o{4c�-�5��"	�;�2��Ӆ�S�!��^6�oBw�v��      5      x�K1N40L32MN5O����� .�;      .   �  x�Ք�N[A���>E����w̪�J��P+B����x�.!$!�<Mߥ/�D���q6���ͧ#SV�L�pa6!��$��a|`�A-�{�&�ldY��}�ZE��t��~�����Ӄqۭ�U��p�Sҡ#h���K������C�ӛ����D� �ȃ�D�Y�\��c-�9A)�ar��2El�&t��J&�yxmx/Q�m�U�7ݱL�k@�M��>Cuq���-/?����0��*E���:h�ɦ�1�((G�Z�ƨ)W@�BE�;��=���DO��hb�llg�z�ؾ6����"��tӝ�4����y���a��t�����3"�Ě���UQ�8!2q��sD I�Y��@csitV1��nw��Ė�TOF���Օf%�o����v�Gu.�q��ݾ<�3�������tqrzry?�IF�g3@t�Z�� C���=_UΑs���)�o���8���0+&�      0   \   x�s1000�tr�Tp"�ON###} a�ih���k`ln����������U����������'�PWS͸b���� �O      4   �  x�ݖ�j�@�ף���rΜ�z�:"���J�]F`hp��td�J�7]�hb8�F����5 [�ʝ����)<���2O��p:=�}�.?�e�*?�wV})�M.�!���c#A!kp����^�v`���w��Dɀ��*~< 	�+D�Q�MF"��/N��_�L4y��{�A��B؂ז�'�@��f=c�@��%	R	���GRn"�.��M^�7x}��Ez��.^�/Wd$'r����r���t�����.:W�sD�-H+��)]՜U��/���i���ꡮ�|�� ��E���XF�2��>�����|�:N�U�5��4o(jh�����t�:��^�&�_R� QDui�H���OX��կ1jL���c+��t�L�W�����8>�W�~�*;Rڇ��M����mL�7L^zp���=6д�E;��C0�&�ISҟ��8>��!I�����      2   =   x�Uɱ�@�z���@�m����0�wӝN���p	m�Δ;��S��Ϟ�R��{      /   �   x����0E�ׯ����vv�����@\�/�D^P�^H�t�ɍ������'�@�L��*j���c�0���XY�ż��:e�NC�ԥWb]gY��q}v~;�_�
��Gl�E��qx�r�_��,��U��h���,�     