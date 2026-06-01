/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_v_ibs_busicq
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
drop table ${iol_schema}.nibs_v_ibs_busicq_ex purge;
alter table ${iol_schema}.nibs_v_ibs_busicq add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.nibs_v_ibs_busicq;

-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_v_ibs_busicq_ex nologging
compress
as
select * from ${iol_schema}.nibs_v_ibs_busicq where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_v_ibs_busicq_ex(
    channeldate -- 业务日期
    ,tx_teller_num -- 办理业务柜员号
    ,tx_teller_name -- 柜员姓名
    ,tx_org_num -- 机构号
    ,tx_org_name -- 机构名称
    ,auth_tel_num -- 授权柜员号
    ,auth_tel_name -- 授权柜员姓名
    ,authbranchnum -- 授权机构号
    ,authbranchname -- 授权机构名称
    ,cust_num -- 客户号
    ,queuegettime -- 客户取号时间
    ,queuecalltime -- 柜员叫号时间
    ,transtarttime -- 开始办理业务时间
    ,tranendtime -- 业务结束时间
    ,channeltrancode -- 交易码
    ,menuname -- 交易名称
    ,authstarttime -- 授权开始时间
    ,authendtime -- 授权结束时间
    ,auth_mould -- 授权模式
    ,tx_seq_num -- 业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    channeldate -- 业务日期
    ,tx_teller_num -- 办理业务柜员号
    ,tx_teller_name -- 柜员姓名
    ,tx_org_num -- 机构号
    ,tx_org_name -- 机构名称
    ,auth_tel_num -- 授权柜员号
    ,auth_tel_name -- 授权柜员姓名
    ,authbranchnum -- 授权机构号
    ,authbranchname -- 授权机构名称
    ,cust_num -- 客户号
    ,queuegettime -- 客户取号时间
    ,queuecalltime -- 柜员叫号时间
    ,transtarttime -- 开始办理业务时间
    ,tranendtime -- 业务结束时间
    ,channeltrancode -- 交易码
    ,menuname -- 交易名称
    ,authstarttime -- 授权开始时间
    ,authendtime -- 授权结束时间
    ,auth_mould -- 授权模式
    ,tx_seq_num -- 业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_v_ibs_busicq
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nibs_v_ibs_busicq exchange partition p_${batch_date} with table ${iol_schema}.nibs_v_ibs_busicq_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_v_ibs_busicq to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_v_ibs_busicq_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_v_ibs_busicq',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);