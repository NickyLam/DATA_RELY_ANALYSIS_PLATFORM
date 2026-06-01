/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_indv_cust_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_indv_cust_basic_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_indv_cust_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_indv_cust_basic_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_type_cd varchar2(20) -- 客户类型代码
    ,cert_type_cd varchar2(10) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,cert_effect_dt date -- 证件生效日期
    ,cert_exp_dt date -- 证件到期日期
    ,cert_issue_org varchar2(750) -- 证件签发机关
    ,cust_name varchar2(250) -- 客户名称
    ,cust_en_name varchar2(750) -- 客户英文名称
    ,open_acct_dt date -- 客户开户日期
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,anti_mon_lau_belong_org_id varchar2(60) -- 反洗钱归属机构编号
    ,open_acct_teller_id varchar2(60) -- 开户柜员编号
    ,gender_cd varchar2(10) -- 性别代码
    ,open_acct_chn_cd varchar2(10) -- 开户渠道代码
    ,create_chn_cd varchar2(10) -- 创建渠道编号
    ,birth_dt date -- 出生日期
    ,marriage_situ_cd varchar2(10) -- 婚姻状况代码
    ,resd_status_cd varchar2(10) -- 居住状况代码
    ,estate_val_cd varchar2(30) -- 房产价值
    ,owner_type_cd varchar2(10) -- 业主类型代码
    ,politic_status_cd varchar2(10) -- 政治面貌代码
    ,nation_cd varchar2(10) -- 国籍代码
    ,dist_cd varchar2(10) -- 行政区域代码
    ,rg_cd varchar2(30) -- 地区代码
    ,nationty_cd varchar2(10) -- 民族代码
    ,nati_place varchar2(500) -- 籍贯
    ,cust_status_cd varchar2(10) -- 客户状态代码
    ,depositr_cate_cd varchar2(20) -- 存款人类别代码
    ,prov_pulation_type_cd varchar2(10) -- 供养人口类型代码
    ,child_number_cd varchar2(10) -- 子女人数代码
    ,cont_num varchar2(60) -- 电话号码
    ,cont_num_is_self_flg varchar2(10) -- 电话号码是否本人标志
    ,open_acct_rsrv_mobile_no varchar2(60) -- 开户预留手机号码
    ,elec_mail_addr varchar2(300) -- 电子邮件地址
    ,cust_lev_cd varchar2(10) -- 客户级别代码
    ,edu_cd varchar2(10) -- 学历代码
    ,degree_cd varchar2(10) -- 学位代码
    ,grad_sch varchar2(500) -- 毕业学校
    ,title_cd varchar2(10) -- 职称等级代码
    ,post_cd varchar2(10) -- 职务代码
    ,career_cd varchar2(30) -- 职业代码
    ,posta_addr varchar2(750) -- 通讯地址
    ,comm_zip_cd varchar2(90) -- 通讯邮政编码
    ,resdnt_addr varchar2(750) -- 常住地址
    ,resdnt_zip_cd varchar2(90) -- 常住邮政编码
    ,rpr_site varchar2(750) -- 户口所在地
    ,family_addr varchar2(750) -- 家庭地址
    ,family_zip_cd varchar2(90) -- 家庭邮政编码
    ,nome_phone_num varchar2(60) -- 家庭电话号码
    ,work_unit_name varchar2(500) -- 工作单位名称
    ,work_unit_addr varchar2(1000) -- 工作单位地址
    ,work_unit_tel varchar2(500) -- 工作单位电话
    ,work_unit_zip_cd varchar2(60) -- 工作单位邮政编码
    ,work_unit_char_cd varchar2(250) -- 登记注册类型代码
    ,corp_bl_induty_type_cd varchar2(10) -- 单位所属行业类型代码
    ,corp_work_years number(10) -- 单位工作年限
    ,indv_mon_inco number(30,2) -- 个人月收入
    ,indv_anl_inco number(30,2) -- 个人年收入
    ,family_mon_inco number(30,2) -- 家庭月收入
    ,family_anl_inco number(30,2) -- 家庭年收入
    ,tax_resdnt_idti_cd varchar2(30) -- 税收居民身份代码
    ,tax_red_cty_cd varchar2(500) -- 税收居民国家代码
    ,tax_num varchar2(500) -- 纳税人识别号
    ,tax_num_null_rs_descb varchar2(3000) -- 纳税人识别号空值原因描述
    ,stament_flg varchar2(10) -- 自证声明标志
    ,indv_bus_flg varchar2(10) -- 个体工商户标志
    ,sm_bus_owner_flg varchar2(10) -- 小微企业主标志
    ,resdnt_flg varchar2(10) -- 居民标志
    ,farm_flg varchar2(10) -- 农户标志
    ,ghb_emply_flg varchar2(10) -- 本行员工标志
    ,ghb_shard_flg varchar2(10) -- 本行股东标志
    ,crdt_cust_flg varchar2(10) -- 授信客户标志
    ,real_name_flg varchar2(10) -- 实名标志
    ,dom_overs_flg varchar2(10) -- 境内外标志
    ,local_estate_flg varchar2(10) -- 当地房产标志
    ,local_soci_secu_flg varchar2(10) -- 当地社保标志
    ,ctysd_contr_oper_acct_flg varchar2(10) -- 农村承包经营户标志
    ,ghb_rela_peop_flg varchar2(10) -- 本行关系人标志
    ,hxb_shard_flg varchar2(10) -- 我行股东标志
    ,hxb_trast_inter_bus_flg varchar2(10) -- 在我行办理过中间业务标志
    ,hxb_payoff_sal_acct_flg varchar2(10) -- 我行代发工资户标志
    ,hxb_reg_cust_flg varchar2(10) -- 我行定期客户标志
    ,hxb_finc_cust_flg varchar2(10) -- 我行理财客户标志
    ,hxb_vip_cust_idf varchar2(10) -- 我行VIP客户标识
    ,spouse_and_child_img_flg varchar2(10) -- 配偶及子女移民标志
    ,enjoy_cty_prefr_policy_flg varchar2(10) -- 享受国家优惠政策标志
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,employ_type_cd varchar2(10) -- 雇佣类型代码
    ,dep_class_cust_flg varchar2(10) -- 存款类客户标志
    ,loan_class_cust_flg varchar2(10) -- 贷款类客户标志
    ,guar_class_cust_flg varchar2(10) -- 担保类客户标志
    ,clos_acct_dt date -- 客户销户日期
    ,clos_acct_org_id varchar2(60) -- 销户机构编号
    ,clos_acct_teller_id varchar2(60) -- 销户柜员编号
    ,have_car_flg varchar2(10) -- 拥有汽车标志
    ,salar_flg varchar2(10) -- 受薪人士标志
    ,civ_sert_flg varchar2(10) -- 公务员标志
    ,tax_red_en_name varchar2(100) -- 税收居民英文名称
    ,other_career_info varchar2(1000) -- 其他职业信息
    ,curt_corp_empyt_dt date -- 现单位入职日期
    ,rela_tran_flg varchar2(10) -- 关联方标志
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
grant select on ${icl_schema}.cmm_indv_cust_basic_info to ${idl_schema};
grant select on ${icl_schema}.cmm_indv_cust_basic_info to ${iel_schema};
grant select on ${icl_schema}.cmm_indv_cust_basic_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_indv_cust_basic_info is '个人客户基本信息';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cust_type_cd is '客户类型代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cert_type_cd is '证件类型代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cert_no is '证件号码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cert_effect_dt is '证件生效日期';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cert_exp_dt is '证件到期日期';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cert_issue_org is '证件签发机关';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cust_name is '客户名称';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cust_en_name is '客户英文名称';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.open_acct_dt is '客户开户日期';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.anti_mon_lau_belong_org_id is '反洗钱归属机构编号';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.open_acct_teller_id is '开户柜员编号';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.gender_cd is '性别代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.open_acct_chn_cd is '开户渠道代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.create_chn_cd is '创建渠道编号';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.birth_dt is '出生日期';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.marriage_situ_cd is '婚姻状况代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.resd_status_cd is '居住状况代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.estate_val_cd is '房产价值';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.owner_type_cd is '业主类型代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.politic_status_cd is '政治面貌代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.nation_cd is '国籍代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.dist_cd is '行政区域代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.rg_cd is '地区代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.nationty_cd is '民族代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.nati_place is '籍贯';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cust_status_cd is '客户状态代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.depositr_cate_cd is '存款人类别代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.prov_pulation_type_cd is '供养人口类型代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.child_number_cd is '子女人数代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cont_num is '电话号码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cont_num_is_self_flg is '联系号码是否本人标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.open_acct_rsrv_mobile_no is '开户预留手机号码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.elec_mail_addr is '电子邮件地址';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cust_lev_cd is '客户级别代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.edu_cd is '学历代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.degree_cd is '学位代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.grad_sch is '毕业学校';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.title_cd is '职称等级代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.post_cd is '职务代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.career_cd is '职业代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.posta_addr is '通讯地址';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.comm_zip_cd is '通讯邮政编码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.resdnt_addr is '常住地址';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.resdnt_zip_cd is '常住邮政编码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.rpr_site is '户口所在地';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.family_addr is '家庭地址';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.family_zip_cd is '家庭邮政编码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.nome_phone_num is '家庭电话号码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.work_unit_name is '工作单位名称';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.work_unit_addr is '工作单位地址';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.work_unit_tel is '工作单位电话';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.work_unit_zip_cd is '工作单位邮政编码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.work_unit_char_cd is '登记注册类型代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.corp_bl_induty_type_cd is '单位所属行业类型代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.corp_work_years is '单位工作年限';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.indv_mon_inco is '个人月收入';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.indv_anl_inco is '个人年收入';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.family_mon_inco is '家庭月收入';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.family_anl_inco is '家庭年收入';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.tax_resdnt_idti_cd is '税收居民身份代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.tax_red_cty_cd is '税收居民国家代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.tax_num is '纳税人识别号';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.tax_num_null_rs_descb is '纳税人识别号空值原因描述';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.stament_flg is '自证声明标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.indv_bus_flg is '个体工商户标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.sm_bus_owner_flg is '小微企业主标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.resdnt_flg is '居民标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.farm_flg is '农户标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.ghb_emply_flg is '本行员工标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.ghb_shard_flg is '本行股东标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.crdt_cust_flg is '授信客户标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.real_name_flg is '实名标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.dom_overs_flg is '境内外标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.local_estate_flg is '当地房产标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.local_soci_secu_flg is '当地社保标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.ctysd_contr_oper_acct_flg is '农村承包经营户标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.ghb_rela_peop_flg is '本行关系人标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.hxb_shard_flg is '我行股东标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.hxb_trast_inter_bus_flg is '在我行办理过中间业务标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.hxb_payoff_sal_acct_flg is '我行代发工资户标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.hxb_reg_cust_flg is '我行定期客户标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.hxb_finc_cust_flg is '我行理财客户标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.hxb_vip_cust_idf is '我行VIP客户标识';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.spouse_and_child_img_flg is '配偶及子女移民标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.enjoy_cty_prefr_policy_flg is '享受国家优惠政策标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.employ_type_cd is '雇佣类型代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.dep_class_cust_flg is '存款类客户标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.loan_class_cust_flg is '贷款类客户标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.guar_class_cust_flg is '担保类客户标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.clos_acct_dt is '客户销户日期';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.clos_acct_org_id is '销户机构编号';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.clos_acct_teller_id is '销户柜员编号';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.have_car_flg is '拥有汽车标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.salar_flg is '受薪人士标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.civ_sert_flg is '公务员标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.tax_red_en_name is '税收居民英文名称';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.other_career_info is '其他职业信息';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.curt_corp_empyt_dt is '现单位入职日期';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.rela_tran_flg is '关联方标志';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_indv_cust_basic_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_indv_cust_basic_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_indv_cust_basic_info.etl_timestamp is 'ETL处理时间戳';
