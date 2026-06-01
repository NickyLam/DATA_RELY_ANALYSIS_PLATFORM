/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_eqpt_tran_def
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
create table ${iol_schema}.ncbs_tb_eqpt_tran_def_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_eqpt_tran_def
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_eqpt_tran_def_op purge;
drop table ${iol_schema}.ncbs_tb_eqpt_tran_def_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_eqpt_tran_def_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_eqpt_tran_def where 0=1;

create table ${iol_schema}.ncbs_tb_eqpt_tran_def_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_eqpt_tran_def where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_eqpt_tran_def_cl(
            amt_type -- 金额类型
            ,prod_type -- 产品编号
            ,tran_type -- 交易类型
            ,cash_equal -- 现金碰库标志
            ,company -- 法人
            ,cv_flag -- 现金/凭证标志
            ,event_type -- 事件类型
            ,centralize_flag -- 是否集中式
            ,move_type -- 转移类型
            ,pay_rec -- 收付标志
            ,post_flag -- 是否生成分录
            ,reversal -- 是否冲正标志
            ,tailbox_type -- 尾箱类型
            ,tran_desc -- 交易描述
            ,tran_timestamp -- 交易时间戳
            ,contra_branch_type -- 对方机构类型
            ,move_status -- 转移状态
            ,eqpt_type -- 自助设备类型
            ,eqpt_tran_status -- 自助设备交易流程状态
            ,amt_change_type -- 金额变化类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_eqpt_tran_def_op(
            amt_type -- 金额类型
            ,prod_type -- 产品编号
            ,tran_type -- 交易类型
            ,cash_equal -- 现金碰库标志
            ,company -- 法人
            ,cv_flag -- 现金/凭证标志
            ,event_type -- 事件类型
            ,centralize_flag -- 是否集中式
            ,move_type -- 转移类型
            ,pay_rec -- 收付标志
            ,post_flag -- 是否生成分录
            ,reversal -- 是否冲正标志
            ,tailbox_type -- 尾箱类型
            ,tran_desc -- 交易描述
            ,tran_timestamp -- 交易时间戳
            ,contra_branch_type -- 对方机构类型
            ,move_status -- 转移状态
            ,eqpt_type -- 自助设备类型
            ,eqpt_tran_status -- 自助设备交易流程状态
            ,amt_change_type -- 金额变化类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amt_type, o.amt_type) as amt_type -- 金额类型
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.cash_equal, o.cash_equal) as cash_equal -- 现金碰库标志
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.cv_flag, o.cv_flag) as cv_flag -- 现金/凭证标志
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.centralize_flag, o.centralize_flag) as centralize_flag -- 是否集中式
    ,nvl(n.move_type, o.move_type) as move_type -- 转移类型
    ,nvl(n.pay_rec, o.pay_rec) as pay_rec -- 收付标志
    ,nvl(n.post_flag, o.post_flag) as post_flag -- 是否生成分录
    ,nvl(n.reversal, o.reversal) as reversal -- 是否冲正标志
    ,nvl(n.tailbox_type, o.tailbox_type) as tailbox_type -- 尾箱类型
    ,nvl(n.tran_desc, o.tran_desc) as tran_desc -- 交易描述
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.contra_branch_type, o.contra_branch_type) as contra_branch_type -- 对方机构类型
    ,nvl(n.move_status, o.move_status) as move_status -- 转移状态
    ,nvl(n.eqpt_type, o.eqpt_type) as eqpt_type -- 自助设备类型
    ,nvl(n.eqpt_tran_status, o.eqpt_tran_status) as eqpt_tran_status -- 自助设备交易流程状态
    ,nvl(n.amt_change_type, o.amt_change_type) as amt_change_type -- 金额变化类型
    ,case when
            n.cv_flag is null
            and n.centralize_flag is null
            and n.eqpt_type is null
            and n.eqpt_tran_status is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cv_flag is null
            and n.centralize_flag is null
            and n.eqpt_type is null
            and n.eqpt_tran_status is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cv_flag is null
            and n.centralize_flag is null
            and n.eqpt_type is null
            and n.eqpt_tran_status is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_eqpt_tran_def_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_eqpt_tran_def where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cv_flag = n.cv_flag
            and o.centralize_flag = n.centralize_flag
            and o.eqpt_type = n.eqpt_type
            and o.eqpt_tran_status = n.eqpt_tran_status
where (
        o.cv_flag is null
        and o.centralize_flag is null
        and o.eqpt_type is null
        and o.eqpt_tran_status is null
    )
    or (
        n.cv_flag is null
        and n.centralize_flag is null
        and n.eqpt_type is null
        and n.eqpt_tran_status is null
    )
    or (
        o.amt_type <> n.amt_type
        or o.prod_type <> n.prod_type
        or o.tran_type <> n.tran_type
        or o.cash_equal <> n.cash_equal
        or o.company <> n.company
        or o.event_type <> n.event_type
        or o.move_type <> n.move_type
        or o.pay_rec <> n.pay_rec
        or o.post_flag <> n.post_flag
        or o.reversal <> n.reversal
        or o.tailbox_type <> n.tailbox_type
        or o.tran_desc <> n.tran_desc
        or o.tran_timestamp <> n.tran_timestamp
        or o.contra_branch_type <> n.contra_branch_type
        or o.move_status <> n.move_status
        or o.amt_change_type <> n.amt_change_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_eqpt_tran_def_cl(
            amt_type -- 金额类型
            ,prod_type -- 产品编号
            ,tran_type -- 交易类型
            ,cash_equal -- 现金碰库标志
            ,company -- 法人
            ,cv_flag -- 现金/凭证标志
            ,event_type -- 事件类型
            ,centralize_flag -- 是否集中式
            ,move_type -- 转移类型
            ,pay_rec -- 收付标志
            ,post_flag -- 是否生成分录
            ,reversal -- 是否冲正标志
            ,tailbox_type -- 尾箱类型
            ,tran_desc -- 交易描述
            ,tran_timestamp -- 交易时间戳
            ,contra_branch_type -- 对方机构类型
            ,move_status -- 转移状态
            ,eqpt_type -- 自助设备类型
            ,eqpt_tran_status -- 自助设备交易流程状态
            ,amt_change_type -- 金额变化类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_eqpt_tran_def_op(
            amt_type -- 金额类型
            ,prod_type -- 产品编号
            ,tran_type -- 交易类型
            ,cash_equal -- 现金碰库标志
            ,company -- 法人
            ,cv_flag -- 现金/凭证标志
            ,event_type -- 事件类型
            ,centralize_flag -- 是否集中式
            ,move_type -- 转移类型
            ,pay_rec -- 收付标志
            ,post_flag -- 是否生成分录
            ,reversal -- 是否冲正标志
            ,tailbox_type -- 尾箱类型
            ,tran_desc -- 交易描述
            ,tran_timestamp -- 交易时间戳
            ,contra_branch_type -- 对方机构类型
            ,move_status -- 转移状态
            ,eqpt_type -- 自助设备类型
            ,eqpt_tran_status -- 自助设备交易流程状态
            ,amt_change_type -- 金额变化类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amt_type -- 金额类型
    ,o.prod_type -- 产品编号
    ,o.tran_type -- 交易类型
    ,o.cash_equal -- 现金碰库标志
    ,o.company -- 法人
    ,o.cv_flag -- 现金/凭证标志
    ,o.event_type -- 事件类型
    ,o.centralize_flag -- 是否集中式
    ,o.move_type -- 转移类型
    ,o.pay_rec -- 收付标志
    ,o.post_flag -- 是否生成分录
    ,o.reversal -- 是否冲正标志
    ,o.tailbox_type -- 尾箱类型
    ,o.tran_desc -- 交易描述
    ,o.tran_timestamp -- 交易时间戳
    ,o.contra_branch_type -- 对方机构类型
    ,o.move_status -- 转移状态
    ,o.eqpt_type -- 自助设备类型
    ,o.eqpt_tran_status -- 自助设备交易流程状态
    ,o.amt_change_type -- 金额变化类型
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
from ${iol_schema}.ncbs_tb_eqpt_tran_def_bk o
    left join ${iol_schema}.ncbs_tb_eqpt_tran_def_op n
        on
            o.cv_flag = n.cv_flag
            and o.centralize_flag = n.centralize_flag
            and o.eqpt_type = n.eqpt_type
            and o.eqpt_tran_status = n.eqpt_tran_status
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_eqpt_tran_def_cl d
        on
            o.cv_flag = d.cv_flag
            and o.centralize_flag = d.centralize_flag
            and o.eqpt_type = d.eqpt_type
            and o.eqpt_tran_status = d.eqpt_tran_status
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_eqpt_tran_def;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_eqpt_tran_def') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_eqpt_tran_def drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_eqpt_tran_def add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_eqpt_tran_def exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_eqpt_tran_def_cl;
alter table ${iol_schema}.ncbs_tb_eqpt_tran_def exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_eqpt_tran_def_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_eqpt_tran_def to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_eqpt_tran_def_op purge;
drop table ${iol_schema}.ncbs_tb_eqpt_tran_def_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_eqpt_tran_def_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_eqpt_tran_def',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
