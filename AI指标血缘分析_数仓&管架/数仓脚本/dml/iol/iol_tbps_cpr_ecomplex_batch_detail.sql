/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_ecomplex_batch_detail
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
drop table ${iol_schema}.tbps_cpr_ecomplex_batch_detail_ex purge;
alter table ${iol_schema}.tbps_cpr_ecomplex_batch_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.tbps_cpr_ecomplex_batch_detail;

-- 2.3 insert data to ex table
create table ${iol_schema}.tbps_cpr_ecomplex_batch_detail_ex nologging
compress
as
select * from ${iol_schema}.tbps_cpr_ecomplex_batch_detail where 0=1;

insert /*+ append */ into ${iol_schema}.tbps_cpr_ecomplex_batch_detail_ex(
    ebd_batchno -- 批次号,8位日期+8位序号
    ,ebd_seqno -- 序号，从1开始
    ,ebd_payeracno -- 付款账号
    ,ebd_payeracname -- 付款账号名称
    ,ebd_currency -- 币种
    ,ebd_payeeacno -- 收款账号
    ,ebd_payeeacname -- 收款账号名称
    ,ebd_payeeciftype -- 收款方账号类型:1：企业客户,2：个人客户
    ,ebd_priority -- 转账方式:2：实时,3：行内
    ,ebd_uniondeptid -- 收款方联行号
    ,ebd_uniondeptname -- 收款方银行名称
    ,ebd_amount -- 转账金额
    ,ebd_fee -- 转账手续费
    ,ebd_remark -- 备注
    ,ebd_transcode -- 交易码
    ,ebd_parentfee -- 手续费费率
    ,ebd_discountrate -- 折扣率
    ,ebd_errorcode -- 错误码
    ,ebd_errormsg -- 错误信息
    ,ebd_detailstate -- 状态
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ebd_batchno -- 批次号,8位日期+8位序号
    ,ebd_seqno -- 序号，从1开始
    ,ebd_payeracno -- 付款账号
    ,ebd_payeracname -- 付款账号名称
    ,ebd_currency -- 币种
    ,ebd_payeeacno -- 收款账号
    ,ebd_payeeacname -- 收款账号名称
    ,ebd_payeeciftype -- 收款方账号类型:1：企业客户,2：个人客户
    ,ebd_priority -- 转账方式:2：实时,3：行内
    ,ebd_uniondeptid -- 收款方联行号
    ,ebd_uniondeptname -- 收款方银行名称
    ,ebd_amount -- 转账金额
    ,ebd_fee -- 转账手续费
    ,ebd_remark -- 备注
    ,ebd_transcode -- 交易码
    ,ebd_parentfee -- 手续费费率
    ,ebd_discountrate -- 折扣率
    ,ebd_errorcode -- 错误码
    ,ebd_errormsg -- 错误信息
    ,ebd_detailstate -- 状态
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tbps_cpr_ecomplex_batch_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tbps_cpr_ecomplex_batch_detail exchange partition p_${batch_date} with table ${iol_schema}.tbps_cpr_ecomplex_batch_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_ecomplex_batch_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tbps_cpr_ecomplex_batch_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_ecomplex_batch_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);