/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_dbs
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_isbs_dbs drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_dbs drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_dbs add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_dbs partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- Internal Unique ID
    ,tmpref  -- 临时申报流水号
    ,ownextkey  -- Initial Entity Code
    ,ver  -- Version
    ,actiontype  -- 操作类型
    ,actiondesc  -- 修改/删除原因
    ,rptno  -- 申报号码
    ,country  -- 收款人常驻国家/地区编码
    ,isref  -- 是否保税'物项下付款
    ,paytype  -- 付款类型
    ,payattr  -- 付汇性质
    ,txcode  -- 交易编码1
    ,tc1amt  -- 相应金额1
    ,txcode2  -- 交易编码2
    ,tc2amt  -- 相应金额2
    ,impdate  -- 最迟装运日期
    ,contrno  -- 合同号
    ,invoino  -- 发票号
    ,billno  -- 提运单号
    ,contamt  -- 合同金额
    ,regno  -- 外汇局批件号/备案表号/业务编号
    ,crtuser  -- 填报人
    ,inptelc  -- 填报人电话
    ,rptdate  -- 申报日期
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.inr,chr(13),''),chr(10),'')  -- Internal Unique ID
    ,replace(replace(t1.tmpref,chr(13),''),chr(10),'')  -- 临时申报流水号
    ,replace(replace(t1.ownextkey,chr(13),''),chr(10),'')  -- Initial Entity Code
    ,replace(replace(t1.ver,chr(13),''),chr(10),'')  -- Version
    ,replace(replace(t1.actiontype,chr(13),''),chr(10),'')  -- 操作类型
    ,replace(replace(t1.actiondesc,chr(13),''),chr(10),'')  -- 修改/删除原因
    ,replace(replace(t1.rptno,chr(13),''),chr(10),'')  -- 申报号码
    ,replace(replace(t1.country,chr(13),''),chr(10),'')  -- 收款人常驻国家/地区编码
    ,replace(replace(t1.isref,chr(13),''),chr(10),'')  -- 是否保税'物项下付款
    ,replace(replace(t1.paytype,chr(13),''),chr(10),'')  -- 付款类型
    ,replace(replace(t1.payattr,chr(13),''),chr(10),'')  -- 付汇性质
    ,replace(replace(t1.txcode,chr(13),''),chr(10),'')  -- 交易编码1
    ,t1.tc1amt  -- 相应金额1
    ,replace(replace(t1.txcode2,chr(13),''),chr(10),'')  -- 交易编码2
    ,t1.tc2amt  -- 相应金额2
    ,t1.impdate  -- 最迟装运日期
    ,replace(replace(t1.contrno,chr(13),''),chr(10),'')  -- 合同号
    ,replace(replace(t1.invoino,chr(13),''),chr(10),'')  -- 发票号
    ,replace(replace(t1.billno,chr(13),''),chr(10),'')  -- 提运单号
    ,t1.contamt  -- 合同金额
    ,replace(replace(t1.regno,chr(13),''),chr(10),'')  -- 外汇局批件号/备案表号/业务编号
    ,replace(replace(t1.crtuser,chr(13),''),chr(10),'')  -- 填报人
    ,replace(replace(t1.inptelc,chr(13),''),chr(10),'')  -- 填报人电话
    ,t1.rptdate  -- 申报日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_dbs t1    --境内付款/承兑通知书-核销专用信
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_dbs',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);