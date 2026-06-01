/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_appr_letter_tran_hist
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
drop table ${iol_schema}.ncbs_rb_appr_letter_tran_hist_ex purge;
alter table ${iol_schema}.ncbs_rb_appr_letter_tran_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_appr_letter_tran_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_appr_letter_tran_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_appr_letter_tran_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_appr_letter_tran_hist_ex(
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,branch -- 机构编号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,gl_code -- 科目代码
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,acct_desc -- 账户描述
    ,appr_letter_no -- 核准件编号
    ,appr_type -- 核准件类型
    ,bank_seq_no -- 银行交易序号
    ,cash_item -- 现金项目
    ,company -- 法人
    ,cr_dr_ind -- 借贷标志
    ,cr_dr_maint_ind -- 借贷标识
    ,event_type -- 事件类型
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,oth_seq_no -- 对方交易流水号
    ,priority -- 优先级
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_type -- 渠道编号
    ,terminal_id -- 交易终端编号
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,tran_status -- 冲补抹标志
    ,tran_category -- 交易种类
    ,effect_date -- 产品生效日期
    ,reversal_date -- 冲正日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,actual_bal -- 实际余额
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_branch -- 对方账户开户机构
    ,oth_internal_key -- 对手账户内部键
    ,oth_prod_type -- 对方账户产品类型
    ,oth_reference -- 对方交易参考号
    ,previous_bal_amt -- 交易前余额
    ,tran_amt -- 交易金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,branch -- 机构编号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,gl_code -- 科目代码
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,acct_desc -- 账户描述
    ,appr_letter_no -- 核准件编号
    ,appr_type -- 核准件类型
    ,bank_seq_no -- 银行交易序号
    ,cash_item -- 现金项目
    ,company -- 法人
    ,cr_dr_ind -- 借贷标志
    ,cr_dr_maint_ind -- 借贷标识
    ,event_type -- 事件类型
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,oth_seq_no -- 对方交易流水号
    ,priority -- 优先级
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_type -- 渠道编号
    ,terminal_id -- 交易终端编号
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,tran_status -- 冲补抹标志
    ,tran_category -- 交易种类
    ,effect_date -- 产品生效日期
    ,reversal_date -- 冲正日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,actual_bal -- 实际余额
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_branch -- 对方账户开户机构
    ,oth_internal_key -- 对手账户内部键
    ,oth_prod_type -- 对方账户产品类型
    ,oth_reference -- 对方交易参考号
    ,previous_bal_amt -- 交易前余额
    ,tran_amt -- 交易金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_appr_letter_tran_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_appr_letter_tran_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_appr_letter_tran_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_appr_letter_tran_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_appr_letter_tran_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_appr_letter_tran_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);