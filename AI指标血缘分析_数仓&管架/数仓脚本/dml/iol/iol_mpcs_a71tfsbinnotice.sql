/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a71tfsbinnotice
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
create table ${iol_schema}.mpcs_a71tfsbinnotice_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a71tfsbinnotice
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a71tfsbinnotice_op purge;
drop table ${iol_schema}.mpcs_a71tfsbinnotice_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a71tfsbinnotice_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a71tfsbinnotice where 0=1;

create table ${iol_schema}.mpcs_a71tfsbinnotice_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a71tfsbinnotice where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a71tfsbinnotice_cl(
            transcode -- 交易代码
            ,transdt -- 平台日期
            ,transtm -- 平台时间
            ,mainseq -- 平台交易流水号
            ,syscd -- 入账渠道代码
            ,chnldate -- 渠道交易日期
            ,chnlnbr -- 渠道交易流水
            ,instcode -- 机构代码
            ,indate -- 到帐时间
            ,inamount -- 到帐金额
            ,inname -- 付款人户名
            ,inacct -- 付款人账号
            ,inbank -- 付款人开户行
            ,inbankname -- 付款人开户行名
            ,inmemo -- 收款账号(即子账号)
            ,acctname -- 随机子户名
            ,jshacctno -- 结算账户
            ,bzjacctno -- 保证金账号
            ,bzjchildacc -- 保证金子户
            ,ftransdate -- 通用记账交易日期
            ,ftranstime -- 通用记账交易时间
            ,ftrace -- 通用记账上主机流水号
            ,dataid -- 通用记账dataid
            ,fhostcmd -- 内部户到结算户主机返回码
            ,fhostmsg -- 内部户到结算户主机返回信息
            ,fhostdate -- 内部户到结算户主机日期
            ,fhostnbr -- 内部户到结算户主机流水
            ,ktransdate -- 开子户交易日期
            ,ktranstime -- 开子户交易时间
            ,ktrace -- 开子户上主机流水号
            ,khostdate -- 开子户主机日期
            ,khostnbr -- 开子户主机流水
            ,khostcmd -- 开子户主机返回码
            ,khostmsg -- 开子户主机返回信息
            ,transdate -- 第三方交易日期
            ,transtime -- 第三方交易时间
            ,thdseqno -- 第三方流水号
            ,result -- 处理代码：00-成功处理01-接收重复09-其它错误99-系统错误
            ,addword -- 处理结果
            ,status -- 入账通知状态：1-已通知2-未通知3-已通知未成功，需要重发通知
            ,flag -- 账务状态：0-入账失败1-入账成功
            ,checkflag -- 对账标志：0-未对账 1-已对账
            ,accflag -- 通用记账状态 0失败，1成功 （1内部户到结算户）
            ,openaccflag -- 开子户状态 0失败，1成功
            ,rtnflg -- 退汇标志：y-退汇n-非退汇
            ,errmsg -- 失败原因
            ,remark -- 附言
            ,fee -- 手续费
            ,pswd -- 密码
            ,nodeid -- 节点号
            ,memocd -- 摘要代码
            ,ccynbr -- 币种
            ,idtftp -- 证件类型
            ,idtfno -- 证件号码
            ,cheqtp -- 交易凭证类型
            ,cheqno -- 交易凭证号码
            ,invodt -- 交易凭证出售日期
            ,ccyflag -- 炒汇标志
            ,zihuflag -- 保证金子户状态：0-未开户1-已开户2-已销户
            ,triflag -- 试算过程标志：0未试算1已试算
            ,uniqueflag -- 试算唯一标识
            ,brcno -- 交易机构
            ,tlrno -- 交易柜员
            ,authtlrno -- 授权柜员
            ,ntctimes -- 通知推送次数：最多5次
            ,projname -- 项目名称
            ,subopenbanknm -- 子账户开户行名称
            ,operrname -- 经办
            ,memoinfo -- 摘要
            ,amntcd -- 借贷标志
            ,opertyp -- 操作类型
            ,jshacctname -- 主账号户名
            ,acctbal -- 账户余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a71tfsbinnotice_op(
            transcode -- 交易代码
            ,transdt -- 平台日期
            ,transtm -- 平台时间
            ,mainseq -- 平台交易流水号
            ,syscd -- 入账渠道代码
            ,chnldate -- 渠道交易日期
            ,chnlnbr -- 渠道交易流水
            ,instcode -- 机构代码
            ,indate -- 到帐时间
            ,inamount -- 到帐金额
            ,inname -- 付款人户名
            ,inacct -- 付款人账号
            ,inbank -- 付款人开户行
            ,inbankname -- 付款人开户行名
            ,inmemo -- 收款账号(即子账号)
            ,acctname -- 随机子户名
            ,jshacctno -- 结算账户
            ,bzjacctno -- 保证金账号
            ,bzjchildacc -- 保证金子户
            ,ftransdate -- 通用记账交易日期
            ,ftranstime -- 通用记账交易时间
            ,ftrace -- 通用记账上主机流水号
            ,dataid -- 通用记账dataid
            ,fhostcmd -- 内部户到结算户主机返回码
            ,fhostmsg -- 内部户到结算户主机返回信息
            ,fhostdate -- 内部户到结算户主机日期
            ,fhostnbr -- 内部户到结算户主机流水
            ,ktransdate -- 开子户交易日期
            ,ktranstime -- 开子户交易时间
            ,ktrace -- 开子户上主机流水号
            ,khostdate -- 开子户主机日期
            ,khostnbr -- 开子户主机流水
            ,khostcmd -- 开子户主机返回码
            ,khostmsg -- 开子户主机返回信息
            ,transdate -- 第三方交易日期
            ,transtime -- 第三方交易时间
            ,thdseqno -- 第三方流水号
            ,result -- 处理代码：00-成功处理01-接收重复09-其它错误99-系统错误
            ,addword -- 处理结果
            ,status -- 入账通知状态：1-已通知2-未通知3-已通知未成功，需要重发通知
            ,flag -- 账务状态：0-入账失败1-入账成功
            ,checkflag -- 对账标志：0-未对账 1-已对账
            ,accflag -- 通用记账状态 0失败，1成功 （1内部户到结算户）
            ,openaccflag -- 开子户状态 0失败，1成功
            ,rtnflg -- 退汇标志：y-退汇n-非退汇
            ,errmsg -- 失败原因
            ,remark -- 附言
            ,fee -- 手续费
            ,pswd -- 密码
            ,nodeid -- 节点号
            ,memocd -- 摘要代码
            ,ccynbr -- 币种
            ,idtftp -- 证件类型
            ,idtfno -- 证件号码
            ,cheqtp -- 交易凭证类型
            ,cheqno -- 交易凭证号码
            ,invodt -- 交易凭证出售日期
            ,ccyflag -- 炒汇标志
            ,zihuflag -- 保证金子户状态：0-未开户1-已开户2-已销户
            ,triflag -- 试算过程标志：0未试算1已试算
            ,uniqueflag -- 试算唯一标识
            ,brcno -- 交易机构
            ,tlrno -- 交易柜员
            ,authtlrno -- 授权柜员
            ,ntctimes -- 通知推送次数：最多5次
            ,projname -- 项目名称
            ,subopenbanknm -- 子账户开户行名称
            ,operrname -- 经办
            ,memoinfo -- 摘要
            ,amntcd -- 借贷标志
            ,opertyp -- 操作类型
            ,jshacctname -- 主账号户名
            ,acctbal -- 账户余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.transcode, o.transcode) as transcode -- 交易代码
    ,nvl(n.transdt, o.transdt) as transdt -- 平台日期
    ,nvl(n.transtm, o.transtm) as transtm -- 平台时间
    ,nvl(n.mainseq, o.mainseq) as mainseq -- 平台交易流水号
    ,nvl(n.syscd, o.syscd) as syscd -- 入账渠道代码
    ,nvl(n.chnldate, o.chnldate) as chnldate -- 渠道交易日期
    ,nvl(n.chnlnbr, o.chnlnbr) as chnlnbr -- 渠道交易流水
    ,nvl(n.instcode, o.instcode) as instcode -- 机构代码
    ,nvl(n.indate, o.indate) as indate -- 到帐时间
    ,nvl(n.inamount, o.inamount) as inamount -- 到帐金额
    ,nvl(n.inname, o.inname) as inname -- 付款人户名
    ,nvl(n.inacct, o.inacct) as inacct -- 付款人账号
    ,nvl(n.inbank, o.inbank) as inbank -- 付款人开户行
    ,nvl(n.inbankname, o.inbankname) as inbankname -- 付款人开户行名
    ,nvl(n.inmemo, o.inmemo) as inmemo -- 收款账号(即子账号)
    ,nvl(n.acctname, o.acctname) as acctname -- 随机子户名
    ,nvl(n.jshacctno, o.jshacctno) as jshacctno -- 结算账户
    ,nvl(n.bzjacctno, o.bzjacctno) as bzjacctno -- 保证金账号
    ,nvl(n.bzjchildacc, o.bzjchildacc) as bzjchildacc -- 保证金子户
    ,nvl(n.ftransdate, o.ftransdate) as ftransdate -- 通用记账交易日期
    ,nvl(n.ftranstime, o.ftranstime) as ftranstime -- 通用记账交易时间
    ,nvl(n.ftrace, o.ftrace) as ftrace -- 通用记账上主机流水号
    ,nvl(n.dataid, o.dataid) as dataid -- 通用记账dataid
    ,nvl(n.fhostcmd, o.fhostcmd) as fhostcmd -- 内部户到结算户主机返回码
    ,nvl(n.fhostmsg, o.fhostmsg) as fhostmsg -- 内部户到结算户主机返回信息
    ,nvl(n.fhostdate, o.fhostdate) as fhostdate -- 内部户到结算户主机日期
    ,nvl(n.fhostnbr, o.fhostnbr) as fhostnbr -- 内部户到结算户主机流水
    ,nvl(n.ktransdate, o.ktransdate) as ktransdate -- 开子户交易日期
    ,nvl(n.ktranstime, o.ktranstime) as ktranstime -- 开子户交易时间
    ,nvl(n.ktrace, o.ktrace) as ktrace -- 开子户上主机流水号
    ,nvl(n.khostdate, o.khostdate) as khostdate -- 开子户主机日期
    ,nvl(n.khostnbr, o.khostnbr) as khostnbr -- 开子户主机流水
    ,nvl(n.khostcmd, o.khostcmd) as khostcmd -- 开子户主机返回码
    ,nvl(n.khostmsg, o.khostmsg) as khostmsg -- 开子户主机返回信息
    ,nvl(n.transdate, o.transdate) as transdate -- 第三方交易日期
    ,nvl(n.transtime, o.transtime) as transtime -- 第三方交易时间
    ,nvl(n.thdseqno, o.thdseqno) as thdseqno -- 第三方流水号
    ,nvl(n.result, o.result) as result -- 处理代码：00-成功处理01-接收重复09-其它错误99-系统错误
    ,nvl(n.addword, o.addword) as addword -- 处理结果
    ,nvl(n.status, o.status) as status -- 入账通知状态：1-已通知2-未通知3-已通知未成功，需要重发通知
    ,nvl(n.flag, o.flag) as flag -- 账务状态：0-入账失败1-入账成功
    ,nvl(n.checkflag, o.checkflag) as checkflag -- 对账标志：0-未对账 1-已对账
    ,nvl(n.accflag, o.accflag) as accflag -- 通用记账状态 0失败，1成功 （1内部户到结算户）
    ,nvl(n.openaccflag, o.openaccflag) as openaccflag -- 开子户状态 0失败，1成功
    ,nvl(n.rtnflg, o.rtnflg) as rtnflg -- 退汇标志：y-退汇n-非退汇
    ,nvl(n.errmsg, o.errmsg) as errmsg -- 失败原因
    ,nvl(n.remark, o.remark) as remark -- 附言
    ,nvl(n.fee, o.fee) as fee -- 手续费
    ,nvl(n.pswd, o.pswd) as pswd -- 密码
    ,nvl(n.nodeid, o.nodeid) as nodeid -- 节点号
    ,nvl(n.memocd, o.memocd) as memocd -- 摘要代码
    ,nvl(n.ccynbr, o.ccynbr) as ccynbr -- 币种
    ,nvl(n.idtftp, o.idtftp) as idtftp -- 证件类型
    ,nvl(n.idtfno, o.idtfno) as idtfno -- 证件号码
    ,nvl(n.cheqtp, o.cheqtp) as cheqtp -- 交易凭证类型
    ,nvl(n.cheqno, o.cheqno) as cheqno -- 交易凭证号码
    ,nvl(n.invodt, o.invodt) as invodt -- 交易凭证出售日期
    ,nvl(n.ccyflag, o.ccyflag) as ccyflag -- 炒汇标志
    ,nvl(n.zihuflag, o.zihuflag) as zihuflag -- 保证金子户状态：0-未开户1-已开户2-已销户
    ,nvl(n.triflag, o.triflag) as triflag -- 试算过程标志：0未试算1已试算
    ,nvl(n.uniqueflag, o.uniqueflag) as uniqueflag -- 试算唯一标识
    ,nvl(n.brcno, o.brcno) as brcno -- 交易机构
    ,nvl(n.tlrno, o.tlrno) as tlrno -- 交易柜员
    ,nvl(n.authtlrno, o.authtlrno) as authtlrno -- 授权柜员
    ,nvl(n.ntctimes, o.ntctimes) as ntctimes -- 通知推送次数：最多5次
    ,nvl(n.projname, o.projname) as projname -- 项目名称
    ,nvl(n.subopenbanknm, o.subopenbanknm) as subopenbanknm -- 子账户开户行名称
    ,nvl(n.operrname, o.operrname) as operrname -- 经办
    ,nvl(n.memoinfo, o.memoinfo) as memoinfo -- 摘要
    ,nvl(n.amntcd, o.amntcd) as amntcd -- 借贷标志
    ,nvl(n.opertyp, o.opertyp) as opertyp -- 操作类型
    ,nvl(n.jshacctname, o.jshacctname) as jshacctname -- 主账号户名
    ,nvl(n.acctbal, o.acctbal) as acctbal -- 账户余额
    ,case when
            n.mainseq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mainseq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mainseq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a71tfsbinnotice_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a71tfsbinnotice where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mainseq = n.mainseq
where (
        o.mainseq is null
    )
    or (
        n.mainseq is null
    )
    or (
        o.transcode <> n.transcode
        or o.transdt <> n.transdt
        or o.transtm <> n.transtm
        or o.syscd <> n.syscd
        or o.chnldate <> n.chnldate
        or o.chnlnbr <> n.chnlnbr
        or o.instcode <> n.instcode
        or o.indate <> n.indate
        or o.inamount <> n.inamount
        or o.inname <> n.inname
        or o.inacct <> n.inacct
        or o.inbank <> n.inbank
        or o.inbankname <> n.inbankname
        or o.inmemo <> n.inmemo
        or o.acctname <> n.acctname
        or o.jshacctno <> n.jshacctno
        or o.bzjacctno <> n.bzjacctno
        or o.bzjchildacc <> n.bzjchildacc
        or o.ftransdate <> n.ftransdate
        or o.ftranstime <> n.ftranstime
        or o.ftrace <> n.ftrace
        or o.dataid <> n.dataid
        or o.fhostcmd <> n.fhostcmd
        or o.fhostmsg <> n.fhostmsg
        or o.fhostdate <> n.fhostdate
        or o.fhostnbr <> n.fhostnbr
        or o.ktransdate <> n.ktransdate
        or o.ktranstime <> n.ktranstime
        or o.ktrace <> n.ktrace
        or o.khostdate <> n.khostdate
        or o.khostnbr <> n.khostnbr
        or o.khostcmd <> n.khostcmd
        or o.khostmsg <> n.khostmsg
        or o.transdate <> n.transdate
        or o.transtime <> n.transtime
        or o.thdseqno <> n.thdseqno
        or o.result <> n.result
        or o.addword <> n.addword
        or o.status <> n.status
        or o.flag <> n.flag
        or o.checkflag <> n.checkflag
        or o.accflag <> n.accflag
        or o.openaccflag <> n.openaccflag
        or o.rtnflg <> n.rtnflg
        or o.errmsg <> n.errmsg
        or o.remark <> n.remark
        or o.fee <> n.fee
        or o.pswd <> n.pswd
        or o.nodeid <> n.nodeid
        or o.memocd <> n.memocd
        or o.ccynbr <> n.ccynbr
        or o.idtftp <> n.idtftp
        or o.idtfno <> n.idtfno
        or o.cheqtp <> n.cheqtp
        or o.cheqno <> n.cheqno
        or o.invodt <> n.invodt
        or o.ccyflag <> n.ccyflag
        or o.zihuflag <> n.zihuflag
        or o.triflag <> n.triflag
        or o.uniqueflag <> n.uniqueflag
        or o.brcno <> n.brcno
        or o.tlrno <> n.tlrno
        or o.authtlrno <> n.authtlrno
        or o.ntctimes <> n.ntctimes
        or o.projname <> n.projname
        or o.subopenbanknm <> n.subopenbanknm
        or o.operrname <> n.operrname
        or o.memoinfo <> n.memoinfo
        or o.amntcd <> n.amntcd
        or o.opertyp <> n.opertyp
        or o.jshacctname <> n.jshacctname
        or o.acctbal <> n.acctbal
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a71tfsbinnotice_cl(
            transcode -- 交易代码
            ,transdt -- 平台日期
            ,transtm -- 平台时间
            ,mainseq -- 平台交易流水号
            ,syscd -- 入账渠道代码
            ,chnldate -- 渠道交易日期
            ,chnlnbr -- 渠道交易流水
            ,instcode -- 机构代码
            ,indate -- 到帐时间
            ,inamount -- 到帐金额
            ,inname -- 付款人户名
            ,inacct -- 付款人账号
            ,inbank -- 付款人开户行
            ,inbankname -- 付款人开户行名
            ,inmemo -- 收款账号(即子账号)
            ,acctname -- 随机子户名
            ,jshacctno -- 结算账户
            ,bzjacctno -- 保证金账号
            ,bzjchildacc -- 保证金子户
            ,ftransdate -- 通用记账交易日期
            ,ftranstime -- 通用记账交易时间
            ,ftrace -- 通用记账上主机流水号
            ,dataid -- 通用记账dataid
            ,fhostcmd -- 内部户到结算户主机返回码
            ,fhostmsg -- 内部户到结算户主机返回信息
            ,fhostdate -- 内部户到结算户主机日期
            ,fhostnbr -- 内部户到结算户主机流水
            ,ktransdate -- 开子户交易日期
            ,ktranstime -- 开子户交易时间
            ,ktrace -- 开子户上主机流水号
            ,khostdate -- 开子户主机日期
            ,khostnbr -- 开子户主机流水
            ,khostcmd -- 开子户主机返回码
            ,khostmsg -- 开子户主机返回信息
            ,transdate -- 第三方交易日期
            ,transtime -- 第三方交易时间
            ,thdseqno -- 第三方流水号
            ,result -- 处理代码：00-成功处理01-接收重复09-其它错误99-系统错误
            ,addword -- 处理结果
            ,status -- 入账通知状态：1-已通知2-未通知3-已通知未成功，需要重发通知
            ,flag -- 账务状态：0-入账失败1-入账成功
            ,checkflag -- 对账标志：0-未对账 1-已对账
            ,accflag -- 通用记账状态 0失败，1成功 （1内部户到结算户）
            ,openaccflag -- 开子户状态 0失败，1成功
            ,rtnflg -- 退汇标志：y-退汇n-非退汇
            ,errmsg -- 失败原因
            ,remark -- 附言
            ,fee -- 手续费
            ,pswd -- 密码
            ,nodeid -- 节点号
            ,memocd -- 摘要代码
            ,ccynbr -- 币种
            ,idtftp -- 证件类型
            ,idtfno -- 证件号码
            ,cheqtp -- 交易凭证类型
            ,cheqno -- 交易凭证号码
            ,invodt -- 交易凭证出售日期
            ,ccyflag -- 炒汇标志
            ,zihuflag -- 保证金子户状态：0-未开户1-已开户2-已销户
            ,triflag -- 试算过程标志：0未试算1已试算
            ,uniqueflag -- 试算唯一标识
            ,brcno -- 交易机构
            ,tlrno -- 交易柜员
            ,authtlrno -- 授权柜员
            ,ntctimes -- 通知推送次数：最多5次
            ,projname -- 项目名称
            ,subopenbanknm -- 子账户开户行名称
            ,operrname -- 经办
            ,memoinfo -- 摘要
            ,amntcd -- 借贷标志
            ,opertyp -- 操作类型
            ,jshacctname -- 主账号户名
            ,acctbal -- 账户余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a71tfsbinnotice_op(
            transcode -- 交易代码
            ,transdt -- 平台日期
            ,transtm -- 平台时间
            ,mainseq -- 平台交易流水号
            ,syscd -- 入账渠道代码
            ,chnldate -- 渠道交易日期
            ,chnlnbr -- 渠道交易流水
            ,instcode -- 机构代码
            ,indate -- 到帐时间
            ,inamount -- 到帐金额
            ,inname -- 付款人户名
            ,inacct -- 付款人账号
            ,inbank -- 付款人开户行
            ,inbankname -- 付款人开户行名
            ,inmemo -- 收款账号(即子账号)
            ,acctname -- 随机子户名
            ,jshacctno -- 结算账户
            ,bzjacctno -- 保证金账号
            ,bzjchildacc -- 保证金子户
            ,ftransdate -- 通用记账交易日期
            ,ftranstime -- 通用记账交易时间
            ,ftrace -- 通用记账上主机流水号
            ,dataid -- 通用记账dataid
            ,fhostcmd -- 内部户到结算户主机返回码
            ,fhostmsg -- 内部户到结算户主机返回信息
            ,fhostdate -- 内部户到结算户主机日期
            ,fhostnbr -- 内部户到结算户主机流水
            ,ktransdate -- 开子户交易日期
            ,ktranstime -- 开子户交易时间
            ,ktrace -- 开子户上主机流水号
            ,khostdate -- 开子户主机日期
            ,khostnbr -- 开子户主机流水
            ,khostcmd -- 开子户主机返回码
            ,khostmsg -- 开子户主机返回信息
            ,transdate -- 第三方交易日期
            ,transtime -- 第三方交易时间
            ,thdseqno -- 第三方流水号
            ,result -- 处理代码：00-成功处理01-接收重复09-其它错误99-系统错误
            ,addword -- 处理结果
            ,status -- 入账通知状态：1-已通知2-未通知3-已通知未成功，需要重发通知
            ,flag -- 账务状态：0-入账失败1-入账成功
            ,checkflag -- 对账标志：0-未对账 1-已对账
            ,accflag -- 通用记账状态 0失败，1成功 （1内部户到结算户）
            ,openaccflag -- 开子户状态 0失败，1成功
            ,rtnflg -- 退汇标志：y-退汇n-非退汇
            ,errmsg -- 失败原因
            ,remark -- 附言
            ,fee -- 手续费
            ,pswd -- 密码
            ,nodeid -- 节点号
            ,memocd -- 摘要代码
            ,ccynbr -- 币种
            ,idtftp -- 证件类型
            ,idtfno -- 证件号码
            ,cheqtp -- 交易凭证类型
            ,cheqno -- 交易凭证号码
            ,invodt -- 交易凭证出售日期
            ,ccyflag -- 炒汇标志
            ,zihuflag -- 保证金子户状态：0-未开户1-已开户2-已销户
            ,triflag -- 试算过程标志：0未试算1已试算
            ,uniqueflag -- 试算唯一标识
            ,brcno -- 交易机构
            ,tlrno -- 交易柜员
            ,authtlrno -- 授权柜员
            ,ntctimes -- 通知推送次数：最多5次
            ,projname -- 项目名称
            ,subopenbanknm -- 子账户开户行名称
            ,operrname -- 经办
            ,memoinfo -- 摘要
            ,amntcd -- 借贷标志
            ,opertyp -- 操作类型
            ,jshacctname -- 主账号户名
            ,acctbal -- 账户余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.transcode -- 交易代码
    ,o.transdt -- 平台日期
    ,o.transtm -- 平台时间
    ,o.mainseq -- 平台交易流水号
    ,o.syscd -- 入账渠道代码
    ,o.chnldate -- 渠道交易日期
    ,o.chnlnbr -- 渠道交易流水
    ,o.instcode -- 机构代码
    ,o.indate -- 到帐时间
    ,o.inamount -- 到帐金额
    ,o.inname -- 付款人户名
    ,o.inacct -- 付款人账号
    ,o.inbank -- 付款人开户行
    ,o.inbankname -- 付款人开户行名
    ,o.inmemo -- 收款账号(即子账号)
    ,o.acctname -- 随机子户名
    ,o.jshacctno -- 结算账户
    ,o.bzjacctno -- 保证金账号
    ,o.bzjchildacc -- 保证金子户
    ,o.ftransdate -- 通用记账交易日期
    ,o.ftranstime -- 通用记账交易时间
    ,o.ftrace -- 通用记账上主机流水号
    ,o.dataid -- 通用记账dataid
    ,o.fhostcmd -- 内部户到结算户主机返回码
    ,o.fhostmsg -- 内部户到结算户主机返回信息
    ,o.fhostdate -- 内部户到结算户主机日期
    ,o.fhostnbr -- 内部户到结算户主机流水
    ,o.ktransdate -- 开子户交易日期
    ,o.ktranstime -- 开子户交易时间
    ,o.ktrace -- 开子户上主机流水号
    ,o.khostdate -- 开子户主机日期
    ,o.khostnbr -- 开子户主机流水
    ,o.khostcmd -- 开子户主机返回码
    ,o.khostmsg -- 开子户主机返回信息
    ,o.transdate -- 第三方交易日期
    ,o.transtime -- 第三方交易时间
    ,o.thdseqno -- 第三方流水号
    ,o.result -- 处理代码：00-成功处理01-接收重复09-其它错误99-系统错误
    ,o.addword -- 处理结果
    ,o.status -- 入账通知状态：1-已通知2-未通知3-已通知未成功，需要重发通知
    ,o.flag -- 账务状态：0-入账失败1-入账成功
    ,o.checkflag -- 对账标志：0-未对账 1-已对账
    ,o.accflag -- 通用记账状态 0失败，1成功 （1内部户到结算户）
    ,o.openaccflag -- 开子户状态 0失败，1成功
    ,o.rtnflg -- 退汇标志：y-退汇n-非退汇
    ,o.errmsg -- 失败原因
    ,o.remark -- 附言
    ,o.fee -- 手续费
    ,o.pswd -- 密码
    ,o.nodeid -- 节点号
    ,o.memocd -- 摘要代码
    ,o.ccynbr -- 币种
    ,o.idtftp -- 证件类型
    ,o.idtfno -- 证件号码
    ,o.cheqtp -- 交易凭证类型
    ,o.cheqno -- 交易凭证号码
    ,o.invodt -- 交易凭证出售日期
    ,o.ccyflag -- 炒汇标志
    ,o.zihuflag -- 保证金子户状态：0-未开户1-已开户2-已销户
    ,o.triflag -- 试算过程标志：0未试算1已试算
    ,o.uniqueflag -- 试算唯一标识
    ,o.brcno -- 交易机构
    ,o.tlrno -- 交易柜员
    ,o.authtlrno -- 授权柜员
    ,o.ntctimes -- 通知推送次数：最多5次
    ,o.projname -- 项目名称
    ,o.subopenbanknm -- 子账户开户行名称
    ,o.operrname -- 经办
    ,o.memoinfo -- 摘要
    ,o.amntcd -- 借贷标志
    ,o.opertyp -- 操作类型
    ,o.jshacctname -- 主账号户名
    ,o.acctbal -- 账户余额
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
from ${iol_schema}.mpcs_a71tfsbinnotice_bk o
    left join ${iol_schema}.mpcs_a71tfsbinnotice_op n
        on
            o.mainseq = n.mainseq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a71tfsbinnotice_cl d
        on
            o.mainseq = d.mainseq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a71tfsbinnotice;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a71tfsbinnotice') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a71tfsbinnotice drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a71tfsbinnotice add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a71tfsbinnotice exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a71tfsbinnotice_cl;
alter table ${iol_schema}.mpcs_a71tfsbinnotice exchange partition p_20991231 with table ${iol_schema}.mpcs_a71tfsbinnotice_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a71tfsbinnotice to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a71tfsbinnotice_op purge;
drop table ${iol_schema}.mpcs_a71tfsbinnotice_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a71tfsbinnotice_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a71tfsbinnotice',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
