/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_dkzhqmx
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
drop table ${iol_schema}.pams_jxdx_dkzhqmx_ex purge;
alter table ${iol_schema}.pams_jxdx_dkzhqmx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.pams_jxdx_dkzhqmx;

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxdx_dkzhqmx_ex nologging
compress
as
select * from ${iol_schema}.pams_jxdx_dkzhqmx where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxdx_dkzhqmx_ex(
    jxdxdh -- 绩效对象代号
    ,qsrq -- 起始日期
    ,jsrq -- 结束日期
    ,bz -- 币种
    ,jgdh -- 机构代号
    ,kmh -- 科目号
    ,cph -- 产品号
    ,ywpz -- 业务品种
    ,yqkm -- 逾期科目
    ,khrq -- 开户日期
    ,ffrq -- 发放日期
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,xhrq -- 销户日期
    ,qx -- 期限
    ,nll -- 年利率
    ,qynll -- 逾期年利率
    ,bjyqts -- 本金逾期天数
    ,lxyqts -- 利息逾期天数
    ,zhzt -- 账户状态
    ,zhdh -- 账号
    ,zzh -- 子账号
    ,hxbz -- 核销标志
    ,sndkbz -- 涉农贷款标志
    ,lhdkbz -- 绿色贷款标志
    ,wldkbz -- 网络贷款标志
    ,se -- 税额
    ,drlxsr -- 当日利息收入
    ,jqrq -- 结清日期
    ,xwdkbs -- 小微贷款标识
    ,yqxyss -- 预计信用损失
    ,jjzt -- 借据状态
    ,gylrzcplx -- 
    ,zycklx -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    jxdxdh -- 绩效对象代号
    ,qsrq -- 起始日期
    ,jsrq -- 结束日期
    ,bz -- 币种
    ,jgdh -- 机构代号
    ,kmh -- 科目号
    ,cph -- 产品号
    ,ywpz -- 业务品种
    ,yqkm -- 逾期科目
    ,khrq -- 开户日期
    ,ffrq -- 发放日期
    ,qxrq -- 起息日期
    ,dqrq -- 到期日期
    ,xhrq -- 销户日期
    ,qx -- 期限
    ,nll -- 年利率
    ,qynll -- 逾期年利率
    ,bjyqts -- 本金逾期天数
    ,lxyqts -- 利息逾期天数
    ,zhzt -- 账户状态
    ,zhdh -- 账号
    ,zzh -- 子账号
    ,hxbz -- 核销标志
    ,sndkbz -- 涉农贷款标志
    ,lhdkbz -- 绿色贷款标志
    ,wldkbz -- 网络贷款标志
    ,se -- 税额
    ,drlxsr -- 当日利息收入
    ,jqrq -- 结清日期
    ,xwdkbs -- 小微贷款标识
    ,yqxyss -- 预计信用损失
    ,jjzt -- 借据状态
    ,gylrzcplx -- 
    ,zycklx -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxdx_dkzhqmx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxdx_dkzhqmx exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_dkzhqmx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_dkzhqmx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxdx_dkzhqmx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_dkzhqmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);