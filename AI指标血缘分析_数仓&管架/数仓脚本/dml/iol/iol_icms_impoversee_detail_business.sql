/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_impoversee_detail_business
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
drop table ${iol_schema}.icms_impoversee_detail_business_ex purge;
alter table ${iol_schema}.icms_impoversee_detail_business add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_impoversee_detail_business;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_impoversee_detail_business_ex nologging
compress
as
select * from ${iol_schema}.icms_impoversee_detail_business where 0=1;

insert /*+ append */ into ${iol_schema}.icms_impoversee_detail_business_ex(
    serialno -- 流水号
    ,objecttype -- 申请类型
    ,businessoperateorgid -- 业务经办机构编号
    ,riskclassify -- 风险分类
    ,inputorgid -- 登记机构
    ,putoutsum -- 出账金额
    ,balance -- 当前余额
    ,putoutdate -- 出账日期
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,operateuserid -- 业务经办人
    ,updatedate -- 更新时间
    ,productid -- 业务品种
    ,duebillserialno -- 借据编号
    ,updateorgid -- 更新机构
    ,inputuserid -- 登记人
    ,contractserialno -- 业务合同编号
    ,putoutmaurity -- 出账到期日
    ,operateorgid -- 业务经办机构
    ,impoverseeserialno -- 监测流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 流水号
    ,objecttype -- 申请类型
    ,businessoperateorgid -- 业务经办机构编号
    ,riskclassify -- 风险分类
    ,inputorgid -- 登记机构
    ,putoutsum -- 出账金额
    ,balance -- 当前余额
    ,putoutdate -- 出账日期
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,operateuserid -- 业务经办人
    ,updatedate -- 更新时间
    ,productid -- 业务品种
    ,duebillserialno -- 借据编号
    ,updateorgid -- 更新机构
    ,inputuserid -- 登记人
    ,contractserialno -- 业务合同编号
    ,putoutmaurity -- 出账到期日
    ,operateorgid -- 业务经办机构
    ,impoverseeserialno -- 监测流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_impoversee_detail_business
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_impoversee_detail_business exchange partition p_${batch_date} with table ${iol_schema}.icms_impoversee_detail_business_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_impoversee_detail_business to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_impoversee_detail_business_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_impoversee_detail_business',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);