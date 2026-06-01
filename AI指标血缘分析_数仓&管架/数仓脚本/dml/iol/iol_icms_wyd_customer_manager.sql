/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_customer_manager
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
drop table ${iol_schema}.icms_wyd_customer_manager_ex purge;
alter table ${iol_schema}.icms_wyd_customer_manager add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_wyd_customer_manager truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_wyd_customer_manager_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_customer_manager where 0=1;

insert /*+ append */ into ${iol_schema}.icms_wyd_customer_manager_ex(
    customerid -- 对公客户编号
    ,positions -- 高管类型
    ,managername -- 高管名称
    ,certtype -- 证件类型
    ,certid -- 证件号码
    ,sex -- 性别
    ,birthday -- 出生日期
    ,certbegindate -- 证件签发日期
    ,certenddate -- 证件到期日期
    ,duty -- 学历
    ,telephone -- 联系电话
    ,pcredit -- 个人征信记录
    ,updatedate1 -- 微纵企业联系人基本信息更新时间
    ,ratio -- 持股比例
    ,address -- 联系地址
    ,position -- 职务
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,custid -- 行内客户号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    customerid -- 对公客户编号
    ,positions -- 高管类型
    ,managername -- 高管名称
    ,certtype -- 证件类型
    ,certid -- 证件号码
    ,sex -- 性别
    ,birthday -- 出生日期
    ,certbegindate -- 证件签发日期
    ,certenddate -- 证件到期日期
    ,duty -- 学历
    ,telephone -- 联系电话
    ,pcredit -- 个人征信记录
    ,updatedate1 -- 微纵企业联系人基本信息更新时间
    ,ratio -- 持股比例
    ,address -- 联系地址
    ,position -- 职务
    ,inputuserid -- 登记人
    ,inputorgid -- 登记人所属机构
    ,inputdate -- 登记时间
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,productid -- 产品编号
    ,classifyresult -- 废除五级分类
    ,custid -- 行内客户号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_wyd_customer_manager
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_wyd_customer_manager exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_customer_manager_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_customer_manager to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_wyd_customer_manager_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_customer_manager',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);