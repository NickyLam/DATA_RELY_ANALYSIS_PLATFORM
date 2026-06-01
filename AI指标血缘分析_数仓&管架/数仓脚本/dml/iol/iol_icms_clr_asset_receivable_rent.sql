/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_receivable_rent
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
create table ${iol_schema}.icms_clr_asset_receivable_rent_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_receivable_rent
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_receivable_rent_op purge;
drop table ${iol_schema}.icms_clr_asset_receivable_rent_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_receivable_rent_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_receivable_rent where 0=1;

create table ${iol_schema}.icms_clr_asset_receivable_rent_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_receivable_rent where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_receivable_rent_cl(
            clrid -- 押品编号
            ,renttime -- 每年收租次数
            ,renttype -- 租金类型
            ,tdcurrency -- 币种
            ,rentmoney -- 每次收取的固定租金金额
            ,descibe -- 每次收取的浮动租金金额描述
            ,startdate -- 租约开始日期
            ,duedate -- 租约结束日期
            ,isnotice -- 是否通知应收账款义务人
            ,isproduce -- 是否由销售、出租、或提供服务产生债权
            ,isrelation2 -- 是否与证券化、从属参与或信用衍生工具相关
            ,remark -- 其他说明
            ,leasecontract -- 租约合同号
            ,frequency -- 收租频率
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,guarantyregno -- 抵押登记编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_receivable_rent_op(
            clrid -- 押品编号
            ,renttime -- 每年收租次数
            ,renttype -- 租金类型
            ,tdcurrency -- 币种
            ,rentmoney -- 每次收取的固定租金金额
            ,descibe -- 每次收取的浮动租金金额描述
            ,startdate -- 租约开始日期
            ,duedate -- 租约结束日期
            ,isnotice -- 是否通知应收账款义务人
            ,isproduce -- 是否由销售、出租、或提供服务产生债权
            ,isrelation2 -- 是否与证券化、从属参与或信用衍生工具相关
            ,remark -- 其他说明
            ,leasecontract -- 租约合同号
            ,frequency -- 收租频率
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,guarantyregno -- 抵押登记编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.renttime, o.renttime) as renttime -- 每年收租次数
    ,nvl(n.renttype, o.renttype) as renttype -- 租金类型
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,nvl(n.rentmoney, o.rentmoney) as rentmoney -- 每次收取的固定租金金额
    ,nvl(n.descibe, o.descibe) as descibe -- 每次收取的浮动租金金额描述
    ,nvl(n.startdate, o.startdate) as startdate -- 租约开始日期
    ,nvl(n.duedate, o.duedate) as duedate -- 租约结束日期
    ,nvl(n.isnotice, o.isnotice) as isnotice -- 是否通知应收账款义务人
    ,nvl(n.isproduce, o.isproduce) as isproduce -- 是否由销售、出租、或提供服务产生债权
    ,nvl(n.isrelation2, o.isrelation2) as isrelation2 -- 是否与证券化、从属参与或信用衍生工具相关
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.leasecontract, o.leasecontract) as leasecontract -- 租约合同号
    ,nvl(n.frequency, o.frequency) as frequency -- 收租频率
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,nvl(n.guarantyregno, o.guarantyregno) as guarantyregno -- 抵押登记编号
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
from (select * from ${iol_schema}.icms_clr_asset_receivable_rent_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_receivable_rent where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.renttime <> n.renttime
        or o.renttype <> n.renttype
        or o.tdcurrency <> n.tdcurrency
        or o.rentmoney <> n.rentmoney
        or o.descibe <> n.descibe
        or o.startdate <> n.startdate
        or o.duedate <> n.duedate
        or o.isnotice <> n.isnotice
        or o.isproduce <> n.isproduce
        or o.isrelation2 <> n.isrelation2
        or o.remark <> n.remark
        or o.leasecontract <> n.leasecontract
        or o.frequency <> n.frequency
        or o.migtflag <> n.migtflag
        or o.guarantyregno <> n.guarantyregno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_receivable_rent_cl(
            clrid -- 押品编号
            ,renttime -- 每年收租次数
            ,renttype -- 租金类型
            ,tdcurrency -- 币种
            ,rentmoney -- 每次收取的固定租金金额
            ,descibe -- 每次收取的浮动租金金额描述
            ,startdate -- 租约开始日期
            ,duedate -- 租约结束日期
            ,isnotice -- 是否通知应收账款义务人
            ,isproduce -- 是否由销售、出租、或提供服务产生债权
            ,isrelation2 -- 是否与证券化、从属参与或信用衍生工具相关
            ,remark -- 其他说明
            ,leasecontract -- 租约合同号
            ,frequency -- 收租频率
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,guarantyregno -- 抵押登记编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_receivable_rent_op(
            clrid -- 押品编号
            ,renttime -- 每年收租次数
            ,renttype -- 租金类型
            ,tdcurrency -- 币种
            ,rentmoney -- 每次收取的固定租金金额
            ,descibe -- 每次收取的浮动租金金额描述
            ,startdate -- 租约开始日期
            ,duedate -- 租约结束日期
            ,isnotice -- 是否通知应收账款义务人
            ,isproduce -- 是否由销售、出租、或提供服务产生债权
            ,isrelation2 -- 是否与证券化、从属参与或信用衍生工具相关
            ,remark -- 其他说明
            ,leasecontract -- 租约合同号
            ,frequency -- 收租频率
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,guarantyregno -- 抵押登记编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.renttime -- 每年收租次数
    ,o.renttype -- 租金类型
    ,o.tdcurrency -- 币种
    ,o.rentmoney -- 每次收取的固定租金金额
    ,o.descibe -- 每次收取的浮动租金金额描述
    ,o.startdate -- 租约开始日期
    ,o.duedate -- 租约结束日期
    ,o.isnotice -- 是否通知应收账款义务人
    ,o.isproduce -- 是否由销售、出租、或提供服务产生债权
    ,o.isrelation2 -- 是否与证券化、从属参与或信用衍生工具相关
    ,o.remark -- 其他说明
    ,o.leasecontract -- 租约合同号
    ,o.frequency -- 收租频率
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
    ,o.guarantyregno -- 抵押登记编号
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
from ${iol_schema}.icms_clr_asset_receivable_rent_bk o
    left join ${iol_schema}.icms_clr_asset_receivable_rent_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_receivable_rent_cl d
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
--truncate table ${iol_schema}.icms_clr_asset_receivable_rent;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_receivable_rent') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_receivable_rent drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_receivable_rent add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_receivable_rent exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_receivable_rent_cl;
alter table ${iol_schema}.icms_clr_asset_receivable_rent exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_receivable_rent_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_receivable_rent to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_receivable_rent_op purge;
drop table ${iol_schema}.icms_clr_asset_receivable_rent_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_receivable_rent_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_receivable_rent',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
