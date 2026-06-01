/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_contact_business
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
drop table ${iol_schema}.icms_customer_contact_business_ex purge;
alter table ${iol_schema}.icms_customer_contact_business add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_customer_contact_business;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_customer_contact_business_ex nologging
compress
as
select * from ${iol_schema}.icms_customer_contact_business where 0=1;

insert /*+ append */ into ${iol_schema}.icms_customer_contact_business_ex(
    creditserialno -- 对象号(风险监测-客户联系监测授信额度流水号)
    ,updatedate -- 更新日期
    ,duebillserialno -- 借据编号
    ,operateuserid -- 经办人
    ,customerid -- 客户编号
    ,contactserialno -- 对象号(风险监测-客户联系监测流水号)
    ,marurity -- 到期日期
    ,operateorgid -- 经办机构
    ,serialno -- 流水号
    ,objectno -- 对象号(风险监测主表流水号)
    ,productid -- 业务品种
    ,putoutsum -- 出账金额
    ,inputuserid -- 登记人
    ,riskclassify -- 风险分类
    ,inputdate -- 登记日期
    ,bcserialno -- 额度合同编号
    ,currentsum -- 当期金额
    ,updateuserid -- 更新人编号
    ,updateorgid -- 更新人机构编号
    ,inputorgid -- 登记机构
    ,putoutdate -- 出账日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    creditserialno -- 对象号(风险监测-客户联系监测授信额度流水号)
    ,updatedate -- 更新日期
    ,duebillserialno -- 借据编号
    ,operateuserid -- 经办人
    ,customerid -- 客户编号
    ,contactserialno -- 对象号(风险监测-客户联系监测流水号)
    ,marurity -- 到期日期
    ,operateorgid -- 经办机构
    ,serialno -- 流水号
    ,objectno -- 对象号(风险监测主表流水号)
    ,productid -- 业务品种
    ,putoutsum -- 出账金额
    ,inputuserid -- 登记人
    ,riskclassify -- 风险分类
    ,inputdate -- 登记日期
    ,bcserialno -- 额度合同编号
    ,currentsum -- 当期金额
    ,updateuserid -- 更新人编号
    ,updateorgid -- 更新人机构编号
    ,inputorgid -- 登记机构
    ,putoutdate -- 出账日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_customer_contact_business
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_customer_contact_business exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_contact_business_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_contact_business to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_customer_contact_business_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_contact_business',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);