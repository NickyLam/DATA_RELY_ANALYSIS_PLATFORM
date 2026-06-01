/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_repayment_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_repayment_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_repayment_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_repayment_info(
    serialno varchar2(200) -- 流水号
    ,curdate varchar2(8) -- 账务日期
    ,trantime varchar2(14) -- 交易时间
    ,bdserialno varchar2(64) -- 借据编号(第三方/行内)
    ,repayterm varchar2(20) -- 还款期数
    ,totalamt number(24,6) -- 还款金额
    ,currency varchar2(3) -- 币种
    ,lxbusinesssum number(24,6) -- 实还本金
    ,lxintamt number(24,6) -- 实还利息
    ,lxqodpamt number(24,6) -- 实还罚息
    ,odiamt number(24,6) -- 实还复利
    ,prepmtfeerepay number(24,6) -- 已还提前还款手续费
    ,repayaccounttype varchar2(2) -- 还款账户类型
    ,repayaccountname varchar2(500) -- 还款账户名
    ,repayaccountbankname varchar2(500) -- 还款账户开户机构
    ,repayaccountno varchar2(64) -- 还款账户编号
    ,repaymode varchar2(1) -- 还款类型 1-正常还款 2-逾期还款 4-提前还款
    ,repayway varchar2(1) -- 还款方式 1-线上还款 2-线下还款 3-系统扣款 9-未知
    ,receipttype varchar2(1) -- 回收类型 1-正常回收 2-担保代偿
    ,settlementserialno varchar2(64) -- 清算交易编号
    ,inseqno varchar2(64) -- 内部交易流水号
    ,seqno varchar2(64) -- 交易流水号
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_lhwd_repayment_info to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_repayment_info to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_repayment_info to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_repayment_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_repayment_info is '联合网贷还款信息表';
comment on column ${iol_schema}.icms_lhwd_repayment_info.serialno is '流水号';
comment on column ${iol_schema}.icms_lhwd_repayment_info.curdate is '账务日期';
comment on column ${iol_schema}.icms_lhwd_repayment_info.trantime is '交易时间';
comment on column ${iol_schema}.icms_lhwd_repayment_info.bdserialno is '借据编号(第三方/行内)';
comment on column ${iol_schema}.icms_lhwd_repayment_info.repayterm is '还款期数';
comment on column ${iol_schema}.icms_lhwd_repayment_info.totalamt is '还款金额';
comment on column ${iol_schema}.icms_lhwd_repayment_info.currency is '币种';
comment on column ${iol_schema}.icms_lhwd_repayment_info.lxbusinesssum is '实还本金';
comment on column ${iol_schema}.icms_lhwd_repayment_info.lxintamt is '实还利息';
comment on column ${iol_schema}.icms_lhwd_repayment_info.lxqodpamt is '实还罚息';
comment on column ${iol_schema}.icms_lhwd_repayment_info.odiamt is '实还复利';
comment on column ${iol_schema}.icms_lhwd_repayment_info.prepmtfeerepay is '已还提前还款手续费';
comment on column ${iol_schema}.icms_lhwd_repayment_info.repayaccounttype is '还款账户类型';
comment on column ${iol_schema}.icms_lhwd_repayment_info.repayaccountname is '还款账户名';
comment on column ${iol_schema}.icms_lhwd_repayment_info.repayaccountbankname is '还款账户开户机构';
comment on column ${iol_schema}.icms_lhwd_repayment_info.repayaccountno is '还款账户编号';
comment on column ${iol_schema}.icms_lhwd_repayment_info.repaymode is '还款类型 1-正常还款 2-逾期还款 4-提前还款';
comment on column ${iol_schema}.icms_lhwd_repayment_info.repayway is '还款方式 1-线上还款 2-线下还款 3-系统扣款 9-未知';
comment on column ${iol_schema}.icms_lhwd_repayment_info.receipttype is '回收类型 1-正常回收 2-担保代偿';
comment on column ${iol_schema}.icms_lhwd_repayment_info.settlementserialno is '清算交易编号';
comment on column ${iol_schema}.icms_lhwd_repayment_info.inseqno is '内部交易流水号';
comment on column ${iol_schema}.icms_lhwd_repayment_info.seqno is '交易流水号';
comment on column ${iol_schema}.icms_lhwd_repayment_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhwd_repayment_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhwd_repayment_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lhwd_repayment_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_lhwd_repayment_info.etl_timestamp is 'ETL处理时间戳';
