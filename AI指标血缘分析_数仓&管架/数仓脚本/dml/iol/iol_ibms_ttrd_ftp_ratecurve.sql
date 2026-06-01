/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_ftp_ratecurve
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
drop table ${iol_schema}.ibms_ttrd_ftp_ratecurve_ex purge;
alter table ${iol_schema}.ibms_ttrd_ftp_ratecurve add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ibms_ttrd_ftp_ratecurve truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_ftp_ratecurve_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_ftp_ratecurve where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_ftp_ratecurve_ex(
    status -- 状态0-未生效1-已生效
    ,value_date -- 数据日期
    ,curve_no -- 曲线编号
    ,curve_name -- 曲线名称
    ,rate_1d -- 1日(%)
    ,rate_7d -- 7日(%)
    ,rate_14d -- 14日(%)
    ,rate_21d -- 21日(%)
    ,rate_1m -- 1月(%)
    ,rate_3m -- 3月(%)
    ,rate_6m -- 6月(%)
    ,rate_9m -- 9月(%)
    ,rate_1y -- 1年(%)
    ,update_user -- 更新人
    ,effect_time -- 生效时间
    ,update_user_id -- 更新人id
    ,current_rate -- 跨月活期利率
    ,notrans_current_rate -- 不跨月活期利率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    status -- 状态0-未生效1-已生效
    ,value_date -- 数据日期
    ,curve_no -- 曲线编号
    ,curve_name -- 曲线名称
    ,rate_1d -- 1日(%)
    ,rate_7d -- 7日(%)
    ,rate_14d -- 14日(%)
    ,rate_21d -- 21日(%)
    ,rate_1m -- 1月(%)
    ,rate_3m -- 3月(%)
    ,rate_6m -- 6月(%)
    ,rate_9m -- 9月(%)
    ,rate_1y -- 1年(%)
    ,update_user -- 更新人
    ,effect_time -- 生效时间
    ,update_user_id -- 更新人id
    ,current_rate -- 跨月活期利率
    ,notrans_current_rate -- 不跨月活期利率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_ftp_ratecurve
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_ftp_ratecurve exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_ftp_ratecurve_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_ftp_ratecurve to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_ftp_ratecurve_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_ftp_ratecurve',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);