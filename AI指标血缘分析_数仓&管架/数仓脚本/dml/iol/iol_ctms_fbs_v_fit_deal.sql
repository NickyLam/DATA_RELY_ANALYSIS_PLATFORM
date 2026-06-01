/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_v_fit_deal
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
create table ${iol_schema}.ctms_fbs_v_fit_deal_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_fbs_v_fit_deal
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_fit_deal_op purge;
drop table ${iol_schema}.ctms_fbs_v_fit_deal_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_fit_deal_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_fit_deal where 0=1;

create table ${iol_schema}.ctms_fbs_v_fit_deal_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_fit_deal where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_fit_deal_cl(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 成交流水号
            ,deal_date -- 交易日期和时间
            ,trnsfr_date -- 头寸调拨日
            ,trnsfr_type -- 调拨类型
            ,crncy_code -- 货币的SRNO
            ,first_amnt -- 交易金额
            ,trade_purpose -- 交易目的
            ,business_date -- 系统交易日
            ,counter_party_id -- 交易对手编码
            ,counter_party_scname -- 交易对手中文简称
            ,update_time -- 记录修改日期
            ,pdd_deal_sqno -- 成交流水号
            ,deal_status -- 成交单状态
            ,deal_dir -- 交易方向
            ,client_deal_sqno -- 业务成交编号，
            ,trade_type -- 交易模式
            ,deal_source -- 交易来源
            ,deal_market -- 交易场所
            ,settle_type -- 清算方式
            ,deal_link_sqno -- 交易修改删除的序列关系。
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合ID
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型
            ,portfolio_status -- 投资组合状态
            ,portfolio_link_sqno -- 投组交易链接编号
            ,amnt_type -- 金额类型
            ,stlmnt_stts -- INDC结算状态
            ,from_account_infr_srno -- 划出行账户编号
            ,to_account_infr_srno -- 划入行账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_fit_deal_op(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 成交流水号
            ,deal_date -- 交易日期和时间
            ,trnsfr_date -- 头寸调拨日
            ,trnsfr_type -- 调拨类型
            ,crncy_code -- 货币的SRNO
            ,first_amnt -- 交易金额
            ,trade_purpose -- 交易目的
            ,business_date -- 系统交易日
            ,counter_party_id -- 交易对手编码
            ,counter_party_scname -- 交易对手中文简称
            ,update_time -- 记录修改日期
            ,pdd_deal_sqno -- 成交流水号
            ,deal_status -- 成交单状态
            ,deal_dir -- 交易方向
            ,client_deal_sqno -- 业务成交编号，
            ,trade_type -- 交易模式
            ,deal_source -- 交易来源
            ,deal_market -- 交易场所
            ,settle_type -- 清算方式
            ,deal_link_sqno -- 交易修改删除的序列关系。
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合ID
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型
            ,portfolio_status -- 投资组合状态
            ,portfolio_link_sqno -- 投组交易链接编号
            ,amnt_type -- 金额类型
            ,stlmnt_stts -- INDC结算状态
            ,from_account_infr_srno -- 划出行账户编号
            ,to_account_infr_srno -- 划入行账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cus_number, o.cus_number) as cus_number -- 机构的唯一标识号
    ,nvl(n.branch_number, o.branch_number) as branch_number -- 分支机构的唯一标识号
    ,nvl(n.deal_sqno, o.deal_sqno) as deal_sqno -- 成交流水号
    ,nvl(n.deal_date, o.deal_date) as deal_date -- 交易日期和时间
    ,nvl(n.trnsfr_date, o.trnsfr_date) as trnsfr_date -- 头寸调拨日
    ,nvl(n.trnsfr_type, o.trnsfr_type) as trnsfr_type -- 调拨类型
    ,nvl(n.crncy_code, o.crncy_code) as crncy_code -- 货币的SRNO
    ,nvl(n.first_amnt, o.first_amnt) as first_amnt -- 交易金额
    ,nvl(n.trade_purpose, o.trade_purpose) as trade_purpose -- 交易目的
    ,nvl(n.business_date, o.business_date) as business_date -- 系统交易日
    ,nvl(n.counter_party_id, o.counter_party_id) as counter_party_id -- 交易对手编码
    ,nvl(n.counter_party_scname, o.counter_party_scname) as counter_party_scname -- 交易对手中文简称
    ,nvl(n.update_time, o.update_time) as update_time -- 记录修改日期
    ,nvl(n.pdd_deal_sqno, o.pdd_deal_sqno) as pdd_deal_sqno -- 成交流水号
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 成交单状态
    ,nvl(n.deal_dir, o.deal_dir) as deal_dir -- 交易方向
    ,nvl(n.client_deal_sqno, o.client_deal_sqno) as client_deal_sqno -- 业务成交编号，
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 交易模式
    ,nvl(n.deal_source, o.deal_source) as deal_source -- 交易来源
    ,nvl(n.deal_market, o.deal_market) as deal_market -- 交易场所
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 清算方式
    ,nvl(n.deal_link_sqno, o.deal_link_sqno) as deal_link_sqno -- 交易修改删除的序列关系。
    ,nvl(n.modify_date, o.modify_date) as modify_date -- 更新日期
    ,nvl(n.portfolio_sqno, o.portfolio_sqno) as portfolio_sqno -- 投组交易编号
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 投资组合ID
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 投资组合名称
    ,nvl(n.portfolio_type, o.portfolio_type) as portfolio_type -- 投组类型
    ,nvl(n.portfolio_status, o.portfolio_status) as portfolio_status -- 投资组合状态
    ,nvl(n.portfolio_link_sqno, o.portfolio_link_sqno) as portfolio_link_sqno -- 投组交易链接编号
    ,nvl(n.amnt_type, o.amnt_type) as amnt_type -- 金额类型
    ,nvl(n.stlmnt_stts, o.stlmnt_stts) as stlmnt_stts -- INDC结算状态
    ,nvl(n.from_account_infr_srno, o.from_account_infr_srno) as from_account_infr_srno -- 划出行账户编号
    ,nvl(n.to_account_infr_srno, o.to_account_infr_srno) as to_account_infr_srno -- 划入行账户编号
    ,case when
            n.cus_number is null
            and n.branch_number is null
            and n.deal_sqno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cus_number is null
            and n.branch_number is null
            and n.deal_sqno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cus_number is null
            and n.branch_number is null
            and n.deal_sqno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_fbs_v_fit_deal_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_fbs_v_fit_deal where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cus_number = n.cus_number
            and o.branch_number = n.branch_number
            and o.deal_sqno = n.deal_sqno
where (
        o.cus_number is null
        and o.branch_number is null
        and o.deal_sqno is null
    )
    or (
        n.cus_number is null
        and n.branch_number is null
        and n.deal_sqno is null
    )
    or (
        o.deal_date <> n.deal_date
        or o.trnsfr_date <> n.trnsfr_date
        or o.trnsfr_type <> n.trnsfr_type
        or o.crncy_code <> n.crncy_code
        or o.first_amnt <> n.first_amnt
        or o.trade_purpose <> n.trade_purpose
        or o.business_date <> n.business_date
        or o.counter_party_id <> n.counter_party_id
        or o.counter_party_scname <> n.counter_party_scname
        or o.update_time <> n.update_time
        or o.pdd_deal_sqno <> n.pdd_deal_sqno
        or o.deal_status <> n.deal_status
        or o.deal_dir <> n.deal_dir
        or o.client_deal_sqno <> n.client_deal_sqno
        or o.trade_type <> n.trade_type
        or o.deal_source <> n.deal_source
        or o.deal_market <> n.deal_market
        or o.settle_type <> n.settle_type
        or o.deal_link_sqno <> n.deal_link_sqno
        or o.modify_date <> n.modify_date
        or o.portfolio_sqno <> n.portfolio_sqno
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.portfolio_type <> n.portfolio_type
        or o.portfolio_status <> n.portfolio_status
        or o.portfolio_link_sqno <> n.portfolio_link_sqno
        or o.amnt_type <> n.amnt_type
        or o.stlmnt_stts <> n.stlmnt_stts
        or o.from_account_infr_srno <> n.from_account_infr_srno
        or o.to_account_infr_srno <> n.to_account_infr_srno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_fit_deal_cl(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 成交流水号
            ,deal_date -- 交易日期和时间
            ,trnsfr_date -- 头寸调拨日
            ,trnsfr_type -- 调拨类型
            ,crncy_code -- 货币的SRNO
            ,first_amnt -- 交易金额
            ,trade_purpose -- 交易目的
            ,business_date -- 系统交易日
            ,counter_party_id -- 交易对手编码
            ,counter_party_scname -- 交易对手中文简称
            ,update_time -- 记录修改日期
            ,pdd_deal_sqno -- 成交流水号
            ,deal_status -- 成交单状态
            ,deal_dir -- 交易方向
            ,client_deal_sqno -- 业务成交编号，
            ,trade_type -- 交易模式
            ,deal_source -- 交易来源
            ,deal_market -- 交易场所
            ,settle_type -- 清算方式
            ,deal_link_sqno -- 交易修改删除的序列关系。
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合ID
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型
            ,portfolio_status -- 投资组合状态
            ,portfolio_link_sqno -- 投组交易链接编号
            ,amnt_type -- 金额类型
            ,stlmnt_stts -- INDC结算状态
            ,from_account_infr_srno -- 划出行账户编号
            ,to_account_infr_srno -- 划入行账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_fit_deal_op(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 成交流水号
            ,deal_date -- 交易日期和时间
            ,trnsfr_date -- 头寸调拨日
            ,trnsfr_type -- 调拨类型
            ,crncy_code -- 货币的SRNO
            ,first_amnt -- 交易金额
            ,trade_purpose -- 交易目的
            ,business_date -- 系统交易日
            ,counter_party_id -- 交易对手编码
            ,counter_party_scname -- 交易对手中文简称
            ,update_time -- 记录修改日期
            ,pdd_deal_sqno -- 成交流水号
            ,deal_status -- 成交单状态
            ,deal_dir -- 交易方向
            ,client_deal_sqno -- 业务成交编号，
            ,trade_type -- 交易模式
            ,deal_source -- 交易来源
            ,deal_market -- 交易场所
            ,settle_type -- 清算方式
            ,deal_link_sqno -- 交易修改删除的序列关系。
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合ID
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型
            ,portfolio_status -- 投资组合状态
            ,portfolio_link_sqno -- 投组交易链接编号
            ,amnt_type -- 金额类型
            ,stlmnt_stts -- INDC结算状态
            ,from_account_infr_srno -- 划出行账户编号
            ,to_account_infr_srno -- 划入行账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cus_number -- 机构的唯一标识号
    ,o.branch_number -- 分支机构的唯一标识号
    ,o.deal_sqno -- 成交流水号
    ,o.deal_date -- 交易日期和时间
    ,o.trnsfr_date -- 头寸调拨日
    ,o.trnsfr_type -- 调拨类型
    ,o.crncy_code -- 货币的SRNO
    ,o.first_amnt -- 交易金额
    ,o.trade_purpose -- 交易目的
    ,o.business_date -- 系统交易日
    ,o.counter_party_id -- 交易对手编码
    ,o.counter_party_scname -- 交易对手中文简称
    ,o.update_time -- 记录修改日期
    ,o.pdd_deal_sqno -- 成交流水号
    ,o.deal_status -- 成交单状态
    ,o.deal_dir -- 交易方向
    ,o.client_deal_sqno -- 业务成交编号，
    ,o.trade_type -- 交易模式
    ,o.deal_source -- 交易来源
    ,o.deal_market -- 交易场所
    ,o.settle_type -- 清算方式
    ,o.deal_link_sqno -- 交易修改删除的序列关系。
    ,o.modify_date -- 更新日期
    ,o.portfolio_sqno -- 投组交易编号
    ,o.portfolio_id -- 投资组合ID
    ,o.portfolio_name -- 投资组合名称
    ,o.portfolio_type -- 投组类型
    ,o.portfolio_status -- 投资组合状态
    ,o.portfolio_link_sqno -- 投组交易链接编号
    ,o.amnt_type -- 金额类型
    ,o.stlmnt_stts -- INDC结算状态
    ,o.from_account_infr_srno -- 划出行账户编号
    ,o.to_account_infr_srno -- 划入行账户编号
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
from ${iol_schema}.ctms_fbs_v_fit_deal_bk o
    left join ${iol_schema}.ctms_fbs_v_fit_deal_op n
        on
            o.cus_number = n.cus_number
            and o.branch_number = n.branch_number
            and o.deal_sqno = n.deal_sqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_fbs_v_fit_deal_cl d
        on
            o.cus_number = d.cus_number
            and o.branch_number = d.branch_number
            and o.deal_sqno = d.deal_sqno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_fbs_v_fit_deal;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_fbs_v_fit_deal') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_fbs_v_fit_deal drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_fbs_v_fit_deal add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_fbs_v_fit_deal exchange partition p_${batch_date} with table ${iol_schema}.ctms_fbs_v_fit_deal_cl;
alter table ${iol_schema}.ctms_fbs_v_fit_deal exchange partition p_20991231 with table ${iol_schema}.ctms_fbs_v_fit_deal_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_fbs_v_fit_deal to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_fit_deal_op purge;
drop table ${iol_schema}.ctms_fbs_v_fit_deal_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_fbs_v_fit_deal_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_fbs_v_fit_deal',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
