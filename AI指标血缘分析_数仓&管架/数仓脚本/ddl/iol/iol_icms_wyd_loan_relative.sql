/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_loan_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_loan_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_loan_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_loan_relative(
    lendingref varchar2(64) -- 借据号
    ,relativelendingref varchar2(64) -- 关联借据号
    ,businesstype varchar2(10) -- 业务类型
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
grant select on ${iol_schema}.icms_wyd_loan_relative to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_loan_relative to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_loan_relative to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_loan_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_loan_relative is '借据信息关联表';
comment on column ${iol_schema}.icms_wyd_loan_relative.lendingref is '借据号';
comment on column ${iol_schema}.icms_wyd_loan_relative.relativelendingref is '关联借据号';
comment on column ${iol_schema}.icms_wyd_loan_relative.businesstype is '业务类型';
comment on column ${iol_schema}.icms_wyd_loan_relative.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_loan_relative.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_loan_relative.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_loan_relative.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_loan_relative.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_loan_relative.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_loan_relative.customerid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_loan_relative.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_loan_relative.classifyresult is '废除五级分类';
comment on column ${iol_schema}.icms_wyd_loan_relative.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_loan_relative.etl_timestamp is 'ETL处理时间戳';
