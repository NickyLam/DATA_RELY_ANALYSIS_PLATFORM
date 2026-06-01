/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybkzd_iqp_loan_app
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybkzd_iqp_loan_app
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybkzd_iqp_loan_app purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_iqp_loan_app(
    serialno varchar2(32) -- 业务流水号
    ,applyno varchar2(64) -- 蚂蚁申请单号
    ,prdcode varchar2(32) -- 产品编号
    ,prdname varchar2(160) -- 产品名称
    ,applydate varchar2(20) -- 申请日期
    ,certtype varchar2(4) -- 证件类型
    ,certcode varchar2(60) -- 证件号码
    ,cusname varchar2(200) -- 姓名
    ,cusid varchar2(32) -- 客户号
    ,platformaccess varchar2(2) -- 网商贷审批结果
    ,platformadmit number(16,2) -- 授信建议额度
    ,platformratelimit number(12,9) -- 授信年利率上限
    ,platformratebottom number(12,9) -- 授信年利率下限
    ,failreason varchar2(1600) -- 拒绝原因
    ,applyamount number(16,2) -- 审批额度(元)
    ,rulingir number(16,9) -- 年利率
    ,startdate varchar2(20) -- 审批开始时间
    ,enddate varchar2(20) -- 审批结束时间
    ,approvestatus varchar2(64) -- 审批状态
    ,informflag varchar2(2) -- 初审通知成功与否
    ,informfinalflag varchar2(2) -- 终审通知成功与否
    ,lastadvicedate varchar2(20) -- 终审通知时间
    ,inputid varchar2(20) -- 登记人
    ,inputbrid varchar2(20) -- 登记机构
    ,businessmodel varchar2(64) -- 业务模式
    ,refusecode varchar2(30) -- 拒绝码
    ,ackmsg varchar2(1000) -- 拒绝原因
    ,csapprovestatus varchar2(20) -- 初审审批状态
    ,targetjyflag2 varchar2(64) -- 客群经营标签（人行口径）
    ,targetjyflag3 varchar2(64) -- 客群经营标签（银监口径）
    ,farmerflag varchar2(64) -- 是否农户
    ,mobile varchar2(32) -- 手机号码
    ,requestid varchar2(256) -- 初审幂等ID
    ,zsrequestid varchar2(256) -- 终审幂等ID
    ,loanar varchar2(32) -- 业务场景
    ,bsntype varchar2(64) -- 产品业务类型
    ,actcerttype varchar2(8) -- 企业实控人证件类型
    ,actcertno varchar2(64) -- 企业实控人证件号码
    ,actcertname varchar2(64) -- 企业实控人证件名
    ,staffnum varchar2(64) -- 职工人数
    ,income varchar2(64) -- 营业收入，单位元
    ,arno varchar2(64) -- 方案合约号（代表一种合作模式，区分旺农贷和中和农信）
    ,lprlimit number(14,10) -- 利率上限LPR，网商贷默认一年期LPR
    ,lprbottom number(14,10) -- 利率下限LPR，网商贷默认一年期LPR
    ,floatratebplimit number(14,10) -- 利率上限浮动点差BP
    ,floatratebpbottom number(14,10) -- 利率下限浮动点差BP
    ,ratefloatmodelimit varchar2(2) -- 利率上限浮动方式
    ,ratefloatmodebottom varchar2(2) -- 利率下限浮动方式
    ,applytimes varchar2(6) -- 申请次数（同一客户）
    ,custinst varchar2(64) -- 客引机构ID(区分旺农贷、中和农信)
    ,csappresult varchar2(128) -- 网商贷初审结论
    ,balstatus varchar2(20) -- 额度状态
    ,authorizationbookid varchar2(80) -- 授权书编号
    ,isfreshcust varchar2(2) -- 是否绿色信贷
    ,loanusetype varchar2(6) -- 贷款用途
    ,ownapplyamount number(16,2) -- 我行审批额度
    ,greenloanflag varchar2(2) -- 绿色信贷标识
    ,greenloanuse varchar2(400) -- 绿色贷款用途
    ,gradeamt varchar2(10) -- 命中反洗钱评级
    ,openingflag varchar2(2) -- 开户标识
    ,csretry varchar2(10) -- 初审重试次数
    ,zsretry varchar2(10) -- 终审重试次数
    ,issendbooster varchar2(2) -- 是否已发booster接口: YesNo
    ,sendriskstatus varchar2(2) -- 发送风控状态: onlineFlowStatus
    ,noticedate date -- 通知时间
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
grant select on ${iol_schema}.icms_mybkzd_iqp_loan_app to ${iml_schema};
grant select on ${iol_schema}.icms_mybkzd_iqp_loan_app to ${icl_schema};
grant select on ${iol_schema}.icms_mybkzd_iqp_loan_app to ${idl_schema};
grant select on ${iol_schema}.icms_mybkzd_iqp_loan_app to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybkzd_iqp_loan_app is '网商贷助贷申请信息表';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.serialno is '业务流水号';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.applyno is '蚂蚁申请单号';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.prdcode is '产品编号';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.prdname is '产品名称';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.applydate is '申请日期';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.certtype is '证件类型';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.certcode is '证件号码';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.cusname is '姓名';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.cusid is '客户号';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.platformaccess is '网商贷审批结果';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.platformadmit is '授信建议额度';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.platformratelimit is '授信年利率上限';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.platformratebottom is '授信年利率下限';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.failreason is '拒绝原因';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.applyamount is '审批额度(元)';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.rulingir is '年利率';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.startdate is '审批开始时间';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.enddate is '审批结束时间';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.informflag is '初审通知成功与否';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.informfinalflag is '终审通知成功与否';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.lastadvicedate is '终审通知时间';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.inputid is '登记人';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.inputbrid is '登记机构';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.businessmodel is '业务模式';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.refusecode is '拒绝码';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.ackmsg is '拒绝原因';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.csapprovestatus is '初审审批状态';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.targetjyflag2 is '客群经营标签（人行口径）';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.targetjyflag3 is '客群经营标签（银监口径）';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.farmerflag is '是否农户';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.mobile is '手机号码';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.requestid is '初审幂等ID';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.zsrequestid is '终审幂等ID';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.loanar is '业务场景';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.actcerttype is '企业实控人证件类型';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.actcertno is '企业实控人证件号码';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.actcertname is '企业实控人证件名';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.staffnum is '职工人数';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.income is '营业收入，单位元';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.arno is '方案合约号（代表一种合作模式，区分旺农贷和中和农信）';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.lprlimit is '利率上限LPR，网商贷默认一年期LPR';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.lprbottom is '利率下限LPR，网商贷默认一年期LPR';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.floatratebplimit is '利率上限浮动点差BP';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.floatratebpbottom is '利率下限浮动点差BP';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.ratefloatmodelimit is '利率上限浮动方式';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.ratefloatmodebottom is '利率下限浮动方式';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.applytimes is '申请次数（同一客户）';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.custinst is '客引机构ID(区分旺农贷、中和农信)';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.csappresult is '网商贷初审结论';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.balstatus is '额度状态';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.authorizationbookid is '授权书编号';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.isfreshcust is '是否绿色信贷';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.loanusetype is '贷款用途';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.ownapplyamount is '我行审批额度';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.greenloanflag is '绿色信贷标识';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.greenloanuse is '绿色贷款用途';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.gradeamt is '命中反洗钱评级';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.openingflag is '开户标识';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.csretry is '初审重试次数';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.zsretry is '终审重试次数';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.issendbooster is '是否已发booster接口: YesNo';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.sendriskstatus is '发送风控状态: onlineFlowStatus';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.noticedate is '通知时间';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybkzd_iqp_loan_app.etl_timestamp is 'ETL处理时间戳';
