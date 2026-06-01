/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_git
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
create table ${iol_schema}.isbs_git_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_git
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_git_op purge;
drop table ${iol_schema}.isbs_git_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_git_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_git where 0=1;

create table ${iol_schema}.isbs_git_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_git where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_git_cl(
            inr -- 进口信用证ID号
            ,ver -- 版本号
            ,covgodsrv -- 遮盖物
            ,gidtxt -- 保函文本
            ,gtxgidtxt -- 保函文本显示规则
            ,gidtxtame -- 改正历史
            ,orcplc -- 初始交易地点
            ,addinf -- 附加信息
            ,revtxt -- 文本信息
            ,fldmodblk -- 修改信息
            ,apprul -- 适用的国际惯例
            ,apprultxt -- 国际惯例内容具体描述
            ,contag72 -- 72场的内容
            ,contag79 -- 79场的内容
            ,addamtcov -- 保证金附加额
            ,chaded -- 报文71场内容
            ,amtspc -- 报文39场内容
            ,accspc -- 报文25场内容
            ,decamtstm -- 减额金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_git_op(
            inr -- 进口信用证ID号
            ,ver -- 版本号
            ,covgodsrv -- 遮盖物
            ,gidtxt -- 保函文本
            ,gtxgidtxt -- 保函文本显示规则
            ,gidtxtame -- 改正历史
            ,orcplc -- 初始交易地点
            ,addinf -- 附加信息
            ,revtxt -- 文本信息
            ,fldmodblk -- 修改信息
            ,apprul -- 适用的国际惯例
            ,apprultxt -- 国际惯例内容具体描述
            ,contag72 -- 72场的内容
            ,contag79 -- 79场的内容
            ,addamtcov -- 保证金附加额
            ,chaded -- 报文71场内容
            ,amtspc -- 报文39场内容
            ,accspc -- 报文25场内容
            ,decamtstm -- 减额金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 进口信用证ID号
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.covgodsrv, o.covgodsrv) as covgodsrv -- 遮盖物
    ,nvl(n.gidtxt, o.gidtxt) as gidtxt -- 保函文本
    ,nvl(n.gtxgidtxt, o.gtxgidtxt) as gtxgidtxt -- 保函文本显示规则
    ,nvl(n.gidtxtame, o.gidtxtame) as gidtxtame -- 改正历史
    ,nvl(n.orcplc, o.orcplc) as orcplc -- 初始交易地点
    ,nvl(n.addinf, o.addinf) as addinf -- 附加信息
    ,nvl(n.revtxt, o.revtxt) as revtxt -- 文本信息
    ,nvl(n.fldmodblk, o.fldmodblk) as fldmodblk -- 修改信息
    ,nvl(n.apprul, o.apprul) as apprul -- 适用的国际惯例
    ,nvl(n.apprultxt, o.apprultxt) as apprultxt -- 国际惯例内容具体描述
    ,nvl(n.contag72, o.contag72) as contag72 -- 72场的内容
    ,nvl(n.contag79, o.contag79) as contag79 -- 79场的内容
    ,nvl(n.addamtcov, o.addamtcov) as addamtcov -- 保证金附加额
    ,nvl(n.chaded, o.chaded) as chaded -- 报文71场内容
    ,nvl(n.amtspc, o.amtspc) as amtspc -- 报文39场内容
    ,nvl(n.accspc, o.accspc) as accspc -- 报文25场内容
    ,nvl(n.decamtstm, o.decamtstm) as decamtstm -- 减额金额
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_git_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_git where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.ver <> n.ver
        or o.covgodsrv <> n.covgodsrv
        or o.gidtxt <> n.gidtxt
        or o.gtxgidtxt <> n.gtxgidtxt
        or o.gidtxtame <> n.gidtxtame
        or o.orcplc <> n.orcplc
        or o.addinf <> n.addinf
        or o.revtxt <> n.revtxt
        or o.fldmodblk <> n.fldmodblk
        or o.apprul <> n.apprul
        or o.apprultxt <> n.apprultxt
        or o.contag72 <> n.contag72
        or o.contag79 <> n.contag79
        or o.addamtcov <> n.addamtcov
        or o.chaded <> n.chaded
        or o.amtspc <> n.amtspc
        or o.accspc <> n.accspc
        or o.decamtstm <> n.decamtstm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_git_cl(
            inr -- 进口信用证ID号
            ,ver -- 版本号
            ,covgodsrv -- 遮盖物
            ,gidtxt -- 保函文本
            ,gtxgidtxt -- 保函文本显示规则
            ,gidtxtame -- 改正历史
            ,orcplc -- 初始交易地点
            ,addinf -- 附加信息
            ,revtxt -- 文本信息
            ,fldmodblk -- 修改信息
            ,apprul -- 适用的国际惯例
            ,apprultxt -- 国际惯例内容具体描述
            ,contag72 -- 72场的内容
            ,contag79 -- 79场的内容
            ,addamtcov -- 保证金附加额
            ,chaded -- 报文71场内容
            ,amtspc -- 报文39场内容
            ,accspc -- 报文25场内容
            ,decamtstm -- 减额金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_git_op(
            inr -- 进口信用证ID号
            ,ver -- 版本号
            ,covgodsrv -- 遮盖物
            ,gidtxt -- 保函文本
            ,gtxgidtxt -- 保函文本显示规则
            ,gidtxtame -- 改正历史
            ,orcplc -- 初始交易地点
            ,addinf -- 附加信息
            ,revtxt -- 文本信息
            ,fldmodblk -- 修改信息
            ,apprul -- 适用的国际惯例
            ,apprultxt -- 国际惯例内容具体描述
            ,contag72 -- 72场的内容
            ,contag79 -- 79场的内容
            ,addamtcov -- 保证金附加额
            ,chaded -- 报文71场内容
            ,amtspc -- 报文39场内容
            ,accspc -- 报文25场内容
            ,decamtstm -- 减额金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 进口信用证ID号
    ,o.ver -- 版本号
    ,o.covgodsrv -- 遮盖物
    ,o.gidtxt -- 保函文本
    ,o.gtxgidtxt -- 保函文本显示规则
    ,o.gidtxtame -- 改正历史
    ,o.orcplc -- 初始交易地点
    ,o.addinf -- 附加信息
    ,o.revtxt -- 文本信息
    ,o.fldmodblk -- 修改信息
    ,o.apprul -- 适用的国际惯例
    ,o.apprultxt -- 国际惯例内容具体描述
    ,o.contag72 -- 72场的内容
    ,o.contag79 -- 79场的内容
    ,o.addamtcov -- 保证金附加额
    ,o.chaded -- 报文71场内容
    ,o.amtspc -- 报文39场内容
    ,o.accspc -- 报文25场内容
    ,o.decamtstm -- 减额金额
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
from ${iol_schema}.isbs_git_bk o
    left join ${iol_schema}.isbs_git_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_git_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.isbs_git;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_git') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_git drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_git add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_git exchange partition p_${batch_date} with table ${iol_schema}.isbs_git_cl;
alter table ${iol_schema}.isbs_git exchange partition p_20991231 with table ${iol_schema}.isbs_git_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_git to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_git_op purge;
drop table ${iol_schema}.isbs_git_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_git_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_git',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
