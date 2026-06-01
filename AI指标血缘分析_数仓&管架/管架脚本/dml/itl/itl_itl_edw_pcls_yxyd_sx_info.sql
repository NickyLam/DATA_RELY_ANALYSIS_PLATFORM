/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pcls_yxyd_sx_info
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
--alter table ${itl_schema}.itl_edw_pcls_yxyd_sx_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pcls_yxyd_sx_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pcls_yxyd_sx_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pcls_yxyd_sx_info partition for (to_date('${batch_date}','yyyymmdd')) (
    appl_dt -- 申请日期
    ,appl_cnt -- 申请通过笔数
    ,final_pass_cnt -- 申请通过笔数
    ,final_pass_percent -- 授信通过率（笔数）
    ,final_pass_credit -- 终审通过笔数
    ,final_pass_repay -- 终审通过率
    ,appl_pass_cnt -- 额度
    ,appl_pass_percent -- 定价
    ,tele_pass_cnt -- 电核通过笔数
    ,tele_pass_percent -- 电核通过率
    ,face_pass_cnt -- 面签通过笔数
    ,face_pass_percent -- 面签通过率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(appl_dt), 0) as appl_dt -- 申请日期
    ,nvl(trim(appl_cnt), 0) as appl_cnt -- 申请通过笔数
    ,nvl(trim(final_pass_cnt), 0) as final_pass_cnt -- 申请通过笔数
    ,nvl(trim(final_pass_percent), 0) as final_pass_percent -- 授信通过率（笔数）
    ,nvl(trim(final_pass_credit), 0) as final_pass_credit -- 终审通过笔数
    ,nvl(trim(final_pass_repay), 0) as final_pass_repay -- 终审通过率
    ,nvl(trim(appl_pass_cnt), 0) as appl_pass_cnt -- 额度
    ,nvl(trim(appl_pass_percent), 0) as appl_pass_percent -- 定价
    ,nvl(trim(tele_pass_cnt), 0) as tele_pass_cnt -- 电核通过笔数
    ,nvl(trim(tele_pass_percent), 0) as tele_pass_percent -- 电核通过率
    ,nvl(trim(face_pass_cnt), 0) as face_pass_cnt -- 面签通过笔数
    ,nvl(trim(face_pass_percent), 0) as face_pass_percent -- 面签通过率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pcls_yxyd_sx_info
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pcls_yxyd_sx_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pcls_yxyd_sx_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);