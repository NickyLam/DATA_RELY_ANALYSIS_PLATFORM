/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_other_order_smooth_depo
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
create table ${iol_schema}.ibms_ttrd_other_order_smooth_depo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_other_order_smooth_depo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_other_order_smooth_depo_op purge;
drop table ${iol_schema}.ibms_ttrd_other_order_smooth_depo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_other_order_smooth_depo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_other_order_smooth_depo where 0=1;

create table ${iol_schema}.ibms_ttrd_other_order_smooth_depo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_other_order_smooth_depo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_other_order_smooth_depo_cl(
            id -- 自增主键
            ,ord_id -- 审批单号
            ,entity_type -- 非交易类型 214- 顺心存定期签约 215-顺心存定期解约
            ,acct_id -- 定期账号
            ,ext_cash_acctid -- 活期账号
            ,sign_beg_date -- 签约起始日
            ,sign_end_date -- 签约到期日
            ,repo_term -- 实际占款天数
            ,depo_term -- 定期期限
            ,in_rate -- 存款利率
            ,in_amount -- 存款金额
            ,advance_rate -- 提支利率
            ,overdue_rate -- 逾期利率
            ,accumulated_mode -- 滚存模式 1-单利 2-复利
            ,daycount -- 计息基准
            ,sign_type -- 签约状态 1-已签约 2- 已解约
            ,contract_number -- 合约号
            ,break_cause -- 解约原因 1-解约 2-提前支取
            ,break_date -- 解约日期
            ,memo -- 备注
            ,operator_user_id -- 发起人
            ,operator_org_id -- 发起机构
            ,operator_time -- 发起时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_other_order_smooth_depo_op(
            id -- 自增主键
            ,ord_id -- 审批单号
            ,entity_type -- 非交易类型 214- 顺心存定期签约 215-顺心存定期解约
            ,acct_id -- 定期账号
            ,ext_cash_acctid -- 活期账号
            ,sign_beg_date -- 签约起始日
            ,sign_end_date -- 签约到期日
            ,repo_term -- 实际占款天数
            ,depo_term -- 定期期限
            ,in_rate -- 存款利率
            ,in_amount -- 存款金额
            ,advance_rate -- 提支利率
            ,overdue_rate -- 逾期利率
            ,accumulated_mode -- 滚存模式 1-单利 2-复利
            ,daycount -- 计息基准
            ,sign_type -- 签约状态 1-已签约 2- 已解约
            ,contract_number -- 合约号
            ,break_cause -- 解约原因 1-解约 2-提前支取
            ,break_date -- 解约日期
            ,memo -- 备注
            ,operator_user_id -- 发起人
            ,operator_org_id -- 发起机构
            ,operator_time -- 发起时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 自增主键
    ,nvl(n.ord_id, o.ord_id) as ord_id -- 审批单号
    ,nvl(n.entity_type, o.entity_type) as entity_type -- 非交易类型 214- 顺心存定期签约 215-顺心存定期解约
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 定期账号
    ,nvl(n.ext_cash_acctid, o.ext_cash_acctid) as ext_cash_acctid -- 活期账号
    ,nvl(n.sign_beg_date, o.sign_beg_date) as sign_beg_date -- 签约起始日
    ,nvl(n.sign_end_date, o.sign_end_date) as sign_end_date -- 签约到期日
    ,nvl(n.repo_term, o.repo_term) as repo_term -- 实际占款天数
    ,nvl(n.depo_term, o.depo_term) as depo_term -- 定期期限
    ,nvl(n.in_rate, o.in_rate) as in_rate -- 存款利率
    ,nvl(n.in_amount, o.in_amount) as in_amount -- 存款金额
    ,nvl(n.advance_rate, o.advance_rate) as advance_rate -- 提支利率
    ,nvl(n.overdue_rate, o.overdue_rate) as overdue_rate -- 逾期利率
    ,nvl(n.accumulated_mode, o.accumulated_mode) as accumulated_mode -- 滚存模式 1-单利 2-复利
    ,nvl(n.daycount, o.daycount) as daycount -- 计息基准
    ,nvl(n.sign_type, o.sign_type) as sign_type -- 签约状态 1-已签约 2- 已解约
    ,nvl(n.contract_number, o.contract_number) as contract_number -- 合约号
    ,nvl(n.break_cause, o.break_cause) as break_cause -- 解约原因 1-解约 2-提前支取
    ,nvl(n.break_date, o.break_date) as break_date -- 解约日期
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.operator_user_id, o.operator_user_id) as operator_user_id -- 发起人
    ,nvl(n.operator_org_id, o.operator_org_id) as operator_org_id -- 发起机构
    ,nvl(n.operator_time, o.operator_time) as operator_time -- 发起时间
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
from (select * from ${iol_schema}.ibms_ttrd_other_order_smooth_depo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_other_order_smooth_depo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.ord_id <> n.ord_id
        or o.entity_type <> n.entity_type
        or o.acct_id <> n.acct_id
        or o.ext_cash_acctid <> n.ext_cash_acctid
        or o.sign_beg_date <> n.sign_beg_date
        or o.sign_end_date <> n.sign_end_date
        or o.repo_term <> n.repo_term
        or o.depo_term <> n.depo_term
        or o.in_rate <> n.in_rate
        or o.in_amount <> n.in_amount
        or o.advance_rate <> n.advance_rate
        or o.overdue_rate <> n.overdue_rate
        or o.accumulated_mode <> n.accumulated_mode
        or o.daycount <> n.daycount
        or o.sign_type <> n.sign_type
        or o.contract_number <> n.contract_number
        or o.break_cause <> n.break_cause
        or o.break_date <> n.break_date
        or o.memo <> n.memo
        or o.operator_user_id <> n.operator_user_id
        or o.operator_org_id <> n.operator_org_id
        or o.operator_time <> n.operator_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_other_order_smooth_depo_cl(
            id -- 自增主键
            ,ord_id -- 审批单号
            ,entity_type -- 非交易类型 214- 顺心存定期签约 215-顺心存定期解约
            ,acct_id -- 定期账号
            ,ext_cash_acctid -- 活期账号
            ,sign_beg_date -- 签约起始日
            ,sign_end_date -- 签约到期日
            ,repo_term -- 实际占款天数
            ,depo_term -- 定期期限
            ,in_rate -- 存款利率
            ,in_amount -- 存款金额
            ,advance_rate -- 提支利率
            ,overdue_rate -- 逾期利率
            ,accumulated_mode -- 滚存模式 1-单利 2-复利
            ,daycount -- 计息基准
            ,sign_type -- 签约状态 1-已签约 2- 已解约
            ,contract_number -- 合约号
            ,break_cause -- 解约原因 1-解约 2-提前支取
            ,break_date -- 解约日期
            ,memo -- 备注
            ,operator_user_id -- 发起人
            ,operator_org_id -- 发起机构
            ,operator_time -- 发起时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_other_order_smooth_depo_op(
            id -- 自增主键
            ,ord_id -- 审批单号
            ,entity_type -- 非交易类型 214- 顺心存定期签约 215-顺心存定期解约
            ,acct_id -- 定期账号
            ,ext_cash_acctid -- 活期账号
            ,sign_beg_date -- 签约起始日
            ,sign_end_date -- 签约到期日
            ,repo_term -- 实际占款天数
            ,depo_term -- 定期期限
            ,in_rate -- 存款利率
            ,in_amount -- 存款金额
            ,advance_rate -- 提支利率
            ,overdue_rate -- 逾期利率
            ,accumulated_mode -- 滚存模式 1-单利 2-复利
            ,daycount -- 计息基准
            ,sign_type -- 签约状态 1-已签约 2- 已解约
            ,contract_number -- 合约号
            ,break_cause -- 解约原因 1-解约 2-提前支取
            ,break_date -- 解约日期
            ,memo -- 备注
            ,operator_user_id -- 发起人
            ,operator_org_id -- 发起机构
            ,operator_time -- 发起时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 自增主键
    ,o.ord_id -- 审批单号
    ,o.entity_type -- 非交易类型 214- 顺心存定期签约 215-顺心存定期解约
    ,o.acct_id -- 定期账号
    ,o.ext_cash_acctid -- 活期账号
    ,o.sign_beg_date -- 签约起始日
    ,o.sign_end_date -- 签约到期日
    ,o.repo_term -- 实际占款天数
    ,o.depo_term -- 定期期限
    ,o.in_rate -- 存款利率
    ,o.in_amount -- 存款金额
    ,o.advance_rate -- 提支利率
    ,o.overdue_rate -- 逾期利率
    ,o.accumulated_mode -- 滚存模式 1-单利 2-复利
    ,o.daycount -- 计息基准
    ,o.sign_type -- 签约状态 1-已签约 2- 已解约
    ,o.contract_number -- 合约号
    ,o.break_cause -- 解约原因 1-解约 2-提前支取
    ,o.break_date -- 解约日期
    ,o.memo -- 备注
    ,o.operator_user_id -- 发起人
    ,o.operator_org_id -- 发起机构
    ,o.operator_time -- 发起时间
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
from ${iol_schema}.ibms_ttrd_other_order_smooth_depo_bk o
    left join ${iol_schema}.ibms_ttrd_other_order_smooth_depo_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_other_order_smooth_depo_cl d
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
--truncate table ${iol_schema}.ibms_ttrd_other_order_smooth_depo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_other_order_smooth_depo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_other_order_smooth_depo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_other_order_smooth_depo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_other_order_smooth_depo exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_other_order_smooth_depo_cl;
alter table ${iol_schema}.ibms_ttrd_other_order_smooth_depo exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_other_order_smooth_depo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_other_order_smooth_depo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_other_order_smooth_depo_op purge;
drop table ${iol_schema}.ibms_ttrd_other_order_smooth_depo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_other_order_smooth_depo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_other_order_smooth_depo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
