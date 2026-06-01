/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_seal_relation_hist
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_rb_seal_relation_hist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_seal_relation_hist
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_seal_relation_hist_op purge;
drop table ${iol_schema}.ncbs_rb_seal_relation_hist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_seal_relation_hist_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ncbs_rb_seal_relation_hist where 0=1;

create table ${iol_schema}.ncbs_rb_seal_relation_hist_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ncbs_rb_seal_relation_hist where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.ncbs_rb_seal_relation_hist_op(
        client_no -- 客户编号
        ,doc_type -- 凭证类型
        ,internal_key -- 账户内部键值
        ,remark -- 备注
        ,voucher_no -- 凭证号码
        ,company -- 法人
        ,lead_acct_flag -- 主账户标志
        ,operate_flag -- 操作类型
        ,prefix -- 前缀
        ,end_date -- 结束日期
        ,last_change_date -- 最后修改日期
        ,start_date -- 开始日期
        ,tran_timestamp -- 交易时间戳
        ,last_change_user_id -- 最后修改柜员
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.client_no -- 客户编号
    ,n.doc_type -- 凭证类型
    ,n.internal_key -- 账户内部键值
    ,n.remark -- 备注
    ,n.voucher_no -- 凭证号码
    ,n.company -- 法人
    ,n.lead_acct_flag -- 主账户标志
    ,n.operate_flag -- 操作类型
    ,n.prefix -- 前缀
    ,n.end_date -- 结束日期
    ,n.last_change_date -- 最后修改日期
    ,n.start_date -- 开始日期
    ,n.tran_timestamp -- 交易时间戳
    ,n.last_change_user_id -- 最后修改柜员
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_seal_relation_hist_bk o
    right join (select * from ${itl_schema}.ncbs_rb_seal_relation_hist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.doc_type = n.doc_type
            and o.internal_key = n.internal_key
            and o.voucher_no = n.voucher_no
where (
        o.doc_type is null
        and o.internal_key is null
        and o.voucher_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.remark <> n.remark
        or o.company <> n.company
        or o.lead_acct_flag <> n.lead_acct_flag
        or o.operate_flag <> n.operate_flag
        or o.prefix <> n.prefix
        or o.end_date <> n.end_date
        or o.last_change_date <> n.last_change_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.last_change_user_id <> n.last_change_user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_seal_relation_hist_cl(
            client_no -- 客户编号
        ,doc_type -- 凭证类型
        ,internal_key -- 账户内部键值
        ,remark -- 备注
        ,voucher_no -- 凭证号码
        ,company -- 法人
        ,lead_acct_flag -- 主账户标志
        ,operate_flag -- 操作类型
        ,prefix -- 前缀
        ,end_date -- 结束日期
        ,last_change_date -- 最后修改日期
        ,start_date -- 开始日期
        ,tran_timestamp -- 交易时间戳
        ,last_change_user_id -- 最后修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_seal_relation_hist_op(
            client_no -- 客户编号
        ,doc_type -- 凭证类型
        ,internal_key -- 账户内部键值
        ,remark -- 备注
        ,voucher_no -- 凭证号码
        ,company -- 法人
        ,lead_acct_flag -- 主账户标志
        ,operate_flag -- 操作类型
        ,prefix -- 前缀
        ,end_date -- 结束日期
        ,last_change_date -- 最后修改日期
        ,start_date -- 开始日期
        ,tran_timestamp -- 交易时间戳
        ,last_change_user_id -- 最后修改柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.doc_type -- 凭证类型
    ,o.internal_key -- 账户内部键值
    ,o.remark -- 备注
    ,o.voucher_no -- 凭证号码
    ,o.company -- 法人
    ,o.lead_acct_flag -- 主账户标志
    ,o.operate_flag -- 操作类型
    ,o.prefix -- 前缀
    ,o.end_date -- 结束日期
    ,o.last_change_date -- 最后修改日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.last_change_user_id -- 最后修改柜员
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_seal_relation_hist_bk o
    left join ${iol_schema}.ncbs_rb_seal_relation_hist_op n
        on
            o.doc_type = n.doc_type
            and o.internal_key = n.internal_key
            and o.voucher_no = n.voucher_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_seal_relation_hist;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_seal_relation_hist') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_seal_relation_hist drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_seal_relation_hist add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_seal_relation_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_seal_relation_hist_cl;
alter table ${iol_schema}.ncbs_rb_seal_relation_hist exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_seal_relation_hist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_seal_relation_hist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_seal_relation_hist_op purge;
drop table ${iol_schema}.ncbs_rb_seal_relation_hist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_seal_relation_hist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_seal_relation_hist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
