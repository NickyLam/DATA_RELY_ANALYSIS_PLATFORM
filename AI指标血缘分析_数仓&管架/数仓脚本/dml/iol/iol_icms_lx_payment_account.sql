/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lx_payment_account
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
create table ${iol_schema}.icms_lx_payment_account_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lx_payment_account
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lx_payment_account_op purge;
drop table ${iol_schema}.icms_lx_payment_account_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_payment_account_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_payment_account where 0=1;

create table ${iol_schema}.icms_lx_payment_account_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_payment_account where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lx_payment_account_cl(
            assetid -- 资产号
            ,capitalloanno -- 借据号
            ,stageno -- 期数
            ,porintreceipttime -- 本息回收时间
            ,settlementtradeno -- 清算交易编号
            ,repaymentacctype -- 还款账户类型
            ,repayacctno -- 还款账户编号
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
        into ${iol_schema}.icms_lx_payment_account_op(
            assetid -- 资产号
            ,capitalloanno -- 借据号
            ,stageno -- 期数
            ,porintreceipttime -- 本息回收时间
            ,settlementtradeno -- 清算交易编号
            ,repaymentacctype -- 还款账户类型
            ,repayacctno -- 还款账户编号
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
    nvl(n.assetid, o.assetid) as assetid -- 资产号
    ,nvl(n.capitalloanno, o.capitalloanno) as capitalloanno -- 借据号
    ,nvl(n.stageno, o.stageno) as stageno -- 期数
    ,nvl(n.porintreceipttime, o.porintreceipttime) as porintreceipttime -- 本息回收时间
    ,nvl(n.settlementtradeno, o.settlementtradeno) as settlementtradeno -- 清算交易编号
    ,nvl(n.repaymentacctype, o.repaymentacctype) as repaymentacctype -- 还款账户类型
    ,nvl(n.repayacctno, o.repayacctno) as repayacctno -- 还款账户编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,case when
            n.assetid is null
            and n.capitalloanno is null
            and n.stageno is null
            and n.settlementtradeno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.assetid is null
            and n.capitalloanno is null
            and n.stageno is null
            and n.settlementtradeno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.assetid is null
            and n.capitalloanno is null
            and n.stageno is null
            and n.settlementtradeno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_lx_payment_account_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lx_payment_account where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.assetid = n.assetid
            and o.capitalloanno = n.capitalloanno
            and o.stageno = n.stageno
            and o.settlementtradeno = n.settlementtradeno
where (
        o.assetid is null
        and o.capitalloanno is null
        and o.stageno is null
        and o.settlementtradeno is null
    )
    or (
        n.assetid is null
        and n.capitalloanno is null
        and n.stageno is null
        and n.settlementtradeno is null
    )
    or (
        o.porintreceipttime <> n.porintreceipttime
        or o.repaymentacctype <> n.repaymentacctype
        or o.repayacctno <> n.repayacctno
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
        into ${iol_schema}.icms_lx_payment_account_cl(
            assetid -- 资产号
            ,capitalloanno -- 借据号
            ,stageno -- 期数
            ,porintreceipttime -- 本息回收时间
            ,settlementtradeno -- 清算交易编号
            ,repaymentacctype -- 还款账户类型
            ,repayacctno -- 还款账户编号
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
        into ${iol_schema}.icms_lx_payment_account_op(
            assetid -- 资产号
            ,capitalloanno -- 借据号
            ,stageno -- 期数
            ,porintreceipttime -- 本息回收时间
            ,settlementtradeno -- 清算交易编号
            ,repaymentacctype -- 还款账户类型
            ,repayacctno -- 还款账户编号
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
    o.assetid -- 资产号
    ,o.capitalloanno -- 借据号
    ,o.stageno -- 期数
    ,o.porintreceipttime -- 本息回收时间
    ,o.settlementtradeno -- 清算交易编号
    ,o.repaymentacctype -- 还款账户类型
    ,o.repayacctno -- 还款账户编号
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
from ${iol_schema}.icms_lx_payment_account_bk o
    left join ${iol_schema}.icms_lx_payment_account_op n
        on
            o.assetid = n.assetid
            and o.capitalloanno = n.capitalloanno
            and o.stageno = n.stageno
            and o.settlementtradeno = n.settlementtradeno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lx_payment_account_cl d
        on
            o.assetid = d.assetid
            and o.capitalloanno = d.capitalloanno
            and o.stageno = d.stageno
            and o.settlementtradeno = d.settlementtradeno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_lx_payment_account;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lx_payment_account') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lx_payment_account drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lx_payment_account add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lx_payment_account exchange partition p_${batch_date} with table ${iol_schema}.icms_lx_payment_account_cl;
alter table ${iol_schema}.icms_lx_payment_account exchange partition p_20991231 with table ${iol_schema}.icms_lx_payment_account_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lx_payment_account to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lx_payment_account_op purge;
drop table ${iol_schema}.icms_lx_payment_account_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lx_payment_account_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lx_payment_account',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
