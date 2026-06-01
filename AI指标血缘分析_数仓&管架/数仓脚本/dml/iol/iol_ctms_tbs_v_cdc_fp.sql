/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_cdc_fp
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_cdc_fp_ex purge;
alter table ${iol_schema}.ctms_tbs_v_cdc_fp add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ctms_tbs_v_cdc_fp truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ctms_tbs_v_cdc_fp_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_cdc_fp where 0=1;

insert /*+ append */ into ${iol_schema}.ctms_tbs_v_cdc_fp_ex(
    security_code -- 债券代码
    ,pricing_date -- 日期
    ,market -- 市场类别
    ,ttm -- 剩余期限
    ,reliability -- 是否推荐
    ,dp -- 全价
    ,cp -- 净价
    ,yield -- 到期收益率
    ,duration -- 久期
    ,mduration -- 修正久期
    ,valid -- 有效性
    ,lastupdate -- 最后更新时间
    ,end_dp -- 日终全价
    ,cdc_yield -- 估价收益率（%）
    ,cdc_md -- 估价修正久期
    ,cdc_convexity -- 估价凸性
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    security_code -- 债券代码
    ,pricing_date -- 日期
    ,market -- 市场类别
    ,ttm -- 剩余期限
    ,reliability -- 是否推荐
    ,dp -- 全价
    ,cp -- 净价
    ,yield -- 到期收益率
    ,duration -- 久期
    ,mduration -- 修正久期
    ,valid -- 有效性
    ,lastupdate -- 最后更新时间
    ,end_dp -- 日终全价
    ,cdc_yield -- 估价收益率（%）
    ,cdc_md -- 估价修正久期
    ,cdc_convexity -- 估价凸性
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ctms_tbs_v_cdc_fp
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ctms_tbs_v_cdc_fp exchange partition p_${batch_date} with table ${iol_schema}.ctms_tbs_v_cdc_fp_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_cdc_fp to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ctms_tbs_v_cdc_fp_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_cdc_fp',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);