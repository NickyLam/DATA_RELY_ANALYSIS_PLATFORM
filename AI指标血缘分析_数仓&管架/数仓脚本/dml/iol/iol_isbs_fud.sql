/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_fud
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
create table ${iol_schema}.isbs_fud_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_fud
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fud_op purge;
drop table ${iol_schema}.isbs_fud_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fud_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fud where 0=1;

create table ${iol_schema}.isbs_fud_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fud where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fud_cl(
            inr -- 主键
            ,ownref -- Own Reference (业务参考号)
            ,nam -- 显示名称
            ,opndat -- 创建日期
            ,proref -- 委托书编号
            ,ovaref -- 客户参数编号
            ,trnway -- 交易方向
            ,lmttyp -- 交割类型
            ,expdat -- 到期日
            ,frgact -- 外币账号
            ,frgcur -- 外币币别
            ,frgamt -- 外币金额
            ,rat -- 成交汇率
            ,cnyact -- 人民币账号
            ,cnycur -- 人民币币别
            ,cnyamt -- 人民币金额
            ,clsdat -- 闭卷日期
            ,mrgact -- 保证金账号
            ,mrgcur -- 保证金币别
            ,cshpct -- 保证金比例
            ,cshpctori -- 当前保证金比例
            ,aplptyinr -- 申请人PTY表INR
            ,aplptainr -- 申请人PTA表INR
            ,aplnam -- 客户名称
            ,apltyp -- 客户类型
            ,aplref -- 客户参考号
            ,inqref -- 询价编号
            ,fixlmt -- 固定期限交割)
            ,begdat -- 起始日
            ,enddat -- 终止日
            ,stdlmt -- 标准期限
            ,extlmt -- 是否可宽限
            ,extflg -- 择期交割通知标志
            ,hdltyp -- 合理状态
            ,sysrat -- 系统内平盘汇率
            ,sptrat -- 远期价格
            ,appdat -- 客户申请日期
            ,infdsp -- Display Infotext
            ,spread -- 展期标志
            ,ver -- 版本号
            ,credat -- 登记日期
            ,pnttyp -- 父业务类型
            ,pntinr -- 父业务主键
            ,branchinr -- 所属机构主键
            ,bchkeyinr -- 经办机构主键
            ,lstamt -- 损益人民币金额
            ,syflg -- 是否损失
            ,losamt -- 我行损失金额
            ,loscur -- 币种
            ,lstcur -- 币种
            ,etyextkey -- 业务主体信息
            ,trnman -- 交易主体
            ,trdint -- TRADE IN
            ,trdout -- TRADE OUT
            ,regref -- Register reference
            ,setdat -- Settlement date
            ,setref -- 交割编号
            ,cetrat -- 客户展期近端汇率
            ,ceurat -- 客户展期远端汇率
            ,cesamt -- 客户展期损益
            ,cesact -- 客户展期损益入/出账号
            ,betrat -- 我行展期近端汇率
            ,beurat -- 我行展期远端汇率
            ,besamt -- 我行展期损益
            ,eusinc -- 展期价差收益
            ,eudtyp -- 日期展期类型
            ,cdrrat -- 客户对冲价格
            ,cdramt -- 客户损失金额
            ,cdract -- 客户扣款"号(违约)
            ,bdrrat -- 我行对冲价格
            ,bdramt -- 我行违约损益
            ,dcrinc -- 违约价差收益
            ,mrgcurbnk -- Margin Currency (保证金币别)
            ,cshpctbnk -- Margin Percent (保证金比例)
            ,cnyamtbnk -- CN Amount (人民币金额-银行端)
            ,cnycurbnk -- CN Currency (人民币币别-银行端)
            ,cvaref -- 客户协议编号
            ,inffrgamt -- 通知交割金额
            ,infexpdat -- 通知交割到期日
            ,inffvaref -- 签约编号
            ,infadvflg -- 通知交割类型
            ,clsflg -- 授信闭卷状态
            ,cdtref -- 授信编号
            ,lmtpct -- 授信额度比例
            ,ccvint -- 保证金计息方式
            ,ccvrat -- 保证金中间价
            ,lmdamt -- 授信额度扣减金额
            ,mrgamt -- 本次保证金金额
            ,lmtamt -- 展期新增授信额度
            ,mrgamtbnk -- 银行端保证金/授信额度
            ,ownusr -- Responsible User
            ,oldownref -- 历史参考号
            ,mrgamtprt -- 保证金余额
            ,padflg -- 垫款标志
            ,selflg -- 自营标志
            ,zjly -- 资金来源
            ,rptcod -- 申报代码
            ,dbway -- 担保方式
            ,setlmttyp -- 交割期限类型
            ,rcvbnkamt -- 收合作银行金额
            ,rcvtyp -- 收款类
            ,ownact -- 我行扣款/收款账号
            ,seqno -- 账户序列号
            ,hkchn -- 汇款渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fud_op(
            inr -- 主键
            ,ownref -- Own Reference (业务参考号)
            ,nam -- 显示名称
            ,opndat -- 创建日期
            ,proref -- 委托书编号
            ,ovaref -- 客户参数编号
            ,trnway -- 交易方向
            ,lmttyp -- 交割类型
            ,expdat -- 到期日
            ,frgact -- 外币账号
            ,frgcur -- 外币币别
            ,frgamt -- 外币金额
            ,rat -- 成交汇率
            ,cnyact -- 人民币账号
            ,cnycur -- 人民币币别
            ,cnyamt -- 人民币金额
            ,clsdat -- 闭卷日期
            ,mrgact -- 保证金账号
            ,mrgcur -- 保证金币别
            ,cshpct -- 保证金比例
            ,cshpctori -- 当前保证金比例
            ,aplptyinr -- 申请人PTY表INR
            ,aplptainr -- 申请人PTA表INR
            ,aplnam -- 客户名称
            ,apltyp -- 客户类型
            ,aplref -- 客户参考号
            ,inqref -- 询价编号
            ,fixlmt -- 固定期限交割)
            ,begdat -- 起始日
            ,enddat -- 终止日
            ,stdlmt -- 标准期限
            ,extlmt -- 是否可宽限
            ,extflg -- 择期交割通知标志
            ,hdltyp -- 合理状态
            ,sysrat -- 系统内平盘汇率
            ,sptrat -- 远期价格
            ,appdat -- 客户申请日期
            ,infdsp -- Display Infotext
            ,spread -- 展期标志
            ,ver -- 版本号
            ,credat -- 登记日期
            ,pnttyp -- 父业务类型
            ,pntinr -- 父业务主键
            ,branchinr -- 所属机构主键
            ,bchkeyinr -- 经办机构主键
            ,lstamt -- 损益人民币金额
            ,syflg -- 是否损失
            ,losamt -- 我行损失金额
            ,loscur -- 币种
            ,lstcur -- 币种
            ,etyextkey -- 业务主体信息
            ,trnman -- 交易主体
            ,trdint -- TRADE IN
            ,trdout -- TRADE OUT
            ,regref -- Register reference
            ,setdat -- Settlement date
            ,setref -- 交割编号
            ,cetrat -- 客户展期近端汇率
            ,ceurat -- 客户展期远端汇率
            ,cesamt -- 客户展期损益
            ,cesact -- 客户展期损益入/出账号
            ,betrat -- 我行展期近端汇率
            ,beurat -- 我行展期远端汇率
            ,besamt -- 我行展期损益
            ,eusinc -- 展期价差收益
            ,eudtyp -- 日期展期类型
            ,cdrrat -- 客户对冲价格
            ,cdramt -- 客户损失金额
            ,cdract -- 客户扣款"号(违约)
            ,bdrrat -- 我行对冲价格
            ,bdramt -- 我行违约损益
            ,dcrinc -- 违约价差收益
            ,mrgcurbnk -- Margin Currency (保证金币别)
            ,cshpctbnk -- Margin Percent (保证金比例)
            ,cnyamtbnk -- CN Amount (人民币金额-银行端)
            ,cnycurbnk -- CN Currency (人民币币别-银行端)
            ,cvaref -- 客户协议编号
            ,inffrgamt -- 通知交割金额
            ,infexpdat -- 通知交割到期日
            ,inffvaref -- 签约编号
            ,infadvflg -- 通知交割类型
            ,clsflg -- 授信闭卷状态
            ,cdtref -- 授信编号
            ,lmtpct -- 授信额度比例
            ,ccvint -- 保证金计息方式
            ,ccvrat -- 保证金中间价
            ,lmdamt -- 授信额度扣减金额
            ,mrgamt -- 本次保证金金额
            ,lmtamt -- 展期新增授信额度
            ,mrgamtbnk -- 银行端保证金/授信额度
            ,ownusr -- Responsible User
            ,oldownref -- 历史参考号
            ,mrgamtprt -- 保证金余额
            ,padflg -- 垫款标志
            ,selflg -- 自营标志
            ,zjly -- 资金来源
            ,rptcod -- 申报代码
            ,dbway -- 担保方式
            ,setlmttyp -- 交割期限类型
            ,rcvbnkamt -- 收合作银行金额
            ,rcvtyp -- 收款类
            ,ownact -- 我行扣款/收款账号
            ,seqno -- 账户序列号
            ,hkchn -- 汇款渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 主键
    ,nvl(n.ownref, o.ownref) as ownref -- Own Reference (业务参考号)
    ,nvl(n.nam, o.nam) as nam -- 显示名称
    ,nvl(n.opndat, o.opndat) as opndat -- 创建日期
    ,nvl(n.proref, o.proref) as proref -- 委托书编号
    ,nvl(n.ovaref, o.ovaref) as ovaref -- 客户参数编号
    ,nvl(n.trnway, o.trnway) as trnway -- 交易方向
    ,nvl(n.lmttyp, o.lmttyp) as lmttyp -- 交割类型
    ,nvl(n.expdat, o.expdat) as expdat -- 到期日
    ,nvl(n.frgact, o.frgact) as frgact -- 外币账号
    ,nvl(n.frgcur, o.frgcur) as frgcur -- 外币币别
    ,nvl(n.frgamt, o.frgamt) as frgamt -- 外币金额
    ,nvl(n.rat, o.rat) as rat -- 成交汇率
    ,nvl(n.cnyact, o.cnyact) as cnyact -- 人民币账号
    ,nvl(n.cnycur, o.cnycur) as cnycur -- 人民币币别
    ,nvl(n.cnyamt, o.cnyamt) as cnyamt -- 人民币金额
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 闭卷日期
    ,nvl(n.mrgact, o.mrgact) as mrgact -- 保证金账号
    ,nvl(n.mrgcur, o.mrgcur) as mrgcur -- 保证金币别
    ,nvl(n.cshpct, o.cshpct) as cshpct -- 保证金比例
    ,nvl(n.cshpctori, o.cshpctori) as cshpctori -- 当前保证金比例
    ,nvl(n.aplptyinr, o.aplptyinr) as aplptyinr -- 申请人PTY表INR
    ,nvl(n.aplptainr, o.aplptainr) as aplptainr -- 申请人PTA表INR
    ,nvl(n.aplnam, o.aplnam) as aplnam -- 客户名称
    ,nvl(n.apltyp, o.apltyp) as apltyp -- 客户类型
    ,nvl(n.aplref, o.aplref) as aplref -- 客户参考号
    ,nvl(n.inqref, o.inqref) as inqref -- 询价编号
    ,nvl(n.fixlmt, o.fixlmt) as fixlmt -- 固定期限交割)
    ,nvl(n.begdat, o.begdat) as begdat -- 起始日
    ,nvl(n.enddat, o.enddat) as enddat -- 终止日
    ,nvl(n.stdlmt, o.stdlmt) as stdlmt -- 标准期限
    ,nvl(n.extlmt, o.extlmt) as extlmt -- 是否可宽限
    ,nvl(n.extflg, o.extflg) as extflg -- 择期交割通知标志
    ,nvl(n.hdltyp, o.hdltyp) as hdltyp -- 合理状态
    ,nvl(n.sysrat, o.sysrat) as sysrat -- 系统内平盘汇率
    ,nvl(n.sptrat, o.sptrat) as sptrat -- 远期价格
    ,nvl(n.appdat, o.appdat) as appdat -- 客户申请日期
    ,nvl(n.infdsp, o.infdsp) as infdsp -- Display Infotext
    ,nvl(n.spread, o.spread) as spread -- 展期标志
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.credat, o.credat) as credat -- 登记日期
    ,nvl(n.pnttyp, o.pnttyp) as pnttyp -- 父业务类型
    ,nvl(n.pntinr, o.pntinr) as pntinr -- 父业务主键
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 所属机构主键
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 经办机构主键
    ,nvl(n.lstamt, o.lstamt) as lstamt -- 损益人民币金额
    ,nvl(n.syflg, o.syflg) as syflg -- 是否损失
    ,nvl(n.losamt, o.losamt) as losamt -- 我行损失金额
    ,nvl(n.loscur, o.loscur) as loscur -- 币种
    ,nvl(n.lstcur, o.lstcur) as lstcur -- 币种
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 业务主体信息
    ,nvl(n.trnman, o.trnman) as trnman -- 交易主体
    ,nvl(n.trdint, o.trdint) as trdint -- TRADE IN
    ,nvl(n.trdout, o.trdout) as trdout -- TRADE OUT
    ,nvl(n.regref, o.regref) as regref -- Register reference
    ,nvl(n.setdat, o.setdat) as setdat -- Settlement date
    ,nvl(n.setref, o.setref) as setref -- 交割编号
    ,nvl(n.cetrat, o.cetrat) as cetrat -- 客户展期近端汇率
    ,nvl(n.ceurat, o.ceurat) as ceurat -- 客户展期远端汇率
    ,nvl(n.cesamt, o.cesamt) as cesamt -- 客户展期损益
    ,nvl(n.cesact, o.cesact) as cesact -- 客户展期损益入/出账号
    ,nvl(n.betrat, o.betrat) as betrat -- 我行展期近端汇率
    ,nvl(n.beurat, o.beurat) as beurat -- 我行展期远端汇率
    ,nvl(n.besamt, o.besamt) as besamt -- 我行展期损益
    ,nvl(n.eusinc, o.eusinc) as eusinc -- 展期价差收益
    ,nvl(n.eudtyp, o.eudtyp) as eudtyp -- 日期展期类型
    ,nvl(n.cdrrat, o.cdrrat) as cdrrat -- 客户对冲价格
    ,nvl(n.cdramt, o.cdramt) as cdramt -- 客户损失金额
    ,nvl(n.cdract, o.cdract) as cdract -- 客户扣款"号(违约)
    ,nvl(n.bdrrat, o.bdrrat) as bdrrat -- 我行对冲价格
    ,nvl(n.bdramt, o.bdramt) as bdramt -- 我行违约损益
    ,nvl(n.dcrinc, o.dcrinc) as dcrinc -- 违约价差收益
    ,nvl(n.mrgcurbnk, o.mrgcurbnk) as mrgcurbnk -- Margin Currency (保证金币别)
    ,nvl(n.cshpctbnk, o.cshpctbnk) as cshpctbnk -- Margin Percent (保证金比例)
    ,nvl(n.cnyamtbnk, o.cnyamtbnk) as cnyamtbnk -- CN Amount (人民币金额-银行端)
    ,nvl(n.cnycurbnk, o.cnycurbnk) as cnycurbnk -- CN Currency (人民币币别-银行端)
    ,nvl(n.cvaref, o.cvaref) as cvaref -- 客户协议编号
    ,nvl(n.inffrgamt, o.inffrgamt) as inffrgamt -- 通知交割金额
    ,nvl(n.infexpdat, o.infexpdat) as infexpdat -- 通知交割到期日
    ,nvl(n.inffvaref, o.inffvaref) as inffvaref -- 签约编号
    ,nvl(n.infadvflg, o.infadvflg) as infadvflg -- 通知交割类型
    ,nvl(n.clsflg, o.clsflg) as clsflg -- 授信闭卷状态
    ,nvl(n.cdtref, o.cdtref) as cdtref -- 授信编号
    ,nvl(n.lmtpct, o.lmtpct) as lmtpct -- 授信额度比例
    ,nvl(n.ccvint, o.ccvint) as ccvint -- 保证金计息方式
    ,nvl(n.ccvrat, o.ccvrat) as ccvrat -- 保证金中间价
    ,nvl(n.lmdamt, o.lmdamt) as lmdamt -- 授信额度扣减金额
    ,nvl(n.mrgamt, o.mrgamt) as mrgamt -- 本次保证金金额
    ,nvl(n.lmtamt, o.lmtamt) as lmtamt -- 展期新增授信额度
    ,nvl(n.mrgamtbnk, o.mrgamtbnk) as mrgamtbnk -- 银行端保证金/授信额度
    ,nvl(n.ownusr, o.ownusr) as ownusr -- Responsible User
    ,nvl(n.oldownref, o.oldownref) as oldownref -- 历史参考号
    ,nvl(n.mrgamtprt, o.mrgamtprt) as mrgamtprt -- 保证金余额
    ,nvl(n.padflg, o.padflg) as padflg -- 垫款标志
    ,nvl(n.selflg, o.selflg) as selflg -- 自营标志
    ,nvl(n.zjly, o.zjly) as zjly -- 资金来源
    ,nvl(n.rptcod, o.rptcod) as rptcod -- 申报代码
    ,nvl(n.dbway, o.dbway) as dbway -- 担保方式
    ,nvl(n.setlmttyp, o.setlmttyp) as setlmttyp -- 交割期限类型
    ,nvl(n.rcvbnkamt, o.rcvbnkamt) as rcvbnkamt -- 收合作银行金额
    ,nvl(n.rcvtyp, o.rcvtyp) as rcvtyp -- 收款类
    ,nvl(n.ownact, o.ownact) as ownact -- 我行扣款/收款账号
    ,nvl(n.seqno, o.seqno) as seqno -- 账户序列号
    ,nvl(n.hkchn, o.hkchn) as hkchn -- 汇款渠道
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
from (select * from ${iol_schema}.isbs_fud_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_fud where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.opndat <> n.opndat
        or o.proref <> n.proref
        or o.ovaref <> n.ovaref
        or o.trnway <> n.trnway
        or o.lmttyp <> n.lmttyp
        or o.expdat <> n.expdat
        or o.frgact <> n.frgact
        or o.frgcur <> n.frgcur
        or o.frgamt <> n.frgamt
        or o.rat <> n.rat
        or o.cnyact <> n.cnyact
        or o.cnycur <> n.cnycur
        or o.cnyamt <> n.cnyamt
        or o.clsdat <> n.clsdat
        or o.mrgact <> n.mrgact
        or o.mrgcur <> n.mrgcur
        or o.cshpct <> n.cshpct
        or o.cshpctori <> n.cshpctori
        or o.aplptyinr <> n.aplptyinr
        or o.aplptainr <> n.aplptainr
        or o.aplnam <> n.aplnam
        or o.apltyp <> n.apltyp
        or o.aplref <> n.aplref
        or o.inqref <> n.inqref
        or o.fixlmt <> n.fixlmt
        or o.begdat <> n.begdat
        or o.enddat <> n.enddat
        or o.stdlmt <> n.stdlmt
        or o.extlmt <> n.extlmt
        or o.extflg <> n.extflg
        or o.hdltyp <> n.hdltyp
        or o.sysrat <> n.sysrat
        or o.sptrat <> n.sptrat
        or o.appdat <> n.appdat
        or o.infdsp <> n.infdsp
        or o.spread <> n.spread
        or o.ver <> n.ver
        or o.credat <> n.credat
        or o.pnttyp <> n.pnttyp
        or o.pntinr <> n.pntinr
        or o.branchinr <> n.branchinr
        or o.bchkeyinr <> n.bchkeyinr
        or o.lstamt <> n.lstamt
        or o.syflg <> n.syflg
        or o.losamt <> n.losamt
        or o.loscur <> n.loscur
        or o.lstcur <> n.lstcur
        or o.etyextkey <> n.etyextkey
        or o.trnman <> n.trnman
        or o.trdint <> n.trdint
        or o.trdout <> n.trdout
        or o.regref <> n.regref
        or o.setdat <> n.setdat
        or o.setref <> n.setref
        or o.cetrat <> n.cetrat
        or o.ceurat <> n.ceurat
        or o.cesamt <> n.cesamt
        or o.cesact <> n.cesact
        or o.betrat <> n.betrat
        or o.beurat <> n.beurat
        or o.besamt <> n.besamt
        or o.eusinc <> n.eusinc
        or o.eudtyp <> n.eudtyp
        or o.cdrrat <> n.cdrrat
        or o.cdramt <> n.cdramt
        or o.cdract <> n.cdract
        or o.bdrrat <> n.bdrrat
        or o.bdramt <> n.bdramt
        or o.dcrinc <> n.dcrinc
        or o.mrgcurbnk <> n.mrgcurbnk
        or o.cshpctbnk <> n.cshpctbnk
        or o.cnyamtbnk <> n.cnyamtbnk
        or o.cnycurbnk <> n.cnycurbnk
        or o.cvaref <> n.cvaref
        or o.inffrgamt <> n.inffrgamt
        or o.infexpdat <> n.infexpdat
        or o.inffvaref <> n.inffvaref
        or o.infadvflg <> n.infadvflg
        or o.clsflg <> n.clsflg
        or o.cdtref <> n.cdtref
        or o.lmtpct <> n.lmtpct
        or o.ccvint <> n.ccvint
        or o.ccvrat <> n.ccvrat
        or o.lmdamt <> n.lmdamt
        or o.mrgamt <> n.mrgamt
        or o.lmtamt <> n.lmtamt
        or o.mrgamtbnk <> n.mrgamtbnk
        or o.ownusr <> n.ownusr
        or o.oldownref <> n.oldownref
        or o.mrgamtprt <> n.mrgamtprt
        or o.padflg <> n.padflg
        or o.selflg <> n.selflg
        or o.zjly <> n.zjly
        or o.rptcod <> n.rptcod
        or o.dbway <> n.dbway
        or o.setlmttyp <> n.setlmttyp
        or o.rcvbnkamt <> n.rcvbnkamt
        or o.rcvtyp <> n.rcvtyp
        or o.ownact <> n.ownact
        or o.seqno <> n.seqno
        or o.hkchn <> n.hkchn
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fud_cl(
            inr -- 主键
            ,ownref -- Own Reference (业务参考号)
            ,nam -- 显示名称
            ,opndat -- 创建日期
            ,proref -- 委托书编号
            ,ovaref -- 客户参数编号
            ,trnway -- 交易方向
            ,lmttyp -- 交割类型
            ,expdat -- 到期日
            ,frgact -- 外币账号
            ,frgcur -- 外币币别
            ,frgamt -- 外币金额
            ,rat -- 成交汇率
            ,cnyact -- 人民币账号
            ,cnycur -- 人民币币别
            ,cnyamt -- 人民币金额
            ,clsdat -- 闭卷日期
            ,mrgact -- 保证金账号
            ,mrgcur -- 保证金币别
            ,cshpct -- 保证金比例
            ,cshpctori -- 当前保证金比例
            ,aplptyinr -- 申请人PTY表INR
            ,aplptainr -- 申请人PTA表INR
            ,aplnam -- 客户名称
            ,apltyp -- 客户类型
            ,aplref -- 客户参考号
            ,inqref -- 询价编号
            ,fixlmt -- 固定期限交割)
            ,begdat -- 起始日
            ,enddat -- 终止日
            ,stdlmt -- 标准期限
            ,extlmt -- 是否可宽限
            ,extflg -- 择期交割通知标志
            ,hdltyp -- 合理状态
            ,sysrat -- 系统内平盘汇率
            ,sptrat -- 远期价格
            ,appdat -- 客户申请日期
            ,infdsp -- Display Infotext
            ,spread -- 展期标志
            ,ver -- 版本号
            ,credat -- 登记日期
            ,pnttyp -- 父业务类型
            ,pntinr -- 父业务主键
            ,branchinr -- 所属机构主键
            ,bchkeyinr -- 经办机构主键
            ,lstamt -- 损益人民币金额
            ,syflg -- 是否损失
            ,losamt -- 我行损失金额
            ,loscur -- 币种
            ,lstcur -- 币种
            ,etyextkey -- 业务主体信息
            ,trnman -- 交易主体
            ,trdint -- TRADE IN
            ,trdout -- TRADE OUT
            ,regref -- Register reference
            ,setdat -- Settlement date
            ,setref -- 交割编号
            ,cetrat -- 客户展期近端汇率
            ,ceurat -- 客户展期远端汇率
            ,cesamt -- 客户展期损益
            ,cesact -- 客户展期损益入/出账号
            ,betrat -- 我行展期近端汇率
            ,beurat -- 我行展期远端汇率
            ,besamt -- 我行展期损益
            ,eusinc -- 展期价差收益
            ,eudtyp -- 日期展期类型
            ,cdrrat -- 客户对冲价格
            ,cdramt -- 客户损失金额
            ,cdract -- 客户扣款"号(违约)
            ,bdrrat -- 我行对冲价格
            ,bdramt -- 我行违约损益
            ,dcrinc -- 违约价差收益
            ,mrgcurbnk -- Margin Currency (保证金币别)
            ,cshpctbnk -- Margin Percent (保证金比例)
            ,cnyamtbnk -- CN Amount (人民币金额-银行端)
            ,cnycurbnk -- CN Currency (人民币币别-银行端)
            ,cvaref -- 客户协议编号
            ,inffrgamt -- 通知交割金额
            ,infexpdat -- 通知交割到期日
            ,inffvaref -- 签约编号
            ,infadvflg -- 通知交割类型
            ,clsflg -- 授信闭卷状态
            ,cdtref -- 授信编号
            ,lmtpct -- 授信额度比例
            ,ccvint -- 保证金计息方式
            ,ccvrat -- 保证金中间价
            ,lmdamt -- 授信额度扣减金额
            ,mrgamt -- 本次保证金金额
            ,lmtamt -- 展期新增授信额度
            ,mrgamtbnk -- 银行端保证金/授信额度
            ,ownusr -- Responsible User
            ,oldownref -- 历史参考号
            ,mrgamtprt -- 保证金余额
            ,padflg -- 垫款标志
            ,selflg -- 自营标志
            ,zjly -- 资金来源
            ,rptcod -- 申报代码
            ,dbway -- 担保方式
            ,setlmttyp -- 交割期限类型
            ,rcvbnkamt -- 收合作银行金额
            ,rcvtyp -- 收款类
            ,ownact -- 我行扣款/收款账号
            ,seqno -- 账户序列号
            ,hkchn -- 汇款渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fud_op(
            inr -- 主键
            ,ownref -- Own Reference (业务参考号)
            ,nam -- 显示名称
            ,opndat -- 创建日期
            ,proref -- 委托书编号
            ,ovaref -- 客户参数编号
            ,trnway -- 交易方向
            ,lmttyp -- 交割类型
            ,expdat -- 到期日
            ,frgact -- 外币账号
            ,frgcur -- 外币币别
            ,frgamt -- 外币金额
            ,rat -- 成交汇率
            ,cnyact -- 人民币账号
            ,cnycur -- 人民币币别
            ,cnyamt -- 人民币金额
            ,clsdat -- 闭卷日期
            ,mrgact -- 保证金账号
            ,mrgcur -- 保证金币别
            ,cshpct -- 保证金比例
            ,cshpctori -- 当前保证金比例
            ,aplptyinr -- 申请人PTY表INR
            ,aplptainr -- 申请人PTA表INR
            ,aplnam -- 客户名称
            ,apltyp -- 客户类型
            ,aplref -- 客户参考号
            ,inqref -- 询价编号
            ,fixlmt -- 固定期限交割)
            ,begdat -- 起始日
            ,enddat -- 终止日
            ,stdlmt -- 标准期限
            ,extlmt -- 是否可宽限
            ,extflg -- 择期交割通知标志
            ,hdltyp -- 合理状态
            ,sysrat -- 系统内平盘汇率
            ,sptrat -- 远期价格
            ,appdat -- 客户申请日期
            ,infdsp -- Display Infotext
            ,spread -- 展期标志
            ,ver -- 版本号
            ,credat -- 登记日期
            ,pnttyp -- 父业务类型
            ,pntinr -- 父业务主键
            ,branchinr -- 所属机构主键
            ,bchkeyinr -- 经办机构主键
            ,lstamt -- 损益人民币金额
            ,syflg -- 是否损失
            ,losamt -- 我行损失金额
            ,loscur -- 币种
            ,lstcur -- 币种
            ,etyextkey -- 业务主体信息
            ,trnman -- 交易主体
            ,trdint -- TRADE IN
            ,trdout -- TRADE OUT
            ,regref -- Register reference
            ,setdat -- Settlement date
            ,setref -- 交割编号
            ,cetrat -- 客户展期近端汇率
            ,ceurat -- 客户展期远端汇率
            ,cesamt -- 客户展期损益
            ,cesact -- 客户展期损益入/出账号
            ,betrat -- 我行展期近端汇率
            ,beurat -- 我行展期远端汇率
            ,besamt -- 我行展期损益
            ,eusinc -- 展期价差收益
            ,eudtyp -- 日期展期类型
            ,cdrrat -- 客户对冲价格
            ,cdramt -- 客户损失金额
            ,cdract -- 客户扣款"号(违约)
            ,bdrrat -- 我行对冲价格
            ,bdramt -- 我行违约损益
            ,dcrinc -- 违约价差收益
            ,mrgcurbnk -- Margin Currency (保证金币别)
            ,cshpctbnk -- Margin Percent (保证金比例)
            ,cnyamtbnk -- CN Amount (人民币金额-银行端)
            ,cnycurbnk -- CN Currency (人民币币别-银行端)
            ,cvaref -- 客户协议编号
            ,inffrgamt -- 通知交割金额
            ,infexpdat -- 通知交割到期日
            ,inffvaref -- 签约编号
            ,infadvflg -- 通知交割类型
            ,clsflg -- 授信闭卷状态
            ,cdtref -- 授信编号
            ,lmtpct -- 授信额度比例
            ,ccvint -- 保证金计息方式
            ,ccvrat -- 保证金中间价
            ,lmdamt -- 授信额度扣减金额
            ,mrgamt -- 本次保证金金额
            ,lmtamt -- 展期新增授信额度
            ,mrgamtbnk -- 银行端保证金/授信额度
            ,ownusr -- Responsible User
            ,oldownref -- 历史参考号
            ,mrgamtprt -- 保证金余额
            ,padflg -- 垫款标志
            ,selflg -- 自营标志
            ,zjly -- 资金来源
            ,rptcod -- 申报代码
            ,dbway -- 担保方式
            ,setlmttyp -- 交割期限类型
            ,rcvbnkamt -- 收合作银行金额
            ,rcvtyp -- 收款类
            ,ownact -- 我行扣款/收款账号
            ,seqno -- 账户序列号
            ,hkchn -- 汇款渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 主键
    ,o.ownref -- Own Reference (业务参考号)
    ,o.nam -- 显示名称
    ,o.opndat -- 创建日期
    ,o.proref -- 委托书编号
    ,o.ovaref -- 客户参数编号
    ,o.trnway -- 交易方向
    ,o.lmttyp -- 交割类型
    ,o.expdat -- 到期日
    ,o.frgact -- 外币账号
    ,o.frgcur -- 外币币别
    ,o.frgamt -- 外币金额
    ,o.rat -- 成交汇率
    ,o.cnyact -- 人民币账号
    ,o.cnycur -- 人民币币别
    ,o.cnyamt -- 人民币金额
    ,o.clsdat -- 闭卷日期
    ,o.mrgact -- 保证金账号
    ,o.mrgcur -- 保证金币别
    ,o.cshpct -- 保证金比例
    ,o.cshpctori -- 当前保证金比例
    ,o.aplptyinr -- 申请人PTY表INR
    ,o.aplptainr -- 申请人PTA表INR
    ,o.aplnam -- 客户名称
    ,o.apltyp -- 客户类型
    ,o.aplref -- 客户参考号
    ,o.inqref -- 询价编号
    ,o.fixlmt -- 固定期限交割)
    ,o.begdat -- 起始日
    ,o.enddat -- 终止日
    ,o.stdlmt -- 标准期限
    ,o.extlmt -- 是否可宽限
    ,o.extflg -- 择期交割通知标志
    ,o.hdltyp -- 合理状态
    ,o.sysrat -- 系统内平盘汇率
    ,o.sptrat -- 远期价格
    ,o.appdat -- 客户申请日期
    ,o.infdsp -- Display Infotext
    ,o.spread -- 展期标志
    ,o.ver -- 版本号
    ,o.credat -- 登记日期
    ,o.pnttyp -- 父业务类型
    ,o.pntinr -- 父业务主键
    ,o.branchinr -- 所属机构主键
    ,o.bchkeyinr -- 经办机构主键
    ,o.lstamt -- 损益人民币金额
    ,o.syflg -- 是否损失
    ,o.losamt -- 我行损失金额
    ,o.loscur -- 币种
    ,o.lstcur -- 币种
    ,o.etyextkey -- 业务主体信息
    ,o.trnman -- 交易主体
    ,o.trdint -- TRADE IN
    ,o.trdout -- TRADE OUT
    ,o.regref -- Register reference
    ,o.setdat -- Settlement date
    ,o.setref -- 交割编号
    ,o.cetrat -- 客户展期近端汇率
    ,o.ceurat -- 客户展期远端汇率
    ,o.cesamt -- 客户展期损益
    ,o.cesact -- 客户展期损益入/出账号
    ,o.betrat -- 我行展期近端汇率
    ,o.beurat -- 我行展期远端汇率
    ,o.besamt -- 我行展期损益
    ,o.eusinc -- 展期价差收益
    ,o.eudtyp -- 日期展期类型
    ,o.cdrrat -- 客户对冲价格
    ,o.cdramt -- 客户损失金额
    ,o.cdract -- 客户扣款"号(违约)
    ,o.bdrrat -- 我行对冲价格
    ,o.bdramt -- 我行违约损益
    ,o.dcrinc -- 违约价差收益
    ,o.mrgcurbnk -- Margin Currency (保证金币别)
    ,o.cshpctbnk -- Margin Percent (保证金比例)
    ,o.cnyamtbnk -- CN Amount (人民币金额-银行端)
    ,o.cnycurbnk -- CN Currency (人民币币别-银行端)
    ,o.cvaref -- 客户协议编号
    ,o.inffrgamt -- 通知交割金额
    ,o.infexpdat -- 通知交割到期日
    ,o.inffvaref -- 签约编号
    ,o.infadvflg -- 通知交割类型
    ,o.clsflg -- 授信闭卷状态
    ,o.cdtref -- 授信编号
    ,o.lmtpct -- 授信额度比例
    ,o.ccvint -- 保证金计息方式
    ,o.ccvrat -- 保证金中间价
    ,o.lmdamt -- 授信额度扣减金额
    ,o.mrgamt -- 本次保证金金额
    ,o.lmtamt -- 展期新增授信额度
    ,o.mrgamtbnk -- 银行端保证金/授信额度
    ,o.ownusr -- Responsible User
    ,o.oldownref -- 历史参考号
    ,o.mrgamtprt -- 保证金余额
    ,o.padflg -- 垫款标志
    ,o.selflg -- 自营标志
    ,o.zjly -- 资金来源
    ,o.rptcod -- 申报代码
    ,o.dbway -- 担保方式
    ,o.setlmttyp -- 交割期限类型
    ,o.rcvbnkamt -- 收合作银行金额
    ,o.rcvtyp -- 收款类
    ,o.ownact -- 我行扣款/收款账号
    ,o.seqno -- 账户序列号
    ,o.hkchn -- 汇款渠道
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
from ${iol_schema}.isbs_fud_bk o
    left join ${iol_schema}.isbs_fud_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_fud_cl d
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
--truncate table ${iol_schema}.isbs_fud;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_fud') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_fud drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_fud add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_fud exchange partition p_${batch_date} with table ${iol_schema}.isbs_fud_cl;
alter table ${iol_schema}.isbs_fud exchange partition p_20991231 with table ${iol_schema}.isbs_fud_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_fud to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fud_op purge;
drop table ${iol_schema}.isbs_fud_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_fud_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_fud',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
