prompt Importing table kss.cg_ref_codes...
set feedback off
set define off

delete kss.cg_ref_codes
 where owner = 'APICULTURA';

insert into kss.cg_ref_codes (RV_DOMAIN, RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_MEANING, OWNER)
values ('COLMEIA.ESPECIE', 'AFRICANA', null, 'Africana', null, 'APICULTURA');

insert into kss.cg_ref_codes (RV_DOMAIN, RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_MEANING, OWNER)
values ('COLMEIA.ESPECIE', 'EUROPEIA', null, 'Europeia', null, 'APICULTURA');


insert into kss.cg_ref_codes (RV_DOMAIN, RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_MEANING, OWNER)
values ('ABELHA.MODALIDADE', 'FROTA', null, 'Frota', null, 'APICULTURA');

insert into kss.cg_ref_codes (RV_DOMAIN, RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_MEANING, OWNER)
values ('ABELHA.MODALIDADE', 'AGREGADO', null, 'Agregado', null, 'APICULTURA');

insert into kss.cg_ref_codes (RV_DOMAIN, RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_MEANING, OWNER)
values ('ABELHA.MODALIDADE', 'TERCEIRO', null, 'Terceiro', null, 'APICULTURA');

commit; 

prompt Done.
