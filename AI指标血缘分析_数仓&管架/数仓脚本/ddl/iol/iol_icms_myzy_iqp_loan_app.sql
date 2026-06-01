/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myzy_iqp_loan_app
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myzy_iqp_loan_app
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myzy_iqp_loan_app purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myzy_iqp_loan_app(
    serno varchar2(32) -- 流水号
    ,requestid varchar2(64) -- 请求流水号
    ,cusnamenew varchar2(128) -- 新姓名
    ,ischeckrule varchar2(1) -- 反欺诈是否已校验标识
    ,resultmsg varchar2(512) -- 审批结果描述
    ,telenew varchar2(18) -- 新联系方式
    ,sysid varchar2(15) -- 处理业务系统ID
    ,floatratebp number(14,10) -- 利率浮动点差BP
    ,creditflag varchar2(32) -- 当前用户授信标识
    ,nationalitynew varchar2(6) -- 新国籍
    ,cusid varchar2(32) -- 客户号
    ,validdatestartnew varchar2(10) -- 新证件有效期起始日
    ,source varchar2(32) -- 申请来源
    ,cardno varchar2(32) -- 快捷卡卡号
    ,certvalidenddate varchar2(32) -- 证件有效期
    ,inputid varchar2(20) -- 登记人
    ,isapplyscore varchar2(2) -- 发送评分接口成功与否
    ,execrate number(14,10) -- 执行年利率，借呗推送日利率X360
    ,validdateendnew varchar2(10) -- 新证件有效期到期日
    ,startdate varchar2(20) -- 审批开始时间
    ,promotereason varchar2(500) -- 调额的原因说明
    ,certcodenew varchar2(18) -- 新证件号码
    ,zmauthflag varchar2(2) -- 芝麻授权成功表示
    ,prdcode varchar2(32) -- 产品编号
    ,applyno varchar2(64) -- 授信申请单号
    ,repaymode varchar2(32) -- 还款方式
    ,expired varchar2(32) -- 申请过期时间
    ,expirydate varchar2(20) -- 固化授信有效期
    ,lpr number(14,10) -- LPR
    ,productcode varchar2(32) -- 产品标识
    ,hasjbadmit varchar2(2) -- 是否之前就有借呗额度
    ,cusname varchar2(200) -- 客户姓名
    ,rulingir number(16,9) -- 基准利率
    ,informflag varchar2(2) -- 通知借呗成功与否
    ,failreason varchar2(2000) -- 备注信息
    ,bizmode varchar2(32) -- 业务模式
    ,promotetype varchar2(32) -- 调额的类型
    ,certtypenew varchar2(5) -- 新证件类型
    ,inputbrid varchar2(20) -- 登记机构
    ,approvestatus varchar2(10) -- 审批状态
    ,autoscore varchar2(10) -- 评分A卡评分
    ,creditno varchar2(64) -- 授信编号
    ,applydate varchar2(20) -- 申请日期
    ,modeltype varchar2(3) -- 所属模块
    ,riskrating varchar2(2) -- 风险评级
    ,migtflag varchar2(80) -- 
    ,certtype varchar2(4) -- 证件类型
    ,isgetcuscode varchar2(2) -- 是否开户成功
    ,isagree varchar2(1) -- 借呗是否同意审批结果
    ,sexnew varchar2(2) -- 新性别
    ,resultcode varchar2(64) -- 审批结果码
    ,iscreditadopted varchar2(2) -- 征信规则校验结果
    ,lastadvicedate varchar2(20) -- 终审通知时间
    ,applyamount number(16,2) -- 审批额度(元)
    ,enddate varchar2(20) -- 审批结束时间
    ,isintercept varchar2(2) -- 是否成功发起MQ
    ,iscollectcredit varchar2(2) -- 个人征信采集成功与否
    ,addressnew varchar2(512) -- 新地址
    ,ratefloatmode varchar2(2) -- 利率浮动方式
    ,ratetype varchar2(2) -- 利率类型1基准2lpr
    ,professionnew varchar2(128) -- 新职业
    ,prdname varchar2(80) -- 产品名称
    ,biztype varchar2(32) -- 申请类型
    ,certcode varchar2(60) -- 证件号码
    ,mobileno varchar2(11) -- 手机号
    ,changeresultreason varchar2(500) -- 额度、定价变更原因
    ,solvencyratings varchar2(2) -- 偿债能力评级
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
grant select on ${iol_schema}.icms_myzy_iqp_loan_app to ${iml_schema};
grant select on ${iol_schema}.icms_myzy_iqp_loan_app to ${icl_schema};
grant select on ${iol_schema}.icms_myzy_iqp_loan_app to ${idl_schema};
grant select on ${iol_schema}.icms_myzy_iqp_loan_app to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myzy_iqp_loan_app is '借呗贷申请信息-三期';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.serno is '流水号';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.requestid is '请求流水号';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.cusnamenew is '新姓名';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.ischeckrule is '反欺诈是否已校验标识';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.resultmsg is '审批结果描述';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.telenew is '新联系方式';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.sysid is '处理业务系统ID';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.floatratebp is '利率浮动点差BP';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.creditflag is '当前用户授信标识';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.nationalitynew is '新国籍';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.cusid is '客户号';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.validdatestartnew is '新证件有效期起始日';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.source is '申请来源';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.cardno is '快捷卡卡号';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.certvalidenddate is '证件有效期';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.inputid is '登记人';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.isapplyscore is '发送评分接口成功与否';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.execrate is '执行年利率，借呗推送日利率X360';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.validdateendnew is '新证件有效期到期日';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.startdate is '审批开始时间';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.promotereason is '调额的原因说明';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.certcodenew is '新证件号码';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.zmauthflag is '芝麻授权成功表示';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.prdcode is '产品编号';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.applyno is '授信申请单号';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.repaymode is '还款方式';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.expired is '申请过期时间';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.expirydate is '固化授信有效期';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.lpr is 'LPR';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.productcode is '产品标识';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.hasjbadmit is '是否之前就有借呗额度';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.cusname is '客户姓名';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.rulingir is '基准利率';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.informflag is '通知借呗成功与否';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.failreason is '备注信息';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.bizmode is '业务模式';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.promotetype is '调额的类型';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.certtypenew is '新证件类型';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.inputbrid is '登记机构';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.autoscore is '评分A卡评分';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.creditno is '授信编号';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.applydate is '申请日期';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.modeltype is '所属模块';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.riskrating is '风险评级';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.migtflag is '';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.certtype is '证件类型';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.isgetcuscode is '是否开户成功';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.isagree is '借呗是否同意审批结果';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.sexnew is '新性别';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.resultcode is '审批结果码';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.iscreditadopted is '征信规则校验结果';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.lastadvicedate is '终审通知时间';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.applyamount is '审批额度(元)';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.enddate is '审批结束时间';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.isintercept is '是否成功发起MQ';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.iscollectcredit is '个人征信采集成功与否';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.addressnew is '新地址';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.ratefloatmode is '利率浮动方式';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.ratetype is '利率类型1基准2lpr';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.professionnew is '新职业';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.prdname is '产品名称';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.biztype is '申请类型';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.certcode is '证件号码';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.mobileno is '手机号';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.changeresultreason is '额度、定价变更原因';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.solvencyratings is '偿债能力评级';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.start_dt is '开始时间';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.end_dt is '结束时间';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.id_mark is '增删标志';
comment on column ${iol_schema}.icms_myzy_iqp_loan_app.etl_timestamp is 'ETL处理时间戳';
