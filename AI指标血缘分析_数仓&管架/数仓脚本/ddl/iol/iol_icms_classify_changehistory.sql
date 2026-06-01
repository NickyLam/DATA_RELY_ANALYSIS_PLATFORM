/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_classify_changehistory
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_classify_changehistory
whenever sqlerror continue none;
drop table ${iol_schema}.icms_classify_changehistory purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_classify_changehistory(
    serialno varchar2(32) -- 流水号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,relativetype varchar2(5) -- 关联流程类型(1-风险分类发起2-风险分类调整申请)
    ,changetime date -- 调整时间
    ,flowinputuserid varchar2(8) -- 流程发起人
    ,objectno varchar2(32) -- 对象值(额度合同号或业务合同号或客户号)
    ,businesstype varchar2(18) -- 业务类型
    ,operateorgid varchar2(20) -- 管护机构
    ,lastclassifyeleven varchar2(20) -- 调整前十一级分类
    ,balance number(24,6) -- 余额
    ,lastclassifyfive varchar2(20) -- 调整前五级分类
    ,operateuserid varchar2(8) -- 管护人
    ,relativeserialno varchar2(32) -- 关联流程编号
    ,businesscurrency varchar2(40) -- 业务币种
    ,contractserialno varchar2(40) -- 业务合同号
    ,afterclassifyfive varchar2(20) -- 调整后五级分类
    ,afterclassifyeleven varchar2(20) -- 调整后十一级分类
    ,customerid varchar2(40) -- 客户号
    ,customername varchar2(200) -- 客户名称
    ,objectype varchar2(5) -- 对象类型(01-针对额度合同02-业务合同03-客户)
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
grant select on ${iol_schema}.icms_classify_changehistory to ${iml_schema};
grant select on ${iol_schema}.icms_classify_changehistory to ${icl_schema};
grant select on ${iol_schema}.icms_classify_changehistory to ${idl_schema};
grant select on ${iol_schema}.icms_classify_changehistory to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_classify_changehistory is '风险分类迁徙记录表';
comment on column ${iol_schema}.icms_classify_changehistory.serialno is '流水号';
comment on column ${iol_schema}.icms_classify_changehistory.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_classify_changehistory.relativetype is '关联流程类型(1-风险分类发起2-风险分类调整申请)';
comment on column ${iol_schema}.icms_classify_changehistory.changetime is '调整时间';
comment on column ${iol_schema}.icms_classify_changehistory.flowinputuserid is '流程发起人';
comment on column ${iol_schema}.icms_classify_changehistory.objectno is '对象值(额度合同号或业务合同号或客户号)';
comment on column ${iol_schema}.icms_classify_changehistory.businesstype is '业务类型';
comment on column ${iol_schema}.icms_classify_changehistory.operateorgid is '管护机构';
comment on column ${iol_schema}.icms_classify_changehistory.lastclassifyeleven is '调整前十一级分类';
comment on column ${iol_schema}.icms_classify_changehistory.balance is '余额';
comment on column ${iol_schema}.icms_classify_changehistory.lastclassifyfive is '调整前五级分类';
comment on column ${iol_schema}.icms_classify_changehistory.operateuserid is '管护人';
comment on column ${iol_schema}.icms_classify_changehistory.relativeserialno is '关联流程编号';
comment on column ${iol_schema}.icms_classify_changehistory.businesscurrency is '业务币种';
comment on column ${iol_schema}.icms_classify_changehistory.contractserialno is '业务合同号';
comment on column ${iol_schema}.icms_classify_changehistory.afterclassifyfive is '调整后五级分类';
comment on column ${iol_schema}.icms_classify_changehistory.afterclassifyeleven is '调整后十一级分类';
comment on column ${iol_schema}.icms_classify_changehistory.customerid is '客户号';
comment on column ${iol_schema}.icms_classify_changehistory.customername is '客户名称';
comment on column ${iol_schema}.icms_classify_changehistory.objectype is '对象类型(01-针对额度合同02-业务合同03-客户)';
comment on column ${iol_schema}.icms_classify_changehistory.start_dt is '开始时间';
comment on column ${iol_schema}.icms_classify_changehistory.end_dt is '结束时间';
comment on column ${iol_schema}.icms_classify_changehistory.id_mark is '增删标志';
comment on column ${iol_schema}.icms_classify_changehistory.etl_timestamp is 'ETL处理时间戳';
