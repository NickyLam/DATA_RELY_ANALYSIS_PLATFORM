/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_union_pay_advance_repayment_result
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
create table ${iol_schema}.amss_union_pay_advance_repayment_result_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_union_pay_advance_repayment_result
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_union_pay_advance_repayment_result_op purge;
drop table ${iol_schema}.amss_union_pay_advance_repayment_result_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_union_pay_advance_repayment_result_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_union_pay_advance_repayment_result where 0=1;

create table ${iol_schema}.amss_union_pay_advance_repayment_result_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_union_pay_advance_repayment_result where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_union_pay_advance_repayment_result_cl(
            id -- 主键
            ,trade_date -- 交易日期
            ,fund_id -- 商户编号
            ,fund_name -- 商户名称
            ,org_id -- 所属分行机构号
            ,org_name -- 所属分行机构名称
            ,mer_limit -- 商户额度
            ,sucess_amt -- 当天成功金额
            ,un_amt -- 当天未明金额
            ,balance_limt -- 剩余额度
            ,repayment_amt -- 已还款金额
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,clean_state -- 清分状态：0-未清分 1-清分中 2-已清分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_union_pay_advance_repayment_result_op(
            id -- 主键
            ,trade_date -- 交易日期
            ,fund_id -- 商户编号
            ,fund_name -- 商户名称
            ,org_id -- 所属分行机构号
            ,org_name -- 所属分行机构名称
            ,mer_limit -- 商户额度
            ,sucess_amt -- 当天成功金额
            ,un_amt -- 当天未明金额
            ,balance_limt -- 剩余额度
            ,repayment_amt -- 已还款金额
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,clean_state -- 清分状态：0-未清分 1-清分中 2-已清分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 交易日期
    ,nvl(n.fund_id, o.fund_id) as fund_id -- 商户编号
    ,nvl(n.fund_name, o.fund_name) as fund_name -- 商户名称
    ,nvl(n.org_id, o.org_id) as org_id -- 所属分行机构号
    ,nvl(n.org_name, o.org_name) as org_name -- 所属分行机构名称
    ,nvl(n.mer_limit, o.mer_limit) as mer_limit -- 商户额度
    ,nvl(n.sucess_amt, o.sucess_amt) as sucess_amt -- 当天成功金额
    ,nvl(n.un_amt, o.un_amt) as un_amt -- 当天未明金额
    ,nvl(n.balance_limt, o.balance_limt) as balance_limt -- 剩余额度
    ,nvl(n.repayment_amt, o.repayment_amt) as repayment_amt -- 已还款金额
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识 1-正常 2-删除
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 更新人
    ,nvl(n.clean_state, o.clean_state) as clean_state -- 清分状态：0-未清分 1-清分中 2-已清分
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
from (select * from ${iol_schema}.amss_union_pay_advance_repayment_result_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_union_pay_advance_repayment_result where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.trade_date <> n.trade_date
        or o.fund_id <> n.fund_id
        or o.fund_name <> n.fund_name
        or o.org_id <> n.org_id
        or o.org_name <> n.org_name
        or o.mer_limit <> n.mer_limit
        or o.sucess_amt <> n.sucess_amt
        or o.un_amt <> n.un_amt
        or o.balance_limt <> n.balance_limt
        or o.repayment_amt <> n.repayment_amt
        or o.physics_flag <> n.physics_flag
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.create_emp <> n.create_emp
        or o.update_emp <> n.update_emp
        or o.clean_state <> n.clean_state
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_union_pay_advance_repayment_result_cl(
            id -- 主键
            ,trade_date -- 交易日期
            ,fund_id -- 商户编号
            ,fund_name -- 商户名称
            ,org_id -- 所属分行机构号
            ,org_name -- 所属分行机构名称
            ,mer_limit -- 商户额度
            ,sucess_amt -- 当天成功金额
            ,un_amt -- 当天未明金额
            ,balance_limt -- 剩余额度
            ,repayment_amt -- 已还款金额
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,clean_state -- 清分状态：0-未清分 1-清分中 2-已清分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_union_pay_advance_repayment_result_op(
            id -- 主键
            ,trade_date -- 交易日期
            ,fund_id -- 商户编号
            ,fund_name -- 商户名称
            ,org_id -- 所属分行机构号
            ,org_name -- 所属分行机构名称
            ,mer_limit -- 商户额度
            ,sucess_amt -- 当天成功金额
            ,un_amt -- 当天未明金额
            ,balance_limt -- 剩余额度
            ,repayment_amt -- 已还款金额
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,clean_state -- 清分状态：0-未清分 1-清分中 2-已清分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.trade_date -- 交易日期
    ,o.fund_id -- 商户编号
    ,o.fund_name -- 商户名称
    ,o.org_id -- 所属分行机构号
    ,o.org_name -- 所属分行机构名称
    ,o.mer_limit -- 商户额度
    ,o.sucess_amt -- 当天成功金额
    ,o.un_amt -- 当天未明金额
    ,o.balance_limt -- 剩余额度
    ,o.repayment_amt -- 已还款金额
    ,o.physics_flag -- 物理标识 1-正常 2-删除
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.create_emp -- 创建人
    ,o.update_emp -- 更新人
    ,o.clean_state -- 清分状态：0-未清分 1-清分中 2-已清分
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
from ${iol_schema}.amss_union_pay_advance_repayment_result_bk o
    left join ${iol_schema}.amss_union_pay_advance_repayment_result_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_union_pay_advance_repayment_result_cl d
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
--truncate table ${iol_schema}.amss_union_pay_advance_repayment_result;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_union_pay_advance_repayment_result') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_union_pay_advance_repayment_result drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_union_pay_advance_repayment_result add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_union_pay_advance_repayment_result exchange partition p_${batch_date} with table ${iol_schema}.amss_union_pay_advance_repayment_result_cl;
alter table ${iol_schema}.amss_union_pay_advance_repayment_result exchange partition p_20991231 with table ${iol_schema}.amss_union_pay_advance_repayment_result_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_union_pay_advance_repayment_result to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_union_pay_advance_repayment_result_op purge;
drop table ${iol_schema}.amss_union_pay_advance_repayment_result_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_union_pay_advance_repayment_result_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_union_pay_advance_repayment_result',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
