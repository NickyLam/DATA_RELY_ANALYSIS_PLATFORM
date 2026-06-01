/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_ccrw_u_ip_result_ccrw_mcss
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
--alter table ${itl_schema}.itl_ccrw_u_ip_result_ccrw_mcss drop partition p_${retain_day};
alter table ${itl_schema}.itl_ccrw_u_ip_result_ccrw_mcss drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_ccrw_u_ip_result_ccrw_mcss add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_ccrw_u_ip_result_ccrw_mcss partition for (to_date('${batch_date}','yyyymmdd')) (
    result_id -- 指标结果ID
    ,index_mx_id -- 实际指标ID
    ,org_or_user_id -- 机构或员工ID
    ,fit_obj -- 适用对象
    ,gh_type -- 管户类型
    ,ccy_type -- 币别类型
    ,index_cycle_value -- 指标周期值
    ,index_cycle -- 指标周期
    ,bk_index_id -- 集市指标ID
    ,run_batch_date -- 跑批日期
    ,index_from -- 指标来源
    ,value -- 结果值
    ,last_day -- 比上日
    ,last_week -- 比上周
    ,last_month -- 比上月末
    ,last_season -- 比上季末
    ,last_year -- 比上年末
    ,last_year_same -- 比上年同期末
    ,d_sub_zf -- 比上日增幅
    ,w_sub_zf -- 比上周增幅
    ,m_sub_zf -- 比上月末增幅
    ,q_sub_zf -- 比上季末增幅
    ,y_sub_zf -- 比上年末增幅
    ,yoy_sub_zf -- 比去年同期增幅
    ,unit -- 指标单位 1-元 2-户 3-笔
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(result_id), ' ') as result_id -- 指标结果ID
    ,nvl(trim(index_mx_id), ' ') as index_mx_id -- 实际指标ID
    ,nvl(trim(org_or_user_id), ' ') as org_or_user_id -- 机构或员工ID
    ,nvl(trim(fit_obj), ' ') as fit_obj -- 适用对象
    ,nvl(trim(gh_type), ' ') as gh_type -- 管户类型
    ,nvl(trim(ccy_type), ' ') as ccy_type -- 币别类型
    ,nvl(trim(index_cycle_value), ' ') as index_cycle_value -- 指标周期值
    ,nvl(trim(index_cycle), ' ') as index_cycle -- 指标周期
    ,nvl(trim(bk_index_id), ' ') as bk_index_id -- 集市指标ID
    ,nvl(trim(run_batch_date), ' ') as run_batch_date -- 跑批日期
    ,nvl(trim(index_from), ' ') as index_from -- 指标来源
    ,nvl(trim(value), 0) as value -- 结果值
    ,nvl(trim(last_day), 0) as last_day -- 比上日
    ,nvl(trim(last_week), 0) as last_week -- 比上周
    ,nvl(trim(last_month), 0) as last_month -- 比上月末
    ,nvl(trim(last_season), 0) as last_season -- 比上季末
    ,nvl(trim(last_year), 0) as last_year -- 比上年末
    ,nvl(trim(last_year_same), 0) as last_year_same -- 比上年同期末
    ,nvl(trim(d_sub_zf), 0) as d_sub_zf -- 比上日增幅
    ,nvl(trim(w_sub_zf), 0) as w_sub_zf -- 比上周增幅
    ,nvl(trim(m_sub_zf), 0) as m_sub_zf -- 比上月末增幅
    ,nvl(trim(q_sub_zf), 0) as q_sub_zf -- 比上季末增幅
    ,nvl(trim(y_sub_zf), 0) as y_sub_zf -- 比上年末增幅
    ,nvl(trim(yoy_sub_zf), 0) as yoy_sub_zf -- 比去年同期增幅
    ,nvl(trim(unit), ' ') as unit -- 指标单位 1-元 2-户 3-笔
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_ccrw_u_ip_result_ccrw_mcss to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_ccrw_u_ip_result_ccrw_mcss',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);