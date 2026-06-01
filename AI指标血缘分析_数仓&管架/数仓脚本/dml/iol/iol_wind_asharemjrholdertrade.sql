/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_asharemjrholdertrade
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
create table ${iol_schema}.wind_asharemjrholdertrade_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_asharemjrholdertrade;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_asharemjrholdertrade_op purge;
drop table ${iol_schema}.wind_asharemjrholdertrade_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharemjrholdertrade_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_asharemjrholdertrade where 0=1;

create table ${iol_schema}.wind_asharemjrholdertrade_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_asharemjrholdertrade where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_asharemjrholdertrade_cl(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,ann_dt -- 公告日期
            ,transact_startdate -- 变动起始日期
            ,transact_enddate -- 变动截至日期
            ,holder_name -- 持有人
            ,holder_type -- 持有人类型
            ,transact_type -- 买卖方向
            ,transact_quantity -- 变动数量
            ,transact_quantity_ratio -- 变动数量占流通量比例(%)
            ,holder_quantity_new -- 最新持有流通数量
            ,holder_quantity_new_ratio -- 最新持有流通数量占流通量比例(%)
            ,avg_price -- 平均价格
            ,whether_agreed_repur_trans -- 是否约定购回式交易
            ,blocktrade_quantity -- 通过大宗交易系统的变动数量
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_asharemjrholdertrade_op(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,ann_dt -- 公告日期
            ,transact_startdate -- 变动起始日期
            ,transact_enddate -- 变动截至日期
            ,holder_name -- 持有人
            ,holder_type -- 持有人类型
            ,transact_type -- 买卖方向
            ,transact_quantity -- 变动数量
            ,transact_quantity_ratio -- 变动数量占流通量比例(%)
            ,holder_quantity_new -- 最新持有流通数量
            ,holder_quantity_new_ratio -- 最新持有流通数量占流通量比例(%)
            ,avg_price -- 平均价格
            ,whether_agreed_repur_trans -- 是否约定购回式交易
            ,blocktrade_quantity -- 通过大宗交易系统的变动数量
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.object_id, o.object_id) as object_id -- 对象id
    ,nvl(n.s_info_windcode, o.s_info_windcode) as s_info_windcode -- wind代码
    ,nvl(n.ann_dt, o.ann_dt) as ann_dt -- 公告日期
    ,nvl(n.transact_startdate, o.transact_startdate) as transact_startdate -- 变动起始日期
    ,nvl(n.transact_enddate, o.transact_enddate) as transact_enddate -- 变动截至日期
    ,nvl(n.holder_name, o.holder_name) as holder_name -- 持有人
    ,nvl(n.holder_type, o.holder_type) as holder_type -- 持有人类型
    ,nvl(n.transact_type, o.transact_type) as transact_type -- 买卖方向
    ,nvl(n.transact_quantity, o.transact_quantity) as transact_quantity -- 变动数量
    ,nvl(n.transact_quantity_ratio, o.transact_quantity_ratio) as transact_quantity_ratio -- 变动数量占流通量比例(%)
    ,nvl(n.holder_quantity_new, o.holder_quantity_new) as holder_quantity_new -- 最新持有流通数量
    ,nvl(n.holder_quantity_new_ratio, o.holder_quantity_new_ratio) as holder_quantity_new_ratio -- 最新持有流通数量占流通量比例(%)
    ,nvl(n.avg_price, o.avg_price) as avg_price -- 平均价格
    ,nvl(n.whether_agreed_repur_trans, o.whether_agreed_repur_trans) as whether_agreed_repur_trans -- 是否约定购回式交易
    ,nvl(n.blocktrade_quantity, o.blocktrade_quantity) as blocktrade_quantity -- 通过大宗交易系统的变动数量
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
from (select * from ${iol_schema}.wind_asharemjrholdertrade_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_asharemjrholdertrade where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.ann_dt <> n.ann_dt
        or o.transact_startdate <> n.transact_startdate
        or o.transact_enddate <> n.transact_enddate
        or o.holder_name <> n.holder_name
        or o.holder_type <> n.holder_type
        or o.transact_type <> n.transact_type
        or o.transact_quantity <> n.transact_quantity
        or o.transact_quantity_ratio <> n.transact_quantity_ratio
        or o.holder_quantity_new <> n.holder_quantity_new
        or o.holder_quantity_new_ratio <> n.holder_quantity_new_ratio
        or o.avg_price <> n.avg_price
        or o.whether_agreed_repur_trans <> n.whether_agreed_repur_trans
        or o.blocktrade_quantity <> n.blocktrade_quantity
        or o.opdate <> n.opdate
        or o.opmode <> n.opmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_asharemjrholdertrade_cl(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,ann_dt -- 公告日期
            ,transact_startdate -- 变动起始日期
            ,transact_enddate -- 变动截至日期
            ,holder_name -- 持有人
            ,holder_type -- 持有人类型
            ,transact_type -- 买卖方向
            ,transact_quantity -- 变动数量
            ,transact_quantity_ratio -- 变动数量占流通量比例(%)
            ,holder_quantity_new -- 最新持有流通数量
            ,holder_quantity_new_ratio -- 最新持有流通数量占流通量比例(%)
            ,avg_price -- 平均价格
            ,whether_agreed_repur_trans -- 是否约定购回式交易
            ,blocktrade_quantity -- 通过大宗交易系统的变动数量
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_asharemjrholdertrade_op(
            object_id -- 对象id
            ,s_info_windcode -- wind代码
            ,ann_dt -- 公告日期
            ,transact_startdate -- 变动起始日期
            ,transact_enddate -- 变动截至日期
            ,holder_name -- 持有人
            ,holder_type -- 持有人类型
            ,transact_type -- 买卖方向
            ,transact_quantity -- 变动数量
            ,transact_quantity_ratio -- 变动数量占流通量比例(%)
            ,holder_quantity_new -- 最新持有流通数量
            ,holder_quantity_new_ratio -- 最新持有流通数量占流通量比例(%)
            ,avg_price -- 平均价格
            ,whether_agreed_repur_trans -- 是否约定购回式交易
            ,blocktrade_quantity -- 通过大宗交易系统的变动数量
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象id
    ,o.s_info_windcode -- wind代码
    ,o.ann_dt -- 公告日期
    ,o.transact_startdate -- 变动起始日期
    ,o.transact_enddate -- 变动截至日期
    ,o.holder_name -- 持有人
    ,o.holder_type -- 持有人类型
    ,o.transact_type -- 买卖方向
    ,o.transact_quantity -- 变动数量
    ,o.transact_quantity_ratio -- 变动数量占流通量比例(%)
    ,o.holder_quantity_new -- 最新持有流通数量
    ,o.holder_quantity_new_ratio -- 最新持有流通数量占流通量比例(%)
    ,o.avg_price -- 平均价格
    ,o.whether_agreed_repur_trans -- 是否约定购回式交易
    ,o.blocktrade_quantity -- 通过大宗交易系统的变动数量
    ,o.opdate -- 
    ,o.opmode -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_asharemjrholdertrade_bk o
    left join ${iol_schema}.wind_asharemjrholdertrade_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_asharemjrholdertrade_cl d
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
-- truncate table ${iol_schema}.wind_asharemjrholdertrade;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_asharemjrholdertrade exchange partition p_19000101 with table ${iol_schema}.wind_asharemjrholdertrade_cl;
alter table ${iol_schema}.wind_asharemjrholdertrade exchange partition p_20991231 with table ${iol_schema}.wind_asharemjrholdertrade_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_asharemjrholdertrade to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_asharemjrholdertrade_op purge;
drop table ${iol_schema}.wind_asharemjrholdertrade_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_asharemjrholdertrade_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_asharemjrholdertrade',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
