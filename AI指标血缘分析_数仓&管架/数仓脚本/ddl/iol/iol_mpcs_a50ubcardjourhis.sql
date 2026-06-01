/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a50ubcardjourhis
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a50ubcardjourhis
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a50ubcardjourhis purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50ubcardjourhis(
    acqinstid varchar2(17) -- 受理方标识码
    ,fwdinstid varchar2(17) -- 发送方标识码
    ,systrace varchar2(9) -- 系统跟踪号
    ,transtime varchar2(15) -- 交易时间（mmddhhmmss）
    ,transcode varchar2(15) -- 交易代码
    ,transdate varchar2(12) -- 前置交易日期
    ,tlrnbr varchar2(30) -- 柜员号
    ,brnnbr varchar2(12) -- 网点号
    ,trantype varchar2(3) -- 交易类型
    ,channels varchar2(5) -- 渠道
    ,msgtype varchar2(6) -- 消息类型
    ,priacct varchar2(53) -- 主账户号
    ,procecode varchar2(9) -- 处理码
    ,workcode varchar2(12) -- 内部处理码
    ,transamt number(15,2) -- 交易金额
    ,onlnbl number(15,2) -- 联机余额
    ,avalbl number(15,2) -- 账户当日可用余额
    ,cravbl number(15,2) -- atm取款当日可用余额
    ,trxfee varchar2(17) -- 交易费用
    ,localtime varchar2(9) -- 受理方所在地时间
    ,localdate varchar2(9) -- 受理方所在地日期
    ,exprdate varchar2(6) -- 有效期
    ,settlmtdate varchar2(6) -- 清算日期
    ,mchnttype varchar2(6) -- 商户类型
    ,posentrymode varchar2(5) -- 服务点输入方式码
    ,servicecode varchar2(3) -- 服务点条件码
    ,trackdata2 varchar2(56) -- 二磁道数据
    ,trackdata3 varchar2(156) -- 三磁道数据
    ,retrivarefnum varchar2(18) -- 检索参考号
    ,authridresp varchar2(9) -- 授权标识应答码
    ,respcode varchar2(3) -- 响应码
    ,acptermnlid varchar2(12) -- 受理终端标识码
    ,accptrid varchar2(23) -- 受理商户代码
    ,accttrnameloc varchar2(60) -- 受理方名称/地址
    ,addtnlrespcd varchar2(38) -- 附加响应数据
    ,privatedate varchar2(768) -- 附加私有域
    ,currcycode varchar2(5) -- 交易货币代码
    ,pindata varchar2(24) -- 个人标识码数据
    ,reserve varchar2(150) -- 保留域
    ,rcvinstid varchar2(17) -- 接收方标识码
    ,cupsreserve varchar2(150) -- cups保留
    ,oldacqinstid varchar2(17) -- 原受理方标识码
    ,oldfwdinstid varchar2(17) -- 原发送方标识码
    ,oldsystrace varchar2(9) -- 原系统跟踪号
    ,oldtranstime varchar2(15) -- 原交易时间
    ,inputdata varchar2(300) -- 输入数据
    ,outputdata varchar2(150) -- 银联汇率：优先取9域，否则取10域
    ,outacctnbr varchar2(53) -- 支出账号
    ,inacctnbr varchar2(53) -- 存入账号
    ,atmctrace varchar2(12) -- atmc交易流水号
    ,linkid number(22) -- 链路id
    ,headinfo varchar2(138) -- 报文头信息
    ,status varchar2(2) -- 状态 0 : 失效状态(最终状态) 1 : 交易成功(最终状态) 2 : 已冲正(最终状态) 4 : 已发送到银联 5 : 已发送到核心 6 : 银联成功 7 : 核心成功 8 : 核心失败 9 : 已撤消(最终状态)
    ,errcode varchar2(11) -- 错误码
    ,errmsg varchar2(288) -- 错误信息
    ,tertype varchar2(15) -- 终端类型
    ,promty varchar2(15) -- 发起方式
    ,acqinstctrycd varchar2(5) -- 商户国家代码
    ,cardholdamt number(15,2) -- 持卡人扣款金额
    ,cardholdrate varchar2(14) -- 持卡人扣账汇率
    ,settlmtamt number(15,2) -- 清算金额
    ,newfwdinstid varchar2(30) -- 发送方机构码（f33真实值）
    ,channeltp varchar2(2) -- 跨境标识符
    ,cardseq varchar2(6) -- 卡序列号
    ,inpbocelem varchar2(768) -- 接入ic卡数据域
    ,outpbocelem varchar2(768) -- 发出ic卡数据域
    ,atmcrust varchar2(24) -- c端脚本执行响应
    ,trncd varchar2(14) -- 内部交易代码
    ,foriegnbl number(15,2) -- 
    ,acctype varchar2(15) -- 账户等级，i ii iii类
    ,openbrch varchar2(15) -- 开户机构
    ,fee number(15,2) -- 手续费或其他费用
    ,card_type varchar2(6) -- 卡类型：0:ic卡 1:磁条卡 3:未知
    ,card_trn_typ varchar2(6) -- 卡交易类型：1:ic卡 2:磁条卡 3:二维码 4:云闪付 5:applepay 0:无卡
    ,scene varchar2(5) -- 二维码付款场景 100-被扫消费 210-主扫一般商户消费 211-主扫消费 220-主扫atm取现 212-主扫小微商户消费   231-主扫人到人二维码付款（贷记交易） 32-主扫人到人二维码付款（扣款交易）
    ,cross_flag varchar2(2) -- 跨行标志
    ,fallback_fg varchar2(2) -- 降级标识
    ,petty_flag varchar2(2) -- 小额免密标识 1:免密
    ,respcode_s varchar2(15) -- 细化应答码
    ,memo_cd varchar2(30) -- 摘要码
    ,memo_det varchar2(381) -- 附言
    ,global_seq varchar2(96) -- 全局流水
    ,trn_seq varchar2(96) -- 交易流水
    ,old_trn_seq varchar2(96) -- 原交易流水
    ,upp_status varchar2(3) -- upp入账状态
    ,host_nbr varchar2(75) -- 后台记账流水
    ,host_date varchar2(15) -- 后台记账日期
    ,dly_trn_id varchar2(75) -- 延时扣款交易流水
    ,dly_trn_dt varchar2(15) -- 延时扣款交易日期
    ,dly_yl_stu varchar2(3) -- 银联延时转账结果
    ,dly_status varchar2(3) -- 延时转账结果
    ,cust_termid varchar2(75) -- 终端设备号
    ,cust_ip varchar2(45) -- 终端ip
    ,client_sim varchar2(30) -- 终端sim号码
    ,client_gps varchar2(75) -- 终端gps位置
    ,mobile varchar2(30) -- 预留手机号
    ,cust_no varchar2(75) -- 客户号
    ,cust_name varchar2(120) -- 客户名称
    ,trn_time varchar2(30) -- 交易时中台日期 yyyymmddhhmmssfff
    ,back_acct_date varchar2(23) -- 后台会计日期
    ,oldtranscode varchar2(15) -- 原交易码
    ,busi_seq varchar2(96) -- 业务流水号
    ,old_busi_seq varchar2(96) -- 原业务流水号
    ,old_global_seq varchar2(96) -- 原全局流水号
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
grant select on ${iol_schema}.mpcs_a50ubcardjourhis to ${iml_schema};
grant select on ${iol_schema}.mpcs_a50ubcardjourhis to ${icl_schema};
grant select on ${iol_schema}.mpcs_a50ubcardjourhis to ${idl_schema};
grant select on ${iol_schema}.mpcs_a50ubcardjourhis to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a50ubcardjourhis is '交易历史流水表';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.acqinstid is '受理方标识码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.fwdinstid is '发送方标识码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.systrace is '系统跟踪号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.transtime is '交易时间（mmddhhmmss）';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.transcode is '交易代码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.transdate is '前置交易日期';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.tlrnbr is '柜员号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.brnnbr is '网点号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.trantype is '交易类型';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.channels is '渠道';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.msgtype is '消息类型';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.priacct is '主账户号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.procecode is '处理码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.workcode is '内部处理码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.onlnbl is '联机余额';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.avalbl is '账户当日可用余额';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.cravbl is 'atm取款当日可用余额';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.trxfee is '交易费用';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.localtime is '受理方所在地时间';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.localdate is '受理方所在地日期';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.exprdate is '有效期';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.settlmtdate is '清算日期';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.mchnttype is '商户类型';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.posentrymode is '服务点输入方式码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.servicecode is '服务点条件码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.trackdata2 is '二磁道数据';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.trackdata3 is '三磁道数据';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.retrivarefnum is '检索参考号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.authridresp is '授权标识应答码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.respcode is '响应码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.acptermnlid is '受理终端标识码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.accptrid is '受理商户代码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.accttrnameloc is '受理方名称/地址';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.addtnlrespcd is '附加响应数据';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.privatedate is '附加私有域';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.currcycode is '交易货币代码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.pindata is '个人标识码数据';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.reserve is '保留域';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.rcvinstid is '接收方标识码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.cupsreserve is 'cups保留';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.oldacqinstid is '原受理方标识码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.oldfwdinstid is '原发送方标识码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.oldsystrace is '原系统跟踪号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.oldtranstime is '原交易时间';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.inputdata is '输入数据';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.outputdata is '银联汇率：优先取9域，否则取10域';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.outacctnbr is '支出账号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.inacctnbr is '存入账号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.atmctrace is 'atmc交易流水号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.linkid is '链路id';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.headinfo is '报文头信息';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.status is '状态 0 : 失效状态(最终状态) 1 : 交易成功(最终状态) 2 : 已冲正(最终状态) 4 : 已发送到银联 5 : 已发送到核心 6 : 银联成功 7 : 核心成功 8 : 核心失败 9 : 已撤消(最终状态)';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.errcode is '错误码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.tertype is '终端类型';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.promty is '发起方式';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.acqinstctrycd is '商户国家代码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.cardholdamt is '持卡人扣款金额';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.cardholdrate is '持卡人扣账汇率';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.settlmtamt is '清算金额';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.newfwdinstid is '发送方机构码（f33真实值）';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.channeltp is '跨境标识符';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.cardseq is '卡序列号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.inpbocelem is '接入ic卡数据域';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.outpbocelem is '发出ic卡数据域';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.atmcrust is 'c端脚本执行响应';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.trncd is '内部交易代码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.foriegnbl is '';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.acctype is '账户等级，i ii iii类';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.openbrch is '开户机构';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.fee is '手续费或其他费用';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.card_type is '卡类型：0:ic卡 1:磁条卡 3:未知';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.card_trn_typ is '卡交易类型：1:ic卡 2:磁条卡 3:二维码 4:云闪付 5:applepay 0:无卡';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.scene is '二维码付款场景 100-被扫消费 210-主扫一般商户消费 211-主扫消费 220-主扫atm取现 212-主扫小微商户消费   231-主扫人到人二维码付款（贷记交易） 32-主扫人到人二维码付款（扣款交易）';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.cross_flag is '跨行标志';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.fallback_fg is '降级标识';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.petty_flag is '小额免密标识 1:免密';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.respcode_s is '细化应答码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.memo_cd is '摘要码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.memo_det is '附言';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.global_seq is '全局流水';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.trn_seq is '交易流水';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.old_trn_seq is '原交易流水';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.upp_status is 'upp入账状态';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.host_nbr is '后台记账流水';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.host_date is '后台记账日期';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.dly_trn_id is '延时扣款交易流水';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.dly_trn_dt is '延时扣款交易日期';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.dly_yl_stu is '银联延时转账结果';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.dly_status is '延时转账结果';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.cust_termid is '终端设备号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.cust_ip is '终端ip';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.client_sim is '终端sim号码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.client_gps is '终端gps位置';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.mobile is '预留手机号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.cust_no is '客户号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.cust_name is '客户名称';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.trn_time is '交易时中台日期 yyyymmddhhmmssfff';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.back_acct_date is '后台会计日期';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.oldtranscode is '原交易码';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.busi_seq is '业务流水号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.old_busi_seq is '原业务流水号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.old_global_seq is '原全局流水号';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a50ubcardjourhis.etl_timestamp is 'ETL处理时间戳';
