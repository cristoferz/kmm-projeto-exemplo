-- Create table
begin
   execute immediate '
      create table APICULTURA.ABELHA
      (
        cod_gestao      NUMBER not null,
        abelha_id       INTEGER not null,
        colmeia_id      INTEGER not null,
        num_abelha      INTEGER not null,
        nome            VARCHAR2(60) not null,
        producao_individual INTEGER,
        modalidade      VARCHAR2(60) not null,
        data_admissao   date not null,
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
alter table APICULTURA.abelha
  add constraint PKC_ABE primary key (ABELHA_ID, COD_GESTAO)';
exception
   when others then
      if sqlcode not in (-2260) then
         raise;
      end if;
end;
/
begin
   execute immediate '
alter table APICULTURA.ABELHA
  add constraint UKC_ABE_NOME unique (COLMEIA_ID, NOME, COD_GESTAO)';
exception
   when others then
      if sqlcode not in (-2261) then
         raise;
      end if;
end;
/
begin
   execute immediate '
alter table APICULTURA.ABELHA
  add constraint UKC_ABE_NUM unique (COLMEIA_ID, NUM_ABELHA, COD_GESTAO)';
exception
   when others then
      if sqlcode not in (-2261) then
         raise;
      end if;
end;
/
