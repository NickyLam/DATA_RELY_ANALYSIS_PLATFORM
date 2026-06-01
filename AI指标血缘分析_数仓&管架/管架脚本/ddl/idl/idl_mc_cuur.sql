prompt PL/SQL Developer import file
prompt Created on 2020年8月23日 by wuzheng
set feedback off
set define off
prompt Creating MC_CURR...
drop table MC_CURR cascade constraints;
prompt Creating MC_CURR...
create table MC_CURR
(
  curr_id   VARCHAR2(10),
  curr_name VARCHAR2(60)
)
;

prompt Loading MC_CURR...
insert into MC_CURR (curr_id, curr_name)
values ('WB_CNY', '外币折本币');
insert into MC_CURR (curr_id, curr_name)
values ('CNY', '人民币');
insert into MC_CURR (curr_id, curr_name)
values ('BWB', '本外币合计');
commit;
prompt 3 records loaded
set feedback on
set define on
prompt Done.
