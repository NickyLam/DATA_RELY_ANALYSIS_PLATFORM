/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_intrbnk_refactor_info_h_scfsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_intrbnk_refactor_info_h add partition p_scfsf1 values ('scfsf1')(
        subpartition p_scfsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_scfsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intrbnk_refactor_info_h partition for ('scfsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_tm purge;
drop table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_op purge;
drop table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,id -- ID
    ,intrbnk_refactor_id -- 跨行再保理编号
    ,bus_type_cd -- 业务类型代码
    ,flow_status_cd -- 流程状态代码
    ,tran_status_cd -- 交易状态代码
    ,init_agt_id -- 原协议编号
    ,factor_bank_no -- 保理行号
    ,factor_bank_name -- 保理行名称
    ,refactor_bank_no -- 再保理行号
    ,refactor_bank_name -- 再保理行名称
    ,aldy_sell_refactor_id -- 已卖出再保理编号
    ,sell_dt -- 卖出日期
    ,buy_out_net_amnt -- 买断净额
    ,buy_out_amt -- 买断金额
    ,buy_out_int_rat -- 买断利率
    ,buy_int -- 买断利息
    ,buy_out_net_amnt_pay_tenor -- 买断净额支付期限
    ,comm_fee -- 手续费
    ,tenor -- 期限
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,crdt_risk_guar_bank_name -- 信用风险担保行名称
    ,pre_recv_int_flg -- 预收息标志
    ,int_paybl -- 应付利息
    ,cfm_closing_dt -- 确认截止日期
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,open_bank_num -- 开户行号
    ,open_bank_name -- 开户行名称
    ,lg_pay_id -- 大额支付编号
    ,cotas_name -- 联系人名称
    ,tel -- 电话
    ,mailbox -- 邮箱
    ,deduct_status_cd -- 回款划出状态代码
    ,deduct_dt -- 回款划出日期
    ,rededuct_flow_num -- 回款划出转账流水号
    ,rededuct_dt -- 回款划出转账日期
    ,rededuct_plat_flow_num -- 回款划出转账平台流水号
    ,rededuct_plat_tran_dt -- 回款划出转账平台交易日期
    ,rededuct_pay_acct_id -- 回款划出付款账户编号
    ,rededuct_pay_name -- 回款划出付款名称
    ,rededuct_pay_acct_bal -- 回款划出付款账户余额
    ,rededuct_recver_bank_id -- 回款划出收款方银行编号
    ,rededuct_recver_acct_id -- 回款划出收款人账户编号
    ,rededuct_recvbl_name -- 回款划出收款名称
    ,rededuct_postsc -- 回款划出附言
    ,amort_rgst_status_cd -- 摊销登记状态代码
    ,sys_del_flg -- 系统内删除标志
    ,remark -- 备注
    ,operr_id -- 经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,entry_org_id -- 记账机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intrbnk_refactor_info_h partition for ('scfsf1')
where 0=1
;

create table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intrbnk_refactor_info_h partition for ('scfsf1') where 0=1;

create table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_intrbnk_refactor_info_h partition for ('scfsf1') where 0=1;

-- 3.1 get new data into table
-- scfs_biz_inter_bank_fact_inf-1
insert into ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,id -- ID
    ,intrbnk_refactor_id -- 跨行再保理编号
    ,bus_type_cd -- 业务类型代码
    ,flow_status_cd -- 流程状态代码
    ,tran_status_cd -- 交易状态代码
    ,init_agt_id -- 原协议编号
    ,factor_bank_no -- 保理行号
    ,factor_bank_name -- 保理行名称
    ,refactor_bank_no -- 再保理行号
    ,refactor_bank_name -- 再保理行名称
    ,aldy_sell_refactor_id -- 已卖出再保理编号
    ,sell_dt -- 卖出日期
    ,buy_out_net_amnt -- 买断净额
    ,buy_out_amt -- 买断金额
    ,buy_out_int_rat -- 买断利率
    ,buy_int -- 买断利息
    ,buy_out_net_amnt_pay_tenor -- 买断净额支付期限
    ,comm_fee -- 手续费
    ,tenor -- 期限
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,crdt_risk_guar_bank_name -- 信用风险担保行名称
    ,pre_recv_int_flg -- 预收息标志
    ,int_paybl -- 应付利息
    ,cfm_closing_dt -- 确认截止日期
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,open_bank_num -- 开户行号
    ,open_bank_name -- 开户行名称
    ,lg_pay_id -- 大额支付编号
    ,cotas_name -- 联系人名称
    ,tel -- 电话
    ,mailbox -- 邮箱
    ,deduct_status_cd -- 回款划出状态代码
    ,deduct_dt -- 回款划出日期
    ,rededuct_flow_num -- 回款划出转账流水号
    ,rededuct_dt -- 回款划出转账日期
    ,rededuct_plat_flow_num -- 回款划出转账平台流水号
    ,rededuct_plat_tran_dt -- 回款划出转账平台交易日期
    ,rededuct_pay_acct_id -- 回款划出付款账户编号
    ,rededuct_pay_name -- 回款划出付款名称
    ,rededuct_pay_acct_bal -- 回款划出付款账户余额
    ,rededuct_recver_bank_id -- 回款划出收款方银行编号
    ,rededuct_recver_acct_id -- 回款划出收款人账户编号
    ,rededuct_recvbl_name -- 回款划出收款名称
    ,rededuct_postsc -- 回款划出附言
    ,amort_rgst_status_cd -- 摊销登记状态代码
    ,sys_del_flg -- 系统内删除标志
    ,remark -- 备注
    ,operr_id -- 经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,entry_org_id -- 记账机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300046'||to_char(P1.ID)||P1.VERSION -- 协议编号
    ,'9999' -- 法人编号
    ,to_char(P1.ID) -- ID
    ,P1.BANK_FACT_ID -- 跨行再保理编号
    ,nvl(trim(P1.BANK_FACT_TYPE),'-') -- 业务类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PCS_ST_CD END -- 流程状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.INTERFACE_PUSH_ST_CD END -- 交易状态代码
    ,P1.COOP_NO -- 原协议编号
    ,P1.FACT_BANK_NUM -- 保理行号
    ,P1.FACT_BANK_NM -- 保理行名称
    ,P1.RE_FACT_BANK_NUM -- 再保理行号
    ,P1.RE_FACT_BANK_NM -- 再保理行名称
    ,P1.EXPD_ID -- 已卖出再保理编号
    ,P1.SELL_DATE -- 卖出日期
    ,P1.BAY_OUT_NET_AMT -- 买断净额
    ,P1.BAY_OUT_AMT -- 买断金额
    ,P1.BAY_OUT_RATE -- 买断利率
    ,P1.BAY_OUT_RATE_AMT -- 买断利息
    ,to_number(nvl(trim(P1.BAY_OUT_PAY_TERM),'0')) -- 买断净额支付期限
    ,P1.FEE_AMT -- 手续费
    ,to_number(P1.BUSS_TERM) -- 期限
    ,P1.START_DATE -- 起息日期
    ,P1.RE_FACT_FNC_TERM_DATE -- 到期日期
    ,P1.CREDIT_RISK_GUAR_BANK -- 信用风险担保行名称
    ,nvl(trim(P1.WTHR_PRE_COLL_INT),'-') -- 预收息标志
    ,P1.INTEREST_PAY_AMT -- 应付利息
    ,P1.RE_FACT_BANK_COMFIRM_DEADLINE -- 确认截止日期
    ,P1.RECV_ACC_NUM -- 收款账户编号
    ,P1.RECV_ACC_NM -- 收款账户名称
    ,P1.OPEN_BANK_NUM -- 开户行号
    ,P1.OPEN_BANK_NM -- 开户行名称
    ,P1.LARGE_PAY_ACC_NUM -- 大额支付编号
    ,P1.CONTACT_NAME -- 联系人名称
    ,P1.CONTACT_PHONE -- 电话
    ,P1.EMAIL -- 邮箱
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TRANSFER_ST_CD END -- 回款划出状态代码
    ,P1.REFUND_MARK_OUT_DATE -- 回款划出日期
    ,P1.REFUND_MARK_OUT_SEQ_NO -- 回款划出转账流水号
    ,P1.REFUND_MARK_OUT_DT -- 回款划出转账日期
    ,P1.REFUND_MARK_OUT_PLATF_TRX_SEQ -- 回款划出转账平台流水号
    ,P1.REFUND_MARK_OUT_PLATF_TRX_DT -- 回款划出转账平台交易日期
    ,P1.REFUND_MARK_OUT_PAY_ACC_NO -- 回款划出付款账户编号
    ,P1.REFUND_MARK_OUT_PAY_ACC_NM -- 回款划出付款名称
    ,P1.REFUND_MARK_OUT_PAY_ACC_AMT -- 回款划出付款账户余额
    ,P1.REFUND_MARK_OUT_TO_BANK_NO -- 回款划出收款方银行编号
    ,P1.REFUND_MARK_OUT_TO_ACC_NO -- 回款划出收款人账户编号
    ,P1.REFUND_MARK_OUT_TO_ACC_NM -- 回款划出收款名称
    ,P1.REFUND_MARK_OUT_INFO -- 回款划出附言
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.AMORIZE_REGISTER_ST_CD END -- 摊销登记状态代码
    ,nvl(trim(P1.DEL_IND),'-') -- 系统内删除标志
    ,P1.OPIN -- 备注
    ,P1.RSPB_PSN_ID -- 经办人编号
    ,P1.HDL_INST_ID -- 经办机构编号
    ,P1.HDL_DT -- 经办日期
    ,P1.SELL_ORG_NUM -- 记账机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'scfs_biz_inter_bank_fact_inf' -- 源表名称
    ,'scfsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.scfs_biz_inter_bank_fact_inf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on  P1.PCS_ST_CD = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'SCFS'
        AND R1.SRC_TAB_EN_NAME= 'SCFS_BIZ_INTER_BANK_FACT_INF'
        AND R1.SRC_FIELD_EN_NAME= 'PCS_ST_CD'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_INTRBNK_REFACTOR_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'FLOW_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on  P1.INTERFACE_PUSH_ST_CD = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'SCFS'
        AND R2.SRC_TAB_EN_NAME= 'SCFS_BIZ_INTER_BANK_FACT_INF'
        AND R2.SRC_FIELD_EN_NAME= 'INTERFACE_PUSH_ST_CD'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_INTRBNK_REFACTOR_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on  P1.TRANSFER_ST_CD = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'SCFS'
        AND R3.SRC_TAB_EN_NAME= 'SCFS_BIZ_INTER_BANK_FACT_INF'
        AND R3.SRC_FIELD_EN_NAME= 'TRANSFER_ST_CD'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_INTRBNK_REFACTOR_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'DEDUCT_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on  P1.AMORIZE_REGISTER_ST_CD = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'SCFS'
        AND R4.SRC_TAB_EN_NAME= 'SCFS_BIZ_INTER_BANK_FACT_INF'
        AND R4.SRC_FIELD_EN_NAME= 'AMORIZE_REGISTER_ST_CD'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_INTRBNK_REFACTOR_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'AMORT_RGST_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,id -- ID
    ,intrbnk_refactor_id -- 跨行再保理编号
    ,bus_type_cd -- 业务类型代码
    ,flow_status_cd -- 流程状态代码
    ,tran_status_cd -- 交易状态代码
    ,init_agt_id -- 原协议编号
    ,factor_bank_no -- 保理行号
    ,factor_bank_name -- 保理行名称
    ,refactor_bank_no -- 再保理行号
    ,refactor_bank_name -- 再保理行名称
    ,aldy_sell_refactor_id -- 已卖出再保理编号
    ,sell_dt -- 卖出日期
    ,buy_out_net_amnt -- 买断净额
    ,buy_out_amt -- 买断金额
    ,buy_out_int_rat -- 买断利率
    ,buy_int -- 买断利息
    ,buy_out_net_amnt_pay_tenor -- 买断净额支付期限
    ,comm_fee -- 手续费
    ,tenor -- 期限
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,crdt_risk_guar_bank_name -- 信用风险担保行名称
    ,pre_recv_int_flg -- 预收息标志
    ,int_paybl -- 应付利息
    ,cfm_closing_dt -- 确认截止日期
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,open_bank_num -- 开户行号
    ,open_bank_name -- 开户行名称
    ,lg_pay_id -- 大额支付编号
    ,cotas_name -- 联系人名称
    ,tel -- 电话
    ,mailbox -- 邮箱
    ,deduct_status_cd -- 回款划出状态代码
    ,deduct_dt -- 回款划出日期
    ,rededuct_flow_num -- 回款划出转账流水号
    ,rededuct_dt -- 回款划出转账日期
    ,rededuct_plat_flow_num -- 回款划出转账平台流水号
    ,rededuct_plat_tran_dt -- 回款划出转账平台交易日期
    ,rededuct_pay_acct_id -- 回款划出付款账户编号
    ,rededuct_pay_name -- 回款划出付款名称
    ,rededuct_pay_acct_bal -- 回款划出付款账户余额
    ,rededuct_recver_bank_id -- 回款划出收款方银行编号
    ,rededuct_recver_acct_id -- 回款划出收款人账户编号
    ,rededuct_recvbl_name -- 回款划出收款名称
    ,rededuct_postsc -- 回款划出附言
    ,amort_rgst_status_cd -- 摊销登记状态代码
    ,sys_del_flg -- 系统内删除标志
    ,remark -- 备注
    ,operr_id -- 经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,entry_org_id -- 记账机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,id -- ID
    ,intrbnk_refactor_id -- 跨行再保理编号
    ,bus_type_cd -- 业务类型代码
    ,flow_status_cd -- 流程状态代码
    ,tran_status_cd -- 交易状态代码
    ,init_agt_id -- 原协议编号
    ,factor_bank_no -- 保理行号
    ,factor_bank_name -- 保理行名称
    ,refactor_bank_no -- 再保理行号
    ,refactor_bank_name -- 再保理行名称
    ,aldy_sell_refactor_id -- 已卖出再保理编号
    ,sell_dt -- 卖出日期
    ,buy_out_net_amnt -- 买断净额
    ,buy_out_amt -- 买断金额
    ,buy_out_int_rat -- 买断利率
    ,buy_int -- 买断利息
    ,buy_out_net_amnt_pay_tenor -- 买断净额支付期限
    ,comm_fee -- 手续费
    ,tenor -- 期限
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,crdt_risk_guar_bank_name -- 信用风险担保行名称
    ,pre_recv_int_flg -- 预收息标志
    ,int_paybl -- 应付利息
    ,cfm_closing_dt -- 确认截止日期
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,open_bank_num -- 开户行号
    ,open_bank_name -- 开户行名称
    ,lg_pay_id -- 大额支付编号
    ,cotas_name -- 联系人名称
    ,tel -- 电话
    ,mailbox -- 邮箱
    ,deduct_status_cd -- 回款划出状态代码
    ,deduct_dt -- 回款划出日期
    ,rededuct_flow_num -- 回款划出转账流水号
    ,rededuct_dt -- 回款划出转账日期
    ,rededuct_plat_flow_num -- 回款划出转账平台流水号
    ,rededuct_plat_tran_dt -- 回款划出转账平台交易日期
    ,rededuct_pay_acct_id -- 回款划出付款账户编号
    ,rededuct_pay_name -- 回款划出付款名称
    ,rededuct_pay_acct_bal -- 回款划出付款账户余额
    ,rededuct_recver_bank_id -- 回款划出收款方银行编号
    ,rededuct_recver_acct_id -- 回款划出收款人账户编号
    ,rededuct_recvbl_name -- 回款划出收款名称
    ,rededuct_postsc -- 回款划出附言
    ,amort_rgst_status_cd -- 摊销登记状态代码
    ,sys_del_flg -- 系统内删除标志
    ,remark -- 备注
    ,operr_id -- 经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,entry_org_id -- 记账机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.id, o.id) as id -- ID
    ,nvl(n.intrbnk_refactor_id, o.intrbnk_refactor_id) as intrbnk_refactor_id -- 跨行再保理编号
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.flow_status_cd, o.flow_status_cd) as flow_status_cd -- 流程状态代码
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.init_agt_id, o.init_agt_id) as init_agt_id -- 原协议编号
    ,nvl(n.factor_bank_no, o.factor_bank_no) as factor_bank_no -- 保理行号
    ,nvl(n.factor_bank_name, o.factor_bank_name) as factor_bank_name -- 保理行名称
    ,nvl(n.refactor_bank_no, o.refactor_bank_no) as refactor_bank_no -- 再保理行号
    ,nvl(n.refactor_bank_name, o.refactor_bank_name) as refactor_bank_name -- 再保理行名称
    ,nvl(n.aldy_sell_refactor_id, o.aldy_sell_refactor_id) as aldy_sell_refactor_id -- 已卖出再保理编号
    ,nvl(n.sell_dt, o.sell_dt) as sell_dt -- 卖出日期
    ,nvl(n.buy_out_net_amnt, o.buy_out_net_amnt) as buy_out_net_amnt -- 买断净额
    ,nvl(n.buy_out_amt, o.buy_out_amt) as buy_out_amt -- 买断金额
    ,nvl(n.buy_out_int_rat, o.buy_out_int_rat) as buy_out_int_rat -- 买断利率
    ,nvl(n.buy_int, o.buy_int) as buy_int -- 买断利息
    ,nvl(n.buy_out_net_amnt_pay_tenor, o.buy_out_net_amnt_pay_tenor) as buy_out_net_amnt_pay_tenor -- 买断净额支付期限
    ,nvl(n.comm_fee, o.comm_fee) as comm_fee -- 手续费
    ,nvl(n.tenor, o.tenor) as tenor -- 期限
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.crdt_risk_guar_bank_name, o.crdt_risk_guar_bank_name) as crdt_risk_guar_bank_name -- 信用风险担保行名称
    ,nvl(n.pre_recv_int_flg, o.pre_recv_int_flg) as pre_recv_int_flg -- 预收息标志
    ,nvl(n.int_paybl, o.int_paybl) as int_paybl -- 应付利息
    ,nvl(n.cfm_closing_dt, o.cfm_closing_dt) as cfm_closing_dt -- 确认截止日期
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.recvbl_acct_name, o.recvbl_acct_name) as recvbl_acct_name -- 收款账户名称
    ,nvl(n.open_bank_num, o.open_bank_num) as open_bank_num -- 开户行号
    ,nvl(n.open_bank_name, o.open_bank_name) as open_bank_name -- 开户行名称
    ,nvl(n.lg_pay_id, o.lg_pay_id) as lg_pay_id -- 大额支付编号
    ,nvl(n.cotas_name, o.cotas_name) as cotas_name -- 联系人名称
    ,nvl(n.tel, o.tel) as tel -- 电话
    ,nvl(n.mailbox, o.mailbox) as mailbox -- 邮箱
    ,nvl(n.deduct_status_cd, o.deduct_status_cd) as deduct_status_cd -- 回款划出状态代码
    ,nvl(n.deduct_dt, o.deduct_dt) as deduct_dt -- 回款划出日期
    ,nvl(n.rededuct_flow_num, o.rededuct_flow_num) as rededuct_flow_num -- 回款划出转账流水号
    ,nvl(n.rededuct_dt, o.rededuct_dt) as rededuct_dt -- 回款划出转账日期
    ,nvl(n.rededuct_plat_flow_num, o.rededuct_plat_flow_num) as rededuct_plat_flow_num -- 回款划出转账平台流水号
    ,nvl(n.rededuct_plat_tran_dt, o.rededuct_plat_tran_dt) as rededuct_plat_tran_dt -- 回款划出转账平台交易日期
    ,nvl(n.rededuct_pay_acct_id, o.rededuct_pay_acct_id) as rededuct_pay_acct_id -- 回款划出付款账户编号
    ,nvl(n.rededuct_pay_name, o.rededuct_pay_name) as rededuct_pay_name -- 回款划出付款名称
    ,nvl(n.rededuct_pay_acct_bal, o.rededuct_pay_acct_bal) as rededuct_pay_acct_bal -- 回款划出付款账户余额
    ,nvl(n.rededuct_recver_bank_id, o.rededuct_recver_bank_id) as rededuct_recver_bank_id -- 回款划出收款方银行编号
    ,nvl(n.rededuct_recver_acct_id, o.rededuct_recver_acct_id) as rededuct_recver_acct_id -- 回款划出收款人账户编号
    ,nvl(n.rededuct_recvbl_name, o.rededuct_recvbl_name) as rededuct_recvbl_name -- 回款划出收款名称
    ,nvl(n.rededuct_postsc, o.rededuct_postsc) as rededuct_postsc -- 回款划出附言
    ,nvl(n.amort_rgst_status_cd, o.amort_rgst_status_cd) as amort_rgst_status_cd -- 摊销登记状态代码
    ,nvl(n.sys_del_flg, o.sys_del_flg) as sys_del_flg -- 系统内删除标志
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.operr_id, o.operr_id) as operr_id -- 经办人编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 经办日期
    ,nvl(n.entry_org_id, o.entry_org_id) as entry_org_id -- 记账机构编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_tm n
    full join (select * from ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.id <> n.id
        or o.intrbnk_refactor_id <> n.intrbnk_refactor_id
        or o.bus_type_cd <> n.bus_type_cd
        or o.flow_status_cd <> n.flow_status_cd
        or o.tran_status_cd <> n.tran_status_cd
        or o.init_agt_id <> n.init_agt_id
        or o.factor_bank_no <> n.factor_bank_no
        or o.factor_bank_name <> n.factor_bank_name
        or o.refactor_bank_no <> n.refactor_bank_no
        or o.refactor_bank_name <> n.refactor_bank_name
        or o.aldy_sell_refactor_id <> n.aldy_sell_refactor_id
        or o.sell_dt <> n.sell_dt
        or o.buy_out_net_amnt <> n.buy_out_net_amnt
        or o.buy_out_amt <> n.buy_out_amt
        or o.buy_out_int_rat <> n.buy_out_int_rat
        or o.buy_int <> n.buy_int
        or o.buy_out_net_amnt_pay_tenor <> n.buy_out_net_amnt_pay_tenor
        or o.comm_fee <> n.comm_fee
        or o.tenor <> n.tenor
        or o.value_dt <> n.value_dt
        or o.exp_dt <> n.exp_dt
        or o.crdt_risk_guar_bank_name <> n.crdt_risk_guar_bank_name
        or o.pre_recv_int_flg <> n.pre_recv_int_flg
        or o.int_paybl <> n.int_paybl
        or o.cfm_closing_dt <> n.cfm_closing_dt
        or o.recvbl_acct_id <> n.recvbl_acct_id
        or o.recvbl_acct_name <> n.recvbl_acct_name
        or o.open_bank_num <> n.open_bank_num
        or o.open_bank_name <> n.open_bank_name
        or o.lg_pay_id <> n.lg_pay_id
        or o.cotas_name <> n.cotas_name
        or o.tel <> n.tel
        or o.mailbox <> n.mailbox
        or o.deduct_status_cd <> n.deduct_status_cd
        or o.deduct_dt <> n.deduct_dt
        or o.rededuct_flow_num <> n.rededuct_flow_num
        or o.rededuct_dt <> n.rededuct_dt
        or o.rededuct_plat_flow_num <> n.rededuct_plat_flow_num
        or o.rededuct_plat_tran_dt <> n.rededuct_plat_tran_dt
        or o.rededuct_pay_acct_id <> n.rededuct_pay_acct_id
        or o.rededuct_pay_name <> n.rededuct_pay_name
        or o.rededuct_pay_acct_bal <> n.rededuct_pay_acct_bal
        or o.rededuct_recver_bank_id <> n.rededuct_recver_bank_id
        or o.rededuct_recver_acct_id <> n.rededuct_recver_acct_id
        or o.rededuct_recvbl_name <> n.rededuct_recvbl_name
        or o.rededuct_postsc <> n.rededuct_postsc
        or o.amort_rgst_status_cd <> n.amort_rgst_status_cd
        or o.sys_del_flg <> n.sys_del_flg
        or o.remark <> n.remark
        or o.operr_id <> n.operr_id
        or o.oper_org_id <> n.oper_org_id
        or o.oper_dt <> n.oper_dt
        or o.entry_org_id <> n.entry_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,id -- ID
    ,intrbnk_refactor_id -- 跨行再保理编号
    ,bus_type_cd -- 业务类型代码
    ,flow_status_cd -- 流程状态代码
    ,tran_status_cd -- 交易状态代码
    ,init_agt_id -- 原协议编号
    ,factor_bank_no -- 保理行号
    ,factor_bank_name -- 保理行名称
    ,refactor_bank_no -- 再保理行号
    ,refactor_bank_name -- 再保理行名称
    ,aldy_sell_refactor_id -- 已卖出再保理编号
    ,sell_dt -- 卖出日期
    ,buy_out_net_amnt -- 买断净额
    ,buy_out_amt -- 买断金额
    ,buy_out_int_rat -- 买断利率
    ,buy_int -- 买断利息
    ,buy_out_net_amnt_pay_tenor -- 买断净额支付期限
    ,comm_fee -- 手续费
    ,tenor -- 期限
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,crdt_risk_guar_bank_name -- 信用风险担保行名称
    ,pre_recv_int_flg -- 预收息标志
    ,int_paybl -- 应付利息
    ,cfm_closing_dt -- 确认截止日期
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,open_bank_num -- 开户行号
    ,open_bank_name -- 开户行名称
    ,lg_pay_id -- 大额支付编号
    ,cotas_name -- 联系人名称
    ,tel -- 电话
    ,mailbox -- 邮箱
    ,deduct_status_cd -- 回款划出状态代码
    ,deduct_dt -- 回款划出日期
    ,rededuct_flow_num -- 回款划出转账流水号
    ,rededuct_dt -- 回款划出转账日期
    ,rededuct_plat_flow_num -- 回款划出转账平台流水号
    ,rededuct_plat_tran_dt -- 回款划出转账平台交易日期
    ,rededuct_pay_acct_id -- 回款划出付款账户编号
    ,rededuct_pay_name -- 回款划出付款名称
    ,rededuct_pay_acct_bal -- 回款划出付款账户余额
    ,rededuct_recver_bank_id -- 回款划出收款方银行编号
    ,rededuct_recver_acct_id -- 回款划出收款人账户编号
    ,rededuct_recvbl_name -- 回款划出收款名称
    ,rededuct_postsc -- 回款划出附言
    ,amort_rgst_status_cd -- 摊销登记状态代码
    ,sys_del_flg -- 系统内删除标志
    ,remark -- 备注
    ,operr_id -- 经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,entry_org_id -- 记账机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,id -- ID
    ,intrbnk_refactor_id -- 跨行再保理编号
    ,bus_type_cd -- 业务类型代码
    ,flow_status_cd -- 流程状态代码
    ,tran_status_cd -- 交易状态代码
    ,init_agt_id -- 原协议编号
    ,factor_bank_no -- 保理行号
    ,factor_bank_name -- 保理行名称
    ,refactor_bank_no -- 再保理行号
    ,refactor_bank_name -- 再保理行名称
    ,aldy_sell_refactor_id -- 已卖出再保理编号
    ,sell_dt -- 卖出日期
    ,buy_out_net_amnt -- 买断净额
    ,buy_out_amt -- 买断金额
    ,buy_out_int_rat -- 买断利率
    ,buy_int -- 买断利息
    ,buy_out_net_amnt_pay_tenor -- 买断净额支付期限
    ,comm_fee -- 手续费
    ,tenor -- 期限
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,crdt_risk_guar_bank_name -- 信用风险担保行名称
    ,pre_recv_int_flg -- 预收息标志
    ,int_paybl -- 应付利息
    ,cfm_closing_dt -- 确认截止日期
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,open_bank_num -- 开户行号
    ,open_bank_name -- 开户行名称
    ,lg_pay_id -- 大额支付编号
    ,cotas_name -- 联系人名称
    ,tel -- 电话
    ,mailbox -- 邮箱
    ,deduct_status_cd -- 回款划出状态代码
    ,deduct_dt -- 回款划出日期
    ,rededuct_flow_num -- 回款划出转账流水号
    ,rededuct_dt -- 回款划出转账日期
    ,rededuct_plat_flow_num -- 回款划出转账平台流水号
    ,rededuct_plat_tran_dt -- 回款划出转账平台交易日期
    ,rededuct_pay_acct_id -- 回款划出付款账户编号
    ,rededuct_pay_name -- 回款划出付款名称
    ,rededuct_pay_acct_bal -- 回款划出付款账户余额
    ,rededuct_recver_bank_id -- 回款划出收款方银行编号
    ,rededuct_recver_acct_id -- 回款划出收款人账户编号
    ,rededuct_recvbl_name -- 回款划出收款名称
    ,rededuct_postsc -- 回款划出附言
    ,amort_rgst_status_cd -- 摊销登记状态代码
    ,sys_del_flg -- 系统内删除标志
    ,remark -- 备注
    ,operr_id -- 经办人编号
    ,oper_org_id -- 经办机构编号
    ,oper_dt -- 经办日期
    ,entry_org_id -- 记账机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.id -- ID
    ,o.intrbnk_refactor_id -- 跨行再保理编号
    ,o.bus_type_cd -- 业务类型代码
    ,o.flow_status_cd -- 流程状态代码
    ,o.tran_status_cd -- 交易状态代码
    ,o.init_agt_id -- 原协议编号
    ,o.factor_bank_no -- 保理行号
    ,o.factor_bank_name -- 保理行名称
    ,o.refactor_bank_no -- 再保理行号
    ,o.refactor_bank_name -- 再保理行名称
    ,o.aldy_sell_refactor_id -- 已卖出再保理编号
    ,o.sell_dt -- 卖出日期
    ,o.buy_out_net_amnt -- 买断净额
    ,o.buy_out_amt -- 买断金额
    ,o.buy_out_int_rat -- 买断利率
    ,o.buy_int -- 买断利息
    ,o.buy_out_net_amnt_pay_tenor -- 买断净额支付期限
    ,o.comm_fee -- 手续费
    ,o.tenor -- 期限
    ,o.value_dt -- 起息日期
    ,o.exp_dt -- 到期日期
    ,o.crdt_risk_guar_bank_name -- 信用风险担保行名称
    ,o.pre_recv_int_flg -- 预收息标志
    ,o.int_paybl -- 应付利息
    ,o.cfm_closing_dt -- 确认截止日期
    ,o.recvbl_acct_id -- 收款账户编号
    ,o.recvbl_acct_name -- 收款账户名称
    ,o.open_bank_num -- 开户行号
    ,o.open_bank_name -- 开户行名称
    ,o.lg_pay_id -- 大额支付编号
    ,o.cotas_name -- 联系人名称
    ,o.tel -- 电话
    ,o.mailbox -- 邮箱
    ,o.deduct_status_cd -- 回款划出状态代码
    ,o.deduct_dt -- 回款划出日期
    ,o.rededuct_flow_num -- 回款划出转账流水号
    ,o.rededuct_dt -- 回款划出转账日期
    ,o.rededuct_plat_flow_num -- 回款划出转账平台流水号
    ,o.rededuct_plat_tran_dt -- 回款划出转账平台交易日期
    ,o.rededuct_pay_acct_id -- 回款划出付款账户编号
    ,o.rededuct_pay_name -- 回款划出付款名称
    ,o.rededuct_pay_acct_bal -- 回款划出付款账户余额
    ,o.rededuct_recver_bank_id -- 回款划出收款方银行编号
    ,o.rededuct_recver_acct_id -- 回款划出收款人账户编号
    ,o.rededuct_recvbl_name -- 回款划出收款名称
    ,o.rededuct_postsc -- 回款划出附言
    ,o.amort_rgst_status_cd -- 摊销登记状态代码
    ,o.sys_del_flg -- 系统内删除标志
    ,o.remark -- 备注
    ,o.operr_id -- 经办人编号
    ,o.oper_org_id -- 经办机构编号
    ,o.oper_dt -- 经办日期
    ,o.entry_org_id -- 记账机构编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_bk o
    left join ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_intrbnk_refactor_info_h;
--alter table ${iml_schema}.agt_intrbnk_refactor_info_h truncate partition for ('scfsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_intrbnk_refactor_info_h') 
               and substr(subpartition_name,1,8)=upper('p_scfsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_intrbnk_refactor_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_intrbnk_refactor_info_h modify partition p_scfsf1 
add subpartition p_scfsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_intrbnk_refactor_info_h exchange subpartition p_scfsf1_${batch_date} with table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_cl;
alter table ${iml_schema}.agt_intrbnk_refactor_info_h exchange subpartition p_scfsf1_20991231 with table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_intrbnk_refactor_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_tm purge;
drop table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_op purge;
drop table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_intrbnk_refactor_info_h_scfsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_intrbnk_refactor_info_h', partname => 'p_scfsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
