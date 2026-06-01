/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a20tsafeboxinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a20tsafeboxinf
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a20tsafeboxinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a20tsafeboxinf(
    mainseq varchar2(75) -- 中台流水
    ,transdt varchar2(75) -- 交易日期
    ,transtm varchar2(75) -- 交易时间
    ,fnttrncd varchar2(30) -- 交易码
    ,safebox varchar2(75) -- 保管箱编号
    ,custtype varchar2(5) -- 客户类型
    ,custnm varchar2(300) -- 客户名称
    ,custno varchar2(30) -- 客户号
    ,idtype varchar2(6) -- 证件类型
    ,idno varchar2(75) -- 证件号码
    ,payacct varchar2(75) -- 付款账号
    ,subseqno varchar2(8) -- 子账户
    ,payname varchar2(300) -- 付款人名称
    ,payprodtype varchar2(18) -- 付款方产品类型
    ,incoacct varchar2(75) -- 收款账号
    ,incosubseqno varchar2(8) -- 收款方子账户
    ,inconame varchar2(300) -- 收款人名称
    ,incoprodtype varchar2(18) -- 收款方产品类型
    ,deposit varchar2(26) -- 押金
    ,ccy varchar2(5) -- 币种
    ,doctype varchar2(15) -- 凭证类型
    ,docno varchar2(75) -- 凭证号码
    ,draftdate varchar2(12) -- 凭证到日期
    ,fundsource varchar2(2) -- 资金来源:1-现金；2-客户转账；3-内部户转账
    ,opnrs_9_elmnt varchar2(1536) -- 开箱人9要素
    ,opnrs_20_elmnt varchar2(1536) -- 开箱人20要素
    ,opener_opnacctchk varchar2(2) -- 开箱人开户核查结果:1-通过；2-不通过
    ,opener_kycchk varchar2(2) -- 开箱人kyc核查结果:1-通过；2-不通过
    ,opener_fxqchk varchar2(2) -- 开箱人反洗钱核查结果:1-通过；2-不通过
    ,opener_lwhcchk varchar2(2) -- 开箱人联网核查结果:1-通过；2-不通过
    ,co_opnrs_9_elmnt varchar2(1536) -- 联名开箱人9要素
    ,co_opener_opnacctchk varchar2(2) -- 联名开箱人开户核查结果:1-通过；2-不通过
    ,co_opener_kycchk varchar2(2) -- 联名开箱人kyc核查结果:1-通过；2-不通过
    ,co_opener_fxqchk varchar2(2) -- 联名开箱人反洗钱核查结果:1-通过；2-不通过
    ,co_opener_lwhcchk varchar2(2) -- 联名开箱人联网核查结果:1-通过；2-不通过
    ,agent_9_elmnt varchar2(1536) -- 代理人4要素
    ,agent_opnacctchk varchar2(2) -- 代理人开户核查结果:1-通过；2-不通过
    ,agent_kycchk varchar2(2) -- 代理人kyc核查结果:1-通过；2-不通过
    ,agent_fxqchk varchar2(2) -- 代理人反洗钱核查结果:1-通过；2-不通过
    ,agent_lwhcchk varchar2(2) -- 代理人联网核查结果:1-通过；2-不通过
    ,glob_seq_num varchar2(105) -- 全局流水号
    ,unique_seq_num varchar2(105) -- 业务流水号
    ,chn_id varchar2(9) -- 渠道号
    ,brcno varchar2(15) -- 机构号
    ,tlrno varchar2(15) -- 处理柜员
    ,authtlrno varchar2(15) -- 授权柜员
    ,hangseqno varchar2(105) -- 挂销账流水
    ,dsttrncd varchar2(30) -- 第三方交易码
    ,hostdt varchar2(12) -- 核心日期
    ,hostseqno varchar2(105) -- 核心流水
    ,status varchar2(2) -- 交易状态
    ,abscde varchar2(6) -- 会计分录
    ,dataid varchar2(105) -- 记账子流水
    ,ucstat varchar2(2) -- 冲正状态：1-已冲正
    ,rspcd varchar2(30) -- 应答码
    ,rspmsg varchar2(750) -- 应答信息
    ,uc_glob_seq_num varchar2(105) -- 冲正全局流水
    ,uc_err_msg varchar2(750) -- 冲正失败信息
    ,uc_times number(22) -- 冲正次数
    ,upd_time varchar2(29) -- 更新时间
    ,rentboxdate varchar2(12) -- 租箱日期
    ,rentboxenddt varchar2(12) -- 租箱到期日
    ,rentboxstatus varchar2(2) -- 租箱状态 0-租箱失败;1-租箱;2-退箱
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
grant select on ${iol_schema}.mpcs_a20tsafeboxinf to ${iml_schema};
grant select on ${iol_schema}.mpcs_a20tsafeboxinf to ${icl_schema};
grant select on ${iol_schema}.mpcs_a20tsafeboxinf to ${idl_schema};
grant select on ${iol_schema}.mpcs_a20tsafeboxinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a20tsafeboxinf is '保管箱业务流水表';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.mainseq is '中台流水';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.transtm is '交易时间';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.fnttrncd is '交易码';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.safebox is '保管箱编号';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.custtype is '客户类型';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.custnm is '客户名称';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.custno is '客户号';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.idtype is '证件类型';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.idno is '证件号码';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.payacct is '付款账号';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.subseqno is '子账户';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.payname is '付款人名称';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.payprodtype is '付款方产品类型';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.incoacct is '收款账号';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.incosubseqno is '收款方子账户';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.inconame is '收款人名称';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.incoprodtype is '收款方产品类型';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.deposit is '押金';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.ccy is '币种';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.doctype is '凭证类型';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.docno is '凭证号码';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.draftdate is '凭证到日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.fundsource is '资金来源:1-现金；2-客户转账；3-内部户转账';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.opnrs_9_elmnt is '开箱人9要素';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.opnrs_20_elmnt is '开箱人20要素';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.opener_opnacctchk is '开箱人开户核查结果:1-通过；2-不通过';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.opener_kycchk is '开箱人kyc核查结果:1-通过；2-不通过';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.opener_fxqchk is '开箱人反洗钱核查结果:1-通过；2-不通过';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.opener_lwhcchk is '开箱人联网核查结果:1-通过；2-不通过';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.co_opnrs_9_elmnt is '联名开箱人9要素';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.co_opener_opnacctchk is '联名开箱人开户核查结果:1-通过；2-不通过';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.co_opener_kycchk is '联名开箱人kyc核查结果:1-通过；2-不通过';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.co_opener_fxqchk is '联名开箱人反洗钱核查结果:1-通过；2-不通过';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.co_opener_lwhcchk is '联名开箱人联网核查结果:1-通过；2-不通过';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.agent_9_elmnt is '代理人4要素';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.agent_opnacctchk is '代理人开户核查结果:1-通过；2-不通过';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.agent_kycchk is '代理人kyc核查结果:1-通过；2-不通过';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.agent_fxqchk is '代理人反洗钱核查结果:1-通过；2-不通过';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.agent_lwhcchk is '代理人联网核查结果:1-通过；2-不通过';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.unique_seq_num is '业务流水号';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.chn_id is '渠道号';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.brcno is '机构号';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.tlrno is '处理柜员';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.authtlrno is '授权柜员';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.hangseqno is '挂销账流水';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.dsttrncd is '第三方交易码';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.hostdt is '核心日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.hostseqno is '核心流水';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.status is '交易状态';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.abscde is '会计分录';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.dataid is '记账子流水';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.ucstat is '冲正状态：1-已冲正';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.rspcd is '应答码';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.rspmsg is '应答信息';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.uc_glob_seq_num is '冲正全局流水';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.uc_err_msg is '冲正失败信息';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.uc_times is '冲正次数';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.upd_time is '更新时间';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.rentboxdate is '租箱日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.rentboxenddt is '租箱到期日';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.rentboxstatus is '租箱状态 0-租箱失败;1-租箱;2-退箱';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a20tsafeboxinf.etl_timestamp is 'ETL处理时间戳';
