/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_hkshareprosecution
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
drop table ${iol_schema}.wind_hkshareprosecution_ex purge;
alter table ${iol_schema}.wind_hkshareprosecution add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_hkshareprosecution truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_hkshareprosecution_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_hkshareprosecution where 0=1;

insert /*+ append */ into ${iol_schema}.wind_hkshareprosecution_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司ID
    ,ann_dt -- 公告日期
    ,title -- 案件名称
    ,accuser -- 原告方
    ,defendant -- 被告方
    ,pro_type -- 诉讼类型
    ,amount -- 涉案金额
    ,crncy_code -- 货币代码
    ,prosecute_dt -- 起诉日期
    ,court -- 一审受理法院
    ,judge_dt -- 判决日期
    ,result9 -- 判决内容
    ,is_appeal -- 是否上诉
    ,appellant -- 二审上诉方(是否原告)
    ,court2 -- 二审受理法院
    ,judge_dt2 -- 二审判决日期
    ,result2 -- 二审判决内容
    ,resultamount -- 判决金额
    ,briefresult -- 诉讼结果
    ,execution -- 执行情况
    ,introduction -- 案件描述
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compcode -- 公司ID
    ,ann_dt -- 公告日期
    ,title -- 案件名称
    ,accuser -- 原告方
    ,defendant -- 被告方
    ,pro_type -- 诉讼类型
    ,amount -- 涉案金额
    ,crncy_code -- 货币代码
    ,prosecute_dt -- 起诉日期
    ,court -- 一审受理法院
    ,judge_dt -- 判决日期
    ,result9 -- 判决内容
    ,is_appeal -- 是否上诉
    ,appellant -- 二审上诉方(是否原告)
    ,court2 -- 二审受理法院
    ,judge_dt2 -- 二审判决日期
    ,result2 -- 二审判决内容
    ,resultamount -- 判决金额
    ,briefresult -- 诉讼结果
    ,execution -- 执行情况
    ,introduction -- 案件描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_hkshareprosecution
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_hkshareprosecution exchange partition p_${batch_date} with table ${iol_schema}.wind_hkshareprosecution_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_hkshareprosecution to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_hkshareprosecution_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_hkshareprosecution',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);