/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbdivdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbdivdetail
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbdivdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbdivdetail(
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
grant select on ${iol_schema}.ifms_tbdivdetail to ${iml_schema};
grant select on ${iol_schema}.ifms_tbdivdetail to ${icl_schema};
grant select on ${iol_schema}.ifms_tbdivdetail to ${idl_schema};
grant select on ${iol_schema}.ifms_tbdivdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbdivdetail is '';
comment on column ${iol_schema}.ifms_tbdivdetail.ta_code is '';
comment on column ${iol_schema}.ifms_tbdivdetail.cfm_date is '';
comment on column ${iol_schema}.ifms_tbdivdetail.cfm_no is '';
comment on column ${iol_schema}.ifms_tbdivdetail.busin_code is '';
comment on column ${iol_schema}.ifms_tbdivdetail.branch_no is '';
comment on column ${iol_schema}.ifms_tbdivdetail.open_branch is '';
comment on column ${iol_schema}.ifms_tbdivdetail.in_client_no is '';
comment on column ${iol_schema}.ifms_tbdivdetail.client_type is '';
comment on column ${iol_schema}.ifms_tbdivdetail.asset_acc is '';
comment on column ${iol_schema}.ifms_tbdivdetail.bank_no is '';
comment on column ${iol_schema}.ifms_tbdivdetail.client_no is '';
comment on column ${iol_schema}.ifms_tbdivdetail.bank_acc is '';
comment on column ${iol_schema}.ifms_tbdivdetail.ta_client is '';
comment on column ${iol_schema}.ifms_tbdivdetail.prd_code is '';
comment on column ${iol_schema}.ifms_tbdivdetail.tot_vol is '';
comment on column ${iol_schema}.ifms_tbdivdetail.div_per_unit is '';
comment on column ${iol_schema}.ifms_tbdivdetail.div_mode is '';
comment on column ${iol_schema}.ifms_tbdivdetail.tot_div_amt is '';
comment on column ${iol_schema}.ifms_tbdivdetail.curr_type is '';
comment on column ${iol_schema}.ifms_tbdivdetail.cfm_amt is '';
comment on column ${iol_schema}.ifms_tbdivdetail.nav is '';
comment on column ${iol_schema}.ifms_tbdivdetail.div_vol is '';
comment on column ${iol_schema}.ifms_tbdivdetail.frozen_amt is '';
comment on column ${iol_schema}.ifms_tbdivdetail.frozen_vol is '';
comment on column ${iol_schema}.ifms_tbdivdetail.charge is '';
comment on column ${iol_schema}.ifms_tbdivdetail.agency_fee is '';
comment on column ${iol_schema}.ifms_tbdivdetail.stamp_tax is '';
comment on column ${iol_schema}.ifms_tbdivdetail.other_fee1 is '';
comment on column ${iol_schema}.ifms_tbdivdetail.other_fee2 is '';
comment on column ${iol_schema}.ifms_tbdivdetail.vol_cumulate is '';
comment on column ${iol_schema}.ifms_tbdivdetail.reg_date is '';
comment on column ${iol_schema}.ifms_tbdivdetail.div_date is '';
comment on column ${iol_schema}.ifms_tbdivdetail.xr_date is '';
comment on column ${iol_schema}.ifms_tbdivdetail.post_vol is '';
comment on column ${iol_schema}.ifms_tbdivdetail.amt1 is '';
comment on column ${iol_schema}.ifms_tbdivdetail.amt2 is '';
comment on column ${iol_schema}.ifms_tbdivdetail.reserve1 is '';
comment on column ${iol_schema}.ifms_tbdivdetail.reserve2 is '';
comment on column ${iol_schema}.ifms_tbdivdetail.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbdivdetail.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbdivdetail.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbdivdetail.etl_timestamp is 'ETL处理时间戳';
