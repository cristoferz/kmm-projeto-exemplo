create or replace view apicultura.v$colmeia as
select c.colmeia_id
     , c.num_colmeia
     , c.descricao
     , c.tipo
     , c.producao_minima
     , c.municipio_id
     , c.user_insert
     , c.date_insert
     , c.user_update
     , c.date_update
     , c.site
  from apicultura.colmeia c
 where cod_gestao = kss.getgestao;

grant select on apicultura.v$colmeia to kss_corporativo;  
