/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_upl_corp_relative
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
create table ${iol_schema}.icms_upl_corp_relative_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_upl_corp_relative
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_upl_corp_relative_op purge;
drop table ${iol_schema}.icms_upl_corp_relative_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_upl_corp_relative_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_upl_corp_relative where 0=1;

create table ${iol_schema}.icms_upl_corp_relative_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_upl_corp_relative where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_upl_corp_relative_cl(
            orgid -- 合作公司编码
            ,orgname -- 合作公司名称
            ,belongorg -- 所属机构
            ,updatedate -- 更新日期
            ,inputorg -- 录入机构
            ,inputdate -- 录入日期
            ,migtflag -- 
            ,status -- 是否有效
            ,inputuser -- 录入人
            ,updateuser -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_upl_corp_relative_op(
            orgid -- 合作公司编码
            ,orgname -- 合作公司名称
            ,belongorg -- 所属机构
            ,updatedate -- 更新日期
            ,inputorg -- 录入机构
            ,inputdate -- 录入日期
            ,migtflag -- 
            ,status -- 是否有效
            ,inputuser -- 录入人
            ,updateuser -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.orgid, o.orgid) as orgid -- 合作公司编码
    ,nvl(n.orgname, o.orgname) as orgname -- 合作公司名称
    ,nvl(n.belongorg, o.belongorg) as belongorg -- 所属机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 录入机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 录入日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.status, o.status) as status -- 是否有效
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 录入人
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新人
    ,case when
            n.orgid is null
            and n.orgname is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.orgid is null
            and n.orgname is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.orgid is null
            and n.orgname is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_upl_corp_relative_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_upl_corp_relative where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.orgid = n.orgid
            and o.orgname = n.orgname
where (
        o.orgid is null
        and o.orgname is null
    )
    or (
        n.orgid is null
        and n.orgname is null
    )
    or (
        o.belongorg <> n.belongorg
        or o.updatedate <> n.updatedate
        or o.inputorg <> n.inputorg
        or o.inputdate <> n.inputdate
        or o.migtflag <> n.migtflag
        or o.status <> n.status
        or o.inputuser <> n.inputuser
        or o.updateuser <> n.updateuser
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_upl_corp_relative_cl(
            orgid -- 合作公司编码
            ,orgname -- 合作公司名称
            ,belongorg -- 所属机构
            ,updatedate -- 更新日期
            ,inputorg -- 录入机构
            ,inputdate -- 录入日期
            ,migtflag -- 
            ,status -- 是否有效
            ,inputuser -- 录入人
            ,updateuser -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_upl_corp_relative_op(
            orgid -- 合作公司编码
            ,orgname -- 合作公司名称
            ,belongorg -- 所属机构
            ,updatedate -- 更新日期
            ,inputorg -- 录入机构
            ,inputdate -- 录入日期
            ,migtflag -- 
            ,status -- 是否有效
            ,inputuser -- 录入人
            ,updateuser -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.orgid -- 合作公司编码
    ,o.orgname -- 合作公司名称
    ,o.belongorg -- 所属机构
    ,o.updatedate -- 更新日期
    ,o.inputorg -- 录入机构
    ,o.inputdate -- 录入日期
    ,o.migtflag -- 
    ,o.status -- 是否有效
    ,o.inputuser -- 录入人
    ,o.updateuser -- 更新人
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
from ${iol_schema}.icms_upl_corp_relative_bk o
    left join ${iol_schema}.icms_upl_corp_relative_op n
        on
            o.orgid = n.orgid
            and o.orgname = n.orgname
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_upl_corp_relative_cl d
        on
            o.orgid = d.orgid
            and o.orgname = d.orgname
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_upl_corp_relative;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_upl_corp_relative') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_upl_corp_relative drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_upl_corp_relative add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_upl_corp_relative exchange partition p_${batch_date} with table ${iol_schema}.icms_upl_corp_relative_cl;
alter table ${iol_schema}.icms_upl_corp_relative exchange partition p_20991231 with table ${iol_schema}.icms_upl_corp_relative_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_upl_corp_relative to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_upl_corp_relative_op purge;
drop table ${iol_schema}.icms_upl_corp_relative_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_upl_corp_relative_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_upl_corp_relative',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
