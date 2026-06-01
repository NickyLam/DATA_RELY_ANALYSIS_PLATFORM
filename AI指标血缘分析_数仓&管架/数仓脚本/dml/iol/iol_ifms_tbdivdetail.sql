/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbdivdetail
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
create table ${iol_schema}.ifms_tbdivdetail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbdivdetail;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbdivdetail_op purge;
drop table ${iol_schema}.ifms_tbdivdetail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbdivdetail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbdivdetail where 0=1;

create table ${iol_schema}.ifms_tbdivdetail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbdivdetail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbdivdetail_cl(
            ta_code -- 
            ,cfm_date -- 
            ,cfm_no -- 
            ,busin_code -- 
            ,branch_no -- 
            ,open_branch -- 
            ,in_client_no -- 
            ,client_type -- 
            ,asset_acc -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,tot_vol -- 
            ,div_per_unit -- 
            ,div_mode -- 
            ,tot_div_amt -- 
            ,curr_type -- 
            ,cfm_amt -- 
            ,nav -- 
            ,div_vol -- 
            ,frozen_amt -- 
            ,frozen_vol -- 
            ,charge -- 
            ,agency_fee -- 
            ,stamp_tax -- 
            ,other_fee1 -- 
            ,other_fee2 -- 
            ,vol_cumulate -- 
            ,reg_date -- 
            ,div_date -- 
            ,xr_date -- 
            ,post_vol -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbdivdetail_op(
            ta_code -- 
            ,cfm_date -- 
            ,cfm_no -- 
            ,busin_code -- 
            ,branch_no -- 
            ,open_branch -- 
            ,in_client_no -- 
            ,client_type -- 
            ,asset_acc -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,tot_vol -- 
            ,div_per_unit -- 
            ,div_mode -- 
            ,tot_div_amt -- 
            ,curr_type -- 
            ,cfm_amt -- 
            ,nav -- 
            ,div_vol -- 
            ,frozen_amt -- 
            ,frozen_vol -- 
            ,charge -- 
            ,agency_fee -- 
            ,stamp_tax -- 
            ,other_fee1 -- 
            ,other_fee2 -- 
            ,vol_cumulate -- 
            ,reg_date -- 
            ,div_date -- 
            ,xr_date -- 
            ,post_vol -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 
    ,nvl(n.cfm_no, o.cfm_no) as cfm_no -- 
    ,nvl(n.busin_code, o.busin_code) as busin_code -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.client_no, o.client_no) as client_no -- 
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 
    ,nvl(n.ta_client, o.ta_client) as ta_client -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.tot_vol, o.tot_vol) as tot_vol -- 
    ,nvl(n.div_per_unit, o.div_per_unit) as div_per_unit -- 
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 
    ,nvl(n.tot_div_amt, o.tot_div_amt) as tot_div_amt -- 
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 
    ,nvl(n.cfm_amt, o.cfm_amt) as cfm_amt -- 
    ,nvl(n.nav, o.nav) as nav -- 
    ,nvl(n.div_vol, o.div_vol) as div_vol -- 
    ,nvl(n.frozen_amt, o.frozen_amt) as frozen_amt -- 
    ,nvl(n.frozen_vol, o.frozen_vol) as frozen_vol -- 
    ,nvl(n.charge, o.charge) as charge -- 
    ,nvl(n.agency_fee, o.agency_fee) as agency_fee -- 
    ,nvl(n.stamp_tax, o.stamp_tax) as stamp_tax -- 
    ,nvl(n.other_fee1, o.other_fee1) as other_fee1 -- 
    ,nvl(n.other_fee2, o.other_fee2) as other_fee2 -- 
    ,nvl(n.vol_cumulate, o.vol_cumulate) as vol_cumulate -- 
    ,nvl(n.reg_date, o.reg_date) as reg_date -- 
    ,nvl(n.div_date, o.div_date) as div_date -- 
    ,nvl(n.xr_date, o.xr_date) as xr_date -- 
    ,nvl(n.post_vol, o.post_vol) as post_vol -- 
    ,nvl(n.amt1, o.amt1) as amt1 -- 
    ,nvl(n.amt2, o.amt2) as amt2 -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,case when
            n.ta_code is null
            and n.cfm_date is null
            and n.cfm_no is null
            and n.ta_client is null
            and n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ta_code is null
            and n.cfm_date is null
            and n.cfm_no is null
            and n.ta_client is null
            and n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ta_code is null
            and n.cfm_date is null
            and n.cfm_no is null
            and n.ta_client is null
            and n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbdivdetail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbdivdetail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ta_code = n.ta_code
            and o.cfm_date = n.cfm_date
            and o.cfm_no = n.cfm_no
            and o.ta_client = n.ta_client
            and o.prd_code = n.prd_code
where (
        o.ta_code is null
        and o.cfm_date is null
        and o.cfm_no is null
        and o.ta_client is null
        and o.prd_code is null
    )
    or (
        n.ta_code is null
        and n.cfm_date is null
        and n.cfm_no is null
        and n.ta_client is null
        and n.prd_code is null
    )
    or (
        o.busin_code <> n.busin_code
        or o.branch_no <> n.branch_no
        or o.open_branch <> n.open_branch
        or o.in_client_no <> n.in_client_no
        or o.client_type <> n.client_type
        or o.asset_acc <> n.asset_acc
        or o.bank_no <> n.bank_no
        or o.client_no <> n.client_no
        or o.bank_acc <> n.bank_acc
        or o.tot_vol <> n.tot_vol
        or o.div_per_unit <> n.div_per_unit
        or o.div_mode <> n.div_mode
        or o.tot_div_amt <> n.tot_div_amt
        or o.curr_type <> n.curr_type
        or o.cfm_amt <> n.cfm_amt
        or o.nav <> n.nav
        or o.div_vol <> n.div_vol
        or o.frozen_amt <> n.frozen_amt
        or o.frozen_vol <> n.frozen_vol
        or o.charge <> n.charge
        or o.agency_fee <> n.agency_fee
        or o.stamp_tax <> n.stamp_tax
        or o.other_fee1 <> n.other_fee1
        or o.other_fee2 <> n.other_fee2
        or o.vol_cumulate <> n.vol_cumulate
        or o.reg_date <> n.reg_date
        or o.div_date <> n.div_date
        or o.xr_date <> n.xr_date
        or o.post_vol <> n.post_vol
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbdivdetail_cl(
            ta_code -- 
            ,cfm_date -- 
            ,cfm_no -- 
            ,busin_code -- 
            ,branch_no -- 
            ,open_branch -- 
            ,in_client_no -- 
            ,client_type -- 
            ,asset_acc -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,tot_vol -- 
            ,div_per_unit -- 
            ,div_mode -- 
            ,tot_div_amt -- 
            ,curr_type -- 
            ,cfm_amt -- 
            ,nav -- 
            ,div_vol -- 
            ,frozen_amt -- 
            ,frozen_vol -- 
            ,charge -- 
            ,agency_fee -- 
            ,stamp_tax -- 
            ,other_fee1 -- 
            ,other_fee2 -- 
            ,vol_cumulate -- 
            ,reg_date -- 
            ,div_date -- 
            ,xr_date -- 
            ,post_vol -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbdivdetail_op(
            ta_code -- 
            ,cfm_date -- 
            ,cfm_no -- 
            ,busin_code -- 
            ,branch_no -- 
            ,open_branch -- 
            ,in_client_no -- 
            ,client_type -- 
            ,asset_acc -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,tot_vol -- 
            ,div_per_unit -- 
            ,div_mode -- 
            ,tot_div_amt -- 
            ,curr_type -- 
            ,cfm_amt -- 
            ,nav -- 
            ,div_vol -- 
            ,frozen_amt -- 
            ,frozen_vol -- 
            ,charge -- 
            ,agency_fee -- 
            ,stamp_tax -- 
            ,other_fee1 -- 
            ,other_fee2 -- 
            ,vol_cumulate -- 
            ,reg_date -- 
            ,div_date -- 
            ,xr_date -- 
            ,post_vol -- 
            ,amt1 -- 
            ,amt2 -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_code -- 
    ,o.cfm_date -- 
    ,o.cfm_no -- 
    ,o.busin_code -- 
    ,o.branch_no -- 
    ,o.open_branch -- 
    ,o.in_client_no -- 
    ,o.client_type -- 
    ,o.asset_acc -- 
    ,o.bank_no -- 
    ,o.client_no -- 
    ,o.bank_acc -- 
    ,o.ta_client -- 
    ,o.prd_code -- 
    ,o.tot_vol -- 
    ,o.div_per_unit -- 
    ,o.div_mode -- 
    ,o.tot_div_amt -- 
    ,o.curr_type -- 
    ,o.cfm_amt -- 
    ,o.nav -- 
    ,o.div_vol -- 
    ,o.frozen_amt -- 
    ,o.frozen_vol -- 
    ,o.charge -- 
    ,o.agency_fee -- 
    ,o.stamp_tax -- 
    ,o.other_fee1 -- 
    ,o.other_fee2 -- 
    ,o.vol_cumulate -- 
    ,o.reg_date -- 
    ,o.div_date -- 
    ,o.xr_date -- 
    ,o.post_vol -- 
    ,o.amt1 -- 
    ,o.amt2 -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbdivdetail_bk o
    left join ${iol_schema}.ifms_tbdivdetail_op n
        on
            o.ta_code = n.ta_code
            and o.cfm_date = n.cfm_date
            and o.cfm_no = n.cfm_no
            and o.ta_client = n.ta_client
            and o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbdivdetail_cl d
        on
            o.ta_code = d.ta_code
            and o.cfm_date = d.cfm_date
            and o.cfm_no = d.cfm_no
            and o.ta_client = d.ta_client
            and o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbdivdetail;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbdivdetail exchange partition p_19000101 with table ${iol_schema}.ifms_tbdivdetail_cl;
alter table ${iol_schema}.ifms_tbdivdetail exchange partition p_20991231 with table ${iol_schema}.ifms_tbdivdetail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbdivdetail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbdivdetail_op purge;
drop table ${iol_schema}.ifms_tbdivdetail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbdivdetail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbdivdetail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
