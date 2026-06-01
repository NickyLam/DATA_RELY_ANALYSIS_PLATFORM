/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_business_receipt_info
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
create table ${iol_schema}.icms_business_receipt_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_business_receipt_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_receipt_info_op purge;
drop table ${iol_schema}.icms_business_receipt_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_receipt_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_receipt_info where 0=1;

create table ${iol_schema}.icms_business_receipt_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_business_receipt_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_receipt_info_cl(
            recordno -- 记录编号
            ,objectno -- 关联流水号
            ,objecttype -- 关联对象类型
            ,receiptid -- 单据编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,receiptccy -- 单据币种
            ,receiptamount -- 单据金额（元）
            ,receipttype -- 单据种类
            ,attribute1 -- 预留字段1
            ,attribute2 -- 预留字段2
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_receipt_info_op(
            recordno -- 记录编号
            ,objectno -- 关联流水号
            ,objecttype -- 关联对象类型
            ,receiptid -- 单据编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,receiptccy -- 单据币种
            ,receiptamount -- 单据金额（元）
            ,receipttype -- 单据种类
            ,attribute1 -- 预留字段1
            ,attribute2 -- 预留字段2
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.recordno, o.recordno) as recordno -- 记录编号
    ,nvl(n.objectno, o.objectno) as objectno -- 关联流水号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 关联对象类型
    ,nvl(n.receiptid, o.receiptid) as receiptid -- 单据编号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.receiptccy, o.receiptccy) as receiptccy -- 单据币种
    ,nvl(n.receiptamount, o.receiptamount) as receiptamount -- 单据金额（元）
    ,nvl(n.receipttype, o.receipttype) as receipttype -- 单据种类
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 预留字段1
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 预留字段2
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,case when
            n.recordno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.recordno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.recordno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_business_receipt_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_business_receipt_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.recordno = n.recordno
where (
        o.recordno is null
    )
    or (
        n.recordno is null
    )
    or (
        o.objectno <> n.objectno
        or o.objecttype <> n.objecttype
        or o.receiptid <> n.receiptid
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.receiptccy <> n.receiptccy
        or o.receiptamount <> n.receiptamount
        or o.receipttype <> n.receipttype
        or o.attribute1 <> n.attribute1
        or o.attribute2 <> n.attribute2
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_business_receipt_info_cl(
            recordno -- 记录编号
            ,objectno -- 关联流水号
            ,objecttype -- 关联对象类型
            ,receiptid -- 单据编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,receiptccy -- 单据币种
            ,receiptamount -- 单据金额（元）
            ,receipttype -- 单据种类
            ,attribute1 -- 预留字段1
            ,attribute2 -- 预留字段2
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_business_receipt_info_op(
            recordno -- 记录编号
            ,objectno -- 关联流水号
            ,objecttype -- 关联对象类型
            ,receiptid -- 单据编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,receiptccy -- 单据币种
            ,receiptamount -- 单据金额（元）
            ,receipttype -- 单据种类
            ,attribute1 -- 预留字段1
            ,attribute2 -- 预留字段2
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.recordno -- 记录编号
    ,o.objectno -- 关联流水号
    ,o.objecttype -- 关联对象类型
    ,o.receiptid -- 单据编号
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.receiptccy -- 单据币种
    ,o.receiptamount -- 单据金额（元）
    ,o.receipttype -- 单据种类
    ,o.attribute1 -- 预留字段1
    ,o.attribute2 -- 预留字段2
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
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
from ${iol_schema}.icms_business_receipt_info_bk o
    left join ${iol_schema}.icms_business_receipt_info_op n
        on
            o.recordno = n.recordno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_business_receipt_info_cl d
        on
            o.recordno = d.recordno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_business_receipt_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_business_receipt_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_business_receipt_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_business_receipt_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_business_receipt_info exchange partition p_${batch_date} with table ${iol_schema}.icms_business_receipt_info_cl;
alter table ${iol_schema}.icms_business_receipt_info exchange partition p_20991231 with table ${iol_schema}.icms_business_receipt_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_business_receipt_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_business_receipt_info_op purge;
drop table ${iol_schema}.icms_business_receipt_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_business_receipt_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_business_receipt_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
