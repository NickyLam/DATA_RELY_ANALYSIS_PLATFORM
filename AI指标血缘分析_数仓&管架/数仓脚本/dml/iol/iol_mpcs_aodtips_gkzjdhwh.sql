/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_aodtips_gkzjdhwh
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
create table ${iol_schema}.mpcs_aodtips_gkzjdhwh_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_aodtips_gkzjdhwh
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_aodtips_gkzjdhwh_op purge;
drop table ${iol_schema}.mpcs_aodtips_gkzjdhwh_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_aodtips_gkzjdhwh_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_aodtips_gkzjdhwh where 0=1;

create table ${iol_schema}.mpcs_aodtips_gkzjdhwh_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_aodtips_gkzjdhwh where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_aodtips_gkzjdhwh_cl(
            fundtype -- 资金类型
            ,payacc -- 付款人账号
            ,payname -- 付款人名称
            ,paybankacc -- 付款行行号
            ,paybankname -- 付款行行名
            ,proceedsacc -- 收款人账号
            ,proceedsname -- 收款人名称
            ,proceedsbankacc -- 收款行行号
            ,proceedsbankname -- 收款行行名
            ,postscriptcontent -- 附言
            ,teller_no -- 变更柜员
            ,brchno -- 变更机构
            ,adddata -- 变更日期
            ,addtime -- 变更时间
            ,fuyanmodel -- 附言模板
            ,fuyanshili -- 附言示例
            ,model -- 模板格式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_aodtips_gkzjdhwh_op(
            fundtype -- 资金类型
            ,payacc -- 付款人账号
            ,payname -- 付款人名称
            ,paybankacc -- 付款行行号
            ,paybankname -- 付款行行名
            ,proceedsacc -- 收款人账号
            ,proceedsname -- 收款人名称
            ,proceedsbankacc -- 收款行行号
            ,proceedsbankname -- 收款行行名
            ,postscriptcontent -- 附言
            ,teller_no -- 变更柜员
            ,brchno -- 变更机构
            ,adddata -- 变更日期
            ,addtime -- 变更时间
            ,fuyanmodel -- 附言模板
            ,fuyanshili -- 附言示例
            ,model -- 模板格式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fundtype, o.fundtype) as fundtype -- 资金类型
    ,nvl(n.payacc, o.payacc) as payacc -- 付款人账号
    ,nvl(n.payname, o.payname) as payname -- 付款人名称
    ,nvl(n.paybankacc, o.paybankacc) as paybankacc -- 付款行行号
    ,nvl(n.paybankname, o.paybankname) as paybankname -- 付款行行名
    ,nvl(n.proceedsacc, o.proceedsacc) as proceedsacc -- 收款人账号
    ,nvl(n.proceedsname, o.proceedsname) as proceedsname -- 收款人名称
    ,nvl(n.proceedsbankacc, o.proceedsbankacc) as proceedsbankacc -- 收款行行号
    ,nvl(n.proceedsbankname, o.proceedsbankname) as proceedsbankname -- 收款行行名
    ,nvl(n.postscriptcontent, o.postscriptcontent) as postscriptcontent -- 附言
    ,nvl(n.teller_no, o.teller_no) as teller_no -- 变更柜员
    ,nvl(n.brchno, o.brchno) as brchno -- 变更机构
    ,nvl(n.adddata, o.adddata) as adddata -- 变更日期
    ,nvl(n.addtime, o.addtime) as addtime -- 变更时间
    ,nvl(n.fuyanmodel, o.fuyanmodel) as fuyanmodel -- 附言模板
    ,nvl(n.fuyanshili, o.fuyanshili) as fuyanshili -- 附言示例
    ,nvl(n.model, o.model) as model -- 模板格式
    ,case when
            n.fundtype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fundtype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fundtype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_aodtips_gkzjdhwh_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_aodtips_gkzjdhwh where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fundtype = n.fundtype
where (
        o.fundtype is null
    )
    or (
        n.fundtype is null
    )
    or (
        o.payacc <> n.payacc
        or o.payname <> n.payname
        or o.paybankacc <> n.paybankacc
        or o.paybankname <> n.paybankname
        or o.proceedsacc <> n.proceedsacc
        or o.proceedsname <> n.proceedsname
        or o.proceedsbankacc <> n.proceedsbankacc
        or o.proceedsbankname <> n.proceedsbankname
        or o.postscriptcontent <> n.postscriptcontent
        or o.teller_no <> n.teller_no
        or o.brchno <> n.brchno
        or o.adddata <> n.adddata
        or o.addtime <> n.addtime
        or o.fuyanmodel <> n.fuyanmodel
        or o.fuyanshili <> n.fuyanshili
        or o.model <> n.model
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_aodtips_gkzjdhwh_cl(
            fundtype -- 资金类型
            ,payacc -- 付款人账号
            ,payname -- 付款人名称
            ,paybankacc -- 付款行行号
            ,paybankname -- 付款行行名
            ,proceedsacc -- 收款人账号
            ,proceedsname -- 收款人名称
            ,proceedsbankacc -- 收款行行号
            ,proceedsbankname -- 收款行行名
            ,postscriptcontent -- 附言
            ,teller_no -- 变更柜员
            ,brchno -- 变更机构
            ,adddata -- 变更日期
            ,addtime -- 变更时间
            ,fuyanmodel -- 附言模板
            ,fuyanshili -- 附言示例
            ,model -- 模板格式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_aodtips_gkzjdhwh_op(
            fundtype -- 资金类型
            ,payacc -- 付款人账号
            ,payname -- 付款人名称
            ,paybankacc -- 付款行行号
            ,paybankname -- 付款行行名
            ,proceedsacc -- 收款人账号
            ,proceedsname -- 收款人名称
            ,proceedsbankacc -- 收款行行号
            ,proceedsbankname -- 收款行行名
            ,postscriptcontent -- 附言
            ,teller_no -- 变更柜员
            ,brchno -- 变更机构
            ,adddata -- 变更日期
            ,addtime -- 变更时间
            ,fuyanmodel -- 附言模板
            ,fuyanshili -- 附言示例
            ,model -- 模板格式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fundtype -- 资金类型
    ,o.payacc -- 付款人账号
    ,o.payname -- 付款人名称
    ,o.paybankacc -- 付款行行号
    ,o.paybankname -- 付款行行名
    ,o.proceedsacc -- 收款人账号
    ,o.proceedsname -- 收款人名称
    ,o.proceedsbankacc -- 收款行行号
    ,o.proceedsbankname -- 收款行行名
    ,o.postscriptcontent -- 附言
    ,o.teller_no -- 变更柜员
    ,o.brchno -- 变更机构
    ,o.adddata -- 变更日期
    ,o.addtime -- 变更时间
    ,o.fuyanmodel -- 附言模板
    ,o.fuyanshili -- 附言示例
    ,o.model -- 模板格式
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
from ${iol_schema}.mpcs_aodtips_gkzjdhwh_bk o
    left join ${iol_schema}.mpcs_aodtips_gkzjdhwh_op n
        on
            o.fundtype = n.fundtype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_aodtips_gkzjdhwh_cl d
        on
            o.fundtype = d.fundtype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_aodtips_gkzjdhwh;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_aodtips_gkzjdhwh') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_aodtips_gkzjdhwh drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_aodtips_gkzjdhwh add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_aodtips_gkzjdhwh exchange partition p_${batch_date} with table ${iol_schema}.mpcs_aodtips_gkzjdhwh_cl;
alter table ${iol_schema}.mpcs_aodtips_gkzjdhwh exchange partition p_20991231 with table ${iol_schema}.mpcs_aodtips_gkzjdhwh_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_aodtips_gkzjdhwh to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_aodtips_gkzjdhwh_op purge;
drop table ${iol_schema}.mpcs_aodtips_gkzjdhwh_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_aodtips_gkzjdhwh_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_aodtips_gkzjdhwh',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
