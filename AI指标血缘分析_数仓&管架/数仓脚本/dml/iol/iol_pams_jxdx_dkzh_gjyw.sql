/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_dkzh_gjyw
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
drop table ${iol_schema}.pams_jxdx_dkzh_gjyw_ex purge;
alter table ${iol_schema}.pams_jxdx_dkzh_gjyw add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.pams_jxdx_dkzh_gjyw;

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxdx_dkzh_gjyw_ex nologging
compress
as
select * from ${iol_schema}.pams_jxdx_dkzh_gjyw where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxdx_dkzh_gjyw_ex(
    jxdxdh -- 贷款绩效对象代号
    ,zhdh -- 账户代号
    ,zzh -- 子账号
    ,jjh -- 借据号
    ,pjh -- 票据号
    ,cph -- 产品号
    ,xyzbh -- 信用证编号
    ,xyzdjbh -- 信用证单据编号
    ,bz -- 币种
    ,dkje -- 贷款金额
    ,zrmbhl -- 折人民币汇率
    ,bzjje -- 保证金金额
    ,cdje -- 存单金额
    ,ypbzjbl -- 押品保证金比例
    ,ypbzjblqj -- 押品保证金比例区间：0-低风险,1-类低风险,2-敞口,99-未知
    ,ypbzjblqj1 -- 一级福费廷对应信用证押品保证金比例区间：0-低风险,1-类低风险,2-敞口,99-未知
    ,tjrq -- 数据入库日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    jxdxdh -- 贷款绩效对象代号
    ,zhdh -- 账户代号
    ,zzh -- 子账号
    ,jjh -- 借据号
    ,pjh -- 票据号
    ,cph -- 产品号
    ,xyzbh -- 信用证编号
    ,xyzdjbh -- 信用证单据编号
    ,bz -- 币种
    ,dkje -- 贷款金额
    ,zrmbhl -- 折人民币汇率
    ,bzjje -- 保证金金额
    ,cdje -- 存单金额
    ,ypbzjbl -- 押品保证金比例
    ,ypbzjblqj -- 押品保证金比例区间：0-低风险,1-类低风险,2-敞口,99-未知
    ,ypbzjblqj1 -- 一级福费廷对应信用证押品保证金比例区间：0-低风险,1-类低风险,2-敞口,99-未知
    ,tjrq -- 数据入库日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxdx_dkzh_gjyw
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxdx_dkzh_gjyw exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_dkzh_gjyw_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_dkzh_gjyw to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxdx_dkzh_gjyw_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_dkzh_gjyw',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);