/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_alsointerest_info
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
create table ${iol_schema}.icms_alsointerest_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_alsointerest_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_alsointerest_info_op purge;
drop table ${iol_schema}.icms_alsointerest_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_alsointerest_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_alsointerest_info where 0=1;

create table ${iol_schema}.icms_alsointerest_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_alsointerest_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_alsointerest_info_cl(
            serialno -- 流水号
            ,duebillserialno -- 借据号
            ,paymentsum -- 还款金额
            ,dateno -- 期号
            ,insttg -- 利息类别
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,alsointerestsum -- 还息金额
            ,loansq -- 序号
            ,paymentsubaccountno -- 还款子户号
            ,signuptype -- 签约类型
            ,paymentaccountno -- 还款账号
            ,alsointerestdate -- 还息日期
            ,pdtmno -- 产生利息的本金所属期数
            ,alsointerestno -- 序号
            ,businesscurrency -- 币种
            ,pdlnsq -- 产生利息的本金余额序号
            ,interesttype -- 利息种类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_alsointerest_info_op(
            serialno -- 流水号
            ,duebillserialno -- 借据号
            ,paymentsum -- 还款金额
            ,dateno -- 期号
            ,insttg -- 利息类别
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,alsointerestsum -- 还息金额
            ,loansq -- 序号
            ,paymentsubaccountno -- 还款子户号
            ,signuptype -- 签约类型
            ,paymentaccountno -- 还款账号
            ,alsointerestdate -- 还息日期
            ,pdtmno -- 产生利息的本金所属期数
            ,alsointerestno -- 序号
            ,businesscurrency -- 币种
            ,pdlnsq -- 产生利息的本金余额序号
            ,interesttype -- 利息种类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.duebillserialno, o.duebillserialno) as duebillserialno -- 借据号
    ,nvl(n.paymentsum, o.paymentsum) as paymentsum -- 还款金额
    ,nvl(n.dateno, o.dateno) as dateno -- 期号
    ,nvl(n.insttg, o.insttg) as insttg -- 利息类别
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.alsointerestsum, o.alsointerestsum) as alsointerestsum -- 还息金额
    ,nvl(n.loansq, o.loansq) as loansq -- 序号
    ,nvl(n.paymentsubaccountno, o.paymentsubaccountno) as paymentsubaccountno -- 还款子户号
    ,nvl(n.signuptype, o.signuptype) as signuptype -- 签约类型
    ,nvl(n.paymentaccountno, o.paymentaccountno) as paymentaccountno -- 还款账号
    ,nvl(n.alsointerestdate, o.alsointerestdate) as alsointerestdate -- 还息日期
    ,nvl(n.pdtmno, o.pdtmno) as pdtmno -- 产生利息的本金所属期数
    ,nvl(n.alsointerestno, o.alsointerestno) as alsointerestno -- 序号
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 币种
    ,nvl(n.pdlnsq, o.pdlnsq) as pdlnsq -- 产生利息的本金余额序号
    ,nvl(n.interesttype, o.interesttype) as interesttype -- 利息种类
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
from (select * from ${iol_schema}.icms_alsointerest_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_alsointerest_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.duebillserialno <> n.duebillserialno
        or o.paymentsum <> n.paymentsum
        or o.dateno <> n.dateno
        or o.insttg <> n.insttg
        or o.migtflag <> n.migtflag
        or o.alsointerestsum <> n.alsointerestsum
        or o.loansq <> n.loansq
        or o.paymentsubaccountno <> n.paymentsubaccountno
        or o.signuptype <> n.signuptype
        or o.paymentaccountno <> n.paymentaccountno
        or o.alsointerestdate <> n.alsointerestdate
        or o.pdtmno <> n.pdtmno
        or o.alsointerestno <> n.alsointerestno
        or o.businesscurrency <> n.businesscurrency
        or o.pdlnsq <> n.pdlnsq
        or o.interesttype <> n.interesttype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_alsointerest_info_cl(
            serialno -- 流水号
            ,duebillserialno -- 借据号
            ,paymentsum -- 还款金额
            ,dateno -- 期号
            ,insttg -- 利息类别
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,alsointerestsum -- 还息金额
            ,loansq -- 序号
            ,paymentsubaccountno -- 还款子户号
            ,signuptype -- 签约类型
            ,paymentaccountno -- 还款账号
            ,alsointerestdate -- 还息日期
            ,pdtmno -- 产生利息的本金所属期数
            ,alsointerestno -- 序号
            ,businesscurrency -- 币种
            ,pdlnsq -- 产生利息的本金余额序号
            ,interesttype -- 利息种类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_alsointerest_info_op(
            serialno -- 流水号
            ,duebillserialno -- 借据号
            ,paymentsum -- 还款金额
            ,dateno -- 期号
            ,insttg -- 利息类别
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,alsointerestsum -- 还息金额
            ,loansq -- 序号
            ,paymentsubaccountno -- 还款子户号
            ,signuptype -- 签约类型
            ,paymentaccountno -- 还款账号
            ,alsointerestdate -- 还息日期
            ,pdtmno -- 产生利息的本金所属期数
            ,alsointerestno -- 序号
            ,businesscurrency -- 币种
            ,pdlnsq -- 产生利息的本金余额序号
            ,interesttype -- 利息种类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.duebillserialno -- 借据号
    ,o.paymentsum -- 还款金额
    ,o.dateno -- 期号
    ,o.insttg -- 利息类别
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.alsointerestsum -- 还息金额
    ,o.loansq -- 序号
    ,o.paymentsubaccountno -- 还款子户号
    ,o.signuptype -- 签约类型
    ,o.paymentaccountno -- 还款账号
    ,o.alsointerestdate -- 还息日期
    ,o.pdtmno -- 产生利息的本金所属期数
    ,o.alsointerestno -- 序号
    ,o.businesscurrency -- 币种
    ,o.pdlnsq -- 产生利息的本金余额序号
    ,o.interesttype -- 利息种类
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
from ${iol_schema}.icms_alsointerest_info_bk o
    left join ${iol_schema}.icms_alsointerest_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_alsointerest_info_cl d
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
--truncate table ${iol_schema}.icms_alsointerest_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_alsointerest_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_alsointerest_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_alsointerest_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_alsointerest_info exchange partition p_${batch_date} with table ${iol_schema}.icms_alsointerest_info_cl;
alter table ${iol_schema}.icms_alsointerest_info exchange partition p_20991231 with table ${iol_schema}.icms_alsointerest_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_alsointerest_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_alsointerest_info_op purge;
drop table ${iol_schema}.icms_alsointerest_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_alsointerest_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_alsointerest_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
