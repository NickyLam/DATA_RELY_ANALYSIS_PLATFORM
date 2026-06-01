/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_isbs_dba
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
alter table ${idl_schema}.aml_isbs_dba drop partition p_${last_date};
alter table ${idl_schema}.aml_isbs_dba drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_isbs_dba add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_isbs_dba partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,inr  -- Internal Unique ID
    ,tmpref  -- 临时申报流水号
    ,ownextkey  -- Initial Entity Code
    ,ver  -- Version
    ,actiontype  -- 操作类型
    ,actiondesc  -- 修改/删除原因
    ,rptno  -- 申报号码
    ,custype  -- 收款人类型
    ,idcode  -- 个人身份证件号码
    ,custcod  -- 组织机构
    ,custnm  -- 收款人名称
    ,oppuser  -- 付款人名称
    ,txccy  -- 收入款币种
    ,txamt  -- 收入款金额
    ,exrate  -- 结汇汇率
    ,lcyamt  -- 结汇金额
    ,lcyacc  -- 人民币帐号/银行卡号
    ,fcyamt  -- 现汇金额
    ,fcyacc  -- 外汇帐号/银行卡号
    ,othamt  -- 其它金额
    ,othacc  -- 其它帐号/银行卡号
    ,methods  -- 结算方式
    ,buscode  -- 银行业务编号
    ,inchargeccy  -- 国内银行扣费币种
    ,inchargeamt  -- 国内银行扣费金额
    ,outchargeccy  -- 国外银行扣费币种
    ,outchargeamt  -- 国外银行扣费金额
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
    ,replace(replace(t1.custype,chr(13),''),chr(10),'')  -- 收款人类型
    ,replace(replace(t1.idcode,chr(13),''),chr(10),'')  -- 个人身份证件号码
    ,replace(replace(t1.custcod,chr(13),''),chr(10),'')  -- 组织机构
    ,replace(replace(t1.custnm,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.oppuser,chr(13),''),chr(10),'')  -- 付款人名称
    ,replace(replace(t1.txccy,chr(13),''),chr(10),'')  -- 收入款币种
    ,t1.txamt  -- 收入款金额
    ,t1.exrate  -- 结汇汇率
    ,t1.lcyamt  -- 结汇金额
    ,replace(replace(t1.lcyacc,chr(13),''),chr(10),'')  -- 人民币帐号/银行卡号
    ,t1.fcyamt  -- 现汇金额
    ,replace(replace(t1.fcyacc,chr(13),''),chr(10),'')  -- 外汇帐号/银行卡号
    ,t1.othamt  -- 其它金额
    ,replace(replace(t1.othacc,chr(13),''),chr(10),'')  -- 其它帐号/银行卡号
    ,replace(replace(t1.methods,chr(13),''),chr(10),'')  -- 结算方式
    ,replace(replace(t1.buscode,chr(13),''),chr(10),'')  -- 银行业务编号
    ,replace(replace(t1.inchargeccy,chr(13),''),chr(10),'')  -- 国内银行扣费币种
    ,t1.inchargeamt  -- 国内银行扣费金额
    ,replace(replace(t1.outchargeccy,chr(13),''),chr(10),'')  -- 国外银行扣费币种
    ,t1.outchargeamt  -- 国外银行扣费金额
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_dba t1    --涉外收入申报单-基础信息
where t1.start_dt <=to_date('${batch_date}','yyyymmdd') and t1.end_dt >to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_isbs_dba',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);