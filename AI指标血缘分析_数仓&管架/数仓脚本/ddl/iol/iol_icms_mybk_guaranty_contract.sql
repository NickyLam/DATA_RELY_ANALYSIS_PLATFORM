/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_guaranty_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_guaranty_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_guaranty_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_guaranty_contract(
    guarantyno varchar2(50) -- 担保合同编号
    ,guarantytype varchar2(6) -- 担保合同类型(一般担保合同、最高额担保合同)
    ,guarantystyle varchar2(12) -- 担保方式
    ,guarantystatus varchar2(12) -- 担保合同状态
    ,signdate varchar2(20) -- 协议签定日期
    ,begindate varchar2(20) -- 合同生效日
    ,enddate varchar2(20) -- 合同到期日
    ,customerid varchar2(32) -- 被担保人客户号
    ,guarantorid varchar2(60) -- 担保人编号
    ,guarantorname varchar2(200) -- 担保人名称
    ,certtype varchar2(4) -- 担保人证件类型
    ,certid varchar2(30) -- 担保人证件号码
    ,guaranteeform varchar2(12) -- 保证担保形式
    ,guaorgname varchar2(64) -- 担保机构名称
    ,guapromisebookid varchar2(48) -- 担保事项承诺书编号
    ,inputorgid varchar2(64) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,guarantycurrency varchar2(3) -- 担保币种
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,usesum number(20,2) -- 担保金额
    ,isguarantyplatformloan varchar2(2) -- 是否政府性融资担保公司保证
    ,isbackguaranty varchar2(2) -- 是否反担保
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
grant select on ${iol_schema}.icms_mybk_guaranty_contract to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_guaranty_contract to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_guaranty_contract to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_guaranty_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_guaranty_contract is '网商贷担保合同表';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.guarantyno is '担保合同编号';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.guarantytype is '担保合同类型(一般担保合同、最高额担保合同)';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.guarantystyle is '担保方式';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.guarantystatus is '担保合同状态';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.signdate is '协议签定日期';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.begindate is '合同生效日';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.enddate is '合同到期日';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.customerid is '被担保人客户号';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.guarantorid is '担保人编号';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.guarantorname is '担保人名称';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.certtype is '担保人证件类型';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.certid is '担保人证件号码';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.guaranteeform is '保证担保形式';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.guaorgname is '担保机构名称';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.guapromisebookid is '担保事项承诺书编号';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.inputuserid is '登记人';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.inputdate is '登记日期';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.guarantycurrency is '担保币种';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.usesum is '担保金额';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.isguarantyplatformloan is '是否政府性融资担保公司保证';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.isbackguaranty is '是否反担保';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybk_guaranty_contract.etl_timestamp is 'ETL处理时间戳';
