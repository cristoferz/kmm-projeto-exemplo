CREATE OR REPLACE TRIGGER APICULTURA.TR_COL_BIR_PKC
 BEFORE INSERT
 ON apicultura.colmeia
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
begin
   if (dbms_reputil.from_remote != TRUE) and
      (dbms_snapshot.i_am_a_refresh != TRUE) then
      select sqe_col.nextval
        into :new.colmeia_id
        from dual;
   end if;
end;
/

CREATE OR REPLACE TRIGGER APICULTURA.TR_COL_BIR_AUDIT
 BEFORE INSERT
 ON apicultura.colmeia
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
begin
   if (dbms_reputil.from_remote != TRUE) and
      (dbms_snapshot.i_am_a_refresh != TRUE) then
      :new.cod_gestao := kss.getgestao;
      :new.site := dbms_reputil.global_name;
   end if;
end;
/

CREATE OR REPLACE TRIGGER APICULTURA.TR_COL_BUR_AUDIT
 BEFORE UPDATE
 ON apicultura.colmeia
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
begin
   if (dbms_reputil.from_remote != TRUE) and
      (dbms_snapshot.i_am_a_refresh != TRUE) then
      :new.user_update := user;
      :new.date_update := sysdate;
   end if;
end;
/

