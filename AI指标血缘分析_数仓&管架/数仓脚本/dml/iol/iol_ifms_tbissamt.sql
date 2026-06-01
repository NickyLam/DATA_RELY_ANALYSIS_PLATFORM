/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbissamt
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
create table ${iol_schema}.ifms_tbissamt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbissamt;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbissamt_op purge;
drop table ${iol_schema}.ifms_tbissamt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbissamt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbissamt where 0=1;

create table ${iol_schema}.ifms_tbissamt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbissamt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbissamt_cl(
            prd_code -- 
            ,branch_no -- 
            ,internal_branch -- 
            ,totsale_amt -- 
            ,person_amt -- 
            ,sale_pamt -- 
            ,allot_pamt -- 
            ,org_amt -- 
            ,sale_oamt -- 
            ,allot_oamt -- 
            ,adjust_amt -- 
            ,sadjust_pamt -- 
            ,sadjust_oamt -- 
            ,aadjust_amt -- 
            ,limitbook_amt -- 
            ,totbook_amt -- 
            ,sale_bamt -- 
            ,hold_amt -- 
            ,allot_hamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbissamt_op(
            prd_code -- 
            ,branch_no -- 
            ,internal_branch -- 
            ,totsale_amt -- 
            ,person_amt -- 
            ,sale_pamt -- 
            ,allot_pamt -- 
            ,org_amt -- 
            ,sale_oamt -- 
            ,allot_oamt -- 
            ,adjust_amt -- 
            ,sadjust_pamt -- 
            ,sadjust_oamt -- 
            ,aadjust_amt -- 
            ,limitbook_amt -- 
            ,totbook_amt -- 
            ,sale_bamt -- 
            ,hold_amt -- 
            ,allot_hamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.internal_branch, o.internal_branch) as internal_branch -- 
    ,nvl(n.totsale_amt, o.totsale_amt) as totsale_amt -- 
    ,nvl(n.person_amt, o.person_amt) as person_amt -- 
    ,nvl(n.sale_pamt, o.sale_pamt) as sale_pamt -- 
    ,nvl(n.allot_pamt, o.allot_pamt) as allot_pamt -- 
    ,nvl(n.org_amt, o.org_amt) as org_amt -- 
    ,nvl(n.sale_oamt, o.sale_oamt) as sale_oamt -- 
    ,nvl(n.allot_oamt, o.allot_oamt) as allot_oamt -- 
    ,nvl(n.adjust_amt, o.adjust_amt) as adjust_amt -- 
    ,nvl(n.sadjust_pamt, o.sadjust_pamt) as sadjust_pamt -- 
    ,nvl(n.sadjust_oamt, o.sadjust_oamt) as sadjust_oamt -- 
    ,nvl(n.aadjust_amt, o.aadjust_amt) as aadjust_amt -- 
    ,nvl(n.limitbook_amt, o.limitbook_amt) as limitbook_amt -- 
    ,nvl(n.totbook_amt, o.totbook_amt) as totbook_amt -- 
    ,nvl(n.sale_bamt, o.sale_bamt) as sale_bamt -- 
    ,nvl(n.hold_amt, o.hold_amt) as hold_amt -- 
    ,nvl(n.allot_hamt, o.allot_hamt) as allot_hamt -- 
    ,case when
            n.prd_code is null
            and n.branch_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_code is null
            and n.branch_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_code is null
            and n.branch_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbissamt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbissamt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_code = n.prd_code
            and o.branch_no = n.branch_no
where (
        o.prd_code is null
        and o.branch_no is null
    )
    or (
        n.prd_code is null
        and n.branch_no is null
    )
    or (
        o.internal_branch <> n.internal_branch
        or o.totsale_amt <> n.totsale_amt
        or o.person_amt <> n.person_amt
        or o.sale_pamt <> n.sale_pamt
        or o.allot_pamt <> n.allot_pamt
        or o.org_amt <> n.org_amt
        or o.sale_oamt <> n.sale_oamt
        or o.allot_oamt <> n.allot_oamt
        or o.adjust_amt <> n.adjust_amt
        or o.sadjust_pamt <> n.sadjust_pamt
        or o.sadjust_oamt <> n.sadjust_oamt
        or o.aadjust_amt <> n.aadjust_amt
        or o.limitbook_amt <> n.limitbook_amt
        or o.totbook_amt <> n.totbook_amt
        or o.sale_bamt <> n.sale_bamt
        or o.hold_amt <> n.hold_amt
        or o.allot_hamt <> n.allot_hamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbissamt_cl(
            prd_code -- 
            ,branch_no -- 
            ,internal_branch -- 
            ,totsale_amt -- 
            ,person_amt -- 
            ,sale_pamt -- 
            ,allot_pamt -- 
            ,org_amt -- 
            ,sale_oamt -- 
            ,allot_oamt -- 
            ,adjust_amt -- 
            ,sadjust_pamt -- 
            ,sadjust_oamt -- 
            ,aadjust_amt -- 
            ,limitbook_amt -- 
            ,totbook_amt -- 
            ,sale_bamt -- 
            ,hold_amt -- 
            ,allot_hamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbissamt_op(
            prd_code -- 
            ,branch_no -- 
            ,internal_branch -- 
            ,totsale_amt -- 
            ,person_amt -- 
            ,sale_pamt -- 
            ,allot_pamt -- 
            ,org_amt -- 
            ,sale_oamt -- 
            ,allot_oamt -- 
            ,adjust_amt -- 
            ,sadjust_pamt -- 
            ,sadjust_oamt -- 
            ,aadjust_amt -- 
            ,limitbook_amt -- 
            ,totbook_amt -- 
            ,sale_bamt -- 
            ,hold_amt -- 
            ,allot_hamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prd_code -- 
    ,o.branch_no -- 
    ,o.internal_branch -- 
    ,o.totsale_amt -- 
    ,o.person_amt -- 
    ,o.sale_pamt -- 
    ,o.allot_pamt -- 
    ,o.org_amt -- 
    ,o.sale_oamt -- 
    ,o.allot_oamt -- 
    ,o.adjust_amt -- 
    ,o.sadjust_pamt -- 
    ,o.sadjust_oamt -- 
    ,o.aadjust_amt -- 
    ,o.limitbook_amt -- 
    ,o.totbook_amt -- 
    ,o.sale_bamt -- 
    ,o.hold_amt -- 
    ,o.allot_hamt -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbissamt_bk o
    left join ${iol_schema}.ifms_tbissamt_op n
        on
            o.prd_code = n.prd_code
            and o.branch_no = n.branch_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbissamt_cl d
        on
            o.prd_code = d.prd_code
            and o.branch_no = d.branch_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbissamt;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbissamt exchange partition p_19000101 with table ${iol_schema}.ifms_tbissamt_cl;
alter table ${iol_schema}.ifms_tbissamt exchange partition p_20991231 with table ${iol_schema}.ifms_tbissamt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbissamt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbissamt_op purge;
drop table ${iol_schema}.ifms_tbissamt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbissamt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbissamt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
