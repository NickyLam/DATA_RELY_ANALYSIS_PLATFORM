/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_loan_rebuild_book_tab
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
create table ${iol_schema}.icms_loan_rebuild_book_tab_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_loan_rebuild_book_tab
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_loan_rebuild_book_tab_op purge;
drop table ${iol_schema}.icms_loan_rebuild_book_tab_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_loan_rebuild_book_tab_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_loan_rebuild_book_tab where 0=1;

create table ${iol_schema}.icms_loan_rebuild_book_tab_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_loan_rebuild_book_tab where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_loan_rebuild_book_tab_cl(
            duebillserialno -- 借据号(主键)
            ,loanrebuildtype -- 重组贷款类型
            ,inbusinesssum -- 加入重组时借据余额
            ,infiveclass -- 加入重组时五级分类
            ,restructuretheloandate -- 实施重组日期（年月日）
            ,exbusinesssum -- 退出重组时借据余额
            ,exfiveclass -- 退出重组时五级分类
            ,exstructuretheloandate -- 退出重组日期（年月日）
            ,exreason -- 退出重组原因
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_loan_rebuild_book_tab_op(
            duebillserialno -- 借据号(主键)
            ,loanrebuildtype -- 重组贷款类型
            ,inbusinesssum -- 加入重组时借据余额
            ,infiveclass -- 加入重组时五级分类
            ,restructuretheloandate -- 实施重组日期（年月日）
            ,exbusinesssum -- 退出重组时借据余额
            ,exfiveclass -- 退出重组时五级分类
            ,exstructuretheloandate -- 退出重组日期（年月日）
            ,exreason -- 退出重组原因
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.duebillserialno, o.duebillserialno) as duebillserialno -- 借据号(主键)
    ,nvl(n.loanrebuildtype, o.loanrebuildtype) as loanrebuildtype -- 重组贷款类型
    ,nvl(n.inbusinesssum, o.inbusinesssum) as inbusinesssum -- 加入重组时借据余额
    ,nvl(n.infiveclass, o.infiveclass) as infiveclass -- 加入重组时五级分类
    ,nvl(n.restructuretheloandate, o.restructuretheloandate) as restructuretheloandate -- 实施重组日期（年月日）
    ,nvl(n.exbusinesssum, o.exbusinesssum) as exbusinesssum -- 退出重组时借据余额
    ,nvl(n.exfiveclass, o.exfiveclass) as exfiveclass -- 退出重组时五级分类
    ,nvl(n.exstructuretheloandate, o.exstructuretheloandate) as exstructuretheloandate -- 退出重组日期（年月日）
    ,nvl(n.exreason, o.exreason) as exreason -- 退出重组原因
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,case when
            n.duebillserialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.duebillserialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.duebillserialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_loan_rebuild_book_tab_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_loan_rebuild_book_tab where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.duebillserialno = n.duebillserialno
where (
        o.duebillserialno is null
    )
    or (
        n.duebillserialno is null
    )
    or (
        o.loanrebuildtype <> n.loanrebuildtype
        or o.inbusinesssum <> n.inbusinesssum
        or o.infiveclass <> n.infiveclass
        or o.restructuretheloandate <> n.restructuretheloandate
        or o.exbusinesssum <> n.exbusinesssum
        or o.exfiveclass <> n.exfiveclass
        or o.exstructuretheloandate <> n.exstructuretheloandate
        or o.exreason <> n.exreason
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_loan_rebuild_book_tab_cl(
            duebillserialno -- 借据号(主键)
            ,loanrebuildtype -- 重组贷款类型
            ,inbusinesssum -- 加入重组时借据余额
            ,infiveclass -- 加入重组时五级分类
            ,restructuretheloandate -- 实施重组日期（年月日）
            ,exbusinesssum -- 退出重组时借据余额
            ,exfiveclass -- 退出重组时五级分类
            ,exstructuretheloandate -- 退出重组日期（年月日）
            ,exreason -- 退出重组原因
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_loan_rebuild_book_tab_op(
            duebillserialno -- 借据号(主键)
            ,loanrebuildtype -- 重组贷款类型
            ,inbusinesssum -- 加入重组时借据余额
            ,infiveclass -- 加入重组时五级分类
            ,restructuretheloandate -- 实施重组日期（年月日）
            ,exbusinesssum -- 退出重组时借据余额
            ,exfiveclass -- 退出重组时五级分类
            ,exstructuretheloandate -- 退出重组日期（年月日）
            ,exreason -- 退出重组原因
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.duebillserialno -- 借据号(主键)
    ,o.loanrebuildtype -- 重组贷款类型
    ,o.inbusinesssum -- 加入重组时借据余额
    ,o.infiveclass -- 加入重组时五级分类
    ,o.restructuretheloandate -- 实施重组日期（年月日）
    ,o.exbusinesssum -- 退出重组时借据余额
    ,o.exfiveclass -- 退出重组时五级分类
    ,o.exstructuretheloandate -- 退出重组日期（年月日）
    ,o.exreason -- 退出重组原因
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记时间
    ,o.updatedate -- 更新时间
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
from ${iol_schema}.icms_loan_rebuild_book_tab_bk o
    left join ${iol_schema}.icms_loan_rebuild_book_tab_op n
        on
            o.duebillserialno = n.duebillserialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_loan_rebuild_book_tab_cl d
        on
            o.duebillserialno = d.duebillserialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_loan_rebuild_book_tab;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_loan_rebuild_book_tab') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_loan_rebuild_book_tab drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_loan_rebuild_book_tab add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_loan_rebuild_book_tab exchange partition p_${batch_date} with table ${iol_schema}.icms_loan_rebuild_book_tab_cl;
alter table ${iol_schema}.icms_loan_rebuild_book_tab exchange partition p_20991231 with table ${iol_schema}.icms_loan_rebuild_book_tab_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_loan_rebuild_book_tab to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_loan_rebuild_book_tab_op purge;
drop table ${iol_schema}.icms_loan_rebuild_book_tab_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_loan_rebuild_book_tab_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_loan_rebuild_book_tab',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
