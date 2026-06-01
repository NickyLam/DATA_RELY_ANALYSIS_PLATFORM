/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_jjxx
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
create table ${iol_schema}.pams_jxdx_jjxx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_jjxx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_jjxx_op purge;
drop table ${iol_schema}.pams_jxdx_jjxx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_jjxx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_jjxx where 0=1;

create table ${iol_schema}.pams_jxdx_jjxx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_jjxx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_jjxx_cl(
            jxdxdh -- 考核对象代号
            ,khh -- 客户号
            ,cpdm -- 产品代码
            ,cpsx -- 产品属性
            ,tadm -- TA代码
            ,bzcpdm -- 标准产品代码
            ,jyzh -- 交易账户
            ,jgdh -- 机构代号
            ,fhfs -- 分红方式
            ,zhbs -- 账户标识
            ,zhdhrq -- 最后动户日期
            ,tjrq -- 统计日期
            ,fe -- 份额
            ,jz -- 净值
            ,zhye -- 账户余额
            ,ztbz -- 在途基金标识：1-在途，0-非在途
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_jjxx_op(
            jxdxdh -- 考核对象代号
            ,khh -- 客户号
            ,cpdm -- 产品代码
            ,cpsx -- 产品属性
            ,tadm -- TA代码
            ,bzcpdm -- 标准产品代码
            ,jyzh -- 交易账户
            ,jgdh -- 机构代号
            ,fhfs -- 分红方式
            ,zhbs -- 账户标识
            ,zhdhrq -- 最后动户日期
            ,tjrq -- 统计日期
            ,fe -- 份额
            ,jz -- 净值
            ,zhye -- 账户余额
            ,ztbz -- 在途基金标识：1-在途，0-非在途
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 考核对象代号
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.cpdm, o.cpdm) as cpdm -- 产品代码
    ,nvl(n.cpsx, o.cpsx) as cpsx -- 产品属性
    ,nvl(n.tadm, o.tadm) as tadm -- TA代码
    ,nvl(n.bzcpdm, o.bzcpdm) as bzcpdm -- 标准产品代码
    ,nvl(n.jyzh, o.jyzh) as jyzh -- 交易账户
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 机构代号
    ,nvl(n.fhfs, o.fhfs) as fhfs -- 分红方式
    ,nvl(n.zhbs, o.zhbs) as zhbs -- 账户标识
    ,nvl(n.zhdhrq, o.zhdhrq) as zhdhrq -- 最后动户日期
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.fe, o.fe) as fe -- 份额
    ,nvl(n.jz, o.jz) as jz -- 净值
    ,nvl(n.zhye, o.zhye) as zhye -- 账户余额
    ,nvl(n.ztbz, o.ztbz) as ztbz -- 在途基金标识：1-在途，0-非在途
    ,case when
            n.jxdxdh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.jxdxdh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.jxdxdh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_jxdx_jjxx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_jjxx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
where (
        o.jxdxdh is null
    )
    or (
        n.jxdxdh is null
    )
    or (
        o.khh <> n.khh
        or o.cpdm <> n.cpdm
        or o.cpsx <> n.cpsx
        or o.tadm <> n.tadm
        or o.bzcpdm <> n.bzcpdm
        or o.jyzh <> n.jyzh
        or o.jgdh <> n.jgdh
        or o.fhfs <> n.fhfs
        or o.zhbs <> n.zhbs
        or o.zhdhrq <> n.zhdhrq
        or o.tjrq <> n.tjrq
        or o.fe <> n.fe
        or o.jz <> n.jz
        or o.zhye <> n.zhye
        or o.ztbz <> n.ztbz
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_jjxx_cl(
            jxdxdh -- 考核对象代号
            ,khh -- 客户号
            ,cpdm -- 产品代码
            ,cpsx -- 产品属性
            ,tadm -- TA代码
            ,bzcpdm -- 标准产品代码
            ,jyzh -- 交易账户
            ,jgdh -- 机构代号
            ,fhfs -- 分红方式
            ,zhbs -- 账户标识
            ,zhdhrq -- 最后动户日期
            ,tjrq -- 统计日期
            ,fe -- 份额
            ,jz -- 净值
            ,zhye -- 账户余额
            ,ztbz -- 在途基金标识：1-在途，0-非在途
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_jjxx_op(
            jxdxdh -- 考核对象代号
            ,khh -- 客户号
            ,cpdm -- 产品代码
            ,cpsx -- 产品属性
            ,tadm -- TA代码
            ,bzcpdm -- 标准产品代码
            ,jyzh -- 交易账户
            ,jgdh -- 机构代号
            ,fhfs -- 分红方式
            ,zhbs -- 账户标识
            ,zhdhrq -- 最后动户日期
            ,tjrq -- 统计日期
            ,fe -- 份额
            ,jz -- 净值
            ,zhye -- 账户余额
            ,ztbz -- 在途基金标识：1-在途，0-非在途
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 考核对象代号
    ,o.khh -- 客户号
    ,o.cpdm -- 产品代码
    ,o.cpsx -- 产品属性
    ,o.tadm -- TA代码
    ,o.bzcpdm -- 标准产品代码
    ,o.jyzh -- 交易账户
    ,o.jgdh -- 机构代号
    ,o.fhfs -- 分红方式
    ,o.zhbs -- 账户标识
    ,o.zhdhrq -- 最后动户日期
    ,o.tjrq -- 统计日期
    ,o.fe -- 份额
    ,o.jz -- 净值
    ,o.zhye -- 账户余额
    ,o.ztbz -- 在途基金标识：1-在途，0-非在途
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
from ${iol_schema}.pams_jxdx_jjxx_bk o
    left join ${iol_schema}.pams_jxdx_jjxx_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_jjxx_cl d
        on
            o.jxdxdh = d.jxdxdh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_jxdx_jjxx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_jjxx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_jjxx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_jjxx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_jjxx exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_jjxx_cl;
alter table ${iol_schema}.pams_jxdx_jjxx exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_jjxx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_jjxx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_jjxx_op purge;
drop table ${iol_schema}.pams_jxdx_jjxx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_jjxx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_jjxx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
