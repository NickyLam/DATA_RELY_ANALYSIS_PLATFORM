/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_owner
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
create table ${iol_schema}.icms_clr_owner_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_owner
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_owner_op purge;
drop table ${iol_schema}.icms_clr_owner_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_owner_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_owner where 0=1;

create table ${iol_schema}.icms_clr_owner_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_owner where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_owner_cl(
            clrownerid -- 权属人编号
            ,clrid -- 押品编号
            ,ecifcustomerid -- ECIF客户号
            ,clrownername -- 权属人名称
            ,clrownertype -- 权属人类别
            ,clrownercerttype -- 权属人证件类型
            ,clrownercertid -- 权属人证件号码
            ,percentage -- 分摊比例
            ,relationship -- 权属人与借款人关系
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,corporgid -- 法人机构编号
            ,oldclrid -- 合并前押品编号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_owner_op(
            clrownerid -- 权属人编号
            ,clrid -- 押品编号
            ,ecifcustomerid -- ECIF客户号
            ,clrownername -- 权属人名称
            ,clrownertype -- 权属人类别
            ,clrownercerttype -- 权属人证件类型
            ,clrownercertid -- 权属人证件号码
            ,percentage -- 分摊比例
            ,relationship -- 权属人与借款人关系
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,corporgid -- 法人机构编号
            ,oldclrid -- 合并前押品编号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrownerid, o.clrownerid) as clrownerid -- 权属人编号
    ,nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.ecifcustomerid, o.ecifcustomerid) as ecifcustomerid -- ECIF客户号
    ,nvl(n.clrownername, o.clrownername) as clrownername -- 权属人名称
    ,nvl(n.clrownertype, o.clrownertype) as clrownertype -- 权属人类别
    ,nvl(n.clrownercerttype, o.clrownercerttype) as clrownercerttype -- 权属人证件类型
    ,nvl(n.clrownercertid, o.clrownercertid) as clrownercertid -- 权属人证件号码
    ,nvl(n.percentage, o.percentage) as percentage -- 分摊比例
    ,nvl(n.relationship, o.relationship) as relationship -- 权属人与借款人关系
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.oldclrid, o.oldclrid) as oldclrid -- 合并前押品编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,case when
            n.clrownerid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clrownerid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clrownerid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_owner_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_owner where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrownerid = n.clrownerid
where (
        o.clrownerid is null
    )
    or (
        n.clrownerid is null
    )
    or (
        o.clrid <> n.clrid
        or o.ecifcustomerid <> n.ecifcustomerid
        or o.clrownername <> n.clrownername
        or o.clrownertype <> n.clrownertype
        or o.clrownercerttype <> n.clrownercerttype
        or o.clrownercertid <> n.clrownercertid
        or o.percentage <> n.percentage
        or o.relationship <> n.relationship
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.corporgid <> n.corporgid
        or o.oldclrid <> n.oldclrid
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_owner_cl(
            clrownerid -- 权属人编号
            ,clrid -- 押品编号
            ,ecifcustomerid -- ECIF客户号
            ,clrownername -- 权属人名称
            ,clrownertype -- 权属人类别
            ,clrownercerttype -- 权属人证件类型
            ,clrownercertid -- 权属人证件号码
            ,percentage -- 分摊比例
            ,relationship -- 权属人与借款人关系
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,corporgid -- 法人机构编号
            ,oldclrid -- 合并前押品编号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_owner_op(
            clrownerid -- 权属人编号
            ,clrid -- 押品编号
            ,ecifcustomerid -- ECIF客户号
            ,clrownername -- 权属人名称
            ,clrownertype -- 权属人类别
            ,clrownercerttype -- 权属人证件类型
            ,clrownercertid -- 权属人证件号码
            ,percentage -- 分摊比例
            ,relationship -- 权属人与借款人关系
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,corporgid -- 法人机构编号
            ,oldclrid -- 合并前押品编号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrownerid -- 权属人编号
    ,o.clrid -- 押品编号
    ,o.ecifcustomerid -- ECIF客户号
    ,o.clrownername -- 权属人名称
    ,o.clrownertype -- 权属人类别
    ,o.clrownercerttype -- 权属人证件类型
    ,o.clrownercertid -- 权属人证件号码
    ,o.percentage -- 分摊比例
    ,o.relationship -- 权属人与借款人关系
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新时间
    ,o.corporgid -- 法人机构编号
    ,o.oldclrid -- 合并前押品编号
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
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
from ${iol_schema}.icms_clr_owner_bk o
    left join ${iol_schema}.icms_clr_owner_op n
        on
            o.clrownerid = n.clrownerid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_owner_cl d
        on
            o.clrownerid = d.clrownerid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_owner;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_owner') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_owner drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_owner add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_owner exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_owner_cl;
alter table ${iol_schema}.icms_clr_owner exchange partition p_20991231 with table ${iol_schema}.icms_clr_owner_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_owner to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_owner_op purge;
drop table ${iol_schema}.icms_clr_owner_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_owner_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_owner',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
