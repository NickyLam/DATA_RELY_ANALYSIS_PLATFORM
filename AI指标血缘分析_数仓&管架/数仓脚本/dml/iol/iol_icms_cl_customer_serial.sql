/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_customer_serial
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
drop table ${iol_schema}.icms_cl_customer_serial_ex purge;
alter table ${iol_schema}.icms_cl_customer_serial add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_cl_customer_serial truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_cl_customer_serial_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_customer_serial where 0=1;

insert /*+ append */ into ${iol_schema}.icms_cl_customer_serial_ex(
    customername -- 客户名称
    ,inputuserid -- 登记人
    ,certtype -- 主证件的类型
    ,certid -- 主证件的号码
    ,sourcesystemcustomerid -- 源系统产品编号
    ,crossbranchgroupflag -- 跨分行集团客户标志
    ,entscale -- 企业规模
    ,status -- 状态
    ,serialno -- 流水号
    ,updateorgid -- 最后更新机构
    ,inputdate -- 登记日期
    ,unifiedcreditnominalamount -- 统一授信名义金额
    ,importantgroupflag -- 重点集团客户标志
    ,customerid -- 客户编号
    ,swiftcode -- SWIFT代码
    ,remark -- 备注
    ,unifiedcreditexposureamount -- 统一授信敞口金额
    ,inputorgid -- 登记机构
    ,limitamountcurrency -- 限额币种
    ,sourcesystem -- 来源系统
    ,businesslicenseno -- 营业执照号
    ,updatedate -- 最后更新日期
    ,limitamount -- 限额
    ,updateuserid -- 最后更新人
    ,customertype -- 客户类型
    ,unifiedcreditcurrency -- 统一授信币种
    ,financialinstitutioncode -- 金融机构代码
    ,belonggroupid -- 所属集团编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    customername -- 客户名称
    ,inputuserid -- 登记人
    ,certtype -- 主证件的类型
    ,certid -- 主证件的号码
    ,sourcesystemcustomerid -- 源系统产品编号
    ,crossbranchgroupflag -- 跨分行集团客户标志
    ,entscale -- 企业规模
    ,status -- 状态
    ,serialno -- 流水号
    ,updateorgid -- 最后更新机构
    ,inputdate -- 登记日期
    ,unifiedcreditnominalamount -- 统一授信名义金额
    ,importantgroupflag -- 重点集团客户标志
    ,customerid -- 客户编号
    ,swiftcode -- SWIFT代码
    ,remark -- 备注
    ,unifiedcreditexposureamount -- 统一授信敞口金额
    ,inputorgid -- 登记机构
    ,limitamountcurrency -- 限额币种
    ,sourcesystem -- 来源系统
    ,businesslicenseno -- 营业执照号
    ,updatedate -- 最后更新日期
    ,limitamount -- 限额
    ,updateuserid -- 最后更新人
    ,customertype -- 客户类型
    ,unifiedcreditcurrency -- 统一授信币种
    ,financialinstitutioncode -- 金融机构代码
    ,belonggroupid -- 所属集团编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_cl_customer_serial
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_cl_customer_serial exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_customer_serial_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_customer_serial to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_cl_customer_serial_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_customer_serial',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);