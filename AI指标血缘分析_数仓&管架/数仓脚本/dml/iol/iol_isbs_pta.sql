/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_pta
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
create table ${iol_schema}.isbs_pta_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_pta;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_pta_op purge;
drop table ${iol_schema}.isbs_pta_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_pta_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_pta where 0=1;

create table ${iol_schema}.isbs_pta_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_pta where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_pta_cl(
            inr -- 内部唯一ID号
            ,ptyinr -- 联系实体INR
            ,nam -- 地址名
            ,pri -- 优先权
            ,eno -- 用户的外部ID
            ,objtyp -- 关联地址种类
            ,objinr -- 关联地址INR
            ,objkey -- 关联地址关键值
            ,usg -- 地址使用代码
            ,ver -- 版本号
            ,bic -- 地址BIC
            ,adrsta -- 地址状态
            ,ptytyp -- 客户类型
            ,ptyextkey -- 客户唯一键值
            ,tid -- 与TC通信时客户地址的唯一ID
            ,etgextkey -- 实体组唯一键值
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,nam1 -- 中文名称
            ,issbchinf -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_pta_op(
            inr -- 内部唯一ID号
            ,ptyinr -- 联系实体INR
            ,nam -- 地址名
            ,pri -- 优先权
            ,eno -- 用户的外部ID
            ,objtyp -- 关联地址种类
            ,objinr -- 关联地址INR
            ,objkey -- 关联地址关键值
            ,usg -- 地址使用代码
            ,ver -- 版本号
            ,bic -- 地址BIC
            ,adrsta -- 地址状态
            ,ptytyp -- 客户类型
            ,ptyextkey -- 客户唯一键值
            ,tid -- 与TC通信时客户地址的唯一ID
            ,etgextkey -- 实体组唯一键值
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,nam1 -- 中文名称
            ,issbchinf -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 内部唯一ID号
    ,nvl(n.ptyinr, o.ptyinr) as ptyinr -- 联系实体INR
    ,nvl(n.nam, o.nam) as nam -- 地址名
    ,nvl(n.pri, o.pri) as pri -- 优先权
    ,nvl(n.eno, o.eno) as eno -- 用户的外部ID
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 关联地址种类
    ,nvl(n.objinr, o.objinr) as objinr -- 关联地址INR
    ,nvl(n.objkey, o.objkey) as objkey -- 关联地址关键值
    ,nvl(n.usg, o.usg) as usg -- 地址使用代码
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.bic, o.bic) as bic -- 地址BIC
    ,nvl(n.adrsta, o.adrsta) as adrsta -- 地址状态
    ,nvl(n.ptytyp, o.ptytyp) as ptytyp -- 客户类型
    ,nvl(n.ptyextkey, o.ptyextkey) as ptyextkey -- 客户唯一键值
    ,nvl(n.tid, o.tid) as tid -- 与TC通信时客户地址的唯一ID
    ,nvl(n.etgextkey, o.etgextkey) as etgextkey -- 实体组唯一键值
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 所属机构号
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 经办机构号
    ,nvl(n.nam1, o.nam1) as nam1 -- 中文名称
    ,nvl(n.issbchinf, o.issbchinf) as issbchinf -- 
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_pta_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_pta where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.ptyinr <> n.ptyinr
        or o.nam <> n.nam
        or o.pri <> n.pri
        or o.eno <> n.eno
        or o.objtyp <> n.objtyp
        or o.objinr <> n.objinr
        or o.objkey <> n.objkey
        or o.usg <> n.usg
        or o.ver <> n.ver
        or o.bic <> n.bic
        or o.adrsta <> n.adrsta
        or o.ptytyp <> n.ptytyp
        or o.ptyextkey <> n.ptyextkey
        or o.tid <> n.tid
        or o.etgextkey <> n.etgextkey
        or o.branchinr <> n.branchinr
        or o.bchkeyinr <> n.bchkeyinr
        or o.nam1 <> n.nam1
        or o.issbchinf <> n.issbchinf
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_pta_cl(
            inr -- 内部唯一ID号
            ,ptyinr -- 联系实体INR
            ,nam -- 地址名
            ,pri -- 优先权
            ,eno -- 用户的外部ID
            ,objtyp -- 关联地址种类
            ,objinr -- 关联地址INR
            ,objkey -- 关联地址关键值
            ,usg -- 地址使用代码
            ,ver -- 版本号
            ,bic -- 地址BIC
            ,adrsta -- 地址状态
            ,ptytyp -- 客户类型
            ,ptyextkey -- 客户唯一键值
            ,tid -- 与TC通信时客户地址的唯一ID
            ,etgextkey -- 实体组唯一键值
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,nam1 -- 中文名称
            ,issbchinf -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_pta_op(
            inr -- 内部唯一ID号
            ,ptyinr -- 联系实体INR
            ,nam -- 地址名
            ,pri -- 优先权
            ,eno -- 用户的外部ID
            ,objtyp -- 关联地址种类
            ,objinr -- 关联地址INR
            ,objkey -- 关联地址关键值
            ,usg -- 地址使用代码
            ,ver -- 版本号
            ,bic -- 地址BIC
            ,adrsta -- 地址状态
            ,ptytyp -- 客户类型
            ,ptyextkey -- 客户唯一键值
            ,tid -- 与TC通信时客户地址的唯一ID
            ,etgextkey -- 实体组唯一键值
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,nam1 -- 中文名称
            ,issbchinf -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 内部唯一ID号
    ,o.ptyinr -- 联系实体INR
    ,o.nam -- 地址名
    ,o.pri -- 优先权
    ,o.eno -- 用户的外部ID
    ,o.objtyp -- 关联地址种类
    ,o.objinr -- 关联地址INR
    ,o.objkey -- 关联地址关键值
    ,o.usg -- 地址使用代码
    ,o.ver -- 版本号
    ,o.bic -- 地址BIC
    ,o.adrsta -- 地址状态
    ,o.ptytyp -- 客户类型
    ,o.ptyextkey -- 客户唯一键值
    ,o.tid -- 与TC通信时客户地址的唯一ID
    ,o.etgextkey -- 实体组唯一键值
    ,o.branchinr -- 所属机构号
    ,o.bchkeyinr -- 经办机构号
    ,o.nam1 -- 中文名称
    ,o.issbchinf -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_pta_bk o
    left join ${iol_schema}.isbs_pta_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_pta_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_pta;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_pta exchange partition p_19000101 with table ${iol_schema}.isbs_pta_cl;
alter table ${iol_schema}.isbs_pta exchange partition p_20991231 with table ${iol_schema}.isbs_pta_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_pta to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_pta_op purge;
drop table ${iol_schema}.isbs_pta_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_pta_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_pta',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
