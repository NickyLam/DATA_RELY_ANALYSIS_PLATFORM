/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbtatransreq
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
drop table ${iol_schema}.ifms_tbtatransreq_ex purge;
alter table ${iol_schema}.ifms_tbtatransreq add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifms_tbtatransreq truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifms_tbtatransreq_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbtatransreq where 0=1;

insert /*+ append */ into ${iol_schema}.ifms_tbtatransreq_ex(
    busin_code -- 
    ,trans_date -- 
    ,trans_time -- 
    ,serial_no -- 
    ,seller_code -- 
    ,branch_no -- 
    ,asset_acc -- 
    ,ta_client -- 
    ,prd_code -- 
    ,share_class -- 
    ,amt -- 
    ,vol -- 
    ,tot_fee -- 
    ,targ_prd_code -- 
    ,targ_share_class -- 
    ,targ_asset_acc -- 
    ,targ_ta_client -- 
    ,targ_seller_code -- 
    ,targ_net_no -- 
    ,ori_cfm_date -- 
    ,ori_serial_no -- 
    ,ori_cfm_no -- 
    ,larg_red_flag -- 
    ,hope_date -- 
    ,agio -- 
    ,div_mode -- 
    ,frozen_cause -- 
    ,frozen_end_date -- 
    ,frozen_law_no -- 
    ,unfroze_law_no -- 
    ,ta_flag -- 
    ,out_busin_code -- 
    ,man_flag -- 
    ,client_type -- 
    ,in_client_no -- 
    ,last_cfm_date -- 
    ,status -- 
    ,cfm_amt -- 
    ,cfm_vol -- 
    ,ori_agio -- 
    ,cfm_rate -- 
    ,rule_agio -- 
    ,broker -- 
    ,nodeal_flag -- 
    ,price -- 
    ,targ_price -- 
    ,ch_vol -- 
    ,channel -- 
    ,transfer_cause -- 
    ,first_cfm_date -- 
    ,income -- 
    ,back_agio -- 
    ,bank_no -- 
    ,client_rate -- 
    ,client_group -- 
    ,red_mode -- 
    ,manager_agio -- 
    ,real_flag -- 
    ,err_code -- 
    ,err_msg -- 
    ,amt1 -- 
    ,amt2 -- 
    ,reserve1 -- 
    ,reserve2 -- 
    ,reserve3 -- 
    ,reserve4 -- 
    ,reserve5 -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    busin_code -- 
    ,trans_date -- 
    ,trans_time -- 
    ,serial_no -- 
    ,seller_code -- 
    ,branch_no -- 
    ,asset_acc -- 
    ,ta_client -- 
    ,prd_code -- 
    ,share_class -- 
    ,amt -- 
    ,vol -- 
    ,tot_fee -- 
    ,targ_prd_code -- 
    ,targ_share_class -- 
    ,targ_asset_acc -- 
    ,targ_ta_client -- 
    ,targ_seller_code -- 
    ,targ_net_no -- 
    ,ori_cfm_date -- 
    ,ori_serial_no -- 
    ,ori_cfm_no -- 
    ,larg_red_flag -- 
    ,hope_date -- 
    ,agio -- 
    ,div_mode -- 
    ,frozen_cause -- 
    ,frozen_end_date -- 
    ,frozen_law_no -- 
    ,unfroze_law_no -- 
    ,ta_flag -- 
    ,out_busin_code -- 
    ,man_flag -- 
    ,client_type -- 
    ,in_client_no -- 
    ,last_cfm_date -- 
    ,status -- 
    ,cfm_amt -- 
    ,cfm_vol -- 
    ,ori_agio -- 
    ,cfm_rate -- 
    ,rule_agio -- 
    ,broker -- 
    ,nodeal_flag -- 
    ,price -- 
    ,targ_price -- 
    ,ch_vol -- 
    ,channel -- 
    ,transfer_cause -- 
    ,first_cfm_date -- 
    ,income -- 
    ,back_agio -- 
    ,bank_no -- 
    ,client_rate -- 
    ,client_group -- 
    ,red_mode -- 
    ,manager_agio -- 
    ,real_flag -- 
    ,err_code -- 
    ,err_msg -- 
    ,amt1 -- 
    ,amt2 -- 
    ,reserve1 -- 
    ,reserve2 -- 
    ,reserve3 -- 
    ,reserve4 -- 
    ,reserve5 -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifms_tbtatransreq
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifms_tbtatransreq exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbtatransreq_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbtatransreq to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifms_tbtatransreq_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbtatransreq',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);