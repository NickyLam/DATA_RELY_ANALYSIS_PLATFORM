/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a50tatmtfrtrace
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
create table ${iol_schema}.mpcs_a50tatmtfrtrace_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a50tatmtfrtrace
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a50tatmtfrtrace_op purge;
drop table ${iol_schema}.mpcs_a50tatmtfrtrace_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50tatmtfrtrace_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a50tatmtfrtrace where 0=1;

create table ${iol_schema}.mpcs_a50tatmtfrtrace_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a50tatmtfrtrace where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a50tatmtfrtrace_cl(
            msgtype -- 消息类型
            ,acqinstid -- 受理方标识码
            ,fwdinstid -- 发送方标识码
            ,transcode -- 交易码
            ,systrace -- 系统跟踪号
            ,zttransdate -- 中台日期
            ,transdate -- 银联前置日期
            ,transtime -- 交易时间
            ,priacct -- 主账号
            ,mobile -- 核心开户预留手机号
            ,transamt -- 交易金额
            ,settlmtamt -- 清算金额
            ,status -- 状态00: 失效状态(最终状态) 01: 冻结成功(最终状态) 02：已冲正(最终状态) 22：核心冲正失败(最终状态) 03：UPP添加失败(最终状态，可忽视) 04：UPP添加成功 15：已发送到UPP添加 05: 已发送到核心冻结 06：已发送到UPP撤销 17：UPP撤销失败(最终状态) 19：UPP已撤消(最终状态) 07：核心撤销失败 08: 核心冻结失败 09: 核心已撤消 10：扣款失败 11：扣款成功(最终状态) 12: 解冻失败(最终状态) 13：解冻成功(最终状态) 25: 核心找不到
            ,ylstatus -- 银联转账结果通知结果，0：成功，1：失败，2：已撤销
            ,hostnbr -- 核心冻结流水号
            ,hostdate -- 核心冻结日期
            ,delayhostnbr -- 核心扣款流水号
            ,delaydate -- 实际扣款日期
            ,delaytime -- 实际扣款时间
            ,delaystatus -- 实际扣款状态
            ,errcode -- 错误码
            ,errmsg -- 错误信息
            ,oldacqinstid -- 原受理方标识码
            ,oldfwdinstid -- 原发送方标识码
            ,oldsystrace -- 原系统跟踪号
            ,oldtranstime -- 原交易时间（MMDDHHMMSS）
            ,servtp -- 渠道ID
            ,devtype -- 设备类型
            ,devnbr -- 设备号
            ,nodeid -- 节点号
            ,posentrymode -- 服务点输入方式码
            ,cardseq -- 卡序号
            ,settlmtdt -- 清算日期
            ,outacctnbr -- 输出账号
            ,inacctnbr -- 输入账号
            ,tlrno -- 柜员号
            ,brcno -- 机构号
            ,channels -- 通道号
            ,dsttrncd -- 交易代码
            ,workcode -- 交易代码
            ,mchnttype -- 商户类型
            ,accptrid -- 受理商户代码
            ,accttrnmlc -- 受理方名称和地址
            ,ccynbr -- 币种
            ,ylccynbr -- 银联币种
            ,cvncode -- CVN码
            ,pindata -- 密码
            ,accttype -- 账户类型
            ,savecode -- 储种
            ,termcode -- 存期
            ,businesstype -- 业务类型
            ,purpos -- 资金用途
            ,pbocelem -- IC卡55域
            ,msgfill -- 备注
            ,remark1 -- 是否已调账 1：已处理 其他未处理
            ,remark2 -- 保留
            ,remark3 -- 对手方户名
            ,global_seq -- 全局流水号
            ,trn_seq -- 交易流水号
            ,fee -- 手续费
            ,memo_cd -- 摘要码
            ,busi_seq -- 业务流水号
            ,old_global_seq -- 原全局流水号
            ,old_busi_seq -- 原业务流水号
            ,old_trn_seq -- 原交易流水号
            ,fee_type -- 费用类型
            ,transtp -- 交易类型
            ,acctname -- 转出账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a50tatmtfrtrace_op(
            msgtype -- 消息类型
            ,acqinstid -- 受理方标识码
            ,fwdinstid -- 发送方标识码
            ,transcode -- 交易码
            ,systrace -- 系统跟踪号
            ,zttransdate -- 中台日期
            ,transdate -- 银联前置日期
            ,transtime -- 交易时间
            ,priacct -- 主账号
            ,mobile -- 核心开户预留手机号
            ,transamt -- 交易金额
            ,settlmtamt -- 清算金额
            ,status -- 状态00: 失效状态(最终状态) 01: 冻结成功(最终状态) 02：已冲正(最终状态) 22：核心冲正失败(最终状态) 03：UPP添加失败(最终状态，可忽视) 04：UPP添加成功 15：已发送到UPP添加 05: 已发送到核心冻结 06：已发送到UPP撤销 17：UPP撤销失败(最终状态) 19：UPP已撤消(最终状态) 07：核心撤销失败 08: 核心冻结失败 09: 核心已撤消 10：扣款失败 11：扣款成功(最终状态) 12: 解冻失败(最终状态) 13：解冻成功(最终状态) 25: 核心找不到
            ,ylstatus -- 银联转账结果通知结果，0：成功，1：失败，2：已撤销
            ,hostnbr -- 核心冻结流水号
            ,hostdate -- 核心冻结日期
            ,delayhostnbr -- 核心扣款流水号
            ,delaydate -- 实际扣款日期
            ,delaytime -- 实际扣款时间
            ,delaystatus -- 实际扣款状态
            ,errcode -- 错误码
            ,errmsg -- 错误信息
            ,oldacqinstid -- 原受理方标识码
            ,oldfwdinstid -- 原发送方标识码
            ,oldsystrace -- 原系统跟踪号
            ,oldtranstime -- 原交易时间（MMDDHHMMSS）
            ,servtp -- 渠道ID
            ,devtype -- 设备类型
            ,devnbr -- 设备号
            ,nodeid -- 节点号
            ,posentrymode -- 服务点输入方式码
            ,cardseq -- 卡序号
            ,settlmtdt -- 清算日期
            ,outacctnbr -- 输出账号
            ,inacctnbr -- 输入账号
            ,tlrno -- 柜员号
            ,brcno -- 机构号
            ,channels -- 通道号
            ,dsttrncd -- 交易代码
            ,workcode -- 交易代码
            ,mchnttype -- 商户类型
            ,accptrid -- 受理商户代码
            ,accttrnmlc -- 受理方名称和地址
            ,ccynbr -- 币种
            ,ylccynbr -- 银联币种
            ,cvncode -- CVN码
            ,pindata -- 密码
            ,accttype -- 账户类型
            ,savecode -- 储种
            ,termcode -- 存期
            ,businesstype -- 业务类型
            ,purpos -- 资金用途
            ,pbocelem -- IC卡55域
            ,msgfill -- 备注
            ,remark1 -- 是否已调账 1：已处理 其他未处理
            ,remark2 -- 保留
            ,remark3 -- 对手方户名
            ,global_seq -- 全局流水号
            ,trn_seq -- 交易流水号
            ,fee -- 手续费
            ,memo_cd -- 摘要码
            ,busi_seq -- 业务流水号
            ,old_global_seq -- 原全局流水号
            ,old_busi_seq -- 原业务流水号
            ,old_trn_seq -- 原交易流水号
            ,fee_type -- 费用类型
            ,transtp -- 交易类型
            ,acctname -- 转出账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.msgtype, o.msgtype) as msgtype -- 消息类型
    ,nvl(n.acqinstid, o.acqinstid) as acqinstid -- 受理方标识码
    ,nvl(n.fwdinstid, o.fwdinstid) as fwdinstid -- 发送方标识码
    ,nvl(n.transcode, o.transcode) as transcode -- 交易码
    ,nvl(n.systrace, o.systrace) as systrace -- 系统跟踪号
    ,nvl(n.zttransdate, o.zttransdate) as zttransdate -- 中台日期
    ,nvl(n.transdate, o.transdate) as transdate -- 银联前置日期
    ,nvl(n.transtime, o.transtime) as transtime -- 交易时间
    ,nvl(n.priacct, o.priacct) as priacct -- 主账号
    ,nvl(n.mobile, o.mobile) as mobile -- 核心开户预留手机号
    ,nvl(n.transamt, o.transamt) as transamt -- 交易金额
    ,nvl(n.settlmtamt, o.settlmtamt) as settlmtamt -- 清算金额
    ,nvl(n.status, o.status) as status -- 状态00: 失效状态(最终状态) 01: 冻结成功(最终状态) 02：已冲正(最终状态) 22：核心冲正失败(最终状态) 03：UPP添加失败(最终状态，可忽视) 04：UPP添加成功 15：已发送到UPP添加 05: 已发送到核心冻结 06：已发送到UPP撤销 17：UPP撤销失败(最终状态) 19：UPP已撤消(最终状态) 07：核心撤销失败 08: 核心冻结失败 09: 核心已撤消 10：扣款失败 11：扣款成功(最终状态) 12: 解冻失败(最终状态) 13：解冻成功(最终状态) 25: 核心找不到
    ,nvl(n.ylstatus, o.ylstatus) as ylstatus -- 银联转账结果通知结果，0：成功，1：失败，2：已撤销
    ,nvl(n.hostnbr, o.hostnbr) as hostnbr -- 核心冻结流水号
    ,nvl(n.hostdate, o.hostdate) as hostdate -- 核心冻结日期
    ,nvl(n.delayhostnbr, o.delayhostnbr) as delayhostnbr -- 核心扣款流水号
    ,nvl(n.delaydate, o.delaydate) as delaydate -- 实际扣款日期
    ,nvl(n.delaytime, o.delaytime) as delaytime -- 实际扣款时间
    ,nvl(n.delaystatus, o.delaystatus) as delaystatus -- 实际扣款状态
    ,nvl(n.errcode, o.errcode) as errcode -- 错误码
    ,nvl(n.errmsg, o.errmsg) as errmsg -- 错误信息
    ,nvl(n.oldacqinstid, o.oldacqinstid) as oldacqinstid -- 原受理方标识码
    ,nvl(n.oldfwdinstid, o.oldfwdinstid) as oldfwdinstid -- 原发送方标识码
    ,nvl(n.oldsystrace, o.oldsystrace) as oldsystrace -- 原系统跟踪号
    ,nvl(n.oldtranstime, o.oldtranstime) as oldtranstime -- 原交易时间（MMDDHHMMSS）
    ,nvl(n.servtp, o.servtp) as servtp -- 渠道ID
    ,nvl(n.devtype, o.devtype) as devtype -- 设备类型
    ,nvl(n.devnbr, o.devnbr) as devnbr -- 设备号
    ,nvl(n.nodeid, o.nodeid) as nodeid -- 节点号
    ,nvl(n.posentrymode, o.posentrymode) as posentrymode -- 服务点输入方式码
    ,nvl(n.cardseq, o.cardseq) as cardseq -- 卡序号
    ,nvl(n.settlmtdt, o.settlmtdt) as settlmtdt -- 清算日期
    ,nvl(n.outacctnbr, o.outacctnbr) as outacctnbr -- 输出账号
    ,nvl(n.inacctnbr, o.inacctnbr) as inacctnbr -- 输入账号
    ,nvl(n.tlrno, o.tlrno) as tlrno -- 柜员号
    ,nvl(n.brcno, o.brcno) as brcno -- 机构号
    ,nvl(n.channels, o.channels) as channels -- 通道号
    ,nvl(n.dsttrncd, o.dsttrncd) as dsttrncd -- 交易代码
    ,nvl(n.workcode, o.workcode) as workcode -- 交易代码
    ,nvl(n.mchnttype, o.mchnttype) as mchnttype -- 商户类型
    ,nvl(n.accptrid, o.accptrid) as accptrid -- 受理商户代码
    ,nvl(n.accttrnmlc, o.accttrnmlc) as accttrnmlc -- 受理方名称和地址
    ,nvl(n.ccynbr, o.ccynbr) as ccynbr -- 币种
    ,nvl(n.ylccynbr, o.ylccynbr) as ylccynbr -- 银联币种
    ,nvl(n.cvncode, o.cvncode) as cvncode -- CVN码
    ,nvl(n.pindata, o.pindata) as pindata -- 密码
    ,nvl(n.accttype, o.accttype) as accttype -- 账户类型
    ,nvl(n.savecode, o.savecode) as savecode -- 储种
    ,nvl(n.termcode, o.termcode) as termcode -- 存期
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务类型
    ,nvl(n.purpos, o.purpos) as purpos -- 资金用途
    ,nvl(n.pbocelem, o.pbocelem) as pbocelem -- IC卡55域
    ,nvl(n.msgfill, o.msgfill) as msgfill -- 备注
    ,nvl(n.remark1, o.remark1) as remark1 -- 是否已调账 1：已处理 其他未处理
    ,nvl(n.remark2, o.remark2) as remark2 -- 保留
    ,nvl(n.remark3, o.remark3) as remark3 -- 对手方户名
    ,nvl(n.global_seq, o.global_seq) as global_seq -- 全局流水号
    ,nvl(n.trn_seq, o.trn_seq) as trn_seq -- 交易流水号
    ,nvl(n.fee, o.fee) as fee -- 手续费
    ,nvl(n.memo_cd, o.memo_cd) as memo_cd -- 摘要码
    ,nvl(n.busi_seq, o.busi_seq) as busi_seq -- 业务流水号
    ,nvl(n.old_global_seq, o.old_global_seq) as old_global_seq -- 原全局流水号
    ,nvl(n.old_busi_seq, o.old_busi_seq) as old_busi_seq -- 原业务流水号
    ,nvl(n.old_trn_seq, o.old_trn_seq) as old_trn_seq -- 原交易流水号
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费用类型
    ,nvl(n.transtp, o.transtp) as transtp -- 交易类型
    ,nvl(n.acctname, o.acctname) as acctname -- 转出账户名称
    ,case when
            n.systrace is null
            and n.transtime is null
            and n.priacct is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.systrace is null
            and n.transtime is null
            and n.priacct is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.systrace is null
            and n.transtime is null
            and n.priacct is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a50tatmtfrtrace_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a50tatmtfrtrace where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.systrace = n.systrace
            and o.transtime = n.transtime
            and o.priacct = n.priacct
where (
        o.systrace is null
        and o.transtime is null
        and o.priacct is null
    )
    or (
        n.systrace is null
        and n.transtime is null
        and n.priacct is null
    )
    or (
        o.msgtype <> n.msgtype
        or o.acqinstid <> n.acqinstid
        or o.fwdinstid <> n.fwdinstid
        or o.transcode <> n.transcode
        or o.zttransdate <> n.zttransdate
        or o.transdate <> n.transdate
        or o.mobile <> n.mobile
        or o.transamt <> n.transamt
        or o.settlmtamt <> n.settlmtamt
        or o.status <> n.status
        or o.ylstatus <> n.ylstatus
        or o.hostnbr <> n.hostnbr
        or o.hostdate <> n.hostdate
        or o.delayhostnbr <> n.delayhostnbr
        or o.delaydate <> n.delaydate
        or o.delaytime <> n.delaytime
        or o.delaystatus <> n.delaystatus
        or o.errcode <> n.errcode
        or o.errmsg <> n.errmsg
        or o.oldacqinstid <> n.oldacqinstid
        or o.oldfwdinstid <> n.oldfwdinstid
        or o.oldsystrace <> n.oldsystrace
        or o.oldtranstime <> n.oldtranstime
        or o.servtp <> n.servtp
        or o.devtype <> n.devtype
        or o.devnbr <> n.devnbr
        or o.nodeid <> n.nodeid
        or o.posentrymode <> n.posentrymode
        or o.cardseq <> n.cardseq
        or o.settlmtdt <> n.settlmtdt
        or o.outacctnbr <> n.outacctnbr
        or o.inacctnbr <> n.inacctnbr
        or o.tlrno <> n.tlrno
        or o.brcno <> n.brcno
        or o.channels <> n.channels
        or o.dsttrncd <> n.dsttrncd
        or o.workcode <> n.workcode
        or o.mchnttype <> n.mchnttype
        or o.accptrid <> n.accptrid
        or o.accttrnmlc <> n.accttrnmlc
        or o.ccynbr <> n.ccynbr
        or o.ylccynbr <> n.ylccynbr
        or o.cvncode <> n.cvncode
        or o.pindata <> n.pindata
        or o.accttype <> n.accttype
        or o.savecode <> n.savecode
        or o.termcode <> n.termcode
        or o.businesstype <> n.businesstype
        or o.purpos <> n.purpos
        or o.pbocelem <> n.pbocelem
        or o.msgfill <> n.msgfill
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.remark3 <> n.remark3
        or o.global_seq <> n.global_seq
        or o.trn_seq <> n.trn_seq
        or o.fee <> n.fee
        or o.memo_cd <> n.memo_cd
        or o.busi_seq <> n.busi_seq
        or o.old_global_seq <> n.old_global_seq
        or o.old_busi_seq <> n.old_busi_seq
        or o.old_trn_seq <> n.old_trn_seq
        or o.fee_type <> n.fee_type
        or o.transtp <> n.transtp
        or o.acctname <> n.acctname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a50tatmtfrtrace_cl(
            msgtype -- 消息类型
            ,acqinstid -- 受理方标识码
            ,fwdinstid -- 发送方标识码
            ,transcode -- 交易码
            ,systrace -- 系统跟踪号
            ,zttransdate -- 中台日期
            ,transdate -- 银联前置日期
            ,transtime -- 交易时间
            ,priacct -- 主账号
            ,mobile -- 核心开户预留手机号
            ,transamt -- 交易金额
            ,settlmtamt -- 清算金额
            ,status -- 状态00: 失效状态(最终状态) 01: 冻结成功(最终状态) 02：已冲正(最终状态) 22：核心冲正失败(最终状态) 03：UPP添加失败(最终状态，可忽视) 04：UPP添加成功 15：已发送到UPP添加 05: 已发送到核心冻结 06：已发送到UPP撤销 17：UPP撤销失败(最终状态) 19：UPP已撤消(最终状态) 07：核心撤销失败 08: 核心冻结失败 09: 核心已撤消 10：扣款失败 11：扣款成功(最终状态) 12: 解冻失败(最终状态) 13：解冻成功(最终状态) 25: 核心找不到
            ,ylstatus -- 银联转账结果通知结果，0：成功，1：失败，2：已撤销
            ,hostnbr -- 核心冻结流水号
            ,hostdate -- 核心冻结日期
            ,delayhostnbr -- 核心扣款流水号
            ,delaydate -- 实际扣款日期
            ,delaytime -- 实际扣款时间
            ,delaystatus -- 实际扣款状态
            ,errcode -- 错误码
            ,errmsg -- 错误信息
            ,oldacqinstid -- 原受理方标识码
            ,oldfwdinstid -- 原发送方标识码
            ,oldsystrace -- 原系统跟踪号
            ,oldtranstime -- 原交易时间（MMDDHHMMSS）
            ,servtp -- 渠道ID
            ,devtype -- 设备类型
            ,devnbr -- 设备号
            ,nodeid -- 节点号
            ,posentrymode -- 服务点输入方式码
            ,cardseq -- 卡序号
            ,settlmtdt -- 清算日期
            ,outacctnbr -- 输出账号
            ,inacctnbr -- 输入账号
            ,tlrno -- 柜员号
            ,brcno -- 机构号
            ,channels -- 通道号
            ,dsttrncd -- 交易代码
            ,workcode -- 交易代码
            ,mchnttype -- 商户类型
            ,accptrid -- 受理商户代码
            ,accttrnmlc -- 受理方名称和地址
            ,ccynbr -- 币种
            ,ylccynbr -- 银联币种
            ,cvncode -- CVN码
            ,pindata -- 密码
            ,accttype -- 账户类型
            ,savecode -- 储种
            ,termcode -- 存期
            ,businesstype -- 业务类型
            ,purpos -- 资金用途
            ,pbocelem -- IC卡55域
            ,msgfill -- 备注
            ,remark1 -- 是否已调账 1：已处理 其他未处理
            ,remark2 -- 保留
            ,remark3 -- 对手方户名
            ,global_seq -- 全局流水号
            ,trn_seq -- 交易流水号
            ,fee -- 手续费
            ,memo_cd -- 摘要码
            ,busi_seq -- 业务流水号
            ,old_global_seq -- 原全局流水号
            ,old_busi_seq -- 原业务流水号
            ,old_trn_seq -- 原交易流水号
            ,fee_type -- 费用类型
            ,transtp -- 交易类型
            ,acctname -- 转出账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a50tatmtfrtrace_op(
            msgtype -- 消息类型
            ,acqinstid -- 受理方标识码
            ,fwdinstid -- 发送方标识码
            ,transcode -- 交易码
            ,systrace -- 系统跟踪号
            ,zttransdate -- 中台日期
            ,transdate -- 银联前置日期
            ,transtime -- 交易时间
            ,priacct -- 主账号
            ,mobile -- 核心开户预留手机号
            ,transamt -- 交易金额
            ,settlmtamt -- 清算金额
            ,status -- 状态00: 失效状态(最终状态) 01: 冻结成功(最终状态) 02：已冲正(最终状态) 22：核心冲正失败(最终状态) 03：UPP添加失败(最终状态，可忽视) 04：UPP添加成功 15：已发送到UPP添加 05: 已发送到核心冻结 06：已发送到UPP撤销 17：UPP撤销失败(最终状态) 19：UPP已撤消(最终状态) 07：核心撤销失败 08: 核心冻结失败 09: 核心已撤消 10：扣款失败 11：扣款成功(最终状态) 12: 解冻失败(最终状态) 13：解冻成功(最终状态) 25: 核心找不到
            ,ylstatus -- 银联转账结果通知结果，0：成功，1：失败，2：已撤销
            ,hostnbr -- 核心冻结流水号
            ,hostdate -- 核心冻结日期
            ,delayhostnbr -- 核心扣款流水号
            ,delaydate -- 实际扣款日期
            ,delaytime -- 实际扣款时间
            ,delaystatus -- 实际扣款状态
            ,errcode -- 错误码
            ,errmsg -- 错误信息
            ,oldacqinstid -- 原受理方标识码
            ,oldfwdinstid -- 原发送方标识码
            ,oldsystrace -- 原系统跟踪号
            ,oldtranstime -- 原交易时间（MMDDHHMMSS）
            ,servtp -- 渠道ID
            ,devtype -- 设备类型
            ,devnbr -- 设备号
            ,nodeid -- 节点号
            ,posentrymode -- 服务点输入方式码
            ,cardseq -- 卡序号
            ,settlmtdt -- 清算日期
            ,outacctnbr -- 输出账号
            ,inacctnbr -- 输入账号
            ,tlrno -- 柜员号
            ,brcno -- 机构号
            ,channels -- 通道号
            ,dsttrncd -- 交易代码
            ,workcode -- 交易代码
            ,mchnttype -- 商户类型
            ,accptrid -- 受理商户代码
            ,accttrnmlc -- 受理方名称和地址
            ,ccynbr -- 币种
            ,ylccynbr -- 银联币种
            ,cvncode -- CVN码
            ,pindata -- 密码
            ,accttype -- 账户类型
            ,savecode -- 储种
            ,termcode -- 存期
            ,businesstype -- 业务类型
            ,purpos -- 资金用途
            ,pbocelem -- IC卡55域
            ,msgfill -- 备注
            ,remark1 -- 是否已调账 1：已处理 其他未处理
            ,remark2 -- 保留
            ,remark3 -- 对手方户名
            ,global_seq -- 全局流水号
            ,trn_seq -- 交易流水号
            ,fee -- 手续费
            ,memo_cd -- 摘要码
            ,busi_seq -- 业务流水号
            ,old_global_seq -- 原全局流水号
            ,old_busi_seq -- 原业务流水号
            ,old_trn_seq -- 原交易流水号
            ,fee_type -- 费用类型
            ,transtp -- 交易类型
            ,acctname -- 转出账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.msgtype -- 消息类型
    ,o.acqinstid -- 受理方标识码
    ,o.fwdinstid -- 发送方标识码
    ,o.transcode -- 交易码
    ,o.systrace -- 系统跟踪号
    ,o.zttransdate -- 中台日期
    ,o.transdate -- 银联前置日期
    ,o.transtime -- 交易时间
    ,o.priacct -- 主账号
    ,o.mobile -- 核心开户预留手机号
    ,o.transamt -- 交易金额
    ,o.settlmtamt -- 清算金额
    ,o.status -- 状态00: 失效状态(最终状态) 01: 冻结成功(最终状态) 02：已冲正(最终状态) 22：核心冲正失败(最终状态) 03：UPP添加失败(最终状态，可忽视) 04：UPP添加成功 15：已发送到UPP添加 05: 已发送到核心冻结 06：已发送到UPP撤销 17：UPP撤销失败(最终状态) 19：UPP已撤消(最终状态) 07：核心撤销失败 08: 核心冻结失败 09: 核心已撤消 10：扣款失败 11：扣款成功(最终状态) 12: 解冻失败(最终状态) 13：解冻成功(最终状态) 25: 核心找不到
    ,o.ylstatus -- 银联转账结果通知结果，0：成功，1：失败，2：已撤销
    ,o.hostnbr -- 核心冻结流水号
    ,o.hostdate -- 核心冻结日期
    ,o.delayhostnbr -- 核心扣款流水号
    ,o.delaydate -- 实际扣款日期
    ,o.delaytime -- 实际扣款时间
    ,o.delaystatus -- 实际扣款状态
    ,o.errcode -- 错误码
    ,o.errmsg -- 错误信息
    ,o.oldacqinstid -- 原受理方标识码
    ,o.oldfwdinstid -- 原发送方标识码
    ,o.oldsystrace -- 原系统跟踪号
    ,o.oldtranstime -- 原交易时间（MMDDHHMMSS）
    ,o.servtp -- 渠道ID
    ,o.devtype -- 设备类型
    ,o.devnbr -- 设备号
    ,o.nodeid -- 节点号
    ,o.posentrymode -- 服务点输入方式码
    ,o.cardseq -- 卡序号
    ,o.settlmtdt -- 清算日期
    ,o.outacctnbr -- 输出账号
    ,o.inacctnbr -- 输入账号
    ,o.tlrno -- 柜员号
    ,o.brcno -- 机构号
    ,o.channels -- 通道号
    ,o.dsttrncd -- 交易代码
    ,o.workcode -- 交易代码
    ,o.mchnttype -- 商户类型
    ,o.accptrid -- 受理商户代码
    ,o.accttrnmlc -- 受理方名称和地址
    ,o.ccynbr -- 币种
    ,o.ylccynbr -- 银联币种
    ,o.cvncode -- CVN码
    ,o.pindata -- 密码
    ,o.accttype -- 账户类型
    ,o.savecode -- 储种
    ,o.termcode -- 存期
    ,o.businesstype -- 业务类型
    ,o.purpos -- 资金用途
    ,o.pbocelem -- IC卡55域
    ,o.msgfill -- 备注
    ,o.remark1 -- 是否已调账 1：已处理 其他未处理
    ,o.remark2 -- 保留
    ,o.remark3 -- 对手方户名
    ,o.global_seq -- 全局流水号
    ,o.trn_seq -- 交易流水号
    ,o.fee -- 手续费
    ,o.memo_cd -- 摘要码
    ,o.busi_seq -- 业务流水号
    ,o.old_global_seq -- 原全局流水号
    ,o.old_busi_seq -- 原业务流水号
    ,o.old_trn_seq -- 原交易流水号
    ,o.fee_type -- 费用类型
    ,o.transtp -- 交易类型
    ,o.acctname -- 转出账户名称
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
from ${iol_schema}.mpcs_a50tatmtfrtrace_bk o
    left join ${iol_schema}.mpcs_a50tatmtfrtrace_op n
        on
            o.systrace = n.systrace
            and o.transtime = n.transtime
            and o.priacct = n.priacct
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a50tatmtfrtrace_cl d
        on
            o.systrace = d.systrace
            and o.transtime = d.transtime
            and o.priacct = d.priacct
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a50tatmtfrtrace;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a50tatmtfrtrace') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a50tatmtfrtrace drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a50tatmtfrtrace add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a50tatmtfrtrace exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a50tatmtfrtrace_cl;
alter table ${iol_schema}.mpcs_a50tatmtfrtrace exchange partition p_20991231 with table ${iol_schema}.mpcs_a50tatmtfrtrace_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a50tatmtfrtrace to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a50tatmtfrtrace_op purge;
drop table ${iol_schema}.mpcs_a50tatmtfrtrace_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a50tatmtfrtrace_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a50tatmtfrtrace',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
