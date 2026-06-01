/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a71tfsbinnotice
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a71tfsbinnotice
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a71tfsbinnotice purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a71tfsbinnotice(
    transcode varchar2(9) -- 交易代码
    ,transdt varchar2(12) -- 平台日期
    ,transtm varchar2(9) -- 平台时间
    ,mainseq varchar2(30) -- 平台交易流水号
    ,syscd varchar2(15) -- 入账渠道代码
    ,chnldate varchar2(12) -- 渠道交易日期
    ,chnlnbr varchar2(96) -- 渠道交易流水
    ,instcode varchar2(36) -- 机构代码
    ,indate varchar2(21) -- 到帐时间
    ,inamount varchar2(24) -- 到帐金额
    ,inname varchar2(150) -- 付款人户名
    ,inacct varchar2(45) -- 付款人账号
    ,inbank varchar2(150) -- 付款人开户行
    ,inbankname varchar2(150) -- 付款人开户行名
    ,inmemo varchar2(45) -- 收款账号(即子账号)
    ,acctname varchar2(150) -- 随机子户名
    ,jshacctno varchar2(53) -- 结算账户
    ,bzjacctno varchar2(53) -- 保证金账号
    ,bzjchildacc varchar2(65) -- 保证金子户
    ,ftransdate varchar2(12) -- 通用记账交易日期
    ,ftranstime varchar2(9) -- 通用记账交易时间
    ,ftrace varchar2(96) -- 通用记账上主机流水号
    ,dataid varchar2(96) -- 通用记账dataid
    ,fhostcmd varchar2(24) -- 内部户到结算户主机返回码
    ,fhostmsg varchar2(150) -- 内部户到结算户主机返回信息
    ,fhostdate varchar2(12) -- 内部户到结算户主机日期
    ,fhostnbr varchar2(60) -- 内部户到结算户主机流水
    ,ktransdate varchar2(12) -- 开子户交易日期
    ,ktranstime varchar2(9) -- 开子户交易时间
    ,ktrace varchar2(30) -- 开子户上主机流水号
    ,khostdate varchar2(12) -- 开子户主机日期
    ,khostnbr varchar2(30) -- 开子户主机流水
    ,khostcmd varchar2(15) -- 开子户主机返回码
    ,khostmsg varchar2(150) -- 开子户主机返回信息
    ,transdate varchar2(12) -- 第三方交易日期
    ,transtime varchar2(9) -- 第三方交易时间
    ,thdseqno varchar2(45) -- 第三方流水号
    ,result varchar2(3) -- 处理代码：00-成功处理01-接收重复09-其它错误99-系统错误
    ,addword varchar2(150) -- 处理结果
    ,status varchar2(24) -- 入账通知状态：1-已通知2-未通知3-已通知未成功，需要重发通知
    ,flag varchar2(3) -- 账务状态：0-入账失败1-入账成功
    ,checkflag varchar2(3) -- 对账标志：0-未对账 1-已对账
    ,accflag varchar2(2) -- 通用记账状态 0失败，1成功 （1内部户到结算户）
    ,openaccflag varchar2(2) -- 开子户状态 0失败，1成功
    ,rtnflg varchar2(3) -- 退汇标志：y-退汇n-非退汇
    ,errmsg varchar2(150) -- 失败原因
    ,remark varchar2(420) -- 附言
    ,fee varchar2(27) -- 手续费
    ,pswd varchar2(96) -- 密码
    ,nodeid varchar2(30) -- 节点号
    ,memocd varchar2(15) -- 摘要代码
    ,ccynbr varchar2(5) -- 币种
    ,idtftp varchar2(9) -- 证件类型
    ,idtfno varchar2(30) -- 证件号码
    ,cheqtp varchar2(5) -- 交易凭证类型
    ,cheqno varchar2(30) -- 交易凭证号码
    ,invodt varchar2(12) -- 交易凭证出售日期
    ,ccyflag varchar2(5) -- 炒汇标志
    ,zihuflag varchar2(2) -- 保证金子户状态：0-未开户1-已开户2-已销户
    ,triflag varchar2(2) -- 试算过程标志：0未试算1已试算
    ,uniqueflag varchar2(150) -- 试算唯一标识
    ,brcno varchar2(9) -- 交易机构
    ,tlrno varchar2(15) -- 交易柜员
    ,authtlrno varchar2(15) -- 授权柜员
    ,ntctimes number(22) -- 通知推送次数：最多5次
    ,projname varchar2(150) -- 项目名称
    ,subopenbanknm varchar2(150) -- 子账户开户行名称
    ,operrname varchar2(45) -- 经办
    ,memoinfo varchar2(150) -- 摘要
    ,amntcd varchar2(3) -- 借贷标志
    ,opertyp varchar2(3) -- 操作类型
    ,jshacctname varchar2(384) -- 主账号户名
    ,acctbal varchar2(30) -- 账户余额
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a71tfsbinnotice to ${iml_schema};
grant select on ${iol_schema}.mpcs_a71tfsbinnotice to ${icl_schema};
grant select on ${iol_schema}.mpcs_a71tfsbinnotice to ${idl_schema};
grant select on ${iol_schema}.mpcs_a71tfsbinnotice to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a71tfsbinnotice is 'fsbzj入账通知记录表';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.transcode is '交易代码';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.transdt is '平台日期';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.transtm is '平台时间';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.mainseq is '平台交易流水号';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.syscd is '入账渠道代码';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.chnldate is '渠道交易日期';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.chnlnbr is '渠道交易流水';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.instcode is '机构代码';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.indate is '到帐时间';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.inamount is '到帐金额';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.inname is '付款人户名';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.inacct is '付款人账号';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.inbank is '付款人开户行';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.inbankname is '付款人开户行名';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.inmemo is '收款账号(即子账号)';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.acctname is '随机子户名';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.jshacctno is '结算账户';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.bzjacctno is '保证金账号';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.bzjchildacc is '保证金子户';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.ftransdate is '通用记账交易日期';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.ftranstime is '通用记账交易时间';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.ftrace is '通用记账上主机流水号';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.dataid is '通用记账dataid';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.fhostcmd is '内部户到结算户主机返回码';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.fhostmsg is '内部户到结算户主机返回信息';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.fhostdate is '内部户到结算户主机日期';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.fhostnbr is '内部户到结算户主机流水';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.ktransdate is '开子户交易日期';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.ktranstime is '开子户交易时间';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.ktrace is '开子户上主机流水号';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.khostdate is '开子户主机日期';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.khostnbr is '开子户主机流水';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.khostcmd is '开子户主机返回码';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.khostmsg is '开子户主机返回信息';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.transdate is '第三方交易日期';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.transtime is '第三方交易时间';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.thdseqno is '第三方流水号';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.result is '处理代码：00-成功处理01-接收重复09-其它错误99-系统错误';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.addword is '处理结果';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.status is '入账通知状态：1-已通知2-未通知3-已通知未成功，需要重发通知';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.flag is '账务状态：0-入账失败1-入账成功';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.checkflag is '对账标志：0-未对账 1-已对账';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.accflag is '通用记账状态 0失败，1成功 （1内部户到结算户）';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.openaccflag is '开子户状态 0失败，1成功';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.rtnflg is '退汇标志：y-退汇n-非退汇';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.errmsg is '失败原因';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.remark is '附言';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.fee is '手续费';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.pswd is '密码';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.nodeid is '节点号';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.memocd is '摘要代码';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.ccynbr is '币种';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.idtftp is '证件类型';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.idtfno is '证件号码';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.cheqtp is '交易凭证类型';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.cheqno is '交易凭证号码';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.invodt is '交易凭证出售日期';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.ccyflag is '炒汇标志';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.zihuflag is '保证金子户状态：0-未开户1-已开户2-已销户';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.triflag is '试算过程标志：0未试算1已试算';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.uniqueflag is '试算唯一标识';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.brcno is '交易机构';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.tlrno is '交易柜员';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.authtlrno is '授权柜员';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.ntctimes is '通知推送次数：最多5次';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.projname is '项目名称';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.subopenbanknm is '子账户开户行名称';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.operrname is '经办';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.memoinfo is '摘要';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.amntcd is '借贷标志';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.opertyp is '操作类型';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.jshacctname is '主账号户名';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.acctbal is '账户余额';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a71tfsbinnotice.etl_timestamp is 'ETL处理时间戳';
