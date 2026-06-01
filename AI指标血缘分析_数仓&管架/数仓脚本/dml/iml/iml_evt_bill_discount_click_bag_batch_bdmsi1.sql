/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bill_discount_click_bag_batch_bdmsi1
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
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_bill_discount_click_bag_batch add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

create table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_discount_click_bag_batch partition for ('bdmsi1') 
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_tm purge;
drop table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_op purge;
drop table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_ser_num -- 批次序列号
    ,batch_id -- 批次编号
    ,bus_type_cd -- 业务类型代码
    ,bus_dt -- 业务日期
    ,tran_dir_cd -- 交易方向代码
    ,anony_flg -- 匿名标志
    ,tran_range_cd -- 交易范围代码
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,tran_teller_id -- 交易柜员编号
    ,bill_type_cd -- 票据类型代码
    ,bill_attr_cd -- 票据属性代码
    ,part_bag_option_flg -- 部分成交选项标志
    ,quot_valid_tm -- 报价有效时间
    ,stop_stl_tm -- 截止结算时间
    ,clear_speed_cd -- 清算速度代码
    ,bill_cnt -- 票据张数
    ,bill_tot -- 票据总额
    ,yld_rat -- 收益率
    ,weight_avg_surp_tenor -- 加权平均剩余期限
    ,stl_amt -- 结算金额
    ,discnt_int_rat -- 贴现利率
    ,int_paybl -- 应付利息
    ,stl_dt -- 结算日期
    ,stl_way_cd -- 结算方式代码
    ,clear_type_cd -- 清算类型代码
    ,cntpty_clear_mode -- 交易对手方清算模式
    ,cntpty_org_cd -- 交易对手方机构代码
    ,cntpty_non_lp_prod_id -- 交易对手方非法人产品编号
    ,cntpty_tran_teller_id -- 交易对手方交易柜员编号
    ,pay_cfm_flg -- 付款确认标志
    ,shortest_surp_tenor -- 最短剩余期限
    ,lont_surp_tenor -- 最长剩余期限
    ,bill_exp_begin_day -- 票据到期起始日
    ,bill_exp_stop_day -- 票据到期截止日
    ,min_singl_fac_val_amt -- 最小单张票面金额
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_code -- 信用主体编码
    ,cntpty_type_cd -- 交易对手类型代码
    ,acpt_bank_type_cd -- 承兑银行类型代码
    ,acpt_bank_id -- 承兑银行编号
    ,discnt_bank_type_cd -- 贴现银行类型代码
    ,discnt_bank_id -- 贴现银行编号
    ,guar_incre_crdt_bk_type_cd -- 保证增信行类型代码
    ,guar_incre_crdt_bank_id -- 保证增信银行编号
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,apv_status_cd -- 审批状态代码
    ,msg_proc_status_cd -- 报文处理状态代码
    ,clear_status_cd -- 清算状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_tm -- 最后修改时间
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,ctr_nt_ser_num -- 成交单序列号
    ,quot_bill_id -- 报价单编号
    ,click_bag_type_cd -- 点击成交类型代码
    ,ctr_nt_id -- 成交单编号
    ,quot_forward_cnt -- 报价转发次数
    ,batch_type_cd -- 批次类型代码
    ,ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_discount_click_bag_batch partition for ('bdmsi1')
where 0=1
;

create table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_discount_click_bag_batch partition for ('bdmsi1') where 0=1;

create table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_discount_click_bag_batch partition for ('bdmsi1') where 0=1;

-- 3.1 get new data into table
-- bdms_cpes_click_deal_contract-
insert into ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_ser_num -- 批次序列号
    ,batch_id -- 批次编号
    ,bus_type_cd -- 业务类型代码
    ,bus_dt -- 业务日期
    ,tran_dir_cd -- 交易方向代码
    ,anony_flg -- 匿名标志
    ,tran_range_cd -- 交易范围代码
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,tran_teller_id -- 交易柜员编号
    ,bill_type_cd -- 票据类型代码
    ,bill_attr_cd -- 票据属性代码
    ,part_bag_option_flg -- 部分成交选项标志
    ,quot_valid_tm -- 报价有效时间
    ,stop_stl_tm -- 截止结算时间
    ,clear_speed_cd -- 清算速度代码
    ,bill_cnt -- 票据张数
    ,bill_tot -- 票据总额
    ,yld_rat -- 收益率
    ,weight_avg_surp_tenor -- 加权平均剩余期限
    ,stl_amt -- 结算金额
    ,discnt_int_rat -- 贴现利率
    ,int_paybl -- 应付利息
    ,stl_dt -- 结算日期
    ,stl_way_cd -- 结算方式代码
    ,clear_type_cd -- 清算类型代码
    ,cntpty_clear_mode -- 交易对手方清算模式
    ,cntpty_org_cd -- 交易对手方机构代码
    ,cntpty_non_lp_prod_id -- 交易对手方非法人产品编号
    ,cntpty_tran_teller_id -- 交易对手方交易柜员编号
    ,pay_cfm_flg -- 付款确认标志
    ,shortest_surp_tenor -- 最短剩余期限
    ,lont_surp_tenor -- 最长剩余期限
    ,bill_exp_begin_day -- 票据到期起始日
    ,bill_exp_stop_day -- 票据到期截止日
    ,min_singl_fac_val_amt -- 最小单张票面金额
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_code -- 信用主体编码
    ,cntpty_type_cd -- 交易对手类型代码
    ,acpt_bank_type_cd -- 承兑银行类型代码
    ,acpt_bank_id -- 承兑银行编号
    ,discnt_bank_type_cd -- 贴现银行类型代码
    ,discnt_bank_id -- 贴现银行编号
    ,guar_incre_crdt_bk_type_cd -- 保证增信行类型代码
    ,guar_incre_crdt_bank_id -- 保证增信银行编号
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,apv_status_cd -- 审批状态代码
    ,msg_proc_status_cd -- 报文处理状态代码
    ,clear_status_cd -- 清算状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_tm -- 最后修改时间
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,ctr_nt_ser_num -- 成交单序列号
    ,quot_bill_id -- 报价单编号
    ,click_bag_type_cd -- 点击成交类型代码
    ,ctr_nt_id -- 成交单编号
    ,quot_forward_cnt -- 报价转发次数
    ,batch_type_cd -- 批次类型代码
    ,ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105005'||p1.id -- 事件编号
    ,'9999' -- 法人编号
    ,p1.id -- 批次序列号
    ,p1.contract_no -- 批次编号
    ,nvl(trim(P1.busi_type),'BT00') -- 业务类型代码
    ,${iml_schema}.DATEFORMAT_MAX2(p1.busi_date) -- 业务日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TRADE_DIRECT END -- 交易方向代码
    ,NVL(TRIM(p1.is_anonymous),'-'） -- 匿名标志
    ,case when R3.target_cd_val is not null then R3.target_cd_val else '@'||p1.trade_scope end -- 交易范围代码
    ,p1.busi_branch_no -- 业务机构编号
    ,p1.top_branch_no -- 总行机构编号
    ,p1.own_user_id -- 交易柜员编号
    ,nvl(trim(P1.DRAFT_TYPE),'-') -- 票据类型代码
    ,case when R5.target_cd_val is not null then R5.target_cd_val else '@'||p1.draft_attr end -- 票据属性代码
    ,NVL(TRIM(p1.sub_deal_flag),'-'） -- 部分成交选项标志
    ,${iml_schema}.TIMEFORMAT_MAX2(p1.quote_valid_tm) -- 报价有效时间
    ,${iml_schema}.TIMEFORMAT_MAX2(p1.settle_time) -- 截止结算时间
    ,case when R6.target_cd_val is not null then R6.target_cd_val else '@'||p1.clear_speed end -- 清算速度代码
    ,P1.sum_count -- 票据张数
    ,P1.sum_amount -- 票据总额
    ,P1.yield_rate -- 收益率
    ,P1.tenor_days -- 加权平均剩余期限
    ,P1.settle_amt -- 结算金额
    ,P1.rate -- 贴现利率
    ,P1.pay_interest -- 应付利息
    ,${iml_schema}.DATEFORMAT_MAX2(p1.settle_date) -- 结算日期
    ,case when R7.target_cd_val is not null then R7.target_cd_val else '@'||p1.settle_mode end -- 结算方式代码
    ,case when R8.target_cd_val is not null then R8.target_cd_val else '@'||p1.clear_type end -- 清算类型代码
    ,case when R9.target_cd_val is not null then R9.target_cd_val else '@'||p1.adver_clear_mode end -- 交易对手方清算模式
    ,p1.adver_brh_no -- 交易对手方机构代码
    ,p1.adver_pro_no -- 交易对手方非法人产品编号
    ,p1.adver_user_id -- 交易对手方交易柜员编号
    ,NVL(TRIM(p1.is_need_pay_confirm),'-') -- 付款确认标志
    ,P1.min_tenor_days -- 最短剩余期限
    ,P1.max_tenor_days -- 最长剩余期限
    ,${iml_schema}.DATEFORMAT_MAX2(p1.due_date_begin) -- 票据到期起始日
    ,${iml_schema}.DATEFORMAT_MAX2(p1.due_date_end) -- 票据到期截止日
    ,P1.min_draft_amt -- 最小单张票面金额
    ,nvl(trim(p1.credit_type),'000') -- 信用主体类型代码
    ,p1.credit_codes -- 信用主体编码
    ,nvl(trim(p1.cust_types),'000') -- 交易对手类型代码
    ,nvl(trim(p1.accept_brh_types),'000') -- 承兑银行类型代码
    ,p1.accept_brh_no_list -- 承兑银行编号
    ,nvl(trim(p1.discount_brh_no_types),'000') -- 贴现银行类型代码
    ,p1.discount_brh_no_list -- 贴现银行编号
    ,nvl(trim(p1.guarantee_brh_types),'000') -- 保证增信行类型代码
    ,p1.guarantee_brh_no_list -- 保证增信银行编号
    ,P1.DEPARTMENT_NO -- 部门编号
    ,p1.manager_no -- 客户经理编号
    ,CASE WHEN R12.TARGET_CD_VAL IS NOT NULL THEN R12.TARGET_CD_VAL ELSE '@'||P1.CONTRACT_STATUS END -- 审批状态代码
    ,case when R10.target_cd_val is not null then R10.target_cd_val else '@'||p1.message_status end -- 报文处理状态代码
    ,nvl(trim(p1.settle_status),'-') -- 清算状态代码
    ,case when R11.target_cd_val is not null then R11.target_cd_val else '@'||p1.account_status end -- 记账状态代码
    ,${iml_schema}.timeformat_max2(p1.last_upd_time) -- 最后修改时间
    ,p1.product_no -- 产品编号
    ,nvl(trim(p2.PROD_CODE),' ') -- 标准产品编号
    ,p1.deal_id -- 成交单序列号
    ,p1.quote_no -- 报价单编号
    ,nvl(trim(p1.click_type),'-') -- 点击成交类型代码
    ,p1.dealed_no -- 成交单编号
    ,P1.forward_num -- 报价转发次数
    ,case when R4.target_cd_val is not null then R4.target_cd_val else '@'||p1.ck_contract_type end -- 批次类型代码
    ,nvl(trim(p1.credit_check_status),'-') -- 同业授信额度占用状态代码
    ,nvl(trim(p1.i9_type),'XXX') -- 资产三分类代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_click_deal_contract' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_click_deal_contract p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TRADE_DIRECT= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CPES_CLICK_DEAL_CONTRACT'
        AND R2.SRC_FIELD_EN_NAME= 'TRADE_DIRECT'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_BILL_DISCOUNT_CLICK_BAG_BATCH'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TRADE_SCOPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_CPES_CLICK_DEAL_CONTRACT'
        AND R3.SRC_FIELD_EN_NAME= 'TRADE_SCOPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_BILL_DISCOUNT_CLICK_BAG_BATCH'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_RANGE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.DRAFT_ATTR = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'BDMS'
        AND R5.SRC_TAB_EN_NAME= 'BDMS_CPES_CLICK_DEAL_CONTRACT'
        AND R5.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_BILL_DISCOUNT_CLICK_BAG_BATCH'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'BILL_ATTR_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.CLEAR_SPEED = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'BDMS'
        AND R6.SRC_TAB_EN_NAME= 'BDMS_CPES_CLICK_DEAL_CONTRACT'
        AND R6.SRC_FIELD_EN_NAME= 'CLEAR_SPEED'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_BILL_DISCOUNT_CLICK_BAG_BATCH'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_SPEED_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.SETTLE_MODE = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'BDMS'
        AND R7.SRC_TAB_EN_NAME= 'BDMS_CPES_CLICK_DEAL_CONTRACT'
        AND R7.SRC_FIELD_EN_NAME= 'SETTLE_MODE'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_BILL_DISCOUNT_CLICK_BAG_BATCH'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.CLEAR_TYPE = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'BDMS'
        AND R8.SRC_TAB_EN_NAME= 'BDMS_CPES_CLICK_DEAL_CONTRACT'
        AND R8.SRC_FIELD_EN_NAME= 'CLEAR_TYPE'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_BILL_DISCOUNT_CLICK_BAG_BATCH'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.ADVER_CLEAR_MODE = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'BDMS'
        AND R9.SRC_TAB_EN_NAME= 'BDMS_CPES_CLICK_DEAL_CONTRACT'
        AND R9.SRC_FIELD_EN_NAME= 'ADVER_CLEAR_MODE'
        AND R9.TARGET_TAB_EN_NAME= 'EVT_BILL_DISCOUNT_CLICK_BAG_BATCH'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'CNTPTY_CLEAR_MODE'
    left join ${iml_schema}.ref_pub_cd_map r12 on P1.CONTRACT_STATUS = R12.SRC_CODE_VAL
        AND R12.SORC_SYS_CD= 'BDMS'
        AND R12.SRC_TAB_EN_NAME= 'BDMS_CPES_CLICK_DEAL_CONTRACT'
        AND R12.SRC_FIELD_EN_NAME= 'CONTRACT_STATUS'
        AND R12.TARGET_TAB_EN_NAME= 'EVT_BILL_DISCOUNT_CLICK_BAG_BATCH'
        AND R12.TARGET_TAB_FIELD_EN_NAME= 'APV_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r10 on P1.MESSAGE_STATUS = R10.SRC_CODE_VAL
        AND R10.SORC_SYS_CD= 'BDMS'
        AND R10.SRC_TAB_EN_NAME= 'BDMS_CPES_CLICK_DEAL_CONTRACT'
        AND R10.SRC_FIELD_EN_NAME= 'MESSAGE_STATUS'
        AND R10.TARGET_TAB_EN_NAME= 'EVT_BILL_DISCOUNT_CLICK_BAG_BATCH'
        AND R10.TARGET_TAB_FIELD_EN_NAME= 'MSG_PROC_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r11 on P1.ACCOUNT_STATUS = R11.SRC_CODE_VAL
        AND R11.SORC_SYS_CD= 'BDMS'
        AND R11.SRC_TAB_EN_NAME= 'BDMS_CPES_CLICK_DEAL_CONTRACT'
        AND R11.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R11.TARGET_TAB_EN_NAME= 'EVT_BILL_DISCOUNT_CLICK_BAG_BATCH'
        AND R11.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
    left join ${iol_schema}.bdms_meta_deposit_define p2 on P1.PRODUCT_NO=P2.PRODUCT_NO 
AND P2.START_DT<= TO_DATE('${batch_date}','YYYYMMDD') 
AND P2.END_DT > TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CK_CONTRACT_TYPE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'BDMS'
        AND R4.SRC_TAB_EN_NAME= 'BDMS_CPES_CLICK_DEAL_CONTRACT'
        AND R4.SRC_FIELD_EN_NAME= 'CK_CONTRACT_TYPE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_BILL_DISCOUNT_CLICK_BAG_BATCH'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'BATCH_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND substr(trim(P1.last_upd_time),1,8)='${batch_date}'
;
commit;


commit;


whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_tm 
  	                                group by 
  	                                        evt_id
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

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_op(
        evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_ser_num -- 批次序列号
    ,batch_id -- 批次编号
    ,bus_type_cd -- 业务类型代码
    ,bus_dt -- 业务日期
    ,tran_dir_cd -- 交易方向代码
    ,anony_flg -- 匿名标志
    ,tran_range_cd -- 交易范围代码
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,tran_teller_id -- 交易柜员编号
    ,bill_type_cd -- 票据类型代码
    ,bill_attr_cd -- 票据属性代码
    ,part_bag_option_flg -- 部分成交选项标志
    ,quot_valid_tm -- 报价有效时间
    ,stop_stl_tm -- 截止结算时间
    ,clear_speed_cd -- 清算速度代码
    ,bill_cnt -- 票据张数
    ,bill_tot -- 票据总额
    ,yld_rat -- 收益率
    ,weight_avg_surp_tenor -- 加权平均剩余期限
    ,stl_amt -- 结算金额
    ,discnt_int_rat -- 贴现利率
    ,int_paybl -- 应付利息
    ,stl_dt -- 结算日期
    ,stl_way_cd -- 结算方式代码
    ,clear_type_cd -- 清算类型代码
    ,cntpty_clear_mode -- 交易对手方清算模式
    ,cntpty_org_cd -- 交易对手方机构代码
    ,cntpty_non_lp_prod_id -- 交易对手方非法人产品编号
    ,cntpty_tran_teller_id -- 交易对手方交易柜员编号
    ,pay_cfm_flg -- 付款确认标志
    ,shortest_surp_tenor -- 最短剩余期限
    ,lont_surp_tenor -- 最长剩余期限
    ,bill_exp_begin_day -- 票据到期起始日
    ,bill_exp_stop_day -- 票据到期截止日
    ,min_singl_fac_val_amt -- 最小单张票面金额
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_code -- 信用主体编码
    ,cntpty_type_cd -- 交易对手类型代码
    ,acpt_bank_type_cd -- 承兑银行类型代码
    ,acpt_bank_id -- 承兑银行编号
    ,discnt_bank_type_cd -- 贴现银行类型代码
    ,discnt_bank_id -- 贴现银行编号
    ,guar_incre_crdt_bk_type_cd -- 保证增信行类型代码
    ,guar_incre_crdt_bank_id -- 保证增信银行编号
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,apv_status_cd -- 审批状态代码
    ,msg_proc_status_cd -- 报文处理状态代码
    ,clear_status_cd -- 清算状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_tm -- 最后修改时间
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,ctr_nt_ser_num -- 成交单序列号
    ,quot_bill_id -- 报价单编号
    ,click_bag_type_cd -- 点击成交类型代码
    ,ctr_nt_id -- 成交单编号
    ,quot_forward_cnt -- 报价转发次数
    ,batch_type_cd -- 批次类型代码
    ,ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
    ,asset_thd_cls_cd -- 资产三分类代码
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.evt_id -- 事件编号
    ,n.lp_id -- 法人编号
    ,n.batch_ser_num -- 批次序列号
    ,n.batch_id -- 批次编号
    ,n.bus_type_cd -- 业务类型代码
    ,n.bus_dt -- 业务日期
    ,n.tran_dir_cd -- 交易方向代码
    ,n.anony_flg -- 匿名标志
    ,n.tran_range_cd -- 交易范围代码
    ,n.bus_org_id -- 业务机构编号
    ,n.hq_org_id -- 总行机构编号
    ,n.tran_teller_id -- 交易柜员编号
    ,n.bill_type_cd -- 票据类型代码
    ,n.bill_attr_cd -- 票据属性代码
    ,n.part_bag_option_flg -- 部分成交选项标志
    ,n.quot_valid_tm -- 报价有效时间
    ,n.stop_stl_tm -- 截止结算时间
    ,n.clear_speed_cd -- 清算速度代码
    ,n.bill_cnt -- 票据张数
    ,n.bill_tot -- 票据总额
    ,n.yld_rat -- 收益率
    ,n.weight_avg_surp_tenor -- 加权平均剩余期限
    ,n.stl_amt -- 结算金额
    ,n.discnt_int_rat -- 贴现利率
    ,n.int_paybl -- 应付利息
    ,n.stl_dt -- 结算日期
    ,n.stl_way_cd -- 结算方式代码
    ,n.clear_type_cd -- 清算类型代码
    ,n.cntpty_clear_mode -- 交易对手方清算模式
    ,n.cntpty_org_cd -- 交易对手方机构代码
    ,n.cntpty_non_lp_prod_id -- 交易对手方非法人产品编号
    ,n.cntpty_tran_teller_id -- 交易对手方交易柜员编号
    ,n.pay_cfm_flg -- 付款确认标志
    ,n.shortest_surp_tenor -- 最短剩余期限
    ,n.lont_surp_tenor -- 最长剩余期限
    ,n.bill_exp_begin_day -- 票据到期起始日
    ,n.bill_exp_stop_day -- 票据到期截止日
    ,n.min_singl_fac_val_amt -- 最小单张票面金额
    ,n.crdt_main_type_cd -- 信用主体类型代码
    ,n.crdt_main_code -- 信用主体编码
    ,n.cntpty_type_cd -- 交易对手类型代码
    ,n.acpt_bank_type_cd -- 承兑银行类型代码
    ,n.acpt_bank_id -- 承兑银行编号
    ,n.discnt_bank_type_cd -- 贴现银行类型代码
    ,n.discnt_bank_id -- 贴现银行编号
    ,n.guar_incre_crdt_bk_type_cd -- 保证增信行类型代码
    ,n.guar_incre_crdt_bank_id -- 保证增信银行编号
    ,n.dept_id -- 部门编号
    ,n.cust_mgr_id -- 客户经理编号
    ,n.apv_status_cd -- 审批状态代码
    ,n.msg_proc_status_cd -- 报文处理状态代码
    ,n.clear_status_cd -- 清算状态代码
    ,n.entry_status_cd -- 记账状态代码
    ,n.final_modif_tm -- 最后修改时间
    ,n.prod_id -- 产品编号
    ,n.std_prod_id -- 标准产品编号
    ,n.ctr_nt_ser_num -- 成交单序列号
    ,n.quot_bill_id -- 报价单编号
    ,n.click_bag_type_cd -- 点击成交类型代码
    ,n.ctr_nt_id -- 成交单编号
    ,n.quot_forward_cnt -- 报价转发次数
    ,n.batch_type_cd -- 批次类型代码
    ,n.ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
    ,n.asset_thd_cls_cd -- 资产三分类代码
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'bdmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_tm n
    left join ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_bk o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        o.batch_ser_num <> n.batch_ser_num
        or o.batch_id <> n.batch_id
        or o.bus_type_cd <> n.bus_type_cd
        or o.bus_dt <> n.bus_dt
        or o.tran_dir_cd <> n.tran_dir_cd
        or o.anony_flg <> n.anony_flg
        or o.tran_range_cd <> n.tran_range_cd
        or o.bus_org_id <> n.bus_org_id
        or o.hq_org_id <> n.hq_org_id
        or o.tran_teller_id <> n.tran_teller_id
        or o.bill_type_cd <> n.bill_type_cd
        or o.bill_attr_cd <> n.bill_attr_cd
        or o.part_bag_option_flg <> n.part_bag_option_flg
        or o.quot_valid_tm <> n.quot_valid_tm
        or o.stop_stl_tm <> n.stop_stl_tm
        or o.clear_speed_cd <> n.clear_speed_cd
        or o.bill_cnt <> n.bill_cnt
        or o.bill_tot <> n.bill_tot
        or o.yld_rat <> n.yld_rat
        or o.weight_avg_surp_tenor <> n.weight_avg_surp_tenor
        or o.stl_amt <> n.stl_amt
        or o.discnt_int_rat <> n.discnt_int_rat
        or o.int_paybl <> n.int_paybl
        or o.stl_dt <> n.stl_dt
        or o.stl_way_cd <> n.stl_way_cd
        or o.clear_type_cd <> n.clear_type_cd
        or o.cntpty_clear_mode <> n.cntpty_clear_mode
        or o.cntpty_org_cd <> n.cntpty_org_cd
        or o.cntpty_non_lp_prod_id <> n.cntpty_non_lp_prod_id
        or o.cntpty_tran_teller_id <> n.cntpty_tran_teller_id
        or o.pay_cfm_flg <> n.pay_cfm_flg
        or o.shortest_surp_tenor <> n.shortest_surp_tenor
        or o.lont_surp_tenor <> n.lont_surp_tenor
        or o.bill_exp_begin_day <> n.bill_exp_begin_day
        or o.bill_exp_stop_day <> n.bill_exp_stop_day
        or o.min_singl_fac_val_amt <> n.min_singl_fac_val_amt
        or o.crdt_main_type_cd <> n.crdt_main_type_cd
        or o.crdt_main_code <> n.crdt_main_code
        or o.cntpty_type_cd <> n.cntpty_type_cd
        or o.acpt_bank_type_cd <> n.acpt_bank_type_cd
        or o.acpt_bank_id <> n.acpt_bank_id
        or o.discnt_bank_type_cd <> n.discnt_bank_type_cd
        or o.discnt_bank_id <> n.discnt_bank_id
        or o.guar_incre_crdt_bk_type_cd <> n.guar_incre_crdt_bk_type_cd
        or o.guar_incre_crdt_bank_id <> n.guar_incre_crdt_bank_id
        or o.dept_id <> n.dept_id
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.apv_status_cd <> n.apv_status_cd
        or o.msg_proc_status_cd <> n.msg_proc_status_cd
        or o.clear_status_cd <> n.clear_status_cd
        or o.entry_status_cd <> n.entry_status_cd
        or o.final_modif_tm <> n.final_modif_tm
        or o.prod_id <> n.prod_id
        or o.std_prod_id <> n.std_prod_id
        or o.ctr_nt_ser_num <> n.ctr_nt_ser_num
        or o.quot_bill_id <> n.quot_bill_id
        or o.click_bag_type_cd <> n.click_bag_type_cd
        or o.ctr_nt_id <> n.ctr_nt_id
        or o.quot_forward_cnt <> n.quot_forward_cnt
        or o.batch_type_cd <> n.batch_type_cd
        or o.ibank_crdt_lmt_ocup_status_cd <> n.ibank_crdt_lmt_ocup_status_cd
        or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_ser_num -- 批次序列号
    ,batch_id -- 批次编号
    ,bus_type_cd -- 业务类型代码
    ,bus_dt -- 业务日期
    ,tran_dir_cd -- 交易方向代码
    ,anony_flg -- 匿名标志
    ,tran_range_cd -- 交易范围代码
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,tran_teller_id -- 交易柜员编号
    ,bill_type_cd -- 票据类型代码
    ,bill_attr_cd -- 票据属性代码
    ,part_bag_option_flg -- 部分成交选项标志
    ,quot_valid_tm -- 报价有效时间
    ,stop_stl_tm -- 截止结算时间
    ,clear_speed_cd -- 清算速度代码
    ,bill_cnt -- 票据张数
    ,bill_tot -- 票据总额
    ,yld_rat -- 收益率
    ,weight_avg_surp_tenor -- 加权平均剩余期限
    ,stl_amt -- 结算金额
    ,discnt_int_rat -- 贴现利率
    ,int_paybl -- 应付利息
    ,stl_dt -- 结算日期
    ,stl_way_cd -- 结算方式代码
    ,clear_type_cd -- 清算类型代码
    ,cntpty_clear_mode -- 交易对手方清算模式
    ,cntpty_org_cd -- 交易对手方机构代码
    ,cntpty_non_lp_prod_id -- 交易对手方非法人产品编号
    ,cntpty_tran_teller_id -- 交易对手方交易柜员编号
    ,pay_cfm_flg -- 付款确认标志
    ,shortest_surp_tenor -- 最短剩余期限
    ,lont_surp_tenor -- 最长剩余期限
    ,bill_exp_begin_day -- 票据到期起始日
    ,bill_exp_stop_day -- 票据到期截止日
    ,min_singl_fac_val_amt -- 最小单张票面金额
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_code -- 信用主体编码
    ,cntpty_type_cd -- 交易对手类型代码
    ,acpt_bank_type_cd -- 承兑银行类型代码
    ,acpt_bank_id -- 承兑银行编号
    ,discnt_bank_type_cd -- 贴现银行类型代码
    ,discnt_bank_id -- 贴现银行编号
    ,guar_incre_crdt_bk_type_cd -- 保证增信行类型代码
    ,guar_incre_crdt_bank_id -- 保证增信银行编号
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,apv_status_cd -- 审批状态代码
    ,msg_proc_status_cd -- 报文处理状态代码
    ,clear_status_cd -- 清算状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_tm -- 最后修改时间
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,ctr_nt_ser_num -- 成交单序列号
    ,quot_bill_id -- 报价单编号
    ,click_bag_type_cd -- 点击成交类型代码
    ,ctr_nt_id -- 成交单编号
    ,quot_forward_cnt -- 报价转发次数
    ,batch_type_cd -- 批次类型代码
    ,ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
    ,asset_thd_cls_cd -- 资产三分类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,batch_ser_num -- 批次序列号
    ,batch_id -- 批次编号
    ,bus_type_cd -- 业务类型代码
    ,bus_dt -- 业务日期
    ,tran_dir_cd -- 交易方向代码
    ,anony_flg -- 匿名标志
    ,tran_range_cd -- 交易范围代码
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,tran_teller_id -- 交易柜员编号
    ,bill_type_cd -- 票据类型代码
    ,bill_attr_cd -- 票据属性代码
    ,part_bag_option_flg -- 部分成交选项标志
    ,quot_valid_tm -- 报价有效时间
    ,stop_stl_tm -- 截止结算时间
    ,clear_speed_cd -- 清算速度代码
    ,bill_cnt -- 票据张数
    ,bill_tot -- 票据总额
    ,yld_rat -- 收益率
    ,weight_avg_surp_tenor -- 加权平均剩余期限
    ,stl_amt -- 结算金额
    ,discnt_int_rat -- 贴现利率
    ,int_paybl -- 应付利息
    ,stl_dt -- 结算日期
    ,stl_way_cd -- 结算方式代码
    ,clear_type_cd -- 清算类型代码
    ,cntpty_clear_mode -- 交易对手方清算模式
    ,cntpty_org_cd -- 交易对手方机构代码
    ,cntpty_non_lp_prod_id -- 交易对手方非法人产品编号
    ,cntpty_tran_teller_id -- 交易对手方交易柜员编号
    ,pay_cfm_flg -- 付款确认标志
    ,shortest_surp_tenor -- 最短剩余期限
    ,lont_surp_tenor -- 最长剩余期限
    ,bill_exp_begin_day -- 票据到期起始日
    ,bill_exp_stop_day -- 票据到期截止日
    ,min_singl_fac_val_amt -- 最小单张票面金额
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_code -- 信用主体编码
    ,cntpty_type_cd -- 交易对手类型代码
    ,acpt_bank_type_cd -- 承兑银行类型代码
    ,acpt_bank_id -- 承兑银行编号
    ,discnt_bank_type_cd -- 贴现银行类型代码
    ,discnt_bank_id -- 贴现银行编号
    ,guar_incre_crdt_bk_type_cd -- 保证增信行类型代码
    ,guar_incre_crdt_bank_id -- 保证增信银行编号
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,apv_status_cd -- 审批状态代码
    ,msg_proc_status_cd -- 报文处理状态代码
    ,clear_status_cd -- 清算状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_tm -- 最后修改时间
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,ctr_nt_ser_num -- 成交单序列号
    ,quot_bill_id -- 报价单编号
    ,click_bag_type_cd -- 点击成交类型代码
    ,ctr_nt_id -- 成交单编号
    ,quot_forward_cnt -- 报价转发次数
    ,batch_type_cd -- 批次类型代码
    ,ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
    ,asset_thd_cls_cd -- 资产三分类代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.batch_ser_num -- 批次序列号
    ,o.batch_id -- 批次编号
    ,o.bus_type_cd -- 业务类型代码
    ,o.bus_dt -- 业务日期
    ,o.tran_dir_cd -- 交易方向代码
    ,o.anony_flg -- 匿名标志
    ,o.tran_range_cd -- 交易范围代码
    ,o.bus_org_id -- 业务机构编号
    ,o.hq_org_id -- 总行机构编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.bill_type_cd -- 票据类型代码
    ,o.bill_attr_cd -- 票据属性代码
    ,o.part_bag_option_flg -- 部分成交选项标志
    ,o.quot_valid_tm -- 报价有效时间
    ,o.stop_stl_tm -- 截止结算时间
    ,o.clear_speed_cd -- 清算速度代码
    ,o.bill_cnt -- 票据张数
    ,o.bill_tot -- 票据总额
    ,o.yld_rat -- 收益率
    ,o.weight_avg_surp_tenor -- 加权平均剩余期限
    ,o.stl_amt -- 结算金额
    ,o.discnt_int_rat -- 贴现利率
    ,o.int_paybl -- 应付利息
    ,o.stl_dt -- 结算日期
    ,o.stl_way_cd -- 结算方式代码
    ,o.clear_type_cd -- 清算类型代码
    ,o.cntpty_clear_mode -- 交易对手方清算模式
    ,o.cntpty_org_cd -- 交易对手方机构代码
    ,o.cntpty_non_lp_prod_id -- 交易对手方非法人产品编号
    ,o.cntpty_tran_teller_id -- 交易对手方交易柜员编号
    ,o.pay_cfm_flg -- 付款确认标志
    ,o.shortest_surp_tenor -- 最短剩余期限
    ,o.lont_surp_tenor -- 最长剩余期限
    ,o.bill_exp_begin_day -- 票据到期起始日
    ,o.bill_exp_stop_day -- 票据到期截止日
    ,o.min_singl_fac_val_amt -- 最小单张票面金额
    ,o.crdt_main_type_cd -- 信用主体类型代码
    ,o.crdt_main_code -- 信用主体编码
    ,o.cntpty_type_cd -- 交易对手类型代码
    ,o.acpt_bank_type_cd -- 承兑银行类型代码
    ,o.acpt_bank_id -- 承兑银行编号
    ,o.discnt_bank_type_cd -- 贴现银行类型代码
    ,o.discnt_bank_id -- 贴现银行编号
    ,o.guar_incre_crdt_bk_type_cd -- 保证增信行类型代码
    ,o.guar_incre_crdt_bank_id -- 保证增信银行编号
    ,o.dept_id -- 部门编号
    ,o.cust_mgr_id -- 客户经理编号
    ,o.apv_status_cd -- 审批状态代码
    ,o.msg_proc_status_cd -- 报文处理状态代码
    ,o.clear_status_cd -- 清算状态代码
    ,o.entry_status_cd -- 记账状态代码
    ,o.final_modif_tm -- 最后修改时间
    ,o.prod_id -- 产品编号
    ,o.std_prod_id -- 标准产品编号
    ,o.ctr_nt_ser_num -- 成交单序列号
    ,o.quot_bill_id -- 报价单编号
    ,o.click_bag_type_cd -- 点击成交类型代码
    ,o.ctr_nt_id -- 成交单编号
    ,o.quot_forward_cnt -- 报价转发次数
    ,o.batch_type_cd -- 批次类型代码
    ,o.ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
    ,o.asset_thd_cls_cd -- 资产三分类代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_bk o
    left join ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;


-- 4.1 rebuild partition
whenever sqlerror continue none;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_bill_discount_click_bag_batch') 
               and substr(subpartition_name,1,8)=upper('p_bdmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_bill_discount_click_bag_batch drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_bill_discount_click_bag_batch modify partition p_bdmsi1 
add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','YYYYMMDD'));
  
-- 4.2 exchange partition
alter table ${iml_schema}.evt_bill_discount_click_bag_batch exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_cl;
alter table ${iml_schema}.evt_bill_discount_click_bag_batch exchange subpartition p_bdmsi1_20991231 with table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bill_discount_click_bag_batch to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_tm purge;
drop table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_op purge;
drop table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_bill_discount_click_bag_batch_bdmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bill_discount_click_bag_batch', partname => 'p_bdmsi1_20991231', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1', no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
