/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_sfggmxgrjk_data_preservation
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
drop table ${iol_schema}.uxds_f_sfggmxgrjk_data_preservation_ex purge;
alter table ${iol_schema}.uxds_f_sfggmxgrjk_data_preservation add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_sfggmxgrjk_data_preservation truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_sfggmxgrjk_data_preservation_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_sfggmxgrjk_data_preservation where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_sfggmxgrjk_data_preservation_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,count_count_total -- 案件总数
    ,count_count_wei_beigao -- 被告未结案总数
    ,count_count_beigao -- 被告总数
    ,count_count_yuangao -- 原告总数
    ,count_money_beigao -- 被告金额
    ,count_money_jie_yuangao -- 原告已结金额
    ,count_area_stat -- 涉案时间分布
    ,count_ay_stat -- 涉案案由分布
    ,count_money_wei_yuangao -- 原告未结案金额
    ,count_jafs_stat -- 结案方式分布
    ,count_count_other -- 第三人总数
    ,data_preservation -- 关联标签
    ,count_money_yuangao -- 原告金额
    ,count_money_wei_beigao -- 被告未结案金额
    ,count_larq_stat -- 涉案地点分布
    ,count_count_wei_other -- 第三人未结案总数
    ,count_count_wei_yuangao -- 原告未结案总数
    ,count_money_jie_total -- 已结案金额
    ,count_money_jie_beigao -- 被告已结案金额
    ,count_money_total -- 涉案总金额
    ,count_count_wei_total -- 未结案总数
    ,count_count_jie_beigao -- 被告已结案总数
    ,cases -- cases
    ,count_money_wei_total -- 未结案金额
    ,count_money_other -- 第三人金额
    ,count_money_wei_percent -- 未结案金额百分比
    ,count_money_jie_other -- 第三人已结案金额
    ,count_money_wei_other -- 第三人未结案金额
    ,count_count_jie_yuangao -- 原告已结案总数
    ,count_count_jie_total -- 已结案总数
    ,count_count_jie_other -- 第三人已结案总数
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,count_count_total -- 案件总数
    ,count_count_wei_beigao -- 被告未结案总数
    ,count_count_beigao -- 被告总数
    ,count_count_yuangao -- 原告总数
    ,count_money_beigao -- 被告金额
    ,count_money_jie_yuangao -- 原告已结金额
    ,count_area_stat -- 涉案时间分布
    ,count_ay_stat -- 涉案案由分布
    ,count_money_wei_yuangao -- 原告未结案金额
    ,count_jafs_stat -- 结案方式分布
    ,count_count_other -- 第三人总数
    ,data_preservation -- 关联标签
    ,count_money_yuangao -- 原告金额
    ,count_money_wei_beigao -- 被告未结案金额
    ,count_larq_stat -- 涉案地点分布
    ,count_count_wei_other -- 第三人未结案总数
    ,count_count_wei_yuangao -- 原告未结案总数
    ,count_money_jie_total -- 已结案金额
    ,count_money_jie_beigao -- 被告已结案金额
    ,count_money_total -- 涉案总金额
    ,count_count_wei_total -- 未结案总数
    ,count_count_jie_beigao -- 被告已结案总数
    ,cases -- cases
    ,count_money_wei_total -- 未结案金额
    ,count_money_other -- 第三人金额
    ,count_money_wei_percent -- 未结案金额百分比
    ,count_money_jie_other -- 第三人已结案金额
    ,count_money_wei_other -- 第三人未结案金额
    ,count_count_jie_yuangao -- 原告已结案总数
    ,count_count_jie_total -- 已结案总数
    ,count_count_jie_other -- 第三人已结案总数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_sfggmxgrjk_data_preservation
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_sfggmxgrjk_data_preservation exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_sfggmxgrjk_data_preservation_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_sfggmxgrjk_data_preservation to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_sfggmxgrjk_data_preservation_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_sfggmxgrjk_data_preservation',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);