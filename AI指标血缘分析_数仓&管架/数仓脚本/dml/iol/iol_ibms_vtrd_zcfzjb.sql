/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_vtrd_zcfzjb
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
drop table ${iol_schema}.ibms_vtrd_zcfzjb_ex purge;
alter table ${iol_schema}.ibms_vtrd_zcfzjb add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ibms_vtrd_zcfzjb truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_vtrd_zcfzjb_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_vtrd_zcfzjb where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_vtrd_zcfzjb_ex(
    beg_date -- BEG_DATE
    ,ordid -- ORDID
    ,title -- TITLE
    ,all_real_cp -- 汇总_REAL_CP
    ,all_minus_cp -- 汇总_MINUS_CP
    ,zb_real_cp -- 总部_REAL_CP
    ,zb_minus_cp -- 总部_MINUS_CP
    ,gz_real_cp -- 广州团队_REAL_CP
    ,gz_minus_cp -- 广州团队_MINUS_CP
    ,sz_real_cp -- 深圳团队_REAL_CP
    ,sz_minus_cp -- 深圳团队_MINUS_CP
    ,szsfq_real_cp -- 深圳示范区_REAL_CP
    ,szsfq_minus_cp -- 深圳示范区_MINUS_CP
    ,fs_real_cp -- 佛山团队_REAL_CP
    ,fs_minus_cp -- 佛山团队_MINUS_CP
    ,dg_real_cp -- 东莞团队_REAL_CP
    ,dg_minus_cp -- 东莞团队_MINUS_CP
    ,st_real_cp -- 汕头团队_REAL_CP
    ,st_minus_cp -- 汕头团队_MINUS_CP
    ,jm_real_cp -- 江门团队_REAL_CP
    ,jm_minus_cp -- 江门团队_MINUS_CP
    ,zh_real_cp -- 珠海团队_REAL_CP
    ,zh_minus_cp -- 珠海团队_MINUS_CP
    ,hz_real_cp -- 惠州团队_REAL_CP
    ,hz_minus_cp -- 惠州团队_MINUS_CP
    ,zs_real_cp -- 中山团队_REAL_CP
    ,zs_minus_cp -- 中山团队_MINUS_CP
    ,zq_real_cp -- 肇庆团队_REAL_CP
    ,zq_minus_cp -- 肇庆团队_MINUS_CP
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    beg_date -- BEG_DATE
    ,ordid -- ORDID
    ,title -- TITLE
    ,all_real_cp -- 汇总_REAL_CP
    ,all_minus_cp -- 汇总_MINUS_CP
    ,zb_real_cp -- 总部_REAL_CP
    ,zb_minus_cp -- 总部_MINUS_CP
    ,gz_real_cp -- 广州团队_REAL_CP
    ,gz_minus_cp -- 广州团队_MINUS_CP
    ,sz_real_cp -- 深圳团队_REAL_CP
    ,sz_minus_cp -- 深圳团队_MINUS_CP
    ,szsfq_real_cp -- 深圳示范区_REAL_CP
    ,szsfq_minus_cp -- 深圳示范区_MINUS_CP
    ,fs_real_cp -- 佛山团队_REAL_CP
    ,fs_minus_cp -- 佛山团队_MINUS_CP
    ,dg_real_cp -- 东莞团队_REAL_CP
    ,dg_minus_cp -- 东莞团队_MINUS_CP
    ,st_real_cp -- 汕头团队_REAL_CP
    ,st_minus_cp -- 汕头团队_MINUS_CP
    ,jm_real_cp -- 江门团队_REAL_CP
    ,jm_minus_cp -- 江门团队_MINUS_CP
    ,zh_real_cp -- 珠海团队_REAL_CP
    ,zh_minus_cp -- 珠海团队_MINUS_CP
    ,hz_real_cp -- 惠州团队_REAL_CP
    ,hz_minus_cp -- 惠州团队_MINUS_CP
    ,zs_real_cp -- 中山团队_REAL_CP
    ,zs_minus_cp -- 中山团队_MINUS_CP
    ,zq_real_cp -- 肇庆团队_REAL_CP
    ,zq_minus_cp -- 肇庆团队_MINUS_CP
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_vtrd_zcfzjb
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_vtrd_zcfzjb exchange partition p_${batch_date} with table ${iol_schema}.ibms_vtrd_zcfzjb_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_vtrd_zcfzjb to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_vtrd_zcfzjb_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_vtrd_zcfzjb',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);