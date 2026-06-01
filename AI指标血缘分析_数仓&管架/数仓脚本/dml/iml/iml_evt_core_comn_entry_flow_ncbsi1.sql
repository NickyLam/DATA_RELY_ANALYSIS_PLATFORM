/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_core_comn_entry_flow_ncbsi1
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
drop table ${iml_schema}.evt_core_comn_entry_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_core_comn_entry_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_core_comn_entry_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_core_comn_entry_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,tran_flow_num -- 交易流水号
    ,lp_id -- 法人编号
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,revs_tran_type_code -- 冲正交易类型码
    ,revs_tran_dt -- 冲正交易日期
    ,check_entry_cd -- 对账码
    ,fee_prod_id -- 费用产品编号
    ,float_ratio -- 浮动比例
    ,follow_id -- 跟踪编号
    ,post_flg -- 过账标志
    ,accti_status_cd -- 核算状态代码
    ,core_flow_num -- 核心流水号
    ,core_tran_teller_id -- 核心交易柜员编号
    ,core_tran_org_id -- 核心交易机构编号
    ,org_id -- 机构编号
    ,tran_id -- 交易编号
    ,tran_ref_no -- 交易参考号
    ,cntpty_curr_cd -- 交易对手币种代码
    ,cntpty_prod_id -- 交易对手产品编号
    ,cntpty_org_dist_cd -- 交易对手机构行政区划代码
    ,cntpty_tran_ref_no -- 交易对手交易参考号
    ,cntpty_tran_flow_num -- 交易对手交易流水号
    ,cntpty_type_cd -- 交易对手客户类型代码
    ,cntpty_cust_acct_num -- 交易对手客户账号
    ,cntpty_name -- 交易对手名称
    ,cntpty_bank_name -- 交易对手银行名称
    ,cntpty_unionpay_num -- 交易对手银联号
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_open_acct_org_id -- 交易对手账户开户机构编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_sub_acct_num -- 交易对手账户子账号
    ,cntpty_cert_no -- 交易对手证件号码
    ,cntpty_cert_type_cd -- 交易对手证件类型代码
    ,tran_happ_site -- 交易发生地点
    ,tran_postsc -- 交易附言
    ,tran_amt -- 交易金额
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,tran_batch_no -- 交易批次号
    ,tran_tm -- 交易时间
    ,tran_revd_flg -- 交易已冲正标志
    ,tran_memo_descb -- 交易摘要描述
    ,tran_termn_id -- 交易终端编号
    ,med_type_cd -- 介质类型代码
    ,debit_crdt_flg -- 借贷标志
    ,amt_type_cd -- 金额类型代码
    ,subj_id -- 科目编号
    ,subj_entry_cust_name -- 科目记账客户名称
    ,subj_entry_cust_acct_num -- 科目记账客户账号
    ,subj_entry_sub_acct_num -- 科目记账子账号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,src_sys_id -- 来源系统编号
    ,fe_flow_num -- 前端流水号
    ,clear_dt -- 清算日期
    ,chn_tran_dt -- 渠道交易日期
    ,ova_flow_num -- 全局流水号
    ,effect_dt -- 生效日期
    ,auth_teller_id -- 授权柜员编号
    ,sys_id -- 系统编号
    ,cash_proj_cd -- 现金项目代码
    ,crdt_card_num -- 信用卡号
    ,bus_proc_status_cd -- 业务处理状态代码
    ,bus_tran_flow_num -- 业务交易流水号
    ,bus_tran_dt -- 业务交易日期
    ,bus_flow_num -- 业务流水号
    ,bank_tran_seq_num -- 银行交易序号
    ,have_med_flg -- 有介质标志
    ,src_module_type_cd -- 源模块类型代码
    ,sob_cate_cd -- 账套类别代码
    ,real_cntpty_prod_id -- 真实交易对手产品编号
    ,real_cntpty_org_id -- 真实交易对手机构编号
    ,real_cntpty_org_dist_cd -- 真实交易对手机构行政区划代码
    ,real_cntpty_org_name -- 真实交易对手机构名称
    ,real_cntpty_cust_acct_num -- 真实交易对手客户账号
    ,real_cntpty_name -- 真实交易对手名称
    ,real_cntpty_cert_no -- 真实交易对手证件号码
    ,real_cntpty_cert_type_cd -- 真实交易对手证件类型代码
    ,real_tran_happ_site -- 真实交易发生地点
    ,main_tran_seq_num -- 主交易序号
    ,main_evt_cls_cd -- 主事件分类代码
    ,auto_revs_flg -- 自动冲正标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_core_comn_entry_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_common_account_hist-1
insert into ${iml_schema}.evt_core_comn_entry_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,tran_flow_num -- 交易流水号
    ,lp_id -- 法人编号
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,revs_tran_type_code -- 冲正交易类型码
    ,revs_tran_dt -- 冲正交易日期
    ,check_entry_cd -- 对账码
    ,fee_prod_id -- 费用产品编号
    ,float_ratio -- 浮动比例
    ,follow_id -- 跟踪编号
    ,post_flg -- 过账标志
    ,accti_status_cd -- 核算状态代码
    ,core_flow_num -- 核心流水号
    ,core_tran_teller_id -- 核心交易柜员编号
    ,core_tran_org_id -- 核心交易机构编号
    ,org_id -- 机构编号
    ,tran_id -- 交易编号
    ,tran_ref_no -- 交易参考号
    ,cntpty_curr_cd -- 交易对手币种代码
    ,cntpty_prod_id -- 交易对手产品编号
    ,cntpty_org_dist_cd -- 交易对手机构行政区划代码
    ,cntpty_tran_ref_no -- 交易对手交易参考号
    ,cntpty_tran_flow_num -- 交易对手交易流水号
    ,cntpty_type_cd -- 交易对手客户类型代码
    ,cntpty_cust_acct_num -- 交易对手客户账号
    ,cntpty_name -- 交易对手名称
    ,cntpty_bank_name -- 交易对手银行名称
    ,cntpty_unionpay_num -- 交易对手银联号
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_open_acct_org_id -- 交易对手账户开户机构编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_sub_acct_num -- 交易对手账户子账号
    ,cntpty_cert_no -- 交易对手证件号码
    ,cntpty_cert_type_cd -- 交易对手证件类型代码
    ,tran_happ_site -- 交易发生地点
    ,tran_postsc -- 交易附言
    ,tran_amt -- 交易金额
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,tran_batch_no -- 交易批次号
    ,tran_tm -- 交易时间
    ,tran_revd_flg -- 交易已冲正标志
    ,tran_memo_descb -- 交易摘要描述
    ,tran_termn_id -- 交易终端编号
    ,med_type_cd -- 介质类型代码
    ,debit_crdt_flg -- 借贷标志
    ,amt_type_cd -- 金额类型代码
    ,subj_id -- 科目编号
    ,subj_entry_cust_name -- 科目记账客户名称
    ,subj_entry_cust_acct_num -- 科目记账客户账号
    ,subj_entry_sub_acct_num -- 科目记账子账号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,src_sys_id -- 来源系统编号
    ,fe_flow_num -- 前端流水号
    ,clear_dt -- 清算日期
    ,chn_tran_dt -- 渠道交易日期
    ,ova_flow_num -- 全局流水号
    ,effect_dt -- 生效日期
    ,auth_teller_id -- 授权柜员编号
    ,sys_id -- 系统编号
    ,cash_proj_cd -- 现金项目代码
    ,crdt_card_num -- 信用卡号
    ,bus_proc_status_cd -- 业务处理状态代码
    ,bus_tran_flow_num -- 业务交易流水号
    ,bus_tran_dt -- 业务交易日期
    ,bus_flow_num -- 业务流水号
    ,bank_tran_seq_num -- 银行交易序号
    ,have_med_flg -- 有介质标志
    ,src_module_type_cd -- 源模块类型代码
    ,sob_cate_cd -- 账套类别代码
    ,real_cntpty_prod_id -- 真实交易对手产品编号
    ,real_cntpty_org_id -- 真实交易对手机构编号
    ,real_cntpty_org_dist_cd -- 真实交易对手机构行政区划代码
    ,real_cntpty_org_name -- 真实交易对手机构名称
    ,real_cntpty_cust_acct_num -- 真实交易对手客户账号
    ,real_cntpty_name -- 真实交易对手名称
    ,real_cntpty_cert_no -- 真实交易对手证件号码
    ,real_cntpty_cert_type_cd -- 真实交易对手证件类型代码
    ,real_tran_happ_site -- 真实交易发生地点
    ,main_tran_seq_num -- 主交易序号
    ,main_evt_cls_cd -- 主事件分类代码
    ,auto_revs_flg -- 自动冲正标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '302003'||P1.SEQ_NO -- 事件编号
    ,P1.SEQ_NO -- 交易流水号
    ,'9999' -- 法人编号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_CCY -- 币种代码
    ,P1.REVERSAL_TRAN_TYPE -- 冲正交易类型码
    ,P1.REVERSAL_TRAN_DATE -- 冲正交易日期
    ,P1.REACCOUNT_CD -- 对账码
    ,P1.FEE_TYPE -- 费用产品编号
    ,P1.SPREAD_PERCENT -- 浮动比例
    ,P1.TRACE_ID -- 跟踪编号
    ,P1.GL_POSTED_FLAG -- 过账标志
    ,P1.ACCOUNTING_STATUS -- 核算状态代码
    ,P1.SUB_SEQ_NO -- 核心流水号
    ,P1.USER_ID -- 核心交易柜员编号
    ,P1.TRAN_BRANCH -- 核心交易机构编号
    ,P1.BRANCH -- 机构编号
    ,P1.PROGRAM_ID -- 交易编号
    ,P1.REFERENCE -- 交易参考号
    ,P1.OTH_ACCT_CCY -- 交易对手币种代码
    ,P1.OTH_PROD_TYPE -- 交易对手产品编号
    ,P1.OTH_BRANCH_REGIONALISM_CODE -- 交易对手机构行政区划代码
    ,P1.OTH_REFERENCE -- 交易对手交易参考号
    ,P1.OTH_SEQ_NO -- 交易对手交易流水号
    ,nvl(trim(P1.OTH_CLIENT_TYPE),'-') -- 交易对手客户类型代码
    ,P1.OTH_BASE_ACCT_NO -- 交易对手客户账号
    ,P1.OTH_TRAN_NAME -- 交易对手名称
    ,P1.OTH_BANK_NAME -- 交易对手银行名称
    ,P1.OTH_BANK_CODE -- 交易对手银联号
    ,P1.OTH_INTERNAL_KEY -- 交易对手账户编号
    ,P1.OTH_BRANCH -- 交易对手账户开户机构编号
    ,P1.OTH_ACCT_DESC -- 交易对手账户名称
    ,P1.OTH_ACCT_SEQ_NO -- 交易对手账户子账号
    ,P1.OTH_DOCUMENT_ID -- 交易对手证件号码
    ,P1.OTH_DOCUMENT_TYPE -- 交易对手证件类型代码
    ,P1.OTH_TRAN_ADDR -- 交易发生地点
    ,P1.TRAN_NOTE -- 交易附言
    ,P1.TRAN_AMT -- 交易金额
    ,P1.TRAN_TYPE -- 交易码
    ,P1.TRAN_DESC -- 交易描述
    ,P1.BATCH_NO -- 交易批次号
    ,P1.TRAN_TIMESTAMP -- 交易时间
    ,P1.REVERSAL_FLAG -- 交易已冲正标志
    ,P1.NARRATIVE -- 交易摘要描述
    ,P1.TERMINAL_ID -- 交易终端编号
    ,P1.MEDIUM_TYPE -- 介质类型代码
    ,P1.CR_DR_IND -- 借贷标志
    ,P1.AMT_TYPE -- 金额类型代码
    ,P1.GL_CODE -- 科目编号
    ,P1.SETTLE_CLIENT_ACCT_NAME -- 科目记账客户名称
    ,P1.SETTLE_CLIENT_ACCT_NO -- 科目记账客户账号
    ,P1.SETTLE_CLIENT_ACCT_SEQ_NO -- 科目记账子账号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.SYSTEM_CODE -- 来源系统编号
    ,P1.BR_SEQ_NO -- 前端流水号
    ,P1.SETTLEMENT_DATE -- 清算日期
    ,P1.CHANNEL_DATE -- 渠道交易日期
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.EFFECT_DATE -- 生效日期
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.SYSTEM_ID -- 系统编号
    ,P1.CASH_ITEM -- 现金项目代码
    ,P1.CREDIT_CARD_NO -- 信用卡号
    ,P1.TRAN_STATUS -- 业务处理状态代码
    ,P1.TRAN_HIST_SEQ_NO -- 业务交易流水号
    ,P1.TRAN_DATE -- 业务交易日期
    ,P1.BUS_SEQ_NO -- 业务流水号
    ,P1.BANK_SEQ_NO -- 银行交易序号
    ,P1.MEDIUM_FLAG -- 有介质标志
    ,P1.SOURCE_MODULE -- 源模块类型代码
    ,P1.BUSINESS_UNIT -- 账套类别代码
    ,P1.OTH_REAL_PROD_TYPE -- 真实交易对手产品编号
    ,P1.OTH_REAL_BANK_CODE -- 真实交易对手机构编号
    ,P1.OTH_REAL_BRANCH_REGION_CODE -- 真实交易对手机构行政区划代码
    ,P1.OTH_REAL_BANK_NAME -- 真实交易对手机构名称
    ,P1.OTH_REAL_BASE_ACCT_NO -- 真实交易对手客户账号
    ,P1.OTH_REAL_TRAN_NAME -- 真实交易对手名称
    ,P1.OTH_REAL_DOCUMENT_ID -- 真实交易对手证件号码
    ,P1.OTH_REAL_DOCUMENT_TYPE -- 真实交易对手证件类型代码
    ,P1.OTH_REAL_TRAN_ADDR -- 真实交易发生地点
    ,P1.PRIMARY_TRAN_SEQ_NO -- 主交易序号
    ,P1.PRIMARY_EVENT_TYPE -- 主事件分类代码
    ,P1.AUTO_REVERSAL_FLAG -- 自动冲正标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_common_account_hist' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_common_account_hist p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_core_comn_entry_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_core_comn_entry_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_core_comn_entry_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_core_comn_entry_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_core_comn_entry_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_core_comn_entry_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);