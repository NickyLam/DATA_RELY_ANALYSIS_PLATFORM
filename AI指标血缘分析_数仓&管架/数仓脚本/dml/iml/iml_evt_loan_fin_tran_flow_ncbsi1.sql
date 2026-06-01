/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_loan_fin_tran_flow_ncbsi1
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
drop table ${iml_schema}.evt_loan_fin_tran_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_loan_fin_tran_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_loan_fin_tran_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_fin_tran_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,tran_flow_num -- 交易流水号
    ,lp_id -- 法人编号
    ,cap_froz_flow_num -- 资金冻结流水号
    ,main_evt_cls_cd -- 主事件分类代码
    ,main_tran_seq_num -- 主交易序号
    ,inter_bus_type_cd -- 中间业务类型代码
    ,exch_rat_type_cd -- 汇率类型代码
    ,wdraw_way_cd -- 支取方式代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,sob_cate_cd -- 账套类别代码
    ,src_module_type_cd -- 源模块类型代码
    ,acct_status_cd -- 账户状态代码
    ,acct_name -- 账户名称
    ,acct_prod_id -- 账户产品编号
    ,acct_id -- 账户编号
    ,acct_curr_cd -- 账户币种代码
    ,prior_level -- 优先等级
    ,camp_prod_name -- 营销产品名称
    ,camp_prod_id -- 营销产品编号
    ,bank_tran_seq_num -- 银行交易序号
    ,bus_tran_batch_no -- 业务交易批次号
    ,bus_proc_status_cd -- 业务处理状态代码
    ,vtual_acct_flg -- 虚户标志
    ,lmt_code -- 限额编码
    ,cash_proj_cd -- 现金项目代码
    ,cash_tran_flg -- 现金交易标志
    ,cross_amt -- 套算金额
    ,auth_teller_id -- 授权柜员编号
    ,evt_cate_id -- 事件类别编号
    ,actl_bal -- 实际余额
    ,actl_cross_exch_rat -- 实际交叉汇率
    ,effect_dt -- 生效日期
    ,ova_flow_num -- 全局流水号
    ,chn_sub_flow_num -- 渠道子流水号
    ,chn_id -- 渠道编号
    ,clear_dt -- 清算日期
    ,begin_curr_cd -- 起始币种代码
    ,vouch_no -- 凭证号码
    ,seller_quot_type_cd -- 卖方牌价类型代码
    ,seller_exch_rat_val -- 卖方汇率值
    ,seller_exch_rat_cls_cd -- 卖方汇率分类代码
    ,sell_amt -- 卖出金额
    ,sell_curr_cd -- 卖出币种代码
    ,buy_amt -- 买入金额
    ,buyer_quot_type_cd -- 买方牌价类型代码
    ,buyer_exch_rat_val -- 买方汇率值
    ,buyer_exch_rat_cls_cd -- 买方汇率分类代码
    ,cust_name -- 客户名称
    ,cust_econ_type_cd -- 客户经济类型代码
    ,cust_id -- 客户编号
    ,open_acct_org_id -- 开户机构编号
    ,amt_type_cd -- 金额类型代码
    ,amt_calc_type_cd -- 金额计算类型代码
    ,debit_crdt_flg -- 借贷标志
    ,tran_kind_cd -- 交易种类代码
    ,tran_termn_id -- 交易终端编号
    ,tran_memo_descb -- 交易摘要描述
    ,tran_comnt -- 交易说明
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,bef_tran_bal -- 交易前余额
    ,tran_cd -- 交易码
    ,tran_amt -- 交易金额
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_postsc -- 交易附言
    ,tran_ref_no -- 交易参考号
    ,payment_corp_name -- 交款单位名称
    ,cross_exch_rat -- 交叉汇率
    ,base_equvl_amt -- 基础等值金额
    ,exch_rat_cls_cd -- 汇率分类代码
    ,callbk_id -- 回收编号
    ,accti_status_cd -- 核算状态代码
    ,post_flg -- 过账标志
    ,follow_id -- 跟踪编号
    ,check_teller_id -- 复核柜员编号
    ,serv_fee_flg -- 服务费标志
    ,distr_flow_num -- 放款流水号
    ,cntpty_acct_sub_acct_num -- 对手账户子账号
    ,cntpty_acct_name -- 对手账户名称
    ,cntpty_acct_prod_id -- 对手账户产品编号
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_bank_name -- 对手银行名称
    ,cntpty_bank_no -- 对手银行行号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_open_acct_org_id -- 对手开户机构编号
    ,cntpty_tran_flow_num -- 对手交易流水号
    ,cntpty_equvl_amt -- 对手等值金额
    ,cntpty_curr_cd -- 对手币种代码
    ,cntpty_tran_ref_no -- 对方交易参考号
    ,avl_way_cd -- 到账方式代码
    ,loan_num -- 贷款号
    ,public_agent_name -- 代办人名称
    ,public_agent_tel_num -- 代办人电话号码
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,revs_dt -- 冲正日期
    ,revs_flow_num -- 冲正流水号
    ,revs_tran_cd -- 冲正交易码
    ,revs_flg -- 冲正标志
    ,bal_type_cd -- 钞汇余额代码
    ,attach_rgst_dep_flg -- 补登存标志
    ,curr_cd -- 币种代码
    ,check_entry_code -- 对账编码
    ,bus_flow_num -- 业务流水号
    ,fxq_tran_dt -- 反洗钱交易日期
    ,cust_type_cd -- 客户类型代码
    ,core_flow_num -- 核心流水号
    ,belong_module -- 所属模块
    ,src_sys_cd -- 来源系统代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_loan_fin_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_cl_tran_hist-1
insert into ${iml_schema}.evt_loan_fin_tran_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,tran_flow_num -- 交易流水号
    ,lp_id -- 法人编号
    ,cap_froz_flow_num -- 资金冻结流水号
    ,main_evt_cls_cd -- 主事件分类代码
    ,main_tran_seq_num -- 主交易序号
    ,inter_bus_type_cd -- 中间业务类型代码
    ,exch_rat_type_cd -- 汇率类型代码
    ,wdraw_way_cd -- 支取方式代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,sob_cate_cd -- 账套类别代码
    ,src_module_type_cd -- 源模块类型代码
    ,acct_status_cd -- 账户状态代码
    ,acct_name -- 账户名称
    ,acct_prod_id -- 账户产品编号
    ,acct_id -- 账户编号
    ,acct_curr_cd -- 账户币种代码
    ,prior_level -- 优先等级
    ,camp_prod_name -- 营销产品名称
    ,camp_prod_id -- 营销产品编号
    ,bank_tran_seq_num -- 银行交易序号
    ,bus_tran_batch_no -- 业务交易批次号
    ,bus_proc_status_cd -- 业务处理状态代码
    ,vtual_acct_flg -- 虚户标志
    ,lmt_code -- 限额编码
    ,cash_proj_cd -- 现金项目代码
    ,cash_tran_flg -- 现金交易标志
    ,cross_amt -- 套算金额
    ,auth_teller_id -- 授权柜员编号
    ,evt_cate_id -- 事件类别编号
    ,actl_bal -- 实际余额
    ,actl_cross_exch_rat -- 实际交叉汇率
    ,effect_dt -- 生效日期
    ,ova_flow_num -- 全局流水号
    ,chn_sub_flow_num -- 渠道子流水号
    ,chn_id -- 渠道编号
    ,clear_dt -- 清算日期
    ,begin_curr_cd -- 起始币种代码
    ,vouch_no -- 凭证号码
    ,seller_quot_type_cd -- 卖方牌价类型代码
    ,seller_exch_rat_val -- 卖方汇率值
    ,seller_exch_rat_cls_cd -- 卖方汇率分类代码
    ,sell_amt -- 卖出金额
    ,sell_curr_cd -- 卖出币种代码
    ,buy_amt -- 买入金额
    ,buyer_quot_type_cd -- 买方牌价类型代码
    ,buyer_exch_rat_val -- 买方汇率值
    ,buyer_exch_rat_cls_cd -- 买方汇率分类代码
    ,cust_name -- 客户名称
    ,cust_econ_type_cd -- 客户经济类型代码
    ,cust_id -- 客户编号
    ,open_acct_org_id -- 开户机构编号
    ,amt_type_cd -- 金额类型代码
    ,amt_calc_type_cd -- 金额计算类型代码
    ,debit_crdt_flg -- 借贷标志
    ,tran_kind_cd -- 交易种类代码
    ,tran_termn_id -- 交易终端编号
    ,tran_memo_descb -- 交易摘要描述
    ,tran_comnt -- 交易说明
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,bef_tran_bal -- 交易前余额
    ,tran_cd -- 交易码
    ,tran_amt -- 交易金额
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_postsc -- 交易附言
    ,tran_ref_no -- 交易参考号
    ,payment_corp_name -- 交款单位名称
    ,cross_exch_rat -- 交叉汇率
    ,base_equvl_amt -- 基础等值金额
    ,exch_rat_cls_cd -- 汇率分类代码
    ,callbk_id -- 回收编号
    ,accti_status_cd -- 核算状态代码
    ,post_flg -- 过账标志
    ,follow_id -- 跟踪编号
    ,check_teller_id -- 复核柜员编号
    ,serv_fee_flg -- 服务费标志
    ,distr_flow_num -- 放款流水号
    ,cntpty_acct_sub_acct_num -- 对手账户子账号
    ,cntpty_acct_name -- 对手账户名称
    ,cntpty_acct_prod_id -- 对手账户产品编号
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_bank_name -- 对手银行名称
    ,cntpty_bank_no -- 对手银行行号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_open_acct_org_id -- 对手开户机构编号
    ,cntpty_tran_flow_num -- 对手交易流水号
    ,cntpty_equvl_amt -- 对手等值金额
    ,cntpty_curr_cd -- 对手币种代码
    ,cntpty_tran_ref_no -- 对方交易参考号
    ,avl_way_cd -- 到账方式代码
    ,loan_num -- 贷款号
    ,public_agent_name -- 代办人名称
    ,public_agent_tel_num -- 代办人电话号码
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,revs_dt -- 冲正日期
    ,revs_flow_num -- 冲正流水号
    ,revs_tran_cd -- 冲正交易码
    ,revs_flg -- 冲正标志
    ,bal_type_cd -- 钞汇余额代码
    ,attach_rgst_dep_flg -- 补登存标志
    ,curr_cd -- 币种代码
    ,check_entry_code -- 对账编码
    ,bus_flow_num -- 业务流水号
    ,fxq_tran_dt -- 反洗钱交易日期
    ,cust_type_cd -- 客户类型代码
    ,core_flow_num -- 核心流水号
    ,belong_module -- 所属模块
    ,src_sys_cd -- 来源系统代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101031'||P1.SEQ_NO -- 事件编号
    ,P1.SEQ_NO -- 交易流水号
    ,'9999' -- 法人编号
    ,P1.FH_SEQ_NO -- 资金冻结流水号
    ,P1.PRIMARY_EVENT_TYPE -- 主事件分类代码
    ,P1.PRIMARY_TRAN_SEQ_NO -- 主交易序号
    ,P1.BIZ_TYPE -- 中间业务类型代码
    ,nvl(trim(P1.RATE_TYPE),'-') -- 汇率类型代码
    ,nvl(trim(P1.WITHDRAWAL_TYPE),'-') -- 支取方式代码
    ,nvl(trim(P1.DOCUMENT_TYPE),'0000') -- 证件类型代码
    ,P1.DOCUMENT_ID -- 证件号码
    ,nvl(trim(P1.BUSINESS_UNIT),'-') -- 账套类别代码
    ,P1.SOURCE_MODULE -- 源模块类型代码
    ,P1.ACCT_STATUS -- 账户状态代码
    ,P1.ACCT_DESC -- 账户名称
    ,P1.PROD_TYPE -- 账户产品编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 账户币种代码
    ,P1.PRIORITY -- 优先等级
    ,P1.MARKETING_PROD_DESC -- 营销产品名称
    ,P1.MARKETING_PROD -- 营销产品编号
    ,P1.BANK_SEQ_NO -- 银行交易序号
    ,P1.BATCH_NO -- 业务交易批次号
    ,P1.TRAN_STATUS -- 业务处理状态代码
    ,DECODE(TRIM(P1.ACCT_REAL_FLAG),'','-','Y','1','N','0',P1.ACCT_REAL_FLAG) -- 虚户标志
    ,P1.LIMIT_REF -- 限额编码
    ,nvl(trim(P1.CASH_ITEM),'-') -- 现金项目代码
    ,DECODE(TRIM(P1.ACCT_TRAN_FLAG),'','-','Y','1','N','0',P1.ACCT_TRAN_FLAG) -- 现金交易标志
    ,P1.OV_TO_AMOUNT -- 套算金额
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.EVENT_TYPE -- 事件类别编号
    ,P1.ACTUAL_BAL -- 实际余额
    ,P1.OV_CROSS_RATE -- 实际交叉汇率
    ,P1.EFFECT_DATE -- 生效日期
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.CHANNEL_SUB_SEQ_NO -- 渠道子流水号
    ,P1.SOURCE_TYPE -- 渠道编号
    ,P1.SETTLEMENT_DATE -- 清算日期
    ,nvl(trim(P1.FROM_CCY),'-') -- 起始币种代码
    ,P1.VOUCHER_NO -- 凭证号码
    ,nvl(trim(P1.TO_ID),'-') -- 卖方牌价类型代码
    ,P1.TO_XRATE -- 卖方汇率值
    ,nvl(trim(P1.TO_RATE_FLAG),'-') -- 卖方汇率分类代码
    ,P1.TO_AMOUNT -- 卖出金额
    ,nvl(trim(P1.TO_CCY),'-') -- 卖出币种代码
    ,P1.FROM_AMOUNT -- 买入金额
    ,nvl(trim(P1.QUOTE_TYPE),'-') -- 买方牌价类型代码
    ,P1.FROM_XRATE -- 买方汇率值
    ,nvl(trim(P1.FROM_RATE_FLAG),'-') -- 买方汇率分类代码
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.CLIENT_ECON_TYPE -- 客户经济类型代码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,P1.AMT_TYPE -- 金额类型代码
    ,nvl(trim(P1.AMT_CALC_TYPE),'-') -- 金额计算类型代码
    ,P1.CR_DR_MAINT_IND -- 借贷标志
    ,nvl(trim(P1.TRAN_CATEGORY),'XXX') -- 交易种类代码
    ,P1.TERMINAL_ID -- 交易终端编号
    ,P1.NARRATIVE -- 交易摘要描述
    ,P1.TRAN_DESC -- 交易说明
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.TRAN_DATE -- 交易日期
    ,P1.PREVIOUS_BAL_AMT -- 交易前余额
    ,P1.TRAN_TYPE -- 交易码
    ,P1.TRAN_AMT -- 交易金额
    ,P1.BRANCH -- 交易机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.TRAN_NOTE -- 交易附言
    ,P1.REFERENCE -- 交易参考号
    ,P1.PAY_UNIT -- 交款单位名称
    ,P1.CROSS_RATE -- 交叉汇率
    ,P1.BASE_EQUIV_AMT -- 基础等值金额
    ,nvl(trim(P1.RATE_FLAG),'-') -- 汇率分类代码
    ,P1.RECEIPT_NO -- 回收编号
    ,nvl(trim(P1.ACCOUNTING_STATUS),'-') -- 核算状态代码
    ,DECODE(TRIM(P1.GL_POSTED_FLAG),'','-','Y','1','N','0',P1.GL_POSTED_FLAG) -- 过账标志
    ,P1.TRACE_ID -- 跟踪编号
    ,P1.APPR_USER_ID -- 复核柜员编号
    ,DECODE(P1.SERV_CHARGE,'Y','1','N','0') -- 服务费标志
    ,P1.DD_NO -- 放款流水号
    ,P1.OTH_ACCT_SEQ_NO -- 对手账户子账号
    ,P1.OTH_ACCT_DESC -- 对手账户名称
    ,P1.OTH_PROD_TYPE -- 对手账户产品编号
    ,P1.OTH_INTERNAL_KEY -- 对手账户编号
    ,nvl(trim(P1.OTH_ACCT_CCY),'-') -- 对手账户币种代码
    ,P1.OTH_BANK_NAME -- 对手银行名称
    ,P1.OTH_BANK_CODE -- 对手银行行号
    ,P1.OTH_BASE_ACCT_NO -- 对手客户账号
    ,P1.OTH_BRANCH -- 对手开户机构编号
    ,P1.OTH_SEQ_NO -- 对手交易流水号
    ,P1.CONTRA_EQUIV_AMT -- 对手等值金额
    ,nvl(trim(P1.CONTRA_ACCT_CCY),'-') -- 对手币种代码
    ,P1.OTH_REFERENCE -- 对方交易参考号
    ,nvl(trim(P1.TRAN_METHOD),'-') -- 到账方式代码
    ,P1.LOAN_NO -- 贷款号
    ,P1.COMMISSION_CLIENT_NAME -- 代办人名称
    ,P1.COMMISSION_PHONE -- 代办人电话号码
    ,nvl(trim(P1.DOC_TYPE),'-') -- 存款凭证类别代码
    ,P1.REVERSAL_DATE -- 冲正日期
    ,P1.REVERSAL_SEQ_NO -- 冲正流水号
    ,P1.REVERSAL_TRAN_TYPE -- 冲正交易码
    ,DECODE(P1.REVERSAL,'Y','1','N','0') -- 冲正标志
    ,nvl(trim(P1.BAL_TYPE),'-') -- 钞汇余额代码
    ,DECODE(TRIM(P1.PBK_UPD_FLAG),'','-','Y','1','N','0',P1.PBK_UPD_FLAG) -- 补登存标志
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,P1.REACCOUNT_CD -- 对账编码
    ,P1.BUS_SEQ_NO -- 业务流水号
    ,${iml_schema}.timeformat_max(P1.EXTRA_TRAN_TIMESTAMP) -- 反洗钱交易日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.SUB_SEQ_NO -- 核心流水号
    ,P1.MAIN_SOURCE_MODULE -- 所属模块
    ,nvl(trim(P1.SYSTEM_CODE),'-') -- 来源系统代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_tran_hist' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_tran_hist p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND  R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_CL_TRAN_HIST'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_LOAN_FIN_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where  1 = 1 
     and to_char(P1.tran_date,'yyyymmdd') = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_loan_fin_tran_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_loan_fin_tran_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_loan_fin_tran_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_loan_fin_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_loan_fin_tran_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_loan_fin_tran_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);