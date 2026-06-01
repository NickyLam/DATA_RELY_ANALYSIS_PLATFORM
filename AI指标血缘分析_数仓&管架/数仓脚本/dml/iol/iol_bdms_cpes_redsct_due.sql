/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_redsct_due
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
create table ${iol_schema}.bdms_cpes_redsct_due_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_redsct_due;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_redsct_due_op purge;
drop table ${iol_schema}.bdms_cpes_redsct_due_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_redsct_due_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_redsct_due where 0=1;

create table ${iol_schema}.bdms_cpes_redsct_due_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_redsct_due where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_redsct_due_cl(
            id -- 
            ,org_contract_id -- 原业务批次表ID
            ,contract_no -- 批次号
            ,busi_date -- 业务日期
            ,busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
            ,settle_type -- 清结算业务类型： RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
            ,product_no -- 产品号
            ,deal_no -- 成交单编号
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,facct_no -- 资金账号
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,real_settle_amount -- 实际结算金额
            ,settle_draft_num -- 结算票据张数
            ,settle_pay_interest -- 结算应付利息
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,settle_status -- 清结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_redsct_due_op(
            id -- 
            ,org_contract_id -- 原业务批次表ID
            ,contract_no -- 批次号
            ,busi_date -- 业务日期
            ,busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
            ,settle_type -- 清结算业务类型： RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
            ,product_no -- 产品号
            ,deal_no -- 成交单编号
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,facct_no -- 资金账号
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,real_settle_amount -- 实际结算金额
            ,settle_draft_num -- 结算票据张数
            ,settle_pay_interest -- 结算应付利息
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,settle_status -- 清结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.org_contract_id, o.org_contract_id) as org_contract_id -- 原业务批次表ID
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 批次号
    ,nvl(n.busi_date, o.busi_date) as busi_date -- 业务日期
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 清结算业务类型： RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.deal_no, o.deal_no) as deal_no -- 成交单编号
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 业务机构号
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.facct_no, o.facct_no) as facct_no -- 资金账号
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 账务机构号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易员ID
    ,nvl(n.real_settle_amount, o.real_settle_amount) as real_settle_amount -- 实际结算金额
    ,nvl(n.settle_draft_num, o.settle_draft_num) as settle_draft_num -- 结算票据张数
    ,nvl(n.settle_pay_interest, o.settle_pay_interest) as settle_pay_interest -- 结算应付利息
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 清结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.reserver1, o.reserver1) as reserver1 -- 预留域1
    ,nvl(n.reserver2, o.reserver2) as reserver2 -- 预留域2
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_cpes_redsct_due_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_redsct_due where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.org_contract_id <> n.org_contract_id
        or o.contract_no <> n.contract_no
        or o.busi_date <> n.busi_date
        or o.busi_type <> n.busi_type
        or o.settle_type <> n.settle_type
        or o.product_no <> n.product_no
        or o.deal_no <> n.deal_no
        or o.busi_branch_no <> n.busi_branch_no
        or o.top_branch_no <> n.top_branch_no
        or o.facct_no <> n.facct_no
        or o.acct_branch_no <> n.acct_branch_no
        or o.user_id <> n.user_id
        or o.real_settle_amount <> n.real_settle_amount
        or o.settle_draft_num <> n.settle_draft_num
        or o.settle_pay_interest <> n.settle_pay_interest
        or o.account_status <> n.account_status
        or o.settle_status <> n.settle_status
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.reserver1 <> n.reserver1
        or o.reserver2 <> n.reserver2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_redsct_due_cl(
            id -- 
            ,org_contract_id -- 原业务批次表ID
            ,contract_no -- 批次号
            ,busi_date -- 业务日期
            ,busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
            ,settle_type -- 清结算业务类型： RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
            ,product_no -- 产品号
            ,deal_no -- 成交单编号
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,facct_no -- 资金账号
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,real_settle_amount -- 实际结算金额
            ,settle_draft_num -- 结算票据张数
            ,settle_pay_interest -- 结算应付利息
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,settle_status -- 清结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_redsct_due_op(
            id -- 
            ,org_contract_id -- 原业务批次表ID
            ,contract_no -- 批次号
            ,busi_date -- 业务日期
            ,busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
            ,settle_type -- 清结算业务类型： RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
            ,product_no -- 产品号
            ,deal_no -- 成交单编号
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,facct_no -- 资金账号
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,real_settle_amount -- 实际结算金额
            ,settle_draft_num -- 结算票据张数
            ,settle_pay_interest -- 结算应付利息
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,settle_status -- 清结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.org_contract_id -- 原业务批次表ID
    ,o.contract_no -- 批次号
    ,o.busi_date -- 业务日期
    ,o.busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
    ,o.settle_type -- 清结算业务类型： RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
    ,o.product_no -- 产品号
    ,o.deal_no -- 成交单编号
    ,o.busi_branch_no -- 业务机构号
    ,o.top_branch_no -- 总行机构号
    ,o.facct_no -- 资金账号
    ,o.acct_branch_no -- 账务机构号
    ,o.user_id -- 交易员ID
    ,o.real_settle_amount -- 实际结算金额
    ,o.settle_draft_num -- 结算票据张数
    ,o.settle_pay_interest -- 结算应付利息
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.settle_status -- 清结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,o.last_upd_opr -- 最后操作人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.reserver1 -- 预留域1
    ,o.reserver2 -- 预留域2
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cpes_redsct_due_bk o
    left join ${iol_schema}.bdms_cpes_redsct_due_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_redsct_due_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.bdms_cpes_redsct_due;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_cpes_redsct_due exchange partition p_19000101 with table ${iol_schema}.bdms_cpes_redsct_due_cl;
alter table ${iol_schema}.bdms_cpes_redsct_due exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_redsct_due_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_redsct_due to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_redsct_due_op purge;
drop table ${iol_schema}.bdms_cpes_redsct_due_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_redsct_due_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_redsct_due',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
