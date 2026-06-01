/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_other_fwarereceipt
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
create table ${iol_schema}.icms_clr_asset_other_fwarereceipt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_other_fwarereceipt
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_other_fwarereceipt_op purge;
drop table ${iol_schema}.icms_clr_asset_other_fwarereceipt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_fwarereceipt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_other_fwarereceipt where 0=1;

create table ${iol_schema}.icms_clr_asset_other_fwarereceipt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_other_fwarereceipt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_other_fwarereceipt_cl(
            clrid -- 押品编号
            ,billno -- 单据号码
            ,startdate -- 仓单起始日期
            ,enddate -- 仓单到期日期
            ,tradename -- 货物名称
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,unit -- 货物计量单位
            ,otherremark -- 其他计量单位说明
            ,amount -- 货物账面数量
            ,perprice -- 货物账面单价
            ,totalprice -- 非标仓单价值
            ,tdcurrency -- 币种
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_other_fwarereceipt_op(
            clrid -- 押品编号
            ,billno -- 单据号码
            ,startdate -- 仓单起始日期
            ,enddate -- 仓单到期日期
            ,tradename -- 货物名称
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,unit -- 货物计量单位
            ,otherremark -- 其他计量单位说明
            ,amount -- 货物账面数量
            ,perprice -- 货物账面单价
            ,totalprice -- 非标仓单价值
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
    ,nvl(n.billno, o.billno) as billno -- 单据号码
    ,nvl(n.startdate, o.startdate) as startdate -- 仓单起始日期
    ,nvl(n.enddate, o.enddate) as enddate -- 仓单到期日期
    ,nvl(n.tradename, o.tradename) as tradename -- 货物名称
    ,nvl(n.province, o.province) as province -- 所在/注册省份
    ,nvl(n.city, o.city) as city -- 所在/注册市
    ,nvl(n.unit, o.unit) as unit -- 货物计量单位
    ,nvl(n.otherremark, o.otherremark) as otherremark -- 其他计量单位说明
    ,nvl(n.amount, o.amount) as amount -- 货物账面数量
    ,nvl(n.perprice, o.perprice) as perprice -- 货物账面单价
    ,nvl(n.totalprice, o.totalprice) as totalprice -- 非标仓单价值
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
from (select * from ${iol_schema}.icms_clr_asset_other_fwarereceipt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_other_fwarereceipt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.billno <> n.billno
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.tradename <> n.tradename
        or o.province <> n.province
        or o.city <> n.city
        or o.unit <> n.unit
        or o.otherremark <> n.otherremark
        or o.amount <> n.amount
        or o.perprice <> n.perprice
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
        into ${iol_schema}.icms_clr_asset_other_fwarereceipt_cl(
            clrid -- 押品编号
            ,billno -- 单据号码
            ,startdate -- 仓单起始日期
            ,enddate -- 仓单到期日期
            ,tradename -- 货物名称
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,unit -- 货物计量单位
            ,otherremark -- 其他计量单位说明
            ,amount -- 货物账面数量
            ,perprice -- 货物账面单价
            ,totalprice -- 非标仓单价值
            ,tdcurrency -- 币种
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_other_fwarereceipt_op(
            clrid -- 押品编号
            ,billno -- 单据号码
            ,startdate -- 仓单起始日期
            ,enddate -- 仓单到期日期
            ,tradename -- 货物名称
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,unit -- 货物计量单位
            ,otherremark -- 其他计量单位说明
            ,amount -- 货物账面数量
            ,perprice -- 货物账面单价
            ,totalprice -- 非标仓单价值
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
    ,o.billno -- 单据号码
    ,o.startdate -- 仓单起始日期
    ,o.enddate -- 仓单到期日期
    ,o.tradename -- 货物名称
    ,o.province -- 所在/注册省份
    ,o.city -- 所在/注册市
    ,o.unit -- 货物计量单位
    ,o.otherremark -- 其他计量单位说明
    ,o.amount -- 货物账面数量
    ,o.perprice -- 货物账面单价
    ,o.totalprice -- 非标仓单价值
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
from ${iol_schema}.icms_clr_asset_other_fwarereceipt_bk o
    left join ${iol_schema}.icms_clr_asset_other_fwarereceipt_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_other_fwarereceipt_cl d
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
--truncate table ${iol_schema}.icms_clr_asset_other_fwarereceipt;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_other_fwarereceipt') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_other_fwarereceipt drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_other_fwarereceipt add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_other_fwarereceipt exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_other_fwarereceipt_cl;
alter table ${iol_schema}.icms_clr_asset_other_fwarereceipt exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_other_fwarereceipt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_other_fwarereceipt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_other_fwarereceipt_op purge;
drop table ${iol_schema}.icms_clr_asset_other_fwarereceipt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_other_fwarereceipt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_other_fwarereceipt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
