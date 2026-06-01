/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_chb_month_report_detail
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
drop table ${iol_schema}.fams_chb_month_report_detail_ex purge;
alter table ${iol_schema}.fams_chb_month_report_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.fams_chb_month_report_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.fams_chb_month_report_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_chb_month_report_detail where 0=1;

insert /*+ append */ into ${iol_schema}.fams_chb_month_report_detail_ex(
    termid -- 期数
    ,reporttype -- 报表类型：prod-产品，balance-资产负债表，deposit-结构性存款
    ,propertycode -- 属性代码
    ,prodcounts -- 本期产品只数
    ,prodamount -- 本期总募集金额
    ,prodnetamount -- 本期净募集金额
    ,durationprodcounts -- 期末存续产品只数
    ,balance -- 期末余额
    ,bottombalance -- 期末余额（穿透后）
    ,customerprofit -- 本期客户收益
    ,bankprofit -- 本期银行收益
    ,prodyield -- 本期产品收益率
    ,detailuuid -- 
    ,org_code -- 机构代码
    ,dept_code -- 部门代码
    ,reportuuid -- 月报主表主键
    ,prodpayamount -- 本期兑付金额
    ,xgdurationprodcounts -- 合规新产品期末存续只数
    ,xgbalance -- 合规新产品期末余额
    ,xgbottombalance -- 合规新产品期末余额（穿透后）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    termid -- 期数
    ,reporttype -- 报表类型：prod-产品，balance-资产负债表，deposit-结构性存款
    ,propertycode -- 属性代码
    ,prodcounts -- 本期产品只数
    ,prodamount -- 本期总募集金额
    ,prodnetamount -- 本期净募集金额
    ,durationprodcounts -- 期末存续产品只数
    ,balance -- 期末余额
    ,bottombalance -- 期末余额（穿透后）
    ,customerprofit -- 本期客户收益
    ,bankprofit -- 本期银行收益
    ,prodyield -- 本期产品收益率
    ,detailuuid -- 
    ,org_code -- 机构代码
    ,dept_code -- 部门代码
    ,reportuuid -- 月报主表主键
    ,prodpayamount -- 本期兑付金额
    ,xgdurationprodcounts -- 合规新产品期末存续只数
    ,xgbalance -- 合规新产品期末余额
    ,xgbottombalance -- 合规新产品期末余额（穿透后）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.fams_chb_month_report_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.fams_chb_month_report_detail exchange partition p_${batch_date} with table ${iol_schema}.fams_chb_month_report_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_chb_month_report_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.fams_chb_month_report_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_chb_month_report_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);