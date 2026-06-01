/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_fee_int_detail
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
create table ${iol_schema}.ncbs_rb_fee_int_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_fee_int_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_fee_int_detail_op purge;
drop table ${iol_schema}.ncbs_rb_fee_int_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_fee_int_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_fee_int_detail where 0=1;

create table ${iol_schema}.ncbs_rb_fee_int_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_fee_int_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_fee_int_detail_cl(
            fee_int_no -- 费用计提编号
            ,int_amt -- 利息金额
            ,start_accrual_date -- 开始计提日期
            ,end_accrual_date -- 结束计提日期
            ,freq_type -- 频率
            ,ext_trade_no -- 原业务编号
            ,fee_type -- 费率类型
            ,status -- 状态
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_diff -- 计提金额差额
            ,user_id -- 交易柜员编号
            ,auth_user_id -- 授权柜员
            ,tran_branch -- 核心交易机构编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,tran_date -- 交易日期
            ,write_off_int_amt -- 核销利息
            ,recalc_start_date -- 利息重算起始日
            ,accr_date -- 计提日期
            ,next_accr_date -- 下一计提日期
            ,narrative -- 摘要
            ,narrative_code -- 摘要码
            ,int_accr -- 计提利息
            ,recalc_int_amt -- 重算利息总金额
            ,reference -- 交易参考号
            ,ccy -- 币种
            ,oth_client_name -- 对手客户名称
            ,acct_exec_name -- 客户经理姓名
            ,acct_exec -- 银行客户经理编号
            ,oth_client_no -- 对手客户
            ,oth_business_no -- 对手业务编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_fee_int_detail_op(
            fee_int_no -- 费用计提编号
            ,int_amt -- 利息金额
            ,start_accrual_date -- 开始计提日期
            ,end_accrual_date -- 结束计提日期
            ,freq_type -- 频率
            ,ext_trade_no -- 原业务编号
            ,fee_type -- 费率类型
            ,status -- 状态
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_diff -- 计提金额差额
            ,user_id -- 交易柜员编号
            ,auth_user_id -- 授权柜员
            ,tran_branch -- 核心交易机构编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,tran_date -- 交易日期
            ,write_off_int_amt -- 核销利息
            ,recalc_start_date -- 利息重算起始日
            ,accr_date -- 计提日期
            ,next_accr_date -- 下一计提日期
            ,narrative -- 摘要
            ,narrative_code -- 摘要码
            ,int_accr -- 计提利息
            ,recalc_int_amt -- 重算利息总金额
            ,reference -- 交易参考号
            ,ccy -- 币种
            ,oth_client_name -- 对手客户名称
            ,acct_exec_name -- 客户经理姓名
            ,acct_exec -- 银行客户经理编号
            ,oth_client_no -- 对手客户
            ,oth_business_no -- 对手业务编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fee_int_no, o.fee_int_no) as fee_int_no -- 费用计提编号
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息金额
    ,nvl(n.start_accrual_date, o.start_accrual_date) as start_accrual_date -- 开始计提日期
    ,nvl(n.end_accrual_date, o.end_accrual_date) as end_accrual_date -- 结束计提日期
    ,nvl(n.freq_type, o.freq_type) as freq_type -- 频率
    ,nvl(n.ext_trade_no, o.ext_trade_no) as ext_trade_no -- 原业务编号
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费率类型
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.int_accrued, o.int_accrued) as int_accrued -- 累计计提
    ,nvl(n.int_accrued_calc_ctd, o.int_accrued_calc_ctd) as int_accrued_calc_ctd -- 计提日计提实际金额
    ,nvl(n.int_accrued_diff, o.int_accrued_diff) as int_accrued_diff -- 计提金额差额
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.write_off_int_amt, o.write_off_int_amt) as write_off_int_amt -- 核销利息
    ,nvl(n.recalc_start_date, o.recalc_start_date) as recalc_start_date -- 利息重算起始日
    ,nvl(n.accr_date, o.accr_date) as accr_date -- 计提日期
    ,nvl(n.next_accr_date, o.next_accr_date) as next_accr_date -- 下一计提日期
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.narrative_code, o.narrative_code) as narrative_code -- 摘要码
    ,nvl(n.int_accr, o.int_accr) as int_accr -- 计提利息
    ,nvl(n.recalc_int_amt, o.recalc_int_amt) as recalc_int_amt -- 重算利息总金额
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.oth_client_name, o.oth_client_name) as oth_client_name -- 对手客户名称
    ,nvl(n.acct_exec_name, o.acct_exec_name) as acct_exec_name -- 客户经理姓名
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理编号
    ,nvl(n.oth_client_no, o.oth_client_no) as oth_client_no -- 对手客户
    ,nvl(n.oth_business_no, o.oth_business_no) as oth_business_no -- 对手业务编号
    ,case when
            n.fee_int_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fee_int_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fee_int_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_fee_int_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_fee_int_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fee_int_no = n.fee_int_no
where (
        o.fee_int_no is null
    )
    or (
        n.fee_int_no is null
    )
    or (
        o.int_amt <> n.int_amt
        or o.start_accrual_date <> n.start_accrual_date
        or o.end_accrual_date <> n.end_accrual_date
        or o.freq_type <> n.freq_type
        or o.ext_trade_no <> n.ext_trade_no
        or o.fee_type <> n.fee_type
        or o.status <> n.status
        or o.int_accrued <> n.int_accrued
        or o.int_accrued_calc_ctd <> n.int_accrued_calc_ctd
        or o.int_accrued_diff <> n.int_accrued_diff
        or o.user_id <> n.user_id
        or o.auth_user_id <> n.auth_user_id
        or o.tran_branch <> n.tran_branch
        or o.tran_timestamp <> n.tran_timestamp
        or o.company <> n.company
        or o.tran_date <> n.tran_date
        or o.write_off_int_amt <> n.write_off_int_amt
        or o.recalc_start_date <> n.recalc_start_date
        or o.accr_date <> n.accr_date
        or o.next_accr_date <> n.next_accr_date
        or o.narrative <> n.narrative
        or o.narrative_code <> n.narrative_code
        or o.int_accr <> n.int_accr
        or o.recalc_int_amt <> n.recalc_int_amt
        or o.reference <> n.reference
        or o.ccy <> n.ccy
        or o.oth_client_name <> n.oth_client_name
        or o.acct_exec_name <> n.acct_exec_name
        or o.acct_exec <> n.acct_exec
        or o.oth_client_no <> n.oth_client_no
        or o.oth_business_no <> n.oth_business_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_fee_int_detail_cl(
            fee_int_no -- 费用计提编号
            ,int_amt -- 利息金额
            ,start_accrual_date -- 开始计提日期
            ,end_accrual_date -- 结束计提日期
            ,freq_type -- 频率
            ,ext_trade_no -- 原业务编号
            ,fee_type -- 费率类型
            ,status -- 状态
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_diff -- 计提金额差额
            ,user_id -- 交易柜员编号
            ,auth_user_id -- 授权柜员
            ,tran_branch -- 核心交易机构编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,tran_date -- 交易日期
            ,write_off_int_amt -- 核销利息
            ,recalc_start_date -- 利息重算起始日
            ,accr_date -- 计提日期
            ,next_accr_date -- 下一计提日期
            ,narrative -- 摘要
            ,narrative_code -- 摘要码
            ,int_accr -- 计提利息
            ,recalc_int_amt -- 重算利息总金额
            ,reference -- 交易参考号
            ,ccy -- 币种
            ,oth_client_name -- 对手客户名称
            ,acct_exec_name -- 客户经理姓名
            ,acct_exec -- 银行客户经理编号
            ,oth_client_no -- 对手客户
            ,oth_business_no -- 对手业务编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_fee_int_detail_op(
            fee_int_no -- 费用计提编号
            ,int_amt -- 利息金额
            ,start_accrual_date -- 开始计提日期
            ,end_accrual_date -- 结束计提日期
            ,freq_type -- 频率
            ,ext_trade_no -- 原业务编号
            ,fee_type -- 费率类型
            ,status -- 状态
            ,int_accrued -- 累计计提
            ,int_accrued_calc_ctd -- 计提日计提实际金额
            ,int_accrued_diff -- 计提金额差额
            ,user_id -- 交易柜员编号
            ,auth_user_id -- 授权柜员
            ,tran_branch -- 核心交易机构编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,tran_date -- 交易日期
            ,write_off_int_amt -- 核销利息
            ,recalc_start_date -- 利息重算起始日
            ,accr_date -- 计提日期
            ,next_accr_date -- 下一计提日期
            ,narrative -- 摘要
            ,narrative_code -- 摘要码
            ,int_accr -- 计提利息
            ,recalc_int_amt -- 重算利息总金额
            ,reference -- 交易参考号
            ,ccy -- 币种
            ,oth_client_name -- 对手客户名称
            ,acct_exec_name -- 客户经理姓名
            ,acct_exec -- 银行客户经理编号
            ,oth_client_no -- 对手客户
            ,oth_business_no -- 对手业务编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fee_int_no -- 费用计提编号
    ,o.int_amt -- 利息金额
    ,o.start_accrual_date -- 开始计提日期
    ,o.end_accrual_date -- 结束计提日期
    ,o.freq_type -- 频率
    ,o.ext_trade_no -- 原业务编号
    ,o.fee_type -- 费率类型
    ,o.status -- 状态
    ,o.int_accrued -- 累计计提
    ,o.int_accrued_calc_ctd -- 计提日计提实际金额
    ,o.int_accrued_diff -- 计提金额差额
    ,o.user_id -- 交易柜员编号
    ,o.auth_user_id -- 授权柜员
    ,o.tran_branch -- 核心交易机构编号
    ,o.tran_timestamp -- 交易时间戳
    ,o.company -- 法人
    ,o.tran_date -- 交易日期
    ,o.write_off_int_amt -- 核销利息
    ,o.recalc_start_date -- 利息重算起始日
    ,o.accr_date -- 计提日期
    ,o.next_accr_date -- 下一计提日期
    ,o.narrative -- 摘要
    ,o.narrative_code -- 摘要码
    ,o.int_accr -- 计提利息
    ,o.recalc_int_amt -- 重算利息总金额
    ,o.reference -- 交易参考号
    ,o.ccy -- 币种
    ,o.oth_client_name -- 对手客户名称
    ,o.acct_exec_name -- 客户经理姓名
    ,o.acct_exec -- 银行客户经理编号
    ,o.oth_client_no -- 对手客户
    ,o.oth_business_no -- 对手业务编号
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
from ${iol_schema}.ncbs_rb_fee_int_detail_bk o
    left join ${iol_schema}.ncbs_rb_fee_int_detail_op n
        on
            o.fee_int_no = n.fee_int_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_fee_int_detail_cl d
        on
            o.fee_int_no = d.fee_int_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_fee_int_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_fee_int_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_fee_int_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_fee_int_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_fee_int_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_fee_int_detail_cl;
alter table ${iol_schema}.ncbs_rb_fee_int_detail exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_fee_int_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_fee_int_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_fee_int_detail_op purge;
drop table ${iol_schema}.ncbs_rb_fee_int_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_fee_int_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_fee_int_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
