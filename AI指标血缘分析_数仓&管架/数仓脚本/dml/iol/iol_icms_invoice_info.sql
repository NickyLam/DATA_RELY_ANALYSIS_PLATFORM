/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_invoice_info
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
create table ${iol_schema}.icms_invoice_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_invoice_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_invoice_info_op purge;
drop table ${iol_schema}.icms_invoice_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_invoice_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_invoice_info where 0=1;

create table ${iol_schema}.icms_invoice_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_invoice_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_invoice_info_cl(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,invoiceno -- 发票号码
            ,tradetype -- 贸易方式
            ,makeoutdate -- 开票日期
            ,inputuserid -- 登记人
            ,purchaserid -- 买方代码
            ,purchasername -- 买方名称
            ,remark -- 备注
            ,bargainorid -- 卖方代码
            ,inputorgid -- 登记机构
            ,tradeproduct -- 贸易产品
            ,invoicecurrency -- 发票币种
            ,bargainorname -- 卖方名称
            ,updatedate -- 更新日期
            ,invoicesum -- 发票金额
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_invoice_info_op(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,invoiceno -- 发票号码
            ,tradetype -- 贸易方式
            ,makeoutdate -- 开票日期
            ,inputuserid -- 登记人
            ,purchaserid -- 买方代码
            ,purchasername -- 买方名称
            ,remark -- 备注
            ,bargainorid -- 卖方代码
            ,inputorgid -- 登记机构
            ,tradeproduct -- 贸易产品
            ,invoicecurrency -- 发票币种
            ,bargainorname -- 卖方名称
            ,updatedate -- 更新日期
            ,invoicesum -- 发票金额
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.invoiceno, o.invoiceno) as invoiceno -- 发票号码
    ,nvl(n.tradetype, o.tradetype) as tradetype -- 贸易方式
    ,nvl(n.makeoutdate, o.makeoutdate) as makeoutdate -- 开票日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.purchaserid, o.purchaserid) as purchaserid -- 买方代码
    ,nvl(n.purchasername, o.purchasername) as purchasername -- 买方名称
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.bargainorid, o.bargainorid) as bargainorid -- 卖方代码
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.tradeproduct, o.tradeproduct) as tradeproduct -- 贸易产品
    ,nvl(n.invoicecurrency, o.invoicecurrency) as invoicecurrency -- 发票币种
    ,nvl(n.bargainorname, o.bargainorname) as bargainorname -- 卖方名称
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.invoicesum, o.invoicesum) as invoicesum -- 发票金额
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,case when
            n.serialno is null
            and n.objecttype is null
            and n.objectno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
            and n.objecttype is null
            and n.objectno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
            and n.objecttype is null
            and n.objectno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_invoice_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_invoice_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
            and o.objecttype = n.objecttype
            and o.objectno = n.objectno
where (
        o.serialno is null
        and o.objecttype is null
        and o.objectno is null
    )
    or (
        n.serialno is null
        and n.objecttype is null
        and n.objectno is null
    )
    or (
        o.invoiceno <> n.invoiceno
        or o.tradetype <> n.tradetype
        or o.makeoutdate <> n.makeoutdate
        or o.inputuserid <> n.inputuserid
        or o.purchaserid <> n.purchaserid
        or o.purchasername <> n.purchasername
        or o.remark <> n.remark
        or o.bargainorid <> n.bargainorid
        or o.inputorgid <> n.inputorgid
        or o.tradeproduct <> n.tradeproduct
        or o.invoicecurrency <> n.invoicecurrency
        or o.bargainorname <> n.bargainorname
        or o.updatedate <> n.updatedate
        or o.invoicesum <> n.invoicesum
        or o.inputdate <> n.inputdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_invoice_info_cl(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,invoiceno -- 发票号码
            ,tradetype -- 贸易方式
            ,makeoutdate -- 开票日期
            ,inputuserid -- 登记人
            ,purchaserid -- 买方代码
            ,purchasername -- 买方名称
            ,remark -- 备注
            ,bargainorid -- 卖方代码
            ,inputorgid -- 登记机构
            ,tradeproduct -- 贸易产品
            ,invoicecurrency -- 发票币种
            ,bargainorname -- 卖方名称
            ,updatedate -- 更新日期
            ,invoicesum -- 发票金额
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_invoice_info_op(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,invoiceno -- 发票号码
            ,tradetype -- 贸易方式
            ,makeoutdate -- 开票日期
            ,inputuserid -- 登记人
            ,purchaserid -- 买方代码
            ,purchasername -- 买方名称
            ,remark -- 备注
            ,bargainorid -- 卖方代码
            ,inputorgid -- 登记机构
            ,tradeproduct -- 贸易产品
            ,invoicecurrency -- 发票币种
            ,bargainorname -- 卖方名称
            ,updatedate -- 更新日期
            ,invoicesum -- 发票金额
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.objecttype -- 对象类型
    ,o.objectno -- 对象编号
    ,o.invoiceno -- 发票号码
    ,o.tradetype -- 贸易方式
    ,o.makeoutdate -- 开票日期
    ,o.inputuserid -- 登记人
    ,o.purchaserid -- 买方代码
    ,o.purchasername -- 买方名称
    ,o.remark -- 备注
    ,o.bargainorid -- 卖方代码
    ,o.inputorgid -- 登记机构
    ,o.tradeproduct -- 贸易产品
    ,o.invoicecurrency -- 发票币种
    ,o.bargainorname -- 卖方名称
    ,o.updatedate -- 更新日期
    ,o.invoicesum -- 发票金额
    ,o.inputdate -- 登记日期
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
from ${iol_schema}.icms_invoice_info_bk o
    left join ${iol_schema}.icms_invoice_info_op n
        on
            o.serialno = n.serialno
            and o.objecttype = n.objecttype
            and o.objectno = n.objectno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_invoice_info_cl d
        on
            o.serialno = d.serialno
            and o.objecttype = d.objecttype
            and o.objectno = d.objectno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_invoice_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_invoice_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_invoice_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_invoice_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_invoice_info exchange partition p_${batch_date} with table ${iol_schema}.icms_invoice_info_cl;
alter table ${iol_schema}.icms_invoice_info exchange partition p_20991231 with table ${iol_schema}.icms_invoice_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_invoice_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_invoice_info_op purge;
drop table ${iol_schema}.icms_invoice_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_invoice_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_invoice_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
