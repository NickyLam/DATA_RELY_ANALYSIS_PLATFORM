/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ppps_crdt_class_tran_flow_pppsi1
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
drop table ${iml_schema}.evt_ppps_crdt_class_tran_flow_pppsi1_tm purge;
alter table ${iml_schema}.evt_ppps_crdt_class_tran_flow add partition p_pppsi1 values ('pppsi1')(
        subpartition p_pppsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ppps_crdt_class_tran_flow modify partition p_pppsi1
    add subpartition p_pppsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ppps_crdt_class_tran_flow_pppsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,ova_flow_num -- 全局流水号
    ,tran_cate_cd -- 交易类别代码
    ,bus_type_cd -- 业务类型代码
    ,bus_status_cd -- 业务状态代码
    ,nostro_cd -- 往来账代码
    ,chn_id -- 渠道编号
    ,mercht_tran_flow_num -- 商户交易流水号
    ,mercht_tran_dt -- 商户交易日期
    ,tran_amt -- 交易金额
    ,tran_curr_cd -- 交易币种代码
    ,tran_aging_type_cd -- 交易时效类型代码
    ,tran_proc_status_cd -- 交易处理状态代码
    ,tran_batch_no -- 交易批次号
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,realtm_clear_flg -- 实时清算标志
    ,clear_dt -- 清算日期
    ,sign_agt_id -- 签约协议编号
    ,tran_postsc -- 交易附言
    ,recvbl_cert_type_cd -- 收款证件类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_cate_cd -- 收款账户类别代码
    ,recvbl_acct_belong_sys_cd -- 收款账户归属系统代码
    ,recvbl_mobile_no -- 收款手机号码
    ,recvbl_clear_bk_no -- 收款清算行行号
    ,recvbl_clear_bk_name -- 收款清算行名称
    ,pay_cert_type_cd -- 付款证件类型代码
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_cate_cd -- 付款账户类别代码
    ,pay_acct_belong_sys_cd -- 付款账户归属系统代码
    ,pay_bank_clear_bk_num -- 付款行清算行号
    ,pay_clear_bk_name -- 付款清算行名称
    ,actl_pay_acct_id -- 实际付款账户编号
    ,actl_pay_name -- 实际付款名称
    ,actl_pay_acct_cate_cd -- 实际付款账户类别代码
    ,actl_pay_acct_belong_sys_cd -- 实际付款账户归属系统代码
    ,acm_lmt_type_cd -- 累计限额类型代码
    ,core_tran_flow_num -- 核心交易流水号
    ,core_acct_status_cd -- 核心账务状态代码
    ,core_dt -- 核心日期
    ,call_pass_flow_num -- 调用通道流水号
    ,pass_sys_abbr -- 通道系统简称
    ,pass_tran_flow_num -- 通道交易流水号
    ,pass_init_status_cd -- 通道原始状态代码
    ,pass_resp_flow_num -- 通道响应流水号
    ,pass_resp_dt -- 通道响应日期
    ,pass_resp_status_cd -- 通道响应状态代码
    ,pass_tran_dt -- 通道交易日期
    ,pass_cost_fee -- 通道成本费
    ,check_entry_dt -- 对账日期
    ,check_entry_proc_idf -- 对账处理标识
    ,check_entry_idf_type_cd -- 对账标识类型代码
    ,check_entry_rest_descb -- 对账结果描述
    ,check_entry_proc_dt -- 对账处理日期
    ,chn_check_entry_code -- 渠道对账编码
    ,chn_check_entry_dt -- 渠道对账日期
    ,chn_check_entry_mode_cd -- 渠道对账模式代码
    ,pass_check_entry_proc_descb -- 通道对账处理描述
    ,cross_bank_flg -- 跨行标志
    ,coll_comm_fee_flg -- 收取手续费标志
    ,comm_fee_amt -- 手续费金额
    ,need_delay_tran_acct_flg -- 需要延时转账标志
    ,delay_tm -- 延长时间
    ,check_teller_id -- 复核柜员编号
    ,call_sys_id -- 调用系统编号
    ,sorc_sys_id -- 源系统编号
    ,adv_exp_flg -- 垫支标志
    ,belong_sys_id -- 归属系统编号
    ,fir_create_dt -- 首次创建日期
    ,final_update_dt -- 最后更新日期
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ppps_crdt_class_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ppps_t_txn_credit-1
insert into ${iml_schema}.evt_ppps_crdt_class_tran_flow_pppsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,ova_flow_num -- 全局流水号
    ,tran_cate_cd -- 交易类别代码
    ,bus_type_cd -- 业务类型代码
    ,bus_status_cd -- 业务状态代码
    ,nostro_cd -- 往来账代码
    ,chn_id -- 渠道编号
    ,mercht_tran_flow_num -- 商户交易流水号
    ,mercht_tran_dt -- 商户交易日期
    ,tran_amt -- 交易金额
    ,tran_curr_cd -- 交易币种代码
    ,tran_aging_type_cd -- 交易时效类型代码
    ,tran_proc_status_cd -- 交易处理状态代码
    ,tran_batch_no -- 交易批次号
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,realtm_clear_flg -- 实时清算标志
    ,clear_dt -- 清算日期
    ,sign_agt_id -- 签约协议编号
    ,tran_postsc -- 交易附言
    ,recvbl_cert_type_cd -- 收款证件类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_cate_cd -- 收款账户类别代码
    ,recvbl_acct_belong_sys_cd -- 收款账户归属系统代码
    ,recvbl_mobile_no -- 收款手机号码
    ,recvbl_clear_bk_no -- 收款清算行行号
    ,recvbl_clear_bk_name -- 收款清算行名称
    ,pay_cert_type_cd -- 付款证件类型代码
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_cate_cd -- 付款账户类别代码
    ,pay_acct_belong_sys_cd -- 付款账户归属系统代码
    ,pay_bank_clear_bk_num -- 付款行清算行号
    ,pay_clear_bk_name -- 付款清算行名称
    ,actl_pay_acct_id -- 实际付款账户编号
    ,actl_pay_name -- 实际付款名称
    ,actl_pay_acct_cate_cd -- 实际付款账户类别代码
    ,actl_pay_acct_belong_sys_cd -- 实际付款账户归属系统代码
    ,acm_lmt_type_cd -- 累计限额类型代码
    ,core_tran_flow_num -- 核心交易流水号
    ,core_acct_status_cd -- 核心账务状态代码
    ,core_dt -- 核心日期
    ,call_pass_flow_num -- 调用通道流水号
    ,pass_sys_abbr -- 通道系统简称
    ,pass_tran_flow_num -- 通道交易流水号
    ,pass_init_status_cd -- 通道原始状态代码
    ,pass_resp_flow_num -- 通道响应流水号
    ,pass_resp_dt -- 通道响应日期
    ,pass_resp_status_cd -- 通道响应状态代码
    ,pass_tran_dt -- 通道交易日期
    ,pass_cost_fee -- 通道成本费
    ,check_entry_dt -- 对账日期
    ,check_entry_proc_idf -- 对账处理标识
    ,check_entry_idf_type_cd -- 对账标识类型代码
    ,check_entry_rest_descb -- 对账结果描述
    ,check_entry_proc_dt -- 对账处理日期
    ,chn_check_entry_code -- 渠道对账编码
    ,chn_check_entry_dt -- 渠道对账日期
    ,chn_check_entry_mode_cd -- 渠道对账模式代码
    ,pass_check_entry_proc_descb -- 通道对账处理描述
    ,cross_bank_flg -- 跨行标志
    ,coll_comm_fee_flg -- 收取手续费标志
    ,comm_fee_amt -- 手续费金额
    ,need_delay_tran_acct_flg -- 需要延时转账标志
    ,delay_tm -- 延长时间
    ,check_teller_id -- 复核柜员编号
    ,call_sys_id -- 调用系统编号
    ,sorc_sys_id -- 源系统编号
    ,adv_exp_flg -- 垫支标志
    ,belong_sys_id -- 归属系统编号
    ,fir_create_dt -- 首次创建日期
    ,final_update_dt -- 最后更新日期
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '302004'||P1.TXN_NO||P1.TXN_DATE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TXN_NO -- 交易流水号
    ,${iml_schema}.dateformat_max2(P1.TXN_DATE||P1.TXN_TIME) -- 交易日期
    ,P1.GLOBAL_NO -- 全局流水号
    ,nvl(trim(P1.TRADE_TYPE),'-') -- 交易类别代码
    ,nvl(trim(P1.BIZ_TYPE),'-') -- 业务类型代码
    ,nvl(trim(P1.BIZ_STATUS),'-') -- 业务状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TXN_TYPE END -- 往来账代码
    ,nvl(trim(P1.MCHT_NO),'0000') -- 渠道编号
    ,P1.TRAN_NO -- 商户交易流水号
    ,${iml_schema}.dateformat_max2(P1.TRAN_DATE||P1.TRAN_TIME) -- 商户交易日期
    ,P1.AMOUNT -- 交易金额
    ,nvl(trim(P1.CURRENCY),'-') -- 交易币种代码
    ,nvl(trim(P1.PRIORITY),'-') -- 交易时效类型代码
    ,nvl(trim(P1.STATUS),'-') -- 交易处理状态代码
    ,P1.BATCH_NO -- 交易批次号
    ,P1.TRANS_ORG_NO -- 交易机构编号
    ,P1.TELLER_NO -- 交易柜员编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CLEAR_TYPE END -- 实时清算标志
    ,${iml_schema}.dateformat_max2(P1.CLEAR_DATE) -- 清算日期
    ,P1.SIGN_NO -- 签约协议编号
    ,P1.PURPOSE -- 交易附言
    ,nvl(trim(P1.payee_cert_type),'0000') -- 收款证件类型代码
    ,P1.PAYEE_ACCT_NO -- 收款账户编号
    ,P1.PAYEE_ACCT_NAME -- 收款账户名称
    ,nvl(trim(P1.PAYEE_ACCT_TYPE),'-') -- 收款账户类别代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.PAYEE_HOST_TYPE END -- 收款账户归属系统代码
    ,P1.PAYEE_PHONE -- 收款手机号码
    ,P1.PAYEE_BANK_CODE -- 收款清算行行号
    ,P1.PAYEE_BANK_NAME -- 收款清算行名称
    ,nvl(trim(P1.payer_cert_type),'0000') -- 付款证件类型代码
    ,P1.PAYER_ACCT_NO -- 付款账户编号
    ,P1.PAYER_ACCT_NAME -- 付款账户名称
    ,nvl(trim(P1.PAYER_ACCT_TYPE),'-') -- 付款账户类别代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.PAYER_HOST_TYPE END -- 付款账户归属系统代码
    ,P1.PAYER_BANK_CODE -- 付款行清算行号
    ,P1.PAYER_BANK_NAME -- 付款清算行名称
    ,P1.REAL_PAYER_ACCT_NO -- 实际付款账户编号
    ,P1.REAL_PAYER_ACCT_NAME -- 实际付款名称
    ,nvl(trim(P1.REAL_PAYER_ACCT_TYPE),'-') -- 实际付款账户类别代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.REAL_PAYER_HOST_TYPE END -- 实际付款账户归属系统代码
    ,nvl(trim(P1.IS_LIMITED),'-') -- 累计限额类型代码
    ,P1.HOST_NO -- 核心交易流水号
    ,nvl(trim(P1.HOST_STATUS),'-') -- 核心账务状态代码
    ,${iml_schema}.dateformat_max2(P1.HOST_DATE||P1.HOST_TIME) -- 核心日期
    ,P1.SYS_COMM_NO -- 调用通道流水号
    ,nvl(trim(P1.PMC_CODE),'-') -- 通道系统简称
    ,P1.PMC_NO -- 通道交易流水号
    ,nvl(trim(P1.PMC_STATUS),'-') -- 通道原始状态代码
    ,P1.PMC_RET_NO -- 通道响应流水号
    ,${iml_schema}.dateformat_max2(P1.PMC_RET_DATE||P1.PMC_RET_TIME) -- 通道响应日期
    ,P1.PMC_RET_STATUS -- 通道响应状态代码
    ,${iml_schema}.dateformat_max2(P1.PMC_DATE||P1.PMC_TIME) -- 通道交易日期
    ,P1.PMC_COST -- 通道成本费
    ,${iml_schema}.dateformat_max2(P1.CHECK_DATE) -- 对账日期
    ,nvl(trim(P1.CHECKED),'-') -- 对账处理标识
    ,nvl(trim(P1.CHECK_FLAG),'-') -- 对账标识类型代码
    ,P1.BALANCE_DESC -- 对账结果描述
    ,P1.CHECK_TIME -- 对账处理日期
    ,P1.CHL_CHECKING_CODE -- 渠道对账编码
    ,${iml_schema}.dateformat_max2(P1.CHL_CHECK_DATE) -- 渠道对账日期
    ,nvl(trim(P1.MCHT_CHECK_MODE),'-') -- 渠道对账模式代码
    ,P1.CHANNEL_DESC -- 通道对账处理描述
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.BUINESS_MODULE END -- 跨行标志
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.IS_CHARGE END -- 收取手续费标志
    ,P1.FEE_AMOUNT -- 手续费金额
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.IS_DELAY END -- 需要延时转账标志
    ,P1.DELAY_TIME -- 延长时间
    ,P1.CHECK_TELLER_NO -- 复核柜员编号
    ,P1.CONSUMER_ID -- 调用系统编号
    ,P1.INIT_MCHT_NO -- 源系统编号
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.ADVANCE_FLAG END -- 垫支标志
    ,P1.BIZ_SYS_CODE -- 归属系统编号
    ,P1.CREATE_TIME -- 首次创建日期
    ,P1.UPDATE_TIME -- 最后更新日期
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ppps_t_txn_credit' -- 源表名称
    ,'pppsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ppps_t_txn_credit p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TXN_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'PPPS'
        AND R1.SRC_TAB_EN_NAME= 'PPPS_T_TXN_CREDIT'
        AND R1.SRC_FIELD_EN_NAME= 'TXN_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_PPPS_CRDT_CLASS_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'NOSTRO_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CLEAR_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'PPPS'
        AND R2.SRC_TAB_EN_NAME= 'PPPS_T_TXN_CREDIT'
        AND R2.SRC_FIELD_EN_NAME= 'CLEAR_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_PPPS_CRDT_CLASS_TRAN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'REALTM_CLEAR_FLG'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.PAYEE_HOST_TYPE= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'PPPS'
        AND R3.SRC_TAB_EN_NAME= 'PPPS_T_TXN_CREDIT'
        AND R3.SRC_FIELD_EN_NAME= 'PAYEE_HOST_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_PPPS_CRDT_CLASS_TRAN_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'RECVBL_ACCT_BELONG_SYS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.PAYER_HOST_TYPE= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'PPPS'
        AND R4.SRC_TAB_EN_NAME= 'PPPS_T_TXN_CREDIT'
        AND R4.SRC_FIELD_EN_NAME= 'PAYER_HOST_TYPE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_PPPS_CRDT_CLASS_TRAN_FLOW'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'PAY_ACCT_BELONG_SYS_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.REAL_PAYER_HOST_TYPE= R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'PPPS'
        AND R5.SRC_TAB_EN_NAME= 'PPPS_T_TXN_CREDIT'
        AND R5.SRC_FIELD_EN_NAME= 'REAL_PAYER_HOST_TYPE'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_PPPS_CRDT_CLASS_TRAN_FLOW'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'ACTL_PAY_ACCT_BELONG_SYS_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.BUINESS_MODULE= R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'PPPS'
        AND R6.SRC_TAB_EN_NAME= 'PPPS_T_TXN_CREDIT'
        AND R6.SRC_FIELD_EN_NAME= 'BUINESS_MODULE'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_PPPS_CRDT_CLASS_TRAN_FLOW'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'CROSS_BANK_FLG'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.IS_CHARGE= R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'PPPS'
        AND R7.SRC_TAB_EN_NAME= 'PPPS_T_TXN_CREDIT'
        AND R7.SRC_FIELD_EN_NAME= 'IS_CHARGE'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_PPPS_CRDT_CLASS_TRAN_FLOW'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'COLL_COMM_FEE_FLG'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.IS_DELAY= R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'PPPS'
        AND R8.SRC_TAB_EN_NAME= 'PPPS_T_TXN_CREDIT'
        AND R8.SRC_FIELD_EN_NAME= 'IS_DELAY'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_PPPS_CRDT_CLASS_TRAN_FLOW'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'NEED_DELAY_TRAN_ACCT_FLG'
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.ADVANCE_FLAG= R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'PPPS'
        AND R9.SRC_TAB_EN_NAME= 'PPPS_T_TXN_CREDIT'
        AND R9.SRC_FIELD_EN_NAME= 'ADVANCE_FLAG'
        AND R9.TARGET_TAB_EN_NAME= 'EVT_PPPS_CRDT_CLASS_TRAN_FLOW'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'ADV_EXP_FLG'
where  1 = 1 
     and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ppps_crdt_class_tran_flow truncate subpartition p_pppsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ppps_crdt_class_tran_flow exchange subpartition p_pppsi1_${batch_date} with table ${iml_schema}.evt_ppps_crdt_class_tran_flow_pppsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ppps_crdt_class_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ppps_crdt_class_tran_flow_pppsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ppps_crdt_class_tran_flow', partname => 'p_pppsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);