/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_hsgrsvfndpfrcrdbscinf
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
drop table ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf_ex purge;
alter table ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,acc_id -- 账户编号:EF05AI01
    ,first_py_yrmo -- 初缴年月:EF05AR01
    ,emplnum -- 员工人数(职工人数):EF05AS01
    ,hsgrsvfnd_pyf_crdnlt -- 住房公积金缴费基数(缴费基数):EF05AJ01
    ,rctly_oc_pyf_dt -- 最近一次缴费日期:EF05AR02
    ,hsgrsvfnd_pyt_yrmo -- 住房公积金缴至年月(缴至年月):EF05AR03
    ,cr_hsgrsvfnd_pyf_stcd -- 征信住房公积金缴费状态代码(缴费状态):EF05AD01
    ,acm_ow_amt -- 累计欠费金额:EF05AJ02
    ,stat_yrmo -- 统计年月:EF05AR04
    ,pyf_rcrd_num -- 缴费记录条数:EF05BS01
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,acc_id -- 账户编号:EF05AI01
    ,first_py_yrmo -- 初缴年月:EF05AR01
    ,emplnum -- 员工人数(职工人数):EF05AS01
    ,hsgrsvfnd_pyf_crdnlt -- 住房公积金缴费基数(缴费基数):EF05AJ01
    ,rctly_oc_pyf_dt -- 最近一次缴费日期:EF05AR02
    ,hsgrsvfnd_pyt_yrmo -- 住房公积金缴至年月(缴至年月):EF05AR03
    ,cr_hsgrsvfnd_pyf_stcd -- 征信住房公积金缴费状态代码(缴费状态):EF05AD01
    ,acm_ow_amt -- 累计欠费金额:EF05AJ02
    ,stat_yrmo -- 统计年月:EF05AR04
    ,pyf_rcrd_num -- 缴费记录条数:EF05BS01
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_hsgrsvfndpfrcrdbscinf_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_hsgrsvfndpfrcrdbscinf',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);