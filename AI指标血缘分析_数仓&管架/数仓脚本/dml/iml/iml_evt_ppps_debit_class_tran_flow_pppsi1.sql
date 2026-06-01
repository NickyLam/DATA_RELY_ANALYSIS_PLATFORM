/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ppps_debit_class_tran_flow_pppsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_ppps_debit_class_tran_flow_pppsi1_tm purge;
alter table ${iml_schema}.evt_ppps_debit_class_tran_flow add partition p_pppsi1 values ('pppsi1')(
        subpartition p_pppsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ppps_debit_class_tran_flow modify partition p_pppsi1
    add subpartition p_pppsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ppps_debit_class_tran_flow_pppsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,plat_flow_num -- 平台流水号
    ,plat_tran_dt -- 平台交易日期
    ,plat_tran_tm -- 平台交易时间
    ,prod_id -- 产品编号
    ,adv_flg -- 垫资标志
    ,check_entry_idf_type_cd -- 对账标识类型代码
    ,check_entry_proc_flg -- 对账处理标志
    ,check_entry_proc_tm -- 对账处理时间
    ,check_entry_rest_descb -- 对账结果描述
    ,check_entry_dt -- 对账日期
    ,check_entry_status_cd -- 对账状态代码
    ,payer_cust_acct_num -- 付款方客户账号
    ,payer_mobile_no -- 付款方手机号码
    ,payer_acct_num_cate_cd -- 付款方账号类别代码
    ,payer_acct_num_belong_core_type_cd -- 付款方账号所属核心类型代码
    ,payer_acct_name -- 付款方账户名称
    ,pay_bank_clear_bk_num -- 付款行清算行号
    ,pay_bank_clear_bk_name -- 付款行清算行名称
    ,check_teller_id -- 复核柜员编号
    ,core_revs_flow_num -- 核心冲正流水号
    ,core_check_entry_rest_descb -- 核心对账结果描述
    ,core_tran_flow_num -- 核心交易流水号
    ,core_resp_dt -- 核心响应日期
    ,core_resp_tm -- 核心响应时间
    ,fee_type_cd -- 计费类型代码
    ,tran_remark -- 交易备注
    ,tran_curr_cd -- 交易币种代码
    ,tran_proc_status_cd -- 交易处理状态代码
    ,tran_postsc -- 交易附言
    ,tran_teller_id -- 交易柜员编号
    ,tran_core_acct_status_cd -- 交易核心账务状态代码
    ,tran_org_id -- 交易机构编号
    ,tran_amt -- 交易金额
    ,tran_cate_cd -- 交易类别代码
    ,tran_batch_id -- 交易批次编号
    ,tran_clear_dt -- 交易清算日期
    ,tran_aging_type_cd -- 交易时效类型代码
    ,cust_comm_fee -- 客户手续费
    ,cross_bank_flg -- 跨行标志
    ,free_comm_fee_flg -- 免手续费标志
    ,clear_type_cd -- 清算类型代码
    ,clear_flow_num -- 清算流水号
    ,chn_id -- 渠道编号
    ,chn_check_entry_prod_id -- 渠道对账产品编号
    ,chn_check_entry_mode_cd -- 渠道对账模式代码
    ,chn_check_entry_dt -- 渠道对账日期
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_tran_dt -- 渠道交易日期
    ,chn_tran_tm -- 渠道交易时间
    ,chn_tran_comm_fee -- 渠道交易手续费
    ,chn_comm_fee_entry_flow_num -- 渠道手续费记账流水号
    ,sorc_sys_id -- 源系统编号
    ,ova_flow_num -- 全局流水号
    ,realtm_clear_flg -- 实时清算标志
    ,recver_cust_acct_num -- 收款方客户账号
    ,recver_mobile_no -- 收款方手机号码
    ,recver_acct_num_cate_cd -- 收款方账号类别代码
    ,recver_acct_num_belong_core_type_cd -- 收款方账号所属核心类型代码
    ,recver_acct_name -- 收款方账户名称
    ,recv_bank_clear_bk_num -- 收款行清算行号
    ,recv_bank_clear_bk_name_name -- 收款行清算行名名称
    ,comm_fee_collect_status_cd -- 手续费计收状态代码
    ,auth_teller_id -- 授权柜员编号
    ,caller_sys_id -- 调用方系统ID
    ,pass_cost_fee -- 通道成本费
    ,pass_check_entry_rest_descb -- 通道对账结果描述
    ,pass_tran_flow_num -- 通道交易流水号
    ,pass_tran_dt -- 通道交易日期
    ,pass_tran_tm -- 通道交易时间
    ,pass_sys_code -- 通道系统编码
    ,pass_resp_flow_num -- 通道响应流水号
    ,pass_resp_dt -- 通道响应日期
    ,pass_resp_tm -- 通道响应时间
    ,pass_resp_status_cd -- 通道响应状态代码
    ,nostro_cd -- 往来账代码
    ,sys_comm_flow_num -- 系统通讯流水号
    ,bus_proc_status_cd -- 业务处理状态代码
    ,bus_type_cd -- 业务类型代码
    ,aldy_clear_flg -- 已清算标志
    ,aldy_refund_flg -- 已退款标志
    ,final_update_tm -- 最后更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ppps_debit_class_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ppps_t_txn_debit-
insert into ${iml_schema}.evt_ppps_debit_class_tran_flow_pppsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,plat_flow_num -- 平台流水号
    ,plat_tran_dt -- 平台交易日期
    ,plat_tran_tm -- 平台交易时间
    ,prod_id -- 产品编号
    ,adv_flg -- 垫资标志
    ,check_entry_idf_type_cd -- 对账标识类型代码
    ,check_entry_proc_flg -- 对账处理标志
    ,check_entry_proc_tm -- 对账处理时间
    ,check_entry_rest_descb -- 对账结果描述
    ,check_entry_dt -- 对账日期
    ,check_entry_status_cd -- 对账状态代码
    ,payer_cust_acct_num -- 付款方客户账号
    ,payer_mobile_no -- 付款方手机号码
    ,payer_acct_num_cate_cd -- 付款方账号类别代码
    ,payer_acct_num_belong_core_type_cd -- 付款方账号所属核心类型代码
    ,payer_acct_name -- 付款方账户名称
    ,pay_bank_clear_bk_num -- 付款行清算行号
    ,pay_bank_clear_bk_name -- 付款行清算行名称
    ,check_teller_id -- 复核柜员编号
    ,core_revs_flow_num -- 核心冲正流水号
    ,core_check_entry_rest_descb -- 核心对账结果描述
    ,core_tran_flow_num -- 核心交易流水号
    ,core_resp_dt -- 核心响应日期
    ,core_resp_tm -- 核心响应时间
    ,fee_type_cd -- 计费类型代码
    ,tran_remark -- 交易备注
    ,tran_curr_cd -- 交易币种代码
    ,tran_proc_status_cd -- 交易处理状态代码
    ,tran_postsc -- 交易附言
    ,tran_teller_id -- 交易柜员编号
    ,tran_core_acct_status_cd -- 交易核心账务状态代码
    ,tran_org_id -- 交易机构编号
    ,tran_amt -- 交易金额
    ,tran_cate_cd -- 交易类别代码
    ,tran_batch_id -- 交易批次编号
    ,tran_clear_dt -- 交易清算日期
    ,tran_aging_type_cd -- 交易时效类型代码
    ,cust_comm_fee -- 客户手续费
    ,cross_bank_flg -- 跨行标志
    ,free_comm_fee_flg -- 免手续费标志
    ,clear_type_cd -- 清算类型代码
    ,clear_flow_num -- 清算流水号
    ,chn_id -- 渠道编号
    ,chn_check_entry_prod_id -- 渠道对账产品编号
    ,chn_check_entry_mode_cd -- 渠道对账模式代码
    ,chn_check_entry_dt -- 渠道对账日期
    ,chn_tran_flow_num -- 渠道交易流水号
    ,chn_tran_dt -- 渠道交易日期
    ,chn_tran_tm -- 渠道交易时间
    ,chn_tran_comm_fee -- 渠道交易手续费
    ,chn_comm_fee_entry_flow_num -- 渠道手续费记账流水号
    ,sorc_sys_id -- 源系统编号
    ,ova_flow_num -- 全局流水号
    ,realtm_clear_flg -- 实时清算标志
    ,recver_cust_acct_num -- 收款方客户账号
    ,recver_mobile_no -- 收款方手机号码
    ,recver_acct_num_cate_cd -- 收款方账号类别代码
    ,recver_acct_num_belong_core_type_cd -- 收款方账号所属核心类型代码
    ,recver_acct_name -- 收款方账户名称
    ,recv_bank_clear_bk_num -- 收款行清算行号
    ,recv_bank_clear_bk_name_name -- 收款行清算行名名称
    ,comm_fee_collect_status_cd -- 手续费计收状态代码
    ,auth_teller_id -- 授权柜员编号
    ,caller_sys_id -- 调用方系统ID
    ,pass_cost_fee -- 通道成本费
    ,pass_check_entry_rest_descb -- 通道对账结果描述
    ,pass_tran_flow_num -- 通道交易流水号
    ,pass_tran_dt -- 通道交易日期
    ,pass_tran_tm -- 通道交易时间
    ,pass_sys_code -- 通道系统编码
    ,pass_resp_flow_num -- 通道响应流水号
    ,pass_resp_dt -- 通道响应日期
    ,pass_resp_tm -- 通道响应时间
    ,pass_resp_status_cd -- 通道响应状态代码
    ,nostro_cd -- 往来账代码
    ,sys_comm_flow_num -- 系统通讯流水号
    ,bus_proc_status_cd -- 业务处理状态代码
    ,bus_type_cd -- 业务类型代码
    ,aldy_clear_flg -- 已清算标志
    ,aldy_refund_flg -- 已退款标志
    ,final_update_tm -- 最后更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '302005'||P1.TXN_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TXN_NO -- 平台流水号
    ,${iml_schema}.dateformat_max2(P1.TXN_DATE) -- 平台交易日期
    ,${iml_schema}.timeformat_max2(P1.TXN_DATE||' '||P1.TXN_TIME) -- 平台交易时间
    ,P1.PRODUCT_NO -- 产品编号
    ,P1.ADVANCE_FLAG -- 垫资标志
    ,P1.CHECK_FLAG -- 对账标识类型代码
    ,P1.CHECKED -- 对账处理标志
    ,${iml_schema}.timeformat_max2(P1.CHECK_TIME) -- 对账处理时间
    ,P1.BALANCE_DESC -- 对账结果描述
    ,${iml_schema}.dateformat_max2(P1.CHECK_DATE) -- 对账日期
    ,P1.CHECK_STATE -- 对账状态代码
    ,P1.PAYER_ACCT_NO -- 付款方客户账号
    ,P1.PAYER_PHONE -- 付款方手机号码
    ,P1.PAYER_ACCT_TYPE -- 付款方账号类别代码
    ,P1.PAYER_HOST_TYPE -- 付款方账号所属核心类型代码
    ,P1.PAYER_ACCT_NAME -- 付款方账户名称
    ,P1.PAYER_BANK_CODE -- 付款行清算行号
    ,P1.PAYER_BANK_NAME -- 付款行清算行名称
    ,P1.CHECK_TELLER_NO -- 复核柜员编号
    ,P1.REVERSE_NO -- 核心冲正流水号
    ,P1.HOST_DESC -- 核心对账结果描述
    ,P1.HOST_NO -- 核心交易流水号
    ,${iml_schema}.dateformat_max2(P1.HOST_DATE) -- 核心响应日期
    ,${iml_schema}.timeformat_max2(P1.HOST_DATE||' '||P1.HOST_TIME) -- 核心响应时间
    ,P1.CHARGE_TYPE -- 计费类型代码
    ,P1.REMARK -- 交易备注
    ,P1.CURRENCY -- 交易币种代码
    ,P1.STATUS -- 交易处理状态代码
    ,P1.PURPOSE -- 交易附言
    ,P1.TELLER_NO -- 交易柜员编号
    ,P1.HOST_STATUS -- 交易核心账务状态代码
    ,P1.TRANS_ORG_NO -- 交易机构编号
    ,P1.AMOUNT -- 交易金额
    ,P1.TRADE_TYPE -- 交易类别代码
    ,P1.BATCH_NO -- 交易批次编号
    ,${iml_schema}.dateformat_max2(P1.CLEAR_DATE) -- 交易清算日期
    ,P1.PRIORITY -- 交易时效类型代码
    ,P1.FEE_AMOUNT -- 客户手续费
    ,P1.BUINESS_MODULE -- 跨行标志
    ,P1.IS_CHARGE -- 免手续费标志
    ,P1.CLEAR_TYPE -- 清算类型代码
    ,P1.CLEAR_NO -- 清算流水号
    ,P1.MCHT_NO -- 渠道编号
    ,P1.CHL_CHECKING_CODE -- 渠道对账产品编号
    ,P1.MCHT_CHECK_MODE -- 渠道对账模式代码
    ,${iml_schema}.dateformat_max2(P1.CHL_CHECK_DATE) -- 渠道对账日期
    ,P1.TRAN_NO -- 渠道交易流水号
    ,${iml_schema}.dateformat_max2(P1.TRAN_DATE) -- 渠道交易日期
    ,${iml_schema}.timeformat_max2(P1.TRAN_DATE||' '||P1.TRAN_TIME) -- 渠道交易时间
    ,P1.MCHT_FEE -- 渠道交易手续费
    ,P1.FEE_NO -- 渠道手续费记账流水号
    ,P1.INIT_MCHT_NO -- 源系统编号
    ,P1.GLOBAL_NO -- 全局流水号
    ,P1.CLEAR_CYCLE -- 实时清算标志
    ,P1.PAYEE_ACCT_NO -- 收款方客户账号
    ,P1.PAYEE_PHONE -- 收款方手机号码
    ,P1.PAYEE_ACCT_TYPE -- 收款方账号类别代码
    ,P1.PAYEE_HOST_TYPE -- 收款方账号所属核心类型代码
    ,P1.PAYEE_ACCT_NAME -- 收款方账户名称
    ,P1.PAYEE_BANK_CODE -- 收款行清算行号
    ,P1.PAYEE_BANK_NAME -- 收款行清算行名名称
    ,P1.FEE_STATUS -- 手续费计收状态代码
    ,P1.AUTH_TELLER_NO -- 授权柜员编号
    ,P1.CONSUMER_ID -- 调用方系统ID
    ,P1.PMC_COST -- 通道成本费
    ,P1.CHANNEL_DESC -- 通道对账结果描述
    ,P1.PMC_NO -- 通道交易流水号
    ,${iml_schema}.dateformat_max2(P1.PMC_DATE) -- 通道交易日期
    ,${iml_schema}.timeformat_max2(P1.PMC_DATE||' '||P1.PMC_TIME) -- 通道交易时间
    ,P1.PMC_CODE -- 通道系统编码
    ,P1.PMC_RET_NO -- 通道响应流水号
    ,${iml_schema}.dateformat_max2(P1.PMC_RET_DATE) -- 通道响应日期
    ,${iml_schema}.timeformat_max2(P1.PMC_RET_DATE||' '||P1.PMC_RET_TIME) -- 通道响应时间
    ,P1.PMC_RET_STATUS -- 通道响应状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TXN_TYPE END -- 往来账代码
    ,P1.SYS_COMM_NO -- 系统通讯流水号
    ,P1.BIZ_STATUS -- 业务处理状态代码
    ,P1.BIZ_TYPE -- 业务类型代码
    ,P1.CLEARED -- 已清算标志
    ,P1.REFUNDED -- 已退款标志
    ,P1.UPDATE_TIME -- 最后更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ppps_t_txn_debit' -- 源表名称
    ,'pppsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ppps_t_txn_debit p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TXN_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'PPPS'
        AND R1.SRC_TAB_EN_NAME= 'PPPS_T_TXN_DEBIT'
        AND R1.SRC_FIELD_EN_NAME= 'TXN_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_PPPS_DEBIT_CLASS_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'NOSTRO_CD'
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ppps_debit_class_tran_flow truncate subpartition p_pppsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ppps_debit_class_tran_flow exchange subpartition p_pppsi1_${batch_date} with table ${iml_schema}.evt_ppps_debit_class_tran_flow_pppsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ppps_debit_class_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ppps_debit_class_tran_flow_pppsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ppps_debit_class_tran_flow', partname => 'p_pppsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);