/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_agt_acct_change_rgst_b
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
alter table ${itl_schema}.itl_edw_agt_acct_change_rgst_b drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_agt_acct_change_rgst_b drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_agt_acct_change_rgst_b add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_agt_acct_change_rgst_b partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt -- 数据日期
    ,agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,old_acct_id -- 旧账户编号
    ,new_acct_id -- 新账户编号
    ,tran_dt -- 交易日期
    ,tran_flow_num -- 交易流水号
    ,advised_midgrod_flg -- 已通知中台标志
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,etl_timestamp -- ETL处理时间
    ,job_cd -- 任务编码

)
select
    nvl(etl_dt, to_date('00010101', 'yyyymmdd')) as etl_dt -- 数据日期
    ,nvl(trim(agt_id), ' ') as agt_id -- 协议编号
    ,nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(old_acct_id), ' ') as old_acct_id -- 旧账户编号
    ,nvl(trim(new_acct_id), ' ') as new_acct_id -- 新账户编号
    ,nvl(tran_dt, to_date('00010101', 'yyyymmdd')) as tran_dt -- 交易日期
    ,nvl(trim(tran_flow_num), ' ') as tran_flow_num -- 交易流水号
    ,nvl(trim(advised_midgrod_flg), ' ') as advised_midgrod_flg -- 已通知中台标志
    ,nvl(trim(tran_org_id), ' ') as tran_org_id -- 交易机构编号
    ,nvl(trim(tran_teller_id), ' ') as tran_teller_id -- 交易柜员编号
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
    ,nvl(trim(job_cd), ' ') as job_cd -- 删除标识
from ${msl_schema}.msl_edw_agt_acct_change_rgst_b
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_agt_acct_change_rgst_b to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_agt_acct_change_rgst_b',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);