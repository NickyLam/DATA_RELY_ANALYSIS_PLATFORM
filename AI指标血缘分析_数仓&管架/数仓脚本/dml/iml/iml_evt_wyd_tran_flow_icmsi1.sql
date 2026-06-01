/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wyd_tran_flow_icmsi1
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
drop table ${iml_schema}.evt_wyd_tran_flow_icmsi1_tm purge;
alter table ${iml_schema}.evt_wyd_tran_flow add partition p_icmsi1 values ('icmsi1')(
        subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wyd_tran_flow modify partition p_icmsi1
    add subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wyd_tran_flow_icmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,we_flow_num -- 微众流水号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,org_id -- 机构编号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,level5_cls_cd -- 五级分类代码
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,debit_crdt_flg -- 借贷标志
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,acct_bal -- 账户余额
    ,cash_trans_flg -- 现转标志
    ,enter_acct_amt -- 入账金额
    ,enter_acct_way_cd -- 入账方式代码
    ,enter_acct_dt -- 入账日期
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_bank_no -- 交易对手行号
    ,cntpty_bank_name -- 交易对手行名称
    ,erase_acct_flg -- 冲抹标志
    ,repay_clear_tran_id -- 还款清算交易编号
    ,batch_dt -- 批量日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wyd_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_wyd_loan_trans_detail-1
insert into ${iml_schema}.evt_wyd_tran_flow_icmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,we_flow_num -- 微众流水号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,org_id -- 机构编号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,level5_cls_cd -- 五级分类代码
    ,tran_code -- 交易码
    ,tran_descb -- 交易描述
    ,debit_crdt_flg -- 借贷标志
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,acct_bal -- 账户余额
    ,cash_trans_flg -- 现转标志
    ,enter_acct_amt -- 入账金额
    ,enter_acct_way_cd -- 入账方式代码
    ,enter_acct_dt -- 入账日期
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_bank_no -- 交易对手行号
    ,cntpty_bank_name -- 交易对手行名称
    ,erase_acct_flg -- 冲抹标志
    ,repay_clear_tran_id -- 还款清算交易编号
    ,batch_dt -- 批量日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101031'||P1.CONSUMERTRANSID  -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CONSUMERTRANSID -- 微众流水号
    ,P1.TXNSEQ -- 交易流水号
    ,${iml_schema}.timeformat_max2(P1.TXNDATE||P1.TXNTIME) -- 交易日期
    ,P1.ORGID -- 机构编号
    ,P1.LENDINGREF -- 借据编号
    ,P1.CURRCD -- 币种代码
    ,P1.CUSTOMERID -- 客户编号
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim（P1.CLASSIFYRESULT),'99') -- 五级分类代码
    ,nvl(trim（P1.TXNCODE),'-') -- 交易码
    ,P1.TXNDESC -- 交易描述
    ,P1.DBCRIND -- 借贷标志
    ,P1.ACCTNO -- 账户编号
    ,nvl(trim（P1.ACCTTYPE),'-') -- 账户类型代码
    ,P1.TXNBALANCE -- 账户余额
    ,nvl(trim（P1.CASHFLAG),'-') -- 现转标志
    ,P1.POSTAMT -- 入账金额
    ,nvl(trim（P1.POSTGLIND),'-') -- 入账方式代码
    ,${iml_schema}.timeformat_max2(P1.POSTDATE||P1.POSTTIME) -- 入账日期
    ,P1.YOURACCTNO -- 交易对手账户编号
    ,P1.YOURACCTNAME -- 交易对手账户名称
    ,P1.YOURBANKID -- 交易对手行号
    ,P1.YOURBANKNAME -- 交易对手行名称
    ,nvl(trim（P1.TRANSFLAG),'-') -- 冲抹标志
    ,P1.SETTLEID -- 还款清算交易编号
    ,${iml_schema}.timeformat_max2(P1.BATCHDATE) -- 批量日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记所属机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wyd_loan_trans_detail' -- 源表名称
    ,'icmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wyd_loan_trans_detail p1
where  1 = 1 
    and p1.etl_dt=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wyd_tran_flow truncate subpartition p_icmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wyd_tran_flow exchange subpartition p_icmsi1_${batch_date} with table ${iml_schema}.evt_wyd_tran_flow_icmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wyd_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wyd_tran_flow_icmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wyd_tran_flow', partname => 'p_icmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);