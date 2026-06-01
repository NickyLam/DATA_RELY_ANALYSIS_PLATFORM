/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_trade_aft_collect_credit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_trade_aft_collect_credit
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_trade_aft_collect_credit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_trade_aft_collect_credit(
    bus_dep varchar2(900) -- 
    ,is_bank_business varchar2(18) -- 
    ,system_bus_name varchar2(720) -- 
    ,cust_no varchar2(576) -- 
    ,rp_name varchar2(2250) -- 
    ,ybj_rp_card_type varchar2(90) -- 
    ,rp_card_no varchar2(900) -- 
    ,rp_bloc_name varchar2(2250) -- 
    ,rp_bloc_no varchar2(900) -- 
    ,product_name varchar2(2250) -- 
    ,product_code varchar2(900) -- 
    ,contract_no varchar2(900) -- 
    ,sign_date date -- 
    ,sign_end_date date -- 
    ,credit_dead_line varchar2(90) -- 
    ,trans_start_date date -- 
    ,trans_end_date date -- 
    ,curr_code varchar2(54) -- 
    ,trans_amount number(22,4) -- 
    ,foreign_curr_to_rmb number(22,4) -- 
    ,use_balance number(22,4) -- 
    ,price_type varchar2(18) -- 
    ,interest_rate_type varchar2(288) -- 
    ,stock_pledge_name varchar2(2250) -- 
    ,guarantee_mode varchar2(18) -- 
    ,guarantor_type varchar2(18) -- 
    ,guarantor_name varchar2(2250) -- 
    ,guarantor_card_no varchar2(1800) -- 
    ,money_direction varchar2(90) -- 
    ,related_amount number(22,4) -- 
    ,invest_desc varchar2(4000) -- 
    ,trans_price varchar2(2700) -- 
    ,pricing_strategy varchar2(4000) -- 
    ,trans_desc varchar2(4000) -- 
    ,remarks varchar2(4000) -- 
    ,create_time date -- 
    ,create_org varchar2(1152) -- 
    ,agent_in_charge varchar2(288) -- 
    ,responsible_department varchar2(1152) -- 
    ,financial_name varchar2(1800) -- 
    ,product_issue_no varchar2(900) -- 
    ,five_level_type varchar2(36) -- 
    ,npl_ye number(22,4) -- 
    ,overdue_state varchar2(18) -- 
    ,ol_je number(22,4) -- 
    ,credit_status varchar2(90) -- 
    ,security_amount number(22,4) -- 
    ,bank_certificate_amount number(22,4) -- 
    ,tb_amount number(22,4) -- 
    ,etl_dt date -- 
    ,id varchar2(1152) -- 
    ,bus_id varchar2(1152) -- 
    ,aplv_flow_num varchar2(900) -- 
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
grant select on ${iol_schema}.rptm_rtm_trade_aft_collect_credit to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_trade_aft_collect_credit to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_trade_aft_collect_credit to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_trade_aft_collect_credit to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_trade_aft_collect_credit is '关联交易事后采集授信表';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.bus_dep is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.is_bank_business is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.system_bus_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.cust_no is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.rp_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.ybj_rp_card_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.rp_card_no is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.rp_bloc_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.rp_bloc_no is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.product_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.product_code is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.contract_no is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.sign_date is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.sign_end_date is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.credit_dead_line is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.trans_start_date is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.trans_end_date is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.curr_code is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.trans_amount is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.foreign_curr_to_rmb is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.use_balance is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.price_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.interest_rate_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.stock_pledge_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.guarantee_mode is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.guarantor_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.guarantor_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.guarantor_card_no is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.money_direction is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.related_amount is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.invest_desc is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.trans_price is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.pricing_strategy is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.trans_desc is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.remarks is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.create_time is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.create_org is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.agent_in_charge is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.responsible_department is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.financial_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.product_issue_no is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.five_level_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.npl_ye is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.overdue_state is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.ol_je is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.credit_status is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.security_amount is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.bank_certificate_amount is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.tb_amount is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.etl_dt is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.id is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.bus_id is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.aplv_flow_num is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.start_dt is '开始时间';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.end_dt is '结束时间';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.id_mark is '增删标志';
comment on column ${iol_schema}.rptm_rtm_trade_aft_collect_credit.etl_timestamp is 'ETL处理时间戳';
