/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_trn
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
create table ${iol_schema}.isbs_trn_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_trn
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_trn_op purge;
drop table ${iol_schema}.isbs_trn_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_trn_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_trn where 0=1;

create table ${iol_schema}.isbs_trn_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_trn where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_trn_cl(
            inr -- 内部唯一ID
            ,inidattim -- 开立日期
            ,inifrm -- 交易名
            ,iniusr -- 用户ID
            ,ininam -- 交易名
            ,ownref -- 参考号
            ,objtyp -- 业务表名称
            ,objinr -- 业务表INR
            ,objnam -- 交易对象描述
            ,ssninr -- 连接 ID
            ,smhnxt -- 报文、面函个数
            ,usg -- 操作员组
            ,usr -- 操作员
            ,cpldattim -- 完成日期
            ,infdsp -- 显示信息
            ,inftxt -- 信息文本
            ,relflg -- 授权状态
            ,comflg -- 提交标志
            ,comdat -- 提交日期
            ,cortrninr -- 被删除或需要修改的TRN的INR
            ,xreflg -- 重算标志
            ,xrecurblk -- 可用货币
            ,relcur -- 授权币种
            ,relamt -- 授权金额
            ,reloricur -- 币种
            ,reloriamt -- 金额
            ,relreq -- 授权请求状态
            ,relres -- 签名状态
            ,cnfflg -- 国外确认标志
            ,evttxt -- Event事件描述
            ,rprusr -- 退回到指定人员
            ,ordinr -- ORD表inr
            ,exedat -- 执行日期
            ,etyextkey -- 实体
            ,bchkeyinr -- 经办机构
            ,accbchinr -- 记账机构
            ,relreq0 -- 单证中心授权请求
            ,relreq1 -- 分行授权请求
            ,relreq2 -- 支行授权请求
            ,relres0 -- 单证中心签名
            ,relres1 -- 分行签名
            ,relres2 -- 支行签名
            ,relusr1 -- 授权用户
            ,relusr2 -- 授权用户
            ,relusr3 -- 授权用户
            ,imginr -- 图像inr
            ,branchinr -- 业务所属支行INR
            ,orgflg -- 机构标识
            ,addtxt -- 附加信息
            ,gylsh -- 核心柜员流水号
            ,gylsh1 -- 核心表外柜员流水号
            ,yewgzh -- 业务跟踪号
            ,cmtflg -- CMT100报文标识
            ,ctrbnknum -- 对手行行号
            ,ctrbnknam -- 对手行行名
            ,atrdon -- 
            ,atrque -- 
            ,qjls -- 全局流水号
            ,qjlscz -- 全局流水号（冲正）
            ,czreason -- 
            ,ywls -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_trn_op(
            inr -- 内部唯一ID
            ,inidattim -- 开立日期
            ,inifrm -- 交易名
            ,iniusr -- 用户ID
            ,ininam -- 交易名
            ,ownref -- 参考号
            ,objtyp -- 业务表名称
            ,objinr -- 业务表INR
            ,objnam -- 交易对象描述
            ,ssninr -- 连接 ID
            ,smhnxt -- 报文、面函个数
            ,usg -- 操作员组
            ,usr -- 操作员
            ,cpldattim -- 完成日期
            ,infdsp -- 显示信息
            ,inftxt -- 信息文本
            ,relflg -- 授权状态
            ,comflg -- 提交标志
            ,comdat -- 提交日期
            ,cortrninr -- 被删除或需要修改的TRN的INR
            ,xreflg -- 重算标志
            ,xrecurblk -- 可用货币
            ,relcur -- 授权币种
            ,relamt -- 授权金额
            ,reloricur -- 币种
            ,reloriamt -- 金额
            ,relreq -- 授权请求状态
            ,relres -- 签名状态
            ,cnfflg -- 国外确认标志
            ,evttxt -- Event事件描述
            ,rprusr -- 退回到指定人员
            ,ordinr -- ORD表inr
            ,exedat -- 执行日期
            ,etyextkey -- 实体
            ,bchkeyinr -- 经办机构
            ,accbchinr -- 记账机构
            ,relreq0 -- 单证中心授权请求
            ,relreq1 -- 分行授权请求
            ,relreq2 -- 支行授权请求
            ,relres0 -- 单证中心签名
            ,relres1 -- 分行签名
            ,relres2 -- 支行签名
            ,relusr1 -- 授权用户
            ,relusr2 -- 授权用户
            ,relusr3 -- 授权用户
            ,imginr -- 图像inr
            ,branchinr -- 业务所属支行INR
            ,orgflg -- 机构标识
            ,addtxt -- 附加信息
            ,gylsh -- 核心柜员流水号
            ,gylsh1 -- 核心表外柜员流水号
            ,yewgzh -- 业务跟踪号
            ,cmtflg -- CMT100报文标识
            ,ctrbnknum -- 对手行行号
            ,ctrbnknam -- 对手行行名
            ,atrdon -- 
            ,atrque -- 
            ,qjls -- 全局流水号
            ,qjlscz -- 全局流水号（冲正）
            ,czreason -- 
            ,ywls -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 内部唯一ID
    ,nvl(n.inidattim, o.inidattim) as inidattim -- 开立日期
    ,nvl(n.inifrm, o.inifrm) as inifrm -- 交易名
    ,nvl(n.iniusr, o.iniusr) as iniusr -- 用户ID
    ,nvl(n.ininam, o.ininam) as ininam -- 交易名
    ,nvl(n.ownref, o.ownref) as ownref -- 参考号
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 业务表名称
    ,nvl(n.objinr, o.objinr) as objinr -- 业务表INR
    ,nvl(n.objnam, o.objnam) as objnam -- 交易对象描述
    ,nvl(n.ssninr, o.ssninr) as ssninr -- 连接 ID
    ,nvl(n.smhnxt, o.smhnxt) as smhnxt -- 报文、面函个数
    ,nvl(n.usg, o.usg) as usg -- 操作员组
    ,nvl(n.usr, o.usr) as usr -- 操作员
    ,nvl(n.cpldattim, o.cpldattim) as cpldattim -- 完成日期
    ,nvl(n.infdsp, o.infdsp) as infdsp -- 显示信息
    ,nvl(n.inftxt, o.inftxt) as inftxt -- 信息文本
    ,nvl(n.relflg, o.relflg) as relflg -- 授权状态
    ,nvl(n.comflg, o.comflg) as comflg -- 提交标志
    ,nvl(n.comdat, o.comdat) as comdat -- 提交日期
    ,nvl(n.cortrninr, o.cortrninr) as cortrninr -- 被删除或需要修改的TRN的INR
    ,nvl(n.xreflg, o.xreflg) as xreflg -- 重算标志
    ,nvl(n.xrecurblk, o.xrecurblk) as xrecurblk -- 可用货币
    ,nvl(n.relcur, o.relcur) as relcur -- 授权币种
    ,nvl(n.relamt, o.relamt) as relamt -- 授权金额
    ,nvl(n.reloricur, o.reloricur) as reloricur -- 币种
    ,nvl(n.reloriamt, o.reloriamt) as reloriamt -- 金额
    ,nvl(n.relreq, o.relreq) as relreq -- 授权请求状态
    ,nvl(n.relres, o.relres) as relres -- 签名状态
    ,nvl(n.cnfflg, o.cnfflg) as cnfflg -- 国外确认标志
    ,nvl(n.evttxt, o.evttxt) as evttxt -- Event事件描述
    ,nvl(n.rprusr, o.rprusr) as rprusr -- 退回到指定人员
    ,nvl(n.ordinr, o.ordinr) as ordinr -- ORD表inr
    ,nvl(n.exedat, o.exedat) as exedat -- 执行日期
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 实体
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 经办机构
    ,nvl(n.accbchinr, o.accbchinr) as accbchinr -- 记账机构
    ,nvl(n.relreq0, o.relreq0) as relreq0 -- 单证中心授权请求
    ,nvl(n.relreq1, o.relreq1) as relreq1 -- 分行授权请求
    ,nvl(n.relreq2, o.relreq2) as relreq2 -- 支行授权请求
    ,nvl(n.relres0, o.relres0) as relres0 -- 单证中心签名
    ,nvl(n.relres1, o.relres1) as relres1 -- 分行签名
    ,nvl(n.relres2, o.relres2) as relres2 -- 支行签名
    ,nvl(n.relusr1, o.relusr1) as relusr1 -- 授权用户
    ,nvl(n.relusr2, o.relusr2) as relusr2 -- 授权用户
    ,nvl(n.relusr3, o.relusr3) as relusr3 -- 授权用户
    ,nvl(n.imginr, o.imginr) as imginr -- 图像inr
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 业务所属支行INR
    ,nvl(n.orgflg, o.orgflg) as orgflg -- 机构标识
    ,nvl(n.addtxt, o.addtxt) as addtxt -- 附加信息
    ,nvl(n.gylsh, o.gylsh) as gylsh -- 核心柜员流水号
    ,nvl(n.gylsh1, o.gylsh1) as gylsh1 -- 核心表外柜员流水号
    ,nvl(n.yewgzh, o.yewgzh) as yewgzh -- 业务跟踪号
    ,nvl(n.cmtflg, o.cmtflg) as cmtflg -- CMT100报文标识
    ,nvl(n.ctrbnknum, o.ctrbnknum) as ctrbnknum -- 对手行行号
    ,nvl(n.ctrbnknam, o.ctrbnknam) as ctrbnknam -- 对手行行名
    ,nvl(n.atrdon, o.atrdon) as atrdon -- 
    ,nvl(n.atrque, o.atrque) as atrque -- 
    ,nvl(n.qjls, o.qjls) as qjls -- 全局流水号
    ,nvl(n.qjlscz, o.qjlscz) as qjlscz -- 全局流水号（冲正）
    ,nvl(n.czreason, o.czreason) as czreason -- 
    ,nvl(n.ywls, o.ywls) as ywls -- 
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
from (select * from ${iol_schema}.isbs_trn_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_trn where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.inidattim <> n.inidattim
        or o.inifrm <> n.inifrm
        or o.iniusr <> n.iniusr
        or o.ininam <> n.ininam
        or o.ownref <> n.ownref
        or o.objtyp <> n.objtyp
        or o.objinr <> n.objinr
        or o.objnam <> n.objnam
        or o.ssninr <> n.ssninr
        or o.smhnxt <> n.smhnxt
        or o.usg <> n.usg
        or o.usr <> n.usr
        or o.cpldattim <> n.cpldattim
        or o.infdsp <> n.infdsp
        or o.inftxt <> n.inftxt
        or o.relflg <> n.relflg
        or o.comflg <> n.comflg
        or o.comdat <> n.comdat
        or o.cortrninr <> n.cortrninr
        or o.xreflg <> n.xreflg
        or o.xrecurblk <> n.xrecurblk
        or o.relcur <> n.relcur
        or o.relamt <> n.relamt
        or o.reloricur <> n.reloricur
        or o.reloriamt <> n.reloriamt
        or o.relreq <> n.relreq
        or o.relres <> n.relres
        or o.cnfflg <> n.cnfflg
        or o.evttxt <> n.evttxt
        or o.rprusr <> n.rprusr
        or o.ordinr <> n.ordinr
        or o.exedat <> n.exedat
        or o.etyextkey <> n.etyextkey
        or o.bchkeyinr <> n.bchkeyinr
        or o.accbchinr <> n.accbchinr
        or o.relreq0 <> n.relreq0
        or o.relreq1 <> n.relreq1
        or o.relreq2 <> n.relreq2
        or o.relres0 <> n.relres0
        or o.relres1 <> n.relres1
        or o.relres2 <> n.relres2
        or o.relusr1 <> n.relusr1
        or o.relusr2 <> n.relusr2
        or o.relusr3 <> n.relusr3
        or o.imginr <> n.imginr
        or o.branchinr <> n.branchinr
        or o.orgflg <> n.orgflg
        or o.addtxt <> n.addtxt
        or o.gylsh <> n.gylsh
        or o.gylsh1 <> n.gylsh1
        or o.yewgzh <> n.yewgzh
        or o.cmtflg <> n.cmtflg
        or o.ctrbnknum <> n.ctrbnknum
        or o.ctrbnknam <> n.ctrbnknam
        or o.atrdon <> n.atrdon
        or o.atrque <> n.atrque
        or o.qjls <> n.qjls
        or o.qjlscz <> n.qjlscz
        or o.czreason <> n.czreason
        or o.ywls <> n.ywls
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_trn_cl(
            inr -- 内部唯一ID
            ,inidattim -- 开立日期
            ,inifrm -- 交易名
            ,iniusr -- 用户ID
            ,ininam -- 交易名
            ,ownref -- 参考号
            ,objtyp -- 业务表名称
            ,objinr -- 业务表INR
            ,objnam -- 交易对象描述
            ,ssninr -- 连接 ID
            ,smhnxt -- 报文、面函个数
            ,usg -- 操作员组
            ,usr -- 操作员
            ,cpldattim -- 完成日期
            ,infdsp -- 显示信息
            ,inftxt -- 信息文本
            ,relflg -- 授权状态
            ,comflg -- 提交标志
            ,comdat -- 提交日期
            ,cortrninr -- 被删除或需要修改的TRN的INR
            ,xreflg -- 重算标志
            ,xrecurblk -- 可用货币
            ,relcur -- 授权币种
            ,relamt -- 授权金额
            ,reloricur -- 币种
            ,reloriamt -- 金额
            ,relreq -- 授权请求状态
            ,relres -- 签名状态
            ,cnfflg -- 国外确认标志
            ,evttxt -- Event事件描述
            ,rprusr -- 退回到指定人员
            ,ordinr -- ORD表inr
            ,exedat -- 执行日期
            ,etyextkey -- 实体
            ,bchkeyinr -- 经办机构
            ,accbchinr -- 记账机构
            ,relreq0 -- 单证中心授权请求
            ,relreq1 -- 分行授权请求
            ,relreq2 -- 支行授权请求
            ,relres0 -- 单证中心签名
            ,relres1 -- 分行签名
            ,relres2 -- 支行签名
            ,relusr1 -- 授权用户
            ,relusr2 -- 授权用户
            ,relusr3 -- 授权用户
            ,imginr -- 图像inr
            ,branchinr -- 业务所属支行INR
            ,orgflg -- 机构标识
            ,addtxt -- 附加信息
            ,gylsh -- 核心柜员流水号
            ,gylsh1 -- 核心表外柜员流水号
            ,yewgzh -- 业务跟踪号
            ,cmtflg -- CMT100报文标识
            ,ctrbnknum -- 对手行行号
            ,ctrbnknam -- 对手行行名
            ,atrdon -- 
            ,atrque -- 
            ,qjls -- 全局流水号
            ,qjlscz -- 全局流水号（冲正）
            ,czreason -- 
            ,ywls -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_trn_op(
            inr -- 内部唯一ID
            ,inidattim -- 开立日期
            ,inifrm -- 交易名
            ,iniusr -- 用户ID
            ,ininam -- 交易名
            ,ownref -- 参考号
            ,objtyp -- 业务表名称
            ,objinr -- 业务表INR
            ,objnam -- 交易对象描述
            ,ssninr -- 连接 ID
            ,smhnxt -- 报文、面函个数
            ,usg -- 操作员组
            ,usr -- 操作员
            ,cpldattim -- 完成日期
            ,infdsp -- 显示信息
            ,inftxt -- 信息文本
            ,relflg -- 授权状态
            ,comflg -- 提交标志
            ,comdat -- 提交日期
            ,cortrninr -- 被删除或需要修改的TRN的INR
            ,xreflg -- 重算标志
            ,xrecurblk -- 可用货币
            ,relcur -- 授权币种
            ,relamt -- 授权金额
            ,reloricur -- 币种
            ,reloriamt -- 金额
            ,relreq -- 授权请求状态
            ,relres -- 签名状态
            ,cnfflg -- 国外确认标志
            ,evttxt -- Event事件描述
            ,rprusr -- 退回到指定人员
            ,ordinr -- ORD表inr
            ,exedat -- 执行日期
            ,etyextkey -- 实体
            ,bchkeyinr -- 经办机构
            ,accbchinr -- 记账机构
            ,relreq0 -- 单证中心授权请求
            ,relreq1 -- 分行授权请求
            ,relreq2 -- 支行授权请求
            ,relres0 -- 单证中心签名
            ,relres1 -- 分行签名
            ,relres2 -- 支行签名
            ,relusr1 -- 授权用户
            ,relusr2 -- 授权用户
            ,relusr3 -- 授权用户
            ,imginr -- 图像inr
            ,branchinr -- 业务所属支行INR
            ,orgflg -- 机构标识
            ,addtxt -- 附加信息
            ,gylsh -- 核心柜员流水号
            ,gylsh1 -- 核心表外柜员流水号
            ,yewgzh -- 业务跟踪号
            ,cmtflg -- CMT100报文标识
            ,ctrbnknum -- 对手行行号
            ,ctrbnknam -- 对手行行名
            ,atrdon -- 
            ,atrque -- 
            ,qjls -- 全局流水号
            ,qjlscz -- 全局流水号（冲正）
            ,czreason -- 
            ,ywls -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 内部唯一ID
    ,o.inidattim -- 开立日期
    ,o.inifrm -- 交易名
    ,o.iniusr -- 用户ID
    ,o.ininam -- 交易名
    ,o.ownref -- 参考号
    ,o.objtyp -- 业务表名称
    ,o.objinr -- 业务表INR
    ,o.objnam -- 交易对象描述
    ,o.ssninr -- 连接 ID
    ,o.smhnxt -- 报文、面函个数
    ,o.usg -- 操作员组
    ,o.usr -- 操作员
    ,o.cpldattim -- 完成日期
    ,o.infdsp -- 显示信息
    ,o.inftxt -- 信息文本
    ,o.relflg -- 授权状态
    ,o.comflg -- 提交标志
    ,o.comdat -- 提交日期
    ,o.cortrninr -- 被删除或需要修改的TRN的INR
    ,o.xreflg -- 重算标志
    ,o.xrecurblk -- 可用货币
    ,o.relcur -- 授权币种
    ,o.relamt -- 授权金额
    ,o.reloricur -- 币种
    ,o.reloriamt -- 金额
    ,o.relreq -- 授权请求状态
    ,o.relres -- 签名状态
    ,o.cnfflg -- 国外确认标志
    ,o.evttxt -- Event事件描述
    ,o.rprusr -- 退回到指定人员
    ,o.ordinr -- ORD表inr
    ,o.exedat -- 执行日期
    ,o.etyextkey -- 实体
    ,o.bchkeyinr -- 经办机构
    ,o.accbchinr -- 记账机构
    ,o.relreq0 -- 单证中心授权请求
    ,o.relreq1 -- 分行授权请求
    ,o.relreq2 -- 支行授权请求
    ,o.relres0 -- 单证中心签名
    ,o.relres1 -- 分行签名
    ,o.relres2 -- 支行签名
    ,o.relusr1 -- 授权用户
    ,o.relusr2 -- 授权用户
    ,o.relusr3 -- 授权用户
    ,o.imginr -- 图像inr
    ,o.branchinr -- 业务所属支行INR
    ,o.orgflg -- 机构标识
    ,o.addtxt -- 附加信息
    ,o.gylsh -- 核心柜员流水号
    ,o.gylsh1 -- 核心表外柜员流水号
    ,o.yewgzh -- 业务跟踪号
    ,o.cmtflg -- CMT100报文标识
    ,o.ctrbnknum -- 对手行行号
    ,o.ctrbnknam -- 对手行行名
    ,o.atrdon -- 
    ,o.atrque -- 
    ,o.qjls -- 全局流水号
    ,o.qjlscz -- 全局流水号（冲正）
    ,o.czreason -- 
    ,o.ywls -- 
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
from ${iol_schema}.isbs_trn_bk o
    left join ${iol_schema}.isbs_trn_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_trn_cl d
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
--truncate table ${iol_schema}.isbs_trn;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_trn') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_trn drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_trn add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_trn exchange partition p_${batch_date} with table ${iol_schema}.isbs_trn_cl;
alter table ${iol_schema}.isbs_trn exchange partition p_20991231 with table ${iol_schema}.isbs_trn_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_trn to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_trn_op purge;
drop table ${iol_schema}.isbs_trn_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_trn_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_trn',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
