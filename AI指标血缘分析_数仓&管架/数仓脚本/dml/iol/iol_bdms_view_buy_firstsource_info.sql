/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_view_buy_firstsource_info
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
create table ${iol_schema}.bdms_view_buy_firstsource_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_view_buy_firstsource_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_view_buy_firstsource_info_op purge;
drop table ${iol_schema}.bdms_view_buy_firstsource_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_view_buy_firstsource_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_view_buy_firstsource_info where 0=1;

create table ${iol_schema}.bdms_view_buy_firstsource_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_view_buy_firstsource_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_view_buy_firstsource_info_cl(
            draftid -- 票据编号
            ,draftnumber -- 票据号码
            ,cdrange -- 子票区间
            ,contractid -- 买入协议编号
            ,productno -- 产品号
            ,firstsource -- 首笔买入来源： 1-贴现，2-系统内转贴现,3-系统外转贴现
            ,firstsourcecustno -- 交易对手客户号,我行记录在库对公客户为客户编号，同业客户客户号为票交所机构号
            ,firstcustname -- 交易对手名称
            ,fristbankno -- 交易对手开户行联行号或交易对手联行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_view_buy_firstsource_info_op(
            draftid -- 票据编号
            ,draftnumber -- 票据号码
            ,cdrange -- 子票区间
            ,contractid -- 买入协议编号
            ,productno -- 产品号
            ,firstsource -- 首笔买入来源： 1-贴现，2-系统内转贴现,3-系统外转贴现
            ,firstsourcecustno -- 交易对手客户号,我行记录在库对公客户为客户编号，同业客户客户号为票交所机构号
            ,firstcustname -- 交易对手名称
            ,fristbankno -- 交易对手开户行联行号或交易对手联行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.draftid, o.draftid) as draftid -- 票据编号
    ,nvl(n.draftnumber, o.draftnumber) as draftnumber -- 票据号码
    ,nvl(n.cdrange, o.cdrange) as cdrange -- 子票区间
    ,nvl(n.contractid, o.contractid) as contractid -- 买入协议编号
    ,nvl(n.productno, o.productno) as productno -- 产品号
    ,nvl(n.firstsource, o.firstsource) as firstsource -- 首笔买入来源： 1-贴现，2-系统内转贴现,3-系统外转贴现
    ,nvl(n.firstsourcecustno, o.firstsourcecustno) as firstsourcecustno -- 交易对手客户号,我行记录在库对公客户为客户编号，同业客户客户号为票交所机构号
    ,nvl(n.firstcustname, o.firstcustname) as firstcustname -- 交易对手名称
    ,nvl(n.fristbankno, o.fristbankno) as fristbankno -- 交易对手开户行联行号或交易对手联行号
    ,case when
            n.draftid is null
            and n.draftnumber is null
            and n.cdrange is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.draftid is null
            and n.draftnumber is null
            and n.cdrange is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.draftid is null
            and n.draftnumber is null
            and n.cdrange is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_view_buy_firstsource_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_view_buy_firstsource_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.draftid = n.draftid
            and o.draftnumber = n.draftnumber
            and o.cdrange = n.cdrange
where (
        o.draftid is null
        and o.draftnumber is null
        and o.cdrange is null
    )
    or (
        n.draftid is null
        and n.draftnumber is null
        and n.cdrange is null
    )
    or (
        o.contractid <> n.contractid
        or o.productno <> n.productno
        or o.firstsource <> n.firstsource
        or o.firstsourcecustno <> n.firstsourcecustno
        or o.firstcustname <> n.firstcustname
        or o.fristbankno <> n.fristbankno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_view_buy_firstsource_info_cl(
            draftid -- 票据编号
            ,draftnumber -- 票据号码
            ,cdrange -- 子票区间
            ,contractid -- 买入协议编号
            ,productno -- 产品号
            ,firstsource -- 首笔买入来源： 1-贴现，2-系统内转贴现,3-系统外转贴现
            ,firstsourcecustno -- 交易对手客户号,我行记录在库对公客户为客户编号，同业客户客户号为票交所机构号
            ,firstcustname -- 交易对手名称
            ,fristbankno -- 交易对手开户行联行号或交易对手联行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_view_buy_firstsource_info_op(
            draftid -- 票据编号
            ,draftnumber -- 票据号码
            ,cdrange -- 子票区间
            ,contractid -- 买入协议编号
            ,productno -- 产品号
            ,firstsource -- 首笔买入来源： 1-贴现，2-系统内转贴现,3-系统外转贴现
            ,firstsourcecustno -- 交易对手客户号,我行记录在库对公客户为客户编号，同业客户客户号为票交所机构号
            ,firstcustname -- 交易对手名称
            ,fristbankno -- 交易对手开户行联行号或交易对手联行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.draftid -- 票据编号
    ,o.draftnumber -- 票据号码
    ,o.cdrange -- 子票区间
    ,o.contractid -- 买入协议编号
    ,o.productno -- 产品号
    ,o.firstsource -- 首笔买入来源： 1-贴现，2-系统内转贴现,3-系统外转贴现
    ,o.firstsourcecustno -- 交易对手客户号,我行记录在库对公客户为客户编号，同业客户客户号为票交所机构号
    ,o.firstcustname -- 交易对手名称
    ,o.fristbankno -- 交易对手开户行联行号或交易对手联行号
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
from ${iol_schema}.bdms_view_buy_firstsource_info_bk o
    left join ${iol_schema}.bdms_view_buy_firstsource_info_op n
        on
            o.draftid = n.draftid
            and o.draftnumber = n.draftnumber
            and o.cdrange = n.cdrange
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_view_buy_firstsource_info_cl d
        on
            o.draftid = d.draftid
            and o.draftnumber = d.draftnumber
            and o.cdrange = d.cdrange
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_view_buy_firstsource_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_view_buy_firstsource_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_view_buy_firstsource_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_view_buy_firstsource_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_view_buy_firstsource_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_view_buy_firstsource_info_cl;
alter table ${iol_schema}.bdms_view_buy_firstsource_info exchange partition p_20991231 with table ${iol_schema}.bdms_view_buy_firstsource_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_view_buy_firstsource_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_view_buy_firstsource_info_op purge;
drop table ${iol_schema}.bdms_view_buy_firstsource_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_view_buy_firstsource_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_view_buy_firstsource_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
