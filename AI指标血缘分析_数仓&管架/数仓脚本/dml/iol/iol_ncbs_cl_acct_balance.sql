/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct_balance
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
create table ${iol_schema}.ncbs_cl_acct_balance_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_acct_balance
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_balance_op purge;
drop table ${iol_schema}.ncbs_cl_acct_balance_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_balance_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct_balance where 0=1;

create table ${iol_schema}.ncbs_cl_acct_balance_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct_balance where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_balance_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,last_bal_upd_date -- 上次动户日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,dd_amt -- 发放金额
            ,dda_amt_prev -- 上日发放金额
            ,gintp_amt -- 宽限期利息
            ,gintp_amt_prev -- 上日宽限期利息
            ,godip_amt -- 宽限期复利
            ,godip_amt_prev -- 上日宽限期复利
            ,godpp_amt -- 宽限期罚息
            ,godpp_amt_prev -- 上日宽限期罚息
            ,gprd_amt -- 宽限期本金
            ,gprd_amt_prev -- 上日宽限期本金
            ,intp_amt -- 逾期利息
            ,intp_amt_prev -- 账户上日逾期利息
            ,last_change_user_id -- 最后修改柜员
            ,odip_amt -- 复利余额
            ,odip_amt_prev -- 上日逾期复利
            ,odpp_amt -- 逾期罚息余额
            ,odpp_amt_prev -- 上日逾期罚息
            ,osl_amt -- 客户未到期本金
            ,osl_amt_prev -- 上日未到期本金
            ,prd_amt -- 逾期本金
            ,prd_amt_prev -- 上日逾期本金
            ,dd_amt_last_prev -- 上上日发放金额
            ,osl_amt_last_prev -- 上上日未到期本金
            ,prd_amt_last_prev -- 上上日逾期本金
            ,intp_amt_last_prev -- 上上日逾期利息
            ,odpp_amt_last_prev -- 上上日逾期罚息
            ,odip_amt_last_prev -- 上上日逾期复利
            ,gprd_amt_last_prev -- 上上日宽限期本金
            ,gintp_amt_last_prev -- 上上日宽限期利息
            ,godpp_amt_last_prev -- 上上日宽限期罚息
            ,godip_amt_last_prev -- 上上日宽限期复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_balance_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,last_bal_upd_date -- 上次动户日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,dd_amt -- 发放金额
            ,dda_amt_prev -- 上日发放金额
            ,gintp_amt -- 宽限期利息
            ,gintp_amt_prev -- 上日宽限期利息
            ,godip_amt -- 宽限期复利
            ,godip_amt_prev -- 上日宽限期复利
            ,godpp_amt -- 宽限期罚息
            ,godpp_amt_prev -- 上日宽限期罚息
            ,gprd_amt -- 宽限期本金
            ,gprd_amt_prev -- 上日宽限期本金
            ,intp_amt -- 逾期利息
            ,intp_amt_prev -- 账户上日逾期利息
            ,last_change_user_id -- 最后修改柜员
            ,odip_amt -- 复利余额
            ,odip_amt_prev -- 上日逾期复利
            ,odpp_amt -- 逾期罚息余额
            ,odpp_amt_prev -- 上日逾期罚息
            ,osl_amt -- 客户未到期本金
            ,osl_amt_prev -- 上日未到期本金
            ,prd_amt -- 逾期本金
            ,prd_amt_prev -- 上日逾期本金
            ,dd_amt_last_prev -- 上上日发放金额
            ,osl_amt_last_prev -- 上上日未到期本金
            ,prd_amt_last_prev -- 上上日逾期本金
            ,intp_amt_last_prev -- 上上日逾期利息
            ,odpp_amt_last_prev -- 上上日逾期罚息
            ,odip_amt_last_prev -- 上上日逾期复利
            ,gprd_amt_last_prev -- 上上日宽限期本金
            ,gintp_amt_last_prev -- 上上日宽限期利息
            ,godpp_amt_last_prev -- 上上日宽限期罚息
            ,godip_amt_last_prev -- 上上日宽限期复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.dac_value, o.dac_value) as dac_value -- dac值防篡改加密
    ,nvl(n.last_bal_upd_date, o.last_bal_upd_date) as last_bal_upd_date -- 上次动户日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.dd_amt, o.dd_amt) as dd_amt -- 发放金额
    ,nvl(n.dda_amt_prev, o.dda_amt_prev) as dda_amt_prev -- 上日发放金额
    ,nvl(n.gintp_amt, o.gintp_amt) as gintp_amt -- 宽限期利息
    ,nvl(n.gintp_amt_prev, o.gintp_amt_prev) as gintp_amt_prev -- 上日宽限期利息
    ,nvl(n.godip_amt, o.godip_amt) as godip_amt -- 宽限期复利
    ,nvl(n.godip_amt_prev, o.godip_amt_prev) as godip_amt_prev -- 上日宽限期复利
    ,nvl(n.godpp_amt, o.godpp_amt) as godpp_amt -- 宽限期罚息
    ,nvl(n.godpp_amt_prev, o.godpp_amt_prev) as godpp_amt_prev -- 上日宽限期罚息
    ,nvl(n.gprd_amt, o.gprd_amt) as gprd_amt -- 宽限期本金
    ,nvl(n.gprd_amt_prev, o.gprd_amt_prev) as gprd_amt_prev -- 上日宽限期本金
    ,nvl(n.intp_amt, o.intp_amt) as intp_amt -- 逾期利息
    ,nvl(n.intp_amt_prev, o.intp_amt_prev) as intp_amt_prev -- 账户上日逾期利息
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.odip_amt, o.odip_amt) as odip_amt -- 复利余额
    ,nvl(n.odip_amt_prev, o.odip_amt_prev) as odip_amt_prev -- 上日逾期复利
    ,nvl(n.odpp_amt, o.odpp_amt) as odpp_amt -- 逾期罚息余额
    ,nvl(n.odpp_amt_prev, o.odpp_amt_prev) as odpp_amt_prev -- 上日逾期罚息
    ,nvl(n.osl_amt, o.osl_amt) as osl_amt -- 客户未到期本金
    ,nvl(n.osl_amt_prev, o.osl_amt_prev) as osl_amt_prev -- 上日未到期本金
    ,nvl(n.prd_amt, o.prd_amt) as prd_amt -- 逾期本金
    ,nvl(n.prd_amt_prev, o.prd_amt_prev) as prd_amt_prev -- 上日逾期本金
    ,nvl(n.dd_amt_last_prev, o.dd_amt_last_prev) as dd_amt_last_prev -- 上上日发放金额
    ,nvl(n.osl_amt_last_prev, o.osl_amt_last_prev) as osl_amt_last_prev -- 上上日未到期本金
    ,nvl(n.prd_amt_last_prev, o.prd_amt_last_prev) as prd_amt_last_prev -- 上上日逾期本金
    ,nvl(n.intp_amt_last_prev, o.intp_amt_last_prev) as intp_amt_last_prev -- 上上日逾期利息
    ,nvl(n.odpp_amt_last_prev, o.odpp_amt_last_prev) as odpp_amt_last_prev -- 上上日逾期罚息
    ,nvl(n.odip_amt_last_prev, o.odip_amt_last_prev) as odip_amt_last_prev -- 上上日逾期复利
    ,nvl(n.gprd_amt_last_prev, o.gprd_amt_last_prev) as gprd_amt_last_prev -- 上上日宽限期本金
    ,nvl(n.gintp_amt_last_prev, o.gintp_amt_last_prev) as gintp_amt_last_prev -- 上上日宽限期利息
    ,nvl(n.godpp_amt_last_prev, o.godpp_amt_last_prev) as godpp_amt_last_prev -- 上上日宽限期罚息
    ,nvl(n.godip_amt_last_prev, o.godip_amt_last_prev) as godip_amt_last_prev -- 上上日宽限期复利
    ,case when
            n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_acct_balance_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_acct_balance where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.client_no <> n.client_no
        or o.company <> n.company
        or o.dac_value <> n.dac_value
        or o.last_bal_upd_date <> n.last_bal_upd_date
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.dd_amt <> n.dd_amt
        or o.dda_amt_prev <> n.dda_amt_prev
        or o.gintp_amt <> n.gintp_amt
        or o.gintp_amt_prev <> n.gintp_amt_prev
        or o.godip_amt <> n.godip_amt
        or o.godip_amt_prev <> n.godip_amt_prev
        or o.godpp_amt <> n.godpp_amt
        or o.godpp_amt_prev <> n.godpp_amt_prev
        or o.gprd_amt <> n.gprd_amt
        or o.gprd_amt_prev <> n.gprd_amt_prev
        or o.intp_amt <> n.intp_amt
        or o.intp_amt_prev <> n.intp_amt_prev
        or o.last_change_user_id <> n.last_change_user_id
        or o.odip_amt <> n.odip_amt
        or o.odip_amt_prev <> n.odip_amt_prev
        or o.odpp_amt <> n.odpp_amt
        or o.odpp_amt_prev <> n.odpp_amt_prev
        or o.osl_amt <> n.osl_amt
        or o.osl_amt_prev <> n.osl_amt_prev
        or o.prd_amt <> n.prd_amt
        or o.prd_amt_prev <> n.prd_amt_prev
        or o.dd_amt_last_prev <> n.dd_amt_last_prev
        or o.osl_amt_last_prev <> n.osl_amt_last_prev
        or o.prd_amt_last_prev <> n.prd_amt_last_prev
        or o.intp_amt_last_prev <> n.intp_amt_last_prev
        or o.odpp_amt_last_prev <> n.odpp_amt_last_prev
        or o.odip_amt_last_prev <> n.odip_amt_last_prev
        or o.gprd_amt_last_prev <> n.gprd_amt_last_prev
        or o.gintp_amt_last_prev <> n.gintp_amt_last_prev
        or o.godpp_amt_last_prev <> n.godpp_amt_last_prev
        or o.godip_amt_last_prev <> n.godip_amt_last_prev
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_balance_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,last_bal_upd_date -- 上次动户日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,dd_amt -- 发放金额
            ,dda_amt_prev -- 上日发放金额
            ,gintp_amt -- 宽限期利息
            ,gintp_amt_prev -- 上日宽限期利息
            ,godip_amt -- 宽限期复利
            ,godip_amt_prev -- 上日宽限期复利
            ,godpp_amt -- 宽限期罚息
            ,godpp_amt_prev -- 上日宽限期罚息
            ,gprd_amt -- 宽限期本金
            ,gprd_amt_prev -- 上日宽限期本金
            ,intp_amt -- 逾期利息
            ,intp_amt_prev -- 账户上日逾期利息
            ,last_change_user_id -- 最后修改柜员
            ,odip_amt -- 复利余额
            ,odip_amt_prev -- 上日逾期复利
            ,odpp_amt -- 逾期罚息余额
            ,odpp_amt_prev -- 上日逾期罚息
            ,osl_amt -- 客户未到期本金
            ,osl_amt_prev -- 上日未到期本金
            ,prd_amt -- 逾期本金
            ,prd_amt_prev -- 上日逾期本金
            ,dd_amt_last_prev -- 上上日发放金额
            ,osl_amt_last_prev -- 上上日未到期本金
            ,prd_amt_last_prev -- 上上日逾期本金
            ,intp_amt_last_prev -- 上上日逾期利息
            ,odpp_amt_last_prev -- 上上日逾期罚息
            ,odip_amt_last_prev -- 上上日逾期复利
            ,gprd_amt_last_prev -- 上上日宽限期本金
            ,gintp_amt_last_prev -- 上上日宽限期利息
            ,godpp_amt_last_prev -- 上上日宽限期罚息
            ,godip_amt_last_prev -- 上上日宽限期复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_balance_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,last_bal_upd_date -- 上次动户日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,dd_amt -- 发放金额
            ,dda_amt_prev -- 上日发放金额
            ,gintp_amt -- 宽限期利息
            ,gintp_amt_prev -- 上日宽限期利息
            ,godip_amt -- 宽限期复利
            ,godip_amt_prev -- 上日宽限期复利
            ,godpp_amt -- 宽限期罚息
            ,godpp_amt_prev -- 上日宽限期罚息
            ,gprd_amt -- 宽限期本金
            ,gprd_amt_prev -- 上日宽限期本金
            ,intp_amt -- 逾期利息
            ,intp_amt_prev -- 账户上日逾期利息
            ,last_change_user_id -- 最后修改柜员
            ,odip_amt -- 复利余额
            ,odip_amt_prev -- 上日逾期复利
            ,odpp_amt -- 逾期罚息余额
            ,odpp_amt_prev -- 上日逾期罚息
            ,osl_amt -- 客户未到期本金
            ,osl_amt_prev -- 上日未到期本金
            ,prd_amt -- 逾期本金
            ,prd_amt_prev -- 上日逾期本金
            ,dd_amt_last_prev -- 上上日发放金额
            ,osl_amt_last_prev -- 上上日未到期本金
            ,prd_amt_last_prev -- 上上日逾期本金
            ,intp_amt_last_prev -- 上上日逾期利息
            ,odpp_amt_last_prev -- 上上日逾期罚息
            ,odip_amt_last_prev -- 上上日逾期复利
            ,gprd_amt_last_prev -- 上上日宽限期本金
            ,gintp_amt_last_prev -- 上上日宽限期利息
            ,godpp_amt_last_prev -- 上上日宽限期罚息
            ,godip_amt_last_prev -- 上上日宽限期复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.company -- 法人
    ,o.dac_value -- dac值防篡改加密
    ,o.last_bal_upd_date -- 上次动户日期
    ,o.last_change_date -- 最后修改日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.dd_amt -- 发放金额
    ,o.dda_amt_prev -- 上日发放金额
    ,o.gintp_amt -- 宽限期利息
    ,o.gintp_amt_prev -- 上日宽限期利息
    ,o.godip_amt -- 宽限期复利
    ,o.godip_amt_prev -- 上日宽限期复利
    ,o.godpp_amt -- 宽限期罚息
    ,o.godpp_amt_prev -- 上日宽限期罚息
    ,o.gprd_amt -- 宽限期本金
    ,o.gprd_amt_prev -- 上日宽限期本金
    ,o.intp_amt -- 逾期利息
    ,o.intp_amt_prev -- 账户上日逾期利息
    ,o.last_change_user_id -- 最后修改柜员
    ,o.odip_amt -- 复利余额
    ,o.odip_amt_prev -- 上日逾期复利
    ,o.odpp_amt -- 逾期罚息余额
    ,o.odpp_amt_prev -- 上日逾期罚息
    ,o.osl_amt -- 客户未到期本金
    ,o.osl_amt_prev -- 上日未到期本金
    ,o.prd_amt -- 逾期本金
    ,o.prd_amt_prev -- 上日逾期本金
    ,o.dd_amt_last_prev -- 上上日发放金额
    ,o.osl_amt_last_prev -- 上上日未到期本金
    ,o.prd_amt_last_prev -- 上上日逾期本金
    ,o.intp_amt_last_prev -- 上上日逾期利息
    ,o.odpp_amt_last_prev -- 上上日逾期罚息
    ,o.odip_amt_last_prev -- 上上日逾期复利
    ,o.gprd_amt_last_prev -- 上上日宽限期本金
    ,o.gintp_amt_last_prev -- 上上日宽限期利息
    ,o.godpp_amt_last_prev -- 上上日宽限期罚息
    ,o.godip_amt_last_prev -- 上上日宽限期复利
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
from ${iol_schema}.ncbs_cl_acct_balance_bk o
    left join ${iol_schema}.ncbs_cl_acct_balance_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_acct_balance_cl d
        on
            o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_acct_balance;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_acct_balance') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_acct_balance drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_acct_balance add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_acct_balance exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_acct_balance_cl;
alter table ${iol_schema}.ncbs_cl_acct_balance exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_acct_balance_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_acct_balance to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_balance_op purge;
drop table ${iol_schema}.ncbs_cl_acct_balance_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_acct_balance_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_acct_balance',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
