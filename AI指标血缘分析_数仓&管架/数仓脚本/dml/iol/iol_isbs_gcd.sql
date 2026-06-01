/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_gcd
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
create table ${iol_schema}.isbs_gcd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_gcd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_gcd_op purge;
drop table ${iol_schema}.isbs_gcd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_gcd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_gcd where 0=1;

create table ${iol_schema}.isbs_gcd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_gcd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_gcd_cl(
            inr -- 保函内部ID号
            ,ownref -- 参考号
            ,pntinr -- 父保函INR
            ,pnttyp -- 保函交易类型
            ,nam -- 交易名称
            ,credat -- 创建日期
            ,clsdat -- 结束日期
            ,opndat -- 有效开始日期
            ,newexpdat -- 申请日期
            ,ownusr -- 负责人
            ,ver -- 版本号
            ,clmtyp -- 索赔种类
            ,clmctl -- 索赔类型
            ,clmdat -- 索赔日期
            ,cannowflg -- 取消保函下付款
            ,msgdat -- 拒接报文日期
            ,payrol -- 付款人
            ,docprbrol -- 承兑人
            ,etyextkey -- 实体合同
            ,frepayflg -- 免费方单标志
            ,bchkeyinr -- 业务经办行
            ,branchinr -- 业务所属行
            ,nraflg -- NRA标志
            ,qsqdbh -- 清算渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_gcd_op(
            inr -- 保函内部ID号
            ,ownref -- 参考号
            ,pntinr -- 父保函INR
            ,pnttyp -- 保函交易类型
            ,nam -- 交易名称
            ,credat -- 创建日期
            ,clsdat -- 结束日期
            ,opndat -- 有效开始日期
            ,newexpdat -- 申请日期
            ,ownusr -- 负责人
            ,ver -- 版本号
            ,clmtyp -- 索赔种类
            ,clmctl -- 索赔类型
            ,clmdat -- 索赔日期
            ,cannowflg -- 取消保函下付款
            ,msgdat -- 拒接报文日期
            ,payrol -- 付款人
            ,docprbrol -- 承兑人
            ,etyextkey -- 实体合同
            ,frepayflg -- 免费方单标志
            ,bchkeyinr -- 业务经办行
            ,branchinr -- 业务所属行
            ,nraflg -- NRA标志
            ,qsqdbh -- 清算渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 保函内部ID号
    ,nvl(n.ownref, o.ownref) as ownref -- 参考号
    ,nvl(n.pntinr, o.pntinr) as pntinr -- 父保函INR
    ,nvl(n.pnttyp, o.pnttyp) as pnttyp -- 保函交易类型
    ,nvl(n.nam, o.nam) as nam -- 交易名称
    ,nvl(n.credat, o.credat) as credat -- 创建日期
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 结束日期
    ,nvl(n.opndat, o.opndat) as opndat -- 有效开始日期
    ,nvl(n.newexpdat, o.newexpdat) as newexpdat -- 申请日期
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 负责人
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.clmtyp, o.clmtyp) as clmtyp -- 索赔种类
    ,nvl(n.clmctl, o.clmctl) as clmctl -- 索赔类型
    ,nvl(n.clmdat, o.clmdat) as clmdat -- 索赔日期
    ,nvl(n.cannowflg, o.cannowflg) as cannowflg -- 取消保函下付款
    ,nvl(n.msgdat, o.msgdat) as msgdat -- 拒接报文日期
    ,nvl(n.payrol, o.payrol) as payrol -- 付款人
    ,nvl(n.docprbrol, o.docprbrol) as docprbrol -- 承兑人
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 实体合同
    ,nvl(n.frepayflg, o.frepayflg) as frepayflg -- 免费方单标志
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 业务经办行
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 业务所属行
    ,nvl(n.nraflg, o.nraflg) as nraflg -- NRA标志
    ,nvl(n.qsqdbh, o.qsqdbh) as qsqdbh -- 清算渠道
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
from (select * from ${iol_schema}.isbs_gcd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_gcd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.ownref <> n.ownref
        or o.pntinr <> n.pntinr
        or o.pnttyp <> n.pnttyp
        or o.nam <> n.nam
        or o.credat <> n.credat
        or o.clsdat <> n.clsdat
        or o.opndat <> n.opndat
        or o.newexpdat <> n.newexpdat
        or o.ownusr <> n.ownusr
        or o.ver <> n.ver
        or o.clmtyp <> n.clmtyp
        or o.clmctl <> n.clmctl
        or o.clmdat <> n.clmdat
        or o.cannowflg <> n.cannowflg
        or o.msgdat <> n.msgdat
        or o.payrol <> n.payrol
        or o.docprbrol <> n.docprbrol
        or o.etyextkey <> n.etyextkey
        or o.frepayflg <> n.frepayflg
        or o.bchkeyinr <> n.bchkeyinr
        or o.branchinr <> n.branchinr
        or o.nraflg <> n.nraflg
        or o.qsqdbh <> n.qsqdbh
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_gcd_cl(
            inr -- 保函内部ID号
            ,ownref -- 参考号
            ,pntinr -- 父保函INR
            ,pnttyp -- 保函交易类型
            ,nam -- 交易名称
            ,credat -- 创建日期
            ,clsdat -- 结束日期
            ,opndat -- 有效开始日期
            ,newexpdat -- 申请日期
            ,ownusr -- 负责人
            ,ver -- 版本号
            ,clmtyp -- 索赔种类
            ,clmctl -- 索赔类型
            ,clmdat -- 索赔日期
            ,cannowflg -- 取消保函下付款
            ,msgdat -- 拒接报文日期
            ,payrol -- 付款人
            ,docprbrol -- 承兑人
            ,etyextkey -- 实体合同
            ,frepayflg -- 免费方单标志
            ,bchkeyinr -- 业务经办行
            ,branchinr -- 业务所属行
            ,nraflg -- NRA标志
            ,qsqdbh -- 清算渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_gcd_op(
            inr -- 保函内部ID号
            ,ownref -- 参考号
            ,pntinr -- 父保函INR
            ,pnttyp -- 保函交易类型
            ,nam -- 交易名称
            ,credat -- 创建日期
            ,clsdat -- 结束日期
            ,opndat -- 有效开始日期
            ,newexpdat -- 申请日期
            ,ownusr -- 负责人
            ,ver -- 版本号
            ,clmtyp -- 索赔种类
            ,clmctl -- 索赔类型
            ,clmdat -- 索赔日期
            ,cannowflg -- 取消保函下付款
            ,msgdat -- 拒接报文日期
            ,payrol -- 付款人
            ,docprbrol -- 承兑人
            ,etyextkey -- 实体合同
            ,frepayflg -- 免费方单标志
            ,bchkeyinr -- 业务经办行
            ,branchinr -- 业务所属行
            ,nraflg -- NRA标志
            ,qsqdbh -- 清算渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 保函内部ID号
    ,o.ownref -- 参考号
    ,o.pntinr -- 父保函INR
    ,o.pnttyp -- 保函交易类型
    ,o.nam -- 交易名称
    ,o.credat -- 创建日期
    ,o.clsdat -- 结束日期
    ,o.opndat -- 有效开始日期
    ,o.newexpdat -- 申请日期
    ,o.ownusr -- 负责人
    ,o.ver -- 版本号
    ,o.clmtyp -- 索赔种类
    ,o.clmctl -- 索赔类型
    ,o.clmdat -- 索赔日期
    ,o.cannowflg -- 取消保函下付款
    ,o.msgdat -- 拒接报文日期
    ,o.payrol -- 付款人
    ,o.docprbrol -- 承兑人
    ,o.etyextkey -- 实体合同
    ,o.frepayflg -- 免费方单标志
    ,o.bchkeyinr -- 业务经办行
    ,o.branchinr -- 业务所属行
    ,o.nraflg -- NRA标志
    ,o.qsqdbh -- 清算渠道
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_gcd_bk o
    left join ${iol_schema}.isbs_gcd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_gcd_cl d
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
-- truncate table ${iol_schema}.isbs_gcd;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_gcd exchange partition p_19000101 with table ${iol_schema}.isbs_gcd_cl;
alter table ${iol_schema}.isbs_gcd exchange partition p_20991231 with table ${iol_schema}.isbs_gcd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_gcd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_gcd_op purge;
drop table ${iol_schema}.isbs_gcd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_gcd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_gcd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
