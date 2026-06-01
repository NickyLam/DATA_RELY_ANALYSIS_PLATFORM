/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_supplychainfinance_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_supplychainfinance_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_supplychainfinance_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_supplychainfinance_list(
    operatebranchorgid varchar2(32) -- 经办分行
    ,balance number(24,6) -- 出账金额
    ,coreenterprisename varchar2(80) -- 对应核心企业名称
    ,totalsum number(24,6) -- 敞口金额
    ,customername varchar2(80) -- 借款人名称
    ,maturity date -- 业务到期日
    ,contractserialno varchar2(32) -- 业务合同流水号
    ,putoutdate varchar2(10) -- 业务起始日
    ,migtflag varchar2(80) -- 
    ,commissionrate varchar2(10) -- 手续费率
    ,supplychainfinancetype varchar2(8) -- 供应链金融业务品种
    ,businesssum number(24,6) -- 合同金额
    ,additionalbailsum number(24,6) -- 追加保证金
    ,inputdate date -- 数据记入日期
    ,initbailsum number(24,6) -- 初始化保证金
    ,businessrate varchar2(10) -- 融资利率
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
grant select on ${iol_schema}.icms_supplychainfinance_list to ${iml_schema};
grant select on ${iol_schema}.icms_supplychainfinance_list to ${icl_schema};
grant select on ${iol_schema}.icms_supplychainfinance_list to ${idl_schema};
grant select on ${iol_schema}.icms_supplychainfinance_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_supplychainfinance_list is '供应链金融业务清单表';
comment on column ${iol_schema}.icms_supplychainfinance_list.operatebranchorgid is '经办分行';
comment on column ${iol_schema}.icms_supplychainfinance_list.balance is '出账金额';
comment on column ${iol_schema}.icms_supplychainfinance_list.coreenterprisename is '对应核心企业名称';
comment on column ${iol_schema}.icms_supplychainfinance_list.totalsum is '敞口金额';
comment on column ${iol_schema}.icms_supplychainfinance_list.customername is '借款人名称';
comment on column ${iol_schema}.icms_supplychainfinance_list.maturity is '业务到期日';
comment on column ${iol_schema}.icms_supplychainfinance_list.contractserialno is '业务合同流水号';
comment on column ${iol_schema}.icms_supplychainfinance_list.putoutdate is '业务起始日';
comment on column ${iol_schema}.icms_supplychainfinance_list.migtflag is '';
comment on column ${iol_schema}.icms_supplychainfinance_list.commissionrate is '手续费率';
comment on column ${iol_schema}.icms_supplychainfinance_list.supplychainfinancetype is '供应链金融业务品种';
comment on column ${iol_schema}.icms_supplychainfinance_list.businesssum is '合同金额';
comment on column ${iol_schema}.icms_supplychainfinance_list.additionalbailsum is '追加保证金';
comment on column ${iol_schema}.icms_supplychainfinance_list.inputdate is '数据记入日期';
comment on column ${iol_schema}.icms_supplychainfinance_list.initbailsum is '初始化保证金';
comment on column ${iol_schema}.icms_supplychainfinance_list.businessrate is '融资利率';
comment on column ${iol_schema}.icms_supplychainfinance_list.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_supplychainfinance_list.etl_timestamp is 'ETL处理时间戳';
