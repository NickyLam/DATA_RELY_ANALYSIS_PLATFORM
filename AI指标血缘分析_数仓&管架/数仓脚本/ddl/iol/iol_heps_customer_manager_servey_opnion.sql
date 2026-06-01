/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_customer_manager_servey_opnion
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_customer_manager_servey_opnion
whenever sqlerror continue none;
drop table ${iol_schema}.heps_customer_manager_servey_opnion purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_customer_manager_servey_opnion(
    id number -- id
    ,customer_id number(22) -- 顾客id
    ,flow_id varchar2(64) -- 业务id
    ,status number(22) -- 状态
    ,create_time varchar2(32) -- 创建时间
    ,customer_manager_id number(22) -- 客户经理号
    ,question_id number(22) -- 问题id
    ,question varchar2(128) -- 问题
    ,result varchar2(128) -- 答案
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.heps_customer_manager_servey_opnion to ${iml_schema};
grant select on ${iol_schema}.heps_customer_manager_servey_opnion to ${icl_schema};
grant select on ${iol_schema}.heps_customer_manager_servey_opnion to ${idl_schema};
grant select on ${iol_schema}.heps_customer_manager_servey_opnion to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_customer_manager_servey_opnion is '客户经理问题调查信息表';
comment on column ${iol_schema}.heps_customer_manager_servey_opnion.id is 'id';
comment on column ${iol_schema}.heps_customer_manager_servey_opnion.customer_id is '顾客id';
comment on column ${iol_schema}.heps_customer_manager_servey_opnion.flow_id is '业务id';
comment on column ${iol_schema}.heps_customer_manager_servey_opnion.status is '状态';
comment on column ${iol_schema}.heps_customer_manager_servey_opnion.create_time is '创建时间';
comment on column ${iol_schema}.heps_customer_manager_servey_opnion.customer_manager_id is '客户经理号';
comment on column ${iol_schema}.heps_customer_manager_servey_opnion.question_id is '问题id';
comment on column ${iol_schema}.heps_customer_manager_servey_opnion.question is '问题';
comment on column ${iol_schema}.heps_customer_manager_servey_opnion.result is '答案';
comment on column ${iol_schema}.heps_customer_manager_servey_opnion.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_customer_manager_servey_opnion.etl_timestamp is 'ETL处理时间戳';
