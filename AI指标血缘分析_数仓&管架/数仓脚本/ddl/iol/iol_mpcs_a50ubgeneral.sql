/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a50ubgeneral
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a50ubgeneral
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a50ubgeneral purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50ubgeneral(
    acqinstid varchar2(17) -- 受理方标识码
    ,fwdinstid varchar2(17) -- 发送方标识码
    ,systrace varchar2(9) -- 系统跟踪号
    ,transtime varchar2(15) -- 交易时间(mmddhhmmss)
    ,transcode varchar2(9) -- 交易码
    ,transdate varchar2(12) -- 前置交易日期
    ,transnbr varchar2(9) -- 交易流水
    ,tlrnbr varchar2(30) -- 柜员号
    ,brnnbr varchar2(9) -- 网点号
    ,trantype varchar2(3) -- 交易类型
    ,channels varchar2(5) -- 渠道
    ,msgtype varchar2(6) -- 消息类型
    ,priacct varchar2(53) -- 主账户号
    ,procecode varchar2(9) -- 处理码
    ,transamt number(15,2) -- 交易金额
    ,feeamt number(11,2) -- 手续费
    ,localtime varchar2(9) -- 受理方所在地时间
    ,localdate varchar2(9) -- 受理方所在地日期
    ,exprdate varchar2(6) -- 有效期
    ,settlmtdate varchar2(6) -- 清算日期
    ,mchnttype varchar2(6) -- 商户类型
    ,posentrymode varchar2(5) -- 服务点输入方式码
    ,servicecode varchar2(3) -- 服务点条件码
    ,trackdata2 varchar2(56) -- 第二磁道数据
    ,trackdata3 varchar2(156) -- 第三磁道数据
    ,retrivarefnum varchar2(18) -- 检索参考号
    ,authridresp varchar2(9) -- 授权标识应答码
    ,respcode varchar2(3) -- 响应码
    ,acptermnlid varchar2(12) -- 受理终端标识码
    ,accptrid varchar2(23) -- 受理商户代码
    ,accttrnameloc varchar2(60) -- 受理方名称/地址
    ,addtnlrespcd varchar2(38) -- 附加响应数据
    ,privatedate varchar2(768) -- 附加私有数据
    ,currcycode varchar2(5) -- 交易货币代码
    ,pindata varchar2(48) -- 个人标识码数据
    ,reserve varchar2(150) -- 保留域
    ,oldacqinstid varchar2(17) -- 原受理方标识码
    ,oldfwdinstid varchar2(17) -- 原发送方标识码
    ,outacctnbr varchar2(53) -- 支出帐号
    ,inacctnbr varchar2(53) -- 存入账号
    ,status varchar2(2) -- 状态" 0:失效状态 1:交易成功 2:已冲正 3:已挂账"
    ,errcode varchar2(11) -- 错误码
    ,flag varchar2(2) -- 标志
    ,tertype varchar2(15) -- 终端类型
    ,promty varchar2(15) -- 发送类型
    ,acctna1 varchar2(45) -- 账户户名1
    ,oldsystrace varchar2(9) -- 原系统跟踪号
    ,errmsg varchar2(288) -- 错误信息
    ,oldtranstime varchar2(15) -- 原交易时间(mmddhhmmss)
    ,fundacctno varchar2(53) -- 基金账号
    ,acctna2 varchar2(45) -- 账户户名2
    ,trncd varchar2(14) -- 内部交易处理码
    ,busi_seq varchar2(96) -- 业务流水号
    ,global_seq varchar2(96) -- 全局流水号
    ,old_busi_seq varchar2(96) -- 原业务流水号
    ,old_global_seq varchar2(96) -- 原全局流水号
    ,old_trn_seq varchar2(96) -- 原交易流水号(原系统内流水号)
    ,trn_seq varchar2(96) -- 交易流水号(系统内流水号)
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
grant select on ${iol_schema}.mpcs_a50ubgeneral to ${iml_schema};
grant select on ${iol_schema}.mpcs_a50ubgeneral to ${icl_schema};
grant select on ${iol_schema}.mpcs_a50ubgeneral to ${idl_schema};
grant select on ${iol_schema}.mpcs_a50ubgeneral to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a50ubgeneral is '业务流水表';
comment on column ${iol_schema}.mpcs_a50ubgeneral.acqinstid is '受理方标识码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.fwdinstid is '发送方标识码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.systrace is '系统跟踪号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.transtime is '交易时间(mmddhhmmss)';
comment on column ${iol_schema}.mpcs_a50ubgeneral.transcode is '交易码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.transdate is '前置交易日期';
comment on column ${iol_schema}.mpcs_a50ubgeneral.transnbr is '交易流水';
comment on column ${iol_schema}.mpcs_a50ubgeneral.tlrnbr is '柜员号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.brnnbr is '网点号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.trantype is '交易类型';
comment on column ${iol_schema}.mpcs_a50ubgeneral.channels is '渠道';
comment on column ${iol_schema}.mpcs_a50ubgeneral.msgtype is '消息类型';
comment on column ${iol_schema}.mpcs_a50ubgeneral.priacct is '主账户号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.procecode is '处理码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a50ubgeneral.feeamt is '手续费';
comment on column ${iol_schema}.mpcs_a50ubgeneral.localtime is '受理方所在地时间';
comment on column ${iol_schema}.mpcs_a50ubgeneral.localdate is '受理方所在地日期';
comment on column ${iol_schema}.mpcs_a50ubgeneral.exprdate is '有效期';
comment on column ${iol_schema}.mpcs_a50ubgeneral.settlmtdate is '清算日期';
comment on column ${iol_schema}.mpcs_a50ubgeneral.mchnttype is '商户类型';
comment on column ${iol_schema}.mpcs_a50ubgeneral.posentrymode is '服务点输入方式码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.servicecode is '服务点条件码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.trackdata2 is '第二磁道数据';
comment on column ${iol_schema}.mpcs_a50ubgeneral.trackdata3 is '第三磁道数据';
comment on column ${iol_schema}.mpcs_a50ubgeneral.retrivarefnum is '检索参考号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.authridresp is '授权标识应答码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.respcode is '响应码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.acptermnlid is '受理终端标识码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.accptrid is '受理商户代码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.accttrnameloc is '受理方名称/地址';
comment on column ${iol_schema}.mpcs_a50ubgeneral.addtnlrespcd is '附加响应数据';
comment on column ${iol_schema}.mpcs_a50ubgeneral.privatedate is '附加私有数据';
comment on column ${iol_schema}.mpcs_a50ubgeneral.currcycode is '交易货币代码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.pindata is '个人标识码数据';
comment on column ${iol_schema}.mpcs_a50ubgeneral.reserve is '保留域';
comment on column ${iol_schema}.mpcs_a50ubgeneral.oldacqinstid is '原受理方标识码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.oldfwdinstid is '原发送方标识码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.outacctnbr is '支出帐号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.inacctnbr is '存入账号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.status is '状态" 0:失效状态 1:交易成功 2:已冲正 3:已挂账"';
comment on column ${iol_schema}.mpcs_a50ubgeneral.errcode is '错误码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.flag is '标志';
comment on column ${iol_schema}.mpcs_a50ubgeneral.tertype is '终端类型';
comment on column ${iol_schema}.mpcs_a50ubgeneral.promty is '发送类型';
comment on column ${iol_schema}.mpcs_a50ubgeneral.acctna1 is '账户户名1';
comment on column ${iol_schema}.mpcs_a50ubgeneral.oldsystrace is '原系统跟踪号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a50ubgeneral.oldtranstime is '原交易时间(mmddhhmmss)';
comment on column ${iol_schema}.mpcs_a50ubgeneral.fundacctno is '基金账号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.acctna2 is '账户户名2';
comment on column ${iol_schema}.mpcs_a50ubgeneral.trncd is '内部交易处理码';
comment on column ${iol_schema}.mpcs_a50ubgeneral.busi_seq is '业务流水号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.global_seq is '全局流水号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.old_busi_seq is '原业务流水号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.old_global_seq is '原全局流水号';
comment on column ${iol_schema}.mpcs_a50ubgeneral.old_trn_seq is '原交易流水号(原系统内流水号)';
comment on column ${iol_schema}.mpcs_a50ubgeneral.trn_seq is '交易流水号(系统内流水号)';
comment on column ${iol_schema}.mpcs_a50ubgeneral.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a50ubgeneral.etl_timestamp is 'ETL处理时间戳';
