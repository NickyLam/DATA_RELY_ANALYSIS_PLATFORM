/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_hi_psndoc_linkman
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
create table ${iol_schema}.nhrs_hi_psndoc_linkman_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_hi_psndoc_linkman
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psndoc_linkman_op purge;
drop table ${iol_schema}.nhrs_hi_psndoc_linkman_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_linkman_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psndoc_linkman where 0=1;

create table ${iol_schema}.nhrs_hi_psndoc_linkman_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psndoc_linkman where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psndoc_linkman_cl(
            creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,email -- 电子邮件
            ,fax -- 传真
            ,homephone -- 家庭电话
            ,ismain -- 是否主要联系人
            ,lastflag -- 最近记录标志
            ,linkaddr -- 联系地址
            ,linkman -- 联系人
            ,mobile -- 手机
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,officephone -- 办公电话
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 人员子表主键
            ,pk_psnorg -- 组织关系主键
            ,postalcode -- 邮政编码
            ,recordnum -- 记录序号
            ,relation -- 与联系人关系
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psndoc_linkman_op(
            creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,email -- 电子邮件
            ,fax -- 传真
            ,homephone -- 家庭电话
            ,ismain -- 是否主要联系人
            ,lastflag -- 最近记录标志
            ,linkaddr -- 联系地址
            ,linkman -- 联系人
            ,mobile -- 手机
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,officephone -- 办公电话
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 人员子表主键
            ,pk_psnorg -- 组织关系主键
            ,postalcode -- 邮政编码
            ,recordnum -- 记录序号
            ,relation -- 与联系人关系
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.dr, o.dr) as dr -- 备用DR
    ,nvl(n.email, o.email) as email -- 电子邮件
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.homephone, o.homephone) as homephone -- 家庭电话
    ,nvl(n.ismain, o.ismain) as ismain -- 是否主要联系人
    ,nvl(n.lastflag, o.lastflag) as lastflag -- 最近记录标志
    ,nvl(n.linkaddr, o.linkaddr) as linkaddr -- 联系地址
    ,nvl(n.linkman, o.linkman) as linkman -- 联系人
    ,nvl(n.mobile, o.mobile) as mobile -- 手机
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.officephone, o.officephone) as officephone -- 办公电话
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 所属组织
    ,nvl(n.pk_psndoc, o.pk_psndoc) as pk_psndoc -- 人员主键
    ,nvl(n.pk_psndoc_sub, o.pk_psndoc_sub) as pk_psndoc_sub -- 人员子表主键
    ,nvl(n.pk_psnorg, o.pk_psnorg) as pk_psnorg -- 组织关系主键
    ,nvl(n.postalcode, o.postalcode) as postalcode -- 邮政编码
    ,nvl(n.recordnum, o.recordnum) as recordnum -- 记录序号
    ,nvl(n.relation, o.relation) as relation -- 与联系人关系
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,case when
            n.pk_psndoc_sub is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_psndoc_sub is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_psndoc_sub is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_hi_psndoc_linkman_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_hi_psndoc_linkman where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_psndoc_sub = n.pk_psndoc_sub
where (
        o.pk_psndoc_sub is null
    )
    or (
        n.pk_psndoc_sub is null
    )
    or (
        o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dr <> n.dr
        or o.email <> n.email
        or o.fax <> n.fax
        or o.homephone <> n.homephone
        or o.ismain <> n.ismain
        or o.lastflag <> n.lastflag
        or o.linkaddr <> n.linkaddr
        or o.linkman <> n.linkman
        or o.mobile <> n.mobile
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.officephone <> n.officephone
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_psndoc <> n.pk_psndoc
        or o.pk_psnorg <> n.pk_psnorg
        or o.postalcode <> n.postalcode
        or o.recordnum <> n.recordnum
        or o.relation <> n.relation
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psndoc_linkman_cl(
            creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,email -- 电子邮件
            ,fax -- 传真
            ,homephone -- 家庭电话
            ,ismain -- 是否主要联系人
            ,lastflag -- 最近记录标志
            ,linkaddr -- 联系地址
            ,linkman -- 联系人
            ,mobile -- 手机
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,officephone -- 办公电话
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 人员子表主键
            ,pk_psnorg -- 组织关系主键
            ,postalcode -- 邮政编码
            ,recordnum -- 记录序号
            ,relation -- 与联系人关系
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psndoc_linkman_op(
            creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,email -- 电子邮件
            ,fax -- 传真
            ,homephone -- 家庭电话
            ,ismain -- 是否主要联系人
            ,lastflag -- 最近记录标志
            ,linkaddr -- 联系地址
            ,linkman -- 联系人
            ,mobile -- 手机
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,officephone -- 办公电话
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 人员子表主键
            ,pk_psnorg -- 组织关系主键
            ,postalcode -- 邮政编码
            ,recordnum -- 记录序号
            ,relation -- 与联系人关系
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.dr -- 备用DR
    ,o.email -- 电子邮件
    ,o.fax -- 传真
    ,o.homephone -- 家庭电话
    ,o.ismain -- 是否主要联系人
    ,o.lastflag -- 最近记录标志
    ,o.linkaddr -- 联系地址
    ,o.linkman -- 联系人
    ,o.mobile -- 手机
    ,o.modifiedtime -- 修改时间
    ,o.modifier -- 修改人
    ,o.officephone -- 办公电话
    ,o.pk_group -- 所属集团
    ,o.pk_org -- 所属组织
    ,o.pk_psndoc -- 人员主键
    ,o.pk_psndoc_sub -- 人员子表主键
    ,o.pk_psnorg -- 组织关系主键
    ,o.postalcode -- 邮政编码
    ,o.recordnum -- 记录序号
    ,o.relation -- 与联系人关系
    ,o.ts -- 时间戳
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
from ${iol_schema}.nhrs_hi_psndoc_linkman_bk o
    left join ${iol_schema}.nhrs_hi_psndoc_linkman_op n
        on
            o.pk_psndoc_sub = n.pk_psndoc_sub
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_hi_psndoc_linkman_cl d
        on
            o.pk_psndoc_sub = d.pk_psndoc_sub
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_hi_psndoc_linkman;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_hi_psndoc_linkman') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_hi_psndoc_linkman drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_hi_psndoc_linkman add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_hi_psndoc_linkman exchange partition p_${batch_date} with table ${iol_schema}.nhrs_hi_psndoc_linkman_cl;
alter table ${iol_schema}.nhrs_hi_psndoc_linkman exchange partition p_20991231 with table ${iol_schema}.nhrs_hi_psndoc_linkman_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_hi_psndoc_linkman to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psndoc_linkman_op purge;
drop table ${iol_schema}.nhrs_hi_psndoc_linkman_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_hi_psndoc_linkman_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_hi_psndoc_linkman',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
