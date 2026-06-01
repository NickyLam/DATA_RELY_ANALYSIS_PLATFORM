/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_clrec_deduction_detail_hist
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist_ex purge;
alter table ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist_ex(
    acct_seq_no -- 账户子账号
    ,amt_type -- 金额类型
    ,base_acct_no -- 交易账号/卡号
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,remark -- 备注
    ,tran_type -- 交易类型
    ,amt_ctl -- 金额控制标志
    ,auto_blocking -- 自动锁定标志
    ,batch_no -- 批次号
    ,batch_seq_no -- 批次明细序号
    ,company -- 法人
    ,error_msg -- 错误代码
    ,fixed_amt -- 额定监管总金额
    ,group_id -- 流程组id
    ,priority -- 优先级
    ,res_seq_no -- 限制编号
    ,ret_status -- 结果状态
    ,scene_id -- 场景id
    ,seq_no -- 序号
    ,settle_acct_class -- 结算账户分类
    ,settle_no -- 结算编号
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_ccy -- 账户币种
    ,oppo_acct_no -- 行外对手账号
    ,oppo_bank_code -- 行外对手账户行号
    ,oppo_bank_name -- 行外对手账户行名
    ,oth_settle_acct_ccy -- 对手结算账户币种
    ,oth_settle_acct_name -- 对手结算账户户名
    ,oth_settle_acct_seq_no -- 对手结算账户序号
    ,oth_settle_base_acct_no -- 对手结算账号
    ,oth_settle_client -- 对手结算客户号
    ,oth_settle_prod_type -- 对手结算账户产品类型
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_name -- 结算账户户名
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_amt -- 结算金额
    ,settle_base_acct_no -- 结算账号
    ,settle_client -- 结算客户号
    ,tran_amt -- 交易金额
    ,deal_status -- 处理状态
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,amt_type -- 金额类型
    ,base_acct_no -- 交易账号/卡号
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,remark -- 备注
    ,tran_type -- 交易类型
    ,amt_ctl -- 金额控制标志
    ,auto_blocking -- 自动锁定标志
    ,batch_no -- 批次号
    ,batch_seq_no -- 批次明细序号
    ,company -- 法人
    ,error_msg -- 错误代码
    ,fixed_amt -- 额定监管总金额
    ,group_id -- 流程组id
    ,priority -- 优先级
    ,res_seq_no -- 限制编号
    ,ret_status -- 结果状态
    ,scene_id -- 场景id
    ,seq_no -- 序号
    ,settle_acct_class -- 结算账户分类
    ,settle_no -- 结算编号
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_ccy -- 账户币种
    ,oppo_acct_no -- 行外对手账号
    ,oppo_bank_code -- 行外对手账户行号
    ,oppo_bank_name -- 行外对手账户行名
    ,oth_settle_acct_ccy -- 对手结算账户币种
    ,oth_settle_acct_name -- 对手结算账户户名
    ,oth_settle_acct_seq_no -- 对手结算账户序号
    ,oth_settle_base_acct_no -- 对手结算账号
    ,oth_settle_client -- 对手结算客户号
    ,oth_settle_prod_type -- 对手结算账户产品类型
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_name -- 结算账户户名
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_amt -- 结算金额
    ,settle_base_acct_no -- 结算账号
    ,settle_client -- 结算客户号
    ,tran_amt -- 交易金额
    ,deal_status -- 处理状态
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_clrec_deduction_detail_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_clrec_deduction_detail_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_clrec_deduction_detail_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);