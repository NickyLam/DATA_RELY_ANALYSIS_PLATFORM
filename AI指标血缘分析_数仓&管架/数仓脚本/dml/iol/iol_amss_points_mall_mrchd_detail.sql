/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_points_mall_mrchd_detail
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
create table ${iol_schema}.amss_points_mall_mrchd_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_points_mall_mrchd_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_points_mall_mrchd_detail_op purge;
drop table ${iol_schema}.amss_points_mall_mrchd_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_points_mall_mrchd_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_points_mall_mrchd_detail where 0=1;

create table ${iol_schema}.amss_points_mall_mrchd_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_points_mall_mrchd_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_points_mall_mrchd_detail_cl(
            id -- 主键
            ,serial_num -- 订单主键
            ,mrchd_id -- 商品信息ID
            ,mrchd_price -- 单个商品价值
            ,cnsm_typ -- 消费类型 P-积分 C-现金 F-福利金 X-权益积分
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,undo_refund_flag -- 退货专用字段 0：未退货    2：已退货
            ,order_no -- 渠道方订单流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_points_mall_mrchd_detail_op(
            id -- 主键
            ,serial_num -- 订单主键
            ,mrchd_id -- 商品信息ID
            ,mrchd_price -- 单个商品价值
            ,cnsm_typ -- 消费类型 P-积分 C-现金 F-福利金 X-权益积分
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,undo_refund_flag -- 退货专用字段 0：未退货    2：已退货
            ,order_no -- 渠道方订单流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.serial_num, o.serial_num) as serial_num -- 订单主键
    ,nvl(n.mrchd_id, o.mrchd_id) as mrchd_id -- 商品信息ID
    ,nvl(n.mrchd_price, o.mrchd_price) as mrchd_price -- 单个商品价值
    ,nvl(n.cnsm_typ, o.cnsm_typ) as cnsm_typ -- 消费类型 P-积分 C-现金 F-福利金 X-权益积分
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识 1-正常 2-删除
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 更新人
    ,nvl(n.undo_refund_flag, o.undo_refund_flag) as undo_refund_flag -- 退货专用字段 0：未退货    2：已退货
    ,nvl(n.order_no, o.order_no) as order_no -- 渠道方订单流水
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_points_mall_mrchd_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_points_mall_mrchd_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.serial_num <> n.serial_num
        or o.mrchd_id <> n.mrchd_id
        or o.mrchd_price <> n.mrchd_price
        or o.cnsm_typ <> n.cnsm_typ
        or o.physics_flag <> n.physics_flag
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.create_emp <> n.create_emp
        or o.update_emp <> n.update_emp
        or o.undo_refund_flag <> n.undo_refund_flag
        or o.order_no <> n.order_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_points_mall_mrchd_detail_cl(
            id -- 主键
            ,serial_num -- 订单主键
            ,mrchd_id -- 商品信息ID
            ,mrchd_price -- 单个商品价值
            ,cnsm_typ -- 消费类型 P-积分 C-现金 F-福利金 X-权益积分
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,undo_refund_flag -- 退货专用字段 0：未退货    2：已退货
            ,order_no -- 渠道方订单流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_points_mall_mrchd_detail_op(
            id -- 主键
            ,serial_num -- 订单主键
            ,mrchd_id -- 商品信息ID
            ,mrchd_price -- 单个商品价值
            ,cnsm_typ -- 消费类型 P-积分 C-现金 F-福利金 X-权益积分
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,undo_refund_flag -- 退货专用字段 0：未退货    2：已退货
            ,order_no -- 渠道方订单流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.serial_num -- 订单主键
    ,o.mrchd_id -- 商品信息ID
    ,o.mrchd_price -- 单个商品价值
    ,o.cnsm_typ -- 消费类型 P-积分 C-现金 F-福利金 X-权益积分
    ,o.physics_flag -- 物理标识 1-正常 2-删除
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.create_emp -- 创建人
    ,o.update_emp -- 更新人
    ,o.undo_refund_flag -- 退货专用字段 0：未退货    2：已退货
    ,o.order_no -- 渠道方订单流水
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
from ${iol_schema}.amss_points_mall_mrchd_detail_bk o
    left join ${iol_schema}.amss_points_mall_mrchd_detail_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_points_mall_mrchd_detail_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_points_mall_mrchd_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_points_mall_mrchd_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_points_mall_mrchd_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_points_mall_mrchd_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_points_mall_mrchd_detail exchange partition p_${batch_date} with table ${iol_schema}.amss_points_mall_mrchd_detail_cl;
alter table ${iol_schema}.amss_points_mall_mrchd_detail exchange partition p_20991231 with table ${iol_schema}.amss_points_mall_mrchd_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_points_mall_mrchd_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_points_mall_mrchd_detail_op purge;
drop table ${iol_schema}.amss_points_mall_mrchd_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_points_mall_mrchd_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_points_mall_mrchd_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
