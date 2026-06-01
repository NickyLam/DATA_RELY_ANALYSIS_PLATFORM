/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_dispatch_def
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
create table ${iol_schema}.ncbs_tb_dispatch_def_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_dispatch_def
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_dispatch_def_op purge;
drop table ${iol_schema}.ncbs_tb_dispatch_def_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_dispatch_def_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_dispatch_def where 0=1;

create table ${iol_schema}.ncbs_tb_dispatch_def_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_dispatch_def where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_dispatch_def_cl(
            tran_type -- 交易类型
            ,acgl_flag -- 记账种类
            ,acs_flag -- 人行联网取现标志
            ,company -- 法人
            ,contra_event_type -- 对手事件类型
            ,contra_tran_type -- 对手交易类型
            ,cv_flag -- 现金/凭证标志
            ,event_type -- 事件类型
            ,move_type -- 转移类型
            ,post_flag -- 是否生成分录
            ,seq_no -- 序号
            ,tran_desc -- 交易描述
            ,use_by_order_flag -- 是否按顺序使用
            ,tran_timestamp -- 交易时间戳
            ,contra_branch_type -- 对方机构类型
            ,dispatch_option -- 调拨业务标记
            ,inout_confirm_flag -- 出入库确认标志
            ,confirm_event_type -- 确认事件类型
            ,confirm_tran_type -- 确认交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_dispatch_def_op(
            tran_type -- 交易类型
            ,acgl_flag -- 记账种类
            ,acs_flag -- 人行联网取现标志
            ,company -- 法人
            ,contra_event_type -- 对手事件类型
            ,contra_tran_type -- 对手交易类型
            ,cv_flag -- 现金/凭证标志
            ,event_type -- 事件类型
            ,move_type -- 转移类型
            ,post_flag -- 是否生成分录
            ,seq_no -- 序号
            ,tran_desc -- 交易描述
            ,use_by_order_flag -- 是否按顺序使用
            ,tran_timestamp -- 交易时间戳
            ,contra_branch_type -- 对方机构类型
            ,dispatch_option -- 调拨业务标记
            ,inout_confirm_flag -- 出入库确认标志
            ,confirm_event_type -- 确认事件类型
            ,confirm_tran_type -- 确认交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.acgl_flag, o.acgl_flag) as acgl_flag -- 记账种类
    ,nvl(n.acs_flag, o.acs_flag) as acs_flag -- 人行联网取现标志
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.contra_event_type, o.contra_event_type) as contra_event_type -- 对手事件类型
    ,nvl(n.contra_tran_type, o.contra_tran_type) as contra_tran_type -- 对手交易类型
    ,nvl(n.cv_flag, o.cv_flag) as cv_flag -- 现金/凭证标志
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.move_type, o.move_type) as move_type -- 转移类型
    ,nvl(n.post_flag, o.post_flag) as post_flag -- 是否生成分录
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.tran_desc, o.tran_desc) as tran_desc -- 交易描述
    ,nvl(n.use_by_order_flag, o.use_by_order_flag) as use_by_order_flag -- 是否按顺序使用
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.contra_branch_type, o.contra_branch_type) as contra_branch_type -- 对方机构类型
    ,nvl(n.dispatch_option, o.dispatch_option) as dispatch_option -- 调拨业务标记
    ,nvl(n.inout_confirm_flag, o.inout_confirm_flag) as inout_confirm_flag -- 出入库确认标志
    ,nvl(n.confirm_event_type, o.confirm_event_type) as confirm_event_type -- 确认事件类型
    ,nvl(n.confirm_tran_type, o.confirm_tran_type) as confirm_tran_type -- 确认交易类型
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
from (select * from ${iol_schema}.ncbs_tb_dispatch_def_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_dispatch_def where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.tran_type <> n.tran_type
        or o.acgl_flag <> n.acgl_flag
        or o.acs_flag <> n.acs_flag
        or o.company <> n.company
        or o.contra_event_type <> n.contra_event_type
        or o.contra_tran_type <> n.contra_tran_type
        or o.cv_flag <> n.cv_flag
        or o.event_type <> n.event_type
        or o.move_type <> n.move_type
        or o.post_flag <> n.post_flag
        or o.tran_desc <> n.tran_desc
        or o.use_by_order_flag <> n.use_by_order_flag
        or o.tran_timestamp <> n.tran_timestamp
        or o.contra_branch_type <> n.contra_branch_type
        or o.dispatch_option <> n.dispatch_option
        or o.inout_confirm_flag <> n.inout_confirm_flag
        or o.confirm_event_type <> n.confirm_event_type
        or o.confirm_tran_type <> n.confirm_tran_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_dispatch_def_cl(
            tran_type -- 交易类型
            ,acgl_flag -- 记账种类
            ,acs_flag -- 人行联网取现标志
            ,company -- 法人
            ,contra_event_type -- 对手事件类型
            ,contra_tran_type -- 对手交易类型
            ,cv_flag -- 现金/凭证标志
            ,event_type -- 事件类型
            ,move_type -- 转移类型
            ,post_flag -- 是否生成分录
            ,seq_no -- 序号
            ,tran_desc -- 交易描述
            ,use_by_order_flag -- 是否按顺序使用
            ,tran_timestamp -- 交易时间戳
            ,contra_branch_type -- 对方机构类型
            ,dispatch_option -- 调拨业务标记
            ,inout_confirm_flag -- 出入库确认标志
            ,confirm_event_type -- 确认事件类型
            ,confirm_tran_type -- 确认交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_dispatch_def_op(
            tran_type -- 交易类型
            ,acgl_flag -- 记账种类
            ,acs_flag -- 人行联网取现标志
            ,company -- 法人
            ,contra_event_type -- 对手事件类型
            ,contra_tran_type -- 对手交易类型
            ,cv_flag -- 现金/凭证标志
            ,event_type -- 事件类型
            ,move_type -- 转移类型
            ,post_flag -- 是否生成分录
            ,seq_no -- 序号
            ,tran_desc -- 交易描述
            ,use_by_order_flag -- 是否按顺序使用
            ,tran_timestamp -- 交易时间戳
            ,contra_branch_type -- 对方机构类型
            ,dispatch_option -- 调拨业务标记
            ,inout_confirm_flag -- 出入库确认标志
            ,confirm_event_type -- 确认事件类型
            ,confirm_tran_type -- 确认交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tran_type -- 交易类型
    ,o.acgl_flag -- 记账种类
    ,o.acs_flag -- 人行联网取现标志
    ,o.company -- 法人
    ,o.contra_event_type -- 对手事件类型
    ,o.contra_tran_type -- 对手交易类型
    ,o.cv_flag -- 现金/凭证标志
    ,o.event_type -- 事件类型
    ,o.move_type -- 转移类型
    ,o.post_flag -- 是否生成分录
    ,o.seq_no -- 序号
    ,o.tran_desc -- 交易描述
    ,o.use_by_order_flag -- 是否按顺序使用
    ,o.tran_timestamp -- 交易时间戳
    ,o.contra_branch_type -- 对方机构类型
    ,o.dispatch_option -- 调拨业务标记
    ,o.inout_confirm_flag -- 出入库确认标志
    ,o.confirm_event_type -- 确认事件类型
    ,o.confirm_tran_type -- 确认交易类型
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
from ${iol_schema}.ncbs_tb_dispatch_def_bk o
    left join ${iol_schema}.ncbs_tb_dispatch_def_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_dispatch_def_cl d
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
--truncate table ${iol_schema}.ncbs_tb_dispatch_def;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_dispatch_def') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_dispatch_def drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_dispatch_def add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_dispatch_def exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_dispatch_def_cl;
alter table ${iol_schema}.ncbs_tb_dispatch_def exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_dispatch_def_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_dispatch_def to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_dispatch_def_op purge;
drop table ${iol_schema}.ncbs_tb_dispatch_def_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_dispatch_def_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_dispatch_def',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
