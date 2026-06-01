/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_crdtbond_timelimit_dtl
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
drop table ${iol_schema}.ctms_crdtbond_timelimit_dtl_ex purge;
alter table ${iol_schema}.ctms_crdtbond_timelimit_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ctms_crdtbond_timelimit_dtl truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ctms_crdtbond_timelimit_dtl_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_crdtbond_timelimit_dtl where 0=1;

insert /*+ append */ into ${iol_schema}.ctms_crdtbond_timelimit_dtl_ex(
    settledate -- 数据日期
    ,src_trd_id -- 系统编号
    ,currency -- 币种
    ,limit_name -- 限额类型
    ,portfolio_id -- 投组编号
    ,portfolio_name -- 投组名称
    ,bondscode -- 债券代码
    ,bondsname -- 债券名称
    ,bondstype -- 债券类别
    ,occupy_value -- 买入金额
    ,sum_occupy_value -- 累计买入金额
    ,balance -- 余额
    ,maturity_date -- 到期日
    ,trade_date -- 交易日
    ,sec_maturity_date -- 180天到期日
    ,sec_term_to_maturity -- 180天剩余有效期限
    ,thd_maturity_date -- 30天到期日
    ,thd_term_to_maturity -- 30天剩余有效期限
    ,dmp_time -- 创建时间戳
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    settledate -- 数据日期
    ,src_trd_id -- 系统编号
    ,currency -- 币种
    ,limit_name -- 限额类型
    ,portfolio_id -- 投组编号
    ,portfolio_name -- 投组名称
    ,bondscode -- 债券代码
    ,bondsname -- 债券名称
    ,bondstype -- 债券类别
    ,occupy_value -- 买入金额
    ,sum_occupy_value -- 累计买入金额
    ,balance -- 余额
    ,maturity_date -- 到期日
    ,trade_date -- 交易日
    ,sec_maturity_date -- 180天到期日
    ,sec_term_to_maturity -- 180天剩余有效期限
    ,thd_maturity_date -- 30天到期日
    ,thd_term_to_maturity -- 30天剩余有效期限
    ,dmp_time -- 创建时间戳
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ctms_crdtbond_timelimit_dtl
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ctms_crdtbond_timelimit_dtl exchange partition p_${batch_date} with table ${iol_schema}.ctms_crdtbond_timelimit_dtl_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_crdtbond_timelimit_dtl to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ctms_crdtbond_timelimit_dtl_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_crdtbond_timelimit_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);