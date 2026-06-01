/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_mpcs_a50ubcardjour
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_mpcs_a50ubcardjour
whenever sqlerror continue none;
drop table ${idl_schema}.aml_mpcs_a50ubcardjour purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_mpcs_a50ubcardjour(
    etl_dt date -- 数据日期
    ,acqinstid varchar2(11) -- 受理方标识码
    ,fwdinstid varchar2(11) -- 发送方标识码
    ,systrace varchar2(6) -- 系统跟踪号
    ,transtime varchar2(10) -- 交易时间（MMDDHHMMSS）
    ,transcode varchar2(10) -- 交易码
    ,transdate varchar2(8) -- 前置交易日期
    ,tlrnbr varchar2(20) -- 柜员号
    ,brnnbr varchar2(8) -- 网点号
    ,trantype varchar2(2) -- 交易类型 01 : 银联前置 02 : ATMP前置 03 : 柜台交易
    ,channels varchar2(3) -- 渠道 CDM-本行CDM CUP-银联 ATM-本行ATM GMT-柜面通
    ,msgtype varchar2(4) -- 消息类型
    ,priacct varchar2(35) -- 主账户号
    ,procecode varchar2(6) -- 处理码
    ,workcode varchar2(8) -- 内部处理码
    ,transamt number(15,2) -- 交易金额
    ,onlnbl number(15,2) -- 联机余额
    ,avalbl number(15,2) -- 账户当日可用余额
    ,cravbl number(15,2) -- ATM取款当日可用余额
    ,trxfee varchar2(11) -- 交易费用
    ,localtime varchar2(6) -- 受理方所在地时间
    ,localdate varchar2(6) -- 受理方所在地日期
    ,exprdate varchar2(4) -- 有效期
    ,settlmtdate varchar2(4) -- 清算日期
    ,mchnttype varchar2(4) -- 商户类型
    ,posentrymode varchar2(3) -- 服务点输入方式码
    ,servicecode varchar2(2) -- 服务点条件码
    ,trackdata2 varchar2(37) -- 第二磁道数据
    ,trackdata3 varchar2(104) -- 第三磁道数据
    ,retrivarefnum varchar2(12) -- 检索参考号
    ,authridresp varchar2(6) -- 授权标识应答码
    ,respcode varchar2(2) -- 响应码
    ,acptermnlid varchar2(8) -- 受理终端标识码
    ,accptrid varchar2(15) -- 受理商户代码
    ,accttrnameloc varchar2(40) -- 受理方名称/地址
    ,addtnlrespcd varchar2(25) -- 附加响应数据
    ,privatedate varchar2(512) -- 附加私有域
    ,currcycode varchar2(3) -- 交易货币代码
    ,pindata varchar2(16) -- 个人标识码数据
    ,reserve varchar2(100) -- 保留域
    ,rcvinstid varchar2(11) -- 接收方标识码
    ,cupsreserve varchar2(100) -- CUPS保留
    ,oldacqinstid varchar2(11) -- 原受理方标识码
    ,oldfwdinstid varchar2(11) -- 原发送方标识码
    ,oldsystrace varchar2(6) -- 原系统跟踪号
    ,oldtranstime varchar2(10) -- 原交易时间（MMDDHHMMSS）
    ,inputdata varchar2(200) -- 输入数据
    ,outputdata varchar2(100) -- 银联汇率：优先取9域，否则取10域
    ,outacctnbr varchar2(35) -- 支出账号
    ,inacctnbr varchar2(35) -- 存入账号
    ,atmctrace varchar2(8) -- ATMC交易流水号
    ,linkid number -- 链路ID
    ,headinfo varchar2(92) -- 报文头信息
    ,status varchar2(1) -- 状态 0 : 失效状态(最终状态) 1 : 交易成功(最终状态) 2 : 已冲正(最终状态) 4 : 已发送到银联 5 : 已发送到核心 6 : 银联成功 7 : 核心成功 8 : 核心失败 9 : 已撤消(最终状态)
    ,errcode varchar2(7) -- 错误码
    ,errmsg varchar2(192) -- 错误信息
    ,tertype varchar2(10) -- 终端类型
    ,promty varchar2(10) -- 发起方式
    ,acqinstctrycd varchar2(3) -- 商户国家代码
    ,cardholdamt number(15,2) -- 持卡人扣款金额
    ,cardholdrate varchar2(9) -- 持卡人扣帐汇率
    ,settlmtamt number(15,2) -- 清算金额
    ,newfwdinstid varchar2(20) -- 发送方机构码（F33真实值）
    ,channeltp varchar2(1) -- 跨境标识符 0 境内 1境外
    ,cardseq varchar2(4) -- 卡序列号
    ,inpbocelem varchar2(512) -- 接入IC卡数据域
    ,outpbocelem varchar2(512) -- 发出IC卡数据域
    ,atmcrust varchar2(16) -- C端脚本执行响应
    ,trncd varchar2(9) -- 内部交易代码
    ,foriegnbl number(15,2) -- 外币交易主金额
    ,acctype varchar2(10) -- 账户等级，I II III类
    ,openbrch varchar2(10) -- 开户机构
    ,fee number(15,2) -- 手续费或其他费用
    ,card_type varchar2(4) -- 卡类型：0:IC卡 1:磁条卡 3:未知
    ,card_trn_typ varchar2(4) -- 卡交易类型：1:IC卡 2:磁条卡 3:二维码 4:云闪付 5:APPLEPAY 0:无卡
    ,scene varchar2(3) -- 二维码付款场景 100-被扫消费 210-主扫一般商户消费 211-主扫消费 220-主扫ATM取现 212-主扫小微商户消费   231-主扫人到人二维码付款（贷记交易） 32-主扫人到人二维码付款（扣款交易）
    ,cross_flag varchar2(1) -- 跨行标志
    ,fallback_fg varchar2(1) -- 降级标识
    ,petty_flag varchar2(1) -- 小额免密标识 1:免密
    ,respcode_s varchar2(10) -- 细化应答码
    ,memo_cd varchar2(20) -- 摘要码
    ,memo_det varchar2(254) -- 附言
    ,global_seq varchar2(64) -- 全局流水
    ,trn_seq varchar2(64) -- 交易流水
    ,old_trn_seq varchar2(64) -- 原交易流水
    ,upp_status varchar2(2) -- UPP入账状态
    ,host_nbr varchar2(50) -- 后台记账流水
    ,host_date varchar2(10) -- 后台记账日期
    ,dly_trn_id varchar2(50) -- 延时扣款交易流水
    ,dly_trn_dt varchar2(10) -- 延时扣款交易日期
    ,dly_yl_stu varchar2(2) -- 银联延时转账结果
    ,dly_status varchar2(2) -- 延时转账结果
    ,cust_termid varchar2(50) -- 终端设备号
    ,cust_ip varchar2(30) -- 终端IP
    ,client_sim varchar2(20) -- 终端SIM号码
    ,client_gps varchar2(50) -- 终端GPS位置
    ,mobile varchar2(20) -- 预留手机号
    ,cust_no varchar2(50) -- 客户号
    ,cust_name varchar2(80) -- 客户名称
    ,trn_time varchar2(20) -- 交易时中台日期 YYYYMMDDhhmmssfff
    ,back_acct_date varchar2(15) -- 后台会计日期
    ,oldtranscode varchar2(10) -- 原交易码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_mpcs_a50ubcardjour to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_mpcs_a50ubcardjour is 'ATMP/银联前置交易流水表';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.acqinstid is '受理方标识码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.fwdinstid is '发送方标识码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.systrace is '系统跟踪号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.transtime is '交易时间（MMDDHHMMSS）';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.transcode is '交易码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.transdate is '前置交易日期';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.tlrnbr is '柜员号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.brnnbr is '网点号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.trantype is '交易类型 01 : 银联前置 02 : ATMP前置 03 : 柜台交易';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.channels is '渠道 CDM-本行CDM CUP-银联 ATM-本行ATM GMT-柜面通';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.msgtype is '消息类型';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.priacct is '主账户号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.procecode is '处理码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.workcode is '内部处理码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.transamt is '交易金额';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.onlnbl is '联机余额';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.avalbl is '账户当日可用余额';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.cravbl is 'ATM取款当日可用余额';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.trxfee is '交易费用';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.localtime is '受理方所在地时间';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.localdate is '受理方所在地日期';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.exprdate is '有效期';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.settlmtdate is '清算日期';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.mchnttype is '商户类型';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.posentrymode is '服务点输入方式码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.servicecode is '服务点条件码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.trackdata2 is '第二磁道数据';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.trackdata3 is '第三磁道数据';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.retrivarefnum is '检索参考号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.authridresp is '授权标识应答码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.respcode is '响应码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.acptermnlid is '受理终端标识码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.accptrid is '受理商户代码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.accttrnameloc is '受理方名称/地址';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.addtnlrespcd is '附加响应数据';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.privatedate is '附加私有域';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.currcycode is '交易货币代码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.pindata is '个人标识码数据';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.reserve is '保留域';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.rcvinstid is '接收方标识码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.cupsreserve is 'CUPS保留';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.oldacqinstid is '原受理方标识码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.oldfwdinstid is '原发送方标识码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.oldsystrace is '原系统跟踪号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.oldtranstime is '原交易时间（MMDDHHMMSS）';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.inputdata is '输入数据';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.outputdata is '银联汇率：优先取9域，否则取10域';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.outacctnbr is '支出账号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.inacctnbr is '存入账号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.atmctrace is 'ATMC交易流水号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.linkid is '链路ID';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.headinfo is '报文头信息';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.status is '状态 0 : 失效状态(最终状态) 1 : 交易成功(最终状态) 2 : 已冲正(最终状态) 4 : 已发送到银联 5 : 已发送到核心 6 : 银联成功 7 : 核心成功 8 : 核心失败 9 : 已撤消(最终状态)';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.errcode is '错误码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.errmsg is '错误信息';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.tertype is '终端类型';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.promty is '发起方式';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.acqinstctrycd is '商户国家代码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.cardholdamt is '持卡人扣款金额';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.cardholdrate is '持卡人扣帐汇率';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.settlmtamt is '清算金额';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.newfwdinstid is '发送方机构码（F33真实值）';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.channeltp is '跨境标识符 0 境内 1境外';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.cardseq is '卡序列号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.inpbocelem is '接入IC卡数据域';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.outpbocelem is '发出IC卡数据域';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.atmcrust is 'C端脚本执行响应';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.trncd is '内部交易代码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.foriegnbl is '外币交易主金额';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.acctype is '账户等级，I II III类';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.openbrch is '开户机构';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.fee is '手续费或其他费用';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.card_type is '卡类型：0:IC卡 1:磁条卡 3:未知';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.card_trn_typ is '卡交易类型：1:IC卡 2:磁条卡 3:二维码 4:云闪付 5:APPLEPAY 0:无卡';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.scene is '二维码付款场景 100-被扫消费 210-主扫一般商户消费 211-主扫消费 220-主扫ATM取现 212-主扫小微商户消费   231-主扫人到人二维码付款（贷记交易） 32-主扫人到人二维码付款（扣款交易）';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.cross_flag is '跨行标志';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.fallback_fg is '降级标识';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.petty_flag is '小额免密标识 1:免密';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.respcode_s is '细化应答码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.memo_cd is '摘要码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.memo_det is '附言';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.global_seq is '全局流水';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.trn_seq is '交易流水';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.old_trn_seq is '原交易流水';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.upp_status is 'UPP入账状态';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.host_nbr is '后台记账流水';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.host_date is '后台记账日期';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.dly_trn_id is '延时扣款交易流水';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.dly_trn_dt is '延时扣款交易日期';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.dly_yl_stu is '银联延时转账结果';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.dly_status is '延时转账结果';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.cust_termid is '终端设备号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.cust_ip is '终端IP';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.client_sim is '终端SIM号码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.client_gps is '终端GPS位置';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.mobile is '预留手机号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.cust_no is '客户号';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.cust_name is '客户名称';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.trn_time is '交易时中台日期 YYYYMMDDhhmmssfff';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.back_acct_date is '后台会计日期';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.oldtranscode is '原交易码';
comment on column ${idl_schema}.aml_mpcs_a50ubcardjour.etl_timestamp is '数据处理时间';
