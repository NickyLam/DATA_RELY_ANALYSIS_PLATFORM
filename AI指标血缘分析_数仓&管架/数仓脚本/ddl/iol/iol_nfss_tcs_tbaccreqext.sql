/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tcs_tbaccreqext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tcs_tbaccreqext
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tcs_tbaccreqext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbaccreqext(
    serial_no varchar2(48) -- 
    ,ex_serial varchar2(48) -- 
    ,cfm_no varchar2(48) -- 
    ,trans_date number(22) -- 
    ,trans_time number(22) -- 
    ,ta_code varchar2(14) -- 
    ,in_client_no varchar2(30) -- 
    ,glblsrlno varchar2(60) -- 
    ,cnsmrsysid varchar2(48) -- 
    ,cnltxncd varchar2(96) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
    ,reserve5 varchar2(375) -- 
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
grant select on ${iol_schema}.nfss_tcs_tbaccreqext to ${iml_schema};
grant select on ${iol_schema}.nfss_tcs_tbaccreqext to ${icl_schema};
grant select on ${iol_schema}.nfss_tcs_tbaccreqext to ${idl_schema};
grant select on ${iol_schema}.nfss_tcs_tbaccreqext to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tcs_tbaccreqext is '账户类请求流水扩展表';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.serial_no is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.ex_serial is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.cfm_no is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.trans_date is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.trans_time is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.ta_code is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.in_client_no is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.glblsrlno is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.cnsmrsysid is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.cnltxncd is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.reserve1 is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.reserve2 is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.reserve3 is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.reserve4 is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.reserve5 is '';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tcs_tbaccreqext.etl_timestamp is 'ETL处理时间戳';
