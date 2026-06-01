/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubmerchantacct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubmerchantacct
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubmerchantacct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubmerchantacct(
    transdate varchar2(12) -- 交易日期
    ,transnbr varchar2(9) -- 交易流水号
    ,hostnbr varchar2(96) -- 主机流水
    ,hostdate varchar2(18) -- 主机日期
    ,lnflag varchar2(2) -- 交易地标志n : 异地l : 本地l : 本地
    ,bankname varchar2(90) -- 行名
    ,merchantname varchar2(90) -- 商户名称
    ,dateofstlm varchar2(12) -- 清算日期
    ,bankcode varchar2(12) -- 行号
    ,merchantcode varchar2(23) -- 商行代码
    ,transamt number(15,2) -- 交易金额
    ,mchtsevifee number(12,2) -- 商行服务金额
    ,acctno varchar2(53) -- 账号
    ,sumoffee number(12,2) -- 手续费
    ,pcaamt number(15,2) -- 消费金额
    ,pptamt number(15,2) -- 退货金额
    ,rvslpcaamt number(15,2) -- 消费沖正金额
    ,rvslpptamt number(15,2) -- 退货沖正金额
    ,dadjamt number(15,2) -- 借记调整金额
    ,cadjamt number(15,2) -- 贷记调整金额
    ,transt varchar2(2) -- 交易状态 0：失败 1：成功 5：超时未知  9：预登记
    ,errcode varchar2(30) -- 错误码
    ,errmsg varchar2(288) -- 错误信息
    ,flag varchar2(2) -- 标志
    ,status varchar2(2) -- 状态 0：失败未处理 1：已入账 2：已挂账  9：无需处理
    ,brchno varchar2(15) -- 行号
    ,accnbr varchar2(30) -- 柜员号
    ,trandt varchar2(12) -- 前置交易日期
    ,sdtlsq varchar2(96) -- 登记流水
    ,transnum number(8,0) -- 交易总笔数
    ,brchbr varchar2(21) -- 机构代码
    ,acctioflg varchar2(2) -- 行内行外标记 1-行内 2-行外
    ,sysdt varchar2(12) -- 系统日期
    ,batchno varchar2(75) -- 批次号
    ,remark1 varchar2(75) -- 实际入账账户
    ,remark2 varchar2(75) -- 保留2
    ,remark3 varchar2(150) -- 核心附言
    ,remark4 varchar2(150) -- 保留4
    ,remark5 varchar2(384) -- 保留5
    ,busi_seq varchar2(96) -- 业务流水号
    ,global_seq varchar2(50) -- 全局流水号
    ,trn_seq varchar2(96) -- 交易流水号
    ,old_busi_seq varchar2(96) -- 原交易流水号
    ,old_global_seq varchar2(96) -- 原全局流水号
    ,old_trn_seq varchar2(96) -- 原业务流水号
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
grant select on ${iol_schema}.mpcs_a51ubmerchantacct to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubmerchantacct to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubmerchantacct to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubmerchantacct to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubmerchantacct is '商户入帐清单文件';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.transdate is '交易日期';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.transnbr is '交易流水号';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.hostnbr is '主机流水';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.hostdate is '主机日期';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.lnflag is '交易地标志n : 异地l : 本地l : 本地';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.bankname is '行名';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.merchantname is '商户名称';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.dateofstlm is '清算日期';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.bankcode is '行号';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.merchantcode is '商行代码';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.mchtsevifee is '商行服务金额';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.acctno is '账号';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.sumoffee is '手续费';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.pcaamt is '消费金额';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.pptamt is '退货金额';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.rvslpcaamt is '消费沖正金额';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.rvslpptamt is '退货沖正金额';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.dadjamt is '借记调整金额';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.cadjamt is '贷记调整金额';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.transt is '交易状态 0：失败 1：成功 5：超时未知  9：预登记';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.errcode is '错误码';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.flag is '标志';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.status is '状态 0：失败未处理 1：已入账 2：已挂账  9：无需处理';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.brchno is '行号';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.accnbr is '柜员号';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.trandt is '前置交易日期';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.sdtlsq is '登记流水';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.transnum is '交易总笔数';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.brchbr is '机构代码';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.acctioflg is '行内行外标记 1-行内 2-行外';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.sysdt is '系统日期';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.batchno is '批次号';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.remark1 is '实际入账账户';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.remark2 is '保留2';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.remark3 is '核心附言';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.remark4 is '保留4';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.remark5 is '保留5';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.busi_seq is '业务流水号';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.global_seq is '全局流水号';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.trn_seq is '交易流水号';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.old_busi_seq is '原交易流水号';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.old_global_seq is '原全局流水号';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.old_trn_seq is '原业务流水号';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubmerchantacct.etl_timestamp is 'ETL处理时间戳';
