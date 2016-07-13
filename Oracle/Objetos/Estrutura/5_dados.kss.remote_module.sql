declare
v_cod_module   kss.remote_module.cod_module%type := 'EXEMPLO';
v_descricao    kss.remote_module.cod_module%type := 'Exemplo';
v_package_name kss.remote_module.cod_module%type := 'apicultura.pkg_colmeia_backend';
begin
   update kss.remote_module
      set descricao = v_descricao
        , package_name = v_package_name
    where cod_module = v_cod_module;
   
   if sql%notfound then
      insert into kss.remote_module
         (cod_module, descricao, package_name)
      values
         (v_cod_module, v_descricao, v_package_name);
   end if;
   
   commit;
end;
/