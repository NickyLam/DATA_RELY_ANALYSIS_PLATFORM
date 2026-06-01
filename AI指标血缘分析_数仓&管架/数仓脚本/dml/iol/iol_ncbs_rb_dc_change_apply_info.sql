/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_change_apply_info
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
create table ${iol_schema}.ncbs_rb_dc_change_apply_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_dc_change_apply_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_change_apply_info_op purge;
drop table ${iol_schema}.ncbs_rb_dc_change_apply_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_change_apply_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_change_apply_info where 0=1;

create table ${iol_schema}.ncbs_rb_dc_change_apply_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_change_apply_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_change_apply_info_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,stage_code -- 期次代码
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,dep_keep_days -- 存款天数
            ,int_rem_days -- 计息剩余天数
            ,trf_total_settle_amt -- 转让总对价
            ,trf_end_date -- 转让到期日
            ,direction_trf_flag -- 是否定期转让
            ,order_start_date -- 挂单起始日期
            ,trf_in_fee_amt -- 转入费用
            ,order_end_date -- 挂单结束日期
            ,trf_pri_amt -- 转让本金金额
            ,trf_command -- 转让口令
            ,trf_rate -- 转让利率
            ,trf_type -- 转让类型
            ,trf_status -- 转让状态
            ,beneficiary_client_no -- 受益人客户号
            ,trf_no -- 转让号
            ,trf_date -- 转让日期
            ,beneficiary_profit_rate -- 受让人收益率
            ,trf_out_fee_amt -- 转出费用
            ,prod_type -- 产品编号|产品编号
            ,settle_acct_seq_no -- 结算账户序号|结算账户序号
            ,settle_base_acct_no -- 结算账号|结算账号
            ,inner_base_acct_no -- 转入账号/卡号
            ,reference -- 转让流水号
            ,rec_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_change_apply_info_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,stage_code -- 期次代码
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,dep_keep_days -- 存款天数
            ,int_rem_days -- 计息剩余天数
            ,trf_total_settle_amt -- 转让总对价
            ,trf_end_date -- 转让到期日
            ,direction_trf_flag -- 是否定期转让
            ,order_start_date -- 挂单起始日期
            ,trf_in_fee_amt -- 转入费用
            ,order_end_date -- 挂单结束日期
            ,trf_pri_amt -- 转让本金金额
            ,trf_command -- 转让口令
            ,trf_rate -- 转让利率
            ,trf_type -- 转让类型
            ,trf_status -- 转让状态
            ,beneficiary_client_no -- 受益人客户号
            ,trf_no -- 转让号
            ,trf_date -- 转让日期
            ,beneficiary_profit_rate -- 受让人收益率
            ,trf_out_fee_amt -- 转出费用
            ,prod_type -- 产品编号|产品编号
            ,settle_acct_seq_no -- 结算账户序号|结算账户序号
            ,settle_base_acct_no -- 结算账号|结算账号
            ,inner_base_acct_no -- 转入账号/卡号
            ,reference -- 转让流水号
            ,rec_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.stage_code, o.stage_code) as stage_code -- 期次代码
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.dep_keep_days, o.dep_keep_days) as dep_keep_days -- 存款天数
    ,nvl(n.int_rem_days, o.int_rem_days) as int_rem_days -- 计息剩余天数
    ,nvl(n.trf_total_settle_amt, o.trf_total_settle_amt) as trf_total_settle_amt -- 转让总对价
    ,nvl(n.trf_end_date, o.trf_end_date) as trf_end_date -- 转让到期日
    ,nvl(n.direction_trf_flag, o.direction_trf_flag) as direction_trf_flag -- 是否定期转让
    ,nvl(n.order_start_date, o.order_start_date) as order_start_date -- 挂单起始日期
    ,nvl(n.trf_in_fee_amt, o.trf_in_fee_amt) as trf_in_fee_amt -- 转入费用
    ,nvl(n.order_end_date, o.order_end_date) as order_end_date -- 挂单结束日期
    ,nvl(n.trf_pri_amt, o.trf_pri_amt) as trf_pri_amt -- 转让本金金额
    ,nvl(n.trf_command, o.trf_command) as trf_command -- 转让口令
    ,nvl(n.trf_rate, o.trf_rate) as trf_rate -- 转让利率
    ,nvl(n.trf_type, o.trf_type) as trf_type -- 转让类型
    ,nvl(n.trf_status, o.trf_status) as trf_status -- 转让状态
    ,nvl(n.beneficiary_client_no, o.beneficiary_client_no) as beneficiary_client_no -- 受益人客户号
    ,nvl(n.trf_no, o.trf_no) as trf_no -- 转让号
    ,nvl(n.trf_date, o.trf_date) as trf_date -- 转让日期
    ,nvl(n.beneficiary_profit_rate, o.beneficiary_profit_rate) as beneficiary_profit_rate -- 受让人收益率
    ,nvl(n.trf_out_fee_amt, o.trf_out_fee_amt) as trf_out_fee_amt -- 转出费用
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号|产品编号
    ,nvl(n.settle_acct_seq_no, o.settle_acct_seq_no) as settle_acct_seq_no -- 结算账户序号|结算账户序号
    ,nvl(n.settle_base_acct_no, o.settle_base_acct_no) as settle_base_acct_no -- 结算账号|结算账号
    ,nvl(n.inner_base_acct_no, o.inner_base_acct_no) as inner_base_acct_no -- 转入账号/卡号
    ,nvl(n.reference, o.reference) as reference -- 转让流水号
    ,nvl(n.rec_time, o.rec_time) as rec_time -- 
    ,case when
            n.trf_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trf_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trf_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_dc_change_apply_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_dc_change_apply_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trf_no = n.trf_no
where (
        o.trf_no is null
    )
    or (
        n.trf_no is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_name <> n.client_name
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.res_seq_no <> n.res_seq_no
        or o.stage_code <> n.stage_code
        or o.last_change_date <> n.last_change_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.dep_keep_days <> n.dep_keep_days
        or o.int_rem_days <> n.int_rem_days
        or o.trf_total_settle_amt <> n.trf_total_settle_amt
        or o.trf_end_date <> n.trf_end_date
        or o.direction_trf_flag <> n.direction_trf_flag
        or o.order_start_date <> n.order_start_date
        or o.trf_in_fee_amt <> n.trf_in_fee_amt
        or o.order_end_date <> n.order_end_date
        or o.trf_pri_amt <> n.trf_pri_amt
        or o.trf_command <> n.trf_command
        or o.trf_rate <> n.trf_rate
        or o.trf_type <> n.trf_type
        or o.trf_status <> n.trf_status
        or o.beneficiary_client_no <> n.beneficiary_client_no
        or o.trf_date <> n.trf_date
        or o.beneficiary_profit_rate <> n.beneficiary_profit_rate
        or o.trf_out_fee_amt <> n.trf_out_fee_amt
        or o.prod_type <> n.prod_type
        or o.settle_acct_seq_no <> n.settle_acct_seq_no
        or o.settle_base_acct_no <> n.settle_base_acct_no
        or o.inner_base_acct_no <> n.inner_base_acct_no
        or o.reference <> n.reference
        or o.rec_time <> n.rec_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_change_apply_info_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,stage_code -- 期次代码
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,dep_keep_days -- 存款天数
            ,int_rem_days -- 计息剩余天数
            ,trf_total_settle_amt -- 转让总对价
            ,trf_end_date -- 转让到期日
            ,direction_trf_flag -- 是否定期转让
            ,order_start_date -- 挂单起始日期
            ,trf_in_fee_amt -- 转入费用
            ,order_end_date -- 挂单结束日期
            ,trf_pri_amt -- 转让本金金额
            ,trf_command -- 转让口令
            ,trf_rate -- 转让利率
            ,trf_type -- 转让类型
            ,trf_status -- 转让状态
            ,beneficiary_client_no -- 受益人客户号
            ,trf_no -- 转让号
            ,trf_date -- 转让日期
            ,beneficiary_profit_rate -- 受让人收益率
            ,trf_out_fee_amt -- 转出费用
            ,prod_type -- 产品编号|产品编号
            ,settle_acct_seq_no -- 结算账户序号|结算账户序号
            ,settle_base_acct_no -- 结算账号|结算账号
            ,inner_base_acct_no -- 转入账号/卡号
            ,reference -- 转让流水号
            ,rec_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_change_apply_info_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,stage_code -- 期次代码
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,dep_keep_days -- 存款天数
            ,int_rem_days -- 计息剩余天数
            ,trf_total_settle_amt -- 转让总对价
            ,trf_end_date -- 转让到期日
            ,direction_trf_flag -- 是否定期转让
            ,order_start_date -- 挂单起始日期
            ,trf_in_fee_amt -- 转入费用
            ,order_end_date -- 挂单结束日期
            ,trf_pri_amt -- 转让本金金额
            ,trf_command -- 转让口令
            ,trf_rate -- 转让利率
            ,trf_type -- 转让类型
            ,trf_status -- 转让状态
            ,beneficiary_client_no -- 受益人客户号
            ,trf_no -- 转让号
            ,trf_date -- 转让日期
            ,beneficiary_profit_rate -- 受让人收益率
            ,trf_out_fee_amt -- 转出费用
            ,prod_type -- 产品编号|产品编号
            ,settle_acct_seq_no -- 结算账户序号|结算账户序号
            ,settle_base_acct_no -- 结算账号|结算账号
            ,inner_base_acct_no -- 转入账号/卡号
            ,reference -- 转让流水号
            ,rec_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_name -- 客户名称
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.res_seq_no -- 限制编号
    ,o.stage_code -- 期次代码
    ,o.last_change_date -- 最后修改日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.dep_keep_days -- 存款天数
    ,o.int_rem_days -- 计息剩余天数
    ,o.trf_total_settle_amt -- 转让总对价
    ,o.trf_end_date -- 转让到期日
    ,o.direction_trf_flag -- 是否定期转让
    ,o.order_start_date -- 挂单起始日期
    ,o.trf_in_fee_amt -- 转入费用
    ,o.order_end_date -- 挂单结束日期
    ,o.trf_pri_amt -- 转让本金金额
    ,o.trf_command -- 转让口令
    ,o.trf_rate -- 转让利率
    ,o.trf_type -- 转让类型
    ,o.trf_status -- 转让状态
    ,o.beneficiary_client_no -- 受益人客户号
    ,o.trf_no -- 转让号
    ,o.trf_date -- 转让日期
    ,o.beneficiary_profit_rate -- 受让人收益率
    ,o.trf_out_fee_amt -- 转出费用
    ,o.prod_type -- 产品编号|产品编号
    ,o.settle_acct_seq_no -- 结算账户序号|结算账户序号
    ,o.settle_base_acct_no -- 结算账号|结算账号
    ,o.inner_base_acct_no -- 转入账号/卡号
    ,o.reference -- 转让流水号
    ,o.rec_time -- 
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
from ${iol_schema}.ncbs_rb_dc_change_apply_info_bk o
    left join ${iol_schema}.ncbs_rb_dc_change_apply_info_op n
        on
            o.trf_no = n.trf_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_dc_change_apply_info_cl d
        on
            o.trf_no = d.trf_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_dc_change_apply_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_dc_change_apply_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_dc_change_apply_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_dc_change_apply_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_dc_change_apply_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_dc_change_apply_info_cl;
alter table ${iol_schema}.ncbs_rb_dc_change_apply_info exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_dc_change_apply_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_dc_change_apply_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_change_apply_info_op purge;
drop table ${iol_schema}.ncbs_rb_dc_change_apply_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_dc_change_apply_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_dc_change_apply_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
