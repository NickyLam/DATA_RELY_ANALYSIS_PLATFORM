/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_appr_letter_sub
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
create table ${iol_schema}.ncbs_rb_appr_letter_sub_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_appr_letter_sub
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_appr_letter_sub_op purge;
drop table ${iol_schema}.ncbs_rb_appr_letter_sub_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_appr_letter_sub_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_appr_letter_sub where 0=1;

create table ${iol_schema}.ncbs_rb_appr_letter_sub_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_appr_letter_sub where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_appr_letter_sub_cl(
            ccy -- 币种
            ,client_no -- 客户编号
            ,appr_letter_no -- 核准件编号
            ,company -- 法人
            ,main_sub_ind -- 核准件主子标志
            ,tran_timestamp -- 交易时间戳
            ,appr_limit_amt -- 核准件限额
            ,cr_total_amt -- 贷方总金额
            ,dr_total_amt -- 借方金额
            ,grace_amt -- 浮动金额
            ,grace_proportion -- 浮动比例
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_appr_letter_sub_op(
            ccy -- 币种
            ,client_no -- 客户编号
            ,appr_letter_no -- 核准件编号
            ,company -- 法人
            ,main_sub_ind -- 核准件主子标志
            ,tran_timestamp -- 交易时间戳
            ,appr_limit_amt -- 核准件限额
            ,cr_total_amt -- 贷方总金额
            ,dr_total_amt -- 借方金额
            ,grace_amt -- 浮动金额
            ,grace_proportion -- 浮动比例
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.appr_letter_no, o.appr_letter_no) as appr_letter_no -- 核准件编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.main_sub_ind, o.main_sub_ind) as main_sub_ind -- 核准件主子标志
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.appr_limit_amt, o.appr_limit_amt) as appr_limit_amt -- 核准件限额
    ,nvl(n.cr_total_amt, o.cr_total_amt) as cr_total_amt -- 贷方总金额
    ,nvl(n.dr_total_amt, o.dr_total_amt) as dr_total_amt -- 借方金额
    ,nvl(n.grace_amt, o.grace_amt) as grace_amt -- 浮动金额
    ,nvl(n.grace_proportion, o.grace_proportion) as grace_proportion -- 浮动比例
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.ccy is null
            and n.appr_letter_no is null
            and n.main_sub_ind is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ccy is null
            and n.appr_letter_no is null
            and n.main_sub_ind is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ccy is null
            and n.appr_letter_no is null
            and n.main_sub_ind is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_appr_letter_sub_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_appr_letter_sub where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ccy = n.ccy
            and o.appr_letter_no = n.appr_letter_no
            and o.main_sub_ind = n.main_sub_ind
where (
        o.ccy is null
        and o.appr_letter_no is null
        and o.main_sub_ind is null
    )
    or (
        n.ccy is null
        and n.appr_letter_no is null
        and n.main_sub_ind is null
    )
    or (
        o.client_no <> n.client_no
        or o.company <> n.company
        or o.tran_timestamp <> n.tran_timestamp
        or o.appr_limit_amt <> n.appr_limit_amt
        or o.cr_total_amt <> n.cr_total_amt
        or o.dr_total_amt <> n.dr_total_amt
        or o.grace_amt <> n.grace_amt
        or o.grace_proportion <> n.grace_proportion
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_appr_letter_sub_cl(
            ccy -- 币种
            ,client_no -- 客户编号
            ,appr_letter_no -- 核准件编号
            ,company -- 法人
            ,main_sub_ind -- 核准件主子标志
            ,tran_timestamp -- 交易时间戳
            ,appr_limit_amt -- 核准件限额
            ,cr_total_amt -- 贷方总金额
            ,dr_total_amt -- 借方金额
            ,grace_amt -- 浮动金额
            ,grace_proportion -- 浮动比例
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_appr_letter_sub_op(
            ccy -- 币种
            ,client_no -- 客户编号
            ,appr_letter_no -- 核准件编号
            ,company -- 法人
            ,main_sub_ind -- 核准件主子标志
            ,tran_timestamp -- 交易时间戳
            ,appr_limit_amt -- 核准件限额
            ,cr_total_amt -- 贷方总金额
            ,dr_total_amt -- 借方金额
            ,grace_amt -- 浮动金额
            ,grace_proportion -- 浮动比例
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.appr_letter_no -- 核准件编号
    ,o.company -- 法人
    ,o.main_sub_ind -- 核准件主子标志
    ,o.tran_timestamp -- 交易时间戳
    ,o.appr_limit_amt -- 核准件限额
    ,o.cr_total_amt -- 贷方总金额
    ,o.dr_total_amt -- 借方金额
    ,o.grace_amt -- 浮动金额
    ,o.grace_proportion -- 浮动比例
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
from ${iol_schema}.ncbs_rb_appr_letter_sub_bk o
    left join ${iol_schema}.ncbs_rb_appr_letter_sub_op n
        on
            o.ccy = n.ccy
            and o.appr_letter_no = n.appr_letter_no
            and o.main_sub_ind = n.main_sub_ind
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_appr_letter_sub_cl d
        on
            o.ccy = d.ccy
            and o.appr_letter_no = d.appr_letter_no
            and o.main_sub_ind = d.main_sub_ind
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_appr_letter_sub;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_appr_letter_sub') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_appr_letter_sub drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_appr_letter_sub add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_appr_letter_sub exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_appr_letter_sub_cl;
alter table ${iol_schema}.ncbs_rb_appr_letter_sub exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_appr_letter_sub_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_appr_letter_sub to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_appr_letter_sub_op purge;
drop table ${iol_schema}.ncbs_rb_appr_letter_sub_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_appr_letter_sub_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_appr_letter_sub',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
