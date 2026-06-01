/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_xxd_loanapply_online
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_xxd_loanapply_online
whenever sqlerror continue none;
drop table ${iol_schema}.icms_xxd_loanapply_online purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_xxd_loanapply_online(
    serialno varchar2(32) -- 流水号
    ,baserialno varchar2(32) -- 授信申请流水号
    ,lmtcontractno varchar2(32) -- 额度合同编号
    ,loancontractno varchar2(32) -- 借款合同编号
    ,prdcode varchar2(32) -- 产品编号
    ,prdname varchar2(80) -- 产品名称
    ,putouttype varchar2(10) -- 提款方式(01--线上提款,02--线下提款)
    ,certtype varchar2(4) -- 证件类型
    ,certid varchar2(60) -- 证件编号
    ,customername varchar2(200) -- 客户名称
    ,customerid varchar2(32) -- 客户号
    ,applyamt number(24,6) -- 申请金额（单位:元）
    ,loanterm varchar2(4) -- 申请期数（单位:月）
    ,loanpurpose varchar2(10) -- 申请贷款用途
    ,concretepurpose varchar2(500) -- 具体用途
    ,repaytype varchar2(10) -- 还款方式
    ,applydate date -- 申请日期
    ,startdate date -- 起始日
    ,enddate date -- 到期日
    ,executerate number(15,8) -- 执行利率
    ,rateadd varchar2(10) -- 利率加点(%)
    ,authotype varchar2(2) -- 授权方式
    ,biometrics varchar2(2) -- 生物识别技术
    ,authotime date -- 授权时间
    ,authostrdate date -- 授权开始时间
    ,authoenddate date -- 授权结束时间
    ,incomingcode varchar2(2) -- 进件模式（0：团购企业模式 1：战略客户模式）
    ,approvestatus varchar2(30) -- 审批状态
    ,channel varchar2(12) -- 渠道
    ,customermanagerno varchar2(20) -- 客户经理编号
    ,belongorgid varchar2(300) -- 所属分行
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
    ,applyno varchar2(32) -- 申请流水号（前端业务流水号）
    ,putoutstatus varchar2(4) -- 用信状态
    ,payaccount varchar2(32) -- 还款账号
    ,payaccountname varchar2(200) -- 还款账号姓名
    ,qryusertype varchar2(4) -- 征信查询人类型
    ,qryopertp varchar2(4) -- 征信查询操作申请类型
    ,partner varchar2(10) -- 客户来源
    ,reportusernm varchar2(100) -- 报告使用人姓名
    ,reportuseroff varchar2(20) -- 报告使用人所属部门
    ,istimeoutrefuse varchar2(4) -- 是否超时拒绝
    ,reason varchar2(500) -- 原因
    ,ismqrisk varchar2(4) -- 是否风控中（0--未发送,1--风控中，2--风控完成）
    ,mqrisksendtime date -- 发送风控时间
    ,iscollectcredit varchar2(20) -- 征信查询情况
    ,finalapplyamount number(24,6) -- 终审审批额度(元)
    ,apprendtime varchar2(20) -- 审批结束时间
    ,manualapproval varchar2(4) -- 是否人工审批标识
    ,failreason varchar2(4000) -- 拒绝原因
    ,warninginfo varchar2(800) -- 预警信息
    ,isbankrel varchar2(2) -- 是否我行关联人
    ,autoscore varchar2(10) -- 评分分值
    ,roomprice number(24,2) -- 评估价值
    ,approvedamt number(24,6) -- 风控审批可用金额
    ,artificialno varchar2(300) -- 文本合同编号
    ,paymenttype varchar2(10) -- 支付方式 (1-受托支付，2-自主支付)
    ,entryaccount varchar2(32) -- 入账账号
    ,entryaccountname varchar2(200) -- 入账账号姓名
    ,riskstatus varchar2(32) -- 风控状态
    ,imagebatchno varchar2(64) -- 影像批次号
    ,orderno varchar2(32) -- 订单号
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
grant select on ${iol_schema}.icms_xxd_loanapply_online to ${iml_schema};
grant select on ${iol_schema}.icms_xxd_loanapply_online to ${icl_schema};
grant select on ${iol_schema}.icms_xxd_loanapply_online to ${idl_schema};
grant select on ${iol_schema}.icms_xxd_loanapply_online to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_xxd_loanapply_online is '线上客户用信申请表';
comment on column ${iol_schema}.icms_xxd_loanapply_online.serialno is '流水号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.baserialno is '授信申请流水号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.lmtcontractno is '额度合同编号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.loancontractno is '借款合同编号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.prdcode is '产品编号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.prdname is '产品名称';
comment on column ${iol_schema}.icms_xxd_loanapply_online.putouttype is '提款方式(01--线上提款,02--线下提款)';
comment on column ${iol_schema}.icms_xxd_loanapply_online.certtype is '证件类型';
comment on column ${iol_schema}.icms_xxd_loanapply_online.certid is '证件编号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.customername is '客户名称';
comment on column ${iol_schema}.icms_xxd_loanapply_online.customerid is '客户号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.applyamt is '申请金额（单位:元）';
comment on column ${iol_schema}.icms_xxd_loanapply_online.loanterm is '申请期数（单位:月）';
comment on column ${iol_schema}.icms_xxd_loanapply_online.loanpurpose is '申请贷款用途';
comment on column ${iol_schema}.icms_xxd_loanapply_online.concretepurpose is '具体用途';
comment on column ${iol_schema}.icms_xxd_loanapply_online.repaytype is '还款方式';
comment on column ${iol_schema}.icms_xxd_loanapply_online.applydate is '申请日期';
comment on column ${iol_schema}.icms_xxd_loanapply_online.startdate is '起始日';
comment on column ${iol_schema}.icms_xxd_loanapply_online.enddate is '到期日';
comment on column ${iol_schema}.icms_xxd_loanapply_online.executerate is '执行利率';
comment on column ${iol_schema}.icms_xxd_loanapply_online.rateadd is '利率加点(%)';
comment on column ${iol_schema}.icms_xxd_loanapply_online.authotype is '授权方式';
comment on column ${iol_schema}.icms_xxd_loanapply_online.biometrics is '生物识别技术';
comment on column ${iol_schema}.icms_xxd_loanapply_online.authotime is '授权时间';
comment on column ${iol_schema}.icms_xxd_loanapply_online.authostrdate is '授权开始时间';
comment on column ${iol_schema}.icms_xxd_loanapply_online.authoenddate is '授权结束时间';
comment on column ${iol_schema}.icms_xxd_loanapply_online.incomingcode is '进件模式（0：团购企业模式 1：战略客户模式）';
comment on column ${iol_schema}.icms_xxd_loanapply_online.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_xxd_loanapply_online.channel is '渠道';
comment on column ${iol_schema}.icms_xxd_loanapply_online.customermanagerno is '客户经理编号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.belongorgid is '所属分行';
comment on column ${iol_schema}.icms_xxd_loanapply_online.inputuserid is '登记人';
comment on column ${iol_schema}.icms_xxd_loanapply_online.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_xxd_loanapply_online.inputdate is '登记日期';
comment on column ${iol_schema}.icms_xxd_loanapply_online.updateuserid is '更新人';
comment on column ${iol_schema}.icms_xxd_loanapply_online.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_xxd_loanapply_online.updatedate is '更新日期';
comment on column ${iol_schema}.icms_xxd_loanapply_online.applyno is '申请流水号（前端业务流水号）';
comment on column ${iol_schema}.icms_xxd_loanapply_online.putoutstatus is '用信状态';
comment on column ${iol_schema}.icms_xxd_loanapply_online.payaccount is '还款账号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.payaccountname is '还款账号姓名';
comment on column ${iol_schema}.icms_xxd_loanapply_online.qryusertype is '征信查询人类型';
comment on column ${iol_schema}.icms_xxd_loanapply_online.qryopertp is '征信查询操作申请类型';
comment on column ${iol_schema}.icms_xxd_loanapply_online.partner is '客户来源';
comment on column ${iol_schema}.icms_xxd_loanapply_online.reportusernm is '报告使用人姓名';
comment on column ${iol_schema}.icms_xxd_loanapply_online.reportuseroff is '报告使用人所属部门';
comment on column ${iol_schema}.icms_xxd_loanapply_online.istimeoutrefuse is '是否超时拒绝';
comment on column ${iol_schema}.icms_xxd_loanapply_online.reason is '原因';
comment on column ${iol_schema}.icms_xxd_loanapply_online.ismqrisk is '是否风控中（0--未发送,1--风控中，2--风控完成）';
comment on column ${iol_schema}.icms_xxd_loanapply_online.mqrisksendtime is '发送风控时间';
comment on column ${iol_schema}.icms_xxd_loanapply_online.iscollectcredit is '征信查询情况';
comment on column ${iol_schema}.icms_xxd_loanapply_online.finalapplyamount is '终审审批额度(元)';
comment on column ${iol_schema}.icms_xxd_loanapply_online.apprendtime is '审批结束时间';
comment on column ${iol_schema}.icms_xxd_loanapply_online.manualapproval is '是否人工审批标识';
comment on column ${iol_schema}.icms_xxd_loanapply_online.failreason is '拒绝原因';
comment on column ${iol_schema}.icms_xxd_loanapply_online.warninginfo is '预警信息';
comment on column ${iol_schema}.icms_xxd_loanapply_online.isbankrel is '是否我行关联人';
comment on column ${iol_schema}.icms_xxd_loanapply_online.autoscore is '评分分值';
comment on column ${iol_schema}.icms_xxd_loanapply_online.roomprice is '评估价值';
comment on column ${iol_schema}.icms_xxd_loanapply_online.approvedamt is '风控审批可用金额';
comment on column ${iol_schema}.icms_xxd_loanapply_online.artificialno is '文本合同编号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.paymenttype is '支付方式 (1-受托支付，2-自主支付)';
comment on column ${iol_schema}.icms_xxd_loanapply_online.entryaccount is '入账账号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.entryaccountname is '入账账号姓名';
comment on column ${iol_schema}.icms_xxd_loanapply_online.riskstatus is '风控状态';
comment on column ${iol_schema}.icms_xxd_loanapply_online.imagebatchno is '影像批次号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.orderno is '订单号';
comment on column ${iol_schema}.icms_xxd_loanapply_online.start_dt is '开始时间';
comment on column ${iol_schema}.icms_xxd_loanapply_online.end_dt is '结束时间';
comment on column ${iol_schema}.icms_xxd_loanapply_online.id_mark is '增删标志';
comment on column ${iol_schema}.icms_xxd_loanapply_online.etl_timestamp is 'ETL处理时间戳';
