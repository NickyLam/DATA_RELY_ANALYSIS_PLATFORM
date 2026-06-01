/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_business_credit_relation
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
create table ${iol_schema}.icms_cl_business_credit_relation_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_cl_business_credit_relation
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_business_credit_relation_op purge;
drop table ${iol_schema}.icms_cl_business_credit_relation_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_business_credit_relation_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_business_credit_relation where 0=1;

create table ${iol_schema}.icms_cl_business_credit_relation_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_business_credit_relation where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_business_credit_relation_cl(
            relativetype -- 关系类型
            ,inputuserid -- 登记人
            ,updateuserid -- 最后更新人
            ,roletype -- 角色类型
            ,occupyexposureamount -- 占用敞口金额
            ,updateorgid -- 最后更新机构
            ,actualoccupyexposureamount -- 实际占用敞口金额
            ,occupycoefficient -- 占用上层额度的系数
            ,inputorgid -- 登记机构
            ,businessno -- 额度系统业务编号
            ,createdway -- 关系建立方式
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,actualoccupynominalamount -- 实际占用名义金额
            ,relativecreditno -- 额度系统额度编号
            ,inputdate -- 登记日期
            ,customerid -- 额度系统客户编号
            ,occupynominalamount -- 占用名义金额
            ,occupycurrency -- 占用币种
            ,effect -- Y有效N无效
            ,updatedate -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_business_credit_relation_op(
            relativetype -- 关系类型
            ,inputuserid -- 登记人
            ,updateuserid -- 最后更新人
            ,roletype -- 角色类型
            ,occupyexposureamount -- 占用敞口金额
            ,updateorgid -- 最后更新机构
            ,actualoccupyexposureamount -- 实际占用敞口金额
            ,occupycoefficient -- 占用上层额度的系数
            ,inputorgid -- 登记机构
            ,businessno -- 额度系统业务编号
            ,createdway -- 关系建立方式
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,actualoccupynominalamount -- 实际占用名义金额
            ,relativecreditno -- 额度系统额度编号
            ,inputdate -- 登记日期
            ,customerid -- 额度系统客户编号
            ,occupynominalamount -- 占用名义金额
            ,occupycurrency -- 占用币种
            ,effect -- Y有效N无效
            ,updatedate -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.relativetype, o.relativetype) as relativetype -- 关系类型
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 最后更新人
    ,nvl(n.roletype, o.roletype) as roletype -- 角色类型
    ,nvl(n.occupyexposureamount, o.occupyexposureamount) as occupyexposureamount -- 占用敞口金额
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 最后更新机构
    ,nvl(n.actualoccupyexposureamount, o.actualoccupyexposureamount) as actualoccupyexposureamount -- 实际占用敞口金额
    ,nvl(n.occupycoefficient, o.occupycoefficient) as occupycoefficient -- 占用上层额度的系数
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.businessno, o.businessno) as businessno -- 额度系统业务编号
    ,nvl(n.createdway, o.createdway) as createdway -- 关系建立方式
    ,nvl(n.execslowreleaseexposureamount, o.execslowreleaseexposureamount) as execslowreleaseexposureamount -- 执行可缓释敞口金额
    ,nvl(n.actualoccupynominalamount, o.actualoccupynominalamount) as actualoccupynominalamount -- 实际占用名义金额
    ,nvl(n.relativecreditno, o.relativecreditno) as relativecreditno -- 额度系统额度编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.customerid, o.customerid) as customerid -- 额度系统客户编号
    ,nvl(n.occupynominalamount, o.occupynominalamount) as occupynominalamount -- 占用名义金额
    ,nvl(n.occupycurrency, o.occupycurrency) as occupycurrency -- 占用币种
    ,nvl(n.effect, o.effect) as effect -- Y有效N无效
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 最后更新日期
    ,case when
            n.relativetype is null
            and n.businessno is null
            and n.relativecreditno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.relativetype is null
            and n.businessno is null
            and n.relativecreditno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.relativetype is null
            and n.businessno is null
            and n.relativecreditno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_cl_business_credit_relation_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_cl_business_credit_relation where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.relativetype = n.relativetype
            and o.businessno = n.businessno
            and o.relativecreditno = n.relativecreditno
where (
        o.relativetype is null
        and o.businessno is null
        and o.relativecreditno is null
    )
    or (
        n.relativetype is null
        and n.businessno is null
        and n.relativecreditno is null
    )
    or (
        o.inputuserid <> n.inputuserid
        or o.updateuserid <> n.updateuserid
        or o.roletype <> n.roletype
        or o.occupyexposureamount <> n.occupyexposureamount
        or o.updateorgid <> n.updateorgid
        or o.actualoccupyexposureamount <> n.actualoccupyexposureamount
        or o.occupycoefficient <> n.occupycoefficient
        or o.inputorgid <> n.inputorgid
        or o.createdway <> n.createdway
        or o.execslowreleaseexposureamount <> n.execslowreleaseexposureamount
        or o.actualoccupynominalamount <> n.actualoccupynominalamount
        or o.inputdate <> n.inputdate
        or o.customerid <> n.customerid
        or o.occupynominalamount <> n.occupynominalamount
        or o.occupycurrency <> n.occupycurrency
        or o.effect <> n.effect
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_cl_business_credit_relation_cl(
            relativetype -- 关系类型
            ,inputuserid -- 登记人
            ,updateuserid -- 最后更新人
            ,roletype -- 角色类型
            ,occupyexposureamount -- 占用敞口金额
            ,updateorgid -- 最后更新机构
            ,actualoccupyexposureamount -- 实际占用敞口金额
            ,occupycoefficient -- 占用上层额度的系数
            ,inputorgid -- 登记机构
            ,businessno -- 额度系统业务编号
            ,createdway -- 关系建立方式
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,actualoccupynominalamount -- 实际占用名义金额
            ,relativecreditno -- 额度系统额度编号
            ,inputdate -- 登记日期
            ,customerid -- 额度系统客户编号
            ,occupynominalamount -- 占用名义金额
            ,occupycurrency -- 占用币种
            ,effect -- Y有效N无效
            ,updatedate -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_cl_business_credit_relation_op(
            relativetype -- 关系类型
            ,inputuserid -- 登记人
            ,updateuserid -- 最后更新人
            ,roletype -- 角色类型
            ,occupyexposureamount -- 占用敞口金额
            ,updateorgid -- 最后更新机构
            ,actualoccupyexposureamount -- 实际占用敞口金额
            ,occupycoefficient -- 占用上层额度的系数
            ,inputorgid -- 登记机构
            ,businessno -- 额度系统业务编号
            ,createdway -- 关系建立方式
            ,execslowreleaseexposureamount -- 执行可缓释敞口金额
            ,actualoccupynominalamount -- 实际占用名义金额
            ,relativecreditno -- 额度系统额度编号
            ,inputdate -- 登记日期
            ,customerid -- 额度系统客户编号
            ,occupynominalamount -- 占用名义金额
            ,occupycurrency -- 占用币种
            ,effect -- Y有效N无效
            ,updatedate -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.relativetype -- 关系类型
    ,o.inputuserid -- 登记人
    ,o.updateuserid -- 最后更新人
    ,o.roletype -- 角色类型
    ,o.occupyexposureamount -- 占用敞口金额
    ,o.updateorgid -- 最后更新机构
    ,o.actualoccupyexposureamount -- 实际占用敞口金额
    ,o.occupycoefficient -- 占用上层额度的系数
    ,o.inputorgid -- 登记机构
    ,o.businessno -- 额度系统业务编号
    ,o.createdway -- 关系建立方式
    ,o.execslowreleaseexposureamount -- 执行可缓释敞口金额
    ,o.actualoccupynominalamount -- 实际占用名义金额
    ,o.relativecreditno -- 额度系统额度编号
    ,o.inputdate -- 登记日期
    ,o.customerid -- 额度系统客户编号
    ,o.occupynominalamount -- 占用名义金额
    ,o.occupycurrency -- 占用币种
    ,o.effect -- Y有效N无效
    ,o.updatedate -- 最后更新日期
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
from ${iol_schema}.icms_cl_business_credit_relation_bk o
    left join ${iol_schema}.icms_cl_business_credit_relation_op n
        on
            o.relativetype = n.relativetype
            and o.businessno = n.businessno
            and o.relativecreditno = n.relativecreditno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_cl_business_credit_relation_cl d
        on
            o.relativetype = d.relativetype
            and o.businessno = d.businessno
            and o.relativecreditno = d.relativecreditno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_cl_business_credit_relation;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_cl_business_credit_relation') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_cl_business_credit_relation drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_cl_business_credit_relation add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_cl_business_credit_relation exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_business_credit_relation_cl;
alter table ${iol_schema}.icms_cl_business_credit_relation exchange partition p_20991231 with table ${iol_schema}.icms_cl_business_credit_relation_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_business_credit_relation to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_business_credit_relation_op purge;
drop table ${iol_schema}.icms_cl_business_credit_relation_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_cl_business_credit_relation_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_business_credit_relation',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
