/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t2f_staff
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t2f_staff
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t2f_staff purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2f_staff(
    staf_id varchar2(96) -- 员工编号
    ,opr_id varchar2(48) -- 柜员编号
    ,staf_name varchar2(144) -- 员工姓名
    ,cust_id varchar2(48) -- 员工客户编号
    ,org_id varchar2(30) -- 机构编号
    ,dept varchar2(150) -- 所属部门
    ,staf_lvl varchar2(2) -- 员工级别
    ,staf_duty varchar2(48) -- 员工职务
    ,staf_tel varchar2(30) -- 联系电话
    ,cert_type varchar2(264) -- 证件类型
    ,cert_no varchar2(192) -- 证件号码
    ,entry_dt varchar2(15) -- 入职日期
    ,leave_dt varchar2(15) -- 离职日期
    ,sex varchar2(6) -- 性别
    ,marriage varchar2(6) -- 婚姻
    ,politic varchar2(96) -- 政治面貌
    ,post_name varchar2(150) -- 岗位
    ,work_dt varchar2(15) -- 参加日期
    ,rsrv_01 varchar2(48) -- 备用字段1-员工类型
    ,rsrv_02 varchar2(48) -- 备用字段2
    ,rsrv_03 varchar2(96) -- 备用字段3
    ,rsrv_04 varchar2(96) -- 备用字段4
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
grant select on ${iol_schema}.amls_t2f_staff to ${iml_schema};
grant select on ${iol_schema}.amls_t2f_staff to ${icl_schema};
grant select on ${iol_schema}.amls_t2f_staff to ${idl_schema};
grant select on ${iol_schema}.amls_t2f_staff to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t2f_staff is 'T2F_员工信息表';
comment on column ${iol_schema}.amls_t2f_staff.staf_id is '员工编号';
comment on column ${iol_schema}.amls_t2f_staff.opr_id is '柜员编号';
comment on column ${iol_schema}.amls_t2f_staff.staf_name is '员工姓名';
comment on column ${iol_schema}.amls_t2f_staff.cust_id is '员工客户编号';
comment on column ${iol_schema}.amls_t2f_staff.org_id is '机构编号';
comment on column ${iol_schema}.amls_t2f_staff.dept is '所属部门';
comment on column ${iol_schema}.amls_t2f_staff.staf_lvl is '员工级别';
comment on column ${iol_schema}.amls_t2f_staff.staf_duty is '员工职务';
comment on column ${iol_schema}.amls_t2f_staff.staf_tel is '联系电话';
comment on column ${iol_schema}.amls_t2f_staff.cert_type is '证件类型';
comment on column ${iol_schema}.amls_t2f_staff.cert_no is '证件号码';
comment on column ${iol_schema}.amls_t2f_staff.entry_dt is '入职日期';
comment on column ${iol_schema}.amls_t2f_staff.leave_dt is '离职日期';
comment on column ${iol_schema}.amls_t2f_staff.sex is '性别';
comment on column ${iol_schema}.amls_t2f_staff.marriage is '婚姻';
comment on column ${iol_schema}.amls_t2f_staff.politic is '政治面貌';
comment on column ${iol_schema}.amls_t2f_staff.post_name is '岗位';
comment on column ${iol_schema}.amls_t2f_staff.work_dt is '参加日期';
comment on column ${iol_schema}.amls_t2f_staff.rsrv_01 is '备用字段1-员工类型';
comment on column ${iol_schema}.amls_t2f_staff.rsrv_02 is '备用字段2';
comment on column ${iol_schema}.amls_t2f_staff.rsrv_03 is '备用字段3';
comment on column ${iol_schema}.amls_t2f_staff.rsrv_04 is '备用字段4';
comment on column ${iol_schema}.amls_t2f_staff.start_dt is '开始时间';
comment on column ${iol_schema}.amls_t2f_staff.end_dt is '结束时间';
comment on column ${iol_schema}.amls_t2f_staff.id_mark is '增删标志';
comment on column ${iol_schema}.amls_t2f_staff.etl_timestamp is 'ETL处理时间戳';
