grant references on cep.municipio to apicultura;

begin
   execute immediate '
alter table apicultura.colmeia
  add constraint fkc_col_mun
  foreign key (municipio_id) references cep.municipio (municipio_id)
  deferrable';
exception
   when others then
      if sqlcode not in (-2275) then
         raise;
      end if;
end;
/