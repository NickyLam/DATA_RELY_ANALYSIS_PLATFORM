/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_ashareinsideholder
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
drop table ${iol_schema}.wind_ashareinsideholder_ex purge;
alter table ${iol_schema}.wind_ashareinsideholder add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.wind_ashareinsideholder;

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_ashareinsideholder_ex nologging
compress
as
select * from ${iol_schema}.wind_ashareinsideholder where 0=1;

insert /*+ append */ into ${iol_schema}.wind_ashareinsideholder_ex(
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,ann_dt -- 公告日期
    ,s_holder_enddate -- 截止日期
    ,s_holder_holdercategory -- 股东类型
    ,s_holder_name -- 股东名称
    ,s_holder_quantity -- 持股数量
    ,s_holder_pct -- 持股比例
    ,s_holder_sharecategory -- 持股性质代码
    ,s_holder_restrictedquantity -- 持有限售股份（非流通股）数量
    ,s_holder_aname -- 股东名称
    ,s_holder_sequence -- 关联方序号
    ,s_holder_sharecategoryname -- 持股性质
    ,s_holder_memo -- 股东说明
    ,opdate -- 
    ,opmode -- 
    ,s_info_compcode -- 股东公司ID
    ,report_period -- 报告期
    ,s_holder_nat -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,ann_dt -- 公告日期
    ,s_holder_enddate -- 截止日期
    ,s_holder_holdercategory -- 股东类型
    ,s_holder_name -- 股东名称
    ,s_holder_quantity -- 持股数量
    ,s_holder_pct -- 持股比例
    ,s_holder_sharecategory -- 持股性质代码
    ,s_holder_restrictedquantity -- 持有限售股份（非流通股）数量
    ,s_holder_aname -- 股东名称
    ,s_holder_sequence -- 关联方序号
    ,s_holder_sharecategoryname -- 持股性质
    ,s_holder_memo -- 股东说明
    ,opdate -- 
    ,opmode -- 
    ,s_info_compcode -- 股东公司ID
    ,report_period -- 报告期
    ,s_holder_nat -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_ashareinsideholder
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_ashareinsideholder exchange partition p_${batch_date} with table ${iol_schema}.wind_ashareinsideholder_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_ashareinsideholder to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_ashareinsideholder_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_ashareinsideholder',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);