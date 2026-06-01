/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alms_rp_alm_rrs_1104_report_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alms_rp_alm_rrs_1104_report_result
whenever sqlerror continue none;
drop table ${iol_schema}.alms_rp_alm_rrs_1104_report_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alms_rp_alm_rrs_1104_report_result(
    data_rpt_date varchar2(8) -- 
    ,data_rpt_no varchar2(64) -- 
    ,data_rpt_desc varchar2(640) -- 
    ,data_line_no varchar2(64) -- 
    ,data_line_desc varchar2(640) -- 
    ,data_val1 varchar2(64) -- 
    ,data_val2 varchar2(64) -- 
    ,data_val3 varchar2(64) -- 
    ,data_val4 varchar2(64) -- 
    ,data_val5 varchar2(64) -- 
    ,data_val6 varchar2(64) -- 
    ,data_val7 varchar2(64) -- 
    ,data_val8 varchar2(64) -- 
    ,data_val9 varchar2(64) -- 
    ,data_val10 varchar2(64) -- 
    ,data_val11 varchar2(64) -- 
    ,data_val12 varchar2(64) -- 
    ,data_val13 varchar2(64) -- 
    ,data_val14 varchar2(64) -- 
    ,data_val15 varchar2(64) -- 
    ,data_val16 varchar2(64) -- 
    ,data_val17 varchar2(64) -- 
    ,data_val18 varchar2(64) -- 
    ,data_val19 varchar2(64) -- 
    ,data_val20 varchar2(64) -- 
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
grant select on ${iol_schema}.alms_rp_alm_rrs_1104_report_result to ${iml_schema};
grant select on ${iol_schema}.alms_rp_alm_rrs_1104_report_result to ${icl_schema};
grant select on ${iol_schema}.alms_rp_alm_rrs_1104_report_result to ${idl_schema};
grant select on ${iol_schema}.alms_rp_alm_rrs_1104_report_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.alms_rp_alm_rrs_1104_report_result is '资债系统1104法人报表报送落地数据表';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_rpt_date is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_rpt_no is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_rpt_desc is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_line_no is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_line_desc is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val1 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val2 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val3 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val4 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val5 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val6 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val7 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val8 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val9 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val10 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val11 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val12 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val13 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val14 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val15 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val16 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val17 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val18 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val19 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.data_val20 is '';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alms_rp_alm_rrs_1104_report_result.etl_timestamp is 'ETL处理时间戳';
