/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_hi_psndoc_family
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
create table ${iol_schema}.nhrs_hi_psndoc_family_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_hi_psndoc_family
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psndoc_family_op purge;
drop table ${iol_schema}.nhrs_hi_psndoc_family_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_family_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psndoc_family where 0=1;

create table ${iol_schema}.nhrs_hi_psndoc_family_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_hi_psndoc_family where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psndoc_family_cl(
            approveflag -- 审批标志
            ,begindate -- 起始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 终止日期
            ,lastflag -- 最近记录标志
            ,mem_birthday -- 出生日期
            ,mem_corp -- 工作单位
            ,mem_job -- 职务
            ,mem_name -- 家庭成员姓名
            ,mem_relation -- 与本人关系
            ,memo -- 备注
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,period -- 期间
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 人员子表主键
            ,politics -- 政治面貌
            ,profession -- 职业
            ,recordnum -- 记录序号
            ,relaaddr -- 联系地址
            ,relaphone -- 联系电话
            ,ts -- 时间戳
            ,glbdef1 -- 性别
            ,glbdef2 -- 状态
            ,glbdef3 -- 备用GLBDEF3
            ,glbdef4 -- 学校/工作单位及职务
            ,glbdef5 -- 户籍所在地
            ,glbdef7 -- 备用GLBDEF7
            ,glbdef8 -- 学历及学位
            ,glbdef6 -- 证件号码
            ,glbdef9 -- 备用GLBDEF9
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psndoc_family_op(
            approveflag -- 审批标志
            ,begindate -- 起始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 终止日期
            ,lastflag -- 最近记录标志
            ,mem_birthday -- 出生日期
            ,mem_corp -- 工作单位
            ,mem_job -- 职务
            ,mem_name -- 家庭成员姓名
            ,mem_relation -- 与本人关系
            ,memo -- 备注
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,period -- 期间
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 人员子表主键
            ,politics -- 政治面貌
            ,profession -- 职业
            ,recordnum -- 记录序号
            ,relaaddr -- 联系地址
            ,relaphone -- 联系电话
            ,ts -- 时间戳
            ,glbdef1 -- 性别
            ,glbdef2 -- 状态
            ,glbdef3 -- 备用GLBDEF3
            ,glbdef4 -- 学校/工作单位及职务
            ,glbdef5 -- 户籍所在地
            ,glbdef7 -- 备用GLBDEF7
            ,glbdef8 -- 学历及学位
            ,glbdef6 -- 证件号码
            ,glbdef9 -- 备用GLBDEF9
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.approveflag, o.approveflag) as approveflag -- 审批标志
    ,nvl(n.begindate, o.begindate) as begindate -- 起始日期
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.dr, o.dr) as dr -- 备用DR
    ,nvl(n.enddate, o.enddate) as enddate -- 终止日期
    ,nvl(n.lastflag, o.lastflag) as lastflag -- 最近记录标志
    ,nvl(n.mem_birthday, o.mem_birthday) as mem_birthday -- 出生日期
    ,nvl(n.mem_corp, o.mem_corp) as mem_corp -- 工作单位
    ,nvl(n.mem_job, o.mem_job) as mem_job -- 职务
    ,nvl(n.mem_name, o.mem_name) as mem_name -- 家庭成员姓名
    ,nvl(n.mem_relation, o.mem_relation) as mem_relation -- 与本人关系
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.period, o.period) as period -- 期间
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 所属组织
    ,nvl(n.pk_psndoc, o.pk_psndoc) as pk_psndoc -- 人员主键
    ,nvl(n.pk_psndoc_sub, o.pk_psndoc_sub) as pk_psndoc_sub -- 人员子表主键
    ,nvl(n.politics, o.politics) as politics -- 政治面貌
    ,nvl(n.profession, o.profession) as profession -- 职业
    ,nvl(n.recordnum, o.recordnum) as recordnum -- 记录序号
    ,nvl(n.relaaddr, o.relaaddr) as relaaddr -- 联系地址
    ,nvl(n.relaphone, o.relaphone) as relaphone -- 联系电话
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.glbdef1, o.glbdef1) as glbdef1 -- 性别
    ,nvl(n.glbdef2, o.glbdef2) as glbdef2 -- 状态
    ,nvl(n.glbdef3, o.glbdef3) as glbdef3 -- 备用GLBDEF3
    ,nvl(n.glbdef4, o.glbdef4) as glbdef4 -- 学校/工作单位及职务
    ,nvl(n.glbdef5, o.glbdef5) as glbdef5 -- 户籍所在地
    ,nvl(n.glbdef7, o.glbdef7) as glbdef7 -- 备用GLBDEF7
    ,nvl(n.glbdef8, o.glbdef8) as glbdef8 -- 学历及学位
    ,nvl(n.glbdef6, o.glbdef6) as glbdef6 -- 证件号码
    ,nvl(n.glbdef9, o.glbdef9) as glbdef9 -- 备用GLBDEF9
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
from (select * from ${iol_schema}.nhrs_hi_psndoc_family_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_hi_psndoc_family where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_psndoc_sub = n.pk_psndoc_sub
where (
        o.pk_psndoc_sub is null
    )
    or (
        n.pk_psndoc_sub is null
    )
    or (
        o.approveflag <> n.approveflag
        or o.begindate <> n.begindate
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.dr <> n.dr
        or o.enddate <> n.enddate
        or o.lastflag <> n.lastflag
        or o.mem_birthday <> n.mem_birthday
        or o.mem_corp <> n.mem_corp
        or o.mem_job <> n.mem_job
        or o.mem_name <> n.mem_name
        or o.mem_relation <> n.mem_relation
        or o.memo <> n.memo
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.period <> n.period
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_psndoc <> n.pk_psndoc
        or o.politics <> n.politics
        or o.profession <> n.profession
        or o.recordnum <> n.recordnum
        or o.relaaddr <> n.relaaddr
        or o.relaphone <> n.relaphone
        or o.ts <> n.ts
        or o.glbdef1 <> n.glbdef1
        or o.glbdef2 <> n.glbdef2
        or o.glbdef3 <> n.glbdef3
        or o.glbdef4 <> n.glbdef4
        or o.glbdef5 <> n.glbdef5
        or o.glbdef7 <> n.glbdef7
        or o.glbdef8 <> n.glbdef8
        or o.glbdef6 <> n.glbdef6
        or o.glbdef9 <> n.glbdef9
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_hi_psndoc_family_cl(
            approveflag -- 审批标志
            ,begindate -- 起始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 终止日期
            ,lastflag -- 最近记录标志
            ,mem_birthday -- 出生日期
            ,mem_corp -- 工作单位
            ,mem_job -- 职务
            ,mem_name -- 家庭成员姓名
            ,mem_relation -- 与本人关系
            ,memo -- 备注
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,period -- 期间
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 人员子表主键
            ,politics -- 政治面貌
            ,profession -- 职业
            ,recordnum -- 记录序号
            ,relaaddr -- 联系地址
            ,relaphone -- 联系电话
            ,ts -- 时间戳
            ,glbdef1 -- 性别
            ,glbdef2 -- 状态
            ,glbdef3 -- 备用GLBDEF3
            ,glbdef4 -- 学校/工作单位及职务
            ,glbdef5 -- 户籍所在地
            ,glbdef7 -- 备用GLBDEF7
            ,glbdef8 -- 学历及学位
            ,glbdef6 -- 证件号码
            ,glbdef9 -- 备用GLBDEF9
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_hi_psndoc_family_op(
            approveflag -- 审批标志
            ,begindate -- 起始日期
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,dr -- 备用DR
            ,enddate -- 终止日期
            ,lastflag -- 最近记录标志
            ,mem_birthday -- 出生日期
            ,mem_corp -- 工作单位
            ,mem_job -- 职务
            ,mem_name -- 家庭成员姓名
            ,mem_relation -- 与本人关系
            ,memo -- 备注
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,period -- 期间
            ,pk_group -- 所属集团
            ,pk_org -- 所属组织
            ,pk_psndoc -- 人员主键
            ,pk_psndoc_sub -- 人员子表主键
            ,politics -- 政治面貌
            ,profession -- 职业
            ,recordnum -- 记录序号
            ,relaaddr -- 联系地址
            ,relaphone -- 联系电话
            ,ts -- 时间戳
            ,glbdef1 -- 性别
            ,glbdef2 -- 状态
            ,glbdef3 -- 备用GLBDEF3
            ,glbdef4 -- 学校/工作单位及职务
            ,glbdef5 -- 户籍所在地
            ,glbdef7 -- 备用GLBDEF7
            ,glbdef8 -- 学历及学位
            ,glbdef6 -- 证件号码
            ,glbdef9 -- 备用GLBDEF9
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.approveflag -- 审批标志
    ,o.begindate -- 起始日期
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.dr -- 备用DR
    ,o.enddate -- 终止日期
    ,o.lastflag -- 最近记录标志
    ,o.mem_birthday -- 出生日期
    ,o.mem_corp -- 工作单位
    ,o.mem_job -- 职务
    ,o.mem_name -- 家庭成员姓名
    ,o.mem_relation -- 与本人关系
    ,o.memo -- 备注
    ,o.modifiedtime -- 修改时间
    ,o.modifier -- 修改人
    ,o.period -- 期间
    ,o.pk_group -- 所属集团
    ,o.pk_org -- 所属组织
    ,o.pk_psndoc -- 人员主键
    ,o.pk_psndoc_sub -- 人员子表主键
    ,o.politics -- 政治面貌
    ,o.profession -- 职业
    ,o.recordnum -- 记录序号
    ,o.relaaddr -- 联系地址
    ,o.relaphone -- 联系电话
    ,o.ts -- 时间戳
    ,o.glbdef1 -- 性别
    ,o.glbdef2 -- 状态
    ,o.glbdef3 -- 备用GLBDEF3
    ,o.glbdef4 -- 学校/工作单位及职务
    ,o.glbdef5 -- 户籍所在地
    ,o.glbdef7 -- 备用GLBDEF7
    ,o.glbdef8 -- 学历及学位
    ,o.glbdef6 -- 证件号码
    ,o.glbdef9 -- 备用GLBDEF9
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
from ${iol_schema}.nhrs_hi_psndoc_family_bk o
    left join ${iol_schema}.nhrs_hi_psndoc_family_op n
        on
            o.pk_psndoc_sub = n.pk_psndoc_sub
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_hi_psndoc_family_cl d
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
--truncate table ${iol_schema}.nhrs_hi_psndoc_family;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_hi_psndoc_family') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_hi_psndoc_family drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_hi_psndoc_family add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_hi_psndoc_family exchange partition p_${batch_date} with table ${iol_schema}.nhrs_hi_psndoc_family_cl;
alter table ${iol_schema}.nhrs_hi_psndoc_family exchange partition p_20991231 with table ${iol_schema}.nhrs_hi_psndoc_family_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_hi_psndoc_family to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_hi_psndoc_family_op purge;
drop table ${iol_schema}.nhrs_hi_psndoc_family_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_hi_psndoc_family_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_hi_psndoc_family',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
