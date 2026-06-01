/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_fdl_idx_index_def
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
-- alter table ${itl_schema}.mtl_fdl_idx_index_def drop partition p_${retain_day}; 20200901去除删除策略，保留全部
alter table ${itl_schema}.mtl_fdl_idx_index_def drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_fdl_idx_index_def add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_fdl_idx_index_def partition for (to_date('${batch_date}','yyyymmdd')) (
    index_int_id -- 指标内部ID
    ,index_num -- 指标编号
    ,index_name -- 指标名称
    ,index_desc -- 指标描述
    ,index_bclass -- 指标大类
    ,index_level1_class -- 指标一级分类
    ,index_level2_class -- 指标二级分类
    ,index_level3_class -- 指标三级分类
    ,index_measure -- 指标度量
    ,index_deriv_measure -- 指标衍生度量
    ,data_attr -- 数值属性
    ,index_dim -- 指标维度
    ,measure_unit -- 度量单位
    ,stat_period -- 统计周期
    ,data_format -- 数据格式
    ,prod_mode -- 产生方式
    ,biz_cali -- 业务口径
    ,tech_cali -- 技术口径
    ,issue_range -- 发布范围
    ,main_sys -- 主系统
    ,warn_val -- 预警值
    ,alarm_val -- 报警值
    ,owner -- 所有者
    ,write_person -- 填写人
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,matn_person -- 维护人
    ,matn_dt -- 维护日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(index_int_id), ' ') as index_int_id -- 指标内部ID
    ,nvl(trim(index_num), ' ') as index_num -- 指标编号
    ,nvl(trim(index_name), ' ') as index_name -- 指标名称
    ,nvl(trim(index_desc), ' ') as index_desc -- 指标描述
    ,nvl(trim(index_bclass), ' ') as index_bclass -- 指标大类
    ,nvl(trim(index_level1_class), ' ') as index_level1_class -- 指标一级分类
    ,nvl(trim(index_level2_class), ' ') as index_level2_class -- 指标二级分类
    ,nvl(trim(index_level3_class), ' ') as index_level3_class -- 指标三级分类
    ,nvl(trim(index_measure), ' ') as index_measure -- 指标度量
    ,nvl(trim(index_deriv_measure), ' ') as index_deriv_measure -- 指标衍生度量
    ,nvl(trim(data_attr), ' ') as data_attr -- 数值属性
    ,nvl(trim(index_dim), ' ') as index_dim -- 指标维度
    ,nvl(trim(measure_unit), ' ') as measure_unit -- 度量单位
    ,nvl(trim(stat_period), ' ') as stat_period -- 统计周期
    ,nvl(trim(data_format), ' ') as data_format -- 数据格式
    ,nvl(trim(prod_mode), ' ') as prod_mode -- 产生方式
    ,nvl(trim(biz_cali), ' ') as biz_cali -- 业务口径
    ,nvl(trim(tech_cali), ' ') as tech_cali -- 技术口径
    ,nvl(trim(issue_range), ' ') as issue_range -- 发布范围
    ,nvl(trim(main_sys), ' ') as main_sys -- 主系统
    ,nvl(trim(warn_val), ' ') as warn_val -- 预警值
    ,nvl(trim(alarm_val), ' ') as alarm_val -- 报警值
    ,nvl(trim(owner), ' ') as owner -- 所有者
    ,nvl(trim(write_person), ' ') as write_person -- 填写人
    ,nvl(effect_dt, null) as effect_dt -- 生效日期
    ,nvl(invalid_dt, null) as invalid_dt -- 失效日期
    ,nvl(trim(matn_person), ' ') as matn_person -- 维护人
    ,nvl(matn_dt, null) as matn_dt -- 维护日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_fdl_idx_index_def
where 1 = 1
 and etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_fdl_idx_index_def to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_fdl_idx_index_def',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);