/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_bcd
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
create table ${iol_schema}.isbs_bcd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_bcd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bcd_op purge;
drop table ${iol_schema}.isbs_bcd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bcd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bcd where 0=1;

create table ${iol_schema}.isbs_bcd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bcd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bcd_cl(
            inr -- 唯一ID号
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,relgodflg -- 货物授权标志
            ,relgoddat -- 货物到达日期
            ,rcvdat -- 收货日期
            ,predat -- 提示日期
            ,shpdat -- 发船日期
            ,credat -- 进口代收产生日期
            ,advdat -- 单据已到的通知日期
            ,clsdat -- 到期日期
            ,matdat -- 效期到期日
            ,opndat -- 开证日期
            ,doctypcod -- 拒付/收货的代码
            ,matperbeg -- 效期起始日
            ,matpercnt -- 效期天数
            ,matpertyp -- 日期的类型
            ,ownusr -- 负责人
            ,ver -- 版本号
            ,trpdoctyp -- 传送单据类型
            ,trpdocnum -- 单据编号
            ,tradat -- 发单日期
            ,tramod -- 发单方式
            ,shpfro -- 发货地点
            ,shpto -- 到货地点
            ,chato -- 付款方向
            ,othins -- 延期付款
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,accdat -- 承兑日期
            ,amenbr -- 修改次数
            ,dftgarflg -- 担保标志
            ,reltyp -- release类型
            ,expdat -- 运输担保到期日
            ,rtodreflg -- 放货标志
            ,mattxtflg -- 混合付款标志
            ,focflg -- 免付款交单标志
            ,waicolcod -- 代收行费用遭拒付时是否放弃
            ,wairmtcod -- 我方费用遭拒付时是否放弃
            ,oridre -- 发送面函标志
            ,docsta -- 单据状态
            ,resflg -- 预留标志
            ,agtdat -- 提货日期
            ,etyextkey -- 用户组别关键字
            ,proins -- 拒付说明
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,nraflg -- NRA收款标志
            ,qsqdbh -- 清算渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bcd_op(
            inr -- 唯一ID号
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,relgodflg -- 货物授权标志
            ,relgoddat -- 货物到达日期
            ,rcvdat -- 收货日期
            ,predat -- 提示日期
            ,shpdat -- 发船日期
            ,credat -- 进口代收产生日期
            ,advdat -- 单据已到的通知日期
            ,clsdat -- 到期日期
            ,matdat -- 效期到期日
            ,opndat -- 开证日期
            ,doctypcod -- 拒付/收货的代码
            ,matperbeg -- 效期起始日
            ,matpercnt -- 效期天数
            ,matpertyp -- 日期的类型
            ,ownusr -- 负责人
            ,ver -- 版本号
            ,trpdoctyp -- 传送单据类型
            ,trpdocnum -- 单据编号
            ,tradat -- 发单日期
            ,tramod -- 发单方式
            ,shpfro -- 发货地点
            ,shpto -- 到货地点
            ,chato -- 付款方向
            ,othins -- 延期付款
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,accdat -- 承兑日期
            ,amenbr -- 修改次数
            ,dftgarflg -- 担保标志
            ,reltyp -- release类型
            ,expdat -- 运输担保到期日
            ,rtodreflg -- 放货标志
            ,mattxtflg -- 混合付款标志
            ,focflg -- 免付款交单标志
            ,waicolcod -- 代收行费用遭拒付时是否放弃
            ,wairmtcod -- 我方费用遭拒付时是否放弃
            ,oridre -- 发送面函标志
            ,docsta -- 单据状态
            ,resflg -- 预留标志
            ,agtdat -- 提货日期
            ,etyextkey -- 用户组别关键字
            ,proins -- 拒付说明
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,nraflg -- NRA收款标志
            ,qsqdbh -- 清算渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 唯一ID号
    ,nvl(n.ownref, o.ownref) as ownref -- 参考号
    ,nvl(n.nam, o.nam) as nam -- 交易名称
    ,nvl(n.relgodflg, o.relgodflg) as relgodflg -- 货物授权标志
    ,nvl(n.relgoddat, o.relgoddat) as relgoddat -- 货物到达日期
    ,nvl(n.rcvdat, o.rcvdat) as rcvdat -- 收货日期
    ,nvl(n.predat, o.predat) as predat -- 提示日期
    ,nvl(n.shpdat, o.shpdat) as shpdat -- 发船日期
    ,nvl(n.credat, o.credat) as credat -- 进口代收产生日期
    ,nvl(n.advdat, o.advdat) as advdat -- 单据已到的通知日期
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 到期日期
    ,nvl(n.matdat, o.matdat) as matdat -- 效期到期日
    ,nvl(n.opndat, o.opndat) as opndat -- 开证日期
    ,nvl(n.doctypcod, o.doctypcod) as doctypcod -- 拒付/收货的代码
    ,nvl(n.matperbeg, o.matperbeg) as matperbeg -- 效期起始日
    ,nvl(n.matpercnt, o.matpercnt) as matpercnt -- 效期天数
    ,nvl(n.matpertyp, o.matpertyp) as matpertyp -- 日期的类型
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 负责人
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.trpdoctyp, o.trpdoctyp) as trpdoctyp -- 传送单据类型
    ,nvl(n.trpdocnum, o.trpdocnum) as trpdocnum -- 单据编号
    ,nvl(n.tradat, o.tradat) as tradat -- 发单日期
    ,nvl(n.tramod, o.tramod) as tramod -- 发单方式
    ,nvl(n.shpfro, o.shpfro) as shpfro -- 发货地点
    ,nvl(n.shpto, o.shpto) as shpto -- 到货地点
    ,nvl(n.chato, o.chato) as chato -- 付款方向
    ,nvl(n.othins, o.othins) as othins -- 延期付款
    ,nvl(n.stacty, o.stacty) as stacty -- 国家代码
    ,nvl(n.stagod, o.stagod) as stagod -- 货物代码
    ,nvl(n.accdat, o.accdat) as accdat -- 承兑日期
    ,nvl(n.amenbr, o.amenbr) as amenbr -- 修改次数
    ,nvl(n.dftgarflg, o.dftgarflg) as dftgarflg -- 担保标志
    ,nvl(n.reltyp, o.reltyp) as reltyp -- release类型
    ,nvl(n.expdat, o.expdat) as expdat -- 运输担保到期日
    ,nvl(n.rtodreflg, o.rtodreflg) as rtodreflg -- 放货标志
    ,nvl(n.mattxtflg, o.mattxtflg) as mattxtflg -- 混合付款标志
    ,nvl(n.focflg, o.focflg) as focflg -- 免付款交单标志
    ,nvl(n.waicolcod, o.waicolcod) as waicolcod -- 代收行费用遭拒付时是否放弃
    ,nvl(n.wairmtcod, o.wairmtcod) as wairmtcod -- 我方费用遭拒付时是否放弃
    ,nvl(n.oridre, o.oridre) as oridre -- 发送面函标志
    ,nvl(n.docsta, o.docsta) as docsta -- 单据状态
    ,nvl(n.resflg, o.resflg) as resflg -- 预留标志
    ,nvl(n.agtdat, o.agtdat) as agtdat -- 提货日期
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 用户组别关键字
    ,nvl(n.proins, o.proins) as proins -- 拒付说明
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 所属机构号
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 经办机构号
    ,nvl(n.nraflg, o.nraflg) as nraflg -- NRA收款标志
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
from (select * from ${iol_schema}.isbs_bcd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_bcd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.relgodflg <> n.relgodflg
        or o.relgoddat <> n.relgoddat
        or o.rcvdat <> n.rcvdat
        or o.predat <> n.predat
        or o.shpdat <> n.shpdat
        or o.credat <> n.credat
        or o.advdat <> n.advdat
        or o.clsdat <> n.clsdat
        or o.matdat <> n.matdat
        or o.opndat <> n.opndat
        or o.doctypcod <> n.doctypcod
        or o.matperbeg <> n.matperbeg
        or o.matpercnt <> n.matpercnt
        or o.matpertyp <> n.matpertyp
        or o.ownusr <> n.ownusr
        or o.ver <> n.ver
        or o.trpdoctyp <> n.trpdoctyp
        or o.trpdocnum <> n.trpdocnum
        or o.tradat <> n.tradat
        or o.tramod <> n.tramod
        or o.shpfro <> n.shpfro
        or o.shpto <> n.shpto
        or o.chato <> n.chato
        or o.othins <> n.othins
        or o.stacty <> n.stacty
        or o.stagod <> n.stagod
        or o.accdat <> n.accdat
        or o.amenbr <> n.amenbr
        or o.dftgarflg <> n.dftgarflg
        or o.reltyp <> n.reltyp
        or o.expdat <> n.expdat
        or o.rtodreflg <> n.rtodreflg
        or o.mattxtflg <> n.mattxtflg
        or o.focflg <> n.focflg
        or o.waicolcod <> n.waicolcod
        or o.wairmtcod <> n.wairmtcod
        or o.oridre <> n.oridre
        or o.docsta <> n.docsta
        or o.resflg <> n.resflg
        or o.agtdat <> n.agtdat
        or o.etyextkey <> n.etyextkey
        or o.proins <> n.proins
        or o.branchinr <> n.branchinr
        or o.bchkeyinr <> n.bchkeyinr
        or o.nraflg <> n.nraflg
        or o.qsqdbh <> n.qsqdbh
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bcd_cl(
            inr -- 唯一ID号
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,relgodflg -- 货物授权标志
            ,relgoddat -- 货物到达日期
            ,rcvdat -- 收货日期
            ,predat -- 提示日期
            ,shpdat -- 发船日期
            ,credat -- 进口代收产生日期
            ,advdat -- 单据已到的通知日期
            ,clsdat -- 到期日期
            ,matdat -- 效期到期日
            ,opndat -- 开证日期
            ,doctypcod -- 拒付/收货的代码
            ,matperbeg -- 效期起始日
            ,matpercnt -- 效期天数
            ,matpertyp -- 日期的类型
            ,ownusr -- 负责人
            ,ver -- 版本号
            ,trpdoctyp -- 传送单据类型
            ,trpdocnum -- 单据编号
            ,tradat -- 发单日期
            ,tramod -- 发单方式
            ,shpfro -- 发货地点
            ,shpto -- 到货地点
            ,chato -- 付款方向
            ,othins -- 延期付款
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,accdat -- 承兑日期
            ,amenbr -- 修改次数
            ,dftgarflg -- 担保标志
            ,reltyp -- release类型
            ,expdat -- 运输担保到期日
            ,rtodreflg -- 放货标志
            ,mattxtflg -- 混合付款标志
            ,focflg -- 免付款交单标志
            ,waicolcod -- 代收行费用遭拒付时是否放弃
            ,wairmtcod -- 我方费用遭拒付时是否放弃
            ,oridre -- 发送面函标志
            ,docsta -- 单据状态
            ,resflg -- 预留标志
            ,agtdat -- 提货日期
            ,etyextkey -- 用户组别关键字
            ,proins -- 拒付说明
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,nraflg -- NRA收款标志
            ,qsqdbh -- 清算渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bcd_op(
            inr -- 唯一ID号
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,relgodflg -- 货物授权标志
            ,relgoddat -- 货物到达日期
            ,rcvdat -- 收货日期
            ,predat -- 提示日期
            ,shpdat -- 发船日期
            ,credat -- 进口代收产生日期
            ,advdat -- 单据已到的通知日期
            ,clsdat -- 到期日期
            ,matdat -- 效期到期日
            ,opndat -- 开证日期
            ,doctypcod -- 拒付/收货的代码
            ,matperbeg -- 效期起始日
            ,matpercnt -- 效期天数
            ,matpertyp -- 日期的类型
            ,ownusr -- 负责人
            ,ver -- 版本号
            ,trpdoctyp -- 传送单据类型
            ,trpdocnum -- 单据编号
            ,tradat -- 发单日期
            ,tramod -- 发单方式
            ,shpfro -- 发货地点
            ,shpto -- 到货地点
            ,chato -- 付款方向
            ,othins -- 延期付款
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,accdat -- 承兑日期
            ,amenbr -- 修改次数
            ,dftgarflg -- 担保标志
            ,reltyp -- release类型
            ,expdat -- 运输担保到期日
            ,rtodreflg -- 放货标志
            ,mattxtflg -- 混合付款标志
            ,focflg -- 免付款交单标志
            ,waicolcod -- 代收行费用遭拒付时是否放弃
            ,wairmtcod -- 我方费用遭拒付时是否放弃
            ,oridre -- 发送面函标志
            ,docsta -- 单据状态
            ,resflg -- 预留标志
            ,agtdat -- 提货日期
            ,etyextkey -- 用户组别关键字
            ,proins -- 拒付说明
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,nraflg -- NRA收款标志
            ,qsqdbh -- 清算渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 唯一ID号
    ,o.ownref -- 参考号
    ,o.nam -- 交易名称
    ,o.relgodflg -- 货物授权标志
    ,o.relgoddat -- 货物到达日期
    ,o.rcvdat -- 收货日期
    ,o.predat -- 提示日期
    ,o.shpdat -- 发船日期
    ,o.credat -- 进口代收产生日期
    ,o.advdat -- 单据已到的通知日期
    ,o.clsdat -- 到期日期
    ,o.matdat -- 效期到期日
    ,o.opndat -- 开证日期
    ,o.doctypcod -- 拒付/收货的代码
    ,o.matperbeg -- 效期起始日
    ,o.matpercnt -- 效期天数
    ,o.matpertyp -- 日期的类型
    ,o.ownusr -- 负责人
    ,o.ver -- 版本号
    ,o.trpdoctyp -- 传送单据类型
    ,o.trpdocnum -- 单据编号
    ,o.tradat -- 发单日期
    ,o.tramod -- 发单方式
    ,o.shpfro -- 发货地点
    ,o.shpto -- 到货地点
    ,o.chato -- 付款方向
    ,o.othins -- 延期付款
    ,o.stacty -- 国家代码
    ,o.stagod -- 货物代码
    ,o.accdat -- 承兑日期
    ,o.amenbr -- 修改次数
    ,o.dftgarflg -- 担保标志
    ,o.reltyp -- release类型
    ,o.expdat -- 运输担保到期日
    ,o.rtodreflg -- 放货标志
    ,o.mattxtflg -- 混合付款标志
    ,o.focflg -- 免付款交单标志
    ,o.waicolcod -- 代收行费用遭拒付时是否放弃
    ,o.wairmtcod -- 我方费用遭拒付时是否放弃
    ,o.oridre -- 发送面函标志
    ,o.docsta -- 单据状态
    ,o.resflg -- 预留标志
    ,o.agtdat -- 提货日期
    ,o.etyextkey -- 用户组别关键字
    ,o.proins -- 拒付说明
    ,o.branchinr -- 所属机构号
    ,o.bchkeyinr -- 经办机构号
    ,o.nraflg -- NRA收款标志
    ,o.qsqdbh -- 清算渠道
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_bcd_bk o
    left join ${iol_schema}.isbs_bcd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bcd_cl d
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
-- truncate table ${iol_schema}.isbs_bcd;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_bcd exchange partition p_19000101 with table ${iol_schema}.isbs_bcd_cl;
alter table ${iol_schema}.isbs_bcd exchange partition p_20991231 with table ${iol_schema}.isbs_bcd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_bcd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bcd_op purge;
drop table ${iol_schema}.isbs_bcd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_bcd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_bcd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
