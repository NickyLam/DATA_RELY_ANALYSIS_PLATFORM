/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_rdl_idx_indx_data
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
--alter table ${itl_schema}.mtl_rdl_idx_indx_data drop partition p_${retain_day};
alter table ${itl_schema}.mtl_rdl_idx_indx_data drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_rdl_idx_indx_data add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_rdl_idx_indx_data partition for (to_date('${batch_date}','yyyymmdd')) (
    indx_no -- 指标编号
    ,org_no -- 机构编号
    ,curr_cd -- 币种代码
    ,indx_dimen_no -- 指标维度编号
    ,indx_dimen_cd -- 指标维度代码
    ,stat_ped_cd -- 统计周期代码
    ,indx_val -- 指标值
    ,comp_ear_year_val -- 与年初比
    ,comp_same_term_val -- 与同期比
    ,comp_last_mon_val -- 与上月比
    ,comp_last_qua_val -- 与上季比
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
    ,biz_strip_line_cd -- 业务条线代码
    ,index_measure -- 指标度量
)
select
    nvl(trim(indx_no), ' ') as indx_no -- 指标编号
    ,nvl(trim(org_no), ' ') as org_no -- 机构编号
    ,nvl(trim(curr_cd), ' ') as curr_cd -- 币种代码
    ,nvl(trim(indx_dimen_no), ' ') as indx_dimen_no -- 指标维度编号
    ,nvl(trim(indx_dimen_cd), ' ') as indx_dimen_cd -- 指标维度代码
    ,nvl(trim(stat_ped_cd), ' ') as stat_ped_cd -- 统计周期代码
    ,nvl(trim(indx_val), 0) as indx_val -- 指标值
    ,nvl(trim(comp_ear_year_val), 0) as comp_ear_year_val -- 与年初比
    ,nvl(trim(comp_same_term_val), 0) as comp_same_term_val -- 与同期比
    ,nvl(trim(comp_last_mon_val), 0) as comp_last_mon_val -- 与上月比
    ,nvl(trim(comp_last_qua_val), 0) as comp_last_qua_val -- 与上季比
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
    ,nvl(trim(biz_strip_line_cd), ' ') as biz_strip_line_cd -- 业务条线代码
    ,nvl(trim(index_measure), ' ') as index_measure -- 指标度量
   from ${msl_schema}.msl_rdl_idx_indx_data
where 1 = 1
--AND  etl_dt = last_day(etl_dt) --只装月末数据
AND  etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_rdl_idx_indx_data to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_rdl_idx_indx_data',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);