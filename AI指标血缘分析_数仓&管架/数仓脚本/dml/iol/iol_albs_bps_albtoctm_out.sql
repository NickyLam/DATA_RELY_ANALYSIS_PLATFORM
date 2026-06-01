/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_albs_bps_albtoctm_out
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
create table ${iol_schema}.albs_bps_albtoctm_out_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.albs_bps_albtoctm_out
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.albs_bps_albtoctm_out_op purge;
drop table ${iol_schema}.albs_bps_albtoctm_out_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.albs_bps_albtoctm_out_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.albs_bps_albtoctm_out where 0=1;

create table ${iol_schema}.albs_bps_albtoctm_out_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.albs_bps_albtoctm_out where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.albs_bps_albtoctm_out_cl(
            black_id -- 名单表id
            ,source_program -- 黑名单来源明细
            ,is_china_limit -- 是否属于中国制裁1：是0：否
            ,bla_type -- 名单类型 1：个体 2：组织或实体
            ,source_desc -- 黑名单来源类型
            ,blacklist_type -- 黑名单归属类型
            ,gender -- 性别1：男2：女0：NONE（空）
            ,bla_identity -- 黑名单证件
            ,bla_name -- 黑名单名称
            ,input_type -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单
            ,active_date -- 启用日期
            ,original_id -- 黑名单第三方原始ID
            ,bla_type_detail -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织
            ,id -- 主键ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.albs_bps_albtoctm_out_op(
            black_id -- 名单表id
            ,source_program -- 黑名单来源明细
            ,is_china_limit -- 是否属于中国制裁1：是0：否
            ,bla_type -- 名单类型 1：个体 2：组织或实体
            ,source_desc -- 黑名单来源类型
            ,blacklist_type -- 黑名单归属类型
            ,gender -- 性别1：男2：女0：NONE（空）
            ,bla_identity -- 黑名单证件
            ,bla_name -- 黑名单名称
            ,input_type -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单
            ,active_date -- 启用日期
            ,original_id -- 黑名单第三方原始ID
            ,bla_type_detail -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织
            ,id -- 主键ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.black_id, o.black_id) as black_id -- 名单表id
    ,nvl(n.source_program, o.source_program) as source_program -- 黑名单来源明细
    ,nvl(n.is_china_limit, o.is_china_limit) as is_china_limit -- 是否属于中国制裁1：是0：否
    ,nvl(n.bla_type, o.bla_type) as bla_type -- 名单类型 1：个体 2：组织或实体
    ,nvl(n.source_desc, o.source_desc) as source_desc -- 黑名单来源类型
    ,nvl(n.blacklist_type, o.blacklist_type) as blacklist_type -- 黑名单归属类型
    ,nvl(n.gender, o.gender) as gender -- 性别1：男2：女0：NONE（空）
    ,nvl(n.bla_identity, o.bla_identity) as bla_identity -- 黑名单证件
    ,nvl(n.bla_name, o.bla_name) as bla_name -- 黑名单名称
    ,nvl(n.input_type, o.input_type) as input_type -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单
    ,nvl(n.active_date, o.active_date) as active_date -- 启用日期
    ,nvl(n.original_id, o.original_id) as original_id -- 黑名单第三方原始ID
    ,nvl(n.bla_type_detail, o.bla_type_detail) as bla_type_detail -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织
    ,nvl(n.id, o.id) as id -- 主键ID
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.albs_bps_albtoctm_out_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.albs_bps_albtoctm_out where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.black_id <> n.black_id
        or o.source_program <> n.source_program
        or o.is_china_limit <> n.is_china_limit
        or o.bla_type <> n.bla_type
        or o.source_desc <> n.source_desc
        or o.blacklist_type <> n.blacklist_type
        or o.gender <> n.gender
        or o.bla_identity <> n.bla_identity
        or o.bla_name <> n.bla_name
        or o.input_type <> n.input_type
        or o.active_date <> n.active_date
        or o.original_id <> n.original_id
        or o.bla_type_detail <> n.bla_type_detail
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.albs_bps_albtoctm_out_cl(
            black_id -- 名单表id
            ,source_program -- 黑名单来源明细
            ,is_china_limit -- 是否属于中国制裁1：是0：否
            ,bla_type -- 名单类型 1：个体 2：组织或实体
            ,source_desc -- 黑名单来源类型
            ,blacklist_type -- 黑名单归属类型
            ,gender -- 性别1：男2：女0：NONE（空）
            ,bla_identity -- 黑名单证件
            ,bla_name -- 黑名单名称
            ,input_type -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单
            ,active_date -- 启用日期
            ,original_id -- 黑名单第三方原始ID
            ,bla_type_detail -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织
            ,id -- 主键ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.albs_bps_albtoctm_out_op(
            black_id -- 名单表id
            ,source_program -- 黑名单来源明细
            ,is_china_limit -- 是否属于中国制裁1：是0：否
            ,bla_type -- 名单类型 1：个体 2：组织或实体
            ,source_desc -- 黑名单来源类型
            ,blacklist_type -- 黑名单归属类型
            ,gender -- 性别1：男2：女0：NONE（空）
            ,bla_identity -- 黑名单证件
            ,bla_name -- 黑名单名称
            ,input_type -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单
            ,active_date -- 启用日期
            ,original_id -- 黑名单第三方原始ID
            ,bla_type_detail -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织
            ,id -- 主键ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.black_id -- 名单表id
    ,o.source_program -- 黑名单来源明细
    ,o.is_china_limit -- 是否属于中国制裁1：是0：否
    ,o.bla_type -- 名单类型 1：个体 2：组织或实体
    ,o.source_desc -- 黑名单来源类型
    ,o.blacklist_type -- 黑名单归属类型
    ,o.gender -- 性别1：男2：女0：NONE（空）
    ,o.bla_identity -- 黑名单证件
    ,o.bla_name -- 黑名单名称
    ,o.input_type -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单
    ,o.active_date -- 启用日期
    ,o.original_id -- 黑名单第三方原始ID
    ,o.bla_type_detail -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织
    ,o.id -- 主键ID
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
from ${iol_schema}.albs_bps_albtoctm_out_bk o
    left join ${iol_schema}.albs_bps_albtoctm_out_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.albs_bps_albtoctm_out_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.albs_bps_albtoctm_out;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('albs_bps_albtoctm_out') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.albs_bps_albtoctm_out drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.albs_bps_albtoctm_out add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.albs_bps_albtoctm_out exchange partition p_${batch_date} with table ${iol_schema}.albs_bps_albtoctm_out_cl;
alter table ${iol_schema}.albs_bps_albtoctm_out exchange partition p_20991231 with table ${iol_schema}.albs_bps_albtoctm_out_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.albs_bps_albtoctm_out to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.albs_bps_albtoctm_out_op purge;
drop table ${iol_schema}.albs_bps_albtoctm_out_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.albs_bps_albtoctm_out_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'albs_bps_albtoctm_out',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
