begin
   sys.prc_create_owner('APICULTURA', 'kmm');
end;
/

grant execute on kss.getgestao to APICULTURA with grant option;
grant select on cep.v$municipio to apicultura;
grant execute on kss.pkg_string to apicultura;
