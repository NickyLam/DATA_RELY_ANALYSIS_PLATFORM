/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_other_bwarereceipt
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
create table ${iol_schema}.icms_clr_asset_other_bwarereceipt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_other_bwarereceipt
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_other_bwarereceipt_op purge;
drop table ${iol_schema}.icms_clr_asset_other_bwarereceipt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_bwarereceipt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_other_bwarereceipt where 0=1;

create table ${iol_schema}.icms_clr_asset_other_bwarereceipt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_other_bwarereceipt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_other_bwarereceipt_cl(
            clrid -- 押品编号
            ,warereceiptno -- 仓单编号
            ,startdate -- 仓单起始日期
            ,enddate -- 仓单到期日期
            ,tradename -- 货物名称
            ,issuername -- 发行人名称
            ,issuertype -- 发行人类型
            ,bourse -- 仓单所属交易所
            ,totalprice -- 标准仓单价值
            ,tdcurrency -- 币种
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_other_bwarereceipt_op(
            clrid -- 押品编号
            ,warereceiptno -- 仓单编号
            ,startdate -- 仓单起始日期
            ,enddate -- 仓单到期日期
            ,tradename -- 货物名称
            ,issuername -- 发行人名称
            ,issuertype -- 发行人类型
            ,bourse -- 仓单所属交易所
            ,totalprice -- 标准仓单价值
            ,tdcurrency -- 币种
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.warereceiptno, o.warereceiptno) as warereceiptno -- 仓单编号
    ,nvl(n.startdate, o.startdate) as startdate -- 仓单起始日期
    ,nvl(n.enddate, o.enddate) as enddate -- 仓单到期日期
    ,nvl(n.tradename, o.tradename) as tradename -- 货物名称
    ,nvl(n.issuername, o.issuername) as issuername -- 发行人名称
    ,nvl(n.issuertype, o.issuertype) as issuertype -- 发行人类型
    ,nvl(n.bourse, o.bourse) as bourse -- 仓单所属交易所
    ,nvl(n.totalprice, o.totalprice) as totalprice -- 标准仓单价值
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,case when
            n.clrid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clrid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clrid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_asset_other_bwarereceipt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_other_bwarereceipt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.warereceiptno <> n.warereceiptno
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.tradename <> n.tradename
        or o.issuername <> n.issuername
        or o.issuertype <> n.issuertype
        or o.bourse <> n.bourse
        or o.totalprice <> n.totalprice
        or o.tdcurrency <> n.tdcurrency
        or o.remark <> n.remark
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_other_bwarereceipt_cl(
            clrid -- 押品编号
            ,warereceiptno -- 仓单编号
            ,startdate -- 仓单起始日期
            ,enddate -- 仓单到期日期
            ,tradename -- 货物名称
            ,issuername -- 发行人名称
            ,issuertype -- 发行人类型
            ,bourse -- 仓单所属交易所
            ,totalprice -- 标准仓单价值
            ,tdcurrency -- 币种
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_other_bwarereceipt_op(
            clrid -- 押品编号
            ,warereceiptno -- 仓单编号
            ,startdate -- 仓单起始日期
            ,enddate -- 仓单到期日期
            ,tradename -- 货物名称
            ,issuername -- 发行人名称
            ,issuertype -- 发行人类型
            ,bourse -- 仓单所属交易所
            ,totalprice -- 标准仓单价值
            ,tdcurrency -- 币种
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.warereceiptno -- 仓单编号
    ,o.startdate -- 仓单起始日期
    ,o.enddate -- 仓单到期日期
    ,o.tradename -- 货物名称
    ,o.issuername -- 发行人名称
    ,o.issuertype -- 发行人类型
    ,o.bourse -- 仓单所属交易所
    ,o.totalprice -- 标准仓单价值
    ,o.tdcurrency -- 币种
    ,o.remark -- 其他说明
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
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
from ${iol_schema}.icms_clr_asset_other_bwarereceipt_bk o
    left join ${iol_schema}.icms_clr_asset_other_bwarereceipt_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_other_bwarereceipt_cl d
        on
            o.clrid = d.clrid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_asset_other_bwarereceipt;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_other_bwarereceipt') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_other_bwarereceipt drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_other_bwarereceipt add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_other_bwarereceipt exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_other_bwarereceipt_cl;
alter table ${iol_schema}.icms_clr_asset_other_bwarereceipt exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_other_bwarereceipt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_other_bwarereceipt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_other_bwarereceipt_op purge;
drop table ${iol_schema}.icms_clr_asset_other_bwarereceipt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_other_bwarereceipt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_other_bwarereceipt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
