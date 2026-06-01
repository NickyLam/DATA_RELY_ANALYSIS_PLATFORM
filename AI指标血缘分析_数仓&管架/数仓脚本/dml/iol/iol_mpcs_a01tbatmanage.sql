/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a01tbatmanage
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
drop table ${iol_schema}.mpcs_a01tbatmanage_ex purge;
alter table ${iol_schema}.mpcs_a01tbatmanage add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a01tbatmanage truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a01tbatmanage_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a01tbatmanage where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a01tbatmanage_ex(
    chnlid -- 
    ,batchtype -- 
    ,batchdt -- 
    ,batchno -- 批次号
    ,fntdt -- 
    ,fntseqno -- 
    ,filename -- 
    ,custno -- 
    ,payacctno -- 
    ,payacctname -- 
    ,ccy -- 
    ,totalnum -- 
    ,succnum -- 
    ,failnum -- 
    ,totalamt -- 
    ,succamt -- 
    ,failamt -- 
    ,trndtts -- 
    ,tmpflag -- 
    ,tmpacctno -- 
    ,tmpacctname -- 
    ,memo -- 
    ,stat -- 
    ,reserve -- 
    ,crossflag -- 跨行标识:0-本行1-跨行
    ,otherflag -- 他行标识
    ,inneracno -- 过渡内部户账号
    ,inneracna -- 过渡内部户户名
    ,rspcd -- 返回码
    ,dataid -- 核心外围流水号
    ,hostseqno -- 核心流水号
    ,hostseqdt -- 核心日期
    ,brcno -- 开户机构
    ,tlrno -- 交易柜员
    ,realchn -- 实际代发系统标识 1-薪酬服务平台 0-企业网银
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    chnlid -- 
    ,batchtype -- 
    ,batchdt -- 
    ,batchno -- 批次号
    ,fntdt -- 
    ,fntseqno -- 
    ,filename -- 
    ,custno -- 
    ,payacctno -- 
    ,payacctname -- 
    ,ccy -- 
    ,totalnum -- 
    ,succnum -- 
    ,failnum -- 
    ,totalamt -- 
    ,succamt -- 
    ,failamt -- 
    ,trndtts -- 
    ,tmpflag -- 
    ,tmpacctno -- 
    ,tmpacctname -- 
    ,memo -- 
    ,stat -- 
    ,reserve -- 
    ,crossflag -- 跨行标识:0-本行1-跨行
    ,otherflag -- 他行标识
    ,inneracno -- 过渡内部户账号
    ,inneracna -- 过渡内部户户名
    ,rspcd -- 返回码
    ,dataid -- 核心外围流水号
    ,hostseqno -- 核心流水号
    ,hostseqdt -- 核心日期
    ,brcno -- 开户机构
    ,tlrno -- 交易柜员
    ,realchn -- 实际代发系统标识 1-薪酬服务平台 0-企业网银
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a01tbatmanage
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a01tbatmanage exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a01tbatmanage_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a01tbatmanage to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a01tbatmanage_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a01tbatmanage',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);