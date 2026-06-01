/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_voucher_stm_mistake
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
create table ${iol_schema}.ncbs_tb_voucher_stm_mistake_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_voucher_stm_mistake
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_voucher_stm_mistake_op purge;
drop table ${iol_schema}.ncbs_tb_voucher_stm_mistake_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_voucher_stm_mistake_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_voucher_stm_mistake where 0=1;

create table ${iol_schema}.ncbs_tb_voucher_stm_mistake_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_voucher_stm_mistake where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_voucher_stm_mistake_cl(
            doc_type -- 凭证类型
            ,voucher_no -- 凭证号码
            ,company -- 法人
            ,deal_flag -- 处理标识
            ,from_tailbox_id -- 转出尾箱代号
            ,mistake_type -- 凭证差错类型
            ,to_tailbox_id -- 对方尾箱
            ,voucher_move_id -- 凭证转移id
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,deal_reason -- 处理说明
            ,from_user_id -- 分配/清机柜员
            ,to_branch -- 对方机构
            ,to_user_id -- 对方柜员
            ,from_branch -- 转出机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_voucher_stm_mistake_op(
            doc_type -- 凭证类型
            ,voucher_no -- 凭证号码
            ,company -- 法人
            ,deal_flag -- 处理标识
            ,from_tailbox_id -- 转出尾箱代号
            ,mistake_type -- 凭证差错类型
            ,to_tailbox_id -- 对方尾箱
            ,voucher_move_id -- 凭证转移id
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,deal_reason -- 处理说明
            ,from_user_id -- 分配/清机柜员
            ,to_branch -- 对方机构
            ,to_user_id -- 对方柜员
            ,from_branch -- 转出机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.voucher_no, o.voucher_no) as voucher_no -- 凭证号码
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.deal_flag, o.deal_flag) as deal_flag -- 处理标识
    ,nvl(n.from_tailbox_id, o.from_tailbox_id) as from_tailbox_id -- 转出尾箱代号
    ,nvl(n.mistake_type, o.mistake_type) as mistake_type -- 凭证差错类型
    ,nvl(n.to_tailbox_id, o.to_tailbox_id) as to_tailbox_id -- 对方尾箱
    ,nvl(n.voucher_move_id, o.voucher_move_id) as voucher_move_id -- 凭证转移id
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.deal_reason, o.deal_reason) as deal_reason -- 处理说明
    ,nvl(n.from_user_id, o.from_user_id) as from_user_id -- 分配/清机柜员
    ,nvl(n.to_branch, o.to_branch) as to_branch -- 对方机构
    ,nvl(n.to_user_id, o.to_user_id) as to_user_id -- 对方柜员
    ,nvl(n.from_branch, o.from_branch) as from_branch -- 转出机构
    ,case when
            n.doc_type is null
            and n.voucher_no is null
            and n.voucher_move_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.doc_type is null
            and n.voucher_no is null
            and n.voucher_move_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.doc_type is null
            and n.voucher_no is null
            and n.voucher_move_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_voucher_stm_mistake_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_voucher_stm_mistake where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.doc_type = n.doc_type
            and o.voucher_no = n.voucher_no
            and o.voucher_move_id = n.voucher_move_id
where (
        o.doc_type is null
        and o.voucher_no is null
        and o.voucher_move_id is null
    )
    or (
        n.doc_type is null
        and n.voucher_no is null
        and n.voucher_move_id is null
    )
    or (
        o.company <> n.company
        or o.deal_flag <> n.deal_flag
        or o.from_tailbox_id <> n.from_tailbox_id
        or o.mistake_type <> n.mistake_type
        or o.to_tailbox_id <> n.to_tailbox_id
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.deal_reason <> n.deal_reason
        or o.from_user_id <> n.from_user_id
        or o.to_branch <> n.to_branch
        or o.to_user_id <> n.to_user_id
        or o.from_branch <> n.from_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_voucher_stm_mistake_cl(
            doc_type -- 凭证类型
            ,voucher_no -- 凭证号码
            ,company -- 法人
            ,deal_flag -- 处理标识
            ,from_tailbox_id -- 转出尾箱代号
            ,mistake_type -- 凭证差错类型
            ,to_tailbox_id -- 对方尾箱
            ,voucher_move_id -- 凭证转移id
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,deal_reason -- 处理说明
            ,from_user_id -- 分配/清机柜员
            ,to_branch -- 对方机构
            ,to_user_id -- 对方柜员
            ,from_branch -- 转出机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_voucher_stm_mistake_op(
            doc_type -- 凭证类型
            ,voucher_no -- 凭证号码
            ,company -- 法人
            ,deal_flag -- 处理标识
            ,from_tailbox_id -- 转出尾箱代号
            ,mistake_type -- 凭证差错类型
            ,to_tailbox_id -- 对方尾箱
            ,voucher_move_id -- 凭证转移id
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,deal_reason -- 处理说明
            ,from_user_id -- 分配/清机柜员
            ,to_branch -- 对方机构
            ,to_user_id -- 对方柜员
            ,from_branch -- 转出机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.doc_type -- 凭证类型
    ,o.voucher_no -- 凭证号码
    ,o.company -- 法人
    ,o.deal_flag -- 处理标识
    ,o.from_tailbox_id -- 转出尾箱代号
    ,o.mistake_type -- 凭证差错类型
    ,o.to_tailbox_id -- 对方尾箱
    ,o.voucher_move_id -- 凭证转移id
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.deal_reason -- 处理说明
    ,o.from_user_id -- 分配/清机柜员
    ,o.to_branch -- 对方机构
    ,o.to_user_id -- 对方柜员
    ,o.from_branch -- 转出机构
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
from ${iol_schema}.ncbs_tb_voucher_stm_mistake_bk o
    left join ${iol_schema}.ncbs_tb_voucher_stm_mistake_op n
        on
            o.doc_type = n.doc_type
            and o.voucher_no = n.voucher_no
            and o.voucher_move_id = n.voucher_move_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_voucher_stm_mistake_cl d
        on
            o.doc_type = d.doc_type
            and o.voucher_no = d.voucher_no
            and o.voucher_move_id = d.voucher_move_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_voucher_stm_mistake;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_voucher_stm_mistake') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_voucher_stm_mistake drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_voucher_stm_mistake add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_voucher_stm_mistake exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_voucher_stm_mistake_cl;
alter table ${iol_schema}.ncbs_tb_voucher_stm_mistake exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_voucher_stm_mistake_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_voucher_stm_mistake to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_voucher_stm_mistake_op purge;
drop table ${iol_schema}.ncbs_tb_voucher_stm_mistake_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_voucher_stm_mistake_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_voucher_stm_mistake',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
