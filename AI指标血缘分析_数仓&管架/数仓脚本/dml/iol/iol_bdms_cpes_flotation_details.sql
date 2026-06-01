/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_flotation_details
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
create table ${iol_schema}.bdms_cpes_flotation_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_flotation_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_flotation_details_op purge;
drop table ${iol_schema}.bdms_cpes_flotation_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_flotation_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_flotation_details where 0=1;

create table ${iol_schema}.bdms_cpes_flotation_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_flotation_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_flotation_details_cl(
            id -- ID
            ,contract_id -- 批次表ID
            ,draft_id -- 票据表ID
            ,quote_no -- 报价单编号
            ,trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
            ,trade_brh_no -- 贴现机构代码
            ,trade_user_id -- 贴现交易员ID
            ,draft_number -- 票据号码
            ,draft_amt -- 票据金额
            ,maturity_date -- 票据到期日
            ,real_maturity_date -- 票据实际到期日
            ,tenor_day -- 剩余期限
            ,pay_int -- 应付利息
            ,settle_amt -- 结算金额
            ,dscnt_entry_acct -- 贴现申请人账号
            ,dscnt_entry_bank_no -- 贴现申请人开户行行号
            ,drawer_name -- 出票人名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_bank_no -- 承兑人开户行号
            ,flot_status -- 挂牌询价单状态： DES01 已保存 DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认 DES05 成交待确认 DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单 DES11 摘牌待确认
            ,message_status -- 报文处理状态： 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答成功 32 应答确认成功 33 应答确认失败
            ,delist_time -- 摘牌时间
            ,process_code -- 处理码
            ,process_msg -- 处理信息
            ,deal_id -- 成交单表ID
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后操作时间
            ,misc -- 备注域
            ,sub_range -- 子票据区间
            ,product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
            ,standard_amount -- 标准金额
            ,settle_status -- 结算状态： R20 结算成功 R21 结算失败
            ,dpc_draft_id -- 登记中心票据ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_flotation_details_op(
            id -- ID
            ,contract_id -- 批次表ID
            ,draft_id -- 票据表ID
            ,quote_no -- 报价单编号
            ,trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
            ,trade_brh_no -- 贴现机构代码
            ,trade_user_id -- 贴现交易员ID
            ,draft_number -- 票据号码
            ,draft_amt -- 票据金额
            ,maturity_date -- 票据到期日
            ,real_maturity_date -- 票据实际到期日
            ,tenor_day -- 剩余期限
            ,pay_int -- 应付利息
            ,settle_amt -- 结算金额
            ,dscnt_entry_acct -- 贴现申请人账号
            ,dscnt_entry_bank_no -- 贴现申请人开户行行号
            ,drawer_name -- 出票人名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_bank_no -- 承兑人开户行号
            ,flot_status -- 挂牌询价单状态： DES01 已保存 DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认 DES05 成交待确认 DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单 DES11 摘牌待确认
            ,message_status -- 报文处理状态： 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答成功 32 应答确认成功 33 应答确认失败
            ,delist_time -- 摘牌时间
            ,process_code -- 处理码
            ,process_msg -- 处理信息
            ,deal_id -- 成交单表ID
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后操作时间
            ,misc -- 备注域
            ,sub_range -- 子票据区间
            ,product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
            ,standard_amount -- 标准金额
            ,settle_status -- 结算状态： R20 结算成功 R21 结算失败
            ,dpc_draft_id -- 登记中心票据ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 批次表ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据表ID
    ,nvl(n.quote_no, o.quote_no) as quote_no -- 报价单编号
    ,nvl(n.trade_direct, o.trade_direct) as trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
    ,nvl(n.trade_brh_no, o.trade_brh_no) as trade_brh_no -- 贴现机构代码
    ,nvl(n.trade_user_id, o.trade_user_id) as trade_user_id -- 贴现交易员ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码
    ,nvl(n.draft_amt, o.draft_amt) as draft_amt -- 票据金额
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 票据到期日
    ,nvl(n.real_maturity_date, o.real_maturity_date) as real_maturity_date -- 票据实际到期日
    ,nvl(n.tenor_day, o.tenor_day) as tenor_day -- 剩余期限
    ,nvl(n.pay_int, o.pay_int) as pay_int -- 应付利息
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 结算金额
    ,nvl(n.dscnt_entry_acct, o.dscnt_entry_acct) as dscnt_entry_acct -- 贴现申请人账号
    ,nvl(n.dscnt_entry_bank_no, o.dscnt_entry_bank_no) as dscnt_entry_bank_no -- 贴现申请人开户行行号
    ,nvl(n.drawer_name, o.drawer_name) as drawer_name -- 出票人名称
    ,nvl(n.acceptor_name, o.acceptor_name) as acceptor_name -- 承兑人名称
    ,nvl(n.acceptor_bank_no, o.acceptor_bank_no) as acceptor_bank_no -- 承兑人开户行号
    ,nvl(n.flot_status, o.flot_status) as flot_status -- 挂牌询价单状态： DES01 已保存 DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认 DES05 成交待确认 DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单 DES11 摘牌待确认
    ,nvl(n.message_status, o.message_status) as message_status -- 报文处理状态： 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答成功 32 应答确认成功 33 应答确认失败
    ,nvl(n.delist_time, o.delist_time) as delist_time -- 摘牌时间
    ,nvl(n.process_code, o.process_code) as process_code -- 处理码
    ,nvl(n.process_msg, o.process_msg) as process_msg -- 处理信息
    ,nvl(n.deal_id, o.deal_id) as deal_id -- 成交单表ID
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后操作时间
    ,nvl(n.misc, o.misc) as misc -- 备注域
    ,nvl(n.sub_range, o.sub_range) as sub_range -- 子票据区间
    ,nvl(n.product_type, o.product_type) as product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
    ,nvl(n.standard_amount, o.standard_amount) as standard_amount -- 标准金额
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 结算状态： R20 结算成功 R21 结算失败
    ,nvl(n.dpc_draft_id, o.dpc_draft_id) as dpc_draft_id -- 登记中心票据ID
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
from (select * from ${iol_schema}.bdms_cpes_flotation_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_flotation_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_id <> n.contract_id
        or o.draft_id <> n.draft_id
        or o.quote_no <> n.quote_no
        or o.trade_direct <> n.trade_direct
        or o.trade_brh_no <> n.trade_brh_no
        or o.trade_user_id <> n.trade_user_id
        or o.draft_number <> n.draft_number
        or o.draft_amt <> n.draft_amt
        or o.maturity_date <> n.maturity_date
        or o.real_maturity_date <> n.real_maturity_date
        or o.tenor_day <> n.tenor_day
        or o.pay_int <> n.pay_int
        or o.settle_amt <> n.settle_amt
        or o.dscnt_entry_acct <> n.dscnt_entry_acct
        or o.dscnt_entry_bank_no <> n.dscnt_entry_bank_no
        or o.drawer_name <> n.drawer_name
        or o.acceptor_name <> n.acceptor_name
        or o.acceptor_bank_no <> n.acceptor_bank_no
        or o.flot_status <> n.flot_status
        or o.message_status <> n.message_status
        or o.delist_time <> n.delist_time
        or o.process_code <> n.process_code
        or o.process_msg <> n.process_msg
        or o.deal_id <> n.deal_id
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.sub_range <> n.sub_range
        or o.product_type <> n.product_type
        or o.standard_amount <> n.standard_amount
        or o.settle_status <> n.settle_status
        or o.dpc_draft_id <> n.dpc_draft_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_flotation_details_cl(
            id -- ID
            ,contract_id -- 批次表ID
            ,draft_id -- 票据表ID
            ,quote_no -- 报价单编号
            ,trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
            ,trade_brh_no -- 贴现机构代码
            ,trade_user_id -- 贴现交易员ID
            ,draft_number -- 票据号码
            ,draft_amt -- 票据金额
            ,maturity_date -- 票据到期日
            ,real_maturity_date -- 票据实际到期日
            ,tenor_day -- 剩余期限
            ,pay_int -- 应付利息
            ,settle_amt -- 结算金额
            ,dscnt_entry_acct -- 贴现申请人账号
            ,dscnt_entry_bank_no -- 贴现申请人开户行行号
            ,drawer_name -- 出票人名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_bank_no -- 承兑人开户行号
            ,flot_status -- 挂牌询价单状态： DES01 已保存 DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认 DES05 成交待确认 DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单 DES11 摘牌待确认
            ,message_status -- 报文处理状态： 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答成功 32 应答确认成功 33 应答确认失败
            ,delist_time -- 摘牌时间
            ,process_code -- 处理码
            ,process_msg -- 处理信息
            ,deal_id -- 成交单表ID
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后操作时间
            ,misc -- 备注域
            ,sub_range -- 子票据区间
            ,product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
            ,standard_amount -- 标准金额
            ,settle_status -- 结算状态： R20 结算成功 R21 结算失败
            ,dpc_draft_id -- 登记中心票据ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_flotation_details_op(
            id -- ID
            ,contract_id -- 批次表ID
            ,draft_id -- 票据表ID
            ,quote_no -- 报价单编号
            ,trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
            ,trade_brh_no -- 贴现机构代码
            ,trade_user_id -- 贴现交易员ID
            ,draft_number -- 票据号码
            ,draft_amt -- 票据金额
            ,maturity_date -- 票据到期日
            ,real_maturity_date -- 票据实际到期日
            ,tenor_day -- 剩余期限
            ,pay_int -- 应付利息
            ,settle_amt -- 结算金额
            ,dscnt_entry_acct -- 贴现申请人账号
            ,dscnt_entry_bank_no -- 贴现申请人开户行行号
            ,drawer_name -- 出票人名称
            ,acceptor_name -- 承兑人名称
            ,acceptor_bank_no -- 承兑人开户行号
            ,flot_status -- 挂牌询价单状态： DES01 已保存 DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认 DES05 成交待确认 DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单 DES11 摘牌待确认
            ,message_status -- 报文处理状态： 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答成功 32 应答确认成功 33 应答确认失败
            ,delist_time -- 摘牌时间
            ,process_code -- 处理码
            ,process_msg -- 处理信息
            ,deal_id -- 成交单表ID
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后操作时间
            ,misc -- 备注域
            ,sub_range -- 子票据区间
            ,product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
            ,standard_amount -- 标准金额
            ,settle_status -- 结算状态： R20 结算成功 R21 结算失败
            ,dpc_draft_id -- 登记中心票据ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.contract_id -- 批次表ID
    ,o.draft_id -- 票据表ID
    ,o.quote_no -- 报价单编号
    ,o.trade_direct -- 交易方向： TDD01 贴入 TDD02 贴出
    ,o.trade_brh_no -- 贴现机构代码
    ,o.trade_user_id -- 贴现交易员ID
    ,o.draft_number -- 票据号码
    ,o.draft_amt -- 票据金额
    ,o.maturity_date -- 票据到期日
    ,o.real_maturity_date -- 票据实际到期日
    ,o.tenor_day -- 剩余期限
    ,o.pay_int -- 应付利息
    ,o.settle_amt -- 结算金额
    ,o.dscnt_entry_acct -- 贴现申请人账号
    ,o.dscnt_entry_bank_no -- 贴现申请人开户行行号
    ,o.drawer_name -- 出票人名称
    ,o.acceptor_name -- 承兑人名称
    ,o.acceptor_bank_no -- 承兑人开户行号
    ,o.flot_status -- 挂牌询价单状态： DES01 已保存 DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认 DES05 成交待确认 DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单 DES11 摘牌待确认
    ,o.message_status -- 报文处理状态： 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答成功 32 应答确认成功 33 应答确认失败
    ,o.delist_time -- 摘牌时间
    ,o.process_code -- 处理码
    ,o.process_msg -- 处理信息
    ,o.deal_id -- 成交单表ID
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后操作时间
    ,o.misc -- 备注域
    ,o.sub_range -- 子票据区间
    ,o.product_type -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
    ,o.standard_amount -- 标准金额
    ,o.settle_status -- 结算状态： R20 结算成功 R21 结算失败
    ,o.dpc_draft_id -- 登记中心票据ID
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
from ${iol_schema}.bdms_cpes_flotation_details_bk o
    left join ${iol_schema}.bdms_cpes_flotation_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_flotation_details_cl d
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
--truncate table ${iol_schema}.bdms_cpes_flotation_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_flotation_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_flotation_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_flotation_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_flotation_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_flotation_details_cl;
alter table ${iol_schema}.bdms_cpes_flotation_details exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_flotation_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_flotation_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_flotation_details_op purge;
drop table ${iol_schema}.bdms_cpes_flotation_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_flotation_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_flotation_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
