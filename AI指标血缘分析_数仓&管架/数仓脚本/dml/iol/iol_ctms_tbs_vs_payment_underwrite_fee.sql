/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_payment_underwrite_fee
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
create table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee where 0=1;

create table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cpty_name -- 成交编号
            ,security_code -- 债券代码
            ,fee -- 手续费
            ,trade_date -- 交易日
            ,value_date -- 交割日
            ,trade_type -- 交易类型
            ,note -- 备注
            ,serial_number -- 交易序号
            ,uw_trade_no -- 原承分销交易addon序号
            ,uw_trade_id -- 原承分销交易F2B编号
            ,review_status -- 复核状态(前台)
            ,trade_time -- 交易时间
            ,dealer_id -- 交易员ID
            ,dealer_name -- 交易员名称
            ,orig_serial_number -- 原始交易编号
            ,link_serial_number -- 父原始交易序号
            ,status -- 状态
            ,process_status -- 原始处理状态
            ,impstatus -- 导入状态
            ,prostatus -- 处理状态
            ,lastmodified -- 最近更新时间
            ,datasymbol_id -- 数据源引用ID
            ,user_number -- addon 交易输入用户编号
            ,modify_user -- 修改人员
            ,modify_date -- addon交易录入日
            ,counterparty_seq -- addon交易对手序号
            ,ori_trade_date -- 原始交易日期
            ,fee_type -- 手续费类型
            ,cust_key -- 交易对手
            ,underwrite_fee_id_grand -- 原始交易ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,dn_dealer -- 本币交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cpty_name -- 成交编号
            ,security_code -- 债券代码
            ,fee -- 手续费
            ,trade_date -- 交易日
            ,value_date -- 交割日
            ,trade_type -- 交易类型
            ,note -- 备注
            ,serial_number -- 交易序号
            ,uw_trade_no -- 原承分销交易addon序号
            ,uw_trade_id -- 原承分销交易F2B编号
            ,review_status -- 复核状态(前台)
            ,trade_time -- 交易时间
            ,dealer_id -- 交易员ID
            ,dealer_name -- 交易员名称
            ,orig_serial_number -- 原始交易编号
            ,link_serial_number -- 父原始交易序号
            ,status -- 状态
            ,process_status -- 原始处理状态
            ,impstatus -- 导入状态
            ,prostatus -- 处理状态
            ,lastmodified -- 最近更新时间
            ,datasymbol_id -- 数据源引用ID
            ,user_number -- addon 交易输入用户编号
            ,modify_user -- 修改人员
            ,modify_date -- addon交易录入日
            ,counterparty_seq -- addon交易对手序号
            ,ori_trade_date -- 原始交易日期
            ,fee_type -- 手续费类型
            ,cust_key -- 交易对手
            ,underwrite_fee_id_grand -- 原始交易ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,dn_dealer -- 本币交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deal_id, o.deal_id) as deal_id -- 引用表ID
    ,nvl(n.deal_name, o.deal_name) as deal_name -- 引用表名
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门编号
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 交易组别
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 交易组别名称
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 账户名称
    ,nvl(n.cpty_name, o.cpty_name) as cpty_name -- 成交编号
    ,nvl(n.security_code, o.security_code) as security_code -- 债券代码
    ,nvl(n.fee, o.fee) as fee -- 手续费
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 交易日
    ,nvl(n.value_date, o.value_date) as value_date -- 交割日
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 交易类型
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 交易序号
    ,nvl(n.uw_trade_no, o.uw_trade_no) as uw_trade_no -- 原承分销交易addon序号
    ,nvl(n.uw_trade_id, o.uw_trade_id) as uw_trade_id -- 原承分销交易F2B编号
    ,nvl(n.review_status, o.review_status) as review_status -- 复核状态(前台)
    ,nvl(n.trade_time, o.trade_time) as trade_time -- 交易时间
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员ID
    ,nvl(n.dealer_name, o.dealer_name) as dealer_name -- 交易员名称
    ,nvl(n.orig_serial_number, o.orig_serial_number) as orig_serial_number -- 原始交易编号
    ,nvl(n.link_serial_number, o.link_serial_number) as link_serial_number -- 父原始交易序号
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.process_status, o.process_status) as process_status -- 原始处理状态
    ,nvl(n.impstatus, o.impstatus) as impstatus -- 导入状态
    ,nvl(n.prostatus, o.prostatus) as prostatus -- 处理状态
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最近更新时间
    ,nvl(n.datasymbol_id, o.datasymbol_id) as datasymbol_id -- 数据源引用ID
    ,nvl(n.user_number, o.user_number) as user_number -- addon 交易输入用户编号
    ,nvl(n.modify_user, o.modify_user) as modify_user -- 修改人员
    ,nvl(n.modify_date, o.modify_date) as modify_date -- addon交易录入日
    ,nvl(n.counterparty_seq, o.counterparty_seq) as counterparty_seq -- addon交易对手序号
    ,nvl(n.ori_trade_date, o.ori_trade_date) as ori_trade_date -- 原始交易日期
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 手续费类型
    ,nvl(n.cust_key, o.cust_key) as cust_key -- 交易对手
    ,nvl(n.underwrite_fee_id_grand, o.underwrite_fee_id_grand) as underwrite_fee_id_grand -- 原始交易ID
    ,nvl(n.lastmodified_pay, o.lastmodified_pay) as lastmodified_pay -- 实收付确认的修改时间
    ,nvl(n.dn_dealer, o.dn_dealer) as dn_dealer -- 本币交易员
    ,case when
            n.deal_id is null
            and n.deal_name is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.deal_id is null
            and n.deal_name is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.deal_id is null
            and n.deal_name is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_payment_underwrite_fee where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.deal_id = n.deal_id
            and o.deal_name = n.deal_name
where (
        o.deal_id is null
        and o.deal_name is null
    )
    or (
        n.deal_id is null
        and n.deal_name is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.keepfolder_id <> n.keepfolder_id
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.cpty_name <> n.cpty_name
        or o.security_code <> n.security_code
        or o.fee <> n.fee
        or o.trade_date <> n.trade_date
        or o.value_date <> n.value_date
        or o.trade_type <> n.trade_type
        or o.note <> n.note
        or o.serial_number <> n.serial_number
        or o.uw_trade_no <> n.uw_trade_no
        or o.uw_trade_id <> n.uw_trade_id
        or o.review_status <> n.review_status
        or o.trade_time <> n.trade_time
        or o.dealer_id <> n.dealer_id
        or o.dealer_name <> n.dealer_name
        or o.orig_serial_number <> n.orig_serial_number
        or o.link_serial_number <> n.link_serial_number
        or o.status <> n.status
        or o.process_status <> n.process_status
        or o.impstatus <> n.impstatus
        or o.prostatus <> n.prostatus
        or o.lastmodified <> n.lastmodified
        or o.datasymbol_id <> n.datasymbol_id
        or o.user_number <> n.user_number
        or o.modify_user <> n.modify_user
        or o.modify_date <> n.modify_date
        or o.counterparty_seq <> n.counterparty_seq
        or o.ori_trade_date <> n.ori_trade_date
        or o.fee_type <> n.fee_type
        or o.cust_key <> n.cust_key
        or o.underwrite_fee_id_grand <> n.underwrite_fee_id_grand
        or o.lastmodified_pay <> n.lastmodified_pay
        or o.dn_dealer <> n.dn_dealer
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cpty_name -- 成交编号
            ,security_code -- 债券代码
            ,fee -- 手续费
            ,trade_date -- 交易日
            ,value_date -- 交割日
            ,trade_type -- 交易类型
            ,note -- 备注
            ,serial_number -- 交易序号
            ,uw_trade_no -- 原承分销交易addon序号
            ,uw_trade_id -- 原承分销交易F2B编号
            ,review_status -- 复核状态(前台)
            ,trade_time -- 交易时间
            ,dealer_id -- 交易员ID
            ,dealer_name -- 交易员名称
            ,orig_serial_number -- 原始交易编号
            ,link_serial_number -- 父原始交易序号
            ,status -- 状态
            ,process_status -- 原始处理状态
            ,impstatus -- 导入状态
            ,prostatus -- 处理状态
            ,lastmodified -- 最近更新时间
            ,datasymbol_id -- 数据源引用ID
            ,user_number -- addon 交易输入用户编号
            ,modify_user -- 修改人员
            ,modify_date -- addon交易录入日
            ,counterparty_seq -- addon交易对手序号
            ,ori_trade_date -- 原始交易日期
            ,fee_type -- 手续费类型
            ,cust_key -- 交易对手
            ,underwrite_fee_id_grand -- 原始交易ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,dn_dealer -- 本币交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cpty_name -- 成交编号
            ,security_code -- 债券代码
            ,fee -- 手续费
            ,trade_date -- 交易日
            ,value_date -- 交割日
            ,trade_type -- 交易类型
            ,note -- 备注
            ,serial_number -- 交易序号
            ,uw_trade_no -- 原承分销交易addon序号
            ,uw_trade_id -- 原承分销交易F2B编号
            ,review_status -- 复核状态(前台)
            ,trade_time -- 交易时间
            ,dealer_id -- 交易员ID
            ,dealer_name -- 交易员名称
            ,orig_serial_number -- 原始交易编号
            ,link_serial_number -- 父原始交易序号
            ,status -- 状态
            ,process_status -- 原始处理状态
            ,impstatus -- 导入状态
            ,prostatus -- 处理状态
            ,lastmodified -- 最近更新时间
            ,datasymbol_id -- 数据源引用ID
            ,user_number -- addon 交易输入用户编号
            ,modify_user -- 修改人员
            ,modify_date -- addon交易录入日
            ,counterparty_seq -- addon交易对手序号
            ,ori_trade_date -- 原始交易日期
            ,fee_type -- 手续费类型
            ,cust_key -- 交易对手
            ,underwrite_fee_id_grand -- 原始交易ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,dn_dealer -- 本币交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deal_id -- 引用表ID
    ,o.deal_name -- 引用表名
    ,o.aspclient_id -- 部门编号
    ,o.portfolio_id -- 交易组别
    ,o.portfolio_name -- 交易组别名称
    ,o.keepfolder_id -- 账户ID
    ,o.keepfolder_shortname -- 账户名称
    ,o.cpty_name -- 成交编号
    ,o.security_code -- 债券代码
    ,o.fee -- 手续费
    ,o.trade_date -- 交易日
    ,o.value_date -- 交割日
    ,o.trade_type -- 交易类型
    ,o.note -- 备注
    ,o.serial_number -- 交易序号
    ,o.uw_trade_no -- 原承分销交易addon序号
    ,o.uw_trade_id -- 原承分销交易F2B编号
    ,o.review_status -- 复核状态(前台)
    ,o.trade_time -- 交易时间
    ,o.dealer_id -- 交易员ID
    ,o.dealer_name -- 交易员名称
    ,o.orig_serial_number -- 原始交易编号
    ,o.link_serial_number -- 父原始交易序号
    ,o.status -- 状态
    ,o.process_status -- 原始处理状态
    ,o.impstatus -- 导入状态
    ,o.prostatus -- 处理状态
    ,o.lastmodified -- 最近更新时间
    ,o.datasymbol_id -- 数据源引用ID
    ,o.user_number -- addon 交易输入用户编号
    ,o.modify_user -- 修改人员
    ,o.modify_date -- addon交易录入日
    ,o.counterparty_seq -- addon交易对手序号
    ,o.ori_trade_date -- 原始交易日期
    ,o.fee_type -- 手续费类型
    ,o.cust_key -- 交易对手
    ,o.underwrite_fee_id_grand -- 原始交易ID
    ,o.lastmodified_pay -- 实收付确认的修改时间
    ,o.dn_dealer -- 本币交易员
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_bk o
    left join ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_op n
        on
            o.deal_id = n.deal_id
            and o.deal_name = n.deal_name
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_cl d
        on
            o.deal_id = d.deal_id
            and o.deal_name = d.deal_name
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_cl;
alter table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_payment_underwrite_fee_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_payment_underwrite_fee',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
