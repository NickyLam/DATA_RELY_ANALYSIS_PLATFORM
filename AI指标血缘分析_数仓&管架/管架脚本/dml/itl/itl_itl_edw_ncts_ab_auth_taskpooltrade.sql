/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ncts_ab_auth_taskpooltrade
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
alter table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade partition for (to_date('${batch_date}','yyyymmdd')) (
    authorgno -- 授权机构
    ,taskpoolid -- 任务池编号
    ,channelcode -- 渠道码
    ,tradecode -- 交易码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(authorgno), ' ') as authorgno -- 授权机构
    ,nvl(trim(taskpoolid), ' ') as taskpoolid -- 任务池编号
    ,nvl(trim(channelcode), ' ') as channelcode -- 渠道码
    ,nvl(trim(tradecode), ' ') as tradecode -- 交易码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_ncts_ab_auth_taskpooltrade
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ncts_ab_auth_taskpooltrade',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);