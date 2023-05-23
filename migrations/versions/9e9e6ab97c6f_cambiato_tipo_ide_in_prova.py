"""Cambiato tipo idE in prova

Revision ID: 9e9e6ab97c6f
Revises: cfc2ca704070
Create Date: 2023-05-23 13:07:54.183127

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '9e9e6ab97c6f'
down_revision = 'cfc2ca704070'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('prova', schema=None) as batch_op:
        batch_op.alter_column('idE',
               existing_type=sa.INTEGER(),
               type_=sa.String(length=100),
               existing_nullable=True)

    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    with op.batch_alter_table('prova', schema=None) as batch_op:
        batch_op.alter_column('idE',
               existing_type=sa.String(length=100),
               type_=sa.INTEGER(),
               existing_nullable=True)

    with op.batch_alter_table('esame', schema=None) as batch_op:
        batch_op.alter_column('idE',
               existing_type=sa.Integer(),
               type_=sa.VARCHAR(length=100),
               existing_nullable=False,
               autoincrement=True)

    op.create_table('appelli',
    sa.Column('idE', sa.INTEGER(), nullable=False),
    sa.Column('idS', sa.INTEGER(), nullable=False),
    sa.Column('data_superamento', sa.DATE(), nullable=True),
    sa.Column('data_scadenza', sa.DATE(), nullable=True),
    sa.Column('voto', sa.INTEGER(), nullable=True),
    sa.Column('stato_superamento', sa.BOOLEAN(), nullable=True)
    )
    op.create_table('creazione_esame',
    sa.Column('idD', sa.INTEGER(), nullable=False),
    sa.Column('idE', sa.INTEGER(), nullable=False),
    sa.ForeignKeyConstraint(['idD'], ['docente.idD'], ),
    sa.ForeignKeyConstraint(['idE'], ['esame.idE'], ),
    sa.PrimaryKeyConstraint('idD', 'idE')
    )
    op.create_table('registrazione_esame',
    sa.Column('idS', sa.INTEGER(), nullable=False),
    sa.Column('idE', sa.INTEGER(), nullable=False),
    sa.Column('voto', sa.INTEGER(), nullable=True),
    sa.Column('data_superamento', sa.DATE(), nullable=True),
    sa.ForeignKeyConstraint(['idE'], ['esame.idE'], ),
    sa.ForeignKeyConstraint(['idS'], ['studente.idS'], ),
    sa.PrimaryKeyConstraint('idS', 'idE')
    )
    op.drop_table('Registrazione_esame')
    op.drop_table('Creazione_esame')
    op.drop_table('Appelli')
    # ### end Alembic commands ###
