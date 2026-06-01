/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_report_overdue
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
drop table ${iol_schema}.icms_report_overdue_ex purge;
alter table ${iol_schema}.icms_report_overdue add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_report_overdue;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_report_overdue_ex nologging
compress
as
select * from ${iol_schema}.icms_report_overdue where 0=1;

insert /*+ append */ into ${iol_schema}.icms_report_overdue_ex(
    xh -- 序号
    ,pcrq -- 批次日期
    ,lb -- 类别
    ,bjylxzdyqts -- 本金与利息最大逾期天数
    ,khmc -- 客户名称
    ,jbjg -- 经办机构
    ,ssjt -- 所属集团
    ,ywpz -- 业务品种
    ,zhye -- 整户余额(单位：元)
    ,zhckye -- 整户敞口余额(单位：元)
    ,yqywye -- 逾期业务余额(单位：元)
    ,wjfl -- 五级分类
    ,yqqsr -- 逾期起始日
    ,bjzdyqts -- 本金最大逾期天数
    ,lxzdyqts -- 利息最大逾期天数
    ,yqbjje -- 逾期本金金额(单位：元)
    ,yqlxje -- 逾期利息金额(单位：元)
    ,yswslx -- 应收未收利息(单位：元)
    ,faxje -- 复息金额(单位：元)
    ,fuxje -- 罚息金额(单位：元)
    ,hj -- 合计(单位：元)
    ,yqdqtrq -- 逾期达7天日期
    ,yqdsltrq -- 逾期达30天日期
    ,yqdjltrq -- 逾期达90天日期
    ,yqdeqltrq -- 逾期达270天日期
    ,yqdslltrq -- 逾期达360天日期
    ,sjrq -- 数据日期
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,ylcs1 -- 参数1
    ,ylcs2 -- 参数2
    ,ylcs3 -- 参数3
    ,ylcs4 -- 参数4
    ,ylcs5 -- 参数5
    ,ylcs6 -- 参数6
    ,ylcs7 -- 参数7
    ,ylcs8 -- 参数8
    ,ylcs9 -- 参数9
    ,ylcs10 -- 参数10
    ,ylcs11 -- 参数11
    ,ylcs12 -- 参数12
    ,ylcs13 -- 参数13
    ,ylcs14 -- 参数14
    ,ylcs15 -- 参数15
    ,ylcs16 -- 参数16
    ,ylcs17 -- 参数17
    ,ylcs18 -- 参数18
    ,ylcs19 -- 参数19
    ,ylcs20 -- 参数20
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    xh -- 序号
    ,pcrq -- 批次日期
    ,lb -- 类别
    ,bjylxzdyqts -- 本金与利息最大逾期天数
    ,khmc -- 客户名称
    ,jbjg -- 经办机构
    ,ssjt -- 所属集团
    ,ywpz -- 业务品种
    ,zhye -- 整户余额(单位：元)
    ,zhckye -- 整户敞口余额(单位：元)
    ,yqywye -- 逾期业务余额(单位：元)
    ,wjfl -- 五级分类
    ,yqqsr -- 逾期起始日
    ,bjzdyqts -- 本金最大逾期天数
    ,lxzdyqts -- 利息最大逾期天数
    ,yqbjje -- 逾期本金金额(单位：元)
    ,yqlxje -- 逾期利息金额(单位：元)
    ,yswslx -- 应收未收利息(单位：元)
    ,faxje -- 复息金额(单位：元)
    ,fuxje -- 罚息金额(单位：元)
    ,hj -- 合计(单位：元)
    ,yqdqtrq -- 逾期达7天日期
    ,yqdsltrq -- 逾期达30天日期
    ,yqdjltrq -- 逾期达90天日期
    ,yqdeqltrq -- 逾期达270天日期
    ,yqdslltrq -- 逾期达360天日期
    ,sjrq -- 数据日期
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,ylcs1 -- 参数1
    ,ylcs2 -- 参数2
    ,ylcs3 -- 参数3
    ,ylcs4 -- 参数4
    ,ylcs5 -- 参数5
    ,ylcs6 -- 参数6
    ,ylcs7 -- 参数7
    ,ylcs8 -- 参数8
    ,ylcs9 -- 参数9
    ,ylcs10 -- 参数10
    ,ylcs11 -- 参数11
    ,ylcs12 -- 参数12
    ,ylcs13 -- 参数13
    ,ylcs14 -- 参数14
    ,ylcs15 -- 参数15
    ,ylcs16 -- 参数16
    ,ylcs17 -- 参数17
    ,ylcs18 -- 参数18
    ,ylcs19 -- 参数19
    ,ylcs20 -- 参数20
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_report_overdue
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_report_overdue exchange partition p_${batch_date} with table ${iol_schema}.icms_report_overdue_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_report_overdue to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_report_overdue_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_report_overdue',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);