/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_anoclick_due
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
create table ${iol_schema}.bdms_cpes_anoclick_due_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_anoclick_due;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_anoclick_due_op purge;
drop table ${iol_schema}.bdms_cpes_anoclick_due_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_anoclick_due_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_anoclick_due where 0=1;

create table ${iol_schema}.bdms_cpes_anoclick_due_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_anoclick_due where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_anoclick_due_cl(
            id -- ID
            ,contract_no -- 协议号
            ,busi_date -- 业务日期
            ,org_cpes_match_contract_id -- 原匹配批次ID
            ,product_no -- 产品号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,deal_no -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,busi_branch_no -- 业务机构号
            ,facct_no -- 资金账号
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作员
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
        into ${iol_schema}.bdms_cpes_anoclick_due_op(
            id -- ID
            ,contract_no -- 协议号
            ,busi_date -- 业务日期
            ,org_cpes_match_contract_id -- 原匹配批次ID
            ,product_no -- 产品号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,deal_no -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,busi_branch_no -- 业务机构号
            ,facct_no -- 资金账号
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作员
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
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 协议号
    ,nvl(n.busi_date, o.busi_date) as busi_date -- 业务日期
    ,nvl(n.org_cpes_match_contract_id, o.org_cpes_match_contract_id) as org_cpes_match_contract_id -- 原匹配批次ID
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,nvl(n.deal_no, o.deal_no) as deal_no -- 成交单编号
    ,nvl(n.trade_direct, o.trade_direct) as trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 业务机构号
    ,nvl(n.facct_no, o.facct_no) as facct_no -- 资金账号
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 账务机构号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易员ID
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
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
from (select * from ${iol_schema}.bdms_cpes_anoclick_due_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_anoclick_due where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_no <> n.contract_no
        or o.busi_date <> n.busi_date
        or o.org_cpes_match_contract_id <> n.org_cpes_match_contract_id
        or o.product_no <> n.product_no
        or o.busi_type <> n.busi_type
        or o.deal_no <> n.deal_no
        or o.trade_direct <> n.trade_direct
        or o.busi_branch_no <> n.busi_branch_no
        or o.facct_no <> n.facct_no
        or o.acct_branch_no <> n.acct_branch_no
        or o.user_id <> n.user_id
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
        into ${iol_schema}.bdms_cpes_anoclick_due_cl(
            id -- ID
            ,contract_no -- 协议号
            ,busi_date -- 业务日期
            ,org_cpes_match_contract_id -- 原匹配批次ID
            ,product_no -- 产品号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,deal_no -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,busi_branch_no -- 业务机构号
            ,facct_no -- 资金账号
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作员
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
        into ${iol_schema}.bdms_cpes_anoclick_due_op(
            id -- ID
            ,contract_no -- 协议号
            ,busi_date -- 业务日期
            ,org_cpes_match_contract_id -- 原匹配批次ID
            ,product_no -- 产品号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,deal_no -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
            ,busi_branch_no -- 业务机构号
            ,facct_no -- 资金账号
            ,acct_branch_no -- 账务机构号
            ,user_id -- 交易员ID
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,last_upd_opr -- 最后操作员
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
    o.id -- ID
    ,o.contract_no -- 协议号
    ,o.busi_date -- 业务日期
    ,o.org_cpes_match_contract_id -- 原匹配批次ID
    ,o.product_no -- 产品号
    ,o.busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,o.deal_no -- 成交单编号
    ,o.trade_direct -- 交易方向： TDD01 买入 TDD02 卖出
    ,o.busi_branch_no -- 业务机构号
    ,o.facct_no -- 资金账号
    ,o.acct_branch_no -- 账务机构号
    ,o.user_id -- 交易员ID
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,o.last_upd_opr -- 最后操作员
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
from ${iol_schema}.bdms_cpes_anoclick_due_bk o
    left join ${iol_schema}.bdms_cpes_anoclick_due_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_anoclick_due_cl d
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
-- truncate table ${iol_schema}.bdms_cpes_anoclick_due;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_cpes_anoclick_due exchange partition p_19000101 with table ${iol_schema}.bdms_cpes_anoclick_due_cl;
alter table ${iol_schema}.bdms_cpes_anoclick_due exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_anoclick_due_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_anoclick_due to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_anoclick_due_op purge;
drop table ${iol_schema}.bdms_cpes_anoclick_due_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_anoclick_due_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_anoclick_due',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
