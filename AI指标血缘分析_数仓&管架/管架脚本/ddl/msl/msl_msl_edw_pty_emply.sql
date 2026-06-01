/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pty_emply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pty_emply
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pty_emply purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pty_emply(
    etl_dt date
    ,emply_id varchar2(60)
    ,region_acct_num varchar2(60)
    ,first_name varchar2(500)
    ,last_name varchar2(500)
    ,cert_type_cd varchar2(10)
    ,cert_no varchar2(60)
    ,gender_cd varchar2(10)
    ,birth_dt date
    ,nationty_cd varchar2(10)
    ,politic_status_cd varchar2(10)
    ,marriage_situ_cd varchar2(10)
    ,edu_cd varchar2(10)
    ,join_work_dt date
    ,teller_pic_name varchar2(500)
    ,emply_type_cd varchar2(10)
    ,belong_dept_id varchar2(60)
    ,postn_cd varchar2(30)
    ,teller_belong_org_id varchar2(60)
    ,empyt_dt date
    ,dimission_dt date
    ,emply_status_cd varchar2(10)
    ,emply_sys_status_cd varchar2(10)
    ,fax_dom_area_cd varchar2(60)
    ,fax_num varchar2(60)
    ,work_tel_dom_area_cd varchar2(60)
    ,work_tel_num varchar2(60)
    ,mobile_phone_num varchar2(60)
    ,mobile_phone_num_2 varchar2(60)
    ,cty_cd varchar2(10)
    ,resd_addr varchar2(500)
    ,e_mail varchar2(100)
    ,salary_lev_cd varchar2(10)
    ,dsply_seq_num varchar2(60)
    ,vtual_accti_dept_id varchar2(60)
    ,modif_dt date
    ,subsidy_distr_dt date
    ,ding_talk_user_id varchar2(60)
    ,post_cd varchar2(30)
    ,lp_id varchar2(60)
    ,main_teller_id varchar2(60)
    ,title_cd varchar2(30)
    ,party_id varchar2(60)
    ,create_dt date
    ,update_dt date
    ,id_mark varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pty_emply to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pty_emply is '员工';
comment on column ${msl_schema}.msl_edw_pty_emply.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pty_emply.emply_id is '员工编号';
comment on column ${msl_schema}.msl_edw_pty_emply.region_acct_num is '域账号';
comment on column ${msl_schema}.msl_edw_pty_emply.first_name is '名字';
comment on column ${msl_schema}.msl_edw_pty_emply.last_name is '姓氏';
comment on column ${msl_schema}.msl_edw_pty_emply.cert_type_cd is '证件类型代码';
comment on column ${msl_schema}.msl_edw_pty_emply.cert_no is '证件号码';
comment on column ${msl_schema}.msl_edw_pty_emply.gender_cd is '性别代码';
comment on column ${msl_schema}.msl_edw_pty_emply.birth_dt is '出生日期';
comment on column ${msl_schema}.msl_edw_pty_emply.nationty_cd is '民族代码';
comment on column ${msl_schema}.msl_edw_pty_emply.politic_status_cd is '政治面貌代码';
comment on column ${msl_schema}.msl_edw_pty_emply.marriage_situ_cd is '婚姻状况代码';
comment on column ${msl_schema}.msl_edw_pty_emply.edu_cd is '学历代码';
comment on column ${msl_schema}.msl_edw_pty_emply.join_work_dt is '参加工作日期';
comment on column ${msl_schema}.msl_edw_pty_emply.teller_pic_name is '柜员图片名称';
comment on column ${msl_schema}.msl_edw_pty_emply.emply_type_cd is '员工类型代码';
comment on column ${msl_schema}.msl_edw_pty_emply.belong_dept_id is '所属部门编号';
comment on column ${msl_schema}.msl_edw_pty_emply.postn_cd is '职位代码';
comment on column ${msl_schema}.msl_edw_pty_emply.teller_belong_org_id is '柜员所属机构编号';
comment on column ${msl_schema}.msl_edw_pty_emply.empyt_dt is '入职日期';
comment on column ${msl_schema}.msl_edw_pty_emply.dimission_dt is '离职日期';
comment on column ${msl_schema}.msl_edw_pty_emply.emply_status_cd is '员工状态代码';
comment on column ${msl_schema}.msl_edw_pty_emply.emply_sys_status_cd is '员工系统状态代码';
comment on column ${msl_schema}.msl_edw_pty_emply.fax_dom_area_cd is '传真国内区号';
comment on column ${msl_schema}.msl_edw_pty_emply.fax_num is '传真号码';
comment on column ${msl_schema}.msl_edw_pty_emply.work_tel_dom_area_cd is '单位电话国内区号';
comment on column ${msl_schema}.msl_edw_pty_emply.work_tel_num is '单位电话号码';
comment on column ${msl_schema}.msl_edw_pty_emply.mobile_phone_num is '移动电话号码';
comment on column ${msl_schema}.msl_edw_pty_emply.mobile_phone_num_2 is '移动电话号码2';
comment on column ${msl_schema}.msl_edw_pty_emply.cty_cd is '国家代码';
comment on column ${msl_schema}.msl_edw_pty_emply.resd_addr is '住宅地址';
comment on column ${msl_schema}.msl_edw_pty_emply.e_mail is '电子邮箱';
comment on column ${msl_schema}.msl_edw_pty_emply.salary_lev_cd is '薪资级别代码';
comment on column ${msl_schema}.msl_edw_pty_emply.dsply_seq_num is '显示顺序号';
comment on column ${msl_schema}.msl_edw_pty_emply.vtual_accti_dept_id is '虚拟核算部门编号';
comment on column ${msl_schema}.msl_edw_pty_emply.modif_dt is '修改日期';
comment on column ${msl_schema}.msl_edw_pty_emply.subsidy_distr_dt is '补贴发放日期';
comment on column ${msl_schema}.msl_edw_pty_emply.ding_talk_user_id is '钉钉用户编号';
comment on column ${msl_schema}.msl_edw_pty_emply.post_cd is '职务代码';
comment on column ${msl_schema}.msl_edw_pty_emply.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_pty_emply.main_teller_id is '主柜员编号';
comment on column ${msl_schema}.msl_edw_pty_emply.title_cd is '职称代码';
comment on column ${msl_schema}.msl_edw_pty_emply.party_id is '当事人编号';
comment on column ${msl_schema}.msl_edw_pty_emply.create_dt is '创建日期';
comment on column ${msl_schema}.msl_edw_pty_emply.update_dt is '更新日期';
comment on column ${msl_schema}.msl_edw_pty_emply.id_mark is '删除标识';
