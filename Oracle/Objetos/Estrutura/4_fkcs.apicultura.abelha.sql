begin
   execute immediate '
alter table apicultura.abelha
  add constraint fkc_abe_col
  foreign key (colmeia_id, cod_gestao) references apicultura.colmeia (colmeia_id, cod_gestao)
  deferrable';
exception
   when others then
      if sqlcode not in (-2275) then
         raise;
      end if;
end;
/