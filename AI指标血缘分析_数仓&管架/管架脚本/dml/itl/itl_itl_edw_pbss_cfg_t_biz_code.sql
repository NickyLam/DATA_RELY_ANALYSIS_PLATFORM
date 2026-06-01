/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pbss_cfg_t_biz_code
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
--营运管驾Itl层存放历史数据
alter table ${itl_schema}.itl_edw_pbss_cfg_t_biz_code drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pbss_cfg_t_biz_code drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pbss_cfg_t_biz_code add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pbss_cfg_t_biz_code partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt -- 数据日期
    ,id -- 
    ,biz_code -- 
    ,biz_name -- 
    ,eft_date -- 
    ,biz_property -- 
    ,is_auto_priority -- 是否使用动态优化级 1-是 0-否
    ,pre_setup_point -- 取值0至1之间，其它值表示无效
    ,pre_setup_priority -- 预先调整优先级值
    ,time_len -- 业务时长，单位：分钟
    ,timeout_priority -- 超时调整优先级
    ,time_limit -- 截止时间，格式：hh:mm:ss
    ,timelimit_priority -- 限时调整优先级
    ,kind_code -- 业务种类编码
    ,order_no -- 2016年9月投产需求要求指定顺序
    ,is_display -- 用于“指定任务获取界面”的“业务类型”是否显示，新增业务类型默认设置为显示。0:不显示,1:显示
    ,start_dt -- 开始日期
    ,end_dt -- 结束日期
    ,id_mark -- 删除标识
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(etl_dt, to_date('00010101', 'yyyymmdd')) as etl_dt -- 数据日期
    ,nvl(trim(id), ' ') as id -- 
    ,nvl(trim(biz_code), ' ') as biz_code -- 
    ,nvl(trim(biz_name), ' ') as biz_name -- 
    ,nvl(eft_date, to_date('00010101', 'yyyymmdd')) as eft_date -- 
    ,nvl(trim(biz_property), ' ') as biz_property -- 
    ,nvl(trim(is_auto_priority), ' ') as is_auto_priority -- 是否使用动态优化级 1-是 0-否
    ,nvl(trim(pre_setup_point), 0) as pre_setup_point -- 取值0至1之间，其它值表示无效
    ,nvl(trim(pre_setup_priority), 0) as pre_setup_priority -- 预先调整优先级值
    ,nvl(trim(time_len), ' ') as time_len -- 业务时长，单位：分钟
    ,nvl(trim(timeout_priority), 0) as timeout_priority -- 超时调整优先级
    ,nvl(trim(time_limit), ' ') as time_limit -- 截止时间，格式：hh:mm:ss
    ,nvl(trim(timelimit_priority), 0) as timelimit_priority -- 限时调整优先级
    ,nvl(trim(kind_code), ' ') as kind_code -- 业务种类编码
    ,nvl(trim(order_no), 0) as order_no -- 2016年9月投产需求要求指定顺序
    ,nvl(trim(is_display), ' ') as is_display -- 用于“指定任务获取界面”的“业务类型”是否显示，新增业务类型默认设置为显示。0:不显示,1:显示
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始日期
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束日期
    ,nvl(trim(id_mark), ' ') as id_mark -- 删除标识
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pbss_cfg_t_biz_code
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pbss_cfg_t_biz_code to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pbss_cfg_t_biz_code',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);