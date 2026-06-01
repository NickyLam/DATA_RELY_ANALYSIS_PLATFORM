/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_suspd_wrtoff_on_acct_rgst_b_ncbsi1
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
drop table ${iml_schema}.evt_suspd_wrtoff_on_acct_rgst_b_ncbsi1_tm purge;
alter table ${iml_schema}.evt_suspd_wrtoff_on_acct_rgst_b add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_suspd_wrtoff_on_acct_rgst_b modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_suspd_wrtoff_on_acct_rgst_b_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,on_acct_seq_num -- 挂账序号
    ,supp_on_acct_sub_acct_num -- 追加挂账子账号
    ,cust_acct_num -- 客户账号
    ,curr_cd -- 币种代码
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,debit_crdt_flg -- 借贷标志
    ,on_acct_status_cd -- 挂账状态代码
    ,max_wrtoff_seq_num -- 最大销账序号
    ,memo -- 摘要
    ,cntpty_acct_bank_int_flg -- 交易对手账户行内标志
    ,on_acct_exp_dt -- 挂账到期日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,appl_cust_id -- 申请客户编号
    ,auth_teller_id -- 授权柜员编号
    ,on_acct_bal -- 挂账余额
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_id -- 结算账户编号
    ,tran_org_id -- 交易机构编号
    ,on_acct_amt -- 挂账金额
    ,on_acct_cap_src_dir_cd -- 挂账资金来源去向代码
    ,mtg_amt_bus_id -- 押金业务编号
    ,suspd_wrtoff_tm -- 挂销账时间
    ,on_acct_tot -- 挂账总额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_suspd_wrtoff_on_acct_rgst_b
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_gl_hang_account-1
insert into ${iml_schema}.evt_suspd_wrtoff_on_acct_rgst_b_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,on_acct_seq_num -- 挂账序号
    ,supp_on_acct_sub_acct_num -- 追加挂账子账号
    ,cust_acct_num -- 客户账号
    ,curr_cd -- 币种代码
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,tran_ref_no -- 交易参考号
    ,tran_teller_id -- 交易柜员编号
    ,debit_crdt_flg -- 借贷标志
    ,on_acct_status_cd -- 挂账状态代码
    ,max_wrtoff_seq_num -- 最大销账序号
    ,memo -- 摘要
    ,cntpty_acct_bank_int_flg -- 交易对手账户行内标志
    ,on_acct_exp_dt -- 挂账到期日期
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,appl_cust_id -- 申请客户编号
    ,auth_teller_id -- 授权柜员编号
    ,on_acct_bal -- 挂账余额
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_id -- 结算账户编号
    ,tran_org_id -- 交易机构编号
    ,on_acct_amt -- 挂账金额
    ,on_acct_cap_src_dir_cd -- 挂账资金来源去向代码
    ,mtg_amt_bus_id -- 押金业务编号
    ,suspd_wrtoff_tm -- 挂销账时间
    ,on_acct_tot -- 挂账总额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101041'||P1.HANG_SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.HANG_SEQ_NO -- 挂账序号
    ,P1.SUB_HANG_SEQ_NO -- 追加挂账子账号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.CCY -- 币种代码
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.CLIENT_NO -- 客户编号
    ,P1.DOCUMENT_ID -- 证件号码
    ,P1.DOCUMENT_TYPE -- 证件类型代码
    ,P1.REFERENCE -- 交易参考号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.CR_DR_IND -- 借贷标志
    ,P1.HANG_STATUS -- 挂账状态代码
    ,P1.MWRITE_OFF_SEQ_NO -- 最大销账序号
    ,P1.NARRATIVE -- 摘要
    ,DECODE(P1.OTH_BANK_FLAG,'Y','1','N','0') -- 交易对手账户行内标志
    ,P1.HANG_END_DATE -- 挂账到期日期
    ,P1.TRAN_DATE -- 交易日期
    ,${iml_schema}.timeformat_max2(P1.TRAN_TIMESTAMP) -- 交易时间
    ,P1.APPLY_CLIENT_NO -- 申请客户编号
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.HANG_BAL -- 挂账余额
    ,P1.OTH_ACCT_NAME -- 交易对手账户名称
    ,P1.OTH_BASE_ACCT_NO -- 交易对手账户编号
    ,P1.OTH_BRANCH -- 交易对手开户机构编号
    ,P1.SETTLE_ACCT_NAME -- 结算账户名称
    ,P1.SETTLE_BASE_ACCT_NO -- 结算账户编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.HANG_AMT -- 挂账金额
    ,P1.HANG_DEAL_TYPE -- 挂账资金来源去向代码
    ,P1.PLEDGE_BUSI_NO -- 押金业务编号
    ,${iml_schema}.timeformat_max2(P1.HANG_WRITE_OFF_TIME) -- 挂销账时间
    ,P1.HANG_TOTAL_AMT -- 挂账总额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_gl_hang_account' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_gl_hang_account p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_suspd_wrtoff_on_acct_rgst_b truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_suspd_wrtoff_on_acct_rgst_b exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_suspd_wrtoff_on_acct_rgst_b_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_suspd_wrtoff_on_acct_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_suspd_wrtoff_on_acct_rgst_b_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_suspd_wrtoff_on_acct_rgst_b', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);