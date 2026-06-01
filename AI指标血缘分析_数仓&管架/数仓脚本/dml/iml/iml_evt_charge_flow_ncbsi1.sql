/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_charge_flow_ncbsi1
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
drop table ${iml_schema}.evt_charge_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_charge_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_charge_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_charge_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,charge_seq_num -- 收费序号
    ,tran_dt -- 交易日期
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,flow_num -- 流水号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,acct_flg_idf -- 账户标识符
    ,open_acct_org_id -- 开户机构编号
    ,dep_agt_id -- 存款协议编号
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_begin_num -- 凭证起始号码
    ,vouch_sum_qtty -- 凭证合计数量
    ,effect_dt -- 生效日期
    ,revs_org_id -- 冲正机构编号
    ,tran_org_id -- 交易机构编号
    ,ova_flow_num -- 全局流水号
    ,tran_ref_no -- 交易参考号
    ,tran_cd -- 交易码
    ,tran_seq_num -- 交易序号
    ,tran_tm -- 交易时间
    ,cntpty_cust_acct_num -- 交易对手业务编号
    ,cntpty_name -- 交易对手名称
    ,cntpty_cust_id -- 交易对手客户编号
    ,cntpty_cust_name -- 交易对手客户名称
    ,cntpty_type_cd -- 交易对手客户类型代码
    ,tran_teller_id -- 交易柜员编号
    ,recvbl_fee_seq_num -- 应收费用序号
    ,fee_charge_way_cd -- 费用收费方式代码
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,fee_type_id -- 费用类型编号
    ,acct_dmic_charge_curr_cd -- 费用币种代码
    ,fee_price -- 费用单价
    ,acct_dmic_fee_amt -- 费用金额
    ,init_recvbl_fee_amt -- 原应收费用金额
    ,fee_discnt_rat -- 费用折扣率
    ,fee_discnt_type_cd -- 费用折扣类型代码
    ,init_fee_amt -- 原始费用金额
    ,discnt_fee_amt -- 折扣费用金额
    ,tax -- 税金
    ,tax_rat -- 税率
    ,tax_category_cd -- 税种代码
    ,amort_flg -- 摊销标志
    ,amort_tm_type_cd -- 摊销时间类型代码
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_day -- 摊销日
    ,amort_mon -- 摊销月
    ,amort_begin_dt -- 摊销起始日期
    ,amort_closing_dt -- 摊销截止日期
    ,prft_cut_flg -- 分润标志
    ,tran_bank_ratio -- 交易行比例
    ,tran_bank_prft_cut_amt -- 交易行分润金额
    ,acct_bank_ratio -- 账户行比例
    ,acct_bank_prft_cut_amt -- 账户行分润金额
    ,post_flg -- 过账标志
    ,check_entry_cd -- 对账码
    ,tran_revd_flg -- 交易已冲正标志
    ,tran_acct_serv_fee_revs_seq_num -- 转账服务费冲正序号
    ,revs_auth_teller -- 冲正授权柜员编号
    ,revs_teller -- 冲正柜员编号
    ,org_tran_seq_num -- 机构交易序号
    ,end_day_onl_cd -- 日终联机代码
    ,termnt_num -- 终止号码
    ,core_flow_num -- 核心流水号
    ,bus_flow_num -- 业务流水号
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理名称
    ,cust_type_cd -- 客户类型代码
    ,remark -- 备注
    ,amort_status_cd -- 摊销状态代码
    ,loan_prod_id -- 贷款产品编号
    ,bal_pay_idf_cd -- 收支标识代码
    ,chn_id -- 渠道编号
    ,enter_acct_dt -- 入账日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_charge_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_serv_charge_hist-1
insert into ${iml_schema}.evt_charge_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,charge_seq_num -- 收费序号
    ,tran_dt -- 交易日期
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,flow_num -- 流水号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,acct_flg_idf -- 账户标识符
    ,open_acct_org_id -- 开户机构编号
    ,dep_agt_id -- 存款协议编号
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_begin_num -- 凭证起始号码
    ,vouch_sum_qtty -- 凭证合计数量
    ,effect_dt -- 生效日期
    ,revs_org_id -- 冲正机构编号
    ,tran_org_id -- 交易机构编号
    ,ova_flow_num -- 全局流水号
    ,tran_ref_no -- 交易参考号
    ,tran_cd -- 交易码
    ,tran_seq_num -- 交易序号
    ,tran_tm -- 交易时间
    ,cntpty_cust_acct_num -- 交易对手业务编号
    ,cntpty_name -- 交易对手名称
    ,cntpty_cust_id -- 交易对手客户编号
    ,cntpty_cust_name -- 交易对手客户名称
    ,cntpty_type_cd -- 交易对手客户类型代码
    ,tran_teller_id -- 交易柜员编号
    ,recvbl_fee_seq_num -- 应收费用序号
    ,fee_charge_way_cd -- 费用收费方式代码
    ,comm_fee_coll_way_cd -- 手续费收取方式代码
    ,fee_type_id -- 费用类型编号
    ,acct_dmic_charge_curr_cd -- 费用币种代码
    ,fee_price -- 费用单价
    ,acct_dmic_fee_amt -- 费用金额
    ,init_recvbl_fee_amt -- 原应收费用金额
    ,fee_discnt_rat -- 费用折扣率
    ,fee_discnt_type_cd -- 费用折扣类型代码
    ,init_fee_amt -- 原始费用金额
    ,discnt_fee_amt -- 折扣费用金额
    ,tax -- 税金
    ,tax_rat -- 税率
    ,tax_category_cd -- 税种代码
    ,amort_flg -- 摊销标志
    ,amort_tm_type_cd -- 摊销时间类型代码
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_day -- 摊销日
    ,amort_mon -- 摊销月
    ,amort_begin_dt -- 摊销起始日期
    ,amort_closing_dt -- 摊销截止日期
    ,prft_cut_flg -- 分润标志
    ,tran_bank_ratio -- 交易行比例
    ,tran_bank_prft_cut_amt -- 交易行分润金额
    ,acct_bank_ratio -- 账户行比例
    ,acct_bank_prft_cut_amt -- 账户行分润金额
    ,post_flg -- 过账标志
    ,check_entry_cd -- 对账码
    ,tran_revd_flg -- 交易已冲正标志
    ,tran_acct_serv_fee_revs_seq_num -- 转账服务费冲正序号
    ,revs_auth_teller -- 冲正授权柜员编号
    ,revs_teller -- 冲正柜员编号
    ,org_tran_seq_num -- 机构交易序号
    ,end_day_onl_cd -- 日终联机代码
    ,termnt_num -- 终止号码
    ,core_flow_num -- 核心流水号
    ,bus_flow_num -- 业务流水号
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_name -- 客户经理名称
    ,cust_type_cd -- 客户类型代码
    ,remark -- 备注
    ,amort_status_cd -- 摊销状态代码
    ,loan_prod_id -- 贷款产品编号
    ,bal_pay_idf_cd -- 收支标识代码
    ,chn_id -- 渠道编号
    ,enter_acct_dt -- 入账日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101065'||P1.SC_SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SC_SEQ_NO -- 收费序号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.CHARGE_TO_PROD_TYPE -- 产品编号
    ,nvl(trim(P1.CHARGE_TO_CCY),'-') -- 币种代码
    ,P1.SEQ_NO -- 流水号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,nvl(trim(p8.card_no),p1.CHARGE_TO_BASE_ACCT_NO) -- 客户账号
    ,P1.CHARGE_TO_ACCT_SEQ_NO -- 子账号
    ,P1.CHARGE_TO_INTERNAL_KEY -- 账户标识符
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,P1.AGREEMENT_ID -- 存款协议编号
    ,nvl(trim(P1.DOC_TYPE),'-') -- 存款凭证类别代码
    ,P1.VOUCHER_START_NO -- 凭证起始号码
    ,P1.VOUCHER_SUM -- 凭证合计数量
    ,P1.EFFECT_DATE -- 生效日期
    ,P1.REVERSAL_BRANCH -- 冲正机构编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.REFERENCE -- 交易参考号
    ,P1.TRAN_TYPE -- 交易码
    ,P1.TRAN_SEQ_NO -- 交易序号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.OTH_BUSINESS_NO -- 交易对手业务编号
    ,P1.OTH_NAME -- 交易对手名称
    ,P1.OTH_CLIENT_NO -- 交易对手客户编号
    ,P1.OTH_CLIENT_NAME -- 交易对手客户名称
    ,nvl(trim(P1.OTH_CLIENT_TYPE),'-') -- 交易对手客户类型代码
    ,P1.USER_ID -- 交易柜员编号
    ,P1.OSD_SEQ_NO -- 应收费用序号
    ,P1.CHARGE_WAY -- 费用收费方式代码
    ,nvl(trim(P1.FEE_CHARGE_METHOD),'-') -- 手续费收取方式代码
    ,P1.FEE_TYPE -- 费用类型编号
    ,P1.FEE_CCY -- 费用币种代码
    ,P1.UNIT_PRICE -- 费用单价
    ,P1.FEE_AMT -- 费用金额
    ,P1.TRAN_FEE_AMT -- 原应收费用金额
    ,P1.SC_DISCOUNT_RATE -- 费用折扣率
    ,P1.SC_DISCOUNT_TYPE -- 费用折扣类型代码
    ,P1.ORIG_FEE_AMT -- 原始费用金额
    ,P1.DISC_FEE_AMT -- 折扣费用金额
    ,P1.TAX_AMT -- 税金
    ,P1.TAX_RATE -- 税率
    ,nvl(trim(P1.TAX_TYPE),'-') -- 税种代码
    ,DECODE(TRIM(P1.PROFIT_AMORTIZE_FLAG),'','-','Y','1','N','0',P1.PROFIT_AMORTIZE_FLAG) -- 摊销标志
    ,nvl(trim(P1.AMORTIZE_TIME_TYPE),'-') -- 摊销时间类型代码
    ,nvl(trim(P1.AMORTIZE_PERIOD_TYPE),'-') -- 摊销期限类型代码
    ,P1.AMORTIZE_DAY -- 摊销日
    ,P1.AMORTIZE_MONTH -- 摊销月
    ,P1.AMORT_START -- 摊销起始日期
    ,P1.AMORT_END -- 摊销截止日期
    ,DECODE(TRIM(P1.PROFIT_ALLOT_FLAG),'','-','Y','1','N','0',P1.PROFIT_ALLOT_FLAG) -- 分润标志
    ,P1.TRAN_BRANCH_PERCENT -- 交易行比例
    ,P1.TRAN_PROFIT_AMT -- 交易行分润金额
    ,P1.OPEN_BRANCH_PERCENT -- 账户行比例
    ,P1.OPEN_PROFIT_AMT -- 账户行分润金额
    ,DECODE(TRIM(P1.GL_POSTED_FLAG),'','-','Y','1','N','0',P1.GL_POSTED_FLAG) -- 过账标志
    ,P1.REACCOUNT_CD -- 对账码
    ,DECODE(TRIM(P1.REVERSAL_FLAG),'','-','Y','1','N','0',P1.REVERSAL_FLAG) -- 交易已冲正标志
    ,P1.REVERSAL_SC_SEQ_NO -- 转账服务费冲正序号
    ,P1.REVERSAL_AUTH_USER_ID -- 冲正授权柜员编号
    ,P1.REVERSAL_USER_ID -- 冲正柜员编号
    ,P1.BANK_SEQ_NO -- 机构交易序号
    ,P1.BO_IND -- 日终联机代码
    ,P1.END_NO -- 终止号码
    ,P1.SUB_SEQ_NO -- 核心流水号
    ,P1.BUS_SEQ_NO -- 业务流水号
    ,P1.ACCT_EXEC -- 客户经理编号
    ,P1.ACCT_EXEC_NAME -- 客户经理名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.REASON -- 备注
    ,nvl(trim(P1.AMORTIZE_STATUS),'-') -- 摊销状态代码
    ,P1.LOAN_PROD_TYPE -- 贷款产品编号
    ,nvl(trim(P1.CHARGE_PAY_FLAG),'-') -- 收支标识代码
    ,P1.SOURCE_TYPE -- 渠道编号
    ,P1.ACCOUNT_DATE -- 入账日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_serv_charge_hist' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_serv_charge_hist p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.charge_to_base_acct_no = p8.base_acct_no
   and p8.base_acct_no like '0%'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_RB_SERV_CHARGE_HIST'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_CHARGE_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where  1 = 1 
    and P1.TRAN_DATE=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_charge_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_charge_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_charge_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_charge_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_charge_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_charge_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);