/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_batch_fee_rgst_dtl_ncbsi1
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
drop table ${iml_schema}.evt_batch_fee_rgst_dtl_ncbsi1_tm purge;
alter table ${iml_schema}.evt_batch_fee_rgst_dtl add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_batch_fee_rgst_dtl modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_batch_fee_rgst_dtl_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,batch_dtl_seq_num -- 批次明细序号
    ,lp_id -- 法人编号
    ,ova_flow_num -- 全局流水号
    ,tran_ref_no -- 交易参考号
    ,fee_type_id -- 费用类型编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,acct_open_acct_org_id -- 账户开户机构编号
    ,tran_dt -- 交易日期
    ,tran_org -- 交易机构编号
    ,init_fee_amt -- 原始费用金额
    ,fee_discnt_amt -- 费用折扣金额
    ,charge_curr_cd -- 收费币种代码
    ,discnt_cate_cd -- 折扣类别代码
    ,int_rat_discnt -- 利率折扣
    ,fee_amt -- 费用金额
    ,tax -- 税金
    ,tax_rat -- 税率
    ,tax_category_cd -- 税种代码
    ,charge_day -- 收费日
    ,next_charge_dt -- 下一收费日期
    ,tran_bank_ratio -- 交易行比例
    ,acct_bank_ratio -- 账户行比例
    ,acct_bank_prft_cut_amt -- 账户行分润金额
    ,end_day_onl_cd -- 日终联机代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,card_no -- 卡号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_batch_fee_rgst_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_batch_charge-1
insert into ${iml_schema}.evt_batch_fee_rgst_dtl_ncbsi1_tm(
    evt_id -- 事件编号
    ,batch_dtl_seq_num -- 批次明细序号
    ,lp_id -- 法人编号
    ,ova_flow_num -- 全局流水号
    ,tran_ref_no -- 交易参考号
    ,fee_type_id -- 费用类型编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,acct_open_acct_org_id -- 账户开户机构编号
    ,tran_dt -- 交易日期
    ,tran_org -- 交易机构编号
    ,init_fee_amt -- 原始费用金额
    ,fee_discnt_amt -- 费用折扣金额
    ,charge_curr_cd -- 收费币种代码
    ,discnt_cate_cd -- 折扣类别代码
    ,int_rat_discnt -- 利率折扣
    ,fee_amt -- 费用金额
    ,tax -- 税金
    ,tax_rat -- 税率
    ,tax_category_cd -- 税种代码
    ,charge_day -- 收费日
    ,next_charge_dt -- 下一收费日期
    ,tran_bank_ratio -- 交易行比例
    ,acct_bank_ratio -- 账户行比例
    ,acct_bank_prft_cut_amt -- 账户行分润金额
    ,end_day_onl_cd -- 日终联机代码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,card_no -- 卡号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101062'||P1.BATCH_SEQ_NO -- 事件编号
    ,P1.BATCH_SEQ_NO -- 批次明细序号
    ,'9999' -- 法人编号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.REFERENCE -- 交易参考号
    ,P1.FEE_TYPE -- 费用类型编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_CCY -- 账户币种代码
    ,P1.ACCT_SEQ_NO -- 账户子账号
    ,P1.ACCT_BRANCH -- 账户开户机构编号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.ORIG_FEE_AMT -- 原始费用金额
    ,P1.DISC_FEE_AMT -- 费用折扣金额
    ,P1.FEE_CCY -- 收费币种代码
    ,P1.DISC_TYPE -- 折扣类别代码
    ,P1.DISC_RATE -- 利率折扣
    ,P1.FEE_AMT -- 费用金额
    ,P1.TAX_AMT -- 税金
    ,P1.TAX_RATE -- 税率
    ,P1.TAX_TYPE -- 税种代码
    ,P1.CHARGE_DAY -- 收费日
    ,P1.NEXT_CHARGE_DATE -- 下一收费日期
    ,P1.TRAN_BRANCH_PERCENT -- 交易行比例
    ,P1.OPEN_BRANCH_PERCENT -- 账户行比例
    ,P1.OPEN_PROFIT_AMT -- 账户行分润金额
    ,P1.BO_IND -- 日终联机代码
    ,P1.USER_ID -- 交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.CARD_NO -- 卡号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_batch_charge' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_batch_charge p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_batch_fee_rgst_dtl truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_batch_fee_rgst_dtl exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_batch_fee_rgst_dtl_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_batch_fee_rgst_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_batch_fee_rgst_dtl_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_batch_fee_rgst_dtl', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);