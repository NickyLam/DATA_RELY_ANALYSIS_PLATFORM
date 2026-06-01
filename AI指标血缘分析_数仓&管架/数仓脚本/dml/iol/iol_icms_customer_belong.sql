/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_belong
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
create table ${iol_schema}.icms_customer_belong_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_belong
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_belong_op purge;
drop table ${iol_schema}.icms_customer_belong_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_belong_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_belong where 0=1;

create table ${iol_schema}.icms_customer_belong_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_belong where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_belong_cl(
            customerid -- 客户编号
            ,belongorgid -- 机构编号
            ,belonguserid -- 员工编号
            ,editright -- 信息维护权
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,viewright -- 信息查看权
            ,updateuserid -- 更新人
            ,corporgid -- 法人机构编号
            ,businessright -- 业务办理权
            ,inputdate -- 登记日期
            ,businessright1 -- 非标业务申办权
            ,manageright -- 主办权
            ,updatedate -- 更新日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updateorgid -- 更新机构
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_belong_op(
            customerid -- 客户编号
            ,belongorgid -- 机构编号
            ,belonguserid -- 员工编号
            ,editright -- 信息维护权
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,viewright -- 信息查看权
            ,updateuserid -- 更新人
            ,corporgid -- 法人机构编号
            ,businessright -- 业务办理权
            ,inputdate -- 登记日期
            ,businessright1 -- 非标业务申办权
            ,manageright -- 主办权
            ,updatedate -- 更新日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updateorgid -- 更新机构
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.belongorgid, o.belongorgid) as belongorgid -- 机构编号
    ,nvl(n.belonguserid, o.belonguserid) as belonguserid -- 员工编号
    ,nvl(n.editright, o.editright) as editright -- 信息维护权
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.viewright, o.viewright) as viewright -- 信息查看权
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.businessright, o.businessright) as businessright -- 业务办理权
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.businessright1, o.businessright1) as businessright1 -- 非标业务申办权
    ,nvl(n.manageright, o.manageright) as manageright -- 主办权
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 迁移数据-参数转换前字段值
    ,case when
            n.customerid is null
            and n.belongorgid is null
            and n.belonguserid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
            and n.belongorgid is null
            and n.belonguserid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
            and n.belongorgid is null
            and n.belonguserid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_customer_belong_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_belong where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
            and o.belongorgid = n.belongorgid
            and o.belonguserid = n.belonguserid
where (
        o.customerid is null
        and o.belongorgid is null
        and o.belonguserid is null
    )
    or (
        n.customerid is null
        and n.belongorgid is null
        and n.belonguserid is null
    )
    or (
        o.editright <> n.editright
        or o.remark <> n.remark
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.viewright <> n.viewright
        or o.updateuserid <> n.updateuserid
        or o.corporgid <> n.corporgid
        or o.businessright <> n.businessright
        or o.inputdate <> n.inputdate
        or o.businessright1 <> n.businessright1
        or o.manageright <> n.manageright
        or o.updatedate <> n.updatedate
        or o.migtflag <> n.migtflag
        or o.updateorgid <> n.updateorgid
        or o.migtoldvalue <> n.migtoldvalue
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_belong_cl(
            customerid -- 客户编号
            ,belongorgid -- 机构编号
            ,belonguserid -- 员工编号
            ,editright -- 信息维护权
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,viewright -- 信息查看权
            ,updateuserid -- 更新人
            ,corporgid -- 法人机构编号
            ,businessright -- 业务办理权
            ,inputdate -- 登记日期
            ,businessright1 -- 非标业务申办权
            ,manageright -- 主办权
            ,updatedate -- 更新日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updateorgid -- 更新机构
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_belong_op(
            customerid -- 客户编号
            ,belongorgid -- 机构编号
            ,belonguserid -- 员工编号
            ,editright -- 信息维护权
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,viewright -- 信息查看权
            ,updateuserid -- 更新人
            ,corporgid -- 法人机构编号
            ,businessright -- 业务办理权
            ,inputdate -- 登记日期
            ,businessright1 -- 非标业务申办权
            ,manageright -- 主办权
            ,updatedate -- 更新日期
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,updateorgid -- 更新机构
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customerid -- 客户编号
    ,o.belongorgid -- 机构编号
    ,o.belonguserid -- 员工编号
    ,o.editright -- 信息维护权
    ,o.remark -- 备注
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.viewright -- 信息查看权
    ,o.updateuserid -- 更新人
    ,o.corporgid -- 法人机构编号
    ,o.businessright -- 业务办理权
    ,o.inputdate -- 登记日期
    ,o.businessright1 -- 非标业务申办权
    ,o.manageright -- 主办权
    ,o.updatedate -- 更新日期
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.updateorgid -- 更新机构
    ,o.migtoldvalue -- 迁移数据-参数转换前字段值
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
from ${iol_schema}.icms_customer_belong_bk o
    left join ${iol_schema}.icms_customer_belong_op n
        on
            o.customerid = n.customerid
            and o.belongorgid = n.belongorgid
            and o.belonguserid = n.belonguserid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_belong_cl d
        on
            o.customerid = d.customerid
            and o.belongorgid = d.belongorgid
            and o.belonguserid = d.belonguserid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_customer_belong;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_belong') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_belong drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_belong add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_belong exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_belong_cl;
alter table ${iol_schema}.icms_customer_belong exchange partition p_20991231 with table ${iol_schema}.icms_customer_belong_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_belong to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_belong_op purge;
drop table ${iol_schema}.icms_customer_belong_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_belong_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_belong',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
