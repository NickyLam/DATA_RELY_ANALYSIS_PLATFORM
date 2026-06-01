/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_ca_risk_record_item
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
drop table ${iol_schema}.nfss_ca_risk_record_item_ex purge;
alter table ${iol_schema}.nfss_ca_risk_record_item add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.nfss_ca_risk_record_item;

-- 2.3 insert data to ex table
create table ${iol_schema}.nfss_ca_risk_record_item_ex nologging
compress
as
select * from ${iol_schema}.nfss_ca_risk_record_item where 0=1;

insert /*+ append */ into ${iol_schema}.nfss_ca_risk_record_item_ex(
    id -- 主键ID
    ,risk_record_id -- 关联风评记录主键ID
    ,paper_id -- 关联问卷主键
    ,question_id -- 关联问题主键
    ,paper_no -- 问卷编号
    ,version -- 问卷版本号
    ,question_no -- 问题编号
    ,question_type -- 问题类型
    ,risk_option -- 选择项
    ,question -- 题目内容
    ,subject -- 选择项内容
    ,score -- 分数
    ,mut_risk_option -- 多选选择项
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 主键ID
    ,risk_record_id -- 关联风评记录主键ID
    ,paper_id -- 关联问卷主键
    ,question_id -- 关联问题主键
    ,paper_no -- 问卷编号
    ,version -- 问卷版本号
    ,question_no -- 问题编号
    ,question_type -- 问题类型
    ,risk_option -- 选择项
    ,question -- 题目内容
    ,subject -- 选择项内容
    ,score -- 分数
    ,mut_risk_option -- 多选选择项
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nfss_ca_risk_record_item
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nfss_ca_risk_record_item exchange partition p_${batch_date} with table ${iol_schema}.nfss_ca_risk_record_item_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_ca_risk_record_item to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nfss_ca_risk_record_item_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_ca_risk_record_item',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);