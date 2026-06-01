/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_brd
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
create table ${iol_schema}.isbs_brd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_brd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_brd_op purge;
drop table ${iol_schema}.isbs_brd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_brd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_brd where 0=1;

create table ${iol_schema}.isbs_brd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_brd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_brd_cl(
            inr -- 进口单据INR号
            ,ownref -- 来单参考号
            ,nam -- 来单名称
            ,ownusr -- 负责人
            ,credat -- 寄单日期
            ,opndat -- 开证日期
            ,clsdat -- 结束日期
            ,pnttyp -- 父类类型
            ,pntinr -- 父类交易INR号
            ,predat -- 寄单行寄单日期
            ,shpdat -- 最迟装运日期
            ,spddat -- 过期日期
            ,totdat -- 总天数
            ,advdat -- 通知日期
            ,matdat -- 效期
            ,rcvdat -- 提单收到日期
            ,disdat -- 不符点通知日期
            ,docflg -- 到单标志
            ,rejflg -- 拒付标志
            ,approvcod -- 是否批准
            ,relgodflg -- 货物授权标志
            ,relgoddat -- 授权日期
            ,trpdocnum -- 传送单据数目
            ,frepayflg -- 免付款交单标志
            ,ver -- 版本号
            ,advtyp -- 接收的的通知类型
            ,reltyp -- 授权类型
            ,expdat -- 提货担保开立日期
            ,rtoaplflg -- 货物授权申请人标志
            ,trpdoctyp -- 提单类型
            ,tradat -- 提单日期
            ,tramod -- 运输类型
            ,mattxtflg -- 多期限标志
            ,dscinsflg -- 单据差异标志
            ,docprbrol -- 提交角色
            ,docsta -- 单据类型
            ,igndisflg -- 忽略不符点标志
            ,totcur -- 付款总金额币种
            ,totamt -- 付款总金额
            ,payrol -- 付款人
            ,acpnowflg -- 承兑标志
            ,orddat -- 来单日期
            ,advdocflg -- 退单标志
            ,etyextkey -- 实体组
            ,bchkeyinr -- 经办机构号
            ,branchinr -- 所属机构号
            ,ngrcod -- 货物代码
            ,sgdinr -- 提货担保inr
            ,blnum -- 提单号
            ,shgref -- 提货担保参考号
            ,fincod -- 借据号
            ,fintyp -- 业务品种
            ,nraflg -- NRA付款标志
            ,qsqdbh -- 清算渠道
            ,invnum -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_brd_op(
            inr -- 进口单据INR号
            ,ownref -- 来单参考号
            ,nam -- 来单名称
            ,ownusr -- 负责人
            ,credat -- 寄单日期
            ,opndat -- 开证日期
            ,clsdat -- 结束日期
            ,pnttyp -- 父类类型
            ,pntinr -- 父类交易INR号
            ,predat -- 寄单行寄单日期
            ,shpdat -- 最迟装运日期
            ,spddat -- 过期日期
            ,totdat -- 总天数
            ,advdat -- 通知日期
            ,matdat -- 效期
            ,rcvdat -- 提单收到日期
            ,disdat -- 不符点通知日期
            ,docflg -- 到单标志
            ,rejflg -- 拒付标志
            ,approvcod -- 是否批准
            ,relgodflg -- 货物授权标志
            ,relgoddat -- 授权日期
            ,trpdocnum -- 传送单据数目
            ,frepayflg -- 免付款交单标志
            ,ver -- 版本号
            ,advtyp -- 接收的的通知类型
            ,reltyp -- 授权类型
            ,expdat -- 提货担保开立日期
            ,rtoaplflg -- 货物授权申请人标志
            ,trpdoctyp -- 提单类型
            ,tradat -- 提单日期
            ,tramod -- 运输类型
            ,mattxtflg -- 多期限标志
            ,dscinsflg -- 单据差异标志
            ,docprbrol -- 提交角色
            ,docsta -- 单据类型
            ,igndisflg -- 忽略不符点标志
            ,totcur -- 付款总金额币种
            ,totamt -- 付款总金额
            ,payrol -- 付款人
            ,acpnowflg -- 承兑标志
            ,orddat -- 来单日期
            ,advdocflg -- 退单标志
            ,etyextkey -- 实体组
            ,bchkeyinr -- 经办机构号
            ,branchinr -- 所属机构号
            ,ngrcod -- 货物代码
            ,sgdinr -- 提货担保inr
            ,blnum -- 提单号
            ,shgref -- 提货担保参考号
            ,fincod -- 借据号
            ,fintyp -- 业务品种
            ,nraflg -- NRA付款标志
            ,qsqdbh -- 清算渠道
            ,invnum -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 进口单据INR号
    ,nvl(n.ownref, o.ownref) as ownref -- 来单参考号
    ,nvl(n.nam, o.nam) as nam -- 来单名称
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 负责人
    ,nvl(n.credat, o.credat) as credat -- 寄单日期
    ,nvl(n.opndat, o.opndat) as opndat -- 开证日期
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 结束日期
    ,nvl(n.pnttyp, o.pnttyp) as pnttyp -- 父类类型
    ,nvl(n.pntinr, o.pntinr) as pntinr -- 父类交易INR号
    ,nvl(n.predat, o.predat) as predat -- 寄单行寄单日期
    ,nvl(n.shpdat, o.shpdat) as shpdat -- 最迟装运日期
    ,nvl(n.spddat, o.spddat) as spddat -- 过期日期
    ,nvl(n.totdat, o.totdat) as totdat -- 总天数
    ,nvl(n.advdat, o.advdat) as advdat -- 通知日期
    ,nvl(n.matdat, o.matdat) as matdat -- 效期
    ,nvl(n.rcvdat, o.rcvdat) as rcvdat -- 提单收到日期
    ,nvl(n.disdat, o.disdat) as disdat -- 不符点通知日期
    ,nvl(n.docflg, o.docflg) as docflg -- 到单标志
    ,nvl(n.rejflg, o.rejflg) as rejflg -- 拒付标志
    ,nvl(n.approvcod, o.approvcod) as approvcod -- 是否批准
    ,nvl(n.relgodflg, o.relgodflg) as relgodflg -- 货物授权标志
    ,nvl(n.relgoddat, o.relgoddat) as relgoddat -- 授权日期
    ,nvl(n.trpdocnum, o.trpdocnum) as trpdocnum -- 传送单据数目
    ,nvl(n.frepayflg, o.frepayflg) as frepayflg -- 免付款交单标志
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.advtyp, o.advtyp) as advtyp -- 接收的的通知类型
    ,nvl(n.reltyp, o.reltyp) as reltyp -- 授权类型
    ,nvl(n.expdat, o.expdat) as expdat -- 提货担保开立日期
    ,nvl(n.rtoaplflg, o.rtoaplflg) as rtoaplflg -- 货物授权申请人标志
    ,nvl(n.trpdoctyp, o.trpdoctyp) as trpdoctyp -- 提单类型
    ,nvl(n.tradat, o.tradat) as tradat -- 提单日期
    ,nvl(n.tramod, o.tramod) as tramod -- 运输类型
    ,nvl(n.mattxtflg, o.mattxtflg) as mattxtflg -- 多期限标志
    ,nvl(n.dscinsflg, o.dscinsflg) as dscinsflg -- 单据差异标志
    ,nvl(n.docprbrol, o.docprbrol) as docprbrol -- 提交角色
    ,nvl(n.docsta, o.docsta) as docsta -- 单据类型
    ,nvl(n.igndisflg, o.igndisflg) as igndisflg -- 忽略不符点标志
    ,nvl(n.totcur, o.totcur) as totcur -- 付款总金额币种
    ,nvl(n.totamt, o.totamt) as totamt -- 付款总金额
    ,nvl(n.payrol, o.payrol) as payrol -- 付款人
    ,nvl(n.acpnowflg, o.acpnowflg) as acpnowflg -- 承兑标志
    ,nvl(n.orddat, o.orddat) as orddat -- 来单日期
    ,nvl(n.advdocflg, o.advdocflg) as advdocflg -- 退单标志
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 实体组
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 经办机构号
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 所属机构号
    ,nvl(n.ngrcod, o.ngrcod) as ngrcod -- 货物代码
    ,nvl(n.sgdinr, o.sgdinr) as sgdinr -- 提货担保inr
    ,nvl(n.blnum, o.blnum) as blnum -- 提单号
    ,nvl(n.shgref, o.shgref) as shgref -- 提货担保参考号
    ,nvl(n.fincod, o.fincod) as fincod -- 借据号
    ,nvl(n.fintyp, o.fintyp) as fintyp -- 业务品种
    ,nvl(n.nraflg, o.nraflg) as nraflg -- NRA付款标志
    ,nvl(n.qsqdbh, o.qsqdbh) as qsqdbh -- 清算渠道
    ,nvl(n.invnum, o.invnum) as invnum -- 
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
from (select * from ${iol_schema}.isbs_brd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_brd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.nam <> n.nam
        or o.ownusr <> n.ownusr
        or o.credat <> n.credat
        or o.opndat <> n.opndat
        or o.clsdat <> n.clsdat
        or o.pnttyp <> n.pnttyp
        or o.pntinr <> n.pntinr
        or o.predat <> n.predat
        or o.shpdat <> n.shpdat
        or o.spddat <> n.spddat
        or o.totdat <> n.totdat
        or o.advdat <> n.advdat
        or o.matdat <> n.matdat
        or o.rcvdat <> n.rcvdat
        or o.disdat <> n.disdat
        or o.docflg <> n.docflg
        or o.rejflg <> n.rejflg
        or o.approvcod <> n.approvcod
        or o.relgodflg <> n.relgodflg
        or o.relgoddat <> n.relgoddat
        or o.trpdocnum <> n.trpdocnum
        or o.frepayflg <> n.frepayflg
        or o.ver <> n.ver
        or o.advtyp <> n.advtyp
        or o.reltyp <> n.reltyp
        or o.expdat <> n.expdat
        or o.rtoaplflg <> n.rtoaplflg
        or o.trpdoctyp <> n.trpdoctyp
        or o.tradat <> n.tradat
        or o.tramod <> n.tramod
        or o.mattxtflg <> n.mattxtflg
        or o.dscinsflg <> n.dscinsflg
        or o.docprbrol <> n.docprbrol
        or o.docsta <> n.docsta
        or o.igndisflg <> n.igndisflg
        or o.totcur <> n.totcur
        or o.totamt <> n.totamt
        or o.payrol <> n.payrol
        or o.acpnowflg <> n.acpnowflg
        or o.orddat <> n.orddat
        or o.advdocflg <> n.advdocflg
        or o.etyextkey <> n.etyextkey
        or o.bchkeyinr <> n.bchkeyinr
        or o.branchinr <> n.branchinr
        or o.ngrcod <> n.ngrcod
        or o.sgdinr <> n.sgdinr
        or o.blnum <> n.blnum
        or o.shgref <> n.shgref
        or o.fincod <> n.fincod
        or o.fintyp <> n.fintyp
        or o.nraflg <> n.nraflg
        or o.qsqdbh <> n.qsqdbh
        or o.invnum <> n.invnum
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_brd_cl(
            inr -- 进口单据INR号
            ,ownref -- 来单参考号
            ,nam -- 来单名称
            ,ownusr -- 负责人
            ,credat -- 寄单日期
            ,opndat -- 开证日期
            ,clsdat -- 结束日期
            ,pnttyp -- 父类类型
            ,pntinr -- 父类交易INR号
            ,predat -- 寄单行寄单日期
            ,shpdat -- 最迟装运日期
            ,spddat -- 过期日期
            ,totdat -- 总天数
            ,advdat -- 通知日期
            ,matdat -- 效期
            ,rcvdat -- 提单收到日期
            ,disdat -- 不符点通知日期
            ,docflg -- 到单标志
            ,rejflg -- 拒付标志
            ,approvcod -- 是否批准
            ,relgodflg -- 货物授权标志
            ,relgoddat -- 授权日期
            ,trpdocnum -- 传送单据数目
            ,frepayflg -- 免付款交单标志
            ,ver -- 版本号
            ,advtyp -- 接收的的通知类型
            ,reltyp -- 授权类型
            ,expdat -- 提货担保开立日期
            ,rtoaplflg -- 货物授权申请人标志
            ,trpdoctyp -- 提单类型
            ,tradat -- 提单日期
            ,tramod -- 运输类型
            ,mattxtflg -- 多期限标志
            ,dscinsflg -- 单据差异标志
            ,docprbrol -- 提交角色
            ,docsta -- 单据类型
            ,igndisflg -- 忽略不符点标志
            ,totcur -- 付款总金额币种
            ,totamt -- 付款总金额
            ,payrol -- 付款人
            ,acpnowflg -- 承兑标志
            ,orddat -- 来单日期
            ,advdocflg -- 退单标志
            ,etyextkey -- 实体组
            ,bchkeyinr -- 经办机构号
            ,branchinr -- 所属机构号
            ,ngrcod -- 货物代码
            ,sgdinr -- 提货担保inr
            ,blnum -- 提单号
            ,shgref -- 提货担保参考号
            ,fincod -- 借据号
            ,fintyp -- 业务品种
            ,nraflg -- NRA付款标志
            ,qsqdbh -- 清算渠道
            ,invnum -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_brd_op(
            inr -- 进口单据INR号
            ,ownref -- 来单参考号
            ,nam -- 来单名称
            ,ownusr -- 负责人
            ,credat -- 寄单日期
            ,opndat -- 开证日期
            ,clsdat -- 结束日期
            ,pnttyp -- 父类类型
            ,pntinr -- 父类交易INR号
            ,predat -- 寄单行寄单日期
            ,shpdat -- 最迟装运日期
            ,spddat -- 过期日期
            ,totdat -- 总天数
            ,advdat -- 通知日期
            ,matdat -- 效期
            ,rcvdat -- 提单收到日期
            ,disdat -- 不符点通知日期
            ,docflg -- 到单标志
            ,rejflg -- 拒付标志
            ,approvcod -- 是否批准
            ,relgodflg -- 货物授权标志
            ,relgoddat -- 授权日期
            ,trpdocnum -- 传送单据数目
            ,frepayflg -- 免付款交单标志
            ,ver -- 版本号
            ,advtyp -- 接收的的通知类型
            ,reltyp -- 授权类型
            ,expdat -- 提货担保开立日期
            ,rtoaplflg -- 货物授权申请人标志
            ,trpdoctyp -- 提单类型
            ,tradat -- 提单日期
            ,tramod -- 运输类型
            ,mattxtflg -- 多期限标志
            ,dscinsflg -- 单据差异标志
            ,docprbrol -- 提交角色
            ,docsta -- 单据类型
            ,igndisflg -- 忽略不符点标志
            ,totcur -- 付款总金额币种
            ,totamt -- 付款总金额
            ,payrol -- 付款人
            ,acpnowflg -- 承兑标志
            ,orddat -- 来单日期
            ,advdocflg -- 退单标志
            ,etyextkey -- 实体组
            ,bchkeyinr -- 经办机构号
            ,branchinr -- 所属机构号
            ,ngrcod -- 货物代码
            ,sgdinr -- 提货担保inr
            ,blnum -- 提单号
            ,shgref -- 提货担保参考号
            ,fincod -- 借据号
            ,fintyp -- 业务品种
            ,nraflg -- NRA付款标志
            ,qsqdbh -- 清算渠道
            ,invnum -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 进口单据INR号
    ,o.ownref -- 来单参考号
    ,o.nam -- 来单名称
    ,o.ownusr -- 负责人
    ,o.credat -- 寄单日期
    ,o.opndat -- 开证日期
    ,o.clsdat -- 结束日期
    ,o.pnttyp -- 父类类型
    ,o.pntinr -- 父类交易INR号
    ,o.predat -- 寄单行寄单日期
    ,o.shpdat -- 最迟装运日期
    ,o.spddat -- 过期日期
    ,o.totdat -- 总天数
    ,o.advdat -- 通知日期
    ,o.matdat -- 效期
    ,o.rcvdat -- 提单收到日期
    ,o.disdat -- 不符点通知日期
    ,o.docflg -- 到单标志
    ,o.rejflg -- 拒付标志
    ,o.approvcod -- 是否批准
    ,o.relgodflg -- 货物授权标志
    ,o.relgoddat -- 授权日期
    ,o.trpdocnum -- 传送单据数目
    ,o.frepayflg -- 免付款交单标志
    ,o.ver -- 版本号
    ,o.advtyp -- 接收的的通知类型
    ,o.reltyp -- 授权类型
    ,o.expdat -- 提货担保开立日期
    ,o.rtoaplflg -- 货物授权申请人标志
    ,o.trpdoctyp -- 提单类型
    ,o.tradat -- 提单日期
    ,o.tramod -- 运输类型
    ,o.mattxtflg -- 多期限标志
    ,o.dscinsflg -- 单据差异标志
    ,o.docprbrol -- 提交角色
    ,o.docsta -- 单据类型
    ,o.igndisflg -- 忽略不符点标志
    ,o.totcur -- 付款总金额币种
    ,o.totamt -- 付款总金额
    ,o.payrol -- 付款人
    ,o.acpnowflg -- 承兑标志
    ,o.orddat -- 来单日期
    ,o.advdocflg -- 退单标志
    ,o.etyextkey -- 实体组
    ,o.bchkeyinr -- 经办机构号
    ,o.branchinr -- 所属机构号
    ,o.ngrcod -- 货物代码
    ,o.sgdinr -- 提货担保inr
    ,o.blnum -- 提单号
    ,o.shgref -- 提货担保参考号
    ,o.fincod -- 借据号
    ,o.fintyp -- 业务品种
    ,o.nraflg -- NRA付款标志
    ,o.qsqdbh -- 清算渠道
    ,o.invnum -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_brd_bk o
    left join ${iol_schema}.isbs_brd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_brd_cl d
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
-- truncate table ${iol_schema}.isbs_brd;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_brd exchange partition p_19000101 with table ${iol_schema}.isbs_brd_cl;
alter table ${iol_schema}.isbs_brd exchange partition p_20991231 with table ${iol_schema}.isbs_brd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_brd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_brd_op purge;
drop table ${iol_schema}.isbs_brd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_brd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_brd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
