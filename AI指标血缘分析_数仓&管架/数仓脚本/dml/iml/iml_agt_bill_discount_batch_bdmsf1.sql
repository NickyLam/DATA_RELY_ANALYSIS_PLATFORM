/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_discount_batch_bdmsf1
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
drop table ${iml_schema}.agt_bill_discount_batch_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_discount_batch_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bill_discount_batch add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bill_discount_batch modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_discount_batch_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_discount_batch partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_discount_batch_bdmsf1_tm
compress ${option_switch} for query high
as
select
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,hq_org_id -- 总行机构编号
    ,cont_id -- 合同编号
    ,appl_dt -- 申请日期
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,bus_dt -- 转贴现日期
    ,quot_bill_id -- 报价单编号
    ,bus_type_cd -- 业务类型代码
    ,sys_in_flg -- 系统外标志
    ,send_msg_flg -- 发送报文标志
    ,ctr_nt_id -- 成交单编号
    ,tran_dir_cd -- 交易方向代码
    ,bus_org_id -- 业务机构编号
    ,acct_instit_id -- 账务机构编号
    ,tran_teller_id -- 交易柜员编号
    ,cust_mgr_id -- 客户经理编号
    ,dept_id -- 部门编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_belong_bank_no -- 客户所属行行号
    ,cust_belong_org_id -- 客户所属机构编号
    ,bill_type_cd -- 票据类型代码
    ,bill_med_cd -- 票据介质代码
    ,bill_cnt -- 票据张数
    ,bill_tot -- 票据总额
    ,repo_amt -- 回购金额
    ,hold_tenor -- 持票期限
    ,part_bag_option_flg -- 部分成交选项标志
    ,quot_valid_tm -- 报价有效时间
    ,clear_speed_cd -- 清算速度代码
    ,clear_type_cd -- 清算类型代码
    ,latest_stl_tm -- 最晚结算时间
    ,stl_way_cd -- 结算方式代码
    ,stl_amt -- 转贴现金额
    ,exp_stl_amt -- 到期结算金额
    ,stl_dt -- 结算日期
    ,exp_stl_dt -- 到期结算日期
    ,int_rat -- 利率
    ,exp_int_rat -- 到期利率
    ,int_paybl -- 应付利息
    ,exp_int_paybl -- 到期应付利息
    ,yld_rat -- 收益率
    ,select_type_cd -- 挑票类型代码
    ,bill_pkg_id -- 票据包编号
    ,crdt_check_status_cd -- 授信检查状态代码
    ,entry_status_cd -- 记账状态代码
    ,msg_status_cd -- 报文状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_tm -- 最后修改时间
    ,apv_status_cd -- 审批状态代码
    ,modif_flg -- 修改标志
    ,asset_thd_cls_cd -- 资产三分类代码
    ,remark_1 -- 备注1
    ,creator_id -- 创建人编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_discount_batch
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bill_discount_batch_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bill_discount_batch partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_cpes_quote_contract-
insert into ${iml_schema}.agt_bill_discount_batch_bdmsf1_tm(
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,hq_org_id -- 总行机构编号
    ,cont_id -- 合同编号
    ,appl_dt -- 申请日期
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,bus_dt -- 转贴现日期
    ,quot_bill_id -- 报价单编号
    ,bus_type_cd -- 业务类型代码
    ,sys_in_flg -- 系统外标志
    ,send_msg_flg -- 发送报文标志
    ,ctr_nt_id -- 成交单编号
    ,tran_dir_cd -- 交易方向代码
    ,bus_org_id -- 业务机构编号
    ,acct_instit_id -- 账务机构编号
    ,tran_teller_id -- 交易柜员编号
    ,cust_mgr_id -- 客户经理编号
    ,dept_id -- 部门编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_belong_bank_no -- 客户所属行行号
    ,cust_belong_org_id -- 客户所属机构编号
    ,bill_type_cd -- 票据类型代码
    ,bill_med_cd -- 票据介质代码
    ,bill_cnt -- 票据张数
    ,bill_tot -- 票据总额
    ,repo_amt -- 回购金额
    ,hold_tenor -- 持票期限
    ,part_bag_option_flg -- 部分成交选项标志
    ,quot_valid_tm -- 报价有效时间
    ,clear_speed_cd -- 清算速度代码
    ,clear_type_cd -- 清算类型代码
    ,latest_stl_tm -- 最晚结算时间
    ,stl_way_cd -- 结算方式代码
    ,stl_amt -- 转贴现金额
    ,exp_stl_amt -- 到期结算金额
    ,stl_dt -- 结算日期
    ,exp_stl_dt -- 到期结算日期
    ,int_rat -- 利率
    ,exp_int_rat -- 到期利率
    ,int_paybl -- 应付利息
    ,exp_int_paybl -- 到期应付利息
    ,yld_rat -- 收益率
    ,select_type_cd -- 挑票类型代码
    ,bill_pkg_id -- 票据包编号
    ,crdt_check_status_cd -- 授信检查状态代码
    ,entry_status_cd -- 记账状态代码
    ,msg_status_cd -- 报文状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_tm -- 最后修改时间
    ,apv_status_cd -- 审批状态代码
    ,modif_flg -- 修改标志
    ,asset_thd_cls_cd -- 资产三分类代码
    ,remark_1 -- 备注1
    ,creator_id -- 创建人编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 批次编号
    ,'9999' -- 法人编号
    ,P1.TOP_BRANCH_NO -- 总行机构编号
    ,P1.CONTRACT_NO -- 合同编号
    ,${iml_schema}.DATEFORMAT_MAX2(P1.APPLY_DATE) -- 申请日期
    ,P1.PRODUCT_NO -- 产品编号
    ,nvl(trim(p3.PROD_CODE),' ') -- 标准产品编号
    ,${iml_schema}.DATEFORMAT_MAX2(P1.BUSI_DATE) -- 转贴现日期
    ,P1.QUOTE_NO -- 报价单编号
    ,NVL(TRIM(P1.BUSI_TYPE),'BT00') -- 业务类型代码
    ,NVL(TRIM(P1.INNER_FLAG),'-') -- 系统外标志
    ,NVL(TRIM(P1.IS_SEND),'-') -- 发送报文标志
    ,P1.DEAL_ID -- 成交单编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TRADE_DIRECT END -- 交易方向代码
    ,P1.BUSI_BRANCH_NO -- 业务机构编号
    ,P1.ACCT_BRANCH_NO -- 账务机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.MANAGER_NO -- 客户经理编号
    ,P1.DEPARTMENT_NO -- 部门编号
    ,coalesce(TRIM(P2.CUST_NO),P5.CUST_NO,' ') -- 客户编号
    ,P1.CUST_NAME -- 客户名称
    ,P1.CUST_BANK_NO -- 客户所属行行号
    ,P1.CUST_BRH_NO -- 客户所属机构编号
    ,nvl(trim(P1.DRAFT_TYPE),'-') -- 票据类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DRAFT_ATTR END -- 票据介质代码
    ,P1.SUM_COUNT -- 票据张数
    ,P1.SUM_AMOUNT -- 票据总额
    ,P1.BUY_BACK_AMT -- 回购金额
    ,P1.TENOR_DAYS -- 持票期限
    ,NVL(TRIM(P1.SUB_DEAL_FLAG),'-') -- 部分成交选项标志
    ,to_timestamp(to_char(${iml_schema}.dateformat_max(P1.QUOTE_VALID_TM),'yyyy/mm/dd HH24:MI:SS'),'yyyy/mm/dd HH24:MI:SS.FF6') -- 报价有效时间
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.CLEAR_SPEED END -- 清算速度代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.CLEAR_TYPE END -- 清算类型代码
    ,to_timestamp(to_char(${iml_schema}.dateformat_max(P1.SETTLE_TIME),'yyyy/mm/dd HH24:MI:SS'),'yyyy/mm/dd HH24:MI:SS.FF6') -- 最晚结算时间
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.SETTLE_MODE END -- 结算方式代码
    ,P1.SETTLE_AMT -- 转贴现金额
    ,P1.DUE_SETTLE_AMT -- 到期结算金额
    ,${iml_schema}.DATEFORMAT_MAX2(P1.SETTLE_DATE) -- 结算日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.DUE_SETTLE_DATE) -- 到期结算日期
    ,P1.RATE*100 -- 利率
    ,P1.DUE_RATE -- 到期利率
    ,P1.PAY_INTEREST -- 应付利息
    ,P1.DUE_PAY_INTEREST -- 到期应付利息
    ,P1.YIELD_RATE -- 收益率
    ,NVL(TRIM(P1.SELECT_TYPE),'CSM00') -- 挑票类型代码
    ,P1.PACKAGE_NO -- 票据包编号
    ,NVL(TRIM(P1.CREDIT_CHECK_STATUS),'-') -- 授信检查状态代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_STATUS END -- 记账状态代码
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.MESSAGE_STATUS END -- 报文状态代码
    ,NVL(TRIM(P1.SETTLE_STATUS),'-') -- 清算状态代码
    ,to_timestamp(to_char(${iml_schema}.dateformat_max(P1.LAST_UPD_TIME),'yyyy/mm/dd HH24:MI:SS'),'yyyy/mm/dd HH24:MI:SS.FF6') -- 最后修改时间
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.CONTRACT_STATUS END -- 审批状态代码
    ,NVL(TRIM(P1.MODIFY_FLAG),'-') -- 修改标志
    ,CASE WHEN P1.BUSI_TYPE='BT01' AND P1.TRADE_DIRECT= 'TDD01' THEN  NVL(TRIM(P1.I9_TYPE),'FVOCI') WHEN  P1.TRADE_DIRECT= 'CRD01' THEN NVL(TRIM(P1.I9_TYPE),'AC') ELSE NVL(TRIM(P1.I9_TYPE),'XXX') END -- 资产三分类代码
    ,P1.RESERVER2 -- 备注1
    ,P1.CREATED_BY -- 创建人编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_quote_contract' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_quote_contract p1
    left join (select * from ${iol_schema}.bdms_bms_customer_info b where  b.cust_type='3' and trim(b.brh_no)  is not null and b.start_dt<=to_date('${batch_date}','yyyymmdd') and b.end_dt>to_date('${batch_date}','yyyymmdd')) p2 on p1.cust_brh_no=p2.BRH_NO
    left join ${iol_schema}.bdms_meta_deposit_define p3 on p1.PRODUCT_NO=p3.PRODUCT_NO
and p3.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') 
AND p3.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TRADE_DIRECT= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_CPES_QUOTE_CONTRACT'
        AND R3.SRC_FIELD_EN_NAME= 'TRADE_DIRECT'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCOUNT_BATCH'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iol_schema}.bdms_cust_mem_brh_rel p4 on p1.cust_brh_no = p4.brh_no and p4.start_dt<=to_date('${batch_date}','yyyymmdd') and p4.end_dt>to_date('${batch_date}','yyyymmdd')
    left join (select * from ${iol_schema}.bdms_bms_customer_info b where  b.cust_type='3'  and b.start_dt<=to_date('${batch_date}','yyyymmdd') and b.end_dt>to_date('${batch_date}','yyyymmdd')) p5 on P4.CUST_ID=p5.ID
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DRAFT_ATTR = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CPES_QUOTE_CONTRACT'
        AND R2.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCOUNT_BATCH'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BILL_MED_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CLEAR_SPEED = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'BDMS'
        AND R4.SRC_TAB_EN_NAME= 'BDMS_CPES_QUOTE_CONTRACT'
        AND R4.SRC_FIELD_EN_NAME= 'CLEAR_SPEED'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCOUNT_BATCH'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_SPEED_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CLEAR_TYPE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'BDMS'
        AND R5.SRC_TAB_EN_NAME= 'BDMS_CPES_QUOTE_CONTRACT'
        AND R5.SRC_FIELD_EN_NAME= 'CLEAR_TYPE'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCOUNT_BATCH'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.SETTLE_MODE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'BDMS'
        AND R6.SRC_TAB_EN_NAME= 'BDMS_CPES_QUOTE_CONTRACT'
        AND R6.SRC_FIELD_EN_NAME= 'SETTLE_MODE'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCOUNT_BATCH'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.ACCOUNT_STATUS = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'BDMS'
        AND R7.SRC_TAB_EN_NAME= 'BDMS_CPES_QUOTE_CONTRACT'
        AND R7.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R7.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCOUNT_BATCH'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.MESSAGE_STATUS = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'BDMS'
        AND R8.SRC_TAB_EN_NAME= 'BDMS_CPES_QUOTE_CONTRACT'
        AND R8.SRC_FIELD_EN_NAME= 'MESSAGE_STATUS'
        AND R8.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCOUNT_BATCH'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'MSG_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.CONTRACT_STATUS = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'BDMS'
        AND R9.SRC_TAB_EN_NAME= 'BDMS_CPES_QUOTE_CONTRACT'
        AND R9.SRC_FIELD_EN_NAME= 'CONTRACT_STATUS'
        AND R9.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCOUNT_BATCH'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'APV_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_discount_batch_bdmsf1_tm 
  	                                group by 
  	                                        batch_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_bill_discount_batch_bdmsf1_ex(
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,hq_org_id -- 总行机构编号
    ,cont_id -- 合同编号
    ,appl_dt -- 申请日期
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,bus_dt -- 转贴现日期
    ,quot_bill_id -- 报价单编号
    ,bus_type_cd -- 业务类型代码
    ,sys_in_flg -- 系统外标志
    ,send_msg_flg -- 发送报文标志
    ,ctr_nt_id -- 成交单编号
    ,tran_dir_cd -- 交易方向代码
    ,bus_org_id -- 业务机构编号
    ,acct_instit_id -- 账务机构编号
    ,tran_teller_id -- 交易柜员编号
    ,cust_mgr_id -- 客户经理编号
    ,dept_id -- 部门编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_belong_bank_no -- 客户所属行行号
    ,cust_belong_org_id -- 客户所属机构编号
    ,bill_type_cd -- 票据类型代码
    ,bill_med_cd -- 票据介质代码
    ,bill_cnt -- 票据张数
    ,bill_tot -- 票据总额
    ,repo_amt -- 回购金额
    ,hold_tenor -- 持票期限
    ,part_bag_option_flg -- 部分成交选项标志
    ,quot_valid_tm -- 报价有效时间
    ,clear_speed_cd -- 清算速度代码
    ,clear_type_cd -- 清算类型代码
    ,latest_stl_tm -- 最晚结算时间
    ,stl_way_cd -- 结算方式代码
    ,stl_amt -- 转贴现金额
    ,exp_stl_amt -- 到期结算金额
    ,stl_dt -- 结算日期
    ,exp_stl_dt -- 到期结算日期
    ,int_rat -- 利率
    ,exp_int_rat -- 到期利率
    ,int_paybl -- 应付利息
    ,exp_int_paybl -- 到期应付利息
    ,yld_rat -- 收益率
    ,select_type_cd -- 挑票类型代码
    ,bill_pkg_id -- 票据包编号
    ,crdt_check_status_cd -- 授信检查状态代码
    ,entry_status_cd -- 记账状态代码
    ,msg_status_cd -- 报文状态代码
    ,clear_status_cd -- 清算状态代码
    ,final_modif_tm -- 最后修改时间
    ,apv_status_cd -- 审批状态代码
    ,modif_flg -- 修改标志
    ,asset_thd_cls_cd -- 资产三分类代码
    ,remark_1 -- 备注1
    ,creator_id -- 创建人编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.hq_org_id, o.hq_org_id) as hq_org_id -- 总行机构编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.std_prod_id, o.std_prod_id) as std_prod_id -- 标准产品编号
    ,nvl(n.bus_dt, o.bus_dt) as bus_dt -- 转贴现日期
    ,nvl(n.quot_bill_id, o.quot_bill_id) as quot_bill_id -- 报价单编号
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.sys_in_flg, o.sys_in_flg) as sys_in_flg -- 系统外标志
    ,nvl(n.send_msg_flg, o.send_msg_flg) as send_msg_flg -- 发送报文标志
    ,nvl(n.ctr_nt_id, o.ctr_nt_id) as ctr_nt_id -- 成交单编号
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.bus_org_id, o.bus_org_id) as bus_org_id -- 业务机构编号
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.dept_id, o.dept_id) as dept_id -- 部门编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_belong_bank_no, o.cust_belong_bank_no) as cust_belong_bank_no -- 客户所属行行号
    ,nvl(n.cust_belong_org_id, o.cust_belong_org_id) as cust_belong_org_id -- 客户所属机构编号
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.bill_med_cd, o.bill_med_cd) as bill_med_cd -- 票据介质代码
    ,nvl(n.bill_cnt, o.bill_cnt) as bill_cnt -- 票据张数
    ,nvl(n.bill_tot, o.bill_tot) as bill_tot -- 票据总额
    ,nvl(n.repo_amt, o.repo_amt) as repo_amt -- 回购金额
    ,nvl(n.hold_tenor, o.hold_tenor) as hold_tenor -- 持票期限
    ,nvl(n.part_bag_option_flg, o.part_bag_option_flg) as part_bag_option_flg -- 部分成交选项标志
    ,nvl(n.quot_valid_tm, o.quot_valid_tm) as quot_valid_tm -- 报价有效时间
    ,nvl(n.clear_speed_cd, o.clear_speed_cd) as clear_speed_cd -- 清算速度代码
    ,nvl(n.clear_type_cd, o.clear_type_cd) as clear_type_cd -- 清算类型代码
    ,nvl(n.latest_stl_tm, o.latest_stl_tm) as latest_stl_tm -- 最晚结算时间
    ,nvl(n.stl_way_cd, o.stl_way_cd) as stl_way_cd -- 结算方式代码
    ,nvl(n.stl_amt, o.stl_amt) as stl_amt -- 转贴现金额
    ,nvl(n.exp_stl_amt, o.exp_stl_amt) as exp_stl_amt -- 到期结算金额
    ,nvl(n.stl_dt, o.stl_dt) as stl_dt -- 结算日期
    ,nvl(n.exp_stl_dt, o.exp_stl_dt) as exp_stl_dt -- 到期结算日期
    ,nvl(n.int_rat, o.int_rat) as int_rat -- 利率
    ,nvl(n.exp_int_rat, o.exp_int_rat) as exp_int_rat -- 到期利率
    ,nvl(n.int_paybl, o.int_paybl) as int_paybl -- 应付利息
    ,nvl(n.exp_int_paybl, o.exp_int_paybl) as exp_int_paybl -- 到期应付利息
    ,nvl(n.yld_rat, o.yld_rat) as yld_rat -- 收益率
    ,nvl(n.select_type_cd, o.select_type_cd) as select_type_cd -- 挑票类型代码
    ,nvl(n.bill_pkg_id, o.bill_pkg_id) as bill_pkg_id -- 票据包编号
    ,nvl(n.crdt_check_status_cd, o.crdt_check_status_cd) as crdt_check_status_cd -- 授信检查状态代码
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.msg_status_cd, o.msg_status_cd) as msg_status_cd -- 报文状态代码
    ,nvl(n.clear_status_cd, o.clear_status_cd) as clear_status_cd -- 清算状态代码
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.modif_flg, o.modif_flg) as modif_flg -- 修改标志
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.remark_1, o.remark_1) as remark_1 -- 备注1
    ,nvl(n.creator_id, o.creator_id) as creator_id -- 创建人编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.batch_id is null
                and o.lp_id is null
            ) or (
                o.hq_org_id <> n.hq_org_id
                or o.cont_id <> n.cont_id
                or o.appl_dt <> n.appl_dt
                or o.prod_id <> n.prod_id
                or o.std_prod_id <> n.std_prod_id
                or o.bus_dt <> n.bus_dt
                or o.quot_bill_id <> n.quot_bill_id
                or o.bus_type_cd <> n.bus_type_cd
                or o.sys_in_flg <> n.sys_in_flg
                or o.send_msg_flg <> n.send_msg_flg
                or o.ctr_nt_id <> n.ctr_nt_id
                or o.tran_dir_cd <> n.tran_dir_cd
                or o.bus_org_id <> n.bus_org_id
                or o.acct_instit_id <> n.acct_instit_id
                or o.tran_teller_id <> n.tran_teller_id
                or o.cust_mgr_id <> n.cust_mgr_id
                or o.dept_id <> n.dept_id
                or o.cust_id <> n.cust_id
                or o.cust_name <> n.cust_name
                or o.cust_belong_bank_no <> n.cust_belong_bank_no
                or o.cust_belong_org_id <> n.cust_belong_org_id
                or o.bill_type_cd <> n.bill_type_cd
                or o.bill_med_cd <> n.bill_med_cd
                or o.bill_cnt <> n.bill_cnt
                or o.bill_tot <> n.bill_tot
                or o.repo_amt <> n.repo_amt
                or o.hold_tenor <> n.hold_tenor
                or o.part_bag_option_flg <> n.part_bag_option_flg
                or o.quot_valid_tm <> n.quot_valid_tm
                or o.clear_speed_cd <> n.clear_speed_cd
                or o.clear_type_cd <> n.clear_type_cd
                or o.latest_stl_tm <> n.latest_stl_tm
                or o.stl_way_cd <> n.stl_way_cd
                or o.stl_amt <> n.stl_amt
                or o.exp_stl_amt <> n.exp_stl_amt
                or o.stl_dt <> n.stl_dt
                or o.exp_stl_dt <> n.exp_stl_dt
                or o.int_rat <> n.int_rat
                or o.exp_int_rat <> n.exp_int_rat
                or o.int_paybl <> n.int_paybl
                or o.exp_int_paybl <> n.exp_int_paybl
                or o.yld_rat <> n.yld_rat
                or o.select_type_cd <> n.select_type_cd
                or o.bill_pkg_id <> n.bill_pkg_id
                or o.crdt_check_status_cd <> n.crdt_check_status_cd
                or o.entry_status_cd <> n.entry_status_cd
                or o.msg_status_cd <> n.msg_status_cd
                or o.clear_status_cd <> n.clear_status_cd
                or o.final_modif_tm <> n.final_modif_tm
                or o.apv_status_cd <> n.apv_status_cd
                or o.modif_flg <> n.modif_flg
                or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
                or o.remark_1 <> n.remark_1
                or o.creator_id <> n.creator_id
            ) or (
                 case when (
                           n.batch_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.batch_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_discount_batch_bdmsf1_tm n
    full join ${iml_schema}.agt_bill_discount_batch_bdmsf1_bk o
        on
            o.batch_id = n.batch_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bill_discount_batch truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bill_discount_batch exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_discount_batch_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bill_discount_batch drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_discount_batch to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bill_discount_batch_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_discount_batch_bdmsf1_ex purge;
drop table ${iml_schema}.agt_bill_discount_batch_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_discount_batch', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);