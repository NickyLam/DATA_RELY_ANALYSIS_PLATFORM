/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_alms_rp_alm_rrs_liquidity_report_result
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
--alter table ${itl_schema}.itl_edw_alms_rp_alm_rrs_liquidity_report_result drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_alms_rp_alm_rrs_liquidity_report_result drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_alms_rp_alm_rrs_liquidity_report_result add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_alms_rp_alm_rrs_liquidity_report_result partition for (to_date('${batch_date}','yyyymmdd')) (
    v_rep_cd -- 报表id
    ,v_rep_line_order -- 序号
    ,n_rep_line_cd -- 报表条目编号
    ,v_rep_line_name -- 报表条目名称(即指标名称)
    ,v_rep_line_display_order -- 报表条目展示顺序号
    ,n_bold_ind -- 粗体展示标识:0：正常；1：粗体
    ,n_indent_level -- 缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；
    ,v_regulatory_level -- 监控级别
    ,v_index_class -- 指标分类
    ,v_supervision_require -- 监管要求
    ,v_limit_value -- 限额值
    ,v_prewarning_value -- 预警值
    ,v_index_type -- 指标类型
    ,v_statistical_frequency -- 统计频率
    ,v_monitor_frequency -- 监测频率
    ,v_read_lvl -- 审阅层级
    ,v_department_type -- 指标部门
    ,d_created_dt -- 创建日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(v_rep_cd), ' ') as v_rep_cd -- 报表id
    ,nvl(trim(v_rep_line_order), 0) as v_rep_line_order -- 序号
    ,nvl(trim(n_rep_line_cd), 0) as n_rep_line_cd -- 报表条目编号
    ,nvl(trim(v_rep_line_name), ' ') as v_rep_line_name -- 报表条目名称(即指标名称)
    ,nvl(trim(v_rep_line_display_order), 0) as v_rep_line_display_order -- 报表条目展示顺序号
    ,nvl(trim(n_bold_ind), 0) as n_bold_ind -- 粗体展示标识:0：正常；1：粗体
    ,nvl(trim(n_indent_level), 0) as n_indent_level -- 缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；
    ,nvl(trim(v_regulatory_level), ' ') as v_regulatory_level -- 监控级别
    ,nvl(trim(v_index_class), ' ') as v_index_class -- 指标分类
    ,nvl(trim(v_supervision_require), ' ') as v_supervision_require -- 监管要求
    ,nvl(trim(v_limit_value), ' ') as v_limit_value -- 限额值
    ,nvl(trim(v_prewarning_value), ' ') as v_prewarning_value -- 预警值
    ,nvl(trim(v_index_type), ' ') as v_index_type -- 指标类型
    ,nvl(trim(v_statistical_frequency), ' ') as v_statistical_frequency -- 统计频率
    ,nvl(trim(v_monitor_frequency), ' ') as v_monitor_frequency -- 监测频率
    ,nvl(trim(v_read_lvl), ' ') as v_read_lvl -- 审阅层级
    ,nvl(trim(v_department_type), ' ') as v_department_type -- 指标部门
    ,nvl(d_created_dt, to_date('00010101', 'yyyymmdd')) as d_created_dt -- 创建日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result
where etl_dt=to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_alms_rp_alm_rrs_liquidity_report_result to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_alms_rp_alm_rrs_liquidity_report_result',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);