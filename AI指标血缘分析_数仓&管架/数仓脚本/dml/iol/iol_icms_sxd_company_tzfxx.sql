/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_sxd_company_tzfxx
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
create table ${iol_schema}.icms_sxd_company_tzfxx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_sxd_company_tzfxx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sxd_company_tzfxx_op purge;
drop table ${iol_schema}.icms_sxd_company_tzfxx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_tzfxx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sxd_company_tzfxx where 0=1;

create table ${iol_schema}.icms_sxd_company_tzfxx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sxd_company_tzfxx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sxd_company_tzfxx_cl(
            id -- 主键
            ,yxqz -- 有效期止
            ,zjhm -- 证件号码
            ,zj_mc -- 证件类型
            ,tzje -- 投资金额
            ,yxqq -- 有效期起
            ,serno -- 业务流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,tzbl -- 投资比例
            ,tzfmc -- 投资方名称
            ,tzfjjxz_mc -- 投资方经济性质名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sxd_company_tzfxx_op(
            id -- 主键
            ,yxqz -- 有效期止
            ,zjhm -- 证件号码
            ,zj_mc -- 证件类型
            ,tzje -- 投资金额
            ,yxqq -- 有效期起
            ,serno -- 业务流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,tzbl -- 投资比例
            ,tzfmc -- 投资方名称
            ,tzfjjxz_mc -- 投资方经济性质名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.yxqz, o.yxqz) as yxqz -- 有效期止
    ,nvl(n.zjhm, o.zjhm) as zjhm -- 证件号码
    ,nvl(n.zj_mc, o.zj_mc) as zj_mc -- 证件类型
    ,nvl(n.tzje, o.tzje) as tzje -- 投资金额
    ,nvl(n.yxqq, o.yxqq) as yxqq -- 有效期起
    ,nvl(n.serno, o.serno) as serno -- 业务流水号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.tzbl, o.tzbl) as tzbl -- 投资比例
    ,nvl(n.tzfmc, o.tzfmc) as tzfmc -- 投资方名称
    ,nvl(n.tzfjjxz_mc, o.tzfjjxz_mc) as tzfjjxz_mc -- 投资方经济性质名称
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_sxd_company_tzfxx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_sxd_company_tzfxx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.yxqz <> n.yxqz
        or o.zjhm <> n.zjhm
        or o.zj_mc <> n.zj_mc
        or o.tzje <> n.tzje
        or o.yxqq <> n.yxqq
        or o.serno <> n.serno
        or o.migtflag <> n.migtflag
        or o.tzbl <> n.tzbl
        or o.tzfmc <> n.tzfmc
        or o.tzfjjxz_mc <> n.tzfjjxz_mc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sxd_company_tzfxx_cl(
            id -- 主键
            ,yxqz -- 有效期止
            ,zjhm -- 证件号码
            ,zj_mc -- 证件类型
            ,tzje -- 投资金额
            ,yxqq -- 有效期起
            ,serno -- 业务流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,tzbl -- 投资比例
            ,tzfmc -- 投资方名称
            ,tzfjjxz_mc -- 投资方经济性质名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sxd_company_tzfxx_op(
            id -- 主键
            ,yxqz -- 有效期止
            ,zjhm -- 证件号码
            ,zj_mc -- 证件类型
            ,tzje -- 投资金额
            ,yxqq -- 有效期起
            ,serno -- 业务流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,tzbl -- 投资比例
            ,tzfmc -- 投资方名称
            ,tzfjjxz_mc -- 投资方经济性质名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.yxqz -- 有效期止
    ,o.zjhm -- 证件号码
    ,o.zj_mc -- 证件类型
    ,o.tzje -- 投资金额
    ,o.yxqq -- 有效期起
    ,o.serno -- 业务流水号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.tzbl -- 投资比例
    ,o.tzfmc -- 投资方名称
    ,o.tzfjjxz_mc -- 投资方经济性质名称
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
from ${iol_schema}.icms_sxd_company_tzfxx_bk o
    left join ${iol_schema}.icms_sxd_company_tzfxx_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_sxd_company_tzfxx_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_sxd_company_tzfxx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_sxd_company_tzfxx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_sxd_company_tzfxx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_sxd_company_tzfxx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_sxd_company_tzfxx exchange partition p_${batch_date} with table ${iol_schema}.icms_sxd_company_tzfxx_cl;
alter table ${iol_schema}.icms_sxd_company_tzfxx exchange partition p_20991231 with table ${iol_schema}.icms_sxd_company_tzfxx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_sxd_company_tzfxx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sxd_company_tzfxx_op purge;
drop table ${iol_schema}.icms_sxd_company_tzfxx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_sxd_company_tzfxx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_sxd_company_tzfxx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
