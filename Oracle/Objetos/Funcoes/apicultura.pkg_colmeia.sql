create or replace package apicultura.pkg_colmeia is

procedure prc_ins_colmeia
 (p_colmeia_id     out apicultura.v$colmeia.colmeia_id%type
 ,p_num_colmeia     in apicultura.v$colmeia.num_colmeia%type
 ,p_descricao       in apicultura.v$colmeia.descricao%type
 ,p_tipo            in apicultura.v$colmeia.tipo%type
 ,p_producao_minima in apicultura.v$colmeia.producao_minima%type
 ,p_municipio_id    in apicultura.v$colmeia.municipio_id%type
  );

procedure prc_alt_colmeia
 (p_colmeia_id      in apicultura.v$colmeia.colmeia_id%type
 ,p_num_colmeia     in apicultura.v$colmeia.num_colmeia%type
 ,p_descricao       in apicultura.v$colmeia.descricao%type
 ,p_tipo            in apicultura.v$colmeia.tipo%type
 ,p_producao_minima in apicultura.v$colmeia.producao_minima%type
 ,p_municipio_id    in apicultura.v$colmeia.municipio_id%type
 );

procedure prc_del_colmeia
 (p_colmeia_id in apicultura.v$colmeia.colmeia_id%type
 );

procedure prc_ins_abelha
 (p_abelha_id          out apicultura.v$abelha.abelha_id%type
 ,p_colmeia_id          in apicultura.v$abelha.colmeia_id%type
 ,p_num_abelha          in apicultura.v$abelha.num_abelha%type
 ,p_nome                in apicultura.v$abelha.nome%type
 ,p_producao_individual in apicultura.v$abelha.producao_individual%type
 ,p_modalidade          in apicultura.v$abelha.modalidade%type
 ,p_data_admissao       in apicultura.v$abelha.data_admissao%type
  );

procedure prc_alt_abelha
 (p_abelha_id           in apicultura.v$abelha.abelha_id%type
 ,p_colmeia_id          in apicultura.v$abelha.colmeia_id%type
 ,p_num_abelha          in apicultura.v$abelha.num_abelha%type
 ,p_nome                in apicultura.v$abelha.nome%type
 ,p_producao_individual in apicultura.v$abelha.producao_individual%type
 ,p_modalidade          in apicultura.v$abelha.modalidade%type
 ,p_data_admissao       in apicultura.v$abelha.data_admissao%type
 );

procedure prc_del_abelha
 (p_abelha_id in apicultura.v$abelha.abelha_id%type
 );

end pkg_colmeia;
/
create or replace package body apicultura.pkg_colmeia is

procedure prc_ins_colmeia
 (p_colmeia_id     out apicultura.v$colmeia.colmeia_id%type
 ,p_num_colmeia     in apicultura.v$colmeia.num_colmeia%type
 ,p_descricao       in apicultura.v$colmeia.descricao%type
 ,p_tipo            in apicultura.v$colmeia.tipo%type
 ,p_producao_minima in apicultura.v$colmeia.producao_minima%type
 ,p_municipio_id    in apicultura.v$colmeia.municipio_id%type
  ) is 
begin
   insert into apicultura.v$colmeia (
          num_colmeia, descricao, tipo, producao_minima, municipio_id)
   values (p_num_colmeia, p_descricao, p_tipo, p_producao_minima, p_municipio_id)
   returning colmeia_id into p_colmeia_id;
exception
   when kss.pkg_mensagem.kmm_check_constraint_msg or
        kss.pkg_mensagem.kmm_fk_reference_msg or
        kss.pkg_mensagem.kmm_fk_reference_by_msg or
        kss.pkg_mensagem.kmm_unique_constraint_msg then
      kss.pkg_mensagem.prc_trata_constraint(sqlcode, sqlerrm); 
end;

procedure prc_alt_colmeia
 (p_colmeia_id      in apicultura.v$colmeia.colmeia_id%type
 ,p_num_colmeia     in apicultura.v$colmeia.num_colmeia%type
 ,p_descricao       in apicultura.v$colmeia.descricao%type
 ,p_tipo            in apicultura.v$colmeia.tipo%type
 ,p_producao_minima in apicultura.v$colmeia.producao_minima%type
 ,p_municipio_id    in apicultura.v$colmeia.municipio_id%type
 ) is 
begin
   update apicultura.v$colmeia c
      set c.num_colmeia     = p_num_colmeia
        , c.descricao       = p_descricao
        , c.tipo            = p_tipo
        , c.producao_minima = p_producao_minima
        , c.municipio_id    = p_municipio_id
    where c.colmeia_id = p_colmeia_id;
exception
   when kss.pkg_mensagem.kmm_check_constraint_msg or
        kss.pkg_mensagem.kmm_fk_reference_msg or
        kss.pkg_mensagem.kmm_fk_reference_by_msg or
        kss.pkg_mensagem.kmm_unique_constraint_msg then
      kss.pkg_mensagem.prc_trata_constraint(sqlcode, sqlerrm); 
end;

procedure prc_del_colmeia
 (p_colmeia_id in apicultura.v$colmeia.colmeia_id%type
 ) is 
begin
   delete apicultura.v$colmeia c
    where c.colmeia_id = p_colmeia_id;
exception
   when kss.pkg_mensagem.kmm_check_constraint_msg or
        kss.pkg_mensagem.kmm_fk_reference_msg or
        kss.pkg_mensagem.kmm_fk_reference_by_msg or
        kss.pkg_mensagem.kmm_unique_constraint_msg then
      kss.pkg_mensagem.prc_trata_constraint(sqlcode, sqlerrm); 
end;

procedure prc_ins_abelha
 (p_abelha_id          out apicultura.v$abelha.abelha_id%type
 ,p_colmeia_id          in apicultura.v$abelha.colmeia_id%type
 ,p_num_abelha          in apicultura.v$abelha.num_abelha%type
 ,p_nome                in apicultura.v$abelha.nome%type
 ,p_producao_individual in apicultura.v$abelha.producao_individual%type
 ,p_modalidade          in apicultura.v$abelha.modalidade%type
 ,p_data_admissao       in apicultura.v$abelha.data_admissao%type
  ) is 
begin
   insert into apicultura.v$abelha (
          colmeia_id, num_abelha, nome, producao_individual
        , modalidade, data_admissao)
   values (p_colmeia_id, p_num_abelha, p_nome, p_producao_individual
        , p_modalidade, p_data_admissao)
   returning abelha_id into p_abelha_id;
exception
   when kss.pkg_mensagem.kmm_check_constraint_msg or
        kss.pkg_mensagem.kmm_fk_reference_msg or
        kss.pkg_mensagem.kmm_fk_reference_by_msg or
        kss.pkg_mensagem.kmm_unique_constraint_msg then
      kss.pkg_mensagem.prc_trata_constraint(sqlcode, sqlerrm); 
end;

procedure prc_alt_abelha
 (p_abelha_id           in apicultura.v$abelha.abelha_id%type
 ,p_colmeia_id          in apicultura.v$abelha.colmeia_id%type
 ,p_num_abelha          in apicultura.v$abelha.num_abelha%type
 ,p_nome                in apicultura.v$abelha.nome%type
 ,p_producao_individual in apicultura.v$abelha.producao_individual%type
 ,p_modalidade          in apicultura.v$abelha.modalidade%type
 ,p_data_admissao       in apicultura.v$abelha.data_admissao%type
 ) is 
begin
   update apicultura.v$abelha a
      set a.colmeia_id          = p_colmeia_id
        , a.num_abelha          = p_num_abelha
        , a.nome                = p_nome
        , a.producao_individual = p_producao_individual
        , a.modalidade          = p_modalidade
        , a.data_admissao       = p_data_admissao
    where a.abelha_id = p_abelha_id;
exception
   when kss.pkg_mensagem.kmm_check_constraint_msg or
        kss.pkg_mensagem.kmm_fk_reference_msg or
        kss.pkg_mensagem.kmm_fk_reference_by_msg or
        kss.pkg_mensagem.kmm_unique_constraint_msg then
      kss.pkg_mensagem.prc_trata_constraint(sqlcode, sqlerrm); 
end;

procedure prc_del_abelha
 (p_abelha_id in apicultura.v$abelha.abelha_id%type
 ) is 
begin
   delete apicultura.v$abelha a
    where a.abelha_id = p_abelha_id;
exception
   when kss.pkg_mensagem.kmm_check_constraint_msg or
        kss.pkg_mensagem.kmm_fk_reference_msg or
        kss.pkg_mensagem.kmm_fk_reference_by_msg or
        kss.pkg_mensagem.kmm_unique_constraint_msg then
      kss.pkg_mensagem.prc_trata_constraint(sqlcode, sqlerrm); 
end;


end pkg_colmeia;
/
begin
   execute immediate 'grant execute on apicultura.pkg_colmeia to kss_corporativo';
end;
/
