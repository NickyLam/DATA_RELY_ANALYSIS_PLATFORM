prompt PL/SQL Developer import file
prompt Created on 2020年8月24日 by wuzheng
set feedback off
set define off
prompt Creating MC_SUP_PARA...
drop table MC_SUP_PARA cascade constraints;
prompt Creating MC_SUP_PARA...
create table MC_SUP_PARA
(
  index_no      VARCHAR2(60),
  index_name    VARCHAR2(200),
  sup_logic     VARCHAR2(10),
  sup_value     NUMBER(30,8),
  sup_status    VARCHAR2(10),
  effect_dt     DATE,
  invalid_dt    DATE,
  etl_timestamp TIMESTAMP(6)
)
compress
nologging;
comment on table MC_SUP_PARA
  is '监控阀值表';
comment on column MC_SUP_PARA.index_no
  is '指标编码';
comment on column MC_SUP_PARA.index_name
  is '指标名称';
comment on column MC_SUP_PARA.sup_logic
  is '逻辑关系';
comment on column MC_SUP_PARA.sup_value
  is '阀值';
comment on column MC_SUP_PARA.sup_status
  is '阀值状态';
comment on column MC_SUP_PARA.effect_dt
  is '生效日期';
comment on column MC_SUP_PARA.invalid_dt
  is '失效日期';
comment on column MC_SUP_PARA.etl_timestamp
  is 'ETL处理时间戳';

prompt Loading MC_SUP_PARA...
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('YL04021000', '平均资产收益率（ROAA）', '<=', .0095, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('YL04022000', '加权平均净资产收益率（ROAE)', '<=', .1362, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('YL04030000', '成本收入比', '<=', .36, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('FX02024000', '不良贷款率', '>=', .015, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('FX02022000', '不良资产率', '>=', .01, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('FX02041000', '贷款拨备率', '<=', .018, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('FX02042000', '拨备覆盖率', '<=', 1.3, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('FX01030000', '资本充足率', '<=', .105, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('FX01031000', '一级资本充足率', '<=', .085, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('FX01032000', '核心一级资本充足率', '<=', .075, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('FX01040000', '杠杆率', '<=', .04, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('FX03011000', '流动性比率', '<=', .25, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('FX03012000', '流动性覆盖率', '<=', 1, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('FX03013000', '净稳定资金比例', '<=', 1, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('TY02023000', '成本收入比', '<=', .36, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('TY03010000', '资本充足率', '<=', .105, '正常', null, null, null);
insert into MC_SUP_PARA (index_no, index_name, sup_logic, sup_value, sup_status, effect_dt, invalid_dt, etl_timestamp)
values ('TY03023000', '拨备覆盖率', '<=', 1.3, '正常', null, null, null);
commit;
prompt 17 records loaded
set feedback on
set define on
prompt Done.
