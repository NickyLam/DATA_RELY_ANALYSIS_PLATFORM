/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbhisfrozen
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbhisfrozen
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbhisfrozen purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbhisfrozen(
    frozen_serial varchar2(48) -- 
    ,frozen_date number(22,0) -- 
    ,cfm_date number(22,0) -- 
    ,frozen_cfm_no varchar2(48) -- 
    ,ta_code varchar2(18) -- 
    ,in_client_no varchar2(30) -- 
    ,bank_no varchar2(32) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(64) -- 
    ,asset_acc varchar2(30) -- 
    ,trans_code varchar2(32) -- 
    ,prd_code varchar2(32) -- 
    ,frozen_vol number(18,3) -- 
    ,frozen_cause varchar2(2) -- 
    ,end_date number(22,0) -- 
    ,frozen_branch varchar2(24) -- 
    ,org_name varchar2(300) -- 
    ,frozen_law_no varchar2(150) -- 
    ,unfrzn_law_no varchar2(75) -- 
    ,unfrozen_date number(22,0) -- 
    ,unfrozen_serial varchar2(48) -- 
    ,unfrozen_cfm_no varchar2(48) -- 
    ,status varchar2(2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,maturity_acc varchar2(48) -- 
    ,ori_frozen_vol number(18,2) -- 
    ,reserve3 varchar2(375) -- 
    ,reserve4 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbhisfrozen to ${iml_schema};
grant select on ${iol_schema}.ifms_tbhisfrozen to ${icl_schema};
grant select on ${iol_schema}.ifms_tbhisfrozen to ${idl_schema};
grant select on ${iol_schema}.ifms_tbhisfrozen to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbhisfrozen is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.frozen_serial is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.frozen_date is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.cfm_date is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.frozen_cfm_no is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.ta_code is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.in_client_no is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.bank_no is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.client_no is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.bank_acc is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.asset_acc is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.trans_code is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.prd_code is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.frozen_vol is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.frozen_cause is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.end_date is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.frozen_branch is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.org_name is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.frozen_law_no is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.unfrzn_law_no is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.unfrozen_date is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.unfrozen_serial is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.unfrozen_cfm_no is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.status is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.reserve1 is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.reserve2 is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.maturity_acc is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.ori_frozen_vol is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.reserve3 is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.reserve4 is '';
comment on column ${iol_schema}.ifms_tbhisfrozen.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbhisfrozen.etl_timestamp is 'ETL处理时间戳';
