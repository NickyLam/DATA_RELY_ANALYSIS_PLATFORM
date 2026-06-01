/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbshareinsure
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
create table ${iol_schema}.ifms_tbshareinsure_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbshareinsure;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbshareinsure_op purge;
drop table ${iol_schema}.ifms_tbshareinsure_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbshareinsure_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbshareinsure where 0=1;

create table ${iol_schema}.ifms_tbshareinsure_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbshareinsure where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbshareinsure_cl(
            ta_code -- 
            ,prd_code -- 
            ,insure_no -- 
            ,bank_no -- 
            ,insure_pwd -- 
            ,client_manager -- 
            ,client_no -- 
            ,holder_name -- 
            ,holder_id_type -- 
            ,holder_id_code -- 
            ,relation -- 
            ,insured_name -- 
            ,insured_id_type -- 
            ,insured_id_code -- 
            ,insure_print -- 
            ,insure_publish -- 
            ,invoice_no -- 
            ,internal_branch -- 
            ,branch_no -- 
            ,oper_no -- 
            ,trans_date -- 
            ,serial_no -- 
            ,insure_date -- 
            ,cfm_date -- 
            ,pay_year -- 
            ,insure_year_type -- 
            ,insure_year -- 
            ,effect_date -- 
            ,pay_type -- 
            ,pay_year_type -- 
            ,amt -- 
            ,insure_fee -- 
            ,bank_acc -- 
            ,vol -- 
            ,status -- 
            ,recommender -- 
            ,benici_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbshareinsure_op(
            ta_code -- 
            ,prd_code -- 
            ,insure_no -- 
            ,bank_no -- 
            ,insure_pwd -- 
            ,client_manager -- 
            ,client_no -- 
            ,holder_name -- 
            ,holder_id_type -- 
            ,holder_id_code -- 
            ,relation -- 
            ,insured_name -- 
            ,insured_id_type -- 
            ,insured_id_code -- 
            ,insure_print -- 
            ,insure_publish -- 
            ,invoice_no -- 
            ,internal_branch -- 
            ,branch_no -- 
            ,oper_no -- 
            ,trans_date -- 
            ,serial_no -- 
            ,insure_date -- 
            ,cfm_date -- 
            ,pay_year -- 
            ,insure_year_type -- 
            ,insure_year -- 
            ,effect_date -- 
            ,pay_type -- 
            ,pay_year_type -- 
            ,amt -- 
            ,insure_fee -- 
            ,bank_acc -- 
            ,vol -- 
            ,status -- 
            ,recommender -- 
            ,benici_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.insure_no, o.insure_no) as insure_no -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.insure_pwd, o.insure_pwd) as insure_pwd -- 
    ,nvl(n.client_manager, o.client_manager) as client_manager -- 
    ,nvl(n.client_no, o.client_no) as client_no -- 
    ,nvl(n.holder_name, o.holder_name) as holder_name -- 
    ,nvl(n.holder_id_type, o.holder_id_type) as holder_id_type -- 
    ,nvl(n.holder_id_code, o.holder_id_code) as holder_id_code -- 
    ,nvl(n.relation, o.relation) as relation -- 
    ,nvl(n.insured_name, o.insured_name) as insured_name -- 
    ,nvl(n.insured_id_type, o.insured_id_type) as insured_id_type -- 
    ,nvl(n.insured_id_code, o.insured_id_code) as insured_id_code -- 
    ,nvl(n.insure_print, o.insure_print) as insure_print -- 
    ,nvl(n.insure_publish, o.insure_publish) as insure_publish -- 
    ,nvl(n.invoice_no, o.invoice_no) as invoice_no -- 
    ,nvl(n.internal_branch, o.internal_branch) as internal_branch -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.oper_no, o.oper_no) as oper_no -- 
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 
    ,nvl(n.insure_date, o.insure_date) as insure_date -- 
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 
    ,nvl(n.pay_year, o.pay_year) as pay_year -- 
    ,nvl(n.insure_year_type, o.insure_year_type) as insure_year_type -- 
    ,nvl(n.insure_year, o.insure_year) as insure_year -- 
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 
    ,nvl(n.pay_year_type, o.pay_year_type) as pay_year_type -- 
    ,nvl(n.amt, o.amt) as amt -- 
    ,nvl(n.insure_fee, o.insure_fee) as insure_fee -- 
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 
    ,nvl(n.vol, o.vol) as vol -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.recommender, o.recommender) as recommender -- 
    ,nvl(n.benici_flag, o.benici_flag) as benici_flag -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,case when
            n.ta_code is null
            and n.prd_code is null
            and n.insure_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ta_code is null
            and n.prd_code is null
            and n.insure_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ta_code is null
            and n.prd_code is null
            and n.insure_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbshareinsure_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbshareinsure where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ta_code = n.ta_code
            and o.prd_code = n.prd_code
            and o.insure_no = n.insure_no
where (
        o.ta_code is null
        and o.prd_code is null
        and o.insure_no is null
    )
    or (
        n.ta_code is null
        and n.prd_code is null
        and n.insure_no is null
    )
    or (
        o.bank_no <> n.bank_no
        or o.insure_pwd <> n.insure_pwd
        or o.client_manager <> n.client_manager
        or o.client_no <> n.client_no
        or o.holder_name <> n.holder_name
        or o.holder_id_type <> n.holder_id_type
        or o.holder_id_code <> n.holder_id_code
        or o.relation <> n.relation
        or o.insured_name <> n.insured_name
        or o.insured_id_type <> n.insured_id_type
        or o.insured_id_code <> n.insured_id_code
        or o.insure_print <> n.insure_print
        or o.insure_publish <> n.insure_publish
        or o.invoice_no <> n.invoice_no
        or o.internal_branch <> n.internal_branch
        or o.branch_no <> n.branch_no
        or o.oper_no <> n.oper_no
        or o.trans_date <> n.trans_date
        or o.serial_no <> n.serial_no
        or o.insure_date <> n.insure_date
        or o.cfm_date <> n.cfm_date
        or o.pay_year <> n.pay_year
        or o.insure_year_type <> n.insure_year_type
        or o.insure_year <> n.insure_year
        or o.effect_date <> n.effect_date
        or o.pay_type <> n.pay_type
        or o.pay_year_type <> n.pay_year_type
        or o.amt <> n.amt
        or o.insure_fee <> n.insure_fee
        or o.bank_acc <> n.bank_acc
        or o.vol <> n.vol
        or o.status <> n.status
        or o.recommender <> n.recommender
        or o.benici_flag <> n.benici_flag
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbshareinsure_cl(
            ta_code -- 
            ,prd_code -- 
            ,insure_no -- 
            ,bank_no -- 
            ,insure_pwd -- 
            ,client_manager -- 
            ,client_no -- 
            ,holder_name -- 
            ,holder_id_type -- 
            ,holder_id_code -- 
            ,relation -- 
            ,insured_name -- 
            ,insured_id_type -- 
            ,insured_id_code -- 
            ,insure_print -- 
            ,insure_publish -- 
            ,invoice_no -- 
            ,internal_branch -- 
            ,branch_no -- 
            ,oper_no -- 
            ,trans_date -- 
            ,serial_no -- 
            ,insure_date -- 
            ,cfm_date -- 
            ,pay_year -- 
            ,insure_year_type -- 
            ,insure_year -- 
            ,effect_date -- 
            ,pay_type -- 
            ,pay_year_type -- 
            ,amt -- 
            ,insure_fee -- 
            ,bank_acc -- 
            ,vol -- 
            ,status -- 
            ,recommender -- 
            ,benici_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbshareinsure_op(
            ta_code -- 
            ,prd_code -- 
            ,insure_no -- 
            ,bank_no -- 
            ,insure_pwd -- 
            ,client_manager -- 
            ,client_no -- 
            ,holder_name -- 
            ,holder_id_type -- 
            ,holder_id_code -- 
            ,relation -- 
            ,insured_name -- 
            ,insured_id_type -- 
            ,insured_id_code -- 
            ,insure_print -- 
            ,insure_publish -- 
            ,invoice_no -- 
            ,internal_branch -- 
            ,branch_no -- 
            ,oper_no -- 
            ,trans_date -- 
            ,serial_no -- 
            ,insure_date -- 
            ,cfm_date -- 
            ,pay_year -- 
            ,insure_year_type -- 
            ,insure_year -- 
            ,effect_date -- 
            ,pay_type -- 
            ,pay_year_type -- 
            ,amt -- 
            ,insure_fee -- 
            ,bank_acc -- 
            ,vol -- 
            ,status -- 
            ,recommender -- 
            ,benici_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_code -- 
    ,o.prd_code -- 
    ,o.insure_no -- 
    ,o.bank_no -- 
    ,o.insure_pwd -- 
    ,o.client_manager -- 
    ,o.client_no -- 
    ,o.holder_name -- 
    ,o.holder_id_type -- 
    ,o.holder_id_code -- 
    ,o.relation -- 
    ,o.insured_name -- 
    ,o.insured_id_type -- 
    ,o.insured_id_code -- 
    ,o.insure_print -- 
    ,o.insure_publish -- 
    ,o.invoice_no -- 
    ,o.internal_branch -- 
    ,o.branch_no -- 
    ,o.oper_no -- 
    ,o.trans_date -- 
    ,o.serial_no -- 
    ,o.insure_date -- 
    ,o.cfm_date -- 
    ,o.pay_year -- 
    ,o.insure_year_type -- 
    ,o.insure_year -- 
    ,o.effect_date -- 
    ,o.pay_type -- 
    ,o.pay_year_type -- 
    ,o.amt -- 
    ,o.insure_fee -- 
    ,o.bank_acc -- 
    ,o.vol -- 
    ,o.status -- 
    ,o.recommender -- 
    ,o.benici_flag -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbshareinsure_bk o
    left join ${iol_schema}.ifms_tbshareinsure_op n
        on
            o.ta_code = n.ta_code
            and o.prd_code = n.prd_code
            and o.insure_no = n.insure_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbshareinsure_cl d
        on
            o.ta_code = d.ta_code
            and o.prd_code = d.prd_code
            and o.insure_no = d.insure_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbshareinsure;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbshareinsure exchange partition p_19000101 with table ${iol_schema}.ifms_tbshareinsure_cl;
alter table ${iol_schema}.ifms_tbshareinsure exchange partition p_20991231 with table ${iol_schema}.ifms_tbshareinsure_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbshareinsure to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbshareinsure_op purge;
drop table ${iol_schema}.ifms_tbshareinsure_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbshareinsure_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbshareinsure',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
