/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_ashareequfroinfo
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
drop table ${iol_schema}.wind_ashareequfroinfo_ex purge;
alter table ${iol_schema}.wind_ashareequfroinfo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_ashareequfroinfo truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_ashareequfroinfo_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareequfroinfo where 0=1;

insert /*+ append */ into ${iol_schema}.wind_ashareequfroinfo_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,ann_date -- 公告日期
    ,s_fro_bgdate -- 冻结起始时间
    ,s_fro_enddate -- 冻结结束时间
    ,s_holder_name -- 股东名称
    ,s_fro_shares -- 冻结数量(万股)
    ,frozen_institution -- 执行冻结机构
    ,disfrozen_time -- 解冻日期
    ,s_holder_type_code -- 股东类型代码
    ,s_holder_id -- 股东ID
    ,shr_category_code -- 股份性质类别代码
    ,is_turn_frozen -- 是否轮候冻结
    ,is_disfrozen -- 是否解冻
    ,s_total_holding_shr -- 持股总数（万股）
    ,s_fro_shr_ratio -- 本次冻结股数占公司总股本比例
    ,s_total_holding_shr_ratio -- 持股总数占公司总股本比例
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,ann_date -- 公告日期
    ,s_fro_bgdate -- 冻结起始时间
    ,s_fro_enddate -- 冻结结束时间
    ,s_holder_name -- 股东名称
    ,s_fro_shares -- 冻结数量(万股)
    ,frozen_institution -- 执行冻结机构
    ,disfrozen_time -- 解冻日期
    ,s_holder_type_code -- 股东类型代码
    ,s_holder_id -- 股东ID
    ,shr_category_code -- 股份性质类别代码
    ,is_turn_frozen -- 是否轮候冻结
    ,is_disfrozen -- 是否解冻
    ,s_total_holding_shr -- 持股总数（万股）
    ,s_fro_shr_ratio -- 本次冻结股数占公司总股本比例
    ,s_total_holding_shr_ratio -- 持股总数占公司总股本比例
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_ashareequfroinfo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_ashareequfroinfo exchange partition p_${batch_date} with table ${iol_schema}.wind_ashareequfroinfo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_ashareequfroinfo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_ashareequfroinfo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_ashareequfroinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);