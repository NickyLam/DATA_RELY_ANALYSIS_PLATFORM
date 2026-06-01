/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_upps_t_txn_credit
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--数仓供的增量，所以ITL层要存放历史
--alter table ${itl_schema}.itl_edw_upps_t_txn_credit drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_upps_t_txn_credit drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_upps_t_txn_credit add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_upps_t_txn_credit partition for (to_date('${batch_date}','yyyymmdd')) (
    id -- 
    ,global_no -- 
    ,txn_no -- 
    ,txn_date -- 
    ,txn_time -- 
    ,txn_type -- 
    ,corporate -- 
    ,mcht_no -- 
    ,product_no -- 
    ,tran_no -- 
    ,tran_date -- 
    ,tran_time -- 
    ,status -- 
    ,biz_status -- 
    ,trade_type -- 
    ,route_type -- 
    ,priority -- 
    ,work_date -- 
    ,amount -- 
    ,currency -- 
    ,payee_acct_no -- 
    ,payee_acct_name -- 
    ,payee_acct_type -- 
    ,payee_host_type -- 
    ,payee_bank_code -- 
    ,payer_acct_no -- 
    ,payer_acct_name -- 
    ,payer_acct_type -- 
    ,payer_host_type -- 
    ,payer_phone -- 
    ,payer_valid_date -- 
    ,payer_cvn2 -- 
    ,payer_bank_code -- 
    ,real_payer_acct_no -- 
    ,real_payer_acct_name -- 
    ,real_payer_acct_type -- 
    ,real_payer_host_type -- 
    ,ret_code -- 
    ,ret_msg -- 
    ,is_limited -- 
    ,action_type -- 
    ,host_status -- 
    ,account_cnt -- 
    ,host_code_list -- 
    ,host_no -- 
    ,reverse_no -- 
    ,refunded -- 
    ,pmc_code -- 
    ,pmc_no -- 
    ,pmc_status -- 
    ,pmc_ret_code -- 
    ,pmc_ret_msg -- 
    ,pmc_date -- 
    ,pmc_time -- 
    ,pmc_cost -- 
    ,mcht_fee -- 
    ,fee_no -- 
    ,fee_status -- 
    ,charge_type -- 
    ,check_date -- 
    ,checked -- 
    ,check_state -- 
    ,is_charge -- 
    ,is_delay -- 
    ,delay_time -- 
    ,fee_amount -- 
    ,chl_checking_code -- 
    ,chl_check_date -- 
    ,auth_teller_no -- 
    ,check_teller_no -- 
    ,trans_org_no -- 
    ,summery_code -- 
    ,consumer_id -- 
    ,is_notify -- 
    ,notify_addr -- 
    ,notify_service_name -- 
    ,payer_ext_map_id -- 
    ,payee_ext_map_id -- 
    ,route_map_id -- 
    ,host_desc -- 
    ,channel_desc -- 
    ,balance_desc -- 
    ,check_time -- 
    ,buiness_module -- 
    ,init_mcht_no -- 
    ,sys_comm_no -- 
    ,pmc_ret_no -- 
    ,pmc_ret_date -- 
    ,pmc_ret_time -- 
    ,pmc_ret_status -- 
    ,mcht_check_mode -- 
    ,payer_bank_name -- 
    ,payee_bank_name -- 
    ,check_flag -- 
    ,host_date -- 
    ,host_time -- 
    ,acc_bean_json -- 
    ,clear_date -- 
    ,cleared -- 
    ,clear_no -- 
    ,clear_type -- 
    ,clear_cycle -- 
    ,teller_no -- 
    ,payee_phone -- 
    ,payee_valid_date -- 
    ,payee_cvn2 -- 
    ,biz_type -- 
    ,sign_no -- 
    ,batch_no -- 
    ,purpose -- 
    ,log_id -- 
    ,server_id -- 
    ,sharding -- 
    ,remark -- 
    ,create_time -- 
    ,update_time -- 
    ,trace_msg -- 
    ,checking_code -- 
    ,advance_flag -- 
    ,biz_sys_code -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(id), 0) as id -- 
    ,nvl(trim(global_no), ' ') as global_no -- 
    ,nvl(trim(txn_no), ' ') as txn_no -- 
    ,nvl(trim(txn_date), ' ') as txn_date -- 
    ,nvl(trim(txn_time), ' ') as txn_time -- 
    ,nvl(trim(txn_type), ' ') as txn_type -- 
    ,nvl(trim(corporate), ' ') as corporate -- 
    ,nvl(trim(mcht_no), ' ') as mcht_no -- 
    ,nvl(trim(product_no), ' ') as product_no -- 
    ,nvl(trim(tran_no), ' ') as tran_no -- 
    ,nvl(trim(tran_date), ' ') as tran_date -- 
    ,nvl(trim(tran_time), ' ') as tran_time -- 
    ,nvl(trim(status), ' ') as status -- 
    ,nvl(trim(biz_status), ' ') as biz_status -- 
    ,nvl(trim(trade_type), ' ') as trade_type -- 
    ,nvl(trim(route_type), ' ') as route_type -- 
    ,nvl(trim(priority), ' ') as priority -- 
    ,nvl(trim(work_date), ' ') as work_date -- 
    ,nvl(trim(amount), 0) as amount -- 
    ,nvl(trim(currency), ' ') as currency -- 
    ,nvl(trim(payee_acct_no), ' ') as payee_acct_no -- 
    ,nvl(trim(payee_acct_name), ' ') as payee_acct_name -- 
    ,nvl(trim(payee_acct_type), ' ') as payee_acct_type -- 
    ,nvl(trim(payee_host_type), ' ') as payee_host_type -- 
    ,nvl(trim(payee_bank_code), ' ') as payee_bank_code -- 
    ,nvl(trim(payer_acct_no), ' ') as payer_acct_no -- 
    ,nvl(trim(payer_acct_name), ' ') as payer_acct_name -- 
    ,nvl(trim(payer_acct_type), ' ') as payer_acct_type -- 
    ,nvl(trim(payer_host_type), ' ') as payer_host_type -- 
    ,nvl(trim(payer_phone), ' ') as payer_phone -- 
    ,nvl(trim(payer_valid_date), ' ') as payer_valid_date -- 
    ,nvl(trim(payer_cvn2), ' ') as payer_cvn2 -- 
    ,nvl(trim(payer_bank_code), ' ') as payer_bank_code -- 
    ,nvl(trim(real_payer_acct_no), ' ') as real_payer_acct_no -- 
    ,nvl(trim(real_payer_acct_name), ' ') as real_payer_acct_name -- 
    ,nvl(trim(real_payer_acct_type), ' ') as real_payer_acct_type -- 
    ,nvl(trim(real_payer_host_type), ' ') as real_payer_host_type -- 
    ,nvl(trim(ret_code), ' ') as ret_code -- 
    ,nvl(trim(ret_msg), ' ') as ret_msg -- 
    ,nvl(trim(is_limited), ' ') as is_limited -- 
    ,nvl(trim(action_type), ' ') as action_type -- 
    ,nvl(trim(host_status), ' ') as host_status -- 
    ,nvl(trim(account_cnt), 0) as account_cnt -- 
    ,nvl(trim(host_code_list), ' ') as host_code_list -- 
    ,nvl(trim(host_no), ' ') as host_no -- 
    ,nvl(trim(reverse_no), ' ') as reverse_no -- 
    ,nvl(trim(refunded), ' ') as refunded -- 
    ,nvl(trim(pmc_code), ' ') as pmc_code -- 
    ,nvl(trim(pmc_no), ' ') as pmc_no -- 
    ,nvl(trim(pmc_status), ' ') as pmc_status -- 
    ,nvl(trim(pmc_ret_code), ' ') as pmc_ret_code -- 
    ,nvl(trim(pmc_ret_msg), ' ') as pmc_ret_msg -- 
    ,nvl(trim(pmc_date), ' ') as pmc_date -- 
    ,nvl(trim(pmc_time), ' ') as pmc_time -- 
    ,nvl(trim(pmc_cost), 0) as pmc_cost -- 
    ,nvl(trim(mcht_fee), 0) as mcht_fee -- 
    ,nvl(trim(fee_no), ' ') as fee_no -- 
    ,nvl(trim(fee_status), ' ') as fee_status -- 
    ,nvl(trim(charge_type), ' ') as charge_type -- 
    ,nvl(trim(check_date), ' ') as check_date -- 
    ,nvl(trim(checked), ' ') as checked -- 
    ,nvl(trim(check_state), ' ') as check_state -- 
    ,nvl(trim(is_charge), ' ') as is_charge -- 
    ,nvl(trim(is_delay), ' ') as is_delay -- 
    ,nvl(trim(delay_time), ' ') as delay_time -- 
    ,nvl(trim(fee_amount), 0) as fee_amount -- 
    ,nvl(trim(chl_checking_code), ' ') as chl_checking_code -- 
    ,nvl(trim(chl_check_date), ' ') as chl_check_date -- 
    ,nvl(trim(auth_teller_no), ' ') as auth_teller_no -- 
    ,nvl(trim(check_teller_no), ' ') as check_teller_no -- 
    ,nvl(trim(trans_org_no), ' ') as trans_org_no -- 
    ,nvl(trim(summery_code), ' ') as summery_code -- 
    ,nvl(trim(consumer_id), ' ') as consumer_id -- 
    ,nvl(trim(is_notify), ' ') as is_notify -- 
    ,nvl(trim(notify_addr), ' ') as notify_addr -- 
    ,nvl(trim(notify_service_name), ' ') as notify_service_name -- 
    ,nvl(trim(payer_ext_map_id), ' ') as payer_ext_map_id -- 
    ,nvl(trim(payee_ext_map_id), ' ') as payee_ext_map_id -- 
    ,nvl(trim(route_map_id), ' ') as route_map_id -- 
    ,nvl(trim(host_desc), ' ') as host_desc -- 
    ,nvl(trim(channel_desc), ' ') as channel_desc -- 
    ,nvl(trim(balance_desc), ' ') as balance_desc -- 
    ,nvl(check_time, to_date('00010101', 'yyyymmdd')) as check_time -- 
    ,nvl(trim(buiness_module), ' ') as buiness_module -- 
    ,nvl(trim(init_mcht_no), ' ') as init_mcht_no -- 
    ,nvl(trim(sys_comm_no), ' ') as sys_comm_no -- 
    ,nvl(trim(pmc_ret_no), ' ') as pmc_ret_no -- 
    ,nvl(trim(pmc_ret_date), ' ') as pmc_ret_date -- 
    ,nvl(trim(pmc_ret_time), ' ') as pmc_ret_time -- 
    ,nvl(trim(pmc_ret_status), ' ') as pmc_ret_status -- 
    ,nvl(trim(mcht_check_mode), ' ') as mcht_check_mode -- 
    ,nvl(trim(payer_bank_name), ' ') as payer_bank_name -- 
    ,nvl(trim(payee_bank_name), ' ') as payee_bank_name -- 
    ,nvl(trim(check_flag), ' ') as check_flag -- 
    ,nvl(trim(host_date), ' ') as host_date -- 
    ,nvl(trim(host_time), ' ') as host_time -- 
    ,nvl(trim(acc_bean_json), ' ') as acc_bean_json -- 
    ,nvl(trim(clear_date), ' ') as clear_date -- 
    ,nvl(trim(cleared), ' ') as cleared -- 
    ,nvl(trim(clear_no), ' ') as clear_no -- 
    ,nvl(trim(clear_type), ' ') as clear_type -- 
    ,nvl(trim(clear_cycle), 0) as clear_cycle -- 
    ,nvl(trim(teller_no), ' ') as teller_no -- 
    ,nvl(trim(payee_phone), ' ') as payee_phone -- 
    ,nvl(trim(payee_valid_date), ' ') as payee_valid_date -- 
    ,nvl(trim(payee_cvn2), ' ') as payee_cvn2 -- 
    ,nvl(trim(biz_type), ' ') as biz_type -- 
    ,nvl(trim(sign_no), ' ') as sign_no -- 
    ,nvl(trim(batch_no), ' ') as batch_no -- 
    ,nvl(trim(purpose), ' ') as purpose -- 
    ,nvl(trim(log_id), ' ') as log_id -- 
    ,nvl(trim(server_id), ' ') as server_id -- 
    ,nvl(trim(sharding), ' ') as sharding -- 
    ,nvl(trim(remark), ' ') as remark -- 
    ,nvl(create_time, to_date('00010101', 'yyyymmdd')) as create_time -- 
    ,nvl(update_time, to_date('00010101', 'yyyymmdd')) as update_time -- 
    ,nvl(trim(trace_msg), ' ') as trace_msg -- 
    ,nvl(trim(checking_code), ' ') as checking_code -- 
    ,nvl(trim(advance_flag), ' ') as advance_flag -- 
    ,nvl(trim(biz_sys_code), ' ') as biz_sys_code -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_upps_t_txn_credit
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_upps_t_txn_credit to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_upps_t_txn_credit',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);