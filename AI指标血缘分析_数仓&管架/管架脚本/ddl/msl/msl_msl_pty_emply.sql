/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_pty_emply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_pty_emply
whenever sqlerror continue none;
drop table ${msl_schema}.msl_pty_emply purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_pty_emply(
    ETL_DT DATE
    ,EMPLY_ID VARCHAR2(60)
    ,REGION_ACCT_NUM VARCHAR2(60)
    ,FIRST_NAME VARCHAR2(100)
    ,LAST_NAME VARCHAR2(100)
    ,CERT_TYPE_CD VARCHAR2(10)
    ,CERT_NO VARCHAR2(60)
    ,GENDER_CD VARCHAR2(10)
    ,BIRTH_DT DATE
    ,NATIONTY_CD VARCHAR2(10)
    ,POLITIC_STATUS_CD VARCHAR2(10)
    ,MARRIAGE_SITU_CD VARCHAR2(10)
    ,EDU_CD VARCHAR2(10)
    ,JOIN_WORK_DT DATE
    ,TELLER_PIC_NAME VARCHAR2(100)
    ,EMPLY_TYPE_CD VARCHAR2(10)
    ,BELONG_DEPT_ID VARCHAR2(60)
    ,POSTN_CD VARCHAR2(10)
    ,TELLER_BELONG_ORG_ID VARCHAR2(60)
    ,EMPYT_DT DATE
    ,DIMISSION_DT DATE
    ,EMPLY_STATUS_CD VARCHAR2(10)
    ,EMPLY_SYS_STATUS_CD VARCHAR2(10)
    ,FAX_DOM_AREA_CD VARCHAR2(60)
    ,FAX_NUM VARCHAR2(60)
    ,WORK_TEL_DOM_AREA_CD VARCHAR2(60)
    ,WORK_TEL_NUM VARCHAR2(60)
    ,MOBILE_PHONE_NUM VARCHAR2(60)
    ,MOBILE_PHONE_NUM_2 VARCHAR2(60)
    ,CTY_CD VARCHAR2(10)
    ,RESD_ADDR VARCHAR2(100)
    ,E_MAIL VARCHAR2(100)
    ,SALARY_LEV_CD VARCHAR2(10)
    ,DSPLY_SEQ_NUM VARCHAR2(60)
    ,VTUAL_ACCTI_DEPT_ID VARCHAR2(60)
    ,MODIF_DT DATE
    ,SUBSIDY_DISTR_DT DATE
    ,DING_TALK_USER_ID VARCHAR2(60)
    ,POST_CD VARCHAR2(10)
    ,LP_ID VARCHAR2(60)
    ,MAIN_TELLER_ID VARCHAR2(60)
    ,TITLE_CD VARCHAR2(30)
    ,PARTY_ID VARCHAR2(60)
    ,CREATE_DT DATE
    ,UPDATE_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
-- grant select on ${msl_schema}.msl_pty_emply to itl;

-- comment
comment on table ${msl_schema}.msl_pty_emply is '员工';
comment on column ${msl_schema}.msl_pty_emply.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_pty_emply.EMPLY_ID is '员工编号';
comment on column ${msl_schema}.msl_pty_emply.REGION_ACCT_NUM is '域账号';
comment on column ${msl_schema}.msl_pty_emply.FIRST_NAME is '名字';
comment on column ${msl_schema}.msl_pty_emply.LAST_NAME is '姓氏';
comment on column ${msl_schema}.msl_pty_emply.CERT_TYPE_CD is '证件类型代码';
comment on column ${msl_schema}.msl_pty_emply.CERT_NO is '证件号码';
comment on column ${msl_schema}.msl_pty_emply.GENDER_CD is '性别代码';
comment on column ${msl_schema}.msl_pty_emply.BIRTH_DT is '出生日期';
comment on column ${msl_schema}.msl_pty_emply.NATIONTY_CD is '民族代码';
comment on column ${msl_schema}.msl_pty_emply.POLITIC_STATUS_CD is '政治面貌代码';
comment on column ${msl_schema}.msl_pty_emply.MARRIAGE_SITU_CD is '婚姻状况代码';
comment on column ${msl_schema}.msl_pty_emply.EDU_CD is '学历代码';
comment on column ${msl_schema}.msl_pty_emply.JOIN_WORK_DT is '参加工作日期';
comment on column ${msl_schema}.msl_pty_emply.TELLER_PIC_NAME is '柜员图片名称';
comment on column ${msl_schema}.msl_pty_emply.EMPLY_TYPE_CD is '员工类型代码';
comment on column ${msl_schema}.msl_pty_emply.BELONG_DEPT_ID is '所属部门编号';
comment on column ${msl_schema}.msl_pty_emply.POSTN_CD is '职位代码';
comment on column ${msl_schema}.msl_pty_emply.TELLER_BELONG_ORG_ID is '柜员所属机构编号';
comment on column ${msl_schema}.msl_pty_emply.EMPYT_DT is '入职日期';
comment on column ${msl_schema}.msl_pty_emply.DIMISSION_DT is '离职日期';
comment on column ${msl_schema}.msl_pty_emply.EMPLY_STATUS_CD is '员工状态代码';
comment on column ${msl_schema}.msl_pty_emply.EMPLY_SYS_STATUS_CD is '员工系统状态代码';
comment on column ${msl_schema}.msl_pty_emply.FAX_DOM_AREA_CD is '传真国内区号';
comment on column ${msl_schema}.msl_pty_emply.FAX_NUM is '传真号码';
comment on column ${msl_schema}.msl_pty_emply.WORK_TEL_DOM_AREA_CD is '单位电话国内区号';
comment on column ${msl_schema}.msl_pty_emply.WORK_TEL_NUM is '单位电话号码';
comment on column ${msl_schema}.msl_pty_emply.MOBILE_PHONE_NUM is '移动电话号码';
comment on column ${msl_schema}.msl_pty_emply.MOBILE_PHONE_NUM_2 is '移动电话号码2';
comment on column ${msl_schema}.msl_pty_emply.CTY_CD is '国家代码';
comment on column ${msl_schema}.msl_pty_emply.RESD_ADDR is '住宅地址';
comment on column ${msl_schema}.msl_pty_emply.E_MAIL is '电子邮箱';
comment on column ${msl_schema}.msl_pty_emply.SALARY_LEV_CD is '薪资级别代码';
comment on column ${msl_schema}.msl_pty_emply.DSPLY_SEQ_NUM is '显示顺序号';
comment on column ${msl_schema}.msl_pty_emply.VTUAL_ACCTI_DEPT_ID is '虚拟核算部门编号';
comment on column ${msl_schema}.msl_pty_emply.MODIF_DT is '修改日期';
comment on column ${msl_schema}.msl_pty_emply.SUBSIDY_DISTR_DT is '补贴发放日期';
comment on column ${msl_schema}.msl_pty_emply.DING_TALK_USER_ID is '钉钉用户编号';
comment on column ${msl_schema}.msl_pty_emply.POST_CD is '职务代码';
comment on column ${msl_schema}.msl_pty_emply.LP_ID is '法人编号';
comment on column ${msl_schema}.msl_pty_emply.MAIN_TELLER_ID is '主柜员编号';
comment on column ${msl_schema}.msl_pty_emply.TITLE_CD is '职称代码';
comment on column ${msl_schema}.msl_pty_emply.PARTY_ID is '当事人编号';
comment on column ${msl_schema}.msl_pty_emply.CREATE_DT is '创建日期';
comment on column ${msl_schema}.msl_pty_emply.UPDATE_DT is '更新日期';
comment on column ${msl_schema}.msl_pty_emply.ID_MARK is '删除标识';
