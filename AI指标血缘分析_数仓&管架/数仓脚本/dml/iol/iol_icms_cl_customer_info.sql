/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_customer_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_cl_customer_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_cl_customer_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_customer_info_op purge;
drop table ${iol_schema}.icms_cl_customer_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_customer_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_customer_info where 0=1;

create table ${iol_schema}.icms_cl_customer_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_customer_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_customer_info_cl(
            sourcesystemcustomerid -- 源系统产品编号
            ,swiftcode -- SWIFT代码
            ,limitamount -- 限额
            ,unifiedcreditexposureamount -- 统一授信敞口金额
            ,updateuserid -- 最后更新人
            ,belonggroupid -- 所属集团编号
            ,crossbranchgroupflag -- 跨分行集团客户标志
            ,updatedate -- 最后更新日期
            ,limitamountcurrency -- 限额币种
            ,inputdate -- 登记日期
            ,updateorgid -- 最后更新机构
            ,customername -- 客户名称
            ,importantgroupflag -- 重点集团客户标志
            ,unifiedcreditcurrency -- 统一授信币种
            ,financialinstitutioncode -- 金融机构代码
            ,creditleveltype -- 适用额度层级类型
            ,entscale -- 企业规模
            ,inputorgid -- 登记机构
            ,customerid -- 客户编号
            ,customertype -- 客户类型
            ,businesslicenseno -- 营业执照号
            ,status -- 状态
            ,inputuserid -- 登记人
            ,sourcesystem -- 来源系统
            ,unifiedcreditnominalamount -- 统一授信名义金额
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_customer_info_op(
            sourcesystemcustomerid -- 源系统产品编号
            ,swiftcode -- SWIFT代码
            ,limitamount -- 限额
            ,unifiedcreditexposureamount -- 统一授信敞口金额
            ,updateuserid -- 最后更新人
            ,belonggroupid -- 所属集团编号
            ,crossbranchgroupflag -- 跨分行集团客户标志
            ,updatedate -- 最后更新日期
            ,limitamountcurrency -- 限额币种
            ,inputdate -- 登记日期
            ,updateorgid -- 最后更新机构
            ,customername -- 客户名称
            ,importantgroupflag -- 重点集团客户标志
            ,unifiedcreditcurrency -- 统一授信币种
            ,financialinstitutioncode -- 金融机构代码
            ,creditleveltype -- 适用额度层级类型
            ,entscale -- 企业规模
            ,inputorgid -- 登记机构
            ,customerid -- 客户编号
            ,customertype -- 客户类型
            ,businesslicenseno -- 营业执照号
            ,status -- 状态
            ,inputuserid -- 登记人
            ,sourcesystem -- 来源系统
            ,unifiedcreditnominalamount -- 统一授信名义金额
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sourcesystemcustomerid, o.sourcesystemcustomerid) as sourcesystemcustomerid -- 源系统产品编号
    ,nvl(n.swiftcode, o.swiftcode) as swiftcode -- SWIFT代码
    ,nvl(n.limitamount, o.limitamount) as limitamount -- 限额
    ,nvl(n.unifiedcreditexposureamount, o.unifiedcreditexposureamount) as unifiedcreditexposureamount -- 统一授信敞口金额
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 最后更新人
    ,nvl(n.belonggroupid, o.belonggroupid) as belonggroupid -- 所属集团编号
    ,nvl(n.crossbranchgroupflag, o.crossbranchgroupflag) as crossbranchgroupflag -- 跨分行集团客户标志
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 最后更新日期
    ,nvl(n.limitamountcurrency, o.limitamountcurrency) as limitamountcurrency -- 限额币种
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 最后更新机构
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.importantgroupflag, o.importantgroupflag) as importantgroupflag -- 重点集团客户标志
    ,nvl(n.unifiedcreditcurrency, o.unifiedcreditcurrency) as unifiedcreditcurrency -- 统一授信币种
    ,nvl(n.financialinstitutioncode, o.financialinstitutioncode) as financialinstitutioncode -- 金融机构代码
    ,nvl(n.creditleveltype, o.creditleveltype) as creditleveltype -- 适用额度层级类型
    ,nvl(n.entscale, o.entscale) as entscale -- 企业规模
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.businesslicenseno, o.businesslicenseno) as businesslicenseno -- 营业执照号
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.sourcesystem, o.sourcesystem) as sourcesystem -- 来源系统
    ,nvl(n.unifiedcreditnominalamount, o.unifiedcreditnominalamount) as unifiedcreditnominalamount -- 统一授信名义金额
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.customerid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_cl_customer_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_cl_customer_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
where (
        o.customerid is null
    )
    or (
        n.customerid is null
    )
    or (
        o.sourcesystemcustomerid <> n.sourcesystemcustomerid
        or o.swiftcode <> n.swiftcode
        or o.limitamount <> n.limitamount
        or o.unifiedcreditexposureamount <> n.unifiedcreditexposureamount
        or o.updateuserid <> n.updateuserid
        or o.belonggroupid <> n.belonggroupid
        or o.crossbranchgroupflag <> n.crossbranchgroupflag
        or o.updatedate <> n.updatedate
        or o.limitamountcurrency <> n.limitamountcurrency
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.customername <> n.customername
        or o.importantgroupflag <> n.importantgroupflag
        or o.unifiedcreditcurrency <> n.unifiedcreditcurrency
        or o.financialinstitutioncode <> n.financialinstitutioncode
        or o.creditleveltype <> n.creditleveltype
        or o.entscale <> n.entscale
        or o.inputorgid <> n.inputorgid
        or o.customertype <> n.customertype
        or o.businesslicenseno <> n.businesslicenseno
        or o.status <> n.status
        or o.inputuserid <> n.inputuserid
        or o.sourcesystem <> n.sourcesystem
        or o.unifiedcreditnominalamount <> n.unifiedcreditnominalamount
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_customer_info_cl(
            sourcesystemcustomerid -- 源系统产品编号
            ,swiftcode -- SWIFT代码
            ,limitamount -- 限额
            ,unifiedcreditexposureamount -- 统一授信敞口金额
            ,updateuserid -- 最后更新人
            ,belonggroupid -- 所属集团编号
            ,crossbranchgroupflag -- 跨分行集团客户标志
            ,updatedate -- 最后更新日期
            ,limitamountcurrency -- 限额币种
            ,inputdate -- 登记日期
            ,updateorgid -- 最后更新机构
            ,customername -- 客户名称
            ,importantgroupflag -- 重点集团客户标志
            ,unifiedcreditcurrency -- 统一授信币种
            ,financialinstitutioncode -- 金融机构代码
            ,creditleveltype -- 适用额度层级类型
            ,entscale -- 企业规模
            ,inputorgid -- 登记机构
            ,customerid -- 客户编号
            ,customertype -- 客户类型
            ,businesslicenseno -- 营业执照号
            ,status -- 状态
            ,inputuserid -- 登记人
            ,sourcesystem -- 来源系统
            ,unifiedcreditnominalamount -- 统一授信名义金额
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_customer_info_op(
            sourcesystemcustomerid -- 源系统产品编号
            ,swiftcode -- SWIFT代码
            ,limitamount -- 限额
            ,unifiedcreditexposureamount -- 统一授信敞口金额
            ,updateuserid -- 最后更新人
            ,belonggroupid -- 所属集团编号
            ,crossbranchgroupflag -- 跨分行集团客户标志
            ,updatedate -- 最后更新日期
            ,limitamountcurrency -- 限额币种
            ,inputdate -- 登记日期
            ,updateorgid -- 最后更新机构
            ,customername -- 客户名称
            ,importantgroupflag -- 重点集团客户标志
            ,unifiedcreditcurrency -- 统一授信币种
            ,financialinstitutioncode -- 金融机构代码
            ,creditleveltype -- 适用额度层级类型
            ,entscale -- 企业规模
            ,inputorgid -- 登记机构
            ,customerid -- 客户编号
            ,customertype -- 客户类型
            ,businesslicenseno -- 营业执照号
            ,status -- 状态
            ,inputuserid -- 登记人
            ,sourcesystem -- 来源系统
            ,unifiedcreditnominalamount -- 统一授信名义金额
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sourcesystemcustomerid -- 源系统产品编号
    ,o.swiftcode -- SWIFT代码
    ,o.limitamount -- 限额
    ,o.unifiedcreditexposureamount -- 统一授信敞口金额
    ,o.updateuserid -- 最后更新人
    ,o.belonggroupid -- 所属集团编号
    ,o.crossbranchgroupflag -- 跨分行集团客户标志
    ,o.updatedate -- 最后更新日期
    ,o.limitamountcurrency -- 限额币种
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 最后更新机构
    ,o.customername -- 客户名称
    ,o.importantgroupflag -- 重点集团客户标志
    ,o.unifiedcreditcurrency -- 统一授信币种
    ,o.financialinstitutioncode -- 金融机构代码
    ,o.creditleveltype -- 适用额度层级类型
    ,o.entscale -- 企业规模
    ,o.inputorgid -- 登记机构
    ,o.customerid -- 客户编号
    ,o.customertype -- 客户类型
    ,o.businesslicenseno -- 营业执照号
    ,o.status -- 状态
    ,o.inputuserid -- 登记人
    ,o.sourcesystem -- 来源系统
    ,o.unifiedcreditnominalamount -- 统一授信名义金额
    ,o.remark -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_cl_customer_info_bk o
    left join ${iol_schema}.icms_cl_customer_info_op n
        on
            o.customerid = n.customerid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_cl_customer_info_cl d
        on
            o.customerid = d.customerid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_cl_customer_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_cl_customer_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_cl_customer_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_cl_customer_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_cl_customer_info exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_customer_info_cl;
alter table ${iol_schema}.icms_cl_customer_info exchange partition p_20991231 with table ${iol_schema}.icms_cl_customer_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_customer_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_customer_info_op purge;
drop table ${iol_schema}.icms_cl_customer_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_cl_customer_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_customer_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
