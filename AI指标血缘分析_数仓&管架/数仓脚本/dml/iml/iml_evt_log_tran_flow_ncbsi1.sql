/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_log_tran_flow_ncbsi1
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
drop table ${iml_schema}.evt_log_tran_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_log_tran_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_log_tran_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_log_tran_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,acct_id -- 账户编号
    ,tran_seq_num -- 交易序号
    ,lmt_id -- 限制编号
    ,tran_descb -- 交易描述
    ,tran_ref_no -- 交易参考号
    ,vrif_post_forbid_flg -- 核实后禁止标志
    ,revo_flg -- 撤销标志
    ,log_id -- 保函编号
    ,bus_prod_id -- 业务产品编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,guar_org_id -- 担保机构编号
    ,rev_guar_org_id -- 反担机构编号
    ,log_cont_id -- 保函合同编号
    ,applit_stl_acct_id -- 申请人结算账户编号
    ,benefc_acct_id -- 受益人账户编号
    ,benefc_name -- 受益人名称
    ,cust_mgr_id -- 客户经理编号
    ,curr_cd -- 币种代码
    ,log_amt -- 保函金额
    ,stop_pay_ratio -- 止付比例
    ,margin_amt -- 保证金金额
    ,pymc_cust_acct_num -- 备款客户账号
    ,pymc_acct_sub_acct_num -- 备款账户子账号
    ,pymc_acct_curr_cd -- 备款账户币种代码
    ,pymc_acct_prod_id -- 备款账户产品编号
    ,pbc_clear_cust_acct_num -- 人行清算客户账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_prod_id -- 结算账户产品编号
    ,margin_cust_acct_num -- 保证金客户账号
    ,margin_acct_sub_acct_num -- 保证金账户子账号
    ,margin_acct_curr_cd -- 保证金账户币种代码
    ,margin_acct_prod_id -- 保证金账户产品编号
    ,advc_amt -- 垫款金额
    ,advc_dubil_id -- 垫款借据编号
    ,advc_fix_pnlt_int_rat -- 垫款固定罚息利率
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,log_status_cd -- 保函状态代码
    ,evt_cate_id -- 事件类别编号
    ,post_flg -- 过账标志
    ,tran_termn_id -- 交易终端编号
    ,log_valid_flg -- 保函有效标志
    ,remark -- 备注
    ,mtg_cont_id -- 抵押合同编号
    ,log_compens_status_cd -- 保函赔付状态代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,benefc_cert_type_cd -- 受益人证件类型代码
    ,benefc_cert_no -- 受益人证件号码
    ,col_book_val -- 押品账面价值
    ,new_log_termnt_dt -- 新保函终止日期
    ,benefc_resdnt_addr -- 受益人居住地址
    ,cont_curr_cd -- 合同币种代码
    ,log_compens_amt -- 保函赔付金额
    ,cust_id -- 客户编号
    ,check_teller_id -- 复核柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,check_entry_code -- 对账编码
    ,bus_flow_num -- 业务流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_log_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_cl_lg_tran-1
insert into ${iml_schema}.evt_log_tran_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,acct_id -- 账户编号
    ,tran_seq_num -- 交易序号
    ,lmt_id -- 限制编号
    ,tran_descb -- 交易描述
    ,tran_ref_no -- 交易参考号
    ,vrif_post_forbid_flg -- 核实后禁止标志
    ,revo_flg -- 撤销标志
    ,log_id -- 保函编号
    ,bus_prod_id -- 业务产品编号
    ,open_acct_org_id -- 开户机构编号
    ,tran_org_id -- 交易机构编号
    ,guar_org_id -- 担保机构编号
    ,rev_guar_org_id -- 反担机构编号
    ,log_cont_id -- 保函合同编号
    ,applit_stl_acct_id -- 申请人结算账户编号
    ,benefc_acct_id -- 受益人账户编号
    ,benefc_name -- 受益人名称
    ,cust_mgr_id -- 客户经理编号
    ,curr_cd -- 币种代码
    ,log_amt -- 保函金额
    ,stop_pay_ratio -- 止付比例
    ,margin_amt -- 保证金金额
    ,pymc_cust_acct_num -- 备款客户账号
    ,pymc_acct_sub_acct_num -- 备款账户子账号
    ,pymc_acct_curr_cd -- 备款账户币种代码
    ,pymc_acct_prod_id -- 备款账户产品编号
    ,pbc_clear_cust_acct_num -- 人行清算客户账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_prod_id -- 结算账户产品编号
    ,margin_cust_acct_num -- 保证金客户账号
    ,margin_acct_sub_acct_num -- 保证金账户子账号
    ,margin_acct_curr_cd -- 保证金账户币种代码
    ,margin_acct_prod_id -- 保证金账户产品编号
    ,advc_amt -- 垫款金额
    ,advc_dubil_id -- 垫款借据编号
    ,advc_fix_pnlt_int_rat -- 垫款固定罚息利率
    ,begin_dt -- 起始日期
    ,exp_dt -- 到期日期
    ,log_status_cd -- 保函状态代码
    ,evt_cate_id -- 事件类别编号
    ,post_flg -- 过账标志
    ,tran_termn_id -- 交易终端编号
    ,log_valid_flg -- 保函有效标志
    ,remark -- 备注
    ,mtg_cont_id -- 抵押合同编号
    ,log_compens_status_cd -- 保函赔付状态代码
    ,loan_sign_cont_amt -- 贷款签约合同金额
    ,benefc_cert_type_cd -- 受益人证件类型代码
    ,benefc_cert_no -- 受益人证件号码
    ,col_book_val -- 押品账面价值
    ,new_log_termnt_dt -- 新保函终止日期
    ,benefc_resdnt_addr -- 受益人居住地址
    ,cont_curr_cd -- 合同币种代码
    ,log_compens_amt -- 保函赔付金额
    ,cust_id -- 客户编号
    ,check_teller_id -- 复核柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,check_entry_code -- 对账编码
    ,bus_flow_num -- 业务流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101028'||P1.TRAN_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRAN_NO -- 交易流水号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.COUNTER -- 交易序号
    ,P1.RES_SEQ_NO -- 限制编号
    ,P1.NARRATIVE -- 交易描述
    ,P1.REFERENCE -- 交易参考号
    ,DECODE(trim(P1.VERIFY_FLAG),'','-','Y','1','N','0') -- 核实后禁止标志
    ,DECODE(trim(P1.REVERSED_FLAG),'','-','Y','1','N','0') -- 撤销标志
    ,P1.LG_NO -- 保函编号
    ,P1.PROD_TYPE -- 业务产品编号
    ,P1.OPEN_BRANCH -- 开户机构编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.LG_BRANCH -- 担保机构编号
    ,P1.COUNTERPARTY_BRANCH -- 反担机构编号
    ,P1.CONTRACT_NO -- 保函合同编号
    ,P1.APPLY_CLIENT_NO -- 申请人结算账户编号
    ,P1.BENEFICIARY_ACCT_NO -- 受益人账户编号
    ,P1.BENEFICIARY_NAME -- 受益人名称
    ,P1.ACCT_EXEC -- 客户经理编号
    ,P1.CCY -- 币种代码
    ,P1.LG_AMT -- 保函金额
    ,P1.RESTRAINT_PER -- 止付比例
    ,P1.RESTRAINT_AMT -- 保证金金额
    ,P1.BACK_ACCT_NO -- 备款客户账号
    ,P1.BACK_ACCT_SEQ_NO -- 备款账户子账号
    ,nvl(trim(P1.BACK_ACCT_CCY),'-') -- 备款账户币种代码
    ,P1.BACK_PROD_TYPE -- 备款账户产品编号
    ,P1.SETTLE_ACCT_NO -- 人行清算客户账号
    ,P1.SETTLE_ACCT_SEQ_NO -- 结算账户子账号
    ,P1.SETTLE_ACCT_CCY -- 结算账户币种代码
    ,P1.SETTLE_PROD_TYPE -- 结算账户产品编号
    ,P1.BOND_ACCT_NO -- 保证金客户账号
    ,P1.BOND_ACCT_SEQ_NO -- 保证金账户子账号
    ,nvl(trim(P1.BOND_ACCT_CCY),'-') -- 保证金账户币种代码
    ,P1.BOND_PROD_TYPE -- 保证金账户产品编号
    ,P1.ADVANCED_AMT -- 垫款金额
    ,P1.ADVANCED_ACCT_NO -- 垫款借据编号
    ,P1.PRI_PLTY_ABS -- 垫款固定罚息利率
    ,P1.LG_START_DATE -- 起始日期
    ,P1.LG_END_DATE -- 到期日期
    ,P1.LG_STATUS -- 保函状态代码
    ,P1.EVENT_TYPE -- 事件类别编号
    ,DECODE(P1.GL_POSTED_FLAG,'Y','1','N','0') -- 过账标志
    ,P1.TERMINAL_ID -- 交易终端编号
    ,DECODE(P1.LG_FLAG,'A','1','C','0') -- 保函有效标志
    ,P1.REMARK -- 备注
    ,P1.MORTGAGE_CONTRACT_NO -- 抵押合同编号
    ,nvl(trim(P1.COMPENSATE_STATUS),'-') -- 保函赔付状态代码
    ,P1.ORIG_LOAN_AMT -- 贷款签约合同金额
    ,nvl(trim(P1.BENEFICIARY_DOCUMENT_TYPE),'0000') -- 受益人证件类型代码
    ,P1.BENEFICIARY_DOCUMENT_ID -- 受益人证件号码
    ,P1.COLLAT_VALUE -- 押品账面价值
    ,P1.NEW_LG_END_DATE -- 新保函终止日期
    ,P1.BENEFICIARY_ADDRESS -- 受益人居住地址
    ,P1.CONTRACT_CCY -- 合同币种代码
    ,P1.LG_COMPENSATE_AMT -- 保函赔付金额
    ,P1.CLIENT_NO -- 客户编号
    ,P1.APPR_USER_ID -- 复核柜员编号
    ,P1.USER_ID -- 交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,'' -- 对账编码
    ,'' -- 业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_lg_tran' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_lg_tran p1
where  1 = 1 
    and P1.tran_date = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_log_tran_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_log_tran_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_log_tran_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_log_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_log_tran_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_log_tran_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);