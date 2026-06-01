/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_proce_dept
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
create table ${iol_schema}.icms_ap_proce_dept_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_proce_dept
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_proce_dept_op purge;
drop table ${iol_schema}.icms_ap_proce_dept_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_proce_dept_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_proce_dept where 0=1;

create table ${iol_schema}.icms_ap_proce_dept_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_proce_dept where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_proce_dept_cl(
            deptno -- 抵债回款编号
            ,updateorgid -- 更新机构编号
            ,deptdate -- 抵债日期
            ,ruleorgdate -- 出具裁定日期
            ,caseno -- 关联案件项目编号
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,ruleno -- 裁定书编号
            ,inputuserid -- 登记人编号
            ,inputorgid -- 登记机构编号
            ,fileno -- 影像平台编号
            ,updateuserid -- 更新人编号
            ,saveflag -- 以物抵债回款信息保存状态
            ,tmsp -- 时间戳
            ,ruleorgname -- 出具裁定机构名称
            ,deptsum -- 抵债金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_proce_dept_op(
            deptno -- 抵债回款编号
            ,updateorgid -- 更新机构编号
            ,deptdate -- 抵债日期
            ,ruleorgdate -- 出具裁定日期
            ,caseno -- 关联案件项目编号
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,ruleno -- 裁定书编号
            ,inputuserid -- 登记人编号
            ,inputorgid -- 登记机构编号
            ,fileno -- 影像平台编号
            ,updateuserid -- 更新人编号
            ,saveflag -- 以物抵债回款信息保存状态
            ,tmsp -- 时间戳
            ,ruleorgname -- 出具裁定机构名称
            ,deptsum -- 抵债金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deptno, o.deptno) as deptno -- 抵债回款编号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.deptdate, o.deptdate) as deptdate -- 抵债日期
    ,nvl(n.ruleorgdate, o.ruleorgdate) as ruleorgdate -- 出具裁定日期
    ,nvl(n.caseno, o.caseno) as caseno -- 关联案件项目编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.ruleno, o.ruleno) as ruleno -- 裁定书编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.fileno, o.fileno) as fileno -- 影像平台编号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.saveflag, o.saveflag) as saveflag -- 以物抵债回款信息保存状态
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.ruleorgname, o.ruleorgname) as ruleorgname -- 出具裁定机构名称
    ,nvl(n.deptsum, o.deptsum) as deptsum -- 抵债金额
    ,case when
            n.deptno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.deptno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.deptno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_proce_dept_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_proce_dept where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.deptno = n.deptno
where (
        o.deptno is null
    )
    or (
        n.deptno is null
    )
    or (
        o.updateorgid <> n.updateorgid
        or o.deptdate <> n.deptdate
        or o.ruleorgdate <> n.ruleorgdate
        or o.caseno <> n.caseno
        or o.updatedate <> n.updatedate
        or o.inputdate <> n.inputdate
        or o.ruleno <> n.ruleno
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.fileno <> n.fileno
        or o.updateuserid <> n.updateuserid
        or o.saveflag <> n.saveflag
        or o.tmsp <> n.tmsp
        or o.ruleorgname <> n.ruleorgname
        or o.deptsum <> n.deptsum
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_proce_dept_cl(
            deptno -- 抵债回款编号
            ,updateorgid -- 更新机构编号
            ,deptdate -- 抵债日期
            ,ruleorgdate -- 出具裁定日期
            ,caseno -- 关联案件项目编号
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,ruleno -- 裁定书编号
            ,inputuserid -- 登记人编号
            ,inputorgid -- 登记机构编号
            ,fileno -- 影像平台编号
            ,updateuserid -- 更新人编号
            ,saveflag -- 以物抵债回款信息保存状态
            ,tmsp -- 时间戳
            ,ruleorgname -- 出具裁定机构名称
            ,deptsum -- 抵债金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_proce_dept_op(
            deptno -- 抵债回款编号
            ,updateorgid -- 更新机构编号
            ,deptdate -- 抵债日期
            ,ruleorgdate -- 出具裁定日期
            ,caseno -- 关联案件项目编号
            ,updatedate -- 更新日期
            ,inputdate -- 登记日期
            ,ruleno -- 裁定书编号
            ,inputuserid -- 登记人编号
            ,inputorgid -- 登记机构编号
            ,fileno -- 影像平台编号
            ,updateuserid -- 更新人编号
            ,saveflag -- 以物抵债回款信息保存状态
            ,tmsp -- 时间戳
            ,ruleorgname -- 出具裁定机构名称
            ,deptsum -- 抵债金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deptno -- 抵债回款编号
    ,o.updateorgid -- 更新机构编号
    ,o.deptdate -- 抵债日期
    ,o.ruleorgdate -- 出具裁定日期
    ,o.caseno -- 关联案件项目编号
    ,o.updatedate -- 更新日期
    ,o.inputdate -- 登记日期
    ,o.ruleno -- 裁定书编号
    ,o.inputuserid -- 登记人编号
    ,o.inputorgid -- 登记机构编号
    ,o.fileno -- 影像平台编号
    ,o.updateuserid -- 更新人编号
    ,o.saveflag -- 以物抵债回款信息保存状态
    ,o.tmsp -- 时间戳
    ,o.ruleorgname -- 出具裁定机构名称
    ,o.deptsum -- 抵债金额
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
from ${iol_schema}.icms_ap_proce_dept_bk o
    left join ${iol_schema}.icms_ap_proce_dept_op n
        on
            o.deptno = n.deptno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_proce_dept_cl d
        on
            o.deptno = d.deptno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_proce_dept;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_proce_dept') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_proce_dept drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_proce_dept add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_proce_dept exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_proce_dept_cl;
alter table ${iol_schema}.icms_ap_proce_dept exchange partition p_20991231 with table ${iol_schema}.icms_ap_proce_dept_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_proce_dept to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_proce_dept_op purge;
drop table ${iol_schema}.icms_ap_proce_dept_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_proce_dept_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_proce_dept',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
