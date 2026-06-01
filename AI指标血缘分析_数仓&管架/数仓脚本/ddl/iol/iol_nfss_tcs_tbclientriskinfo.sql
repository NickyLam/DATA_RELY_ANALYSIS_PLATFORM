/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tcs_tbclientriskinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tcs_tbclientriskinfo
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tcs_tbclientriskinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbclientriskinfo(
    in_client_no varchar2(30) -- 
    ,prd_type varchar2(2) -- 
    ,high_risk_flag varchar2(2) -- 
    ,risk_counter_flag varchar2(2) -- 
    ,risk_level number(22,0) -- 
    ,risk_date number(22,0) -- 
    ,last_modify_date number(22,0) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
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
grant select on ${iol_schema}.nfss_tcs_tbclientriskinfo to ${iml_schema};
grant select on ${iol_schema}.nfss_tcs_tbclientriskinfo to ${icl_schema};
grant select on ${iol_schema}.nfss_tcs_tbclientriskinfo to ${idl_schema};
grant select on ${iol_schema}.nfss_tcs_tbclientriskinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tcs_tbclientriskinfo is '客户风险评估结果表';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.in_client_no is '';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.prd_type is '';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.high_risk_flag is '';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.risk_counter_flag is '';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.risk_level is '';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.risk_date is '';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.last_modify_date is '';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.reserve1 is '';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.reserve2 is '';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.reserve3 is '';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tcs_tbclientriskinfo.etl_timestamp is 'ETL处理时间戳';
