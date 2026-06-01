/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0dtps_rtrq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0dtps_rtrq
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0dtps_rtrq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0dtps_rtrq(
    sdtldt varchar2(12) -- 登记日期
    ,sdtlsq varchar2(12) -- 登记流水
    ,brchno varchar2(9) -- 交易部门
    ,grupno varchar2(3) -- 交易柜组
    ,txcode varchar2(18) -- 征收机关代码
    ,tipsdt varchar2(12) -- 委托日期
    ,tipssq varchar2(12) -- 交易流水号
    ,hdtype varchar2(2) -- 经收类别 1国库 2商业银行
    ,recvbk varchar2(18) -- 收款行行号
    ,recvut varchar2(18) -- 收款单位代码
    ,recvac varchar2(48) -- 收款账号、入库账号
    ,recvna varchar2(90) -- 收款单位名称
    ,pyerbk varchar2(18) -- 付款行行号
    ,pyacbk varchar2(18) -- 付款开户行行号
    ,pyerac varchar2(48) -- 付款账号
    ,pyutna varchar2(300) -- 缴款单位名称
    ,tranam number(15,2) -- 交易金额
    ,transt varchar2(2) -- 处理状态 0收到请求 1成功 2失败 9冲正
    ,txvhno varchar2(27) -- 税票号码
    ,txutna varchar2(300) -- 纳税人名称
    ,contid varchar2(90) -- 协议书号
    ,remark varchar2(90) -- 备用
    ,remar1 varchar2(90) -- 对账类型
    ,remar2 varchar2(90) -- 备用
    ,listnm number(22,0) -- 税种条数
    ,tranus varchar2(15) -- 录入用户
    ,taxdat varchar2(12) -- 扣税日期
    ,retncd varchar2(8) -- 处理结果 90000 成功
    ,rtinfo varchar2(90) -- 回执附言
    ,dealtm varchar2(21) -- 接收处理时间
    ,ckbkus varchar2(8) -- 复核（回执）用户
    ,strksq varchar2(96) -- 交易流水（对账不平时发往主机冲账后返回的主机流水）
    ,chckfg varchar2(2) -- 对账标识 0未对帐1同为成功,金额一致2同为成功,金额不一致3人行成功,中台失败4人行成功,中台没记录5人行失败,中台成功7同为失败
    ,prtflg number(4,0) -- 打印标志 0未打印 1已打印
    ,packno varchar2(12) -- 包流水号
    ,trantype varchar2(2) -- 交易类型 1银行端缴款 2实时扣税 3批量扣税
    ,hostnbr varchar2(90) -- 核心流水
    ,hostdate varchar2(12) -- 核心日期
    ,dataid varchar2(90) -- 主机记账id
    ,colsts varchar2(2) -- 主机对账状态 1-同为成功，金额一致 2-同为成功，金额不一致 3-主机成功，中台失败 4-主机成功，中台没记录 5-主机失败，中台成功 6-主机没记录，中台成功 7-同为失败
    ,chkflg varchar2(2) -- 交易类型 null未登记差错 1已登记差错 2登记差错失败
    ,queryno varchar2(30) -- 银行端查询缴税序号
    ,paytype varchar2(3) -- 缴款方式 1-现金 2-转账
    ,txutnaid varchar2(30) -- 纳税人识别号
    ,bookseqno varchar2(60) -- 凭证号码
    ,bookcode varchar2(15) -- 凭证类型
    ,telphoneid varchar2(45) -- 缴款人电话
    ,taxorgname varchar2(90) -- 征收机关名称
    ,passwdid varchar2(60) -- 密码
    ,chcktp varchar2(2) -- 对账类型   0：日间对账 1：日切对账
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
grant select on ${iol_schema}.mpcs_a0dtps_rtrq to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0dtps_rtrq to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0dtps_rtrq to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0dtps_rtrq to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0dtps_rtrq is 'TIPS实时批量扣税请求';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.sdtldt is '登记日期';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.sdtlsq is '登记流水';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.brchno is '交易部门';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.grupno is '交易柜组';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.txcode is '征收机关代码';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.tipsdt is '委托日期';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.tipssq is '交易流水号';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.hdtype is '经收类别 1国库 2商业银行';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.recvbk is '收款行行号';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.recvut is '收款单位代码';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.recvac is '收款账号、入库账号';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.recvna is '收款单位名称';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.pyerbk is '付款行行号';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.pyacbk is '付款开户行行号';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.pyerac is '付款账号';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.pyutna is '缴款单位名称';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.tranam is '交易金额';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.transt is '处理状态 0收到请求 1成功 2失败 9冲正';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.txvhno is '税票号码';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.txutna is '纳税人名称';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.contid is '协议书号';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.remark is '备用';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.remar1 is '对账类型';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.remar2 is '备用';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.listnm is '税种条数';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.tranus is '录入用户';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.taxdat is '扣税日期';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.retncd is '处理结果 90000 成功';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.rtinfo is '回执附言';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.dealtm is '接收处理时间';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.ckbkus is '复核（回执）用户';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.strksq is '交易流水（对账不平时发往主机冲账后返回的主机流水）';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.chckfg is '对账标识 0未对帐1同为成功,金额一致2同为成功,金额不一致3人行成功,中台失败4人行成功,中台没记录5人行失败,中台成功7同为失败';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.prtflg is '打印标志 0未打印 1已打印';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.packno is '包流水号';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.trantype is '交易类型 1银行端缴款 2实时扣税 3批量扣税';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.hostnbr is '核心流水';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.hostdate is '核心日期';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.dataid is '主机记账id';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.colsts is '主机对账状态 1-同为成功，金额一致 2-同为成功，金额不一致 3-主机成功，中台失败 4-主机成功，中台没记录 5-主机失败，中台成功 6-主机没记录，中台成功 7-同为失败';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.chkflg is '交易类型 null未登记差错 1已登记差错 2登记差错失败';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.queryno is '银行端查询缴税序号';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.paytype is '缴款方式 1-现金 2-转账';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.txutnaid is '纳税人识别号';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.bookseqno is '凭证号码';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.bookcode is '凭证类型';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.telphoneid is '缴款人电话';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.taxorgname is '征收机关名称';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.passwdid is '密码';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.chcktp is '对账类型   0：日间对账 1：日切对账';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a0dtps_rtrq.etl_timestamp is 'ETL处理时间戳';
