/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_delay_tran_hist
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
drop table ${iol_schema}.ncbs_rb_delay_tran_hist_ex purge;
alter table ${iol_schema}.ncbs_rb_delay_tran_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_delay_tran_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_delay_tran_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_delay_tran_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_delay_tran_hist_ex(
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,card_no -- 卡号
    ,ccy -- 币种
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,arrival_status -- 到账状态
    ,cash_item -- 现金项目
    ,channel_seq_no -- 全局流水号
    ,commission_client_tel -- 代办/代理人电话
    ,company -- 法人
    ,exchange_tran_code -- 收入方交易编码
    ,exchange_tran_codet -- 支出方交易编码
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,pay_unit -- 交款单位
    ,prefix -- 前缀
    ,res_seq_no -- 限制编号
    ,seq_no -- 序号
    ,settle_card_flag -- 单位结算卡转账标识
    ,source_type -- 渠道编号
    ,sub_seq_no -- 系统流水号
    ,terminal_id -- 交易终端编号
    ,track2 -- 卡二磁道
    ,track3 -- 卡三磁道
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,sign_timestamp -- 延迟到账发起交易时间戳
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_ccy -- 账户币种
    ,auth_user_id -- 授权柜员
    ,cancel_reason -- 撤销原因
    ,commission_client_name -- 代办人名称
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_name -- 对方账户名称
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_card_no -- 对手卡号
    ,oth_internal_key -- 对手账户内部键
    ,oth_prod_type -- 对方账户产品类型
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,tran_method -- 到账方式
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,card_no -- 卡号
    ,ccy -- 币种
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,arrival_status -- 到账状态
    ,cash_item -- 现金项目
    ,channel_seq_no -- 全局流水号
    ,commission_client_tel -- 代办/代理人电话
    ,company -- 法人
    ,exchange_tran_code -- 收入方交易编码
    ,exchange_tran_codet -- 支出方交易编码
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,pay_unit -- 交款单位
    ,prefix -- 前缀
    ,res_seq_no -- 限制编号
    ,seq_no -- 序号
    ,settle_card_flag -- 单位结算卡转账标识
    ,source_type -- 渠道编号
    ,sub_seq_no -- 系统流水号
    ,terminal_id -- 交易终端编号
    ,track2 -- 卡二磁道
    ,track3 -- 卡三磁道
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,sign_timestamp -- 延迟到账发起交易时间戳
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_ccy -- 账户币种
    ,auth_user_id -- 授权柜员
    ,cancel_reason -- 撤销原因
    ,commission_client_name -- 代办人名称
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_name -- 对方账户名称
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_card_no -- 对手卡号
    ,oth_internal_key -- 对手账户内部键
    ,oth_prod_type -- 对方账户产品类型
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,tran_method -- 到账方式
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_delay_tran_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_delay_tran_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_delay_tran_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_delay_tran_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_delay_tran_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_delay_tran_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);