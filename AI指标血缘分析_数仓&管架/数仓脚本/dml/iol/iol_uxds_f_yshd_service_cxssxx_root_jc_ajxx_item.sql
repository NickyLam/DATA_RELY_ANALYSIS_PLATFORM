/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_yshd_service_cxssxx_root_jc_ajxx_item
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
drop table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item_ex purge;
alter table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,sjskze -- 实缴税款总额
    ,jcssqjq -- 检查所属期间起
    ,swjctzssdrq -- 税务检查通知书送达日期
    ,yjskze -- 应缴税款总额
    ,sjznjze -- 实缴滞纳金总额
    ,zxdjrq -- 执行登记日期
    ,rwxdrq -- 任务下达日期
    ,yjfkze -- 应缴罚款总额
    ,sjfkze -- 实缴罚款总额
    ,sljsrq -- 审理结束日期
    ,larq -- 立案日期
    ,jcjsrq -- 检查结束日期
    ,zxwbrq -- 执行完毕日期
    ,shxydm -- 社会信用代码
    ,ajmc -- 案件名称
    ,lrrq -- 录入日期
    ,jcdjrq -- 检查登记日期
    ,ajlxmc -- 案件类型名称
    ,jcrqq -- 检查日期起
    ,sldjrq -- 审理登记日期
    ,item -- 关联标签
    ,jcssqjz -- 检查所属期间止
    ,yjznjze -- 应缴滞纳金总额
    ,jcajbh -- 稽查案件编号
    ,slyj2 -- 审理意见
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,sjskze -- 实缴税款总额
    ,jcssqjq -- 检查所属期间起
    ,swjctzssdrq -- 税务检查通知书送达日期
    ,yjskze -- 应缴税款总额
    ,sjznjze -- 实缴滞纳金总额
    ,zxdjrq -- 执行登记日期
    ,rwxdrq -- 任务下达日期
    ,yjfkze -- 应缴罚款总额
    ,sjfkze -- 实缴罚款总额
    ,sljsrq -- 审理结束日期
    ,larq -- 立案日期
    ,jcjsrq -- 检查结束日期
    ,zxwbrq -- 执行完毕日期
    ,shxydm -- 社会信用代码
    ,ajmc -- 案件名称
    ,lrrq -- 录入日期
    ,jcdjrq -- 检查登记日期
    ,ajlxmc -- 案件类型名称
    ,jcrqq -- 检查日期起
    ,sldjrq -- 审理登记日期
    ,item -- 关联标签
    ,jcssqjz -- 检查所属期间止
    ,yjznjze -- 应缴滞纳金总额
    ,jcajbh -- 稽查案件编号
    ,slyj2 -- 审理意见
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_yshd_service_cxssxx_root_jc_ajxx_item',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);