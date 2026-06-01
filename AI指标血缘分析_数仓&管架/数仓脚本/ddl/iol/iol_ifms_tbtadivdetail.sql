/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbtadivdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbtadivdetail
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbtadivdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbtadivdetail(
    cfm_date number(22) -- 
    ,cfm_no varchar2(48) -- 
    ,reg_date number(22) -- 
    ,bonus_type varchar2(2) -- 
    ,down_flag varchar2(2) -- 
    ,down_date number(22) -- 
    ,asset_acc varchar2(30) -- 
    ,ta_client varchar2(30) -- 
    ,prd_code varchar2(30) -- 
    ,share_class varchar2(2) -- 
    ,seller_code varchar2(14) -- 
    ,total_vol number(18,3) -- 
    ,unit_profit number(18,8) -- 
    ,total_profit number(18,2) -- 
    ,branch_income number(18,2) -- 
    ,tax number(18,2) -- 
    ,div_mode varchar2(2) -- 
    ,real_amt number(18,2) -- 
    ,reinvest_amt number(18,2) -- 
    ,reinvest_vol number(18,3) -- 
    ,trade_fee number(18,2) -- 
    ,reinvest_date number(22) -- 
    ,reinvest_nav number(9,6) -- 
    ,frozen_amt number(18,2) -- 
    ,frozen_vol number(18,3) -- 
    ,income_tax_rate number(5,4) -- 
    ,trans_date number(22) -- 
    ,manager_fee number(18,2) -- 
    ,shares_add number(18,3) -- 
    ,delay_cause varchar2(2) -- 
    ,frozen_no varchar2(48) -- 
    ,send_date number(22) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbtadivdetail to ${iml_schema};
grant select on ${iol_schema}.ifms_tbtadivdetail to ${icl_schema};
grant select on ${iol_schema}.ifms_tbtadivdetail to ${idl_schema};
grant select on ${iol_schema}.ifms_tbtadivdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbtadivdetail is '产品分红明细';
comment on column ${iol_schema}.ifms_tbtadivdetail.cfm_date is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.cfm_no is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.reg_date is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.bonus_type is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.down_flag is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.down_date is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.asset_acc is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.ta_client is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.prd_code is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.share_class is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.seller_code is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.total_vol is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.unit_profit is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.total_profit is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.branch_income is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.tax is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.div_mode is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.real_amt is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.reinvest_amt is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.reinvest_vol is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.trade_fee is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.reinvest_date is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.reinvest_nav is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.frozen_amt is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.frozen_vol is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.income_tax_rate is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.trans_date is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.manager_fee is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.shares_add is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.delay_cause is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.frozen_no is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.send_date is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.reserve1 is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.reserve2 is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.reserve3 is '';
comment on column ${iol_schema}.ifms_tbtadivdetail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tbtadivdetail.etl_timestamp is 'ETL处理时间戳';
