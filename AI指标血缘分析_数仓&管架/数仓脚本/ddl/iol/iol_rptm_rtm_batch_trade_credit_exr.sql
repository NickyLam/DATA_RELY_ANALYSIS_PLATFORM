/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rptm_rtm_batch_trade_credit_exr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rptm_rtm_batch_trade_credit_exr
whenever sqlerror continue none;
drop table ${iol_schema}.rptm_rtm_batch_trade_credit_exr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_batch_trade_credit_exr(
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
    ,data_dt date -- 
    ,bank_certificate_amount number(22,4) -- 
    ,tb_amount number(22,4) -- 
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
grant select on ${iol_schema}.rptm_rtm_batch_trade_credit_exr to ${iml_schema};
grant select on ${iol_schema}.rptm_rtm_batch_trade_credit_exr to ${icl_schema};
grant select on ${iol_schema}.rptm_rtm_batch_trade_credit_exr to ${idl_schema};
grant select on ${iol_schema}.rptm_rtm_batch_trade_credit_exr to ${iel_schema};

-- comment
comment on table ${iol_schema}.rptm_rtm_batch_trade_credit_exr is '关联交易事后授信表';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.id is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.bus_id is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.data_state is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.active_time is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.inst_org is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.bus_dep is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.system_bus_name is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.collect_type is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.collect_state is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.ybj_rp_type is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.rp_bus_id is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.rp_name is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.ybj_rp_card_type is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.rp_card_no is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.rp_bloc_id is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.rp_bloc_name is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.rp_bloc_no is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.trans_type is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.bus_type is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.product_type is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.product_bus_id is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.product_name is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.product_code is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.product_issue_no is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.contract_no is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.sign_date is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.credit_dead_line is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.trans_start_date is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.trans_end_date is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.curr_code is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.trans_amount is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.foreign_curr_to_rmb is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.use_balance is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.is_agreement is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.agreement_bus_id is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.agreement_name is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.price_type is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.interest_rate_type is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.five_level_type is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.overdue_state is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.money_direction is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.related_amount is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.stock_pledge_name is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.guarantee_mode is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.guarantor_type is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.guarantor_name is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.guarantor_card_no is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.trans_involve_assets is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.trans_involve_income is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.trans_involve_cost is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.invest_desc is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.trans_price is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.pricing_strategy is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.trans_desc is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.remarks is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.legal_org_code is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.create_user is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.create_time is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.create_org is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.create_dep is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.update_user is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.update_time is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.update_org is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.update_dep is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.wf_state is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.agree is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.process_instance_id is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.reserve1 is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.reserve2 is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.reserve3 is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.data_dt is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.bank_certificate_amount is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.tb_amount is '';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.start_dt is '开始时间';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.end_dt is '结束时间';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.id_mark is '增删标志';
comment on column ${iol_schema}.rptm_rtm_batch_trade_credit_exr.etl_timestamp is 'ETL处理时间戳';
