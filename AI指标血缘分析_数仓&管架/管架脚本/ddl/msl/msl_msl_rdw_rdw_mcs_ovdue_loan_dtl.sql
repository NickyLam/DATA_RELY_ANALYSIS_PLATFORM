/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_rdw_rdw_mcs_ovdue_loan_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl
whenever sqlerror continue none;
drop table ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl(
    etl_dt date
    ,belong_brch varchar2(200)
    ,asset_cate varchar2(50)
    ,cust_name varchar2(200)
    ,belong_group varchar2(500)
    ,bus_breed varchar2(500)
    ,bus_bal number(28,4)
    ,ovdue_happ_dt varchar2(50)
    ,ovdue_days varchar2(50)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl is '管理驾驶舱逾期贷款明细';
comment on column ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl.belong_brch is '所属分行';
comment on column ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl.asset_cate is '资产类别';
comment on column ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl.cust_name is '客户名称';
comment on column ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl.belong_group is '所属集团';
comment on column ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl.bus_breed is '业务品种';
comment on column ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl.bus_bal is '业务余额';
comment on column ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl.ovdue_happ_dt is '逾期发生日期';
comment on column ${msl_schema}.msl_rdw_rdw_mcs_ovdue_loan_dtl.ovdue_days is '逾期天数';
