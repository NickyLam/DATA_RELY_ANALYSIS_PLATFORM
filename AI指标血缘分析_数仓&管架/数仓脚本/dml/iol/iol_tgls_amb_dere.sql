/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_amb_dere
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
create table ${iol_schema}.tgls_amb_dere_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_amb_dere
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amb_dere_op purge;
drop table ${iol_schema}.tgls_amb_dere_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amb_dere_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amb_dere where 0=1;

create table ${iol_schema}.tgls_amb_dere_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amb_dere where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amb_dere_cl(
            stacid -- 账套标记
            ,systid -- 来源系统编号
            ,datadt -- 业务日期
            ,loanno -- 贷款账户编号
            ,remotp -- 撤并类型(0-整机构撤并，1-条件撤并,2-转移)
            ,bedecd -- 撤并前机构编号
            ,afdecd -- 撤并后机构编号
            ,intesm -- 变更时利息收入总金额
            ,intein -- 记录利息收入
            ,assesm -- 变更时减值损失总金额总金额
            ,asselo -- 记录减值损失
            ,impasm -- 变更时已减值利息收入总金额
            ,impaii -- 记录已减值利息收入
            ,invesm -- 变更时投资收益总金额
            ,invein -- 记录投资收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amb_dere_op(
            stacid -- 账套标记
            ,systid -- 来源系统编号
            ,datadt -- 业务日期
            ,loanno -- 贷款账户编号
            ,remotp -- 撤并类型(0-整机构撤并，1-条件撤并,2-转移)
            ,bedecd -- 撤并前机构编号
            ,afdecd -- 撤并后机构编号
            ,intesm -- 变更时利息收入总金额
            ,intein -- 记录利息收入
            ,assesm -- 变更时减值损失总金额总金额
            ,asselo -- 记录减值损失
            ,impasm -- 变更时已减值利息收入总金额
            ,impaii -- 记录已减值利息收入
            ,invesm -- 变更时投资收益总金额
            ,invein -- 记录投资收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.systid, o.systid) as systid -- 来源系统编号
    ,nvl(n.datadt, o.datadt) as datadt -- 业务日期
    ,nvl(n.loanno, o.loanno) as loanno -- 贷款账户编号
    ,nvl(n.remotp, o.remotp) as remotp -- 撤并类型(0-整机构撤并，1-条件撤并,2-转移)
    ,nvl(n.bedecd, o.bedecd) as bedecd -- 撤并前机构编号
    ,nvl(n.afdecd, o.afdecd) as afdecd -- 撤并后机构编号
    ,nvl(n.intesm, o.intesm) as intesm -- 变更时利息收入总金额
    ,nvl(n.intein, o.intein) as intein -- 记录利息收入
    ,nvl(n.assesm, o.assesm) as assesm -- 变更时减值损失总金额总金额
    ,nvl(n.asselo, o.asselo) as asselo -- 记录减值损失
    ,nvl(n.impasm, o.impasm) as impasm -- 变更时已减值利息收入总金额
    ,nvl(n.impaii, o.impaii) as impaii -- 记录已减值利息收入
    ,nvl(n.invesm, o.invesm) as invesm -- 变更时投资收益总金额
    ,nvl(n.invein, o.invein) as invein -- 记录投资收益
    ,case when
            n.stacid is null
            and n.systid is null
            and n.datadt is null
            and n.loanno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.systid is null
            and n.datadt is null
            and n.loanno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.systid is null
            and n.datadt is null
            and n.loanno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_amb_dere_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_amb_dere where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.systid = n.systid
            and o.datadt = n.datadt
            and o.loanno = n.loanno
where (
        o.stacid is null
        and o.systid is null
        and o.datadt is null
        and o.loanno is null
    )
    or (
        n.stacid is null
        and n.systid is null
        and n.datadt is null
        and n.loanno is null
    )
    or (
        o.remotp <> n.remotp
        or o.bedecd <> n.bedecd
        or o.afdecd <> n.afdecd
        or o.intesm <> n.intesm
        or o.intein <> n.intein
        or o.assesm <> n.assesm
        or o.asselo <> n.asselo
        or o.impasm <> n.impasm
        or o.impaii <> n.impaii
        or o.invesm <> n.invesm
        or o.invein <> n.invein
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amb_dere_cl(
            stacid -- 账套标记
            ,systid -- 来源系统编号
            ,datadt -- 业务日期
            ,loanno -- 贷款账户编号
            ,remotp -- 撤并类型(0-整机构撤并，1-条件撤并,2-转移)
            ,bedecd -- 撤并前机构编号
            ,afdecd -- 撤并后机构编号
            ,intesm -- 变更时利息收入总金额
            ,intein -- 记录利息收入
            ,assesm -- 变更时减值损失总金额总金额
            ,asselo -- 记录减值损失
            ,impasm -- 变更时已减值利息收入总金额
            ,impaii -- 记录已减值利息收入
            ,invesm -- 变更时投资收益总金额
            ,invein -- 记录投资收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amb_dere_op(
            stacid -- 账套标记
            ,systid -- 来源系统编号
            ,datadt -- 业务日期
            ,loanno -- 贷款账户编号
            ,remotp -- 撤并类型(0-整机构撤并，1-条件撤并,2-转移)
            ,bedecd -- 撤并前机构编号
            ,afdecd -- 撤并后机构编号
            ,intesm -- 变更时利息收入总金额
            ,intein -- 记录利息收入
            ,assesm -- 变更时减值损失总金额总金额
            ,asselo -- 记录减值损失
            ,impasm -- 变更时已减值利息收入总金额
            ,impaii -- 记录已减值利息收入
            ,invesm -- 变更时投资收益总金额
            ,invein -- 记录投资收益
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.systid -- 来源系统编号
    ,o.datadt -- 业务日期
    ,o.loanno -- 贷款账户编号
    ,o.remotp -- 撤并类型(0-整机构撤并，1-条件撤并,2-转移)
    ,o.bedecd -- 撤并前机构编号
    ,o.afdecd -- 撤并后机构编号
    ,o.intesm -- 变更时利息收入总金额
    ,o.intein -- 记录利息收入
    ,o.assesm -- 变更时减值损失总金额总金额
    ,o.asselo -- 记录减值损失
    ,o.impasm -- 变更时已减值利息收入总金额
    ,o.impaii -- 记录已减值利息收入
    ,o.invesm -- 变更时投资收益总金额
    ,o.invein -- 记录投资收益
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
from ${iol_schema}.tgls_amb_dere_bk o
    left join ${iol_schema}.tgls_amb_dere_op n
        on
            o.stacid = n.stacid
            and o.systid = n.systid
            and o.datadt = n.datadt
            and o.loanno = n.loanno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_amb_dere_cl d
        on
            o.stacid = d.stacid
            and o.systid = d.systid
            and o.datadt = d.datadt
            and o.loanno = d.loanno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_amb_dere;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_amb_dere') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_amb_dere drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_amb_dere add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_amb_dere exchange partition p_${batch_date} with table ${iol_schema}.tgls_amb_dere_cl;
alter table ${iol_schema}.tgls_amb_dere exchange partition p_20991231 with table ${iol_schema}.tgls_amb_dere_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_amb_dere to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amb_dere_op purge;
drop table ${iol_schema}.tgls_amb_dere_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_amb_dere_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_amb_dere',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
