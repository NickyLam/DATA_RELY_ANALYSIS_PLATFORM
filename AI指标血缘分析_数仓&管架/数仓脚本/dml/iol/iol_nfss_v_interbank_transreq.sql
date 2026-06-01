/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_v_interbank_transreq
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
drop table ${iol_schema}.nfss_v_interbank_transreq_ex purge;
alter table ${iol_schema}.nfss_v_interbank_transreq add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.nfss_v_interbank_transreq;

-- 2.3 insert data to ex table
create table ${iol_schema}.nfss_v_interbank_transreq_ex nologging
compress
as
select * from ${iol_schema}.nfss_v_interbank_transreq where 0=1;

insert /*+ append */ into ${iol_schema}.nfss_v_interbank_transreq_ex(
    client_no -- 客户号
    ,client_name -- 客户名称
    ,serial_no -- 交易流水
    ,trans_date -- 交易日期
    ,trans_time -- 交易时间
    ,trans_code -- 交易代码
    ,trans_name -- 交易代码名称
    ,branch_no -- 机构号
    ,in_client_no -- 内部客户号
    ,client_type -- 客户类型
    ,id_type -- 证件类型
    ,id_code -- 证件号码
    ,amt -- 交易金额
    ,vol -- 份额
    ,bank_acc -- 交易账号
    ,bank_name -- 开户行
    ,cnaps_code -- 大额行号
    ,channel -- 渠道
    ,curr_type -- 币种
    ,status -- 交易确认状态
    ,busin_code -- 业务码
    ,cfm_date -- 确认日期
    ,cfm_amt -- 确认金额
    ,cfm_vol -- 确认份额
    ,repr_name -- 法人代表姓名
    ,repr_id_type -- 法人代表证件类型
    ,repr_id_code -- 法人代表证件号码
    ,repr_mobile -- 法人代表手机号
    ,actor_name -- 经办人姓名
    ,actor_id_type -- 经办人证件类型
    ,actor_id_code -- 经办人证件号码
    ,actor_tel -- 经办人办公电话
    ,actor_mobile -- 经办人手机号
    ,square_no -- 清算流水
    ,seq_no -- 清算序号
    ,square_date -- 清算日期
    ,old_square_date -- 旧清算日期
    ,liqu_dir -- 账务方向
    ,square_amt -- 入账金额
    ,frozen_amt -- 冻结金额
    ,square_status -- 流水状态
    ,deal_status -- 账务状态
    ,open_date -- 开户日期
    ,prd_code -- 产品代码
    ,debit_account -- 认申购归集户
    ,debit_account_name -- 认申购归集户名
    ,crebit_account -- 基金赎回户
    ,crebit_account_name -- 基金赎回户名
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_no -- 客户号
    ,client_name -- 客户名称
    ,serial_no -- 交易流水
    ,trans_date -- 交易日期
    ,trans_time -- 交易时间
    ,trans_code -- 交易代码
    ,trans_name -- 交易代码名称
    ,branch_no -- 机构号
    ,in_client_no -- 内部客户号
    ,client_type -- 客户类型
    ,id_type -- 证件类型
    ,id_code -- 证件号码
    ,amt -- 交易金额
    ,vol -- 份额
    ,bank_acc -- 交易账号
    ,bank_name -- 开户行
    ,cnaps_code -- 大额行号
    ,channel -- 渠道
    ,curr_type -- 币种
    ,status -- 交易确认状态
    ,busin_code -- 业务码
    ,cfm_date -- 确认日期
    ,cfm_amt -- 确认金额
    ,cfm_vol -- 确认份额
    ,repr_name -- 法人代表姓名
    ,repr_id_type -- 法人代表证件类型
    ,repr_id_code -- 法人代表证件号码
    ,repr_mobile -- 法人代表手机号
    ,actor_name -- 经办人姓名
    ,actor_id_type -- 经办人证件类型
    ,actor_id_code -- 经办人证件号码
    ,actor_tel -- 经办人办公电话
    ,actor_mobile -- 经办人手机号
    ,square_no -- 清算流水
    ,seq_no -- 清算序号
    ,square_date -- 清算日期
    ,old_square_date -- 旧清算日期
    ,liqu_dir -- 账务方向
    ,square_amt -- 入账金额
    ,frozen_amt -- 冻结金额
    ,square_status -- 流水状态
    ,deal_status -- 账务状态
    ,open_date -- 开户日期
    ,prd_code -- 产品代码
    ,debit_account -- 认申购归集户
    ,debit_account_name -- 认申购归集户名
    ,crebit_account -- 基金赎回户
    ,crebit_account_name -- 基金赎回户名
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nfss_v_interbank_transreq
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nfss_v_interbank_transreq exchange partition p_${batch_date} with table ${iol_schema}.nfss_v_interbank_transreq_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_v_interbank_transreq to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nfss_v_interbank_transreq_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_v_interbank_transreq',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);