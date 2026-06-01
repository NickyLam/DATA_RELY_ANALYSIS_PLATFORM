/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_anony_click_match_batch_bdmsi1
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
alter table ${iml_schema}.evt_anony_click_match_batch add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

create table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_anony_click_match_batch partition for ('bdmsi1') 
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_tm purge;
drop table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_op purge;
drop table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,match_batch_ser_num -- 匹配批次序列号
    ,appl_batch_ser_num -- 申请批次序列号
    ,ctr_nt_ser_num -- 成交单序列号
    ,match_batch_id -- 匹配批次编号
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,ctr_nt_id -- 成交单编号
    ,bag_way_cd -- 成交方式代码
    ,bag_tm -- 成交时间
    ,ctr_nt_status_cd -- 成交单状态代码
    ,bill_tot_cnt -- 票据总张数
    ,bill_tot_amt -- 票据总金额
    ,quot_bill_id -- 报价单编号
    ,bus_type_cd -- 业务类型代码
    ,tran_dir_cd -- 交易方向代码
    ,ghb_org_cd -- 本方机构代码
    ,ghb_non_lp_prod_id -- 本方非法人产编号
    ,ghb_tran_teller_id -- 本方交易柜员编号
    ,cntpty_org_id -- 对方机构编号
    ,cntpty_non_lp_prod_id -- 对方非法人产品编号
    ,cntpty_tran_teller_id -- 对方交易柜员编号
    ,bill_type_cd -- 票据类型代码
    ,bill_attr_cd -- 票据属性代码
    ,repo_amt -- 回购金额
    ,tenor_breed_cd -- 期限品种代码
    ,repo_tenor -- 回购期限
    ,clear_speed_cd -- 清算速度代码
    ,clear_type_cd -- 清算类型代码
    ,latest_fst_stl_tm -- 最晚首期结算时间
    ,stl_way_cd -- 结算方式代码
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,fst_stl_dt -- 首期结算日期
    ,exp_stl_dt -- 到期结算日期
    ,repo_int_rat -- 回购利率
    ,int_paybl -- 应付利息
    ,repo_yld_rat -- 回购收益率
    ,draw_bill_stop_tm -- 提票截止时间
    ,crdt_main_type_cd -- 信用主体类型代码
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,apv_status_cd -- 审批状态代码
    ,msg_status_cd -- 报文状态代码
    ,clear_status_cd -- 清算状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_tm -- 最后修改时间
    ,ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_anony_click_match_batch partition for ('bdmsi1')
where 0=1
;

create table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_anony_click_match_batch partition for ('bdmsi1') where 0=1;

create table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_anony_click_match_batch partition for ('bdmsi1') where 0=1;

-- 3.1 get new data into table
-- bdms_cpes_anoclick_match_contract-
insert into ${iml_schema}.evt_anony_click_match_batch_bdmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,match_batch_ser_num -- 匹配批次序列号
    ,appl_batch_ser_num -- 申请批次序列号
    ,ctr_nt_ser_num -- 成交单序列号
    ,match_batch_id -- 匹配批次编号
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,ctr_nt_id -- 成交单编号
    ,bag_way_cd -- 成交方式代码
    ,bag_tm -- 成交时间
    ,ctr_nt_status_cd -- 成交单状态代码
    ,bill_tot_cnt -- 票据总张数
    ,bill_tot_amt -- 票据总金额
    ,quot_bill_id -- 报价单编号
    ,bus_type_cd -- 业务类型代码
    ,tran_dir_cd -- 交易方向代码
    ,ghb_org_cd -- 本方机构代码
    ,ghb_non_lp_prod_id -- 本方非法人产编号
    ,ghb_tran_teller_id -- 本方交易柜员编号
    ,cntpty_org_id -- 对方机构编号
    ,cntpty_non_lp_prod_id -- 对方非法人产品编号
    ,cntpty_tran_teller_id -- 对方交易柜员编号
    ,bill_type_cd -- 票据类型代码
    ,bill_attr_cd -- 票据属性代码
    ,repo_amt -- 回购金额
    ,tenor_breed_cd -- 期限品种代码
    ,repo_tenor -- 回购期限
    ,clear_speed_cd -- 清算速度代码
    ,clear_type_cd -- 清算类型代码
    ,latest_fst_stl_tm -- 最晚首期结算时间
    ,stl_way_cd -- 结算方式代码
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,fst_stl_dt -- 首期结算日期
    ,exp_stl_dt -- 到期结算日期
    ,repo_int_rat -- 回购利率
    ,int_paybl -- 应付利息
    ,repo_yld_rat -- 回购收益率
    ,draw_bill_stop_tm -- 提票截止时间
    ,crdt_main_type_cd -- 信用主体类型代码
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,apv_status_cd -- 审批状态代码
    ,msg_status_cd -- 报文状态代码
    ,clear_status_cd -- 清算状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_tm -- 最后修改时间
    ,ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '105006'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,p1.id -- 匹配批次序列号
    ,p1.quote_contract_id -- 申请批次序列号
    ,p1.deal_id -- 成交单序列号
    ,p1.contract_no -- 匹配批次编号
    ,p1.product_no -- 产品编号
    ,nvl(trim(p2.PROD_CODE),' ') -- 标准产品编号
    ,p1.dealed_no -- 成交单编号
    ,nvl(trim(p1.trade_type),'-') -- 成交方式代码
    ,${iml_schema}.TIMEFORMAT_MAX2(p1.trade_time) -- 成交时间
    ,nvl(trim(p1.trade_status),'-') -- 成交单状态代码
    ,P1.sum_count -- 票据总张数
    ,P1.sum_amount -- 票据总金额
    ,p1.quote_no -- 报价单编号
    ,nvl(trim(P1.busi_type),'BT00') -- 业务类型代码
    ,case when R1.target_cd_val is not null then R1.target_cd_val else '@'||p1.trade_direct end -- 交易方向代码
    ,p1.brh_no -- 本方机构代码
    ,p1.pro_no -- 本方非法人产编号
    ,p1.trader_id -- 本方交易柜员编号
    ,p1.adver_brh_no -- 对方机构编号
    ,p1.adver_pro_no -- 对方非法人产品编号
    ,p1.adver_trader_id -- 对方交易柜员编号
    ,nvl(trim(P1.DRAFT_TYPE),'-') -- 票据类型代码
    ,case when R3.target_cd_val is not null then R3.target_cd_val else '@'||p1.draft_attr end -- 票据属性代码
    ,P1.buy_back_amt -- 回购金额
    ,case when R4.target_cd_val is not null then R4.target_cd_val else '@'||p1.tenor_code end -- 期限品种代码
    ,P1.tenor_days -- 回购期限
    ,case when R5.target_cd_val is not null then R5.target_cd_val else '@'||p1.clear_speed end -- 清算速度代码
    ,case when R6.target_cd_val is not null then R6.target_cd_val else '@'||p1.clear_type end -- 清算类型代码
    ,${iml_schema}.TIMEFORMAT_MAX2(p1.latest_settle_time) -- 最晚首期结算时间
    ,case when R7.target_cd_val is not null then R7.target_cd_val else '@'||p1.settle_mode end -- 结算方式代码
    ,P1.settle_amt -- 首期结算金额
    ,P1.due_settle_amt -- 到期结算金额
    ,${iml_schema}.DATEFORMAT_MAX2(p1.settle_date) -- 首期结算日期
    ,${iml_schema}.DATEFORMAT_MAX2(p1.due_settle_date) -- 到期结算日期
    ,P1.rate -- 回购利率
    ,P1.pay_interest -- 应付利息
    ,P1.yield_rate -- 回购收益率
    ,${iml_schema}.timeformat_max2(p1.close_time) -- 提票截止时间
    ,nvl(trim(p1.credit_type),'000') -- 信用主体类型代码
    ,P1.DEPARTMENT_NO -- 部门编号
    ,p1.manager_no -- 客户经理编号
    ,p1.busi_branch_no -- 业务机构编号
    ,p1.top_branch_no -- 总行机构编号
    ,CASE WHEN R10.TARGET_CD_VAL IS NOT NULL THEN R10.TARGET_CD_VAL ELSE '@'||P1.CONTRACT_STATUS END -- 审批状态代码
    ,case when R8.target_cd_val is not null then R8.target_cd_val else '@'||p1.message_status end -- 报文状态代码
    ,nvl(trim(p1.settle_status),'-') -- 清算状态代码
    ,case when R9.target_cd_val is not null then R9.target_cd_val else '@'||p1.account_status end -- 记账状态代码
    ,${iml_schema}.TIMEFORMAT_MAX2(p1.last_upd_time) -- 最后修改时间
    ,nvl(trim(p1.credit_check_status),'-') -- 同业授信额度占用状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_anoclick_match_contract' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_anoclick_match_contract p1
    left join ${iol_schema}.bdms_meta_deposit_define p2 on P1.PRODUCT_NO=P2.PRODUCT_NO 
AND P2.START_DT<= TO_DATE('${batch_date}','YYYYMMDD') 
AND P2.END_DT > TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TRADE_DIRECT = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CPES_ANOCLICK_MATCH_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'TRADE_DIRECT'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_ANONY_CLICK_MATCH_BATCH'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.DRAFT_ATTR = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_CPES_ANOCLICK_MATCH_CONTRACT'
        AND R3.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_ANONY_CLICK_MATCH_BATCH'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BILL_ATTR_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CLEAR_SPEED = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'BDMS'
        AND R4.SRC_TAB_EN_NAME= 'BDMS_CPES_ANOCLICK_MATCH_CONTRACT'
        AND R4.SRC_FIELD_EN_NAME= 'CLEAR_SPEED'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_ANONY_CLICK_MATCH_BATCH'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_SPEED_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CLEAR_SPEED = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'BDMS'
        AND R5.SRC_TAB_EN_NAME= 'BDMS_CPES_ANOCLICK_MATCH_CONTRACT'
        AND R5.SRC_FIELD_EN_NAME= 'CLEAR_SPEED'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_ANONY_CLICK_MATCH_BATCH'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_SPEED_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.CLEAR_TYPE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'BDMS'
        AND R6.SRC_TAB_EN_NAME= 'BDMS_CPES_ANOCLICK_MATCH_CONTRACT'
        AND R6.SRC_FIELD_EN_NAME= 'CLEAR_TYPE'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_ANONY_CLICK_MATCH_BATCH'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.SETTLE_MODE = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'BDMS'
        AND R7.SRC_TAB_EN_NAME= 'BDMS_CPES_ANOCLICK_MATCH_CONTRACT'
        AND R7.SRC_FIELD_EN_NAME= 'SETTLE_MODE'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_ANONY_CLICK_MATCH_BATCH'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r10 on P1.CONTRACT_STATUS = R10.SRC_CODE_VAL
        AND R10.SORC_SYS_CD= 'BDMS'
        AND R10.SRC_TAB_EN_NAME= 'BDMS_CPES_ANOCLICK_MATCH_CONTRACT'
        AND R10.SRC_FIELD_EN_NAME= 'CONTRACT_STATUS'
        AND R10.TARGET_TAB_EN_NAME= 'EVT_ANONY_CLICK_MATCH_BATCH'
        AND R10.TARGET_TAB_FIELD_EN_NAME= 'APV_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.MESSAGE_STATUS = R8.SRC_CODE_VAL
				AND R8.SORC_SYS_CD= 'BDMS'
				AND R8.SRC_TAB_EN_NAME= 'BDMS_CPES_ANOCLICK_MATCH_CONTRACT'
				AND R8.SRC_FIELD_EN_NAME= 'MESSAGE_STATUS'
				AND R8.TARGET_TAB_EN_NAME= 'EVT_ANONY_CLICK_MATCH_BATCH'
				AND R8.TARGET_TAB_FIELD_EN_NAME= 'MSG_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.ACCOUNT_STATUS = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'BDMS'
        AND R9.SRC_TAB_EN_NAME= 'BDMS_CPES_ANOCLICK_MATCH_CONTRACT'
        AND R9.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R9.TARGET_TAB_EN_NAME= 'EVT_ANONY_CLICK_MATCH_BATCH'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
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
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_anony_click_match_batch_bdmsi1_tm 
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
insert /*+ append */ into ${iml_schema}.evt_anony_click_match_batch_bdmsi1_op(
        evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,match_batch_ser_num -- 匹配批次序列号
    ,appl_batch_ser_num -- 申请批次序列号
    ,ctr_nt_ser_num -- 成交单序列号
    ,match_batch_id -- 匹配批次编号
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,ctr_nt_id -- 成交单编号
    ,bag_way_cd -- 成交方式代码
    ,bag_tm -- 成交时间
    ,ctr_nt_status_cd -- 成交单状态代码
    ,bill_tot_cnt -- 票据总张数
    ,bill_tot_amt -- 票据总金额
    ,quot_bill_id -- 报价单编号
    ,bus_type_cd -- 业务类型代码
    ,tran_dir_cd -- 交易方向代码
    ,ghb_org_cd -- 本方机构代码
    ,ghb_non_lp_prod_id -- 本方非法人产编号
    ,ghb_tran_teller_id -- 本方交易柜员编号
    ,cntpty_org_id -- 对方机构编号
    ,cntpty_non_lp_prod_id -- 对方非法人产品编号
    ,cntpty_tran_teller_id -- 对方交易柜员编号
    ,bill_type_cd -- 票据类型代码
    ,bill_attr_cd -- 票据属性代码
    ,repo_amt -- 回购金额
    ,tenor_breed_cd -- 期限品种代码
    ,repo_tenor -- 回购期限
    ,clear_speed_cd -- 清算速度代码
    ,clear_type_cd -- 清算类型代码
    ,latest_fst_stl_tm -- 最晚首期结算时间
    ,stl_way_cd -- 结算方式代码
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,fst_stl_dt -- 首期结算日期
    ,exp_stl_dt -- 到期结算日期
    ,repo_int_rat -- 回购利率
    ,int_paybl -- 应付利息
    ,repo_yld_rat -- 回购收益率
    ,draw_bill_stop_tm -- 提票截止时间
    ,crdt_main_type_cd -- 信用主体类型代码
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,apv_status_cd -- 审批状态代码
    ,msg_status_cd -- 报文状态代码
    ,clear_status_cd -- 清算状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_tm -- 最后修改时间
    ,ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
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
    ,n.match_batch_ser_num -- 匹配批次序列号
    ,n.appl_batch_ser_num -- 申请批次序列号
    ,n.ctr_nt_ser_num -- 成交单序列号
    ,n.match_batch_id -- 匹配批次编号
    ,n.prod_id -- 产品编号
    ,n.std_prod_id -- 标准产品编号
    ,n.ctr_nt_id -- 成交单编号
    ,n.bag_way_cd -- 成交方式代码
    ,n.bag_tm -- 成交时间
    ,n.ctr_nt_status_cd -- 成交单状态代码
    ,n.bill_tot_cnt -- 票据总张数
    ,n.bill_tot_amt -- 票据总金额
    ,n.quot_bill_id -- 报价单编号
    ,n.bus_type_cd -- 业务类型代码
    ,n.tran_dir_cd -- 交易方向代码
    ,n.ghb_org_cd -- 本方机构代码
    ,n.ghb_non_lp_prod_id -- 本方非法人产编号
    ,n.ghb_tran_teller_id -- 本方交易柜员编号
    ,n.cntpty_org_id -- 对方机构编号
    ,n.cntpty_non_lp_prod_id -- 对方非法人产品编号
    ,n.cntpty_tran_teller_id -- 对方交易柜员编号
    ,n.bill_type_cd -- 票据类型代码
    ,n.bill_attr_cd -- 票据属性代码
    ,n.repo_amt -- 回购金额
    ,n.tenor_breed_cd -- 期限品种代码
    ,n.repo_tenor -- 回购期限
    ,n.clear_speed_cd -- 清算速度代码
    ,n.clear_type_cd -- 清算类型代码
    ,n.latest_fst_stl_tm -- 最晚首期结算时间
    ,n.stl_way_cd -- 结算方式代码
    ,n.fst_stl_amt -- 首期结算金额
    ,n.exp_stl_amt -- 到期结算金额
    ,n.fst_stl_dt -- 首期结算日期
    ,n.exp_stl_dt -- 到期结算日期
    ,n.repo_int_rat -- 回购利率
    ,n.int_paybl -- 应付利息
    ,n.repo_yld_rat -- 回购收益率
    ,n.draw_bill_stop_tm -- 提票截止时间
    ,n.crdt_main_type_cd -- 信用主体类型代码
    ,n.dept_id -- 部门编号
    ,n.cust_mgr_id -- 客户经理编号
    ,n.bus_org_id -- 业务机构编号
    ,n.hq_org_id -- 总行机构编号
    ,n.apv_status_cd -- 审批状态代码
    ,n.msg_status_cd -- 报文状态代码
    ,n.clear_status_cd -- 清算状态代码
    ,n.entry_status_cd -- 记账状态代码
    ,n.final_modif_tm -- 最后修改时间
    ,n.ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'bdmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_anony_click_match_batch_bdmsi1_tm n
    left join ${iml_schema}.evt_anony_click_match_batch_bdmsi1_bk o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        o.match_batch_ser_num <> n.match_batch_ser_num
        or o.appl_batch_ser_num <> n.appl_batch_ser_num
        or o.ctr_nt_ser_num <> n.ctr_nt_ser_num
        or o.match_batch_id <> n.match_batch_id
        or o.prod_id <> n.prod_id
        or o.std_prod_id <> n.std_prod_id
        or o.ctr_nt_id <> n.ctr_nt_id
        or o.bag_way_cd <> n.bag_way_cd
        or o.bag_tm <> n.bag_tm
        or o.ctr_nt_status_cd <> n.ctr_nt_status_cd
        or o.bill_tot_cnt <> n.bill_tot_cnt
        or o.bill_tot_amt <> n.bill_tot_amt
        or o.quot_bill_id <> n.quot_bill_id
        or o.bus_type_cd <> n.bus_type_cd
        or o.tran_dir_cd <> n.tran_dir_cd
        or o.ghb_org_cd <> n.ghb_org_cd
        or o.ghb_non_lp_prod_id <> n.ghb_non_lp_prod_id
        or o.ghb_tran_teller_id <> n.ghb_tran_teller_id
        or o.cntpty_org_id <> n.cntpty_org_id
        or o.cntpty_non_lp_prod_id <> n.cntpty_non_lp_prod_id
        or o.cntpty_tran_teller_id <> n.cntpty_tran_teller_id
        or o.bill_type_cd <> n.bill_type_cd
        or o.bill_attr_cd <> n.bill_attr_cd
        or o.repo_amt <> n.repo_amt
        or o.tenor_breed_cd <> n.tenor_breed_cd
        or o.repo_tenor <> n.repo_tenor
        or o.clear_speed_cd <> n.clear_speed_cd
        or o.clear_type_cd <> n.clear_type_cd
        or o.latest_fst_stl_tm <> n.latest_fst_stl_tm
        or o.stl_way_cd <> n.stl_way_cd
        or o.fst_stl_amt <> n.fst_stl_amt
        or o.exp_stl_amt <> n.exp_stl_amt
        or o.fst_stl_dt <> n.fst_stl_dt
        or o.exp_stl_dt <> n.exp_stl_dt
        or o.repo_int_rat <> n.repo_int_rat
        or o.int_paybl <> n.int_paybl
        or o.repo_yld_rat <> n.repo_yld_rat
        or o.draw_bill_stop_tm <> n.draw_bill_stop_tm
        or o.crdt_main_type_cd <> n.crdt_main_type_cd
        or o.dept_id <> n.dept_id
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.bus_org_id <> n.bus_org_id
        or o.hq_org_id <> n.hq_org_id
        or o.apv_status_cd <> n.apv_status_cd
        or o.msg_status_cd <> n.msg_status_cd
        or o.clear_status_cd <> n.clear_status_cd
        or o.entry_status_cd <> n.entry_status_cd
        or o.final_modif_tm <> n.final_modif_tm
        or o.ibank_crdt_lmt_ocup_status_cd <> n.ibank_crdt_lmt_ocup_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_anony_click_match_batch_bdmsi1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,match_batch_ser_num -- 匹配批次序列号
    ,appl_batch_ser_num -- 申请批次序列号
    ,ctr_nt_ser_num -- 成交单序列号
    ,match_batch_id -- 匹配批次编号
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,ctr_nt_id -- 成交单编号
    ,bag_way_cd -- 成交方式代码
    ,bag_tm -- 成交时间
    ,ctr_nt_status_cd -- 成交单状态代码
    ,bill_tot_cnt -- 票据总张数
    ,bill_tot_amt -- 票据总金额
    ,quot_bill_id -- 报价单编号
    ,bus_type_cd -- 业务类型代码
    ,tran_dir_cd -- 交易方向代码
    ,ghb_org_cd -- 本方机构代码
    ,ghb_non_lp_prod_id -- 本方非法人产编号
    ,ghb_tran_teller_id -- 本方交易柜员编号
    ,cntpty_org_id -- 对方机构编号
    ,cntpty_non_lp_prod_id -- 对方非法人产品编号
    ,cntpty_tran_teller_id -- 对方交易柜员编号
    ,bill_type_cd -- 票据类型代码
    ,bill_attr_cd -- 票据属性代码
    ,repo_amt -- 回购金额
    ,tenor_breed_cd -- 期限品种代码
    ,repo_tenor -- 回购期限
    ,clear_speed_cd -- 清算速度代码
    ,clear_type_cd -- 清算类型代码
    ,latest_fst_stl_tm -- 最晚首期结算时间
    ,stl_way_cd -- 结算方式代码
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,fst_stl_dt -- 首期结算日期
    ,exp_stl_dt -- 到期结算日期
    ,repo_int_rat -- 回购利率
    ,int_paybl -- 应付利息
    ,repo_yld_rat -- 回购收益率
    ,draw_bill_stop_tm -- 提票截止时间
    ,crdt_main_type_cd -- 信用主体类型代码
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,apv_status_cd -- 审批状态代码
    ,msg_status_cd -- 报文状态代码
    ,clear_status_cd -- 清算状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_tm -- 最后修改时间
    ,ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_anony_click_match_batch_bdmsi1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,match_batch_ser_num -- 匹配批次序列号
    ,appl_batch_ser_num -- 申请批次序列号
    ,ctr_nt_ser_num -- 成交单序列号
    ,match_batch_id -- 匹配批次编号
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,ctr_nt_id -- 成交单编号
    ,bag_way_cd -- 成交方式代码
    ,bag_tm -- 成交时间
    ,ctr_nt_status_cd -- 成交单状态代码
    ,bill_tot_cnt -- 票据总张数
    ,bill_tot_amt -- 票据总金额
    ,quot_bill_id -- 报价单编号
    ,bus_type_cd -- 业务类型代码
    ,tran_dir_cd -- 交易方向代码
    ,ghb_org_cd -- 本方机构代码
    ,ghb_non_lp_prod_id -- 本方非法人产编号
    ,ghb_tran_teller_id -- 本方交易柜员编号
    ,cntpty_org_id -- 对方机构编号
    ,cntpty_non_lp_prod_id -- 对方非法人产品编号
    ,cntpty_tran_teller_id -- 对方交易柜员编号
    ,bill_type_cd -- 票据类型代码
    ,bill_attr_cd -- 票据属性代码
    ,repo_amt -- 回购金额
    ,tenor_breed_cd -- 期限品种代码
    ,repo_tenor -- 回购期限
    ,clear_speed_cd -- 清算速度代码
    ,clear_type_cd -- 清算类型代码
    ,latest_fst_stl_tm -- 最晚首期结算时间
    ,stl_way_cd -- 结算方式代码
    ,fst_stl_amt -- 首期结算金额
    ,exp_stl_amt -- 到期结算金额
    ,fst_stl_dt -- 首期结算日期
    ,exp_stl_dt -- 到期结算日期
    ,repo_int_rat -- 回购利率
    ,int_paybl -- 应付利息
    ,repo_yld_rat -- 回购收益率
    ,draw_bill_stop_tm -- 提票截止时间
    ,crdt_main_type_cd -- 信用主体类型代码
    ,dept_id -- 部门编号
    ,cust_mgr_id -- 客户经理编号
    ,bus_org_id -- 业务机构编号
    ,hq_org_id -- 总行机构编号
    ,apv_status_cd -- 审批状态代码
    ,msg_status_cd -- 报文状态代码
    ,clear_status_cd -- 清算状态代码
    ,entry_status_cd -- 记账状态代码
    ,final_modif_tm -- 最后修改时间
    ,ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
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
    ,o.match_batch_ser_num -- 匹配批次序列号
    ,o.appl_batch_ser_num -- 申请批次序列号
    ,o.ctr_nt_ser_num -- 成交单序列号
    ,o.match_batch_id -- 匹配批次编号
    ,o.prod_id -- 产品编号
    ,o.std_prod_id -- 标准产品编号
    ,o.ctr_nt_id -- 成交单编号
    ,o.bag_way_cd -- 成交方式代码
    ,o.bag_tm -- 成交时间
    ,o.ctr_nt_status_cd -- 成交单状态代码
    ,o.bill_tot_cnt -- 票据总张数
    ,o.bill_tot_amt -- 票据总金额
    ,o.quot_bill_id -- 报价单编号
    ,o.bus_type_cd -- 业务类型代码
    ,o.tran_dir_cd -- 交易方向代码
    ,o.ghb_org_cd -- 本方机构代码
    ,o.ghb_non_lp_prod_id -- 本方非法人产编号
    ,o.ghb_tran_teller_id -- 本方交易柜员编号
    ,o.cntpty_org_id -- 对方机构编号
    ,o.cntpty_non_lp_prod_id -- 对方非法人产品编号
    ,o.cntpty_tran_teller_id -- 对方交易柜员编号
    ,o.bill_type_cd -- 票据类型代码
    ,o.bill_attr_cd -- 票据属性代码
    ,o.repo_amt -- 回购金额
    ,o.tenor_breed_cd -- 期限品种代码
    ,o.repo_tenor -- 回购期限
    ,o.clear_speed_cd -- 清算速度代码
    ,o.clear_type_cd -- 清算类型代码
    ,o.latest_fst_stl_tm -- 最晚首期结算时间
    ,o.stl_way_cd -- 结算方式代码
    ,o.fst_stl_amt -- 首期结算金额
    ,o.exp_stl_amt -- 到期结算金额
    ,o.fst_stl_dt -- 首期结算日期
    ,o.exp_stl_dt -- 到期结算日期
    ,o.repo_int_rat -- 回购利率
    ,o.int_paybl -- 应付利息
    ,o.repo_yld_rat -- 回购收益率
    ,o.draw_bill_stop_tm -- 提票截止时间
    ,o.crdt_main_type_cd -- 信用主体类型代码
    ,o.dept_id -- 部门编号
    ,o.cust_mgr_id -- 客户经理编号
    ,o.bus_org_id -- 业务机构编号
    ,o.hq_org_id -- 总行机构编号
    ,o.apv_status_cd -- 审批状态代码
    ,o.msg_status_cd -- 报文状态代码
    ,o.clear_status_cd -- 清算状态代码
    ,o.entry_status_cd -- 记账状态代码
    ,o.final_modif_tm -- 最后修改时间
    ,o.ibank_crdt_lmt_ocup_status_cd -- 同业授信额度占用状态代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_anony_click_match_batch_bdmsi1_bk o
    left join ${iml_schema}.evt_anony_click_match_batch_bdmsi1_op n
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
               and table_name=upper('evt_anony_click_match_batch') 
               and substr(subpartition_name,1,8)=upper('p_bdmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_anony_click_match_batch drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_anony_click_match_batch modify partition p_bdmsi1 
add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','YYYYMMDD'));
  
-- 4.2 exchange partition
alter table ${iml_schema}.evt_anony_click_match_batch exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_cl;
alter table ${iml_schema}.evt_anony_click_match_batch exchange subpartition p_bdmsi1_20991231 with table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_anony_click_match_batch to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_tm purge;
drop table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_op purge;
drop table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_anony_click_match_batch_bdmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_anony_click_match_batch', partname => 'p_bdmsi1_20991231', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1', no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
