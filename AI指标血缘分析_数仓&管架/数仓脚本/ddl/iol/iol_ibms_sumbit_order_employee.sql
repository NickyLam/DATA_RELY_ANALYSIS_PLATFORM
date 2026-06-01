/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_sumbit_order_employee
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_sumbit_order_employee
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_sumbit_order_employee purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_sumbit_order_employee(
    assetno varchar2(186) -- 资产唯一标识
    ,createdate varchar2(113) -- 创建时间
    ,employee_card_no varchar2(12) -- 员工编号
    ,obj_id varchar2(45) -- 对象id
    ,employee_card_no2 varchar2(12) -- 总行经办人
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
grant select on ${iol_schema}.ibms_sumbit_order_employee to ${iml_schema};
grant select on ${iol_schema}.ibms_sumbit_order_employee to ${icl_schema};
grant select on ${iol_schema}.ibms_sumbit_order_employee to ${idl_schema};
grant select on ${iol_schema}.ibms_sumbit_order_employee to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_sumbit_order_employee is '首期交易出账审批单提交人员工号';
comment on column ${iol_schema}.ibms_sumbit_order_employee.assetno is '资产唯一标识';
comment on column ${iol_schema}.ibms_sumbit_order_employee.createdate is '创建时间';
comment on column ${iol_schema}.ibms_sumbit_order_employee.employee_card_no is '员工编号';
comment on column ${iol_schema}.ibms_sumbit_order_employee.obj_id is '对象id';
comment on column ${iol_schema}.ibms_sumbit_order_employee.employee_card_no2 is '总行经办人';
comment on column ${iol_schema}.ibms_sumbit_order_employee.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_sumbit_order_employee.etl_timestamp is 'ETL处理时间戳';
