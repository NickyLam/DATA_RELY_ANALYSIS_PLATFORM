/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bp_extend_t
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
create table ${iol_schema}.icms_bp_extend_t_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bp_extend_t
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bp_extend_t_op purge;
drop table ${iol_schema}.icms_bp_extend_t_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bp_extend_t_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bp_extend_t where 0=1;

create table ${iol_schema}.icms_bp_extend_t_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bp_extend_t where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bp_extend_t_cl(
            serialno -- 出账流水号
            ,paybacktimestype -- 还款次数类型
            ,migtflag -- 
            ,iccyc -- 计息周期
            ,aboutbankid -- 收款账户账号
            ,fundsource -- 资金来源
            ,lprtype -- LPR参照方式
            ,ret_msg -- 开户行地址
            ,acceptorbankname -- 开户行名称
            ,financier -- 实际融资人编号
            ,clearingtype -- 开户行类别
            ,principalaccountname -- 划款账户名称
            ,principalbankname -- 划款账户开户行名称
            ,adjustratedate -- 利率调整日
            ,acceptorbankno -- 开户行行号
            ,gatheringname -- 收款账户名称
            ,principalaccountno -- 划款账号
            ,accountcatagory -- 账户类别AccountCatagory
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bp_extend_t_op(
            serialno -- 出账流水号
            ,paybacktimestype -- 还款次数类型
            ,migtflag -- 
            ,iccyc -- 计息周期
            ,aboutbankid -- 收款账户账号
            ,fundsource -- 资金来源
            ,lprtype -- LPR参照方式
            ,ret_msg -- 开户行地址
            ,acceptorbankname -- 开户行名称
            ,financier -- 实际融资人编号
            ,clearingtype -- 开户行类别
            ,principalaccountname -- 划款账户名称
            ,principalbankname -- 划款账户开户行名称
            ,adjustratedate -- 利率调整日
            ,acceptorbankno -- 开户行行号
            ,gatheringname -- 收款账户名称
            ,principalaccountno -- 划款账号
            ,accountcatagory -- 账户类别AccountCatagory
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 出账流水号
    ,nvl(n.paybacktimestype, o.paybacktimestype) as paybacktimestype -- 还款次数类型
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.iccyc, o.iccyc) as iccyc -- 计息周期
    ,nvl(n.aboutbankid, o.aboutbankid) as aboutbankid -- 收款账户账号
    ,nvl(n.fundsource, o.fundsource) as fundsource -- 资金来源
    ,nvl(n.lprtype, o.lprtype) as lprtype -- LPR参照方式
    ,nvl(n.ret_msg, o.ret_msg) as ret_msg -- 开户行地址
    ,nvl(n.acceptorbankname, o.acceptorbankname) as acceptorbankname -- 开户行名称
    ,nvl(n.financier, o.financier) as financier -- 实际融资人编号
    ,nvl(n.clearingtype, o.clearingtype) as clearingtype -- 开户行类别
    ,nvl(n.principalaccountname, o.principalaccountname) as principalaccountname -- 划款账户名称
    ,nvl(n.principalbankname, o.principalbankname) as principalbankname -- 划款账户开户行名称
    ,nvl(n.adjustratedate, o.adjustratedate) as adjustratedate -- 利率调整日
    ,nvl(n.acceptorbankno, o.acceptorbankno) as acceptorbankno -- 开户行行号
    ,nvl(n.gatheringname, o.gatheringname) as gatheringname -- 收款账户名称
    ,nvl(n.principalaccountno, o.principalaccountno) as principalaccountno -- 划款账号
    ,nvl(n.accountcatagory, o.accountcatagory) as accountcatagory -- 账户类别AccountCatagory
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
from (select * from ${iol_schema}.icms_bp_extend_t_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bp_extend_t where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.paybacktimestype <> n.paybacktimestype
        or o.migtflag <> n.migtflag
        or o.iccyc <> n.iccyc
        or o.aboutbankid <> n.aboutbankid
        or o.fundsource <> n.fundsource
        or o.lprtype <> n.lprtype
        or o.ret_msg <> n.ret_msg
        or o.acceptorbankname <> n.acceptorbankname
        or o.financier <> n.financier
        or o.clearingtype <> n.clearingtype
        or o.principalaccountname <> n.principalaccountname
        or o.principalbankname <> n.principalbankname
        or o.adjustratedate <> n.adjustratedate
        or o.acceptorbankno <> n.acceptorbankno
        or o.gatheringname <> n.gatheringname
        or o.principalaccountno <> n.principalaccountno
        or o.accountcatagory <> n.accountcatagory
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bp_extend_t_cl(
            serialno -- 出账流水号
            ,paybacktimestype -- 还款次数类型
            ,migtflag -- 
            ,iccyc -- 计息周期
            ,aboutbankid -- 收款账户账号
            ,fundsource -- 资金来源
            ,lprtype -- LPR参照方式
            ,ret_msg -- 开户行地址
            ,acceptorbankname -- 开户行名称
            ,financier -- 实际融资人编号
            ,clearingtype -- 开户行类别
            ,principalaccountname -- 划款账户名称
            ,principalbankname -- 划款账户开户行名称
            ,adjustratedate -- 利率调整日
            ,acceptorbankno -- 开户行行号
            ,gatheringname -- 收款账户名称
            ,principalaccountno -- 划款账号
            ,accountcatagory -- 账户类别AccountCatagory
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bp_extend_t_op(
            serialno -- 出账流水号
            ,paybacktimestype -- 还款次数类型
            ,migtflag -- 
            ,iccyc -- 计息周期
            ,aboutbankid -- 收款账户账号
            ,fundsource -- 资金来源
            ,lprtype -- LPR参照方式
            ,ret_msg -- 开户行地址
            ,acceptorbankname -- 开户行名称
            ,financier -- 实际融资人编号
            ,clearingtype -- 开户行类别
            ,principalaccountname -- 划款账户名称
            ,principalbankname -- 划款账户开户行名称
            ,adjustratedate -- 利率调整日
            ,acceptorbankno -- 开户行行号
            ,gatheringname -- 收款账户名称
            ,principalaccountno -- 划款账号
            ,accountcatagory -- 账户类别AccountCatagory
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 出账流水号
    ,o.paybacktimestype -- 还款次数类型
    ,o.migtflag -- 
    ,o.iccyc -- 计息周期
    ,o.aboutbankid -- 收款账户账号
    ,o.fundsource -- 资金来源
    ,o.lprtype -- LPR参照方式
    ,o.ret_msg -- 开户行地址
    ,o.acceptorbankname -- 开户行名称
    ,o.financier -- 实际融资人编号
    ,o.clearingtype -- 开户行类别
    ,o.principalaccountname -- 划款账户名称
    ,o.principalbankname -- 划款账户开户行名称
    ,o.adjustratedate -- 利率调整日
    ,o.acceptorbankno -- 开户行行号
    ,o.gatheringname -- 收款账户名称
    ,o.principalaccountno -- 划款账号
    ,o.accountcatagory -- 账户类别AccountCatagory
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
from ${iol_schema}.icms_bp_extend_t_bk o
    left join ${iol_schema}.icms_bp_extend_t_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bp_extend_t_cl d
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
--truncate table ${iol_schema}.icms_bp_extend_t;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bp_extend_t') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bp_extend_t drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bp_extend_t add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bp_extend_t exchange partition p_${batch_date} with table ${iol_schema}.icms_bp_extend_t_cl;
alter table ${iol_schema}.icms_bp_extend_t exchange partition p_20991231 with table ${iol_schema}.icms_bp_extend_t_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bp_extend_t to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bp_extend_t_op purge;
drop table ${iol_schema}.icms_bp_extend_t_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bp_extend_t_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bp_extend_t',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
