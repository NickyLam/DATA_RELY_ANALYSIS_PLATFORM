/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a10tibpsdetaillog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a10tibpsdetaillog
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a10tibpsdetaillog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a10tibpsdetaillog(
    function varchar2(15) -- 主机交易码
    ,function1 varchar2(15) -- 前置交易码
    ,function2 varchar2(30) -- 人行交易代码
    ,businesstrace varchar2(24) -- 行内业务序号
    ,businessno varchar2(42) -- 业务序号
    ,hostretcode varchar2(36) -- 主机结果代码
    ,processcode varchar2(6) -- 人行业务状态
    ,rscode varchar2(6) -- 拒绝原因代码
    ,functype varchar2(6) -- 人行业务类型
    ,businesskind varchar2(8) -- 人行业务种类
    ,businesstype varchar2(8) -- 与主机对账状态
    ,batch varchar2(12) -- 场次
    ,amount varchar2(23) -- 交易金额
    ,kind varchar2(5) -- 币种
    ,settlestat varchar2(2) -- 与人行对账状态
    ,trace varchar2(24) -- 前置机流水号
    ,hosttrace varchar2(96) -- 主机流水号
    ,ticket varchar2(18) -- 传票号
    ,node varchar2(15) -- 交易网点
    ,operater varchar2(15) -- 操作员号
    ,governor1 varchar2(8) -- 主管号一
    ,governor2 varchar2(15) -- 主管号二
    ,terminal varchar2(6) -- 终端号
    ,printstat varchar2(2) -- 网点打印标志
    ,printstat1 varchar2(2) -- 临时打印标志
    ,printtime varchar2(2) -- 打印次数
    ,subj varchar2(6) -- 科目号
    ,vouchkind varchar2(3) -- 凭证类型
    ,vouch varchar2(30) -- 凭证号码
    ,billrecdate varchar2(12) -- 票面记载日期
    ,date0 varchar2(12) -- 提出提回日期
    ,date1 varchar2(12) -- 记帐日期
    ,date2 varchar2(12) -- 送银行日期
    ,dealdate varchar2(12) -- 人行处理日期
    ,trantime varchar2(21) -- 行内系统受理时间
    ,sendtime varchar2(21) -- 业务发起时间
    ,level0 varchar2(2) -- 提交优先级
    ,flag1 varchar2(2) -- 提出提回标记
    ,flag2 varchar2(2) -- 实时联机标记
    ,flag3 varchar2(2) -- 收费标志
    ,flag4 varchar2(2) -- 借贷标记
    ,acceptbank varchar2(18) -- 收款(查询)行行号
    ,acceptbankname varchar2(105) -- 收款(查询)行行名
    ,acceptacct varchar2(48) -- 收款(查询)人帐号
    ,acceptname varchar2(180) -- 收款(查询)人姓名
    ,acceptaccttype varchar2(6) -- 收款(查询)人账户类型
    ,sendbank varchar2(18) -- 付款(被查询)行行号
    ,sendbankname varchar2(105) -- 付款(被查询)行行名
    ,sendacct varchar2(48) -- 付款(被查询)人帐号
    ,sendname varchar2(180) -- 付款(被查询)人姓名
    ,sendaccttype varchar2(6) -- 付款(被查询)人账户类型
    ,msgoutbank varchar2(18) -- 发报行行号
    ,msginbank varchar2(18) -- 收报行行号
    ,status varchar2(2) -- 交易状态
    ,counter varchar2(15) -- 渠道
    ,fill varchar2(384) -- 保留
    ,rejectbank varchar2(18) -- 拒绝业务的机构行号
    ,outsdficode varchar2(18) -- 付款(被查询)清算行行号
    ,insdficode varchar2(18) -- 收款(查询)清算行行号
    ,sendopenbank varchar2(18) -- 付款(被查询)人开户行行号
    ,acceptopenbank varchar2(18) -- 收款(查询)人开户行行号
    ,sendcitycode varchar2(9) -- 付款(被查询)人开户行所属城市代码
    ,acceptcitycode varchar2(9) -- 收款(查询)人开户行所属城市代码
    ,chargefee varchar2(30) -- 手续费
    ,postfee varchar2(30) -- 邮电费
    ,thirdchargefee varchar2(30) -- 第三方机构手续费金额
    ,settleamount varchar2(23) -- 结算金额
    ,endtoendid varchar2(53) -- 端到端标识号、网上交易单号
    ,authtype varchar2(6) -- 认证方式
    ,authinfo varchar2(210) -- 认证信息
    ,authid varchar2(90) -- 预授权号
    ,merchantcode varchar2(300) -- 商户号
    ,merchantname varchar2(180) -- 商户名称
    ,onlinetrantrace varchar2(53) -- 第三方机构行号、收取手续费的参与机构号
    ,onlinetrantime varchar2(21) -- 网上交易时间
    ,onlinetrandesc varchar2(384) -- 网上交易说明
    ,opennode varchar2(15) -- 开户网点号
    ,chmoment varchar2(420) -- 附言
    ,coldate varchar2(12) -- 对账日期
    ,url varchar2(3072) -- url
    ,dealcolflag varchar2(2) -- 对账处理标志
    ,dataid varchar2(96) -- 交易索引号
    ,eaccflg varchar2(3) -- 电子账户标志
    ,transno varchar2(96) -- 电子账户记账请求流水
    ,nextdayflag varchar2(2) -- 次日达标识
    ,bingflag varchar2(3) -- 监管账户
    ,bingacct varchar2(75) -- 监管账号
    ,bingacctnm varchar2(180) -- 监管账号户名
    ,bingacctopeninst varchar2(15) -- 监管账号开户机构
    ,accttype varchar2(30) -- 账户类型
    ,opertype varchar2(6) -- 签约类型
    ,backflag varchar2(2) -- 退款标志
    ,orgnlmsgid varchar2(42) -- 原报文标识号
    ,orgnlmmbid varchar2(18) -- 发起参与机构行号
    ,abscde varchar2(15) -- 会记分录
    ,tacctp varchar2(30) -- 账户类别
    ,handleflag varchar2(3) -- 是否预绑
    ,custno varchar2(45) -- 客户号
    ,otpseqno varchar2(45) -- 短信验证序列号
    ,mobile varchar2(45) -- 手机号码
    ,sendidcode varchar2(27) -- 证件号
    ,traceseqno varchar2(30) -- 超级网银记账流水关联序号
    ,limitorderid varchar2(96) -- 限额订单号
    ,isbindcard varchar2(5) -- 是否绑定标志
    ,globalseqno varchar2(96) -- 全局流水号
    ,returncode varchar2(30) -- esb接口返回码
    ,returnmsg varchar2(1536) -- esb接口返回信息
    ,transseqno varchar2(96) -- esb接口交易流水号
    ,finaccountid varchar2(60) -- 产品账户
    ,memocntt varchar2(60) -- 摘要码
    ,backacctdt varchar2(12) -- 返回的第三方记账日期
    ,backacctseq varchar2(96) -- 返回的第三方记账流水
    ,unique_seq_num varchar2(96) -- 业务流水号
    ,chn_id varchar2(15) -- 渠道id
    ,srvcfee varchar2(24) -- 服务费用
    ,deductmut varchar2(6) -- 扣款时间单位
    ,deductintvl varchar2(5) -- 扣款时间间隔
    ,agramt varchar2(24) -- 约定额度
    ,odamt varchar2(35) -- 透支金额
    ,odflag varchar2(3) -- 透支标志
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
grant select on ${iol_schema}.mpcs_a10tibpsdetaillog to ${iml_schema};
grant select on ${iol_schema}.mpcs_a10tibpsdetaillog to ${icl_schema};
grant select on ${iol_schema}.mpcs_a10tibpsdetaillog to ${idl_schema};
grant select on ${iol_schema}.mpcs_a10tibpsdetaillog to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a10tibpsdetaillog is '';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.function is '主机交易码';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.function1 is '前置交易码';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.function2 is '人行交易代码';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.businesstrace is '行内业务序号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.businessno is '业务序号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.hostretcode is '主机结果代码';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.processcode is '人行业务状态';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.rscode is '拒绝原因代码';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.functype is '人行业务类型';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.businesskind is '人行业务种类';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.businesstype is '与主机对账状态';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.batch is '场次';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.amount is '交易金额';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.kind is '币种';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.settlestat is '与人行对账状态';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.trace is '前置机流水号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.hosttrace is '主机流水号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.ticket is '传票号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.node is '交易网点';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.operater is '操作员号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.governor1 is '主管号一';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.governor2 is '主管号二';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.terminal is '终端号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.printstat is '网点打印标志';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.printstat1 is '临时打印标志';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.printtime is '打印次数';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.subj is '科目号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.vouchkind is '凭证类型';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.vouch is '凭证号码';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.billrecdate is '票面记载日期';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.date0 is '提出提回日期';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.date1 is '记帐日期';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.date2 is '送银行日期';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.dealdate is '人行处理日期';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.trantime is '行内系统受理时间';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.sendtime is '业务发起时间';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.level0 is '提交优先级';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.flag1 is '提出提回标记';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.flag2 is '实时联机标记';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.flag3 is '收费标志';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.flag4 is '借贷标记';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.acceptbank is '收款(查询)行行号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.acceptbankname is '收款(查询)行行名';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.acceptacct is '收款(查询)人帐号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.acceptname is '收款(查询)人姓名';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.acceptaccttype is '收款(查询)人账户类型';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.sendbank is '付款(被查询)行行号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.sendbankname is '付款(被查询)行行名';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.sendacct is '付款(被查询)人帐号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.sendname is '付款(被查询)人姓名';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.sendaccttype is '付款(被查询)人账户类型';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.msgoutbank is '发报行行号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.msginbank is '收报行行号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.status is '交易状态';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.counter is '渠道';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.fill is '保留';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.rejectbank is '拒绝业务的机构行号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.outsdficode is '付款(被查询)清算行行号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.insdficode is '收款(查询)清算行行号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.sendopenbank is '付款(被查询)人开户行行号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.acceptopenbank is '收款(查询)人开户行行号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.sendcitycode is '付款(被查询)人开户行所属城市代码';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.acceptcitycode is '收款(查询)人开户行所属城市代码';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.chargefee is '手续费';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.postfee is '邮电费';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.thirdchargefee is '第三方机构手续费金额';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.settleamount is '结算金额';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.endtoendid is '端到端标识号、网上交易单号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.authtype is '认证方式';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.authinfo is '认证信息';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.authid is '预授权号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.merchantcode is '商户号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.merchantname is '商户名称';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.onlinetrantrace is '第三方机构行号、收取手续费的参与机构号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.onlinetrantime is '网上交易时间';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.onlinetrandesc is '网上交易说明';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.opennode is '开户网点号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.chmoment is '附言';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.coldate is '对账日期';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.url is 'url';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.dealcolflag is '对账处理标志';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.dataid is '交易索引号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.eaccflg is '电子账户标志';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.transno is '电子账户记账请求流水';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.nextdayflag is '次日达标识';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.bingflag is '监管账户';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.bingacct is '监管账号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.bingacctnm is '监管账号户名';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.bingacctopeninst is '监管账号开户机构';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.accttype is '账户类型';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.opertype is '签约类型';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.backflag is '退款标志';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.orgnlmsgid is '原报文标识号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.orgnlmmbid is '发起参与机构行号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.abscde is '会记分录';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.tacctp is '账户类别';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.handleflag is '是否预绑';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.custno is '客户号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.otpseqno is '短信验证序列号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.mobile is '手机号码';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.sendidcode is '证件号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.traceseqno is '超级网银记账流水关联序号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.limitorderid is '限额订单号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.isbindcard is '是否绑定标志';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.globalseqno is '全局流水号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.returncode is 'esb接口返回码';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.returnmsg is 'esb接口返回信息';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.transseqno is 'esb接口交易流水号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.finaccountid is '产品账户';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.memocntt is '摘要码';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.backacctdt is '返回的第三方记账日期';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.backacctseq is '返回的第三方记账流水';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.unique_seq_num is '业务流水号';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.chn_id is '渠道id';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.srvcfee is '服务费用';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.deductmut is '扣款时间单位';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.deductintvl is '扣款时间间隔';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.agramt is '约定额度';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.odamt is '透支金额';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.odflag is '透支标志';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a10tibpsdetaillog.etl_timestamp is 'ETL处理时间戳';
