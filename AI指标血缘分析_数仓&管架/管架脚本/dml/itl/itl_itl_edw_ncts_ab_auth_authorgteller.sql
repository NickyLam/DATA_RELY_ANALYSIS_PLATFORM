/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_ncts_ab_auth_authorgteller
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
alter table ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller partition for (to_date('${batch_date}','yyyymmdd')) (
    authorgno -- 授权机构
    ,authtellerno -- 授权柜员
    ,telleroid -- 授权柜员终端OID
    ,telleronline -- 登录状态。0,离线;1,在线
    ,realocationflag -- 
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(authorgno), ' ') as authorgno -- 授权机构
    ,nvl(trim(authtellerno), ' ') as authtellerno -- 授权柜员
    ,nvl(trim(telleroid), ' ') as telleroid -- 授权柜员终端OID
    ,nvl(trim(telleronline), ' ') as telleronline -- 登录状态。0,离线;1,在线
    ,nvl(trim(realocationflag), ' ') as realocationflag -- 
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始时间
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_ncts_ab_auth_authorgteller
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_ncts_ab_auth_authorgteller to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_ncts_ab_auth_authorgteller',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);