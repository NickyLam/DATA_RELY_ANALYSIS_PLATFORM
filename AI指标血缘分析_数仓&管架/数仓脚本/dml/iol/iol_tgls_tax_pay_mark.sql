/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_tax_pay_mark
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
create table ${iol_schema}.tgls_tax_pay_mark_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_tax_pay_mark
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_pay_mark_op purge;
drop table ${iol_schema}.tgls_tax_pay_mark_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_pay_mark_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_pay_mark where 0=1;

create table ${iol_schema}.tgls_tax_pay_mark_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_tax_pay_mark where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_pay_mark_cl(
            stacid -- 账套
            ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
            ,deptcdbf -- 上划前机构编号
            ,deptcdaf -- 上划后机构编号
            ,smrytx -- 备注
            ,status -- 是否允许同步0-否,1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_pay_mark_op(
            stacid -- 账套
            ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
            ,deptcdbf -- 上划前机构编号
            ,deptcdaf -- 上划后机构编号
            ,smrytx -- 备注
            ,status -- 是否允许同步0-否,1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.taxcode, o.taxcode) as taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,nvl(n.deptcdbf, o.deptcdbf) as deptcdbf -- 上划前机构编号
    ,nvl(n.deptcdaf, o.deptcdaf) as deptcdaf -- 上划后机构编号
    ,nvl(n.smrytx, o.smrytx) as smrytx -- 备注
    ,nvl(n.status, o.status) as status -- 是否允许同步0-否,1-是
    ,case when
            n.stacid is null
            and n.taxcode is null
            and n.deptcdbf is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.taxcode is null
            and n.deptcdbf is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.taxcode is null
            and n.deptcdbf is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_tax_pay_mark_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_tax_pay_mark where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.taxcode = n.taxcode
            and o.deptcdbf = n.deptcdbf
where (
        o.stacid is null
        and o.taxcode is null
        and o.deptcdbf is null
    )
    or (
        n.stacid is null
        and n.taxcode is null
        and n.deptcdbf is null
    )
    or (
        o.deptcdaf <> n.deptcdaf
        or o.smrytx <> n.smrytx
        or o.status <> n.status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_tax_pay_mark_cl(
            stacid -- 账套
            ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
            ,deptcdbf -- 上划前机构编号
            ,deptcdaf -- 上划后机构编号
            ,smrytx -- 备注
            ,status -- 是否允许同步0-否,1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_tax_pay_mark_op(
            stacid -- 账套
            ,taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
            ,deptcdbf -- 上划前机构编号
            ,deptcdaf -- 上划后机构编号
            ,smrytx -- 备注
            ,status -- 是否允许同步0-否,1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套
    ,o.taxcode -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,o.deptcdbf -- 上划前机构编号
    ,o.deptcdaf -- 上划后机构编号
    ,o.smrytx -- 备注
    ,o.status -- 是否允许同步0-否,1-是
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
from ${iol_schema}.tgls_tax_pay_mark_bk o
    left join ${iol_schema}.tgls_tax_pay_mark_op n
        on
            o.stacid = n.stacid
            and o.taxcode = n.taxcode
            and o.deptcdbf = n.deptcdbf
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_tax_pay_mark_cl d
        on
            o.stacid = d.stacid
            and o.taxcode = d.taxcode
            and o.deptcdbf = d.deptcdbf
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_tax_pay_mark;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_tax_pay_mark') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_tax_pay_mark drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_tax_pay_mark add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_tax_pay_mark exchange partition p_${batch_date} with table ${iol_schema}.tgls_tax_pay_mark_cl;
alter table ${iol_schema}.tgls_tax_pay_mark exchange partition p_20991231 with table ${iol_schema}.tgls_tax_pay_mark_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_tax_pay_mark to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_tax_pay_mark_op purge;
drop table ${iol_schema}.tgls_tax_pay_mark_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_tax_pay_mark_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_tax_pay_mark',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
