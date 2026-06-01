/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myhb_iqp_loan_app
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myhb_iqp_loan_app
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myhb_iqp_loan_app purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myhb_iqp_loan_app(
    serialno varchar2(32) -- 业务流水号
    ,validityofprod varchar2(10) -- 协议有效期
    ,lastadvicedate varchar2(20) -- 终审通知时间
    ,migtflag varchar2(80) -- 
    ,applydate varchar2(20) -- 申请日期
    ,approvestatus varchar2(10) -- 审批状态
    ,cusmgr varchar2(20) -- 客户经理
    ,sexnew varchar2(2) -- 新性别
    ,certtype varchar2(4) -- 证件类型
    ,applyamount number(16,2) -- 审批额度(元)
    ,riskrating varchar2(2) -- 风险评级
    ,cusid varchar2(32) -- 客户号
    ,startdate varchar2(20) -- 审批开始时间
    ,prdcode varchar2(32) -- 产品编号
    ,certcodenew varchar2(18) -- 新证件号码
    ,hashbadmit varchar2(2) -- 是否之前就有花呗额度
    ,enddate varchar2(20) -- 审批结束时间
    ,instcode varchar2(32) -- 推荐方机构ID
    ,ischeckrule varchar2(1) -- 准入规则校验结果
    ,zmauthflag varchar2(2) -- 芝麻授权成功表示
    ,platformaccess varchar2(2) -- 蚂蚁金服审批结果
    ,validdatestartnew varchar2(10) -- 新证件有效期起始日
    ,addressnew varchar2(128) -- 新地址
    ,mobileno varchar2(32) -- 手机号
    ,joininstcodes varchar2(64) -- 参与联合审批机构ID列表
    ,nationalitynew varchar2(6) -- 新国籍
    ,rulingir number(16,9) -- 日利率
    ,agreementno varchar2(128) -- 协议编号
    ,certcode varchar2(60) -- 证件号码
    ,solvencyratings varchar2(2) -- 偿债能力评级
    ,invitestatus varchar2(1) -- 邀约是否通过
    ,closetime varchar2(20) -- 用户解约的具体时间
    ,mngbrid varchar2(20) -- 主管机构
    ,certtypenew varchar2(5) -- 新证件类型
    ,applyno varchar2(64) -- 蚂蚁申请单号
    ,platformmaxamt number(16,2) -- 最大额度(元)
    ,platformrefusereason varchar2(1024) -- 蚂蚁金服拒绝原因
    ,ratetype varchar2(2) -- 利率类型1基准利率2LPR
    ,professionnew varchar2(128) -- 新职业
    ,failreason varchar2(2000) -- 拒绝原因
    ,changeresultreason varchar2(500) -- 额度、定价变更原因
    ,refusereason varchar2(500) -- 返回蚂蚁花呗的拒绝原因
    ,cusnamenew varchar2(128) -- 新姓名
    ,certvalidenddate varchar2(10) -- 证件有效期
    ,contracttext varchar2(256) -- 缔约文本
    ,validdateendnew varchar2(10) -- 新证件有效期到期日
    ,telenew varchar2(18) -- 新联系方式
    ,approveprogress varchar2(3) -- 进度说明
    ,cusname varchar2(200) -- 姓名
    ,authtext varchar2(256) -- 用户授权协议概要信息
    ,consumingscore varchar2(20) -- 消费能力评分
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
grant select on ${iol_schema}.icms_myhb_iqp_loan_app to ${iml_schema};
grant select on ${iol_schema}.icms_myhb_iqp_loan_app to ${icl_schema};
grant select on ${iol_schema}.icms_myhb_iqp_loan_app to ${idl_schema};
grant select on ${iol_schema}.icms_myhb_iqp_loan_app to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myhb_iqp_loan_app is '花呗申请信息';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.serialno is '业务流水号';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.validityofprod is '协议有效期';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.lastadvicedate is '终审通知时间';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.migtflag is '';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.applydate is '申请日期';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.cusmgr is '客户经理';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.sexnew is '新性别';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.certtype is '证件类型';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.applyamount is '审批额度(元)';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.riskrating is '风险评级';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.cusid is '客户号';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.startdate is '审批开始时间';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.prdcode is '产品编号';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.certcodenew is '新证件号码';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.hashbadmit is '是否之前就有花呗额度';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.enddate is '审批结束时间';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.instcode is '推荐方机构ID';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.ischeckrule is '准入规则校验结果';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.zmauthflag is '芝麻授权成功表示';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.platformaccess is '蚂蚁金服审批结果';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.validdatestartnew is '新证件有效期起始日';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.addressnew is '新地址';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.mobileno is '手机号';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.joininstcodes is '参与联合审批机构ID列表';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.nationalitynew is '新国籍';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.rulingir is '日利率';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.agreementno is '协议编号';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.certcode is '证件号码';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.solvencyratings is '偿债能力评级';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.invitestatus is '邀约是否通过';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.closetime is '用户解约的具体时间';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.mngbrid is '主管机构';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.certtypenew is '新证件类型';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.applyno is '蚂蚁申请单号';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.platformmaxamt is '最大额度(元)';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.platformrefusereason is '蚂蚁金服拒绝原因';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.ratetype is '利率类型1基准利率2LPR';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.professionnew is '新职业';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.failreason is '拒绝原因';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.changeresultreason is '额度、定价变更原因';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.refusereason is '返回蚂蚁花呗的拒绝原因';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.cusnamenew is '新姓名';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.certvalidenddate is '证件有效期';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.contracttext is '缔约文本';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.validdateendnew is '新证件有效期到期日';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.telenew is '新联系方式';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.approveprogress is '进度说明';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.cusname is '姓名';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.authtext is '用户授权协议概要信息';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.consumingscore is '消费能力评分';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.start_dt is '开始时间';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.end_dt is '结束时间';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.id_mark is '增删标志';
comment on column ${iol_schema}.icms_myhb_iqp_loan_app.etl_timestamp is 'ETL处理时间戳';
