/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_windcustomcode
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.wind_windcustomcode_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_windcustomcode
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_windcustomcode_op purge;
drop table ${iol_schema}.wind_windcustomcode_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_windcustomcode_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_windcustomcode where 0=1;

create table ${iol_schema}.wind_windcustomcode_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_windcustomcode where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_windcustomcode_op(
        object_id -- 对象ID
        ,s_info_windcode -- Wind代码
        ,s_info_asharecode -- 证券ID
        ,s_info_compcode -- 公司ID
        ,s_info_securitiestypes -- 证券类型
        ,s_info_sectypename -- 类型名称
        ,s_info_countryname -- 国别
        ,s_info_countrycode -- 国别编号
        ,s_info_exchmarketname -- 交易所
        ,s_info_exchmarket -- 交易所编号
        ,crncy_name -- 币种
        ,crncy_code -- 币种编号
        ,s_info_isincode -- ISIN代码
        ,s_info_code -- 交易代码
        ,s_info_name -- 证券中文简称
        ,exchmarket -- 交易所
        ,security_status -- 存续状态
        ,s_info_org_code -- 组织机构代码
        ,s_info_typecode -- 分类代码
        ,s_info_min_price_chg_unit -- 最小价格变动单位
        ,s_info_lot_size -- 每手数量
        ,s_info_ename -- 证券英文简称
        ,opdate -- 
        ,opmode -- 
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.object_id -- 对象ID
    ,n.s_info_windcode -- Wind代码
    ,n.s_info_asharecode -- 证券ID
    ,n.s_info_compcode -- 公司ID
    ,n.s_info_securitiestypes -- 证券类型
    ,n.s_info_sectypename -- 类型名称
    ,n.s_info_countryname -- 国别
    ,n.s_info_countrycode -- 国别编号
    ,n.s_info_exchmarketname -- 交易所
    ,n.s_info_exchmarket -- 交易所编号
    ,n.crncy_name -- 币种
    ,n.crncy_code -- 币种编号
    ,n.s_info_isincode -- ISIN代码
    ,n.s_info_code -- 交易代码
    ,n.s_info_name -- 证券中文简称
    ,n.exchmarket -- 交易所
    ,n.security_status -- 存续状态
    ,n.s_info_org_code -- 组织机构代码
    ,n.s_info_typecode -- 分类代码
    ,n.s_info_min_price_chg_unit -- 最小价格变动单位
    ,n.s_info_lot_size -- 每手数量
    ,n.s_info_ename -- 证券英文简称
    ,n.opdate -- 
    ,n.opmode -- 
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_windcustomcode_bk o
    right join (select * from ${itl_schema}.wind_windcustomcode where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
where (
        o.object_id is null
    )
    or (
        o.s_info_windcode <> n.s_info_windcode
        or o.s_info_asharecode <> n.s_info_asharecode
        or o.s_info_compcode <> n.s_info_compcode
        or o.s_info_securitiestypes <> n.s_info_securitiestypes
        or o.s_info_sectypename <> n.s_info_sectypename
        or o.s_info_countryname <> n.s_info_countryname
        or o.s_info_countrycode <> n.s_info_countrycode
        or o.s_info_exchmarketname <> n.s_info_exchmarketname
        or o.s_info_exchmarket <> n.s_info_exchmarket
        or o.crncy_name <> n.crncy_name
        or o.crncy_code <> n.crncy_code
        or o.s_info_isincode <> n.s_info_isincode
        or o.s_info_code <> n.s_info_code
        or o.s_info_name <> n.s_info_name
        or o.exchmarket <> n.exchmarket
        or o.security_status <> n.security_status
        or o.s_info_org_code <> n.s_info_org_code
        or o.s_info_typecode <> n.s_info_typecode
        or o.s_info_min_price_chg_unit <> n.s_info_min_price_chg_unit
        or o.s_info_lot_size <> n.s_info_lot_size
        or o.s_info_ename <> n.s_info_ename
        or o.opdate <> n.opdate
        or o.opmode <> n.opmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_windcustomcode_cl(
            object_id -- 对象ID
        ,s_info_windcode -- Wind代码
        ,s_info_asharecode -- 证券ID
        ,s_info_compcode -- 公司ID
        ,s_info_securitiestypes -- 证券类型
        ,s_info_sectypename -- 类型名称
        ,s_info_countryname -- 国别
        ,s_info_countrycode -- 国别编号
        ,s_info_exchmarketname -- 交易所
        ,s_info_exchmarket -- 交易所编号
        ,crncy_name -- 币种
        ,crncy_code -- 币种编号
        ,s_info_isincode -- ISIN代码
        ,s_info_code -- 交易代码
        ,s_info_name -- 证券中文简称
        ,exchmarket -- 交易所
        ,security_status -- 存续状态
        ,s_info_org_code -- 组织机构代码
        ,s_info_typecode -- 分类代码
        ,s_info_min_price_chg_unit -- 最小价格变动单位
        ,s_info_lot_size -- 每手数量
        ,s_info_ename -- 证券英文简称
        ,opdate -- 
        ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_windcustomcode_op(
            object_id -- 对象ID
        ,s_info_windcode -- Wind代码
        ,s_info_asharecode -- 证券ID
        ,s_info_compcode -- 公司ID
        ,s_info_securitiestypes -- 证券类型
        ,s_info_sectypename -- 类型名称
        ,s_info_countryname -- 国别
        ,s_info_countrycode -- 国别编号
        ,s_info_exchmarketname -- 交易所
        ,s_info_exchmarket -- 交易所编号
        ,crncy_name -- 币种
        ,crncy_code -- 币种编号
        ,s_info_isincode -- ISIN代码
        ,s_info_code -- 交易代码
        ,s_info_name -- 证券中文简称
        ,exchmarket -- 交易所
        ,security_status -- 存续状态
        ,s_info_org_code -- 组织机构代码
        ,s_info_typecode -- 分类代码
        ,s_info_min_price_chg_unit -- 最小价格变动单位
        ,s_info_lot_size -- 每手数量
        ,s_info_ename -- 证券英文简称
        ,opdate -- 
        ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.s_info_windcode -- Wind代码
    ,o.s_info_asharecode -- 证券ID
    ,o.s_info_compcode -- 公司ID
    ,o.s_info_securitiestypes -- 证券类型
    ,o.s_info_sectypename -- 类型名称
    ,o.s_info_countryname -- 国别
    ,o.s_info_countrycode -- 国别编号
    ,o.s_info_exchmarketname -- 交易所
    ,o.s_info_exchmarket -- 交易所编号
    ,o.crncy_name -- 币种
    ,o.crncy_code -- 币种编号
    ,o.s_info_isincode -- ISIN代码
    ,o.s_info_code -- 交易代码
    ,o.s_info_name -- 证券中文简称
    ,o.exchmarket -- 交易所
    ,o.security_status -- 存续状态
    ,o.s_info_org_code -- 组织机构代码
    ,o.s_info_typecode -- 分类代码
    ,o.s_info_min_price_chg_unit -- 最小价格变动单位
    ,o.s_info_lot_size -- 每手数量
    ,o.s_info_ename -- 证券英文简称
    ,o.opdate -- 
    ,o.opmode -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_windcustomcode_bk o
    left join ${iol_schema}.wind_windcustomcode_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_windcustomcode;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wind_windcustomcode') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wind_windcustomcode drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wind_windcustomcode add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wind_windcustomcode exchange partition p_${batch_date} with table ${iol_schema}.wind_windcustomcode_cl;
alter table ${iol_schema}.wind_windcustomcode exchange partition p_20991231 with table ${iol_schema}.wind_windcustomcode_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_windcustomcode to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_windcustomcode_op purge;
drop table ${iol_schema}.wind_windcustomcode_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_windcustomcode_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_windcustomcode',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
