/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_pbs_wx_tourist_info
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
create table ${iol_schema}.osbs_pbs_wx_tourist_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_pbs_wx_tourist_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_wx_tourist_info_op purge;
drop table ${iol_schema}.osbs_pbs_wx_tourist_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_wx_tourist_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_wx_tourist_info where 0=1;

create table ${iol_schema}.osbs_pbs_wx_tourist_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_wx_tourist_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_pbs_wx_tourist_info_cl(
            pwt_unionid -- 微信UNIONID
            ,pwt_openid -- 微信OPENID
            ,pwt_phone -- 手机号
            ,pwt_name -- 客户姓名
            ,pwt_certnum -- 证件号
            ,pwt_chanel -- 来源渠道
            ,pwt_sellsmscontract -- 是否同意接收营销信息短信
            ,pwt_date -- 注册时间
            ,pwt_status -- 状态（0-有效,1-失效）
            ,pwt_tourist_id -- 游客ID
            ,pwt_branchid -- 机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_pbs_wx_tourist_info_op(
            pwt_unionid -- 微信UNIONID
            ,pwt_openid -- 微信OPENID
            ,pwt_phone -- 手机号
            ,pwt_name -- 客户姓名
            ,pwt_certnum -- 证件号
            ,pwt_chanel -- 来源渠道
            ,pwt_sellsmscontract -- 是否同意接收营销信息短信
            ,pwt_date -- 注册时间
            ,pwt_status -- 状态（0-有效,1-失效）
            ,pwt_tourist_id -- 游客ID
            ,pwt_branchid -- 机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pwt_unionid, o.pwt_unionid) as pwt_unionid -- 微信UNIONID
    ,nvl(n.pwt_openid, o.pwt_openid) as pwt_openid -- 微信OPENID
    ,nvl(n.pwt_phone, o.pwt_phone) as pwt_phone -- 手机号
    ,nvl(n.pwt_name, o.pwt_name) as pwt_name -- 客户姓名
    ,nvl(n.pwt_certnum, o.pwt_certnum) as pwt_certnum -- 证件号
    ,nvl(n.pwt_chanel, o.pwt_chanel) as pwt_chanel -- 来源渠道
    ,nvl(n.pwt_sellsmscontract, o.pwt_sellsmscontract) as pwt_sellsmscontract -- 是否同意接收营销信息短信
    ,nvl(n.pwt_date, o.pwt_date) as pwt_date -- 注册时间
    ,nvl(n.pwt_status, o.pwt_status) as pwt_status -- 状态（0-有效,1-失效）
    ,nvl(n.pwt_tourist_id, o.pwt_tourist_id) as pwt_tourist_id -- 游客ID
    ,nvl(n.pwt_branchid, o.pwt_branchid) as pwt_branchid -- 机构号
    ,case when
            n.pwt_phone is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pwt_phone is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pwt_phone is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_pbs_wx_tourist_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_pbs_wx_tourist_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pwt_phone = n.pwt_phone
where (
        o.pwt_phone is null
    )
    or (
        n.pwt_phone is null
    )
    or (
        o.pwt_unionid <> n.pwt_unionid
        or o.pwt_openid <> n.pwt_openid
        or o.pwt_name <> n.pwt_name
        or o.pwt_certnum <> n.pwt_certnum
        or o.pwt_chanel <> n.pwt_chanel
        or o.pwt_sellsmscontract <> n.pwt_sellsmscontract
        or o.pwt_date <> n.pwt_date
        or o.pwt_status <> n.pwt_status
        or o.pwt_tourist_id <> n.pwt_tourist_id
        or o.pwt_branchid <> n.pwt_branchid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_pbs_wx_tourist_info_cl(
            pwt_unionid -- 微信UNIONID
            ,pwt_openid -- 微信OPENID
            ,pwt_phone -- 手机号
            ,pwt_name -- 客户姓名
            ,pwt_certnum -- 证件号
            ,pwt_chanel -- 来源渠道
            ,pwt_sellsmscontract -- 是否同意接收营销信息短信
            ,pwt_date -- 注册时间
            ,pwt_status -- 状态（0-有效,1-失效）
            ,pwt_tourist_id -- 游客ID
            ,pwt_branchid -- 机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_pbs_wx_tourist_info_op(
            pwt_unionid -- 微信UNIONID
            ,pwt_openid -- 微信OPENID
            ,pwt_phone -- 手机号
            ,pwt_name -- 客户姓名
            ,pwt_certnum -- 证件号
            ,pwt_chanel -- 来源渠道
            ,pwt_sellsmscontract -- 是否同意接收营销信息短信
            ,pwt_date -- 注册时间
            ,pwt_status -- 状态（0-有效,1-失效）
            ,pwt_tourist_id -- 游客ID
            ,pwt_branchid -- 机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pwt_unionid -- 微信UNIONID
    ,o.pwt_openid -- 微信OPENID
    ,o.pwt_phone -- 手机号
    ,o.pwt_name -- 客户姓名
    ,o.pwt_certnum -- 证件号
    ,o.pwt_chanel -- 来源渠道
    ,o.pwt_sellsmscontract -- 是否同意接收营销信息短信
    ,o.pwt_date -- 注册时间
    ,o.pwt_status -- 状态（0-有效,1-失效）
    ,o.pwt_tourist_id -- 游客ID
    ,o.pwt_branchid -- 机构号
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
from ${iol_schema}.osbs_pbs_wx_tourist_info_bk o
    left join ${iol_schema}.osbs_pbs_wx_tourist_info_op n
        on
            o.pwt_phone = n.pwt_phone
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_pbs_wx_tourist_info_cl d
        on
            o.pwt_phone = d.pwt_phone
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.osbs_pbs_wx_tourist_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('osbs_pbs_wx_tourist_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.osbs_pbs_wx_tourist_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.osbs_pbs_wx_tourist_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.osbs_pbs_wx_tourist_info exchange partition p_${batch_date} with table ${iol_schema}.osbs_pbs_wx_tourist_info_cl;
alter table ${iol_schema}.osbs_pbs_wx_tourist_info exchange partition p_20991231 with table ${iol_schema}.osbs_pbs_wx_tourist_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_pbs_wx_tourist_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_wx_tourist_info_op purge;
drop table ${iol_schema}.osbs_pbs_wx_tourist_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_pbs_wx_tourist_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_pbs_wx_tourist_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
