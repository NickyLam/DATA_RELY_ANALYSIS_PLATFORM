/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbtacfmdetail
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
create table ${iol_schema}.ifms_tbtacfmdetail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbtacfmdetail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbtacfmdetail_op purge;
drop table ${iol_schema}.ifms_tbtacfmdetail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbtacfmdetail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbtacfmdetail where 0=1;

create table ${iol_schema}.ifms_tbtacfmdetail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbtacfmdetail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbtacfmdetail_cl(
            busin_code -- 
            ,cfm_date -- 
            ,detail_cfm_no -- 
            ,cfm_no -- 
            ,seller_code -- 
            ,asset_acc -- 
            ,prd_code -- 
            ,share_class -- 
            ,trans_date -- 
            ,serial_no -- 
            ,ori_cfm_date -- 
            ,ori_cfm_no -- 
            ,regist_date -- 
            ,cfm_amt -- 
            ,cfm_vol -- 
            ,trade_fee -- 
            ,transfer_fee -- 
            ,stamp_tax -- 
            ,back_fee -- 
            ,other_fee1 -- 
            ,gain_income -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbtacfmdetail_op(
            busin_code -- 
            ,cfm_date -- 
            ,detail_cfm_no -- 
            ,cfm_no -- 
            ,seller_code -- 
            ,asset_acc -- 
            ,prd_code -- 
            ,share_class -- 
            ,trans_date -- 
            ,serial_no -- 
            ,ori_cfm_date -- 
            ,ori_cfm_no -- 
            ,regist_date -- 
            ,cfm_amt -- 
            ,cfm_vol -- 
            ,trade_fee -- 
            ,transfer_fee -- 
            ,stamp_tax -- 
            ,back_fee -- 
            ,other_fee1 -- 
            ,gain_income -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.busin_code, o.busin_code) as busin_code -- 
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 
    ,nvl(n.detail_cfm_no, o.detail_cfm_no) as detail_cfm_no -- 
    ,nvl(n.cfm_no, o.cfm_no) as cfm_no -- 
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.share_class, o.share_class) as share_class -- 
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 
    ,nvl(n.ori_cfm_date, o.ori_cfm_date) as ori_cfm_date -- 
    ,nvl(n.ori_cfm_no, o.ori_cfm_no) as ori_cfm_no -- 
    ,nvl(n.regist_date, o.regist_date) as regist_date -- 
    ,nvl(n.cfm_amt, o.cfm_amt) as cfm_amt -- 
    ,nvl(n.cfm_vol, o.cfm_vol) as cfm_vol -- 
    ,nvl(n.trade_fee, o.trade_fee) as trade_fee -- 
    ,nvl(n.transfer_fee, o.transfer_fee) as transfer_fee -- 
    ,nvl(n.stamp_tax, o.stamp_tax) as stamp_tax -- 
    ,nvl(n.back_fee, o.back_fee) as back_fee -- 
    ,nvl(n.other_fee1, o.other_fee1) as other_fee1 -- 
    ,nvl(n.gain_income, o.gain_income) as gain_income -- 
    ,nvl(n.amt1, o.amt1) as amt1 -- 
    ,nvl(n.amt2, o.amt2) as amt2 -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,case when
            n.detail_cfm_no is null
            and n.cfm_no is null
            and n.seller_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.detail_cfm_no is null
            and n.cfm_no is null
            and n.seller_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.detail_cfm_no is null
            and n.cfm_no is null
            and n.seller_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbtacfmdetail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbtacfmdetail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.detail_cfm_no = n.detail_cfm_no
            and o.cfm_no = n.cfm_no
            and o.seller_code = n.seller_code
where (
        o.detail_cfm_no is null
        and o.cfm_no is null
        and o.seller_code is null
    )
    or (
        n.detail_cfm_no is null
        and n.cfm_no is null
        and n.seller_code is null
    )
    or (
        o.busin_code <> n.busin_code
        or o.cfm_date <> n.cfm_date
        or o.asset_acc <> n.asset_acc
        or o.prd_code <> n.prd_code
        or o.share_class <> n.share_class
        or o.trans_date <> n.trans_date
        or o.serial_no <> n.serial_no
        or o.ori_cfm_date <> n.ori_cfm_date
        or o.ori_cfm_no <> n.ori_cfm_no
        or o.regist_date <> n.regist_date
        or o.cfm_amt <> n.cfm_amt
        or o.cfm_vol <> n.cfm_vol
        or o.trade_fee <> n.trade_fee
        or o.transfer_fee <> n.transfer_fee
        or o.stamp_tax <> n.stamp_tax
        or o.back_fee <> n.back_fee
        or o.other_fee1 <> n.other_fee1
        or o.gain_income <> n.gain_income
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbtacfmdetail_cl(
            busin_code -- 
            ,cfm_date -- 
            ,detail_cfm_no -- 
            ,cfm_no -- 
            ,seller_code -- 
            ,asset_acc -- 
            ,prd_code -- 
            ,share_class -- 
            ,trans_date -- 
            ,serial_no -- 
            ,ori_cfm_date -- 
            ,ori_cfm_no -- 
            ,regist_date -- 
            ,cfm_amt -- 
            ,cfm_vol -- 
            ,trade_fee -- 
            ,transfer_fee -- 
            ,stamp_tax -- 
            ,back_fee -- 
            ,other_fee1 -- 
            ,gain_income -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbtacfmdetail_op(
            busin_code -- 
            ,cfm_date -- 
            ,detail_cfm_no -- 
            ,cfm_no -- 
            ,seller_code -- 
            ,asset_acc -- 
            ,prd_code -- 
            ,share_class -- 
            ,trans_date -- 
            ,serial_no -- 
            ,ori_cfm_date -- 
            ,ori_cfm_no -- 
            ,regist_date -- 
            ,cfm_amt -- 
            ,cfm_vol -- 
            ,trade_fee -- 
            ,transfer_fee -- 
            ,stamp_tax -- 
            ,back_fee -- 
            ,other_fee1 -- 
            ,gain_income -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.busin_code -- 
    ,o.cfm_date -- 
    ,o.detail_cfm_no -- 
    ,o.cfm_no -- 
    ,o.seller_code -- 
    ,o.asset_acc -- 
    ,o.prd_code -- 
    ,o.share_class -- 
    ,o.trans_date -- 
    ,o.serial_no -- 
    ,o.ori_cfm_date -- 
    ,o.ori_cfm_no -- 
    ,o.regist_date -- 
    ,o.cfm_amt -- 
    ,o.cfm_vol -- 
    ,o.trade_fee -- 
    ,o.transfer_fee -- 
    ,o.stamp_tax -- 
    ,o.back_fee -- 
    ,o.other_fee1 -- 
    ,o.gain_income -- 
    ,o.amt1 -- 
    ,o.amt2 -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
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
from ${iol_schema}.ifms_tbtacfmdetail_bk o
    left join ${iol_schema}.ifms_tbtacfmdetail_op n
        on
            o.detail_cfm_no = n.detail_cfm_no
            and o.cfm_no = n.cfm_no
            and o.seller_code = n.seller_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbtacfmdetail_cl d
        on
            o.detail_cfm_no = d.detail_cfm_no
            and o.cfm_no = d.cfm_no
            and o.seller_code = d.seller_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifms_tbtacfmdetail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifms_tbtacfmdetail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifms_tbtacfmdetail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifms_tbtacfmdetail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifms_tbtacfmdetail exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbtacfmdetail_cl;
alter table ${iol_schema}.ifms_tbtacfmdetail exchange partition p_20991231 with table ${iol_schema}.ifms_tbtacfmdetail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbtacfmdetail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbtacfmdetail_op purge;
drop table ${iol_schema}.ifms_tbtacfmdetail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbtacfmdetail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbtacfmdetail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
