/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_wyd_guarantee_cont_rep_three
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three(
    datadt varchar2(10) -- 数据日期
    ,orgid varchar2(20) -- 机构号
    ,guarcontractno varchar2(64) -- 担保合同号
    ,maincontracttype varchar2(10) -- 主合同类型
    ,guaramt number(20,4) -- 担保总金额
    ,ccycd varchar2(10) -- 币种
    ,signdate varchar2(10) -- 签约日期
    ,maturitydate varchar2(10) -- 到期日期
    ,guarcustno varchar2(30) -- 保证人或抵质押品的权属人客户号
    ,guarcustname varchar2(60) -- 保证人或抵质押品的权属人客户名称
    ,guarcusttype varchar2(32) -- 保证人或抵质押品的权属人客户类型
    ,guarcustidtype varchar2(60) -- 保证人或抵质押品的权属人客户证件类型
    ,guarcustidno varchar2(30) -- 保证人或抵质押品的权属人客户证件号码
    ,guarcontracttype varchar2(10) -- 担保合同类型
    ,guartype varchar2(10) -- 担保方式
    ,guarstartdate varchar2(10) -- 担保起始日期
    ,guarenddate varchar2(10) -- 担保到期日期
    ,expiredate varchar2(10) -- 担保合同失效日期
    ,guarcontractsts varchar2(3) -- 担保合同状态
    ,operator varchar2(20) -- 经办员工号
    ,guarantortype varchar2(10) -- 保证人类型
    ,contractno varchar2(64) -- 额度合同编号
    ,merchantid varchar2(32) -- 单位ID
    ,isplatformguar varchar2(1) -- 是否是平台批量担保
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three to ${iml_schema};
grant select on ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three to ${icl_schema};
grant select on ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three to ${idl_schema};
grant select on ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three is '担保合同信息报表中间表03';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.datadt is '数据日期';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.orgid is '机构号';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guarcontractno is '担保合同号';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.maincontracttype is '主合同类型';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guaramt is '担保总金额';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.ccycd is '币种';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.signdate is '签约日期';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.maturitydate is '到期日期';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guarcustno is '保证人或抵质押品的权属人客户号';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guarcustname is '保证人或抵质押品的权属人客户名称';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guarcusttype is '保证人或抵质押品的权属人客户类型';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guarcustidtype is '保证人或抵质押品的权属人客户证件类型';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guarcustidno is '保证人或抵质押品的权属人客户证件号码';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guarcontracttype is '担保合同类型';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guartype is '担保方式';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guarstartdate is '担保起始日期';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guarenddate is '担保到期日期';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.expiredate is '担保合同失效日期';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guarcontractsts is '担保合同状态';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.operator is '经办员工号';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.guarantortype is '保证人类型';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.contractno is '额度合同编号';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.merchantid is '单位ID';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.isplatformguar is '是否是平台批量担保';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_wyd_guarantee_cont_rep_three.etl_timestamp is 'ETL处理时间戳';
