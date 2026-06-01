/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_consume_fin_special_indicator
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
drop table ${iol_schema}.uxds_consume_fin_special_indicator_ex purge;
alter table ${iol_schema}.uxds_consume_fin_special_indicator add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_consume_fin_special_indicator;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_consume_fin_special_indicator_ex nologging
compress
as
select * from ${iol_schema}.uxds_consume_fin_special_indicator where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_consume_fin_special_indicator_ex(
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录同步时间
    ,chg_seq -- 变动序号
    ,project_seq -- 项目序号
    ,org_id -- 机构ID
    ,ed -- 截止日期
    ,statement_year -- 报表年度
    ,report_type_code -- 报告类型编码
    ,statement_type_code -- 报表类型编码
    ,announcement_date -- 公告日期
    ,lastest_symbol -- 最新标志
    ,project_announced_name -- 项目公布名称
    ,project_speci_name_code -- 项目规范名称编码
    ,numerical_value -- 数值
    ,unit -- 单位
    ,currency_code -- 币种名称编码
    ,isvalid -- 是否有效
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录同步时间
    ,chg_seq -- 变动序号
    ,project_seq -- 项目序号
    ,org_id -- 机构ID
    ,ed -- 截止日期
    ,statement_year -- 报表年度
    ,report_type_code -- 报告类型编码
    ,statement_type_code -- 报表类型编码
    ,announcement_date -- 公告日期
    ,lastest_symbol -- 最新标志
    ,project_announced_name -- 项目公布名称
    ,project_speci_name_code -- 项目规范名称编码
    ,numerical_value -- 数值
    ,unit -- 单位
    ,currency_code -- 币种名称编码
    ,isvalid -- 是否有效
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_consume_fin_special_indicator
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_consume_fin_special_indicator exchange partition p_${batch_date} with table ${iol_schema}.uxds_consume_fin_special_indicator_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_consume_fin_special_indicator to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_consume_fin_special_indicator_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_consume_fin_special_indicator',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);