/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_cmm_clerk_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_cmm_clerk_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_cmm_clerk_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_cmm_clerk_info(
    etl_dt date
    ,lp_id varchar2(60)
    ,clerk_id varchar2(60)
    ,clerk_name varchar2(750)
    ,teller_flg varchar2(60)
    ,teller_id varchar2(60)
    ,region_acct_num varchar2(60)
    ,emply_type_cd varchar2(30)
    ,cert_type_cd varchar2(30)
    ,cert_no varchar2(60)
    ,gender_cd varchar2(30)
    ,birth_dt date
    ,nationty_cd varchar2(30)
    ,politic_status_cd varchar2(30)
    ,marriage_situ_cd varchar2(30)
    ,edu_cd varchar2(30)
    ,post_cd varchar2(30)
    ,title_cd varchar2(30)
    ,fir_work_dt date
    ,empyt_dt date
    ,local_dept_id varchar2(100)
    ,dimission_dt date
    ,emply_status_cd varchar2(60)
    ,emply_sys_status_cd varchar2(60)
    ,belong_org_id varchar2(100)
    ,work_tel_inter_area_cd varchar2(60)
    ,work_tel_area_cd varchar2(60)
    ,work_tel_num varchar2(250)
    ,fax_area_cd varchar2(60)
    ,fax_num varchar2(60)
    ,mobile_phone_num varchar2(60)
    ,cty_cd varchar2(100)
    ,dtl_addr varchar2(750)
    ,e_mail_addr varchar2(150)
    ,ding_talk_user_id varchar2(100)
    ,jobs_cd varchar2(10)
    ,jobs_cate varchar2(10)
    ,jobs_name varchar2(500)
    ,cust_mgr_flg varchar2(10)
    ,cust_mgr_lev varchar2(100)
    ,teller_lev_cd varchar2(30)
    ,teller_director_id varchar2(100)
    ,vtual_accti_org_id varchar2(100)
    ,work_tel_ext_num varchar2(100)
    ,fax_inter_area_cd varchar2(100)
    ,fax_ext_num varchar2(100)
    ,resd_tel_inter_area_cd varchar2(100)
    ,resd_tel_dom_area_cd varchar2(100)
    ,resd_tel varchar2(100)
    ,resd_tel_ext_num varchar2(100)
    ,mobile_phone_num_1 varchar2(100)
    ,mobile_phone_num_2 varchar2(100)
    ,mobile_phone_num_3 varchar2(100)
    ,zip_cd varchar2(100)
    ,local_prov varchar2(100)
    ,site varchar2(100)
    ,postn_cd varchar2(30)
    ,post_cate_id varchar2(60)
    ,post_name varchar2(150)
    ,jobs_id varchar2(100)
    ,jobs_descb varchar2(500)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_cmm_clerk_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_cmm_clerk_info is '行员信息表';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.clerk_id is '行员编号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.clerk_name is '行员名称';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.teller_flg is '柜员标志';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.teller_id is '柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.region_acct_num is '域账号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.emply_type_cd is '员工类型代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.cert_type_cd is '证件类型代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.cert_no is '证件号码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.gender_cd is '性别代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.birth_dt is '出生日期';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.nationty_cd is '民族代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.politic_status_cd is '政治面貌代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.marriage_situ_cd is '婚姻状况代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.edu_cd is '学历代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.post_cd is '职务代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.title_cd is '职称代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.fir_work_dt is '首次工作日期';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.empyt_dt is '入职日期';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.local_dept_id is '所在部门编号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.dimission_dt is '离职日期';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.emply_status_cd is '员工状态代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.emply_sys_status_cd is '员工系统状态代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.belong_org_id is '所属机构编号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.work_tel_inter_area_cd is '单位电话国际区号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.work_tel_area_cd is '单位电话区号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.work_tel_num is '单位电话号码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.fax_area_cd is '传真区号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.fax_num is '传真号码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.mobile_phone_num is '移动电话号码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.cty_cd is '国家代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.dtl_addr is '详细地址';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.e_mail_addr is '电子邮箱地址';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.ding_talk_user_id is '钉钉用户编号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.jobs_cd is '岗位代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.jobs_cate is '岗位类别';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.jobs_name is '岗位名称';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.cust_mgr_flg is '客户经理标志';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.cust_mgr_lev is '客户经理级别';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.teller_lev_cd is '柜员级别代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.teller_director_id is '柜员主管编号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.vtual_accti_org_id is '虚拟核算机构编号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.work_tel_ext_num is '单位电话分机号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.fax_inter_area_cd is '传真国际区号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.fax_ext_num is '传真分机号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.resd_tel_inter_area_cd is '住宅电话国际区号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.resd_tel_dom_area_cd is '住宅电话国内区号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.resd_tel is '住宅电话';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.resd_tel_ext_num is '住宅电话分机号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.mobile_phone_num_1 is '移动电话号码1';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.mobile_phone_num_2 is '移动电话号码2';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.mobile_phone_num_3 is '移动电话号码3';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.zip_cd is '邮政编码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.local_prov is '所在省份';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.site is '所在地区';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.postn_cd is '职位代码';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.post_cate_id is '职务类别编号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.post_name is '职务名称';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.jobs_id is '岗位编号';
comment on column ${msl_schema}.msl_edw_cmm_clerk_info.jobs_descb is '岗位描述';
