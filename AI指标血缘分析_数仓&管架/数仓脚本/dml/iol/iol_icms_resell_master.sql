/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_resell_master
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
create table ${iol_schema}.icms_resell_master_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_resell_master
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_resell_master_op purge;
drop table ${iol_schema}.icms_resell_master_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_resell_master_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_resell_master where 0=1;

create table ${iol_schema}.icms_resell_master_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_resell_master where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_resell_master_cl(
            serialno -- 流水号
            ,resellduebillbalancesum -- 转卖借据金额汇总
            ,inputdate -- 申请时间
            ,tradecustomer -- 交易对手
            ,reselltype -- 境内转让、行内转让、跨境转让
            ,payaccountno -- 收款账号
            ,applyexpain -- 转让说明
            ,duebillcount -- 借据笔数
            ,inputuserid -- 申请人
            ,businesstype -- 业务品种
            ,inputorgid -- 申请机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,resellboughtsum -- 转卖收款金额汇总
            ,tradecustomerid -- 交易对手编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_resell_master_op(
            serialno -- 流水号
            ,resellduebillbalancesum -- 转卖借据金额汇总
            ,inputdate -- 申请时间
            ,tradecustomer -- 交易对手
            ,reselltype -- 境内转让、行内转让、跨境转让
            ,payaccountno -- 收款账号
            ,applyexpain -- 转让说明
            ,duebillcount -- 借据笔数
            ,inputuserid -- 申请人
            ,businesstype -- 业务品种
            ,inputorgid -- 申请机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,resellboughtsum -- 转卖收款金额汇总
            ,tradecustomerid -- 交易对手编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.resellduebillbalancesum, o.resellduebillbalancesum) as resellduebillbalancesum -- 转卖借据金额汇总
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 申请时间
    ,nvl(n.tradecustomer, o.tradecustomer) as tradecustomer -- 交易对手
    ,nvl(n.reselltype, o.reselltype) as reselltype -- 境内转让、行内转让、跨境转让
    ,nvl(n.payaccountno, o.payaccountno) as payaccountno -- 收款账号
    ,nvl(n.applyexpain, o.applyexpain) as applyexpain -- 转让说明
    ,nvl(n.duebillcount, o.duebillcount) as duebillcount -- 借据笔数
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 申请人
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务品种
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 申请机构
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.resellboughtsum, o.resellboughtsum) as resellboughtsum -- 转卖收款金额汇总
    ,nvl(n.tradecustomerid, o.tradecustomerid) as tradecustomerid -- 交易对手编号
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
from (select * from ${iol_schema}.icms_resell_master_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_resell_master where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.resellduebillbalancesum <> n.resellduebillbalancesum
        or o.inputdate <> n.inputdate
        or o.tradecustomer <> n.tradecustomer
        or o.reselltype <> n.reselltype
        or o.payaccountno <> n.payaccountno
        or o.applyexpain <> n.applyexpain
        or o.duebillcount <> n.duebillcount
        or o.inputuserid <> n.inputuserid
        or o.businesstype <> n.businesstype
        or o.inputorgid <> n.inputorgid
        or o.migtflag <> n.migtflag
        or o.resellboughtsum <> n.resellboughtsum
        or o.tradecustomerid <> n.tradecustomerid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_resell_master_cl(
            serialno -- 流水号
            ,resellduebillbalancesum -- 转卖借据金额汇总
            ,inputdate -- 申请时间
            ,tradecustomer -- 交易对手
            ,reselltype -- 境内转让、行内转让、跨境转让
            ,payaccountno -- 收款账号
            ,applyexpain -- 转让说明
            ,duebillcount -- 借据笔数
            ,inputuserid -- 申请人
            ,businesstype -- 业务品种
            ,inputorgid -- 申请机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,resellboughtsum -- 转卖收款金额汇总
            ,tradecustomerid -- 交易对手编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_resell_master_op(
            serialno -- 流水号
            ,resellduebillbalancesum -- 转卖借据金额汇总
            ,inputdate -- 申请时间
            ,tradecustomer -- 交易对手
            ,reselltype -- 境内转让、行内转让、跨境转让
            ,payaccountno -- 收款账号
            ,applyexpain -- 转让说明
            ,duebillcount -- 借据笔数
            ,inputuserid -- 申请人
            ,businesstype -- 业务品种
            ,inputorgid -- 申请机构
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,resellboughtsum -- 转卖收款金额汇总
            ,tradecustomerid -- 交易对手编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.resellduebillbalancesum -- 转卖借据金额汇总
    ,o.inputdate -- 申请时间
    ,o.tradecustomer -- 交易对手
    ,o.reselltype -- 境内转让、行内转让、跨境转让
    ,o.payaccountno -- 收款账号
    ,o.applyexpain -- 转让说明
    ,o.duebillcount -- 借据笔数
    ,o.inputuserid -- 申请人
    ,o.businesstype -- 业务品种
    ,o.inputorgid -- 申请机构
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.resellboughtsum -- 转卖收款金额汇总
    ,o.tradecustomerid -- 交易对手编号
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
from ${iol_schema}.icms_resell_master_bk o
    left join ${iol_schema}.icms_resell_master_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_resell_master_cl d
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
--truncate table ${iol_schema}.icms_resell_master;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_resell_master') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_resell_master drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_resell_master add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_resell_master exchange partition p_${batch_date} with table ${iol_schema}.icms_resell_master_cl;
alter table ${iol_schema}.icms_resell_master exchange partition p_20991231 with table ${iol_schema}.icms_resell_master_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_resell_master to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_resell_master_op purge;
drop table ${iol_schema}.icms_resell_master_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_resell_master_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_resell_master',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
