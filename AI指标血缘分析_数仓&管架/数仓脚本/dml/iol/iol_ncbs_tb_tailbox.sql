/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_tailbox
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
create table ${iol_schema}.ncbs_tb_tailbox_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_tailbox
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_tailbox_op purge;
drop table ${iol_schema}.ncbs_tb_tailbox_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_tailbox_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_tailbox where 0=1;

create table ${iol_schema}.ncbs_tb_tailbox_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_tailbox where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_tailbox_cl(
            eod_voucher_equal -- 日终凭证碰库标志
            ,branch -- 机构编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,tailbox_id -- 尾箱代号
            ,tailbox_property -- 尾箱属性
            ,tailbox_status -- 尾箱状态
            ,tailbox_type -- 尾箱类型
            ,create_date -- 创建日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,assign_user_id -- 分配柜员
            ,last_user_id -- 上一柜员id
            ,sod_cash_equal -- 日始现金碰库标识
            ,sod_voucher_equal -- 日始凭证碰库标识
            ,eod_cash_equal -- 日终现金碰库标志
            ,teller_bind_type -- 柜员绑定关系
            ,voucher_equal_timestamp -- 凭证碰库时间戳
            ,cash_equal_timestamp -- 现金碰库时间戳
            ,tailbox_sub_type -- 尾箱细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_tailbox_op(
            eod_voucher_equal -- 日终凭证碰库标志
            ,branch -- 机构编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,tailbox_id -- 尾箱代号
            ,tailbox_property -- 尾箱属性
            ,tailbox_status -- 尾箱状态
            ,tailbox_type -- 尾箱类型
            ,create_date -- 创建日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,assign_user_id -- 分配柜员
            ,last_user_id -- 上一柜员id
            ,sod_cash_equal -- 日始现金碰库标识
            ,sod_voucher_equal -- 日始凭证碰库标识
            ,eod_cash_equal -- 日终现金碰库标志
            ,teller_bind_type -- 柜员绑定关系
            ,voucher_equal_timestamp -- 凭证碰库时间戳
            ,cash_equal_timestamp -- 现金碰库时间戳
            ,tailbox_sub_type -- 尾箱细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.eod_voucher_equal, o.eod_voucher_equal) as eod_voucher_equal -- 日终凭证碰库标志
    ,nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.tailbox_id, o.tailbox_id) as tailbox_id -- 尾箱代号
    ,nvl(n.tailbox_property, o.tailbox_property) as tailbox_property -- 尾箱属性
    ,nvl(n.tailbox_status, o.tailbox_status) as tailbox_status -- 尾箱状态
    ,nvl(n.tailbox_type, o.tailbox_type) as tailbox_type -- 尾箱类型
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.update_date, o.update_date) as update_date -- 更新日期
    ,nvl(n.assign_user_id, o.assign_user_id) as assign_user_id -- 分配柜员
    ,nvl(n.last_user_id, o.last_user_id) as last_user_id -- 上一柜员id
    ,nvl(n.sod_cash_equal, o.sod_cash_equal) as sod_cash_equal -- 日始现金碰库标识
    ,nvl(n.sod_voucher_equal, o.sod_voucher_equal) as sod_voucher_equal -- 日始凭证碰库标识
    ,nvl(n.eod_cash_equal, o.eod_cash_equal) as eod_cash_equal -- 日终现金碰库标志
    ,nvl(n.teller_bind_type, o.teller_bind_type) as teller_bind_type -- 柜员绑定关系
    ,nvl(n.voucher_equal_timestamp, o.voucher_equal_timestamp) as voucher_equal_timestamp -- 凭证碰库时间戳
    ,nvl(n.cash_equal_timestamp, o.cash_equal_timestamp) as cash_equal_timestamp -- 现金碰库时间戳
    ,nvl(n.tailbox_sub_type, o.tailbox_sub_type) as tailbox_sub_type -- 尾箱细类
    ,case when
            n.tailbox_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tailbox_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tailbox_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_tailbox_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_tailbox where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tailbox_id = n.tailbox_id
where (
        o.tailbox_id is null
    )
    or (
        n.tailbox_id is null
    )
    or (
        o.eod_voucher_equal <> n.eod_voucher_equal
        or o.branch <> n.branch
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.tailbox_property <> n.tailbox_property
        or o.tailbox_status <> n.tailbox_status
        or o.tailbox_type <> n.tailbox_type
        or o.create_date <> n.create_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.update_date <> n.update_date
        or o.assign_user_id <> n.assign_user_id
        or o.last_user_id <> n.last_user_id
        or o.sod_cash_equal <> n.sod_cash_equal
        or o.sod_voucher_equal <> n.sod_voucher_equal
        or o.eod_cash_equal <> n.eod_cash_equal
        or o.teller_bind_type <> n.teller_bind_type
        or o.voucher_equal_timestamp <> n.voucher_equal_timestamp
        or o.cash_equal_timestamp <> n.cash_equal_timestamp
        or o.tailbox_sub_type <> n.tailbox_sub_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_tailbox_cl(
            eod_voucher_equal -- 日终凭证碰库标志
            ,branch -- 机构编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,tailbox_id -- 尾箱代号
            ,tailbox_property -- 尾箱属性
            ,tailbox_status -- 尾箱状态
            ,tailbox_type -- 尾箱类型
            ,create_date -- 创建日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,assign_user_id -- 分配柜员
            ,last_user_id -- 上一柜员id
            ,sod_cash_equal -- 日始现金碰库标识
            ,sod_voucher_equal -- 日始凭证碰库标识
            ,eod_cash_equal -- 日终现金碰库标志
            ,teller_bind_type -- 柜员绑定关系
            ,voucher_equal_timestamp -- 凭证碰库时间戳
            ,cash_equal_timestamp -- 现金碰库时间戳
            ,tailbox_sub_type -- 尾箱细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_tailbox_op(
            eod_voucher_equal -- 日终凭证碰库标志
            ,branch -- 机构编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,tailbox_id -- 尾箱代号
            ,tailbox_property -- 尾箱属性
            ,tailbox_status -- 尾箱状态
            ,tailbox_type -- 尾箱类型
            ,create_date -- 创建日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,assign_user_id -- 分配柜员
            ,last_user_id -- 上一柜员id
            ,sod_cash_equal -- 日始现金碰库标识
            ,sod_voucher_equal -- 日始凭证碰库标识
            ,eod_cash_equal -- 日终现金碰库标志
            ,teller_bind_type -- 柜员绑定关系
            ,voucher_equal_timestamp -- 凭证碰库时间戳
            ,cash_equal_timestamp -- 现金碰库时间戳
            ,tailbox_sub_type -- 尾箱细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.eod_voucher_equal -- 日终凭证碰库标志
    ,o.branch -- 机构编号
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.tailbox_id -- 尾箱代号
    ,o.tailbox_property -- 尾箱属性
    ,o.tailbox_status -- 尾箱状态
    ,o.tailbox_type -- 尾箱类型
    ,o.create_date -- 创建日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.update_date -- 更新日期
    ,o.assign_user_id -- 分配柜员
    ,o.last_user_id -- 上一柜员id
    ,o.sod_cash_equal -- 日始现金碰库标识
    ,o.sod_voucher_equal -- 日始凭证碰库标识
    ,o.eod_cash_equal -- 日终现金碰库标志
    ,o.teller_bind_type -- 柜员绑定关系
    ,o.voucher_equal_timestamp -- 凭证碰库时间戳
    ,o.cash_equal_timestamp -- 现金碰库时间戳
    ,o.tailbox_sub_type -- 尾箱细类
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
from ${iol_schema}.ncbs_tb_tailbox_bk o
    left join ${iol_schema}.ncbs_tb_tailbox_op n
        on
            o.tailbox_id = n.tailbox_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_tailbox_cl d
        on
            o.tailbox_id = d.tailbox_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_tailbox;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_tailbox') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_tailbox drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_tailbox add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_tailbox exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_tailbox_cl;
alter table ${iol_schema}.ncbs_tb_tailbox exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_tailbox_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_tailbox to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_tailbox_op purge;
drop table ${iol_schema}.ncbs_tb_tailbox_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_tailbox_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_tailbox',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
