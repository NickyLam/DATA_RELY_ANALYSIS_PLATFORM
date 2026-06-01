/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fkd_policy_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fkd_policy_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fkd_policy_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_policy_info(
    serialno varchar2(40) -- 主键
    ,applyno varchar2(40) -- 业务流水号
    ,loaninterdt varchar2(20) -- 同贷交互时间
    ,insurercode varchar2(10) -- 保险公司代码
    ,performanceperiod number(15,2) -- 履约期
    ,policyno varchar2(24) -- 保单号
    ,cusname varchar2(200) -- 客户名称
    ,loanrate number(11,7) -- 年化利率
    ,policyterms varchar2(3) -- 保险期限
    ,borrowerrelation varchar2(60) -- 与借款人关系
    ,policydeductratio number(11,7) -- 绝对免赔率
    ,loanprice number(16,2) -- 贷款金额
    ,crtdt varchar2(20) -- 创建时间
    ,banktype varchar2(20) -- 新贷款机构
    ,bankcode varchar2(20) -- 银行联行号
    ,relativeserialno varchar2(32) -- 申请表流水号
    ,policyamt number(24,4) -- 保险金额
    ,inputdate date -- 保单生效时间
    ,policyratio number(11,7) -- 承保比例（单位：%）
    ,outputdate date -- 保单解除时间
    ,bankname varchar2(120) -- 银行名称
    ,insurername varchar2(100) -- 保险公司名称
    ,isconformed varchar2(2) -- 是否确认授信
    ,migtflag varchar2(80) -- 
    ,guarcontno varchar2(30) -- 担保合同编号
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
grant select on ${iol_schema}.icms_fkd_policy_info to ${iml_schema};
grant select on ${iol_schema}.icms_fkd_policy_info to ${icl_schema};
grant select on ${iol_schema}.icms_fkd_policy_info to ${idl_schema};
grant select on ${iol_schema}.icms_fkd_policy_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fkd_policy_info is '华兴快贷保单信息';
comment on column ${iol_schema}.icms_fkd_policy_info.serialno is '主键';
comment on column ${iol_schema}.icms_fkd_policy_info.applyno is '业务流水号';
comment on column ${iol_schema}.icms_fkd_policy_info.loaninterdt is '同贷交互时间';
comment on column ${iol_schema}.icms_fkd_policy_info.insurercode is '保险公司代码';
comment on column ${iol_schema}.icms_fkd_policy_info.performanceperiod is '履约期';
comment on column ${iol_schema}.icms_fkd_policy_info.policyno is '保单号';
comment on column ${iol_schema}.icms_fkd_policy_info.cusname is '客户名称';
comment on column ${iol_schema}.icms_fkd_policy_info.loanrate is '年化利率';
comment on column ${iol_schema}.icms_fkd_policy_info.policyterms is '保险期限';
comment on column ${iol_schema}.icms_fkd_policy_info.borrowerrelation is '与借款人关系';
comment on column ${iol_schema}.icms_fkd_policy_info.policydeductratio is '绝对免赔率';
comment on column ${iol_schema}.icms_fkd_policy_info.loanprice is '贷款金额';
comment on column ${iol_schema}.icms_fkd_policy_info.crtdt is '创建时间';
comment on column ${iol_schema}.icms_fkd_policy_info.banktype is '新贷款机构';
comment on column ${iol_schema}.icms_fkd_policy_info.bankcode is '银行联行号';
comment on column ${iol_schema}.icms_fkd_policy_info.relativeserialno is '申请表流水号';
comment on column ${iol_schema}.icms_fkd_policy_info.policyamt is '保险金额';
comment on column ${iol_schema}.icms_fkd_policy_info.inputdate is '保单生效时间';
comment on column ${iol_schema}.icms_fkd_policy_info.policyratio is '承保比例（单位：%）';
comment on column ${iol_schema}.icms_fkd_policy_info.outputdate is '保单解除时间';
comment on column ${iol_schema}.icms_fkd_policy_info.bankname is '银行名称';
comment on column ${iol_schema}.icms_fkd_policy_info.insurername is '保险公司名称';
comment on column ${iol_schema}.icms_fkd_policy_info.isconformed is '是否确认授信';
comment on column ${iol_schema}.icms_fkd_policy_info.migtflag is '';
comment on column ${iol_schema}.icms_fkd_policy_info.guarcontno is '担保合同编号';
comment on column ${iol_schema}.icms_fkd_policy_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fkd_policy_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fkd_policy_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fkd_policy_info.etl_timestamp is 'ETL处理时间戳';
