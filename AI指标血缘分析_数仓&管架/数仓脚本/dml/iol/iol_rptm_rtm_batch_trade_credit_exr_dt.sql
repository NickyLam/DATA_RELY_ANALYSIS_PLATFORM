/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rptm_rtm_batch_trade_credit_exr_dt
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
create table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_op purge;
drop table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt where 0=1;

create table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_cl(
            id -- 
            ,bus_id -- 
            ,data_state -- 
            ,active_time -- 
            ,inst_org -- 
            ,bus_dep -- 
            ,system_bus_name -- 
            ,collect_type -- 
            ,collect_state -- 
            ,ybj_rp_type -- 
            ,rp_bus_id -- 
            ,rp_name -- 
            ,ybj_rp_card_type -- 
            ,rp_card_no -- 
            ,rp_bloc_id -- 
            ,rp_bloc_name -- 
            ,rp_bloc_no -- 
            ,trans_type -- 
            ,bus_type -- 
            ,product_type -- 
            ,product_bus_id -- 
            ,product_name -- 
            ,product_code -- 
            ,product_issue_no -- 
            ,contract_no -- 
            ,sign_date -- 
            ,credit_dead_line -- 
            ,trans_start_date -- 
            ,trans_end_date -- 
            ,curr_code -- 
            ,trans_amount -- 
            ,foreign_curr_to_rmb -- 
            ,use_balance -- 
            ,is_agreement -- 
            ,agreement_bus_id -- 
            ,agreement_name -- 
            ,price_type -- 
            ,interest_rate_type -- 
            ,five_level_type -- 
            ,overdue_state -- 
            ,money_direction -- 
            ,related_amount -- 
            ,stock_pledge_name -- 
            ,guarantee_mode -- 
            ,guarantor_type -- 
            ,guarantor_name -- 
            ,guarantor_card_no -- 
            ,trans_involve_assets -- 
            ,trans_involve_income -- 
            ,trans_involve_cost -- 
            ,invest_desc -- 
            ,trans_price -- 
            ,pricing_strategy -- 
            ,trans_desc -- 
            ,remarks -- 
            ,legal_org_code -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,create_dep -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,update_dep -- 
            ,wf_state -- 
            ,agree -- 
            ,process_instance_id -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,data_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_op(
            id -- 
            ,bus_id -- 
            ,data_state -- 
            ,active_time -- 
            ,inst_org -- 
            ,bus_dep -- 
            ,system_bus_name -- 
            ,collect_type -- 
            ,collect_state -- 
            ,ybj_rp_type -- 
            ,rp_bus_id -- 
            ,rp_name -- 
            ,ybj_rp_card_type -- 
            ,rp_card_no -- 
            ,rp_bloc_id -- 
            ,rp_bloc_name -- 
            ,rp_bloc_no -- 
            ,trans_type -- 
            ,bus_type -- 
            ,product_type -- 
            ,product_bus_id -- 
            ,product_name -- 
            ,product_code -- 
            ,product_issue_no -- 
            ,contract_no -- 
            ,sign_date -- 
            ,credit_dead_line -- 
            ,trans_start_date -- 
            ,trans_end_date -- 
            ,curr_code -- 
            ,trans_amount -- 
            ,foreign_curr_to_rmb -- 
            ,use_balance -- 
            ,is_agreement -- 
            ,agreement_bus_id -- 
            ,agreement_name -- 
            ,price_type -- 
            ,interest_rate_type -- 
            ,five_level_type -- 
            ,overdue_state -- 
            ,money_direction -- 
            ,related_amount -- 
            ,stock_pledge_name -- 
            ,guarantee_mode -- 
            ,guarantor_type -- 
            ,guarantor_name -- 
            ,guarantor_card_no -- 
            ,trans_involve_assets -- 
            ,trans_involve_income -- 
            ,trans_involve_cost -- 
            ,invest_desc -- 
            ,trans_price -- 
            ,pricing_strategy -- 
            ,trans_desc -- 
            ,remarks -- 
            ,legal_org_code -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,create_dep -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,update_dep -- 
            ,wf_state -- 
            ,agree -- 
            ,process_instance_id -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,data_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 
    ,nvl(n.data_state, o.data_state) as data_state -- 
    ,nvl(n.active_time, o.active_time) as active_time -- 
    ,nvl(n.inst_org, o.inst_org) as inst_org -- 
    ,nvl(n.bus_dep, o.bus_dep) as bus_dep -- 
    ,nvl(n.system_bus_name, o.system_bus_name) as system_bus_name -- 
    ,nvl(n.collect_type, o.collect_type) as collect_type -- 
    ,nvl(n.collect_state, o.collect_state) as collect_state -- 
    ,nvl(n.ybj_rp_type, o.ybj_rp_type) as ybj_rp_type -- 
    ,nvl(n.rp_bus_id, o.rp_bus_id) as rp_bus_id -- 
    ,nvl(n.rp_name, o.rp_name) as rp_name -- 
    ,nvl(n.ybj_rp_card_type, o.ybj_rp_card_type) as ybj_rp_card_type -- 
    ,nvl(n.rp_card_no, o.rp_card_no) as rp_card_no -- 
    ,nvl(n.rp_bloc_id, o.rp_bloc_id) as rp_bloc_id -- 
    ,nvl(n.rp_bloc_name, o.rp_bloc_name) as rp_bloc_name -- 
    ,nvl(n.rp_bloc_no, o.rp_bloc_no) as rp_bloc_no -- 
    ,nvl(n.trans_type, o.trans_type) as trans_type -- 
    ,nvl(n.bus_type, o.bus_type) as bus_type -- 
    ,nvl(n.product_type, o.product_type) as product_type -- 
    ,nvl(n.product_bus_id, o.product_bus_id) as product_bus_id -- 
    ,nvl(n.product_name, o.product_name) as product_name -- 
    ,nvl(n.product_code, o.product_code) as product_code -- 
    ,nvl(n.product_issue_no, o.product_issue_no) as product_issue_no -- 
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 
    ,nvl(n.sign_date, o.sign_date) as sign_date -- 
    ,nvl(n.credit_dead_line, o.credit_dead_line) as credit_dead_line -- 
    ,nvl(n.trans_start_date, o.trans_start_date) as trans_start_date -- 
    ,nvl(n.trans_end_date, o.trans_end_date) as trans_end_date -- 
    ,nvl(n.curr_code, o.curr_code) as curr_code -- 
    ,nvl(n.trans_amount, o.trans_amount) as trans_amount -- 
    ,nvl(n.foreign_curr_to_rmb, o.foreign_curr_to_rmb) as foreign_curr_to_rmb -- 
    ,nvl(n.use_balance, o.use_balance) as use_balance -- 
    ,nvl(n.is_agreement, o.is_agreement) as is_agreement -- 
    ,nvl(n.agreement_bus_id, o.agreement_bus_id) as agreement_bus_id -- 
    ,nvl(n.agreement_name, o.agreement_name) as agreement_name -- 
    ,nvl(n.price_type, o.price_type) as price_type -- 
    ,nvl(n.interest_rate_type, o.interest_rate_type) as interest_rate_type -- 
    ,nvl(n.five_level_type, o.five_level_type) as five_level_type -- 
    ,nvl(n.overdue_state, o.overdue_state) as overdue_state -- 
    ,nvl(n.money_direction, o.money_direction) as money_direction -- 
    ,nvl(n.related_amount, o.related_amount) as related_amount -- 
    ,nvl(n.stock_pledge_name, o.stock_pledge_name) as stock_pledge_name -- 
    ,nvl(n.guarantee_mode, o.guarantee_mode) as guarantee_mode -- 
    ,nvl(n.guarantor_type, o.guarantor_type) as guarantor_type -- 
    ,nvl(n.guarantor_name, o.guarantor_name) as guarantor_name -- 
    ,nvl(n.guarantor_card_no, o.guarantor_card_no) as guarantor_card_no -- 
    ,nvl(n.trans_involve_assets, o.trans_involve_assets) as trans_involve_assets -- 
    ,nvl(n.trans_involve_income, o.trans_involve_income) as trans_involve_income -- 
    ,nvl(n.trans_involve_cost, o.trans_involve_cost) as trans_involve_cost -- 
    ,nvl(n.invest_desc, o.invest_desc) as invest_desc -- 
    ,nvl(n.trans_price, o.trans_price) as trans_price -- 
    ,nvl(n.pricing_strategy, o.pricing_strategy) as pricing_strategy -- 
    ,nvl(n.trans_desc, o.trans_desc) as trans_desc -- 
    ,nvl(n.remarks, o.remarks) as remarks -- 
    ,nvl(n.legal_org_code, o.legal_org_code) as legal_org_code -- 
    ,nvl(n.create_user, o.create_user) as create_user -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.create_org, o.create_org) as create_org -- 
    ,nvl(n.create_dep, o.create_dep) as create_dep -- 
    ,nvl(n.update_user, o.update_user) as update_user -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.update_org, o.update_org) as update_org -- 
    ,nvl(n.update_dep, o.update_dep) as update_dep -- 
    ,nvl(n.wf_state, o.wf_state) as wf_state -- 
    ,nvl(n.agree, o.agree) as agree -- 
    ,nvl(n.process_instance_id, o.process_instance_id) as process_instance_id -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.data_dt, o.data_dt) as data_dt -- 
    ,case when

        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when

        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when

        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rptm_rtm_batch_trade_credit_exr_dt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on

where (

    )
    or (

    )
    or (
        o.id <> n.id
        or o.bus_id <> n.bus_id
        or o.data_state <> n.data_state
        or o.active_time <> n.active_time
        or o.inst_org <> n.inst_org
        or o.bus_dep <> n.bus_dep
        or o.system_bus_name <> n.system_bus_name
        or o.collect_type <> n.collect_type
        or o.collect_state <> n.collect_state
        or o.ybj_rp_type <> n.ybj_rp_type
        or o.rp_bus_id <> n.rp_bus_id
        or o.rp_name <> n.rp_name
        or o.ybj_rp_card_type <> n.ybj_rp_card_type
        or o.rp_card_no <> n.rp_card_no
        or o.rp_bloc_id <> n.rp_bloc_id
        or o.rp_bloc_name <> n.rp_bloc_name
        or o.rp_bloc_no <> n.rp_bloc_no
        or o.trans_type <> n.trans_type
        or o.bus_type <> n.bus_type
        or o.product_type <> n.product_type
        or o.product_bus_id <> n.product_bus_id
        or o.product_name <> n.product_name
        or o.product_code <> n.product_code
        or o.product_issue_no <> n.product_issue_no
        or o.contract_no <> n.contract_no
        or o.sign_date <> n.sign_date
        or o.credit_dead_line <> n.credit_dead_line
        or o.trans_start_date <> n.trans_start_date
        or o.trans_end_date <> n.trans_end_date
        or o.curr_code <> n.curr_code
        or o.trans_amount <> n.trans_amount
        or o.foreign_curr_to_rmb <> n.foreign_curr_to_rmb
        or o.use_balance <> n.use_balance
        or o.is_agreement <> n.is_agreement
        or o.agreement_bus_id <> n.agreement_bus_id
        or o.agreement_name <> n.agreement_name
        or o.price_type <> n.price_type
        or o.interest_rate_type <> n.interest_rate_type
        or o.five_level_type <> n.five_level_type
        or o.overdue_state <> n.overdue_state
        or o.money_direction <> n.money_direction
        or o.related_amount <> n.related_amount
        or o.stock_pledge_name <> n.stock_pledge_name
        or o.guarantee_mode <> n.guarantee_mode
        or o.guarantor_type <> n.guarantor_type
        or o.guarantor_name <> n.guarantor_name
        or o.guarantor_card_no <> n.guarantor_card_no
        or o.trans_involve_assets <> n.trans_involve_assets
        or o.trans_involve_income <> n.trans_involve_income
        or o.trans_involve_cost <> n.trans_involve_cost
        or o.invest_desc <> n.invest_desc
        or o.trans_price <> n.trans_price
        or o.pricing_strategy <> n.pricing_strategy
        or o.trans_desc <> n.trans_desc
        or o.remarks <> n.remarks
        or o.legal_org_code <> n.legal_org_code
        or o.create_user <> n.create_user
        or o.create_time <> n.create_time
        or o.create_org <> n.create_org
        or o.create_dep <> n.create_dep
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.update_org <> n.update_org
        or o.update_dep <> n.update_dep
        or o.wf_state <> n.wf_state
        or o.agree <> n.agree
        or o.process_instance_id <> n.process_instance_id
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.data_dt <> n.data_dt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_cl(
            id -- 
            ,bus_id -- 
            ,data_state -- 
            ,active_time -- 
            ,inst_org -- 
            ,bus_dep -- 
            ,system_bus_name -- 
            ,collect_type -- 
            ,collect_state -- 
            ,ybj_rp_type -- 
            ,rp_bus_id -- 
            ,rp_name -- 
            ,ybj_rp_card_type -- 
            ,rp_card_no -- 
            ,rp_bloc_id -- 
            ,rp_bloc_name -- 
            ,rp_bloc_no -- 
            ,trans_type -- 
            ,bus_type -- 
            ,product_type -- 
            ,product_bus_id -- 
            ,product_name -- 
            ,product_code -- 
            ,product_issue_no -- 
            ,contract_no -- 
            ,sign_date -- 
            ,credit_dead_line -- 
            ,trans_start_date -- 
            ,trans_end_date -- 
            ,curr_code -- 
            ,trans_amount -- 
            ,foreign_curr_to_rmb -- 
            ,use_balance -- 
            ,is_agreement -- 
            ,agreement_bus_id -- 
            ,agreement_name -- 
            ,price_type -- 
            ,interest_rate_type -- 
            ,five_level_type -- 
            ,overdue_state -- 
            ,money_direction -- 
            ,related_amount -- 
            ,stock_pledge_name -- 
            ,guarantee_mode -- 
            ,guarantor_type -- 
            ,guarantor_name -- 
            ,guarantor_card_no -- 
            ,trans_involve_assets -- 
            ,trans_involve_income -- 
            ,trans_involve_cost -- 
            ,invest_desc -- 
            ,trans_price -- 
            ,pricing_strategy -- 
            ,trans_desc -- 
            ,remarks -- 
            ,legal_org_code -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,create_dep -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,update_dep -- 
            ,wf_state -- 
            ,agree -- 
            ,process_instance_id -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,data_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_op(
            id -- 
            ,bus_id -- 
            ,data_state -- 
            ,active_time -- 
            ,inst_org -- 
            ,bus_dep -- 
            ,system_bus_name -- 
            ,collect_type -- 
            ,collect_state -- 
            ,ybj_rp_type -- 
            ,rp_bus_id -- 
            ,rp_name -- 
            ,ybj_rp_card_type -- 
            ,rp_card_no -- 
            ,rp_bloc_id -- 
            ,rp_bloc_name -- 
            ,rp_bloc_no -- 
            ,trans_type -- 
            ,bus_type -- 
            ,product_type -- 
            ,product_bus_id -- 
            ,product_name -- 
            ,product_code -- 
            ,product_issue_no -- 
            ,contract_no -- 
            ,sign_date -- 
            ,credit_dead_line -- 
            ,trans_start_date -- 
            ,trans_end_date -- 
            ,curr_code -- 
            ,trans_amount -- 
            ,foreign_curr_to_rmb -- 
            ,use_balance -- 
            ,is_agreement -- 
            ,agreement_bus_id -- 
            ,agreement_name -- 
            ,price_type -- 
            ,interest_rate_type -- 
            ,five_level_type -- 
            ,overdue_state -- 
            ,money_direction -- 
            ,related_amount -- 
            ,stock_pledge_name -- 
            ,guarantee_mode -- 
            ,guarantor_type -- 
            ,guarantor_name -- 
            ,guarantor_card_no -- 
            ,trans_involve_assets -- 
            ,trans_involve_income -- 
            ,trans_involve_cost -- 
            ,invest_desc -- 
            ,trans_price -- 
            ,pricing_strategy -- 
            ,trans_desc -- 
            ,remarks -- 
            ,legal_org_code -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,create_dep -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,update_dep -- 
            ,wf_state -- 
            ,agree -- 
            ,process_instance_id -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,data_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.bus_id -- 
    ,o.data_state -- 
    ,o.active_time -- 
    ,o.inst_org -- 
    ,o.bus_dep -- 
    ,o.system_bus_name -- 
    ,o.collect_type -- 
    ,o.collect_state -- 
    ,o.ybj_rp_type -- 
    ,o.rp_bus_id -- 
    ,o.rp_name -- 
    ,o.ybj_rp_card_type -- 
    ,o.rp_card_no -- 
    ,o.rp_bloc_id -- 
    ,o.rp_bloc_name -- 
    ,o.rp_bloc_no -- 
    ,o.trans_type -- 
    ,o.bus_type -- 
    ,o.product_type -- 
    ,o.product_bus_id -- 
    ,o.product_name -- 
    ,o.product_code -- 
    ,o.product_issue_no -- 
    ,o.contract_no -- 
    ,o.sign_date -- 
    ,o.credit_dead_line -- 
    ,o.trans_start_date -- 
    ,o.trans_end_date -- 
    ,o.curr_code -- 
    ,o.trans_amount -- 
    ,o.foreign_curr_to_rmb -- 
    ,o.use_balance -- 
    ,o.is_agreement -- 
    ,o.agreement_bus_id -- 
    ,o.agreement_name -- 
    ,o.price_type -- 
    ,o.interest_rate_type -- 
    ,o.five_level_type -- 
    ,o.overdue_state -- 
    ,o.money_direction -- 
    ,o.related_amount -- 
    ,o.stock_pledge_name -- 
    ,o.guarantee_mode -- 
    ,o.guarantor_type -- 
    ,o.guarantor_name -- 
    ,o.guarantor_card_no -- 
    ,o.trans_involve_assets -- 
    ,o.trans_involve_income -- 
    ,o.trans_involve_cost -- 
    ,o.invest_desc -- 
    ,o.trans_price -- 
    ,o.pricing_strategy -- 
    ,o.trans_desc -- 
    ,o.remarks -- 
    ,o.legal_org_code -- 
    ,o.create_user -- 
    ,o.create_time -- 
    ,o.create_org -- 
    ,o.create_dep -- 
    ,o.update_user -- 
    ,o.update_time -- 
    ,o.update_org -- 
    ,o.update_dep -- 
    ,o.wf_state -- 
    ,o.agree -- 
    ,o.process_instance_id -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.data_dt -- 
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
from ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_bk o
    left join ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_op n
        on

            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_cl d
        on

where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rptm_rtm_batch_trade_credit_exr_dt') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt exchange partition p_${batch_date} with table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_cl;
alter table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt exchange partition p_20991231 with table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_op purge;
drop table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rptm_rtm_batch_trade_credit_exr_dt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rptm_rtm_batch_trade_credit_exr_dt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
