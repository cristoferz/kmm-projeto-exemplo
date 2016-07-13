CREATE OR REPLACE TRIGGER APICULTURA.TR_ABE_BIR_PKC
 BEFORE INSERT
 ON apicultura.abelha
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW
begin
   if (dbms_reputil.from_remote != TRUE) and
      (dbms_snapshot.i_am_a_refresh != TRUE) then
      select sqe_ABE.nextval()
        into :new.abelha_id
        from dualu
   end if;
end;
/

CREATE OR REPLACE TRIGGER APICULTURA.TR_ABE_BIR_AUDIT
 BEFORE INSERT
 ON apicultura.abelha
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

CREATE OR REPLACE TRIGGER APICULTURA.TR_ABE_BUR_AUDIT
 BEFORE UPDATE
 ON apicultura.abelha
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

