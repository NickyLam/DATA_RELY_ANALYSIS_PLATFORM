/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbprddailyext
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
create table ${iol_schema}.ifms_tbprddailyext_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbprddailyext;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbprddailyext_op purge;
drop table ${iol_schema}.ifms_tbprddailyext_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbprddailyext_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbprddailyext where 0=1;

create table ${iol_schema}.ifms_tbprddailyext_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbprddailyext where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbprddailyext_cl(
            iss_date -- 
            ,cfm_date -- 
            ,prd_code -- 
            ,nav_flag -- 
            ,nav -- 
            ,tot_vol -- 
            ,status -- 
            ,prd_name -- 
            ,periodic_status -- 
            ,chg_agc_status -- 
            ,curr_type -- 
            ,announc_flag -- 
            ,div_mode -- 
            ,osubfirst_amt -- 
            ,osubfirst_vol -- 
            ,osubapp_amt -- 
            ,osubapp_vol -- 
            ,omaxsub_amt -- 
            ,omaxsub_vol -- 
            ,osubunit_amt -- 
            ,osubunit_vol -- 
            ,ofirst_amt -- 
            ,oapp_amt -- 
            ,omax_amt -- 
            ,omax_accu_amt -- 
            ,omax_accured_amt -- 
            ,omax_red_vol -- 
            ,psubfirst_amt -- 
            ,psubfirst_vol -- 
            ,psubapp_amt -- 
            ,psubapp_vol -- 
            ,pmaxsub_amt -- 
            ,pmaxsub_vol -- 
            ,psubunit_amt -- 
            ,psubunit_vol -- 
            ,pfirst_amt -- 
            ,papp_amt -- 
            ,pmax_amt -- 
            ,pmax_accu_amt -- 
            ,pmax_accured_amt -- 
            ,pmax_red_vol -- 
            ,max_red_vol -- 
            ,min_hold_vol -- 
            ,min_red_vol -- 
            ,min_conv_vol -- 
            ,piss_type -- 
            ,oiss_type -- 
            ,invest_amt -- 
            ,invest_date -- 
            ,prd_trustee -- 
            ,ipo_start_date -- 
            ,ipo_end_date -- 
            ,divident_date -- 
            ,reg_date -- 
            ,xr_date -- 
            ,sub_type -- 
            ,transfee_type -- 
            ,price -- 
            ,next_trade_date -- 
            ,value_line -- 
            ,total_bonus -- 
            ,fundincome_unit -- 
            ,fundincome_type -- 
            ,yield -- 
            ,yield_flag -- 
            ,guaranteed_nav -- 
            ,yearincome_rate -- 
            ,yearincome_flag -- 
            ,daily_income_flag -- 
            ,daily_income -- 
            ,breach_red_flag -- 
            ,fund_type -- 
            ,fund_type_name -- 
            ,prd_sponsor -- 
            ,ta_code -- 
            ,ta_name -- 
            ,prd_manager -- 
            ,prd_manager_name -- 
            ,service_tel -- 
            ,internet_address -- 
            ,monthincome_rate -- 
            ,monthincome_flag -- 
            ,quarter_rate -- 
            ,quarter_rate_flag -- 
            ,cycle_rate -- 
            ,cycle_rate_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,nav_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbprddailyext_op(
            iss_date -- 
            ,cfm_date -- 
            ,prd_code -- 
            ,nav_flag -- 
            ,nav -- 
            ,tot_vol -- 
            ,status -- 
            ,prd_name -- 
            ,periodic_status -- 
            ,chg_agc_status -- 
            ,curr_type -- 
            ,announc_flag -- 
            ,div_mode -- 
            ,osubfirst_amt -- 
            ,osubfirst_vol -- 
            ,osubapp_amt -- 
            ,osubapp_vol -- 
            ,omaxsub_amt -- 
            ,omaxsub_vol -- 
            ,osubunit_amt -- 
            ,osubunit_vol -- 
            ,ofirst_amt -- 
            ,oapp_amt -- 
            ,omax_amt -- 
            ,omax_accu_amt -- 
            ,omax_accured_amt -- 
            ,omax_red_vol -- 
            ,psubfirst_amt -- 
            ,psubfirst_vol -- 
            ,psubapp_amt -- 
            ,psubapp_vol -- 
            ,pmaxsub_amt -- 
            ,pmaxsub_vol -- 
            ,psubunit_amt -- 
            ,psubunit_vol -- 
            ,pfirst_amt -- 
            ,papp_amt -- 
            ,pmax_amt -- 
            ,pmax_accu_amt -- 
            ,pmax_accured_amt -- 
            ,pmax_red_vol -- 
            ,max_red_vol -- 
            ,min_hold_vol -- 
            ,min_red_vol -- 
            ,min_conv_vol -- 
            ,piss_type -- 
            ,oiss_type -- 
            ,invest_amt -- 
            ,invest_date -- 
            ,prd_trustee -- 
            ,ipo_start_date -- 
            ,ipo_end_date -- 
            ,divident_date -- 
            ,reg_date -- 
            ,xr_date -- 
            ,sub_type -- 
            ,transfee_type -- 
            ,price -- 
            ,next_trade_date -- 
            ,value_line -- 
            ,total_bonus -- 
            ,fundincome_unit -- 
            ,fundincome_type -- 
            ,yield -- 
            ,yield_flag -- 
            ,guaranteed_nav -- 
            ,yearincome_rate -- 
            ,yearincome_flag -- 
            ,daily_income_flag -- 
            ,daily_income -- 
            ,breach_red_flag -- 
            ,fund_type -- 
            ,fund_type_name -- 
            ,prd_sponsor -- 
            ,ta_code -- 
            ,ta_name -- 
            ,prd_manager -- 
            ,prd_manager_name -- 
            ,service_tel -- 
            ,internet_address -- 
            ,monthincome_rate -- 
            ,monthincome_flag -- 
            ,quarter_rate -- 
            ,quarter_rate_flag -- 
            ,cycle_rate -- 
            ,cycle_rate_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,nav_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.iss_date, o.iss_date) as iss_date -- 
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.nav_flag, o.nav_flag) as nav_flag -- 
    ,nvl(n.nav, o.nav) as nav -- 
    ,nvl(n.tot_vol, o.tot_vol) as tot_vol -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.prd_name, o.prd_name) as prd_name -- 
    ,nvl(n.periodic_status, o.periodic_status) as periodic_status -- 
    ,nvl(n.chg_agc_status, o.chg_agc_status) as chg_agc_status -- 
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 
    ,nvl(n.announc_flag, o.announc_flag) as announc_flag -- 
    ,nvl(n.div_mode, o.div_mode) as div_mode -- 
    ,nvl(n.osubfirst_amt, o.osubfirst_amt) as osubfirst_amt -- 
    ,nvl(n.osubfirst_vol, o.osubfirst_vol) as osubfirst_vol -- 
    ,nvl(n.osubapp_amt, o.osubapp_amt) as osubapp_amt -- 
    ,nvl(n.osubapp_vol, o.osubapp_vol) as osubapp_vol -- 
    ,nvl(n.omaxsub_amt, o.omaxsub_amt) as omaxsub_amt -- 
    ,nvl(n.omaxsub_vol, o.omaxsub_vol) as omaxsub_vol -- 
    ,nvl(n.osubunit_amt, o.osubunit_amt) as osubunit_amt -- 
    ,nvl(n.osubunit_vol, o.osubunit_vol) as osubunit_vol -- 
    ,nvl(n.ofirst_amt, o.ofirst_amt) as ofirst_amt -- 
    ,nvl(n.oapp_amt, o.oapp_amt) as oapp_amt -- 
    ,nvl(n.omax_amt, o.omax_amt) as omax_amt -- 
    ,nvl(n.omax_accu_amt, o.omax_accu_amt) as omax_accu_amt -- 
    ,nvl(n.omax_accured_amt, o.omax_accured_amt) as omax_accured_amt -- 
    ,nvl(n.omax_red_vol, o.omax_red_vol) as omax_red_vol -- 
    ,nvl(n.psubfirst_amt, o.psubfirst_amt) as psubfirst_amt -- 
    ,nvl(n.psubfirst_vol, o.psubfirst_vol) as psubfirst_vol -- 
    ,nvl(n.psubapp_amt, o.psubapp_amt) as psubapp_amt -- 
    ,nvl(n.psubapp_vol, o.psubapp_vol) as psubapp_vol -- 
    ,nvl(n.pmaxsub_amt, o.pmaxsub_amt) as pmaxsub_amt -- 
    ,nvl(n.pmaxsub_vol, o.pmaxsub_vol) as pmaxsub_vol -- 
    ,nvl(n.psubunit_amt, o.psubunit_amt) as psubunit_amt -- 
    ,nvl(n.psubunit_vol, o.psubunit_vol) as psubunit_vol -- 
    ,nvl(n.pfirst_amt, o.pfirst_amt) as pfirst_amt -- 
    ,nvl(n.papp_amt, o.papp_amt) as papp_amt -- 
    ,nvl(n.pmax_amt, o.pmax_amt) as pmax_amt -- 
    ,nvl(n.pmax_accu_amt, o.pmax_accu_amt) as pmax_accu_amt -- 
    ,nvl(n.pmax_accured_amt, o.pmax_accured_amt) as pmax_accured_amt -- 
    ,nvl(n.pmax_red_vol, o.pmax_red_vol) as pmax_red_vol -- 
    ,nvl(n.max_red_vol, o.max_red_vol) as max_red_vol -- 
    ,nvl(n.min_hold_vol, o.min_hold_vol) as min_hold_vol -- 
    ,nvl(n.min_red_vol, o.min_red_vol) as min_red_vol -- 
    ,nvl(n.min_conv_vol, o.min_conv_vol) as min_conv_vol -- 
    ,nvl(n.piss_type, o.piss_type) as piss_type -- 
    ,nvl(n.oiss_type, o.oiss_type) as oiss_type -- 
    ,nvl(n.invest_amt, o.invest_amt) as invest_amt -- 
    ,nvl(n.invest_date, o.invest_date) as invest_date -- 
    ,nvl(n.prd_trustee, o.prd_trustee) as prd_trustee -- 
    ,nvl(n.ipo_start_date, o.ipo_start_date) as ipo_start_date -- 
    ,nvl(n.ipo_end_date, o.ipo_end_date) as ipo_end_date -- 
    ,nvl(n.divident_date, o.divident_date) as divident_date -- 
    ,nvl(n.reg_date, o.reg_date) as reg_date -- 
    ,nvl(n.xr_date, o.xr_date) as xr_date -- 
    ,nvl(n.sub_type, o.sub_type) as sub_type -- 
    ,nvl(n.transfee_type, o.transfee_type) as transfee_type -- 
    ,nvl(n.price, o.price) as price -- 
    ,nvl(n.next_trade_date, o.next_trade_date) as next_trade_date -- 
    ,nvl(n.value_line, o.value_line) as value_line -- 
    ,nvl(n.total_bonus, o.total_bonus) as total_bonus -- 
    ,nvl(n.fundincome_unit, o.fundincome_unit) as fundincome_unit -- 
    ,nvl(n.fundincome_type, o.fundincome_type) as fundincome_type -- 
    ,nvl(n.yield, o.yield) as yield -- 
    ,nvl(n.yield_flag, o.yield_flag) as yield_flag -- 
    ,nvl(n.guaranteed_nav, o.guaranteed_nav) as guaranteed_nav -- 
    ,nvl(n.yearincome_rate, o.yearincome_rate) as yearincome_rate -- 
    ,nvl(n.yearincome_flag, o.yearincome_flag) as yearincome_flag -- 
    ,nvl(n.daily_income_flag, o.daily_income_flag) as daily_income_flag -- 
    ,nvl(n.daily_income, o.daily_income) as daily_income -- 
    ,nvl(n.breach_red_flag, o.breach_red_flag) as breach_red_flag -- 
    ,nvl(n.fund_type, o.fund_type) as fund_type -- 
    ,nvl(n.fund_type_name, o.fund_type_name) as fund_type_name -- 
    ,nvl(n.prd_sponsor, o.prd_sponsor) as prd_sponsor -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.ta_name, o.ta_name) as ta_name -- 
    ,nvl(n.prd_manager, o.prd_manager) as prd_manager -- 
    ,nvl(n.prd_manager_name, o.prd_manager_name) as prd_manager_name -- 
    ,nvl(n.service_tel, o.service_tel) as service_tel -- 
    ,nvl(n.internet_address, o.internet_address) as internet_address -- 
    ,nvl(n.monthincome_rate, o.monthincome_rate) as monthincome_rate -- 
    ,nvl(n.monthincome_flag, o.monthincome_flag) as monthincome_flag -- 
    ,nvl(n.quarter_rate, o.quarter_rate) as quarter_rate -- 
    ,nvl(n.quarter_rate_flag, o.quarter_rate_flag) as quarter_rate_flag -- 
    ,nvl(n.cycle_rate, o.cycle_rate) as cycle_rate -- 
    ,nvl(n.cycle_rate_flag, o.cycle_rate_flag) as cycle_rate_flag -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.nav_date, o.nav_date) as nav_date -- 
    ,case when
            n.iss_date is null
            and n.cfm_date is null
            and n.prd_code is null
            and n.nav_flag is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.iss_date is null
            and n.cfm_date is null
            and n.prd_code is null
            and n.nav_flag is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.iss_date is null
            and n.cfm_date is null
            and n.prd_code is null
            and n.nav_flag is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbprddailyext_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbprddailyext where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.iss_date = n.iss_date
            and o.cfm_date = n.cfm_date
            and o.prd_code = n.prd_code
            and o.nav_flag = n.nav_flag
where (
        o.iss_date is null
        and o.cfm_date is null
        and o.prd_code is null
        and o.nav_flag is null
    )
    or (
        n.iss_date is null
        and n.cfm_date is null
        and n.prd_code is null
        and n.nav_flag is null
    )
    or (
        o.nav <> n.nav
        or o.tot_vol <> n.tot_vol
        or o.status <> n.status
        or o.prd_name <> n.prd_name
        or o.periodic_status <> n.periodic_status
        or o.chg_agc_status <> n.chg_agc_status
        or o.curr_type <> n.curr_type
        or o.announc_flag <> n.announc_flag
        or o.div_mode <> n.div_mode
        or o.osubfirst_amt <> n.osubfirst_amt
        or o.osubfirst_vol <> n.osubfirst_vol
        or o.osubapp_amt <> n.osubapp_amt
        or o.osubapp_vol <> n.osubapp_vol
        or o.omaxsub_amt <> n.omaxsub_amt
        or o.omaxsub_vol <> n.omaxsub_vol
        or o.osubunit_amt <> n.osubunit_amt
        or o.osubunit_vol <> n.osubunit_vol
        or o.ofirst_amt <> n.ofirst_amt
        or o.oapp_amt <> n.oapp_amt
        or o.omax_amt <> n.omax_amt
        or o.omax_accu_amt <> n.omax_accu_amt
        or o.omax_accured_amt <> n.omax_accured_amt
        or o.omax_red_vol <> n.omax_red_vol
        or o.psubfirst_amt <> n.psubfirst_amt
        or o.psubfirst_vol <> n.psubfirst_vol
        or o.psubapp_amt <> n.psubapp_amt
        or o.psubapp_vol <> n.psubapp_vol
        or o.pmaxsub_amt <> n.pmaxsub_amt
        or o.pmaxsub_vol <> n.pmaxsub_vol
        or o.psubunit_amt <> n.psubunit_amt
        or o.psubunit_vol <> n.psubunit_vol
        or o.pfirst_amt <> n.pfirst_amt
        or o.papp_amt <> n.papp_amt
        or o.pmax_amt <> n.pmax_amt
        or o.pmax_accu_amt <> n.pmax_accu_amt
        or o.pmax_accured_amt <> n.pmax_accured_amt
        or o.pmax_red_vol <> n.pmax_red_vol
        or o.max_red_vol <> n.max_red_vol
        or o.min_hold_vol <> n.min_hold_vol
        or o.min_red_vol <> n.min_red_vol
        or o.min_conv_vol <> n.min_conv_vol
        or o.piss_type <> n.piss_type
        or o.oiss_type <> n.oiss_type
        or o.invest_amt <> n.invest_amt
        or o.invest_date <> n.invest_date
        or o.prd_trustee <> n.prd_trustee
        or o.ipo_start_date <> n.ipo_start_date
        or o.ipo_end_date <> n.ipo_end_date
        or o.divident_date <> n.divident_date
        or o.reg_date <> n.reg_date
        or o.xr_date <> n.xr_date
        or o.sub_type <> n.sub_type
        or o.transfee_type <> n.transfee_type
        or o.price <> n.price
        or o.next_trade_date <> n.next_trade_date
        or o.value_line <> n.value_line
        or o.total_bonus <> n.total_bonus
        or o.fundincome_unit <> n.fundincome_unit
        or o.fundincome_type <> n.fundincome_type
        or o.yield <> n.yield
        or o.yield_flag <> n.yield_flag
        or o.guaranteed_nav <> n.guaranteed_nav
        or o.yearincome_rate <> n.yearincome_rate
        or o.yearincome_flag <> n.yearincome_flag
        or o.daily_income_flag <> n.daily_income_flag
        or o.daily_income <> n.daily_income
        or o.breach_red_flag <> n.breach_red_flag
        or o.fund_type <> n.fund_type
        or o.fund_type_name <> n.fund_type_name
        or o.prd_sponsor <> n.prd_sponsor
        or o.ta_code <> n.ta_code
        or o.ta_name <> n.ta_name
        or o.prd_manager <> n.prd_manager
        or o.prd_manager_name <> n.prd_manager_name
        or o.service_tel <> n.service_tel
        or o.internet_address <> n.internet_address
        or o.monthincome_rate <> n.monthincome_rate
        or o.monthincome_flag <> n.monthincome_flag
        or o.quarter_rate <> n.quarter_rate
        or o.quarter_rate_flag <> n.quarter_rate_flag
        or o.cycle_rate <> n.cycle_rate
        or o.cycle_rate_flag <> n.cycle_rate_flag
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.nav_date <> n.nav_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbprddailyext_cl(
            iss_date -- 
            ,cfm_date -- 
            ,prd_code -- 
            ,nav_flag -- 
            ,nav -- 
            ,tot_vol -- 
            ,status -- 
            ,prd_name -- 
            ,periodic_status -- 
            ,chg_agc_status -- 
            ,curr_type -- 
            ,announc_flag -- 
            ,div_mode -- 
            ,osubfirst_amt -- 
            ,osubfirst_vol -- 
            ,osubapp_amt -- 
            ,osubapp_vol -- 
            ,omaxsub_amt -- 
            ,omaxsub_vol -- 
            ,osubunit_amt -- 
            ,osubunit_vol -- 
            ,ofirst_amt -- 
            ,oapp_amt -- 
            ,omax_amt -- 
            ,omax_accu_amt -- 
            ,omax_accured_amt -- 
            ,omax_red_vol -- 
            ,psubfirst_amt -- 
            ,psubfirst_vol -- 
            ,psubapp_amt -- 
            ,psubapp_vol -- 
            ,pmaxsub_amt -- 
            ,pmaxsub_vol -- 
            ,psubunit_amt -- 
            ,psubunit_vol -- 
            ,pfirst_amt -- 
            ,papp_amt -- 
            ,pmax_amt -- 
            ,pmax_accu_amt -- 
            ,pmax_accured_amt -- 
            ,pmax_red_vol -- 
            ,max_red_vol -- 
            ,min_hold_vol -- 
            ,min_red_vol -- 
            ,min_conv_vol -- 
            ,piss_type -- 
            ,oiss_type -- 
            ,invest_amt -- 
            ,invest_date -- 
            ,prd_trustee -- 
            ,ipo_start_date -- 
            ,ipo_end_date -- 
            ,divident_date -- 
            ,reg_date -- 
            ,xr_date -- 
            ,sub_type -- 
            ,transfee_type -- 
            ,price -- 
            ,next_trade_date -- 
            ,value_line -- 
            ,total_bonus -- 
            ,fundincome_unit -- 
            ,fundincome_type -- 
            ,yield -- 
            ,yield_flag -- 
            ,guaranteed_nav -- 
            ,yearincome_rate -- 
            ,yearincome_flag -- 
            ,daily_income_flag -- 
            ,daily_income -- 
            ,breach_red_flag -- 
            ,fund_type -- 
            ,fund_type_name -- 
            ,prd_sponsor -- 
            ,ta_code -- 
            ,ta_name -- 
            ,prd_manager -- 
            ,prd_manager_name -- 
            ,service_tel -- 
            ,internet_address -- 
            ,monthincome_rate -- 
            ,monthincome_flag -- 
            ,quarter_rate -- 
            ,quarter_rate_flag -- 
            ,cycle_rate -- 
            ,cycle_rate_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,nav_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbprddailyext_op(
            iss_date -- 
            ,cfm_date -- 
            ,prd_code -- 
            ,nav_flag -- 
            ,nav -- 
            ,tot_vol -- 
            ,status -- 
            ,prd_name -- 
            ,periodic_status -- 
            ,chg_agc_status -- 
            ,curr_type -- 
            ,announc_flag -- 
            ,div_mode -- 
            ,osubfirst_amt -- 
            ,osubfirst_vol -- 
            ,osubapp_amt -- 
            ,osubapp_vol -- 
            ,omaxsub_amt -- 
            ,omaxsub_vol -- 
            ,osubunit_amt -- 
            ,osubunit_vol -- 
            ,ofirst_amt -- 
            ,oapp_amt -- 
            ,omax_amt -- 
            ,omax_accu_amt -- 
            ,omax_accured_amt -- 
            ,omax_red_vol -- 
            ,psubfirst_amt -- 
            ,psubfirst_vol -- 
            ,psubapp_amt -- 
            ,psubapp_vol -- 
            ,pmaxsub_amt -- 
            ,pmaxsub_vol -- 
            ,psubunit_amt -- 
            ,psubunit_vol -- 
            ,pfirst_amt -- 
            ,papp_amt -- 
            ,pmax_amt -- 
            ,pmax_accu_amt -- 
            ,pmax_accured_amt -- 
            ,pmax_red_vol -- 
            ,max_red_vol -- 
            ,min_hold_vol -- 
            ,min_red_vol -- 
            ,min_conv_vol -- 
            ,piss_type -- 
            ,oiss_type -- 
            ,invest_amt -- 
            ,invest_date -- 
            ,prd_trustee -- 
            ,ipo_start_date -- 
            ,ipo_end_date -- 
            ,divident_date -- 
            ,reg_date -- 
            ,xr_date -- 
            ,sub_type -- 
            ,transfee_type -- 
            ,price -- 
            ,next_trade_date -- 
            ,value_line -- 
            ,total_bonus -- 
            ,fundincome_unit -- 
            ,fundincome_type -- 
            ,yield -- 
            ,yield_flag -- 
            ,guaranteed_nav -- 
            ,yearincome_rate -- 
            ,yearincome_flag -- 
            ,daily_income_flag -- 
            ,daily_income -- 
            ,breach_red_flag -- 
            ,fund_type -- 
            ,fund_type_name -- 
            ,prd_sponsor -- 
            ,ta_code -- 
            ,ta_name -- 
            ,prd_manager -- 
            ,prd_manager_name -- 
            ,service_tel -- 
            ,internet_address -- 
            ,monthincome_rate -- 
            ,monthincome_flag -- 
            ,quarter_rate -- 
            ,quarter_rate_flag -- 
            ,cycle_rate -- 
            ,cycle_rate_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,nav_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.iss_date -- 
    ,o.cfm_date -- 
    ,o.prd_code -- 
    ,o.nav_flag -- 
    ,o.nav -- 
    ,o.tot_vol -- 
    ,o.status -- 
    ,o.prd_name -- 
    ,o.periodic_status -- 
    ,o.chg_agc_status -- 
    ,o.curr_type -- 
    ,o.announc_flag -- 
    ,o.div_mode -- 
    ,o.osubfirst_amt -- 
    ,o.osubfirst_vol -- 
    ,o.osubapp_amt -- 
    ,o.osubapp_vol -- 
    ,o.omaxsub_amt -- 
    ,o.omaxsub_vol -- 
    ,o.osubunit_amt -- 
    ,o.osubunit_vol -- 
    ,o.ofirst_amt -- 
    ,o.oapp_amt -- 
    ,o.omax_amt -- 
    ,o.omax_accu_amt -- 
    ,o.omax_accured_amt -- 
    ,o.omax_red_vol -- 
    ,o.psubfirst_amt -- 
    ,o.psubfirst_vol -- 
    ,o.psubapp_amt -- 
    ,o.psubapp_vol -- 
    ,o.pmaxsub_amt -- 
    ,o.pmaxsub_vol -- 
    ,o.psubunit_amt -- 
    ,o.psubunit_vol -- 
    ,o.pfirst_amt -- 
    ,o.papp_amt -- 
    ,o.pmax_amt -- 
    ,o.pmax_accu_amt -- 
    ,o.pmax_accured_amt -- 
    ,o.pmax_red_vol -- 
    ,o.max_red_vol -- 
    ,o.min_hold_vol -- 
    ,o.min_red_vol -- 
    ,o.min_conv_vol -- 
    ,o.piss_type -- 
    ,o.oiss_type -- 
    ,o.invest_amt -- 
    ,o.invest_date -- 
    ,o.prd_trustee -- 
    ,o.ipo_start_date -- 
    ,o.ipo_end_date -- 
    ,o.divident_date -- 
    ,o.reg_date -- 
    ,o.xr_date -- 
    ,o.sub_type -- 
    ,o.transfee_type -- 
    ,o.price -- 
    ,o.next_trade_date -- 
    ,o.value_line -- 
    ,o.total_bonus -- 
    ,o.fundincome_unit -- 
    ,o.fundincome_type -- 
    ,o.yield -- 
    ,o.yield_flag -- 
    ,o.guaranteed_nav -- 
    ,o.yearincome_rate -- 
    ,o.yearincome_flag -- 
    ,o.daily_income_flag -- 
    ,o.daily_income -- 
    ,o.breach_red_flag -- 
    ,o.fund_type -- 
    ,o.fund_type_name -- 
    ,o.prd_sponsor -- 
    ,o.ta_code -- 
    ,o.ta_name -- 
    ,o.prd_manager -- 
    ,o.prd_manager_name -- 
    ,o.service_tel -- 
    ,o.internet_address -- 
    ,o.monthincome_rate -- 
    ,o.monthincome_flag -- 
    ,o.quarter_rate -- 
    ,o.quarter_rate_flag -- 
    ,o.cycle_rate -- 
    ,o.cycle_rate_flag -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.nav_date -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbprddailyext_bk o
    left join ${iol_schema}.ifms_tbprddailyext_op n
        on
            o.iss_date = n.iss_date
            and o.cfm_date = n.cfm_date
            and o.prd_code = n.prd_code
            and o.nav_flag = n.nav_flag
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbprddailyext_cl d
        on
            o.iss_date = d.iss_date
            and o.cfm_date = d.cfm_date
            and o.prd_code = d.prd_code
            and o.nav_flag = d.nav_flag
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbprddailyext;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbprddailyext exchange partition p_19000101 with table ${iol_schema}.ifms_tbprddailyext_cl;
alter table ${iol_schema}.ifms_tbprddailyext exchange partition p_20991231 with table ${iol_schema}.ifms_tbprddailyext_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbprddailyext to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbprddailyext_op purge;
drop table ${iol_schema}.ifms_tbprddailyext_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbprddailyext_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbprddailyext',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
