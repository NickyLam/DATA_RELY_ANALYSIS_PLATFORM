/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_gl059660
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
drop table ${iol_schema}.isbs_gl059660_ex purge;
alter table ${iol_schema}.isbs_gl059660 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.isbs_gl059660 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.isbs_gl059660_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_gl059660 where 0=1;

insert /*+ append */ into ${iol_schema}.isbs_gl059660_ex(
    inr -- 主键
    ,trninr -- TRN表INR
    ,credattim -- 创建日期
    ,seq -- 序号
    ,base_acct_no -- 账号
    ,acct_seq_no -- 序列号
    ,branch -- 所属机构
    ,tran_type -- 实体关键字
    ,ccy -- 币种
    ,tran_amt -- 金额
    ,tran_branch -- 交易机构
    ,company -- 内部唯一ID
    ,system_id -- 系统ID
    ,event_type -- 事件类型
    ,amt_type -- 金额类型
    ,tran_date -- 业务交易日期
    ,write_off_seq_no -- 销账序号
    ,narrative -- 摘要
    ,is_northbound_sign -- 是否北向通账号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    inr -- 主键
    ,trninr -- TRN表INR
    ,credattim -- 创建日期
    ,seq -- 序号
    ,base_acct_no -- 账号
    ,acct_seq_no -- 序列号
    ,branch -- 所属机构
    ,tran_type -- 实体关键字
    ,ccy -- 币种
    ,tran_amt -- 金额
    ,tran_branch -- 交易机构
    ,company -- 内部唯一ID
    ,system_id -- 系统ID
    ,event_type -- 事件类型
    ,amt_type -- 金额类型
    ,tran_date -- 业务交易日期
    ,write_off_seq_no -- 销账序号
    ,narrative -- 摘要
    ,is_northbound_sign -- 是否北向通账号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.isbs_gl059660
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.isbs_gl059660 exchange partition p_${batch_date} with table ${iol_schema}.isbs_gl059660_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_gl059660 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.isbs_gl059660_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_gl059660',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);