/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_finance_gold
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
create table ${iol_schema}.icms_clr_asset_finance_gold_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_finance_gold
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_finance_gold_op purge;
drop table ${iol_schema}.icms_clr_asset_finance_gold_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_gold_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_finance_gold where 0=1;

create table ${iol_schema}.icms_clr_asset_finance_gold_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_finance_gold where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_finance_gold_cl(
            clrid -- 押品编号
            ,ismaterial -- 是否为实物贵金属
            ,voucherno -- 实物入库凭证号
            ,registno -- 交易所质押登记号
            ,collorg -- 非实物托管单位名称
            ,quality -- 质量
            ,unit -- 质量单位
            ,unitprice -- 贵金属单位价值(元)
            ,currency -- 币种
            ,remark -- 其他说明
            ,goldtype -- 贵金属类别
            ,grade -- 品种/等级
            ,graderemark -- 品种/等级描述
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_finance_gold_op(
            clrid -- 押品编号
            ,ismaterial -- 是否为实物贵金属
            ,voucherno -- 实物入库凭证号
            ,registno -- 交易所质押登记号
            ,collorg -- 非实物托管单位名称
            ,quality -- 质量
            ,unit -- 质量单位
            ,unitprice -- 贵金属单位价值(元)
            ,currency -- 币种
            ,remark -- 其他说明
            ,goldtype -- 贵金属类别
            ,grade -- 品种/等级
            ,graderemark -- 品种/等级描述
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.ismaterial, o.ismaterial) as ismaterial -- 是否为实物贵金属
    ,nvl(n.voucherno, o.voucherno) as voucherno -- 实物入库凭证号
    ,nvl(n.registno, o.registno) as registno -- 交易所质押登记号
    ,nvl(n.collorg, o.collorg) as collorg -- 非实物托管单位名称
    ,nvl(n.quality, o.quality) as quality -- 质量
    ,nvl(n.unit, o.unit) as unit -- 质量单位
    ,nvl(n.unitprice, o.unitprice) as unitprice -- 贵金属单位价值(元)
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.goldtype, o.goldtype) as goldtype -- 贵金属类别
    ,nvl(n.grade, o.grade) as grade -- 品种/等级
    ,nvl(n.graderemark, o.graderemark) as graderemark -- 品种/等级描述
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
from (select * from ${iol_schema}.icms_clr_asset_finance_gold_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_finance_gold where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.ismaterial <> n.ismaterial
        or o.voucherno <> n.voucherno
        or o.registno <> n.registno
        or o.collorg <> n.collorg
        or o.quality <> n.quality
        or o.unit <> n.unit
        or o.unitprice <> n.unitprice
        or o.currency <> n.currency
        or o.remark <> n.remark
        or o.goldtype <> n.goldtype
        or o.grade <> n.grade
        or o.graderemark <> n.graderemark
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_finance_gold_cl(
            clrid -- 押品编号
            ,ismaterial -- 是否为实物贵金属
            ,voucherno -- 实物入库凭证号
            ,registno -- 交易所质押登记号
            ,collorg -- 非实物托管单位名称
            ,quality -- 质量
            ,unit -- 质量单位
            ,unitprice -- 贵金属单位价值(元)
            ,currency -- 币种
            ,remark -- 其他说明
            ,goldtype -- 贵金属类别
            ,grade -- 品种/等级
            ,graderemark -- 品种/等级描述
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_finance_gold_op(
            clrid -- 押品编号
            ,ismaterial -- 是否为实物贵金属
            ,voucherno -- 实物入库凭证号
            ,registno -- 交易所质押登记号
            ,collorg -- 非实物托管单位名称
            ,quality -- 质量
            ,unit -- 质量单位
            ,unitprice -- 贵金属单位价值(元)
            ,currency -- 币种
            ,remark -- 其他说明
            ,goldtype -- 贵金属类别
            ,grade -- 品种/等级
            ,graderemark -- 品种/等级描述
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.ismaterial -- 是否为实物贵金属
    ,o.voucherno -- 实物入库凭证号
    ,o.registno -- 交易所质押登记号
    ,o.collorg -- 非实物托管单位名称
    ,o.quality -- 质量
    ,o.unit -- 质量单位
    ,o.unitprice -- 贵金属单位价值(元)
    ,o.currency -- 币种
    ,o.remark -- 其他说明
    ,o.goldtype -- 贵金属类别
    ,o.grade -- 品种/等级
    ,o.graderemark -- 品种/等级描述
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
from ${iol_schema}.icms_clr_asset_finance_gold_bk o
    left join ${iol_schema}.icms_clr_asset_finance_gold_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_finance_gold_cl d
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
--truncate table ${iol_schema}.icms_clr_asset_finance_gold;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_finance_gold') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_finance_gold drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_finance_gold add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_finance_gold exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_finance_gold_cl;
alter table ${iol_schema}.icms_clr_asset_finance_gold exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_finance_gold_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_finance_gold to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_finance_gold_op purge;
drop table ${iol_schema}.icms_clr_asset_finance_gold_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_finance_gold_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_finance_gold',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
