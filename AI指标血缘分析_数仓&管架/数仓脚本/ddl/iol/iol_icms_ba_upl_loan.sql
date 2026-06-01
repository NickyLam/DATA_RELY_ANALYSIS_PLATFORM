/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ba_upl_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ba_upl_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ba_upl_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ba_upl_loan(
    serialno varchar2(32) -- 授信流水号
    ,trustaccname varchar2(80) -- 提前还款申请人
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,abstract varchar2(200) -- 备注摘要
    ,price1 number(24,6) -- 均价
    ,guarinten varchar2(18) -- 担保意向
    ,amount2 number(24,6) -- 面积
    ,keyinfoflag varchar2(18) -- 关键信息检验标志
    ,feepayment varchar2(18) -- 手续费支付方式
    ,paybankno varchar2(32) -- 收款人行号
    ,purpose varchar2(500) -- 用途
    ,payaccountname2 varchar2(80) -- 第二还款账户名
    ,payaccountno2 varchar2(40) -- 第二还款账户
    ,houseadd1 varchar2(200) -- 房产证地址详细地址
    ,warrantorid varchar2(32) -- 主要担保人代码
    ,isguaranty1 varchar2(1) -- 是否抵押
    ,loanintsettlemethod varchar2(200) -- 贷款结息方式
    ,incomeorgid varchar2(32) -- 入账机构编号
    ,usedsum number(24,6) -- 已占用额度
    ,paybankaddcode varchar2(18) -- 收款人开户行地点
    ,warrantor varchar2(80) -- 主要担保人
    ,havecount2 number(24,6) -- 借款人产权份额
    ,paymenttype varchar2(18) -- 支付方式
    ,preapproverid varchar2(32) -- 面签人姓名编号
    ,trustpayaccountname varchar2(80) -- 受托支付户名
    ,houseareacode2 varchar2(6) -- 房产证地址区划代码
    ,housetype2 varchar2(1) -- 房屋性质(住房、商住两用房、写字楼)
    ,holdcorpus number(20,4) -- 保留本金
    ,usedbailsum number(24,6) -- 已占用保证金金额
    ,feesum number(24,6) -- 手续费金额
    ,oldlcsum number(24,6) -- 原信用证金额
    ,schemeno varchar2(20) -- 贷款方案编码
    ,qualitycontrolflag varchar2(10) -- 质量控制标志
    ,houseadd2 varchar2(200) -- 房产证地址详细地址
    ,orginalbusinessum number(24,6) -- 原贷款金额
    ,price2 number(24,6) -- 均价
    ,reservatestatus varchar2(36) -- 预约状态
    ,loankind varchar2(10) -- 期限类型
    ,paybankkindcode varchar2(18) -- 收款人开户行类别
    ,loandeductmethod varchar2(32) -- 贷款扣款方式
    ,subbusinesstype varchar2(32) -- 助贷默认业务品种
    ,changetypeflag varchar2(2) -- 是否变更业务品种
    ,amount1 number(24,6) -- 面积
    ,iskyd varchar2(1) -- 是否快易贷
    ,loantradesum number(24,6) -- 贷款用途交易金额
    ,approvesum number(24,6) -- 最新审批金额
    ,isguaranty2 varchar2(1) -- 是否抵押
    ,paysource varchar2(500) -- 还款说明
    ,approvelevel varchar2(10) -- 审批级别
    ,creditaggreement varchar2(32) -- 使用授信协议号
    ,trustpayaccountno varchar2(200) -- 受托支付账号
    ,iscompulsapproval varchar2(2) -- 是否强制人工审批
    ,paybankname varchar2(200) -- 收款人行名
    ,houseareacode1 varchar2(6) -- 房产证地址区划代码
    ,housetype1 varchar2(1) -- 房屋性质(住房、商住两用房、写字楼)
    ,havecount1 number(24,6) -- 借款人产权份额
    ,housenmber2 varchar2(100) -- 房产证号
    ,salechannelid varchar2(32) -- 渠道单位编码
    ,barcodeno varchar2(32) -- 资料扫描编码
    ,ifdkqy varchar2(1) -- 是否发起代扣管理费签约
    ,corpguarserialno varchar2(32) -- 担保公司流水号
    ,batchpaymentflag varchar2(1) -- 是否参与批扣
    ,persons1 varchar2(1) -- 共有产权人数
    ,persons2 varchar2(1) -- 共有产权人数
    ,housenmber1 varchar2(100) -- 房产证号
    ,feeratio number(10,6) -- 个贷手续费率(%)
    ,promisesfeeratio number(10,6) -- 承诺费率
    ,mfeesum number(24,6) -- 管理费金额
    ,signedplace varchar2(30) -- 签约地点
    ,guarusedsum number(24,6) -- 担保公司已占用额度
    ,saleteamid varchar2(32) -- 营销单位编码
    ,introducerid varchar2(32) -- 介绍人编号
    ,saleteamname varchar2(500) -- 营销单位名称
    ,salechannelname varchar2(500) -- 营销渠道名称
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
grant select on ${iol_schema}.icms_ba_upl_loan to ${iml_schema};
grant select on ${iol_schema}.icms_ba_upl_loan to ${icl_schema};
grant select on ${iol_schema}.icms_ba_upl_loan to ${idl_schema};
grant select on ${iol_schema}.icms_ba_upl_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ba_upl_loan is '微贷授信申请附表';
comment on column ${iol_schema}.icms_ba_upl_loan.serialno is '授信流水号';
comment on column ${iol_schema}.icms_ba_upl_loan.trustaccname is '提前还款申请人';
comment on column ${iol_schema}.icms_ba_upl_loan.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_ba_upl_loan.abstract is '备注摘要';
comment on column ${iol_schema}.icms_ba_upl_loan.price1 is '均价';
comment on column ${iol_schema}.icms_ba_upl_loan.guarinten is '担保意向';
comment on column ${iol_schema}.icms_ba_upl_loan.amount2 is '面积';
comment on column ${iol_schema}.icms_ba_upl_loan.keyinfoflag is '关键信息检验标志';
comment on column ${iol_schema}.icms_ba_upl_loan.feepayment is '手续费支付方式';
comment on column ${iol_schema}.icms_ba_upl_loan.paybankno is '收款人行号';
comment on column ${iol_schema}.icms_ba_upl_loan.purpose is '用途';
comment on column ${iol_schema}.icms_ba_upl_loan.payaccountname2 is '第二还款账户名';
comment on column ${iol_schema}.icms_ba_upl_loan.payaccountno2 is '第二还款账户';
comment on column ${iol_schema}.icms_ba_upl_loan.houseadd1 is '房产证地址详细地址';
comment on column ${iol_schema}.icms_ba_upl_loan.warrantorid is '主要担保人代码';
comment on column ${iol_schema}.icms_ba_upl_loan.isguaranty1 is '是否抵押';
comment on column ${iol_schema}.icms_ba_upl_loan.loanintsettlemethod is '贷款结息方式';
comment on column ${iol_schema}.icms_ba_upl_loan.incomeorgid is '入账机构编号';
comment on column ${iol_schema}.icms_ba_upl_loan.usedsum is '已占用额度';
comment on column ${iol_schema}.icms_ba_upl_loan.paybankaddcode is '收款人开户行地点';
comment on column ${iol_schema}.icms_ba_upl_loan.warrantor is '主要担保人';
comment on column ${iol_schema}.icms_ba_upl_loan.havecount2 is '借款人产权份额';
comment on column ${iol_schema}.icms_ba_upl_loan.paymenttype is '支付方式';
comment on column ${iol_schema}.icms_ba_upl_loan.preapproverid is '面签人姓名编号';
comment on column ${iol_schema}.icms_ba_upl_loan.trustpayaccountname is '受托支付户名';
comment on column ${iol_schema}.icms_ba_upl_loan.houseareacode2 is '房产证地址区划代码';
comment on column ${iol_schema}.icms_ba_upl_loan.housetype2 is '房屋性质(住房、商住两用房、写字楼)';
comment on column ${iol_schema}.icms_ba_upl_loan.holdcorpus is '保留本金';
comment on column ${iol_schema}.icms_ba_upl_loan.usedbailsum is '已占用保证金金额';
comment on column ${iol_schema}.icms_ba_upl_loan.feesum is '手续费金额';
comment on column ${iol_schema}.icms_ba_upl_loan.oldlcsum is '原信用证金额';
comment on column ${iol_schema}.icms_ba_upl_loan.schemeno is '贷款方案编码';
comment on column ${iol_schema}.icms_ba_upl_loan.qualitycontrolflag is '质量控制标志';
comment on column ${iol_schema}.icms_ba_upl_loan.houseadd2 is '房产证地址详细地址';
comment on column ${iol_schema}.icms_ba_upl_loan.orginalbusinessum is '原贷款金额';
comment on column ${iol_schema}.icms_ba_upl_loan.price2 is '均价';
comment on column ${iol_schema}.icms_ba_upl_loan.reservatestatus is '预约状态';
comment on column ${iol_schema}.icms_ba_upl_loan.loankind is '期限类型';
comment on column ${iol_schema}.icms_ba_upl_loan.paybankkindcode is '收款人开户行类别';
comment on column ${iol_schema}.icms_ba_upl_loan.loandeductmethod is '贷款扣款方式';
comment on column ${iol_schema}.icms_ba_upl_loan.subbusinesstype is '助贷默认业务品种';
comment on column ${iol_schema}.icms_ba_upl_loan.changetypeflag is '是否变更业务品种';
comment on column ${iol_schema}.icms_ba_upl_loan.amount1 is '面积';
comment on column ${iol_schema}.icms_ba_upl_loan.iskyd is '是否快易贷';
comment on column ${iol_schema}.icms_ba_upl_loan.loantradesum is '贷款用途交易金额';
comment on column ${iol_schema}.icms_ba_upl_loan.approvesum is '最新审批金额';
comment on column ${iol_schema}.icms_ba_upl_loan.isguaranty2 is '是否抵押';
comment on column ${iol_schema}.icms_ba_upl_loan.paysource is '还款说明';
comment on column ${iol_schema}.icms_ba_upl_loan.approvelevel is '审批级别';
comment on column ${iol_schema}.icms_ba_upl_loan.creditaggreement is '使用授信协议号';
comment on column ${iol_schema}.icms_ba_upl_loan.trustpayaccountno is '受托支付账号';
comment on column ${iol_schema}.icms_ba_upl_loan.iscompulsapproval is '是否强制人工审批';
comment on column ${iol_schema}.icms_ba_upl_loan.paybankname is '收款人行名';
comment on column ${iol_schema}.icms_ba_upl_loan.houseareacode1 is '房产证地址区划代码';
comment on column ${iol_schema}.icms_ba_upl_loan.housetype1 is '房屋性质(住房、商住两用房、写字楼)';
comment on column ${iol_schema}.icms_ba_upl_loan.havecount1 is '借款人产权份额';
comment on column ${iol_schema}.icms_ba_upl_loan.housenmber2 is '房产证号';
comment on column ${iol_schema}.icms_ba_upl_loan.salechannelid is '渠道单位编码';
comment on column ${iol_schema}.icms_ba_upl_loan.barcodeno is '资料扫描编码';
comment on column ${iol_schema}.icms_ba_upl_loan.ifdkqy is '是否发起代扣管理费签约';
comment on column ${iol_schema}.icms_ba_upl_loan.corpguarserialno is '担保公司流水号';
comment on column ${iol_schema}.icms_ba_upl_loan.batchpaymentflag is '是否参与批扣';
comment on column ${iol_schema}.icms_ba_upl_loan.persons1 is '共有产权人数';
comment on column ${iol_schema}.icms_ba_upl_loan.persons2 is '共有产权人数';
comment on column ${iol_schema}.icms_ba_upl_loan.housenmber1 is '房产证号';
comment on column ${iol_schema}.icms_ba_upl_loan.feeratio is '个贷手续费率(%)';
comment on column ${iol_schema}.icms_ba_upl_loan.promisesfeeratio is '承诺费率';
comment on column ${iol_schema}.icms_ba_upl_loan.mfeesum is '管理费金额';
comment on column ${iol_schema}.icms_ba_upl_loan.signedplace is '签约地点';
comment on column ${iol_schema}.icms_ba_upl_loan.guarusedsum is '担保公司已占用额度';
comment on column ${iol_schema}.icms_ba_upl_loan.saleteamid is '营销单位编码';
comment on column ${iol_schema}.icms_ba_upl_loan.introducerid is '介绍人编号';
comment on column ${iol_schema}.icms_ba_upl_loan.saleteamname is '营销单位名称';
comment on column ${iol_schema}.icms_ba_upl_loan.salechannelname is '营销渠道名称';
comment on column ${iol_schema}.icms_ba_upl_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ba_upl_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ba_upl_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ba_upl_loan.etl_timestamp is 'ETL处理时间戳';
