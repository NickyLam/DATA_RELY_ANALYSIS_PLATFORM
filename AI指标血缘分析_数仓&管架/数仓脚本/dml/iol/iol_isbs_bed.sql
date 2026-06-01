/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_bed
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
create table ${iol_schema}.isbs_bed_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_bed;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bed_op purge;
drop table ${iol_schema}.isbs_bed_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bed_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bed where 0=1;

create table ${iol_schema}.isbs_bed_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bed where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bed_cl(
            inr -- 出口单据ID
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,pnttyp -- 父类交易类型
            ,pntinr -- 父交易
            ,predat -- 提示日期
            ,rcvdat -- 到单日期
            ,shpdat -- 装船日期
            ,advdat -- 通知日期
            ,matdat -- 效期终止日期
            ,doctypcod -- 单据类型
            ,opndat -- 开始日期
            ,clsdat -- 结束日期
            ,credat -- 开证日期
            ,ownusr -- 负责人
            ,ver -- 版本号
            ,approvcod -- 凭保议付标志
            ,frepayflg -- 无偿放单标志
            ,docprbrol -- 出单人
            ,payrol -- 付款人
            ,orddat -- 保证金信件收到日
            ,mattxtflg -- 混合付款标志
            ,dscinsflg -- 不符点标志
            ,acpnowflg -- 现在承兑标志
            ,advtyp -- 收到通知类型
            ,disdat -- 不符点通知时间
            ,totcur -- 付款货币
            ,totamt -- 付款总金额
            ,totdat -- 付款时间
            ,docsta -- 单据状态
            ,docrol -- 单据接受者
            ,docrolflg -- 送单到其他地址标志
            ,dta770snd -- 回执信息发送时间
            ,advdocflg -- 返还单据标志
            ,etyextkey -- 用户所在组的关键字
            ,rmbrol -- 偿付行
            ,lescom -- 国外扣费
            ,bchkeyinr -- 经办机构号
            ,branchinr -- 所属机构号
            ,nraflg -- NRA付款标志
            ,trpdocnum -- 船运单号
            ,trpdoctyp -- 船运类型
            ,tradat -- 船单据日期
            ,tramod -- 运单方式
            ,blnum -- 单据编号
            ,connum -- 合同号
            ,invnum -- 发票号
            ,porlod -- 装运港
            ,portrs -- 转运港
            ,pordis -- 卸货港
            ,delplc -- 传送地
            ,vesnam -- 船名
            ,voynum -- 船次
            ,carnam -- 提单者
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bed_op(
            inr -- 出口单据ID
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,pnttyp -- 父类交易类型
            ,pntinr -- 父交易
            ,predat -- 提示日期
            ,rcvdat -- 到单日期
            ,shpdat -- 装船日期
            ,advdat -- 通知日期
            ,matdat -- 效期终止日期
            ,doctypcod -- 单据类型
            ,opndat -- 开始日期
            ,clsdat -- 结束日期
            ,credat -- 开证日期
            ,ownusr -- 负责人
            ,ver -- 版本号
            ,approvcod -- 凭保议付标志
            ,frepayflg -- 无偿放单标志
            ,docprbrol -- 出单人
            ,payrol -- 付款人
            ,orddat -- 保证金信件收到日
            ,mattxtflg -- 混合付款标志
            ,dscinsflg -- 不符点标志
            ,acpnowflg -- 现在承兑标志
            ,advtyp -- 收到通知类型
            ,disdat -- 不符点通知时间
            ,totcur -- 付款货币
            ,totamt -- 付款总金额
            ,totdat -- 付款时间
            ,docsta -- 单据状态
            ,docrol -- 单据接受者
            ,docrolflg -- 送单到其他地址标志
            ,dta770snd -- 回执信息发送时间
            ,advdocflg -- 返还单据标志
            ,etyextkey -- 用户所在组的关键字
            ,rmbrol -- 偿付行
            ,lescom -- 国外扣费
            ,bchkeyinr -- 经办机构号
            ,branchinr -- 所属机构号
            ,nraflg -- NRA付款标志
            ,trpdocnum -- 船运单号
            ,trpdoctyp -- 船运类型
            ,tradat -- 船单据日期
            ,tramod -- 运单方式
            ,blnum -- 单据编号
            ,connum -- 合同号
            ,invnum -- 发票号
            ,porlod -- 装运港
            ,portrs -- 转运港
            ,pordis -- 卸货港
            ,delplc -- 传送地
            ,vesnam -- 船名
            ,voynum -- 船次
            ,carnam -- 提单者
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 出口单据ID
    ,nvl(n.ownref, o.ownref) as ownref -- 参考号
    ,nvl(n.nam, o.nam) as nam -- 交易名称
    ,nvl(n.pnttyp, o.pnttyp) as pnttyp -- 父类交易类型
    ,nvl(n.pntinr, o.pntinr) as pntinr -- 父交易
    ,nvl(n.predat, o.predat) as predat -- 提示日期
    ,nvl(n.rcvdat, o.rcvdat) as rcvdat -- 到单日期
    ,nvl(n.shpdat, o.shpdat) as shpdat -- 装船日期
    ,nvl(n.advdat, o.advdat) as advdat -- 通知日期
    ,nvl(n.matdat, o.matdat) as matdat -- 效期终止日期
    ,nvl(n.doctypcod, o.doctypcod) as doctypcod -- 单据类型
    ,nvl(n.opndat, o.opndat) as opndat -- 开始日期
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 结束日期
    ,nvl(n.credat, o.credat) as credat -- 开证日期
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 负责人
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.approvcod, o.approvcod) as approvcod -- 凭保议付标志
    ,nvl(n.frepayflg, o.frepayflg) as frepayflg -- 无偿放单标志
    ,nvl(n.docprbrol, o.docprbrol) as docprbrol -- 出单人
    ,nvl(n.payrol, o.payrol) as payrol -- 付款人
    ,nvl(n.orddat, o.orddat) as orddat -- 保证金信件收到日
    ,nvl(n.mattxtflg, o.mattxtflg) as mattxtflg -- 混合付款标志
    ,nvl(n.dscinsflg, o.dscinsflg) as dscinsflg -- 不符点标志
    ,nvl(n.acpnowflg, o.acpnowflg) as acpnowflg -- 现在承兑标志
    ,nvl(n.advtyp, o.advtyp) as advtyp -- 收到通知类型
    ,nvl(n.disdat, o.disdat) as disdat -- 不符点通知时间
    ,nvl(n.totcur, o.totcur) as totcur -- 付款货币
    ,nvl(n.totamt, o.totamt) as totamt -- 付款总金额
    ,nvl(n.totdat, o.totdat) as totdat -- 付款时间
    ,nvl(n.docsta, o.docsta) as docsta -- 单据状态
    ,nvl(n.docrol, o.docrol) as docrol -- 单据接受者
    ,nvl(n.docrolflg, o.docrolflg) as docrolflg -- 送单到其他地址标志
    ,nvl(n.dta770snd, o.dta770snd) as dta770snd -- 回执信息发送时间
    ,nvl(n.advdocflg, o.advdocflg) as advdocflg -- 返还单据标志
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 用户所在组的关键字
    ,nvl(n.rmbrol, o.rmbrol) as rmbrol -- 偿付行
    ,nvl(n.lescom, o.lescom) as lescom -- 国外扣费
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 经办机构号
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 所属机构号
    ,nvl(n.nraflg, o.nraflg) as nraflg -- NRA付款标志
    ,nvl(n.trpdocnum, o.trpdocnum) as trpdocnum -- 船运单号
    ,nvl(n.trpdoctyp, o.trpdoctyp) as trpdoctyp -- 船运类型
    ,nvl(n.tradat, o.tradat) as tradat -- 船单据日期
    ,nvl(n.tramod, o.tramod) as tramod -- 运单方式
    ,nvl(n.blnum, o.blnum) as blnum -- 单据编号
    ,nvl(n.connum, o.connum) as connum -- 合同号
    ,nvl(n.invnum, o.invnum) as invnum -- 发票号
    ,nvl(n.porlod, o.porlod) as porlod -- 装运港
    ,nvl(n.portrs, o.portrs) as portrs -- 转运港
    ,nvl(n.pordis, o.pordis) as pordis -- 卸货港
    ,nvl(n.delplc, o.delplc) as delplc -- 传送地
    ,nvl(n.vesnam, o.vesnam) as vesnam -- 船名
    ,nvl(n.voynum, o.voynum) as voynum -- 船次
    ,nvl(n.carnam, o.carnam) as carnam -- 提单者
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
from (select * from ${iol_schema}.isbs_bed_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_bed where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.pnttyp <> n.pnttyp
        or o.pntinr <> n.pntinr
        or o.predat <> n.predat
        or o.rcvdat <> n.rcvdat
        or o.shpdat <> n.shpdat
        or o.advdat <> n.advdat
        or o.matdat <> n.matdat
        or o.doctypcod <> n.doctypcod
        or o.opndat <> n.opndat
        or o.clsdat <> n.clsdat
        or o.credat <> n.credat
        or o.ownusr <> n.ownusr
        or o.ver <> n.ver
        or o.approvcod <> n.approvcod
        or o.frepayflg <> n.frepayflg
        or o.docprbrol <> n.docprbrol
        or o.payrol <> n.payrol
        or o.orddat <> n.orddat
        or o.mattxtflg <> n.mattxtflg
        or o.dscinsflg <> n.dscinsflg
        or o.acpnowflg <> n.acpnowflg
        or o.advtyp <> n.advtyp
        or o.disdat <> n.disdat
        or o.totcur <> n.totcur
        or o.totamt <> n.totamt
        or o.totdat <> n.totdat
        or o.docsta <> n.docsta
        or o.docrol <> n.docrol
        or o.docrolflg <> n.docrolflg
        or o.dta770snd <> n.dta770snd
        or o.advdocflg <> n.advdocflg
        or o.etyextkey <> n.etyextkey
        or o.rmbrol <> n.rmbrol
        or o.lescom <> n.lescom
        or o.bchkeyinr <> n.bchkeyinr
        or o.branchinr <> n.branchinr
        or o.nraflg <> n.nraflg
        or o.trpdocnum <> n.trpdocnum
        or o.trpdoctyp <> n.trpdoctyp
        or o.tradat <> n.tradat
        or o.tramod <> n.tramod
        or o.blnum <> n.blnum
        or o.connum <> n.connum
        or o.invnum <> n.invnum
        or o.porlod <> n.porlod
        or o.portrs <> n.portrs
        or o.pordis <> n.pordis
        or o.delplc <> n.delplc
        or o.vesnam <> n.vesnam
        or o.voynum <> n.voynum
        or o.carnam <> n.carnam
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bed_cl(
            inr -- 出口单据ID
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,pnttyp -- 父类交易类型
            ,pntinr -- 父交易
            ,predat -- 提示日期
            ,rcvdat -- 到单日期
            ,shpdat -- 装船日期
            ,advdat -- 通知日期
            ,matdat -- 效期终止日期
            ,doctypcod -- 单据类型
            ,opndat -- 开始日期
            ,clsdat -- 结束日期
            ,credat -- 开证日期
            ,ownusr -- 负责人
            ,ver -- 版本号
            ,approvcod -- 凭保议付标志
            ,frepayflg -- 无偿放单标志
            ,docprbrol -- 出单人
            ,payrol -- 付款人
            ,orddat -- 保证金信件收到日
            ,mattxtflg -- 混合付款标志
            ,dscinsflg -- 不符点标志
            ,acpnowflg -- 现在承兑标志
            ,advtyp -- 收到通知类型
            ,disdat -- 不符点通知时间
            ,totcur -- 付款货币
            ,totamt -- 付款总金额
            ,totdat -- 付款时间
            ,docsta -- 单据状态
            ,docrol -- 单据接受者
            ,docrolflg -- 送单到其他地址标志
            ,dta770snd -- 回执信息发送时间
            ,advdocflg -- 返还单据标志
            ,etyextkey -- 用户所在组的关键字
            ,rmbrol -- 偿付行
            ,lescom -- 国外扣费
            ,bchkeyinr -- 经办机构号
            ,branchinr -- 所属机构号
            ,nraflg -- NRA付款标志
            ,trpdocnum -- 船运单号
            ,trpdoctyp -- 船运类型
            ,tradat -- 船单据日期
            ,tramod -- 运单方式
            ,blnum -- 单据编号
            ,connum -- 合同号
            ,invnum -- 发票号
            ,porlod -- 装运港
            ,portrs -- 转运港
            ,pordis -- 卸货港
            ,delplc -- 传送地
            ,vesnam -- 船名
            ,voynum -- 船次
            ,carnam -- 提单者
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bed_op(
            inr -- 出口单据ID
            ,ownref -- 参考号
            ,nam -- 交易名称
            ,pnttyp -- 父类交易类型
            ,pntinr -- 父交易
            ,predat -- 提示日期
            ,rcvdat -- 到单日期
            ,shpdat -- 装船日期
            ,advdat -- 通知日期
            ,matdat -- 效期终止日期
            ,doctypcod -- 单据类型
            ,opndat -- 开始日期
            ,clsdat -- 结束日期
            ,credat -- 开证日期
            ,ownusr -- 负责人
            ,ver -- 版本号
            ,approvcod -- 凭保议付标志
            ,frepayflg -- 无偿放单标志
            ,docprbrol -- 出单人
            ,payrol -- 付款人
            ,orddat -- 保证金信件收到日
            ,mattxtflg -- 混合付款标志
            ,dscinsflg -- 不符点标志
            ,acpnowflg -- 现在承兑标志
            ,advtyp -- 收到通知类型
            ,disdat -- 不符点通知时间
            ,totcur -- 付款货币
            ,totamt -- 付款总金额
            ,totdat -- 付款时间
            ,docsta -- 单据状态
            ,docrol -- 单据接受者
            ,docrolflg -- 送单到其他地址标志
            ,dta770snd -- 回执信息发送时间
            ,advdocflg -- 返还单据标志
            ,etyextkey -- 用户所在组的关键字
            ,rmbrol -- 偿付行
            ,lescom -- 国外扣费
            ,bchkeyinr -- 经办机构号
            ,branchinr -- 所属机构号
            ,nraflg -- NRA付款标志
            ,trpdocnum -- 船运单号
            ,trpdoctyp -- 船运类型
            ,tradat -- 船单据日期
            ,tramod -- 运单方式
            ,blnum -- 单据编号
            ,connum -- 合同号
            ,invnum -- 发票号
            ,porlod -- 装运港
            ,portrs -- 转运港
            ,pordis -- 卸货港
            ,delplc -- 传送地
            ,vesnam -- 船名
            ,voynum -- 船次
            ,carnam -- 提单者
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 出口单据ID
    ,o.ownref -- 参考号
    ,o.nam -- 交易名称
    ,o.pnttyp -- 父类交易类型
    ,o.pntinr -- 父交易
    ,o.predat -- 提示日期
    ,o.rcvdat -- 到单日期
    ,o.shpdat -- 装船日期
    ,o.advdat -- 通知日期
    ,o.matdat -- 效期终止日期
    ,o.doctypcod -- 单据类型
    ,o.opndat -- 开始日期
    ,o.clsdat -- 结束日期
    ,o.credat -- 开证日期
    ,o.ownusr -- 负责人
    ,o.ver -- 版本号
    ,o.approvcod -- 凭保议付标志
    ,o.frepayflg -- 无偿放单标志
    ,o.docprbrol -- 出单人
    ,o.payrol -- 付款人
    ,o.orddat -- 保证金信件收到日
    ,o.mattxtflg -- 混合付款标志
    ,o.dscinsflg -- 不符点标志
    ,o.acpnowflg -- 现在承兑标志
    ,o.advtyp -- 收到通知类型
    ,o.disdat -- 不符点通知时间
    ,o.totcur -- 付款货币
    ,o.totamt -- 付款总金额
    ,o.totdat -- 付款时间
    ,o.docsta -- 单据状态
    ,o.docrol -- 单据接受者
    ,o.docrolflg -- 送单到其他地址标志
    ,o.dta770snd -- 回执信息发送时间
    ,o.advdocflg -- 返还单据标志
    ,o.etyextkey -- 用户所在组的关键字
    ,o.rmbrol -- 偿付行
    ,o.lescom -- 国外扣费
    ,o.bchkeyinr -- 经办机构号
    ,o.branchinr -- 所属机构号
    ,o.nraflg -- NRA付款标志
    ,o.trpdocnum -- 船运单号
    ,o.trpdoctyp -- 船运类型
    ,o.tradat -- 船单据日期
    ,o.tramod -- 运单方式
    ,o.blnum -- 单据编号
    ,o.connum -- 合同号
    ,o.invnum -- 发票号
    ,o.porlod -- 装运港
    ,o.portrs -- 转运港
    ,o.pordis -- 卸货港
    ,o.delplc -- 传送地
    ,o.vesnam -- 船名
    ,o.voynum -- 船次
    ,o.carnam -- 提单者
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_bed_bk o
    left join ${iol_schema}.isbs_bed_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bed_cl d
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
-- truncate table ${iol_schema}.isbs_bed;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_bed exchange partition p_19000101 with table ${iol_schema}.isbs_bed_cl;
alter table ${iol_schema}.isbs_bed exchange partition p_20991231 with table ${iol_schema}.isbs_bed_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_bed to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bed_op purge;
drop table ${iol_schema}.isbs_bed_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_bed_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_bed',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
