prompt PL/SQL Developer import file
prompt Created on 2020年8月23日 by wuzheng
set feedback off
set define off
prompt Creating MC_BANKING_PARA...
drop table MC_BANKING_PARA cascade constraints;
prompt Creating MC_BANKING_PARA...
create table MC_BANKING_PARA
(
  s_info_compcode  VARCHAR2(10),
  banking_name     VARCHAR2(20),
  banking_sort     VARCHAR2(20),
  banking_ipo      VARCHAR2(10),
  enchmarking_flag VARCHAR2(2),
  operate_dt       DATE
)
;
comment on table MC_BANKING_PARA
  is '同业机构表';
comment on column MC_BANKING_PARA.s_info_compcode
  is '公司ID';
comment on column MC_BANKING_PARA.banking_name
  is '银行名称';
comment on column MC_BANKING_PARA.banking_sort
  is '银行性质分类';
comment on column MC_BANKING_PARA.banking_ipo
  is '银行上市分类';
comment on column MC_BANKING_PARA.enchmarking_flag
  is '是否对标行';
comment on column MC_BANKING_PARA.operate_dt
  is '处理时间';

prompt Loading MC_BANKING_PARA...
insert into MC_BANKING_PARA (s_info_compcode, banking_name, banking_sort, banking_ipo, enchmarking_flag, operate_dt)
values ('502045086', '珠海华润银行', '城商行', '未上市', '1', to_date('20-08-2020 14:15:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into MC_BANKING_PARA (s_info_compcode, banking_name, banking_sort, banking_ipo, enchmarking_flag, operate_dt)
values ('1AI997EA31', '东莞银行', '城商行', '未上市', '1', to_date('20-08-2020 14:15:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into MC_BANKING_PARA (s_info_compcode, banking_name, banking_sort, banking_ipo, enchmarking_flag, operate_dt)
values ('04863CDE01', '广州银行', '城商行', '未上市', '1', to_date('20-08-2020 14:15:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into MC_BANKING_PARA (s_info_compcode, banking_name, banking_sort, banking_ipo, enchmarking_flag, operate_dt)
values ('04A5778076', '南粤银行', '城商行', '未上市', '1', to_date('20-08-2020 14:15:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into MC_BANKING_PARA (s_info_compcode, banking_name, banking_sort, banking_ipo, enchmarking_flag, operate_dt)
values ('TzdUzhXR2n', '华兴银行', '城商行', '未上市', '1', to_date('20-08-2020 14:15:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into MC_BANKING_PARA (s_info_compcode, banking_name, banking_sort, banking_ipo, enchmarking_flag, operate_dt)
values ('0PH6B96491', '广州农商行', '农商行', '港股', '1', to_date('20-08-2020 14:15:14', 'dd-mm-yyyy hh24:mi:ss'));
insert into MC_BANKING_PARA (s_info_compcode, banking_name, banking_sort, banking_ipo, enchmarking_flag, operate_dt)
values ('avg', '对标行均值', null, null, null, to_date('20-08-2020 14:15:14', 'dd-mm-yyyy hh24:mi:ss'));
commit;
prompt 7 records loaded
set feedback on
set define on
prompt Done.
