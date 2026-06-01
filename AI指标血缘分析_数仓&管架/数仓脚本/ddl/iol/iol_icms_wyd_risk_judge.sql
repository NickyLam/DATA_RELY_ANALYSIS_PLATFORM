/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_risk_judge
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_risk_judge
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_risk_judge purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_risk_judge(
    serialno varchar2(64) -- 流水号
    ,riskjudgeseq varchar2(64) -- 风险判别流水号
    ,applytime date -- 申请时间
    ,intfccalltime date -- 接口调用时间
    ,scenetype varchar2(10) -- 场景类型
    ,stlprdid varchar2(32) -- 核算产品编号
    ,productid varchar2(32) -- 产品编号
    ,recommender varchar2(32) -- 推荐人
    ,ccy varchar2(64) -- 币种
    ,taxpayerid varchar2(64) -- 纳税人识别号
    ,enterprisename varchar2(200) -- 企业名称
    ,regarea varchar2(20) -- 注册国家或地区
    ,regadmarea varchar2(20) -- 注册地行政区划
    ,regaddress varchar2(500) -- 注册地址
    ,province varchar2(100) -- 省份
    ,orgbranchcode varchar2(64) -- 组织机构代码
    ,socialunitycreditcode varchar2(64) -- 社会统一信用代码
    ,busiregisterno varchar2(64) -- 工商注册号
    ,wzccif varchar2(32) -- 微众客户ID
    ,category varchar2(20) -- 国标行业分类
    ,smallcorpiden varchar2(10) -- 银监会小企业标识
    ,registerdate date -- 成立日期
    ,operyears varchar2(20) -- 经营年限
    ,staffnumber varchar2(20) -- 员工人数
    ,legalname varchar2(200) -- 法人名称
    ,legalcertid varchar2(64) -- 法人证件号
    ,legalcerttype varchar2(32) -- 法人证件类型
    ,legalcertexpiredate date -- 法人证件失效日期
    ,legalsex varchar2(10) -- 法人性别
    ,legalethnicity varchar2(20) -- 法人民族
    ,legaladdress varchar2(500) -- 法人证件地址
    ,legalnationality varchar2(20) -- 法人国籍
    ,legalcareer varchar2(20) -- 法人职业
    ,legalbirth date -- 法人出生日期
    ,legalphoneno varchar2(20) -- 法人手机号码
    ,legalbankcard varchar2(100) -- 法人认证银行卡号
    ,legalmobile varchar2(20) -- 法人认证手机号码
    ,legalecif varchar2(32) -- 法人ECIF
    ,signingenpauthtime varchar2(20) -- 企业征信授权书签署时间
    ,signingpersonauthtime varchar2(20) -- 个人征信授权书签署时间
    ,signingenpauthseq varchar2(64) -- 企业征信授权书签署流水号
    ,signingpersonauthseq varchar2(64) -- 个人征信授权书签署流水号
    ,customerid varchar2(32) -- 客户编号（ECIF）
    ,intfccallresptime date -- 接口调用返回时间
    ,riskresult varchar2(32) -- 风控结果
    ,inputuserid varchar2(20) -- 登记人
    ,inputorgid varchar2(20) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(20) -- 更新人
    ,updateorgid varchar2(20) -- 更新机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_wyd_risk_judge to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_risk_judge to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_risk_judge to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_risk_judge to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_risk_judge is '微业贷风险判别表';
comment on column ${iol_schema}.icms_wyd_risk_judge.serialno is '流水号';
comment on column ${iol_schema}.icms_wyd_risk_judge.riskjudgeseq is '风险判别流水号';
comment on column ${iol_schema}.icms_wyd_risk_judge.applytime is '申请时间';
comment on column ${iol_schema}.icms_wyd_risk_judge.intfccalltime is '接口调用时间';
comment on column ${iol_schema}.icms_wyd_risk_judge.scenetype is '场景类型';
comment on column ${iol_schema}.icms_wyd_risk_judge.stlprdid is '核算产品编号';
comment on column ${iol_schema}.icms_wyd_risk_judge.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_risk_judge.recommender is '推荐人';
comment on column ${iol_schema}.icms_wyd_risk_judge.ccy is '币种';
comment on column ${iol_schema}.icms_wyd_risk_judge.taxpayerid is '纳税人识别号';
comment on column ${iol_schema}.icms_wyd_risk_judge.enterprisename is '企业名称';
comment on column ${iol_schema}.icms_wyd_risk_judge.regarea is '注册国家或地区';
comment on column ${iol_schema}.icms_wyd_risk_judge.regadmarea is '注册地行政区划';
comment on column ${iol_schema}.icms_wyd_risk_judge.regaddress is '注册地址';
comment on column ${iol_schema}.icms_wyd_risk_judge.province is '省份';
comment on column ${iol_schema}.icms_wyd_risk_judge.orgbranchcode is '组织机构代码';
comment on column ${iol_schema}.icms_wyd_risk_judge.socialunitycreditcode is '社会统一信用代码';
comment on column ${iol_schema}.icms_wyd_risk_judge.busiregisterno is '工商注册号';
comment on column ${iol_schema}.icms_wyd_risk_judge.wzccif is '微众客户ID';
comment on column ${iol_schema}.icms_wyd_risk_judge.category is '国标行业分类';
comment on column ${iol_schema}.icms_wyd_risk_judge.smallcorpiden is '银监会小企业标识';
comment on column ${iol_schema}.icms_wyd_risk_judge.registerdate is '成立日期';
comment on column ${iol_schema}.icms_wyd_risk_judge.operyears is '经营年限';
comment on column ${iol_schema}.icms_wyd_risk_judge.staffnumber is '员工人数';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalname is '法人名称';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalcertid is '法人证件号';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalcerttype is '法人证件类型';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalcertexpiredate is '法人证件失效日期';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalsex is '法人性别';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalethnicity is '法人民族';
comment on column ${iol_schema}.icms_wyd_risk_judge.legaladdress is '法人证件地址';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalnationality is '法人国籍';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalcareer is '法人职业';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalbirth is '法人出生日期';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalphoneno is '法人手机号码';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalbankcard is '法人认证银行卡号';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalmobile is '法人认证手机号码';
comment on column ${iol_schema}.icms_wyd_risk_judge.legalecif is '法人ECIF';
comment on column ${iol_schema}.icms_wyd_risk_judge.signingenpauthtime is '企业征信授权书签署时间';
comment on column ${iol_schema}.icms_wyd_risk_judge.signingpersonauthtime is '个人征信授权书签署时间';
comment on column ${iol_schema}.icms_wyd_risk_judge.signingenpauthseq is '企业征信授权书签署流水号';
comment on column ${iol_schema}.icms_wyd_risk_judge.signingpersonauthseq is '个人征信授权书签署流水号';
comment on column ${iol_schema}.icms_wyd_risk_judge.customerid is '客户编号（ECIF）';
comment on column ${iol_schema}.icms_wyd_risk_judge.intfccallresptime is '接口调用返回时间';
comment on column ${iol_schema}.icms_wyd_risk_judge.riskresult is '风控结果';
comment on column ${iol_schema}.icms_wyd_risk_judge.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_risk_judge.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wyd_risk_judge.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wyd_risk_judge.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_risk_judge.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_risk_judge.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_risk_judge.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wyd_risk_judge.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wyd_risk_judge.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wyd_risk_judge.etl_timestamp is 'ETL处理时间戳';
