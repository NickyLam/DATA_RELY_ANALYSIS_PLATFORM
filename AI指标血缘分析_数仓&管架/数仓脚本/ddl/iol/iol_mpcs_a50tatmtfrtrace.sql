/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a50tatmtfrtrace
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a50tatmtfrtrace
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a50tatmtfrtrace purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50tatmtfrtrace(
    msgtype varchar2(4) -- 消息类型
    ,acqinstid varchar2(8) -- 受理方标识码
    ,fwdinstid varchar2(8) -- 发送方标识码
    ,transcode varchar2(12) -- 交易码
    ,systrace varchar2(6) -- 系统跟踪号
    ,zttransdate varchar2(8) -- 中台日期
    ,transdate varchar2(8) -- 银联前置日期
    ,transtime varchar2(10) -- 交易时间
    ,priacct varchar2(20) -- 主账号
    ,mobile varchar2(20) -- 核心开户预留手机号
    ,transamt number(15,2) -- 交易金额
    ,settlmtamt number(15,2) -- 清算金额
    ,status varchar2(2) -- 状态00: 失效状态(最终状态) 01: 冻结成功(最终状态) 02：已冲正(最终状态) 22：核心冲正失败(最终状态) 03：upp添加失败(最终状态，可忽视) 04：upp添加成功 15：已发送到upp添加 05: 已发送到核心冻结 06：已发送到upp撤销 17：upp撤销失败(最终状态) 19：upp已撤消(最终状态) 07：核心撤销失败 08: 核心冻结失败 09: 核心已撤消 10：扣款失败 11：扣款成功(最终状态) 12: 解冻失败(最终状态) 13：解冻成功(最终状态) 25: 核心找不到
    ,ylstatus varchar2(1) -- 银联转账结果通知结果，0：成功，1：失败，2：已撤销
    ,hostnbr varchar2(64) -- 核心冻结流水号
    ,hostdate varchar2(10) -- 核心冻结日期
    ,delayhostnbr varchar2(64) -- 核心扣款流水号
    ,delaydate varchar2(8) -- 实际扣款日期
    ,delaytime varchar2(10) -- 实际扣款时间
    ,delaystatus varchar2(2) -- 实际扣款状态
    ,errcode varchar2(20) -- 错误码
    ,errmsg varchar2(192) -- 错误信息
    ,oldacqinstid varchar2(11) -- 原受理方标识码
    ,oldfwdinstid varchar2(11) -- 原发送方标识码
    ,oldsystrace varchar2(6) -- 原系统跟踪号
    ,oldtranstime varchar2(10) -- 原交易时间（mmddhhmmss）
    ,servtp varchar2(3) -- 渠道id
    ,devtype varchar2(3) -- 设备类型
    ,devnbr varchar2(8) -- 设备号
    ,nodeid varchar2(32) -- 节点号
    ,posentrymode varchar2(3) -- 服务点输入方式码
    ,cardseq varchar2(3) -- 卡序号
    ,settlmtdt varchar2(8) -- 清算日期
    ,outacctnbr varchar2(20) -- 输出账号
    ,inacctnbr varchar2(20) -- 输入账号
    ,tlrno varchar2(20) -- 柜员号
    ,brcno varchar2(15) -- 机构号
    ,channels varchar2(10) -- 通道号
    ,dsttrncd varchar2(15) -- 交易代码
    ,workcode varchar2(15) -- 交易代码
    ,mchnttype varchar2(4) -- 商户类型
    ,accptrid varchar2(15) -- 受理商户代码
    ,accttrnmlc varchar2(60) -- 受理方名称和地址
    ,ccynbr varchar2(3) -- 币种
    ,ylccynbr varchar2(3) -- 银联币种
    ,cvncode varchar2(3) -- cvn码
    ,pindata varchar2(32) -- 密码
    ,accttype varchar2(1) -- 账户类型
    ,savecode varchar2(10) -- 储种
    ,termcode varchar2(10) -- 存期
    ,businesstype varchar2(2) -- 业务类型
    ,purpos varchar2(3) -- 资金用途
    ,pbocelem varchar2(200) -- ic卡55域
    ,msgfill varchar2(200) -- 备注
    ,remark1 varchar2(30) -- 是否已调账 1：已处理 其他未处理
    ,remark2 varchar2(100) -- 保留
    ,remark3 varchar2(300) -- 对手方户名
    ,global_seq varchar2(64) -- 全局流水号
    ,trn_seq varchar2(64) -- 交易流水号
    ,fee number(18,2) -- 手续费
    ,memo_cd varchar2(20) -- 摘要码
    ,busi_seq varchar2(64) -- 业务流水号
    ,old_global_seq varchar2(64) -- 原全局流水号
    ,old_busi_seq varchar2(64) -- 原业务流水号
    ,old_trn_seq varchar2(64) -- 原交易流水号
    ,fee_type varchar2(30) -- 费用类型
    ,transtp varchar2(30) -- 交易类型
    ,acctname varchar2(100) -- 转出账户名称
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
grant select on ${iol_schema}.mpcs_a50tatmtfrtrace to ${iml_schema};
grant select on ${iol_schema}.mpcs_a50tatmtfrtrace to ${icl_schema};
grant select on ${iol_schema}.mpcs_a50tatmtfrtrace to ${idl_schema};
grant select on ${iol_schema}.mpcs_a50tatmtfrtrace to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a50tatmtfrtrace is 'ATM延时转账流水';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.msgtype is '消息类型';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.acqinstid is '受理方标识码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.fwdinstid is '发送方标识码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.transcode is '交易码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.systrace is '系统跟踪号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.zttransdate is '中台日期';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.transdate is '银联前置日期';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.transtime is '交易时间';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.priacct is '主账号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.mobile is '核心开户预留手机号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.settlmtamt is '清算金额';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.status is '状态00: 失效状态(最终状态) 01: 冻结成功(最终状态) 02：已冲正(最终状态) 22：核心冲正失败(最终状态) 03：upp添加失败(最终状态，可忽视) 04：upp添加成功 15：已发送到upp添加 05: 已发送到核心冻结 06：已发送到upp撤销 17：upp撤销失败(最终状态) 19：upp已撤消(最终状态) 07：核心撤销失败 08: 核心冻结失败 09: 核心已撤消 10：扣款失败 11：扣款成功(最终状态) 12: 解冻失败(最终状态) 13：解冻成功(最终状态) 25: 核心找不到';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.ylstatus is '银联转账结果通知结果，0：成功，1：失败，2：已撤销';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.hostnbr is '核心冻结流水号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.hostdate is '核心冻结日期';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.delayhostnbr is '核心扣款流水号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.delaydate is '实际扣款日期';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.delaytime is '实际扣款时间';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.delaystatus is '实际扣款状态';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.errcode is '错误码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.oldacqinstid is '原受理方标识码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.oldfwdinstid is '原发送方标识码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.oldsystrace is '原系统跟踪号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.oldtranstime is '原交易时间（mmddhhmmss）';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.servtp is '渠道id';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.devtype is '设备类型';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.devnbr is '设备号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.nodeid is '节点号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.posentrymode is '服务点输入方式码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.cardseq is '卡序号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.settlmtdt is '清算日期';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.outacctnbr is '输出账号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.inacctnbr is '输入账号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.tlrno is '柜员号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.brcno is '机构号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.channels is '通道号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.dsttrncd is '交易代码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.workcode is '交易代码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.mchnttype is '商户类型';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.accptrid is '受理商户代码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.accttrnmlc is '受理方名称和地址';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.ccynbr is '币种';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.ylccynbr is '银联币种';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.cvncode is 'cvn码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.pindata is '密码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.accttype is '账户类型';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.savecode is '储种';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.termcode is '存期';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.businesstype is '业务类型';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.purpos is '资金用途';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.pbocelem is 'ic卡55域';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.msgfill is '备注';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.remark1 is '是否已调账 1：已处理 其他未处理';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.remark2 is '保留';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.remark3 is '对手方户名';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.global_seq is '全局流水号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.trn_seq is '交易流水号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.fee is '手续费';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.memo_cd is '摘要码';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.busi_seq is '业务流水号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.old_global_seq is '原全局流水号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.old_busi_seq is '原业务流水号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.old_trn_seq is '原交易流水号';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.fee_type is '费用类型';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.transtp is '交易类型';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.acctname is '转出账户名称';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a50tatmtfrtrace.etl_timestamp is 'ETL处理时间戳';
