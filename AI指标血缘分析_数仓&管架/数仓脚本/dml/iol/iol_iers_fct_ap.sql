/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_fct_ap
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
create table ${iol_schema}.iers_fct_ap_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_fct_ap
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fct_ap_op purge;
drop table ${iol_schema}.iers_fct_ap_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fct_ap_op nologging
for exchange with table
${iol_schema}.iers_fct_ap;

create table ${iol_schema}.iers_fct_ap_cl nologging
for exchange with table
${iol_schema}.iers_fct_ap;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fct_ap_cl(
            actualinvalidate -- 实际终止日期
            ,actualvalidate -- 实际生效日期
            ,approver -- 审批人
            ,bankaccount -- 对方银行账号
            ,billmaker -- 制单人
            ,blatest -- 是否最新版本
            ,bordernumexec -- 已生成订单量作为合同执行
            ,btriatradeflag -- 三角贸易
            ,cbilltypecode -- 单据类型
            ,ccurrencyid -- 本位币
            ,corigcurrencyid -- 币种
            ,cprojectid -- 项目
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,crececountryid -- 收货国家/地区
            ,csendcountryid -- 发货国家/地区
            ,ctaxcountryid -- 报税货国家/地区
            ,ctname -- 合同名称
            ,ctname2 -- 合同名称2
            ,ctname3 -- 合同名称3
            ,ctname4 -- 合同名称4
            ,ctname5 -- 合同名称5
            ,ctname6 -- 合同名称6
            ,ctrantypeid -- 合同类型
            ,custunit -- 对方单位说明
            ,cvendorid -- 供应商
            ,dbilldate -- 单据日期
            ,deliaddr -- 交货地点
            ,depid -- 承办部门
            ,depid_v -- 承办部门版本
            ,dmakedate -- 制单日期
            ,dr -- 删除标志
            ,earlysign -- 期初标志
            ,fbuysellflag -- 购销类型
            ,fstatusflag -- 合同状态
            ,invallidate -- 计划终止日期
            ,iprintcount -- 打印次数
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,mountcalculation -- 计划金额计算方式
            ,nexchangerate -- 折本汇率
            ,nglobalexchgrate -- 全局本位币汇率
            ,ngroupexchgrate -- 集团本位币汇率
            ,norigcopamount -- 累计原币应付金额
            ,norigplanamount -- 累计原币预付款金额
            ,norigpshamount -- 累计原币付款金额
            ,norikpmny -- 累计原币收票金额
            ,noriprepaylimitmny -- 预付款限额
            ,noriprepaymny -- 预付款
            ,nprepaylimitmny -- 本币预付款限额
            ,nprepaymny -- 本币预付款
            ,ntotalastnum -- 总数量
            ,ntotalcopamount -- 累计本币应付金额
            ,ntotalgpamount -- 累计本币付款金额
            ,ntotalorigmny -- 原币价税合计
            ,ntotalplanamount -- 累计本币预付款金额
            ,ntotaltaxmny -- 本币价税合计
            ,openct -- 是否敞口合同
            ,organizer -- 承办组织
            ,organizer_v -- 承办组织版本
            ,ourbankaccount -- 本方银行账号
            ,oursignatory -- 本方签字人
            ,overrate -- 超合同付款比例
            ,personnelid -- 承办人员
            ,pk_fct_ap -- 付款合同主键
            ,pk_group -- 集团
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_origct -- 原始主键
            ,pk_payterm -- 付款协议
            ,saga_btxid -- 
            ,saga_frozen -- 
            ,saga_gtxid -- 
            ,saga_status -- 
            ,signatory -- 对方签字人
            ,signorg -- 签约组织
            ,signorg_v -- 签约组织版本
            ,subscribedate -- 签字盖章日期
            ,taudittime -- 审批日期
            ,taxpayernumber -- 对方纳税人识别号
            ,ts -- 时间戳
            ,unconfpayableorg -- 未确认本币应付金额
            ,unconfpayableori -- 未确认原币应付金额
            ,unconfpaymentorg -- 未确认本币付款金额
            ,unconfpaymentori -- 未确认原币付款金额
            ,valdate -- 计划生效日期
            ,vbillcode -- 合同编码
            ,vdef1 -- 自定义项1
            ,vdef10 -- 自定义项10
            ,vdef11 -- 自定义项11
            ,vdef12 -- 自定义项12
            ,vdef13 -- 自定义项13
            ,vdef14 -- 自定义项14
            ,vdef15 -- 自定义项15
            ,vdef16 -- 自定义项16
            ,vdef17 -- 自定义项17
            ,vdef18 -- 自定义项18
            ,vdef19 -- 自定义项19
            ,vdef2 -- 自定义项2
            ,vdef20 -- 自定义项20
            ,vdef21 -- 自定义项21
            ,vdef22 -- 自定义项22
            ,vdef23 -- 自定义项23
            ,vdef24 -- 自定义项24
            ,vdef25 -- 自定义项25
            ,vdef26 -- 自定义项26
            ,vdef27 -- 自定义项27
            ,vdef28 -- 自定义项28
            ,vdef29 -- 自定义项29
            ,vdef3 -- 自定义项3
            ,vdef30 -- 自定义项30
            ,vdef31 -- 自定义项31
            ,vdef32 -- 自定义项32
            ,vdef33 -- 自定义项33
            ,vdef34 -- 自定义项34
            ,vdef35 -- 自定义项35
            ,vdef36 -- 自定义项36
            ,vdef37 -- 自定义项37
            ,vdef38 -- 自定义项38
            ,vdef39 -- 自定义项39
            ,vdef4 -- 自定义项4
            ,vdef40 -- 自定义项40
            ,vdef41 -- 自定义项41
            ,vdef42 -- 自定义项42
            ,vdef43 -- 自定义项43
            ,vdef44 -- 自定义项44
            ,vdef45 -- 自定义项45
            ,vdef46 -- 自定义项46
            ,vdef47 -- 自定义项47
            ,vdef48 -- 自定义项48
            ,vdef49 -- 自定义项49
            ,vdef5 -- 自定义项5
            ,vdef50 -- 自定义项50
            ,vdef51 -- 自定义项51
            ,vdef52 -- 自定义项52
            ,vdef53 -- 自定义项53
            ,vdef54 -- 自定义项54
            ,vdef55 -- 自定义项55
            ,vdef56 -- 自定义项56
            ,vdef57 -- 自定义项57
            ,vdef58 -- 自定义项58
            ,vdef59 -- 自定义项59
            ,vdef6 -- 自定义项6
            ,vdef60 -- 自定义项60
            ,vdef61 -- 自定义项61
            ,vdef62 -- 自定义项62
            ,vdef63 -- 自定义项63
            ,vdef64 -- 自定义项64
            ,vdef65 -- 自定义项65
            ,vdef66 -- 自定义项66
            ,vdef67 -- 自定义项67
            ,vdef68 -- 自定义项68
            ,vdef69 -- 自定义项69
            ,vdef7 -- 自定义项7
            ,vdef70 -- 自定义项70
            ,vdef71 -- 自定义项71
            ,vdef72 -- 自定义项72
            ,vdef73 -- 自定义项73
            ,vdef74 -- 自定义项74
            ,vdef75 -- 自定义项75
            ,vdef76 -- 自定义项76
            ,vdef77 -- 自定义项77
            ,vdef78 -- 自定义项78
            ,vdef79 -- 自定义项79
            ,vdef8 -- 自定义项8
            ,vdef80 -- 自定义项80
            ,vdef81 -- 自定义项81
            ,vdef82 -- 自定义项82
            ,vdef83 -- 自定义项83
            ,vdef84 -- 自定义项84
            ,vdef85 -- 自定义项85
            ,vdef86 -- 自定义项86
            ,vdef87 -- 自定义项87
            ,vdef88 -- 自定义项88
            ,vdef89 -- 自定义项89
            ,vdef9 -- 自定义项9
            ,vdef90 -- 自定义项90
            ,version -- 版本号
            ,vtrantypecode -- 合同类型编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fct_ap_op(
            actualinvalidate -- 实际终止日期
            ,actualvalidate -- 实际生效日期
            ,approver -- 审批人
            ,bankaccount -- 对方银行账号
            ,billmaker -- 制单人
            ,blatest -- 是否最新版本
            ,bordernumexec -- 已生成订单量作为合同执行
            ,btriatradeflag -- 三角贸易
            ,cbilltypecode -- 单据类型
            ,ccurrencyid -- 本位币
            ,corigcurrencyid -- 币种
            ,cprojectid -- 项目
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,crececountryid -- 收货国家/地区
            ,csendcountryid -- 发货国家/地区
            ,ctaxcountryid -- 报税货国家/地区
            ,ctname -- 合同名称
            ,ctname2 -- 合同名称2
            ,ctname3 -- 合同名称3
            ,ctname4 -- 合同名称4
            ,ctname5 -- 合同名称5
            ,ctname6 -- 合同名称6
            ,ctrantypeid -- 合同类型
            ,custunit -- 对方单位说明
            ,cvendorid -- 供应商
            ,dbilldate -- 单据日期
            ,deliaddr -- 交货地点
            ,depid -- 承办部门
            ,depid_v -- 承办部门版本
            ,dmakedate -- 制单日期
            ,dr -- 删除标志
            ,earlysign -- 期初标志
            ,fbuysellflag -- 购销类型
            ,fstatusflag -- 合同状态
            ,invallidate -- 计划终止日期
            ,iprintcount -- 打印次数
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,mountcalculation -- 计划金额计算方式
            ,nexchangerate -- 折本汇率
            ,nglobalexchgrate -- 全局本位币汇率
            ,ngroupexchgrate -- 集团本位币汇率
            ,norigcopamount -- 累计原币应付金额
            ,norigplanamount -- 累计原币预付款金额
            ,norigpshamount -- 累计原币付款金额
            ,norikpmny -- 累计原币收票金额
            ,noriprepaylimitmny -- 预付款限额
            ,noriprepaymny -- 预付款
            ,nprepaylimitmny -- 本币预付款限额
            ,nprepaymny -- 本币预付款
            ,ntotalastnum -- 总数量
            ,ntotalcopamount -- 累计本币应付金额
            ,ntotalgpamount -- 累计本币付款金额
            ,ntotalorigmny -- 原币价税合计
            ,ntotalplanamount -- 累计本币预付款金额
            ,ntotaltaxmny -- 本币价税合计
            ,openct -- 是否敞口合同
            ,organizer -- 承办组织
            ,organizer_v -- 承办组织版本
            ,ourbankaccount -- 本方银行账号
            ,oursignatory -- 本方签字人
            ,overrate -- 超合同付款比例
            ,personnelid -- 承办人员
            ,pk_fct_ap -- 付款合同主键
            ,pk_group -- 集团
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_origct -- 原始主键
            ,pk_payterm -- 付款协议
            ,saga_btxid -- 
            ,saga_frozen -- 
            ,saga_gtxid -- 
            ,saga_status -- 
            ,signatory -- 对方签字人
            ,signorg -- 签约组织
            ,signorg_v -- 签约组织版本
            ,subscribedate -- 签字盖章日期
            ,taudittime -- 审批日期
            ,taxpayernumber -- 对方纳税人识别号
            ,ts -- 时间戳
            ,unconfpayableorg -- 未确认本币应付金额
            ,unconfpayableori -- 未确认原币应付金额
            ,unconfpaymentorg -- 未确认本币付款金额
            ,unconfpaymentori -- 未确认原币付款金额
            ,valdate -- 计划生效日期
            ,vbillcode -- 合同编码
            ,vdef1 -- 自定义项1
            ,vdef10 -- 自定义项10
            ,vdef11 -- 自定义项11
            ,vdef12 -- 自定义项12
            ,vdef13 -- 自定义项13
            ,vdef14 -- 自定义项14
            ,vdef15 -- 自定义项15
            ,vdef16 -- 自定义项16
            ,vdef17 -- 自定义项17
            ,vdef18 -- 自定义项18
            ,vdef19 -- 自定义项19
            ,vdef2 -- 自定义项2
            ,vdef20 -- 自定义项20
            ,vdef21 -- 自定义项21
            ,vdef22 -- 自定义项22
            ,vdef23 -- 自定义项23
            ,vdef24 -- 自定义项24
            ,vdef25 -- 自定义项25
            ,vdef26 -- 自定义项26
            ,vdef27 -- 自定义项27
            ,vdef28 -- 自定义项28
            ,vdef29 -- 自定义项29
            ,vdef3 -- 自定义项3
            ,vdef30 -- 自定义项30
            ,vdef31 -- 自定义项31
            ,vdef32 -- 自定义项32
            ,vdef33 -- 自定义项33
            ,vdef34 -- 自定义项34
            ,vdef35 -- 自定义项35
            ,vdef36 -- 自定义项36
            ,vdef37 -- 自定义项37
            ,vdef38 -- 自定义项38
            ,vdef39 -- 自定义项39
            ,vdef4 -- 自定义项4
            ,vdef40 -- 自定义项40
            ,vdef41 -- 自定义项41
            ,vdef42 -- 自定义项42
            ,vdef43 -- 自定义项43
            ,vdef44 -- 自定义项44
            ,vdef45 -- 自定义项45
            ,vdef46 -- 自定义项46
            ,vdef47 -- 自定义项47
            ,vdef48 -- 自定义项48
            ,vdef49 -- 自定义项49
            ,vdef5 -- 自定义项5
            ,vdef50 -- 自定义项50
            ,vdef51 -- 自定义项51
            ,vdef52 -- 自定义项52
            ,vdef53 -- 自定义项53
            ,vdef54 -- 自定义项54
            ,vdef55 -- 自定义项55
            ,vdef56 -- 自定义项56
            ,vdef57 -- 自定义项57
            ,vdef58 -- 自定义项58
            ,vdef59 -- 自定义项59
            ,vdef6 -- 自定义项6
            ,vdef60 -- 自定义项60
            ,vdef61 -- 自定义项61
            ,vdef62 -- 自定义项62
            ,vdef63 -- 自定义项63
            ,vdef64 -- 自定义项64
            ,vdef65 -- 自定义项65
            ,vdef66 -- 自定义项66
            ,vdef67 -- 自定义项67
            ,vdef68 -- 自定义项68
            ,vdef69 -- 自定义项69
            ,vdef7 -- 自定义项7
            ,vdef70 -- 自定义项70
            ,vdef71 -- 自定义项71
            ,vdef72 -- 自定义项72
            ,vdef73 -- 自定义项73
            ,vdef74 -- 自定义项74
            ,vdef75 -- 自定义项75
            ,vdef76 -- 自定义项76
            ,vdef77 -- 自定义项77
            ,vdef78 -- 自定义项78
            ,vdef79 -- 自定义项79
            ,vdef8 -- 自定义项8
            ,vdef80 -- 自定义项80
            ,vdef81 -- 自定义项81
            ,vdef82 -- 自定义项82
            ,vdef83 -- 自定义项83
            ,vdef84 -- 自定义项84
            ,vdef85 -- 自定义项85
            ,vdef86 -- 自定义项86
            ,vdef87 -- 自定义项87
            ,vdef88 -- 自定义项88
            ,vdef89 -- 自定义项89
            ,vdef9 -- 自定义项9
            ,vdef90 -- 自定义项90
            ,version -- 版本号
            ,vtrantypecode -- 合同类型编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.actualinvalidate, o.actualinvalidate) as actualinvalidate -- 实际终止日期
    ,nvl(n.actualvalidate, o.actualvalidate) as actualvalidate -- 实际生效日期
    ,nvl(n.approver, o.approver) as approver -- 审批人
    ,nvl(n.bankaccount, o.bankaccount) as bankaccount -- 对方银行账号
    ,nvl(n.billmaker, o.billmaker) as billmaker -- 制单人
    ,nvl(n.blatest, o.blatest) as blatest -- 是否最新版本
    ,nvl(n.bordernumexec, o.bordernumexec) as bordernumexec -- 已生成订单量作为合同执行
    ,nvl(n.btriatradeflag, o.btriatradeflag) as btriatradeflag -- 三角贸易
    ,nvl(n.cbilltypecode, o.cbilltypecode) as cbilltypecode -- 单据类型
    ,nvl(n.ccurrencyid, o.ccurrencyid) as ccurrencyid -- 本位币
    ,nvl(n.corigcurrencyid, o.corigcurrencyid) as corigcurrencyid -- 币种
    ,nvl(n.cprojectid, o.cprojectid) as cprojectid -- 项目
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.crececountryid, o.crececountryid) as crececountryid -- 收货国家/地区
    ,nvl(n.csendcountryid, o.csendcountryid) as csendcountryid -- 发货国家/地区
    ,nvl(n.ctaxcountryid, o.ctaxcountryid) as ctaxcountryid -- 报税货国家/地区
    ,nvl(n.ctname, o.ctname) as ctname -- 合同名称
    ,nvl(n.ctname2, o.ctname2) as ctname2 -- 合同名称2
    ,nvl(n.ctname3, o.ctname3) as ctname3 -- 合同名称3
    ,nvl(n.ctname4, o.ctname4) as ctname4 -- 合同名称4
    ,nvl(n.ctname5, o.ctname5) as ctname5 -- 合同名称5
    ,nvl(n.ctname6, o.ctname6) as ctname6 -- 合同名称6
    ,nvl(n.ctrantypeid, o.ctrantypeid) as ctrantypeid -- 合同类型
    ,nvl(n.custunit, o.custunit) as custunit -- 对方单位说明
    ,nvl(n.cvendorid, o.cvendorid) as cvendorid -- 供应商
    ,nvl(n.dbilldate, o.dbilldate) as dbilldate -- 单据日期
    ,nvl(n.deliaddr, o.deliaddr) as deliaddr -- 交货地点
    ,nvl(n.depid, o.depid) as depid -- 承办部门
    ,nvl(n.depid_v, o.depid_v) as depid_v -- 承办部门版本
    ,nvl(n.dmakedate, o.dmakedate) as dmakedate -- 制单日期
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.earlysign, o.earlysign) as earlysign -- 期初标志
    ,nvl(n.fbuysellflag, o.fbuysellflag) as fbuysellflag -- 购销类型
    ,nvl(n.fstatusflag, o.fstatusflag) as fstatusflag -- 合同状态
    ,nvl(n.invallidate, o.invallidate) as invallidate -- 计划终止日期
    ,nvl(n.iprintcount, o.iprintcount) as iprintcount -- 打印次数
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 最后修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 最后修改人
    ,nvl(n.mountcalculation, o.mountcalculation) as mountcalculation -- 计划金额计算方式
    ,nvl(n.nexchangerate, o.nexchangerate) as nexchangerate -- 折本汇率
    ,nvl(n.nglobalexchgrate, o.nglobalexchgrate) as nglobalexchgrate -- 全局本位币汇率
    ,nvl(n.ngroupexchgrate, o.ngroupexchgrate) as ngroupexchgrate -- 集团本位币汇率
    ,nvl(n.norigcopamount, o.norigcopamount) as norigcopamount -- 累计原币应付金额
    ,nvl(n.norigplanamount, o.norigplanamount) as norigplanamount -- 累计原币预付款金额
    ,nvl(n.norigpshamount, o.norigpshamount) as norigpshamount -- 累计原币付款金额
    ,nvl(n.norikpmny, o.norikpmny) as norikpmny -- 累计原币收票金额
    ,nvl(n.noriprepaylimitmny, o.noriprepaylimitmny) as noriprepaylimitmny -- 预付款限额
    ,nvl(n.noriprepaymny, o.noriprepaymny) as noriprepaymny -- 预付款
    ,nvl(n.nprepaylimitmny, o.nprepaylimitmny) as nprepaylimitmny -- 本币预付款限额
    ,nvl(n.nprepaymny, o.nprepaymny) as nprepaymny -- 本币预付款
    ,nvl(n.ntotalastnum, o.ntotalastnum) as ntotalastnum -- 总数量
    ,nvl(n.ntotalcopamount, o.ntotalcopamount) as ntotalcopamount -- 累计本币应付金额
    ,nvl(n.ntotalgpamount, o.ntotalgpamount) as ntotalgpamount -- 累计本币付款金额
    ,nvl(n.ntotalorigmny, o.ntotalorigmny) as ntotalorigmny -- 原币价税合计
    ,nvl(n.ntotalplanamount, o.ntotalplanamount) as ntotalplanamount -- 累计本币预付款金额
    ,nvl(n.ntotaltaxmny, o.ntotaltaxmny) as ntotaltaxmny -- 本币价税合计
    ,nvl(n.openct, o.openct) as openct -- 是否敞口合同
    ,nvl(n.organizer, o.organizer) as organizer -- 承办组织
    ,nvl(n.organizer_v, o.organizer_v) as organizer_v -- 承办组织版本
    ,nvl(n.ourbankaccount, o.ourbankaccount) as ourbankaccount -- 本方银行账号
    ,nvl(n.oursignatory, o.oursignatory) as oursignatory -- 本方签字人
    ,nvl(n.overrate, o.overrate) as overrate -- 超合同付款比例
    ,nvl(n.personnelid, o.personnelid) as personnelid -- 承办人员
    ,nvl(n.pk_fct_ap, o.pk_fct_ap) as pk_fct_ap -- 付款合同主键
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 集团
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 财务组织
    ,nvl(n.pk_org_v, o.pk_org_v) as pk_org_v -- 财务组织版本
    ,nvl(n.pk_origct, o.pk_origct) as pk_origct -- 原始主键
    ,nvl(n.pk_payterm, o.pk_payterm) as pk_payterm -- 付款协议
    ,nvl(n.saga_btxid, o.saga_btxid) as saga_btxid -- 
    ,nvl(n.saga_frozen, o.saga_frozen) as saga_frozen -- 
    ,nvl(n.saga_gtxid, o.saga_gtxid) as saga_gtxid -- 
    ,nvl(n.saga_status, o.saga_status) as saga_status -- 
    ,nvl(n.signatory, o.signatory) as signatory -- 对方签字人
    ,nvl(n.signorg, o.signorg) as signorg -- 签约组织
    ,nvl(n.signorg_v, o.signorg_v) as signorg_v -- 签约组织版本
    ,nvl(n.subscribedate, o.subscribedate) as subscribedate -- 签字盖章日期
    ,nvl(n.taudittime, o.taudittime) as taudittime -- 审批日期
    ,nvl(n.taxpayernumber, o.taxpayernumber) as taxpayernumber -- 对方纳税人识别号
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.unconfpayableorg, o.unconfpayableorg) as unconfpayableorg -- 未确认本币应付金额
    ,nvl(n.unconfpayableori, o.unconfpayableori) as unconfpayableori -- 未确认原币应付金额
    ,nvl(n.unconfpaymentorg, o.unconfpaymentorg) as unconfpaymentorg -- 未确认本币付款金额
    ,nvl(n.unconfpaymentori, o.unconfpaymentori) as unconfpaymentori -- 未确认原币付款金额
    ,nvl(n.valdate, o.valdate) as valdate -- 计划生效日期
    ,nvl(n.vbillcode, o.vbillcode) as vbillcode -- 合同编码
    ,nvl(n.vdef1, o.vdef1) as vdef1 -- 自定义项1
    ,nvl(n.vdef10, o.vdef10) as vdef10 -- 自定义项10
    ,nvl(n.vdef11, o.vdef11) as vdef11 -- 自定义项11
    ,nvl(n.vdef12, o.vdef12) as vdef12 -- 自定义项12
    ,nvl(n.vdef13, o.vdef13) as vdef13 -- 自定义项13
    ,nvl(n.vdef14, o.vdef14) as vdef14 -- 自定义项14
    ,nvl(n.vdef15, o.vdef15) as vdef15 -- 自定义项15
    ,nvl(n.vdef16, o.vdef16) as vdef16 -- 自定义项16
    ,nvl(n.vdef17, o.vdef17) as vdef17 -- 自定义项17
    ,nvl(n.vdef18, o.vdef18) as vdef18 -- 自定义项18
    ,nvl(n.vdef19, o.vdef19) as vdef19 -- 自定义项19
    ,nvl(n.vdef2, o.vdef2) as vdef2 -- 自定义项2
    ,nvl(n.vdef20, o.vdef20) as vdef20 -- 自定义项20
    ,nvl(n.vdef21, o.vdef21) as vdef21 -- 自定义项21
    ,nvl(n.vdef22, o.vdef22) as vdef22 -- 自定义项22
    ,nvl(n.vdef23, o.vdef23) as vdef23 -- 自定义项23
    ,nvl(n.vdef24, o.vdef24) as vdef24 -- 自定义项24
    ,nvl(n.vdef25, o.vdef25) as vdef25 -- 自定义项25
    ,nvl(n.vdef26, o.vdef26) as vdef26 -- 自定义项26
    ,nvl(n.vdef27, o.vdef27) as vdef27 -- 自定义项27
    ,nvl(n.vdef28, o.vdef28) as vdef28 -- 自定义项28
    ,nvl(n.vdef29, o.vdef29) as vdef29 -- 自定义项29
    ,nvl(n.vdef3, o.vdef3) as vdef3 -- 自定义项3
    ,nvl(n.vdef30, o.vdef30) as vdef30 -- 自定义项30
    ,nvl(n.vdef31, o.vdef31) as vdef31 -- 自定义项31
    ,nvl(n.vdef32, o.vdef32) as vdef32 -- 自定义项32
    ,nvl(n.vdef33, o.vdef33) as vdef33 -- 自定义项33
    ,nvl(n.vdef34, o.vdef34) as vdef34 -- 自定义项34
    ,nvl(n.vdef35, o.vdef35) as vdef35 -- 自定义项35
    ,nvl(n.vdef36, o.vdef36) as vdef36 -- 自定义项36
    ,nvl(n.vdef37, o.vdef37) as vdef37 -- 自定义项37
    ,nvl(n.vdef38, o.vdef38) as vdef38 -- 自定义项38
    ,nvl(n.vdef39, o.vdef39) as vdef39 -- 自定义项39
    ,nvl(n.vdef4, o.vdef4) as vdef4 -- 自定义项4
    ,nvl(n.vdef40, o.vdef40) as vdef40 -- 自定义项40
    ,nvl(n.vdef41, o.vdef41) as vdef41 -- 自定义项41
    ,nvl(n.vdef42, o.vdef42) as vdef42 -- 自定义项42
    ,nvl(n.vdef43, o.vdef43) as vdef43 -- 自定义项43
    ,nvl(n.vdef44, o.vdef44) as vdef44 -- 自定义项44
    ,nvl(n.vdef45, o.vdef45) as vdef45 -- 自定义项45
    ,nvl(n.vdef46, o.vdef46) as vdef46 -- 自定义项46
    ,nvl(n.vdef47, o.vdef47) as vdef47 -- 自定义项47
    ,nvl(n.vdef48, o.vdef48) as vdef48 -- 自定义项48
    ,nvl(n.vdef49, o.vdef49) as vdef49 -- 自定义项49
    ,nvl(n.vdef5, o.vdef5) as vdef5 -- 自定义项5
    ,nvl(n.vdef50, o.vdef50) as vdef50 -- 自定义项50
    ,nvl(n.vdef51, o.vdef51) as vdef51 -- 自定义项51
    ,nvl(n.vdef52, o.vdef52) as vdef52 -- 自定义项52
    ,nvl(n.vdef53, o.vdef53) as vdef53 -- 自定义项53
    ,nvl(n.vdef54, o.vdef54) as vdef54 -- 自定义项54
    ,nvl(n.vdef55, o.vdef55) as vdef55 -- 自定义项55
    ,nvl(n.vdef56, o.vdef56) as vdef56 -- 自定义项56
    ,nvl(n.vdef57, o.vdef57) as vdef57 -- 自定义项57
    ,nvl(n.vdef58, o.vdef58) as vdef58 -- 自定义项58
    ,nvl(n.vdef59, o.vdef59) as vdef59 -- 自定义项59
    ,nvl(n.vdef6, o.vdef6) as vdef6 -- 自定义项6
    ,nvl(n.vdef60, o.vdef60) as vdef60 -- 自定义项60
    ,nvl(n.vdef61, o.vdef61) as vdef61 -- 自定义项61
    ,nvl(n.vdef62, o.vdef62) as vdef62 -- 自定义项62
    ,nvl(n.vdef63, o.vdef63) as vdef63 -- 自定义项63
    ,nvl(n.vdef64, o.vdef64) as vdef64 -- 自定义项64
    ,nvl(n.vdef65, o.vdef65) as vdef65 -- 自定义项65
    ,nvl(n.vdef66, o.vdef66) as vdef66 -- 自定义项66
    ,nvl(n.vdef67, o.vdef67) as vdef67 -- 自定义项67
    ,nvl(n.vdef68, o.vdef68) as vdef68 -- 自定义项68
    ,nvl(n.vdef69, o.vdef69) as vdef69 -- 自定义项69
    ,nvl(n.vdef7, o.vdef7) as vdef7 -- 自定义项7
    ,nvl(n.vdef70, o.vdef70) as vdef70 -- 自定义项70
    ,nvl(n.vdef71, o.vdef71) as vdef71 -- 自定义项71
    ,nvl(n.vdef72, o.vdef72) as vdef72 -- 自定义项72
    ,nvl(n.vdef73, o.vdef73) as vdef73 -- 自定义项73
    ,nvl(n.vdef74, o.vdef74) as vdef74 -- 自定义项74
    ,nvl(n.vdef75, o.vdef75) as vdef75 -- 自定义项75
    ,nvl(n.vdef76, o.vdef76) as vdef76 -- 自定义项76
    ,nvl(n.vdef77, o.vdef77) as vdef77 -- 自定义项77
    ,nvl(n.vdef78, o.vdef78) as vdef78 -- 自定义项78
    ,nvl(n.vdef79, o.vdef79) as vdef79 -- 自定义项79
    ,nvl(n.vdef8, o.vdef8) as vdef8 -- 自定义项8
    ,nvl(n.vdef80, o.vdef80) as vdef80 -- 自定义项80
    ,nvl(n.vdef81, o.vdef81) as vdef81 -- 自定义项81
    ,nvl(n.vdef82, o.vdef82) as vdef82 -- 自定义项82
    ,nvl(n.vdef83, o.vdef83) as vdef83 -- 自定义项83
    ,nvl(n.vdef84, o.vdef84) as vdef84 -- 自定义项84
    ,nvl(n.vdef85, o.vdef85) as vdef85 -- 自定义项85
    ,nvl(n.vdef86, o.vdef86) as vdef86 -- 自定义项86
    ,nvl(n.vdef87, o.vdef87) as vdef87 -- 自定义项87
    ,nvl(n.vdef88, o.vdef88) as vdef88 -- 自定义项88
    ,nvl(n.vdef89, o.vdef89) as vdef89 -- 自定义项89
    ,nvl(n.vdef9, o.vdef9) as vdef9 -- 自定义项9
    ,nvl(n.vdef90, o.vdef90) as vdef90 -- 自定义项90
    ,nvl(n.version, o.version) as version -- 版本号
    ,nvl(n.vtrantypecode, o.vtrantypecode) as vtrantypecode -- 合同类型编码
    ,case when
            n.pk_fct_ap is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_fct_ap is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_fct_ap is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_fct_ap_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_fct_ap where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_fct_ap = n.pk_fct_ap
where (
        o.pk_fct_ap is null
    )
    or (
        n.pk_fct_ap is null
    )
    or (
        o.actualinvalidate <> n.actualinvalidate
        or o.actualvalidate <> n.actualvalidate
        or o.approver <> n.approver
        or o.bankaccount <> n.bankaccount
        or o.billmaker <> n.billmaker
        or o.blatest <> n.blatest
        or o.bordernumexec <> n.bordernumexec
        or o.btriatradeflag <> n.btriatradeflag
        or o.cbilltypecode <> n.cbilltypecode
        or o.ccurrencyid <> n.ccurrencyid
        or o.corigcurrencyid <> n.corigcurrencyid
        or o.cprojectid <> n.cprojectid
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.crececountryid <> n.crececountryid
        or o.csendcountryid <> n.csendcountryid
        or o.ctaxcountryid <> n.ctaxcountryid
        or o.ctname <> n.ctname
        or o.ctname2 <> n.ctname2
        or o.ctname3 <> n.ctname3
        or o.ctname4 <> n.ctname4
        or o.ctname5 <> n.ctname5
        or o.ctname6 <> n.ctname6
        or o.ctrantypeid <> n.ctrantypeid
        or o.custunit <> n.custunit
        or o.cvendorid <> n.cvendorid
        or o.dbilldate <> n.dbilldate
        or o.deliaddr <> n.deliaddr
        or o.depid <> n.depid
        or o.depid_v <> n.depid_v
        or o.dmakedate <> n.dmakedate
        or o.dr <> n.dr
        or o.earlysign <> n.earlysign
        or o.fbuysellflag <> n.fbuysellflag
        or o.fstatusflag <> n.fstatusflag
        or o.invallidate <> n.invallidate
        or o.iprintcount <> n.iprintcount
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.mountcalculation <> n.mountcalculation
        or o.nexchangerate <> n.nexchangerate
        or o.nglobalexchgrate <> n.nglobalexchgrate
        or o.ngroupexchgrate <> n.ngroupexchgrate
        or o.norigcopamount <> n.norigcopamount
        or o.norigplanamount <> n.norigplanamount
        or o.norigpshamount <> n.norigpshamount
        or o.norikpmny <> n.norikpmny
        or o.noriprepaylimitmny <> n.noriprepaylimitmny
        or o.noriprepaymny <> n.noriprepaymny
        or o.nprepaylimitmny <> n.nprepaylimitmny
        or o.nprepaymny <> n.nprepaymny
        or o.ntotalastnum <> n.ntotalastnum
        or o.ntotalcopamount <> n.ntotalcopamount
        or o.ntotalgpamount <> n.ntotalgpamount
        or o.ntotalorigmny <> n.ntotalorigmny
        or o.ntotalplanamount <> n.ntotalplanamount
        or o.ntotaltaxmny <> n.ntotaltaxmny
        or o.openct <> n.openct
        or o.organizer <> n.organizer
        or o.organizer_v <> n.organizer_v
        or o.ourbankaccount <> n.ourbankaccount
        or o.oursignatory <> n.oursignatory
        or o.overrate <> n.overrate
        or o.personnelid <> n.personnelid
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_org_v <> n.pk_org_v
        or o.pk_origct <> n.pk_origct
        or o.pk_payterm <> n.pk_payterm
        or o.saga_btxid <> n.saga_btxid
        or o.saga_frozen <> n.saga_frozen
        or o.saga_gtxid <> n.saga_gtxid
        or o.saga_status <> n.saga_status
        or o.signatory <> n.signatory
        or o.signorg <> n.signorg
        or o.signorg_v <> n.signorg_v
        or o.subscribedate <> n.subscribedate
        or o.taudittime <> n.taudittime
        or o.taxpayernumber <> n.taxpayernumber
        or o.ts <> n.ts
        or o.unconfpayableorg <> n.unconfpayableorg
        or o.unconfpayableori <> n.unconfpayableori
        or o.unconfpaymentorg <> n.unconfpaymentorg
        or o.unconfpaymentori <> n.unconfpaymentori
        or o.valdate <> n.valdate
        or o.vbillcode <> n.vbillcode
        or o.vdef1 <> n.vdef1
        or o.vdef10 <> n.vdef10
        or o.vdef11 <> n.vdef11
        or o.vdef12 <> n.vdef12
        or o.vdef13 <> n.vdef13
        or o.vdef14 <> n.vdef14
        or o.vdef15 <> n.vdef15
        or o.vdef16 <> n.vdef16
        or o.vdef17 <> n.vdef17
        or o.vdef18 <> n.vdef18
        or o.vdef19 <> n.vdef19
        or o.vdef2 <> n.vdef2
        or o.vdef20 <> n.vdef20
        or o.vdef21 <> n.vdef21
        or o.vdef22 <> n.vdef22
        or o.vdef23 <> n.vdef23
        or o.vdef24 <> n.vdef24
        or o.vdef25 <> n.vdef25
        or o.vdef26 <> n.vdef26
        or o.vdef27 <> n.vdef27
        or o.vdef28 <> n.vdef28
        or o.vdef29 <> n.vdef29
        or o.vdef3 <> n.vdef3
        or o.vdef30 <> n.vdef30
        or o.vdef31 <> n.vdef31
        or o.vdef32 <> n.vdef32
        or o.vdef33 <> n.vdef33
        or o.vdef34 <> n.vdef34
        or o.vdef35 <> n.vdef35
        or o.vdef36 <> n.vdef36
        or o.vdef37 <> n.vdef37
        or o.vdef38 <> n.vdef38
        or o.vdef39 <> n.vdef39
        or o.vdef4 <> n.vdef4
        or o.vdef40 <> n.vdef40
        or o.vdef41 <> n.vdef41
        or o.vdef42 <> n.vdef42
        or o.vdef43 <> n.vdef43
        or o.vdef44 <> n.vdef44
        or o.vdef45 <> n.vdef45
        or o.vdef46 <> n.vdef46
        or o.vdef47 <> n.vdef47
        or o.vdef48 <> n.vdef48
        or o.vdef49 <> n.vdef49
        or o.vdef5 <> n.vdef5
        or o.vdef50 <> n.vdef50
        or o.vdef51 <> n.vdef51
        or o.vdef52 <> n.vdef52
        or o.vdef53 <> n.vdef53
        or o.vdef54 <> n.vdef54
        or o.vdef55 <> n.vdef55
        or o.vdef56 <> n.vdef56
        or o.vdef57 <> n.vdef57
        or o.vdef58 <> n.vdef58
        or o.vdef59 <> n.vdef59
        or o.vdef6 <> n.vdef6
        or o.vdef60 <> n.vdef60
        or o.vdef61 <> n.vdef61
        or o.vdef62 <> n.vdef62
        or o.vdef63 <> n.vdef63
        or o.vdef64 <> n.vdef64
        or o.vdef65 <> n.vdef65
        or o.vdef66 <> n.vdef66
        or o.vdef67 <> n.vdef67
        or o.vdef68 <> n.vdef68
        or o.vdef69 <> n.vdef69
        or o.vdef7 <> n.vdef7
        or o.vdef70 <> n.vdef70
        or o.vdef71 <> n.vdef71
        or o.vdef72 <> n.vdef72
        or o.vdef73 <> n.vdef73
        or o.vdef74 <> n.vdef74
        or o.vdef75 <> n.vdef75
        or o.vdef76 <> n.vdef76
        or o.vdef77 <> n.vdef77
        or o.vdef78 <> n.vdef78
        or o.vdef79 <> n.vdef79
        or o.vdef8 <> n.vdef8
        or o.vdef80 <> n.vdef80
        or o.vdef81 <> n.vdef81
        or o.vdef82 <> n.vdef82
        or o.vdef83 <> n.vdef83
        or o.vdef84 <> n.vdef84
        or o.vdef85 <> n.vdef85
        or o.vdef86 <> n.vdef86
        or o.vdef87 <> n.vdef87
        or o.vdef88 <> n.vdef88
        or o.vdef89 <> n.vdef89
        or o.vdef9 <> n.vdef9
        or o.vdef90 <> n.vdef90
        or o.version <> n.version
        or o.vtrantypecode <> n.vtrantypecode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fct_ap_cl(
            actualinvalidate -- 实际终止日期
            ,actualvalidate -- 实际生效日期
            ,approver -- 审批人
            ,bankaccount -- 对方银行账号
            ,billmaker -- 制单人
            ,blatest -- 是否最新版本
            ,bordernumexec -- 已生成订单量作为合同执行
            ,btriatradeflag -- 三角贸易
            ,cbilltypecode -- 单据类型
            ,ccurrencyid -- 本位币
            ,corigcurrencyid -- 币种
            ,cprojectid -- 项目
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,crececountryid -- 收货国家/地区
            ,csendcountryid -- 发货国家/地区
            ,ctaxcountryid -- 报税货国家/地区
            ,ctname -- 合同名称
            ,ctname2 -- 合同名称2
            ,ctname3 -- 合同名称3
            ,ctname4 -- 合同名称4
            ,ctname5 -- 合同名称5
            ,ctname6 -- 合同名称6
            ,ctrantypeid -- 合同类型
            ,custunit -- 对方单位说明
            ,cvendorid -- 供应商
            ,dbilldate -- 单据日期
            ,deliaddr -- 交货地点
            ,depid -- 承办部门
            ,depid_v -- 承办部门版本
            ,dmakedate -- 制单日期
            ,dr -- 删除标志
            ,earlysign -- 期初标志
            ,fbuysellflag -- 购销类型
            ,fstatusflag -- 合同状态
            ,invallidate -- 计划终止日期
            ,iprintcount -- 打印次数
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,mountcalculation -- 计划金额计算方式
            ,nexchangerate -- 折本汇率
            ,nglobalexchgrate -- 全局本位币汇率
            ,ngroupexchgrate -- 集团本位币汇率
            ,norigcopamount -- 累计原币应付金额
            ,norigplanamount -- 累计原币预付款金额
            ,norigpshamount -- 累计原币付款金额
            ,norikpmny -- 累计原币收票金额
            ,noriprepaylimitmny -- 预付款限额
            ,noriprepaymny -- 预付款
            ,nprepaylimitmny -- 本币预付款限额
            ,nprepaymny -- 本币预付款
            ,ntotalastnum -- 总数量
            ,ntotalcopamount -- 累计本币应付金额
            ,ntotalgpamount -- 累计本币付款金额
            ,ntotalorigmny -- 原币价税合计
            ,ntotalplanamount -- 累计本币预付款金额
            ,ntotaltaxmny -- 本币价税合计
            ,openct -- 是否敞口合同
            ,organizer -- 承办组织
            ,organizer_v -- 承办组织版本
            ,ourbankaccount -- 本方银行账号
            ,oursignatory -- 本方签字人
            ,overrate -- 超合同付款比例
            ,personnelid -- 承办人员
            ,pk_fct_ap -- 付款合同主键
            ,pk_group -- 集团
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_origct -- 原始主键
            ,pk_payterm -- 付款协议
            ,saga_btxid -- 
            ,saga_frozen -- 
            ,saga_gtxid -- 
            ,saga_status -- 
            ,signatory -- 对方签字人
            ,signorg -- 签约组织
            ,signorg_v -- 签约组织版本
            ,subscribedate -- 签字盖章日期
            ,taudittime -- 审批日期
            ,taxpayernumber -- 对方纳税人识别号
            ,ts -- 时间戳
            ,unconfpayableorg -- 未确认本币应付金额
            ,unconfpayableori -- 未确认原币应付金额
            ,unconfpaymentorg -- 未确认本币付款金额
            ,unconfpaymentori -- 未确认原币付款金额
            ,valdate -- 计划生效日期
            ,vbillcode -- 合同编码
            ,vdef1 -- 自定义项1
            ,vdef10 -- 自定义项10
            ,vdef11 -- 自定义项11
            ,vdef12 -- 自定义项12
            ,vdef13 -- 自定义项13
            ,vdef14 -- 自定义项14
            ,vdef15 -- 自定义项15
            ,vdef16 -- 自定义项16
            ,vdef17 -- 自定义项17
            ,vdef18 -- 自定义项18
            ,vdef19 -- 自定义项19
            ,vdef2 -- 自定义项2
            ,vdef20 -- 自定义项20
            ,vdef21 -- 自定义项21
            ,vdef22 -- 自定义项22
            ,vdef23 -- 自定义项23
            ,vdef24 -- 自定义项24
            ,vdef25 -- 自定义项25
            ,vdef26 -- 自定义项26
            ,vdef27 -- 自定义项27
            ,vdef28 -- 自定义项28
            ,vdef29 -- 自定义项29
            ,vdef3 -- 自定义项3
            ,vdef30 -- 自定义项30
            ,vdef31 -- 自定义项31
            ,vdef32 -- 自定义项32
            ,vdef33 -- 自定义项33
            ,vdef34 -- 自定义项34
            ,vdef35 -- 自定义项35
            ,vdef36 -- 自定义项36
            ,vdef37 -- 自定义项37
            ,vdef38 -- 自定义项38
            ,vdef39 -- 自定义项39
            ,vdef4 -- 自定义项4
            ,vdef40 -- 自定义项40
            ,vdef41 -- 自定义项41
            ,vdef42 -- 自定义项42
            ,vdef43 -- 自定义项43
            ,vdef44 -- 自定义项44
            ,vdef45 -- 自定义项45
            ,vdef46 -- 自定义项46
            ,vdef47 -- 自定义项47
            ,vdef48 -- 自定义项48
            ,vdef49 -- 自定义项49
            ,vdef5 -- 自定义项5
            ,vdef50 -- 自定义项50
            ,vdef51 -- 自定义项51
            ,vdef52 -- 自定义项52
            ,vdef53 -- 自定义项53
            ,vdef54 -- 自定义项54
            ,vdef55 -- 自定义项55
            ,vdef56 -- 自定义项56
            ,vdef57 -- 自定义项57
            ,vdef58 -- 自定义项58
            ,vdef59 -- 自定义项59
            ,vdef6 -- 自定义项6
            ,vdef60 -- 自定义项60
            ,vdef61 -- 自定义项61
            ,vdef62 -- 自定义项62
            ,vdef63 -- 自定义项63
            ,vdef64 -- 自定义项64
            ,vdef65 -- 自定义项65
            ,vdef66 -- 自定义项66
            ,vdef67 -- 自定义项67
            ,vdef68 -- 自定义项68
            ,vdef69 -- 自定义项69
            ,vdef7 -- 自定义项7
            ,vdef70 -- 自定义项70
            ,vdef71 -- 自定义项71
            ,vdef72 -- 自定义项72
            ,vdef73 -- 自定义项73
            ,vdef74 -- 自定义项74
            ,vdef75 -- 自定义项75
            ,vdef76 -- 自定义项76
            ,vdef77 -- 自定义项77
            ,vdef78 -- 自定义项78
            ,vdef79 -- 自定义项79
            ,vdef8 -- 自定义项8
            ,vdef80 -- 自定义项80
            ,vdef81 -- 自定义项81
            ,vdef82 -- 自定义项82
            ,vdef83 -- 自定义项83
            ,vdef84 -- 自定义项84
            ,vdef85 -- 自定义项85
            ,vdef86 -- 自定义项86
            ,vdef87 -- 自定义项87
            ,vdef88 -- 自定义项88
            ,vdef89 -- 自定义项89
            ,vdef9 -- 自定义项9
            ,vdef90 -- 自定义项90
            ,version -- 版本号
            ,vtrantypecode -- 合同类型编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fct_ap_op(
            actualinvalidate -- 实际终止日期
            ,actualvalidate -- 实际生效日期
            ,approver -- 审批人
            ,bankaccount -- 对方银行账号
            ,billmaker -- 制单人
            ,blatest -- 是否最新版本
            ,bordernumexec -- 已生成订单量作为合同执行
            ,btriatradeflag -- 三角贸易
            ,cbilltypecode -- 单据类型
            ,ccurrencyid -- 本位币
            ,corigcurrencyid -- 币种
            ,cprojectid -- 项目
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,crececountryid -- 收货国家/地区
            ,csendcountryid -- 发货国家/地区
            ,ctaxcountryid -- 报税货国家/地区
            ,ctname -- 合同名称
            ,ctname2 -- 合同名称2
            ,ctname3 -- 合同名称3
            ,ctname4 -- 合同名称4
            ,ctname5 -- 合同名称5
            ,ctname6 -- 合同名称6
            ,ctrantypeid -- 合同类型
            ,custunit -- 对方单位说明
            ,cvendorid -- 供应商
            ,dbilldate -- 单据日期
            ,deliaddr -- 交货地点
            ,depid -- 承办部门
            ,depid_v -- 承办部门版本
            ,dmakedate -- 制单日期
            ,dr -- 删除标志
            ,earlysign -- 期初标志
            ,fbuysellflag -- 购销类型
            ,fstatusflag -- 合同状态
            ,invallidate -- 计划终止日期
            ,iprintcount -- 打印次数
            ,modifiedtime -- 最后修改时间
            ,modifier -- 最后修改人
            ,mountcalculation -- 计划金额计算方式
            ,nexchangerate -- 折本汇率
            ,nglobalexchgrate -- 全局本位币汇率
            ,ngroupexchgrate -- 集团本位币汇率
            ,norigcopamount -- 累计原币应付金额
            ,norigplanamount -- 累计原币预付款金额
            ,norigpshamount -- 累计原币付款金额
            ,norikpmny -- 累计原币收票金额
            ,noriprepaylimitmny -- 预付款限额
            ,noriprepaymny -- 预付款
            ,nprepaylimitmny -- 本币预付款限额
            ,nprepaymny -- 本币预付款
            ,ntotalastnum -- 总数量
            ,ntotalcopamount -- 累计本币应付金额
            ,ntotalgpamount -- 累计本币付款金额
            ,ntotalorigmny -- 原币价税合计
            ,ntotalplanamount -- 累计本币预付款金额
            ,ntotaltaxmny -- 本币价税合计
            ,openct -- 是否敞口合同
            ,organizer -- 承办组织
            ,organizer_v -- 承办组织版本
            ,ourbankaccount -- 本方银行账号
            ,oursignatory -- 本方签字人
            ,overrate -- 超合同付款比例
            ,personnelid -- 承办人员
            ,pk_fct_ap -- 付款合同主键
            ,pk_group -- 集团
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_origct -- 原始主键
            ,pk_payterm -- 付款协议
            ,saga_btxid -- 
            ,saga_frozen -- 
            ,saga_gtxid -- 
            ,saga_status -- 
            ,signatory -- 对方签字人
            ,signorg -- 签约组织
            ,signorg_v -- 签约组织版本
            ,subscribedate -- 签字盖章日期
            ,taudittime -- 审批日期
            ,taxpayernumber -- 对方纳税人识别号
            ,ts -- 时间戳
            ,unconfpayableorg -- 未确认本币应付金额
            ,unconfpayableori -- 未确认原币应付金额
            ,unconfpaymentorg -- 未确认本币付款金额
            ,unconfpaymentori -- 未确认原币付款金额
            ,valdate -- 计划生效日期
            ,vbillcode -- 合同编码
            ,vdef1 -- 自定义项1
            ,vdef10 -- 自定义项10
            ,vdef11 -- 自定义项11
            ,vdef12 -- 自定义项12
            ,vdef13 -- 自定义项13
            ,vdef14 -- 自定义项14
            ,vdef15 -- 自定义项15
            ,vdef16 -- 自定义项16
            ,vdef17 -- 自定义项17
            ,vdef18 -- 自定义项18
            ,vdef19 -- 自定义项19
            ,vdef2 -- 自定义项2
            ,vdef20 -- 自定义项20
            ,vdef21 -- 自定义项21
            ,vdef22 -- 自定义项22
            ,vdef23 -- 自定义项23
            ,vdef24 -- 自定义项24
            ,vdef25 -- 自定义项25
            ,vdef26 -- 自定义项26
            ,vdef27 -- 自定义项27
            ,vdef28 -- 自定义项28
            ,vdef29 -- 自定义项29
            ,vdef3 -- 自定义项3
            ,vdef30 -- 自定义项30
            ,vdef31 -- 自定义项31
            ,vdef32 -- 自定义项32
            ,vdef33 -- 自定义项33
            ,vdef34 -- 自定义项34
            ,vdef35 -- 自定义项35
            ,vdef36 -- 自定义项36
            ,vdef37 -- 自定义项37
            ,vdef38 -- 自定义项38
            ,vdef39 -- 自定义项39
            ,vdef4 -- 自定义项4
            ,vdef40 -- 自定义项40
            ,vdef41 -- 自定义项41
            ,vdef42 -- 自定义项42
            ,vdef43 -- 自定义项43
            ,vdef44 -- 自定义项44
            ,vdef45 -- 自定义项45
            ,vdef46 -- 自定义项46
            ,vdef47 -- 自定义项47
            ,vdef48 -- 自定义项48
            ,vdef49 -- 自定义项49
            ,vdef5 -- 自定义项5
            ,vdef50 -- 自定义项50
            ,vdef51 -- 自定义项51
            ,vdef52 -- 自定义项52
            ,vdef53 -- 自定义项53
            ,vdef54 -- 自定义项54
            ,vdef55 -- 自定义项55
            ,vdef56 -- 自定义项56
            ,vdef57 -- 自定义项57
            ,vdef58 -- 自定义项58
            ,vdef59 -- 自定义项59
            ,vdef6 -- 自定义项6
            ,vdef60 -- 自定义项60
            ,vdef61 -- 自定义项61
            ,vdef62 -- 自定义项62
            ,vdef63 -- 自定义项63
            ,vdef64 -- 自定义项64
            ,vdef65 -- 自定义项65
            ,vdef66 -- 自定义项66
            ,vdef67 -- 自定义项67
            ,vdef68 -- 自定义项68
            ,vdef69 -- 自定义项69
            ,vdef7 -- 自定义项7
            ,vdef70 -- 自定义项70
            ,vdef71 -- 自定义项71
            ,vdef72 -- 自定义项72
            ,vdef73 -- 自定义项73
            ,vdef74 -- 自定义项74
            ,vdef75 -- 自定义项75
            ,vdef76 -- 自定义项76
            ,vdef77 -- 自定义项77
            ,vdef78 -- 自定义项78
            ,vdef79 -- 自定义项79
            ,vdef8 -- 自定义项8
            ,vdef80 -- 自定义项80
            ,vdef81 -- 自定义项81
            ,vdef82 -- 自定义项82
            ,vdef83 -- 自定义项83
            ,vdef84 -- 自定义项84
            ,vdef85 -- 自定义项85
            ,vdef86 -- 自定义项86
            ,vdef87 -- 自定义项87
            ,vdef88 -- 自定义项88
            ,vdef89 -- 自定义项89
            ,vdef9 -- 自定义项9
            ,vdef90 -- 自定义项90
            ,version -- 版本号
            ,vtrantypecode -- 合同类型编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.actualinvalidate -- 实际终止日期
    ,o.actualvalidate -- 实际生效日期
    ,o.approver -- 审批人
    ,o.bankaccount -- 对方银行账号
    ,o.billmaker -- 制单人
    ,o.blatest -- 是否最新版本
    ,o.bordernumexec -- 已生成订单量作为合同执行
    ,o.btriatradeflag -- 三角贸易
    ,o.cbilltypecode -- 单据类型
    ,o.ccurrencyid -- 本位币
    ,o.corigcurrencyid -- 币种
    ,o.cprojectid -- 项目
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.crececountryid -- 收货国家/地区
    ,o.csendcountryid -- 发货国家/地区
    ,o.ctaxcountryid -- 报税货国家/地区
    ,o.ctname -- 合同名称
    ,o.ctname2 -- 合同名称2
    ,o.ctname3 -- 合同名称3
    ,o.ctname4 -- 合同名称4
    ,o.ctname5 -- 合同名称5
    ,o.ctname6 -- 合同名称6
    ,o.ctrantypeid -- 合同类型
    ,o.custunit -- 对方单位说明
    ,o.cvendorid -- 供应商
    ,o.dbilldate -- 单据日期
    ,o.deliaddr -- 交货地点
    ,o.depid -- 承办部门
    ,o.depid_v -- 承办部门版本
    ,o.dmakedate -- 制单日期
    ,o.dr -- 删除标志
    ,o.earlysign -- 期初标志
    ,o.fbuysellflag -- 购销类型
    ,o.fstatusflag -- 合同状态
    ,o.invallidate -- 计划终止日期
    ,o.iprintcount -- 打印次数
    ,o.modifiedtime -- 最后修改时间
    ,o.modifier -- 最后修改人
    ,o.mountcalculation -- 计划金额计算方式
    ,o.nexchangerate -- 折本汇率
    ,o.nglobalexchgrate -- 全局本位币汇率
    ,o.ngroupexchgrate -- 集团本位币汇率
    ,o.norigcopamount -- 累计原币应付金额
    ,o.norigplanamount -- 累计原币预付款金额
    ,o.norigpshamount -- 累计原币付款金额
    ,o.norikpmny -- 累计原币收票金额
    ,o.noriprepaylimitmny -- 预付款限额
    ,o.noriprepaymny -- 预付款
    ,o.nprepaylimitmny -- 本币预付款限额
    ,o.nprepaymny -- 本币预付款
    ,o.ntotalastnum -- 总数量
    ,o.ntotalcopamount -- 累计本币应付金额
    ,o.ntotalgpamount -- 累计本币付款金额
    ,o.ntotalorigmny -- 原币价税合计
    ,o.ntotalplanamount -- 累计本币预付款金额
    ,o.ntotaltaxmny -- 本币价税合计
    ,o.openct -- 是否敞口合同
    ,o.organizer -- 承办组织
    ,o.organizer_v -- 承办组织版本
    ,o.ourbankaccount -- 本方银行账号
    ,o.oursignatory -- 本方签字人
    ,o.overrate -- 超合同付款比例
    ,o.personnelid -- 承办人员
    ,o.pk_fct_ap -- 付款合同主键
    ,o.pk_group -- 集团
    ,o.pk_org -- 财务组织
    ,o.pk_org_v -- 财务组织版本
    ,o.pk_origct -- 原始主键
    ,o.pk_payterm -- 付款协议
    ,o.saga_btxid -- 
    ,o.saga_frozen -- 
    ,o.saga_gtxid -- 
    ,o.saga_status -- 
    ,o.signatory -- 对方签字人
    ,o.signorg -- 签约组织
    ,o.signorg_v -- 签约组织版本
    ,o.subscribedate -- 签字盖章日期
    ,o.taudittime -- 审批日期
    ,o.taxpayernumber -- 对方纳税人识别号
    ,o.ts -- 时间戳
    ,o.unconfpayableorg -- 未确认本币应付金额
    ,o.unconfpayableori -- 未确认原币应付金额
    ,o.unconfpaymentorg -- 未确认本币付款金额
    ,o.unconfpaymentori -- 未确认原币付款金额
    ,o.valdate -- 计划生效日期
    ,o.vbillcode -- 合同编码
    ,o.vdef1 -- 自定义项1
    ,o.vdef10 -- 自定义项10
    ,o.vdef11 -- 自定义项11
    ,o.vdef12 -- 自定义项12
    ,o.vdef13 -- 自定义项13
    ,o.vdef14 -- 自定义项14
    ,o.vdef15 -- 自定义项15
    ,o.vdef16 -- 自定义项16
    ,o.vdef17 -- 自定义项17
    ,o.vdef18 -- 自定义项18
    ,o.vdef19 -- 自定义项19
    ,o.vdef2 -- 自定义项2
    ,o.vdef20 -- 自定义项20
    ,o.vdef21 -- 自定义项21
    ,o.vdef22 -- 自定义项22
    ,o.vdef23 -- 自定义项23
    ,o.vdef24 -- 自定义项24
    ,o.vdef25 -- 自定义项25
    ,o.vdef26 -- 自定义项26
    ,o.vdef27 -- 自定义项27
    ,o.vdef28 -- 自定义项28
    ,o.vdef29 -- 自定义项29
    ,o.vdef3 -- 自定义项3
    ,o.vdef30 -- 自定义项30
    ,o.vdef31 -- 自定义项31
    ,o.vdef32 -- 自定义项32
    ,o.vdef33 -- 自定义项33
    ,o.vdef34 -- 自定义项34
    ,o.vdef35 -- 自定义项35
    ,o.vdef36 -- 自定义项36
    ,o.vdef37 -- 自定义项37
    ,o.vdef38 -- 自定义项38
    ,o.vdef39 -- 自定义项39
    ,o.vdef4 -- 自定义项4
    ,o.vdef40 -- 自定义项40
    ,o.vdef41 -- 自定义项41
    ,o.vdef42 -- 自定义项42
    ,o.vdef43 -- 自定义项43
    ,o.vdef44 -- 自定义项44
    ,o.vdef45 -- 自定义项45
    ,o.vdef46 -- 自定义项46
    ,o.vdef47 -- 自定义项47
    ,o.vdef48 -- 自定义项48
    ,o.vdef49 -- 自定义项49
    ,o.vdef5 -- 自定义项5
    ,o.vdef50 -- 自定义项50
    ,o.vdef51 -- 自定义项51
    ,o.vdef52 -- 自定义项52
    ,o.vdef53 -- 自定义项53
    ,o.vdef54 -- 自定义项54
    ,o.vdef55 -- 自定义项55
    ,o.vdef56 -- 自定义项56
    ,o.vdef57 -- 自定义项57
    ,o.vdef58 -- 自定义项58
    ,o.vdef59 -- 自定义项59
    ,o.vdef6 -- 自定义项6
    ,o.vdef60 -- 自定义项60
    ,o.vdef61 -- 自定义项61
    ,o.vdef62 -- 自定义项62
    ,o.vdef63 -- 自定义项63
    ,o.vdef64 -- 自定义项64
    ,o.vdef65 -- 自定义项65
    ,o.vdef66 -- 自定义项66
    ,o.vdef67 -- 自定义项67
    ,o.vdef68 -- 自定义项68
    ,o.vdef69 -- 自定义项69
    ,o.vdef7 -- 自定义项7
    ,o.vdef70 -- 自定义项70
    ,o.vdef71 -- 自定义项71
    ,o.vdef72 -- 自定义项72
    ,o.vdef73 -- 自定义项73
    ,o.vdef74 -- 自定义项74
    ,o.vdef75 -- 自定义项75
    ,o.vdef76 -- 自定义项76
    ,o.vdef77 -- 自定义项77
    ,o.vdef78 -- 自定义项78
    ,o.vdef79 -- 自定义项79
    ,o.vdef8 -- 自定义项8
    ,o.vdef80 -- 自定义项80
    ,o.vdef81 -- 自定义项81
    ,o.vdef82 -- 自定义项82
    ,o.vdef83 -- 自定义项83
    ,o.vdef84 -- 自定义项84
    ,o.vdef85 -- 自定义项85
    ,o.vdef86 -- 自定义项86
    ,o.vdef87 -- 自定义项87
    ,o.vdef88 -- 自定义项88
    ,o.vdef89 -- 自定义项89
    ,o.vdef9 -- 自定义项9
    ,o.vdef90 -- 自定义项90
    ,o.version -- 版本号
    ,o.vtrantypecode -- 合同类型编码
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
from ${iol_schema}.iers_fct_ap_bk o
    left join ${iol_schema}.iers_fct_ap_op n
        on
            o.pk_fct_ap = n.pk_fct_ap
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_fct_ap_cl d
        on
            o.pk_fct_ap = d.pk_fct_ap
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_fct_ap;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_fct_ap') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_fct_ap drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_fct_ap add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_fct_ap exchange partition p_${batch_date} with table ${iol_schema}.iers_fct_ap_cl;
alter table ${iol_schema}.iers_fct_ap exchange partition p_20991231 with table ${iol_schema}.iers_fct_ap_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_fct_ap to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fct_ap_op purge;
drop table ${iol_schema}.iers_fct_ap_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_fct_ap_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_fct_ap',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
