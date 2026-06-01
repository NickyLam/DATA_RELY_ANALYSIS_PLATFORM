/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_business_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_business_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_business_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_business_apply(
    serialno varchar2(32) -- 流水号
    ,usage varchar2(32) -- 借款用途
    ,creditchannel varchar2(32) -- 授信渠道
    ,applyno varchar2(64) -- 全局流水号（第三方）
    ,businessmodel varchar2(64) -- 业务模式（第三方）
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,currency varchar2(3) -- 币种
    ,businesssum number(24,6) -- 授信申请金额
    ,productid varchar2(32) -- 产品编号（行内）
    ,productno varchar2(32) -- 产品编号（第三方）
    ,termmonth number(38,0) -- 期限(月)
    ,termday number(38,0) -- 期限(天)
    ,iscycle varchar2(5) -- 循环标志
    ,vouchtype varchar2(1) -- 担保方式
    ,nationalindustrytype varchar2(32) -- 贷款投向行业
    ,loanusetype varchar2(32) -- 贷款用途
    ,approvestatus varchar2(32) -- 审批状态
    ,bankcontriratio number(24,6) -- 银行出资比例
    ,refusecode varchar2(64) -- 拒绝错误码
    ,refusereason varchar2(2000) -- 拒绝原因描述
    ,acceptrisktime date -- 接收风控返回时间（终审结束时间）
    ,manualapproval varchar2(5) -- 转人工标识
    ,partnerapvrestflg varchar2(32) -- 合作方审批结果
    ,apvstarttm date -- 审批开始时间
    ,apvamt number(24,6) -- 我行授信金额
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新时间
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
grant select on ${iol_schema}.icms_lhwd_business_apply to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_business_apply to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_business_apply to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_business_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_business_apply is '联合网贷授信申请表';
comment on column ${iol_schema}.icms_lhwd_business_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_lhwd_business_apply.usage is '借款用途';
comment on column ${iol_schema}.icms_lhwd_business_apply.creditchannel is '授信渠道';
comment on column ${iol_schema}.icms_lhwd_business_apply.applyno is '全局流水号（第三方）';
comment on column ${iol_schema}.icms_lhwd_business_apply.businessmodel is '业务模式（第三方）';
comment on column ${iol_schema}.icms_lhwd_business_apply.customerid is '客户编号';
comment on column ${iol_schema}.icms_lhwd_business_apply.customername is '客户名称';
comment on column ${iol_schema}.icms_lhwd_business_apply.currency is '币种';
comment on column ${iol_schema}.icms_lhwd_business_apply.businesssum is '授信申请金额';
comment on column ${iol_schema}.icms_lhwd_business_apply.productid is '产品编号（行内）';
comment on column ${iol_schema}.icms_lhwd_business_apply.productno is '产品编号（第三方）';
comment on column ${iol_schema}.icms_lhwd_business_apply.termmonth is '期限(月)';
comment on column ${iol_schema}.icms_lhwd_business_apply.termday is '期限(天)';
comment on column ${iol_schema}.icms_lhwd_business_apply.iscycle is '循环标志';
comment on column ${iol_schema}.icms_lhwd_business_apply.vouchtype is '担保方式';
comment on column ${iol_schema}.icms_lhwd_business_apply.nationalindustrytype is '贷款投向行业';
comment on column ${iol_schema}.icms_lhwd_business_apply.loanusetype is '贷款用途';
comment on column ${iol_schema}.icms_lhwd_business_apply.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_lhwd_business_apply.bankcontriratio is '银行出资比例';
comment on column ${iol_schema}.icms_lhwd_business_apply.refusecode is '拒绝错误码';
comment on column ${iol_schema}.icms_lhwd_business_apply.refusereason is '拒绝原因描述';
comment on column ${iol_schema}.icms_lhwd_business_apply.acceptrisktime is '接收风控返回时间（终审结束时间）';
comment on column ${iol_schema}.icms_lhwd_business_apply.manualapproval is '转人工标识';
comment on column ${iol_schema}.icms_lhwd_business_apply.partnerapvrestflg is '合作方审批结果';
comment on column ${iol_schema}.icms_lhwd_business_apply.apvstarttm is '审批开始时间';
comment on column ${iol_schema}.icms_lhwd_business_apply.apvamt is '我行授信金额';
comment on column ${iol_schema}.icms_lhwd_business_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lhwd_business_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lhwd_business_apply.inputdate is '登记时间';
comment on column ${iol_schema}.icms_lhwd_business_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhwd_business_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhwd_business_apply.updatedate is '更新时间';
comment on column ${iol_schema}.icms_lhwd_business_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lhwd_business_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lhwd_business_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lhwd_business_apply.etl_timestamp is 'ETL处理时间戳';
