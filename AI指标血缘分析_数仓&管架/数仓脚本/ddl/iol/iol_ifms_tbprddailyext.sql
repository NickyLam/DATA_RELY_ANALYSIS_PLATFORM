/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbprddailyext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbprddailyext
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbprddailyext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbprddailyext(
    iss_date number(22) -- 
    ,cfm_date number(22) -- 
    ,prd_code varchar2(30) -- 
    ,nav_flag varchar2(2) -- 
    ,nav number(18,8) -- 
    ,tot_vol number(18,3) -- 
    ,status varchar2(2) -- 
    ,prd_name varchar2(375) -- 
    ,periodic_status varchar2(2) -- 
    ,chg_agc_status varchar2(2) -- 
    ,curr_type varchar2(5) -- 
    ,announc_flag varchar2(2) -- 
    ,div_mode varchar2(2) -- 
    ,osubfirst_amt number(18,2) -- 
    ,osubfirst_vol number(18,2) -- 
    ,osubapp_amt number(18,2) -- 
    ,osubapp_vol number(18,2) -- 
    ,omaxsub_amt number(18,2) -- 
    ,omaxsub_vol number(18,2) -- 
    ,osubunit_amt number(18,2) -- 
    ,osubunit_vol number(18,2) -- 
    ,ofirst_amt number(18,2) -- 
    ,oapp_amt number(18,2) -- 
    ,omax_amt number(18,2) -- 
    ,omax_accu_amt number(18,2) -- 
    ,omax_accured_amt number(18,2) -- 
    ,omax_red_vol number(18,2) -- 
    ,psubfirst_amt number(18,2) -- 
    ,psubfirst_vol number(18,2) -- 
    ,psubapp_amt number(18,2) -- 
    ,psubapp_vol number(18,2) -- 
    ,pmaxsub_amt number(18,2) -- 
    ,pmaxsub_vol number(18,2) -- 
    ,psubunit_amt number(18,2) -- 
    ,psubunit_vol number(18,2) -- 
    ,pfirst_amt number(18,2) -- 
    ,papp_amt number(18,2) -- 
    ,pmax_amt number(18,2) -- 
    ,pmax_accu_amt number(18,2) -- 
    ,pmax_accured_amt number(18,2) -- 
    ,pmax_red_vol number(18,2) -- 
    ,max_red_vol number(18,2) -- 
    ,min_hold_vol number(18,2) -- 
    ,min_red_vol number(18,2) -- 
    ,min_conv_vol number(18,2) -- 
    ,piss_type varchar2(2) -- 
    ,oiss_type varchar2(2) -- 
    ,invest_amt number(18,2) -- 
    ,invest_date number(22) -- 
    ,prd_trustee varchar2(5) -- 
    ,ipo_start_date number(22) -- 
    ,ipo_end_date number(22) -- 
    ,divident_date number(22) -- 
    ,reg_date number(22) -- 
    ,xr_date number(22) -- 
    ,sub_type varchar2(2) -- 
    ,transfee_type varchar2(2) -- 
    ,price number(18,8) -- 
    ,next_trade_date number(22) -- 
    ,value_line number(7,2) -- 
    ,total_bonus number(18,8) -- 
    ,fundincome_unit number(18,8) -- 
    ,fundincome_type varchar2(2) -- 
    ,yield number(18,8) -- 
    ,yield_flag varchar2(2) -- 
    ,guaranteed_nav number(18,8) -- 
    ,yearincome_rate number(18,8) -- 
    ,yearincome_flag varchar2(2) -- 
    ,daily_income_flag varchar2(2) -- 
    ,daily_income number(18,2) -- 
    ,breach_red_flag varchar2(2) -- 
    ,fund_type varchar2(2) -- 
    ,fund_type_name varchar2(375) -- 
    ,prd_sponsor varchar2(5) -- 
    ,ta_code varchar2(14) -- 
    ,ta_name varchar2(375) -- 
    ,prd_manager varchar2(9) -- 
    ,prd_manager_name varchar2(375) -- 
    ,service_tel varchar2(45) -- 
    ,internet_address varchar2(375) -- 
    ,monthincome_rate number(18,8) -- 
    ,monthincome_flag varchar2(2) -- 
    ,quarter_rate number(18,8) -- 
    ,quarter_rate_flag varchar2(2) -- 
    ,cycle_rate number(18,8) -- 
    ,cycle_rate_flag varchar2(2) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
    ,reserve3 varchar2(375) -- 
    ,nav_date number(22,0) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifms_tbprddailyext to ${iml_schema};
grant select on ${iol_schema}.ifms_tbprddailyext to ${icl_schema};
grant select on ${iol_schema}.ifms_tbprddailyext to ${idl_schema};
grant select on ${iol_schema}.ifms_tbprddailyext to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbprddailyext is '产品日信息扩展表';
comment on column ${iol_schema}.ifms_tbprddailyext.iss_date is '';
comment on column ${iol_schema}.ifms_tbprddailyext.cfm_date is '';
comment on column ${iol_schema}.ifms_tbprddailyext.prd_code is '';
comment on column ${iol_schema}.ifms_tbprddailyext.nav_flag is '';
comment on column ${iol_schema}.ifms_tbprddailyext.nav is '';
comment on column ${iol_schema}.ifms_tbprddailyext.tot_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.status is '';
comment on column ${iol_schema}.ifms_tbprddailyext.prd_name is '';
comment on column ${iol_schema}.ifms_tbprddailyext.periodic_status is '';
comment on column ${iol_schema}.ifms_tbprddailyext.chg_agc_status is '';
comment on column ${iol_schema}.ifms_tbprddailyext.curr_type is '';
comment on column ${iol_schema}.ifms_tbprddailyext.announc_flag is '';
comment on column ${iol_schema}.ifms_tbprddailyext.div_mode is '';
comment on column ${iol_schema}.ifms_tbprddailyext.osubfirst_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.osubfirst_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.osubapp_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.osubapp_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.omaxsub_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.omaxsub_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.osubunit_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.osubunit_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.ofirst_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.oapp_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.omax_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.omax_accu_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.omax_accured_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.omax_red_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.psubfirst_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.psubfirst_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.psubapp_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.psubapp_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.pmaxsub_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.pmaxsub_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.psubunit_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.psubunit_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.pfirst_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.papp_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.pmax_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.pmax_accu_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.pmax_accured_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.pmax_red_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.max_red_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.min_hold_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.min_red_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.min_conv_vol is '';
comment on column ${iol_schema}.ifms_tbprddailyext.piss_type is '';
comment on column ${iol_schema}.ifms_tbprddailyext.oiss_type is '';
comment on column ${iol_schema}.ifms_tbprddailyext.invest_amt is '';
comment on column ${iol_schema}.ifms_tbprddailyext.invest_date is '';
comment on column ${iol_schema}.ifms_tbprddailyext.prd_trustee is '';
comment on column ${iol_schema}.ifms_tbprddailyext.ipo_start_date is '';
comment on column ${iol_schema}.ifms_tbprddailyext.ipo_end_date is '';
comment on column ${iol_schema}.ifms_tbprddailyext.divident_date is '';
comment on column ${iol_schema}.ifms_tbprddailyext.reg_date is '';
comment on column ${iol_schema}.ifms_tbprddailyext.xr_date is '';
comment on column ${iol_schema}.ifms_tbprddailyext.sub_type is '';
comment on column ${iol_schema}.ifms_tbprddailyext.transfee_type is '';
comment on column ${iol_schema}.ifms_tbprddailyext.price is '';
comment on column ${iol_schema}.ifms_tbprddailyext.next_trade_date is '';
comment on column ${iol_schema}.ifms_tbprddailyext.value_line is '';
comment on column ${iol_schema}.ifms_tbprddailyext.total_bonus is '';
comment on column ${iol_schema}.ifms_tbprddailyext.fundincome_unit is '';
comment on column ${iol_schema}.ifms_tbprddailyext.fundincome_type is '';
comment on column ${iol_schema}.ifms_tbprddailyext.yield is '';
comment on column ${iol_schema}.ifms_tbprddailyext.yield_flag is '';
comment on column ${iol_schema}.ifms_tbprddailyext.guaranteed_nav is '';
comment on column ${iol_schema}.ifms_tbprddailyext.yearincome_rate is '';
comment on column ${iol_schema}.ifms_tbprddailyext.yearincome_flag is '';
comment on column ${iol_schema}.ifms_tbprddailyext.daily_income_flag is '';
comment on column ${iol_schema}.ifms_tbprddailyext.daily_income is '';
comment on column ${iol_schema}.ifms_tbprddailyext.breach_red_flag is '';
comment on column ${iol_schema}.ifms_tbprddailyext.fund_type is '';
comment on column ${iol_schema}.ifms_tbprddailyext.fund_type_name is '';
comment on column ${iol_schema}.ifms_tbprddailyext.prd_sponsor is '';
comment on column ${iol_schema}.ifms_tbprddailyext.ta_code is '';
comment on column ${iol_schema}.ifms_tbprddailyext.ta_name is '';
comment on column ${iol_schema}.ifms_tbprddailyext.prd_manager is '';
comment on column ${iol_schema}.ifms_tbprddailyext.prd_manager_name is '';
comment on column ${iol_schema}.ifms_tbprddailyext.service_tel is '';
comment on column ${iol_schema}.ifms_tbprddailyext.internet_address is '';
comment on column ${iol_schema}.ifms_tbprddailyext.monthincome_rate is '';
comment on column ${iol_schema}.ifms_tbprddailyext.monthincome_flag is '';
comment on column ${iol_schema}.ifms_tbprddailyext.quarter_rate is '';
comment on column ${iol_schema}.ifms_tbprddailyext.quarter_rate_flag is '';
comment on column ${iol_schema}.ifms_tbprddailyext.cycle_rate is '';
comment on column ${iol_schema}.ifms_tbprddailyext.cycle_rate_flag is '';
comment on column ${iol_schema}.ifms_tbprddailyext.reserve1 is '';
comment on column ${iol_schema}.ifms_tbprddailyext.reserve2 is '';
comment on column ${iol_schema}.ifms_tbprddailyext.reserve3 is '';
comment on column ${iol_schema}.ifms_tbprddailyext.nav_date is '';
comment on column ${iol_schema}.ifms_tbprddailyext.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbprddailyext.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbprddailyext.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbprddailyext.etl_timestamp is 'ETL处理时间戳';
