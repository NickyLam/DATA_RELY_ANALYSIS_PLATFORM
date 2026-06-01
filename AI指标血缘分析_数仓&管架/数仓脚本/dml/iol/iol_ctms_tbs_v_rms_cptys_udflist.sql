/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_rms_cptys_udflist
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
create table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_rms_cptys_udflist;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_op purge;
drop table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_rms_cptys_udflist where 0=1;

create table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_rms_cptys_udflist where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_cl(
            entyid -- 交易对手编号
            ,udf_code -- 自定义字段编号
            ,udf_desc -- 自定义字段名称
            ,udf_type -- 自定义字段类型
            ,udf_value -- 自定义字段值
            ,udf_valuedesc -- 自定义字段枚举值名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_op(
            entyid -- 交易对手编号
            ,udf_code -- 自定义字段编号
            ,udf_desc -- 自定义字段名称
            ,udf_type -- 自定义字段类型
            ,udf_value -- 自定义字段值
            ,udf_valuedesc -- 自定义字段枚举值名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.entyid, o.entyid) as entyid -- 交易对手编号
    ,nvl(n.udf_code, o.udf_code) as udf_code -- 自定义字段编号
    ,nvl(n.udf_desc, o.udf_desc) as udf_desc -- 自定义字段名称
    ,nvl(n.udf_type, o.udf_type) as udf_type -- 自定义字段类型
    ,nvl(n.udf_value, o.udf_value) as udf_value -- 自定义字段值
    ,nvl(n.udf_valuedesc, o.udf_valuedesc) as udf_valuedesc -- 自定义字段枚举值名称
    ,case when
            n.entyid is null
            and n.udf_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.entyid is null
            and n.udf_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.entyid is null
            and n.udf_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_rms_cptys_udflist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.entyid = n.entyid
            and o.udf_code = n.udf_code
where (
        o.entyid is null
        and o.udf_code is null
    )
    or (
        n.entyid is null
        and n.udf_code is null
    )
    or (
        o.udf_desc <> n.udf_desc
        or o.udf_type <> n.udf_type
        or o.udf_value <> n.udf_value
        or o.udf_valuedesc <> n.udf_valuedesc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_cl(
            entyid -- 交易对手编号
            ,udf_code -- 自定义字段编号
            ,udf_desc -- 自定义字段名称
            ,udf_type -- 自定义字段类型
            ,udf_value -- 自定义字段值
            ,udf_valuedesc -- 自定义字段枚举值名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_op(
            entyid -- 交易对手编号
            ,udf_code -- 自定义字段编号
            ,udf_desc -- 自定义字段名称
            ,udf_type -- 自定义字段类型
            ,udf_value -- 自定义字段值
            ,udf_valuedesc -- 自定义字段枚举值名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.entyid -- 交易对手编号
    ,o.udf_code -- 自定义字段编号
    ,o.udf_desc -- 自定义字段名称
    ,o.udf_type -- 自定义字段类型
    ,o.udf_value -- 自定义字段值
    ,o.udf_valuedesc -- 自定义字段枚举值名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_bk o
    left join ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_op n
        on
            o.entyid = n.entyid
            and o.udf_code = n.udf_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_cl d
        on
            o.entyid = d.entyid
            and o.udf_code = d.udf_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_cl;
alter table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_rms_cptys_udflist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_op purge;
drop table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_rms_cptys_udflist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_rms_cptys_udflist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
