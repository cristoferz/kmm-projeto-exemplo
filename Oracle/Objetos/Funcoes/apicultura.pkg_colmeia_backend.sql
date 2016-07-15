create or replace package apicultura.pkg_colmeia_backend is

  -- Author  : CRISTOFER
  -- Created : 7/11/2016 3:47:18 PM
  -- Purpose : 

function fnc_get_especie
(p_parameters in  xmltype
) return xmltype;

function fnc_get_modalidade
(p_parameters in  xmltype
) return xmltype;

function fnc_get_abelha
(p_parameters in  xmltype
) return xmltype;

procedure prc_module_gateway
(p_operation  in varchar2
,p_parameters in xmltype
,p_result     out xmltype
);

end pkg_colmeia_backend;
/
create or replace package body apicultura.pkg_colmeia_backend is

function fnc_get_especie
(p_parameters in  xmltype
) return xmltype as
v_result xmltype;
begin
   select xmlelement("especies",
             xmlattributes('array' as "type"),
             xmlagg(
                xmlelement("arrayItem",
                   xmlattributes('object' as "type"),
                   jsonelement('cod_especie', 'string', cg.rv_low_value),
                   jsonelement('descricao', 'string', cg.rv_abbreviation)
                )
             )
          )
     into v_result
     from kss.cg_ref_codes cg
    where owner = 'APICULTURA'
      and rv_domain = 'COLMEIA.ESPECIE';
   
  return v_result;
end;

function fnc_get_modalidade
(p_parameters in  xmltype
) return xmltype as
v_result xmltype;
begin
   select xmlelement("modalidades",
             xmlattributes('array' as "type"),
             xmlagg(
                xmlelement("arrayItem",
                   xmlattributes('object' as "type"),
                   jsonelement('cod_modalidade', 'string', cg.rv_low_value),
                   jsonelement('descricao', 'string', cg.rv_abbreviation)
                )
             )
          )
     into v_result
     from kss.cg_ref_codes cg
    where owner = 'APICULTURA'
      and rv_domain = 'ABELHA.MODALIDADE';
   
  return v_result;
end;

procedure prc_init_colmeia
(p_parameters in xmltype
,p_result     out xmltype
) as
begin
   for i in (
      select *
        from xmltable('/params' passing p_parameters
                columns
                   retornar_especies varchar2(10) path '/params/retornar_especies',
                   retornar_modalidades varchar2(10) path '/params/retornar_modalidades'
             )
   ) loop
      select xmlconcat(
                case when i.retornar_especies = 'true' then fnc_get_especie(null) else null end,
                case when i.retornar_modalidades = 'true' then fnc_get_modalidade(null) else null end
             )
        into p_result
        from dual;
   end loop;
end;

function fnc_get_municipio
(p_parameters in  xmltype
) return xmltype as
v_result xmltype;
v_sql    clob;
begin
   for i in (
      select *
        from xmltable('/params' passing p_parameters
                columns
                   municipio_id integer       path '/params/municipio_id'
                 , municipio    varchar2(400) path '/params/municipio'
                 , uf           varchar2(400) path '/params/uf'
                 , cod_ibge     varchar2(100) path '/params/cod_ibge'
             )
   ) loop
      dbms_lob.createtemporary(v_sql, true);
      
      dbms_lob.append(v_sql, '
      select xmlelement("municipios",
                xmlattributes(''array'' as "type"),
                xmlagg(
                   xmlelement("arrayItem",
                      xmlattributes(''object'' as "type"),
                      jsonelement(''municipio_id'', ''number'', m.municipio_id),
                      jsonelement(''municipio'', ''string'', m.municipio),
                      jsonelement(''uf'', ''string'', m.uf_id),
                      jsonelement(''cod_ibge'', ''string'', m.cod_ibge)
                   )
                )
             )
        from (select m.municipio_id
                   , m.municipio
                   , m.uf_id
                   , m.cod_ibge
                from cep.v$municipio m
               where 1=1
');
      if trim(i.municipio_id) is not null then
         dbms_lob.append(v_sql, '   and m.municipio_id = '||i.municipio_id||chr(13)||chr(10));
      end if;
      if trim(i.municipio) is not null then
         dbms_lob.append(v_sql, '   and lower(trim(kss.pkg_string.fnc_string_clean(m.municipio))) like lower(trim(kss.pkg_string.fnc_string_clean('''||i.municipio||''')))'||chr(13)||chr(10));
      end if;
      if trim(i.uf) is not null then
         dbms_lob.append(v_sql, '   and m.uf_id = '''||i.uf||''''||chr(13)||chr(10));
      end if;
      if trim(i.cod_ibge) is not null then
         dbms_lob.append(v_sql, '   and m.cod_ibge = '''||i.cod_ibge||''''||chr(13)||chr(10));
      end if;
      dbms_lob.append(v_sql, ' order by m.municipio
             ) m');
             
      execute immediate v_sql
         into v_result;
      return v_result;
   end loop;
end;

function fnc_get_abelha
(p_parameters in  xmltype
) return xmltype as
v_sql clob;
v_result xmltype;
begin
   for i in (
      select *
        from xmltable('/params' passing p_parameters
                columns
                   colmeia_id        integer       path '/params/colmeia_id'
             )
   ) loop
      dbms_lob.createtemporary(v_sql, true);
      dbms_lob.append(v_sql, '
      select xmlelement("abelhas",
                xmlattributes(''array'' as "type"),
                xmlagg(
                   xmlelement("arrayItem",
                      xmlattributes(''object'' as "type"),
                      jsonelement(''abelha_id'', ''number'', a.abelha_id),
                      jsonelement(''num_abelha'', ''number'', a.num_abelha),
                      jsonelement(''nome'', ''string'', a.nome),
                      jsonelement(''producao_individual'', ''number'', a.producao_individual),
                      jsonelement(''modalidade'', ''string'', a.modalidade)
                   )
                )
             )
        from (select a.abelha_id
                   , a.num_abelha
                   , a.nome
                   , a.producao_individual
                   , a.modalidade
                from apicultura.v$abelha a
               where 1=1');
      if trim(i.colmeia_id) is not null then
         dbms_lob.append(v_sql, '
                 and colmeia_id = '||i.colmeia_id);
      end if;
      dbms_lob.append(v_sql, '
               order by a.num_abelha) a');
               
      execute immediate v_sql
         into v_result;
      
      return v_result;
   end loop;
   
   return v_result;
end;

function fnc_get_colmeia
(p_parameters in xmltype
) return xmltype as
v_result xmltype;
v_sql clob;
begin
   dbms_lob.createtemporary(v_sql, true);
   
   for i in (
      select *
        from xmltable('/params' passing p_parameters
                columns
                   colmeia_id        integer       path '/params/colmeia_id',
                   num_colmeia       integer       path '/params/num_colmeia',
                   descricao         varchar2(100) path '/params/descricao',
                   tipo              varchar2(100) path '/params/tipo',
                   municipio         varchar2(100) path '/params/municipio',
                   municipio_id      integer       path '/params/municipio_id',
                   retornar_abelhas  varchar2(20)  path '/params/retornar_abelhas'
             )
   ) loop
      dbms_lob.append(v_sql, '
         select xmlelement("colmeias",
                   xmlattributes(''array'' as "type"),
                   xmlagg(
                      xmlelement("arrayItem",
                         xmlattributes(''object'' as "type"),
                         jsonelement(''colmeia_id'', ''number'', c.colmeia_id),
                         jsonelement(''num_colmeia'', ''number'', c.num_colmeia),
                         jsonelement(''descricao'', ''string'', c.descricao),
                         jsonelement(''tipo'', ''string'', c.tipo),
                         jsonelement(''producao_minima'', ''number'', c.producao_minima),
                         jsonelement(''municipio_id'', ''number'', c.municipio_id),
                         jsonelement(''cod_ibge'', ''string'', c.cod_ibge),
                         jsonelement(''municipio'', ''string'', c.municipio),
                         jsonelement(''uf'', ''string'', c.uf_id)');
      if i.retornar_abelhas = 'true' then
         dbms_lob.append(v_sql, ', 
                         apicultura.pkg_colmeia_backend.fnc_get_abelha(
                            xmlelement("params", 
                               xmlattributes(''object'' as "type"), 
                               jsonelement(''colmeia_id'', ''number'', c.colmeia_id)
                            )
                         )');
      end if;
      dbms_lob.append(v_sql, '
                      )
                   )
                )
           from (select c.colmeia_id
                      , c.num_colmeia
                      , c.descricao
                      , c.tipo
                      , c.producao_minima
                      , c.municipio_id
                      , m.cod_ibge
                      , m.municipio
                      , m.uf_id
                   from apicultura.v$colmeia c
                  inner join cep.v$municipio m
                     on m.municipio_id = c.municipio_id
                  where 1=1');
      if trim(i.colmeia_id) is not null then
         dbms_lob.append(v_sql, '
                    and c.colmeia_id = '||i.colmeia_id);
      end if;
      if trim(i.num_colmeia) is not null then
         dbms_lob.append(v_sql, '
                    and c.num_colmeia = '||i.num_colmeia);
      end if;
      if trim(i.descricao) is not null then
         dbms_lob.append(v_sql, '
                    and lower(trim(kss.pkg_string.fnc_string_clean(c.descricao))) like lower(trim(kss.pkg_string.fnc_string_clean('''||i.descricao||''')))');
      end if;
      if trim(i.tipo) is not null then
         dbms_lob.append(v_sql, '
                    and c.tipo = '''||i.tipo||'''');
      end if;
      if trim(i.municipio_id) is not null then
         dbms_lob.append(v_sql, '
                    and c.municipio_id = '||i.municipio_id);
      end if;
      if trim(i.municipio) is not null then
         dbms_lob.append(v_sql, '
                    and lower(trim(kss.pkg_string.fnc_string_clean(m.municipio))) like lower(trim(kss.pkg_string.fnc_string_clean('''||i.municipio||''')))');
      end if;
      dbms_lob.append(v_sql, '
                  order by c.num_colmeia) c');
      execute immediate v_sql
         into v_result;

      return v_result;
   end loop;
  
end;

procedure prc_ins_colmeia
(p_parameters in xmltype
,p_result     out xmltype
) as
v_colmeia_id      apicultura.colmeia.colmeia_id%type;
begin
   for i in (
      select *
        from xmltable('/params' passing p_parameters
                columns
                   num_colmeia integer path '/params/num_colmeia'
                 , descricao   varchar2(60) path '/params/descricao'
                 , tipo        varchar2(60) path '/params/tipo'
                 , producao_minima integer  path '/params/producao_minima'
                 , municipio_id integer     path '/params/municipio_id'
                 , abelhas     xmltype      path '/params/abelhas'
             )
   ) loop
      apicultura.pkg_colmeia.prc_ins_colmeia(p_colmeia_id       => v_colmeia_id
                                            ,p_num_colmeia      => i.num_colmeia
                                            ,p_descricao        => i.descricao
                                            ,p_tipo             => i.tipo
                                            ,p_producao_minima  => i.producao_minima
                                            ,p_municipio_id     => i.municipio_id
                                            );
      
      for j in (
         select *
           from xmltable('/abelhas/arrayItem' passing i.abelhas
                   columns
                      num_abelha    integer path '/arrayItem/num_abelha'
                    , nome          varchar2(60) path '/arrayItem/nome'
                    , producao_individual integer path '/arrayItem/producao_individual'
                    , modalidade    varchar2(60) path '/arrayItem/modalidade'
                    , data_admissao varchar2(60) path '/arrayItem/data_admissao'
                )
      ) loop
         declare
         v_abelha_id integer;
         begin
            apicultura.pkg_colmeia.prc_ins_abelha(p_abelha_id            => v_abelha_id
                                                 ,p_colmeia_id           => v_colmeia_id
                                                 ,p_num_abelha           => j.num_abelha
                                                 ,p_nome                 => j.nome
                                                 ,p_producao_individual  => j.producao_individual
                                                 ,p_modalidade           => j.modalidade
                                                 ,p_data_admissao        => j.data_admissao
                                                 );

         end;
      end loop;
      
      select xmlconcat(
                jsonelement('mensagem', 'string', 'Colmeia inserida com sucesso'),
                jsonelement('colmeia_id', 'number', v_colmeia_id),
                fnc_get_abelha(xmlelement("params", 
                                  xmlattributes('object' as "type"),
                                  jsonelement('colmeia_id', 'number', v_colmeia_id)
                               )
                )
             )
        into p_result
        from dual;
   end loop;
end;

procedure prc_upd_colmeia
(p_parameters in xmltype
,p_result     out xmltype
) as
begin
   for i in (
      select *
        from xmltable('/params' passing p_parameters
                columns
                   colmeia_id  integer path '/params/colmeia_id'
                 , num_colmeia integer path '/params/num_colmeia'
                 , descricao   varchar2(60) path '/params/descricao'
                 , tipo        varchar2(60) path '/params/tipo'
                 , producao_minima integer  path '/params/producao_minima'
                 , municipio_id integer     path '/params/municipio_id'
                 , abelhas     xmltype      path '/params/abelhas'
             )
   ) loop
      apicultura.pkg_colmeia.prc_alt_colmeia(p_colmeia_id       => i.colmeia_id
                                            ,p_num_colmeia      => i.num_colmeia
                                            ,p_descricao        => i.descricao
                                            ,p_tipo             => i.tipo
                                            ,p_producao_minima  => i.producao_minima
                                            ,p_municipio_id     => i.municipio_id
                                            );
      
      for j in (
         select *
           from xmltable('/abelhas/arrayItem' passing i.abelhas
                   columns
                      operation     varchar2(10) path '/arrayItem/operation'
                    , abelha_id     integer path '/arrayItem/abelha_id'
                    , num_abelha    integer path '/arrayItem/num_abelha'
                    , nome          varchar2(60) path '/arrayItem/nome'
                    , producao_individual integer path '/arrayItem/producao_individual'
                    , modalidade    varchar2(60) path '/arrayItem/modalidade'
                    , data_admissao varchar2(60) path '/arrayItem/data_admissao'
                )
      ) loop
         declare
         v_abelha_id integer;
         begin
            case j.operation
               when 'INSERT' then
                  apicultura.pkg_colmeia.prc_ins_abelha(p_abelha_id            => v_abelha_id
                                                       ,p_colmeia_id           => i.colmeia_id
                                                       ,p_num_abelha           => j.num_abelha
                                                       ,p_nome                 => j.nome
                                                       ,p_producao_individual  => j.producao_individual
                                                       ,p_modalidade           => j.modalidade
                                                       ,p_data_admissao        => j.data_admissao
                                                       );
               when 'UPDATE' then
                  apicultura.pkg_colmeia.prc_alt_abelha(p_abelha_id            => j.abelha_id
                                                       ,p_colmeia_id           => i.colmeia_id
                                                       ,p_num_abelha           => j.num_abelha
                                                       ,p_nome                 => j.nome
                                                       ,p_producao_individual  => j.producao_individual
                                                       ,p_modalidade           => j.modalidade
                                                       ,p_data_admissao        => j.data_admissao
                                                       );
               when 'DELETE' then
                  apicultura.pkg_colmeia.prc_del_abelha(p_abelha_id            => j.abelha_id
                                                       );
               else
                  raise_application_error(-20000, 'Operação invalida para abelhas da colmeia: '||j.operation); 
            end case;
         end;
      end loop;
      
      select xmlconcat(
                jsonelement('mensagem', 'string', 'Colmeia alterada com sucesso'),
                jsonelement('colmeia_id', 'number', i.colmeia_id),
                fnc_get_abelha(xmlelement("params", 
                                  xmlattributes('object' as "type"),
                                  jsonelement('colmeia_id', 'number', i.colmeia_id)
                               )
                )
             )
        into p_result
        from dual;
   end loop;
end;

procedure prc_del_colmeia
(p_parameters in xmltype
,p_result     out xmltype
) as
v_colmeia_id      apicultura.colmeia.colmeia_id%type;
begin
   for i in (
      select *
        from xmltable('/params' passing p_parameters
                columns
                   colmeia_id  integer path '/params/colmeia_id'
             )
   ) loop
      apicultura.pkg_colmeia.prc_del_colmeia(p_colmeia_id       => v_colmeia_id
                                            );
      
      select jsonelement('mensagem', 'string', 'Colmeia excluída com sucesso.')
        into p_result
        from dual;
   end loop;
end;

procedure prc_module_gateway
(p_operation  in varchar2
,p_parameters in xmltype
,p_result     out xmltype
) as
begin
   case p_operation
      when 'getMunicipio' then
         p_result := fnc_get_municipio(p_parameters => p_parameters);
      when 'getColmeia' then
         p_result := fnc_get_colmeia(p_parameters => p_parameters);
      when 'getAbelha' then
         p_result := fnc_get_abelha(p_parameters => p_parameters);
      when 'initColmeia' then
         prc_init_colmeia(p_parameters => p_parameters
                         ,p_result     => p_result
                         );
      when 'insColmeia' then
         prc_ins_colmeia(p_parameters => p_parameters
                        ,p_result     => p_result
                        );
      when 'updColmeia' then
         prc_upd_colmeia(p_parameters => p_parameters
                        ,p_result     => p_result
                        );
      when 'delColmeia' then
         prc_del_colmeia(p_parameters => p_parameters
                        ,p_result     => p_result
                        );
      else
         raise_application_error(-20000, 'Operação '||p_operation||' inválida'); 
   end case;
     
end;

end pkg_colmeia_backend;
/
begin
   execute immediate 'grant execute on apicultura.pkg_colmeia_backend to kss';
end;
/
