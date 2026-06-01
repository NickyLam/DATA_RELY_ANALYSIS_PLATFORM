/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybkzq_iqp_loan_app
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybkzq_iqp_loan_app
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybkzq_iqp_loan_app purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzq_iqp_loan_app(
    serialno varchar2(64) -- 业务流水号
    ,applyno varchar2(128) -- 蚂蚁申请单号
    ,prdcode varchar2(64) -- 产品编号
    ,prdname varchar2(160) -- 产品名称
    ,applydate date -- 申请日期
    ,certtype varchar2(32) -- 证件类型
    ,certcode varchar2(64) -- 证件号码
    ,cusname varchar2(256) -- 客户姓名
    ,cusid varchar2(64) -- 客户号
    ,platformaccess varchar2(8) -- 网商贷审批结果
    ,businessmodel varchar2(128) -- 业务模式
    ,csrequestid varchar2(512) -- 初审幂等ID
    ,informcsflag varchar2(4) -- 初审通知成功与否
    ,csapprovestatus varchar2(40) -- 初审审批状态
    ,csappresult varchar2(256) -- 初审审批结论
    ,csretry varchar2(20) -- 初审重试次数
    ,zsrequestid varchar2(512) -- 终审幂等ID
    ,informzsflag varchar2(4) -- 终审通知成功与否
    ,zsadvicedate varchar2(40) -- 终审通知时间
    ,zsrefusecode varchar2(40) -- 终审审批错误码
    ,zsackmsg varchar2(1024) -- 终审审批结论
    ,zsretry varchar2(20) -- 终审重试次数
    ,approvestatus varchar2(40) -- 终审结束审批状态
    ,applytimes varchar2(12) -- 申请次数（同一客户）
    ,openingflag varchar2(4) -- 开户标识
    ,inputid varchar2(40) -- 登记人
    ,inputorgid varchar2(40) -- 登记机构
    ,applyamount number(24,6) -- 审批额度
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
grant select on ${iol_schema}.icms_mybkzq_iqp_loan_app to ${iml_schema};
grant select on ${iol_schema}.icms_mybkzq_iqp_loan_app to ${icl_schema};
grant select on ${iol_schema}.icms_mybkzq_iqp_loan_app to ${idl_schema};
grant select on ${iol_schema}.icms_mybkzq_iqp_loan_app to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybkzq_iqp_loan_app is '网商贷债权直转申请表';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.serialno is '业务流水号';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.applyno is '蚂蚁申请单号';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.prdcode is '产品编号';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.prdname is '产品名称';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.applydate is '申请日期';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.certtype is '证件类型';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.certcode is '证件号码';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.cusname is '客户姓名';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.cusid is '客户号';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.platformaccess is '网商贷审批结果';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.businessmodel is '业务模式';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.csrequestid is '初审幂等ID';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.informcsflag is '初审通知成功与否';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.csapprovestatus is '初审审批状态';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.csappresult is '初审审批结论';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.csretry is '初审重试次数';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.zsrequestid is '终审幂等ID';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.informzsflag is '终审通知成功与否';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.zsadvicedate is '终审通知时间';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.zsrefusecode is '终审审批错误码';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.zsackmsg is '终审审批结论';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.zsretry is '终审重试次数';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.approvestatus is '终审结束审批状态';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.applytimes is '申请次数（同一客户）';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.openingflag is '开户标识';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.inputid is '登记人';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.applyamount is '审批额度';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybkzq_iqp_loan_app.etl_timestamp is 'ETL处理时间戳';
