/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bd_personal_loan
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
create table ${iol_schema}.icms_bd_personal_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bd_personal_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bd_personal_loan_op purge;
drop table ${iol_schema}.icms_bd_personal_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bd_personal_loan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bd_personal_loan where 0=1;

create table ${iol_schema}.icms_bd_personal_loan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bd_personal_loan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bd_personal_loan_cl(
            serialno -- 借据编号
            ,iswhite -- 是否白户
            ,balloonamortenddate -- 气球贷摊销到期日
            ,isfarmer -- 是否农户
            ,migtflag -- 迁移标志
            ,indtype -- 客户性质：IndType
            ,taxflg -- 是否涉税：YesNo
            ,custloantype -- 
            ,isagriculture -- 
            ,entclaimserialno -- 
            ,retailclaimserialno -- 
            ,entclaimimageinfono -- 
            ,indclaimimageinfono -- 
            ,isbelongterm -- 
            ,productchannel -- 
            ,ftpapplyno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bd_personal_loan_op(
            serialno -- 借据编号
            ,iswhite -- 是否白户
            ,balloonamortenddate -- 气球贷摊销到期日
            ,isfarmer -- 是否农户
            ,migtflag -- 迁移标志
            ,indtype -- 客户性质：IndType
            ,taxflg -- 是否涉税：YesNo
            ,custloantype -- 
            ,isagriculture -- 
            ,entclaimserialno -- 
            ,retailclaimserialno -- 
            ,entclaimimageinfono -- 
            ,indclaimimageinfono -- 
            ,isbelongterm -- 
            ,productchannel -- 
            ,ftpapplyno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 借据编号
    ,nvl(n.iswhite, o.iswhite) as iswhite -- 是否白户
    ,nvl(n.balloonamortenddate, o.balloonamortenddate) as balloonamortenddate -- 气球贷摊销到期日
    ,nvl(n.isfarmer, o.isfarmer) as isfarmer -- 是否农户
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志
    ,nvl(n.indtype, o.indtype) as indtype -- 客户性质：IndType
    ,nvl(n.taxflg, o.taxflg) as taxflg -- 是否涉税：YesNo
    ,nvl(n.custloantype, o.custloantype) as custloantype -- 
    ,nvl(n.isagriculture, o.isagriculture) as isagriculture -- 
    ,nvl(n.entclaimserialno, o.entclaimserialno) as entclaimserialno -- 
    ,nvl(n.retailclaimserialno, o.retailclaimserialno) as retailclaimserialno -- 
    ,nvl(n.entclaimimageinfono, o.entclaimimageinfono) as entclaimimageinfono -- 
    ,nvl(n.indclaimimageinfono, o.indclaimimageinfono) as indclaimimageinfono -- 
    ,nvl(n.isbelongterm, o.isbelongterm) as isbelongterm -- 
    ,nvl(n.productchannel, o.productchannel) as productchannel -- 
    ,nvl(n.ftpapplyno, o.ftpapplyno) as ftpapplyno -- 
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_bd_personal_loan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bd_personal_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.iswhite <> n.iswhite
        or o.balloonamortenddate <> n.balloonamortenddate
        or o.isfarmer <> n.isfarmer
        or o.migtflag <> n.migtflag
        or o.indtype <> n.indtype
        or o.taxflg <> n.taxflg
        or o.custloantype <> n.custloantype
        or o.isagriculture <> n.isagriculture
        or o.entclaimserialno <> n.entclaimserialno
        or o.retailclaimserialno <> n.retailclaimserialno
        or o.entclaimimageinfono <> n.entclaimimageinfono
        or o.indclaimimageinfono <> n.indclaimimageinfono
        or o.isbelongterm <> n.isbelongterm
        or o.productchannel <> n.productchannel
        or o.ftpapplyno <> n.ftpapplyno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bd_personal_loan_cl(
            serialno -- 借据编号
            ,iswhite -- 是否白户
            ,balloonamortenddate -- 气球贷摊销到期日
            ,isfarmer -- 是否农户
            ,migtflag -- 迁移标志
            ,indtype -- 客户性质：IndType
            ,taxflg -- 是否涉税：YesNo
            ,custloantype -- 
            ,isagriculture -- 
            ,entclaimserialno -- 
            ,retailclaimserialno -- 
            ,entclaimimageinfono -- 
            ,indclaimimageinfono -- 
            ,isbelongterm -- 
            ,productchannel -- 
            ,ftpapplyno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bd_personal_loan_op(
            serialno -- 借据编号
            ,iswhite -- 是否白户
            ,balloonamortenddate -- 气球贷摊销到期日
            ,isfarmer -- 是否农户
            ,migtflag -- 迁移标志
            ,indtype -- 客户性质：IndType
            ,taxflg -- 是否涉税：YesNo
            ,custloantype -- 
            ,isagriculture -- 
            ,entclaimserialno -- 
            ,retailclaimserialno -- 
            ,entclaimimageinfono -- 
            ,indclaimimageinfono -- 
            ,isbelongterm -- 
            ,productchannel -- 
            ,ftpapplyno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 借据编号
    ,o.iswhite -- 是否白户
    ,o.balloonamortenddate -- 气球贷摊销到期日
    ,o.isfarmer -- 是否农户
    ,o.migtflag -- 迁移标志
    ,o.indtype -- 客户性质：IndType
    ,o.taxflg -- 是否涉税：YesNo
    ,o.custloantype -- 
    ,o.isagriculture -- 
    ,o.entclaimserialno -- 
    ,o.retailclaimserialno -- 
    ,o.entclaimimageinfono -- 
    ,o.indclaimimageinfono -- 
    ,o.isbelongterm -- 
    ,o.productchannel -- 
    ,o.ftpapplyno -- 
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
from ${iol_schema}.icms_bd_personal_loan_bk o
    left join ${iol_schema}.icms_bd_personal_loan_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bd_personal_loan_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_bd_personal_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bd_personal_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bd_personal_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bd_personal_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bd_personal_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_bd_personal_loan_cl;
alter table ${iol_schema}.icms_bd_personal_loan exchange partition p_20991231 with table ${iol_schema}.icms_bd_personal_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bd_personal_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bd_personal_loan_op purge;
drop table ${iol_schema}.icms_bd_personal_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bd_personal_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bd_personal_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
