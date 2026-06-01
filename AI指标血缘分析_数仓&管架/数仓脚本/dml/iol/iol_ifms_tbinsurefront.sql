/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbinsurefront
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
create table ${iol_schema}.ifms_tbinsurefront_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbinsurefront;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsurefront_op purge;
drop table ${iol_schema}.ifms_tbinsurefront_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsurefront_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsurefront where 0=1;

create table ${iol_schema}.ifms_tbinsurefront_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsurefront where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsurefront_cl(
            trans_code -- 
            ,ta_code -- 
            ,prd_code -- 
            ,title_name -- 
            ,field_name -- 
            ,input_type -- 
            ,attr_type -- 
            ,spec_type -- 
            ,show_value -- 
            ,fix_value -- 
            ,fix_valuename -- 
            ,required -- 
            ,hs_key -- 
            ,order_no -- 
            ,belongtype -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsurefront_op(
            trans_code -- 
            ,ta_code -- 
            ,prd_code -- 
            ,title_name -- 
            ,field_name -- 
            ,input_type -- 
            ,attr_type -- 
            ,spec_type -- 
            ,show_value -- 
            ,fix_value -- 
            ,fix_valuename -- 
            ,required -- 
            ,hs_key -- 
            ,order_no -- 
            ,belongtype -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trans_code, o.trans_code) as trans_code -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.title_name, o.title_name) as title_name -- 
    ,nvl(n.field_name, o.field_name) as field_name -- 
    ,nvl(n.input_type, o.input_type) as input_type -- 
    ,nvl(n.attr_type, o.attr_type) as attr_type -- 
    ,nvl(n.spec_type, o.spec_type) as spec_type -- 
    ,nvl(n.show_value, o.show_value) as show_value -- 
    ,nvl(n.fix_value, o.fix_value) as fix_value -- 
    ,nvl(n.fix_valuename, o.fix_valuename) as fix_valuename -- 
    ,nvl(n.required, o.required) as required -- 
    ,nvl(n.hs_key, o.hs_key) as hs_key -- 
    ,nvl(n.order_no, o.order_no) as order_no -- 
    ,nvl(n.belongtype, o.belongtype) as belongtype -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,case when
            n.trans_code is null
            and n.ta_code is null
            and n.prd_code is null
            and n.field_name is null
            and n.belongtype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trans_code is null
            and n.ta_code is null
            and n.prd_code is null
            and n.field_name is null
            and n.belongtype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trans_code is null
            and n.ta_code is null
            and n.prd_code is null
            and n.field_name is null
            and n.belongtype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbinsurefront_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbinsurefront where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trans_code = n.trans_code
            and o.ta_code = n.ta_code
            and o.prd_code = n.prd_code
            and o.field_name = n.field_name
            and o.belongtype = n.belongtype
where (
        o.trans_code is null
        and o.ta_code is null
        and o.prd_code is null
        and o.field_name is null
        and o.belongtype is null
    )
    or (
        n.trans_code is null
        and n.ta_code is null
        and n.prd_code is null
        and n.field_name is null
        and n.belongtype is null
    )
    or (
        o.title_name <> n.title_name
        or o.input_type <> n.input_type
        or o.attr_type <> n.attr_type
        or o.spec_type <> n.spec_type
        or o.show_value <> n.show_value
        or o.fix_value <> n.fix_value
        or o.fix_valuename <> n.fix_valuename
        or o.required <> n.required
        or o.hs_key <> n.hs_key
        or o.order_no <> n.order_no
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsurefront_cl(
            trans_code -- 
            ,ta_code -- 
            ,prd_code -- 
            ,title_name -- 
            ,field_name -- 
            ,input_type -- 
            ,attr_type -- 
            ,spec_type -- 
            ,show_value -- 
            ,fix_value -- 
            ,fix_valuename -- 
            ,required -- 
            ,hs_key -- 
            ,order_no -- 
            ,belongtype -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsurefront_op(
            trans_code -- 
            ,ta_code -- 
            ,prd_code -- 
            ,title_name -- 
            ,field_name -- 
            ,input_type -- 
            ,attr_type -- 
            ,spec_type -- 
            ,show_value -- 
            ,fix_value -- 
            ,fix_valuename -- 
            ,required -- 
            ,hs_key -- 
            ,order_no -- 
            ,belongtype -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trans_code -- 
    ,o.ta_code -- 
    ,o.prd_code -- 
    ,o.title_name -- 
    ,o.field_name -- 
    ,o.input_type -- 
    ,o.attr_type -- 
    ,o.spec_type -- 
    ,o.show_value -- 
    ,o.fix_value -- 
    ,o.fix_valuename -- 
    ,o.required -- 
    ,o.hs_key -- 
    ,o.order_no -- 
    ,o.belongtype -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbinsurefront_bk o
    left join ${iol_schema}.ifms_tbinsurefront_op n
        on
            o.trans_code = n.trans_code
            and o.ta_code = n.ta_code
            and o.prd_code = n.prd_code
            and o.field_name = n.field_name
            and o.belongtype = n.belongtype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbinsurefront_cl d
        on
            o.trans_code = d.trans_code
            and o.ta_code = d.ta_code
            and o.prd_code = d.prd_code
            and o.field_name = d.field_name
            and o.belongtype = d.belongtype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbinsurefront;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbinsurefront exchange partition p_19000101 with table ${iol_schema}.ifms_tbinsurefront_cl;
alter table ${iol_schema}.ifms_tbinsurefront exchange partition p_20991231 with table ${iol_schema}.ifms_tbinsurefront_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbinsurefront to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsurefront_op purge;
drop table ${iol_schema}.ifms_tbinsurefront_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbinsurefront_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbinsurefront',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
