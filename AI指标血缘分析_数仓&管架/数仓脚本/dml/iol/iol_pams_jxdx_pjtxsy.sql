/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_pjtxsy
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
drop table ${iol_schema}.pams_jxdx_pjtxsy_ex purge;
alter table ${iol_schema}.pams_jxdx_pjtxsy add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxdx_pjtxsy truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxdx_pjtxsy_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_pjtxsy where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxdx_pjtxsy_ex(
    tjrq -- 统计日期
    ,zhdh -- 账户代号
    ,pch -- 批次号
    ,jgdh -- 机构代号
    ,pjh -- 票据号
    ,zqjh -- 子区间号
    ,pmje -- 票面金额
    ,txsqr -- 贴现申请人
    ,txll -- 贴现利率
    ,txrq -- 贴现日期
    ,dqrq -- 到期日期
    ,txlxsr -- 贴现利息收入
    ,ldjg -- 联动机构
    ,ldll -- 联动利率
    ,zhfpsy -- 总行分配收益
    ,fhfpsy -- 分行分配收益
    ,tzjjx -- 调整加减项
    ,zhtzhsy -- 总行调整后收益
    ,fhtzhsy -- 分行调整后收益
    ,shtxlxsr -- 税后贴现利息收入
    ,cprmc -- 出票人名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,zhdh -- 账户代号
    ,pch -- 批次号
    ,jgdh -- 机构代号
    ,pjh -- 票据号
    ,zqjh -- 子区间号
    ,pmje -- 票面金额
    ,txsqr -- 贴现申请人
    ,txll -- 贴现利率
    ,txrq -- 贴现日期
    ,dqrq -- 到期日期
    ,txlxsr -- 贴现利息收入
    ,ldjg -- 联动机构
    ,ldll -- 联动利率
    ,zhfpsy -- 总行分配收益
    ,fhfpsy -- 分行分配收益
    ,tzjjx -- 调整加减项
    ,zhtzhsy -- 总行调整后收益
    ,fhtzhsy -- 分行调整后收益
    ,shtxlxsr -- 税后贴现利息收入
    ,cprmc -- 出票人名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxdx_pjtxsy
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxdx_pjtxsy exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_pjtxsy_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_pjtxsy to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxdx_pjtxsy_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_pjtxsy',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);