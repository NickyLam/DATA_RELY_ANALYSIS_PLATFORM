/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_rdw_rdw_mcs_ovdue_loan_dtl
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
--alter table ${itl_schema}.itl_rdw_rdw_mcs_ovdue_loan_dtl drop partition p_${retain_day};
alter table ${itl_schema}.itl_rdw_rdw_mcs_ovdue_loan_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_rdw_rdw_mcs_ovdue_loan_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_rdw_rdw_mcs_ovdue_loan_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    belong_brch -- 所属分行
    ,asset_cate -- 资产类别
    ,cust_name -- 客户名称
    ,belong_group -- 所属集团
    ,bus_breed -- 业务品种
    ,bus_bal -- 业务余额
    ,ovdue_happ_dt -- 逾期发生日期
    ,ovdue_days -- 逾期天数
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(belong_brch), ' ') as belong_brch -- 所属分行
    ,nvl(trim(asset_cate), ' ') as asset_cate -- 资产类别
    ,nvl(trim(cust_name), ' ') as cust_name -- 客户名称
    ,nvl(trim(belong_group), ' ') as belong_group -- 所属集团
    ,nvl(trim(bus_breed), ' ') as bus_breed -- 业务品种
    ,nvl(trim(bus_bal), 0) as bus_bal -- 业务余额
    ,nvl(trim(ovdue_happ_dt), ' ') as ovdue_happ_dt -- 逾期发生日期
    ,nvl(trim(ovdue_days), ' ') as ovdue_days -- 逾期天数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_rdw_rdw_mcs_ovdue_loan_dtl to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_rdw_rdw_mcs_ovdue_loan_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);