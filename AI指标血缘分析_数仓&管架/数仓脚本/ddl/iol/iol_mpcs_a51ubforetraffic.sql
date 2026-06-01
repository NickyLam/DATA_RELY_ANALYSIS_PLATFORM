/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubforetraffic
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubforetraffic
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubforetraffic purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubforetraffic(
    acqinstid varchar2(17) -- 受理方标识码
    ,fwdinstid varchar2(17) -- 发送方标识码
    ,systrace varchar2(9) -- 系统跟踪号(银联流水号)
    ,transtime varchar2(15) -- 交易时间(mmddhhmmss)
    ,transcode varchar2(12) -- 交易码
    ,transdate varchar2(12) -- 前置交易日期
    ,transnbr varchar2(9) -- 交易流水号
    ,tlrnbr varchar2(30) -- 柜员号
    ,brnnbr varchar2(9) -- 网点号
    ,trantype varchar2(3) -- 交易类型
    ,channels varchar2(5) -- 渠道
    ,msgtype varchar2(6) -- 消息类型
    ,priacct varchar2(53) -- 主账户号
    ,cltname varchar2(63) -- 客户姓名
    ,identype varchar2(6) -- 证件类型
    ,idennbr varchar2(35) -- 证件号码
    ,procecode varchar2(9) -- 处理码
    ,transamt number(15,2) -- 交易金额
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
    ,privatedate varchar2(150) -- 附加私有数据
    ,currcycode varchar2(5) -- 交易货币代码
    ,pindata varchar2(96) -- 个人标识码数据
    ,reserve varchar2(96) -- 保留域
    ,oldacqinstid varchar2(17) -- 原受理方标识码
    ,oldfwdinstid varchar2(17) -- 原发送方标识码
    ,oldsystrace varchar2(9) -- 原系统跟踪号
    ,oldtranstime varchar2(15) -- 原交易时间(mmddhhmmss)
    ,factor varchar2(63) -- 代理人
    ,fridentype varchar2(6) -- 代理证件类型
    ,fridennbr varchar2(32) -- 代理证件号码
    ,outacctnbr varchar2(53) -- 支出帐号
    ,inacctnbr varchar2(53) -- 存入账号
    ,hostnbr varchar2(96) -- 核心流水
    ,hostdate varchar2(12) -- 核心日期
    ,status varchar2(2) -- 状态0 : 失效状态1 : 交易成功2 : 已冲正3 : 已挂账
    ,errcode varchar2(11) -- 错误码
    ,errmsg varchar2(296) -- 错误信息
    ,cardname varchar2(63) -- 柜面通持卡人姓名
    ,recvname varchar2(63) -- 柜面通收款人姓名
    ,linkid number(9,0) -- 链路id
    ,cardseq varchar2(6) -- 卡序列号
    ,inpbocelem varchar2(768) -- 接入ic卡数据域
    ,outpbocelem varchar2(768) -- 发出ic卡数据域
    ,busi_seq varchar2(96) -- 业务流水号
    ,global_seq varchar2(96) -- 原全局流水号
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
grant select on ${iol_schema}.mpcs_a51ubforetraffic to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubforetraffic to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubforetraffic to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubforetraffic to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubforetraffic is '柜面通交易流水表';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.acqinstid is '受理方标识码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.fwdinstid is '发送方标识码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.systrace is '系统跟踪号(银联流水号)';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.transtime is '交易时间(mmddhhmmss)';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.transcode is '交易码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.transdate is '前置交易日期';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.transnbr is '交易流水号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.tlrnbr is '柜员号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.brnnbr is '网点号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.trantype is '交易类型';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.channels is '渠道';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.msgtype is '消息类型';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.priacct is '主账户号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.cltname is '客户姓名';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.identype is '证件类型';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.idennbr is '证件号码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.procecode is '处理码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.localtime is '受理方所在地时间';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.localdate is '受理方所在地日期';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.exprdate is '有效期';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.settlmtdate is '清算日期';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.mchnttype is '商户类型';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.posentrymode is '服务点输入方式码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.servicecode is '服务点条件码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.trackdata2 is '第二磁道数据';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.trackdata3 is '第三磁道数据';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.retrivarefnum is '检索参考号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.authridresp is '授权标识应答码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.respcode is '响应码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.acptermnlid is '受理终端标识码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.accptrid is '受理商户代码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.accttrnameloc is '受理方名称/地址';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.addtnlrespcd is '附加响应数据';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.privatedate is '附加私有数据';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.currcycode is '交易货币代码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.pindata is '个人标识码数据';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.reserve is '保留域';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.oldacqinstid is '原受理方标识码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.oldfwdinstid is '原发送方标识码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.oldsystrace is '原系统跟踪号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.oldtranstime is '原交易时间(mmddhhmmss)';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.factor is '代理人';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.fridentype is '代理证件类型';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.fridennbr is '代理证件号码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.outacctnbr is '支出帐号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.inacctnbr is '存入账号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.hostnbr is '核心流水';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.hostdate is '核心日期';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.status is '状态0 : 失效状态1 : 交易成功2 : 已冲正3 : 已挂账';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.errcode is '错误码';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.cardname is '柜面通持卡人姓名';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.recvname is '柜面通收款人姓名';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.linkid is '链路id';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.cardseq is '卡序列号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.inpbocelem is '接入ic卡数据域';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.outpbocelem is '发出ic卡数据域';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.busi_seq is '业务流水号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.global_seq is '原全局流水号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.old_busi_seq is '原业务流水号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.old_global_seq is '原全局流水号';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.old_trn_seq is '原交易流水号(原系统内流水号)';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.trn_seq is '交易流水号(系统内流水号)';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubforetraffic.etl_timestamp is 'ETL处理时间戳';
