/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_info
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
create table ${iol_schema}.icms_customer_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_info_op purge;
drop table ${iol_schema}.icms_customer_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_info where 0=1;

create table ${iol_schema}.icms_customer_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_info_cl(
            customerid -- 客户编号
            ,certmaturity -- 证件到期日
            ,manageuserid -- 主办客户经理
            ,inputdate -- 登记日期
            ,isalarmsign -- 是否预警客户
            ,mfcustomerid -- 核心客户号
            ,completeflag -- 数据录入完整性标识
            ,certcountry -- 证件国别
            ,certid -- 证件号码
            ,inputuserid -- 登记人
            ,status -- 状态
            ,isassign -- 是否分配(0未分配1已分配)
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updatedate -- 更新日期
            ,inputorgid -- 登记机构
            ,yxcustomerid -- 影像客户号
            ,updateorgid -- 更新机构
            ,customername -- 客户名称
            ,corporgid -- 法人机构编号
            ,isselfbizcust -- 是否自营客户
            ,certtype -- 证件类型
            ,remark -- 备注
            ,loancardno -- 贷款卡号
            ,custflag -- 客户标志：BZ-标准对公客户
            ,isimpoversee -- 是否重点监测客户
            ,manageorgid -- 管护机构
            ,isrelated -- 是否我行关联方
            ,customertype -- 客户分类
            ,updateuserid -- 更新人
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,customertypelb -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_info_op(
            customerid -- 客户编号
            ,certmaturity -- 证件到期日
            ,manageuserid -- 主办客户经理
            ,inputdate -- 登记日期
            ,isalarmsign -- 是否预警客户
            ,mfcustomerid -- 核心客户号
            ,completeflag -- 数据录入完整性标识
            ,certcountry -- 证件国别
            ,certid -- 证件号码
            ,inputuserid -- 登记人
            ,status -- 状态
            ,isassign -- 是否分配(0未分配1已分配)
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updatedate -- 更新日期
            ,inputorgid -- 登记机构
            ,yxcustomerid -- 影像客户号
            ,updateorgid -- 更新机构
            ,customername -- 客户名称
            ,corporgid -- 法人机构编号
            ,isselfbizcust -- 是否自营客户
            ,certtype -- 证件类型
            ,remark -- 备注
            ,loancardno -- 贷款卡号
            ,custflag -- 客户标志：BZ-标准对公客户
            ,isimpoversee -- 是否重点监测客户
            ,manageorgid -- 管护机构
            ,isrelated -- 是否我行关联方
            ,customertype -- 客户分类
            ,updateuserid -- 更新人
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,customertypelb -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.certmaturity, o.certmaturity) as certmaturity -- 证件到期日
    ,nvl(n.manageuserid, o.manageuserid) as manageuserid -- 主办客户经理
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.isalarmsign, o.isalarmsign) as isalarmsign -- 是否预警客户
    ,nvl(n.mfcustomerid, o.mfcustomerid) as mfcustomerid -- 核心客户号
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 数据录入完整性标识
    ,nvl(n.certcountry, o.certcountry) as certcountry -- 证件国别
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.isassign, o.isassign) as isassign -- 是否分配(0未分配1已分配)
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.yxcustomerid, o.yxcustomerid) as yxcustomerid -- 影像客户号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.isselfbizcust, o.isselfbizcust) as isselfbizcust -- 是否自营客户
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.loancardno, o.loancardno) as loancardno -- 贷款卡号
    ,nvl(n.custflag, o.custflag) as custflag -- 客户标志：BZ-标准对公客户
    ,nvl(n.isimpoversee, o.isimpoversee) as isimpoversee -- 是否重点监测客户
    ,nvl(n.manageorgid, o.manageorgid) as manageorgid -- 管护机构
    ,nvl(n.isrelated, o.isrelated) as isrelated -- 是否我行关联方
    ,nvl(n.customertype, o.customertype) as customertype -- 客户分类
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 迁移数据-参数转换前字段值
    ,nvl(n.customertypelb, o.customertypelb) as customertypelb -- 客户类型
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
from (select * from ${iol_schema}.icms_customer_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
where (
        o.customerid is null
    )
    or (
        n.customerid is null
    )
    or (
        o.certmaturity <> n.certmaturity
        or o.manageuserid <> n.manageuserid
        or o.inputdate <> n.inputdate
        or o.isalarmsign <> n.isalarmsign
        or o.mfcustomerid <> n.mfcustomerid
        or o.completeflag <> n.completeflag
        or o.certcountry <> n.certcountry
        or o.certid <> n.certid
        or o.inputuserid <> n.inputuserid
        or o.status <> n.status
        or o.isassign <> n.isassign
        or o.migtflag <> n.migtflag
        or o.updatedate <> n.updatedate
        or o.inputorgid <> n.inputorgid
        or o.yxcustomerid <> n.yxcustomerid
        or o.updateorgid <> n.updateorgid
        or o.customername <> n.customername
        or o.corporgid <> n.corporgid
        or o.isselfbizcust <> n.isselfbizcust
        or o.certtype <> n.certtype
        or o.remark <> n.remark
        or o.loancardno <> n.loancardno
        or o.custflag <> n.custflag
        or o.isimpoversee <> n.isimpoversee
        or o.manageorgid <> n.manageorgid
        or o.isrelated <> n.isrelated
        or o.customertype <> n.customertype
        or o.updateuserid <> n.updateuserid
        or o.migtoldvalue <> n.migtoldvalue
        or o.customertypelb <> n.customertypelb
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_info_cl(
            customerid -- 客户编号
            ,certmaturity -- 证件到期日
            ,manageuserid -- 主办客户经理
            ,inputdate -- 登记日期
            ,isalarmsign -- 是否预警客户
            ,mfcustomerid -- 核心客户号
            ,completeflag -- 数据录入完整性标识
            ,certcountry -- 证件国别
            ,certid -- 证件号码
            ,inputuserid -- 登记人
            ,status -- 状态
            ,isassign -- 是否分配(0未分配1已分配)
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updatedate -- 更新日期
            ,inputorgid -- 登记机构
            ,yxcustomerid -- 影像客户号
            ,updateorgid -- 更新机构
            ,customername -- 客户名称
            ,corporgid -- 法人机构编号
            ,isselfbizcust -- 是否自营客户
            ,certtype -- 证件类型
            ,remark -- 备注
            ,loancardno -- 贷款卡号
            ,custflag -- 客户标志：BZ-标准对公客户
            ,isimpoversee -- 是否重点监测客户
            ,manageorgid -- 管护机构
            ,isrelated -- 是否我行关联方
            ,customertype -- 客户分类
            ,updateuserid -- 更新人
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,customertypelb -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_info_op(
            customerid -- 客户编号
            ,certmaturity -- 证件到期日
            ,manageuserid -- 主办客户经理
            ,inputdate -- 登记日期
            ,isalarmsign -- 是否预警客户
            ,mfcustomerid -- 核心客户号
            ,completeflag -- 数据录入完整性标识
            ,certcountry -- 证件国别
            ,certid -- 证件号码
            ,inputuserid -- 登记人
            ,status -- 状态
            ,isassign -- 是否分配(0未分配1已分配)
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updatedate -- 更新日期
            ,inputorgid -- 登记机构
            ,yxcustomerid -- 影像客户号
            ,updateorgid -- 更新机构
            ,customername -- 客户名称
            ,corporgid -- 法人机构编号
            ,isselfbizcust -- 是否自营客户
            ,certtype -- 证件类型
            ,remark -- 备注
            ,loancardno -- 贷款卡号
            ,custflag -- 客户标志：BZ-标准对公客户
            ,isimpoversee -- 是否重点监测客户
            ,manageorgid -- 管护机构
            ,isrelated -- 是否我行关联方
            ,customertype -- 客户分类
            ,updateuserid -- 更新人
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,customertypelb -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customerid -- 客户编号
    ,o.certmaturity -- 证件到期日
    ,o.manageuserid -- 主办客户经理
    ,o.inputdate -- 登记日期
    ,o.isalarmsign -- 是否预警客户
    ,o.mfcustomerid -- 核心客户号
    ,o.completeflag -- 数据录入完整性标识
    ,o.certcountry -- 证件国别
    ,o.certid -- 证件号码
    ,o.inputuserid -- 登记人
    ,o.status -- 状态
    ,o.isassign -- 是否分配(0未分配1已分配)
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.updatedate -- 更新日期
    ,o.inputorgid -- 登记机构
    ,o.yxcustomerid -- 影像客户号
    ,o.updateorgid -- 更新机构
    ,o.customername -- 客户名称
    ,o.corporgid -- 法人机构编号
    ,o.isselfbizcust -- 是否自营客户
    ,o.certtype -- 证件类型
    ,o.remark -- 备注
    ,o.loancardno -- 贷款卡号
    ,o.custflag -- 客户标志：BZ-标准对公客户
    ,o.isimpoversee -- 是否重点监测客户
    ,o.manageorgid -- 管护机构
    ,o.isrelated -- 是否我行关联方
    ,o.customertype -- 客户分类
    ,o.updateuserid -- 更新人
    ,o.migtoldvalue -- 迁移数据-参数转换前字段值
    ,o.customertypelb -- 客户类型
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
from ${iol_schema}.icms_customer_info_bk o
    left join ${iol_schema}.icms_customer_info_op n
        on
            o.customerid = n.customerid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_info_cl d
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
--truncate table ${iol_schema}.icms_customer_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_info exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_info_cl;
alter table ${iol_schema}.icms_customer_info exchange partition p_20991231 with table ${iol_schema}.icms_customer_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_info_op purge;
drop table ${iol_schema}.icms_customer_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
