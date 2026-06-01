/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_antifraud_gung_cust_result_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_antifraud_gung_cust_result_info
whenever sqlerror continue none;
drop table ${iol_schema}.alss_antifraud_gung_cust_result_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_antifraud_gung_cust_result_info(
    id varchar2(1256) -- 
    ,map_number varchar2(120) -- 
    ,cust_id varchar2(50) -- 
    ,account varchar2(1000) -- 
    ,early_warning_date varchar2(200) -- 
    ,cust_risk_status varchar2(120) -- 
    ,deal_description varchar2(3750) -- 
    ,deal_result_text varchar2(150) -- 
    ,deal_user_name varchar2(81) -- 下发人
    ,create_time varchar2(30) -- 创建时间
    ,deal_result varchar2(50) -- 处理结果
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
grant select on ${iol_schema}.alss_antifraud_gung_cust_result_info to ${iml_schema};
grant select on ${iol_schema}.alss_antifraud_gung_cust_result_info to ${icl_schema};
grant select on ${iol_schema}.alss_antifraud_gung_cust_result_info to ${idl_schema};
grant select on ${iol_schema}.alss_antifraud_gung_cust_result_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_antifraud_gung_cust_result_info is '可疑团伙客户处置结果表';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.id is '';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.map_number is '';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.cust_id is '';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.account is '';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.early_warning_date is '';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.cust_risk_status is '';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.deal_description is '';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.deal_result_text is '';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.deal_user_name is '下发人';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.create_time is '创建时间';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.deal_result is '处理结果';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alss_antifraud_gung_cust_result_info.etl_timestamp is 'ETL处理时间戳';
