/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_b_v_result
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
drop table ${iol_schema}.icms_cl_b_v_result_ex purge;
alter table ${iol_schema}.icms_cl_b_v_result add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_cl_b_v_result;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_cl_b_v_result_ex nologging
compress
as
select * from ${iol_schema}.icms_cl_b_v_result where 0=1;

insert /*+ append */ into ${iol_schema}.icms_cl_b_v_result_ex(
    totalpaymentinner -- 累计放款内部)
    ,businessno -- 业务编号
    ,totalrepaymentinner -- 累计还款内部)
    ,isdeal -- 是否已处理
    ,totalrepaymentout -- 累计还款外部)
    ,updatedate -- 处理日期
    ,exposurebalanceinner -- 敞口余额内部)
    ,updateuserid -- 处理人
    ,totalpaymentout -- 累计放款外部)
    ,updateorgid -- 处理机构
    ,nominalbalanceinner -- 名义余额内部)
    ,balanceupdatetimeout -- 余额更新时间外部)
    ,balanceupdatetimeinner -- 余额更新时间内部)
    ,serialno -- 流水号
    ,relaserialno -- 关联流水号
    ,exposurebalanceout -- 敞口余额外部)
    ,nominalbalanceout -- 名义余额外部)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    totalpaymentinner -- 累计放款内部)
    ,businessno -- 业务编号
    ,totalrepaymentinner -- 累计还款内部)
    ,isdeal -- 是否已处理
    ,totalrepaymentout -- 累计还款外部)
    ,updatedate -- 处理日期
    ,exposurebalanceinner -- 敞口余额内部)
    ,updateuserid -- 处理人
    ,totalpaymentout -- 累计放款外部)
    ,updateorgid -- 处理机构
    ,nominalbalanceinner -- 名义余额内部)
    ,balanceupdatetimeout -- 余额更新时间外部)
    ,balanceupdatetimeinner -- 余额更新时间内部)
    ,serialno -- 流水号
    ,relaserialno -- 关联流水号
    ,exposurebalanceout -- 敞口余额外部)
    ,nominalbalanceout -- 名义余额外部)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_cl_b_v_result
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_cl_b_v_result exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_b_v_result_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_b_v_result to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_cl_b_v_result_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_b_v_result',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);