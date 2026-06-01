/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_cpr_rating_record
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
drop table ${iol_schema}.rsts_cpr_rating_record_ex purge;
alter table ${iol_schema}.rsts_cpr_rating_record add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rsts_cpr_rating_record truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rsts_cpr_rating_record_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_cpr_rating_record where 0=1;

insert /*+ append */ into ${iol_schema}.rsts_cpr_rating_record_ex(
    uuid -- 评级记录ID
    ,serial_no -- 评级流水号
    ,rating_type -- 评级类型
    ,cust_no -- 客户编号
    ,cust_name -- 客户名称
    ,organization -- 所属机构
    ,national_industry -- 国标行业
    ,rating_model -- 评级模型
    ,model_code -- 模型代码
    ,final_score -- 最终得分
    ,machine_rating -- 机评等级
    ,special_rating -- 特例等级
    ,inputs -- 评级记录入参
    ,outputs -- 评级记录出参
    ,create_time -- 创建时间
    ,spend_time -- 耗时
    ,is_success -- 是否成功(默认0，1成功，-1失败)
    ,describe -- 描述
    ,is_test -- 是否测算(1是0否)
    ,financial_score -- 财务得分
    ,non_financial_score -- 非财务得分
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    uuid -- 评级记录ID
    ,serial_no -- 评级流水号
    ,rating_type -- 评级类型
    ,cust_no -- 客户编号
    ,cust_name -- 客户名称
    ,organization -- 所属机构
    ,national_industry -- 国标行业
    ,rating_model -- 评级模型
    ,model_code -- 模型代码
    ,final_score -- 最终得分
    ,machine_rating -- 机评等级
    ,special_rating -- 特例等级
    ,inputs -- 评级记录入参
    ,outputs -- 评级记录出参
    ,create_time -- 创建时间
    ,spend_time -- 耗时
    ,is_success -- 是否成功(默认0，1成功，-1失败)
    ,describe -- 描述
    ,is_test -- 是否测算(1是0否)
    ,financial_score -- 财务得分
    ,non_financial_score -- 非财务得分
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rsts_cpr_rating_record
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rsts_cpr_rating_record exchange partition p_${batch_date} with table ${iol_schema}.rsts_cpr_rating_record_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_cpr_rating_record to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rsts_cpr_rating_record_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_cpr_rating_record',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);