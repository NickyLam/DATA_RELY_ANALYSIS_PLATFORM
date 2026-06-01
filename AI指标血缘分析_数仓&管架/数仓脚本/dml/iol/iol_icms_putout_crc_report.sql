/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_putout_crc_report
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
create table ${iol_schema}.icms_putout_crc_report_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_putout_crc_report
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_putout_crc_report_op purge;
drop table ${iol_schema}.icms_putout_crc_report_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_putout_crc_report_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_putout_crc_report where 0=1;

create table ${iol_schema}.icms_putout_crc_report_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_putout_crc_report where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_putout_crc_report_cl(
            customerid -- 客户编号
            ,fcscgydbtcrtxnbal -- 借贷交易-关注类余额
            ,fcscgywrnttxnbal -- 担保交易-其中：关注类余额
            ,owtaxrcrdnum -- 欠税记录条数
            ,rctlyocdispldt -- 由资产管理公司处置的债务-最近一次处置日期
            ,adcshbsnacc -- 垫款-账户数
            ,astdspbsnbal -- 由资产管理公司处置的债务-余额
            ,inputdate -- 查询日期
            ,cvljdgmtrcrdnum -- 民事判决记录条数
            ,adcshrctlyocrepydyprd -- 垫款-最近一次还款日期
            ,entnm -- 客户名称
            ,wrnttxnbalbal -- 担保交易-余额
            ,odinadoth -- 逾期-利息及其他
            ,curoduepnp -- 逾期-本金
            ,berecsdbtcrtxnbal -- 借贷交易-其中：被追偿余额
            ,admnpnshrcrdnum -- 行政处罚记录条数
            ,badcgywrnttxnbal -- 担保交易-不良类余额
            ,astdspbsnacc -- 由资产管理公司处置的债务-账户数
            ,adcshbsnbal -- 垫款-余额
            ,pbccrexstnst -- 存续状态,1正常2注销9其他X未知
            ,efrcexercrdnum -- 强制执行记录条数
            ,migtflag -- 
            ,dbtcrtxnbal -- 借贷交易-余额
            ,badcgydbtcrtxnbal -- 借贷交易-不良类余额
            ,curoduetamt -- 逾期-总额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_putout_crc_report_op(
            customerid -- 客户编号
            ,fcscgydbtcrtxnbal -- 借贷交易-关注类余额
            ,fcscgywrnttxnbal -- 担保交易-其中：关注类余额
            ,owtaxrcrdnum -- 欠税记录条数
            ,rctlyocdispldt -- 由资产管理公司处置的债务-最近一次处置日期
            ,adcshbsnacc -- 垫款-账户数
            ,astdspbsnbal -- 由资产管理公司处置的债务-余额
            ,inputdate -- 查询日期
            ,cvljdgmtrcrdnum -- 民事判决记录条数
            ,adcshrctlyocrepydyprd -- 垫款-最近一次还款日期
            ,entnm -- 客户名称
            ,wrnttxnbalbal -- 担保交易-余额
            ,odinadoth -- 逾期-利息及其他
            ,curoduepnp -- 逾期-本金
            ,berecsdbtcrtxnbal -- 借贷交易-其中：被追偿余额
            ,admnpnshrcrdnum -- 行政处罚记录条数
            ,badcgywrnttxnbal -- 担保交易-不良类余额
            ,astdspbsnacc -- 由资产管理公司处置的债务-账户数
            ,adcshbsnbal -- 垫款-余额
            ,pbccrexstnst -- 存续状态,1正常2注销9其他X未知
            ,efrcexercrdnum -- 强制执行记录条数
            ,migtflag -- 
            ,dbtcrtxnbal -- 借贷交易-余额
            ,badcgydbtcrtxnbal -- 借贷交易-不良类余额
            ,curoduetamt -- 逾期-总额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.fcscgydbtcrtxnbal, o.fcscgydbtcrtxnbal) as fcscgydbtcrtxnbal -- 借贷交易-关注类余额
    ,nvl(n.fcscgywrnttxnbal, o.fcscgywrnttxnbal) as fcscgywrnttxnbal -- 担保交易-其中：关注类余额
    ,nvl(n.owtaxrcrdnum, o.owtaxrcrdnum) as owtaxrcrdnum -- 欠税记录条数
    ,nvl(n.rctlyocdispldt, o.rctlyocdispldt) as rctlyocdispldt -- 由资产管理公司处置的债务-最近一次处置日期
    ,nvl(n.adcshbsnacc, o.adcshbsnacc) as adcshbsnacc -- 垫款-账户数
    ,nvl(n.astdspbsnbal, o.astdspbsnbal) as astdspbsnbal -- 由资产管理公司处置的债务-余额
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 查询日期
    ,nvl(n.cvljdgmtrcrdnum, o.cvljdgmtrcrdnum) as cvljdgmtrcrdnum -- 民事判决记录条数
    ,nvl(n.adcshrctlyocrepydyprd, o.adcshrctlyocrepydyprd) as adcshrctlyocrepydyprd -- 垫款-最近一次还款日期
    ,nvl(n.entnm, o.entnm) as entnm -- 客户名称
    ,nvl(n.wrnttxnbalbal, o.wrnttxnbalbal) as wrnttxnbalbal -- 担保交易-余额
    ,nvl(n.odinadoth, o.odinadoth) as odinadoth -- 逾期-利息及其他
    ,nvl(n.curoduepnp, o.curoduepnp) as curoduepnp -- 逾期-本金
    ,nvl(n.berecsdbtcrtxnbal, o.berecsdbtcrtxnbal) as berecsdbtcrtxnbal -- 借贷交易-其中：被追偿余额
    ,nvl(n.admnpnshrcrdnum, o.admnpnshrcrdnum) as admnpnshrcrdnum -- 行政处罚记录条数
    ,nvl(n.badcgywrnttxnbal, o.badcgywrnttxnbal) as badcgywrnttxnbal -- 担保交易-不良类余额
    ,nvl(n.astdspbsnacc, o.astdspbsnacc) as astdspbsnacc -- 由资产管理公司处置的债务-账户数
    ,nvl(n.adcshbsnbal, o.adcshbsnbal) as adcshbsnbal -- 垫款-余额
    ,nvl(n.pbccrexstnst, o.pbccrexstnst) as pbccrexstnst -- 存续状态,1正常2注销9其他X未知
    ,nvl(n.efrcexercrdnum, o.efrcexercrdnum) as efrcexercrdnum -- 强制执行记录条数
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.dbtcrtxnbal, o.dbtcrtxnbal) as dbtcrtxnbal -- 借贷交易-余额
    ,nvl(n.badcgydbtcrtxnbal, o.badcgydbtcrtxnbal) as badcgydbtcrtxnbal -- 借贷交易-不良类余额
    ,nvl(n.curoduetamt, o.curoduetamt) as curoduetamt -- 逾期-总额
    ,case when
            n.customerid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_putout_crc_report_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_putout_crc_report where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
where (
        o.customerid is null
    )
    or (
        n.customerid is null
    )
    or (
        o.fcscgydbtcrtxnbal <> n.fcscgydbtcrtxnbal
        or o.fcscgywrnttxnbal <> n.fcscgywrnttxnbal
        or o.owtaxrcrdnum <> n.owtaxrcrdnum
        or o.rctlyocdispldt <> n.rctlyocdispldt
        or o.adcshbsnacc <> n.adcshbsnacc
        or o.astdspbsnbal <> n.astdspbsnbal
        or o.inputdate <> n.inputdate
        or o.cvljdgmtrcrdnum <> n.cvljdgmtrcrdnum
        or o.adcshrctlyocrepydyprd <> n.adcshrctlyocrepydyprd
        or o.entnm <> n.entnm
        or o.wrnttxnbalbal <> n.wrnttxnbalbal
        or o.odinadoth <> n.odinadoth
        or o.curoduepnp <> n.curoduepnp
        or o.berecsdbtcrtxnbal <> n.berecsdbtcrtxnbal
        or o.admnpnshrcrdnum <> n.admnpnshrcrdnum
        or o.badcgywrnttxnbal <> n.badcgywrnttxnbal
        or o.astdspbsnacc <> n.astdspbsnacc
        or o.adcshbsnbal <> n.adcshbsnbal
        or o.pbccrexstnst <> n.pbccrexstnst
        or o.efrcexercrdnum <> n.efrcexercrdnum
        or o.migtflag <> n.migtflag
        or o.dbtcrtxnbal <> n.dbtcrtxnbal
        or o.badcgydbtcrtxnbal <> n.badcgydbtcrtxnbal
        or o.curoduetamt <> n.curoduetamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_putout_crc_report_cl(
            customerid -- 客户编号
            ,fcscgydbtcrtxnbal -- 借贷交易-关注类余额
            ,fcscgywrnttxnbal -- 担保交易-其中：关注类余额
            ,owtaxrcrdnum -- 欠税记录条数
            ,rctlyocdispldt -- 由资产管理公司处置的债务-最近一次处置日期
            ,adcshbsnacc -- 垫款-账户数
            ,astdspbsnbal -- 由资产管理公司处置的债务-余额
            ,inputdate -- 查询日期
            ,cvljdgmtrcrdnum -- 民事判决记录条数
            ,adcshrctlyocrepydyprd -- 垫款-最近一次还款日期
            ,entnm -- 客户名称
            ,wrnttxnbalbal -- 担保交易-余额
            ,odinadoth -- 逾期-利息及其他
            ,curoduepnp -- 逾期-本金
            ,berecsdbtcrtxnbal -- 借贷交易-其中：被追偿余额
            ,admnpnshrcrdnum -- 行政处罚记录条数
            ,badcgywrnttxnbal -- 担保交易-不良类余额
            ,astdspbsnacc -- 由资产管理公司处置的债务-账户数
            ,adcshbsnbal -- 垫款-余额
            ,pbccrexstnst -- 存续状态,1正常2注销9其他X未知
            ,efrcexercrdnum -- 强制执行记录条数
            ,migtflag -- 
            ,dbtcrtxnbal -- 借贷交易-余额
            ,badcgydbtcrtxnbal -- 借贷交易-不良类余额
            ,curoduetamt -- 逾期-总额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_putout_crc_report_op(
            customerid -- 客户编号
            ,fcscgydbtcrtxnbal -- 借贷交易-关注类余额
            ,fcscgywrnttxnbal -- 担保交易-其中：关注类余额
            ,owtaxrcrdnum -- 欠税记录条数
            ,rctlyocdispldt -- 由资产管理公司处置的债务-最近一次处置日期
            ,adcshbsnacc -- 垫款-账户数
            ,astdspbsnbal -- 由资产管理公司处置的债务-余额
            ,inputdate -- 查询日期
            ,cvljdgmtrcrdnum -- 民事判决记录条数
            ,adcshrctlyocrepydyprd -- 垫款-最近一次还款日期
            ,entnm -- 客户名称
            ,wrnttxnbalbal -- 担保交易-余额
            ,odinadoth -- 逾期-利息及其他
            ,curoduepnp -- 逾期-本金
            ,berecsdbtcrtxnbal -- 借贷交易-其中：被追偿余额
            ,admnpnshrcrdnum -- 行政处罚记录条数
            ,badcgywrnttxnbal -- 担保交易-不良类余额
            ,astdspbsnacc -- 由资产管理公司处置的债务-账户数
            ,adcshbsnbal -- 垫款-余额
            ,pbccrexstnst -- 存续状态,1正常2注销9其他X未知
            ,efrcexercrdnum -- 强制执行记录条数
            ,migtflag -- 
            ,dbtcrtxnbal -- 借贷交易-余额
            ,badcgydbtcrtxnbal -- 借贷交易-不良类余额
            ,curoduetamt -- 逾期-总额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customerid -- 客户编号
    ,o.fcscgydbtcrtxnbal -- 借贷交易-关注类余额
    ,o.fcscgywrnttxnbal -- 担保交易-其中：关注类余额
    ,o.owtaxrcrdnum -- 欠税记录条数
    ,o.rctlyocdispldt -- 由资产管理公司处置的债务-最近一次处置日期
    ,o.adcshbsnacc -- 垫款-账户数
    ,o.astdspbsnbal -- 由资产管理公司处置的债务-余额
    ,o.inputdate -- 查询日期
    ,o.cvljdgmtrcrdnum -- 民事判决记录条数
    ,o.adcshrctlyocrepydyprd -- 垫款-最近一次还款日期
    ,o.entnm -- 客户名称
    ,o.wrnttxnbalbal -- 担保交易-余额
    ,o.odinadoth -- 逾期-利息及其他
    ,o.curoduepnp -- 逾期-本金
    ,o.berecsdbtcrtxnbal -- 借贷交易-其中：被追偿余额
    ,o.admnpnshrcrdnum -- 行政处罚记录条数
    ,o.badcgywrnttxnbal -- 担保交易-不良类余额
    ,o.astdspbsnacc -- 由资产管理公司处置的债务-账户数
    ,o.adcshbsnbal -- 垫款-余额
    ,o.pbccrexstnst -- 存续状态,1正常2注销9其他X未知
    ,o.efrcexercrdnum -- 强制执行记录条数
    ,o.migtflag -- 
    ,o.dbtcrtxnbal -- 借贷交易-余额
    ,o.badcgydbtcrtxnbal -- 借贷交易-不良类余额
    ,o.curoduetamt -- 逾期-总额
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
from ${iol_schema}.icms_putout_crc_report_bk o
    left join ${iol_schema}.icms_putout_crc_report_op n
        on
            o.customerid = n.customerid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_putout_crc_report_cl d
        on
            o.customerid = d.customerid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_putout_crc_report;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_putout_crc_report') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_putout_crc_report drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_putout_crc_report add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_putout_crc_report exchange partition p_${batch_date} with table ${iol_schema}.icms_putout_crc_report_cl;
alter table ${iol_schema}.icms_putout_crc_report exchange partition p_20991231 with table ${iol_schema}.icms_putout_crc_report_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_putout_crc_report to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_putout_crc_report_op purge;
drop table ${iol_schema}.icms_putout_crc_report_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_putout_crc_report_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_putout_crc_report',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
