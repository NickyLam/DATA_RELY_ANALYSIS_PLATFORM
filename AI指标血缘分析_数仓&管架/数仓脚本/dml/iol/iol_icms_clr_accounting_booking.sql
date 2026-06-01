/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_accounting_booking
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
create table ${iol_schema}.icms_clr_accounting_booking_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_accounting_booking
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_accounting_booking_op purge;
drop table ${iol_schema}.icms_clr_accounting_booking_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_accounting_booking_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_accounting_booking where 0=1;

create table ${iol_schema}.icms_clr_accounting_booking_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_accounting_booking where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_accounting_booking_cl(
            serialno -- 记账记录流水号
            ,clientno -- 客户编号
            ,clrid -- 押品编号
            ,registertype -- 登记簿类型（1-无实物押品、2-风管有实物、3-营运有实物）
            ,collattype -- 押品记账登记类型（1-抵押、2-质押、3-代保管）
            ,ccy -- 押品记账价值币种
            ,collatamount -- 押品记账价值金额
            ,paymentdirection -- 收付方向（1-收、2-付）
            ,branch -- 记账机构
            ,company -- 法人
            ,prodtype -- 产品类型
            ,globalno -- 交易全局流水号
            ,transeqno -- 交易流水号
            ,trandate -- 交易日期
            ,trantimestamp -- 交易时间戳
            ,transtatus -- 交易状态（0-待处理，1-已发核算中台，2-记账成功，3-记账失败）
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_accounting_booking_op(
            serialno -- 记账记录流水号
            ,clientno -- 客户编号
            ,clrid -- 押品编号
            ,registertype -- 登记簿类型（1-无实物押品、2-风管有实物、3-营运有实物）
            ,collattype -- 押品记账登记类型（1-抵押、2-质押、3-代保管）
            ,ccy -- 押品记账价值币种
            ,collatamount -- 押品记账价值金额
            ,paymentdirection -- 收付方向（1-收、2-付）
            ,branch -- 记账机构
            ,company -- 法人
            ,prodtype -- 产品类型
            ,globalno -- 交易全局流水号
            ,transeqno -- 交易流水号
            ,trandate -- 交易日期
            ,trantimestamp -- 交易时间戳
            ,transtatus -- 交易状态（0-待处理，1-已发核算中台，2-记账成功，3-记账失败）
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 记账记录流水号
    ,nvl(n.clientno, o.clientno) as clientno -- 客户编号
    ,nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.registertype, o.registertype) as registertype -- 登记簿类型（1-无实物押品、2-风管有实物、3-营运有实物）
    ,nvl(n.collattype, o.collattype) as collattype -- 押品记账登记类型（1-抵押、2-质押、3-代保管）
    ,nvl(n.ccy, o.ccy) as ccy -- 押品记账价值币种
    ,nvl(n.collatamount, o.collatamount) as collatamount -- 押品记账价值金额
    ,nvl(n.paymentdirection, o.paymentdirection) as paymentdirection -- 收付方向（1-收、2-付）
    ,nvl(n.branch, o.branch) as branch -- 记账机构
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.prodtype, o.prodtype) as prodtype -- 产品类型
    ,nvl(n.globalno, o.globalno) as globalno -- 交易全局流水号
    ,nvl(n.transeqno, o.transeqno) as transeqno -- 交易流水号
    ,nvl(n.trandate, o.trandate) as trandate -- 交易日期
    ,nvl(n.trantimestamp, o.trantimestamp) as trantimestamp -- 交易时间戳
    ,nvl(n.transtatus, o.transtatus) as transtatus -- 交易状态（0-待处理，1-已发核算中台，2-记账成功，3-记账失败）
    ,nvl(n.remark, o.remark) as remark -- 备注
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
from (select * from ${iol_schema}.icms_clr_accounting_booking_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_accounting_booking where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.clientno <> n.clientno
        or o.clrid <> n.clrid
        or o.registertype <> n.registertype
        or o.collattype <> n.collattype
        or o.ccy <> n.ccy
        or o.collatamount <> n.collatamount
        or o.paymentdirection <> n.paymentdirection
        or o.branch <> n.branch
        or o.company <> n.company
        or o.prodtype <> n.prodtype
        or o.globalno <> n.globalno
        or o.transeqno <> n.transeqno
        or o.trandate <> n.trandate
        or o.trantimestamp <> n.trantimestamp
        or o.transtatus <> n.transtatus
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_accounting_booking_cl(
            serialno -- 记账记录流水号
            ,clientno -- 客户编号
            ,clrid -- 押品编号
            ,registertype -- 登记簿类型（1-无实物押品、2-风管有实物、3-营运有实物）
            ,collattype -- 押品记账登记类型（1-抵押、2-质押、3-代保管）
            ,ccy -- 押品记账价值币种
            ,collatamount -- 押品记账价值金额
            ,paymentdirection -- 收付方向（1-收、2-付）
            ,branch -- 记账机构
            ,company -- 法人
            ,prodtype -- 产品类型
            ,globalno -- 交易全局流水号
            ,transeqno -- 交易流水号
            ,trandate -- 交易日期
            ,trantimestamp -- 交易时间戳
            ,transtatus -- 交易状态（0-待处理，1-已发核算中台，2-记账成功，3-记账失败）
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_accounting_booking_op(
            serialno -- 记账记录流水号
            ,clientno -- 客户编号
            ,clrid -- 押品编号
            ,registertype -- 登记簿类型（1-无实物押品、2-风管有实物、3-营运有实物）
            ,collattype -- 押品记账登记类型（1-抵押、2-质押、3-代保管）
            ,ccy -- 押品记账价值币种
            ,collatamount -- 押品记账价值金额
            ,paymentdirection -- 收付方向（1-收、2-付）
            ,branch -- 记账机构
            ,company -- 法人
            ,prodtype -- 产品类型
            ,globalno -- 交易全局流水号
            ,transeqno -- 交易流水号
            ,trandate -- 交易日期
            ,trantimestamp -- 交易时间戳
            ,transtatus -- 交易状态（0-待处理，1-已发核算中台，2-记账成功，3-记账失败）
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 记账记录流水号
    ,o.clientno -- 客户编号
    ,o.clrid -- 押品编号
    ,o.registertype -- 登记簿类型（1-无实物押品、2-风管有实物、3-营运有实物）
    ,o.collattype -- 押品记账登记类型（1-抵押、2-质押、3-代保管）
    ,o.ccy -- 押品记账价值币种
    ,o.collatamount -- 押品记账价值金额
    ,o.paymentdirection -- 收付方向（1-收、2-付）
    ,o.branch -- 记账机构
    ,o.company -- 法人
    ,o.prodtype -- 产品类型
    ,o.globalno -- 交易全局流水号
    ,o.transeqno -- 交易流水号
    ,o.trandate -- 交易日期
    ,o.trantimestamp -- 交易时间戳
    ,o.transtatus -- 交易状态（0-待处理，1-已发核算中台，2-记账成功，3-记账失败）
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
from ${iol_schema}.icms_clr_accounting_booking_bk o
    left join ${iol_schema}.icms_clr_accounting_booking_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_accounting_booking_cl d
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
--truncate table ${iol_schema}.icms_clr_accounting_booking;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_accounting_booking') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_accounting_booking drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_accounting_booking add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_accounting_booking exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_accounting_booking_cl;
alter table ${iol_schema}.icms_clr_accounting_booking exchange partition p_20991231 with table ${iol_schema}.icms_clr_accounting_booking_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_accounting_booking to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_accounting_booking_op purge;
drop table ${iol_schema}.icms_clr_accounting_booking_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_accounting_booking_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_accounting_booking',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
