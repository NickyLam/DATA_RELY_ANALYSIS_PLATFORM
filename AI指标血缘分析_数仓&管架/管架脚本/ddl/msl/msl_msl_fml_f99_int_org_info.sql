/*
Purpose: 技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author: Sunline
Usage: python $ETL_HOME/script/init.py msl msl_fml_f99_int_org_info
CreateDate: 20180515
FileType: DDL
Logs:
 zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_fml_f99_int_org_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_fml_f99_int_org_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_fml_f99_int_org_info(
    ETL_DT DATE
    ,LP_ID VARCHAR2(60)
    ,ORG_ID VARCHAR2(60)
    ,ORG_NAME VARCHAR2(200)
    ,ORG_ABBR VARCHAR2(200)
    ,PRINC_EMPLY_ID VARCHAR2(60)
    ,CBRC_FIN_INST_ID VARCHAR2(60)
    ,UNIONPAY_FIN_INST_ID VARCHAR2(60)
    ,FIN_INST_IDF_CODE VARCHAR2(60)
    ,BUS_LICS_NUM VARCHAR2(60)
    ,FIN_LICS_NUM VARCHAR2(60)
    ,PBC_PAY_BANK_NO VARCHAR2(60)
    ,FIN_INST_CODE VARCHAR2(60)
    ,HQ_ORG_ID VARCHAR2(60)
    ,HQ_ORG_NAME VARCHAR2(200)
    ,BRCH_ID VARCHAR2(60)
    ,BRCH_NAME VARCHAR2(200)
    ,SUBRCH_ID VARCHAR2(60)
    ,SUBRCH_NAME VARCHAR2(200)
    ,ORG_TYPE_CD VARCHAR2(10)
    ,ORG_LEV_CD VARCHAR2(10)
    ,ORG_HIBCHY_CD VARCHAR2(10)
    ,ORG_STATUS_CD VARCHAR2(10)
    ,BUS_STATUS_CD VARCHAR2(10)
    ,BUS_ORG_FLG VARCHAR2(10)
    ,ENTY_ORG_FLG VARCHAR2(10)
    ,ACCTI_ORG_FLG VARCHAR2(10)
    ,ADMIN_ORG_FLG VARCHAR2(10)
    ,ACCT_INSTIT_FLG VARCHAR2(10)
    ,VTUAL_ACCTI_ORG_FLG VARCHAR2(10)
    ,ADMIN_SUPER_ORG_ID VARCHAR2(60)
    ,ACCT_SUPER_ORG_ID VARCHAR2(60)
    ,ACCTI_SUPER_ORG_ID VARCHAR2(60)
    ,FUNC_ORG_ID VARCHAR2(60)
    ,FUNC_DEPT_ID VARCHAR2(60)
    ,CTY_RG_CD VARCHAR2(10)
    ,PROV_CD VARCHAR2(10)
    ,CITY_CD VARCHAR2(10)
    ,COUNTY_CD VARCHAR2(10)
    ,PHYS_ADDR VARCHAR2(500)
    ,DDD_AREA_CD VARCHAR2(10)
    ,PHONE VARCHAR2(60)
    ,ZIP_CD VARCHAR2(60)
    ,ORG_FOUND_DT DATE
    ,ORG_REVO_DT DATE
    ,ORG_START_BUS_TM VARCHAR2(6)
    ,ORG_END_BUS_TM VARCHAR2(6)

)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
-- grant select on ${msl_schema}.msl_fml_f99_int_org_info to itl;

-- comment
comment on table ${msl_schema}.msl_fml_f99_int_org_info is 'FML_F99_内部机构信息';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.LP_ID is '法人编号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ORG_ID is '机构编号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ORG_NAME is '机构名称';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ORG_ABBR is '机构简称';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.PRINC_EMPLY_ID is '负责人员工编号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.CBRC_FIN_INST_ID is '银监会金融机构编号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.UNIONPAY_FIN_INST_ID is '银联金融机构编号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.FIN_INST_IDF_CODE is '金融机构标识码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.BUS_LICS_NUM is '营业执照号码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.FIN_LICS_NUM is '金融许可证号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.PBC_PAY_BANK_NO is '人行支付行号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.FIN_INST_CODE is '金融机构编码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.HQ_ORG_ID is '总行机构编号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.HQ_ORG_NAME is '总行机构名称';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.BRCH_ID is '分行编号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.BRCH_NAME is '分行名称';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.SUBRCH_ID is '支行编号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.SUBRCH_NAME is '支行名称';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ORG_TYPE_CD is '机构类型代码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ORG_LEV_CD is '机构级别代码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ORG_HIBCHY_CD is '机构层级代码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ORG_STATUS_CD is '机构状态代码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.BUS_STATUS_CD is '营业状态代码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.BUS_ORG_FLG is '营业机构标志';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ENTY_ORG_FLG is '实体机构标志';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ACCTI_ORG_FLG is '核算机构标志';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ADMIN_ORG_FLG is '行政机构标志';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ACCT_INSTIT_FLG is '账务机构标志';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.VTUAL_ACCTI_ORG_FLG is '虚拟核算机构标志';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ADMIN_SUPER_ORG_ID is '行政上级机构编号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ACCT_SUPER_ORG_ID is '账务上级机构编号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ACCTI_SUPER_ORG_ID is '核算上级机构编号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.FUNC_ORG_ID is '职能机构编号' ;
comment on column ${msl_schema}.msl_fml_f99_int_org_info.FUNC_DEPT_ID is '职能部门编号' ;
comment on column ${msl_schema}.msl_fml_f99_int_org_info.CTY_RG_CD is '国家和地区代码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.PROV_CD is '省代码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.CITY_CD is '市代码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.COUNTY_CD is '县代码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.PHYS_ADDR is '物理地址';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.DDD_AREA_CD is '国内长途区号';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.PHONE is '联系电话';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ZIP_CD is '邮政编码';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ORG_FOUND_DT is '机构成立日期';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ORG_REVO_DT is '机构撤销日期';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ORG_START_BUS_TM is '机构开始营业时间';
comment on column ${msl_schema}.msl_fml_f99_int_org_info.ORG_END_BUS_TM is '机构结束营业时间';
