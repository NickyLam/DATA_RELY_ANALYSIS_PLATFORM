/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_client_exchange_rate_discount
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
create table ${iol_schema}.ncbs_rb_client_exchange_rate_discount_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_client_exchange_rate_discount
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_client_exchange_rate_discount_op purge;
drop table ${iol_schema}.ncbs_rb_client_exchange_rate_discount_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_client_exchange_rate_discount_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_client_exchange_rate_discount where 0=1;

create table ${iol_schema}.ncbs_rb_client_exchange_rate_discount_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_client_exchange_rate_discount where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_client_exchange_rate_discount_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,exchange_type -- 结售汇类型
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,apply_branch -- 申请机构
            ,unc_discount_value -- 平盘优惠值
            ,int_valid_from_date -- 利率优惠有效期起始日期
            ,int_valid_thru_date -- 利率优惠有效期截止日期
            ,discount_term -- 优惠期限
            ,discount_status -- 优惠状态
            ,exchange_discount_type -- 汇率优惠类型
            ,last_operate_status -- 上次操作状态
            ,discount_value -- 客户单户优惠值
            ,coupon_rate_type -- 优惠汇率类型
            ,int_rate_form_no -- 利率审批单单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_client_exchange_rate_discount_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,exchange_type -- 结售汇类型
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,apply_branch -- 申请机构
            ,unc_discount_value -- 平盘优惠值
            ,int_valid_from_date -- 利率优惠有效期起始日期
            ,int_valid_thru_date -- 利率优惠有效期截止日期
            ,discount_term -- 优惠期限
            ,discount_status -- 优惠状态
            ,exchange_discount_type -- 汇率优惠类型
            ,last_operate_status -- 上次操作状态
            ,discount_value -- 客户单户优惠值
            ,coupon_rate_type -- 优惠汇率类型
            ,int_rate_form_no -- 利率审批单单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.exchange_type, o.exchange_type) as exchange_type -- 结售汇类型
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.apply_branch, o.apply_branch) as apply_branch -- 申请机构
    ,nvl(n.unc_discount_value, o.unc_discount_value) as unc_discount_value -- 平盘优惠值
    ,nvl(n.int_valid_from_date, o.int_valid_from_date) as int_valid_from_date -- 利率优惠有效期起始日期
    ,nvl(n.int_valid_thru_date, o.int_valid_thru_date) as int_valid_thru_date -- 利率优惠有效期截止日期
    ,nvl(n.discount_term, o.discount_term) as discount_term -- 优惠期限
    ,nvl(n.discount_status, o.discount_status) as discount_status -- 优惠状态
    ,nvl(n.exchange_discount_type, o.exchange_discount_type) as exchange_discount_type -- 汇率优惠类型
    ,nvl(n.last_operate_status, o.last_operate_status) as last_operate_status -- 上次操作状态
    ,nvl(n.discount_value, o.discount_value) as discount_value -- 客户单户优惠值
    ,nvl(n.coupon_rate_type, o.coupon_rate_type) as coupon_rate_type -- 优惠汇率类型
    ,nvl(n.int_rate_form_no, o.int_rate_form_no) as int_rate_form_no -- 利率审批单单号
    ,case when
            n.ccy is null
            and n.client_no is null
            and n.apply_branch is null
            and n.coupon_rate_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ccy is null
            and n.client_no is null
            and n.apply_branch is null
            and n.coupon_rate_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ccy is null
            and n.client_no is null
            and n.apply_branch is null
            and n.coupon_rate_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_client_exchange_rate_discount_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_client_exchange_rate_discount where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ccy = n.ccy
            and o.client_no = n.client_no
            and o.apply_branch = n.apply_branch
            and o.coupon_rate_type = n.coupon_rate_type
where (
        o.ccy is null
        and o.client_no is null
        and o.apply_branch is null
        and o.coupon_rate_type is null
    )
    or (
        n.ccy is null
        and n.client_no is null
        and n.apply_branch is null
        and n.coupon_rate_type is null
    )
    or (
        o.branch <> n.branch
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.exchange_type <> n.exchange_type
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.unc_discount_value <> n.unc_discount_value
        or o.int_valid_from_date <> n.int_valid_from_date
        or o.int_valid_thru_date <> n.int_valid_thru_date
        or o.discount_term <> n.discount_term
        or o.discount_status <> n.discount_status
        or o.exchange_discount_type <> n.exchange_discount_type
        or o.last_operate_status <> n.last_operate_status
        or o.discount_value <> n.discount_value
        or o.int_rate_form_no <> n.int_rate_form_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_client_exchange_rate_discount_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,exchange_type -- 结售汇类型
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,apply_branch -- 申请机构
            ,unc_discount_value -- 平盘优惠值
            ,int_valid_from_date -- 利率优惠有效期起始日期
            ,int_valid_thru_date -- 利率优惠有效期截止日期
            ,discount_term -- 优惠期限
            ,discount_status -- 优惠状态
            ,exchange_discount_type -- 汇率优惠类型
            ,last_operate_status -- 上次操作状态
            ,discount_value -- 客户单户优惠值
            ,coupon_rate_type -- 优惠汇率类型
            ,int_rate_form_no -- 利率审批单单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_client_exchange_rate_discount_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,exchange_type -- 结售汇类型
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,apply_branch -- 申请机构
            ,unc_discount_value -- 平盘优惠值
            ,int_valid_from_date -- 利率优惠有效期起始日期
            ,int_valid_thru_date -- 利率优惠有效期截止日期
            ,discount_term -- 优惠期限
            ,discount_status -- 优惠状态
            ,exchange_discount_type -- 汇率优惠类型
            ,last_operate_status -- 上次操作状态
            ,discount_value -- 客户单户优惠值
            ,coupon_rate_type -- 优惠汇率类型
            ,int_rate_form_no -- 利率审批单单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.exchange_type -- 结售汇类型
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.apply_branch -- 申请机构
    ,o.unc_discount_value -- 平盘优惠值
    ,o.int_valid_from_date -- 利率优惠有效期起始日期
    ,o.int_valid_thru_date -- 利率优惠有效期截止日期
    ,o.discount_term -- 优惠期限
    ,o.discount_status -- 优惠状态
    ,o.exchange_discount_type -- 汇率优惠类型
    ,o.last_operate_status -- 上次操作状态
    ,o.discount_value -- 客户单户优惠值
    ,o.coupon_rate_type -- 优惠汇率类型
    ,o.int_rate_form_no -- 利率审批单单号
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
from ${iol_schema}.ncbs_rb_client_exchange_rate_discount_bk o
    left join ${iol_schema}.ncbs_rb_client_exchange_rate_discount_op n
        on
            o.ccy = n.ccy
            and o.client_no = n.client_no
            and o.apply_branch = n.apply_branch
            and o.coupon_rate_type = n.coupon_rate_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_client_exchange_rate_discount_cl d
        on
            o.ccy = d.ccy
            and o.client_no = d.client_no
            and o.apply_branch = d.apply_branch
            and o.coupon_rate_type = d.coupon_rate_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_client_exchange_rate_discount;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_client_exchange_rate_discount') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_client_exchange_rate_discount drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_client_exchange_rate_discount add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_client_exchange_rate_discount exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_client_exchange_rate_discount_cl;
alter table ${iol_schema}.ncbs_rb_client_exchange_rate_discount exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_client_exchange_rate_discount_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_client_exchange_rate_discount to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_client_exchange_rate_discount_op purge;
drop table ${iol_schema}.ncbs_rb_client_exchange_rate_discount_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_client_exchange_rate_discount_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_client_exchange_rate_discount',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
