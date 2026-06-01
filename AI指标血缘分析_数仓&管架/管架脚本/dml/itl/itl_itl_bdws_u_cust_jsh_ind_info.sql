/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_bdws_u_cust_jsh_ind_info
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
--alter table ${itl_schema}.itl_bdws_u_cust_jsh_ind_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_bdws_u_cust_jsh_ind_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_bdws_u_cust_jsh_ind_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_bdws_u_cust_jsh_ind_info partition for (to_date('${batch_date}','yyyymmdd')) (
    index_no -- 指标编号
    ,index_name -- 指标名称
    ,execut_type -- 管户类型
    ,clerk_id -- 员工编号
    ,clerk_name -- 员工名称
    ,belong_org_id -- 机构编号
    ,belong_org_name -- 机构名称
    ,statis_cycle -- 统计周期代码
    ,plan_type -- 方案类型代码
    ,val -- 值
    ,d_sub_bal -- 比上日末
    ,m_sub_bal -- 比上月末
    ,q_sub_bal -- 比上季末
    ,y_sub_bal -- 比上年末
    ,w_sub_bal -- 比上周
    ,yoy_sub_bal -- 比去年同期
    ,d_sub_zf -- 比上日增幅
    ,m_sub_zf -- 比上月末增幅
    ,q_sub_zf -- 比上季末增幅
    ,y_sub_zf -- 比上年末增幅
    ,w_sub_zf -- 比上周增幅
    ,yoy_sub_zf -- 比去年同期增幅
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(index_no), ' ') as index_no -- 指标编号
    ,nvl(trim(index_name), ' ') as index_name -- 指标名称
    ,nvl(trim(execut_type), ' ') as execut_type -- 管户类型
    ,nvl(trim(clerk_id), ' ') as clerk_id -- 员工编号
    ,nvl(trim(clerk_name), ' ') as clerk_name -- 员工名称
    ,nvl(trim(belong_org_id), ' ') as belong_org_id -- 机构编号
    ,nvl(trim(belong_org_name), ' ') as belong_org_name -- 机构名称
    ,nvl(trim(statis_cycle), ' ') as statis_cycle -- 统计周期代码
    ,nvl(trim(plan_type), ' ') as plan_type -- 方案类型代码
    ,nvl(trim(val), 0) as val -- 值
    ,nvl(trim(d_sub_bal), 0) as d_sub_bal -- 比上日末
    ,nvl(trim(m_sub_bal), 0) as m_sub_bal -- 比上月末
    ,nvl(trim(q_sub_bal), 0) as q_sub_bal -- 比上季末
    ,nvl(trim(y_sub_bal), 0) as y_sub_bal -- 比上年末
    ,nvl(trim(w_sub_bal), 0) as w_sub_bal -- 比上周
    ,nvl(trim(yoy_sub_bal), 0) as yoy_sub_bal -- 比去年同期
    ,nvl(trim(d_sub_zf), 0) as d_sub_zf -- 比上日增幅
    ,nvl(trim(m_sub_zf), 0) as m_sub_zf -- 比上月末增幅
    ,nvl(trim(q_sub_zf), 0) as q_sub_zf -- 比上季末增幅
    ,nvl(trim(y_sub_zf), 0) as y_sub_zf -- 比上年末增幅
    ,nvl(trim(w_sub_zf), 0) as w_sub_zf -- 比上周增幅
    ,nvl(trim(yoy_sub_zf), 0) as yoy_sub_zf -- 比去年同期增幅
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_bdws_u_cust_jsh_ind_info
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_bdws_u_cust_jsh_ind_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_bdws_u_cust_jsh_ind_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);