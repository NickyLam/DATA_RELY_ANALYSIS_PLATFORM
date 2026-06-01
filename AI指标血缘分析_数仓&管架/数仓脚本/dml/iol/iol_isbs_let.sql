/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_let
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
create table ${iol_schema}.isbs_let_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_let;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_let_op purge;
drop table ${iol_schema}.isbs_let_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_let_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_let where 0=1;

create table ${iol_schema}.isbs_let_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_let where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_let_cl(
            inr -- 出口信用证ID号
            ,adlcnd -- 附加条件
            ,defdet -- 延期付款细节
            ,dftat -- 汇款方式
            ,feetxt -- 费用分担
            ,insbnk -- 给付款/承对/议付行的指示
            ,lcrdoc -- 必须的单据
            ,lcrgod -- 货物描述
            ,mixdet -- 混合付款细节
            ,preper -- 提示期间
            ,shpper -- 装船时期
            ,strinf -- 给收单者信息
            ,ver -- 版本号
            ,adlcndame -- 附加条件
            ,lcrgodame -- 货物描述
            ,lcrdocame -- 修改单据描述
            ,nartxtame -- 叙述
            ,addamtcov -- 增加的保证金
            ,fldmodblk -- 修改栏位记录的内容
            ,revnotes -- 给受益人的信息
            ,revcls -- 循环条款
            ,avbwthtxt -- 适用方式的详细信息
            ,insbnkame -- 给对方信用的修改信息（Paying
            ,contag72 -- 报文72场的内容
            ,contag79 -- 报文79场的内容
            ,spcben -- 
            ,spcrcb -- 
            ,spcbename -- 
            ,spcrcbame -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_let_op(
            inr -- 出口信用证ID号
            ,adlcnd -- 附加条件
            ,defdet -- 延期付款细节
            ,dftat -- 汇款方式
            ,feetxt -- 费用分担
            ,insbnk -- 给付款/承对/议付行的指示
            ,lcrdoc -- 必须的单据
            ,lcrgod -- 货物描述
            ,mixdet -- 混合付款细节
            ,preper -- 提示期间
            ,shpper -- 装船时期
            ,strinf -- 给收单者信息
            ,ver -- 版本号
            ,adlcndame -- 附加条件
            ,lcrgodame -- 货物描述
            ,lcrdocame -- 修改单据描述
            ,nartxtame -- 叙述
            ,addamtcov -- 增加的保证金
            ,fldmodblk -- 修改栏位记录的内容
            ,revnotes -- 给受益人的信息
            ,revcls -- 循环条款
            ,avbwthtxt -- 适用方式的详细信息
            ,insbnkame -- 给对方信用的修改信息（Paying
            ,contag72 -- 报文72场的内容
            ,contag79 -- 报文79场的内容
            ,spcben -- 
            ,spcrcb -- 
            ,spcbename -- 
            ,spcrcbame -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 出口信用证ID号
    ,nvl(n.adlcnd, o.adlcnd) as adlcnd -- 附加条件
    ,nvl(n.defdet, o.defdet) as defdet -- 延期付款细节
    ,nvl(n.dftat, o.dftat) as dftat -- 汇款方式
    ,nvl(n.feetxt, o.feetxt) as feetxt -- 费用分担
    ,nvl(n.insbnk, o.insbnk) as insbnk -- 给付款/承对/议付行的指示
    ,nvl(n.lcrdoc, o.lcrdoc) as lcrdoc -- 必须的单据
    ,nvl(n.lcrgod, o.lcrgod) as lcrgod -- 货物描述
    ,nvl(n.mixdet, o.mixdet) as mixdet -- 混合付款细节
    ,nvl(n.preper, o.preper) as preper -- 提示期间
    ,nvl(n.shpper, o.shpper) as shpper -- 装船时期
    ,nvl(n.strinf, o.strinf) as strinf -- 给收单者信息
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.adlcndame, o.adlcndame) as adlcndame -- 附加条件
    ,nvl(n.lcrgodame, o.lcrgodame) as lcrgodame -- 货物描述
    ,nvl(n.lcrdocame, o.lcrdocame) as lcrdocame -- 修改单据描述
    ,nvl(n.nartxtame, o.nartxtame) as nartxtame -- 叙述
    ,nvl(n.addamtcov, o.addamtcov) as addamtcov -- 增加的保证金
    ,nvl(n.fldmodblk, o.fldmodblk) as fldmodblk -- 修改栏位记录的内容
    ,nvl(n.revnotes, o.revnotes) as revnotes -- 给受益人的信息
    ,nvl(n.revcls, o.revcls) as revcls -- 循环条款
    ,nvl(n.avbwthtxt, o.avbwthtxt) as avbwthtxt -- 适用方式的详细信息
    ,nvl(n.insbnkame, o.insbnkame) as insbnkame -- 给对方信用的修改信息（Paying
    ,nvl(n.contag72, o.contag72) as contag72 -- 报文72场的内容
    ,nvl(n.contag79, o.contag79) as contag79 -- 报文79场的内容
    ,nvl(n.spcben, o.spcben) as spcben -- 
    ,nvl(n.spcrcb, o.spcrcb) as spcrcb -- 
    ,nvl(n.spcbename, o.spcbename) as spcbename -- 
    ,nvl(n.spcrcbame, o.spcrcbame) as spcrcbame -- 
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
from (select * from ${iol_schema}.isbs_let_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_let where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.adlcnd <> n.adlcnd
        or o.defdet <> n.defdet
        or o.dftat <> n.dftat
        or o.feetxt <> n.feetxt
        or o.insbnk <> n.insbnk
        or o.lcrdoc <> n.lcrdoc
        or o.lcrgod <> n.lcrgod
        or o.mixdet <> n.mixdet
        or o.preper <> n.preper
        or o.shpper <> n.shpper
        or o.strinf <> n.strinf
        or o.ver <> n.ver
        or o.adlcndame <> n.adlcndame
        or o.lcrgodame <> n.lcrgodame
        or o.lcrdocame <> n.lcrdocame
        or o.nartxtame <> n.nartxtame
        or o.addamtcov <> n.addamtcov
        or o.fldmodblk <> n.fldmodblk
        or o.revnotes <> n.revnotes
        or o.revcls <> n.revcls
        or o.avbwthtxt <> n.avbwthtxt
        or o.insbnkame <> n.insbnkame
        or o.contag72 <> n.contag72
        or o.contag79 <> n.contag79
        or o.spcben <> n.spcben
        or o.spcrcb <> n.spcrcb
        or o.spcbename <> n.spcbename
        or o.spcrcbame <> n.spcrcbame
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_let_cl(
            inr -- 出口信用证ID号
            ,adlcnd -- 附加条件
            ,defdet -- 延期付款细节
            ,dftat -- 汇款方式
            ,feetxt -- 费用分担
            ,insbnk -- 给付款/承对/议付行的指示
            ,lcrdoc -- 必须的单据
            ,lcrgod -- 货物描述
            ,mixdet -- 混合付款细节
            ,preper -- 提示期间
            ,shpper -- 装船时期
            ,strinf -- 给收单者信息
            ,ver -- 版本号
            ,adlcndame -- 附加条件
            ,lcrgodame -- 货物描述
            ,lcrdocame -- 修改单据描述
            ,nartxtame -- 叙述
            ,addamtcov -- 增加的保证金
            ,fldmodblk -- 修改栏位记录的内容
            ,revnotes -- 给受益人的信息
            ,revcls -- 循环条款
            ,avbwthtxt -- 适用方式的详细信息
            ,insbnkame -- 给对方信用的修改信息（Paying
            ,contag72 -- 报文72场的内容
            ,contag79 -- 报文79场的内容
            ,spcben -- 
            ,spcrcb -- 
            ,spcbename -- 
            ,spcrcbame -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_let_op(
            inr -- 出口信用证ID号
            ,adlcnd -- 附加条件
            ,defdet -- 延期付款细节
            ,dftat -- 汇款方式
            ,feetxt -- 费用分担
            ,insbnk -- 给付款/承对/议付行的指示
            ,lcrdoc -- 必须的单据
            ,lcrgod -- 货物描述
            ,mixdet -- 混合付款细节
            ,preper -- 提示期间
            ,shpper -- 装船时期
            ,strinf -- 给收单者信息
            ,ver -- 版本号
            ,adlcndame -- 附加条件
            ,lcrgodame -- 货物描述
            ,lcrdocame -- 修改单据描述
            ,nartxtame -- 叙述
            ,addamtcov -- 增加的保证金
            ,fldmodblk -- 修改栏位记录的内容
            ,revnotes -- 给受益人的信息
            ,revcls -- 循环条款
            ,avbwthtxt -- 适用方式的详细信息
            ,insbnkame -- 给对方信用的修改信息（Paying
            ,contag72 -- 报文72场的内容
            ,contag79 -- 报文79场的内容
            ,spcben -- 
            ,spcrcb -- 
            ,spcbename -- 
            ,spcrcbame -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 出口信用证ID号
    ,o.adlcnd -- 附加条件
    ,o.defdet -- 延期付款细节
    ,o.dftat -- 汇款方式
    ,o.feetxt -- 费用分担
    ,o.insbnk -- 给付款/承对/议付行的指示
    ,o.lcrdoc -- 必须的单据
    ,o.lcrgod -- 货物描述
    ,o.mixdet -- 混合付款细节
    ,o.preper -- 提示期间
    ,o.shpper -- 装船时期
    ,o.strinf -- 给收单者信息
    ,o.ver -- 版本号
    ,o.adlcndame -- 附加条件
    ,o.lcrgodame -- 货物描述
    ,o.lcrdocame -- 修改单据描述
    ,o.nartxtame -- 叙述
    ,o.addamtcov -- 增加的保证金
    ,o.fldmodblk -- 修改栏位记录的内容
    ,o.revnotes -- 给受益人的信息
    ,o.revcls -- 循环条款
    ,o.avbwthtxt -- 适用方式的详细信息
    ,o.insbnkame -- 给对方信用的修改信息（Paying
    ,o.contag72 -- 报文72场的内容
    ,o.contag79 -- 报文79场的内容
    ,o.spcben -- 
    ,o.spcrcb -- 
    ,o.spcbename -- 
    ,o.spcrcbame -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_let_bk o
    left join ${iol_schema}.isbs_let_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_let_cl d
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
-- truncate table ${iol_schema}.isbs_let;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_let exchange partition p_19000101 with table ${iol_schema}.isbs_let_cl;
alter table ${iol_schema}.isbs_let exchange partition p_20991231 with table ${iol_schema}.isbs_let_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_let to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_let_op purge;
drop table ${iol_schema}.isbs_let_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_let_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_let',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
