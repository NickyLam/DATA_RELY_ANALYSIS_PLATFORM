/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbhisdivdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbhisdivdetail
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbhisdivdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbhisdivdetail(
    ta_code varchar2(18) -- 
    ,cfm_date number(22) -- 
    ,cfm_no varchar2(48) -- 
    ,busin_code varchar2(9) -- 
    ,branch_no varchar2(24) -- 
    ,open_branch varchar2(80) -- 
    ,in_client_no varchar2(30) -- 
    ,client_type varchar2(2) -- 
    ,asset_acc varchar2(30) -- 
    ,bank_no varchar2(32) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(64) -- 
    ,ta_client varchar2(48) -- 
    ,prd_code varchar2(32) -- 
    ,tot_vol number(18,3) -- 
    ,div_per_unit number(18,8) -- 
    ,div_mode varchar2(2) -- 
    ,tot_div_amt number(18,2) -- 
    ,curr_type varchar2(5) -- 
    ,cfm_amt number(18,2) -- 
    ,nav number(18,8) -- 
    ,div_vol number(18,3) -- 
    ,frozen_amt number(18,2) -- 
    ,frozen_vol number(18,3) -- 
    ,charge number(18,2) -- 
    ,agency_fee number(18,2) -- 
    ,stamp_tax number(18,2) -- 
    ,other_fee1 number(18,2) -- 
    ,other_fee2 number(18,2) -- 
    ,vol_cumulate number(18,3) -- 
    ,reg_date number(22) -- 
    ,div_date number(22) -- 
    ,xr_date number(22) -- 
    ,post_vol number(18,3) -- 
    ,amt1 number(18,2) -- 
    ,amt2 number(18,2) -- 
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
grant select on ${iol_schema}.ifms_tbhisdivdetail to ${iml_schema};
grant select on ${iol_schema}.ifms_tbhisdivdetail to ${icl_schema};
grant select on ${iol_schema}.ifms_tbhisdivdetail to ${idl_schema};
grant select on ${iol_schema}.ifms_tbhisdivdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbhisdivdetail is '分红明细历史表';
comment on column ${iol_schema}.ifms_tbhisdivdetail.ta_code is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.cfm_date is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.cfm_no is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.busin_code is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.branch_no is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.open_branch is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.in_client_no is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.client_type is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.asset_acc is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.bank_no is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.client_no is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.bank_acc is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.ta_client is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.prd_code is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.tot_vol is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.div_per_unit is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.div_mode is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.tot_div_amt is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.curr_type is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.cfm_amt is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.nav is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.div_vol is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.frozen_amt is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.frozen_vol is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.charge is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.agency_fee is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.stamp_tax is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.other_fee1 is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.other_fee2 is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.vol_cumulate is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.reg_date is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.div_date is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.xr_date is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.post_vol is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.amt1 is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.amt2 is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.reserve1 is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.reserve2 is '';
comment on column ${iol_schema}.ifms_tbhisdivdetail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbhisdivdetail.etl_timestamp is 'ETL处理时间戳';
