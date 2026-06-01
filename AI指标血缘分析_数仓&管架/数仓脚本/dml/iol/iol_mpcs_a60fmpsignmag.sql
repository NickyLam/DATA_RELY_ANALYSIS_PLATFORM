/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a60fmpsignmag
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
create table ${iol_schema}.mpcs_a60fmpsignmag_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a60fmpsignmag
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a60fmpsignmag_op purge;
drop table ${iol_schema}.mpcs_a60fmpsignmag_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60fmpsignmag_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a60fmpsignmag where 0=1;

create table ${iol_schema}.mpcs_a60fmpsignmag_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a60fmpsignmag where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a60fmpsignmag_cl(
            status -- 签约状态
            ,signdate -- 签约日期
            ,signtime -- 签约时间
            ,oprbrn -- 操作机构
            ,oprtlr -- 操作柜员
            ,chkbrn -- 复核机构
            ,chktlr -- 复核柜员
            ,autbrn -- 授权机构
            ,auttlr -- 授权柜员
            ,bankaccount -- 监控账号
            ,presalecode -- 预售证号
            ,companyname -- 开发公司
            ,projectname -- 项目名称
            ,contactnum -- 联系电话
            ,contactadd -- 联系地址
            ,recommend -- 推荐人
            ,remarks -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a60fmpsignmag_op(
            status -- 签约状态
            ,signdate -- 签约日期
            ,signtime -- 签约时间
            ,oprbrn -- 操作机构
            ,oprtlr -- 操作柜员
            ,chkbrn -- 复核机构
            ,chktlr -- 复核柜员
            ,autbrn -- 授权机构
            ,auttlr -- 授权柜员
            ,bankaccount -- 监控账号
            ,presalecode -- 预售证号
            ,companyname -- 开发公司
            ,projectname -- 项目名称
            ,contactnum -- 联系电话
            ,contactadd -- 联系地址
            ,recommend -- 推荐人
            ,remarks -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.status, o.status) as status -- 签约状态
    ,nvl(n.signdate, o.signdate) as signdate -- 签约日期
    ,nvl(n.signtime, o.signtime) as signtime -- 签约时间
    ,nvl(n.oprbrn, o.oprbrn) as oprbrn -- 操作机构
    ,nvl(n.oprtlr, o.oprtlr) as oprtlr -- 操作柜员
    ,nvl(n.chkbrn, o.chkbrn) as chkbrn -- 复核机构
    ,nvl(n.chktlr, o.chktlr) as chktlr -- 复核柜员
    ,nvl(n.autbrn, o.autbrn) as autbrn -- 授权机构
    ,nvl(n.auttlr, o.auttlr) as auttlr -- 授权柜员
    ,nvl(n.bankaccount, o.bankaccount) as bankaccount -- 监控账号
    ,nvl(n.presalecode, o.presalecode) as presalecode -- 预售证号
    ,nvl(n.companyname, o.companyname) as companyname -- 开发公司
    ,nvl(n.projectname, o.projectname) as projectname -- 项目名称
    ,nvl(n.contactnum, o.contactnum) as contactnum -- 联系电话
    ,nvl(n.contactadd, o.contactadd) as contactadd -- 联系地址
    ,nvl(n.recommend, o.recommend) as recommend -- 推荐人
    ,nvl(n.remarks, o.remarks) as remarks -- 备注
    ,case when
            n.bankaccount is null
            and n.presalecode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bankaccount is null
            and n.presalecode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bankaccount is null
            and n.presalecode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a60fmpsignmag_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a60fmpsignmag where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bankaccount = n.bankaccount
            and o.presalecode = n.presalecode
where (
        o.bankaccount is null
        and o.presalecode is null
    )
    or (
        n.bankaccount is null
        and n.presalecode is null
    )
    or (
        o.status <> n.status
        or o.signdate <> n.signdate
        or o.signtime <> n.signtime
        or o.oprbrn <> n.oprbrn
        or o.oprtlr <> n.oprtlr
        or o.chkbrn <> n.chkbrn
        or o.chktlr <> n.chktlr
        or o.autbrn <> n.autbrn
        or o.auttlr <> n.auttlr
        or o.companyname <> n.companyname
        or o.projectname <> n.projectname
        or o.contactnum <> n.contactnum
        or o.contactadd <> n.contactadd
        or o.recommend <> n.recommend
        or o.remarks <> n.remarks
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a60fmpsignmag_cl(
            status -- 签约状态
            ,signdate -- 签约日期
            ,signtime -- 签约时间
            ,oprbrn -- 操作机构
            ,oprtlr -- 操作柜员
            ,chkbrn -- 复核机构
            ,chktlr -- 复核柜员
            ,autbrn -- 授权机构
            ,auttlr -- 授权柜员
            ,bankaccount -- 监控账号
            ,presalecode -- 预售证号
            ,companyname -- 开发公司
            ,projectname -- 项目名称
            ,contactnum -- 联系电话
            ,contactadd -- 联系地址
            ,recommend -- 推荐人
            ,remarks -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a60fmpsignmag_op(
            status -- 签约状态
            ,signdate -- 签约日期
            ,signtime -- 签约时间
            ,oprbrn -- 操作机构
            ,oprtlr -- 操作柜员
            ,chkbrn -- 复核机构
            ,chktlr -- 复核柜员
            ,autbrn -- 授权机构
            ,auttlr -- 授权柜员
            ,bankaccount -- 监控账号
            ,presalecode -- 预售证号
            ,companyname -- 开发公司
            ,projectname -- 项目名称
            ,contactnum -- 联系电话
            ,contactadd -- 联系地址
            ,recommend -- 推荐人
            ,remarks -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.status -- 签约状态
    ,o.signdate -- 签约日期
    ,o.signtime -- 签约时间
    ,o.oprbrn -- 操作机构
    ,o.oprtlr -- 操作柜员
    ,o.chkbrn -- 复核机构
    ,o.chktlr -- 复核柜员
    ,o.autbrn -- 授权机构
    ,o.auttlr -- 授权柜员
    ,o.bankaccount -- 监控账号
    ,o.presalecode -- 预售证号
    ,o.companyname -- 开发公司
    ,o.projectname -- 项目名称
    ,o.contactnum -- 联系电话
    ,o.contactadd -- 联系地址
    ,o.recommend -- 推荐人
    ,o.remarks -- 备注
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
from ${iol_schema}.mpcs_a60fmpsignmag_bk o
    left join ${iol_schema}.mpcs_a60fmpsignmag_op n
        on
            o.bankaccount = n.bankaccount
            and o.presalecode = n.presalecode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a60fmpsignmag_cl d
        on
            o.bankaccount = d.bankaccount
            and o.presalecode = d.presalecode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a60fmpsignmag;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a60fmpsignmag') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a60fmpsignmag drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a60fmpsignmag add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a60fmpsignmag exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a60fmpsignmag_cl;
alter table ${iol_schema}.mpcs_a60fmpsignmag exchange partition p_20991231 with table ${iol_schema}.mpcs_a60fmpsignmag_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a60fmpsignmag to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a60fmpsignmag_op purge;
drop table ${iol_schema}.mpcs_a60fmpsignmag_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a60fmpsignmag_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a60fmpsignmag',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
