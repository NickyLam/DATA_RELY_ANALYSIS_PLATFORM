/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_upl_credit_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_upl_credit_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_upl_credit_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_upl_credit_info(
    serialno varchar2(32) -- 额度编号
    ,currency varchar2(3) -- 币种
    ,inputuser varchar2(32) -- 登记用户
    ,updatedate varchar2(32) -- 更新日期
    ,usedcreditsum number(24,6) -- 已使用的他用额度
    ,status varchar2(2) -- 额度状态
    ,inputorg varchar2(32) -- 登记机构
    ,migtflag varchar2(80) -- 
    ,creditsum number(24,6) -- 他用额度总额
    ,inputdate varchar2(32) -- 登记日期
    ,creditbalance number(24,6) -- 可用的他用额度
    ,frozcredit number(24,6) -- 冻结的他用额度
    ,customerid varchar2(32) -- 客户编号
    ,cycleflag varchar2(2) -- 是否可循环
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
grant select on ${iol_schema}.icms_upl_credit_info to ${iml_schema};
grant select on ${iol_schema}.icms_upl_credit_info to ${icl_schema};
grant select on ${iol_schema}.icms_upl_credit_info to ${idl_schema};
grant select on ${iol_schema}.icms_upl_credit_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_upl_credit_info is '微贷额度信息表';
comment on column ${iol_schema}.icms_upl_credit_info.serialno is '额度编号';
comment on column ${iol_schema}.icms_upl_credit_info.currency is '币种';
comment on column ${iol_schema}.icms_upl_credit_info.inputuser is '登记用户';
comment on column ${iol_schema}.icms_upl_credit_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_upl_credit_info.usedcreditsum is '已使用的他用额度';
comment on column ${iol_schema}.icms_upl_credit_info.status is '额度状态';
comment on column ${iol_schema}.icms_upl_credit_info.inputorg is '登记机构';
comment on column ${iol_schema}.icms_upl_credit_info.migtflag is '';
comment on column ${iol_schema}.icms_upl_credit_info.creditsum is '他用额度总额';
comment on column ${iol_schema}.icms_upl_credit_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_upl_credit_info.creditbalance is '可用的他用额度';
comment on column ${iol_schema}.icms_upl_credit_info.frozcredit is '冻结的他用额度';
comment on column ${iol_schema}.icms_upl_credit_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_upl_credit_info.cycleflag is '是否可循环';
comment on column ${iol_schema}.icms_upl_credit_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_upl_credit_info.etl_timestamp is 'ETL处理时间戳';
