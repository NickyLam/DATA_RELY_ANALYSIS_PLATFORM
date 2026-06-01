/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ba_exp_cash_h_bdmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ba_exp_cash_h add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ba_exp_cash_h partition for ('bdmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    cash_id -- 兑付编号
    ,lp_id -- 法人编号
    ,appl_id -- 申请编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,cash_way_type_cd -- 兑付方式类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_deduct_amt -- 保证金扣取金额
    ,cust_acct_id -- 客户账户编号
    ,cust_acct_deduct_amt -- 客户账户扣取金额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ba_exp_cash_h partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ba_exp_cash_h partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ba_exp_cash_h partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_bms_accept_method-
insert into ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_tm(
    cash_id -- 兑付编号
    ,lp_id -- 法人编号
    ,appl_id -- 申请编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,cash_way_type_cd -- 兑付方式类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_deduct_amt -- 保证金扣取金额
    ,cust_acct_id -- 客户账户编号
    ,cust_acct_deduct_amt -- 客户账户扣取金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 兑付编号
    ,'9999' -- 法人编号
    ,P1.ACCEPT_ID -- 申请编号
    ,P1.DRAFT_ID -- 票据编号
    ,'101008'||P1.DRAFT_ID -- 凭证编号
    ,nvl(trim(P1.ACCEPT_TYPE),'-') -- 兑付方式类型代码
    ,P1.BAIL_ACCOUNT -- 保证金账户编号
    ,P1.BAIL_REDUCE_AMOUNT -- 保证金扣取金额
    ,P1.CUSTOMER_ACCOUNT -- 客户账户编号
    ,P1.CUSTOMER_REDUCE_AMOUNT -- 客户账户扣取金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_accept_method' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_accept_method p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_tm 
  	                                group by 
  	                                        cash_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_cl(
            cash_id -- 兑付编号
    ,lp_id -- 法人编号
    ,appl_id -- 申请编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,cash_way_type_cd -- 兑付方式类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_deduct_amt -- 保证金扣取金额
    ,cust_acct_id -- 客户账户编号
    ,cust_acct_deduct_amt -- 客户账户扣取金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_op(
            cash_id -- 兑付编号
    ,lp_id -- 法人编号
    ,appl_id -- 申请编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,cash_way_type_cd -- 兑付方式类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_deduct_amt -- 保证金扣取金额
    ,cust_acct_id -- 客户账户编号
    ,cust_acct_deduct_amt -- 客户账户扣取金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cash_id, o.cash_id) as cash_id -- 兑付编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.cash_way_type_cd, o.cash_way_type_cd) as cash_way_type_cd -- 兑付方式类型代码
    ,nvl(n.margin_acct_id, o.margin_acct_id) as margin_acct_id -- 保证金账户编号
    ,nvl(n.margin_deduct_amt, o.margin_deduct_amt) as margin_deduct_amt -- 保证金扣取金额
    ,nvl(n.cust_acct_id, o.cust_acct_id) as cust_acct_id -- 客户账户编号
    ,nvl(n.cust_acct_deduct_amt, o.cust_acct_deduct_amt) as cust_acct_deduct_amt -- 客户账户扣取金额
    ,case when
            n.cash_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cash_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cash_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.cash_id = n.cash_id
            and o.lp_id = n.lp_id
where (
        o.cash_id is null
        and o.lp_id is null
    )
    or (
        n.cash_id is null
        and n.lp_id is null
    )
    or (
        o.appl_id <> n.appl_id
        or o.bill_id <> n.bill_id
        or o.vouch_id <> n.vouch_id
        or o.cash_way_type_cd <> n.cash_way_type_cd
        or o.margin_acct_id <> n.margin_acct_id
        or o.margin_deduct_amt <> n.margin_deduct_amt
        or o.cust_acct_id <> n.cust_acct_id
        or o.cust_acct_deduct_amt <> n.cust_acct_deduct_amt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_cl(
            cash_id -- 兑付编号
    ,lp_id -- 法人编号
    ,appl_id -- 申请编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,cash_way_type_cd -- 兑付方式类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_deduct_amt -- 保证金扣取金额
    ,cust_acct_id -- 客户账户编号
    ,cust_acct_deduct_amt -- 客户账户扣取金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_op(
            cash_id -- 兑付编号
    ,lp_id -- 法人编号
    ,appl_id -- 申请编号
    ,bill_id -- 票据编号
    ,vouch_id -- 凭证编号
    ,cash_way_type_cd -- 兑付方式类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_deduct_amt -- 保证金扣取金额
    ,cust_acct_id -- 客户账户编号
    ,cust_acct_deduct_amt -- 客户账户扣取金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cash_id -- 兑付编号
    ,o.lp_id -- 法人编号
    ,o.appl_id -- 申请编号
    ,o.bill_id -- 票据编号
    ,o.vouch_id -- 凭证编号
    ,o.cash_way_type_cd -- 兑付方式类型代码
    ,o.margin_acct_id -- 保证金账户编号
    ,o.margin_deduct_amt -- 保证金扣取金额
    ,o.cust_acct_id -- 客户账户编号
    ,o.cust_acct_deduct_amt -- 客户账户扣取金额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_bk o
    left join ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_op n
        on
            o.cash_id = n.cash_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_cl d
        on
            o.cash_id = d.cash_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ba_exp_cash_h;
alter table ${iml_schema}.agt_ba_exp_cash_h truncate partition for ('bdmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_ba_exp_cash_h exchange subpartition p_bdmsf1_19000101 with table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_cl;
alter table ${iml_schema}.agt_ba_exp_cash_h exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ba_exp_cash_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ba_exp_cash_h_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ba_exp_cash_h', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
