/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ncts_ab_auth_authorgnopara
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
alter table ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara partition for (to_date('${batch_date}','yyyymmdd')) (
    authorgno -- 授权中心机构号
    ,authorgname -- 授权中心名称
    ,oraglev -- 授权中心级别
    ,taskmode -- 授权中心任务模式 1-系统推送，2-抢单
    ,deleteflag -- 删除标识(0-正常 1-已删除)
    ,usingflag -- 授权中心开启标识(0-未开启 1-启动)
    ,authorgtype -- 授权中心类别(第一位1-总行授权中心，第二位1-分行授权中心，第三位1-网点授权中心)
    ,crtdate -- 创建日期
    ,crttellerno -- 创建柜员号
    ,upddate -- 更新日期
    ,uptellerno -- 更新柜员号
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(authorgno), ' ') as authorgno -- 授权中心机构号
    ,nvl(trim(authorgname), ' ') as authorgname -- 授权中心名称
    ,nvl(trim(oraglev), ' ') as oraglev -- 授权中心级别
    ,nvl(trim(taskmode), ' ') as taskmode -- 授权中心任务模式 1-系统推送，2-抢单
    ,nvl(trim(deleteflag), ' ') as deleteflag -- 删除标识(0-正常 1-已删除)
    ,nvl(trim(usingflag), ' ') as usingflag -- 授权中心开启标识(0-未开启 1-启动)
    ,nvl(trim(authorgtype), ' ') as authorgtype -- 授权中心类别(第一位1-总行授权中心，第二位1-分行授权中心，第三位1-网点授权中心)
    ,nvl(crtdate, to_date('00010101', 'yyyymmdd')) as crtdate -- 创建日期
    ,nvl(trim(crttellerno), ' ') as crttellerno -- 创建柜员号
    ,nvl(upddate, to_date('00010101', 'yyyymmdd')) as upddate -- 更新日期
    ,nvl(trim(uptellerno), ' ') as uptellerno -- 更新柜员号
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始时间
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_ncts_ab_auth_authorgnopara
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_ncts_ab_auth_authorgnopara to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ncts_ab_auth_authorgnopara',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);