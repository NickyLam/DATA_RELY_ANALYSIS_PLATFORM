/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cpms_t_account_service_water
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cpms_t_account_service_water
whenever sqlerror continue none;
drop table ${iol_schema}.cpms_t_account_service_water purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cpms_t_account_service_water(
    create_date varchar2(12) -- 日期
    ,pty_id varchar2(750) -- 客户号
    ,pty_name varchar2(300) -- 客户名称
    ,equi_id varchar2(48) -- 权益id
    ,equi_name varchar2(300) -- 权益名称
    ,rema_usab_equi_cnt number(24,4) -- 剩余可用权益次数
    ,equi_has_usage_cnt number(24,4) -- 已使用权益次数
    ,final_oper_pers varchar2(48) -- 最后操作人
    ,val_st_dt varchar2(12) -- 有效开始日期
    ,val_end_dt varchar2(12) -- 有效结束日期
    ,source_name varchar2(150) -- 操作来源
    ,water_date date -- 操作日期
    ,transaction_num varchar2(30) -- 操作数值
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cpms_t_account_service_water to ${iml_schema};
grant select on ${iol_schema}.cpms_t_account_service_water to ${icl_schema};
grant select on ${iol_schema}.cpms_t_account_service_water to ${idl_schema};
grant select on ${iol_schema}.cpms_t_account_service_water to ${iel_schema};

-- comment
comment on table ${iol_schema}.cpms_t_account_service_water is '';
comment on column ${iol_schema}.cpms_t_account_service_water.create_date is '日期';
comment on column ${iol_schema}.cpms_t_account_service_water.pty_id is '客户号';
comment on column ${iol_schema}.cpms_t_account_service_water.pty_name is '客户名称';
comment on column ${iol_schema}.cpms_t_account_service_water.equi_id is '权益id';
comment on column ${iol_schema}.cpms_t_account_service_water.equi_name is '权益名称';
comment on column ${iol_schema}.cpms_t_account_service_water.rema_usab_equi_cnt is '剩余可用权益次数';
comment on column ${iol_schema}.cpms_t_account_service_water.equi_has_usage_cnt is '已使用权益次数';
comment on column ${iol_schema}.cpms_t_account_service_water.final_oper_pers is '最后操作人';
comment on column ${iol_schema}.cpms_t_account_service_water.val_st_dt is '有效开始日期';
comment on column ${iol_schema}.cpms_t_account_service_water.val_end_dt is '有效结束日期';
comment on column ${iol_schema}.cpms_t_account_service_water.source_name is '操作来源';
comment on column ${iol_schema}.cpms_t_account_service_water.water_date is '操作日期';
comment on column ${iol_schema}.cpms_t_account_service_water.transaction_num is '操作数值';
comment on column ${iol_schema}.cpms_t_account_service_water.start_dt is '开始时间';
comment on column ${iol_schema}.cpms_t_account_service_water.end_dt is '结束时间';
comment on column ${iol_schema}.cpms_t_account_service_water.id_mark is '增删标志';
comment on column ${iol_schema}.cpms_t_account_service_water.etl_timestamp is 'ETL处理时间戳';
