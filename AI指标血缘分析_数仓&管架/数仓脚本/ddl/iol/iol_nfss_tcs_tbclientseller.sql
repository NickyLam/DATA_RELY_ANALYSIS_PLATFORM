/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tcs_tbclientseller
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tcs_tbclientseller
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tcs_tbclientseller purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbclientseller(
    in_client_no varchar2(30) -- 
    ,bank_no varchar2(3) -- 
    ,client_no varchar2(36) -- 
    ,seller_code varchar2(14) -- 
    ,open_date number(22,0) -- 
    ,close_date number(22,0) -- 
    ,ta_client varchar2(30) -- 
    ,status varchar2(2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
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
grant select on ${iol_schema}.nfss_tcs_tbclientseller to ${iml_schema};
grant select on ${iol_schema}.nfss_tcs_tbclientseller to ${icl_schema};
grant select on ${iol_schema}.nfss_tcs_tbclientseller to ${idl_schema};
grant select on ${iol_schema}.nfss_tcs_tbclientseller to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tcs_tbclientseller is '客户销售商信息';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.in_client_no is '';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.bank_no is '';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.client_no is '';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.seller_code is '';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.open_date is '';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.close_date is '';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.ta_client is '';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.status is '';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.reserve1 is '';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.reserve2 is '';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tcs_tbclientseller.etl_timestamp is 'ETL处理时间戳';
