/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_e_txn_refund
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
--drop table ${iol_schema}.ppps_e_txn_refund_ex purge;
--alter table ${iol_schema}.ppps_e_txn_refund add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
-- 3.1 get new data into table
set serveroutput on
--set line 200;
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
--dbms_output.put_line('BBB');
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''ppps_e_txn_refund'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    --dbms_output.put_line(v_sql);
    execute immediate v_sql into v_p_exists;
    --dbms_output.put_line(v_p_exists);
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.ppps_e_txn_refund truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --dbms_output.put_line('BBB');  
    --no exists partitions  
    else 
        v_sql := 'alter table iol.ppps_e_txn_refund add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
        --dbms_output.put_line('AAA');
    end if;
      end loop;
end;
/

insert /*+ append */ into ${iol_schema}.ppps_e_txn_refund(
    sys_id -- 系统流水
    ,sys_date -- 系统日期
    ,trx_id -- 退款流水号
    ,batch_id -- 网联批次号
    ,r_p_flg -- 收／付标识
    ,ori_biz_tp -- 原业务种类
    ,ori_trx_id -- 原交易流水号
    ,ori_dbtr_bank_id -- 原付款行交易流水
    ,ori_trx_amt_d -- 原订单金额
    ,trx_curry -- 退款币种
    ,trx_amt_d -- 退款金额
    ,pyer_acct_issr_id -- 退款方账户所属机构标识
    ,pyer_acct_id -- 退款方账户编号
    ,pyer_acct_tp -- 退款方账户类型
    ,pyee_acct_issr_id -- 收款方账户所属机构标识
    ,pyee_acct_tp -- 收款方账户类型
    ,sgn_no -- 收款方账户签约协议号
    ,pyee_acct_id -- 收款方账户编号
    ,pyee_acct_nm -- 收款方账户名称
    ,instg_acct_id -- 备付金账户编号
    ,instg_acct_nm -- 备付金账户名称
    ,resfd_acct_issr_id -- 备付金所属机构标识
    ,trx_status -- 交易状态
    ,trx_ctgy -- 交易类别
    ,trx_dt_tm -- 网联交易日期时间
    ,biz_sts_cd -- 业务返回码
    ,biz_sts_desc -- 业务返回说明
    ,sys_rtn_cd -- 系统返回码
    ,sys_rtn_desc -- 系统返回说明
    ,host_id -- 核心流水
    ,host_date -- 核心日期
    ,host_status -- 核心状态
    ,create_time -- 创建时间
    ,update_time -- 最后更新时间
    ,sys_type -- 系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心
    ,epcc_chk -- 网联状态
    ,host_check -- 核心对账状态
    ,adjust_flag -- 调账标识   0-未调账 1-已调账
    ,liqu_flag -- 清算标识 0-未清算 1-已清算
    ,transfer_flag -- 转移标识 0-未转移 1-已转移
    ,chk_status -- 对账状态
    ,chk_desc -- 对账描述
    ,trans_type -- 交易类型
    ,adj_mtd -- 调账方式(00：无需调账；01：根据终态通知调账；02：根据对账文件调账)
    ,biz_date -- 网联平台业务时间
    ,global_seq_no -- 全局流水号
    ,host_req_no -- 核心请求流水号
    ,host_ret_code -- 核心响应码
    ,host_ret_msg -- 核心响应信息
    ,txn_date -- 平台交易日期
    ,txn_time -- 平台交易时间
    ,status -- 状态
    ,host_revert_date -- 核心冲正日期
    ,host_revert_id -- 核心冲正流水号
    ,txn_no -- 平台流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sys_id -- 系统流水
    ,sys_date -- 系统日期
    ,trx_id -- 退款流水号
    ,batch_id -- 网联批次号
    ,r_p_flg -- 收／付标识
    ,ori_biz_tp -- 原业务种类
    ,ori_trx_id -- 原交易流水号
    ,ori_dbtr_bank_id -- 原付款行交易流水
    ,ori_trx_amt_d -- 原订单金额
    ,trx_curry -- 退款币种
    ,trx_amt_d -- 退款金额
    ,pyer_acct_issr_id -- 退款方账户所属机构标识
    ,pyer_acct_id -- 退款方账户编号
    ,pyer_acct_tp -- 退款方账户类型
    ,pyee_acct_issr_id -- 收款方账户所属机构标识
    ,pyee_acct_tp -- 收款方账户类型
    ,sgn_no -- 收款方账户签约协议号
    ,pyee_acct_id -- 收款方账户编号
    ,pyee_acct_nm -- 收款方账户名称
    ,instg_acct_id -- 备付金账户编号
    ,instg_acct_nm -- 备付金账户名称
    ,resfd_acct_issr_id -- 备付金所属机构标识
    ,trx_status -- 交易状态
    ,trx_ctgy -- 交易类别
    ,trx_dt_tm -- 网联交易日期时间
    ,biz_sts_cd -- 业务返回码
    ,biz_sts_desc -- 业务返回说明
    ,sys_rtn_cd -- 系统返回码
    ,sys_rtn_desc -- 系统返回说明
    ,host_id -- 核心流水
    ,host_date -- 核心日期
    ,host_status -- 核心状态
    ,create_time -- 创建时间
    ,update_time -- 最后更新时间
    ,sys_type -- 系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心
    ,epcc_chk -- 网联状态
    ,host_check -- 核心对账状态
    ,adjust_flag -- 调账标识   0-未调账 1-已调账
    ,liqu_flag -- 清算标识 0-未清算 1-已清算
    ,transfer_flag -- 转移标识 0-未转移 1-已转移
    ,chk_status -- 对账状态
    ,chk_desc -- 对账描述
    ,trans_type -- 交易类型
    ,adj_mtd -- 调账方式(00：无需调账；01：根据终态通知调账；02：根据对账文件调账)
    ,biz_date -- 网联平台业务时间
    ,global_seq_no -- 全局流水号
    ,host_req_no -- 核心请求流水号
    ,host_ret_code -- 核心响应码
    ,host_ret_msg -- 核心响应信息
    ,txn_date -- 平台交易日期
    ,txn_time -- 平台交易时间
    ,status -- 状态
    ,host_revert_date -- 核心冲正日期
    ,host_revert_id -- 核心冲正流水号
    ,txn_no -- 平台流水号
    ,to_date(sys_date,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ppps_e_txn_refund
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
--alter table ${iol_schema}.ppps_e_txn_refund exchange partition p_${batch_date} with table ${iol_schema}.ppps_e_txn_refund_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ppps_e_txn_refund to ${iml_schema};

-- 3.2 drop ex table
--drop table ${iol_schema}.ppps_e_txn_refund_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ppps_e_txn_refund',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);