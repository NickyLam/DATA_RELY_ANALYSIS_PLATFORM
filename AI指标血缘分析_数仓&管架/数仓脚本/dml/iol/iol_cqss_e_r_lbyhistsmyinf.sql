/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_lbyhistsmyinf
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
drop table ${iol_schema}.cqss_e_r_lbyhistsmyinf_ex purge;
alter table ${iol_schema}.cqss_e_r_lbyhistsmyinf add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_lbyhistsmyinf truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_lbyhistsmyinf_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_lbyhistsmyinf where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_lbyhistsmyinf_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,mo -- 月份:EB02CR01
    ,whl_lby_acc -- 全部负债账户数:EB02CS02
    ,whl_lby_bal -- 全部负债余额:EB02CJ01
    ,fcs_cgy_lby_acc -- 关注类负债账户数:EB02CS03
    ,fcs_cgy_lby_bal -- 关注类负债余额:EB02CJ02
    ,bad_cgy_lby_acc -- 不良类负债账户数:EB02CS04
    ,bad_cgy_lby_bal -- 不良类负债余额:EB02CJ03
    ,odue_acc -- 逾期账户数:EB02CS05
    ,cur_odue_tamt -- 当前逾期总额(逾期总额):EB02CJ04
    ,odue_pnp_acc -- 逾期本金账户数:EB02CS06
    ,cur_odue_pnp -- 当前逾期本金(逾期本金):EB02CJ05
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,mo -- 月份:EB02CR01
    ,whl_lby_acc -- 全部负债账户数:EB02CS02
    ,whl_lby_bal -- 全部负债余额:EB02CJ01
    ,fcs_cgy_lby_acc -- 关注类负债账户数:EB02CS03
    ,fcs_cgy_lby_bal -- 关注类负债余额:EB02CJ02
    ,bad_cgy_lby_acc -- 不良类负债账户数:EB02CS04
    ,bad_cgy_lby_bal -- 不良类负债余额:EB02CJ03
    ,odue_acc -- 逾期账户数:EB02CS05
    ,cur_odue_tamt -- 当前逾期总额(逾期总额):EB02CJ04
    ,odue_pnp_acc -- 逾期本金账户数:EB02CS06
    ,cur_odue_pnp -- 当前逾期本金(逾期本金):EB02CJ05
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_lbyhistsmyinf
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_lbyhistsmyinf exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_lbyhistsmyinf_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_lbyhistsmyinf to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_lbyhistsmyinf_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_lbyhistsmyinf',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);