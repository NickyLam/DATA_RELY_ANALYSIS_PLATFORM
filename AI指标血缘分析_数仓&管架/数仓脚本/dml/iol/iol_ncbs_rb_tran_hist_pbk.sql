/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_tran_hist_pbk
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
drop table ${iol_schema}.ncbs_rb_tran_hist_pbk_ex purge;
alter table ${iol_schema}.ncbs_rb_tran_hist_pbk add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_tran_hist_pbk truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_tran_hist_pbk_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_tran_hist_pbk where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_tran_hist_pbk_ex(
    acct_seq_no -- 账户子账号
    ,amt_type -- 金额类型
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,acct_class -- 账户等级
    ,acct_desc -- 账户描述
    ,amt_calc_type -- 金额计算类型
    ,auto_reversal_flag -- 自动冲正标志
    ,bal_type -- 余额类型
    ,bank_seq_no -- 银行交易序号
    ,batch_no -- 批次号
    ,biz_type -- 中间业务类型
    ,cash_item -- 现金项目
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,cr_dr_ind -- 借贷标志
    ,event_type -- 事件类型
    ,fin_type -- 理财类型
    ,from_rate_flag -- 买方交易汇率标志
    ,lender -- 贷款人
    ,medium_flag -- 介质标志
    ,medium_type -- 存款介质类型
    ,narrative -- 摘要
    ,pbk_upd_flag -- 是否补登存
    ,primary_event_type -- 主事件类型
    ,print_cnt -- 打印次数
    ,program_id -- 交易代码
    ,quote_type -- 牌价类型
    ,rate_type -- 汇率类型
    ,receipt_no -- 回收号
    ,reversal -- 是否冲正标志
    ,reversal_seq_no -- 冲正流水号
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,source_type -- 渠道编号
    ,sub_seq_no -- 系统流水号
    ,system_code -- 来源系统编号
    ,tae_sub_seq_no -- tae子流水序号
    ,to_rate_flag -- 卖方交易汇率标志
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,tran_status -- 冲补抹标志
    ,tran_category -- 交易种类
    ,effect_date -- 产品生效日期
    ,orig_tran_timestamp -- 原始交易时间戳
    ,reversal_tran_date -- 冲正交易日期
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,actual_bal -- 实际余额
    ,actual_bal_amt_fin -- 交易后余额加理财
    ,base_equiv_amt -- 基础等值金额
    ,contra_equiv_amt -- 对方等值金额
    ,cross_rate -- 交叉汇率
    ,from_amount -- 移出金额
    ,from_xrate -- 买方汇率值
    ,ov_cross_rate -- 实际交易时修改交叉汇率
    ,ov_to_amount -- 根据实际交易时修改交叉汇率计算的金额
    ,previous_bal_amt -- 交易前余额
    ,to_amount -- 移入金额
    ,to_xrate -- 卖方汇率值
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,tran_method -- 到账方式
    ,flat_rate -- 平盘汇率
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,amt_type -- 金额类型
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,acct_class -- 账户等级
    ,acct_desc -- 账户描述
    ,amt_calc_type -- 金额计算类型
    ,auto_reversal_flag -- 自动冲正标志
    ,bal_type -- 余额类型
    ,bank_seq_no -- 银行交易序号
    ,batch_no -- 批次号
    ,biz_type -- 中间业务类型
    ,cash_item -- 现金项目
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,cr_dr_ind -- 借贷标志
    ,event_type -- 事件类型
    ,fin_type -- 理财类型
    ,from_rate_flag -- 买方交易汇率标志
    ,lender -- 贷款人
    ,medium_flag -- 介质标志
    ,medium_type -- 存款介质类型
    ,narrative -- 摘要
    ,pbk_upd_flag -- 是否补登存
    ,primary_event_type -- 主事件类型
    ,print_cnt -- 打印次数
    ,program_id -- 交易代码
    ,quote_type -- 牌价类型
    ,rate_type -- 汇率类型
    ,receipt_no -- 回收号
    ,reversal -- 是否冲正标志
    ,reversal_seq_no -- 冲正流水号
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,source_type -- 渠道编号
    ,sub_seq_no -- 系统流水号
    ,system_code -- 来源系统编号
    ,tae_sub_seq_no -- tae子流水序号
    ,to_rate_flag -- 卖方交易汇率标志
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,tran_status -- 冲补抹标志
    ,tran_category -- 交易种类
    ,effect_date -- 产品生效日期
    ,orig_tran_timestamp -- 原始交易时间戳
    ,reversal_tran_date -- 冲正交易日期
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,actual_bal -- 实际余额
    ,actual_bal_amt_fin -- 交易后余额加理财
    ,base_equiv_amt -- 基础等值金额
    ,contra_equiv_amt -- 对方等值金额
    ,cross_rate -- 交叉汇率
    ,from_amount -- 移出金额
    ,from_xrate -- 买方汇率值
    ,ov_cross_rate -- 实际交易时修改交叉汇率
    ,ov_to_amount -- 根据实际交易时修改交叉汇率计算的金额
    ,previous_bal_amt -- 交易前余额
    ,to_amount -- 移入金额
    ,to_xrate -- 卖方汇率值
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,tran_method -- 到账方式
    ,flat_rate -- 平盘汇率
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_tran_hist_pbk
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_tran_hist_pbk exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_tran_hist_pbk_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_tran_hist_pbk to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_tran_hist_pbk_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_tran_hist_pbk',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);