/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cms_emp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cms_emp
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cms_emp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_emp(
    emp_id number(10,0) -- 员工ID.
    ,emp_code varchar2(32) -- 员工编号.渠道业务员、商户收银员的员工编号由系统生成,为其登录用户名;银行员工的编码由银行在界面上录入,可以不填
    ,emp_name varchar2(64) -- 员工姓名.
    ,emp_sex number(4,0) -- 员工性别.1:男;2:女
    ,emp_type number(4,0) -- 员工类型.1:渠道业务员;2:商户收银员;3:银行员工;999:其他
    ,org_id varchar2(32) -- 所属机构.机构编号;值为渠道、商户、部门表的主键
    ,emp_dept_name varchar2(64) -- 员工部门名称.保存银行内部员工所属部门名称,跟部门表(CMS_DEPT)中的部门没有关系
    ,emp_position varchar2(64) -- 员工职务.
    ,mobile varchar2(64) -- 手机号码.
    ,id_code varchar2(128) -- 身份证.
    ,enabled number(1,0) -- 是否启用.
    ,remark varchar2(256) -- 备注.
    ,fld_s1 varchar2(256) -- (inviteCode)业务员邀请码
    ,fld_s2 varchar2(256) -- (empNo)员工工号
    ,fld_s3 varchar2(256) -- (operatorId)操作员id
    ,fld_n1 number(10,0) -- 数值型保留字段1.
    ,fld_n2 number(10,0) -- 数值型保留字段2.
    ,fld_n3 number(10,0) -- 数值型保留字段3.
    ,create_user number(10,0) -- 创建用户.
    ,create_emp varchar2(32) -- 创建人.
    ,create_time timestamp -- 创建时间.
    ,update_time timestamp -- 更新时间.
    ,email varchar2(64) -- 邮箱.
    ,physics_flag number(4,0) -- 物理标识.1:正常;2:删除
    ,authority_bit varchar2(32) -- 权限位.
    ,emp_serial varchar2(32) -- 员工序列
    ,teller_id varchar2(30) -- 
    ,admin_flag number(10,0) -- 是否是管理员，0：否，1：是
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
grant select on ${iol_schema}.amss_cms_emp to ${iml_schema};
grant select on ${iol_schema}.amss_cms_emp to ${icl_schema};
grant select on ${iol_schema}.amss_cms_emp to ${idl_schema};
grant select on ${iol_schema}.amss_cms_emp to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cms_emp is '员工资料表';
comment on column ${iol_schema}.amss_cms_emp.emp_id is '员工ID.';
comment on column ${iol_schema}.amss_cms_emp.emp_code is '员工编号.渠道业务员、商户收银员的员工编号由系统生成,为其登录用户名;银行员工的编码由银行在界面上录入,可以不填';
comment on column ${iol_schema}.amss_cms_emp.emp_name is '员工姓名.';
comment on column ${iol_schema}.amss_cms_emp.emp_sex is '员工性别.1:男;2:女';
comment on column ${iol_schema}.amss_cms_emp.emp_type is '员工类型.1:渠道业务员;2:商户收银员;3:银行员工;999:其他';
comment on column ${iol_schema}.amss_cms_emp.org_id is '所属机构.机构编号;值为渠道、商户、部门表的主键';
comment on column ${iol_schema}.amss_cms_emp.emp_dept_name is '员工部门名称.保存银行内部员工所属部门名称,跟部门表(CMS_DEPT)中的部门没有关系';
comment on column ${iol_schema}.amss_cms_emp.emp_position is '员工职务.';
comment on column ${iol_schema}.amss_cms_emp.mobile is '手机号码.';
comment on column ${iol_schema}.amss_cms_emp.id_code is '身份证.';
comment on column ${iol_schema}.amss_cms_emp.enabled is '是否启用.';
comment on column ${iol_schema}.amss_cms_emp.remark is '备注.';
comment on column ${iol_schema}.amss_cms_emp.fld_s1 is '(inviteCode)业务员邀请码';
comment on column ${iol_schema}.amss_cms_emp.fld_s2 is '(empNo)员工工号';
comment on column ${iol_schema}.amss_cms_emp.fld_s3 is '(operatorId)操作员id';
comment on column ${iol_schema}.amss_cms_emp.fld_n1 is '数值型保留字段1.';
comment on column ${iol_schema}.amss_cms_emp.fld_n2 is '数值型保留字段2.';
comment on column ${iol_schema}.amss_cms_emp.fld_n3 is '数值型保留字段3.';
comment on column ${iol_schema}.amss_cms_emp.create_user is '创建用户.';
comment on column ${iol_schema}.amss_cms_emp.create_emp is '创建人.';
comment on column ${iol_schema}.amss_cms_emp.create_time is '创建时间.';
comment on column ${iol_schema}.amss_cms_emp.update_time is '更新时间.';
comment on column ${iol_schema}.amss_cms_emp.email is '邮箱.';
comment on column ${iol_schema}.amss_cms_emp.physics_flag is '物理标识.1:正常;2:删除';
comment on column ${iol_schema}.amss_cms_emp.authority_bit is '权限位.';
comment on column ${iol_schema}.amss_cms_emp.emp_serial is '员工序列';
comment on column ${iol_schema}.amss_cms_emp.teller_id is '';
comment on column ${iol_schema}.amss_cms_emp.admin_flag is '是否是管理员，0：否，1：是';
comment on column ${iol_schema}.amss_cms_emp.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cms_emp.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cms_emp.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cms_emp.etl_timestamp is 'ETL处理时间戳';
