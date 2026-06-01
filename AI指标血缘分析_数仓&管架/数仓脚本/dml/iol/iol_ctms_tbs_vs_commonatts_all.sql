/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_commonatts_all
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
create table ${iol_schema}.ctms_tbs_vs_commonatts_all_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_commonatts_all;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_commonatts_all_op purge;
drop table ${iol_schema}.ctms_tbs_vs_commonatts_all_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_commonatts_all_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_commonatts_all where 0=1;

create table ${iol_schema}.ctms_tbs_vs_commonatts_all_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_commonatts_all where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_commonatts_all_cl(
            commonatts_id -- 交易对手分类ID
            ,aspclient_id -- 部门ID
            ,singleormulti -- 单一/多数
            ,commonatts_shortname -- 发行人分类简称
            ,commonatts_desc -- 发行人分类描述
            ,commonatts_id_parent -- 发行人分类父节点
            ,type -- 类型
            ,lastmodified -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_commonatts_all_op(
            commonatts_id -- 交易对手分类ID
            ,aspclient_id -- 部门ID
            ,singleormulti -- 单一/多数
            ,commonatts_shortname -- 发行人分类简称
            ,commonatts_desc -- 发行人分类描述
            ,commonatts_id_parent -- 发行人分类父节点
            ,type -- 类型
            ,lastmodified -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.commonatts_id, o.commonatts_id) as commonatts_id -- 交易对手分类ID
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门ID
    ,nvl(n.singleormulti, o.singleormulti) as singleormulti -- 单一/多数
    ,nvl(n.commonatts_shortname, o.commonatts_shortname) as commonatts_shortname -- 发行人分类简称
    ,nvl(n.commonatts_desc, o.commonatts_desc) as commonatts_desc -- 发行人分类描述
    ,nvl(n.commonatts_id_parent, o.commonatts_id_parent) as commonatts_id_parent -- 发行人分类父节点
    ,nvl(n.type, o.type) as type -- 类型
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,case when
            n.commonatts_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.commonatts_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.commonatts_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_vs_commonatts_all_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_commonatts_all where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.commonatts_id = n.commonatts_id
where (
        o.commonatts_id is null
    )
    or (
        n.commonatts_id is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.singleormulti <> n.singleormulti
        or o.commonatts_shortname <> n.commonatts_shortname
        or o.commonatts_desc <> n.commonatts_desc
        or o.commonatts_id_parent <> n.commonatts_id_parent
        or o.type <> n.type
        or o.lastmodified <> n.lastmodified
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_commonatts_all_cl(
            commonatts_id -- 交易对手分类ID
            ,aspclient_id -- 部门ID
            ,singleormulti -- 单一/多数
            ,commonatts_shortname -- 发行人分类简称
            ,commonatts_desc -- 发行人分类描述
            ,commonatts_id_parent -- 发行人分类父节点
            ,type -- 类型
            ,lastmodified -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_commonatts_all_op(
            commonatts_id -- 交易对手分类ID
            ,aspclient_id -- 部门ID
            ,singleormulti -- 单一/多数
            ,commonatts_shortname -- 发行人分类简称
            ,commonatts_desc -- 发行人分类描述
            ,commonatts_id_parent -- 发行人分类父节点
            ,type -- 类型
            ,lastmodified -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.commonatts_id -- 交易对手分类ID
    ,o.aspclient_id -- 部门ID
    ,o.singleormulti -- 单一/多数
    ,o.commonatts_shortname -- 发行人分类简称
    ,o.commonatts_desc -- 发行人分类描述
    ,o.commonatts_id_parent -- 发行人分类父节点
    ,o.type -- 类型
    ,o.lastmodified -- 最后修改时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_vs_commonatts_all_bk o
    left join ${iol_schema}.ctms_tbs_vs_commonatts_all_op n
        on
            o.commonatts_id = n.commonatts_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_commonatts_all_cl d
        on
            o.commonatts_id = d.commonatts_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_vs_commonatts_all;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_commonatts_all exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_vs_commonatts_all_cl;
alter table ${iol_schema}.ctms_tbs_vs_commonatts_all exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_commonatts_all_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_commonatts_all to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_commonatts_all_op purge;
drop table ${iol_schema}.ctms_tbs_vs_commonatts_all_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_commonatts_all_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_commonatts_all',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
