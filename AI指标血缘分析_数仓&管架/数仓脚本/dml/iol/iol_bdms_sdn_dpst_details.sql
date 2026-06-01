/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_sdn_dpst_details
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
create table ${iol_schema}.bdms_sdn_dpst_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_sdn_dpst_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_sdn_dpst_details_op purge;
drop table ${iol_schema}.bdms_sdn_dpst_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_sdn_dpst_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_sdn_dpst_details where 0=1;

create table ${iol_schema}.bdms_sdn_dpst_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_sdn_dpst_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_sdn_dpst_details_cl(
            id -- ID
            ,dpst_apply_id -- 申请单表ID
            ,apply_id -- 存托申请单编号
            ,draft_number -- 票号
            ,bp_no -- 票据包编号
            ,bp_range -- 票据区间
            ,draft_amount -- 票据金额
            ,maturity_date -- 到期日
            ,pay_interest -- 应付利息
            ,settle_amount -- 结算金额
            ,return_date -- 退票日期
            ,valid_flag -- 有效标识： 0 否 1 是
            ,wthd_status -- 退票状态： 00 未退票 01 主动退票 02 通知退票
            ,tenor_day -- 剩余期限
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,standard_amt -- 标准金额
            ,create_time -- 鍒涘缓鏃堕棿
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_sdn_dpst_details_op(
            id -- ID
            ,dpst_apply_id -- 申请单表ID
            ,apply_id -- 存托申请单编号
            ,draft_number -- 票号
            ,bp_no -- 票据包编号
            ,bp_range -- 票据区间
            ,draft_amount -- 票据金额
            ,maturity_date -- 到期日
            ,pay_interest -- 应付利息
            ,settle_amount -- 结算金额
            ,return_date -- 退票日期
            ,valid_flag -- 有效标识： 0 否 1 是
            ,wthd_status -- 退票状态： 00 未退票 01 主动退票 02 通知退票
            ,tenor_day -- 剩余期限
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,standard_amt -- 标准金额
            ,create_time -- 鍒涘缓鏃堕棿
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.dpst_apply_id, o.dpst_apply_id) as dpst_apply_id -- 申请单表ID
    ,nvl(n.apply_id, o.apply_id) as apply_id -- 存托申请单编号
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票号
    ,nvl(n.bp_no, o.bp_no) as bp_no -- 票据包编号
    ,nvl(n.bp_range, o.bp_range) as bp_range -- 票据区间
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票据金额
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.settle_amount, o.settle_amount) as settle_amount -- 结算金额
    ,nvl(n.return_date, o.return_date) as return_date -- 退票日期
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 有效标识： 0 否 1 是
    ,nvl(n.wthd_status, o.wthd_status) as wthd_status -- 退票状态： 00 未退票 01 主动退票 02 通知退票
    ,nvl(n.tenor_day, o.tenor_day) as tenor_day -- 剩余期限
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段2
    ,nvl(n.standard_amt, o.standard_amt) as standard_amt -- 标准金额
    ,nvl(n.create_time, o.create_time) as create_time -- 鍒涘缓鏃堕棿
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
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
from (select * from ${iol_schema}.bdms_sdn_dpst_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_sdn_dpst_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.dpst_apply_id <> n.dpst_apply_id
        or o.apply_id <> n.apply_id
        or o.draft_number <> n.draft_number
        or o.bp_no <> n.bp_no
        or o.bp_range <> n.bp_range
        or o.draft_amount <> n.draft_amount
        or o.maturity_date <> n.maturity_date
        or o.pay_interest <> n.pay_interest
        or o.settle_amount <> n.settle_amount
        or o.return_date <> n.return_date
        or o.valid_flag <> n.valid_flag
        or o.wthd_status <> n.wthd_status
        or o.tenor_day <> n.tenor_day
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.standard_amt <> n.standard_amt
        or o.create_time <> n.create_time
        or o.create_by <> n.create_by
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_sdn_dpst_details_cl(
            id -- ID
            ,dpst_apply_id -- 申请单表ID
            ,apply_id -- 存托申请单编号
            ,draft_number -- 票号
            ,bp_no -- 票据包编号
            ,bp_range -- 票据区间
            ,draft_amount -- 票据金额
            ,maturity_date -- 到期日
            ,pay_interest -- 应付利息
            ,settle_amount -- 结算金额
            ,return_date -- 退票日期
            ,valid_flag -- 有效标识： 0 否 1 是
            ,wthd_status -- 退票状态： 00 未退票 01 主动退票 02 通知退票
            ,tenor_day -- 剩余期限
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,standard_amt -- 标准金额
            ,create_time -- 鍒涘缓鏃堕棿
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_sdn_dpst_details_op(
            id -- ID
            ,dpst_apply_id -- 申请单表ID
            ,apply_id -- 存托申请单编号
            ,draft_number -- 票号
            ,bp_no -- 票据包编号
            ,bp_range -- 票据区间
            ,draft_amount -- 票据金额
            ,maturity_date -- 到期日
            ,pay_interest -- 应付利息
            ,settle_amount -- 结算金额
            ,return_date -- 退票日期
            ,valid_flag -- 有效标识： 0 否 1 是
            ,wthd_status -- 退票状态： 00 未退票 01 主动退票 02 通知退票
            ,tenor_day -- 剩余期限
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,standard_amt -- 标准金额
            ,create_time -- 鍒涘缓鏃堕棿
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.dpst_apply_id -- 申请单表ID
    ,o.apply_id -- 存托申请单编号
    ,o.draft_number -- 票号
    ,o.bp_no -- 票据包编号
    ,o.bp_range -- 票据区间
    ,o.draft_amount -- 票据金额
    ,o.maturity_date -- 到期日
    ,o.pay_interest -- 应付利息
    ,o.settle_amount -- 结算金额
    ,o.return_date -- 退票日期
    ,o.valid_flag -- 有效标识： 0 否 1 是
    ,o.wthd_status -- 退票状态： 00 未退票 01 主动退票 02 通知退票
    ,o.tenor_day -- 剩余期限
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
    ,o.standard_amt -- 标准金额
    ,o.create_time -- 鍒涘缓鏃堕棿
    ,o.create_by -- 创建人
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
from ${iol_schema}.bdms_sdn_dpst_details_bk o
    left join ${iol_schema}.bdms_sdn_dpst_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_sdn_dpst_details_cl d
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
--truncate table ${iol_schema}.bdms_sdn_dpst_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_sdn_dpst_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_sdn_dpst_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_sdn_dpst_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_sdn_dpst_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_sdn_dpst_details_cl;
alter table ${iol_schema}.bdms_sdn_dpst_details exchange partition p_20991231 with table ${iol_schema}.bdms_sdn_dpst_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_sdn_dpst_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_sdn_dpst_details_op purge;
drop table ${iol_schema}.bdms_sdn_dpst_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_sdn_dpst_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_sdn_dpst_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
