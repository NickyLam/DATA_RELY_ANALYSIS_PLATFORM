/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ds_accounting_flow
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
drop table ${iol_schema}.icms_ds_accounting_flow_ex purge;
alter table ${iol_schema}.icms_ds_accounting_flow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_ds_accounting_flow truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_ds_accounting_flow_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ds_accounting_flow where 0=1;

insert /*+ append */ into ${iol_schema}.icms_ds_accounting_flow_ex(
    org -- 内部机构号
    ,cpstxnseq -- 核心交易流水
    ,cardno -- 卡号
    ,currcd -- 币种
    ,txncode -- 交易码
    ,txndesc -- 交易描述
    ,dbcrind -- 借贷标记
    ,postamt -- 入账金额
    ,postglind -- 入账方式
    ,owningbranch -- 支行
    ,subject -- 科目
    ,redflag -- 红蓝字标识
    ,queue -- 排序
    ,productcd -- 产品号
    ,refnbr -- 借据号
    ,agegroup -- 账龄组
    ,plannbr -- 信用计划号
    ,bnpgroup -- 余额成分组
    ,bankgroupid -- 参贷方案代码
    ,bankno -- 银行代码
    ,term -- 期数
    ,batchdate -- 批量
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    org -- 内部机构号
    ,cpstxnseq -- 核心交易流水
    ,cardno -- 卡号
    ,currcd -- 币种
    ,txncode -- 交易码
    ,txndesc -- 交易描述
    ,dbcrind -- 借贷标记
    ,postamt -- 入账金额
    ,postglind -- 入账方式
    ,owningbranch -- 支行
    ,subject -- 科目
    ,redflag -- 红蓝字标识
    ,queue -- 排序
    ,productcd -- 产品号
    ,refnbr -- 借据号
    ,agegroup -- 账龄组
    ,plannbr -- 信用计划号
    ,bnpgroup -- 余额成分组
    ,bankgroupid -- 参贷方案代码
    ,bankno -- 银行代码
    ,term -- 期数
    ,batchdate -- 批量
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_ds_accounting_flow
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_ds_accounting_flow exchange partition p_${batch_date} with table ${iol_schema}.icms_ds_accounting_flow_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ds_accounting_flow to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_ds_accounting_flow_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ds_accounting_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);