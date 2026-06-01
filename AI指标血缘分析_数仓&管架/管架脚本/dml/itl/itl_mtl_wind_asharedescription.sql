/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_wind_asharedescription
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
-- alter table ${itl_schema}.mtl_wind_asharedescription drop partition p_${retain_day};
alter table ${itl_schema}.mtl_wind_asharedescription drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_wind_asharedescription add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_wind_asharedescription partition for (to_date('${batch_date}','yyyymmdd')) (
     object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,s_info_code -- 交易代码
    ,s_info_name -- 证券简称
    ,s_info_compname -- 公司中文名称
    ,s_info_compnameeng -- 公司英文名称
    ,s_info_isincode -- ISIN代码
    ,s_info_exchmarket -- 交易所
    ,s_info_listboard -- 上市板类型
    ,s_info_listdate -- 上市日期
    ,s_info_delistdate -- 退市日期
    ,s_info_sedolcode -- 
    ,crncy_code -- 货币代码
    ,s_info_pinyin -- 简称拼音
    ,s_info_listboardname -- 上市板
    ,is_shsc -- 是否在沪股通或深港通范围内
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
     nvl(trim(object_id), ' ') as object_id -- 对象ID
    ,nvl(trim(s_info_windcode), ' ') as s_info_windcode -- Wind代码
    ,nvl(trim(s_info_code), ' ') as s_info_code -- 交易代码
    ,nvl(trim(s_info_name), ' ') as s_info_name -- 证券简称
    ,nvl(trim(s_info_compname), ' ') as s_info_compname -- 公司中文名称
    ,nvl(trim(s_info_compnameeng), ' ') as s_info_compnameeng -- 公司英文名称
    ,nvl(trim(s_info_isincode), ' ') as s_info_isincode -- ISIN代码
    ,nvl(trim(s_info_exchmarket), ' ') as s_info_exchmarket -- 交易所
    ,nvl(trim(s_info_listboard), ' ') as s_info_listboard -- 上市板类型
    ,nvl(trim(s_info_listdate), ' ') as s_info_listdate -- 上市日期
    ,nvl(trim(s_info_delistdate), ' ') as s_info_delistdate -- 退市日期
    ,nvl(trim(s_info_sedolcode), ' ') as s_info_sedolcode -- 
    ,nvl(trim(crncy_code), ' ') as crncy_code -- 货币代码
    ,nvl(trim(s_info_pinyin), ' ') as s_info_pinyin -- 简称拼音
    ,nvl(trim(s_info_listboardname), ' ') as s_info_listboardname -- 上市板
    ,nvl(trim(is_shsc), 0) as is_shsc -- 是否在沪股通或深港通范围内
    ,nvl(start_dt, null) as start_dt -- 开始时间
    ,nvl(end_dt, null) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_wind_asharedescription
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_wind_asharedescription to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_wind_asharedescription',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);