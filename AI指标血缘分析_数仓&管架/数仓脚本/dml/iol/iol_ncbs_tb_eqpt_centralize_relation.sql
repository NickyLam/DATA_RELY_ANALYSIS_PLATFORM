/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_eqpt_centralize_relation
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
create table ${iol_schema}.ncbs_tb_eqpt_centralize_relation_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_eqpt_centralize_relation
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_eqpt_centralize_relation_op purge;
drop table ${iol_schema}.ncbs_tb_eqpt_centralize_relation_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_eqpt_centralize_relation_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_eqpt_centralize_relation where 0=1;

create table ${iol_schema}.ncbs_tb_eqpt_centralize_relation_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_eqpt_centralize_relation where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_eqpt_centralize_relation_cl(
            address -- 地址
            ,company -- 法人
            ,centralize_flag -- 是否集中式
            ,memo -- 备用字段
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,cash_sign_deal_user -- 现金长短款处理柜员
            ,manage_branch -- 管理机构编号
            ,virtual_user_id -- 虚拟柜员代号
            ,virtual_branch -- 虚拟柜员柜员所在机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_eqpt_centralize_relation_op(
            address -- 地址
            ,company -- 法人
            ,centralize_flag -- 是否集中式
            ,memo -- 备用字段
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,cash_sign_deal_user -- 现金长短款处理柜员
            ,manage_branch -- 管理机构编号
            ,virtual_user_id -- 虚拟柜员代号
            ,virtual_branch -- 虚拟柜员柜员所在机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.address, o.address) as address -- 地址
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.centralize_flag, o.centralize_flag) as centralize_flag -- 是否集中式
    ,nvl(n.memo, o.memo) as memo -- 备用字段
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.cash_sign_deal_user, o.cash_sign_deal_user) as cash_sign_deal_user -- 现金长短款处理柜员
    ,nvl(n.manage_branch, o.manage_branch) as manage_branch -- 管理机构编号
    ,nvl(n.virtual_user_id, o.virtual_user_id) as virtual_user_id -- 虚拟柜员代号
    ,nvl(n.virtual_branch, o.virtual_branch) as virtual_branch -- 虚拟柜员柜员所在机构
    ,case when
            n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_eqpt_centralize_relation_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_eqpt_centralize_relation where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.address <> n.address
        or o.company <> n.company
        or o.centralize_flag <> n.centralize_flag
        or o.memo <> n.memo
        or o.source_type <> n.source_type
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.cash_sign_deal_user <> n.cash_sign_deal_user
        or o.manage_branch <> n.manage_branch
        or o.virtual_user_id <> n.virtual_user_id
        or o.virtual_branch <> n.virtual_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_eqpt_centralize_relation_cl(
            address -- 地址
            ,company -- 法人
            ,centralize_flag -- 是否集中式
            ,memo -- 备用字段
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,cash_sign_deal_user -- 现金长短款处理柜员
            ,manage_branch -- 管理机构编号
            ,virtual_user_id -- 虚拟柜员代号
            ,virtual_branch -- 虚拟柜员柜员所在机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_eqpt_centralize_relation_op(
            address -- 地址
            ,company -- 法人
            ,centralize_flag -- 是否集中式
            ,memo -- 备用字段
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,cash_sign_deal_user -- 现金长短款处理柜员
            ,manage_branch -- 管理机构编号
            ,virtual_user_id -- 虚拟柜员代号
            ,virtual_branch -- 虚拟柜员柜员所在机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.address -- 地址
    ,o.company -- 法人
    ,o.centralize_flag -- 是否集中式
    ,o.memo -- 备用字段
    ,o.seq_no -- 序号
    ,o.source_type -- 渠道编号
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.cash_sign_deal_user -- 现金长短款处理柜员
    ,o.manage_branch -- 管理机构编号
    ,o.virtual_user_id -- 虚拟柜员代号
    ,o.virtual_branch -- 虚拟柜员柜员所在机构
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
from ${iol_schema}.ncbs_tb_eqpt_centralize_relation_bk o
    left join ${iol_schema}.ncbs_tb_eqpt_centralize_relation_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_eqpt_centralize_relation_cl d
        on
            o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_eqpt_centralize_relation;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_eqpt_centralize_relation') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_eqpt_centralize_relation drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_eqpt_centralize_relation add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_eqpt_centralize_relation exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_eqpt_centralize_relation_cl;
alter table ${iol_schema}.ncbs_tb_eqpt_centralize_relation exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_eqpt_centralize_relation_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_eqpt_centralize_relation to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_eqpt_centralize_relation_op purge;
drop table ${iol_schema}.ncbs_tb_eqpt_centralize_relation_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_eqpt_centralize_relation_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_eqpt_centralize_relation',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
