/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_corp_cust_rela_ps_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_corp_cust_rela_ps_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_cust_rela_ps_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_cust_rela_ps_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 客户编号
    ,rela_type_cd varchar2(20) -- 关联类型代码
    ,rela_ps_cust_id varchar2(100) -- 关联人客户编号
    ,rela_ps_id varchar2(100) -- 关联人编号
    ,rela_ps_name varchar2(750) -- 关联人姓名
    ,rela_ps_gender_cd varchar2(20) -- 关联人性别代码
    ,rela_ps_nation_cd varchar2(20) -- 关联人国别代码
    ,rela_ps_cert_type_cd varchar2(20) -- 关联人证件类型代码
    ,rela_ps_cert_no varchar2(60) -- 关联人证件号码
    ,rela_ps_cert_effect_dt date -- 关联人证件生效日期
    ,rela_ps_cert_exp_dt date -- 关联人证件到期日期
    ,rela_ps_higt_edu_cd varchar2(20) -- 关联人最高学历代码
    ,rela_ps_post_cd varchar2(100) -- 关联人职务代码
    ,rela_ps_senior_man_flg varchar2(10) -- 关联人高管标志
    ,rela_ps_shard_flg varchar2(10) -- 关联人股东标志
    ,legal_rep_flg varchar2(10) -- 法人代表标志
    ,rela_ps_tel_num varchar2(500) -- 关联人电话号码
    ,rela_ps_tel_ext_num varchar2(60) -- 关联人电话分机号码
    ,rela_ps_mobile_no varchar2(500) -- 关联人手机号码
    ,rela_ps_career_cd varchar2(20) -- 关联人职业代码
    ,rela_ps_title_level_cd varchar2(20) -- 关联人职称等级代码
    ,rela_ps_cont_addr varchar2(500) -- 关联人联系地址
    ,rela_ps_work_unit_name varchar2(500) -- 关联人工作单位名称
    ,rela_ps_work_unit_char_cd varchar2(500) -- 关联人工作单位性质代码
    ,rela_ps_work_unit_addr varchar2(1000) -- 关联人工作单位地址
    ,rela_ps_work_unit_tel_num varchar2(500) -- 关联人工作单位电话号码
    ,rela_ps_other_career_descb varchar2(500) -- 关联人其他职业描述
    ,rela_ps_mon_inco number(30,2) -- 关联人月收入
    ,rela_ps_open_acct_lics varchar2(60) -- 关联人开户许可证
    ,rela_ps_belong_group_num varchar2(60) -- 关联人所属集团号
    ,rela_ps_mang_tenor varchar2(60) -- 关联人经营期限
    ,rela_ps_super_org_orgnz_cd varchar2(60) -- 关联人上级机构组织机构代码
    ,rela_ps_super_org_unify_soci_crdt_cd varchar2(60) -- 关联人上级机构统一社会信用代码
    ,rela_ps_director_corp_rgst_curr_cd varchar2(60) -- 关联人主管单位注册币种代码
    ,rela_ps_director_corp_rgst_amt number(30,2) -- 关联人主管单位注册金额
    ,rela_ps_en_last_name varchar2(100) -- 关联人英文姓氏
    ,rela_ps_en_name varchar2(100) -- 关联人英文名称
    ,rela_ps_stament_flg varchar2(10) -- 关联人自证声明标志
    ,rela_ps_tax_red_idti_cd varchar2(10) -- 关联人税收居民身份代码
    ,rela_ps_birth_dt date -- 关联人出生日期
    ,rela_ps_cn_birth_addr varchar2(200) -- 关联人中文出生地址
    ,rela_ps_en_birth_addr varchar2(200) -- 关联人英文出生地址
    ,rela_ps_cn_resdnt_addr varchar2(200) -- 关联人中文居住地址
    ,rela_ps_en_resdnt_addr varchar2(200) -- 关联人英文居住地址
    ,ctrler_type_cd varchar2(10) -- 控制人类型代码
    ,ctrler_tax_null_rs_descb varchar2(3000) -- 控制人纳税人识别号空值原因描述
    ,ctrler_tax_num varchar2(500) -- 控制人纳税人识别号
    ,ctrler_tax_red_cty varchar2(250) -- 控制人纳税居民国家
    ,rela_ps_post_name varchar2(1500) -- 关联人职务名称
    ,rela_ps_latest_update_tm date -- 关联人最新更新时间
    ,rela_ps_latest_update_teller_no varchar2(60) -- 关联人最新更新柜员号
    ,rela_ps_latest_update_org_no varchar2(60) -- 关联人最新更新机构号
    ,rela_ps_latest_update_chn_cd varchar2(10) -- 关联人最新更新渠道代码
    ,src_sys_cd varchar2(10) -- 来源系统代码
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_corp_cust_rela_ps_info to ${idl_schema};
grant select on ${icl_schema}.cmm_corp_cust_rela_ps_info to ${iel_schema};
grant select on ${icl_schema}.cmm_corp_cust_rela_ps_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_corp_cust_rela_ps_info is '对公客户关联人信息';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_type_cd is '关联类型代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_cust_id is '关联人客户编号';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_id is '关联人编号';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_name is '关联人姓名';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_gender_cd is '关联人性别代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_nation_cd is '关联人国别代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_cert_type_cd is '关联人证件类型代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_cert_no is '关联人证件号码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_cert_effect_dt is '关联人证件生效日期';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_cert_exp_dt is '关联人证件到期日期';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_higt_edu_cd is '关联人最高学历代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_post_cd is '关联人职务代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_senior_man_flg is '关联人高管标志';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_shard_flg is '关联人股东标志';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.legal_rep_flg is '法人代表标志';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_tel_num is '关联人电话号码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_tel_ext_num is '关联人电话分机号码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_mobile_no is '关联人手机号码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_career_cd is '关联人职业代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_title_level_cd is '关联人职称等级代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_cont_addr is '关联人联系地址';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_work_unit_name is '关联人工作单位名称';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_work_unit_char_cd is '关联人工作单位性质代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_work_unit_addr is '关联人工作单位地址';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_work_unit_tel_num is '关联人工作单位电话号码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_other_career_descb is '关联人其他职业描述';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_mon_inco is '关联人月收入';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_open_acct_lics is '关联人开户许可证';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_belong_group_num is '关联人所属集团号';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_mang_tenor is '关联人经营期限';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_super_org_orgnz_cd is '关联人上级机构组织机构代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_super_org_unify_soci_crdt_cd is '关联人上级机构统一社会信用代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_director_corp_rgst_curr_cd is '关联人主管单位注册币种代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_director_corp_rgst_amt is '关联人主管单位注册金额';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_en_last_name is '关联人英文姓氏';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_en_name is '关联人英文名称';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_stament_flg is '关联人自证声明标志';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_tax_red_idti_cd is '关联人税收居民身份代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_birth_dt is '关联人出生日期';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_cn_birth_addr is '关联人中文出生地址';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_en_birth_addr is '关联人英文出生地址';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_cn_resdnt_addr is '关联人中文居住地址';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_en_resdnt_addr is '关联人英文居住地址';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.ctrler_type_cd is '控制人类型代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.ctrler_tax_null_rs_descb is '控制人纳税人识别号空值原因描述';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.ctrler_tax_num is '控制人纳税人识别号';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.ctrler_tax_red_cty is '控制人纳税居民国家';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_post_name is '关联人职务名称';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_latest_update_tm is '关联人最新更新时间';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_latest_update_teller_no is '关联人最新更新柜员号';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_latest_update_org_no is '关联人最新更新机构号';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.rela_ps_latest_update_chn_cd is '关联人最新更新渠道代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.src_sys_cd is '来源系统代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_corp_cust_rela_ps_info.etl_timestamp is 'ETL处理时间戳';
