set define off;

declare
   v_modulo_web       integer;
   v_novo_item_acesso integer;
   v_grupo_acesso_id  integer;
   v_item_acesso_0    integer;
   v_item_acesso_1    integer;
   v_item_acesso_2    integer;

begin
   begin
      select item_acesso_id
        into v_item_acesso_0
        from acesso.item_acesso a
       where (a.item_acesso_pai is null
         and 0 = 0
         and a.dll_name = (select ka.cod_aplicacao
                             from kss.kss_aplicacao ka
                            where ka.cod_projeto = 35))
          or (0 = 1 and item_acesso_id = 1);
   exception
      when no_data_found then
         dbms_output.put_line('Item de acesso PAI não foi encontrado. Estrutura de item de acesso "Exemplo / Cadastro de Colmeia" não foi inserida.'); 
         return;
   end;

   --item acesso: "Exemplo"
   begin
      select ia.item_acesso_id
        into v_item_acesso_1
        from acesso.item_acesso ia
       where ia.item_acesso_pai = v_item_acesso_0
         and upper(regexp_replace(ia.act_caption,'(&){2,}', '&')) = upper('Exemplo');

      update acesso.item_acesso
         set act_caption = 'Exemplo'
           , descricao = 'Exemplo'
           , act_hint = ''
       where item_acesso_id = v_item_acesso_1;
   exception
      when no_data_found then
         insert into acesso.item_acesso (item_acesso_pai, descricao, act_caption, act_visible, act_enabled, ordem, act_hint)
         values (v_item_acesso_0, 'Exemplo', 'Exemplo', 'true', 'true', (select nvl(max(ordem),0)+1 from acesso.item_acesso where item_acesso_pai = v_item_acesso_0), '')
         returning item_acesso_id into v_item_acesso_1;
   end;


   --item acesso: "Cadastro de Colmeia"
   begin
      select ia.item_acesso_id
        into v_item_acesso_2
        from acesso.item_acesso ia
       where ia.item_acesso_pai = v_item_acesso_1

         and (ia.java_jarname = 'Exemplo.jar' and java_classname = 'kmm.modulos.exemplos.apicultura.colmeia.views.FormCadastroColmeia' and java_staticfunction = 'createFormCadastroColmeia');

      update acesso.item_acesso
         set dll_name = ''
           , exported_function = ''
           , java_jarname = 'Exemplo.jar'
           , separar = '0'
           , java_classname = 'kmm.modulos.exemplos.apicultura.colmeia.views.FormCadastroColmeia'
           , java_staticfunction = 'createFormCadastroColmeia'
           , act_caption = 'Cadastro de Colmeia'
           , descricao = 'Cadastro de Colmeia'
           , act_hint = ''
           , web_url = ''
           , web_url_image = ''
           , web_target = ''
           , item_acesso_cod = ''
       where item_acesso_id = v_item_acesso_2;
      v_novo_item_acesso := v_item_acesso_2;
   exception
      when no_data_found then
         insert into acesso.item_acesso (item_acesso_pai, descricao, act_caption, act_hint, java_jarname, java_classname, java_staticfunction, java_extendedstate, dll_name, exported_function, act_visible, act_enabled, ordem, web_url, web_url_image, web_target, item_acesso_cod, separar)
         values (v_item_acesso_1, 'Cadastro de Colmeia', 'Cadastro de Colmeia', '', 'Exemplo.jar', 'kmm.modulos.exemplos.apicultura.colmeia.views.FormCadastroColmeia', 'createFormCadastroColmeia', -1, '', '', 'true', 'true', (select nvl(max(ordem),0)+1 from acesso.item_acesso where item_acesso_pai = v_item_acesso_1), '','','', '', '0')
         returning item_acesso_id into v_novo_item_acesso;
   end;
   v_item_acesso_2 := v_novo_item_acesso;
   --Vincula os itens de acesso criados ao grupo KMM
   for g in (
      select cod_gestao
        from kss.pessoa_aplicacao_gestao g
       where exists (select 0 
                       from kss.pessoa_unidade_negocio u 
                      where u.cod_gestao = g.cod_gestao)
                      order by cod_gestao) loop

      delete from kss.pessoa_usuario_acesso_cur;

      insert into kss.pessoa_usuario_acesso_cur
        (cod_pessoa, usuario)
      select cod_pessoa, 'x'
        from kss.pessoa_unidade_negocio
       where cod_gestao = g.cod_gestao;

      begin
         select ga.grupo_acesso_id
           into v_grupo_acesso_id
           from acesso.v$grupo_acesso ga
          where ga.descricao = 'KMM';
      exception
         when no_data_found then
            raise_application_error(-20000, 'Não foi possível localizar o Grupo KMM.');
      end;

      --vincula item acesso "Exemplo" ao grupo KMM
      begin
         insert into acesso.v$grupo_item_acesso (grupo_acesso_id, item_acesso_id)
         values (v_grupo_acesso_id, v_item_acesso_1);
      exception
         when dup_val_on_index then
            null;
      end;

      --vincula item acesso "Cadastro de Colmeia" ao grupo KMM
      begin
         insert into acesso.v$grupo_item_acesso (grupo_acesso_id, item_acesso_id)
         values (v_grupo_acesso_id, v_item_acesso_2);
      exception
         when dup_val_on_index then
            null;
      end;

   end loop;

   commit;
end;
/