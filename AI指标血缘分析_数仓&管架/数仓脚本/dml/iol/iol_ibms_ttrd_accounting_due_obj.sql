/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_accounting_due_obj
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
create table ${iol_schema}.ibms_ttrd_accounting_due_obj_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_accounting_due_obj
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_accounting_due_obj_op purge;
drop table ${iol_schema}.ibms_ttrd_accounting_due_obj_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_accounting_due_obj_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_accounting_due_obj where 0=1;

create table ${iol_schema}.ibms_ttrd_accounting_due_obj_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_accounting_due_obj where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_accounting_due_obj_cl(
            obj_id -- 对象id
            ,tsk_id -- 任务id
            ,beg_date -- 开始日期
            ,end_date -- 结束日期
            ,prmr_inst_id -- 主指令id
            ,currency -- 币种
            ,pay_amount -- 支付余额
            ,receive_amount -- 收取余额
            ,open_time -- 开仓时间
            ,update_time -- 更新时间
            ,first_prmr_inst_id -- 首次挂账主指令号
            ,inst_type -- 存储维度的指令类型
            ,inst_ext_acct_id -- 外部账户
            ,inst_int_acct_id -- 内部账户
            ,inst_trade_grp_id -- 组合号
            ,inst_i_code -- 金融工具代码
            ,inst_a_type -- 金融工具类型
            ,inst_m_type -- 金融工具市场
            ,state -- 挂账状态
            ,pay_cp -- 支付成本
            ,receive_cp -- 收取成本
            ,pay_ai -- 支付利息
            ,receive_ai -- 收取利息
            ,pay_fee -- 支付费用
            ,receive_fee -- 收取费用
            ,pay_cash -- 支付资金
            ,receive_cash -- 收取资金
            ,inst_custom_dim1 -- 扩展维度1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_accounting_due_obj_op(
            obj_id -- 对象id
            ,tsk_id -- 任务id
            ,beg_date -- 开始日期
            ,end_date -- 结束日期
            ,prmr_inst_id -- 主指令id
            ,currency -- 币种
            ,pay_amount -- 支付余额
            ,receive_amount -- 收取余额
            ,open_time -- 开仓时间
            ,update_time -- 更新时间
            ,first_prmr_inst_id -- 首次挂账主指令号
            ,inst_type -- 存储维度的指令类型
            ,inst_ext_acct_id -- 外部账户
            ,inst_int_acct_id -- 内部账户
            ,inst_trade_grp_id -- 组合号
            ,inst_i_code -- 金融工具代码
            ,inst_a_type -- 金融工具类型
            ,inst_m_type -- 金融工具市场
            ,state -- 挂账状态
            ,pay_cp -- 支付成本
            ,receive_cp -- 收取成本
            ,pay_ai -- 支付利息
            ,receive_ai -- 收取利息
            ,pay_fee -- 支付费用
            ,receive_fee -- 收取费用
            ,pay_cash -- 支付资金
            ,receive_cash -- 收取资金
            ,inst_custom_dim1 -- 扩展维度1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.obj_id, o.obj_id) as obj_id -- 对象id
    ,nvl(n.tsk_id, o.tsk_id) as tsk_id -- 任务id
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 开始日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.prmr_inst_id, o.prmr_inst_id) as prmr_inst_id -- 主指令id
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.pay_amount, o.pay_amount) as pay_amount -- 支付余额
    ,nvl(n.receive_amount, o.receive_amount) as receive_amount -- 收取余额
    ,nvl(n.open_time, o.open_time) as open_time -- 开仓时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.first_prmr_inst_id, o.first_prmr_inst_id) as first_prmr_inst_id -- 首次挂账主指令号
    ,nvl(n.inst_type, o.inst_type) as inst_type -- 存储维度的指令类型
    ,nvl(n.inst_ext_acct_id, o.inst_ext_acct_id) as inst_ext_acct_id -- 外部账户
    ,nvl(n.inst_int_acct_id, o.inst_int_acct_id) as inst_int_acct_id -- 内部账户
    ,nvl(n.inst_trade_grp_id, o.inst_trade_grp_id) as inst_trade_grp_id -- 组合号
    ,nvl(n.inst_i_code, o.inst_i_code) as inst_i_code -- 金融工具代码
    ,nvl(n.inst_a_type, o.inst_a_type) as inst_a_type -- 金融工具类型
    ,nvl(n.inst_m_type, o.inst_m_type) as inst_m_type -- 金融工具市场
    ,nvl(n.state, o.state) as state -- 挂账状态
    ,nvl(n.pay_cp, o.pay_cp) as pay_cp -- 支付成本
    ,nvl(n.receive_cp, o.receive_cp) as receive_cp -- 收取成本
    ,nvl(n.pay_ai, o.pay_ai) as pay_ai -- 支付利息
    ,nvl(n.receive_ai, o.receive_ai) as receive_ai -- 收取利息
    ,nvl(n.pay_fee, o.pay_fee) as pay_fee -- 支付费用
    ,nvl(n.receive_fee, o.receive_fee) as receive_fee -- 收取费用
    ,nvl(n.pay_cash, o.pay_cash) as pay_cash -- 支付资金
    ,nvl(n.receive_cash, o.receive_cash) as receive_cash -- 收取资金
    ,nvl(n.inst_custom_dim1, o.inst_custom_dim1) as inst_custom_dim1 -- 扩展维度1
    ,case when
            n.obj_id is null
            and n.tsk_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.obj_id is null
            and n.tsk_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.obj_id is null
            and n.tsk_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_accounting_due_obj_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_accounting_due_obj where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.obj_id = n.obj_id
            and o.tsk_id = n.tsk_id
where (
        o.obj_id is null
        and o.tsk_id is null
    )
    or (
        n.obj_id is null
        and n.tsk_id is null
    )
    or (
        o.beg_date <> n.beg_date
        or o.end_date <> n.end_date
        or o.prmr_inst_id <> n.prmr_inst_id
        or o.currency <> n.currency
        or o.pay_amount <> n.pay_amount
        or o.receive_amount <> n.receive_amount
        or o.open_time <> n.open_time
        or o.update_time <> n.update_time
        or o.first_prmr_inst_id <> n.first_prmr_inst_id
        or o.inst_type <> n.inst_type
        or o.inst_ext_acct_id <> n.inst_ext_acct_id
        or o.inst_int_acct_id <> n.inst_int_acct_id
        or o.inst_trade_grp_id <> n.inst_trade_grp_id
        or o.inst_i_code <> n.inst_i_code
        or o.inst_a_type <> n.inst_a_type
        or o.inst_m_type <> n.inst_m_type
        or o.state <> n.state
        or o.pay_cp <> n.pay_cp
        or o.receive_cp <> n.receive_cp
        or o.pay_ai <> n.pay_ai
        or o.receive_ai <> n.receive_ai
        or o.pay_fee <> n.pay_fee
        or o.receive_fee <> n.receive_fee
        or o.pay_cash <> n.pay_cash
        or o.receive_cash <> n.receive_cash
        or o.inst_custom_dim1 <> n.inst_custom_dim1
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_accounting_due_obj_cl(
            obj_id -- 对象id
            ,tsk_id -- 任务id
            ,beg_date -- 开始日期
            ,end_date -- 结束日期
            ,prmr_inst_id -- 主指令id
            ,currency -- 币种
            ,pay_amount -- 支付余额
            ,receive_amount -- 收取余额
            ,open_time -- 开仓时间
            ,update_time -- 更新时间
            ,first_prmr_inst_id -- 首次挂账主指令号
            ,inst_type -- 存储维度的指令类型
            ,inst_ext_acct_id -- 外部账户
            ,inst_int_acct_id -- 内部账户
            ,inst_trade_grp_id -- 组合号
            ,inst_i_code -- 金融工具代码
            ,inst_a_type -- 金融工具类型
            ,inst_m_type -- 金融工具市场
            ,state -- 挂账状态
            ,pay_cp -- 支付成本
            ,receive_cp -- 收取成本
            ,pay_ai -- 支付利息
            ,receive_ai -- 收取利息
            ,pay_fee -- 支付费用
            ,receive_fee -- 收取费用
            ,pay_cash -- 支付资金
            ,receive_cash -- 收取资金
            ,inst_custom_dim1 -- 扩展维度1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_accounting_due_obj_op(
            obj_id -- 对象id
            ,tsk_id -- 任务id
            ,beg_date -- 开始日期
            ,end_date -- 结束日期
            ,prmr_inst_id -- 主指令id
            ,currency -- 币种
            ,pay_amount -- 支付余额
            ,receive_amount -- 收取余额
            ,open_time -- 开仓时间
            ,update_time -- 更新时间
            ,first_prmr_inst_id -- 首次挂账主指令号
            ,inst_type -- 存储维度的指令类型
            ,inst_ext_acct_id -- 外部账户
            ,inst_int_acct_id -- 内部账户
            ,inst_trade_grp_id -- 组合号
            ,inst_i_code -- 金融工具代码
            ,inst_a_type -- 金融工具类型
            ,inst_m_type -- 金融工具市场
            ,state -- 挂账状态
            ,pay_cp -- 支付成本
            ,receive_cp -- 收取成本
            ,pay_ai -- 支付利息
            ,receive_ai -- 收取利息
            ,pay_fee -- 支付费用
            ,receive_fee -- 收取费用
            ,pay_cash -- 支付资金
            ,receive_cash -- 收取资金
            ,inst_custom_dim1 -- 扩展维度1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.obj_id -- 对象id
    ,o.tsk_id -- 任务id
    ,o.beg_date -- 开始日期
    ,o.end_date -- 结束日期
    ,o.prmr_inst_id -- 主指令id
    ,o.currency -- 币种
    ,o.pay_amount -- 支付余额
    ,o.receive_amount -- 收取余额
    ,o.open_time -- 开仓时间
    ,o.update_time -- 更新时间
    ,o.first_prmr_inst_id -- 首次挂账主指令号
    ,o.inst_type -- 存储维度的指令类型
    ,o.inst_ext_acct_id -- 外部账户
    ,o.inst_int_acct_id -- 内部账户
    ,o.inst_trade_grp_id -- 组合号
    ,o.inst_i_code -- 金融工具代码
    ,o.inst_a_type -- 金融工具类型
    ,o.inst_m_type -- 金融工具市场
    ,o.state -- 挂账状态
    ,o.pay_cp -- 支付成本
    ,o.receive_cp -- 收取成本
    ,o.pay_ai -- 支付利息
    ,o.receive_ai -- 收取利息
    ,o.pay_fee -- 支付费用
    ,o.receive_fee -- 收取费用
    ,o.pay_cash -- 支付资金
    ,o.receive_cash -- 收取资金
    ,o.inst_custom_dim1 -- 扩展维度1
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
from ${iol_schema}.ibms_ttrd_accounting_due_obj_bk o
    left join ${iol_schema}.ibms_ttrd_accounting_due_obj_op n
        on
            o.obj_id = n.obj_id
            and o.tsk_id = n.tsk_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_accounting_due_obj_cl d
        on
            o.obj_id = d.obj_id
            and o.tsk_id = d.tsk_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_accounting_due_obj;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_accounting_due_obj') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_accounting_due_obj drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_accounting_due_obj add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_accounting_due_obj exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_accounting_due_obj_cl;
alter table ${iol_schema}.ibms_ttrd_accounting_due_obj exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_accounting_due_obj_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_accounting_due_obj to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_accounting_due_obj_op purge;
drop table ${iol_schema}.ibms_ttrd_accounting_due_obj_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_accounting_due_obj_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_accounting_due_obj',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
