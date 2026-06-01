/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_pph_claim_appl_data
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
create table ${iol_schema}.icms_pph_claim_appl_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_pph_claim_appl_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_pph_claim_appl_data_op purge;
drop table ${iol_schema}.icms_pph_claim_appl_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_pph_claim_appl_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_pph_claim_appl_data where 0=1;

create table ${iol_schema}.icms_pph_claim_appl_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_pph_claim_appl_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_pph_claim_appl_data_cl(
            loanno -- 借据号
            ,capdays -- 逾期总天数
            ,capital -- 逾期总本金
            ,aint -- 逾期利息
            ,oint -- 逾期罚息
            ,nint -- 未计利息
            ,curnint -- 未到期本金
            ,claimamt -- 理赔总金额
            ,claimmsg -- 理赔申请书信息
            ,inputdate -- 录入日期
            ,compid -- 助贷公司编码
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_pph_claim_appl_data_op(
            loanno -- 借据号
            ,capdays -- 逾期总天数
            ,capital -- 逾期总本金
            ,aint -- 逾期利息
            ,oint -- 逾期罚息
            ,nint -- 未计利息
            ,curnint -- 未到期本金
            ,claimamt -- 理赔总金额
            ,claimmsg -- 理赔申请书信息
            ,inputdate -- 录入日期
            ,compid -- 助贷公司编码
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.loanno, o.loanno) as loanno -- 借据号
    ,nvl(n.capdays, o.capdays) as capdays -- 逾期总天数
    ,nvl(n.capital, o.capital) as capital -- 逾期总本金
    ,nvl(n.aint, o.aint) as aint -- 逾期利息
    ,nvl(n.oint, o.oint) as oint -- 逾期罚息
    ,nvl(n.nint, o.nint) as nint -- 未计利息
    ,nvl(n.curnint, o.curnint) as curnint -- 未到期本金
    ,nvl(n.claimamt, o.claimamt) as claimamt -- 理赔总金额
    ,nvl(n.claimmsg, o.claimmsg) as claimmsg -- 理赔申请书信息
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 录入日期
    ,nvl(n.compid, o.compid) as compid -- 助贷公司编码
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,case when
            n.loanno is null
            and n.inputdate is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.loanno is null
            and n.inputdate is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.loanno is null
            and n.inputdate is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_pph_claim_appl_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_pph_claim_appl_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.loanno = n.loanno
            and o.inputdate = n.inputdate
where (
        o.loanno is null
        and o.inputdate is null
    )
    or (
        n.loanno is null
        and n.inputdate is null
    )
    or (
        o.capdays <> n.capdays
        or o.capital <> n.capital
        or o.aint <> n.aint
        or o.oint <> n.oint
        or o.nint <> n.nint
        or o.curnint <> n.curnint
        or o.claimamt <> n.claimamt
        or o.claimmsg <> n.claimmsg
        or o.compid <> n.compid
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_pph_claim_appl_data_cl(
            loanno -- 借据号
            ,capdays -- 逾期总天数
            ,capital -- 逾期总本金
            ,aint -- 逾期利息
            ,oint -- 逾期罚息
            ,nint -- 未计利息
            ,curnint -- 未到期本金
            ,claimamt -- 理赔总金额
            ,claimmsg -- 理赔申请书信息
            ,inputdate -- 录入日期
            ,compid -- 助贷公司编码
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_pph_claim_appl_data_op(
            loanno -- 借据号
            ,capdays -- 逾期总天数
            ,capital -- 逾期总本金
            ,aint -- 逾期利息
            ,oint -- 逾期罚息
            ,nint -- 未计利息
            ,curnint -- 未到期本金
            ,claimamt -- 理赔总金额
            ,claimmsg -- 理赔申请书信息
            ,inputdate -- 录入日期
            ,compid -- 助贷公司编码
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.loanno -- 借据号
    ,o.capdays -- 逾期总天数
    ,o.capital -- 逾期总本金
    ,o.aint -- 逾期利息
    ,o.oint -- 逾期罚息
    ,o.nint -- 未计利息
    ,o.curnint -- 未到期本金
    ,o.claimamt -- 理赔总金额
    ,o.claimmsg -- 理赔申请书信息
    ,o.inputdate -- 录入日期
    ,o.compid -- 助贷公司编码
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
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
from ${iol_schema}.icms_pph_claim_appl_data_bk o
    left join ${iol_schema}.icms_pph_claim_appl_data_op n
        on
            o.loanno = n.loanno
            and o.inputdate = n.inputdate
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_pph_claim_appl_data_cl d
        on
            o.loanno = d.loanno
            and o.inputdate = d.inputdate
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_pph_claim_appl_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_pph_claim_appl_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_pph_claim_appl_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_pph_claim_appl_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_pph_claim_appl_data exchange partition p_${batch_date} with table ${iol_schema}.icms_pph_claim_appl_data_cl;
alter table ${iol_schema}.icms_pph_claim_appl_data exchange partition p_20991231 with table ${iol_schema}.icms_pph_claim_appl_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_pph_claim_appl_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_pph_claim_appl_data_op purge;
drop table ${iol_schema}.icms_pph_claim_appl_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_pph_claim_appl_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_pph_claim_appl_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
