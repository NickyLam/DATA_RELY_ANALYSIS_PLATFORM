/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_batch_rec_hist
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
drop table ${iol_schema}.ncbs_cl_batch_rec_hist_ex purge;
alter table ${iol_schema}.ncbs_cl_batch_rec_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cl_batch_rec_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_batch_rec_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_batch_rec_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cl_batch_rec_hist_ex(
    amt_type -- 金额类型
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,dd_no -- 发放号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,acct_class -- 账户等级
    ,auto_blocking -- 自动锁定标志
    ,bank_in_out -- 是否行内行外
    ,batch_rec_status -- 批量扣款状态
    ,batch_seq_no -- 批次明细序号
    ,company -- 法人
    ,invoice_tran_no -- 通知单号
    ,priority -- 优先级
    ,rec_amt_ctrl -- 扣款方式
    ,rec_status -- 回收处理状态
    ,restraint_seq_no -- 冻结编号
    ,settle_acct_class -- 结算账户分类
    ,settle_bank -- 结算行号
    ,settle_weight -- 结算权重
    ,stage_no -- 期次
    ,last_change_date -- 最后修改日期
    ,maturity_date -- 到期日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,last_change_user_id -- 最后修改柜员
    ,loan_no -- 贷款号
    ,paid_amt -- 已还金额
    ,rec_amt -- 回收金额(指回收的本金)
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_name -- 结算账户户名
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_amt -- 结算金额
    ,settle_base_acct_no -- 结算账号
    ,settle_client -- 结算客户号
    ,settle_prod_type -- 结算账户产品类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    amt_type -- 金额类型
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,dd_no -- 发放号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,user_id -- 交易柜员编号
    ,acct_class -- 账户等级
    ,auto_blocking -- 自动锁定标志
    ,bank_in_out -- 是否行内行外
    ,batch_rec_status -- 批量扣款状态
    ,batch_seq_no -- 批次明细序号
    ,company -- 法人
    ,invoice_tran_no -- 通知单号
    ,priority -- 优先级
    ,rec_amt_ctrl -- 扣款方式
    ,rec_status -- 回收处理状态
    ,restraint_seq_no -- 冻结编号
    ,settle_acct_class -- 结算账户分类
    ,settle_bank -- 结算行号
    ,settle_weight -- 结算权重
    ,stage_no -- 期次
    ,last_change_date -- 最后修改日期
    ,maturity_date -- 到期日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,last_change_user_id -- 最后修改柜员
    ,loan_no -- 贷款号
    ,paid_amt -- 已还金额
    ,rec_amt -- 回收金额(指回收的本金)
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_name -- 结算账户户名
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_amt -- 结算金额
    ,settle_base_acct_no -- 结算账号
    ,settle_client -- 结算客户号
    ,settle_prod_type -- 结算账户产品类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_batch_rec_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_batch_rec_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_batch_rec_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_batch_rec_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_batch_rec_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_batch_rec_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);