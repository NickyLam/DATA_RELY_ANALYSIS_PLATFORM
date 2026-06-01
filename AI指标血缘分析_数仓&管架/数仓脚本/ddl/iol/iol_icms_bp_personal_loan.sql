/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bp_personal_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bp_personal_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bp_personal_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bp_personal_loan(
    serialno varchar2(64) -- 出账流水号
    ,isnogroup varchar2(16) -- 是否集团客户
    ,groupcustname varchar2(200) -- 集团客户名称
    ,relationship varchar2(16) -- 借款人与集团关系
    ,payee_bank_name varchar2(80) -- 收款人行名
    ,loanfinishdate date -- 贷款终止日
    ,putouttime date -- 放款时间
    ,payorderid varchar2(32) -- 支付订单号
    ,isrecordtax varchar2(16) -- 是否录入印花税
    ,payaccounttel varchar2(20) -- 开户绑定手机号
    ,loanbegindate date -- 贷款发放日
    ,payacctno varchar2(32) -- 受托支付账号编号
    ,channelcode varchar2(10) -- 放款渠道码
    ,remark varchar2(4000) -- 备注
    ,loanstage number(4,0) -- 贷款期数
    ,loantruedate date -- 贷款实际发放日
    ,guacontno varchar2(100) -- 担保保证函编号
    ,taxaccount varchar2(32) -- 印花税扣税账号
    ,repaydatetype varchar2(10) -- 还款日确定
    ,imageno varchar2(50) -- 影像编号
    ,approveenddate date -- 放款结束时间
    ,taxaccountname varchar2(200) -- 印花税扣税账号名称
    ,putoutconditionremark varchar2(1000) -- 出账落实条件说明
    ,groupcustcode varchar2(64) -- 集团客户号
    ,informflag varchar2(10) -- 放款通知是否成功
    ,approvestartdate date -- 审批开始时间
    ,availexposure number(22,4) -- 集团客户可用敞口额度
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,applysum number(22,2) -- 申请放款金额
    ,taxamount number(16,2) -- 印花税金额
    ,imageupflag varchar2(10) -- 影像上传结果1完成上传2未完成上传
    ,paymentmethodtype varchar2(20) -- 支付工具类型
    ,confirmstate varchar2(10) -- 受托支付确认状态
    ,confirmtime varchar2(40) -- 受托支付确认时间
    ,checkresult varchar2(20) -- 风控规则结果
    ,payaccounttype varchar2(2) -- 卡类型0:本行卡1:他行卡
    ,repaymentmethodtype varchar2(20) -- 还款支付工具类型
    ,cashsum number(22,2) -- 自主支付金额
    ,exchangeresultremark varchar2(1000) -- 交易结果描述
    ,balldate date -- 气球贷摊销日期
    ,relaserialno varchar2(64) -- 关联流水号
    ,isbelongterm varchar2(2) -- 是否靠档计息
    ,productchannel varchar2(20) -- 产品渠道标识
    ,moneylevelresult varchar2(1) -- 命中反洗钱评级情况（0-未命中,1-命中,2-仅命中）
    ,isicmsfactory varchar2(2) -- 信贷工厂模式（01-是,02-否,03-无）
    ,recoverflag varchar2(10) -- 实时追缴标志字段：N否，Y是
    ,repayacctwthrobankcard varchar2(10) -- 还款账户是否他行卡：N否，Y是
    ,postacctwthrobankcard varchar2(10) -- 入账账户是否他行卡：N否，Y是
    ,hangseqno varchar2(50) -- 挂账序列号
    ,settleprodtype varchar2(64) -- 入账账户产品类型
    ,loanprodtype varchar2(64) -- 还款账户产品类型
    ,nextcycledate varchar2(8) -- 下一结息日
    ,finalmerger varchar2(8) -- 末期合并
    ,prerepaydeal varchar2(8) -- 还款计划变更方式
    ,invstflg varchar2(2) -- 尽调标志（N否，Y是，是否尽调为否的时候则为互联网业务）
    ,offlchkidenflg varchar2(2) -- 线下核身标志（N否，Y是）
    ,iscentralizedaccount varchar2(2) -- 是否集中出账（好企贷IPC产品）
    ,priceorderno varchar2(128) -- 定价单号
    ,priceapprovestatus varchar2(10) -- 定价单审批状态
    ,priceenddate varchar2(10) -- 定价单生效截止日
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
grant select on ${iol_schema}.icms_bp_personal_loan to ${iml_schema};
grant select on ${iol_schema}.icms_bp_personal_loan to ${icl_schema};
grant select on ${iol_schema}.icms_bp_personal_loan to ${idl_schema};
grant select on ${iol_schema}.icms_bp_personal_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bp_personal_loan is '出账附属表';
comment on column ${iol_schema}.icms_bp_personal_loan.serialno is '出账流水号';
comment on column ${iol_schema}.icms_bp_personal_loan.isnogroup is '是否集团客户';
comment on column ${iol_schema}.icms_bp_personal_loan.groupcustname is '集团客户名称';
comment on column ${iol_schema}.icms_bp_personal_loan.relationship is '借款人与集团关系';
comment on column ${iol_schema}.icms_bp_personal_loan.payee_bank_name is '收款人行名';
comment on column ${iol_schema}.icms_bp_personal_loan.loanfinishdate is '贷款终止日';
comment on column ${iol_schema}.icms_bp_personal_loan.putouttime is '放款时间';
comment on column ${iol_schema}.icms_bp_personal_loan.payorderid is '支付订单号';
comment on column ${iol_schema}.icms_bp_personal_loan.isrecordtax is '是否录入印花税';
comment on column ${iol_schema}.icms_bp_personal_loan.payaccounttel is '开户绑定手机号';
comment on column ${iol_schema}.icms_bp_personal_loan.loanbegindate is '贷款发放日';
comment on column ${iol_schema}.icms_bp_personal_loan.payacctno is '受托支付账号编号';
comment on column ${iol_schema}.icms_bp_personal_loan.channelcode is '放款渠道码';
comment on column ${iol_schema}.icms_bp_personal_loan.remark is '备注';
comment on column ${iol_schema}.icms_bp_personal_loan.loanstage is '贷款期数';
comment on column ${iol_schema}.icms_bp_personal_loan.loantruedate is '贷款实际发放日';
comment on column ${iol_schema}.icms_bp_personal_loan.guacontno is '担保保证函编号';
comment on column ${iol_schema}.icms_bp_personal_loan.taxaccount is '印花税扣税账号';
comment on column ${iol_schema}.icms_bp_personal_loan.repaydatetype is '还款日确定';
comment on column ${iol_schema}.icms_bp_personal_loan.imageno is '影像编号';
comment on column ${iol_schema}.icms_bp_personal_loan.approveenddate is '放款结束时间';
comment on column ${iol_schema}.icms_bp_personal_loan.taxaccountname is '印花税扣税账号名称';
comment on column ${iol_schema}.icms_bp_personal_loan.putoutconditionremark is '出账落实条件说明';
comment on column ${iol_schema}.icms_bp_personal_loan.groupcustcode is '集团客户号';
comment on column ${iol_schema}.icms_bp_personal_loan.informflag is '放款通知是否成功';
comment on column ${iol_schema}.icms_bp_personal_loan.approvestartdate is '审批开始时间';
comment on column ${iol_schema}.icms_bp_personal_loan.availexposure is '集团客户可用敞口额度';
comment on column ${iol_schema}.icms_bp_personal_loan.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_bp_personal_loan.applysum is '申请放款金额';
comment on column ${iol_schema}.icms_bp_personal_loan.taxamount is '印花税金额';
comment on column ${iol_schema}.icms_bp_personal_loan.imageupflag is '影像上传结果1完成上传2未完成上传';
comment on column ${iol_schema}.icms_bp_personal_loan.paymentmethodtype is '支付工具类型';
comment on column ${iol_schema}.icms_bp_personal_loan.confirmstate is '受托支付确认状态';
comment on column ${iol_schema}.icms_bp_personal_loan.confirmtime is '受托支付确认时间';
comment on column ${iol_schema}.icms_bp_personal_loan.checkresult is '风控规则结果';
comment on column ${iol_schema}.icms_bp_personal_loan.payaccounttype is '卡类型0:本行卡1:他行卡';
comment on column ${iol_schema}.icms_bp_personal_loan.repaymentmethodtype is '还款支付工具类型';
comment on column ${iol_schema}.icms_bp_personal_loan.cashsum is '自主支付金额';
comment on column ${iol_schema}.icms_bp_personal_loan.exchangeresultremark is '交易结果描述';
comment on column ${iol_schema}.icms_bp_personal_loan.balldate is '气球贷摊销日期';
comment on column ${iol_schema}.icms_bp_personal_loan.relaserialno is '关联流水号';
comment on column ${iol_schema}.icms_bp_personal_loan.isbelongterm is '是否靠档计息';
comment on column ${iol_schema}.icms_bp_personal_loan.productchannel is '产品渠道标识';
comment on column ${iol_schema}.icms_bp_personal_loan.moneylevelresult is '命中反洗钱评级情况（0-未命中,1-命中,2-仅命中）';
comment on column ${iol_schema}.icms_bp_personal_loan.isicmsfactory is '信贷工厂模式（01-是,02-否,03-无）';
comment on column ${iol_schema}.icms_bp_personal_loan.recoverflag is '实时追缴标志字段：N否，Y是';
comment on column ${iol_schema}.icms_bp_personal_loan.repayacctwthrobankcard is '还款账户是否他行卡：N否，Y是';
comment on column ${iol_schema}.icms_bp_personal_loan.postacctwthrobankcard is '入账账户是否他行卡：N否，Y是';
comment on column ${iol_schema}.icms_bp_personal_loan.hangseqno is '挂账序列号';
comment on column ${iol_schema}.icms_bp_personal_loan.settleprodtype is '入账账户产品类型';
comment on column ${iol_schema}.icms_bp_personal_loan.loanprodtype is '还款账户产品类型';
comment on column ${iol_schema}.icms_bp_personal_loan.nextcycledate is '下一结息日';
comment on column ${iol_schema}.icms_bp_personal_loan.finalmerger is '末期合并';
comment on column ${iol_schema}.icms_bp_personal_loan.prerepaydeal is '还款计划变更方式';
comment on column ${iol_schema}.icms_bp_personal_loan.invstflg is '尽调标志（N否，Y是，是否尽调为否的时候则为互联网业务）';
comment on column ${iol_schema}.icms_bp_personal_loan.offlchkidenflg is '线下核身标志（N否，Y是）';
comment on column ${iol_schema}.icms_bp_personal_loan.iscentralizedaccount is '是否集中出账（好企贷IPC产品）';
comment on column ${iol_schema}.icms_bp_personal_loan.priceorderno is '定价单号';
comment on column ${iol_schema}.icms_bp_personal_loan.priceapprovestatus is '定价单审批状态';
comment on column ${iol_schema}.icms_bp_personal_loan.priceenddate is '定价单生效截止日';
comment on column ${iol_schema}.icms_bp_personal_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bp_personal_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bp_personal_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bp_personal_loan.etl_timestamp is 'ETL处理时间戳';
