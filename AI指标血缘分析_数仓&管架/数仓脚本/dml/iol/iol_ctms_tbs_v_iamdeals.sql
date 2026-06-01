/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_iamdeals
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
create table ${iol_schema}.ctms_tbs_v_iamdeals_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_iamdeals
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_iamdeals_op purge;
drop table ${iol_schema}.ctms_tbs_v_iamdeals_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_iamdeals_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_iamdeals where 0=1;

create table ${iol_schema}.ctms_tbs_v_iamdeals_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_iamdeals where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_iamdeals_cl(
            deal_id -- 引用表id
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,serial_number -- 交易号(标识数据表中记录的唯一组合)
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,repo_rate -- 拆借利率
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户id
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手id
            ,dealer_id -- 交易员id
            ,dealer_name -- 交易员姓名
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是cfets交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源id
            ,repo_days -- 拆借天数
            ,iamdeals_id_grand -- 原始交易id
            ,note -- 备注
            ,counterparty_type -- 交易类别
            ,repo_id -- 交易品种
            ,dn_dealer -- 本币交易员
            ,trade_time -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_iamdeals_op(
            deal_id -- 引用表id
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,serial_number -- 交易号(标识数据表中记录的唯一组合)
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,repo_rate -- 拆借利率
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户id
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手id
            ,dealer_id -- 交易员id
            ,dealer_name -- 交易员姓名
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是cfets交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源id
            ,repo_days -- 拆借天数
            ,iamdeals_id_grand -- 原始交易id
            ,note -- 备注
            ,counterparty_type -- 交易类别
            ,repo_id -- 交易品种
            ,dn_dealer -- 本币交易员
            ,trade_time -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deal_id, o.deal_id) as deal_id -- 引用表id
    ,nvl(n.deal_tablename, o.deal_tablename) as deal_tablename -- 引用表名
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门编号
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 交易号(标识数据表中记录的唯一组合)
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 首期交易日
    ,nvl(n.value_date, o.value_date) as value_date -- 首期交割日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期交割日
    ,nvl(n.buyorsell, o.buyorsell) as buyorsell -- 交易方向
    ,nvl(n.repo_rate, o.repo_rate) as repo_rate -- 拆借利率
    ,nvl(n.amount, o.amount) as amount -- 首期结算金额
    ,nvl(n.maturity_amount, o.maturity_amount) as maturity_amount -- 到期结算金额
    ,nvl(n.fee, o.fee) as fee -- 首期费用
    ,nvl(n.tax_amt, o.tax_amt) as tax_amt -- 首期税金
    ,nvl(n.broker_amt, o.broker_amt) as broker_amt -- 首期佣金
    ,nvl(n.interest, o.interest) as interest -- 应计利息
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 交易组别
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 交易组别名称
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户id
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 账户名称
    ,nvl(n.cptys_short_name, o.cptys_short_name) as cptys_short_name -- 交易对手名
    ,nvl(n.cptys_id, o.cptys_id) as cptys_id -- 交易对手id
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员id
    ,nvl(n.dealer_name, o.dealer_name) as dealer_name -- 交易员姓名
    ,nvl(n.ref_number, o.ref_number) as ref_number -- 成交编号
    ,nvl(n.cfets_from, o.cfets_from) as cfets_from -- 是否是cfets交易
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.datasymbol_id, o.datasymbol_id) as datasymbol_id -- 数据源id
    ,nvl(n.repo_days, o.repo_days) as repo_days -- 拆借天数
    ,nvl(n.iamdeals_id_grand, o.iamdeals_id_grand) as iamdeals_id_grand -- 原始交易id
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.counterparty_type, o.counterparty_type) as counterparty_type -- 交易类别
    ,nvl(n.repo_id, o.repo_id) as repo_id -- 交易品种
    ,nvl(n.dn_dealer, o.dn_dealer) as dn_dealer -- 本币交易员
    ,nvl(n.trade_time, o.trade_time) as trade_time -- 交易时间
    ,case when
            n.deal_id is null
            and n.deal_tablename is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.deal_id is null
            and n.deal_tablename is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.deal_id is null
            and n.deal_tablename is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_iamdeals_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_iamdeals where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.deal_id = n.deal_id
            and o.deal_tablename = n.deal_tablename
where (
        o.deal_id is null
        and o.deal_tablename is null
    )
    or (
        n.deal_id is null
        and n.deal_tablename is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.serial_number <> n.serial_number
        or o.trade_date <> n.trade_date
        or o.value_date <> n.value_date
        or o.maturity_date <> n.maturity_date
        or o.buyorsell <> n.buyorsell
        or o.repo_rate <> n.repo_rate
        or o.amount <> n.amount
        or o.maturity_amount <> n.maturity_amount
        or o.fee <> n.fee
        or o.tax_amt <> n.tax_amt
        or o.broker_amt <> n.broker_amt
        or o.interest <> n.interest
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.keepfolder_id <> n.keepfolder_id
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.cptys_short_name <> n.cptys_short_name
        or o.cptys_id <> n.cptys_id
        or o.dealer_id <> n.dealer_id
        or o.dealer_name <> n.dealer_name
        or o.ref_number <> n.ref_number
        or o.cfets_from <> n.cfets_from
        or o.lastmodified <> n.lastmodified
        or o.datasymbol_id <> n.datasymbol_id
        or o.repo_days <> n.repo_days
        or o.iamdeals_id_grand <> n.iamdeals_id_grand
        or o.note <> n.note
        or o.counterparty_type <> n.counterparty_type
        or o.repo_id <> n.repo_id
        or o.dn_dealer <> n.dn_dealer
        or o.trade_time <> n.trade_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_iamdeals_cl(
            deal_id -- 引用表id
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,serial_number -- 交易号(标识数据表中记录的唯一组合)
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,repo_rate -- 拆借利率
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户id
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手id
            ,dealer_id -- 交易员id
            ,dealer_name -- 交易员姓名
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是cfets交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源id
            ,repo_days -- 拆借天数
            ,iamdeals_id_grand -- 原始交易id
            ,note -- 备注
            ,counterparty_type -- 交易类别
            ,repo_id -- 交易品种
            ,dn_dealer -- 本币交易员
            ,trade_time -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_iamdeals_op(
            deal_id -- 引用表id
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,serial_number -- 交易号(标识数据表中记录的唯一组合)
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,repo_rate -- 拆借利率
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户id
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手id
            ,dealer_id -- 交易员id
            ,dealer_name -- 交易员姓名
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是cfets交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源id
            ,repo_days -- 拆借天数
            ,iamdeals_id_grand -- 原始交易id
            ,note -- 备注
            ,counterparty_type -- 交易类别
            ,repo_id -- 交易品种
            ,dn_dealer -- 本币交易员
            ,trade_time -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deal_id -- 引用表id
    ,o.deal_tablename -- 引用表名
    ,o.aspclient_id -- 部门编号
    ,o.serial_number -- 交易号(标识数据表中记录的唯一组合)
    ,o.trade_date -- 首期交易日
    ,o.value_date -- 首期交割日
    ,o.maturity_date -- 到期交割日
    ,o.buyorsell -- 交易方向
    ,o.repo_rate -- 拆借利率
    ,o.amount -- 首期结算金额
    ,o.maturity_amount -- 到期结算金额
    ,o.fee -- 首期费用
    ,o.tax_amt -- 首期税金
    ,o.broker_amt -- 首期佣金
    ,o.interest -- 应计利息
    ,o.portfolio_id -- 交易组别
    ,o.portfolio_name -- 交易组别名称
    ,o.keepfolder_id -- 账户id
    ,o.keepfolder_shortname -- 账户名称
    ,o.cptys_short_name -- 交易对手名
    ,o.cptys_id -- 交易对手id
    ,o.dealer_id -- 交易员id
    ,o.dealer_name -- 交易员姓名
    ,o.ref_number -- 成交编号
    ,o.cfets_from -- 是否是cfets交易
    ,o.lastmodified -- 最后修改时间
    ,o.datasymbol_id -- 数据源id
    ,o.repo_days -- 拆借天数
    ,o.iamdeals_id_grand -- 原始交易id
    ,o.note -- 备注
    ,o.counterparty_type -- 交易类别
    ,o.repo_id -- 交易品种
    ,o.dn_dealer -- 本币交易员
    ,o.trade_time -- 交易时间
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
from ${iol_schema}.ctms_tbs_v_iamdeals_bk o
    left join ${iol_schema}.ctms_tbs_v_iamdeals_op n
        on
            o.deal_id = n.deal_id
            and o.deal_tablename = n.deal_tablename
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_iamdeals_cl d
        on
            o.deal_id = d.deal_id
            and o.deal_tablename = d.deal_tablename
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_tbs_v_iamdeals;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_tbs_v_iamdeals') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_tbs_v_iamdeals drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_tbs_v_iamdeals add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_tbs_v_iamdeals exchange partition p_${batch_date} with table ${iol_schema}.ctms_tbs_v_iamdeals_cl;
alter table ${iol_schema}.ctms_tbs_v_iamdeals exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_iamdeals_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_iamdeals to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_iamdeals_op purge;
drop table ${iol_schema}.ctms_tbs_v_iamdeals_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_iamdeals_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_iamdeals',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
