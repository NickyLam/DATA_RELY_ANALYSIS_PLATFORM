/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_additional_business_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_additional_business_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_additional_business_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_additional_business_contract(
    serialno varchar2(32) -- 合同流水号
    ,poolfinancingno varchar2(80) -- 资产池业务合作协议合同编号
    ,isnlflag varchar2(10) -- 是否南铝业务(1是0否)
    ,occupypoolsum number(24,6) -- 占用池水位金额
    ,poolfinancingdate varchar2(10) -- 资产池协议签署时间
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,isdiscountflag varchar2(10) -- 是否当前借款人(1是0否)
    ,poolfinancingflag varchar2(1) -- 是否已签订池融资协议
    ,poolfinancingguarantyno varchar2(80) -- 资产池最高额质押担保合同编号
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
grant select on ${iol_schema}.icms_additional_business_contract to ${iml_schema};
grant select on ${iol_schema}.icms_additional_business_contract to ${icl_schema};
grant select on ${iol_schema}.icms_additional_business_contract to ${idl_schema};
grant select on ${iol_schema}.icms_additional_business_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_additional_business_contract is '合同附加信息表';
comment on column ${iol_schema}.icms_additional_business_contract.serialno is '合同流水号';
comment on column ${iol_schema}.icms_additional_business_contract.poolfinancingno is '资产池业务合作协议合同编号';
comment on column ${iol_schema}.icms_additional_business_contract.isnlflag is '是否南铝业务(1是0否)';
comment on column ${iol_schema}.icms_additional_business_contract.occupypoolsum is '占用池水位金额';
comment on column ${iol_schema}.icms_additional_business_contract.poolfinancingdate is '资产池协议签署时间';
comment on column ${iol_schema}.icms_additional_business_contract.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_additional_business_contract.isdiscountflag is '是否当前借款人(1是0否)';
comment on column ${iol_schema}.icms_additional_business_contract.poolfinancingflag is '是否已签订池融资协议';
comment on column ${iol_schema}.icms_additional_business_contract.poolfinancingguarantyno is '资产池最高额质押担保合同编号';
comment on column ${iol_schema}.icms_additional_business_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_additional_business_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_additional_business_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_additional_business_contract.etl_timestamp is 'ETL处理时间戳';
