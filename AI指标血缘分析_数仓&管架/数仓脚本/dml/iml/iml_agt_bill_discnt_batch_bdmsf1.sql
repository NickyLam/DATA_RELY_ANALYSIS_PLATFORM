/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_discnt_batch_bdmsf1
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
drop table ${iml_schema}.agt_bill_discnt_batch_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_discnt_batch_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bill_discnt_batch add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bill_discnt_batch modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_discnt_batch_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_discnt_batch partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_discnt_batch_bdmsf1_tm
compress ${option_switch} for query high
as
select
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,discnt_agt_id -- 贴现协议编号
    ,org_id -- 机构编号
    ,enter_acct_org_id -- 入账机构编号
    ,buy_prod_cd -- 买入产品代码
    ,buy_type_cd -- 买入类型代码
    ,discnt_bus_type_cd -- 贴现业务类型代码
    ,bus_type_cd -- 贴现类型代码
    ,bus_id -- 业务编号
    ,bill_type_cd -- 票据类型代码
    ,bill_med_cd -- 票据介质代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_open_bank_no -- 客户开户行行号
    ,cust_open_acct_num -- 客户开户账号
    ,int_rat -- 利率
    ,int_rat_type_cd -- 利率类型代码
    ,redem_int_rat -- 赎回利率
    ,redem_int_rat_type_cd -- 赎回利率类型代码
    ,link_int_rat -- 联动利率
    ,buy_dt -- 买入日期
    ,onl_clear_flg -- 线上清算标志
    ,clear_type_cd -- 清算类型代码
    ,stl_dt -- 结算日期
    ,stl_way_cd -- 结算方式代码
    ,redem_open_dt -- 赎回开放日期
    ,redem_closing_dt -- 赎回截止日期
    ,sys_in_flg -- 系统内标志
    ,pay_int_way_cd -- 付息方式代码
    ,int_payer_name -- 付息人名称
    ,int_payer_acct_num -- 付息人账号
    ,pay_int_ratio -- 付息比例
    ,agent_name -- 代理名称
    ,cust_mgr_id -- 客户经理编号
    ,dept_id -- 部门编号
    ,discnt_bf_revw_flg -- 先贴后查标志
    ,cont_matrl_backup_flg -- 合同资料后补标志
    ,backup_closing_dt -- 后补截止日期
    ,operr_id -- 操作员编号
    ,tran_dt -- 交易日期
    ,bus_logic_check_status_cd -- 业务逻辑检查状态代码
    ,crdt_check_status_cd -- 授信检查状态代码
    ,check_status_cd -- 审核状态代码
    ,int_accr_check_status_cd -- 计息复核状态代码
    ,entry_status_cd -- 记账状态代码
    ,intnal_stl_flg -- 内部结算标志
    ,intnal_stl_acct -- 内部结算账户
    ,agt_exp_dt -- 协议到期日期
    ,crdt_valid_amt -- 信贷有效金额
    ,apprved_use_crdt_open_amt -- 已批准使用授信敞口金额
    ,distr_post_acm_use_open_amt -- 本次放款后累计使用敞口金额
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,rela_party_que_rest_cd -- 关联方查询结果代码
    ,crdt_cont_used_amt -- 信贷合同已用金额
    ,crdt_cont_tot_amt -- 信贷合同总金额
    ,lmt_cont_used_tot_amt -- 额度合同已用总金额
    ,midgrod_bus_flow_num -- 中台业务流水号
    ,int_calc_defer_way_cd -- 利息计算顺延方式代码
    ,tgls_entry_status_cd -- 核算中台记账状态代码
    ,ncbs_entry_status_cd -- 核心记账状态代码
    ,h_data_flg -- 历史数据标志
    ,bus_type_id -- 业务类型编号
    ,bus_belong_org_id -- 业务所属机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_discnt_batch
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bill_discnt_batch_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bill_discnt_batch partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_bms_buy_contract-
insert into ${iml_schema}.agt_bill_discnt_batch_bdmsf1_tm(
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,discnt_agt_id -- 贴现协议编号
    ,org_id -- 机构编号
    ,enter_acct_org_id -- 入账机构编号
    ,buy_prod_cd -- 买入产品代码
    ,buy_type_cd -- 买入类型代码
    ,discnt_bus_type_cd -- 贴现业务类型代码
    ,bus_type_cd -- 贴现类型代码
    ,bus_id -- 业务编号
    ,bill_type_cd -- 票据类型代码
    ,bill_med_cd -- 票据介质代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_open_bank_no -- 客户开户行行号
    ,cust_open_acct_num -- 客户开户账号
    ,int_rat -- 利率
    ,int_rat_type_cd -- 利率类型代码
    ,redem_int_rat -- 赎回利率
    ,redem_int_rat_type_cd -- 赎回利率类型代码
    ,link_int_rat -- 联动利率
    ,buy_dt -- 买入日期
    ,onl_clear_flg -- 线上清算标志
    ,clear_type_cd -- 清算类型代码
    ,stl_dt -- 结算日期
    ,stl_way_cd -- 结算方式代码
    ,redem_open_dt -- 赎回开放日期
    ,redem_closing_dt -- 赎回截止日期
    ,sys_in_flg -- 系统内标志
    ,pay_int_way_cd -- 付息方式代码
    ,int_payer_name -- 付息人名称
    ,int_payer_acct_num -- 付息人账号
    ,pay_int_ratio -- 付息比例
    ,agent_name -- 代理名称
    ,cust_mgr_id -- 客户经理编号
    ,dept_id -- 部门编号
    ,discnt_bf_revw_flg -- 先贴后查标志
    ,cont_matrl_backup_flg -- 合同资料后补标志
    ,backup_closing_dt -- 后补截止日期
    ,operr_id -- 操作员编号
    ,tran_dt -- 交易日期
    ,bus_logic_check_status_cd -- 业务逻辑检查状态代码
    ,crdt_check_status_cd -- 授信检查状态代码
    ,check_status_cd -- 审核状态代码
    ,int_accr_check_status_cd -- 计息复核状态代码
    ,entry_status_cd -- 记账状态代码
    ,intnal_stl_flg -- 内部结算标志
    ,intnal_stl_acct -- 内部结算账户
    ,agt_exp_dt -- 协议到期日期
    ,crdt_valid_amt -- 信贷有效金额
    ,apprved_use_crdt_open_amt -- 已批准使用授信敞口金额
    ,distr_post_acm_use_open_amt -- 本次放款后累计使用敞口金额
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,rela_party_que_rest_cd -- 关联方查询结果代码
    ,crdt_cont_used_amt -- 信贷合同已用金额
    ,crdt_cont_tot_amt -- 信贷合同总金额
    ,lmt_cont_used_tot_amt -- 额度合同已用总金额
    ,midgrod_bus_flow_num -- 中台业务流水号
    ,int_calc_defer_way_cd -- 利息计算顺延方式代码
    ,tgls_entry_status_cd -- 核算中台记账状态代码
    ,ncbs_entry_status_cd -- 核心记账状态代码
    ,h_data_flg -- 历史数据标志
    ,bus_type_id -- 业务类型编号
    ,bus_belong_org_id -- 业务所属机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 批次编号
    ,'9999' -- 法人编号
    ,P1.PROTOCOL_NO -- 贴现协议编号
    ,P1.BUSI_BRANCH_NO -- 机构编号
    ,P1.ACCT_BRANCH_NO -- 入账机构编号
    ,P1.PRODUCT_NO -- 买入产品代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.RPD_MK END -- 买入类型代码
    ,NVL(TRIM(P1.CENTRAL_BANKFLG),'-') -- 贴现业务类型代码
    ,NVL(TRIM(P1.BUSI_TYPE),'-') -- 贴现类型代码
    ,P1.CREDIT_NO -- 业务编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DRAFT_TYPE END -- 票据类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.DRAFT_ATTR END -- 票据介质代码
    ,P1.CUST_NO -- 客户编号
    ,P1.CUST_NAME -- 客户名称
    ,P1.CUST_BANK_NO -- 客户开户行行号
    ,P1.CUST_ACCOUNT -- 客户开户账号
    ,P1.RATE*100 -- 利率
    ,NVL(TRIM(P1.RATE_TYPE),'0') -- 利率类型代码
    ,P1.REPURCHASE_RATE -- 赎回利率
    ,NVL(TRIM(P1.REPURCHASE_RATE_TYPE),'0') -- 赎回利率类型代码
    ,P1.LINK_RATE -- 联动利率
    ,${iml_schema}.DATEFORMAT_MAX2(P1.APPLY_DATE) -- 买入日期
    ,nvl(trim(P1.STTLM_MK),'-') -- 线上清算标志
    ,'00' -- 清算类型代码
    ,${iml_schema}.DATEFORMAT_MAX2(P1.APPLY_DATE) -- 结算日期
    ,'99' -- 结算方式代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.REPURCHASE_BEGIN_DATE) -- 赎回开放日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.REPURCHASE_END_DATE) -- 赎回截止日期
    ,nvl(trim(P1.INNER_FLAG),' ') -- 系统内标志
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.PAY_TYPE END -- 付息方式代码
    ,P1.PAYER_NAME -- 付息人名称
    ,P1.PAYER_ACCOUNT -- 付息人账号
    ,P1.PAYER_SCALE -- 付息比例
    ,P1.AGENT_NAME -- 代理名称
    ,P1.MANAGER_NO -- 客户经理编号
    ,P1.DEPARTMENT_NO -- 部门编号
    ,nvl(trim(P1.DISCOUNT_FIRST_FLAG),'-') -- 先贴后查标志
    ,nvl(trim(P1.MEND_FLAG),'-') -- 合同资料后补标志
    ,${iml_schema}.DATEFORMAT_MAX2(P1.ADD_LAST_DATE) -- 后补截止日期
    ,P1.LAST_OPERATOR_NO -- 操作员编号
    ,${iml_schema}.DATEFORMAT_MAX2(P1.TXN_DATE) -- 交易日期
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.CHECK_STATUS END -- 业务逻辑检查状态代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.CREDIT_CHECK_STATUS END -- 授信检查状态代码
    ,NVL(TRIM(P1.CONTRACT_STATUS),'-') -- 审核状态代码
    ,'0' -- 计息复核状态代码
    ,nvl(trim(P1.ACCOUNT_STATUS),'-') -- 记账状态代码
    ,nvl(trim(P1.IS_INTERNAL_SETTLE),'-') -- 内部结算标志
    ,P1.INTERNAL_ACCOUNT -- 内部结算账户
    ,${iml_schema}.DATEFORMAT_MAX2(P1.CONTRACT_DATE) -- 协议到期日期
    ,P1.TRANS_AMOUNT -- 信贷有效金额
    ,P1.ALL_CREDIT_EXP -- 已批准使用授信敞口金额
    ,P1.TOTAL_USE_CREDIT_EXP -- 本次放款后累计使用敞口金额
    ,CASE WHEN R10.TARGET_CD_VAL IS NOT NULL THEN R10.TARGET_CD_VAL ELSE '@'||P1.CERT_TYPE END -- 证件类型代码
    ,P1.CERT_ID -- 证件号码
    ,NVL(TRIM(P1.I9_TYPE),'XXX') -- 资产三分类代码
    ,nvl(trim(P1.IS_RELATED),'-') -- 关联方查询结果代码
    ,to_number(nvl(trim(P1.SUM_USE_CONTRACT),0)) -- 信贷合同已用金额
    ,P1.SUM_CONTRACT -- 信贷合同总金额
    ,P1.USED_TOTAL_SUM -- 额度合同已用总金额
    ,P1.UNIQUE_SEQ_NUM -- 中台业务流水号
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.POSTPONE_TYPE END -- 利息计算顺延方式代码
    ,P1.ACCT_STATUS -- 核算中台记账状态代码
    ,P1.SEND_FILE_STATUS -- 核心记账状态代码
    ,P1.RESERVE1 -- 历史数据标志
    ,P1.BUSSINESS_TYPE -- 业务类型编号
    ,P1.BUSINESS_BELONG_BRANCHNO -- 业务所属机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_buy_contract' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_buy_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.RPD_MK = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_BMS_BUY_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'RPD_MK'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BUY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DRAFT_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_BMS_BUY_CONTRACT'
        AND R2.SRC_FIELD_EN_NAME= 'DRAFT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.DRAFT_ATTR = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_BMS_BUY_CONTRACT'
        AND R3.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BILL_MED_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.PAY_TYPE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'BDMS'
        AND R5.SRC_TAB_EN_NAME= 'BDMS_BMS_BUY_CONTRACT'
        AND R5.SRC_FIELD_EN_NAME= 'PAY_TYPE'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'PAY_INT_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.CHECK_STATUS = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'BDMS'
        AND R6.SRC_TAB_EN_NAME= 'BDMS_BMS_BUY_CONTRACT'
        AND R6.SRC_FIELD_EN_NAME= 'CHECK_STATUS'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'BUS_LOGIC_CHECK_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CREDIT_CHECK_STATUS = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'BDMS'
        AND R4.SRC_TAB_EN_NAME= 'BDMS_BMS_BUY_CONTRACT'
        AND R4.SRC_FIELD_EN_NAME= 'CREDIT_CHECK_STATUS'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CRDT_CHECK_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r10 on P1.CERT_TYPE = R10.SRC_CODE_VAL
        AND R10.SORC_SYS_CD= 'BDMS'
        AND R10.SRC_TAB_EN_NAME= 'BDMS_BMS_BUY_CONTRACT'
        AND R10.SRC_FIELD_EN_NAME= 'CERT_TYPE'
        AND R10.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R10.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.POSTPONE_TYPE = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'BDMS'
        AND R8.SRC_TAB_EN_NAME= 'BDMS_BMS_BUY_CONTRACT'
        AND R8.SRC_FIELD_EN_NAME= 'POSTPONE_TYPE'
        AND R8.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'INT_CALC_DEFER_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and p1.CENTRAL_BANKFLG='0'
;
commit;

-- bdms_cpes_buy_contract-
insert into ${iml_schema}.agt_bill_discnt_batch_bdmsf1_tm(
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,discnt_agt_id -- 贴现协议编号
    ,org_id -- 机构编号
    ,enter_acct_org_id -- 入账机构编号
    ,buy_prod_cd -- 买入产品代码
    ,buy_type_cd -- 买入类型代码
    ,discnt_bus_type_cd -- 贴现业务类型代码
    ,bus_type_cd -- 贴现类型代码
    ,bus_id -- 业务编号
    ,bill_type_cd -- 票据类型代码
    ,bill_med_cd -- 票据介质代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_open_bank_no -- 客户开户行行号
    ,cust_open_acct_num -- 客户开户账号
    ,int_rat -- 利率
    ,int_rat_type_cd -- 利率类型代码
    ,redem_int_rat -- 赎回利率
    ,redem_int_rat_type_cd -- 赎回利率类型代码
    ,link_int_rat -- 联动利率
    ,buy_dt -- 买入日期
    ,onl_clear_flg -- 线上清算标志
    ,clear_type_cd -- 清算类型代码
    ,stl_dt -- 结算日期
    ,stl_way_cd -- 结算方式代码
    ,redem_open_dt -- 赎回开放日期
    ,redem_closing_dt -- 赎回截止日期
    ,sys_in_flg -- 系统内标志
    ,pay_int_way_cd -- 付息方式代码
    ,int_payer_name -- 付息人名称
    ,int_payer_acct_num -- 付息人账号
    ,pay_int_ratio -- 付息比例
    ,agent_name -- 代理名称
    ,cust_mgr_id -- 客户经理编号
    ,dept_id -- 部门编号
    ,discnt_bf_revw_flg -- 先贴后查标志
    ,cont_matrl_backup_flg -- 合同资料后补标志
    ,backup_closing_dt -- 后补截止日期
    ,operr_id -- 操作员编号
    ,tran_dt -- 交易日期
    ,bus_logic_check_status_cd -- 业务逻辑检查状态代码
    ,crdt_check_status_cd -- 授信检查状态代码
    ,check_status_cd -- 审核状态代码
    ,int_accr_check_status_cd -- 计息复核状态代码
    ,entry_status_cd -- 记账状态代码
    ,intnal_stl_flg -- 内部结算标志
    ,intnal_stl_acct -- 内部结算账户
    ,agt_exp_dt -- 协议到期日期
    ,crdt_valid_amt -- 信贷有效金额
    ,apprved_use_crdt_open_amt -- 已批准使用授信敞口金额
    ,distr_post_acm_use_open_amt -- 本次放款后累计使用敞口金额
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,rela_party_que_rest_cd -- 关联方查询结果代码
    ,crdt_cont_used_amt -- 信贷合同已用金额
    ,crdt_cont_tot_amt -- 信贷合同总金额
    ,lmt_cont_used_tot_amt -- 额度合同已用总金额
    ,midgrod_bus_flow_num -- 中台业务流水号
    ,int_calc_defer_way_cd -- 利息计算顺延方式代码
    ,tgls_entry_status_cd -- 核算中台记账状态代码
    ,ncbs_entry_status_cd -- 核心记账状态代码
    ,h_data_flg -- 历史数据标志
    ,bus_type_id -- 业务类型编号
    ,bus_belong_org_id -- 业务所属机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 批次编号
    ,'9999' -- 法人编号
    ,P1.PROTOCOL_NO -- 贴现协议编号
    ,P1.BUSI_BRANCH_NO -- 机构编号
    ,P1.ACCT_BRANCH_NO -- 入账机构编号
    ,P1.PRODUCT_NO -- 买入产品代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.RPD_MK END -- 买入类型代码
    ,'-' -- 贴现业务类型代码
    ,NVL(TRIM(P1.BUSI_TYPE),'-') -- 贴现类型代码
    ,P1.CREDIT_NO -- 业务编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DRAFT_TYPE END -- 票据类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.DRAFT_ATTR END -- 票据介质代码
    ,P1.CUST_NO -- 客户编号
    ,P1.CUST_NAME -- 客户名称
    ,P1.CUST_BANK_NO -- 客户开户行行号
    ,P1.CUST_ACCOUNT -- 客户开户账号
    ,P1.RATE*100 -- 利率
    ,NVL(TRIM(P1.RATE_TYPE),'0') -- 利率类型代码
    ,0.0 -- 赎回利率
    ,NVL(TRIM(P1.REPURCHASE_RATE_TYPE),'0') -- 赎回利率类型代码
    ,P1.LINK_RATE -- 联动利率
    ,${iml_schema}.DATEFORMAT_MAX2(P1.APPLY_DATE) -- 买入日期
    ,'-' -- 线上清算标志
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.CLEAR_TYPE END -- 清算类型代码
    ,${iml_schema}.DATEFORMAT_MAX2(P1.SETTLE_DATE) -- 结算日期
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.SETTLE_TYPE END -- 结算方式代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.REPURCHASE_BEGIN_DATE) -- 赎回开放日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.REPURCHASE_END_DATE) -- 赎回截止日期
    ,nvl(trim(P1.INNER_FLAG),'-') -- 系统内标志
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.PAY_TYPE END -- 付息方式代码
    ,P1.PAYER_NAME -- 付息人名称
    ,P1.PAYER_ACCOUNT -- 付息人账号
    ,P1.PAYER_SCALE -- 付息比例
    ,' ' -- 代理名称
    ,P1.MANAGER_NO -- 客户经理编号
    ,P1.DEPARTMENT_NO -- 部门编号
    ,'-' -- 先贴后查标志
    ,nvl(trim(P1.MEND_FLAG),'-') -- 合同资料后补标志
    ,${iml_schema}.DATEFORMAT_MAX2(null) -- 后补截止日期
    ,' ' -- 操作员编号
    ,${iml_schema}.DATEFORMAT_MAX2(P1.TXN_DATE) -- 交易日期
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.CHECK_STATUS END -- 业务逻辑检查状态代码
    ,'-' -- 授信检查状态代码
    ,NVL(TRIM(P1.CONTRACT_STATUS),'-') -- 审核状态代码
    ,'0' -- 计息复核状态代码
    ,NVL(TRIM(ACCOUNT_STATUS),'-') -- 记账状态代码
    ,'-' -- 内部结算标志
    ,P1.INTERNAL_ACCOUNT -- 内部结算账户
    ,${iml_schema}.DATEFORMAT_MAX2(P1.CONTRACT_DATE) -- 协议到期日期
    ,P1.TRANS_AMOUNT -- 信贷有效金额
    ,P1.ALL_CREDIT_EXP -- 已批准使用授信敞口金额
    ,P1.TOTAL_USE_CREDIT_EXP -- 本次放款后累计使用敞口金额
    ,CASE WHEN R10.TARGET_CD_VAL IS NOT NULL THEN R10.TARGET_CD_VAL ELSE '@'||P1.CERT_TYPE END -- 证件类型代码
    ,P1.CERT_ID -- 证件号码
    ,NVL(TRIM(P1.I9_TYPE),'FVOCI') -- 资产三分类代码
    ,nvl(trim(P1.IS_RELATED),'-') -- 关联方查询结果代码
    ,to_number(nvl(trim(P1.SUM_USE_CONTRACT),0)) -- 信贷合同已用金额
    ,P1.SUM_CONTRACT -- 信贷合同总金额
    ,P1.USED_TOTAL_SUM -- 额度合同已用总金额
    ,P1.UNIQUE_SEQ_NUM -- 中台业务流水号
    ,'00' -- 利息计算顺延方式代码
    ,P1.ACCT_STATUS -- 核算中台记账状态代码
    ,P1.SEND_FILE_STATUS -- 核心记账状态代码
    ,' ' -- 历史数据标志
    ,P1.BUSSINESS_TYPE -- 业务类型编号
    ,P1.BUSINESS_BELONG_BRANCHNO -- 业务所属机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_buy_contract' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_buy_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.RPD_MK = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'RPD_MK'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BUY_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DRAFT_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_CONTRACT'
        AND R2.SRC_FIELD_EN_NAME= 'DRAFT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.DRAFT_ATTR = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_CONTRACT'
        AND R3.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BILL_MED_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CLEAR_TYPE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'BDMS'
        AND R4.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_CONTRACT'
        AND R4.SRC_FIELD_EN_NAME= 'CLEAR_TYPE'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.SETTLE_TYPE = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'BDMS'
        AND R7.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_CONTRACT'
        AND R7.SRC_FIELD_EN_NAME= 'SETTLE_TYPE'
        AND R7.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.PAY_TYPE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'BDMS'
        AND R5.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_CONTRACT'
        AND R5.SRC_FIELD_EN_NAME= 'PAY_TYPE'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'PAY_INT_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.CHECK_STATUS = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'BDMS'
        AND R6.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_CONTRACT'
        AND R6.SRC_FIELD_EN_NAME= 'CHECK_STATUS'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'BUS_LOGIC_CHECK_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r10 on P1.CERT_TYPE = R10.SRC_CODE_VAL
        AND R10.SORC_SYS_CD= 'BDMS'
        AND R10.SRC_TAB_EN_NAME= 'BDMS_CPES_BUY_CONTRACT'
        AND R10.SRC_FIELD_EN_NAME= 'CERT_TYPE'
        AND R10.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCNT_BATCH'
        AND R10.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_discnt_batch_bdmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_bill_discnt_batch_bdmsf1_ex(
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,discnt_agt_id -- 贴现协议编号
    ,org_id -- 机构编号
    ,enter_acct_org_id -- 入账机构编号
    ,buy_prod_cd -- 买入产品代码
    ,buy_type_cd -- 买入类型代码
    ,discnt_bus_type_cd -- 贴现业务类型代码
    ,bus_type_cd -- 贴现类型代码
    ,bus_id -- 业务编号
    ,bill_type_cd -- 票据类型代码
    ,bill_med_cd -- 票据介质代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_open_bank_no -- 客户开户行行号
    ,cust_open_acct_num -- 客户开户账号
    ,int_rat -- 利率
    ,int_rat_type_cd -- 利率类型代码
    ,redem_int_rat -- 赎回利率
    ,redem_int_rat_type_cd -- 赎回利率类型代码
    ,link_int_rat -- 联动利率
    ,buy_dt -- 买入日期
    ,onl_clear_flg -- 线上清算标志
    ,clear_type_cd -- 清算类型代码
    ,stl_dt -- 结算日期
    ,stl_way_cd -- 结算方式代码
    ,redem_open_dt -- 赎回开放日期
    ,redem_closing_dt -- 赎回截止日期
    ,sys_in_flg -- 系统内标志
    ,pay_int_way_cd -- 付息方式代码
    ,int_payer_name -- 付息人名称
    ,int_payer_acct_num -- 付息人账号
    ,pay_int_ratio -- 付息比例
    ,agent_name -- 代理名称
    ,cust_mgr_id -- 客户经理编号
    ,dept_id -- 部门编号
    ,discnt_bf_revw_flg -- 先贴后查标志
    ,cont_matrl_backup_flg -- 合同资料后补标志
    ,backup_closing_dt -- 后补截止日期
    ,operr_id -- 操作员编号
    ,tran_dt -- 交易日期
    ,bus_logic_check_status_cd -- 业务逻辑检查状态代码
    ,crdt_check_status_cd -- 授信检查状态代码
    ,check_status_cd -- 审核状态代码
    ,int_accr_check_status_cd -- 计息复核状态代码
    ,entry_status_cd -- 记账状态代码
    ,intnal_stl_flg -- 内部结算标志
    ,intnal_stl_acct -- 内部结算账户
    ,agt_exp_dt -- 协议到期日期
    ,crdt_valid_amt -- 信贷有效金额
    ,apprved_use_crdt_open_amt -- 已批准使用授信敞口金额
    ,distr_post_acm_use_open_amt -- 本次放款后累计使用敞口金额
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,rela_party_que_rest_cd -- 关联方查询结果代码
    ,crdt_cont_used_amt -- 信贷合同已用金额
    ,crdt_cont_tot_amt -- 信贷合同总金额
    ,lmt_cont_used_tot_amt -- 额度合同已用总金额
    ,midgrod_bus_flow_num -- 中台业务流水号
    ,int_calc_defer_way_cd -- 利息计算顺延方式代码
    ,tgls_entry_status_cd -- 核算中台记账状态代码
    ,ncbs_entry_status_cd -- 核心记账状态代码
    ,h_data_flg -- 历史数据标志
    ,bus_type_id -- 业务类型编号
    ,bus_belong_org_id -- 业务所属机构编号
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
    ,nvl(n.discnt_agt_id, o.discnt_agt_id) as discnt_agt_id -- 贴现协议编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.enter_acct_org_id, o.enter_acct_org_id) as enter_acct_org_id -- 入账机构编号
    ,nvl(n.buy_prod_cd, o.buy_prod_cd) as buy_prod_cd -- 买入产品代码
    ,nvl(n.buy_type_cd, o.buy_type_cd) as buy_type_cd -- 买入类型代码
    ,nvl(n.discnt_bus_type_cd, o.discnt_bus_type_cd) as discnt_bus_type_cd -- 贴现业务类型代码
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 贴现类型代码
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.bill_med_cd, o.bill_med_cd) as bill_med_cd -- 票据介质代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_open_bank_no, o.cust_open_bank_no) as cust_open_bank_no -- 客户开户行行号
    ,nvl(n.cust_open_acct_num, o.cust_open_acct_num) as cust_open_acct_num -- 客户开户账号
    ,nvl(n.int_rat, o.int_rat) as int_rat -- 利率
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.redem_int_rat, o.redem_int_rat) as redem_int_rat -- 赎回利率
    ,nvl(n.redem_int_rat_type_cd, o.redem_int_rat_type_cd) as redem_int_rat_type_cd -- 赎回利率类型代码
    ,nvl(n.link_int_rat, o.link_int_rat) as link_int_rat -- 联动利率
    ,nvl(n.buy_dt, o.buy_dt) as buy_dt -- 买入日期
    ,nvl(n.onl_clear_flg, o.onl_clear_flg) as onl_clear_flg -- 线上清算标志
    ,nvl(n.clear_type_cd, o.clear_type_cd) as clear_type_cd -- 清算类型代码
    ,nvl(n.stl_dt, o.stl_dt) as stl_dt -- 结算日期
    ,nvl(n.stl_way_cd, o.stl_way_cd) as stl_way_cd -- 结算方式代码
    ,nvl(n.redem_open_dt, o.redem_open_dt) as redem_open_dt -- 赎回开放日期
    ,nvl(n.redem_closing_dt, o.redem_closing_dt) as redem_closing_dt -- 赎回截止日期
    ,nvl(n.sys_in_flg, o.sys_in_flg) as sys_in_flg -- 系统内标志
    ,nvl(n.pay_int_way_cd, o.pay_int_way_cd) as pay_int_way_cd -- 付息方式代码
    ,nvl(n.int_payer_name, o.int_payer_name) as int_payer_name -- 付息人名称
    ,nvl(n.int_payer_acct_num, o.int_payer_acct_num) as int_payer_acct_num -- 付息人账号
    ,nvl(n.pay_int_ratio, o.pay_int_ratio) as pay_int_ratio -- 付息比例
    ,nvl(n.agent_name, o.agent_name) as agent_name -- 代理名称
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.dept_id, o.dept_id) as dept_id -- 部门编号
    ,nvl(n.discnt_bf_revw_flg, o.discnt_bf_revw_flg) as discnt_bf_revw_flg -- 先贴后查标志
    ,nvl(n.cont_matrl_backup_flg, o.cont_matrl_backup_flg) as cont_matrl_backup_flg -- 合同资料后补标志
    ,nvl(n.backup_closing_dt, o.backup_closing_dt) as backup_closing_dt -- 后补截止日期
    ,nvl(n.operr_id, o.operr_id) as operr_id -- 操作员编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.bus_logic_check_status_cd, o.bus_logic_check_status_cd) as bus_logic_check_status_cd -- 业务逻辑检查状态代码
    ,nvl(n.crdt_check_status_cd, o.crdt_check_status_cd) as crdt_check_status_cd -- 授信检查状态代码
    ,nvl(n.check_status_cd, o.check_status_cd) as check_status_cd -- 审核状态代码
    ,nvl(n.int_accr_check_status_cd, o.int_accr_check_status_cd) as int_accr_check_status_cd -- 计息复核状态代码
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.intnal_stl_flg, o.intnal_stl_flg) as intnal_stl_flg -- 内部结算标志
    ,nvl(n.intnal_stl_acct, o.intnal_stl_acct) as intnal_stl_acct -- 内部结算账户
    ,nvl(n.agt_exp_dt, o.agt_exp_dt) as agt_exp_dt -- 协议到期日期
    ,nvl(n.crdt_valid_amt, o.crdt_valid_amt) as crdt_valid_amt -- 信贷有效金额
    ,nvl(n.apprved_use_crdt_open_amt, o.apprved_use_crdt_open_amt) as apprved_use_crdt_open_amt -- 已批准使用授信敞口金额
    ,nvl(n.distr_post_acm_use_open_amt, o.distr_post_acm_use_open_amt) as distr_post_acm_use_open_amt -- 本次放款后累计使用敞口金额
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.rela_party_que_rest_cd, o.rela_party_que_rest_cd) as rela_party_que_rest_cd -- 关联方查询结果代码
    ,nvl(n.crdt_cont_used_amt, o.crdt_cont_used_amt) as crdt_cont_used_amt -- 信贷合同已用金额
    ,nvl(n.crdt_cont_tot_amt, o.crdt_cont_tot_amt) as crdt_cont_tot_amt -- 信贷合同总金额
    ,nvl(n.lmt_cont_used_tot_amt, o.lmt_cont_used_tot_amt) as lmt_cont_used_tot_amt -- 额度合同已用总金额
    ,nvl(n.midgrod_bus_flow_num, o.midgrod_bus_flow_num) as midgrod_bus_flow_num -- 中台业务流水号
    ,nvl(n.int_calc_defer_way_cd, o.int_calc_defer_way_cd) as int_calc_defer_way_cd -- 利息计算顺延方式代码
    ,nvl(n.tgls_entry_status_cd, o.tgls_entry_status_cd) as tgls_entry_status_cd -- 核算中台记账状态代码
    ,nvl(n.ncbs_entry_status_cd, o.ncbs_entry_status_cd) as ncbs_entry_status_cd -- 核心记账状态代码
    ,nvl(n.h_data_flg, o.h_data_flg) as h_data_flg -- 历史数据标志
    ,nvl(n.bus_type_id, o.bus_type_id) as bus_type_id -- 业务类型编号
    ,nvl(n.bus_belong_org_id, o.bus_belong_org_id) as bus_belong_org_id -- 业务所属机构编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.batch_id is null
                and o.lp_id is null
            ) or (
                o.discnt_agt_id <> n.discnt_agt_id
                or o.org_id <> n.org_id
                or o.enter_acct_org_id <> n.enter_acct_org_id
                or o.buy_prod_cd <> n.buy_prod_cd
                or o.buy_type_cd <> n.buy_type_cd
                or o.discnt_bus_type_cd <> n.discnt_bus_type_cd
                or o.bus_type_cd <> n.bus_type_cd
                or o.bus_id <> n.bus_id
                or o.bill_type_cd <> n.bill_type_cd
                or o.bill_med_cd <> n.bill_med_cd
                or o.cust_id <> n.cust_id
                or o.cust_name <> n.cust_name
                or o.cust_open_bank_no <> n.cust_open_bank_no
                or o.cust_open_acct_num <> n.cust_open_acct_num
                or o.int_rat <> n.int_rat
                or o.int_rat_type_cd <> n.int_rat_type_cd
                or o.redem_int_rat <> n.redem_int_rat
                or o.redem_int_rat_type_cd <> n.redem_int_rat_type_cd
                or o.link_int_rat <> n.link_int_rat
                or o.buy_dt <> n.buy_dt
                or o.onl_clear_flg <> n.onl_clear_flg
                or o.clear_type_cd <> n.clear_type_cd
                or o.stl_dt <> n.stl_dt
                or o.stl_way_cd <> n.stl_way_cd
                or o.redem_open_dt <> n.redem_open_dt
                or o.redem_closing_dt <> n.redem_closing_dt
                or o.sys_in_flg <> n.sys_in_flg
                or o.pay_int_way_cd <> n.pay_int_way_cd
                or o.int_payer_name <> n.int_payer_name
                or o.int_payer_acct_num <> n.int_payer_acct_num
                or o.pay_int_ratio <> n.pay_int_ratio
                or o.agent_name <> n.agent_name
                or o.cust_mgr_id <> n.cust_mgr_id
                or o.dept_id <> n.dept_id
                or o.discnt_bf_revw_flg <> n.discnt_bf_revw_flg
                or o.cont_matrl_backup_flg <> n.cont_matrl_backup_flg
                or o.backup_closing_dt <> n.backup_closing_dt
                or o.operr_id <> n.operr_id
                or o.tran_dt <> n.tran_dt
                or o.bus_logic_check_status_cd <> n.bus_logic_check_status_cd
                or o.crdt_check_status_cd <> n.crdt_check_status_cd
                or o.check_status_cd <> n.check_status_cd
                or o.int_accr_check_status_cd <> n.int_accr_check_status_cd
                or o.entry_status_cd <> n.entry_status_cd
                or o.intnal_stl_flg <> n.intnal_stl_flg
                or o.intnal_stl_acct <> n.intnal_stl_acct
                or o.agt_exp_dt <> n.agt_exp_dt
                or o.crdt_valid_amt <> n.crdt_valid_amt
                or o.apprved_use_crdt_open_amt <> n.apprved_use_crdt_open_amt
                or o.distr_post_acm_use_open_amt <> n.distr_post_acm_use_open_amt
                or o.cert_type_cd <> n.cert_type_cd
                or o.cert_no <> n.cert_no
                or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
                or o.rela_party_que_rest_cd <> n.rela_party_que_rest_cd
                or o.crdt_cont_used_amt <> n.crdt_cont_used_amt
                or o.crdt_cont_tot_amt <> n.crdt_cont_tot_amt
                or o.lmt_cont_used_tot_amt <> n.lmt_cont_used_tot_amt
                or o.midgrod_bus_flow_num <> n.midgrod_bus_flow_num
                or o.int_calc_defer_way_cd <> n.int_calc_defer_way_cd
                or o.tgls_entry_status_cd <> n.tgls_entry_status_cd
                or o.ncbs_entry_status_cd <> n.ncbs_entry_status_cd
                or o.h_data_flg <> n.h_data_flg
                or o.bus_type_id <> n.bus_type_id
                or o.bus_belong_org_id <> n.bus_belong_org_id
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
from ${iml_schema}.agt_bill_discnt_batch_bdmsf1_tm n
    full join ${iml_schema}.agt_bill_discnt_batch_bdmsf1_bk o
        on
            o.batch_id = n.batch_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bill_discnt_batch truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bill_discnt_batch exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_discnt_batch_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bill_discnt_batch drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_discnt_batch to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bill_discnt_batch_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_discnt_batch_bdmsf1_ex purge;
drop table ${iml_schema}.agt_bill_discnt_batch_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_discnt_batch', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);