/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_ded_rate
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
drop table ${iol_schema}.ibms_ttrd_ded_rate_ex purge;
alter table ${iol_schema}.ibms_ttrd_ded_rate add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ibms_ttrd_ded_rate;

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_ded_rate_ex nologging
compress
as
select * from ${iol_schema}.ibms_ttrd_ded_rate where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_ded_rate_ex(
    id -- 序号
    ,def_id -- 活期金融工具定义序号
    ,rate -- 利率
    ,beg_date -- 有效期起始日期
    ,end_date -- 有效期结束日期
    ,imp_time -- 导入时间
    ,update_time -- 更新时间
    ,update_user -- 更新者
    ,create_time -- 创建时间
    ,create_user -- 创建者
    ,confirm_id -- 确认单编号
    ,create4txy -- 是否是同兴赢维护数据，0或空为否，1为是
    ,signing_amount -- 签约额度
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 序号
    ,def_id -- 活期金融工具定义序号
    ,rate -- 利率
    ,beg_date -- 有效期起始日期
    ,end_date -- 有效期结束日期
    ,imp_time -- 导入时间
    ,update_time -- 更新时间
    ,update_user -- 更新者
    ,create_time -- 创建时间
    ,create_user -- 创建者
    ,confirm_id -- 确认单编号
    ,create4txy -- 是否是同兴赢维护数据，0或空为否，1为是
    ,signing_amount -- 签约额度
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_ded_rate
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_ded_rate exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_ded_rate_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_ded_rate to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_ded_rate_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_ded_rate',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);