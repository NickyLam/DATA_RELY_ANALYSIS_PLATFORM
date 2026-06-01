/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rpss_related_unit
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
create table ${iol_schema}.rpss_related_unit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rpss_related_unit
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rpss_related_unit_op purge;
drop table ${iol_schema}.rpss_related_unit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rpss_related_unit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rpss_related_unit where 0=1;

create table ${iol_schema}.rpss_related_unit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rpss_related_unit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rpss_related_unit_cl(
            related_id -- 关联方编号
            ,unit_name -- 单位名称
            ,certificate_no_dg -- 对公证件号码1
            ,certificate_no_dg_t -- 对公证件号码2
            ,relation -- 担任职务或关联关系
            ,group_name -- 单位归属的企业集团全称
            ,shareholding_ratio -- 持股比例
            ,comments -- 备注
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,belong_org -- 归属机构
            ,mainten_org -- 维护机构
            ,organization -- 所属机构
            ,certificate_type_id_dg -- 对公证件类型1
            ,certificate_type_id_dg_t -- 对公证件类型2
            ,domestic_or_foreign_dg -- 境内外标志1
            ,domestic_or_foreign_dg_t -- 境内外标志2
            ,hold_related_type -- 股东或关联方类型
            ,hold_related_industry -- 股东或关联方所属行业
            ,hold_related_reg_address -- 股东或关联方注册地
            ,hold_related_rel_type -- 股东或关联方关系类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rpss_related_unit_op(
            related_id -- 关联方编号
            ,unit_name -- 单位名称
            ,certificate_no_dg -- 对公证件号码1
            ,certificate_no_dg_t -- 对公证件号码2
            ,relation -- 担任职务或关联关系
            ,group_name -- 单位归属的企业集团全称
            ,shareholding_ratio -- 持股比例
            ,comments -- 备注
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,belong_org -- 归属机构
            ,mainten_org -- 维护机构
            ,organization -- 所属机构
            ,certificate_type_id_dg -- 对公证件类型1
            ,certificate_type_id_dg_t -- 对公证件类型2
            ,domestic_or_foreign_dg -- 境内外标志1
            ,domestic_or_foreign_dg_t -- 境内外标志2
            ,hold_related_type -- 股东或关联方类型
            ,hold_related_industry -- 股东或关联方所属行业
            ,hold_related_reg_address -- 股东或关联方注册地
            ,hold_related_rel_type -- 股东或关联方关系类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.related_id, o.related_id) as related_id -- 关联方编号
    ,nvl(n.unit_name, o.unit_name) as unit_name -- 单位名称
    ,nvl(n.certificate_no_dg, o.certificate_no_dg) as certificate_no_dg -- 对公证件号码1
    ,nvl(n.certificate_no_dg_t, o.certificate_no_dg_t) as certificate_no_dg_t -- 对公证件号码2
    ,nvl(n.relation, o.relation) as relation -- 担任职务或关联关系
    ,nvl(n.group_name, o.group_name) as group_name -- 单位归属的企业集团全称
    ,nvl(n.shareholding_ratio, o.shareholding_ratio) as shareholding_ratio -- 持股比例
    ,nvl(n.comments, o.comments) as comments -- 备注
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 最后更新时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 最后更新事务时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 创建事务时间
    ,nvl(n.belong_org, o.belong_org) as belong_org -- 归属机构
    ,nvl(n.mainten_org, o.mainten_org) as mainten_org -- 维护机构
    ,nvl(n.organization, o.organization) as organization -- 所属机构
    ,nvl(n.certificate_type_id_dg, o.certificate_type_id_dg) as certificate_type_id_dg -- 对公证件类型1
    ,nvl(n.certificate_type_id_dg_t, o.certificate_type_id_dg_t) as certificate_type_id_dg_t -- 对公证件类型2
    ,nvl(n.domestic_or_foreign_dg, o.domestic_or_foreign_dg) as domestic_or_foreign_dg -- 境内外标志1
    ,nvl(n.domestic_or_foreign_dg_t, o.domestic_or_foreign_dg_t) as domestic_or_foreign_dg_t -- 境内外标志2
    ,nvl(n.hold_related_type, o.hold_related_type) as hold_related_type -- 股东或关联方类型
    ,nvl(n.hold_related_industry, o.hold_related_industry) as hold_related_industry -- 股东或关联方所属行业
    ,nvl(n.hold_related_reg_address, o.hold_related_reg_address) as hold_related_reg_address -- 股东或关联方注册地
    ,nvl(n.hold_related_rel_type, o.hold_related_rel_type) as hold_related_rel_type -- 股东或关联方关系类型
    ,case when
            n.related_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.related_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.related_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rpss_related_unit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rpss_related_unit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.related_id = n.related_id
where (
        o.related_id is null
    )
    or (
        n.related_id is null
    )
    or (
        o.unit_name <> n.unit_name
        or o.certificate_no_dg <> n.certificate_no_dg
        or o.certificate_no_dg_t <> n.certificate_no_dg_t
        or o.relation <> n.relation
        or o.group_name <> n.group_name
        or o.shareholding_ratio <> n.shareholding_ratio
        or o.comments <> n.comments
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.belong_org <> n.belong_org
        or o.mainten_org <> n.mainten_org
        or o.organization <> n.organization
        or o.certificate_type_id_dg <> n.certificate_type_id_dg
        or o.certificate_type_id_dg_t <> n.certificate_type_id_dg_t
        or o.domestic_or_foreign_dg <> n.domestic_or_foreign_dg
        or o.domestic_or_foreign_dg_t <> n.domestic_or_foreign_dg_t
        or o.hold_related_type <> n.hold_related_type
        or o.hold_related_industry <> n.hold_related_industry
        or o.hold_related_reg_address <> n.hold_related_reg_address
        or o.hold_related_rel_type <> n.hold_related_rel_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rpss_related_unit_cl(
            related_id -- 关联方编号
            ,unit_name -- 单位名称
            ,certificate_no_dg -- 对公证件号码1
            ,certificate_no_dg_t -- 对公证件号码2
            ,relation -- 担任职务或关联关系
            ,group_name -- 单位归属的企业集团全称
            ,shareholding_ratio -- 持股比例
            ,comments -- 备注
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,belong_org -- 归属机构
            ,mainten_org -- 维护机构
            ,organization -- 所属机构
            ,certificate_type_id_dg -- 对公证件类型1
            ,certificate_type_id_dg_t -- 对公证件类型2
            ,domestic_or_foreign_dg -- 境内外标志1
            ,domestic_or_foreign_dg_t -- 境内外标志2
            ,hold_related_type -- 股东或关联方类型
            ,hold_related_industry -- 股东或关联方所属行业
            ,hold_related_reg_address -- 股东或关联方注册地
            ,hold_related_rel_type -- 股东或关联方关系类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rpss_related_unit_op(
            related_id -- 关联方编号
            ,unit_name -- 单位名称
            ,certificate_no_dg -- 对公证件号码1
            ,certificate_no_dg_t -- 对公证件号码2
            ,relation -- 担任职务或关联关系
            ,group_name -- 单位归属的企业集团全称
            ,shareholding_ratio -- 持股比例
            ,comments -- 备注
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,belong_org -- 归属机构
            ,mainten_org -- 维护机构
            ,organization -- 所属机构
            ,certificate_type_id_dg -- 对公证件类型1
            ,certificate_type_id_dg_t -- 对公证件类型2
            ,domestic_or_foreign_dg -- 境内外标志1
            ,domestic_or_foreign_dg_t -- 境内外标志2
            ,hold_related_type -- 股东或关联方类型
            ,hold_related_industry -- 股东或关联方所属行业
            ,hold_related_reg_address -- 股东或关联方注册地
            ,hold_related_rel_type -- 股东或关联方关系类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.related_id -- 关联方编号
    ,o.unit_name -- 单位名称
    ,o.certificate_no_dg -- 对公证件号码1
    ,o.certificate_no_dg_t -- 对公证件号码2
    ,o.relation -- 担任职务或关联关系
    ,o.group_name -- 单位归属的企业集团全称
    ,o.shareholding_ratio -- 持股比例
    ,o.comments -- 备注
    ,o.last_updated_stamp -- 最后更新时间
    ,o.last_updated_tx_stamp -- 最后更新事务时间
    ,o.created_stamp -- 创建时间
    ,o.created_tx_stamp -- 创建事务时间
    ,o.belong_org -- 归属机构
    ,o.mainten_org -- 维护机构
    ,o.organization -- 所属机构
    ,o.certificate_type_id_dg -- 对公证件类型1
    ,o.certificate_type_id_dg_t -- 对公证件类型2
    ,o.domestic_or_foreign_dg -- 境内外标志1
    ,o.domestic_or_foreign_dg_t -- 境内外标志2
    ,o.hold_related_type -- 股东或关联方类型
    ,o.hold_related_industry -- 股东或关联方所属行业
    ,o.hold_related_reg_address -- 股东或关联方注册地
    ,o.hold_related_rel_type -- 股东或关联方关系类型
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
from ${iol_schema}.rpss_related_unit_bk o
    left join ${iol_schema}.rpss_related_unit_op n
        on
            o.related_id = n.related_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rpss_related_unit_cl d
        on
            o.related_id = d.related_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rpss_related_unit;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rpss_related_unit') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rpss_related_unit drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rpss_related_unit add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rpss_related_unit exchange partition p_${batch_date} with table ${iol_schema}.rpss_related_unit_cl;
alter table ${iol_schema}.rpss_related_unit exchange partition p_20991231 with table ${iol_schema}.rpss_related_unit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rpss_related_unit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rpss_related_unit_op purge;
drop table ${iol_schema}.rpss_related_unit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rpss_related_unit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rpss_related_unit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
