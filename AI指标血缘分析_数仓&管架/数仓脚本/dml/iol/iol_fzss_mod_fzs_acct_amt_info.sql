/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fzss_mod_fzs_acct_amt_info
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
drop table ${iol_schema}.fzss_mod_fzs_acct_amt_info_ex purge;
alter table ${iol_schema}.fzss_mod_fzs_acct_amt_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.fzss_mod_fzs_acct_amt_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.fzss_mod_fzs_acct_amt_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fzss_mod_fzs_acct_amt_info where 0=1;

insert /*+ append */ into ${iol_schema}.fzss_mod_fzs_acct_amt_info_ex(
    data_date -- 数据日期
    ,corp_id -- 平台商户号
    ,sub_acct_no -- 子账号 账号格式 对私：623627+01+序号+1位验证位 对公：暂定开头8
    ,mybank -- 法人标识代码
    ,zone_no -- 分行号
    ,sub_acct_nm -- 子账户名称
    ,acct_cls -- 子账号类别 [枚举: 01 -二级商户子账号、02-功能户]
    ,cust_type -- 客户类型 [枚举: 1-对私,2-对公]
    ,acct_status -- 账户状态 [枚举: A-正常,C-关闭,D-不动户,H-待激活,I-预开户,N-新建,数据字典：CD04011]
    ,balance -- 总余额 [枚举: 总余额]
    ,cash_amt -- 可提余额 [枚举: 清算后的余额]
    ,freeze_amt -- 冻结余额
    ,outstanding_amt -- 待清算余额
    ,create_timestamp -- 创建时间戳
    ,update_timestamp -- 更新时间戳
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_date -- 数据日期
    ,corp_id -- 平台商户号
    ,sub_acct_no -- 子账号 账号格式 对私：623627+01+序号+1位验证位 对公：暂定开头8
    ,mybank -- 法人标识代码
    ,zone_no -- 分行号
    ,sub_acct_nm -- 子账户名称
    ,acct_cls -- 子账号类别 [枚举: 01 -二级商户子账号、02-功能户]
    ,cust_type -- 客户类型 [枚举: 1-对私,2-对公]
    ,acct_status -- 账户状态 [枚举: A-正常,C-关闭,D-不动户,H-待激活,I-预开户,N-新建,数据字典：CD04011]
    ,balance -- 总余额 [枚举: 总余额]
    ,cash_amt -- 可提余额 [枚举: 清算后的余额]
    ,freeze_amt -- 冻结余额
    ,outstanding_amt -- 待清算余额
    ,create_timestamp -- 创建时间戳
    ,update_timestamp -- 更新时间戳
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.fzss_mod_fzs_acct_amt_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.fzss_mod_fzs_acct_amt_info exchange partition p_${batch_date} with table ${iol_schema}.fzss_mod_fzs_acct_amt_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fzss_mod_fzs_acct_amt_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.fzss_mod_fzs_acct_amt_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fzss_mod_fzs_acct_amt_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);