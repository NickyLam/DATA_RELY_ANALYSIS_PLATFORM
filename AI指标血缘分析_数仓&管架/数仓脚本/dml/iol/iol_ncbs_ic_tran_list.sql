/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_ic_tran_list
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
drop table ${iol_schema}.ncbs_ic_tran_list_ex purge;
alter table ${iol_schema}.ncbs_ic_tran_list add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_ic_tran_list truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_ic_tran_list_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_ic_tran_list where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_ic_tran_list_ex(
    tran_date -- 平台交易日期
    ,tran_seq -- 平台交易流水号
    ,txn_chn_num -- 交易渠道编号
    ,glob_seq_num -- 全局流水号
    ,biz_seq_num -- 业务流水号
    ,sys_seq_num -- 系统流水号
    ,txn_dt -- 交易日期
    ,txn_tm -- 交易时间
    ,txn_tell -- 交易柜员编号
    ,txn_org_num -- 交易机构编号
    ,term_no -- 交易终端编号
    ,merch_no -- 商户编号
    ,setl_date -- 清算日期
    ,card_no -- 卡号
    ,ic_card_seq -- 卡序列号
    ,oth_base_acct_no -- 交易对手账号
    ,ccy -- 交易币种
    ,tran_amt -- 交易金额
    ,tran_stat -- 交易状态
    ,ret_code -- 交易状态码
    ,ret_msg -- 服务状态描述
    ,reference -- 交易参考号
    ,ic_aid -- 应用标识符
    ,tran_code -- 交易码
    ,ic_atc -- 交易计数器
    ,ic_act_bal -- 电子现金账户余额
    ,client_name -- 客户名称
    ,document_type -- 客户证件类型
    ,document_id -- 客户证件号码
    ,commission_client_name -- 代办人姓名
    ,commission_document_type -- 代办人证件类型
    ,commission_document_id -- 代办人证件号码
    ,commission_phone -- 代办人电话
    ,agen_cd -- 代理机构标识码
    ,cup_send_code -- 发送机构标识码
    ,memo_cntt -- 摘要
    ,db_cr_dir_cd -- 借贷方向代码
    ,sys_trace_num -- 系统跟踪号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tran_date -- 平台交易日期
    ,tran_seq -- 平台交易流水号
    ,txn_chn_num -- 交易渠道编号
    ,glob_seq_num -- 全局流水号
    ,biz_seq_num -- 业务流水号
    ,sys_seq_num -- 系统流水号
    ,txn_dt -- 交易日期
    ,txn_tm -- 交易时间
    ,txn_tell -- 交易柜员编号
    ,txn_org_num -- 交易机构编号
    ,term_no -- 交易终端编号
    ,merch_no -- 商户编号
    ,setl_date -- 清算日期
    ,card_no -- 卡号
    ,ic_card_seq -- 卡序列号
    ,oth_base_acct_no -- 交易对手账号
    ,ccy -- 交易币种
    ,tran_amt -- 交易金额
    ,tran_stat -- 交易状态
    ,ret_code -- 交易状态码
    ,ret_msg -- 服务状态描述
    ,reference -- 交易参考号
    ,ic_aid -- 应用标识符
    ,tran_code -- 交易码
    ,ic_atc -- 交易计数器
    ,ic_act_bal -- 电子现金账户余额
    ,client_name -- 客户名称
    ,document_type -- 客户证件类型
    ,document_id -- 客户证件号码
    ,commission_client_name -- 代办人姓名
    ,commission_document_type -- 代办人证件类型
    ,commission_document_id -- 代办人证件号码
    ,commission_phone -- 代办人电话
    ,agen_cd -- 代理机构标识码
    ,cup_send_code -- 发送机构标识码
    ,memo_cntt -- 摘要
    ,db_cr_dir_cd -- 借贷方向代码
    ,sys_trace_num -- 系统跟踪号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_ic_tran_list
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_ic_tran_list exchange partition p_${batch_date} with table ${iol_schema}.ncbs_ic_tran_list_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_ic_tran_list to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_ic_tran_list_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_ic_tran_list',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);