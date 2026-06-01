/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_hstctrans1_v_tbgrpsaleshare
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
create table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_op purge;
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare where 0=1;

create table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_cl(
            import_date -- 
            ,seller_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,virtual_bank_acc -- 
            ,ta_client -- 
            ,prd_type -- 
            ,cash_flag -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,prd_code -- 
            ,tot_vol -- 
            ,frozen_vol -- 
            ,long_frozen_vol -- 
            ,group_vol -- 
            ,div_mode -- 
            ,old_div_mode -- 
            ,div_rate -- 
            ,ystdy_tot_vol -- 
            ,open_branch -- 
            ,client_type -- 
            ,other_frozen -- 
            ,cost -- 
            ,prd_value -- 
            ,tot_income -- 
            ,onway_amt -- 
            ,profit_loss -- 
            ,income_onway -- 
            ,income_frozen -- 
            ,income_new -- 
            ,tot_amt -- 
            ,use_amt -- 
            ,income_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,in_client_no -- 
            ,modify_timestamp -- 
            ,group_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_op(
            import_date -- 
            ,seller_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,virtual_bank_acc -- 
            ,ta_client -- 
            ,prd_type -- 
            ,cash_flag -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,prd_code -- 
            ,tot_vol -- 
            ,frozen_vol -- 
            ,long_frozen_vol -- 
            ,group_vol -- 
            ,div_mode -- 
            ,old_div_mode -- 
            ,div_rate -- 
            ,ystdy_tot_vol -- 
            ,open_branch -- 
            ,client_type -- 
            ,other_frozen -- 
            ,cost -- 
            ,prd_value -- 
            ,tot_income -- 
            ,onway_amt -- 
            ,profit_loss -- 
            ,income_onway -- 
            ,income_frozen -- 
            ,income_new -- 
            ,tot_amt -- 
            ,use_amt -- 
            ,income_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,in_client_no -- 
            ,modify_timestamp -- 
            ,group_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.import_date, o.import_date) as import_date -- 
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.client_no, o.client_no) as client_no -- 
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 
    ,nvl(n.virtual_bank_acc, o.virtual_bank_acc) as virtual_bank_acc -- 
    ,nvl(n.ta_client, o.ta_client) as ta_client -- 
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 
    ,nvl(n.cash_flag, o.cash_flag) as cash_flag -- 
    ,nvl(n.trans_account_type, o.trans_account_type) as trans_account_type -- 
    ,nvl(n.trans_account, o.trans_account) as trans_account -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.tot_vol, o.tot_vol) as tot_vol -- 
    ,nvl(n.frozen_vol, o.frozen_vol) as frozen_vol -- 
    ,nvl(n.long_frozen_vol, o.long_frozen_vol) as long_frozen_vol -- 
    ,nvl(n.group_vol, o.group_vol) as group_vol -- 
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 
    ,nvl(n.old_div_mode, o.old_div_mode) as old_div_mode -- 
    ,nvl(n.div_rate, o.div_rate) as div_rate -- 
    ,nvl(n.ystdy_tot_vol, o.ystdy_tot_vol) as ystdy_tot_vol -- 
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.other_frozen, o.other_frozen) as other_frozen -- 
    ,nvl(n.cost, o.cost) as cost -- 
    ,nvl(n.prd_value, o.prd_value) as prd_value -- 
    ,nvl(n.tot_income, o.tot_income) as tot_income -- 
    ,nvl(n.onway_amt, o.onway_amt) as onway_amt -- 
    ,nvl(n.profit_loss, o.profit_loss) as profit_loss -- 
    ,nvl(n.income_onway, o.income_onway) as income_onway -- 
    ,nvl(n.income_frozen, o.income_frozen) as income_frozen -- 
    ,nvl(n.income_new, o.income_new) as income_new -- 
    ,nvl(n.tot_amt, o.tot_amt) as tot_amt -- 
    ,nvl(n.use_amt, o.use_amt) as use_amt -- 
    ,nvl(n.income_date, o.income_date) as income_date -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.modify_timestamp, o.modify_timestamp) as modify_timestamp -- 
    ,nvl(n.group_code, o.group_code) as group_code -- 
    ,case when
            n.import_date is null
            and n.seller_code is null
            and n.bank_no is null
            and n.virtual_bank_acc is null
            and n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.import_date is null
            and n.seller_code is null
            and n.bank_no is null
            and n.virtual_bank_acc is null
            and n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.import_date is null
            and n.seller_code is null
            and n.bank_no is null
            and n.virtual_bank_acc is null
            and n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_hstctrans1_v_tbgrpsaleshare where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.import_date = n.import_date
            and o.seller_code = n.seller_code
            and o.bank_no = n.bank_no
            and o.virtual_bank_acc = n.virtual_bank_acc
            and o.prd_code = n.prd_code
where (
        o.import_date is null
        and o.seller_code is null
        and o.bank_no is null
        and o.virtual_bank_acc is null
        and o.prd_code is null
    )
    or (
        n.import_date is null
        and n.seller_code is null
        and n.bank_no is null
        and n.virtual_bank_acc is null
        and n.prd_code is null
    )
    or (
        o.client_no <> n.client_no
        or o.bank_acc <> n.bank_acc
        or o.ta_client <> n.ta_client
        or o.prd_type <> n.prd_type
        or o.cash_flag <> n.cash_flag
        or o.trans_account_type <> n.trans_account_type
        or o.trans_account <> n.trans_account
        or o.ta_code <> n.ta_code
        or o.asset_acc <> n.asset_acc
        or o.tot_vol <> n.tot_vol
        or o.frozen_vol <> n.frozen_vol
        or o.long_frozen_vol <> n.long_frozen_vol
        or o.group_vol <> n.group_vol
        or o.div_mode <> n.div_mode
        or o.old_div_mode <> n.old_div_mode
        or o.div_rate <> n.div_rate
        or o.ystdy_tot_vol <> n.ystdy_tot_vol
        or o.open_branch <> n.open_branch
        or o.client_type <> n.client_type
        or o.other_frozen <> n.other_frozen
        or o.cost <> n.cost
        or o.prd_value <> n.prd_value
        or o.tot_income <> n.tot_income
        or o.onway_amt <> n.onway_amt
        or o.profit_loss <> n.profit_loss
        or o.income_onway <> n.income_onway
        or o.income_frozen <> n.income_frozen
        or o.income_new <> n.income_new
        or o.tot_amt <> n.tot_amt
        or o.use_amt <> n.use_amt
        or o.income_date <> n.income_date
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.in_client_no <> n.in_client_no
        or o.modify_timestamp <> n.modify_timestamp
        or o.group_code <> n.group_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_cl(
            import_date -- 
            ,seller_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,virtual_bank_acc -- 
            ,ta_client -- 
            ,prd_type -- 
            ,cash_flag -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,prd_code -- 
            ,tot_vol -- 
            ,frozen_vol -- 
            ,long_frozen_vol -- 
            ,group_vol -- 
            ,div_mode -- 
            ,old_div_mode -- 
            ,div_rate -- 
            ,ystdy_tot_vol -- 
            ,open_branch -- 
            ,client_type -- 
            ,other_frozen -- 
            ,cost -- 
            ,prd_value -- 
            ,tot_income -- 
            ,onway_amt -- 
            ,profit_loss -- 
            ,income_onway -- 
            ,income_frozen -- 
            ,income_new -- 
            ,tot_amt -- 
            ,use_amt -- 
            ,income_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,in_client_no -- 
            ,modify_timestamp -- 
            ,group_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_op(
            import_date -- 
            ,seller_code -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,virtual_bank_acc -- 
            ,ta_client -- 
            ,prd_type -- 
            ,cash_flag -- 
            ,trans_account_type -- 
            ,trans_account -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,prd_code -- 
            ,tot_vol -- 
            ,frozen_vol -- 
            ,long_frozen_vol -- 
            ,group_vol -- 
            ,div_mode -- 
            ,old_div_mode -- 
            ,div_rate -- 
            ,ystdy_tot_vol -- 
            ,open_branch -- 
            ,client_type -- 
            ,other_frozen -- 
            ,cost -- 
            ,prd_value -- 
            ,tot_income -- 
            ,onway_amt -- 
            ,profit_loss -- 
            ,income_onway -- 
            ,income_frozen -- 
            ,income_new -- 
            ,tot_amt -- 
            ,use_amt -- 
            ,income_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,reserve5 -- 
            ,in_client_no -- 
            ,modify_timestamp -- 
            ,group_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.import_date -- 
    ,o.seller_code -- 
    ,o.bank_no -- 
    ,o.client_no -- 
    ,o.bank_acc -- 
    ,o.virtual_bank_acc -- 
    ,o.ta_client -- 
    ,o.prd_type -- 
    ,o.cash_flag -- 
    ,o.trans_account_type -- 
    ,o.trans_account -- 
    ,o.ta_code -- 
    ,o.asset_acc -- 
    ,o.prd_code -- 
    ,o.tot_vol -- 
    ,o.frozen_vol -- 
    ,o.long_frozen_vol -- 
    ,o.group_vol -- 
    ,o.div_mode -- 
    ,o.old_div_mode -- 
    ,o.div_rate -- 
    ,o.ystdy_tot_vol -- 
    ,o.open_branch -- 
    ,o.client_type -- 
    ,o.other_frozen -- 
    ,o.cost -- 
    ,o.prd_value -- 
    ,o.tot_income -- 
    ,o.onway_amt -- 
    ,o.profit_loss -- 
    ,o.income_onway -- 
    ,o.income_frozen -- 
    ,o.income_new -- 
    ,o.tot_amt -- 
    ,o.use_amt -- 
    ,o.income_date -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.reserve4 -- 
    ,o.reserve5 -- 
    ,o.in_client_no -- 
    ,o.modify_timestamp -- 
    ,o.group_code -- 
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
from ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_bk o
    left join ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_op n
        on
            o.import_date = n.import_date
            and o.seller_code = n.seller_code
            and o.bank_no = n.bank_no
            and o.virtual_bank_acc = n.virtual_bank_acc
            and o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_cl d
        on
            o.import_date = d.import_date
            and o.seller_code = d.seller_code
            and o.bank_no = d.bank_no
            and o.virtual_bank_acc = d.virtual_bank_acc
            and o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nfss_hstctrans1_v_tbgrpsaleshare') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare exchange partition p_${batch_date} with table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_cl;
alter table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare exchange partition p_20991231 with table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_op purge;
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrpsaleshare_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_hstctrans1_v_tbgrpsaleshare',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
