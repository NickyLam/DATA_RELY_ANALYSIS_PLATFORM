/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_baseasset_info
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
create table ${iol_schema}.icms_baseasset_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_baseasset_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_baseasset_info_op purge;
drop table ${iol_schema}.icms_baseasset_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_baseasset_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_baseasset_info where 0=1;

create table ${iol_schema}.icms_baseasset_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_baseasset_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_baseasset_info_cl(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,industry -- 客户所在行业
            ,currency -- 币种
            ,businesssum -- 金额（元）
            ,begindate -- 起始日
            ,enddate -- 到期日
            ,paycustomertype -- 兑付方客户类型
            ,bookvalue -- 账面价值
            ,migtflag -- 迁移标志
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_baseasset_info_op(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,industry -- 客户所在行业
            ,currency -- 币种
            ,businesssum -- 金额（元）
            ,begindate -- 起始日
            ,enddate -- 到期日
            ,paycustomertype -- 兑付方客户类型
            ,bookvalue -- 账面价值
            ,migtflag -- 迁移标志
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.industry, o.industry) as industry -- 客户所在行业
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 金额（元）
    ,nvl(n.begindate, o.begindate) as begindate -- 起始日
    ,nvl(n.enddate, o.enddate) as enddate -- 到期日
    ,nvl(n.paycustomertype, o.paycustomertype) as paycustomertype -- 兑付方客户类型
    ,nvl(n.bookvalue, o.bookvalue) as bookvalue -- 账面价值
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_baseasset_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_baseasset_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.industry <> n.industry
        or o.currency <> n.currency
        or o.businesssum <> n.businesssum
        or o.begindate <> n.begindate
        or o.enddate <> n.enddate
        or o.paycustomertype <> n.paycustomertype
        or o.bookvalue <> n.bookvalue
        or o.migtflag <> n.migtflag
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.objecttype <> n.objecttype
        or o.objectno <> n.objectno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_baseasset_info_cl(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,industry -- 客户所在行业
            ,currency -- 币种
            ,businesssum -- 金额（元）
            ,begindate -- 起始日
            ,enddate -- 到期日
            ,paycustomertype -- 兑付方客户类型
            ,bookvalue -- 账面价值
            ,migtflag -- 迁移标志
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_baseasset_info_op(
            serialno -- 流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,industry -- 客户所在行业
            ,currency -- 币种
            ,businesssum -- 金额（元）
            ,begindate -- 起始日
            ,enddate -- 到期日
            ,paycustomertype -- 兑付方客户类型
            ,bookvalue -- 账面价值
            ,migtflag -- 迁移标志
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.certtype -- 证件类型
    ,o.certid -- 证件号码
    ,o.industry -- 客户所在行业
    ,o.currency -- 币种
    ,o.businesssum -- 金额（元）
    ,o.begindate -- 起始日
    ,o.enddate -- 到期日
    ,o.paycustomertype -- 兑付方客户类型
    ,o.bookvalue -- 账面价值
    ,o.migtflag -- 迁移标志
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.objecttype -- 对象类型
    ,o.objectno -- 对象编号
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
from ${iol_schema}.icms_baseasset_info_bk o
    left join ${iol_schema}.icms_baseasset_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_baseasset_info_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_baseasset_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_baseasset_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_baseasset_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_baseasset_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_baseasset_info exchange partition p_${batch_date} with table ${iol_schema}.icms_baseasset_info_cl;
alter table ${iol_schema}.icms_baseasset_info exchange partition p_20991231 with table ${iol_schema}.icms_baseasset_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_baseasset_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_baseasset_info_op purge;
drop table ${iol_schema}.icms_baseasset_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_baseasset_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_baseasset_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
