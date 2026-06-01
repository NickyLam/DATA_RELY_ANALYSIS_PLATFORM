/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbtranscfm
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbtranscfm_ex purge;
alter table ${iol_schema}.ifms_tbtranscfm add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifms_tbtranscfm truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifms_tbtranscfm_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbtranscfm where 0=1;

insert /*+ append */ into ${iol_schema}.ifms_tbtranscfm_ex(
    ta_code -- 
    ,cfm_date -- 
    ,cfm_no -- 
    ,ori_cfm_no -- 
    ,from_flag -- 
    ,trans_date -- 
    ,trans_time -- 
    ,clear_date -- 
    ,serial_no -- 
    ,trans_code -- 
    ,busin_code -- 
    ,branch_no -- 
    ,open_branch -- 
    ,channel -- 
    ,term_no -- 
    ,oper_no -- 
    ,in_client_no -- 
    ,client_type -- 
    ,asset_acc -- 
    ,bank_no -- 
    ,client_no -- 
    ,client_name -- 
    ,bank_acc -- 
    ,ta_client -- 
    ,trans_account_type -- 
    ,trans_account -- 
    ,cash_flag -- 
    ,prd_code -- 
    ,share_class -- 
    ,nav -- 
    ,price -- 
    ,amt -- 
    ,curr_type -- 
    ,cfm_amt -- 
    ,vol -- 
    ,cfm_vol -- 
    ,larg_red_flag -- 
    ,red_cause -- 
    ,agio -- 
    ,tot_fee -- 
    ,charge -- 
    ,stamp_tax -- 
    ,interest_tax -- 
    ,transfer_fee -- 
    ,agency_fee -- 
    ,back_fee -- 
    ,other_fee1 -- 
    ,other_fee2 -- 
    ,cfm_income -- 
    ,manage_fee -- 
    ,cont_frozen_amt -- 
    ,vol_cumulate -- 
    ,detail_flag -- 
    ,finish_flag -- 
    ,frozen_cause -- 
    ,conv_dir -- 
    ,targ_prd_code -- 
    ,targ_nav -- 
    ,targ_price -- 
    ,targ_cfm_vol -- 
    ,targ_seller_code -- 
    ,targ_branch -- 
    ,targ_asset_acc -- 
    ,targ_bank_acc -- 
    ,interest -- 
    ,vol_of_int -- 
    ,div_mode -- 
    ,div_rate -- 
    ,summary -- 
    ,err_code -- 
    ,err_msg -- 
    ,status -- 
    ,client_manager -- 
    ,asso_date -- 
    ,asso_serial -- 
    ,bank_charge -- 
    ,ex_serial -- 
    ,contract_no -- 
    ,manage_charge -- 
    ,host_trans_code -- 
    ,host_date -- 
    ,host_serial -- 
    ,post_vol -- 
    ,amt1 -- 
    ,amt2 -- 
    ,amt3 -- 
    ,reserve1 -- 
    ,reserve2 -- 
    ,reserve3 -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ta_code -- 
    ,cfm_date -- 
    ,cfm_no -- 
    ,ori_cfm_no -- 
    ,from_flag -- 
    ,trans_date -- 
    ,trans_time -- 
    ,clear_date -- 
    ,serial_no -- 
    ,trans_code -- 
    ,busin_code -- 
    ,branch_no -- 
    ,open_branch -- 
    ,channel -- 
    ,term_no -- 
    ,oper_no -- 
    ,in_client_no -- 
    ,client_type -- 
    ,asset_acc -- 
    ,bank_no -- 
    ,client_no -- 
    ,client_name -- 
    ,bank_acc -- 
    ,ta_client -- 
    ,trans_account_type -- 
    ,trans_account -- 
    ,cash_flag -- 
    ,prd_code -- 
    ,share_class -- 
    ,nav -- 
    ,price -- 
    ,amt -- 
    ,curr_type -- 
    ,cfm_amt -- 
    ,vol -- 
    ,cfm_vol -- 
    ,larg_red_flag -- 
    ,red_cause -- 
    ,agio -- 
    ,tot_fee -- 
    ,charge -- 
    ,stamp_tax -- 
    ,interest_tax -- 
    ,transfer_fee -- 
    ,agency_fee -- 
    ,back_fee -- 
    ,other_fee1 -- 
    ,other_fee2 -- 
    ,cfm_income -- 
    ,manage_fee -- 
    ,cont_frozen_amt -- 
    ,vol_cumulate -- 
    ,detail_flag -- 
    ,finish_flag -- 
    ,frozen_cause -- 
    ,conv_dir -- 
    ,targ_prd_code -- 
    ,targ_nav -- 
    ,targ_price -- 
    ,targ_cfm_vol -- 
    ,targ_seller_code -- 
    ,targ_branch -- 
    ,targ_asset_acc -- 
    ,targ_bank_acc -- 
    ,interest -- 
    ,vol_of_int -- 
    ,div_mode -- 
    ,div_rate -- 
    ,summary -- 
    ,err_code -- 
    ,err_msg -- 
    ,status -- 
    ,client_manager -- 
    ,asso_date -- 
    ,asso_serial -- 
    ,bank_charge -- 
    ,ex_serial -- 
    ,contract_no -- 
    ,manage_charge -- 
    ,host_trans_code -- 
    ,host_date -- 
    ,host_serial -- 
    ,post_vol -- 
    ,amt1 -- 
    ,amt2 -- 
    ,amt3 -- 
    ,reserve1 -- 
    ,reserve2 -- 
    ,reserve3 -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifms_tbtranscfm
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifms_tbtranscfm exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbtranscfm_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbtranscfm to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifms_tbtranscfm_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbtranscfm',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);