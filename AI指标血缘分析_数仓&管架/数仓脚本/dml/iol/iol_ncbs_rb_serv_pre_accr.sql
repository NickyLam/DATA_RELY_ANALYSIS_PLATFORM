/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_serv_pre_accr
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
create table ${iol_schema}.ncbs_rb_serv_pre_accr_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_serv_pre_accr
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_serv_pre_accr_op purge;
drop table ${iol_schema}.ncbs_rb_serv_pre_accr_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_serv_pre_accr_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_serv_pre_accr where 0=1;

create table ${iol_schema}.ncbs_rb_serv_pre_accr_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_serv_pre_accr where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_serv_pre_accr_cl(
            pre_accr_no -- 预提摊销编号
            ,pre_accr_status -- 预提状态
            ,gl_code -- 科目代码
            ,fee_type -- 费率类型
            ,cur_pre_accr_amt -- 当日预提金额
            ,total_pre_accr_amt -- 预提总金额
            ,agg_pre_accr_amt -- 累计已预提金额
            ,can_pay_accr_amt -- 可支出金额
            ,paid_pre_accr_amt -- 已支出金额
            ,int_accrued_diff -- 计提金额差额
            ,amortize_period_type -- 摊销期限类型
            ,amortize_day -- 摊销日
            ,amortize_month -- 摊销月
            ,pre_accr_date -- 预提日期
            ,supplement_date -- 补账日期
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,oper_date -- 操作日期
            ,oper_user_id -- 操作柜员
            ,auth_user_id -- 授权柜员
            ,branch -- 交易机构编号
            ,ext_trade_no -- 原业务编号
            ,remark -- 备注
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,ccy -- 币种
            ,recalc_start_date -- 利息重算起始日
            ,recalc_int_amt -- 重算利息总金额
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,oth_client_no -- 对手客户
            ,oth_client_name -- 对手客户名称
            ,oth_business_no -- 对手业务编号
            ,oth_client_type -- 对手客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_serv_pre_accr_op(
            pre_accr_no -- 预提摊销编号
            ,pre_accr_status -- 预提状态
            ,gl_code -- 科目代码
            ,fee_type -- 费率类型
            ,cur_pre_accr_amt -- 当日预提金额
            ,total_pre_accr_amt -- 预提总金额
            ,agg_pre_accr_amt -- 累计已预提金额
            ,can_pay_accr_amt -- 可支出金额
            ,paid_pre_accr_amt -- 已支出金额
            ,int_accrued_diff -- 计提金额差额
            ,amortize_period_type -- 摊销期限类型
            ,amortize_day -- 摊销日
            ,amortize_month -- 摊销月
            ,pre_accr_date -- 预提日期
            ,supplement_date -- 补账日期
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,oper_date -- 操作日期
            ,oper_user_id -- 操作柜员
            ,auth_user_id -- 授权柜员
            ,branch -- 交易机构编号
            ,ext_trade_no -- 原业务编号
            ,remark -- 备注
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,ccy -- 币种
            ,recalc_start_date -- 利息重算起始日
            ,recalc_int_amt -- 重算利息总金额
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,oth_client_no -- 对手客户
            ,oth_client_name -- 对手客户名称
            ,oth_business_no -- 对手业务编号
            ,oth_client_type -- 对手客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pre_accr_no, o.pre_accr_no) as pre_accr_no -- 预提摊销编号
    ,nvl(n.pre_accr_status, o.pre_accr_status) as pre_accr_status -- 预提状态
    ,nvl(n.gl_code, o.gl_code) as gl_code -- 科目代码
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费率类型
    ,nvl(n.cur_pre_accr_amt, o.cur_pre_accr_amt) as cur_pre_accr_amt -- 当日预提金额
    ,nvl(n.total_pre_accr_amt, o.total_pre_accr_amt) as total_pre_accr_amt -- 预提总金额
    ,nvl(n.agg_pre_accr_amt, o.agg_pre_accr_amt) as agg_pre_accr_amt -- 累计已预提金额
    ,nvl(n.can_pay_accr_amt, o.can_pay_accr_amt) as can_pay_accr_amt -- 可支出金额
    ,nvl(n.paid_pre_accr_amt, o.paid_pre_accr_amt) as paid_pre_accr_amt -- 已支出金额
    ,nvl(n.int_accrued_diff, o.int_accrued_diff) as int_accrued_diff -- 计提金额差额
    ,nvl(n.amortize_period_type, o.amortize_period_type) as amortize_period_type -- 摊销期限类型
    ,nvl(n.amortize_day, o.amortize_day) as amortize_day -- 摊销日
    ,nvl(n.amortize_month, o.amortize_month) as amortize_month -- 摊销月
    ,nvl(n.pre_accr_date, o.pre_accr_date) as pre_accr_date -- 预提日期
    ,nvl(n.supplement_date, o.supplement_date) as supplement_date -- 补账日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.oper_date, o.oper_date) as oper_date -- 操作日期
    ,nvl(n.oper_user_id, o.oper_user_id) as oper_user_id -- 操作柜员
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.branch, o.branch) as branch -- 交易机构编号
    ,nvl(n.ext_trade_no, o.ext_trade_no) as ext_trade_no -- 原业务编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.recalc_start_date, o.recalc_start_date) as recalc_start_date -- 利息重算起始日
    ,nvl(n.recalc_int_amt, o.recalc_int_amt) as recalc_int_amt -- 重算利息总金额
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理编号
    ,nvl(n.acct_exec_name, o.acct_exec_name) as acct_exec_name -- 客户经理姓名
    ,nvl(n.oth_client_no, o.oth_client_no) as oth_client_no -- 对手客户
    ,nvl(n.oth_client_name, o.oth_client_name) as oth_client_name -- 对手客户名称
    ,nvl(n.oth_business_no, o.oth_business_no) as oth_business_no -- 对手业务编号
    ,nvl(n.oth_client_type, o.oth_client_type) as oth_client_type -- 对手客户类型
    ,case when
            n.pre_accr_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pre_accr_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pre_accr_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_serv_pre_accr_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_serv_pre_accr where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pre_accr_no = n.pre_accr_no
where (
        o.pre_accr_no is null
    )
    or (
        n.pre_accr_no is null
    )
    or (
        o.pre_accr_status <> n.pre_accr_status
        or o.gl_code <> n.gl_code
        or o.fee_type <> n.fee_type
        or o.cur_pre_accr_amt <> n.cur_pre_accr_amt
        or o.total_pre_accr_amt <> n.total_pre_accr_amt
        or o.agg_pre_accr_amt <> n.agg_pre_accr_amt
        or o.can_pay_accr_amt <> n.can_pay_accr_amt
        or o.paid_pre_accr_amt <> n.paid_pre_accr_amt
        or o.int_accrued_diff <> n.int_accrued_diff
        or o.amortize_period_type <> n.amortize_period_type
        or o.amortize_day <> n.amortize_day
        or o.amortize_month <> n.amortize_month
        or o.pre_accr_date <> n.pre_accr_date
        or o.supplement_date <> n.supplement_date
        or o.start_date <> n.start_date
        or o.end_date <> n.end_date
        or o.oper_date <> n.oper_date
        or o.oper_user_id <> n.oper_user_id
        or o.auth_user_id <> n.auth_user_id
        or o.branch <> n.branch
        or o.ext_trade_no <> n.ext_trade_no
        or o.remark <> n.remark
        or o.client_no <> n.client_no
        or o.reference <> n.reference
        or o.ccy <> n.ccy
        or o.recalc_start_date <> n.recalc_start_date
        or o.recalc_int_amt <> n.recalc_int_amt
        or o.acct_exec <> n.acct_exec
        or o.acct_exec_name <> n.acct_exec_name
        or o.oth_client_no <> n.oth_client_no
        or o.oth_client_name <> n.oth_client_name
        or o.oth_business_no <> n.oth_business_no
        or o.oth_client_type <> n.oth_client_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_serv_pre_accr_cl(
            pre_accr_no -- 预提摊销编号
            ,pre_accr_status -- 预提状态
            ,gl_code -- 科目代码
            ,fee_type -- 费率类型
            ,cur_pre_accr_amt -- 当日预提金额
            ,total_pre_accr_amt -- 预提总金额
            ,agg_pre_accr_amt -- 累计已预提金额
            ,can_pay_accr_amt -- 可支出金额
            ,paid_pre_accr_amt -- 已支出金额
            ,int_accrued_diff -- 计提金额差额
            ,amortize_period_type -- 摊销期限类型
            ,amortize_day -- 摊销日
            ,amortize_month -- 摊销月
            ,pre_accr_date -- 预提日期
            ,supplement_date -- 补账日期
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,oper_date -- 操作日期
            ,oper_user_id -- 操作柜员
            ,auth_user_id -- 授权柜员
            ,branch -- 交易机构编号
            ,ext_trade_no -- 原业务编号
            ,remark -- 备注
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,ccy -- 币种
            ,recalc_start_date -- 利息重算起始日
            ,recalc_int_amt -- 重算利息总金额
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,oth_client_no -- 对手客户
            ,oth_client_name -- 对手客户名称
            ,oth_business_no -- 对手业务编号
            ,oth_client_type -- 对手客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_serv_pre_accr_op(
            pre_accr_no -- 预提摊销编号
            ,pre_accr_status -- 预提状态
            ,gl_code -- 科目代码
            ,fee_type -- 费率类型
            ,cur_pre_accr_amt -- 当日预提金额
            ,total_pre_accr_amt -- 预提总金额
            ,agg_pre_accr_amt -- 累计已预提金额
            ,can_pay_accr_amt -- 可支出金额
            ,paid_pre_accr_amt -- 已支出金额
            ,int_accrued_diff -- 计提金额差额
            ,amortize_period_type -- 摊销期限类型
            ,amortize_day -- 摊销日
            ,amortize_month -- 摊销月
            ,pre_accr_date -- 预提日期
            ,supplement_date -- 补账日期
            ,start_date -- 开始日期
            ,end_date -- 结束日期
            ,oper_date -- 操作日期
            ,oper_user_id -- 操作柜员
            ,auth_user_id -- 授权柜员
            ,branch -- 交易机构编号
            ,ext_trade_no -- 原业务编号
            ,remark -- 备注
            ,client_no -- 客户编号
            ,reference -- 交易参考号
            ,ccy -- 币种
            ,recalc_start_date -- 利息重算起始日
            ,recalc_int_amt -- 重算利息总金额
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,oth_client_no -- 对手客户
            ,oth_client_name -- 对手客户名称
            ,oth_business_no -- 对手业务编号
            ,oth_client_type -- 对手客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pre_accr_no -- 预提摊销编号
    ,o.pre_accr_status -- 预提状态
    ,o.gl_code -- 科目代码
    ,o.fee_type -- 费率类型
    ,o.cur_pre_accr_amt -- 当日预提金额
    ,o.total_pre_accr_amt -- 预提总金额
    ,o.agg_pre_accr_amt -- 累计已预提金额
    ,o.can_pay_accr_amt -- 可支出金额
    ,o.paid_pre_accr_amt -- 已支出金额
    ,o.int_accrued_diff -- 计提金额差额
    ,o.amortize_period_type -- 摊销期限类型
    ,o.amortize_day -- 摊销日
    ,o.amortize_month -- 摊销月
    ,o.pre_accr_date -- 预提日期
    ,o.supplement_date -- 补账日期
    ,o.start_date -- 开始日期
    ,o.end_date -- 结束日期
    ,o.oper_date -- 操作日期
    ,o.oper_user_id -- 操作柜员
    ,o.auth_user_id -- 授权柜员
    ,o.branch -- 交易机构编号
    ,o.ext_trade_no -- 原业务编号
    ,o.remark -- 备注
    ,o.client_no -- 客户编号
    ,o.reference -- 交易参考号
    ,o.ccy -- 币种
    ,o.recalc_start_date -- 利息重算起始日
    ,o.recalc_int_amt -- 重算利息总金额
    ,o.acct_exec -- 银行客户经理编号
    ,o.acct_exec_name -- 客户经理姓名
    ,o.oth_client_no -- 对手客户
    ,o.oth_client_name -- 对手客户名称
    ,o.oth_business_no -- 对手业务编号
    ,o.oth_client_type -- 对手客户类型
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
from ${iol_schema}.ncbs_rb_serv_pre_accr_bk o
    left join ${iol_schema}.ncbs_rb_serv_pre_accr_op n
        on
            o.pre_accr_no = n.pre_accr_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_serv_pre_accr_cl d
        on
            o.pre_accr_no = d.pre_accr_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_serv_pre_accr;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_serv_pre_accr') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_serv_pre_accr drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_serv_pre_accr add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_serv_pre_accr exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_serv_pre_accr_cl;
alter table ${iol_schema}.ncbs_rb_serv_pre_accr exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_serv_pre_accr_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_serv_pre_accr to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_serv_pre_accr_op purge;
drop table ${iol_schema}.ncbs_rb_serv_pre_accr_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_serv_pre_accr_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_serv_pre_accr',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
