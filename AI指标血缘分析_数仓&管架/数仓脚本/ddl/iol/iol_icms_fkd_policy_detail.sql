/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fkd_policy_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fkd_policy_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fkd_policy_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_policy_detail(
    serialno varchar2(40) -- 主键
    ,borrowerrelation varchar2(60) -- 与借款人关系
    ,loaninterdt varchar2(20) -- 同贷交互时间
    ,insurancename varchar2(80) -- 保险机构
    ,policyterms varchar2(20) -- 保险期限
    ,policydeductratio number(11,7) -- 绝对免赔率
    ,policyserno varchar2(40) -- 保单信息流水号
    ,insured varchar2(200) -- 被保险人
    ,policyenddate date -- 保单结束日
    ,performanceperiod number(15,2) -- 履约期
    ,relativeserialno varchar2(40) -- 业务流水号
    ,policynumber varchar2(40) -- 保单编号
    ,insurercode varchar2(10) -- 保险公司代码
    ,policystartdate date -- 保单起始日
    ,policyratio number(11,7) -- 承保比例（单位：%）
    ,createtime date -- 创建时间
    ,insuranceamount number(16,2) -- 保险金额
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
grant select on ${iol_schema}.icms_fkd_policy_detail to ${iml_schema};
grant select on ${iol_schema}.icms_fkd_policy_detail to ${icl_schema};
grant select on ${iol_schema}.icms_fkd_policy_detail to ${idl_schema};
grant select on ${iol_schema}.icms_fkd_policy_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fkd_policy_detail is '保单信息明细';
comment on column ${iol_schema}.icms_fkd_policy_detail.serialno is '主键';
comment on column ${iol_schema}.icms_fkd_policy_detail.borrowerrelation is '与借款人关系';
comment on column ${iol_schema}.icms_fkd_policy_detail.loaninterdt is '同贷交互时间';
comment on column ${iol_schema}.icms_fkd_policy_detail.insurancename is '保险机构';
comment on column ${iol_schema}.icms_fkd_policy_detail.policyterms is '保险期限';
comment on column ${iol_schema}.icms_fkd_policy_detail.policydeductratio is '绝对免赔率';
comment on column ${iol_schema}.icms_fkd_policy_detail.policyserno is '保单信息流水号';
comment on column ${iol_schema}.icms_fkd_policy_detail.insured is '被保险人';
comment on column ${iol_schema}.icms_fkd_policy_detail.policyenddate is '保单结束日';
comment on column ${iol_schema}.icms_fkd_policy_detail.performanceperiod is '履约期';
comment on column ${iol_schema}.icms_fkd_policy_detail.relativeserialno is '业务流水号';
comment on column ${iol_schema}.icms_fkd_policy_detail.policynumber is '保单编号';
comment on column ${iol_schema}.icms_fkd_policy_detail.insurercode is '保险公司代码';
comment on column ${iol_schema}.icms_fkd_policy_detail.policystartdate is '保单起始日';
comment on column ${iol_schema}.icms_fkd_policy_detail.policyratio is '承保比例（单位：%）';
comment on column ${iol_schema}.icms_fkd_policy_detail.createtime is '创建时间';
comment on column ${iol_schema}.icms_fkd_policy_detail.insuranceamount is '保险金额';
comment on column ${iol_schema}.icms_fkd_policy_detail.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fkd_policy_detail.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fkd_policy_detail.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fkd_policy_detail.etl_timestamp is 'ETL处理时间戳';
