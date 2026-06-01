/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_icms_business_info_total
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
drop table ${iol_schema}.icms_icms_business_info_total_ex purge;
alter table ${iol_schema}.icms_icms_business_info_total add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_icms_business_info_total;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_icms_business_info_total_ex nologging
compress
as
select * from ${iol_schema}.icms_icms_business_info_total where 0=1;

insert /*+ append */ into ${iol_schema}.icms_icms_business_info_total_ex(
    txndt -- 交易日期
    ,txntm -- 交易时间
    ,blngorgid -- 所属机构编号
    ,opertellerid -- 经办柜员编号
    ,opertellername -- 经办柜员名称
    ,authtellerid -- 授权柜员编号
    ,authtellername -- 授权柜员名称
    ,txnnum -- 交易码
    ,txndesc -- 交易描述
    ,bizsysevtid -- 业务系统流水号
    ,bcsevtid -- 核心系统流水号
    ,datasrccd -- 系统代码
    ,payagtid -- 付款账户
    ,rcvagtid -- 收款账户
    ,txnamt -- 交易金额
    ,etldt -- 数据日期
    ,menuid -- 柜面菜单码(智能网点系统必输)
    ,eftflag -- 金融交易类型(1-金融交易，2-非金融交易)
    ,servflag -- 业务交易类型(1-个人业务交易，2-对公业务交易，3-其他交易)
    ,acctflag -- 账户交易类型(1-账户开户交易，2-账户销户交易，3-账户变更交易)
    ,caflag -- 现金交易类型(1-现金交易，2-非现金交易)
    ,bdflag -- 存取款交易类型(1-存款交易，2-取款交易)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    txndt -- 交易日期
    ,txntm -- 交易时间
    ,blngorgid -- 所属机构编号
    ,opertellerid -- 经办柜员编号
    ,opertellername -- 经办柜员名称
    ,authtellerid -- 授权柜员编号
    ,authtellername -- 授权柜员名称
    ,txnnum -- 交易码
    ,txndesc -- 交易描述
    ,bizsysevtid -- 业务系统流水号
    ,bcsevtid -- 核心系统流水号
    ,datasrccd -- 系统代码
    ,payagtid -- 付款账户
    ,rcvagtid -- 收款账户
    ,txnamt -- 交易金额
    ,etldt -- 数据日期
    ,menuid -- 柜面菜单码(智能网点系统必输)
    ,eftflag -- 金融交易类型(1-金融交易，2-非金融交易)
    ,servflag -- 业务交易类型(1-个人业务交易，2-对公业务交易，3-其他交易)
    ,acctflag -- 账户交易类型(1-账户开户交易，2-账户销户交易，3-账户变更交易)
    ,caflag -- 现金交易类型(1-现金交易，2-非现金交易)
    ,bdflag -- 存取款交易类型(1-存款交易，2-取款交易)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_icms_business_info_total
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_icms_business_info_total exchange partition p_${batch_date} with table ${iol_schema}.icms_icms_business_info_total_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_icms_business_info_total to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_icms_business_info_total_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_icms_business_info_total',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);