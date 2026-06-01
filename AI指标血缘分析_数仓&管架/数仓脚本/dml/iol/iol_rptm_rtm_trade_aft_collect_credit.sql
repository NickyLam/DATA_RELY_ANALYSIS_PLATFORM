/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rptm_rtm_trade_aft_collect_credit
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
create table ${iol_schema}.rptm_rtm_trade_aft_collect_credit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rptm_rtm_trade_aft_collect_credit
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_trade_aft_collect_credit_op purge;
drop table ${iol_schema}.rptm_rtm_trade_aft_collect_credit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_trade_aft_collect_credit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_trade_aft_collect_credit where 0=1;

create table ${iol_schema}.rptm_rtm_trade_aft_collect_credit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_trade_aft_collect_credit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_trade_aft_collect_credit_cl(
            bus_dep -- 
            ,is_bank_business -- 
            ,system_bus_name -- 
            ,cust_no -- 
            ,rp_name -- 
            ,ybj_rp_card_type -- 
            ,rp_card_no -- 
            ,rp_bloc_name -- 
            ,rp_bloc_no -- 
            ,product_name -- 
            ,product_code -- 
            ,contract_no -- 
            ,sign_date -- 
            ,sign_end_date -- 
            ,credit_dead_line -- 
            ,trans_start_date -- 
            ,trans_end_date -- 
            ,curr_code -- 
            ,trans_amount -- 
            ,foreign_curr_to_rmb -- 
            ,use_balance -- 
            ,price_type -- 
            ,interest_rate_type -- 
            ,stock_pledge_name -- 
            ,guarantee_mode -- 
            ,guarantor_type -- 
            ,guarantor_name -- 
            ,guarantor_card_no -- 
            ,money_direction -- 
            ,related_amount -- 
            ,invest_desc -- 
            ,trans_price -- 
            ,pricing_strategy -- 
            ,trans_desc -- 
            ,remarks -- 
            ,create_time -- 
            ,create_org -- 
            ,agent_in_charge -- 
            ,responsible_department -- 
            ,financial_name -- 
            ,product_issue_no -- 
            ,five_level_type -- 
            ,npl_ye -- 
            ,overdue_state -- 
            ,ol_je -- 
            ,credit_status -- 
            ,security_amount -- 
            ,bank_certificate_amount -- 
            ,tb_amount -- 
            ,etl_dt -- 
            ,id -- 
            ,bus_id -- 
            ,aplv_flow_num -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_trade_aft_collect_credit_op(
            bus_dep -- 
            ,is_bank_business -- 
            ,system_bus_name -- 
            ,cust_no -- 
            ,rp_name -- 
            ,ybj_rp_card_type -- 
            ,rp_card_no -- 
            ,rp_bloc_name -- 
            ,rp_bloc_no -- 
            ,product_name -- 
            ,product_code -- 
            ,contract_no -- 
            ,sign_date -- 
            ,sign_end_date -- 
            ,credit_dead_line -- 
            ,trans_start_date -- 
            ,trans_end_date -- 
            ,curr_code -- 
            ,trans_amount -- 
            ,foreign_curr_to_rmb -- 
            ,use_balance -- 
            ,price_type -- 
            ,interest_rate_type -- 
            ,stock_pledge_name -- 
            ,guarantee_mode -- 
            ,guarantor_type -- 
            ,guarantor_name -- 
            ,guarantor_card_no -- 
            ,money_direction -- 
            ,related_amount -- 
            ,invest_desc -- 
            ,trans_price -- 
            ,pricing_strategy -- 
            ,trans_desc -- 
            ,remarks -- 
            ,create_time -- 
            ,create_org -- 
            ,agent_in_charge -- 
            ,responsible_department -- 
            ,financial_name -- 
            ,product_issue_no -- 
            ,five_level_type -- 
            ,npl_ye -- 
            ,overdue_state -- 
            ,ol_je -- 
            ,credit_status -- 
            ,security_amount -- 
            ,bank_certificate_amount -- 
            ,tb_amount -- 
            ,etl_dt -- 
            ,id -- 
            ,bus_id -- 
            ,aplv_flow_num -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bus_dep, o.bus_dep) as bus_dep -- 
    ,nvl(n.is_bank_business, o.is_bank_business) as is_bank_business -- 
    ,nvl(n.system_bus_name, o.system_bus_name) as system_bus_name -- 
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 
    ,nvl(n.rp_name, o.rp_name) as rp_name -- 
    ,nvl(n.ybj_rp_card_type, o.ybj_rp_card_type) as ybj_rp_card_type -- 
    ,nvl(n.rp_card_no, o.rp_card_no) as rp_card_no -- 
    ,nvl(n.rp_bloc_name, o.rp_bloc_name) as rp_bloc_name -- 
    ,nvl(n.rp_bloc_no, o.rp_bloc_no) as rp_bloc_no -- 
    ,nvl(n.product_name, o.product_name) as product_name -- 
    ,nvl(n.product_code, o.product_code) as product_code -- 
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 
    ,nvl(n.sign_date, o.sign_date) as sign_date -- 
    ,nvl(n.sign_end_date, o.sign_end_date) as sign_end_date -- 
    ,nvl(n.credit_dead_line, o.credit_dead_line) as credit_dead_line -- 
    ,nvl(n.trans_start_date, o.trans_start_date) as trans_start_date -- 
    ,nvl(n.trans_end_date, o.trans_end_date) as trans_end_date -- 
    ,nvl(n.curr_code, o.curr_code) as curr_code -- 
    ,nvl(n.trans_amount, o.trans_amount) as trans_amount -- 
    ,nvl(n.foreign_curr_to_rmb, o.foreign_curr_to_rmb) as foreign_curr_to_rmb -- 
    ,nvl(n.use_balance, o.use_balance) as use_balance -- 
    ,nvl(n.price_type, o.price_type) as price_type -- 
    ,nvl(n.interest_rate_type, o.interest_rate_type) as interest_rate_type -- 
    ,nvl(n.stock_pledge_name, o.stock_pledge_name) as stock_pledge_name -- 
    ,nvl(n.guarantee_mode, o.guarantee_mode) as guarantee_mode -- 
    ,nvl(n.guarantor_type, o.guarantor_type) as guarantor_type -- 
    ,nvl(n.guarantor_name, o.guarantor_name) as guarantor_name -- 
    ,nvl(n.guarantor_card_no, o.guarantor_card_no) as guarantor_card_no -- 
    ,nvl(n.money_direction, o.money_direction) as money_direction -- 
    ,nvl(n.related_amount, o.related_amount) as related_amount -- 
    ,nvl(n.invest_desc, o.invest_desc) as invest_desc -- 
    ,nvl(n.trans_price, o.trans_price) as trans_price -- 
    ,nvl(n.pricing_strategy, o.pricing_strategy) as pricing_strategy -- 
    ,nvl(n.trans_desc, o.trans_desc) as trans_desc -- 
    ,nvl(n.remarks, o.remarks) as remarks -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.create_org, o.create_org) as create_org -- 
    ,nvl(n.agent_in_charge, o.agent_in_charge) as agent_in_charge -- 
    ,nvl(n.responsible_department, o.responsible_department) as responsible_department -- 
    ,nvl(n.financial_name, o.financial_name) as financial_name -- 
    ,nvl(n.product_issue_no, o.product_issue_no) as product_issue_no -- 
    ,nvl(n.five_level_type, o.five_level_type) as five_level_type -- 
    ,nvl(n.npl_ye, o.npl_ye) as npl_ye -- 
    ,nvl(n.overdue_state, o.overdue_state) as overdue_state -- 
    ,nvl(n.ol_je, o.ol_je) as ol_je -- 
    ,nvl(n.credit_status, o.credit_status) as credit_status -- 
    ,nvl(n.security_amount, o.security_amount) as security_amount -- 
    ,nvl(n.bank_certificate_amount, o.bank_certificate_amount) as bank_certificate_amount -- 
    ,nvl(n.tb_amount, o.tb_amount) as tb_amount -- 
    ,nvl(n.etl_dt, o.etl_dt) as etl_dt -- 
    ,nvl(n.id, o.id) as id -- 
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 
    ,nvl(n.aplv_flow_num, o.aplv_flow_num) as aplv_flow_num -- 
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
from (select * from ${iol_schema}.rptm_rtm_trade_aft_collect_credit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rptm_rtm_trade_aft_collect_credit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on

where (

    )
    or (

    )
    or (
        o.bus_dep <> n.bus_dep
        or o.is_bank_business <> n.is_bank_business
        or o.system_bus_name <> n.system_bus_name
        or o.cust_no <> n.cust_no
        or o.rp_name <> n.rp_name
        or o.ybj_rp_card_type <> n.ybj_rp_card_type
        or o.rp_card_no <> n.rp_card_no
        or o.rp_bloc_name <> n.rp_bloc_name
        or o.rp_bloc_no <> n.rp_bloc_no
        or o.product_name <> n.product_name
        or o.product_code <> n.product_code
        or o.contract_no <> n.contract_no
        or o.sign_date <> n.sign_date
        or o.sign_end_date <> n.sign_end_date
        or o.credit_dead_line <> n.credit_dead_line
        or o.trans_start_date <> n.trans_start_date
        or o.trans_end_date <> n.trans_end_date
        or o.curr_code <> n.curr_code
        or o.trans_amount <> n.trans_amount
        or o.foreign_curr_to_rmb <> n.foreign_curr_to_rmb
        or o.use_balance <> n.use_balance
        or o.price_type <> n.price_type
        or o.interest_rate_type <> n.interest_rate_type
        or o.stock_pledge_name <> n.stock_pledge_name
        or o.guarantee_mode <> n.guarantee_mode
        or o.guarantor_type <> n.guarantor_type
        or o.guarantor_name <> n.guarantor_name
        or o.guarantor_card_no <> n.guarantor_card_no
        or o.money_direction <> n.money_direction
        or o.related_amount <> n.related_amount
        or o.invest_desc <> n.invest_desc
        or o.trans_price <> n.trans_price
        or o.pricing_strategy <> n.pricing_strategy
        or o.trans_desc <> n.trans_desc
        or o.remarks <> n.remarks
        or o.create_time <> n.create_time
        or o.create_org <> n.create_org
        or o.agent_in_charge <> n.agent_in_charge
        or o.responsible_department <> n.responsible_department
        or o.financial_name <> n.financial_name
        or o.product_issue_no <> n.product_issue_no
        or o.five_level_type <> n.five_level_type
        or o.npl_ye <> n.npl_ye
        or o.overdue_state <> n.overdue_state
        or o.ol_je <> n.ol_je
        or o.credit_status <> n.credit_status
        or o.security_amount <> n.security_amount
        or o.bank_certificate_amount <> n.bank_certificate_amount
        or o.tb_amount <> n.tb_amount
        or o.etl_dt <> n.etl_dt
        or o.id <> n.id
        or o.bus_id <> n.bus_id
        or o.aplv_flow_num <> n.aplv_flow_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_trade_aft_collect_credit_cl(
            bus_dep -- 
            ,is_bank_business -- 
            ,system_bus_name -- 
            ,cust_no -- 
            ,rp_name -- 
            ,ybj_rp_card_type -- 
            ,rp_card_no -- 
            ,rp_bloc_name -- 
            ,rp_bloc_no -- 
            ,product_name -- 
            ,product_code -- 
            ,contract_no -- 
            ,sign_date -- 
            ,sign_end_date -- 
            ,credit_dead_line -- 
            ,trans_start_date -- 
            ,trans_end_date -- 
            ,curr_code -- 
            ,trans_amount -- 
            ,foreign_curr_to_rmb -- 
            ,use_balance -- 
            ,price_type -- 
            ,interest_rate_type -- 
            ,stock_pledge_name -- 
            ,guarantee_mode -- 
            ,guarantor_type -- 
            ,guarantor_name -- 
            ,guarantor_card_no -- 
            ,money_direction -- 
            ,related_amount -- 
            ,invest_desc -- 
            ,trans_price -- 
            ,pricing_strategy -- 
            ,trans_desc -- 
            ,remarks -- 
            ,create_time -- 
            ,create_org -- 
            ,agent_in_charge -- 
            ,responsible_department -- 
            ,financial_name -- 
            ,product_issue_no -- 
            ,five_level_type -- 
            ,npl_ye -- 
            ,overdue_state -- 
            ,ol_je -- 
            ,credit_status -- 
            ,security_amount -- 
            ,bank_certificate_amount -- 
            ,tb_amount -- 
            ,etl_dt -- 
            ,id -- 
            ,bus_id -- 
            ,aplv_flow_num -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_trade_aft_collect_credit_op(
            bus_dep -- 
            ,is_bank_business -- 
            ,system_bus_name -- 
            ,cust_no -- 
            ,rp_name -- 
            ,ybj_rp_card_type -- 
            ,rp_card_no -- 
            ,rp_bloc_name -- 
            ,rp_bloc_no -- 
            ,product_name -- 
            ,product_code -- 
            ,contract_no -- 
            ,sign_date -- 
            ,sign_end_date -- 
            ,credit_dead_line -- 
            ,trans_start_date -- 
            ,trans_end_date -- 
            ,curr_code -- 
            ,trans_amount -- 
            ,foreign_curr_to_rmb -- 
            ,use_balance -- 
            ,price_type -- 
            ,interest_rate_type -- 
            ,stock_pledge_name -- 
            ,guarantee_mode -- 
            ,guarantor_type -- 
            ,guarantor_name -- 
            ,guarantor_card_no -- 
            ,money_direction -- 
            ,related_amount -- 
            ,invest_desc -- 
            ,trans_price -- 
            ,pricing_strategy -- 
            ,trans_desc -- 
            ,remarks -- 
            ,create_time -- 
            ,create_org -- 
            ,agent_in_charge -- 
            ,responsible_department -- 
            ,financial_name -- 
            ,product_issue_no -- 
            ,five_level_type -- 
            ,npl_ye -- 
            ,overdue_state -- 
            ,ol_je -- 
            ,credit_status -- 
            ,security_amount -- 
            ,bank_certificate_amount -- 
            ,tb_amount -- 
            ,etl_dt -- 
            ,id -- 
            ,bus_id -- 
            ,aplv_flow_num -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bus_dep -- 
    ,o.is_bank_business -- 
    ,o.system_bus_name -- 
    ,o.cust_no -- 
    ,o.rp_name -- 
    ,o.ybj_rp_card_type -- 
    ,o.rp_card_no -- 
    ,o.rp_bloc_name -- 
    ,o.rp_bloc_no -- 
    ,o.product_name -- 
    ,o.product_code -- 
    ,o.contract_no -- 
    ,o.sign_date -- 
    ,o.sign_end_date -- 
    ,o.credit_dead_line -- 
    ,o.trans_start_date -- 
    ,o.trans_end_date -- 
    ,o.curr_code -- 
    ,o.trans_amount -- 
    ,o.foreign_curr_to_rmb -- 
    ,o.use_balance -- 
    ,o.price_type -- 
    ,o.interest_rate_type -- 
    ,o.stock_pledge_name -- 
    ,o.guarantee_mode -- 
    ,o.guarantor_type -- 
    ,o.guarantor_name -- 
    ,o.guarantor_card_no -- 
    ,o.money_direction -- 
    ,o.related_amount -- 
    ,o.invest_desc -- 
    ,o.trans_price -- 
    ,o.pricing_strategy -- 
    ,o.trans_desc -- 
    ,o.remarks -- 
    ,o.create_time -- 
    ,o.create_org -- 
    ,o.agent_in_charge -- 
    ,o.responsible_department -- 
    ,o.financial_name -- 
    ,o.product_issue_no -- 
    ,o.five_level_type -- 
    ,o.npl_ye -- 
    ,o.overdue_state -- 
    ,o.ol_je -- 
    ,o.credit_status -- 
    ,o.security_amount -- 
    ,o.bank_certificate_amount -- 
    ,o.tb_amount -- 
    ,o.etl_dt -- 
    ,o.id -- 
    ,o.bus_id -- 
    ,o.aplv_flow_num -- 
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
from ${iol_schema}.rptm_rtm_trade_aft_collect_credit_bk o
    left join ${iol_schema}.rptm_rtm_trade_aft_collect_credit_op n
        on

            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rptm_rtm_trade_aft_collect_credit_cl d
        on

where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rptm_rtm_trade_aft_collect_credit;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rptm_rtm_trade_aft_collect_credit') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rptm_rtm_trade_aft_collect_credit drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rptm_rtm_trade_aft_collect_credit add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rptm_rtm_trade_aft_collect_credit exchange partition p_${batch_date} with table ${iol_schema}.rptm_rtm_trade_aft_collect_credit_cl;
alter table ${iol_schema}.rptm_rtm_trade_aft_collect_credit exchange partition p_20991231 with table ${iol_schema}.rptm_rtm_trade_aft_collect_credit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rptm_rtm_trade_aft_collect_credit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_trade_aft_collect_credit_op purge;
drop table ${iol_schema}.rptm_rtm_trade_aft_collect_credit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rptm_rtm_trade_aft_collect_credit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rptm_rtm_trade_aft_collect_credit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
