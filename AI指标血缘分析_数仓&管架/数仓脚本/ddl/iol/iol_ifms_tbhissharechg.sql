/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbhissharechg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbhissharechg
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbhissharechg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbhissharechg(
    cfm_date number(22) -- 
    ,seller_code varchar2(14) -- 
    ,ta_code varchar2(18) -- 
    ,cfm_no varchar2(48) -- 
    ,busin_code varchar2(9) -- 
    ,trans_date number(22) -- 
    ,serial_no varchar2(48) -- 
    ,prd_code varchar2(32) -- 
    ,in_client_no varchar2(30) -- 
    ,asset_acc varchar2(30) -- 
    ,bank_no varchar2(32) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(64) -- 
    ,ta_client varchar2(48) -- 
    ,vol number(18,3) -- 
    ,amt number(18,2) -- 
    ,frozen_vol number(18,3) -- 
    ,last_vol number(18,3) -- 
    ,last_frozen_vol number(18,3) -- 
    ,gain_income number(18,2) -- 
    ,div_mode varchar2(2) -- 
    ,summary varchar2(375) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbhissharechg to ${iml_schema};
grant select on ${iol_schema}.ifms_tbhissharechg to ${icl_schema};
grant select on ${iol_schema}.ifms_tbhissharechg to ${idl_schema};
grant select on ${iol_schema}.ifms_tbhissharechg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbhissharechg is '份额变动历史流水表';
comment on column ${iol_schema}.ifms_tbhissharechg.cfm_date is '';
comment on column ${iol_schema}.ifms_tbhissharechg.seller_code is '';
comment on column ${iol_schema}.ifms_tbhissharechg.ta_code is '';
comment on column ${iol_schema}.ifms_tbhissharechg.cfm_no is '';
comment on column ${iol_schema}.ifms_tbhissharechg.busin_code is '';
comment on column ${iol_schema}.ifms_tbhissharechg.trans_date is '';
comment on column ${iol_schema}.ifms_tbhissharechg.serial_no is '';
comment on column ${iol_schema}.ifms_tbhissharechg.prd_code is '';
comment on column ${iol_schema}.ifms_tbhissharechg.in_client_no is '';
comment on column ${iol_schema}.ifms_tbhissharechg.asset_acc is '';
comment on column ${iol_schema}.ifms_tbhissharechg.bank_no is '';
comment on column ${iol_schema}.ifms_tbhissharechg.client_no is '';
comment on column ${iol_schema}.ifms_tbhissharechg.bank_acc is '';
comment on column ${iol_schema}.ifms_tbhissharechg.ta_client is '';
comment on column ${iol_schema}.ifms_tbhissharechg.vol is '';
comment on column ${iol_schema}.ifms_tbhissharechg.amt is '';
comment on column ${iol_schema}.ifms_tbhissharechg.frozen_vol is '';
comment on column ${iol_schema}.ifms_tbhissharechg.last_vol is '';
comment on column ${iol_schema}.ifms_tbhissharechg.last_frozen_vol is '';
comment on column ${iol_schema}.ifms_tbhissharechg.gain_income is '';
comment on column ${iol_schema}.ifms_tbhissharechg.div_mode is '';
comment on column ${iol_schema}.ifms_tbhissharechg.summary is '';
comment on column ${iol_schema}.ifms_tbhissharechg.reserve1 is '';
comment on column ${iol_schema}.ifms_tbhissharechg.reserve2 is '';
comment on column ${iol_schema}.ifms_tbhissharechg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbhissharechg.etl_timestamp is 'ETL处理时间戳';
