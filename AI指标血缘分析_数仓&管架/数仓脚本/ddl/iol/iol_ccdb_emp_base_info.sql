/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccdb_emp_base_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccdb_emp_base_info
whenever sqlerror continue none;
drop table ${iol_schema}.ccdb_emp_base_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_emp_base_info(
    code varchar2(30) -- 员工编号
    ,name varchar2(50) -- 员工姓名
    ,idcard_type varchar2(4) -- 员工证件类型
    ,idcard varchar2(30) -- 员工证件号
    ,gender varchar2(4) -- 性别
    ,birthday date -- 生日日期
    ,org_code varchar2(500) -- 组织机构二级code
    ,brithplace varchar2(100) -- 出生地
    ,national varchar2(20) -- 籍贯
    ,home_tel varchar2(20) -- 家庭电话
    ,office_tel varchar2(20) -- 办公电话
    ,phone varchar2(200) -- 手机
    ,email varchar2(50) -- 电子邮箱
    ,duty_id number(22) -- 职务id
    ,create_date date -- 创建日期
    ,update_date date -- 更新日期
    ,leave_date date -- 离职日期
    ,status varchar2(4) -- 状态
    ,is_real_name varchar2(4) -- 是否真实名字 0:no 1:yes
    ,bg_img_path varchar2(100) -- 个人信息板块背景图路径
    ,personal_motto varchar2(200) -- 个性签名
    ,org_id number(22) -- 组织机构id(使用orgcode代替)
    ,remark varchar2(200) -- 备注
    ,is_lead varchar2(4) -- 是否领导(1:否 2:是)
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
grant select on ${iol_schema}.ccdb_emp_base_info to ${iml_schema};
grant select on ${iol_schema}.ccdb_emp_base_info to ${icl_schema};
grant select on ${iol_schema}.ccdb_emp_base_info to ${idl_schema};
grant select on ${iol_schema}.ccdb_emp_base_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ccdb_emp_base_info is '员工基础信息表';
comment on column ${iol_schema}.ccdb_emp_base_info.code is '员工编号';
comment on column ${iol_schema}.ccdb_emp_base_info.name is '员工姓名';
comment on column ${iol_schema}.ccdb_emp_base_info.idcard_type is '员工证件类型';
comment on column ${iol_schema}.ccdb_emp_base_info.idcard is '员工证件号';
comment on column ${iol_schema}.ccdb_emp_base_info.gender is '性别';
comment on column ${iol_schema}.ccdb_emp_base_info.birthday is '生日日期';
comment on column ${iol_schema}.ccdb_emp_base_info.org_code is '组织机构二级code';
comment on column ${iol_schema}.ccdb_emp_base_info.brithplace is '出生地';
comment on column ${iol_schema}.ccdb_emp_base_info.national is '籍贯';
comment on column ${iol_schema}.ccdb_emp_base_info.home_tel is '家庭电话';
comment on column ${iol_schema}.ccdb_emp_base_info.office_tel is '办公电话';
comment on column ${iol_schema}.ccdb_emp_base_info.phone is '手机';
comment on column ${iol_schema}.ccdb_emp_base_info.email is '电子邮箱';
comment on column ${iol_schema}.ccdb_emp_base_info.duty_id is '职务id';
comment on column ${iol_schema}.ccdb_emp_base_info.create_date is '创建日期';
comment on column ${iol_schema}.ccdb_emp_base_info.update_date is '更新日期';
comment on column ${iol_schema}.ccdb_emp_base_info.leave_date is '离职日期';
comment on column ${iol_schema}.ccdb_emp_base_info.status is '状态';
comment on column ${iol_schema}.ccdb_emp_base_info.is_real_name is '是否真实名字 0:no 1:yes';
comment on column ${iol_schema}.ccdb_emp_base_info.bg_img_path is '个人信息板块背景图路径';
comment on column ${iol_schema}.ccdb_emp_base_info.personal_motto is '个性签名';
comment on column ${iol_schema}.ccdb_emp_base_info.org_id is '组织机构id(使用orgcode代替)';
comment on column ${iol_schema}.ccdb_emp_base_info.remark is '备注';
comment on column ${iol_schema}.ccdb_emp_base_info.is_lead is '是否领导(1:否 2:是)';
comment on column ${iol_schema}.ccdb_emp_base_info.start_dt is '开始时间';
comment on column ${iol_schema}.ccdb_emp_base_info.end_dt is '结束时间';
comment on column ${iol_schema}.ccdb_emp_base_info.id_mark is '增删标志';
comment on column ${iol_schema}.ccdb_emp_base_info.etl_timestamp is 'ETL处理时间戳';
