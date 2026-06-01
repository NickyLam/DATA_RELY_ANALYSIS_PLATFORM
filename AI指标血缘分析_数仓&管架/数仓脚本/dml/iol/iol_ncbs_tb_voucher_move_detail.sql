/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_voucher_move_detail
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
create table ${iol_schema}.ncbs_tb_voucher_move_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_voucher_move_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_voucher_move_detail_op purge;
drop table ${iol_schema}.ncbs_tb_voucher_move_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_voucher_move_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_voucher_move_detail where 0=1;

create table ${iol_schema}.ncbs_tb_voucher_move_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_voucher_move_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_voucher_move_detail_cl(
            ccy -- 币种
            ,doc_type -- 凭证类型
            ,company -- 法人
            ,move_id -- 调拨转移id
            ,prefix -- 前缀
            ,voucher_num -- 凭证数量
            ,tran_timestamp -- 交易时间戳
            ,tran_amt -- 交易金额
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,move_detail_id -- 转移明细编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_voucher_move_detail_op(
            ccy -- 币种
            ,doc_type -- 凭证类型
            ,company -- 法人
            ,move_id -- 调拨转移id
            ,prefix -- 前缀
            ,voucher_num -- 凭证数量
            ,tran_timestamp -- 交易时间戳
            ,tran_amt -- 交易金额
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,move_detail_id -- 转移明细编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.move_id, o.move_id) as move_id -- 调拨转移id
    ,nvl(n.prefix, o.prefix) as prefix -- 前缀
    ,nvl(n.voucher_num, o.voucher_num) as voucher_num -- 凭证数量
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.voucher_end_no, o.voucher_end_no) as voucher_end_no -- 凭证终止号码
    ,nvl(n.voucher_start_no, o.voucher_start_no) as voucher_start_no -- 凭证起始号码
    ,nvl(n.move_detail_id, o.move_detail_id) as move_detail_id -- 转移明细编号
    ,case when
            n.move_id is null
            and n.move_detail_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.move_id is null
            and n.move_detail_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.move_id is null
            and n.move_detail_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_voucher_move_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_voucher_move_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.move_id = n.move_id
            and o.move_detail_id = n.move_detail_id
where (
        o.move_id is null
        and o.move_detail_id is null
    )
    or (
        n.move_id is null
        and n.move_detail_id is null
    )
    or (
        o.ccy <> n.ccy
        or o.doc_type <> n.doc_type
        or o.company <> n.company
        or o.prefix <> n.prefix
        or o.voucher_num <> n.voucher_num
        or o.tran_timestamp <> n.tran_timestamp
        or o.tran_amt <> n.tran_amt
        or o.voucher_end_no <> n.voucher_end_no
        or o.voucher_start_no <> n.voucher_start_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_voucher_move_detail_cl(
            ccy -- 币种
            ,doc_type -- 凭证类型
            ,company -- 法人
            ,move_id -- 调拨转移id
            ,prefix -- 前缀
            ,voucher_num -- 凭证数量
            ,tran_timestamp -- 交易时间戳
            ,tran_amt -- 交易金额
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,move_detail_id -- 转移明细编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_voucher_move_detail_op(
            ccy -- 币种
            ,doc_type -- 凭证类型
            ,company -- 法人
            ,move_id -- 调拨转移id
            ,prefix -- 前缀
            ,voucher_num -- 凭证数量
            ,tran_timestamp -- 交易时间戳
            ,tran_amt -- 交易金额
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,move_detail_id -- 转移明细编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.doc_type -- 凭证类型
    ,o.company -- 法人
    ,o.move_id -- 调拨转移id
    ,o.prefix -- 前缀
    ,o.voucher_num -- 凭证数量
    ,o.tran_timestamp -- 交易时间戳
    ,o.tran_amt -- 交易金额
    ,o.voucher_end_no -- 凭证终止号码
    ,o.voucher_start_no -- 凭证起始号码
    ,o.move_detail_id -- 转移明细编号
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
from ${iol_schema}.ncbs_tb_voucher_move_detail_bk o
    left join ${iol_schema}.ncbs_tb_voucher_move_detail_op n
        on
            o.move_id = n.move_id
            and o.move_detail_id = n.move_detail_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_voucher_move_detail_cl d
        on
            o.move_id = d.move_id
            and o.move_detail_id = d.move_detail_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_voucher_move_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_voucher_move_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_voucher_move_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_voucher_move_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_voucher_move_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_voucher_move_detail_cl;
alter table ${iol_schema}.ncbs_tb_voucher_move_detail exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_voucher_move_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_voucher_move_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_voucher_move_detail_op purge;
drop table ${iol_schema}.ncbs_tb_voucher_move_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_voucher_move_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_voucher_move_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
