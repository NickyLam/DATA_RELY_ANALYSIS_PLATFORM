/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_brt
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
create table ${iol_schema}.isbs_brt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_brt;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_brt_op purge;
drop table ${iol_schema}.isbs_brt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_brt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_brt where 0=1;

create table ${iol_schema}.isbs_brt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_brt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_brt_cl(
            inr -- 进口单据ID号
            ,docdis -- 不符点
            ,docins -- 拒付原因
            ,prsdoc -- 提示单据
            ,disdoc -- 处理单据
            ,aplins -- 申请者的说明
            ,matper -- 效期
            ,comcon -- 注释与结论
            ,setinsbr -- 付款指示
            ,roggod -- 货物的鉴定
            ,pordis -- 卸货地点
            ,delplc -- 传送地点
            ,vesnam -- 船名
            ,relstoadr -- 地址授权
            ,chaded -- 扣除费用
            ,chaadd -- 增加费用
            ,fldmodblk -- 修改清单
            ,nartxt77a -- 详述
            ,contag72 -- 附言
            ,contag79 -- 79域
            ,docdisdef -- 默认不符点内容
            ,docdisflg -- 修改不符点标志
            ,disdocdef -- 不符点内容
            ,disdocflg -- 单据不符点内容
            ,porlod -- 装载港口
            ,notpty -- 通知人
            ,voynum -- 航运号
            ,carnam -- 运输商
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_brt_op(
            inr -- 进口单据ID号
            ,docdis -- 不符点
            ,docins -- 拒付原因
            ,prsdoc -- 提示单据
            ,disdoc -- 处理单据
            ,aplins -- 申请者的说明
            ,matper -- 效期
            ,comcon -- 注释与结论
            ,setinsbr -- 付款指示
            ,roggod -- 货物的鉴定
            ,pordis -- 卸货地点
            ,delplc -- 传送地点
            ,vesnam -- 船名
            ,relstoadr -- 地址授权
            ,chaded -- 扣除费用
            ,chaadd -- 增加费用
            ,fldmodblk -- 修改清单
            ,nartxt77a -- 详述
            ,contag72 -- 附言
            ,contag79 -- 79域
            ,docdisdef -- 默认不符点内容
            ,docdisflg -- 修改不符点标志
            ,disdocdef -- 不符点内容
            ,disdocflg -- 单据不符点内容
            ,porlod -- 装载港口
            ,notpty -- 通知人
            ,voynum -- 航运号
            ,carnam -- 运输商
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 进口单据ID号
    ,nvl(n.docdis, o.docdis) as docdis -- 不符点
    ,nvl(n.docins, o.docins) as docins -- 拒付原因
    ,nvl(n.prsdoc, o.prsdoc) as prsdoc -- 提示单据
    ,nvl(n.disdoc, o.disdoc) as disdoc -- 处理单据
    ,nvl(n.aplins, o.aplins) as aplins -- 申请者的说明
    ,nvl(n.matper, o.matper) as matper -- 效期
    ,nvl(n.comcon, o.comcon) as comcon -- 注释与结论
    ,nvl(n.setinsbr, o.setinsbr) as setinsbr -- 付款指示
    ,nvl(n.roggod, o.roggod) as roggod -- 货物的鉴定
    ,nvl(n.pordis, o.pordis) as pordis -- 卸货地点
    ,nvl(n.delplc, o.delplc) as delplc -- 传送地点
    ,nvl(n.vesnam, o.vesnam) as vesnam -- 船名
    ,nvl(n.relstoadr, o.relstoadr) as relstoadr -- 地址授权
    ,nvl(n.chaded, o.chaded) as chaded -- 扣除费用
    ,nvl(n.chaadd, o.chaadd) as chaadd -- 增加费用
    ,nvl(n.fldmodblk, o.fldmodblk) as fldmodblk -- 修改清单
    ,nvl(n.nartxt77a, o.nartxt77a) as nartxt77a -- 详述
    ,nvl(n.contag72, o.contag72) as contag72 -- 附言
    ,nvl(n.contag79, o.contag79) as contag79 -- 79域
    ,nvl(n.docdisdef, o.docdisdef) as docdisdef -- 默认不符点内容
    ,nvl(n.docdisflg, o.docdisflg) as docdisflg -- 修改不符点标志
    ,nvl(n.disdocdef, o.disdocdef) as disdocdef -- 不符点内容
    ,nvl(n.disdocflg, o.disdocflg) as disdocflg -- 单据不符点内容
    ,nvl(n.porlod, o.porlod) as porlod -- 装载港口
    ,nvl(n.notpty, o.notpty) as notpty -- 通知人
    ,nvl(n.voynum, o.voynum) as voynum -- 航运号
    ,nvl(n.carnam, o.carnam) as carnam -- 运输商
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
from (select * from ${iol_schema}.isbs_brt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_brt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.docdis <> n.docdis
        or o.docins <> n.docins
        or o.prsdoc <> n.prsdoc
        or o.disdoc <> n.disdoc
        or o.aplins <> n.aplins
        or o.matper <> n.matper
        or o.comcon <> n.comcon
        or o.setinsbr <> n.setinsbr
        or o.roggod <> n.roggod
        or o.pordis <> n.pordis
        or o.delplc <> n.delplc
        or o.vesnam <> n.vesnam
        or o.relstoadr <> n.relstoadr
        or o.chaded <> n.chaded
        or o.chaadd <> n.chaadd
        or o.fldmodblk <> n.fldmodblk
        or o.nartxt77a <> n.nartxt77a
        or o.contag72 <> n.contag72
        or o.contag79 <> n.contag79
        or o.docdisdef <> n.docdisdef
        or o.docdisflg <> n.docdisflg
        or o.disdocdef <> n.disdocdef
        or o.disdocflg <> n.disdocflg
        or o.porlod <> n.porlod
        or o.notpty <> n.notpty
        or o.voynum <> n.voynum
        or o.carnam <> n.carnam
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_brt_cl(
            inr -- 进口单据ID号
            ,docdis -- 不符点
            ,docins -- 拒付原因
            ,prsdoc -- 提示单据
            ,disdoc -- 处理单据
            ,aplins -- 申请者的说明
            ,matper -- 效期
            ,comcon -- 注释与结论
            ,setinsbr -- 付款指示
            ,roggod -- 货物的鉴定
            ,pordis -- 卸货地点
            ,delplc -- 传送地点
            ,vesnam -- 船名
            ,relstoadr -- 地址授权
            ,chaded -- 扣除费用
            ,chaadd -- 增加费用
            ,fldmodblk -- 修改清单
            ,nartxt77a -- 详述
            ,contag72 -- 附言
            ,contag79 -- 79域
            ,docdisdef -- 默认不符点内容
            ,docdisflg -- 修改不符点标志
            ,disdocdef -- 不符点内容
            ,disdocflg -- 单据不符点内容
            ,porlod -- 装载港口
            ,notpty -- 通知人
            ,voynum -- 航运号
            ,carnam -- 运输商
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_brt_op(
            inr -- 进口单据ID号
            ,docdis -- 不符点
            ,docins -- 拒付原因
            ,prsdoc -- 提示单据
            ,disdoc -- 处理单据
            ,aplins -- 申请者的说明
            ,matper -- 效期
            ,comcon -- 注释与结论
            ,setinsbr -- 付款指示
            ,roggod -- 货物的鉴定
            ,pordis -- 卸货地点
            ,delplc -- 传送地点
            ,vesnam -- 船名
            ,relstoadr -- 地址授权
            ,chaded -- 扣除费用
            ,chaadd -- 增加费用
            ,fldmodblk -- 修改清单
            ,nartxt77a -- 详述
            ,contag72 -- 附言
            ,contag79 -- 79域
            ,docdisdef -- 默认不符点内容
            ,docdisflg -- 修改不符点标志
            ,disdocdef -- 不符点内容
            ,disdocflg -- 单据不符点内容
            ,porlod -- 装载港口
            ,notpty -- 通知人
            ,voynum -- 航运号
            ,carnam -- 运输商
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 进口单据ID号
    ,o.docdis -- 不符点
    ,o.docins -- 拒付原因
    ,o.prsdoc -- 提示单据
    ,o.disdoc -- 处理单据
    ,o.aplins -- 申请者的说明
    ,o.matper -- 效期
    ,o.comcon -- 注释与结论
    ,o.setinsbr -- 付款指示
    ,o.roggod -- 货物的鉴定
    ,o.pordis -- 卸货地点
    ,o.delplc -- 传送地点
    ,o.vesnam -- 船名
    ,o.relstoadr -- 地址授权
    ,o.chaded -- 扣除费用
    ,o.chaadd -- 增加费用
    ,o.fldmodblk -- 修改清单
    ,o.nartxt77a -- 详述
    ,o.contag72 -- 附言
    ,o.contag79 -- 79域
    ,o.docdisdef -- 默认不符点内容
    ,o.docdisflg -- 修改不符点标志
    ,o.disdocdef -- 不符点内容
    ,o.disdocflg -- 单据不符点内容
    ,o.porlod -- 装载港口
    ,o.notpty -- 通知人
    ,o.voynum -- 航运号
    ,o.carnam -- 运输商
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_brt_bk o
    left join ${iol_schema}.isbs_brt_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_brt_cl d
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
-- truncate table ${iol_schema}.isbs_brt;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_brt exchange partition p_19000101 with table ${iol_schema}.isbs_brt_cl;
alter table ${iol_schema}.isbs_brt exchange partition p_20991231 with table ${iol_schema}.isbs_brt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_brt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_brt_op purge;
drop table ${iol_schema}.isbs_brt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_brt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_brt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
