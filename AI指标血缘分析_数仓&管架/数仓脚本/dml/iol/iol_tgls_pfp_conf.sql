/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_pfp_conf
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
create table ${iol_schema}.tgls_pfp_conf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_pfp_conf
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_pfp_conf_op purge;
drop table ${iol_schema}.tgls_pfp_conf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_pfp_conf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_pfp_conf where 0=1;

create table ${iol_schema}.tgls_pfp_conf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_pfp_conf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_pfp_conf_cl(
            stacid -- 账套
            ,brchcd -- 处理对象
            ,orderi -- 结转顺序
            ,tobrch -- 对方机构编号
            ,totype -- 0：损益上划1：损益结转2：本年利润转为未分配利润a：损益上划结转b：本年利润上划c：未分配利润上划
            ,brchit -- 被上划机构的中间科目编号（清算科目）
            ,clbrit -- 上划机构的中间科目编号（清算科目）
            ,smrytx -- 备注
            ,acctmd -- 记账方式
            ,usditem -- 套汇美元外汇买卖科目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_pfp_conf_op(
            stacid -- 账套
            ,brchcd -- 处理对象
            ,orderi -- 结转顺序
            ,tobrch -- 对方机构编号
            ,totype -- 0：损益上划1：损益结转2：本年利润转为未分配利润a：损益上划结转b：本年利润上划c：未分配利润上划
            ,brchit -- 被上划机构的中间科目编号（清算科目）
            ,clbrit -- 上划机构的中间科目编号（清算科目）
            ,smrytx -- 备注
            ,acctmd -- 记账方式
            ,usditem -- 套汇美元外汇买卖科目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.brchcd, o.brchcd) as brchcd -- 处理对象
    ,nvl(n.orderi, o.orderi) as orderi -- 结转顺序
    ,nvl(n.tobrch, o.tobrch) as tobrch -- 对方机构编号
    ,nvl(n.totype, o.totype) as totype -- 0：损益上划1：损益结转2：本年利润转为未分配利润a：损益上划结转b：本年利润上划c：未分配利润上划
    ,nvl(n.brchit, o.brchit) as brchit -- 被上划机构的中间科目编号（清算科目）
    ,nvl(n.clbrit, o.clbrit) as clbrit -- 上划机构的中间科目编号（清算科目）
    ,nvl(n.smrytx, o.smrytx) as smrytx -- 备注
    ,nvl(n.acctmd, o.acctmd) as acctmd -- 记账方式
    ,nvl(n.usditem, o.usditem) as usditem -- 套汇美元外汇买卖科目编号
    ,case when
            n.stacid is null
            and n.brchcd is null
            and n.orderi is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.brchcd is null
            and n.orderi is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.brchcd is null
            and n.orderi is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_pfp_conf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_pfp_conf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.brchcd = n.brchcd
            and o.orderi = n.orderi
where (
        o.stacid is null
        and o.brchcd is null
        and o.orderi is null
    )
    or (
        n.stacid is null
        and n.brchcd is null
        and n.orderi is null
    )
    or (
        o.tobrch <> n.tobrch
        or o.totype <> n.totype
        or o.brchit <> n.brchit
        or o.clbrit <> n.clbrit
        or o.smrytx <> n.smrytx
        or o.acctmd <> n.acctmd
        or o.usditem <> n.usditem
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_pfp_conf_cl(
            stacid -- 账套
            ,brchcd -- 处理对象
            ,orderi -- 结转顺序
            ,tobrch -- 对方机构编号
            ,totype -- 0：损益上划1：损益结转2：本年利润转为未分配利润a：损益上划结转b：本年利润上划c：未分配利润上划
            ,brchit -- 被上划机构的中间科目编号（清算科目）
            ,clbrit -- 上划机构的中间科目编号（清算科目）
            ,smrytx -- 备注
            ,acctmd -- 记账方式
            ,usditem -- 套汇美元外汇买卖科目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_pfp_conf_op(
            stacid -- 账套
            ,brchcd -- 处理对象
            ,orderi -- 结转顺序
            ,tobrch -- 对方机构编号
            ,totype -- 0：损益上划1：损益结转2：本年利润转为未分配利润a：损益上划结转b：本年利润上划c：未分配利润上划
            ,brchit -- 被上划机构的中间科目编号（清算科目）
            ,clbrit -- 上划机构的中间科目编号（清算科目）
            ,smrytx -- 备注
            ,acctmd -- 记账方式
            ,usditem -- 套汇美元外汇买卖科目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套
    ,o.brchcd -- 处理对象
    ,o.orderi -- 结转顺序
    ,o.tobrch -- 对方机构编号
    ,o.totype -- 0：损益上划1：损益结转2：本年利润转为未分配利润a：损益上划结转b：本年利润上划c：未分配利润上划
    ,o.brchit -- 被上划机构的中间科目编号（清算科目）
    ,o.clbrit -- 上划机构的中间科目编号（清算科目）
    ,o.smrytx -- 备注
    ,o.acctmd -- 记账方式
    ,o.usditem -- 套汇美元外汇买卖科目编号
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
from ${iol_schema}.tgls_pfp_conf_bk o
    left join ${iol_schema}.tgls_pfp_conf_op n
        on
            o.stacid = n.stacid
            and o.brchcd = n.brchcd
            and o.orderi = n.orderi
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_pfp_conf_cl d
        on
            o.stacid = d.stacid
            and o.brchcd = d.brchcd
            and o.orderi = d.orderi
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_pfp_conf;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_pfp_conf') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_pfp_conf drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_pfp_conf add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_pfp_conf exchange partition p_${batch_date} with table ${iol_schema}.tgls_pfp_conf_cl;
alter table ${iol_schema}.tgls_pfp_conf exchange partition p_20991231 with table ${iol_schema}.tgls_pfp_conf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_pfp_conf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_pfp_conf_op purge;
drop table ${iol_schema}.tgls_pfp_conf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_pfp_conf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_pfp_conf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
