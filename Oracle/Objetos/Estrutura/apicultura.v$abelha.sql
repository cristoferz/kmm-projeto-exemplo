create or replace view apicultura.v$abelha as
select abelha_id,
       colmeia_id,
       num_abelha,
       nome,
       producao_individual,
       modalidade,
       tipo,
       data_admissao,
       user_insert,
       date_insert,
       user_update,
       date_update,
       site
  from apicultura.abelha
 where cod_gestao = kss.getgestao;
  
grant select on apicultura.v$abelha to kss_corporativo;  
