/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mpcs_a08thvtrx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mpcs_a08thvtrx
whenever sqlerror continue none;
drop table ${idl_schema}.mpcs_a08thvtrx purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mpcs_a08thvtrx(
    mainseq varchar2(16) -- 支付报单号
    ,transseq varchar2(16) -- 支付交易序号（行外）
    ,businesstrace varchar2(16) -- 行内业务序号
    ,cmtno varchar2(20) -- 报文编号（报文类型）
    ,hosttrcd varchar2(10) -- 主机交易码
    ,fronttrcd varchar2(10) -- 中台交易码
    ,transdt varchar2(8) -- 交易日期
    ,consigndt varchar2(8) -- 委托日期
    ,hostdate varchar2(8) -- 主机日期
    ,hostnbr varchar2(20) -- 主机流水
    ,ccynbr varchar2(3) -- 币种
    ,transamt varchar2(17) -- 交易金额
    ,spbrn varchar2(14) -- 特许参与者
    ,sndct varchar2(4) -- 发报中心（被借记行所在中心）
    ,sndupbrn varchar2(14) -- 发起清算行行号
    ,sndbrn varchar2(14) -- 发起行行号（被借记行）
    ,paybrn varchar2(14) -- 付款人开户行部门号
    ,payopenbrn varchar2(14) -- 付款人开户行行号
    ,payopenbanknm varchar2(140) -- 付款人开户行名称
    ,payacct varchar2(35) -- 付款人账号
    ,payname varchar2(120) -- 付款人名称
    ,payaddr varchar2(140) -- 付款人地址
    ,rcvct varchar2(4) -- 收报中心（被贷记行所在中心）
    ,rcvupbrn varchar2(14) -- 接收清算行行号
    ,rcvbrn varchar2(14) -- 接收行行号（被贷记行）
    ,incobrn varchar2(14) -- 收款人开户行行号
    ,recvopenbanknm varchar2(140) -- 收款人开户行名称
    ,incoacct varchar2(35) -- 收款人账号
    ,inconame varchar2(120) -- 收款人名称
    ,incoaddr varchar2(140) -- 收款人地址
    ,servtype varchar2(12) -- 业务种类
    ,bustype varchar2(6) -- 业务类型
    ,billdt varchar2(8) -- 原委托日期
    ,billcode varchar2(16) -- 原支付交易序号
    ,orasndbrn varchar2(14) -- 原发起参与机构
    ,oracmtno varchar2(20) -- 原报文类型
    ,cmpsamt varchar2(17) -- 赔偿金金额、拆借利息、出票金额
    ,inrate varchar2(17) -- 利率
    ,refuseamt varchar2(17) -- 拒付金额
    ,status varchar2(2) -- 处理状态
    ,processcode varchar2(4) -- 人行业务状态
    ,varseal varchar2(30) -- 处理码
    ,ckrvnbr varchar2(15) -- 复核冲正流水号
    ,sndrvnbr varchar2(15) -- 发送冲正流水号
    ,cleardt varchar2(8) -- 清算日期
    ,errcode varchar2(8) -- 错误代码
    ,errms varchar2(300) -- 错误信息
    ,levels varchar2(1) -- 优先级别
    ,oprtlr varchar2(6) -- 录入柜员
    ,chktlr varchar2(6) -- 复核柜员
    ,sndtlr varchar2(6) -- 发送柜员
    ,auttlr varchar2(6) -- 授权柜员
    ,stoptlr varchar2(6) -- 滞留柜员
    ,oprbrn varchar2(6) -- 录入复核柜员部门号
    ,sndtlrbrn varchar2(6) -- 发送柜员部门号
    ,autbrn varchar2(6) -- 授权柜员部门号
    ,seccode varchar2(40) -- 支付密押
    ,chkstatus varchar2(2) -- 对账状态
    ,info varchar2(500) -- 附言
    ,note varchar2(300) -- 备注
    ,note2 varchar2(250) -- 备注2
    ,prtcnt number(22) -- 打印次数
    ,rcvdt varchar2(14) -- 收到时间
    ,transmitdt varchar2(14) -- 发送时间、转发时间
    ,billseccode varchar2(10) -- 汇票密押
    ,paydt varchar2(8) -- 提示付款日期
    ,wlflag varchar2(1) -- 往来帐标志
    ,flag2 varchar2(1) -- 实时联机标记
    ,flag3 varchar2(1) -- 收费标志
    ,flag4 varchar2(1) -- 借贷标记
    ,billrqcode varchar2(16) -- 汇票申请书号码
    ,sacacct varchar2(35) -- 挂帐帐号或确认后入帐帐号
    ,sacname varchar2(120) -- 挂帐帐号或维护入账姓名
    ,crdt varchar2(8) -- 维护入账日期
    ,crtlr varchar2(21) -- 维护入账柜员
    ,crbrn varchar2(21) -- 维护入账部门号
    ,cracct varchar2(32) -- 清分入帐帐号
    ,crseq varchar2(48) -- 清分流水
    ,prodnbr varchar2(12) -- 代理标识
    ,tracenbr varchar2(35) -- 日志流水号
    ,sndtracenbr varchar2(35) -- 发送日志流水
    ,bookcode varchar2(4) -- 凭证类型
    ,bookdate varchar2(8) -- 凭证日期
    ,bookseqno varchar2(35) -- 凭证号码
    ,idtype varchar2(2) -- 证件种类
    ,idno varchar2(30) -- 证件号码
    ,maxtransamt varchar2(17) -- 转帐限额
    ,transnbr varchar2(20) -- 交易流水套号
    ,sndtransnbr varchar2(20) -- 发送交易流水
    ,changtime varchar2(14) -- 修改时间
    ,reserv40 varchar2(40) -- 城商行汇票号
    ,rcdver varchar2(8) -- 记录更新版本号
    ,rcdstatus varchar2(1) -- 记录状态
    ,paymod varchar2(1) -- 支付方式
    ,openwintype varchar2(8) -- 汇兑业务对应的窗口(交易渠道)
    ,changdate varchar2(8) -- 修改日期
    ,servnbr varchar2(40) -- 业务流水号
    ,magebrn varchar2(6) -- 管理机构
    ,feeamt varchar2(17) -- 手续费用金额
    ,feeamt1 varchar2(17) -- 汇划费用金额
    ,feeamt2 varchar2(17) -- 工本费
    ,feeamt3 varchar2(17) -- 备用
    ,linkid varchar2(17) -- 链路ID
    ,endtlr varchar2(12) -- 取消（冲正）柜员
    ,edhostnbr varchar2(10) -- 取消（冲正）交易流水
    ,edhostdt varchar2(8) -- 取消（冲正）交易日期
    ,prodcd varchar2(8) -- 产品代码
    ,isinout varchar2(1) -- 客户帐、内部帐标识
    ,inacct varchar2(35) -- 实际扣帐账号
    ,inname varchar2(100) -- 实际扣帐户名
    ,ourcnapsver varchar2(2) -- 行内系统版本
    ,othercnapsver varchar2(2) -- 对手系统版本
    ,landdealsts varchar2(2) -- 落地处理状态
    ,checkdealsts varchar2(2) -- 查证处理状态
    ,appenddatatable varchar2(30) -- 登记附加数据的表名
    ,hangupreason varchar2(2) -- 挂账原因代码
    ,modifytlr varchar2(6) -- 修改柜员
    ,info2 varchar2(150) -- 附言2
    ,cmtno2 varchar2(20) -- 二代报文号
    ,bustype2 varchar2(6) -- 二代业务类型
    ,servtype2 varchar2(12) -- 二代业务种类
    ,feetype varchar2(2) -- 收费标志
    ,eaccflg varchar2(2) -- 电子账户标志
    ,srcsysssn varchar2(40) -- 渠道流水号
    ,od_flag varchar2(1) -- 是否触发透支业务
    ,od_ovtranam number(18,2) -- 透支金额
    ,nextdayflag varchar2(1) -- 次日转账标识
    ,crotransamt number(18,2) -- 额度变化值
    ,autoflag varchar2(1) -- 自动退汇处理标识
    ,autocount varchar2(1) -- 自动退汇处理次数
    ,automsg varchar2(200) -- 自动退汇处理信息
    ,bindacct varchar2(35) -- 绑定账户
    ,bindacctnm varchar2(120) -- 绑定账户名
    ,accttype varchar2(20) -- 账户类型
    ,bindacctopnbrn varchar2(8) -- 绑定账户开户机构
    ,tacctp varchar2(20) -- 账户分类标识
    ,limitorderid varchar2(32) -- 限额订单号
    ,globalseqno varchar2(23) -- 全局流水号
    ,returncode varchar2(12) -- ESB接口返回码
    ,returnmsg varchar2(1024) -- ESB接口返回信息
    ,transseqno varchar2(32) -- ESB接口交易流水号
    ,sendouttm varchar2(14) -- 发送人行时间
    ,agtflg varchar2(1) -- 是否代理
    ,agtidtp varchar2(1) -- 代理人证件类型
    ,agtidno varchar2(20) -- 代理人证件号码
    ,agtname varchar2(100) -- 代理人姓名
    ,agtphone varchar2(20) -- 代理人联系方式
    ,acct_typ_id varchar2(1) -- 
    ,finaccountid varchar2(40) -- 
    ,memocntt varchar2(255) -- 
    ,sttlmtype varchar2(2) -- 
    ,intrbksttlmdt varchar2(8) -- 
    ,budgetary varchar2(2) -- 预算级次
    ,exchgflg varchar2(1) -- 个人汇兑标识
    ,orisrcsysssn varchar2(32) -- 原交易流水
    ,orisyscd varchar2(4) -- 原支付通道
    ,redoflag varchar2(1) -- 重发标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on idl.mpcs_a08thvtrx to iel;


-- comment
comment on table ${idl_schema}.mpcs_a08thvtrx is '';
comment on column ${idl_schema}.mpcs_a08thvtrx.mainseq is '支付报单号';
comment on column ${idl_schema}.mpcs_a08thvtrx.transseq is '支付交易序号（行外）';
comment on column ${idl_schema}.mpcs_a08thvtrx.businesstrace is '行内业务序号';
comment on column ${idl_schema}.mpcs_a08thvtrx.cmtno is '报文编号（报文类型）';
comment on column ${idl_schema}.mpcs_a08thvtrx.hosttrcd is '主机交易码';
comment on column ${idl_schema}.mpcs_a08thvtrx.fronttrcd is '中台交易码';
comment on column ${idl_schema}.mpcs_a08thvtrx.transdt is '交易日期';
comment on column ${idl_schema}.mpcs_a08thvtrx.consigndt is '委托日期';
comment on column ${idl_schema}.mpcs_a08thvtrx.hostdate is '主机日期';
comment on column ${idl_schema}.mpcs_a08thvtrx.hostnbr is '主机流水';
comment on column ${idl_schema}.mpcs_a08thvtrx.ccynbr is '币种';
comment on column ${idl_schema}.mpcs_a08thvtrx.transamt is '交易金额';
comment on column ${idl_schema}.mpcs_a08thvtrx.spbrn is '特许参与者';
comment on column ${idl_schema}.mpcs_a08thvtrx.sndct is '发报中心（被借记行所在中心）';
comment on column ${idl_schema}.mpcs_a08thvtrx.sndupbrn is '发起清算行行号';
comment on column ${idl_schema}.mpcs_a08thvtrx.sndbrn is '发起行行号（被借记行）';
comment on column ${idl_schema}.mpcs_a08thvtrx.paybrn is '付款人开户行部门号';
comment on column ${idl_schema}.mpcs_a08thvtrx.payopenbrn is '付款人开户行行号';
comment on column ${idl_schema}.mpcs_a08thvtrx.payopenbanknm is '付款人开户行名称';
comment on column ${idl_schema}.mpcs_a08thvtrx.payacct is '付款人账号';
comment on column ${idl_schema}.mpcs_a08thvtrx.payname is '付款人名称';
comment on column ${idl_schema}.mpcs_a08thvtrx.payaddr is '付款人地址';
comment on column ${idl_schema}.mpcs_a08thvtrx.rcvct is '收报中心（被贷记行所在中心）';
comment on column ${idl_schema}.mpcs_a08thvtrx.rcvupbrn is '接收清算行行号';
comment on column ${idl_schema}.mpcs_a08thvtrx.rcvbrn is '接收行行号（被贷记行）';
comment on column ${idl_schema}.mpcs_a08thvtrx.incobrn is '收款人开户行行号';
comment on column ${idl_schema}.mpcs_a08thvtrx.recvopenbanknm is '收款人开户行名称';
comment on column ${idl_schema}.mpcs_a08thvtrx.incoacct is '收款人账号';
comment on column ${idl_schema}.mpcs_a08thvtrx.inconame is '收款人名称';
comment on column ${idl_schema}.mpcs_a08thvtrx.incoaddr is '收款人地址';
comment on column ${idl_schema}.mpcs_a08thvtrx.servtype is '业务种类';
comment on column ${idl_schema}.mpcs_a08thvtrx.bustype is '业务类型';
comment on column ${idl_schema}.mpcs_a08thvtrx.billdt is '原委托日期';
comment on column ${idl_schema}.mpcs_a08thvtrx.billcode is '原支付交易序号';
comment on column ${idl_schema}.mpcs_a08thvtrx.orasndbrn is '原发起参与机构';
comment on column ${idl_schema}.mpcs_a08thvtrx.oracmtno is '原报文类型';
comment on column ${idl_schema}.mpcs_a08thvtrx.cmpsamt is '赔偿金金额、拆借利息、出票金额';
comment on column ${idl_schema}.mpcs_a08thvtrx.inrate is '利率';
comment on column ${idl_schema}.mpcs_a08thvtrx.refuseamt is '拒付金额';
comment on column ${idl_schema}.mpcs_a08thvtrx.status is '处理状态';
comment on column ${idl_schema}.mpcs_a08thvtrx.processcode is '人行业务状态';
comment on column ${idl_schema}.mpcs_a08thvtrx.varseal is '处理码';
comment on column ${idl_schema}.mpcs_a08thvtrx.ckrvnbr is '复核冲正流水号';
comment on column ${idl_schema}.mpcs_a08thvtrx.sndrvnbr is '发送冲正流水号';
comment on column ${idl_schema}.mpcs_a08thvtrx.cleardt is '清算日期';
comment on column ${idl_schema}.mpcs_a08thvtrx.errcode is '错误代码';
comment on column ${idl_schema}.mpcs_a08thvtrx.errms is '错误信息';
comment on column ${idl_schema}.mpcs_a08thvtrx.levels is '优先级别';
comment on column ${idl_schema}.mpcs_a08thvtrx.oprtlr is '录入柜员';
comment on column ${idl_schema}.mpcs_a08thvtrx.chktlr is '复核柜员';
comment on column ${idl_schema}.mpcs_a08thvtrx.sndtlr is '发送柜员';
comment on column ${idl_schema}.mpcs_a08thvtrx.auttlr is '授权柜员';
comment on column ${idl_schema}.mpcs_a08thvtrx.stoptlr is '滞留柜员';
comment on column ${idl_schema}.mpcs_a08thvtrx.oprbrn is '录入复核柜员部门号';
comment on column ${idl_schema}.mpcs_a08thvtrx.sndtlrbrn is '发送柜员部门号';
comment on column ${idl_schema}.mpcs_a08thvtrx.autbrn is '授权柜员部门号';
comment on column ${idl_schema}.mpcs_a08thvtrx.seccode is '支付密押';
comment on column ${idl_schema}.mpcs_a08thvtrx.chkstatus is '对账状态';
comment on column ${idl_schema}.mpcs_a08thvtrx.info is '附言';
comment on column ${idl_schema}.mpcs_a08thvtrx.note is '备注';
comment on column ${idl_schema}.mpcs_a08thvtrx.note2 is '备注2';
comment on column ${idl_schema}.mpcs_a08thvtrx.prtcnt is '打印次数';
comment on column ${idl_schema}.mpcs_a08thvtrx.rcvdt is '收到时间';
comment on column ${idl_schema}.mpcs_a08thvtrx.transmitdt is '发送时间、转发时间';
comment on column ${idl_schema}.mpcs_a08thvtrx.billseccode is '汇票密押';
comment on column ${idl_schema}.mpcs_a08thvtrx.paydt is '提示付款日期';
comment on column ${idl_schema}.mpcs_a08thvtrx.wlflag is '往来帐标志';
comment on column ${idl_schema}.mpcs_a08thvtrx.flag2 is '实时联机标记';
comment on column ${idl_schema}.mpcs_a08thvtrx.flag3 is '收费标志';
comment on column ${idl_schema}.mpcs_a08thvtrx.flag4 is '借贷标记';
comment on column ${idl_schema}.mpcs_a08thvtrx.billrqcode is '汇票申请书号码';
comment on column ${idl_schema}.mpcs_a08thvtrx.sacacct is '挂帐帐号或确认后入帐帐号';
comment on column ${idl_schema}.mpcs_a08thvtrx.sacname is '挂帐帐号或维护入账姓名';
comment on column ${idl_schema}.mpcs_a08thvtrx.crdt is '维护入账日期';
comment on column ${idl_schema}.mpcs_a08thvtrx.crtlr is '维护入账柜员';
comment on column ${idl_schema}.mpcs_a08thvtrx.crbrn is '维护入账部门号';
comment on column ${idl_schema}.mpcs_a08thvtrx.cracct is '清分入帐帐号';
comment on column ${idl_schema}.mpcs_a08thvtrx.crseq is '清分流水';
comment on column ${idl_schema}.mpcs_a08thvtrx.prodnbr is '代理标识';
comment on column ${idl_schema}.mpcs_a08thvtrx.tracenbr is '日志流水号';
comment on column ${idl_schema}.mpcs_a08thvtrx.sndtracenbr is '发送日志流水';
comment on column ${idl_schema}.mpcs_a08thvtrx.bookcode is '凭证类型';
comment on column ${idl_schema}.mpcs_a08thvtrx.bookdate is '凭证日期';
comment on column ${idl_schema}.mpcs_a08thvtrx.bookseqno is '凭证号码';
comment on column ${idl_schema}.mpcs_a08thvtrx.idtype is '证件种类';
comment on column ${idl_schema}.mpcs_a08thvtrx.idno is '证件号码';
comment on column ${idl_schema}.mpcs_a08thvtrx.maxtransamt is '转帐限额';
comment on column ${idl_schema}.mpcs_a08thvtrx.transnbr is '交易流水套号';
comment on column ${idl_schema}.mpcs_a08thvtrx.sndtransnbr is '发送交易流水';
comment on column ${idl_schema}.mpcs_a08thvtrx.changtime is '修改时间';
comment on column ${idl_schema}.mpcs_a08thvtrx.reserv40 is '城商行汇票号';
comment on column ${idl_schema}.mpcs_a08thvtrx.rcdver is '记录更新版本号';
comment on column ${idl_schema}.mpcs_a08thvtrx.rcdstatus is '记录状态';
comment on column ${idl_schema}.mpcs_a08thvtrx.paymod is '支付方式';
comment on column ${idl_schema}.mpcs_a08thvtrx.openwintype is '汇兑业务对应的窗口(交易渠道)';
comment on column ${idl_schema}.mpcs_a08thvtrx.changdate is '修改日期';
comment on column ${idl_schema}.mpcs_a08thvtrx.servnbr is '业务流水号';
comment on column ${idl_schema}.mpcs_a08thvtrx.magebrn is '管理机构';
comment on column ${idl_schema}.mpcs_a08thvtrx.feeamt is '手续费用金额';
comment on column ${idl_schema}.mpcs_a08thvtrx.feeamt1 is '汇划费用金额';
comment on column ${idl_schema}.mpcs_a08thvtrx.feeamt2 is '工本费';
comment on column ${idl_schema}.mpcs_a08thvtrx.feeamt3 is '备用';
comment on column ${idl_schema}.mpcs_a08thvtrx.linkid is '链路ID';
comment on column ${idl_schema}.mpcs_a08thvtrx.endtlr is '取消（冲正）柜员';
comment on column ${idl_schema}.mpcs_a08thvtrx.edhostnbr is '取消（冲正）交易流水';
comment on column ${idl_schema}.mpcs_a08thvtrx.edhostdt is '取消（冲正）交易日期';
comment on column ${idl_schema}.mpcs_a08thvtrx.prodcd is '产品代码';
comment on column ${idl_schema}.mpcs_a08thvtrx.isinout is '客户帐、内部帐标识';
comment on column ${idl_schema}.mpcs_a08thvtrx.inacct is '实际扣帐账号';
comment on column ${idl_schema}.mpcs_a08thvtrx.inname is '实际扣帐户名';
comment on column ${idl_schema}.mpcs_a08thvtrx.ourcnapsver is '行内系统版本';
comment on column ${idl_schema}.mpcs_a08thvtrx.othercnapsver is '对手系统版本';
comment on column ${idl_schema}.mpcs_a08thvtrx.landdealsts is '落地处理状态';
comment on column ${idl_schema}.mpcs_a08thvtrx.checkdealsts is '查证处理状态';
comment on column ${idl_schema}.mpcs_a08thvtrx.appenddatatable is '登记附加数据的表名';
comment on column ${idl_schema}.mpcs_a08thvtrx.hangupreason is '挂账原因代码';
comment on column ${idl_schema}.mpcs_a08thvtrx.modifytlr is '修改柜员';
comment on column ${idl_schema}.mpcs_a08thvtrx.info2 is '附言2';
comment on column ${idl_schema}.mpcs_a08thvtrx.cmtno2 is '二代报文号';
comment on column ${idl_schema}.mpcs_a08thvtrx.bustype2 is '二代业务类型';
comment on column ${idl_schema}.mpcs_a08thvtrx.servtype2 is '二代业务种类';
comment on column ${idl_schema}.mpcs_a08thvtrx.feetype is '收费标志';
comment on column ${idl_schema}.mpcs_a08thvtrx.eaccflg is '电子账户标志';
comment on column ${idl_schema}.mpcs_a08thvtrx.srcsysssn is '渠道流水号';
comment on column ${idl_schema}.mpcs_a08thvtrx.od_flag is '是否触发透支业务';
comment on column ${idl_schema}.mpcs_a08thvtrx.od_ovtranam is '透支金额';
comment on column ${idl_schema}.mpcs_a08thvtrx.nextdayflag is '次日转账标识';
comment on column ${idl_schema}.mpcs_a08thvtrx.crotransamt is '额度变化值';
comment on column ${idl_schema}.mpcs_a08thvtrx.autoflag is '自动退汇处理标识';
comment on column ${idl_schema}.mpcs_a08thvtrx.autocount is '自动退汇处理次数';
comment on column ${idl_schema}.mpcs_a08thvtrx.automsg is '自动退汇处理信息';
comment on column ${idl_schema}.mpcs_a08thvtrx.bindacct is '绑定账户';
comment on column ${idl_schema}.mpcs_a08thvtrx.bindacctnm is '绑定账户名';
comment on column ${idl_schema}.mpcs_a08thvtrx.accttype is '账户类型';
comment on column ${idl_schema}.mpcs_a08thvtrx.bindacctopnbrn is '绑定账户开户机构';
comment on column ${idl_schema}.mpcs_a08thvtrx.tacctp is '账户分类标识';
comment on column ${idl_schema}.mpcs_a08thvtrx.limitorderid is '限额订单号';
comment on column ${idl_schema}.mpcs_a08thvtrx.globalseqno is '全局流水号';
comment on column ${idl_schema}.mpcs_a08thvtrx.returncode is 'ESB接口返回码';
comment on column ${idl_schema}.mpcs_a08thvtrx.returnmsg is 'ESB接口返回信息';
comment on column ${idl_schema}.mpcs_a08thvtrx.transseqno is 'ESB接口交易流水号';
comment on column ${idl_schema}.mpcs_a08thvtrx.sendouttm is '发送人行时间';
comment on column ${idl_schema}.mpcs_a08thvtrx.agtflg is '是否代理';
comment on column ${idl_schema}.mpcs_a08thvtrx.agtidtp is '代理人证件类型';
comment on column ${idl_schema}.mpcs_a08thvtrx.agtidno is '代理人证件号码';
comment on column ${idl_schema}.mpcs_a08thvtrx.agtname is '代理人姓名';
comment on column ${idl_schema}.mpcs_a08thvtrx.agtphone is '代理人联系方式';
comment on column ${idl_schema}.mpcs_a08thvtrx.acct_typ_id is '';
comment on column ${idl_schema}.mpcs_a08thvtrx.finaccountid is '';
comment on column ${idl_schema}.mpcs_a08thvtrx.memocntt is '';
comment on column ${idl_schema}.mpcs_a08thvtrx.sttlmtype is '';
comment on column ${idl_schema}.mpcs_a08thvtrx.intrbksttlmdt is '';
comment on column ${idl_schema}.mpcs_a08thvtrx.budgetary is '预算级次';
comment on column ${idl_schema}.mpcs_a08thvtrx.exchgflg is '个人汇兑标识';
comment on column ${idl_schema}.mpcs_a08thvtrx.orisrcsysssn is '原交易流水';
comment on column ${idl_schema}.mpcs_a08thvtrx.orisyscd is '原支付通道';
comment on column ${idl_schema}.mpcs_a08thvtrx.redoflag is '重发标志';
comment on column ${idl_schema}.mpcs_a08thvtrx.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mpcs_a08thvtrx.etl_timestamp is 'ETL处理时间戳';
