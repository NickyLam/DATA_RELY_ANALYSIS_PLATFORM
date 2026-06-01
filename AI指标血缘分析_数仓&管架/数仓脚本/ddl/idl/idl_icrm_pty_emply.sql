/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_pty_emply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_pty_emply
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_pty_emply purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_pty_emply(
    etl_dt date -- 数据日期
    ,emply_id varchar2(60) -- 员工编号
    ,region_acct_num varchar2(60) -- 域账号
    ,first_name varchar2(100) -- 名字
    ,last_name varchar2(100) -- 姓氏
    ,cert_type_cd varchar2(10) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,gender_cd varchar2(10) -- 性别代码
    ,birth_dt date -- 出生日期
    ,nationty_cd varchar2(10) -- 民族代码
    ,politic_status_cd varchar2(10) -- 政治面貌代码
    ,marriage_situ_cd varchar2(10) -- 婚姻状况代码
    ,edu_cd varchar2(10) -- 学历代码
    ,join_work_dt date -- 参加工作日期
    ,teller_pic_name varchar2(100) -- 柜员图片名称
    ,emply_type_cd varchar2(10) -- 员工类型代码
    ,belong_dept_id varchar2(60) -- 所属部门编号
    ,postn_cd varchar2(10) -- 职位代码
    ,teller_belong_org_id varchar2(60) -- 柜员所属机构编号
    ,empyt_dt date -- 入职日期
    ,dimission_dt date -- 离职日期
    ,emply_status_cd varchar2(10) -- 员工状态代码
    ,emply_sys_status_cd varchar2(10) -- 员工系统状态代码
    ,fax_dom_area_cd varchar2(60) -- 传真国内区号
    ,fax_num varchar2(60) -- 传真号码
    ,work_tel_dom_area_cd varchar2(60) -- 单位电话国内区号
    ,work_tel_num varchar2(60) -- 单位电话号码
    ,mobile_phone_num varchar2(60) -- 移动电话号码
    ,mobile_phone_num_2 varchar2(60) -- 移动电话号码2
    ,cty_cd varchar2(10) -- 国家代码
    ,resd_addr varchar2(100) -- 住宅地址
    ,e_mail varchar2(100) -- 电子邮箱
    ,salary_lev_cd varchar2(10) -- 薪资级别代码
    ,dsply_seq_num varchar2(60) -- 显示顺序号
    ,vtual_accti_dept_id varchar2(60) -- 虚拟核算部门编号
    ,modif_dt date -- 修改日期
    ,subsidy_distr_dt date -- 补贴发放日期
    ,ding_talk_user_id varchar2(60) -- 钉钉用户编号
    ,post_cd varchar2(10) -- 职务代码
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_pty_emply to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_pty_emply is '员工';
comment on column ${idl_schema}.icrm_pty_emply.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_pty_emply.emply_id is '员工编号';
comment on column ${idl_schema}.icrm_pty_emply.region_acct_num is '域账号';
comment on column ${idl_schema}.icrm_pty_emply.first_name is '名字';
comment on column ${idl_schema}.icrm_pty_emply.last_name is '姓氏';
comment on column ${idl_schema}.icrm_pty_emply.cert_type_cd is '证件类型代码';
comment on column ${idl_schema}.icrm_pty_emply.cert_no is '证件号码';
comment on column ${idl_schema}.icrm_pty_emply.gender_cd is '性别代码';
comment on column ${idl_schema}.icrm_pty_emply.birth_dt is '出生日期';
comment on column ${idl_schema}.icrm_pty_emply.nationty_cd is '民族代码';
comment on column ${idl_schema}.icrm_pty_emply.politic_status_cd is '政治面貌代码';
comment on column ${idl_schema}.icrm_pty_emply.marriage_situ_cd is '婚姻状况代码';
comment on column ${idl_schema}.icrm_pty_emply.edu_cd is '学历代码';
comment on column ${idl_schema}.icrm_pty_emply.join_work_dt is '参加工作日期';
comment on column ${idl_schema}.icrm_pty_emply.teller_pic_name is '柜员图片名称';
comment on column ${idl_schema}.icrm_pty_emply.emply_type_cd is '员工类型代码';
comment on column ${idl_schema}.icrm_pty_emply.belong_dept_id is '所属部门编号';
comment on column ${idl_schema}.icrm_pty_emply.postn_cd is '职位代码';
comment on column ${idl_schema}.icrm_pty_emply.teller_belong_org_id is '柜员所属机构编号';
comment on column ${idl_schema}.icrm_pty_emply.empyt_dt is '入职日期';
comment on column ${idl_schema}.icrm_pty_emply.dimission_dt is '离职日期';
comment on column ${idl_schema}.icrm_pty_emply.emply_status_cd is '员工状态代码';
comment on column ${idl_schema}.icrm_pty_emply.emply_sys_status_cd is '员工系统状态代码';
comment on column ${idl_schema}.icrm_pty_emply.fax_dom_area_cd is '传真国内区号';
comment on column ${idl_schema}.icrm_pty_emply.fax_num is '传真号码';
comment on column ${idl_schema}.icrm_pty_emply.work_tel_dom_area_cd is '单位电话国内区号';
comment on column ${idl_schema}.icrm_pty_emply.work_tel_num is '单位电话号码';
comment on column ${idl_schema}.icrm_pty_emply.mobile_phone_num is '移动电话号码';
comment on column ${idl_schema}.icrm_pty_emply.mobile_phone_num_2 is '移动电话号码2';
comment on column ${idl_schema}.icrm_pty_emply.cty_cd is '国家代码';
comment on column ${idl_schema}.icrm_pty_emply.resd_addr is '住宅地址';
comment on column ${idl_schema}.icrm_pty_emply.e_mail is '电子邮箱';
comment on column ${idl_schema}.icrm_pty_emply.salary_lev_cd is '薪资级别代码';
comment on column ${idl_schema}.icrm_pty_emply.dsply_seq_num is '显示顺序号';
comment on column ${idl_schema}.icrm_pty_emply.vtual_accti_dept_id is '虚拟核算部门编号';
comment on column ${idl_schema}.icrm_pty_emply.modif_dt is '修改日期';
comment on column ${idl_schema}.icrm_pty_emply.subsidy_distr_dt is '补贴发放日期';
comment on column ${idl_schema}.icrm_pty_emply.ding_talk_user_id is '钉钉用户编号';
comment on column ${idl_schema}.icrm_pty_emply.post_cd is '职务代码';
comment on column ${idl_schema}.icrm_pty_emply.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_pty_emply.etl_timestamp is '数据处理时间';
