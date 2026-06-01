/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybkzd_credit_change_app
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybkzd_credit_change_app
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybkzd_credit_change_app purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_credit_change_app(
    serialno varchar2(64) -- 授信申请编号
    ,cusid varchar2(32) -- 客户号
    ,cusname varchar2(200) -- 客户名称
    ,certtype varchar2(6) -- 证件类型
    ,certcode varchar2(60) -- 证件号码
    ,csapplydate varchar2(20) -- 初审日期
    ,zsapplydate varchar2(20) -- 终审日期
    ,applyamount number(16,2) -- 原审批额度
    ,applydate varchar2(20) -- 申请日期
    ,informdate varchar2(20) -- 申请通知时间
    ,returndate varchar2(20) -- 回调通知时间
    ,requestid varchar2(256) -- 请求幂等ID
    ,applyno varchar2(64) -- 联合审批单号
    ,custiproleid varchar2(64) -- 会员角色ID
    ,businessmodel varchar2(64) -- 业务模式
    ,changetype varchar2(8) -- 调整类型（0代表关闭授信 1代表调整授信额度、定价）
    ,changecode varchar2(32) -- 调整原因码
    ,changemsg varchar2(512) -- 中文理由说明
    ,creditamt varchar2(20) -- 银行建议的授信额度
    ,creditratelimit number(38,8) -- 银行建议的授信利率上限
    ,creditratebottom number(38,8) -- 银行建议的授信利率下限
    ,informflag varchar2(2) -- 通知成功与否
    ,isagree varchar2(1) -- 网商银行是否同意申请
    ,resultmsg varchar2(500) -- 网商银行处理失败原因
    ,failreason varchar2(2112) -- 备注信息
    ,inputid varchar2(20) -- 登记人
    ,inputbrid varchar2(20) -- 登记机构
    ,sysid varchar2(15) -- 处理业务系统ID
    ,approvestatus varchar2(10) -- 审批状态
    ,loanar varchar2(32) -- 业务场景
    ,applytime varchar2(20) -- 申请时间
    ,closeflag varchar2(5) -- 是否是缺少九要素关闭额度标志
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
grant select on ${iol_schema}.icms_mybkzd_credit_change_app to ${iml_schema};
grant select on ${iol_schema}.icms_mybkzd_credit_change_app to ${icl_schema};
grant select on ${iol_schema}.icms_mybkzd_credit_change_app to ${idl_schema};
grant select on ${iol_schema}.icms_mybkzd_credit_change_app to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybkzd_credit_change_app is '网商助贷额度关闭、调整';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.serialno is '授信申请编号';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.cusid is '客户号';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.cusname is '客户名称';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.certtype is '证件类型';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.certcode is '证件号码';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.csapplydate is '初审日期';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.zsapplydate is '终审日期';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.applyamount is '原审批额度';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.applydate is '申请日期';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.informdate is '申请通知时间';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.returndate is '回调通知时间';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.requestid is '请求幂等ID';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.applyno is '联合审批单号';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.custiproleid is '会员角色ID';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.businessmodel is '业务模式';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.changetype is '调整类型（0代表关闭授信 1代表调整授信额度、定价）';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.changecode is '调整原因码';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.changemsg is '中文理由说明';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.creditamt is '银行建议的授信额度';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.creditratelimit is '银行建议的授信利率上限';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.creditratebottom is '银行建议的授信利率下限';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.informflag is '通知成功与否';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.isagree is '网商银行是否同意申请';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.resultmsg is '网商银行处理失败原因';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.failreason is '备注信息';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.inputid is '登记人';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.inputbrid is '登记机构';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.sysid is '处理业务系统ID';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.loanar is '业务场景';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.applytime is '申请时间';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.closeflag is '是否是缺少九要素关闭额度标志';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybkzd_credit_change_app.etl_timestamp is 'ETL处理时间戳';
