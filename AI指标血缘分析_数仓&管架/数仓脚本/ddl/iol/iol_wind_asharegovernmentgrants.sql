/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharegovernmentgrants
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharegovernmentgrants
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharegovernmentgrants purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharegovernmentgrants(
    object_id varchar2(57) -- 对象ID
    ,s_info_compcode varchar2(15) -- 公司ID
    ,report_period varchar2(12) -- 报告期
    ,item_name varchar2(750) -- 项目
    ,amount_current_issue number(20,4) -- 本期发生额
    ,amount_previous_period number(20,4) -- 上期发生额
    ,memo varchar2(3000) -- 说明
    ,currency_code varchar2(15) -- 货币代码
    ,ann_date varchar2(12) -- 公告日期
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
grant select on ${iol_schema}.wind_asharegovernmentgrants to ${iml_schema};
grant select on ${iol_schema}.wind_asharegovernmentgrants to ${icl_schema};
grant select on ${iol_schema}.wind_asharegovernmentgrants to ${idl_schema};
grant select on ${iol_schema}.wind_asharegovernmentgrants to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharegovernmentgrants is '中国A股政府补助明细';
comment on column ${iol_schema}.wind_asharegovernmentgrants.object_id is '对象ID';
comment on column ${iol_schema}.wind_asharegovernmentgrants.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_asharegovernmentgrants.report_period is '报告期';
comment on column ${iol_schema}.wind_asharegovernmentgrants.item_name is '项目';
comment on column ${iol_schema}.wind_asharegovernmentgrants.amount_current_issue is '本期发生额';
comment on column ${iol_schema}.wind_asharegovernmentgrants.amount_previous_period is '上期发生额';
comment on column ${iol_schema}.wind_asharegovernmentgrants.memo is '说明';
comment on column ${iol_schema}.wind_asharegovernmentgrants.currency_code is '货币代码';
comment on column ${iol_schema}.wind_asharegovernmentgrants.ann_date is '公告日期';
comment on column ${iol_schema}.wind_asharegovernmentgrants.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_asharegovernmentgrants.etl_timestamp is 'ETL处理时间戳';
