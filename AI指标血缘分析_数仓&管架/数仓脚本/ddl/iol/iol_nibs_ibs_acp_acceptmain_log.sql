/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ibs_acp_acceptmain_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ibs_acp_acceptmain_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ibs_acp_acceptmain_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ibs_acp_acceptmain_log(
    tradeserno varchar2(66) -- 预受理编号
    ,oldtradeserno varchar2(32) -- 原预受理编号
    ,cardstatus varchar2(2) -- 
    ,approve_no varchar2(60) -- 订单号(视频审核直接发通知请求时使用)
    ,diff_pla_vide_res varchar2(2) -- 开户许可证核准号/基本存款账户编号
    ,acct_leg_res varchar2(2) -- 基本户法人意愿核实结果（1-审核通过，0-审核不通过）
    ,apply_type varchar2(4) -- 交易类型（2对公单位，1个人）
    ,apply_amt varchar2(64) -- 提现金额
    ,apply_ccy varchar2(20) -- 币种
    ,biztype varchar2(20) -- 业务类型 001-个人开卡预受理  002-大额取现预受理  003-定期存款/无卡折活期存款预受理  004-个人综合签约预受理  005-个人销户预受理  006-资信证明预受理  007-资信证明撤销预受理  008-保号换卡预受理  009-首次风评预受理  010-单位账户开立预受理  011-单位综合签约预受理  012-对公资信业务预受理  013-对公资信证明撤销预受理  014-单位账户信息变更预受理  015-单位账户撤销预受理  021-企业转账业务预受理 022-对公开户异地视频审核直接开户 023-对公开户预填单
    ,status varchar2(12) -- 预受理状态 0-填单中  1-已预约/已填单  2-预审通过  3-预审不通过  4-已作废  5-业务受理中  6-终审审核中  7-终审通过/已完成  8-终审不通过  9-已终止  10-已退回  11-已超时
    ,busiserno varchar2(64) -- 交易流水
    ,channelcode varchar2(40) -- 发起渠道
    ,acctno varchar2(100) -- 账户编号
    ,acctname varchar2(400) -- 户名
    ,custno varchar2(32) -- 客户编号
    ,custname varchar2(400) -- 客户名称
    ,idtype varchar2(20) -- 证件类型
    ,idno varchar2(120) -- 证件号码
    ,idname varchar2(400) -- 证件名称
    ,is_porxy varchar2(4) -- 是否代理(0-否,1-是)
    ,agentidtype varchar2(8) -- 代办人证件类型
    ,agentidno varchar2(120) -- 代办人证件号码
    ,agentidname varchar2(200) -- 代办人证件名称
    ,agentphone varchar2(30) -- 代办人联系方式
    ,remark varchar2(2000) -- 备注|预审结论
    ,createdate varchar2(16) -- 创建日期
    ,createtime varchar2(12) -- 创建时间
    ,createby varchar2(16) -- 柜员编号
    ,updatedate varchar2(16) -- 更新日期
    ,updatetime varchar2(12) -- 更新时间
    ,updateby varchar2(16) -- 柜员编号
    ,reftradeserno varchar2(120) -- 流程银行受理流水号
    ,applydate varchar2(16) -- 申请日期
    ,applybrno varchar2(24) -- 机构编号
    ,phone varchar2(60) -- 手机号码
    ,reserv_id varchar2(80) -- 预约id
    ,apply_remark varchar2(20) -- 提现用途及理由
    ,other_remark varchar2(1000) -- 其他用途
    ,vouchers varchar2(200) -- 券别
    ,vouchers_amt varchar2(1000) -- 券别金额
    ,lpidnum varchar2(120) -- 法人证件号码
    ,lpidtype varchar2(8) -- 法人证件类型
    ,lpname varchar2(200) -- 法人姓名
    ,certvaliddt varchar2(30) -- 证件有效期
    ,esdate varchar2(30) -- 成立日
    ,lpcertduedt varchar2(60) -- 法定代表人证件有效期
    ,operscope varchar2(2000) -- 经营范围
    ,prooffileid varchar2(60) -- 证明文件编号
    ,regcap varchar2(100) -- 注册资金
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
grant select on ${iol_schema}.nibs_ibs_acp_acceptmain_log to ${iml_schema};
grant select on ${iol_schema}.nibs_ibs_acp_acceptmain_log to ${icl_schema};
grant select on ${iol_schema}.nibs_ibs_acp_acceptmain_log to ${idl_schema};
grant select on ${iol_schema}.nibs_ibs_acp_acceptmain_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ibs_acp_acceptmain_log is '预受理流水表';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.tradeserno is '预受理编号';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.oldtradeserno is '原预受理编号';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.cardstatus is '';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.approve_no is '订单号(视频审核直接发通知请求时使用)';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.diff_pla_vide_res is '开户许可证核准号/基本存款账户编号';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.acct_leg_res is '基本户法人意愿核实结果（1-审核通过，0-审核不通过）';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.apply_type is '交易类型（2对公单位，1个人）';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.apply_amt is '提现金额';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.apply_ccy is '币种';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.biztype is '业务类型 001-个人开卡预受理  002-大额取现预受理  003-定期存款/无卡折活期存款预受理  004-个人综合签约预受理  005-个人销户预受理  006-资信证明预受理  007-资信证明撤销预受理  008-保号换卡预受理  009-首次风评预受理  010-单位账户开立预受理  011-单位综合签约预受理  012-对公资信业务预受理  013-对公资信证明撤销预受理  014-单位账户信息变更预受理  015-单位账户撤销预受理  021-企业转账业务预受理 022-对公开户异地视频审核直接开户 023-对公开户预填单';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.status is '预受理状态 0-填单中  1-已预约/已填单  2-预审通过  3-预审不通过  4-已作废  5-业务受理中  6-终审审核中  7-终审通过/已完成  8-终审不通过  9-已终止  10-已退回  11-已超时';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.busiserno is '交易流水';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.channelcode is '发起渠道';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.acctno is '账户编号';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.acctname is '户名';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.custno is '客户编号';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.custname is '客户名称';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.idtype is '证件类型';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.idno is '证件号码';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.idname is '证件名称';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.is_porxy is '是否代理(0-否,1-是)';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.agentidtype is '代办人证件类型';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.agentidno is '代办人证件号码';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.agentidname is '代办人证件名称';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.agentphone is '代办人联系方式';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.remark is '备注|预审结论';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.createdate is '创建日期';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.createtime is '创建时间';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.createby is '柜员编号';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.updatedate is '更新日期';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.updatetime is '更新时间';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.updateby is '柜员编号';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.reftradeserno is '流程银行受理流水号';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.applydate is '申请日期';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.applybrno is '机构编号';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.phone is '手机号码';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.reserv_id is '预约id';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.apply_remark is '提现用途及理由';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.other_remark is '其他用途';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.vouchers is '券别';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.vouchers_amt is '券别金额';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.lpidnum is '法人证件号码';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.lpidtype is '法人证件类型';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.lpname is '法人姓名';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.certvaliddt is '证件有效期';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.esdate is '成立日';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.lpcertduedt is '法定代表人证件有效期';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.operscope is '经营范围';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.prooffileid is '证明文件编号';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.regcap is '注册资金';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_ibs_acp_acceptmain_log.etl_timestamp is 'ETL处理时间戳';
