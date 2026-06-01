/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_menu_inf
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
create table ${iol_schema}.tbps_cpr_menu_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_menu_inf
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_menu_inf_op purge;
drop table ${iol_schema}.tbps_cpr_menu_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_menu_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_menu_inf where 0=1;

create table ${iol_schema}.tbps_cpr_menu_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_menu_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_menu_inf_cl(
            cmi_id -- 菜单ID
            ,cmi_name -- 菜单名称
            ,cmi_channel -- 渠道(TBP：仅交易银行门户 EBK：仅网上银行 OGW：合作商户 ALL：全部)
            ,cmi_authenabled -- 是否允许授权
            ,cmi_state -- 功能状态
            ,cmi_type -- 功能类型(0：查询统计类 1：经办类功能 2：管理功能)
            ,cmi_authtype -- 授权类型(0：即时生效 1：互为授权 2：指定授权)
            ,cmi_authmode -- 授权形式(0：审核式 1：临柜)
            ,cmi_router -- 菜单路由
            ,cmi_showtype -- 展示方式
            ,cmi_only -- 是否仅限制菜单(默认：0 1：是)
            ,cmi_actions -- 菜单有权限的请求
            ,cmi_trancode -- 交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_menu_inf_op(
            cmi_id -- 菜单ID
            ,cmi_name -- 菜单名称
            ,cmi_channel -- 渠道(TBP：仅交易银行门户 EBK：仅网上银行 OGW：合作商户 ALL：全部)
            ,cmi_authenabled -- 是否允许授权
            ,cmi_state -- 功能状态
            ,cmi_type -- 功能类型(0：查询统计类 1：经办类功能 2：管理功能)
            ,cmi_authtype -- 授权类型(0：即时生效 1：互为授权 2：指定授权)
            ,cmi_authmode -- 授权形式(0：审核式 1：临柜)
            ,cmi_router -- 菜单路由
            ,cmi_showtype -- 展示方式
            ,cmi_only -- 是否仅限制菜单(默认：0 1：是)
            ,cmi_actions -- 菜单有权限的请求
            ,cmi_trancode -- 交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cmi_id, o.cmi_id) as cmi_id -- 菜单ID
    ,nvl(n.cmi_name, o.cmi_name) as cmi_name -- 菜单名称
    ,nvl(n.cmi_channel, o.cmi_channel) as cmi_channel -- 渠道(TBP：仅交易银行门户 EBK：仅网上银行 OGW：合作商户 ALL：全部)
    ,nvl(n.cmi_authenabled, o.cmi_authenabled) as cmi_authenabled -- 是否允许授权
    ,nvl(n.cmi_state, o.cmi_state) as cmi_state -- 功能状态
    ,nvl(n.cmi_type, o.cmi_type) as cmi_type -- 功能类型(0：查询统计类 1：经办类功能 2：管理功能)
    ,nvl(n.cmi_authtype, o.cmi_authtype) as cmi_authtype -- 授权类型(0：即时生效 1：互为授权 2：指定授权)
    ,nvl(n.cmi_authmode, o.cmi_authmode) as cmi_authmode -- 授权形式(0：审核式 1：临柜)
    ,nvl(n.cmi_router, o.cmi_router) as cmi_router -- 菜单路由
    ,nvl(n.cmi_showtype, o.cmi_showtype) as cmi_showtype -- 展示方式
    ,nvl(n.cmi_only, o.cmi_only) as cmi_only -- 是否仅限制菜单(默认：0 1：是)
    ,nvl(n.cmi_actions, o.cmi_actions) as cmi_actions -- 菜单有权限的请求
    ,nvl(n.cmi_trancode, o.cmi_trancode) as cmi_trancode -- 交易类型
    ,case when
            n.cmi_id is null
            and n.cmi_channel is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cmi_id is null
            and n.cmi_channel is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cmi_id is null
            and n.cmi_channel is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_menu_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_menu_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cmi_id = n.cmi_id
            and o.cmi_channel = n.cmi_channel
where (
        o.cmi_id is null
        and o.cmi_channel is null
    )
    or (
        n.cmi_id is null
        and n.cmi_channel is null
    )
    or (
        o.cmi_name <> n.cmi_name
        or o.cmi_authenabled <> n.cmi_authenabled
        or o.cmi_state <> n.cmi_state
        or o.cmi_type <> n.cmi_type
        or o.cmi_authtype <> n.cmi_authtype
        or o.cmi_authmode <> n.cmi_authmode
        or o.cmi_router <> n.cmi_router
        or o.cmi_showtype <> n.cmi_showtype
        or o.cmi_only <> n.cmi_only
        or o.cmi_actions <> n.cmi_actions
        or o.cmi_trancode <> n.cmi_trancode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_menu_inf_cl(
            cmi_id -- 菜单ID
            ,cmi_name -- 菜单名称
            ,cmi_channel -- 渠道(TBP：仅交易银行门户 EBK：仅网上银行 OGW：合作商户 ALL：全部)
            ,cmi_authenabled -- 是否允许授权
            ,cmi_state -- 功能状态
            ,cmi_type -- 功能类型(0：查询统计类 1：经办类功能 2：管理功能)
            ,cmi_authtype -- 授权类型(0：即时生效 1：互为授权 2：指定授权)
            ,cmi_authmode -- 授权形式(0：审核式 1：临柜)
            ,cmi_router -- 菜单路由
            ,cmi_showtype -- 展示方式
            ,cmi_only -- 是否仅限制菜单(默认：0 1：是)
            ,cmi_actions -- 菜单有权限的请求
            ,cmi_trancode -- 交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_menu_inf_op(
            cmi_id -- 菜单ID
            ,cmi_name -- 菜单名称
            ,cmi_channel -- 渠道(TBP：仅交易银行门户 EBK：仅网上银行 OGW：合作商户 ALL：全部)
            ,cmi_authenabled -- 是否允许授权
            ,cmi_state -- 功能状态
            ,cmi_type -- 功能类型(0：查询统计类 1：经办类功能 2：管理功能)
            ,cmi_authtype -- 授权类型(0：即时生效 1：互为授权 2：指定授权)
            ,cmi_authmode -- 授权形式(0：审核式 1：临柜)
            ,cmi_router -- 菜单路由
            ,cmi_showtype -- 展示方式
            ,cmi_only -- 是否仅限制菜单(默认：0 1：是)
            ,cmi_actions -- 菜单有权限的请求
            ,cmi_trancode -- 交易类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cmi_id -- 菜单ID
    ,o.cmi_name -- 菜单名称
    ,o.cmi_channel -- 渠道(TBP：仅交易银行门户 EBK：仅网上银行 OGW：合作商户 ALL：全部)
    ,o.cmi_authenabled -- 是否允许授权
    ,o.cmi_state -- 功能状态
    ,o.cmi_type -- 功能类型(0：查询统计类 1：经办类功能 2：管理功能)
    ,o.cmi_authtype -- 授权类型(0：即时生效 1：互为授权 2：指定授权)
    ,o.cmi_authmode -- 授权形式(0：审核式 1：临柜)
    ,o.cmi_router -- 菜单路由
    ,o.cmi_showtype -- 展示方式
    ,o.cmi_only -- 是否仅限制菜单(默认：0 1：是)
    ,o.cmi_actions -- 菜单有权限的请求
    ,o.cmi_trancode -- 交易类型
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
from ${iol_schema}.tbps_cpr_menu_inf_bk o
    left join ${iol_schema}.tbps_cpr_menu_inf_op n
        on
            o.cmi_id = n.cmi_id
            and o.cmi_channel = n.cmi_channel
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_menu_inf_cl d
        on
            o.cmi_id = d.cmi_id
            and o.cmi_channel = d.cmi_channel
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tbps_cpr_menu_inf;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tbps_cpr_menu_inf') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tbps_cpr_menu_inf drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tbps_cpr_menu_inf add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tbps_cpr_menu_inf exchange partition p_${batch_date} with table ${iol_schema}.tbps_cpr_menu_inf_cl;
alter table ${iol_schema}.tbps_cpr_menu_inf exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_menu_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_menu_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_menu_inf_op purge;
drop table ${iol_schema}.tbps_cpr_menu_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_menu_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_menu_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
