-- Create table
begin
   execute immediate '
create table APICULTURA.COLMEIA
(
  cod_gestao      NUMBER not null,
  colmeia_id      INTEGER not null,
  num_colmeia     INTEGER not null,
  descricao       VARCHAR2(60) not null,
  tipo            VARCHAR2(60) not null,
  producao_minima INTEGER,
  municipio_id    INTEGER,
  user_insert     VARCHAR2(30) default user not null,
  date_insert     DATE default sysdate not null,
  user_update     VARCHAR2(30) default user not null,
  date_update     DATE default sysdate not null,
  site            VARCHAR2(30) not null
)';
exception
   when others then
      if sqlcode not in (-955) then
         raise;
      end if;
end;
/

-- Create/Recreate primary, unique and foreign key constraints 
begin
   execute immediate '
alter table APICULTURA.COLMEIA
  add constraint PKC_COL primary key (COLMEIA_ID, COD_GESTAO)
  deferrable';
exception
   when others then
      if sqlcode not in (-2260) then
         raise;
      end if;
end;
/
begin
   execute immediate '
alter table APICULTURA.COLMEIA
  add constraint UKC_COL_DESC unique (DESCRICAO, COD_GESTAO)
  deferrable';
exception
   when others then
      if sqlcode not in (-2261) then
         raise;
      end if;
end;
/
begin
   execute immediate '
alter table APICULTURA.COLMEIA
  add constraint UKC_COL_NUM unique (NUM_COLMEIA, COD_GESTAO)
  deferrable';
exception
   when others then
      if sqlcode not in (-2261) then
         raise;
      end if;
end;
/


