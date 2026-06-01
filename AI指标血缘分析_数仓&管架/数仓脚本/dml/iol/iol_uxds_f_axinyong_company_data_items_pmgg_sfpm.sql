/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_axinyong_company_data_items_pmgg_sfpm
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
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm_ex purge;
alter table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,punishmentorgan -- 执行法院
    ,geographicallocation -- 所属地域
    ,datakeyid -- 数据主键id
    ,datatype -- 数据类型值
    ,transactionprice -- 成交价格
    ,currentprice -- 当前价格
    ,startingprice -- 起拍价格
    ,auctionname -- 拍卖物名称或所有权人
    ,noticecontent -- 公告内容
    ,auctionstage -- 拍卖阶段
    ,announcedate -- 公告日期
    ,closingtime -- 成交时间
    ,pmgg_sfpm -- 关联标签
    ,casenumber -- 执行案号
    ,noticename -- 公告名称
    ,auctionstatus -- 拍卖状态
    ,startingtime -- 起拍时间
    ,name -- 被执行人
    ,estimate -- 评估值
    ,deposit -- 保证金
    ,auctiontype -- 拍卖类型
    ,referencecasenumber -- 执行依据法律文书
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,punishmentorgan -- 执行法院
    ,geographicallocation -- 所属地域
    ,datakeyid -- 数据主键id
    ,datatype -- 数据类型值
    ,transactionprice -- 成交价格
    ,currentprice -- 当前价格
    ,startingprice -- 起拍价格
    ,auctionname -- 拍卖物名称或所有权人
    ,noticecontent -- 公告内容
    ,auctionstage -- 拍卖阶段
    ,announcedate -- 公告日期
    ,closingtime -- 成交时间
    ,pmgg_sfpm -- 关联标签
    ,casenumber -- 执行案号
    ,noticename -- 公告名称
    ,auctionstatus -- 拍卖状态
    ,startingtime -- 起拍时间
    ,name -- 被执行人
    ,estimate -- 评估值
    ,deposit -- 保证金
    ,auctiontype -- 拍卖类型
    ,referencecasenumber -- 执行依据法律文书
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_pmgg_sfpm_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_axinyong_company_data_items_pmgg_sfpm',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);