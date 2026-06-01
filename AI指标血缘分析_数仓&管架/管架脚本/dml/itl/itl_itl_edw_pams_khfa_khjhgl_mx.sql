/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pams_khfa_khjhgl_mx
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_pams_khfa_khjhgl_mx drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pams_khfa_khjhgl_mx drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pams_khfa_khjhgl_mx add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pams_khfa_khjhgl_mx partition for (to_date('${batch_date}','yyyymmdd')) (
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
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(mxfabh), 0) as mxfabh -- 明细方案编号
    ,nvl(trim(fabh), 0) as fabh -- 方案编号
    ,nvl(trim(khnf), 0) as khnf -- 考核年份
    ,nvl(trim(jhmc), ' ') as jhmc -- 计划名称
    ,nvl(trim(khdx), ' ') as khdx -- 考核对象
    ,nvl(trim(lrry), 0) as lrry -- 录入人员
    ,nvl(lrsj, to_timestamp('00010101', 'yyyymmdd')) as lrsj -- 录入时间
    ,nvl(trim(jgkhdxdh), 0) as jgkhdxdh -- 机构考核对象代号
    ,nvl(trim(hykhdxdh), 0) as hykhdxdh -- 行员考核对象代号
    ,nvl(trim(khzbdh), ' ') as khzbdh -- 考核指标代号
    ,nvl(trim(dw), ' ') as dw -- 单位
    ,nvl(trim(dbjs), 0) as dbjs -- 对比基数
    ,nvl(trim(ndmbzone), 0) as ndmbzone -- 年度目标值1
    ,nvl(trim(ndmbztwo), 0) as ndmbztwo -- 年度目标值2
    ,nvl(trim(ndmbzthree), 0) as ndmbzthree -- 年度目标值3
    ,nvl(trim(zlddzone), 0) as zlddzone -- 总量达到值1
    ,nvl(trim(zlddztwo), 0) as zlddztwo -- 总量达到值2
    ,nvl(trim(zlddzthree), 0) as zlddzthree -- 总量达到值3
    ,nvl(trim(janone), 0) as janone -- 月度目标值_一月目标值1
    ,nvl(trim(jantwo), 0) as jantwo -- 月度目标值_一月目标值2
    ,nvl(trim(janthree), 0) as janthree -- 月度目标值_一月目标值3
    ,nvl(trim(febone), 0) as febone -- 月度目标值_二月目标值1
    ,nvl(trim(febtwo), 0) as febtwo -- 月度目标值_二月目标值2
    ,nvl(trim(febthree), 0) as febthree -- 月度目标值_二月目标值3
    ,nvl(trim(marone), 0) as marone -- 月度目标值_三月目标值1
    ,nvl(trim(martwo), 0) as martwo -- 月度目标值_三月目标值2
    ,nvl(trim(marthree), 0) as marthree -- 月度目标值_三月目标值3
    ,nvl(trim(aprone), 0) as aprone -- 月度目标值_四月目标值1
    ,nvl(trim(aprtwo), 0) as aprtwo -- 月度目标值_四月目标值2
    ,nvl(trim(aprthree), 0) as aprthree -- 月度目标值_四月目标值3
    ,nvl(trim(mayone), 0) as mayone -- 月度目标值_五月目标值1
    ,nvl(trim(maytwo), 0) as maytwo -- 月度目标值_五月目标值2
    ,nvl(trim(maythree), 0) as maythree -- 月度目标值_五月目标值3
    ,nvl(trim(junone), 0) as junone -- 月度目标值_六月目标值1
    ,nvl(trim(juntwo), 0) as juntwo -- 月度目标值_六月目标值2
    ,nvl(trim(junthree), 0) as junthree -- 月度目标值_六月目标值3
    ,nvl(trim(julone), 0) as julone -- 月度目标值_七月目标值1
    ,nvl(trim(jultwo), 0) as jultwo -- 月度目标值_七月目标值2
    ,nvl(trim(julthree), 0) as julthree -- 月度目标值_七月目标值3
    ,nvl(trim(augone), 0) as augone -- 月度目标值_八月目标值1
    ,nvl(trim(augtwo), 0) as augtwo -- 月度目标值_八月目标值2
    ,nvl(trim(augthree), 0) as augthree -- 月度目标值_八月目标值3
    ,nvl(trim(septone), 0) as septone -- 月度目标值_九月目标值1
    ,nvl(trim(septtwo), 0) as septtwo -- 月度目标值_九月目标值2
    ,nvl(trim(septthree), 0) as septthree -- 月度目标值_九月目标值3
    ,nvl(trim(octone), 0) as octone -- 月度目标值_十月目标值1
    ,nvl(trim(octtwo), 0) as octtwo -- 月度目标值_十月目标值2
    ,nvl(trim(octthree), 0) as octthree -- 月度目标值_十月目标值3
    ,nvl(trim(novone), 0) as novone -- 月度目标值_十一月目标值1
    ,nvl(trim(novtwo), 0) as novtwo -- 月度目标值_十一月目标值2
    ,nvl(trim(novthree), 0) as novthree -- 月度目标值_十一月目标值3
    ,nvl(trim(decone), 0) as decone -- 月度目标值_十二月目标值1
    ,nvl(trim(dectwo), 0) as dectwo -- 月度目标值_十二月目标值2
    ,nvl(trim(decthree), 0) as decthree -- 月度目标值_十二月目标值3
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pams_khfa_khjhgl_mx
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pams_khfa_khjhgl_mx to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pams_khfa_khjhgl_mx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);