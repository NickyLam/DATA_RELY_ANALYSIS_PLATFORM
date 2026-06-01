/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_cmm_indv_cust_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_cmm_indv_cust_basic_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_cmm_indv_cust_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_cmm_indv_cust_basic_info(
    etl_dt date
    ,lp_id varchar2(60)
    ,cust_id varchar2(60)
    ,cust_type_cd varchar2(20)
    ,cert_type_cd varchar2(10)
    ,cert_no varchar2(60)
    ,cert_exp_dt date
    ,cert_issue_org varchar2(500)
    ,cust_name varchar2(250)
    ,cust_en_name varchar2(500)
    ,open_acct_dt date
    ,belong_org_id varchar2(60)
    ,open_acct_teller_id varchar2(60)
    ,gender_cd varchar2(10)
    ,open_acct_chn_cd varchar2(10)
    ,birth_dt date
    ,marriage_situ_cd varchar2(10)
    ,resd_status_cd varchar2(10)
    ,estate_val_cd varchar2(30)
    ,owner_type_cd varchar2(10)
    ,politic_status_cd varchar2(10)
    ,nation_cd varchar2(10)
    ,dist_cd varchar2(10)
    ,rg_cd varchar2(30)
    ,nationty_cd varchar2(10)
    ,nati_place varchar2(500)
    ,cust_status_cd varchar2(10)
    ,depositr_cate_cd varchar2(20)
    ,prov_pulation_type_cd varchar2(10)
    ,child_number_cd varchar2(10)
    ,cont_num varchar2(60)
    ,open_acct_rsrv_mobile_no varchar2(60)
    ,elec_mail_addr varchar2(200)
    ,cust_lev_cd varchar2(10)
    ,edu_cd varchar2(10)
    ,degree_cd varchar2(10)
    ,grad_sch varchar2(500)
    ,title_cd varchar2(10)
    ,post_cd varchar2(10)
    ,career_cd varchar2(30)
    ,posta_addr varchar2(500)
    ,comm_zip_cd varchar2(60)
    ,resdnt_addr varchar2(500)
    ,resdnt_zip_cd varchar2(60)
    ,rpr_site varchar2(500)
    ,family_addr varchar2(500)
    ,family_zip_cd varchar2(60)
    ,nome_phone_num varchar2(60)
    ,work_unit_name varchar2(500)
    ,work_unit_addr varchar2(500)
    ,work_unit_tel varchar2(500)
    ,work_unit_zip_cd varchar2(60)
    ,work_unit_char_cd VARCHAR2(250)
    ,corp_bl_induty_type_cd varchar2(10)
    ,corp_work_years number(10)
    ,indv_mon_inco number(30,2)
    ,indv_anl_inco number(30,2)
    ,family_mon_inco number(30,2)
    ,family_anl_inco number(30,2)
    ,tax_resdnt_idti_cd varchar2(30)
    ,tax_red_cty_cd varchar2(500)
    ,tax_num varchar2(500)
    ,tax_num_null_rs_descb varchar2(3000)
    ,stament_flg varchar2(10)
    ,indv_bus_flg varchar2(10)
    ,sm_bus_owner_flg varchar2(10)
    ,resdnt_flg varchar2(10)
    ,farm_flg varchar2(10)
    ,ghb_emply_flg varchar2(10)
    ,ghb_shard_flg varchar2(10)
    ,crdt_cust_flg varchar2(10)
    ,real_name_flg varchar2(10)
    ,dom_overs_flg varchar2(10)
    ,local_estate_flg varchar2(10)
    ,local_soci_secu_flg varchar2(10)
    ,ctysd_contr_oper_acct_flg varchar2(10)
    ,ghb_rela_peop_flg varchar2(10)
    ,hxb_shard_flg varchar2(10)
    ,hxb_trast_inter_bus_flg varchar2(10)
    ,hxb_payoff_sal_acct_flg varchar2(10)
    ,hxb_reg_cust_flg varchar2(10)
    ,hxb_finc_cust_flg varchar2(10)
    ,hxb_vip_cust_idf varchar2(10)
    ,spouse_and_child_img_flg varchar2(10)
    ,enjoy_cty_prefr_policy_flg varchar2(10)
    ,cust_mgr_id varchar2(100)
    ,employ_type_cd varchar2(10)
    ,clos_acct_dt date
    ,clos_acct_org_id varchar2(60)
    ,clos_acct_teller_id varchar2(60)
    ,have_car_flg varchar2(10)
    ,salar_flg varchar2(10)
    ,civ_sert_flg varchar2(10)
    ,tax_red_en_name varchar2(100)
    ,other_career_info varchar2(1000)
    ,curt_corp_empyt_dt date
    ,create_chn_cd varchar2(10)
    ,cont_num_is_self_flg varchar2(10)
    ,rela_tran_flg varchar2(10)
    ,cert_effect_dt date
    ,dep_class_cust_flg varchar2(10)
    ,loan_class_cust_flg varchar2(10)
    ,guar_class_cust_flg varchar2(10)
    ,anti_mon_lau_belong_org_id varchar2(60)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_cmm_indv_cust_basic_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_cmm_indv_cust_basic_info is '个人客户基本信息';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cust_id is '客户编号';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cust_type_cd is '客户类型代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cert_type_cd is '证件类型代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cert_no is '证件号码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cert_exp_dt is '证件到期日期';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cert_issue_org is '证件签发机关';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cust_name is '客户名称';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cust_en_name is '客户英文名称';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.open_acct_dt is '客户开户日期';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.belong_org_id is '所属机构编号';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.open_acct_teller_id is '开户柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.gender_cd is '性别代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.open_acct_chn_cd is '开户渠道代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.birth_dt is '出生日期';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.marriage_situ_cd is '婚姻状况代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.resd_status_cd is '居住状态代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.estate_val_cd is '房产价值代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.owner_type_cd is '业主类型代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.politic_status_cd is '政治面貌代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.nation_cd is '国籍代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.dist_cd is '行政区域代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.rg_cd is '地区代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.nationty_cd is '民族代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.nati_place is '籍贯';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cust_status_cd is '客户状态代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.depositr_cate_cd is '存款人类别代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.prov_pulation_type_cd is '供养人口类型代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.child_number_cd is '子女人数代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cont_num is '联系号码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.open_acct_rsrv_mobile_no is '开户预留手机号码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.elec_mail_addr is '电子邮件地址';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cust_lev_cd is '客户级别代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.edu_cd is '学历代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.degree_cd is '学位代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.grad_sch is '毕业学校';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.title_cd is '职称代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.post_cd is '职务代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.career_cd is '职业代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.posta_addr is '通讯地址';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.comm_zip_cd is '通讯邮政编码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.resdnt_addr is '常住地址';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.resdnt_zip_cd is '常住邮政编码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.rpr_site is '户口所在地';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.family_addr is '家庭地址';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.family_zip_cd is '家庭邮政编码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.nome_phone_num is '家庭电话号码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.work_unit_name is '工作单位名称';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.work_unit_addr is '工作单位地址';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.work_unit_tel is '工作单位电话';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.work_unit_zip_cd is '工作单位邮政编码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.work_unit_char_cd is '工作单位性质代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.corp_bl_induty_type_cd is '单位所属行业类型代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.corp_work_years is '单位工作年限';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.indv_mon_inco is '个人月收入';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.indv_anl_inco is '个人年收入';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.family_mon_inco is '家庭月收入';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.family_anl_inco is '家庭年收入';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.tax_resdnt_idti_cd is '税收居民身份代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.tax_red_cty_cd is '税收居民国家代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.tax_num is '纳税人识别号';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.tax_num_null_rs_descb is '纳税人识别号空值原因描述';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.stament_flg is '自证声明标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.indv_bus_flg is '个体工商户标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.sm_bus_owner_flg is '小微企业主标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.resdnt_flg is '居民标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.farm_flg is '农户标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.ghb_emply_flg is '本行员工标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.ghb_shard_flg is '本行股东标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.crdt_cust_flg is '授信客户标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.real_name_flg is '实名标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.dom_overs_flg is '境内外标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.local_estate_flg is '当地房产标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.local_soci_secu_flg is '当地社保标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.ctysd_contr_oper_acct_flg is '农村承包经营户标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.ghb_rela_peop_flg is '本行关系人标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.hxb_shard_flg is '我行股东标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.hxb_trast_inter_bus_flg is '在我行办理过中间业务标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.hxb_payoff_sal_acct_flg is '我行代发工资户标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.hxb_reg_cust_flg is '我行定期客户标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.hxb_finc_cust_flg is '我行理财客户标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.hxb_vip_cust_idf is '我行VIP客户标识';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.spouse_and_child_img_flg is '配偶及子女移民标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.enjoy_cty_prefr_policy_flg is '享受国家优惠政策标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cust_mgr_id is '客户经理编号';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.employ_type_cd is '雇佣类型代码';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.clos_acct_dt is '客户销户日期';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.clos_acct_org_id is '销户机构编号';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.clos_acct_teller_id is '销户柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.have_car_flg is '拥有汽车标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.salar_flg is '受薪人士标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.civ_sert_flg is '公务员标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.tax_red_en_name is '税收居民英文名称';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.other_career_info is '其他职业信息';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.curt_corp_empyt_dt is '现单位入职日期';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.create_chn_cd is '创建渠道编号';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cont_num_is_self_flg is '联系号码是否本人标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.rela_tran_flg is '关联交易标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.cert_effect_dt is '证件生效日期';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.dep_class_cust_flg is '存款类客户标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.loan_class_cust_flg is '贷款类客户标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.guar_class_cust_flg is '担保类客户标志';
comment on column ${msl_schema}.msl_edw_cmm_indv_cust_basic_info.anti_mon_lau_belong_org_id is '反洗钱归属机构编号';
