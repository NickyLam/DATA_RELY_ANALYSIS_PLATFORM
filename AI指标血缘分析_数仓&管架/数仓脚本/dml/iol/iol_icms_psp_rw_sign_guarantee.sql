/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_psp_rw_sign_guarantee
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
create table ${iol_schema}.icms_psp_rw_sign_guarantee_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_psp_rw_sign_guarantee
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_rw_sign_guarantee_op purge;
drop table ${iol_schema}.icms_psp_rw_sign_guarantee_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_rw_sign_guarantee_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_rw_sign_guarantee where 0=1;

create table ${iol_schema}.icms_psp_rw_sign_guarantee_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_psp_rw_sign_guarantee where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_rw_sign_guarantee_cl(
            serno -- 流水号
            ,sign_serno -- 预警信号流水号
            ,main_business -- 主营业务
            ,credit_desc -- 当前授信情况
            ,migtflag -- 
            ,borrower_relation -- 与授信人关系
            ,cus_name -- 保证人名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_rw_sign_guarantee_op(
            serno -- 流水号
            ,sign_serno -- 预警信号流水号
            ,main_business -- 主营业务
            ,credit_desc -- 当前授信情况
            ,migtflag -- 
            ,borrower_relation -- 与授信人关系
            ,cus_name -- 保证人名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serno, o.serno) as serno -- 流水号
    ,nvl(n.sign_serno, o.sign_serno) as sign_serno -- 预警信号流水号
    ,nvl(n.main_business, o.main_business) as main_business -- 主营业务
    ,nvl(n.credit_desc, o.credit_desc) as credit_desc -- 当前授信情况
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.borrower_relation, o.borrower_relation) as borrower_relation -- 与授信人关系
    ,nvl(n.cus_name, o.cus_name) as cus_name -- 保证人名称
    ,case when
            n.serno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_psp_rw_sign_guarantee_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_psp_rw_sign_guarantee where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serno = n.serno
where (
        o.serno is null
    )
    or (
        n.serno is null
    )
    or (
        o.sign_serno <> n.sign_serno
        or o.main_business <> n.main_business
        or o.credit_desc <> n.credit_desc
        or o.migtflag <> n.migtflag
        or o.borrower_relation <> n.borrower_relation
        or o.cus_name <> n.cus_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_psp_rw_sign_guarantee_cl(
            serno -- 流水号
            ,sign_serno -- 预警信号流水号
            ,main_business -- 主营业务
            ,credit_desc -- 当前授信情况
            ,migtflag -- 
            ,borrower_relation -- 与授信人关系
            ,cus_name -- 保证人名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_psp_rw_sign_guarantee_op(
            serno -- 流水号
            ,sign_serno -- 预警信号流水号
            ,main_business -- 主营业务
            ,credit_desc -- 当前授信情况
            ,migtflag -- 
            ,borrower_relation -- 与授信人关系
            ,cus_name -- 保证人名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serno -- 流水号
    ,o.sign_serno -- 预警信号流水号
    ,o.main_business -- 主营业务
    ,o.credit_desc -- 当前授信情况
    ,o.migtflag -- 
    ,o.borrower_relation -- 与授信人关系
    ,o.cus_name -- 保证人名称
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
from ${iol_schema}.icms_psp_rw_sign_guarantee_bk o
    left join ${iol_schema}.icms_psp_rw_sign_guarantee_op n
        on
            o.serno = n.serno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_psp_rw_sign_guarantee_cl d
        on
            o.serno = d.serno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_psp_rw_sign_guarantee;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_psp_rw_sign_guarantee') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_psp_rw_sign_guarantee drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_psp_rw_sign_guarantee add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_psp_rw_sign_guarantee exchange partition p_${batch_date} with table ${iol_schema}.icms_psp_rw_sign_guarantee_cl;
alter table ${iol_schema}.icms_psp_rw_sign_guarantee exchange partition p_20991231 with table ${iol_schema}.icms_psp_rw_sign_guarantee_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_psp_rw_sign_guarantee to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_psp_rw_sign_guarantee_op purge;
drop table ${iol_schema}.icms_psp_rw_sign_guarantee_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_psp_rw_sign_guarantee_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_psp_rw_sign_guarantee',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
