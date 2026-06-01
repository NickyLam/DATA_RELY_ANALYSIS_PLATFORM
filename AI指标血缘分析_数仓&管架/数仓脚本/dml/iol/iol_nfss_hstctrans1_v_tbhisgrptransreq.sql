/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_hstctrans1_v_tbhisgrptransreq
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
drop table ${iol_schema}.nfss_hstctrans1_v_tbhisgrptransreq_ex purge;
alter table ${iol_schema}.nfss_hstctrans1_v_tbhisgrptransreq add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.nfss_hstctrans1_v_tbhisgrptransreq;

-- 2.3 insert data to ex table
create table ${iol_schema}.nfss_hstctrans1_v_tbhisgrptransreq_ex nologging
compress
as
select * from ${iol_schema}.nfss_hstctrans1_v_tbhisgrptransreq where 0=1;

insert /*+ append */ into ${iol_schema}.nfss_hstctrans1_v_tbhisgrptransreq_ex(
    serial_no -- 
    ,ex_serial -- 
    ,contract_no -- 
    ,trans_date -- 
    ,trans_time -- 
    ,occur_init_date -- 
    ,in_client_no -- 
    ,virtual_bank_acc -- 
    ,trans_code -- 
    ,control_flag -- 
    ,branch_no -- 
    ,open_branch -- 
    ,client_type -- 
    ,id_type -- 
    ,id_code -- 
    ,bank_no -- 
    ,client_no -- 
    ,bank_acc -- 
    ,cash_flag -- 
    ,trans_account_type -- 
    ,trans_account -- 
    ,channel -- 
    ,term_no -- 
    ,oper_no -- 
    ,auth_oper -- 
    ,group_code -- 
    ,asso_date -- 
    ,asso_serial -- 
    ,asso_serial2 -- 
    ,asso_serial3 -- 
    ,amt -- 
    ,ori_channel -- 
    ,ori_branch_no -- 
    ,larg_red_flag -- 
    ,to_lcpt_serial -- 
    ,lcpt_check_date -- 
    ,lcpt_trans_code -- 
    ,lcpt_date -- 
    ,lcpt_serial -- 
    ,to_host_serial -- 
    ,host_check_date -- 
    ,ori_host_chk_date -- 
    ,host_trans_code -- 
    ,host_date -- 
    ,host_serial -- 
    ,liqu_status -- 
    ,client_manager -- 
    ,targ_bank_acc -- 
    ,err_code -- 
    ,err_msg -- 
    ,status -- 
    ,summary -- 
    ,debit_account -- 
    ,crebit_account -- 
    ,phy_date -- 
    ,model -- 
    ,reserve1 -- 
    ,reserve2 -- 
    ,reserve3 -- 
    ,reserve4 -- 
    ,reserve5 -- 
    ,amt1 -- 
    ,amt2 -- 
    ,amt3 -- 
    ,amt4 -- 
    ,amt5 -- 
    ,amt6 -- 
    ,double1 -- 
    ,double2 -- 
    ,double3 -- 
    ,double4 -- 
    ,double5 -- 
    ,reserve6 -- 
    ,reserve7 -- 
    ,reserve8 -- 
    ,redem_account -- 
    ,child_prd_codes -- 
    ,child_prd_rates -- 
    ,child_new_prd_rates -- 
    ,modify_timestamp -- 
    ,client_name -- 
    ,mobile -- 
    ,cfm_amt -- 
    ,cfm_date -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serial_no -- 
    ,ex_serial -- 
    ,contract_no -- 
    ,trans_date -- 
    ,trans_time -- 
    ,occur_init_date -- 
    ,in_client_no -- 
    ,virtual_bank_acc -- 
    ,trans_code -- 
    ,control_flag -- 
    ,branch_no -- 
    ,open_branch -- 
    ,client_type -- 
    ,id_type -- 
    ,id_code -- 
    ,bank_no -- 
    ,client_no -- 
    ,bank_acc -- 
    ,cash_flag -- 
    ,trans_account_type -- 
    ,trans_account -- 
    ,channel -- 
    ,term_no -- 
    ,oper_no -- 
    ,auth_oper -- 
    ,group_code -- 
    ,asso_date -- 
    ,asso_serial -- 
    ,asso_serial2 -- 
    ,asso_serial3 -- 
    ,amt -- 
    ,ori_channel -- 
    ,ori_branch_no -- 
    ,larg_red_flag -- 
    ,to_lcpt_serial -- 
    ,lcpt_check_date -- 
    ,lcpt_trans_code -- 
    ,lcpt_date -- 
    ,lcpt_serial -- 
    ,to_host_serial -- 
    ,host_check_date -- 
    ,ori_host_chk_date -- 
    ,host_trans_code -- 
    ,host_date -- 
    ,host_serial -- 
    ,liqu_status -- 
    ,client_manager -- 
    ,targ_bank_acc -- 
    ,err_code -- 
    ,err_msg -- 
    ,status -- 
    ,summary -- 
    ,debit_account -- 
    ,crebit_account -- 
    ,phy_date -- 
    ,model -- 
    ,reserve1 -- 
    ,reserve2 -- 
    ,reserve3 -- 
    ,reserve4 -- 
    ,reserve5 -- 
    ,amt1 -- 
    ,amt2 -- 
    ,amt3 -- 
    ,amt4 -- 
    ,amt5 -- 
    ,amt6 -- 
    ,double1 -- 
    ,double2 -- 
    ,double3 -- 
    ,double4 -- 
    ,double5 -- 
    ,reserve6 -- 
    ,reserve7 -- 
    ,reserve8 -- 
    ,redem_account -- 
    ,child_prd_codes -- 
    ,child_prd_rates -- 
    ,child_new_prd_rates -- 
    ,modify_timestamp -- 
    ,client_name -- 
    ,mobile -- 
    ,cfm_amt -- 
    ,cfm_date -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nfss_hstctrans1_v_tbhisgrptransreq
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nfss_hstctrans1_v_tbhisgrptransreq exchange partition p_${batch_date} with table ${iol_schema}.nfss_hstctrans1_v_tbhisgrptransreq_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_hstctrans1_v_tbhisgrptransreq to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nfss_hstctrans1_v_tbhisgrptransreq_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_hstctrans1_v_tbhisgrptransreq',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);