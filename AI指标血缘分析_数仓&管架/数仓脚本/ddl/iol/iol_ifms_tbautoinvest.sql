/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbautoinvest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbautoinvest
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbautoinvest purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbautoinvest(
    serial_no varchar2(48) -- 
    ,busin_flag varchar2(2) -- 
    ,trans_date number(22) -- 
    ,in_client_no varchar2(30) -- 
    ,bank_no varchar2(32) -- 
    ,client_no varchar2(36) -- 
    ,bank_acc varchar2(64) -- 
    ,cash_flag varchar2(2) -- 
    ,client_group varchar2(10) -- 
    ,channel varchar2(2) -- 
    ,branch_no varchar2(24) -- 
    ,prd_code varchar2(32) -- 
    ,asso_code varchar2(30) -- 
    ,ta_code varchar2(18) -- 
    ,amt number(18,2) -- 
    ,vol number(18,3) -- 
    ,larg_red_flag varchar2(2) -- 
    ,min_amt number(18,2) -- 
    ,max_amt number(18,2) -- 
    ,hold_amt number(18,2) -- 
    ,agio number(5,4) -- 
    ,over_flag varchar2(2) -- 
    ,invest_day number(22) -- 
    ,invest_times number(22) -- 
    ,remain_times number(22) -- 
    ,tot_times number(22) -- 
    ,fail_times number(22) -- 
    ,end_date number(22) -- 
    ,period varchar2(2) -- 
    ,span number(22) -- 
    ,next_invest_date number(22) -- 
    ,last_invest_date number(22) -- 
    ,last_deal_date number(22) -- 
    ,last_msg varchar2(256) -- 
    ,finish_flag varchar2(2) -- 
    ,start_invest_date number(22) -- 
    ,client_manager varchar2(48) -- 
    ,reserve1 varchar2(375) -- 
    ,reserve2 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbautoinvest to ${iml_schema};
grant select on ${iol_schema}.ifms_tbautoinvest to ${icl_schema};
grant select on ${iol_schema}.ifms_tbautoinvest to ${idl_schema};
grant select on ${iol_schema}.ifms_tbautoinvest to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbautoinvest is '自动投资信息表';
comment on column ${iol_schema}.ifms_tbautoinvest.serial_no is '';
comment on column ${iol_schema}.ifms_tbautoinvest.busin_flag is '';
comment on column ${iol_schema}.ifms_tbautoinvest.trans_date is '';
comment on column ${iol_schema}.ifms_tbautoinvest.in_client_no is '';
comment on column ${iol_schema}.ifms_tbautoinvest.bank_no is '';
comment on column ${iol_schema}.ifms_tbautoinvest.client_no is '';
comment on column ${iol_schema}.ifms_tbautoinvest.bank_acc is '';
comment on column ${iol_schema}.ifms_tbautoinvest.cash_flag is '';
comment on column ${iol_schema}.ifms_tbautoinvest.client_group is '';
comment on column ${iol_schema}.ifms_tbautoinvest.channel is '';
comment on column ${iol_schema}.ifms_tbautoinvest.branch_no is '';
comment on column ${iol_schema}.ifms_tbautoinvest.prd_code is '';
comment on column ${iol_schema}.ifms_tbautoinvest.asso_code is '';
comment on column ${iol_schema}.ifms_tbautoinvest.ta_code is '';
comment on column ${iol_schema}.ifms_tbautoinvest.amt is '';
comment on column ${iol_schema}.ifms_tbautoinvest.vol is '';
comment on column ${iol_schema}.ifms_tbautoinvest.larg_red_flag is '';
comment on column ${iol_schema}.ifms_tbautoinvest.min_amt is '';
comment on column ${iol_schema}.ifms_tbautoinvest.max_amt is '';
comment on column ${iol_schema}.ifms_tbautoinvest.hold_amt is '';
comment on column ${iol_schema}.ifms_tbautoinvest.agio is '';
comment on column ${iol_schema}.ifms_tbautoinvest.over_flag is '';
comment on column ${iol_schema}.ifms_tbautoinvest.invest_day is '';
comment on column ${iol_schema}.ifms_tbautoinvest.invest_times is '';
comment on column ${iol_schema}.ifms_tbautoinvest.remain_times is '';
comment on column ${iol_schema}.ifms_tbautoinvest.tot_times is '';
comment on column ${iol_schema}.ifms_tbautoinvest.fail_times is '';
comment on column ${iol_schema}.ifms_tbautoinvest.end_date is '';
comment on column ${iol_schema}.ifms_tbautoinvest.period is '';
comment on column ${iol_schema}.ifms_tbautoinvest.span is '';
comment on column ${iol_schema}.ifms_tbautoinvest.next_invest_date is '';
comment on column ${iol_schema}.ifms_tbautoinvest.last_invest_date is '';
comment on column ${iol_schema}.ifms_tbautoinvest.last_deal_date is '';
comment on column ${iol_schema}.ifms_tbautoinvest.last_msg is '';
comment on column ${iol_schema}.ifms_tbautoinvest.finish_flag is '';
comment on column ${iol_schema}.ifms_tbautoinvest.start_invest_date is '';
comment on column ${iol_schema}.ifms_tbautoinvest.client_manager is '';
comment on column ${iol_schema}.ifms_tbautoinvest.reserve1 is '';
comment on column ${iol_schema}.ifms_tbautoinvest.reserve2 is '';
comment on column ${iol_schema}.ifms_tbautoinvest.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbautoinvest.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbautoinvest.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbautoinvest.etl_timestamp is 'ETL处理时间戳';
