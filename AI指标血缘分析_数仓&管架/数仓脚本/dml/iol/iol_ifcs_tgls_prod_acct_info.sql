/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifcs_tgls_prod_acct_info
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
drop table ${iol_schema}.ifcs_tgls_prod_acct_info_ex purge;
alter table ${iol_schema}.ifcs_tgls_prod_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifcs_tgls_prod_acct_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifcs_tgls_prod_acct_info_ex nologging
for exchange with table
${iol_schema}.ifcs_tgls_prod_acct_info;

insert /*+ append */ into ${iol_schema}.ifcs_tgls_prod_acct_info_ex(
    acctdt -- 账务日期
    ,acctno -- 协议编号
    ,systid -- 系统代号
    ,brchcd -- 账务机构编号
    ,prodcd -- 解析产品
    ,loanp1 -- 产品属性1
    ,loanp2 -- 产品属性2
    ,loanp3 -- 产品属性3
    ,loanp4 -- 产品属性4
    ,loanp5 -- 产品属性5
    ,loanp6 -- 产品属性6
    ,loanp7 -- 产品属性7
    ,loanp8 -- 产品属性8
    ,loanp9 -- 产品属性9
    ,loanpa -- 产品属性10
    ,trprcd -- 金额类型
    ,captal -- 余额
    ,crcycd -- 币种
    ,evetdn -- 交易方向
    ,tranam -- 交易金额
    ,assis1 -- 可售产品
    ,assis2 -- 辅助核算2
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acctdt -- 账务日期
    ,acctno -- 协议编号
    ,systid -- 系统代号
    ,brchcd -- 账务机构编号
    ,prodcd -- 解析产品
    ,loanp1 -- 产品属性1
    ,loanp2 -- 产品属性2
    ,loanp3 -- 产品属性3
    ,loanp4 -- 产品属性4
    ,loanp5 -- 产品属性5
    ,loanp6 -- 产品属性6
    ,loanp7 -- 产品属性7
    ,loanp8 -- 产品属性8
    ,loanp9 -- 产品属性9
    ,loanpa -- 产品属性10
    ,trprcd -- 金额类型
    ,captal -- 余额
    ,crcycd -- 币种
    ,evetdn -- 交易方向
    ,tranam -- 交易金额
    ,assis1 -- 可售产品
    ,assis2 -- 辅助核算2
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifcs_tgls_prod_acct_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifcs_tgls_prod_acct_info exchange partition p_${batch_date} with table ${iol_schema}.ifcs_tgls_prod_acct_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifcs_tgls_prod_acct_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifcs_tgls_prod_acct_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifcs_tgls_prod_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);