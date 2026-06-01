/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_fdl_idx_index_data
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
-- alter table ${itl_schema}.mtl_fdl_idx_index_data drop partition p_${retain_day};  20200901去除删除策略，保留全部
alter table ${itl_schema}.mtl_fdl_idx_index_data drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_fdl_idx_index_data add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_fdl_idx_index_data partition for (to_date('${batch_date}','yyyymmdd')) (
    index_no -- 指标编号
    ,org_no -- 机构编号
    ,biz_strip_line_cd -- 业务条线代码
    ,dim_cd1 -- 维度代码1
    ,dim_cd2 -- 维度代码2
    ,dim_cd3 -- 维度代码3
    ,batch_freq -- 批次频度
    ,index_measure -- 指标度量
    ,curr_cd -- 币种代码
    ,index_val -- 指标值
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(index_no), ' ') as index_no -- 指标编号
    ,nvl(trim(org_no), ' ') as org_no -- 机构编号
    ,nvl(trim(biz_strip_line_cd), ' ') as biz_strip_line_cd -- 业务条线代码
    ,nvl(trim(dim_cd1), ' ') as dim_cd1 -- 维度代码1
    ,nvl(trim(dim_cd2), ' ') as dim_cd2 -- 维度代码2
    ,nvl(trim(dim_cd3), ' ') as dim_cd3 -- 维度代码3
    ,nvl(trim(batch_freq), ' ') as batch_freq -- 批次频度
    ,nvl(trim(index_measure), ' ') as index_measure -- 指标度量
    ,nvl(trim(curr_cd), ' ') as curr_cd -- 币种代码
    ,nvl(trim(index_val), 0) as index_val -- 指标值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_fdl_idx_index_data
where 1 = 1
 and etl_dt = to_date('${batch_date}','yyyymmdd') 
 and substr(index_no,1,2) <> 'JX'
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_fdl_idx_index_data to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_fdl_idx_index_data',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);