/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_commission_register
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
drop table ${iol_schema}.ncbs_rb_commission_register_ex purge;
alter table ${iol_schema}.ncbs_rb_commission_register add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_commission_register truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_commission_register_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_commission_register where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_commission_register_ex(
    acct_name -- 账户名称
    ,acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,client_no -- 客户编号
    ,country -- 国家
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,voucher_no -- 凭证号码
    ,channel_seq_no -- 全局流水号
    ,commission_client_tel -- 代办/代理人电话
    ,commission_reason -- 经办理由
    ,commission_relation -- 代办人关系
    ,company -- 法人
    ,event_type -- 事件类型
    ,is_commission -- 是否代办人
    ,prefix -- 前缀
    ,program_id -- 交易代码
    ,commission_expire_date -- 交易代办人证件证件失效日期
    ,commission_start_date -- 代办人证件开始日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_ccy -- 账户币种
    ,commission_client_name -- 代办人名称
    ,commission_client_no -- 代办人客户号
    ,commission_document_id -- 代办人证件号码
    ,commission_document_type -- 代办人证件类型
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,commission_confirm_result -- 核实结果
    ,commission_confirm_tel -- 核实电话
    ,commission_confirm_time -- 核实时间
    ,commission_confirm_user_id_key1 -- 代办核实员工号1
    ,commission_confirm_user_id_key2 -- 代办核实员工号2
    ,commission_flag -- 是否代理标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_name -- 账户名称
    ,acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,client_no -- 客户编号
    ,country -- 国家
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,voucher_no -- 凭证号码
    ,channel_seq_no -- 全局流水号
    ,commission_client_tel -- 代办/代理人电话
    ,commission_reason -- 经办理由
    ,commission_relation -- 代办人关系
    ,company -- 法人
    ,event_type -- 事件类型
    ,is_commission -- 是否代办人
    ,prefix -- 前缀
    ,program_id -- 交易代码
    ,commission_expire_date -- 交易代办人证件证件失效日期
    ,commission_start_date -- 代办人证件开始日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_ccy -- 账户币种
    ,commission_client_name -- 代办人名称
    ,commission_client_no -- 代办人客户号
    ,commission_document_id -- 代办人证件号码
    ,commission_document_type -- 代办人证件类型
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,commission_confirm_result -- 核实结果
    ,commission_confirm_tel -- 核实电话
    ,commission_confirm_time -- 核实时间
    ,commission_confirm_user_id_key1 -- 代办核实员工号1
    ,commission_confirm_user_id_key2 -- 代办核实员工号2
    ,commission_flag -- 是否代理标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_commission_register
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_commission_register exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_commission_register_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_commission_register to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_commission_register_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_commission_register',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);