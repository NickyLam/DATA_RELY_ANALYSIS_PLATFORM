/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_orws_t_ghbr_bv_details
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
--数仓供的增量，所以ITL层存放历史
--alter table ${itl_schema}.itl_edw_orws_t_ghbr_bv_details drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_orws_t_ghbr_bv_details drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_orws_t_ghbr_bv_details add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_orws_t_ghbr_bv_details partition for (to_date('${batch_date}','yyyymmdd')) (
    txn_dt -- 
    ,txn_tm -- 
    ,parent_org_id -- 
    ,blng_org_id -- 
    ,oper_teller_id -- 
    ,oper_teller_name -- 
    ,auth_teller_id -- 
    ,auth_teller_name -- 
    ,txn_num -- 
    ,txn_desc -- 
    ,biz_sys_evt_id -- 
    ,bcs_evt_id -- 
    ,data_src_cd -- 
    ,pay_agt_id -- 
    ,rcv_agt_id -- 
    ,txn_amt -- 
    ,menuid -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(txn_dt, to_timestamp('00010101', 'yyyymmdd')) as txn_dt -- 
    ,nvl(trim(txn_tm), ' ') as txn_tm -- 
    ,nvl(trim(parent_org_id), ' ') as parent_org_id -- 
    ,nvl(trim(blng_org_id), ' ') as blng_org_id -- 
    ,nvl(trim(oper_teller_id), ' ') as oper_teller_id -- 
    ,nvl(trim(oper_teller_name), ' ') as oper_teller_name -- 
    ,nvl(trim(auth_teller_id), ' ') as auth_teller_id -- 
    ,nvl(trim(auth_teller_name), ' ') as auth_teller_name -- 
    ,nvl(trim(txn_num), ' ') as txn_num -- 
    ,nvl(trim(txn_desc), ' ') as txn_desc -- 
    ,nvl(trim(biz_sys_evt_id), ' ') as biz_sys_evt_id -- 
    ,nvl(trim(bcs_evt_id), ' ') as bcs_evt_id -- 
    ,nvl(trim(data_src_cd), ' ') as data_src_cd -- 
    ,nvl(trim(pay_agt_id), ' ') as pay_agt_id -- 
    ,nvl(trim(rcv_agt_id), ' ') as rcv_agt_id -- 
    ,nvl(trim(txn_amt), 0) as txn_amt -- 
    ,nvl(trim(menuid), ' ') as menuid -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_orws_t_ghbr_bv_details
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_orws_t_ghbr_bv_details to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_orws_t_ghbr_bv_details',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);