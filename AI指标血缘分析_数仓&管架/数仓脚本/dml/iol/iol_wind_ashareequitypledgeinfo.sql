/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_ashareequitypledgeinfo
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
drop table ${iol_schema}.wind_ashareequitypledgeinfo_ex purge;
alter table ${iol_schema}.wind_ashareequitypledgeinfo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.wind_ashareequitypledgeinfo;

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_ashareequitypledgeinfo_ex nologging
compress
as
select * from ${iol_schema}.wind_ashareequitypledgeinfo where 0=1;

insert /*+ append */ into ${iol_schema}.wind_ashareequitypledgeinfo_ex(
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,ann_dt -- 公告日期
    ,s_pledge_bgdate -- 质押起始时间
    ,s_pledge_enddate -- 质押结束时间
    ,s_holder_name -- 股东名称
    ,s_pledge_shares -- 质押数量(万股)
    ,s_pledgor -- 质押方
    ,s_discharge_date -- 解押日期
    ,s_remark -- 备注
    ,is_discharge -- 是否解押
    ,s_holder_type_code -- 股东类型代码
    ,s_holder_id -- 股东ID
    ,s_pledgor_type_code -- 质押方类型代码
    ,s_pledgor_id -- 质押方ID
    ,s_shr_category_code -- 股份性质类别代码
    ,s_total_holding_shr -- 持股总数
    ,s_total_pledge_shr -- 累计质押股数
    ,s_pledge_shr_ratio -- 本次质押股数占公司总股本比例
    ,s_total_holding_shr_ratio -- 持股总数占公司总股本比例
    ,is_equity_pledge_repo -- 是否股权质押回购
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,ann_dt -- 公告日期
    ,s_pledge_bgdate -- 质押起始时间
    ,s_pledge_enddate -- 质押结束时间
    ,s_holder_name -- 股东名称
    ,s_pledge_shares -- 质押数量(万股)
    ,s_pledgor -- 质押方
    ,s_discharge_date -- 解押日期
    ,s_remark -- 备注
    ,is_discharge -- 是否解押
    ,s_holder_type_code -- 股东类型代码
    ,s_holder_id -- 股东ID
    ,s_pledgor_type_code -- 质押方类型代码
    ,s_pledgor_id -- 质押方ID
    ,s_shr_category_code -- 股份性质类别代码
    ,s_total_holding_shr -- 持股总数
    ,s_total_pledge_shr -- 累计质押股数
    ,s_pledge_shr_ratio -- 本次质押股数占公司总股本比例
    ,s_total_holding_shr_ratio -- 持股总数占公司总股本比例
    ,is_equity_pledge_repo -- 是否股权质押回购
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_ashareequitypledgeinfo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_ashareequitypledgeinfo exchange partition p_${batch_date} with table ${iol_schema}.wind_ashareequitypledgeinfo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_ashareequitypledgeinfo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_ashareequitypledgeinfo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_ashareequitypledgeinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);