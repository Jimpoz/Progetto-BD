PGDMP                          {           Progetto_BD    15.1    15.1 +    F           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            G           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            H           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            I           1262    16991    Progetto_BD    DATABASE     �   CREATE DATABASE "Progetto_BD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE "Progetto_BD";
                postgres    false            V           1247    17012 
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
       public         heap    postgres    false            �            1259    17155    creazione_esame_audit    TABLE     �   CREATE TABLE public.creazione_esame_audit (
    "idD" character varying(200),
    "idE" character varying(100),
    ruolo_docente character varying(100)
);
 )   DROP TABLE public.creazione_esame_audit;
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
       public         heap    postgres    false            �            1259    17158    esame_audit    TABLE     �   CREATE TABLE public.esame_audit (
    "idD" character varying(200),
    nome character varying(100),
    anno_accademico character varying(100),
    cfu integer
);
    DROP TABLE public.esame_audit;
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
       public         heap    postgres    false            �            1259    17161    prova_audit    TABLE     n  CREATE TABLE public.prova_audit (
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
       public         heap    postgres    false            =          0    17058    Appelli 
   TABLE DATA           J   COPY public."Appelli" ("idS", voto, stato_superamento, "idP") FROM stdin;
    public          postgres    false    219   3       @          0    17142    Appelli_audit 
   TABLE DATA           P   COPY public."Appelli_audit" ("idP", "idS", voto, stato_superamento) FROM stdin;
    public          postgres    false    222   �3       ;          0    17026    Creazione_esame 
   TABLE DATA           H   COPY public."Creazione_esame" ("idD", "idE", ruolo_docente) FROM stdin;
    public          postgres    false    217   �4       ?          0    17085    alembic_version 
   TABLE DATA           6   COPY public.alembic_version (version_num) FROM stdin;
    public          postgres    false    221   O5       A          0    17155    creazione_esame_audit 
   TABLE DATA           L   COPY public.creazione_esame_audit ("idD", "idE", ruolo_docente) FROM stdin;
    public          postgres    false    223   y5       8          0    16992    docente 
   TABLE DATA           H   COPY public.docente ("idD", nome, cognome, email, password) FROM stdin;
    public          postgres    false    214   �5       :          0    17006    esame 
   TABLE DATA           B   COPY public.esame ("idE", nome, anno_accademico, cfu) FROM stdin;
    public          postgres    false    216   �7       B          0    17158    esame_audit 
   TABLE DATA           H   COPY public.esame_audit ("idD", nome, anno_accademico, cfu) FROM stdin;
    public          postgres    false    224   �7       >          0    17067    prova 
   TABLE DATA           �   COPY public.prova ("idP", tipo_voto, "idE", tipo_prova, nome_prova, "idD", data, data_scadenza, ora_prova, peso, sufficienza) FROM stdin;
    public          postgres    false    220   8       C          0    17161    prova_audit 
   TABLE DATA           �   COPY public.prova_audit ("idP", tipo_voto, "idE", tipo_prova, nome_prova, "idD", data, data_scadenza, ora_prova, peso, sufficienza) FROM stdin;
    public          postgres    false    225   :       <          0    17043    registrazione_esame 
   TABLE DATA           S   COPY public.registrazione_esame ("idS", "idE", voto, data_superamento) FROM stdin;
    public          postgres    false    218   .:       9          0    17001    studente 
   TABLE DATA           8   COPY public.studente ("idS", nome, cognome) FROM stdin;
    public          postgres    false    215   �:       �           2606    17124    Appelli Appelli_pkey 
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
       public          postgres    false    220    219    3234            �           2606    17106 (   Creazione_esame creazione_esame_idd_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_idd_fkey FOREIGN KEY ("idD") REFERENCES public.docente("idD");
 T   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_idd_fkey;
       public          postgres    false    3222    217    214            �           2606    17038 (   Creazione_esame creazione_esame_ide_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Creazione_esame"
    ADD CONSTRAINT creazione_esame_ide_fkey FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 T   ALTER TABLE ONLY public."Creazione_esame" DROP CONSTRAINT creazione_esame_ide_fkey;
       public          postgres    false    3226    217    216            �           2606    17053 0   registrazione_esame registrazione_esame_ide_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_ide_fkey FOREIGN KEY ("idE") REFERENCES public.esame("idE");
 Z   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_ide_fkey;
       public          postgres    false    216    3226    218            �           2606    17048 0   registrazione_esame registrazione_esame_ids_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.registrazione_esame
    ADD CONSTRAINT registrazione_esame_ids_fkey FOREIGN KEY ("idS") REFERENCES public.studente("idS");
 Z   ALTER TABLE ONLY public.registrazione_esame DROP CONSTRAINT registrazione_esame_ids_fkey;
       public          postgres    false    215    3224    218            =   `   x���0326�42�,�t�5000Sp���q�粀JZ I����@$�ML8-�$�`�FHaSFY���8���jH�.4%F��� %0$�      @   �   x�u�;�0��9E/P�G�x�*P����p�JhiIW����Gġ�f��Rx�X�1]�e,	,x2x.��tKI�ܾ�\]��3�M�X|�p۹"���A����v��+�`�hM6���~����s��{R�      ;   �   x�ݒ=��1kr
.`�Ďc��+mAI�G� $��bX}%�9�<͓�9��0�Q�9�\�-z�����QV����n��Z�fp�mB㜀*��.u��n�WxN��c���|O1@*�L�����$	)�j�P�`o�(Y|��+�o{4c�-�5��"	�;�2��Ӆ�S�!��^6�oBw�v��      ?      x�K1N40L32MN5O����� .�;      A      x������ � �      8   �  x�Ք�N[A���>E����w̪�J��P+B����x�.!$!�<Mߥ/�D���q6���ͧ#SV�L�pa6!��$��a|`�A-�{�&�ldY��}�ZE��t��~�����Ӄqۭ�U��p�Sҡ#h���K������C�ӛ����D� �ȃ�D�Y�\��c-�9A)�ar��2El�&t��J&�yxmx/Q�m�U�7ݱL�k@�M��>Cuq���-/?����0��*E���:h�ɦ�1�((G�Z�ƨ)W@�BE�;��=���DO��hb�llg�z�ؾ6����"��tӝ�4����y���a��t�����3"�Ě���UQ�8!2q��sD I�Y��@csitV1��nw��Ė�TOF���Օf%�o����v�Gu.�q��ݾ<�3�������tqrzry?�IF�g3@t�Z�� C���=_UΑs���)�o���8���0+&�      :   \   x�s1000�tr�Tp"�ON###} a�ih���k`ln����������U����������'�PWS͸b���� �O      B      x������ � �      >   �  x�ݖ�n�@F���nu��;JP�d��,�n ��֖l��;`ˍ�&�(��fut��I+�&��/��&jvۗKÐ�����xܱ��IT����N��y2Ϙt� �X� H�Z��k�y-��>�b� 4 ���~�#��B�fi(��x�����a�k����*K��^a��l�n��$
��-������>�[ֈ��3��Ey�&2'D��S?�&�zENpk�@ڵ��N!	���lr@�%\21ʞTp��,R������;:�����.��}J��b�U�;V}MVy����/�'&U0��~�*j��=Ku�)�[S7�|J��Htv�(�^�TO�T׬���̫EeѪ*���̦�N�o�t}e�hX�`�cV��n_���qO˶���*�N��\M�TD��׭���|4�����N���G��B�+�HEb�NX���Ͻ!ԘbD�R}*�y��]W%?��:ݯ���_"&yi�_f��oPZ�      C      x������ � �      <   C   x�]˱�@�z��8^�m�����LF��J��6g�$<h^F��p0�x��ѿY����CUL��      9   �   x����0E�ׯ����vv�����@\�/�D^P�^H�t�ɍ������'�@�L��*j���c�0���XY�ż��:e�NC�ԥWb]gY��q}v~;�_�
��Gl�E��qx�r�_��,��U��h���,�     