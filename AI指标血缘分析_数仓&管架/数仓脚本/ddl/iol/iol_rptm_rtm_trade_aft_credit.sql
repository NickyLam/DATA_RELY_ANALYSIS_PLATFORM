/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_trade_aft_credit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_trade_aft_credit
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_trade_aft_credit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_trade_aft_credit(
    id varchar2(288) -- 
    ,bus_id varchar2(576) -- 
    ,data_state varchar2(18) -- 
    ,active_time date -- 
    ,inst_org varchar2(450) -- 
    ,bus_dep varchar2(288) -- 
    ,system_bus_name varchar2(720) -- 
    ,collect_type varchar2(18) -- 
    ,collect_state varchar2(18) -- 
    ,ybj_rp_type varchar2(18) -- 
    ,rp_bus_id varchar2(576) -- 
    ,rp_name varchar2(1800) -- 
    ,ybj_rp_card_type varchar2(90) -- 
    ,rp_card_no varchar2(900) -- 
    ,rp_bloc_id varchar2(576) -- 
    ,rp_bloc_name varchar2(1800) -- 
    ,rp_bloc_no varchar2(900) -- 
    ,trans_type varchar2(18) -- 
    ,bus_type varchar2(54) -- 
    ,product_type varchar2(18) -- 
    ,product_bus_id varchar2(576) -- 
    ,product_name varchar2(1800) -- 
    ,product_code varchar2(900) -- 
    ,product_issue_no varchar2(900) -- 
    ,contract_no varchar2(900) -- 
    ,sign_date date -- 
    ,credit_dead_line varchar2(90) -- 
    ,trans_start_date date -- 
    ,trans_end_date date -- 
    ,curr_code varchar2(36) -- 
    ,trans_amount number(22,6) -- 
    ,foreign_curr_to_rmb number(22,6) -- 
    ,use_balance number(22,6) -- 
    ,is_agreement varchar2(18) -- 
    ,agreement_bus_id varchar2(576) -- 
    ,agreement_name varchar2(1800) -- 
    ,price_type varchar2(18) -- 
    ,interest_rate_type varchar2(18) -- 
    ,five_level_type varchar2(18) -- 
    ,overdue_state varchar2(18) -- 
    ,money_direction varchar2(18) -- 
    ,related_amount number(22,6) -- 
    ,stock_pledge_name varchar2(900) -- 
    ,guarantee_mode varchar2(18) -- 
    ,guarantor_type varchar2(900) -- 
    ,guarantor_name varchar2(1800) -- 
    ,guarantor_card_no varchar2(900) -- 
    ,trans_involve_assets number(22,6) -- 
    ,trans_involve_income number(22,6) -- 
    ,trans_involve_cost number(22,6) -- 
    ,invest_desc varchar2(4000) -- 
    ,trans_price varchar2(2700) -- 
    ,pricing_strategy varchar2(4000) -- 
    ,trans_desc varchar2(4000) -- 
    ,remarks varchar2(4000) -- 
    ,legal_org_code varchar2(288) -- 
    ,create_user varchar2(288) -- 
    ,create_time date -- 
    ,create_org varchar2(288) -- 
    ,create_dep varchar2(288) -- 
    ,update_user varchar2(288) -- 
    ,update_time date -- 
    ,update_org varchar2(288) -- 
    ,update_dep varchar2(288) -- 
    ,wf_state varchar2(2295) -- 
    ,agree varchar2(2295) -- 
    ,process_instance_id varchar2(2295) -- 
    ,reserve1 varchar2(2295) -- 
    ,reserve2 varchar2(2295) -- 
    ,reserve3 varchar2(2295) -- 
    ,npl_ye number(22,4) -- 
    ,ol_je number(22,4) -- 
    ,credit_status varchar2(90) -- 
    ,security_amount number(22,4) -- 
    ,bank_certificate_amount number(22,4) -- 
    ,tb_amount number(22,4) -- 
    ,sign_end_date date -- 
    ,etl_dt date -- 
    ,date_month varchar2(90) -- 
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
grant select on ${iol_schema}.rptm_rtm_trade_aft_credit to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_trade_aft_credit to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_trade_aft_credit to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_trade_aft_credit to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_trade_aft_credit is '关联交易事后授信表';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.id is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.bus_id is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.data_state is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.active_time is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.inst_org is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.bus_dep is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.system_bus_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.collect_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.collect_state is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.ybj_rp_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.rp_bus_id is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.rp_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.ybj_rp_card_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.rp_card_no is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.rp_bloc_id is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.rp_bloc_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.rp_bloc_no is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.trans_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.bus_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.product_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.product_bus_id is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.product_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.product_code is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.product_issue_no is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.contract_no is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.sign_date is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.credit_dead_line is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.trans_start_date is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.trans_end_date is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.curr_code is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.trans_amount is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.foreign_curr_to_rmb is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.use_balance is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.is_agreement is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.agreement_bus_id is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.agreement_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.price_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.interest_rate_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.five_level_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.overdue_state is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.money_direction is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.related_amount is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.stock_pledge_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.guarantee_mode is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.guarantor_type is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.guarantor_name is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.guarantor_card_no is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.trans_involve_assets is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.trans_involve_income is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.trans_involve_cost is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.invest_desc is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.trans_price is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.pricing_strategy is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.trans_desc is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.remarks is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.legal_org_code is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.create_user is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.create_time is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.create_org is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.create_dep is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.update_user is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.update_time is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.update_org is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.update_dep is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.wf_state is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.agree is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.process_instance_id is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.reserve1 is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.reserve2 is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.reserve3 is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.npl_ye is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.ol_je is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.credit_status is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.security_amount is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.bank_certificate_amount is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.tb_amount is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.sign_end_date is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.etl_dt is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.date_month is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.aplv_flow_num is '';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.start_dt is '开始时间';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.end_dt is '结束时间';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.id_mark is '增删标志';
comment on column ${iol_schema}.rptm_rtm_trade_aft_credit.etl_timestamp is 'ETL处理时间戳';
