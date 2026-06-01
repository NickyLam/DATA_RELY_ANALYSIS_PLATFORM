/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0jtpmisaddghfxseinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo(
    mainseq varchar2(24) -- 中台流水号
    ,transdt varchar2(12) -- 交易日期
    ,businesstrace varchar2(24) -- 行内业务序号
    ,status varchar2(3) -- 交易状态 z 初始状态 1 已应答
    ,trantype varchar2(5) -- 交易类型  zgl  占额度购汇录入 zgb  占额度购汇补录 ugl  不占额度购汇录入 ugb  不占额度购汇补录
    ,bank_self_num varchar2(75) -- 银行自身流水号
    ,biz_type_code varchar2(3) -- 业务类型代码 01-占用额度的结汇 02-个人贸易结汇 03-提供凭证的经常项目其他结汇 04-资本项目结汇 05-通过支付机构的结汇
    ,idtype_code varchar2(6) -- 证件类型代码
    ,idcode varchar2(75) -- 证件号码
    ,ctycode varchar2(5) -- 国家/地区代码
    ,add_idcode varchar2(75) -- 补充证件号码
    ,person_name varchar2(384) -- 姓名
    ,purfx_type_code varchar2(8) -- 购汇资金属性代码
    ,txccy varchar2(5) -- 币种
    ,purfx_amt varchar2(27) -- 购汇金额
    ,purfx_cash_amt varchar2(27) -- 购汇提钞金额
    ,fcy_remit_amt varchar2(27) -- 汇出资金（包括外汇票据）金额
    ,fcy_acct_amt varchar2(27) -- 存入个人外汇账户金额
    ,tchk_amt varchar2(27) -- 旅行支票金额
    ,purfx_acct_cny varchar2(48) -- 购汇人民币账户
    ,lcy_acct_no varchar2(53) -- 个人外汇账户账号
    ,biz_tx_chnl_code varchar2(3) -- 务办理渠道代码 12-柜台渠道（接口模式）21-网上银行 22-手机银行 23-自助终端 24-电话银行 42-特许兑换机构（接口模式）
    ,agent_corp_code varchar2(27) -- 代理企业组织机构代码
    ,agent_corp_name varchar2(384) -- 代理企业名称
    ,indiv_org_code varchar2(27) -- 个体工商户组织机构代码
    ,indiv_org_name varchar2(384) -- 个体工商户名称
    ,pay_org_code varchar2(27) -- 支付机构组织机构代码
    ,capitalno varchar2(30) -- 外汇局批件号/备案表号/业务编号
    ,biz_tx_time varchar2(30) -- 业务办理时间
    ,rein_reason_code varchar2(3) -- 补录原因代码
    ,rein_remark varchar2(384) -- 补录说明
    ,remark varchar2(768) -- 备注
    ,refno varchar2(75) -- 业务参号
    ,ret_bank_self_num varchar2(75) -- 回执银行自身流水号
    ,purfx_amt_usd varchar2(27) -- 本次购汇金额折美元
    ,ann_rem_fcyamt_usd varchar2(27) -- 本年额度内剩余可购汇金额折美元
    ,type_status varchar2(3) -- 个人主体分类状态代码
    ,pub_date varchar2(12) -- 发布日期
    ,end_date varchar2(12) -- 到期日期
    ,pub_reason varchar2(768) -- 发布原因
    ,pub_code varchar2(3) -- 发布原因代码
    ,code varchar2(9) -- 代码
    ,detail varchar2(768) -- 错误详细信息
    ,pckheadsrc varchar2(9) -- 发起节点代码
    ,pckheaddes varchar2(14) -- 接收节点代码
    ,pckheadsendtime varchar2(30) -- 发送时间
    ,pckheadcommon_org_code varchar2(18) -- 机构代码
    ,pckheadmsgno varchar2(50) -- 报文参考号
    ,transmessage varchar2(300) -- 
    ,srcsysid varchar2(15) -- 
    ,srcseqno varchar2(96) -- 
    ,edit_reason_code varchar2(5) -- 
    ,edit_remark varchar2(384) -- 
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
grant select on ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo is '';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.mainseq is '中台流水号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.businesstrace is '行内业务序号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.status is '交易状态 z 初始状态 1 已应答';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.trantype is '交易类型  zgl  占额度购汇录入 zgb  占额度购汇补录 ugl  不占额度购汇录入 ugb  不占额度购汇补录';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.bank_self_num is '银行自身流水号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.biz_type_code is '业务类型代码 01-占用额度的结汇 02-个人贸易结汇 03-提供凭证的经常项目其他结汇 04-资本项目结汇 05-通过支付机构的结汇';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.idtype_code is '证件类型代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.idcode is '证件号码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.ctycode is '国家/地区代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.add_idcode is '补充证件号码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.person_name is '姓名';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.purfx_type_code is '购汇资金属性代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.txccy is '币种';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.purfx_amt is '购汇金额';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.purfx_cash_amt is '购汇提钞金额';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.fcy_remit_amt is '汇出资金（包括外汇票据）金额';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.fcy_acct_amt is '存入个人外汇账户金额';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.tchk_amt is '旅行支票金额';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.purfx_acct_cny is '购汇人民币账户';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.lcy_acct_no is '个人外汇账户账号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.biz_tx_chnl_code is '务办理渠道代码 12-柜台渠道（接口模式）21-网上银行 22-手机银行 23-自助终端 24-电话银行 42-特许兑换机构（接口模式）';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.agent_corp_code is '代理企业组织机构代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.agent_corp_name is '代理企业名称';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.indiv_org_code is '个体工商户组织机构代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.indiv_org_name is '个体工商户名称';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.pay_org_code is '支付机构组织机构代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.capitalno is '外汇局批件号/备案表号/业务编号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.biz_tx_time is '业务办理时间';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.rein_reason_code is '补录原因代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.rein_remark is '补录说明';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.remark is '备注';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.refno is '业务参号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.ret_bank_self_num is '回执银行自身流水号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.purfx_amt_usd is '本次购汇金额折美元';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.ann_rem_fcyamt_usd is '本年额度内剩余可购汇金额折美元';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.type_status is '个人主体分类状态代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.pub_date is '发布日期';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.end_date is '到期日期';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.pub_reason is '发布原因';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.pub_code is '发布原因代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.code is '代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.detail is '错误详细信息';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.pckheadsrc is '发起节点代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.pckheaddes is '接收节点代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.pckheadsendtime is '发送时间';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.pckheadcommon_org_code is '机构代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.pckheadmsgno is '报文参考号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.transmessage is '';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.srcsysid is '';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.srcseqno is '';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.edit_reason_code is '';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.edit_remark is '';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo.etl_timestamp is 'ETL处理时间戳';
