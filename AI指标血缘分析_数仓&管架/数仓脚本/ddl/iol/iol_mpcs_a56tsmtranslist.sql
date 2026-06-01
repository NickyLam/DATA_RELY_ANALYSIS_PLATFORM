/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a56tsmtranslist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a56tsmtranslist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a56tsmtranslist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a56tsmtranslist(
    optype varchar2(45) -- 操作类型
    ,cmdtype varchar2(6) -- 指令类型：01-应用申请， 02-应用下载及个人化， 03-应用删除， 04-应用锁定， 05-应用解锁， 06-应用更新， 07-应用数据更新预销户退订
    ,seid varchar2(48) -- 安全载体标识
    ,appid varchar2(48) -- 应用id
    ,appversion varchar2(15) -- 应用版本
    ,processid varchar2(45) -- 申请单号
    ,acctno varchar2(53) -- 账号
    ,pin varchar2(24) -- 密码
    ,accttype varchar2(3) -- 账户类型（01-借记卡， 02- 贷记卡， 06-纯电子现金卡）
    ,custno varchar2(30) -- 客户号
    ,ecashbalance varchar2(23) -- 电子现金余额
    ,idtype varchar2(3) -- 证件类型
    ,idno varchar2(30) -- 证件号
    ,acctname varchar2(120) -- 姓名
    ,mobile varchar2(18) -- 手机号
    ,smsauthcode varchar2(12) -- 短信验证码
    ,mobilestate varchar2(6) -- 11-预销户退订, 12-销户退订, 13-过户退订, 14-改号退订, 21-欠费停机, 22-用户挂失停机, 23-用户主动停机, 31-续费恢复, 32-解挂后恢复, 33-主动停机后复机, 41-mocam注册通知
    ,bindacctno varchar2(53) -- 开卡时上送的验证卡号
    ,relacctno varchar2(53) -- tsm电子现金账户关联转出账户卡号
    ,sharedtype varchar2(2) -- 是否共享账户（0-银行自行决定， 1-共享账户， 2-非共享账户）：共享账户是指新申请应用的后台账户与用于申请该应用所使用的卡片信息的后台账户对应为同一个
    ,acctstate varchar2(2) -- tsm账户状态：0-正常， 1-预开立, 2-锁定， 3-挂失， 4-删除（销户）
    ,applocked varchar2(2) -- 应用锁定：
    ,chnlid varchar2(23) -- 渠道码
    ,opendate varchar2(23) -- 开卡日期
    ,rspcd varchar2(15) -- 核心返回码
    ,rspmsg varchar2(384) -- 核心返回信息
    ,interfaceversion varchar2(15) -- 接口版本号
    ,transtimesource varchar2(23) -- 发起方交易时间
    ,transtimedestination varchar2(23) -- 接收方交易时间
    ,transseqsource varchar2(48) -- 交易发起方流水号
    ,transseqdestination varchar2(48) -- 交易接收方流水号
    ,transtype varchar2(30) -- 交易类型
    ,transsource varchar2(18) -- 报文请求方
    ,transdestination varchar2(18) -- 报文接收方
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
grant select on ${iol_schema}.mpcs_a56tsmtranslist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a56tsmtranslist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a56tsmtranslist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a56tsmtranslist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a56tsmtranslist is 'TSM操作流水表';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.optype is '操作类型';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.cmdtype is '指令类型：01-应用申请， 02-应用下载及个人化， 03-应用删除， 04-应用锁定， 05-应用解锁， 06-应用更新， 07-应用数据更新预销户退订';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.seid is '安全载体标识';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.appid is '应用id';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.appversion is '应用版本';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.processid is '申请单号';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.acctno is '账号';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.pin is '密码';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.accttype is '账户类型（01-借记卡， 02- 贷记卡， 06-纯电子现金卡）';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.custno is '客户号';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.ecashbalance is '电子现金余额';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.idtype is '证件类型';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.idno is '证件号';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.acctname is '姓名';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.mobile is '手机号';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.smsauthcode is '短信验证码';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.mobilestate is '11-预销户退订, 12-销户退订, 13-过户退订, 14-改号退订, 21-欠费停机, 22-用户挂失停机, 23-用户主动停机, 31-续费恢复, 32-解挂后恢复, 33-主动停机后复机, 41-mocam注册通知';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.bindacctno is '开卡时上送的验证卡号';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.relacctno is 'tsm电子现金账户关联转出账户卡号';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.sharedtype is '是否共享账户（0-银行自行决定， 1-共享账户， 2-非共享账户）：共享账户是指新申请应用的后台账户与用于申请该应用所使用的卡片信息的后台账户对应为同一个';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.acctstate is 'tsm账户状态：0-正常， 1-预开立, 2-锁定， 3-挂失， 4-删除（销户）';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.applocked is '应用锁定：';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.chnlid is '渠道码';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.opendate is '开卡日期';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.rspcd is '核心返回码';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.rspmsg is '核心返回信息';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.interfaceversion is '接口版本号';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.transtimesource is '发起方交易时间';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.transtimedestination is '接收方交易时间';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.transseqsource is '交易发起方流水号';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.transseqdestination is '交易接收方流水号';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.transtype is '交易类型';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.transsource is '报文请求方';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.transdestination is '报文接收方';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a56tsmtranslist.etl_timestamp is 'ETL处理时间戳';
