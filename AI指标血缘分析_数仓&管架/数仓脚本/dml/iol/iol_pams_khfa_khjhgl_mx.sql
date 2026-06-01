/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_khfa_khjhgl_mx
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
drop table ${iol_schema}.pams_khfa_khjhgl_mx_ex purge;
alter table ${iol_schema}.pams_khfa_khjhgl_mx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.pams_khfa_khjhgl_mx;

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_khfa_khjhgl_mx_ex nologging
compress
as
select * from ${iol_schema}.pams_khfa_khjhgl_mx where 0=1;

insert /*+ append */ into ${iol_schema}.pams_khfa_khjhgl_mx_ex(
    mxfabh -- 明细方案编号
    ,fabh -- 方案编号
    ,khnf -- 考核年份
    ,jhmc -- 计划名称
    ,khdx -- 考核对象
    ,lrry -- 录入人员
    ,lrsj -- 录入时间
    ,jgkhdxdh -- 机构考核对象代号
    ,hykhdxdh -- 行员考核对象代号
    ,khzbdh -- 考核指标代号
    ,dw -- 单位
    ,dbjs -- 对比基数
    ,ndmbzone -- 年度目标值1
    ,ndmbztwo -- 年度目标值2
    ,ndmbzthree -- 年度目标值3
    ,zlddzone -- 总量达到值1
    ,zlddztwo -- 总量达到值2
    ,zlddzthree -- 总量达到值3
    ,janone -- 月度目标值_一月目标值1
    ,jantwo -- 月度目标值_一月目标值2
    ,janthree -- 月度目标值_一月目标值3
    ,febone -- 月度目标值_二月目标值1
    ,febtwo -- 月度目标值_二月目标值2
    ,febthree -- 月度目标值_二月目标值3
    ,marone -- 月度目标值_三月目标值1
    ,martwo -- 月度目标值_三月目标值2
    ,marthree -- 月度目标值_三月目标值3
    ,aprone -- 月度目标值_四月目标值1
    ,aprtwo -- 月度目标值_四月目标值2
    ,aprthree -- 月度目标值_四月目标值3
    ,mayone -- 月度目标值_五月目标值1
    ,maytwo -- 月度目标值_五月目标值2
    ,maythree -- 月度目标值_五月目标值3
    ,junone -- 月度目标值_六月目标值1
    ,juntwo -- 月度目标值_六月目标值2
    ,junthree -- 月度目标值_六月目标值3
    ,julone -- 月度目标值_七月目标值1
    ,jultwo -- 月度目标值_七月目标值2
    ,julthree -- 月度目标值_七月目标值3
    ,augone -- 月度目标值_八月目标值1
    ,augtwo -- 月度目标值_八月目标值2
    ,augthree -- 月度目标值_八月目标值3
    ,septone -- 月度目标值_九月目标值1
    ,septtwo -- 月度目标值_九月目标值2
    ,septthree -- 月度目标值_九月目标值3
    ,octone -- 月度目标值_十月目标值1
    ,octtwo -- 月度目标值_十月目标值2
    ,octthree -- 月度目标值_十月目标值3
    ,novone -- 月度目标值_十一月目标值1
    ,novtwo -- 月度目标值_十一月目标值2
    ,novthree -- 月度目标值_十一月目标值3
    ,decone -- 月度目标值_十二月目标值1
    ,dectwo -- 月度目标值_十二月目标值2
    ,decthree -- 月度目标值_十二月目标值3
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    mxfabh -- 明细方案编号
    ,fabh -- 方案编号
    ,khnf -- 考核年份
    ,jhmc -- 计划名称
    ,khdx -- 考核对象
    ,lrry -- 录入人员
    ,lrsj -- 录入时间
    ,jgkhdxdh -- 机构考核对象代号
    ,hykhdxdh -- 行员考核对象代号
    ,khzbdh -- 考核指标代号
    ,dw -- 单位
    ,dbjs -- 对比基数
    ,ndmbzone -- 年度目标值1
    ,ndmbztwo -- 年度目标值2
    ,ndmbzthree -- 年度目标值3
    ,zlddzone -- 总量达到值1
    ,zlddztwo -- 总量达到值2
    ,zlddzthree -- 总量达到值3
    ,janone -- 月度目标值_一月目标值1
    ,jantwo -- 月度目标值_一月目标值2
    ,janthree -- 月度目标值_一月目标值3
    ,febone -- 月度目标值_二月目标值1
    ,febtwo -- 月度目标值_二月目标值2
    ,febthree -- 月度目标值_二月目标值3
    ,marone -- 月度目标值_三月目标值1
    ,martwo -- 月度目标值_三月目标值2
    ,marthree -- 月度目标值_三月目标值3
    ,aprone -- 月度目标值_四月目标值1
    ,aprtwo -- 月度目标值_四月目标值2
    ,aprthree -- 月度目标值_四月目标值3
    ,mayone -- 月度目标值_五月目标值1
    ,maytwo -- 月度目标值_五月目标值2
    ,maythree -- 月度目标值_五月目标值3
    ,junone -- 月度目标值_六月目标值1
    ,juntwo -- 月度目标值_六月目标值2
    ,junthree -- 月度目标值_六月目标值3
    ,julone -- 月度目标值_七月目标值1
    ,jultwo -- 月度目标值_七月目标值2
    ,julthree -- 月度目标值_七月目标值3
    ,augone -- 月度目标值_八月目标值1
    ,augtwo -- 月度目标值_八月目标值2
    ,augthree -- 月度目标值_八月目标值3
    ,septone -- 月度目标值_九月目标值1
    ,septtwo -- 月度目标值_九月目标值2
    ,septthree -- 月度目标值_九月目标值3
    ,octone -- 月度目标值_十月目标值1
    ,octtwo -- 月度目标值_十月目标值2
    ,octthree -- 月度目标值_十月目标值3
    ,novone -- 月度目标值_十一月目标值1
    ,novtwo -- 月度目标值_十一月目标值2
    ,novthree -- 月度目标值_十一月目标值3
    ,decone -- 月度目标值_十二月目标值1
    ,dectwo -- 月度目标值_十二月目标值2
    ,decthree -- 月度目标值_十二月目标值3
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_khfa_khjhgl_mx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_khfa_khjhgl_mx exchange partition p_${batch_date} with table ${iol_schema}.pams_khfa_khjhgl_mx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_khfa_khjhgl_mx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_khfa_khjhgl_mx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_khfa_khjhgl_mx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);