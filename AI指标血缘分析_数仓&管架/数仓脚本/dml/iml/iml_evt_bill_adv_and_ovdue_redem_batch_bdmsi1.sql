/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bill_adv_and_ovdue_redem_batch_bdmsi1
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
alter table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

create table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch partition for ('bdmsi1') 
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_tm purge;
drop table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_op purge;
drop table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_batch_ser_num -- 申请批次序列号
    ,redem_task_ser_num -- 赎回任务序列号
    ,batch_id -- 批次编号
    ,dial_quot_batch_ser_num -- 对话报价批次序列号
    ,init_bus_lmt_ocup_status_cd -- 原业务额度占用状态代码
    ,prod_id -- 产品编号
    ,bus_type_cd -- 业务类型代码
    ,hq_org_id -- 总行机构编号
    ,org_id -- 机构编号
    ,appl_dt -- 申请日期
    ,ghb_org_name -- 本方机构名称
    ,ghb_org_id -- 本方机构编号
    ,cntpty_name -- 交易对手名称
    ,cntpty_org_id -- 交易对手机构编号
    ,cntpty_bank_id -- 交易对手银行编号
    ,cntpty_non_lp_prod_id -- 交易对手非法人产品编号
    ,ctr_nt_id -- 成交单编号
    ,redem_cate_cd -- 赎回类别代码
    ,redem_ar_cd -- 赎回事由代码
    ,redem_rest_cd -- 赎回结果代码
    ,redem_intior_proc_opinion_descb -- 赎回发起方处理意见描述
    ,redem_recv_proc_opinion_descb -- 赎回签收方处理意见描述
    ,redem_intior_remark_descb -- 赎回发起方备注描述
    ,redem_recv_remark_descb -- 赎回签收方备注描述
    ,fs_proc_rest_cd -- 场务处理结果代码
    ,fs_proc_opinion_descb -- 场务处理意见描述
    ,reply_idfg_cd -- 应答标识代码
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bill_tot_amt -- 票据总金额
    ,bill_cnt -- 票据张数
    ,init_bus_repo_amt -- 原业务回购金额
    ,fst_stl_amt -- 首期结算金额
    ,redem_stl_amt -- 赎回结算金额
    ,repo_int_rat -- 回购利率
    ,init_bus_int_paybl -- 原业务应付利息
    ,redem_int_paybl -- 赎回应付利息
    ,repo_yld_rat -- 回购收益率
    ,init_bus_fst_stl_amt -- 原业务首期结算日期
    ,init_bus_exp_stl_dt -- 原业务到期结算日期
    ,lmt_ocup_status_cd -- 额度占用状态代码
    ,apv_status_cd -- 审批状态代码
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,msg_proc_status_cd -- 报文处理状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch partition for ('bdmsi1')
where 0=1
;

create table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch partition for ('bdmsi1') where 0=1;

create table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch partition for ('bdmsi1') where 0=1;

-- 3.1 get new data into table
-- bdms_cpes_buy_back_contract-
insert into ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_batch_ser_num -- 申请批次序列号
    ,redem_task_ser_num -- 赎回任务序列号
    ,batch_id -- 批次编号
    ,dial_quot_batch_ser_num -- 对话报价批次序列号
    ,init_bus_lmt_ocup_status_cd -- 原业务额度占用状态代码
    ,prod_id -- 产品编号
    ,bus_type_cd -- 业务类型代码
    ,hq_org_id -- 总行机构编号
    ,org_id -- 机构编号
    ,appl_dt -- 申请日期
    ,ghb_org_name -- 本方机构名称
    ,ghb_org_id -- 本方机构编号
    ,cntpty_name -- 交易对手名称
    ,cntpty_org_id -- 交易对手机构编号
    ,cntpty_bank_id -- 交易对手银行编号
    ,cntpty_non_lp_prod_id -- 交易对手非法人产品编号
    ,ctr_nt_id -- 成交单编号
    ,redem_cate_cd -- 赎回类别代码
    ,redem_ar_cd -- 赎回事由代码
    ,redem_rest_cd -- 赎回结果代码
    ,redem_intior_proc_opinion_descb -- 赎回发起方处理意见描述
    ,redem_recv_proc_opinion_descb -- 赎回签收方处理意见描述
    ,redem_intior_remark_descb -- 赎回发起方备注描述
    ,redem_recv_remark_descb -- 赎回签收方备注描述
    ,fs_proc_rest_cd -- 场务处理结果代码
    ,fs_proc_opinion_descb -- 场务处理意见描述
    ,reply_idfg_cd -- 应答标识代码
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bill_tot_amt -- 票据总金额
    ,bill_cnt -- 票据张数
    ,init_bus_repo_amt -- 原业务回购金额
    ,fst_stl_amt -- 首期结算金额
    ,redem_stl_amt -- 赎回结算金额
    ,repo_int_rat -- 回购利率
    ,init_bus_int_paybl -- 原业务应付利息
    ,redem_int_paybl -- 赎回应付利息
    ,repo_yld_rat -- 回购收益率
    ,init_bus_fst_stl_amt -- 原业务首期结算日期
    ,init_bus_exp_stl_dt -- 原业务到期结算日期
    ,lmt_ocup_status_cd -- 额度占用状态代码
    ,apv_status_cd -- 审批状态代码
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,msg_proc_status_cd -- 报文处理状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102019'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,p1.id -- 申请批次序列号
    ,p1.apply_id -- 赎回任务序列号
    ,p1.contract_no -- 批次编号
    ,p1.org_contract_id -- 对话报价批次序列号
    ,nvl(trim(P1.org_credit_status),'-') -- 原业务额度占用状态代码
    ,p1.product_no -- 产品编号
    ,nvl(trim(P1.buss_flag),'RBT00') -- 业务类型代码
    ,p1.top_branch_no -- 总行机构编号
    ,p1.branch_no -- 机构编号
    ,${iml_schema}.DATEFORMAT_MIN(p1.apply_date) -- 申请日期
    ,p1.brh_name -- 本方机构名称
    ,p1.brh_no -- 本方机构编号
    ,p1.adver_brh_name -- 交易对手名称
    ,p1.adver_brh_no -- 交易对手机构编号
    ,p1.adver_bank_no -- 交易对手银行编号
    ,p1.adver_pro_no -- 交易对手非法人产品编号
    ,p1.deal_no -- 成交单编号
    ,nvl(trim(P1.buy_back_type),'-') -- 赎回类别代码
    ,case when R1.target_cd_val is not null then R1.target_cd_val else '@'||p1.buy_back_reason end -- 赎回事由代码
    ,nvl(trim(P1.buy_back_result),'-') -- 赎回结果代码
    ,p1.req_deal_opi -- 赎回发起方处理意见描述
    ,p1.sign_deal_opi -- 赎回签收方处理意见描述
    ,p1.req_misc -- 赎回发起方备注描述
    ,p1.sign_misc -- 赎回签收方备注描述
    ,nvl(trim(P1.apv_sign_mk),'-') -- 场务处理结果代码
    ,p1.apv_opi -- 场务处理意见描述
    ,nvl(trim(P1.sign_mk),'-') -- 应答标识代码
    ,P1.DEPARTMENT_NO -- 部门编号
    ,p1.manage_no -- 客户经理编号
    ,case when R3.target_cd_val is not null then R3.target_cd_val else '@'||p1.draft_attr end -- 票据介质代码
    ,nvl(trim(P1.DRAFT_TYPE),'-') -- 票据类型代码
    ,P1.sum_amount -- 票据总金额
    ,P1.sum_count -- 票据张数
    ,P1.org_buy_back_amount -- 原业务回购金额
    ,P1.settle_amount -- 首期结算金额
    ,P1.buy_back_settle_amount -- 赎回结算金额
    ,P1.buy_back_rate -- 回购利率
    ,P1.org_pay_interest -- 原业务应付利息
    ,P1.buy_back_pay_interest -- 赎回应付利息
    ,P1.buy_back_yield_rate -- 回购收益率
    ,${iml_schema}.DATEFORMAT_MIN(p1.org_settle_date） -- 原业务首期结算日期
    ,${iml_schema}.DATEFORMAT_MAX2(p1.org_due_settle_date) -- 原业务到期结算日期
    ,nvl(trim(P1.credit_status),'-') -- 额度占用状态代码
    ,case when R5.target_cd_val is not null then R5.target_cd_val else '@'||p1.contract_status end -- 审批状态代码
    ,case when R6.target_cd_val is not null then R6.target_cd_val else '@'||p1.account_status end -- 记账状态代码
    ,NVL(TRIM(p1.valid_flag),'-') -- 有效标志
    ,case when R7.target_cd_val is not null then R7.target_cd_val else '@'||p1.message_status end -- 报文处理状态代码
    ,nvl(trim(P1.settle_status),'-') -- 清算状态代码
    ,p1.last_upd_opr -- 最后修改操作员编号
    ,${iml_schema}.timeformat_min(p1.last_upd_time) -- 最后修改时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_buy_back_contract' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_buy_back_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BUY_BACK_REASON = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_BACK_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'BUY_BACK_REASON'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BILL_ADV_AND_OVDUE_REDEM_BATCH'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'REDEM_AR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.DRAFT_ATTR = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_BACK_CONTRACT'
        AND R3.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_BILL_ADV_AND_OVDUE_REDEM_BATCH'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BILL_MED_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CONTRACT_STATUS = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'BDMS'
        AND R5.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_BACK_CONTRACT'
        AND R5.SRC_FIELD_EN_NAME= 'CONTRACT_STATUS'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_BILL_ADV_AND_OVDUE_REDEM_BATCH'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'APV_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.ACCOUNT_STATUS = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'BDMS'
        AND R6.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_BACK_CONTRACT'
        AND R6.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_BILL_ADV_AND_OVDUE_REDEM_BATCH'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.MESSAGE_STATUS = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'BDMS'
        AND R7.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_BACK_CONTRACT'
        AND R7.SRC_FIELD_EN_NAME= 'MESSAGE_STATUS'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_BILL_ADV_AND_OVDUE_REDEM_BATCH'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'MSG_PROC_STATUS_CD'
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
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_tm 
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
insert /*+ append */ into ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_op(
        evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_batch_ser_num -- 申请批次序列号
    ,redem_task_ser_num -- 赎回任务序列号
    ,batch_id -- 批次编号
    ,dial_quot_batch_ser_num -- 对话报价批次序列号
    ,init_bus_lmt_ocup_status_cd -- 原业务额度占用状态代码
    ,prod_id -- 产品编号
    ,bus_type_cd -- 业务类型代码
    ,hq_org_id -- 总行机构编号
    ,org_id -- 机构编号
    ,appl_dt -- 申请日期
    ,ghb_org_name -- 本方机构名称
    ,ghb_org_id -- 本方机构编号
    ,cntpty_name -- 交易对手名称
    ,cntpty_org_id -- 交易对手机构编号
    ,cntpty_bank_id -- 交易对手银行编号
    ,cntpty_non_lp_prod_id -- 交易对手非法人产品编号
    ,ctr_nt_id -- 成交单编号
    ,redem_cate_cd -- 赎回类别代码
    ,redem_ar_cd -- 赎回事由代码
    ,redem_rest_cd -- 赎回结果代码
    ,redem_intior_proc_opinion_descb -- 赎回发起方处理意见描述
    ,redem_recv_proc_opinion_descb -- 赎回签收方处理意见描述
    ,redem_intior_remark_descb -- 赎回发起方备注描述
    ,redem_recv_remark_descb -- 赎回签收方备注描述
    ,fs_proc_rest_cd -- 场务处理结果代码
    ,fs_proc_opinion_descb -- 场务处理意见描述
    ,reply_idfg_cd -- 应答标识代码
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bill_tot_amt -- 票据总金额
    ,bill_cnt -- 票据张数
    ,init_bus_repo_amt -- 原业务回购金额
    ,fst_stl_amt -- 首期结算金额
    ,redem_stl_amt -- 赎回结算金额
    ,repo_int_rat -- 回购利率
    ,init_bus_int_paybl -- 原业务应付利息
    ,redem_int_paybl -- 赎回应付利息
    ,repo_yld_rat -- 回购收益率
    ,init_bus_fst_stl_amt -- 原业务首期结算日期
    ,init_bus_exp_stl_dt -- 原业务到期结算日期
    ,lmt_ocup_status_cd -- 额度占用状态代码
    ,apv_status_cd -- 审批状态代码
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,msg_proc_status_cd -- 报文处理状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
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
    ,n.appl_batch_ser_num -- 申请批次序列号
    ,n.redem_task_ser_num -- 赎回任务序列号
    ,n.batch_id -- 批次编号
    ,n.dial_quot_batch_ser_num -- 对话报价批次序列号
    ,n.init_bus_lmt_ocup_status_cd -- 原业务额度占用状态代码
    ,n.prod_id -- 产品编号
    ,n.bus_type_cd -- 业务类型代码
    ,n.hq_org_id -- 总行机构编号
    ,n.org_id -- 机构编号
    ,n.appl_dt -- 申请日期
    ,n.ghb_org_name -- 本方机构名称
    ,n.ghb_org_id -- 本方机构编号
    ,n.cntpty_name -- 交易对手名称
    ,n.cntpty_org_id -- 交易对手机构编号
    ,n.cntpty_bank_id -- 交易对手银行编号
    ,n.cntpty_non_lp_prod_id -- 交易对手非法人产品编号
    ,n.ctr_nt_id -- 成交单编号
    ,n.redem_cate_cd -- 赎回类别代码
    ,n.redem_ar_cd -- 赎回事由代码
    ,n.redem_rest_cd -- 赎回结果代码
    ,n.redem_intior_proc_opinion_descb -- 赎回发起方处理意见描述
    ,n.redem_recv_proc_opinion_descb -- 赎回签收方处理意见描述
    ,n.redem_intior_remark_descb -- 赎回发起方备注描述
    ,n.redem_recv_remark_descb -- 赎回签收方备注描述
    ,n.fs_proc_rest_cd -- 场务处理结果代码
    ,n.fs_proc_opinion_descb -- 场务处理意见描述
    ,n.reply_idfg_cd -- 应答标识代码
    ,n.dept_id -- 部门编号
    ,n.cust_mgr_id -- 客户经理编号
    ,n.bill_med_cd -- 票据介质代码
    ,n.bill_type_cd -- 票据类型代码
    ,n.bill_tot_amt -- 票据总金额
    ,n.bill_cnt -- 票据张数
    ,n.init_bus_repo_amt -- 原业务回购金额
    ,n.fst_stl_amt -- 首期结算金额
    ,n.redem_stl_amt -- 赎回结算金额
    ,n.repo_int_rat -- 回购利率
    ,n.init_bus_int_paybl -- 原业务应付利息
    ,n.redem_int_paybl -- 赎回应付利息
    ,n.repo_yld_rat -- 回购收益率
    ,n.init_bus_fst_stl_amt -- 原业务首期结算日期
    ,n.init_bus_exp_stl_dt -- 原业务到期结算日期
    ,n.lmt_ocup_status_cd -- 额度占用状态代码
    ,n.apv_status_cd -- 审批状态代码
    ,n.entry_status_cd -- 记账状态代码
    ,n.valid_flg -- 有效标志
    ,n.msg_proc_status_cd -- 报文处理状态代码
    ,n.clear_status_cd -- 清算状态代码
    ,n.final_modif_operr_id -- 最后修改操作员编号
    ,n.final_modif_tm -- 最后修改时间
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'bdmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_tm n
    left join ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_bk o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        o.appl_batch_ser_num <> n.appl_batch_ser_num
        or o.redem_task_ser_num <> n.redem_task_ser_num
        or o.batch_id <> n.batch_id
        or o.dial_quot_batch_ser_num <> n.dial_quot_batch_ser_num
        or o.init_bus_lmt_ocup_status_cd <> n.init_bus_lmt_ocup_status_cd
        or o.prod_id <> n.prod_id
        or o.bus_type_cd <> n.bus_type_cd
        or o.hq_org_id <> n.hq_org_id
        or o.org_id <> n.org_id
        or o.appl_dt <> n.appl_dt
        or o.ghb_org_name <> n.ghb_org_name
        or o.ghb_org_id <> n.ghb_org_id
        or o.cntpty_name <> n.cntpty_name
        or o.cntpty_org_id <> n.cntpty_org_id
        or o.cntpty_bank_id <> n.cntpty_bank_id
        or o.cntpty_non_lp_prod_id <> n.cntpty_non_lp_prod_id
        or o.ctr_nt_id <> n.ctr_nt_id
        or o.redem_cate_cd <> n.redem_cate_cd
        or o.redem_ar_cd <> n.redem_ar_cd
        or o.redem_rest_cd <> n.redem_rest_cd
        or o.redem_intior_proc_opinion_descb <> n.redem_intior_proc_opinion_descb
        or o.redem_recv_proc_opinion_descb <> n.redem_recv_proc_opinion_descb
        or o.redem_intior_remark_descb <> n.redem_intior_remark_descb
        or o.redem_recv_remark_descb <> n.redem_recv_remark_descb
        or o.fs_proc_rest_cd <> n.fs_proc_rest_cd
        or o.fs_proc_opinion_descb <> n.fs_proc_opinion_descb
        or o.reply_idfg_cd <> n.reply_idfg_cd
        or o.dept_id <> n.dept_id
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.bill_med_cd <> n.bill_med_cd
        or o.bill_type_cd <> n.bill_type_cd
        or o.bill_tot_amt <> n.bill_tot_amt
        or o.bill_cnt <> n.bill_cnt
        or o.init_bus_repo_amt <> n.init_bus_repo_amt
        or o.fst_stl_amt <> n.fst_stl_amt
        or o.redem_stl_amt <> n.redem_stl_amt
        or o.repo_int_rat <> n.repo_int_rat
        or o.init_bus_int_paybl <> n.init_bus_int_paybl
        or o.redem_int_paybl <> n.redem_int_paybl
        or o.repo_yld_rat <> n.repo_yld_rat
        or o.init_bus_fst_stl_amt <> n.init_bus_fst_stl_amt
        or o.init_bus_exp_stl_dt <> n.init_bus_exp_stl_dt
        or o.lmt_ocup_status_cd <> n.lmt_ocup_status_cd
        or o.apv_status_cd <> n.apv_status_cd
        or o.entry_status_cd <> n.entry_status_cd
        or o.valid_flg <> n.valid_flg
        or o.msg_proc_status_cd <> n.msg_proc_status_cd
        or o.clear_status_cd <> n.clear_status_cd
        or o.final_modif_operr_id <> n.final_modif_operr_id
        or o.final_modif_tm <> n.final_modif_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_batch_ser_num -- 申请批次序列号
    ,redem_task_ser_num -- 赎回任务序列号
    ,batch_id -- 批次编号
    ,dial_quot_batch_ser_num -- 对话报价批次序列号
    ,init_bus_lmt_ocup_status_cd -- 原业务额度占用状态代码
    ,prod_id -- 产品编号
    ,bus_type_cd -- 业务类型代码
    ,hq_org_id -- 总行机构编号
    ,org_id -- 机构编号
    ,appl_dt -- 申请日期
    ,ghb_org_name -- 本方机构名称
    ,ghb_org_id -- 本方机构编号
    ,cntpty_name -- 交易对手名称
    ,cntpty_org_id -- 交易对手机构编号
    ,cntpty_bank_id -- 交易对手银行编号
    ,cntpty_non_lp_prod_id -- 交易对手非法人产品编号
    ,ctr_nt_id -- 成交单编号
    ,redem_cate_cd -- 赎回类别代码
    ,redem_ar_cd -- 赎回事由代码
    ,redem_rest_cd -- 赎回结果代码
    ,redem_intior_proc_opinion_descb -- 赎回发起方处理意见描述
    ,redem_recv_proc_opinion_descb -- 赎回签收方处理意见描述
    ,redem_intior_remark_descb -- 赎回发起方备注描述
    ,redem_recv_remark_descb -- 赎回签收方备注描述
    ,fs_proc_rest_cd -- 场务处理结果代码
    ,fs_proc_opinion_descb -- 场务处理意见描述
    ,reply_idfg_cd -- 应答标识代码
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bill_tot_amt -- 票据总金额
    ,bill_cnt -- 票据张数
    ,init_bus_repo_amt -- 原业务回购金额
    ,fst_stl_amt -- 首期结算金额
    ,redem_stl_amt -- 赎回结算金额
    ,repo_int_rat -- 回购利率
    ,init_bus_int_paybl -- 原业务应付利息
    ,redem_int_paybl -- 赎回应付利息
    ,repo_yld_rat -- 回购收益率
    ,init_bus_fst_stl_amt -- 原业务首期结算日期
    ,init_bus_exp_stl_dt -- 原业务到期结算日期
    ,lmt_ocup_status_cd -- 额度占用状态代码
    ,apv_status_cd -- 审批状态代码
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,msg_proc_status_cd -- 报文处理状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_batch_ser_num -- 申请批次序列号
    ,redem_task_ser_num -- 赎回任务序列号
    ,batch_id -- 批次编号
    ,dial_quot_batch_ser_num -- 对话报价批次序列号
    ,init_bus_lmt_ocup_status_cd -- 原业务额度占用状态代码
    ,prod_id -- 产品编号
    ,bus_type_cd -- 业务类型代码
    ,hq_org_id -- 总行机构编号
    ,org_id -- 机构编号
    ,appl_dt -- 申请日期
    ,ghb_org_name -- 本方机构名称
    ,ghb_org_id -- 本方机构编号
    ,cntpty_name -- 交易对手名称
    ,cntpty_org_id -- 交易对手机构编号
    ,cntpty_bank_id -- 交易对手银行编号
    ,cntpty_non_lp_prod_id -- 交易对手非法人产品编号
    ,ctr_nt_id -- 成交单编号
    ,redem_cate_cd -- 赎回类别代码
    ,redem_ar_cd -- 赎回事由代码
    ,redem_rest_cd -- 赎回结果代码
    ,redem_intior_proc_opinion_descb -- 赎回发起方处理意见描述
    ,redem_recv_proc_opinion_descb -- 赎回签收方处理意见描述
    ,redem_intior_remark_descb -- 赎回发起方备注描述
    ,redem_recv_remark_descb -- 赎回签收方备注描述
    ,fs_proc_rest_cd -- 场务处理结果代码
    ,fs_proc_opinion_descb -- 场务处理意见描述
    ,reply_idfg_cd -- 应答标识代码
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,bill_tot_amt -- 票据总金额
    ,bill_cnt -- 票据张数
    ,init_bus_repo_amt -- 原业务回购金额
    ,fst_stl_amt -- 首期结算金额
    ,redem_stl_amt -- 赎回结算金额
    ,repo_int_rat -- 回购利率
    ,init_bus_int_paybl -- 原业务应付利息
    ,redem_int_paybl -- 赎回应付利息
    ,repo_yld_rat -- 回购收益率
    ,init_bus_fst_stl_amt -- 原业务首期结算日期
    ,init_bus_exp_stl_dt -- 原业务到期结算日期
    ,lmt_ocup_status_cd -- 额度占用状态代码
    ,apv_status_cd -- 审批状态代码
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,msg_proc_status_cd -- 报文处理状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
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
    ,o.appl_batch_ser_num -- 申请批次序列号
    ,o.redem_task_ser_num -- 赎回任务序列号
    ,o.batch_id -- 批次编号
    ,o.dial_quot_batch_ser_num -- 对话报价批次序列号
    ,o.init_bus_lmt_ocup_status_cd -- 原业务额度占用状态代码
    ,o.prod_id -- 产品编号
    ,o.bus_type_cd -- 业务类型代码
    ,o.hq_org_id -- 总行机构编号
    ,o.org_id -- 机构编号
    ,o.appl_dt -- 申请日期
    ,o.ghb_org_name -- 本方机构名称
    ,o.ghb_org_id -- 本方机构编号
    ,o.cntpty_name -- 交易对手名称
    ,o.cntpty_org_id -- 交易对手机构编号
    ,o.cntpty_bank_id -- 交易对手银行编号
    ,o.cntpty_non_lp_prod_id -- 交易对手非法人产品编号
    ,o.ctr_nt_id -- 成交单编号
    ,o.redem_cate_cd -- 赎回类别代码
    ,o.redem_ar_cd -- 赎回事由代码
    ,o.redem_rest_cd -- 赎回结果代码
    ,o.redem_intior_proc_opinion_descb -- 赎回发起方处理意见描述
    ,o.redem_recv_proc_opinion_descb -- 赎回签收方处理意见描述
    ,o.redem_intior_remark_descb -- 赎回发起方备注描述
    ,o.redem_recv_remark_descb -- 赎回签收方备注描述
    ,o.fs_proc_rest_cd -- 场务处理结果代码
    ,o.fs_proc_opinion_descb -- 场务处理意见描述
    ,o.reply_idfg_cd -- 应答标识代码
    ,o.dept_id -- 部门编号
    ,o.cust_mgr_id -- 客户经理编号
    ,o.bill_med_cd -- 票据介质代码
    ,o.bill_type_cd -- 票据类型代码
    ,o.bill_tot_amt -- 票据总金额
    ,o.bill_cnt -- 票据张数
    ,o.init_bus_repo_amt -- 原业务回购金额
    ,o.fst_stl_amt -- 首期结算金额
    ,o.redem_stl_amt -- 赎回结算金额
    ,o.repo_int_rat -- 回购利率
    ,o.init_bus_int_paybl -- 原业务应付利息
    ,o.redem_int_paybl -- 赎回应付利息
    ,o.repo_yld_rat -- 回购收益率
    ,o.init_bus_fst_stl_amt -- 原业务首期结算日期
    ,o.init_bus_exp_stl_dt -- 原业务到期结算日期
    ,o.lmt_ocup_status_cd -- 额度占用状态代码
    ,o.apv_status_cd -- 审批状态代码
    ,o.entry_status_cd -- 记账状态代码
    ,o.valid_flg -- 有效标志
    ,o.msg_proc_status_cd -- 报文处理状态代码
    ,o.clear_status_cd -- 清算状态代码
    ,o.final_modif_operr_id -- 最后修改操作员编号
    ,o.final_modif_tm -- 最后修改时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_bk o
    left join ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_op n
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
               and table_name=upper('evt_bill_adv_and_ovdue_redem_batch') 
               and substr(subpartition_name,1,8)=upper('p_bdmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch modify partition p_bdmsi1 
add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','YYYYMMDD'));
  
-- 4.2 exchange partition
alter table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_cl;
alter table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch exchange subpartition p_bdmsi1_20991231 with table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_tm purge;
drop table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_op purge;
drop table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_bill_adv_and_ovdue_redem_batch_bdmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bill_adv_and_ovdue_redem_batch', partname => 'p_bdmsi1_20991231', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1', no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
