/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_led
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
create table ${iol_schema}.isbs_led_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_led
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_led_op purge;
drop table ${iol_schema}.isbs_led_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_led_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_led where 0=1;

create table ${iol_schema}.isbs_led_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_led where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_led_cl(
            inr -- 出口信用证ID号
            ,ownref -- 参考号
            ,nam -- 标识交易的外部显示名称
            ,ownusr -- 经办人
            ,credat -- 创建日期
            ,opndat -- 开证日期, 指定信用证被开证行开出的日期
            ,clsdat -- 关闭日期
            ,cnfdat -- 保兑日
            ,advdat -- 通知日期
            ,issnam -- 开证行
            ,issref -- 开证行参考号
            ,amedat -- 修改日期
            ,amenbr -- 修改次数
            ,avbby -- 单据处理方式
            ,avbwth -- 单据处理行
            ,bennam -- 受益人
            ,benref -- 受益人参考号
            ,chato -- 费用分担
            ,cnfflg -- 承兑类型
            ,cnfdet -- 开证行保兑状态
            ,cnfsta -- 保兑状态’Y’,’S’,’ ’
            ,expdat -- 出口日期
            ,expplc -- 交易完成地点
            ,lcrtyp -- 付款种类
            ,nomspc -- 溢短装标志。
            ,nomtop -- 溢短装-正
            ,nomton -- 溢短装-负
            ,preadvdt -- 预通知日期
            ,shpdat -- 装船日期，指定装船的最后日期
            ,shpfro -- 装船地点
            ,shppar -- 运货地点
            ,shpto -- 运货地点
            ,shptrs -- 转载
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,utlnbr -- 利用数目
            ,ver -- 版本号
            ,aplbnkdirsnd -- 是否立即发送
            ,tenmaxday -- 最大期限
            ,cnfsnd -- 第一通知行保兑状态
            ,revflg -- 循环标志
            ,revnbr -- 循环信用证号
            ,revtimes -- 循环次数
            ,revdat -- 到单日
            ,revcum -- 累计记贷
            ,revtyp -- 循环类型
            ,cnfins -- 发给第二通知行确认栏位
            ,redclsflg -- 红/绿 条款
            ,advnbr -- 通知次数
            ,resflg -- 预留标志
            ,inctrf -- 开入的装让标志
            ,apprul -- 适用的条款
            ,apprultxt -- 其他适用的条款
            ,pordis -- 卸货港口
            ,porloa -- 部分装船
            ,nonban -- 与银行无关的开证人标志
            ,etyextkey -- 默认/初始用户ID
            ,partcon -- 保兑百分比
            ,collflg -- 信用证抵押标志位
            ,teskeyunc -- 检验是否确认
            ,dbtflg -- 记入借方授权标志
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,rskrat -- 风险额度占用率
            ,dflg -- dflg
            ,tratyp -- 运输方式
            ,negflg -- 
            ,shppars18 -- 
            ,prepers18 -- 
            ,prepertxts18 -- 
            ,shptrss18 -- 
            ,spcbenflg -- 
            ,spcrcbflg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_led_op(
            inr -- 出口信用证ID号
            ,ownref -- 参考号
            ,nam -- 标识交易的外部显示名称
            ,ownusr -- 经办人
            ,credat -- 创建日期
            ,opndat -- 开证日期, 指定信用证被开证行开出的日期
            ,clsdat -- 关闭日期
            ,cnfdat -- 保兑日
            ,advdat -- 通知日期
            ,issnam -- 开证行
            ,issref -- 开证行参考号
            ,amedat -- 修改日期
            ,amenbr -- 修改次数
            ,avbby -- 单据处理方式
            ,avbwth -- 单据处理行
            ,bennam -- 受益人
            ,benref -- 受益人参考号
            ,chato -- 费用分担
            ,cnfflg -- 承兑类型
            ,cnfdet -- 开证行保兑状态
            ,cnfsta -- 保兑状态’Y’,’S’,’ ’
            ,expdat -- 出口日期
            ,expplc -- 交易完成地点
            ,lcrtyp -- 付款种类
            ,nomspc -- 溢短装标志。
            ,nomtop -- 溢短装-正
            ,nomton -- 溢短装-负
            ,preadvdt -- 预通知日期
            ,shpdat -- 装船日期，指定装船的最后日期
            ,shpfro -- 装船地点
            ,shppar -- 运货地点
            ,shpto -- 运货地点
            ,shptrs -- 转载
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,utlnbr -- 利用数目
            ,ver -- 版本号
            ,aplbnkdirsnd -- 是否立即发送
            ,tenmaxday -- 最大期限
            ,cnfsnd -- 第一通知行保兑状态
            ,revflg -- 循环标志
            ,revnbr -- 循环信用证号
            ,revtimes -- 循环次数
            ,revdat -- 到单日
            ,revcum -- 累计记贷
            ,revtyp -- 循环类型
            ,cnfins -- 发给第二通知行确认栏位
            ,redclsflg -- 红/绿 条款
            ,advnbr -- 通知次数
            ,resflg -- 预留标志
            ,inctrf -- 开入的装让标志
            ,apprul -- 适用的条款
            ,apprultxt -- 其他适用的条款
            ,pordis -- 卸货港口
            ,porloa -- 部分装船
            ,nonban -- 与银行无关的开证人标志
            ,etyextkey -- 默认/初始用户ID
            ,partcon -- 保兑百分比
            ,collflg -- 信用证抵押标志位
            ,teskeyunc -- 检验是否确认
            ,dbtflg -- 记入借方授权标志
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,rskrat -- 风险额度占用率
            ,dflg -- dflg
            ,tratyp -- 运输方式
            ,negflg -- 
            ,shppars18 -- 
            ,prepers18 -- 
            ,prepertxts18 -- 
            ,shptrss18 -- 
            ,spcbenflg -- 
            ,spcrcbflg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 出口信用证ID号
    ,nvl(n.ownref, o.ownref) as ownref -- 参考号
    ,nvl(n.nam, o.nam) as nam -- 标识交易的外部显示名称
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 经办人
    ,nvl(n.credat, o.credat) as credat -- 创建日期
    ,nvl(n.opndat, o.opndat) as opndat -- 开证日期, 指定信用证被开证行开出的日期
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 关闭日期
    ,nvl(n.cnfdat, o.cnfdat) as cnfdat -- 保兑日
    ,nvl(n.advdat, o.advdat) as advdat -- 通知日期
    ,nvl(n.issnam, o.issnam) as issnam -- 开证行
    ,nvl(n.issref, o.issref) as issref -- 开证行参考号
    ,nvl(n.amedat, o.amedat) as amedat -- 修改日期
    ,nvl(n.amenbr, o.amenbr) as amenbr -- 修改次数
    ,nvl(n.avbby, o.avbby) as avbby -- 单据处理方式
    ,nvl(n.avbwth, o.avbwth) as avbwth -- 单据处理行
    ,nvl(n.bennam, o.bennam) as bennam -- 受益人
    ,nvl(n.benref, o.benref) as benref -- 受益人参考号
    ,nvl(n.chato, o.chato) as chato -- 费用分担
    ,nvl(n.cnfflg, o.cnfflg) as cnfflg -- 承兑类型
    ,nvl(n.cnfdet, o.cnfdet) as cnfdet -- 开证行保兑状态
    ,nvl(n.cnfsta, o.cnfsta) as cnfsta -- 保兑状态’Y’,’S’,’ ’
    ,nvl(n.expdat, o.expdat) as expdat -- 出口日期
    ,nvl(n.expplc, o.expplc) as expplc -- 交易完成地点
    ,nvl(n.lcrtyp, o.lcrtyp) as lcrtyp -- 付款种类
    ,nvl(n.nomspc, o.nomspc) as nomspc -- 溢短装标志。
    ,nvl(n.nomtop, o.nomtop) as nomtop -- 溢短装-正
    ,nvl(n.nomton, o.nomton) as nomton -- 溢短装-负
    ,nvl(n.preadvdt, o.preadvdt) as preadvdt -- 预通知日期
    ,nvl(n.shpdat, o.shpdat) as shpdat -- 装船日期，指定装船的最后日期
    ,nvl(n.shpfro, o.shpfro) as shpfro -- 装船地点
    ,nvl(n.shppar, o.shppar) as shppar -- 运货地点
    ,nvl(n.shpto, o.shpto) as shpto -- 运货地点
    ,nvl(n.shptrs, o.shptrs) as shptrs -- 转载
    ,nvl(n.stacty, o.stacty) as stacty -- 国家代码
    ,nvl(n.stagod, o.stagod) as stagod -- 货物代码
    ,nvl(n.utlnbr, o.utlnbr) as utlnbr -- 利用数目
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.aplbnkdirsnd, o.aplbnkdirsnd) as aplbnkdirsnd -- 是否立即发送
    ,nvl(n.tenmaxday, o.tenmaxday) as tenmaxday -- 最大期限
    ,nvl(n.cnfsnd, o.cnfsnd) as cnfsnd -- 第一通知行保兑状态
    ,nvl(n.revflg, o.revflg) as revflg -- 循环标志
    ,nvl(n.revnbr, o.revnbr) as revnbr -- 循环信用证号
    ,nvl(n.revtimes, o.revtimes) as revtimes -- 循环次数
    ,nvl(n.revdat, o.revdat) as revdat -- 到单日
    ,nvl(n.revcum, o.revcum) as revcum -- 累计记贷
    ,nvl(n.revtyp, o.revtyp) as revtyp -- 循环类型
    ,nvl(n.cnfins, o.cnfins) as cnfins -- 发给第二通知行确认栏位
    ,nvl(n.redclsflg, o.redclsflg) as redclsflg -- 红/绿 条款
    ,nvl(n.advnbr, o.advnbr) as advnbr -- 通知次数
    ,nvl(n.resflg, o.resflg) as resflg -- 预留标志
    ,nvl(n.inctrf, o.inctrf) as inctrf -- 开入的装让标志
    ,nvl(n.apprul, o.apprul) as apprul -- 适用的条款
    ,nvl(n.apprultxt, o.apprultxt) as apprultxt -- 其他适用的条款
    ,nvl(n.pordis, o.pordis) as pordis -- 卸货港口
    ,nvl(n.porloa, o.porloa) as porloa -- 部分装船
    ,nvl(n.nonban, o.nonban) as nonban -- 与银行无关的开证人标志
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 默认/初始用户ID
    ,nvl(n.partcon, o.partcon) as partcon -- 保兑百分比
    ,nvl(n.collflg, o.collflg) as collflg -- 信用证抵押标志位
    ,nvl(n.teskeyunc, o.teskeyunc) as teskeyunc -- 检验是否确认
    ,nvl(n.dbtflg, o.dbtflg) as dbtflg -- 记入借方授权标志
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 所属机构号
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 经办机构号
    ,nvl(n.rskrat, o.rskrat) as rskrat -- 风险额度占用率
    ,nvl(n.dflg, o.dflg) as dflg -- dflg
    ,nvl(n.tratyp, o.tratyp) as tratyp -- 运输方式
    ,nvl(n.negflg, o.negflg) as negflg -- 
    ,nvl(n.shppars18, o.shppars18) as shppars18 -- 
    ,nvl(n.prepers18, o.prepers18) as prepers18 -- 
    ,nvl(n.prepertxts18, o.prepertxts18) as prepertxts18 -- 
    ,nvl(n.shptrss18, o.shptrss18) as shptrss18 -- 
    ,nvl(n.spcbenflg, o.spcbenflg) as spcbenflg -- 
    ,nvl(n.spcrcbflg, o.spcrcbflg) as spcrcbflg -- 
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
from (select * from ${iol_schema}.isbs_led_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_led where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.cnfdat <> n.cnfdat
        or o.advdat <> n.advdat
        or o.issnam <> n.issnam
        or o.issref <> n.issref
        or o.amedat <> n.amedat
        or o.amenbr <> n.amenbr
        or o.avbby <> n.avbby
        or o.avbwth <> n.avbwth
        or o.bennam <> n.bennam
        or o.benref <> n.benref
        or o.chato <> n.chato
        or o.cnfflg <> n.cnfflg
        or o.cnfdet <> n.cnfdet
        or o.cnfsta <> n.cnfsta
        or o.expdat <> n.expdat
        or o.expplc <> n.expplc
        or o.lcrtyp <> n.lcrtyp
        or o.nomspc <> n.nomspc
        or o.nomtop <> n.nomtop
        or o.nomton <> n.nomton
        or o.preadvdt <> n.preadvdt
        or o.shpdat <> n.shpdat
        or o.shpfro <> n.shpfro
        or o.shppar <> n.shppar
        or o.shpto <> n.shpto
        or o.shptrs <> n.shptrs
        or o.stacty <> n.stacty
        or o.stagod <> n.stagod
        or o.utlnbr <> n.utlnbr
        or o.ver <> n.ver
        or o.aplbnkdirsnd <> n.aplbnkdirsnd
        or o.tenmaxday <> n.tenmaxday
        or o.cnfsnd <> n.cnfsnd
        or o.revflg <> n.revflg
        or o.revnbr <> n.revnbr
        or o.revtimes <> n.revtimes
        or o.revdat <> n.revdat
        or o.revcum <> n.revcum
        or o.revtyp <> n.revtyp
        or o.cnfins <> n.cnfins
        or o.redclsflg <> n.redclsflg
        or o.advnbr <> n.advnbr
        or o.resflg <> n.resflg
        or o.inctrf <> n.inctrf
        or o.apprul <> n.apprul
        or o.apprultxt <> n.apprultxt
        or o.pordis <> n.pordis
        or o.porloa <> n.porloa
        or o.nonban <> n.nonban
        or o.etyextkey <> n.etyextkey
        or o.partcon <> n.partcon
        or o.collflg <> n.collflg
        or o.teskeyunc <> n.teskeyunc
        or o.dbtflg <> n.dbtflg
        or o.branchinr <> n.branchinr
        or o.bchkeyinr <> n.bchkeyinr
        or o.rskrat <> n.rskrat
        or o.dflg <> n.dflg
        or o.tratyp <> n.tratyp
        or o.negflg <> n.negflg
        or o.shppars18 <> n.shppars18
        or o.prepers18 <> n.prepers18
        or o.prepertxts18 <> n.prepertxts18
        or o.shptrss18 <> n.shptrss18
        or o.spcbenflg <> n.spcbenflg
        or o.spcrcbflg <> n.spcrcbflg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_led_cl(
            inr -- 出口信用证ID号
            ,ownref -- 参考号
            ,nam -- 标识交易的外部显示名称
            ,ownusr -- 经办人
            ,credat -- 创建日期
            ,opndat -- 开证日期, 指定信用证被开证行开出的日期
            ,clsdat -- 关闭日期
            ,cnfdat -- 保兑日
            ,advdat -- 通知日期
            ,issnam -- 开证行
            ,issref -- 开证行参考号
            ,amedat -- 修改日期
            ,amenbr -- 修改次数
            ,avbby -- 单据处理方式
            ,avbwth -- 单据处理行
            ,bennam -- 受益人
            ,benref -- 受益人参考号
            ,chato -- 费用分担
            ,cnfflg -- 承兑类型
            ,cnfdet -- 开证行保兑状态
            ,cnfsta -- 保兑状态’Y’,’S’,’ ’
            ,expdat -- 出口日期
            ,expplc -- 交易完成地点
            ,lcrtyp -- 付款种类
            ,nomspc -- 溢短装标志。
            ,nomtop -- 溢短装-正
            ,nomton -- 溢短装-负
            ,preadvdt -- 预通知日期
            ,shpdat -- 装船日期，指定装船的最后日期
            ,shpfro -- 装船地点
            ,shppar -- 运货地点
            ,shpto -- 运货地点
            ,shptrs -- 转载
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,utlnbr -- 利用数目
            ,ver -- 版本号
            ,aplbnkdirsnd -- 是否立即发送
            ,tenmaxday -- 最大期限
            ,cnfsnd -- 第一通知行保兑状态
            ,revflg -- 循环标志
            ,revnbr -- 循环信用证号
            ,revtimes -- 循环次数
            ,revdat -- 到单日
            ,revcum -- 累计记贷
            ,revtyp -- 循环类型
            ,cnfins -- 发给第二通知行确认栏位
            ,redclsflg -- 红/绿 条款
            ,advnbr -- 通知次数
            ,resflg -- 预留标志
            ,inctrf -- 开入的装让标志
            ,apprul -- 适用的条款
            ,apprultxt -- 其他适用的条款
            ,pordis -- 卸货港口
            ,porloa -- 部分装船
            ,nonban -- 与银行无关的开证人标志
            ,etyextkey -- 默认/初始用户ID
            ,partcon -- 保兑百分比
            ,collflg -- 信用证抵押标志位
            ,teskeyunc -- 检验是否确认
            ,dbtflg -- 记入借方授权标志
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,rskrat -- 风险额度占用率
            ,dflg -- dflg
            ,tratyp -- 运输方式
            ,negflg -- 
            ,shppars18 -- 
            ,prepers18 -- 
            ,prepertxts18 -- 
            ,shptrss18 -- 
            ,spcbenflg -- 
            ,spcrcbflg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_led_op(
            inr -- 出口信用证ID号
            ,ownref -- 参考号
            ,nam -- 标识交易的外部显示名称
            ,ownusr -- 经办人
            ,credat -- 创建日期
            ,opndat -- 开证日期, 指定信用证被开证行开出的日期
            ,clsdat -- 关闭日期
            ,cnfdat -- 保兑日
            ,advdat -- 通知日期
            ,issnam -- 开证行
            ,issref -- 开证行参考号
            ,amedat -- 修改日期
            ,amenbr -- 修改次数
            ,avbby -- 单据处理方式
            ,avbwth -- 单据处理行
            ,bennam -- 受益人
            ,benref -- 受益人参考号
            ,chato -- 费用分担
            ,cnfflg -- 承兑类型
            ,cnfdet -- 开证行保兑状态
            ,cnfsta -- 保兑状态’Y’,’S’,’ ’
            ,expdat -- 出口日期
            ,expplc -- 交易完成地点
            ,lcrtyp -- 付款种类
            ,nomspc -- 溢短装标志。
            ,nomtop -- 溢短装-正
            ,nomton -- 溢短装-负
            ,preadvdt -- 预通知日期
            ,shpdat -- 装船日期，指定装船的最后日期
            ,shpfro -- 装船地点
            ,shppar -- 运货地点
            ,shpto -- 运货地点
            ,shptrs -- 转载
            ,stacty -- 国家代码
            ,stagod -- 货物代码
            ,utlnbr -- 利用数目
            ,ver -- 版本号
            ,aplbnkdirsnd -- 是否立即发送
            ,tenmaxday -- 最大期限
            ,cnfsnd -- 第一通知行保兑状态
            ,revflg -- 循环标志
            ,revnbr -- 循环信用证号
            ,revtimes -- 循环次数
            ,revdat -- 到单日
            ,revcum -- 累计记贷
            ,revtyp -- 循环类型
            ,cnfins -- 发给第二通知行确认栏位
            ,redclsflg -- 红/绿 条款
            ,advnbr -- 通知次数
            ,resflg -- 预留标志
            ,inctrf -- 开入的装让标志
            ,apprul -- 适用的条款
            ,apprultxt -- 其他适用的条款
            ,pordis -- 卸货港口
            ,porloa -- 部分装船
            ,nonban -- 与银行无关的开证人标志
            ,etyextkey -- 默认/初始用户ID
            ,partcon -- 保兑百分比
            ,collflg -- 信用证抵押标志位
            ,teskeyunc -- 检验是否确认
            ,dbtflg -- 记入借方授权标志
            ,branchinr -- 所属机构号
            ,bchkeyinr -- 经办机构号
            ,rskrat -- 风险额度占用率
            ,dflg -- dflg
            ,tratyp -- 运输方式
            ,negflg -- 
            ,shppars18 -- 
            ,prepers18 -- 
            ,prepertxts18 -- 
            ,shptrss18 -- 
            ,spcbenflg -- 
            ,spcrcbflg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 出口信用证ID号
    ,o.ownref -- 参考号
    ,o.nam -- 标识交易的外部显示名称
    ,o.ownusr -- 经办人
    ,o.credat -- 创建日期
    ,o.opndat -- 开证日期, 指定信用证被开证行开出的日期
    ,o.clsdat -- 关闭日期
    ,o.cnfdat -- 保兑日
    ,o.advdat -- 通知日期
    ,o.issnam -- 开证行
    ,o.issref -- 开证行参考号
    ,o.amedat -- 修改日期
    ,o.amenbr -- 修改次数
    ,o.avbby -- 单据处理方式
    ,o.avbwth -- 单据处理行
    ,o.bennam -- 受益人
    ,o.benref -- 受益人参考号
    ,o.chato -- 费用分担
    ,o.cnfflg -- 承兑类型
    ,o.cnfdet -- 开证行保兑状态
    ,o.cnfsta -- 保兑状态’Y’,’S’,’ ’
    ,o.expdat -- 出口日期
    ,o.expplc -- 交易完成地点
    ,o.lcrtyp -- 付款种类
    ,o.nomspc -- 溢短装标志。
    ,o.nomtop -- 溢短装-正
    ,o.nomton -- 溢短装-负
    ,o.preadvdt -- 预通知日期
    ,o.shpdat -- 装船日期，指定装船的最后日期
    ,o.shpfro -- 装船地点
    ,o.shppar -- 运货地点
    ,o.shpto -- 运货地点
    ,o.shptrs -- 转载
    ,o.stacty -- 国家代码
    ,o.stagod -- 货物代码
    ,o.utlnbr -- 利用数目
    ,o.ver -- 版本号
    ,o.aplbnkdirsnd -- 是否立即发送
    ,o.tenmaxday -- 最大期限
    ,o.cnfsnd -- 第一通知行保兑状态
    ,o.revflg -- 循环标志
    ,o.revnbr -- 循环信用证号
    ,o.revtimes -- 循环次数
    ,o.revdat -- 到单日
    ,o.revcum -- 累计记贷
    ,o.revtyp -- 循环类型
    ,o.cnfins -- 发给第二通知行确认栏位
    ,o.redclsflg -- 红/绿 条款
    ,o.advnbr -- 通知次数
    ,o.resflg -- 预留标志
    ,o.inctrf -- 开入的装让标志
    ,o.apprul -- 适用的条款
    ,o.apprultxt -- 其他适用的条款
    ,o.pordis -- 卸货港口
    ,o.porloa -- 部分装船
    ,o.nonban -- 与银行无关的开证人标志
    ,o.etyextkey -- 默认/初始用户ID
    ,o.partcon -- 保兑百分比
    ,o.collflg -- 信用证抵押标志位
    ,o.teskeyunc -- 检验是否确认
    ,o.dbtflg -- 记入借方授权标志
    ,o.branchinr -- 所属机构号
    ,o.bchkeyinr -- 经办机构号
    ,o.rskrat -- 风险额度占用率
    ,o.dflg -- dflg
    ,o.tratyp -- 运输方式
    ,o.negflg -- 
    ,o.shppars18 -- 
    ,o.prepers18 -- 
    ,o.prepertxts18 -- 
    ,o.shptrss18 -- 
    ,o.spcbenflg -- 
    ,o.spcrcbflg -- 
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
from ${iol_schema}.isbs_led_bk o
    left join ${iol_schema}.isbs_led_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_led_cl d
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
--truncate table ${iol_schema}.isbs_led;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_led') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_led drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_led add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_led exchange partition p_${batch_date} with table ${iol_schema}.isbs_led_cl;
alter table ${iol_schema}.isbs_led exchange partition p_20991231 with table ${iol_schema}.isbs_led_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_led to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_led_op purge;
drop table ${iol_schema}.isbs_led_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_led_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_led',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
