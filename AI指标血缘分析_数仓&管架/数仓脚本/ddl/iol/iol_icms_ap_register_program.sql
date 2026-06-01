/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_register_program
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_register_program
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_register_program purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_register_program(
    serialno varchar2(64) -- 流水号
    ,programno varchar2(64) -- 方案编号
    ,programname varchar2(1000) -- 方案名称
    ,customername varchar2(100) -- 方案涉及借款人
    ,handletype varchar2(1000) -- 处置类型（不良资产转让）
    ,businesssum number(24,6) -- 合同金额合计
    ,balancesum number(24,6) -- 合同余额合计
    ,receiveamonut number(24,6) -- 财务应收款
    ,oninterestsum number(24,6) -- 表外利息余额合计
    ,outinterestsum number(24,6) -- 表外利息余额合计
    ,pecuniacreditasum number(24,6) -- 债权金额合计
    ,transferprice number(24,6) -- 转让价格
    ,payreceiveamonut number(24,6) -- 偿还财务应收款
    ,paylowamonut number(24,6) -- 偿还法律应收款
    ,paylowcost number(24,6) -- 偿还法律性费用
    ,paysum number(24,6) -- 偿还本金
    ,payinterest number(24,6) -- 偿还利息
    ,transferway varchar2(36) -- 债权转让方式一（CD060034）
    ,othertransferway varchar2(36) -- 债权转让方式二（CD060035）
    ,respinvestigationdate date -- 卖方尽职调查基准日
    ,respinvestigationorg varchar2(160) -- 卖方尽职调查中介机构名称
    ,vendeename varchar2(160) -- 买受人名称
    ,remark varchar2(1000) -- 备注
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,litigationphasecost number(24,6) -- 诉讼阶段法律性费用（元）
    ,cancelaccountcapbaldepos number(24,6) -- 账销案存资产本金余额（元）
    ,cancelaccountcapinowebalance number(24,6) -- 账销案存资产表内欠息余额（元）
    ,cancelaccountcapoutowebalance number(24,6) -- 账销案存资产表外欠息余额（元）
    ,summarize varchar2(4000) -- 方案综述
    ,riskassetlist varchar2(2000) -- 风险资产清单
    ,saveflag varchar2(2) -- 保存标志
    ,executestatus varchar2(2) -- 执行状态(CodeNo:ExecuteResult)
    ,packagedate date -- 封包日期
    ,transferflag varchar2(2) -- 转让标志(CodeNo:TransferFlag)
    ,currency varchar2(3) -- 币种
    ,transferorg varchar2(64) -- 变更后机构
    ,agentlegalfee number(24,6) -- 代垫诉讼费
    ,repaymode varchar2(4) -- 付款方式（一次性付款、分期付款）
    ,downpayment number(24,6) -- 首付金额
    ,onaccountno varchar2(32) -- 挂账编号
    ,transcontractno varchar2(128) -- 转让合同号
    ,counterpartyacctname varchar2(200) -- 交易对手名称
    ,counterpartyacct varchar2(32) -- 交易对手账号
    ,openbankname varchar2(128) -- 交易对手开户行名称
    ,openbankno varchar2(32) -- 交易对手开户行行号
    ,counterpartyaccttype varchar2(20) -- 交易对手类型
    ,transcontractstartdate date -- 转让合同起始日期
    ,transcontractenddate date -- 转让合同到期日期
    ,transtradplatform varchar2(20) -- 转让交易平台
    ,transtradplatformcus varchar2(256) -- 转让交易平台（自定义）
    ,counterpartypaydate date -- 交易对手转账日期
    ,isaddrec number(1) -- 是否补录
    ,counterpartyacctcerttype varchar2(4) -- 交易对手证件类型
    ,counterpartyacctcertid varchar2(60) -- 交易对手证件号码
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
grant select on ${iol_schema}.icms_ap_register_program to ${iml_schema};
grant select on ${iol_schema}.icms_ap_register_program to ${icl_schema};
grant select on ${iol_schema}.icms_ap_register_program to ${idl_schema};
grant select on ${iol_schema}.icms_ap_register_program to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_register_program is '单户资产登记方案表';
comment on column ${iol_schema}.icms_ap_register_program.serialno is '流水号';
comment on column ${iol_schema}.icms_ap_register_program.programno is '方案编号';
comment on column ${iol_schema}.icms_ap_register_program.programname is '方案名称';
comment on column ${iol_schema}.icms_ap_register_program.customername is '方案涉及借款人';
comment on column ${iol_schema}.icms_ap_register_program.handletype is '处置类型（不良资产转让）';
comment on column ${iol_schema}.icms_ap_register_program.businesssum is '合同金额合计';
comment on column ${iol_schema}.icms_ap_register_program.balancesum is '合同余额合计';
comment on column ${iol_schema}.icms_ap_register_program.receiveamonut is '财务应收款';
comment on column ${iol_schema}.icms_ap_register_program.oninterestsum is '表外利息余额合计';
comment on column ${iol_schema}.icms_ap_register_program.outinterestsum is '表外利息余额合计';
comment on column ${iol_schema}.icms_ap_register_program.pecuniacreditasum is '债权金额合计';
comment on column ${iol_schema}.icms_ap_register_program.transferprice is '转让价格';
comment on column ${iol_schema}.icms_ap_register_program.payreceiveamonut is '偿还财务应收款';
comment on column ${iol_schema}.icms_ap_register_program.paylowamonut is '偿还法律应收款';
comment on column ${iol_schema}.icms_ap_register_program.paylowcost is '偿还法律性费用';
comment on column ${iol_schema}.icms_ap_register_program.paysum is '偿还本金';
comment on column ${iol_schema}.icms_ap_register_program.payinterest is '偿还利息';
comment on column ${iol_schema}.icms_ap_register_program.transferway is '债权转让方式一（CD060034）';
comment on column ${iol_schema}.icms_ap_register_program.othertransferway is '债权转让方式二（CD060035）';
comment on column ${iol_schema}.icms_ap_register_program.respinvestigationdate is '卖方尽职调查基准日';
comment on column ${iol_schema}.icms_ap_register_program.respinvestigationorg is '卖方尽职调查中介机构名称';
comment on column ${iol_schema}.icms_ap_register_program.vendeename is '买受人名称';
comment on column ${iol_schema}.icms_ap_register_program.remark is '备注';
comment on column ${iol_schema}.icms_ap_register_program.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_register_program.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_register_program.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_register_program.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_register_program.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_register_program.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_register_program.litigationphasecost is '诉讼阶段法律性费用（元）';
comment on column ${iol_schema}.icms_ap_register_program.cancelaccountcapbaldepos is '账销案存资产本金余额（元）';
comment on column ${iol_schema}.icms_ap_register_program.cancelaccountcapinowebalance is '账销案存资产表内欠息余额（元）';
comment on column ${iol_schema}.icms_ap_register_program.cancelaccountcapoutowebalance is '账销案存资产表外欠息余额（元）';
comment on column ${iol_schema}.icms_ap_register_program.summarize is '方案综述';
comment on column ${iol_schema}.icms_ap_register_program.riskassetlist is '风险资产清单';
comment on column ${iol_schema}.icms_ap_register_program.saveflag is '保存标志';
comment on column ${iol_schema}.icms_ap_register_program.executestatus is '执行状态(CodeNo:ExecuteResult)';
comment on column ${iol_schema}.icms_ap_register_program.packagedate is '封包日期';
comment on column ${iol_schema}.icms_ap_register_program.transferflag is '转让标志(CodeNo:TransferFlag)';
comment on column ${iol_schema}.icms_ap_register_program.currency is '币种';
comment on column ${iol_schema}.icms_ap_register_program.transferorg is '变更后机构';
comment on column ${iol_schema}.icms_ap_register_program.agentlegalfee is '代垫诉讼费';
comment on column ${iol_schema}.icms_ap_register_program.repaymode is '付款方式（一次性付款、分期付款）';
comment on column ${iol_schema}.icms_ap_register_program.downpayment is '首付金额';
comment on column ${iol_schema}.icms_ap_register_program.onaccountno is '挂账编号';
comment on column ${iol_schema}.icms_ap_register_program.transcontractno is '转让合同号';
comment on column ${iol_schema}.icms_ap_register_program.counterpartyacctname is '交易对手名称';
comment on column ${iol_schema}.icms_ap_register_program.counterpartyacct is '交易对手账号';
comment on column ${iol_schema}.icms_ap_register_program.openbankname is '交易对手开户行名称';
comment on column ${iol_schema}.icms_ap_register_program.openbankno is '交易对手开户行行号';
comment on column ${iol_schema}.icms_ap_register_program.counterpartyaccttype is '交易对手类型';
comment on column ${iol_schema}.icms_ap_register_program.transcontractstartdate is '转让合同起始日期';
comment on column ${iol_schema}.icms_ap_register_program.transcontractenddate is '转让合同到期日期';
comment on column ${iol_schema}.icms_ap_register_program.transtradplatform is '转让交易平台';
comment on column ${iol_schema}.icms_ap_register_program.transtradplatformcus is '转让交易平台（自定义）';
comment on column ${iol_schema}.icms_ap_register_program.counterpartypaydate is '交易对手转账日期';
comment on column ${iol_schema}.icms_ap_register_program.isaddrec is '是否补录';
comment on column ${iol_schema}.icms_ap_register_program.counterpartyacctcerttype is '交易对手证件类型';
comment on column ${iol_schema}.icms_ap_register_program.counterpartyacctcertid is '交易对手证件号码';
comment on column ${iol_schema}.icms_ap_register_program.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_register_program.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_register_program.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_register_program.etl_timestamp is 'ETL处理时间戳';
