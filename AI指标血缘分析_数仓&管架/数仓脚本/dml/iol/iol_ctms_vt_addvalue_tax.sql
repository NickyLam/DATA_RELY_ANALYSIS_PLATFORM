/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_vt_addvalue_tax
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
create table ${iol_schema}.ctms_vt_addvalue_tax_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_vt_addvalue_tax
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_vt_addvalue_tax_op purge;
drop table ${iol_schema}.ctms_vt_addvalue_tax_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_vt_addvalue_tax_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_vt_addvalue_tax where 0=1;

create table ${iol_schema}.ctms_vt_addvalue_tax_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_vt_addvalue_tax where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_vt_addvalue_tax_cl(
            accentry2id -- 分录ID
            ,accountingcode -- 科目
            ,accountingdesc -- 科目名称
            ,productcode -- 产品
            ,business -- 业务场景
            ,taxtype -- 计税方法
            ,rate -- 税率
            ,taxcode -- 税目
            ,feecode -- 免税代码
            ,countnm -- 期间收入累计数
            ,amount -- 发生额
            ,fee -- 期间累计税额
            ,org_id -- 机构
            ,settledate -- 时间
            ,currency -- 币种
            ,source -- 来源系统
            ,bundlecode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_vt_addvalue_tax_op(
            accentry2id -- 分录ID
            ,accountingcode -- 科目
            ,accountingdesc -- 科目名称
            ,productcode -- 产品
            ,business -- 业务场景
            ,taxtype -- 计税方法
            ,rate -- 税率
            ,taxcode -- 税目
            ,feecode -- 免税代码
            ,countnm -- 期间收入累计数
            ,amount -- 发生额
            ,fee -- 期间累计税额
            ,org_id -- 机构
            ,settledate -- 时间
            ,currency -- 币种
            ,source -- 来源系统
            ,bundlecode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.accentry2id, o.accentry2id) as accentry2id -- 分录ID
    ,nvl(n.accountingcode, o.accountingcode) as accountingcode -- 科目
    ,nvl(n.accountingdesc, o.accountingdesc) as accountingdesc -- 科目名称
    ,nvl(n.productcode, o.productcode) as productcode -- 产品
    ,nvl(n.business, o.business) as business -- 业务场景
    ,nvl(n.taxtype, o.taxtype) as taxtype -- 计税方法
    ,nvl(n.rate, o.rate) as rate -- 税率
    ,nvl(n.taxcode, o.taxcode) as taxcode -- 税目
    ,nvl(n.feecode, o.feecode) as feecode -- 免税代码
    ,nvl(n.countnm, o.countnm) as countnm -- 期间收入累计数
    ,nvl(n.amount, o.amount) as amount -- 发生额
    ,nvl(n.fee, o.fee) as fee -- 期间累计税额
    ,nvl(n.org_id, o.org_id) as org_id -- 机构
    ,nvl(n.settledate, o.settledate) as settledate -- 时间
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.source, o.source) as source -- 来源系统
    ,nvl(n.bundlecode, o.bundlecode) as bundlecode -- 
    ,case when
            n.accentry2id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.accentry2id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.accentry2id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_vt_addvalue_tax_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_vt_addvalue_tax where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.accentry2id = n.accentry2id
where (
        o.accentry2id is null
    )
    or (
        n.accentry2id is null
    )
    or (
        o.accountingcode <> n.accountingcode
        or o.accountingdesc <> n.accountingdesc
        or o.productcode <> n.productcode
        or o.business <> n.business
        or o.taxtype <> n.taxtype
        or o.rate <> n.rate
        or o.taxcode <> n.taxcode
        or o.feecode <> n.feecode
        or o.countnm <> n.countnm
        or o.amount <> n.amount
        or o.fee <> n.fee
        or o.org_id <> n.org_id
        or o.settledate <> n.settledate
        or o.currency <> n.currency
        or o.source <> n.source
        or o.bundlecode <> n.bundlecode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_vt_addvalue_tax_cl(
            accentry2id -- 分录ID
            ,accountingcode -- 科目
            ,accountingdesc -- 科目名称
            ,productcode -- 产品
            ,business -- 业务场景
            ,taxtype -- 计税方法
            ,rate -- 税率
            ,taxcode -- 税目
            ,feecode -- 免税代码
            ,countnm -- 期间收入累计数
            ,amount -- 发生额
            ,fee -- 期间累计税额
            ,org_id -- 机构
            ,settledate -- 时间
            ,currency -- 币种
            ,source -- 来源系统
            ,bundlecode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_vt_addvalue_tax_op(
            accentry2id -- 分录ID
            ,accountingcode -- 科目
            ,accountingdesc -- 科目名称
            ,productcode -- 产品
            ,business -- 业务场景
            ,taxtype -- 计税方法
            ,rate -- 税率
            ,taxcode -- 税目
            ,feecode -- 免税代码
            ,countnm -- 期间收入累计数
            ,amount -- 发生额
            ,fee -- 期间累计税额
            ,org_id -- 机构
            ,settledate -- 时间
            ,currency -- 币种
            ,source -- 来源系统
            ,bundlecode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.accentry2id -- 分录ID
    ,o.accountingcode -- 科目
    ,o.accountingdesc -- 科目名称
    ,o.productcode -- 产品
    ,o.business -- 业务场景
    ,o.taxtype -- 计税方法
    ,o.rate -- 税率
    ,o.taxcode -- 税目
    ,o.feecode -- 免税代码
    ,o.countnm -- 期间收入累计数
    ,o.amount -- 发生额
    ,o.fee -- 期间累计税额
    ,o.org_id -- 机构
    ,o.settledate -- 时间
    ,o.currency -- 币种
    ,o.source -- 来源系统
    ,o.bundlecode -- 
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
from ${iol_schema}.ctms_vt_addvalue_tax_bk o
    left join ${iol_schema}.ctms_vt_addvalue_tax_op n
        on
            o.accentry2id = n.accentry2id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_vt_addvalue_tax_cl d
        on
            o.accentry2id = d.accentry2id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_vt_addvalue_tax;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_vt_addvalue_tax') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_vt_addvalue_tax drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_vt_addvalue_tax add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_vt_addvalue_tax exchange partition p_${batch_date} with table ${iol_schema}.ctms_vt_addvalue_tax_cl;
alter table ${iol_schema}.ctms_vt_addvalue_tax exchange partition p_20991231 with table ${iol_schema}.ctms_vt_addvalue_tax_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_vt_addvalue_tax to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_vt_addvalue_tax_op purge;
drop table ${iol_schema}.ctms_vt_addvalue_tax_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_vt_addvalue_tax_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_vt_addvalue_tax',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
