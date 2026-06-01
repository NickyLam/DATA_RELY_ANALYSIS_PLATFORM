/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cpms_t_account_equity_list
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
drop table ${iol_schema}.cpms_t_account_equity_list_ex purge;
alter table ${iol_schema}.cpms_t_account_equity_list add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cpms_t_account_equity_list truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cpms_t_account_equity_list_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cpms_t_account_equity_list where 0=1;

insert /*+ append */ into ${iol_schema}.cpms_t_account_equity_list_ex(
    id -- 主键ID
    ,trade_date -- 交易日期
    ,trade_time -- 交易时间
    ,branch_no -- 分行号
    ,branch_no_name -- 分行名称
    ,org_no -- 机构号
    ,org_no_name -- 机构名称
    ,pty_id -- 客户号
    ,pty_name -- 客户名称
    ,equity_count -- 权益积分变化(数值为正负，区分消费，增加)
    ,equity_count_useble -- 剩余可用权益积分
    ,trade_channel -- 交易渠道(系统字母简称)
    ,trade_type -- 交易类型(1-消费：客户兑换权益积分产生的扣减项2-配赠：系统按配赠权益积分，自动生成的增加项3-到期：积分有效期到期，系统自动扣除到期积分的扣减项4-手工调整：由于其他情况，电话银行需手工进行调整权益的增加/扣减项)
    ,remark -- 摘要
    ,attachment_path -- 附件路径
    ,attachment -- 附件名称
    ,last_ope_time -- 最后操作时间
    ,final_oper_pers -- 最后操作人
    ,memo_info -- 备注
    ,glob_seq_num -- 全局流水号
    ,mail_sbj -- 邮件主题
    ,mail_cntt -- 邮件内容
    ,mailbox_addr -- 邮件地址
    ,mail_flag -- 邮件发送标示0未发送1发送中2已发送3不需要发送邮件
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 主键ID
    ,trade_date -- 交易日期
    ,trade_time -- 交易时间
    ,branch_no -- 分行号
    ,branch_no_name -- 分行名称
    ,org_no -- 机构号
    ,org_no_name -- 机构名称
    ,pty_id -- 客户号
    ,pty_name -- 客户名称
    ,equity_count -- 权益积分变化(数值为正负，区分消费，增加)
    ,equity_count_useble -- 剩余可用权益积分
    ,trade_channel -- 交易渠道(系统字母简称)
    ,trade_type -- 交易类型(1-消费：客户兑换权益积分产生的扣减项2-配赠：系统按配赠权益积分，自动生成的增加项3-到期：积分有效期到期，系统自动扣除到期积分的扣减项4-手工调整：由于其他情况，电话银行需手工进行调整权益的增加/扣减项)
    ,remark -- 摘要
    ,attachment_path -- 附件路径
    ,attachment -- 附件名称
    ,last_ope_time -- 最后操作时间
    ,final_oper_pers -- 最后操作人
    ,memo_info -- 备注
    ,glob_seq_num -- 全局流水号
    ,mail_sbj -- 邮件主题
    ,mail_cntt -- 邮件内容
    ,mailbox_addr -- 邮件地址
    ,mail_flag -- 邮件发送标示0未发送1发送中2已发送3不需要发送邮件
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cpms_t_account_equity_list
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cpms_t_account_equity_list exchange partition p_${batch_date} with table ${iol_schema}.cpms_t_account_equity_list_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cpms_t_account_equity_list to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cpms_t_account_equity_list_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cpms_t_account_equity_list',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);