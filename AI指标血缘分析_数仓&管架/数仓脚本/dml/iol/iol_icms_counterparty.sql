/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_counterparty
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
create table ${iol_schema}.icms_counterparty_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_counterparty
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_counterparty_op purge;
drop table ${iol_schema}.icms_counterparty_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_counterparty_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_counterparty where 0=1;

create table ${iol_schema}.icms_counterparty_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_counterparty where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_counterparty_cl(
            serialno -- 流水号
            ,relativeid -- 关联客户编号
            ,relationship -- 关联关系
            ,settlementtype -- 与受信人的结算方式
            ,certid -- 证件号码
            ,output -- 上年实际产量
            ,customername -- 客户名称
            ,income -- 上年销售收入（万元）
            ,isrelationship -- 与受信人有无关联关系
            ,businessvalue -- 与受信人的年交易量
            ,businesstime -- 与受信人合作时间
            ,inputuserid -- 登记人ID
            ,situation -- 在我行授信情况
            ,inputtime -- 登记时间
            ,position -- 行业地位
            ,migtflag -- 
            ,updatetime -- 更新时间
            ,customerid -- 客户编号
            ,certtype -- 证件类型
            ,inputuser -- 登记人
            ,updateuser -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_counterparty_op(
            serialno -- 流水号
            ,relativeid -- 关联客户编号
            ,relationship -- 关联关系
            ,settlementtype -- 与受信人的结算方式
            ,certid -- 证件号码
            ,output -- 上年实际产量
            ,customername -- 客户名称
            ,income -- 上年销售收入（万元）
            ,isrelationship -- 与受信人有无关联关系
            ,businessvalue -- 与受信人的年交易量
            ,businesstime -- 与受信人合作时间
            ,inputuserid -- 登记人ID
            ,situation -- 在我行授信情况
            ,inputtime -- 登记时间
            ,position -- 行业地位
            ,migtflag -- 
            ,updatetime -- 更新时间
            ,customerid -- 客户编号
            ,certtype -- 证件类型
            ,inputuser -- 登记人
            ,updateuser -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.relativeid, o.relativeid) as relativeid -- 关联客户编号
    ,nvl(n.relationship, o.relationship) as relationship -- 关联关系
    ,nvl(n.settlementtype, o.settlementtype) as settlementtype -- 与受信人的结算方式
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.output, o.output) as output -- 上年实际产量
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.income, o.income) as income -- 上年销售收入（万元）
    ,nvl(n.isrelationship, o.isrelationship) as isrelationship -- 与受信人有无关联关系
    ,nvl(n.businessvalue, o.businessvalue) as businessvalue -- 与受信人的年交易量
    ,nvl(n.businesstime, o.businesstime) as businesstime -- 与受信人合作时间
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人ID
    ,nvl(n.situation, o.situation) as situation -- 在我行授信情况
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.position, o.position) as position -- 行业地位
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新人
    ,case when
            n.serialno is null
            and n.relativeid is null
            and n.relationship is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
            and n.relativeid is null
            and n.relationship is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
            and n.relativeid is null
            and n.relationship is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_counterparty_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_counterparty where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
            and o.relativeid = n.relativeid
            and o.relationship = n.relationship
where (
        o.serialno is null
        and o.relativeid is null
        and o.relationship is null
    )
    or (
        n.serialno is null
        and n.relativeid is null
        and n.relationship is null
    )
    or (
        o.settlementtype <> n.settlementtype
        or o.certid <> n.certid
        or o.output <> n.output
        or o.customername <> n.customername
        or o.income <> n.income
        or o.isrelationship <> n.isrelationship
        or o.businessvalue <> n.businessvalue
        or o.businesstime <> n.businesstime
        or o.inputuserid <> n.inputuserid
        or o.situation <> n.situation
        or o.inputtime <> n.inputtime
        or o.position <> n.position
        or o.migtflag <> n.migtflag
        or o.updatetime <> n.updatetime
        or o.customerid <> n.customerid
        or o.certtype <> n.certtype
        or o.inputuser <> n.inputuser
        or o.updateuser <> n.updateuser
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_counterparty_cl(
            serialno -- 流水号
            ,relativeid -- 关联客户编号
            ,relationship -- 关联关系
            ,settlementtype -- 与受信人的结算方式
            ,certid -- 证件号码
            ,output -- 上年实际产量
            ,customername -- 客户名称
            ,income -- 上年销售收入（万元）
            ,isrelationship -- 与受信人有无关联关系
            ,businessvalue -- 与受信人的年交易量
            ,businesstime -- 与受信人合作时间
            ,inputuserid -- 登记人ID
            ,situation -- 在我行授信情况
            ,inputtime -- 登记时间
            ,position -- 行业地位
            ,migtflag -- 
            ,updatetime -- 更新时间
            ,customerid -- 客户编号
            ,certtype -- 证件类型
            ,inputuser -- 登记人
            ,updateuser -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_counterparty_op(
            serialno -- 流水号
            ,relativeid -- 关联客户编号
            ,relationship -- 关联关系
            ,settlementtype -- 与受信人的结算方式
            ,certid -- 证件号码
            ,output -- 上年实际产量
            ,customername -- 客户名称
            ,income -- 上年销售收入（万元）
            ,isrelationship -- 与受信人有无关联关系
            ,businessvalue -- 与受信人的年交易量
            ,businesstime -- 与受信人合作时间
            ,inputuserid -- 登记人ID
            ,situation -- 在我行授信情况
            ,inputtime -- 登记时间
            ,position -- 行业地位
            ,migtflag -- 
            ,updatetime -- 更新时间
            ,customerid -- 客户编号
            ,certtype -- 证件类型
            ,inputuser -- 登记人
            ,updateuser -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.relativeid -- 关联客户编号
    ,o.relationship -- 关联关系
    ,o.settlementtype -- 与受信人的结算方式
    ,o.certid -- 证件号码
    ,o.output -- 上年实际产量
    ,o.customername -- 客户名称
    ,o.income -- 上年销售收入（万元）
    ,o.isrelationship -- 与受信人有无关联关系
    ,o.businessvalue -- 与受信人的年交易量
    ,o.businesstime -- 与受信人合作时间
    ,o.inputuserid -- 登记人ID
    ,o.situation -- 在我行授信情况
    ,o.inputtime -- 登记时间
    ,o.position -- 行业地位
    ,o.migtflag -- 
    ,o.updatetime -- 更新时间
    ,o.customerid -- 客户编号
    ,o.certtype -- 证件类型
    ,o.inputuser -- 登记人
    ,o.updateuser -- 更新人
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
from ${iol_schema}.icms_counterparty_bk o
    left join ${iol_schema}.icms_counterparty_op n
        on
            o.serialno = n.serialno
            and o.relativeid = n.relativeid
            and o.relationship = n.relationship
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_counterparty_cl d
        on
            o.serialno = d.serialno
            and o.relativeid = d.relativeid
            and o.relationship = d.relationship
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_counterparty;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_counterparty') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_counterparty drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_counterparty add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_counterparty exchange partition p_${batch_date} with table ${iol_schema}.icms_counterparty_cl;
alter table ${iol_schema}.icms_counterparty exchange partition p_20991231 with table ${iol_schema}.icms_counterparty_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_counterparty to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_counterparty_op purge;
drop table ${iol_schema}.icms_counterparty_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_counterparty_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_counterparty',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
