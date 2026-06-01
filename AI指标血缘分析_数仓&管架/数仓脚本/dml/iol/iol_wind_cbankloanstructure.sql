/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_cbankloanstructure
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
drop table ${iol_schema}.wind_cbankloanstructure_ex purge;
alter table ${iol_schema}.wind_cbankloanstructure add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_cbankloanstructure truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_cbankloanstructure_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_cbankloanstructure where 0=1;

insert /*+ append */ into ${iol_schema}.wind_cbankloanstructure_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,report_period -- 报告期
    ,statement_type -- 报表类型代码
    ,crncy_code -- 货币代码
    ,crncy_type_code -- 币种类型代码
    ,loan_type_code -- 项目类别代码
    ,ann_item -- [内部]公布名称
    ,loan_item_code -- 贷款项目代码
    ,total_loans -- 贷款余额
    ,ave_loans -- 贷款平均余额
    ,interest_income -- 贷款利息收入
    ,average_yield -- 贷款平均收益率
    ,non_performing_loans -- 不良贷款余额
    ,non_performing_loans_ratio -- 不良贷款率(%)
    ,memo -- 备注
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,report_period -- 报告期
    ,statement_type -- 报表类型代码
    ,crncy_code -- 货币代码
    ,crncy_type_code -- 币种类型代码
    ,loan_type_code -- 项目类别代码
    ,ann_item -- [内部]公布名称
    ,loan_item_code -- 贷款项目代码
    ,total_loans -- 贷款余额
    ,ave_loans -- 贷款平均余额
    ,interest_income -- 贷款利息收入
    ,average_yield -- 贷款平均收益率
    ,non_performing_loans -- 不良贷款余额
    ,non_performing_loans_ratio -- 不良贷款率(%)
    ,memo -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_cbankloanstructure
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_cbankloanstructure exchange partition p_${batch_date} with table ${iol_schema}.wind_cbankloanstructure_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_cbankloanstructure to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_cbankloanstructure_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_cbankloanstructure',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);