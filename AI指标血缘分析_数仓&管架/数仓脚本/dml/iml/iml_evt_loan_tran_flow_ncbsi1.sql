/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_loan_tran_flow_ncbsi1
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
drop table ${iml_schema}.evt_loan_tran_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_loan_tran_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_loan_tran_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_tran_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,ova_flow_num -- 全局流水号
    ,tran_ref_no -- 交易参考号
    ,loan_num -- 贷款号
    ,acct_id -- 账户编号
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,acct_curr_cd -- 账户币种代码
    ,debit_crdt_flg_cd -- 借贷标志代码
    ,vtual_flg -- 虚拟标志
    ,prod_id -- 产品编号
    ,tran_code -- 交易码
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,effect_dt -- 生效日期
    ,tran_amt -- 交易金额
    ,amt_type_cd -- 金额类型代码
    ,curr_cd -- 币种代码
    ,pric_amt -- 本金金额
    ,int_amt -- 利息金额
    ,pnlt_amt -- 罚息金额
    ,comp_int_amt -- 复利金额
    ,tax -- 税金
    ,float_ratio -- 浮动比例
    ,evt_cate_id -- 事件类别编号
    ,src_module_type_cd -- 源模块类型代码
    ,chn_id -- 渠道编号
    ,chn_sub_flow_num -- 渠道子流水号
    ,chn_dt -- 渠道日期
    ,post_flg -- 过账标志
    ,revs_flg -- 冲正标志
    ,revs_flow_num -- 冲正流水号
    ,revs_dt -- 冲正日期
    ,core_tran_org_id -- 核心交易机构编号
    ,tran_org_id -- 交易机构编号
    ,bus_prod_id -- 业务产品编号
    ,accti_status_cd -- 核算状态代码
    ,belong_module -- 所属模块
    ,bank_tran_seq_num -- 银行交易序号
    ,loan_chn_cd -- 贷款渠道代码
    ,bus_flow_num -- 业务流水号
    ,check_entry_code -- 对账编码
    ,modif_bf_org_id -- 变更前机构编号
    ,rule_id -- 规则编号
    ,proc_idf_cd -- 处理标识代码
    ,bal_chg_type_cd -- 余额变化类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_loan_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_cl_gl_hist-1
insert into ${iml_schema}.evt_loan_tran_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,ova_flow_num -- 全局流水号
    ,tran_ref_no -- 交易参考号
    ,loan_num -- 贷款号
    ,acct_id -- 账户编号
    ,cust_type_cd -- 客户类型代码
    ,cust_id -- 客户编号
    ,acct_curr_cd -- 账户币种代码
    ,debit_crdt_flg_cd -- 借贷标志代码
    ,vtual_flg -- 虚拟标志
    ,prod_id -- 产品编号
    ,tran_code -- 交易码
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,effect_dt -- 生效日期
    ,tran_amt -- 交易金额
    ,amt_type_cd -- 金额类型代码
    ,curr_cd -- 币种代码
    ,pric_amt -- 本金金额
    ,int_amt -- 利息金额
    ,pnlt_amt -- 罚息金额
    ,comp_int_amt -- 复利金额
    ,tax -- 税金
    ,float_ratio -- 浮动比例
    ,evt_cate_id -- 事件类别编号
    ,src_module_type_cd -- 源模块类型代码
    ,chn_id -- 渠道编号
    ,chn_sub_flow_num -- 渠道子流水号
    ,chn_dt -- 渠道日期
    ,post_flg -- 过账标志
    ,revs_flg -- 冲正标志
    ,revs_flow_num -- 冲正流水号
    ,revs_dt -- 冲正日期
    ,core_tran_org_id -- 核心交易机构编号
    ,tran_org_id -- 交易机构编号
    ,bus_prod_id -- 业务产品编号
    ,accti_status_cd -- 核算状态代码
    ,belong_module -- 所属模块
    ,bank_tran_seq_num -- 银行交易序号
    ,loan_chn_cd -- 贷款渠道代码
    ,bus_flow_num -- 业务流水号
    ,check_entry_code -- 对账编码
    ,modif_bf_org_id -- 变更前机构编号
    ,rule_id -- 规则编号
    ,proc_idf_cd -- 处理标识代码
    ,bal_chg_type_cd -- 余额变化类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401019'||P1.GL_SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.GL_SEQ_NO -- 交易流水号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.REFERENCE -- 交易参考号
    ,P1.LOAN_NO -- 贷款号
    ,P1.INTERNAL_KEY -- 账户编号
    ,nvl(trim(P1.CLIENT_TYPE),'-') -- 客户类型代码
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 账户币种代码
    ,nvl(trim(P1.CR_DR_MAINT_IND),'-') -- 借贷标志代码
    ,decode(trim(P1.UN_REAL),'','-','Y','1','N','0',P1.UN_REAL) -- 虚拟标志
    ,P1.PROD_TYPE -- 产品编号
    ,P1.TRAN_TYPE -- 交易码
    ,P1.NARRATIVE -- 交易摘要描述
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.TRAN_DATE -- 交易日期
    ,P1.EFFECT_DATE -- 生效日期
    ,P1.AMOUNT -- 交易金额
    ,nvl(trim(P1.AMT_TYPE),'-') -- 金额类型代码
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,P1.PRI_AMT -- 本金金额
    ,P1.INT_AMT -- 利息金额
    ,P1.ODP_AMT -- 罚息金额
    ,P1.ODI_AMT -- 复利金额
    ,P1.TAX_AMT -- 税金
    ,P1.SPREAD_PERCENT -- 浮动比例
    ,P1.EVENT_TYPE -- 事件类别编号
    ,nvl(trim(P1.SOURCE_MODULE),'-') -- 源模块类型代码
    ,P1.SOURCE_TYPE -- 渠道编号
    ,P1.CHANNEL_SUB_SEQ_NO -- 渠道子流水号
    ,P1.CHANNEL_DATE -- 渠道日期
    ,decode(trim(P1.GL_POSTED_FLAG),'','-','Y','1','N','0',P1.GL_POSTED_FLAG) -- 过账标志
    ,decode(trim(P1.REVERSAL),'','-','Y','1','N','0',P1.REVERSAL) -- 冲正标志
    ,P1.REVERSAL_SEQ_NO -- 冲正流水号
    ,P1.REVERSAL_DATE -- 冲正日期
    ,P1.TRAN_BRANCH -- 核心交易机构编号
    ,P1.BRANCH -- 交易机构编号
    ,P1.BUSI_PROD -- 业务产品编号
    ,nvl(trim(P1.ACCOUNTING_STATUS),'-') -- 核算状态代码
    ,P1.SYSTEM_ID -- 所属模块
    ,P1.BANK_SEQ_NO -- 银行交易序号
    ,nvl(trim(P1.RESERVE2),'-') -- 贷款渠道代码
    ,P1.BUS_SEQ_NO -- 业务流水号
    ,P1.REACCOUNT_CD -- 对账编码
    ,P1.OLD_BRANCH -- 变更前机构编号
    ,P1.RULE_NO -- 规则编号
    ,P1.DEAL_FLAG -- 处理标识代码
    ,P1.BALANCE_CHANGE_TYPE -- 余额变化类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_gl_hist' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_gl_hist p1
where  1 = 1 
    and to_char(P1.tran_date,'yyyymmdd') = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_loan_tran_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_loan_tran_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_loan_tran_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_loan_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_loan_tran_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_loan_tran_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);