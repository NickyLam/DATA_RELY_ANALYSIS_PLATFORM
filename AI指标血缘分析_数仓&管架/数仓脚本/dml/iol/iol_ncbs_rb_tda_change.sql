/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_tda_change
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
drop table ${iol_schema}.ncbs_rb_tda_change_ex purge;
alter table ${iol_schema}.ncbs_rb_tda_change add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_tda_change truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_tda_change_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_tda_change where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_tda_change_ex(
    client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,user_id -- 交易柜员编号
    ,term -- 存期
    ,term_type -- 期限单位
    ,change_tda_seq_no -- 存期变更交易序号
    ,change_tda_status -- 存期变更状态
    ,company -- 法人
    ,tda_change_type -- 存期变更类型
    ,maturity_date -- 到期日期
    ,new_maturity_date -- 新到期日
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,new_term -- 新期限
    ,new_term_type -- 新存期类型
    ,tran_branch -- 核心交易机构编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,user_id -- 交易柜员编号
    ,term -- 存期
    ,term_type -- 期限单位
    ,change_tda_seq_no -- 存期变更交易序号
    ,change_tda_status -- 存期变更状态
    ,company -- 法人
    ,tda_change_type -- 存期变更类型
    ,maturity_date -- 到期日期
    ,new_maturity_date -- 新到期日
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,new_term -- 新期限
    ,new_term_type -- 新存期类型
    ,tran_branch -- 核心交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_tda_change
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_tda_change exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_tda_change_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_tda_change to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_tda_change_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_tda_change',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);