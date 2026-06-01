/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_hksharedescription
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
create table ${iol_schema}.wind_hksharedescription_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_hksharedescription;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_hksharedescription_op purge;
drop table ${iol_schema}.wind_hksharedescription_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hksharedescription_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_hksharedescription where 0=1;

create table ${iol_schema}.wind_hksharedescription_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_hksharedescription where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_hksharedescription_cl(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_code -- 交易代码
            ,s_info_isincode -- [内部]ISIN代码
            ,s_info_name -- 证券中文简称
            ,s_info_name_eng -- [内部]证券英文简称
            ,s_info_fullname -- [内部]证券中文全称
            ,s_info_fullname_eng -- [内部]证券英文全称
            ,securityclass -- 品种大类代码
            ,securitysubclass -- 品种细类代码
            ,securitytype -- 品种类型(兼容)
            ,s_info_countrycode -- 国家及地区代码
            ,s_info_exchange_eng -- 交易所英文简称
            ,s_info_exchange -- 交易所名称(兼容)
            ,s_info_listboard -- 上市板
            ,s_info_compcode -- 公司id
            ,s_info_status -- 存续状态
            ,crncy_code -- 交易币种
            ,s_info_par -- 面值
            ,min_prc_chg_unit -- 最小价格变动单位
            ,s_info_unitperlot -- 每手数量
            ,s_info_listdate -- 开始交易日期
            ,s_info_delistdate -- 最后交易日期
            ,s_info_listprice -- 挂牌价
            ,is_hksc -- 是否在港股通范围内
            ,istemporarysymbol -- 是否并行临时代码
            ,is_h -- 是否是H股
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_hksharedescription_op(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_code -- 交易代码
            ,s_info_isincode -- [内部]ISIN代码
            ,s_info_name -- 证券中文简称
            ,s_info_name_eng -- [内部]证券英文简称
            ,s_info_fullname -- [内部]证券中文全称
            ,s_info_fullname_eng -- [内部]证券英文全称
            ,securityclass -- 品种大类代码
            ,securitysubclass -- 品种细类代码
            ,securitytype -- 品种类型(兼容)
            ,s_info_countrycode -- 国家及地区代码
            ,s_info_exchange_eng -- 交易所英文简称
            ,s_info_exchange -- 交易所名称(兼容)
            ,s_info_listboard -- 上市板
            ,s_info_compcode -- 公司id
            ,s_info_status -- 存续状态
            ,crncy_code -- 交易币种
            ,s_info_par -- 面值
            ,min_prc_chg_unit -- 最小价格变动单位
            ,s_info_unitperlot -- 每手数量
            ,s_info_listdate -- 开始交易日期
            ,s_info_delistdate -- 最后交易日期
            ,s_info_listprice -- 挂牌价
            ,is_hksc -- 是否在港股通范围内
            ,istemporarysymbol -- 是否并行临时代码
            ,is_h -- 是否是H股
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.object_id, o.object_id) as object_id -- 对象ID
    ,nvl(n.s_info_windcode, o.s_info_windcode) as s_info_windcode -- Wind代码
    ,nvl(n.s_info_code, o.s_info_code) as s_info_code -- 交易代码
    ,nvl(n.s_info_isincode, o.s_info_isincode) as s_info_isincode -- [内部]ISIN代码
    ,nvl(n.s_info_name, o.s_info_name) as s_info_name -- 证券中文简称
    ,nvl(n.s_info_name_eng, o.s_info_name_eng) as s_info_name_eng -- [内部]证券英文简称
    ,nvl(n.s_info_fullname, o.s_info_fullname) as s_info_fullname -- [内部]证券中文全称
    ,nvl(n.s_info_fullname_eng, o.s_info_fullname_eng) as s_info_fullname_eng -- [内部]证券英文全称
    ,nvl(n.securityclass, o.securityclass) as securityclass -- 品种大类代码
    ,nvl(n.securitysubclass, o.securitysubclass) as securitysubclass -- 品种细类代码
    ,nvl(n.securitytype, o.securitytype) as securitytype -- 品种类型(兼容)
    ,nvl(n.s_info_countrycode, o.s_info_countrycode) as s_info_countrycode -- 国家及地区代码
    ,nvl(n.s_info_exchange_eng, o.s_info_exchange_eng) as s_info_exchange_eng -- 交易所英文简称
    ,nvl(n.s_info_exchange, o.s_info_exchange) as s_info_exchange -- 交易所名称(兼容)
    ,nvl(n.s_info_listboard, o.s_info_listboard) as s_info_listboard -- 上市板
    ,nvl(n.s_info_compcode, o.s_info_compcode) as s_info_compcode -- 公司id
    ,nvl(n.s_info_status, o.s_info_status) as s_info_status -- 存续状态
    ,nvl(n.crncy_code, o.crncy_code) as crncy_code -- 交易币种
    ,nvl(n.s_info_par, o.s_info_par) as s_info_par -- 面值
    ,nvl(n.min_prc_chg_unit, o.min_prc_chg_unit) as min_prc_chg_unit -- 最小价格变动单位
    ,nvl(n.s_info_unitperlot, o.s_info_unitperlot) as s_info_unitperlot -- 每手数量
    ,nvl(n.s_info_listdate, o.s_info_listdate) as s_info_listdate -- 开始交易日期
    ,nvl(n.s_info_delistdate, o.s_info_delistdate) as s_info_delistdate -- 最后交易日期
    ,nvl(n.s_info_listprice, o.s_info_listprice) as s_info_listprice -- 挂牌价
    ,nvl(n.is_hksc, o.is_hksc) as is_hksc -- 是否在港股通范围内
    ,nvl(n.istemporarysymbol, o.istemporarysymbol) as istemporarysymbol -- 是否并行临时代码
    ,nvl(n.is_h, o.is_h) as is_h -- 是否是H股
    ,nvl(n.opdate, o.opdate) as opdate -- 
    ,nvl(n.opmode, o.opmode) as opmode -- 
    ,case when
            n.object_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.object_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.object_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_hksharedescription_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_hksharedescription where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
where (
        o.object_id is null
    )
    or (
        n.object_id is null
    )
    or (
        o.s_info_windcode <> n.s_info_windcode
        or o.s_info_code <> n.s_info_code
        or o.s_info_isincode <> n.s_info_isincode
        or o.s_info_name <> n.s_info_name
        or o.s_info_name_eng <> n.s_info_name_eng
        or o.s_info_fullname <> n.s_info_fullname
        or o.s_info_fullname_eng <> n.s_info_fullname_eng
        or o.securityclass <> n.securityclass
        or o.securitysubclass <> n.securitysubclass
        or o.securitytype <> n.securitytype
        or o.s_info_countrycode <> n.s_info_countrycode
        or o.s_info_exchange_eng <> n.s_info_exchange_eng
        or o.s_info_exchange <> n.s_info_exchange
        or o.s_info_listboard <> n.s_info_listboard
        or o.s_info_compcode <> n.s_info_compcode
        or o.s_info_status <> n.s_info_status
        or o.crncy_code <> n.crncy_code
        or o.s_info_par <> n.s_info_par
        or o.min_prc_chg_unit <> n.min_prc_chg_unit
        or o.s_info_unitperlot <> n.s_info_unitperlot
        or o.s_info_listdate <> n.s_info_listdate
        or o.s_info_delistdate <> n.s_info_delistdate
        or o.s_info_listprice <> n.s_info_listprice
        or o.is_hksc <> n.is_hksc
        or o.istemporarysymbol <> n.istemporarysymbol
        or o.is_h <> n.is_h
        or o.opdate <> n.opdate
        or o.opmode <> n.opmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_hksharedescription_cl(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_code -- 交易代码
            ,s_info_isincode -- [内部]ISIN代码
            ,s_info_name -- 证券中文简称
            ,s_info_name_eng -- [内部]证券英文简称
            ,s_info_fullname -- [内部]证券中文全称
            ,s_info_fullname_eng -- [内部]证券英文全称
            ,securityclass -- 品种大类代码
            ,securitysubclass -- 品种细类代码
            ,securitytype -- 品种类型(兼容)
            ,s_info_countrycode -- 国家及地区代码
            ,s_info_exchange_eng -- 交易所英文简称
            ,s_info_exchange -- 交易所名称(兼容)
            ,s_info_listboard -- 上市板
            ,s_info_compcode -- 公司id
            ,s_info_status -- 存续状态
            ,crncy_code -- 交易币种
            ,s_info_par -- 面值
            ,min_prc_chg_unit -- 最小价格变动单位
            ,s_info_unitperlot -- 每手数量
            ,s_info_listdate -- 开始交易日期
            ,s_info_delistdate -- 最后交易日期
            ,s_info_listprice -- 挂牌价
            ,is_hksc -- 是否在港股通范围内
            ,istemporarysymbol -- 是否并行临时代码
            ,is_h -- 是否是H股
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_hksharedescription_op(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_code -- 交易代码
            ,s_info_isincode -- [内部]ISIN代码
            ,s_info_name -- 证券中文简称
            ,s_info_name_eng -- [内部]证券英文简称
            ,s_info_fullname -- [内部]证券中文全称
            ,s_info_fullname_eng -- [内部]证券英文全称
            ,securityclass -- 品种大类代码
            ,securitysubclass -- 品种细类代码
            ,securitytype -- 品种类型(兼容)
            ,s_info_countrycode -- 国家及地区代码
            ,s_info_exchange_eng -- 交易所英文简称
            ,s_info_exchange -- 交易所名称(兼容)
            ,s_info_listboard -- 上市板
            ,s_info_compcode -- 公司id
            ,s_info_status -- 存续状态
            ,crncy_code -- 交易币种
            ,s_info_par -- 面值
            ,min_prc_chg_unit -- 最小价格变动单位
            ,s_info_unitperlot -- 每手数量
            ,s_info_listdate -- 开始交易日期
            ,s_info_delistdate -- 最后交易日期
            ,s_info_listprice -- 挂牌价
            ,is_hksc -- 是否在港股通范围内
            ,istemporarysymbol -- 是否并行临时代码
            ,is_h -- 是否是H股
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
    ,o.s_info_code -- 交易代码
    ,o.s_info_isincode -- [内部]ISIN代码
    ,o.s_info_name -- 证券中文简称
    ,o.s_info_name_eng -- [内部]证券英文简称
    ,o.s_info_fullname -- [内部]证券中文全称
    ,o.s_info_fullname_eng -- [内部]证券英文全称
    ,o.securityclass -- 品种大类代码
    ,o.securitysubclass -- 品种细类代码
    ,o.securitytype -- 品种类型(兼容)
    ,o.s_info_countrycode -- 国家及地区代码
    ,o.s_info_exchange_eng -- 交易所英文简称
    ,o.s_info_exchange -- 交易所名称(兼容)
    ,o.s_info_listboard -- 上市板
    ,o.s_info_compcode -- 公司id
    ,o.s_info_status -- 存续状态
    ,o.crncy_code -- 交易币种
    ,o.s_info_par -- 面值
    ,o.min_prc_chg_unit -- 最小价格变动单位
    ,o.s_info_unitperlot -- 每手数量
    ,o.s_info_listdate -- 开始交易日期
    ,o.s_info_delistdate -- 最后交易日期
    ,o.s_info_listprice -- 挂牌价
    ,o.is_hksc -- 是否在港股通范围内
    ,o.istemporarysymbol -- 是否并行临时代码
    ,o.is_h -- 是否是H股
    ,o.opdate -- 
    ,o.opmode -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_hksharedescription_bk o
    left join ${iol_schema}.wind_hksharedescription_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_hksharedescription_cl d
        on
            o.object_id = d.object_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.wind_hksharedescription;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_hksharedescription exchange partition p_19000101 with table ${iol_schema}.wind_hksharedescription_cl;
alter table ${iol_schema}.wind_hksharedescription exchange partition p_20991231 with table ${iol_schema}.wind_hksharedescription_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_hksharedescription to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_hksharedescription_op purge;
drop table ${iol_schema}.wind_hksharedescription_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_hksharedescription_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_hksharedescription',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
