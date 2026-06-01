/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_acct_protocol_master
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
create table ${iol_schema}.ibms_ttrd_acct_protocol_master_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_acct_protocol_master
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_acct_protocol_master_op purge;
drop table ${iol_schema}.ibms_ttrd_acct_protocol_master_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acct_protocol_master_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_acct_protocol_master where 0=1;

create table ${iol_schema}.ibms_ttrd_acct_protocol_master_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_acct_protocol_master where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_acct_protocol_master_cl(
            id -- 主键
            ,accid -- 同业赢活期账户id
            ,settle_period -- 结息周期
            ,start_date -- 开始日期
            ,expire_date -- 到期日期
            ,early_end_date -- 提前结束日期
            ,amount -- 约期金额
            ,amount_rate -- 约期金额利率
            ,break_rate -- 约期违约利率
            ,current_rate -- 约期活期利率
            ,contract_no -- 合约号
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,operate -- 操作状态 add 新增  edit 修改
            ,ctrct_id -- 确认单编号
            ,first_payment_date -- 首次付息日
            ,is_monthly_mode -- 是否月均模式
            ,is_near_rate_mode -- 是否支持靠档模式
            ,stride_month_rate -- 跨月利率
            ,not_stride_month_rate -- 不跨月利率
            ,stride_month_remark -- 跨月说明
            ,not_stride_month_remark -- 不跨月说明
            ,fix_settle_period -- 约期结息频率
            ,end_date -- 协议结束日
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_acct_protocol_master_op(
            id -- 主键
            ,accid -- 同业赢活期账户id
            ,settle_period -- 结息周期
            ,start_date -- 开始日期
            ,expire_date -- 到期日期
            ,early_end_date -- 提前结束日期
            ,amount -- 约期金额
            ,amount_rate -- 约期金额利率
            ,break_rate -- 约期违约利率
            ,current_rate -- 约期活期利率
            ,contract_no -- 合约号
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,operate -- 操作状态 add 新增  edit 修改
            ,ctrct_id -- 确认单编号
            ,first_payment_date -- 首次付息日
            ,is_monthly_mode -- 是否月均模式
            ,is_near_rate_mode -- 是否支持靠档模式
            ,stride_month_rate -- 跨月利率
            ,not_stride_month_rate -- 不跨月利率
            ,stride_month_remark -- 跨月说明
            ,not_stride_month_remark -- 不跨月说明
            ,fix_settle_period -- 约期结息频率
            ,end_date -- 协议结束日
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.accid, o.accid) as accid -- 同业赢活期账户id
    ,nvl(n.settle_period, o.settle_period) as settle_period -- 结息周期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 到期日期
    ,nvl(n.early_end_date, o.early_end_date) as early_end_date -- 提前结束日期
    ,nvl(n.amount, o.amount) as amount -- 约期金额
    ,nvl(n.amount_rate, o.amount_rate) as amount_rate -- 约期金额利率
    ,nvl(n.break_rate, o.break_rate) as break_rate -- 约期违约利率
    ,nvl(n.current_rate, o.current_rate) as current_rate -- 约期活期利率
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合约号
    ,nvl(n.usable_flag, o.usable_flag) as usable_flag -- 是否已生效：1： 正常 0： 新增
    ,nvl(n.operate, o.operate) as operate -- 操作状态 add 新增  edit 修改
    ,nvl(n.ctrct_id, o.ctrct_id) as ctrct_id -- 确认单编号
    ,nvl(n.first_payment_date, o.first_payment_date) as first_payment_date -- 首次付息日
    ,nvl(n.is_monthly_mode, o.is_monthly_mode) as is_monthly_mode -- 是否月均模式
    ,nvl(n.is_near_rate_mode, o.is_near_rate_mode) as is_near_rate_mode -- 是否支持靠档模式
    ,nvl(n.stride_month_rate, o.stride_month_rate) as stride_month_rate -- 跨月利率
    ,nvl(n.not_stride_month_rate, o.not_stride_month_rate) as not_stride_month_rate -- 不跨月利率
    ,nvl(n.stride_month_remark, o.stride_month_remark) as stride_month_remark -- 跨月说明
    ,nvl(n.not_stride_month_remark, o.not_stride_month_remark) as not_stride_month_remark -- 不跨月说明
    ,nvl(n.fix_settle_period, o.fix_settle_period) as fix_settle_period -- 约期结息频率
    ,nvl(n.end_date, o.end_date) as end_date -- 协议结束日
    ,nvl(n.remark, o.remark) as remark -- 备注
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
from (select * from ${iol_schema}.ibms_ttrd_acct_protocol_master_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_acct_protocol_master where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.accid <> n.accid
        or o.settle_period <> n.settle_period
        or o.start_date <> n.start_date
        or o.expire_date <> n.expire_date
        or o.early_end_date <> n.early_end_date
        or o.amount <> n.amount
        or o.amount_rate <> n.amount_rate
        or o.break_rate <> n.break_rate
        or o.current_rate <> n.current_rate
        or o.contract_no <> n.contract_no
        or o.usable_flag <> n.usable_flag
        or o.operate <> n.operate
        or o.ctrct_id <> n.ctrct_id
        or o.first_payment_date <> n.first_payment_date
        or o.is_monthly_mode <> n.is_monthly_mode
        or o.is_near_rate_mode <> n.is_near_rate_mode
        or o.stride_month_rate <> n.stride_month_rate
        or o.not_stride_month_rate <> n.not_stride_month_rate
        or o.stride_month_remark <> n.stride_month_remark
        or o.not_stride_month_remark <> n.not_stride_month_remark
        or o.fix_settle_period <> n.fix_settle_period
        or o.end_date <> n.end_date
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_acct_protocol_master_cl(
            id -- 主键
            ,accid -- 同业赢活期账户id
            ,settle_period -- 结息周期
            ,start_date -- 开始日期
            ,expire_date -- 到期日期
            ,early_end_date -- 提前结束日期
            ,amount -- 约期金额
            ,amount_rate -- 约期金额利率
            ,break_rate -- 约期违约利率
            ,current_rate -- 约期活期利率
            ,contract_no -- 合约号
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,operate -- 操作状态 add 新增  edit 修改
            ,ctrct_id -- 确认单编号
            ,first_payment_date -- 首次付息日
            ,is_monthly_mode -- 是否月均模式
            ,is_near_rate_mode -- 是否支持靠档模式
            ,stride_month_rate -- 跨月利率
            ,not_stride_month_rate -- 不跨月利率
            ,stride_month_remark -- 跨月说明
            ,not_stride_month_remark -- 不跨月说明
            ,fix_settle_period -- 约期结息频率
            ,end_date -- 协议结束日
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_acct_protocol_master_op(
            id -- 主键
            ,accid -- 同业赢活期账户id
            ,settle_period -- 结息周期
            ,start_date -- 开始日期
            ,expire_date -- 到期日期
            ,early_end_date -- 提前结束日期
            ,amount -- 约期金额
            ,amount_rate -- 约期金额利率
            ,break_rate -- 约期违约利率
            ,current_rate -- 约期活期利率
            ,contract_no -- 合约号
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,operate -- 操作状态 add 新增  edit 修改
            ,ctrct_id -- 确认单编号
            ,first_payment_date -- 首次付息日
            ,is_monthly_mode -- 是否月均模式
            ,is_near_rate_mode -- 是否支持靠档模式
            ,stride_month_rate -- 跨月利率
            ,not_stride_month_rate -- 不跨月利率
            ,stride_month_remark -- 跨月说明
            ,not_stride_month_remark -- 不跨月说明
            ,fix_settle_period -- 约期结息频率
            ,end_date -- 协议结束日
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.accid -- 同业赢活期账户id
    ,o.settle_period -- 结息周期
    ,o.start_date -- 开始日期
    ,o.expire_date -- 到期日期
    ,o.early_end_date -- 提前结束日期
    ,o.amount -- 约期金额
    ,o.amount_rate -- 约期金额利率
    ,o.break_rate -- 约期违约利率
    ,o.current_rate -- 约期活期利率
    ,o.contract_no -- 合约号
    ,o.usable_flag -- 是否已生效：1： 正常 0： 新增
    ,o.operate -- 操作状态 add 新增  edit 修改
    ,o.ctrct_id -- 确认单编号
    ,o.first_payment_date -- 首次付息日
    ,o.is_monthly_mode -- 是否月均模式
    ,o.is_near_rate_mode -- 是否支持靠档模式
    ,o.stride_month_rate -- 跨月利率
    ,o.not_stride_month_rate -- 不跨月利率
    ,o.stride_month_remark -- 跨月说明
    ,o.not_stride_month_remark -- 不跨月说明
    ,o.fix_settle_period -- 约期结息频率
    ,o.end_date -- 协议结束日
    ,o.remark -- 备注
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
from ${iol_schema}.ibms_ttrd_acct_protocol_master_bk o
    left join ${iol_schema}.ibms_ttrd_acct_protocol_master_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_acct_protocol_master_cl d
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
--truncate table ${iol_schema}.ibms_ttrd_acct_protocol_master;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_acct_protocol_master') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_acct_protocol_master drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_acct_protocol_master add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_acct_protocol_master exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_acct_protocol_master_cl;
alter table ${iol_schema}.ibms_ttrd_acct_protocol_master exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_acct_protocol_master_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_acct_protocol_master to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_acct_protocol_master_op purge;
drop table ${iol_schema}.ibms_ttrd_acct_protocol_master_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_acct_protocol_master_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_acct_protocol_master',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
