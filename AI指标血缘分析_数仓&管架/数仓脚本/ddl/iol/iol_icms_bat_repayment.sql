/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bat_repayment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bat_repayment
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bat_repayment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bat_repayment(
    serialno varchar2(64) -- 流水号
    ,duebillno varchar2(64) -- 借据号
    ,transdate date -- 交易日期
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,certtype varchar2(4) -- 证件类型
    ,certid varchar2(18) -- 证件编号
    ,currency varchar2(3) -- 币种
    ,schedulepayment number(24,6) -- 应还金额
    ,actualpayment number(24,6) -- 实际还款金额
    ,payaccountno varchar2(64) -- 扣款帐号
    ,payserialno varchar2(64) -- 还款交易流水号
    ,paymenttype varchar2(36) -- 支付方式
    ,status varchar2(36) -- 状态
    ,relaobjecttype varchar2(64) -- 关联对象类型
    ,relaobjectno varchar2(64) -- 关联对象编号
    ,batserialno varchar2(64) -- 批次流水号
    ,transserialno varchar2(64) -- 交易流水号(核算)
    ,grouptype varchar2(36) -- 分组类型;分组类型(Code:01-正常数据，02-异常数据-未匹配)
    ,remark varchar2(1000) -- 备注
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,completeflag varchar2(2) -- 完整性标示
    ,priamt number(24,6) -- 实还本金
    ,intamt number(24,6) -- 实还利息
    ,odpamt number(24,6) -- 实还罚息
    ,odiamt number(24,6) -- 实还复利
    ,remamt number(24,6) -- 剩余本金
    ,stageno number(24,6) -- 还款期数
    ,reasoncode varchar2(10) -- 代偿标志
    ,receipttype varchar2(10) -- 还款类型
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,reversal varchar2(2) -- 冲正标识
    ,receiptno varchar2(200) -- 回收单号
    ,channel varchar2(64) -- 渠道号
    ,srcinitsysid varchar2(100) -- 发起系统
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
grant select on ${iol_schema}.icms_bat_repayment to ${iml_schema};
grant select on ${iol_schema}.icms_bat_repayment to ${icl_schema};
grant select on ${iol_schema}.icms_bat_repayment to ${idl_schema};
grant select on ${iol_schema}.icms_bat_repayment to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bat_repayment is '还款信息表;还款信息表';
comment on column ${iol_schema}.icms_bat_repayment.serialno is '流水号';
comment on column ${iol_schema}.icms_bat_repayment.duebillno is '借据号';
comment on column ${iol_schema}.icms_bat_repayment.transdate is '交易日期';
comment on column ${iol_schema}.icms_bat_repayment.customerid is '客户编号';
comment on column ${iol_schema}.icms_bat_repayment.customername is '客户名称';
comment on column ${iol_schema}.icms_bat_repayment.certtype is '证件类型';
comment on column ${iol_schema}.icms_bat_repayment.certid is '证件编号';
comment on column ${iol_schema}.icms_bat_repayment.currency is '币种';
comment on column ${iol_schema}.icms_bat_repayment.schedulepayment is '应还金额';
comment on column ${iol_schema}.icms_bat_repayment.actualpayment is '实际还款金额';
comment on column ${iol_schema}.icms_bat_repayment.payaccountno is '扣款帐号';
comment on column ${iol_schema}.icms_bat_repayment.payserialno is '还款交易流水号';
comment on column ${iol_schema}.icms_bat_repayment.paymenttype is '支付方式';
comment on column ${iol_schema}.icms_bat_repayment.status is '状态';
comment on column ${iol_schema}.icms_bat_repayment.relaobjecttype is '关联对象类型';
comment on column ${iol_schema}.icms_bat_repayment.relaobjectno is '关联对象编号';
comment on column ${iol_schema}.icms_bat_repayment.batserialno is '批次流水号';
comment on column ${iol_schema}.icms_bat_repayment.transserialno is '交易流水号(核算)';
comment on column ${iol_schema}.icms_bat_repayment.grouptype is '分组类型;分组类型(Code:01-正常数据，02-异常数据-未匹配)';
comment on column ${iol_schema}.icms_bat_repayment.remark is '备注';
comment on column ${iol_schema}.icms_bat_repayment.inputuserid is '登记人';
comment on column ${iol_schema}.icms_bat_repayment.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_bat_repayment.inputdate is '登记日期';
comment on column ${iol_schema}.icms_bat_repayment.updateuserid is '更新人';
comment on column ${iol_schema}.icms_bat_repayment.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_bat_repayment.updatedate is '更新日期';
comment on column ${iol_schema}.icms_bat_repayment.completeflag is '完整性标示';
comment on column ${iol_schema}.icms_bat_repayment.priamt is '实还本金';
comment on column ${iol_schema}.icms_bat_repayment.intamt is '实还利息';
comment on column ${iol_schema}.icms_bat_repayment.odpamt is '实还罚息';
comment on column ${iol_schema}.icms_bat_repayment.odiamt is '实还复利';
comment on column ${iol_schema}.icms_bat_repayment.remamt is '剩余本金';
comment on column ${iol_schema}.icms_bat_repayment.stageno is '还款期数';
comment on column ${iol_schema}.icms_bat_repayment.reasoncode is '代偿标志';
comment on column ${iol_schema}.icms_bat_repayment.receipttype is '还款类型';
comment on column ${iol_schema}.icms_bat_repayment.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_bat_repayment.reversal is '冲正标识';
comment on column ${iol_schema}.icms_bat_repayment.receiptno is '回收单号';
comment on column ${iol_schema}.icms_bat_repayment.channel is '渠道号';
comment on column ${iol_schema}.icms_bat_repayment.srcinitsysid is '发起系统';
comment on column ${iol_schema}.icms_bat_repayment.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bat_repayment.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bat_repayment.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bat_repayment.etl_timestamp is 'ETL处理时间戳';
