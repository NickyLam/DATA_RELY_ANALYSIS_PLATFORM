/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_hep_house_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_hep_house_detail
whenever sqlerror continue none;
drop table ${iol_schema}.heps_hep_house_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_hep_house_detail(
    id number(22) -- id
    ,flow_id varchar2(32) -- 业务流水号
    ,status varchar2(32) -- 状态
    ,question_id number(22) -- 问题id序号
    ,question varchar2(128) -- 问题
    ,answer varchar2(128) -- 答案
    ,customer_manager_id number(22) -- 客户经理号
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
grant select on ${iol_schema}.heps_hep_house_detail to ${iml_schema};
grant select on ${iol_schema}.heps_hep_house_detail to ${icl_schema};
grant select on ${iol_schema}.heps_hep_house_detail to ${idl_schema};
grant select on ${iol_schema}.heps_hep_house_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_hep_house_detail is '房屋信息问题调查信息表';
comment on column ${iol_schema}.heps_hep_house_detail.id is 'id';
comment on column ${iol_schema}.heps_hep_house_detail.flow_id is '业务流水号';
comment on column ${iol_schema}.heps_hep_house_detail.status is '状态';
comment on column ${iol_schema}.heps_hep_house_detail.question_id is '问题id序号';
comment on column ${iol_schema}.heps_hep_house_detail.question is '问题';
comment on column ${iol_schema}.heps_hep_house_detail.answer is '答案';
comment on column ${iol_schema}.heps_hep_house_detail.customer_manager_id is '客户经理号';
comment on column ${iol_schema}.heps_hep_house_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_hep_house_detail.etl_timestamp is 'ETL处理时间戳';
