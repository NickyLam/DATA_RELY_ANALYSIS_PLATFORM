/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_trpt_fund_position_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_trpt_fund_position_record
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_trpt_fund_position_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_trpt_fund_position_record(
    obj_id varchar2(45) -- 核算对象
    ,beg_date varchar2(15) -- 基金阶段开仓日期
    ,end_date varchar2(15) -- 基金阶段全部赎回日期
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
grant select on ${iol_schema}.ibms_trpt_fund_position_record to ${iml_schema};
grant select on ${iol_schema}.ibms_trpt_fund_position_record to ${icl_schema};
grant select on ${iol_schema}.ibms_trpt_fund_position_record to ${idl_schema};
grant select on ${iol_schema}.ibms_trpt_fund_position_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_trpt_fund_position_record is '基金持仓记录表';
comment on column ${iol_schema}.ibms_trpt_fund_position_record.obj_id is '核算对象';
comment on column ${iol_schema}.ibms_trpt_fund_position_record.beg_date is '基金阶段开仓日期';
comment on column ${iol_schema}.ibms_trpt_fund_position_record.end_date is '基金阶段全部赎回日期';
comment on column ${iol_schema}.ibms_trpt_fund_position_record.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_trpt_fund_position_record.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_trpt_fund_position_record.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_trpt_fund_position_record.etl_timestamp is 'ETL处理时间戳';
