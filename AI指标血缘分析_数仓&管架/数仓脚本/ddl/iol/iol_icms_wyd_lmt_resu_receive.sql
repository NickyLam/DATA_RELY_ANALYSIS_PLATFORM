/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_lmt_resu_receive
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_lmt_resu_receive
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_lmt_resu_receive purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_lmt_resu_receive(
    serialno varchar2(64) -- 流水号
    ,lmtresuseq varchar2(64) -- 额度结果流水号
    ,riskjudgeseq varchar2(64) -- 风险判别流水号
    ,intfccalltime date -- 接口调用时间
    ,recommender varchar2(32) -- 推荐人
    ,ccy varchar2(64) -- 币种
    ,taxpayerid varchar2(64) -- 纳税人识别号
    ,enterprisename varchar2(200) -- 企业名称
    ,wzccif varchar2(32) -- 微众客户ID
    ,orgbranchcode varchar2(64) -- 组织机构代码
    ,socialunitycreditcode varchar2(64) -- 社会统一信用代码
    ,busiregisterno varchar2(64) -- 工商注册号
    ,legalname varchar2(200) -- 法人名称
    ,legalmobile varchar2(20) -- 法人手机号码
    ,legalcertid varchar2(64) -- 法人证件号
    ,legalcerttype varchar2(32) -- 法人证件类型
    ,customerid varchar2(32) -- 客户编号（ECIF）
    ,modelquotalmt number(24,6) -- 模型核额额度
    ,dayrate number(24,6) -- 日利率
    ,prdterm varchar2(10) -- 产品期限
    ,custlevel varchar2(10) -- 内部评级
    ,quotafailrsns varchar2(4000) -- 核额失败原因
    ,stlprdid varchar2(32) -- 核算产品编号
    ,productid varchar2(32) -- 产品编号
    ,riskresult varchar2(32) -- 风控结果
    ,finalloanrate number(24,6) -- 最终审批利率
    ,finalapplyamount number(24,6) -- 最终审批额度
    ,finalapplyterm number(24,6) -- 最终审批期限
    ,risknote varchar2(4000) -- 备注
    ,riskwarm varchar2(1000) -- 预警
    ,ismoneylaunderlz varchar2(10) -- 是否命中反洗钱汇总
    ,refunum varchar2(10) -- 拒绝码
    ,updateamount number(24,6) -- 我行修改额度
    ,inputuserid varchar2(20) -- 登记人
    ,inputorgid varchar2(20) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(20) -- 更新人
    ,updateorgid varchar2(20) -- 更新机构
    ,updatedate date -- 更新日期
    ,dealstatus varchar2(10) -- 额度确认处理状态
    ,noncestr varchar2(100) -- 请求微众流水
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
grant select on ${iol_schema}.icms_wyd_lmt_resu_receive to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_lmt_resu_receive to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_lmt_resu_receive to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_lmt_resu_receive to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_lmt_resu_receive is '微业贷额度结果接收表';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.serialno is '流水号';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.lmtresuseq is '额度结果流水号';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.riskjudgeseq is '风险判别流水号';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.intfccalltime is '接口调用时间';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.recommender is '推荐人';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.ccy is '币种';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.taxpayerid is '纳税人识别号';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.enterprisename is '企业名称';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.wzccif is '微众客户ID';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.orgbranchcode is '组织机构代码';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.socialunitycreditcode is '社会统一信用代码';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.busiregisterno is '工商注册号';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.legalname is '法人名称';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.legalmobile is '法人手机号码';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.legalcertid is '法人证件号';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.legalcerttype is '法人证件类型';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.customerid is '客户编号（ECIF）';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.modelquotalmt is '模型核额额度';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.dayrate is '日利率';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.prdterm is '产品期限';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.custlevel is '内部评级';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.quotafailrsns is '核额失败原因';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.stlprdid is '核算产品编号';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.riskresult is '风控结果';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.finalloanrate is '最终审批利率';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.finalapplyamount is '最终审批额度';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.finalapplyterm is '最终审批期限';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.risknote is '备注';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.riskwarm is '预警';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.ismoneylaunderlz is '是否命中反洗钱汇总';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.refunum is '拒绝码';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.updateamount is '我行修改额度';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.dealstatus is '额度确认处理状态';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.noncestr is '请求微众流水';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wyd_lmt_resu_receive.etl_timestamp is 'ETL处理时间戳';
