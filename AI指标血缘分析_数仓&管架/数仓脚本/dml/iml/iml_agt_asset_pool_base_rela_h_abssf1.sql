/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_asset_pool_base_rela_h_abssf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_asset_pool_base_rela_h add partition p_abssf1 values ('abssf1')(
        subpartition p_abssf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_abssf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_asset_pool_base_rela_h partition for ('abssf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_tm purge;
drop table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_op purge;
drop table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_pool_id -- 资产池编号
    ,parent_asset_pool_id -- 父资产池编号
    ,base_asset_id -- 基础资产编号
    ,asset_scr_rule_id -- 资产筛选规则编号
    ,obj_type -- 对象类型
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_asset_pool_base_rela_h partition for ('abssf1')
where 0=1
;

create table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_asset_pool_base_rela_h partition for ('abssf1') where 0=1;

create table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_asset_pool_base_rela_h partition for ('abssf1') where 0=1;

-- 3.1 get new data into table
-- abss_abs_pool_relative-
insert into ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_pool_id -- 资产池编号
    ,parent_asset_pool_id -- 父资产池编号
    ,base_asset_id -- 基础资产编号
    ,asset_scr_rule_id -- 资产筛选规则编号
    ,obj_type -- 对象类型
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225110'||P1.ASSETPOOLNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ASSETPOOLNO -- 资产池编号
    ,P1.PARENTASSETPOOLNO -- 父资产池编号
    ,P1.OBJECTNO -- 基础资产编号
    ,P1.RULENO -- 资产筛选规则编号
    ,P1.OBJECTTYPE -- 对象类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'abss_abs_pool_relative' -- 源表名称
    ,'abssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.abss_abs_pool_relative p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_pool_id -- 资产池编号
    ,parent_asset_pool_id -- 父资产池编号
    ,base_asset_id -- 基础资产编号
    ,asset_scr_rule_id -- 资产筛选规则编号
    ,obj_type -- 对象类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_pool_id -- 资产池编号
    ,parent_asset_pool_id -- 父资产池编号
    ,base_asset_id -- 基础资产编号
    ,asset_scr_rule_id -- 资产筛选规则编号
    ,obj_type -- 对象类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.asset_pool_id, o.asset_pool_id) as asset_pool_id -- 资产池编号
    ,nvl(n.parent_asset_pool_id, o.parent_asset_pool_id) as parent_asset_pool_id -- 父资产池编号
    ,nvl(n.base_asset_id, o.base_asset_id) as base_asset_id -- 基础资产编号
    ,nvl(n.asset_scr_rule_id, o.asset_scr_rule_id) as asset_scr_rule_id -- 资产筛选规则编号
    ,nvl(n.obj_type, o.obj_type) as obj_type -- 对象类型
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.base_asset_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.base_asset_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.base_asset_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_tm n
    full join (select * from ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.base_asset_id = n.base_asset_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.base_asset_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.base_asset_id is null
    )
    or (
        o.asset_pool_id <> n.asset_pool_id
        or o.parent_asset_pool_id <> n.parent_asset_pool_id
        or o.asset_scr_rule_id <> n.asset_scr_rule_id
        or o.obj_type <> n.obj_type
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_pool_id -- 资产池编号
    ,parent_asset_pool_id -- 父资产池编号
    ,base_asset_id -- 基础资产编号
    ,asset_scr_rule_id -- 资产筛选规则编号
    ,obj_type -- 对象类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_pool_id -- 资产池编号
    ,parent_asset_pool_id -- 父资产池编号
    ,base_asset_id -- 基础资产编号
    ,asset_scr_rule_id -- 资产筛选规则编号
    ,obj_type -- 对象类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.asset_pool_id -- 资产池编号
    ,o.parent_asset_pool_id -- 父资产池编号
    ,o.base_asset_id -- 基础资产编号
    ,o.asset_scr_rule_id -- 资产筛选规则编号
    ,o.obj_type -- 对象类型
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_bk o
    left join ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.base_asset_id = n.base_asset_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.base_asset_id = d.base_asset_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_asset_pool_base_rela_h;
alter table ${iml_schema}.agt_asset_pool_base_rela_h truncate partition for ('abssf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_asset_pool_base_rela_h exchange subpartition p_abssf1_19000101 with table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_cl;
alter table ${iml_schema}.agt_asset_pool_base_rela_h exchange subpartition p_abssf1_20991231 with table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_asset_pool_base_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_tm purge;
drop table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_op purge;
drop table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_asset_pool_base_rela_h_abssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_asset_pool_base_rela_h', partname => 'p_abssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
