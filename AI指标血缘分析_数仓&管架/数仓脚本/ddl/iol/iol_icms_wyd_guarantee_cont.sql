/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_guarantee_cont
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_guarantee_cont
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_guarantee_cont purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_guarantee_cont(
    datadt varchar2(10) -- 数据日期
    ,orgid varchar2(20) -- 机构号
    ,guarcontractno varchar2(64) -- 担保合同号
    ,maincontracttype varchar2(10) -- 主合同类型
    ,guaramt number(20,4) -- 担保金额
    ,ccycd varchar2(10) -- 币种
    ,signdate varchar2(10) -- 签约日期
    ,maturitydate varchar2(10) -- 到期日期
    ,guarcustno varchar2(30) -- 保证人或抵质押品的权属人客户号
    ,guarcustname varchar2(60) -- 保证人或抵质押品的权属人客户名称
    ,guarcusttype varchar2(32) -- 保证人或抵质押品的权属人客户类型
    ,guarcustidtype varchar2(20) -- 保证人或抵质押品的权属人客户证件类型
    ,guarcustidno varchar2(30) -- 保证人或抵质押品的权属人客户证件号码
    ,guarcontracttype varchar2(10) -- 担保合同类型
    ,guartype varchar2(10) -- 担保方式
    ,localgovguartype varchar2(10) -- 地方政府融资平台担保分类
    ,guarstartdate varchar2(10) -- 担保起始日期
    ,guarenddate varchar2(10) -- 担保到期日期
    ,expiredate varchar2(10) -- 担保合同失效日期
    ,guarcontractsts varchar2(3) -- 担保合同状态
    ,operator varchar2(20) -- 经办员工号
    ,guarantortype varchar2(10) -- 保证人类型
    ,contractno varchar2(64) -- 额度合同编号
    ,merchantid varchar2(32) -- 单位ID
    ,isplatformguar varchar2(1) -- 是否是平台批量担保
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,customerid varchar2(64) -- 我行客户号
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 废除五级分类
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
grant select on ${iol_schema}.icms_wyd_guarantee_cont to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_guarantee_cont to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_guarantee_cont to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_guarantee_cont to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_guarantee_cont is '担保合同信息';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.datadt is '数据日期';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.orgid is '机构号';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guarcontractno is '担保合同号';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.maincontracttype is '主合同类型';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guaramt is '担保金额';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.ccycd is '币种';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.signdate is '签约日期';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.maturitydate is '到期日期';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guarcustno is '保证人或抵质押品的权属人客户号';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guarcustname is '保证人或抵质押品的权属人客户名称';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guarcusttype is '保证人或抵质押品的权属人客户类型';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guarcustidtype is '保证人或抵质押品的权属人客户证件类型';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guarcustidno is '保证人或抵质押品的权属人客户证件号码';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guarcontracttype is '担保合同类型';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guartype is '担保方式';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.localgovguartype is '地方政府融资平台担保分类';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guarstartdate is '担保起始日期';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guarenddate is '担保到期日期';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.expiredate is '担保合同失效日期';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guarcontractsts is '担保合同状态';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.operator is '经办员工号';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.guarantortype is '保证人类型';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.contractno is '额度合同编号';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.merchantid is '单位ID';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.isplatformguar is '是否是平台批量担保';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.customerid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.classifyresult is '废除五级分类';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_guarantee_cont.etl_timestamp is 'ETL处理时间戳';
