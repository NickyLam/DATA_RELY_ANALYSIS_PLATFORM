/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdws_a_cm_cust
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdws_a_cm_cust
whenever sqlerror continue none;
drop table ${iol_schema}.bdws_a_cm_cust purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdws_a_cm_cust(
    cust_id varchar2(4000) -- 客户ID
    ,cust_name varchar2(4000) -- 客户姓名
    ,ecif_cust_id varchar2(4000) -- ECIF客户ID
    ,open_dt varchar2(4000) -- 开户日期
    ,sex varchar2(4000) -- 性别
    ,age number(4,0) -- 年龄
    ,birth_dt varchar2(4000) -- 出生日期
    ,doc_type varchar2(4000) -- 证件类型
    ,idenumber varchar2(4000) -- 证件号码
    ,phone varchar2(4000) -- 手机号码
    ,asset_lev varchar2(4000) -- 客户资产等级
    ,mag_org_id varchar2(4000) -- 所属机构ID
    ,mag_org_name varchar2(4000) -- 所属机构
    ,mag_cst_org_id varchar2(4000) -- 管户人所属机构ID
    ,mag_cst_org_name varchar2(4000) -- 管户人所属机构
    ,mag_cst_mgr_id varchar2(4000) -- 管户人ID
    ,mag_cst_mgr varchar2(4000) -- 管户人
    ,sys_user_id varchar2(4000) -- 共管人ID
    ,sys_user varchar2(4000) -- 共管人
    ,house_telephone varchar2(4000) -- 管户人电话
    ,ghb_emply_flg varchar2(4000) -- 本行员工标志
    ,mrtl_status varchar2(4000) -- 婚姻状况
    ,telephone varchar2(4000) -- 固定电话
    ,occupation varchar2(4000) -- 职业
    ,cust_state varchar2(4000) -- 客户状态
    ,law_cust_name varchar2(4000) -- 法人代表
    ,law_tel varchar2(4000) -- 法人手机
    ,address varchar2(4000) -- 单位地址
    ,nation_code varchar2(4000) -- 国家代码
    ,corp_prop varchar2(4000) -- 企业性质
    ,industry_type varchar2(4000) -- 行业类别
    ,found_date varchar2(4000) -- 成立时间
    ,tel varchar2(4000) -- 单位联系电话
    ,reg_curr_type varchar2(4000) -- 注册资本币种
    ,reg_cptl number(22,2) -- 注册资本
    ,reg_addr varchar2(4000) -- 注册地址
    ,is_sh varchar2(4000) -- 是否商户
    ,nation varchar2(4000) -- 民族
    ,ft_opac_time varchar2(4000) -- 最早开户时间
    ,open_org_name varchar2(4000) -- 最早开户机构
    ,is_hx varchar2(4000) -- 是否华兴银行
    ,is_gh varchar2(4000) -- 是否管户标识
    ,card_type varchar2(4000) -- 卡类型
    ,fist_phon varchar2(4000) -- 首要联系手机号
    ,edu_level varchar2(4000) -- 教育程度
    ,asset_bal number(22,4) -- 资产余额
    ,unti_xz varchar2(4000) -- 单位性质
    ,hang_ye varchar2(4000) -- 行业
    ,activity number(22,4) -- 活跃度
    ,loyalty number(22,4) -- 忠诚度
    ,contribute number(22,4) -- 综合贡献度
    ,level_risk varchar2(4000) -- 客户风险评级
    ,child_num number(10,0) -- 小孩人数
    ,per_income number(22,6) -- 个人月收入
    ,fim_income number(22,6) -- 家庭月收入
    ,is_per_loan varchar2(4000) -- 是否有个人贷款
    ,account_num number(10,0) -- 有多少家银行贵宾账户
    ,use_bank_server varchar2(4000) -- 曾经使用过私人银行服务
    ,card_level varchar2(4000) -- 持卡等级
    ,lc_risk varchar2(4000) -- 理财风险评级
    ,jj_risk varchar2(4000) -- 基金风险评级
    ,bx_risk varchar2(4000) -- 保险风险评级
    ,zg_risk varchar2(4000) -- 资管信托风险评级
    ,clos_acct_dt varchar2(4000) -- 销户日期
    ,et_dt varchar2(4000) -- 数据日期
    ,political_outlook varchar2(4000) -- 政治面貌
    ,education varchar2(4000) -- 学历
    ,english_name varchar2(4000) -- 英文名
    ,corporate_name varchar2(4000) -- 单位名称
    ,industry varchar2(4000) -- 行业
    ,corporate_nature varchar2(4000) -- 公司性质
    ,duties varchar2(4000) -- 职务
    ,positional_titles varchar2(4000) -- 职称
    ,nationality varchar2(4000) -- 国籍
    ,religion varchar2(4000) -- 宗教信仰
    ,pinyin varchar2(4000) -- 拼音
    ,is_leader varchar2(4000) -- 是否我行领导
    ,kid_num number(10,0) -- 小孩人数
    ,kid_age varchar2(4000) -- 小孩年龄
    ,community varchar2(4000) -- 所在社区
    ,branch_bank varchar2(4000) -- 网点
    ,pet_type varchar2(4000) -- 宠物类型
    ,is_executive varchar2(4000) -- 是否高管
    ,type_of_operation varchar2(4000) -- 经营方式
    ,business_products varchar2(4000) -- 经营产品
    ,shop_location varchar2(4000) -- 商铺地段
    ,other varchar2(4000) -- 其他
    ,highest_card_rating varchar2(4000) -- 最高持卡级别
    ,is_pay_by_othre_cust varchar2(4000) -- 是否代发工资客户
    ,is_hx_staff varchar2(4000) -- 是否我行员工
    ,positional varchar2(4000) -- 职位
    ,is_shop varchar2(4000) -- 是否商铺
    ,pyhsical_card varchar2(4000) -- 是否有实体卡
    ,is_contiue_cust varchar2(4000) -- 是否续保客户
    ,family_addr varchar2(4000) -- 家庭地址
    ,elec_mail_addr varchar2(4000) -- 电子邮件地址
    ,resd_status_cd varchar2(4000) -- 居住状态代码
    ,estate_val_cd varchar2(4000) -- 房产价值代码
    ,nome_phone_num varchar2(4000) -- 家庭电话号码
    ,gg_org_id varchar2(4000) -- 共管机构ID
    ,gg_org_name varchar2(4000) -- 共管机构
    ,resdnt_addr varchar2(4000) -- 常住地址
    ,rpr_site varchar2(4000) -- 户口所在地
    ,posta_addr varchar2(4000) -- 通讯地址
    ,party_status_type_cd varchar2(4000) -- 是否同意发送营销信息短信
    ,qual_invtor_cert_flg varchar2(4000) -- 合格投资者认证标志
    ,qual_invtor_vlid_tenor varchar2(4000) -- 合格投资者有效期限
    ,lc_risk_date varchar2(4000) -- 理财评级有效日期
    ,is_new_risk varchar2(4000) -- 新旧风评标志
    ,high_risk_flag varchar2(4000) -- 理财高风险及中高风险产品标识
    ,is_lingui varchar2(4000) -- 是否完成柜面风险评估标志
    ,risk_level varchar2(4000) -- 客户风险等级(新风评后级别)
    ,new_rating_invalid_dt varchar2(4000) -- 新风险评级有效期
    ,jj_risk_date varchar2(4000) -- 基金评级有效日期
    ,bx_risk_date varchar2(4000) -- 保险评级有效日期
    ,zg_risk_date varchar2(4000) -- 资管评级有效日期
    ,cert_exp_dt varchar2(4000) -- 证件到期日
    ,gh_brch_org_id varchar2(4000) -- 管户归属分行ID
    ,gh_brch_org_name varchar2(4000) -- 管户归属分行名称
    ,gh_subbrch_org_id varchar2(4000) -- 管户归属支行ID
    ,gh_subbrch_org_name varchar2(4000) -- 管户归属支行名称
    ,gg_brch_org_id varchar2(4000) -- 共管归属分行ID
    ,gg_brch_org_name varchar2(4000) -- 共管归属分行名称
    ,gg_subbrch_org_id varchar2(4000) -- 共管归属支行ID
    ,gg_subbrch_org_name varchar2(4000) -- 共管归属支行名称
    ,new_citizen_flg varchar2(4000) -- 新市民标志
    ,first_open_i_acct_dt varchar2(4000) -- 最早开通一类户时间
    ,is_stop_no_counter_tran varchar2(4000) -- 是否暂停非柜面交易
    ,cust_max_aum number(32,6) -- 客户历史最高AUM值
    ,cust_max_aum_date varchar2(4000) -- 客户历史最高AUM值对应日期
    ,cust_avgm_aum number(32,6) -- 客户历史最高AUM月日均
    ,cust_avgm_aum_date varchar2(4000) -- 客户历史最高AUM月日均对应日期
    ,is_register_mgm varchar2(4000) -- 是否登记mgm
    ,sysbrch_id varchar2(4000) -- 共管分行ID
    ,sysbrch_name varchar2(4000) -- 共管分行名称
    ,syssubbrch_id varchar2(4000) -- 共管归属机构ID
    ,syssubbrch_name varchar2(4000) -- 共管归属机构名称
    ,if_bill varchar2(4000) -- 是否收单
    ,load_date varchar2(4000) -- 分区字段
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdws_a_cm_cust to ${iml_schema};
grant select on ${iol_schema}.bdws_a_cm_cust to ${icl_schema};
grant select on ${iol_schema}.bdws_a_cm_cust to ${idl_schema};
grant select on ${iol_schema}.bdws_a_cm_cust to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdws_a_cm_cust is '零售客户基本信息(A层)';
comment on column ${iol_schema}.bdws_a_cm_cust.cust_id is '客户ID';
comment on column ${iol_schema}.bdws_a_cm_cust.cust_name is '客户姓名';
comment on column ${iol_schema}.bdws_a_cm_cust.ecif_cust_id is 'ECIF客户ID';
comment on column ${iol_schema}.bdws_a_cm_cust.open_dt is '开户日期';
comment on column ${iol_schema}.bdws_a_cm_cust.sex is '性别';
comment on column ${iol_schema}.bdws_a_cm_cust.age is '年龄';
comment on column ${iol_schema}.bdws_a_cm_cust.birth_dt is '出生日期';
comment on column ${iol_schema}.bdws_a_cm_cust.doc_type is '证件类型';
comment on column ${iol_schema}.bdws_a_cm_cust.idenumber is '证件号码';
comment on column ${iol_schema}.bdws_a_cm_cust.phone is '手机号码';
comment on column ${iol_schema}.bdws_a_cm_cust.asset_lev is '客户资产等级';
comment on column ${iol_schema}.bdws_a_cm_cust.mag_org_id is '所属机构ID';
comment on column ${iol_schema}.bdws_a_cm_cust.mag_org_name is '所属机构';
comment on column ${iol_schema}.bdws_a_cm_cust.mag_cst_org_id is '管户人所属机构ID';
comment on column ${iol_schema}.bdws_a_cm_cust.mag_cst_org_name is '管户人所属机构';
comment on column ${iol_schema}.bdws_a_cm_cust.mag_cst_mgr_id is '管户人ID';
comment on column ${iol_schema}.bdws_a_cm_cust.mag_cst_mgr is '管户人';
comment on column ${iol_schema}.bdws_a_cm_cust.sys_user_id is '共管人ID';
comment on column ${iol_schema}.bdws_a_cm_cust.sys_user is '共管人';
comment on column ${iol_schema}.bdws_a_cm_cust.house_telephone is '管户人电话';
comment on column ${iol_schema}.bdws_a_cm_cust.ghb_emply_flg is '本行员工标志';
comment on column ${iol_schema}.bdws_a_cm_cust.mrtl_status is '婚姻状况';
comment on column ${iol_schema}.bdws_a_cm_cust.telephone is '固定电话';
comment on column ${iol_schema}.bdws_a_cm_cust.occupation is '职业';
comment on column ${iol_schema}.bdws_a_cm_cust.cust_state is '客户状态';
comment on column ${iol_schema}.bdws_a_cm_cust.law_cust_name is '法人代表';
comment on column ${iol_schema}.bdws_a_cm_cust.law_tel is '法人手机';
comment on column ${iol_schema}.bdws_a_cm_cust.address is '单位地址';
comment on column ${iol_schema}.bdws_a_cm_cust.nation_code is '国家代码';
comment on column ${iol_schema}.bdws_a_cm_cust.corp_prop is '企业性质';
comment on column ${iol_schema}.bdws_a_cm_cust.industry_type is '行业类别';
comment on column ${iol_schema}.bdws_a_cm_cust.found_date is '成立时间';
comment on column ${iol_schema}.bdws_a_cm_cust.tel is '单位联系电话';
comment on column ${iol_schema}.bdws_a_cm_cust.reg_curr_type is '注册资本币种';
comment on column ${iol_schema}.bdws_a_cm_cust.reg_cptl is '注册资本';
comment on column ${iol_schema}.bdws_a_cm_cust.reg_addr is '注册地址';
comment on column ${iol_schema}.bdws_a_cm_cust.is_sh is '是否商户';
comment on column ${iol_schema}.bdws_a_cm_cust.nation is '民族';
comment on column ${iol_schema}.bdws_a_cm_cust.ft_opac_time is '最早开户时间';
comment on column ${iol_schema}.bdws_a_cm_cust.open_org_name is '最早开户机构';
comment on column ${iol_schema}.bdws_a_cm_cust.is_hx is '是否华兴银行';
comment on column ${iol_schema}.bdws_a_cm_cust.is_gh is '是否管户标识';
comment on column ${iol_schema}.bdws_a_cm_cust.card_type is '卡类型';
comment on column ${iol_schema}.bdws_a_cm_cust.fist_phon is '首要联系手机号';
comment on column ${iol_schema}.bdws_a_cm_cust.edu_level is '教育程度';
comment on column ${iol_schema}.bdws_a_cm_cust.asset_bal is '资产余额';
comment on column ${iol_schema}.bdws_a_cm_cust.unti_xz is '单位性质';
comment on column ${iol_schema}.bdws_a_cm_cust.hang_ye is '行业';
comment on column ${iol_schema}.bdws_a_cm_cust.activity is '活跃度';
comment on column ${iol_schema}.bdws_a_cm_cust.loyalty is '忠诚度';
comment on column ${iol_schema}.bdws_a_cm_cust.contribute is '综合贡献度';
comment on column ${iol_schema}.bdws_a_cm_cust.level_risk is '客户风险评级';
comment on column ${iol_schema}.bdws_a_cm_cust.child_num is '小孩人数';
comment on column ${iol_schema}.bdws_a_cm_cust.per_income is '个人月收入';
comment on column ${iol_schema}.bdws_a_cm_cust.fim_income is '家庭月收入';
comment on column ${iol_schema}.bdws_a_cm_cust.is_per_loan is '是否有个人贷款';
comment on column ${iol_schema}.bdws_a_cm_cust.account_num is '有多少家银行贵宾账户';
comment on column ${iol_schema}.bdws_a_cm_cust.use_bank_server is '曾经使用过私人银行服务';
comment on column ${iol_schema}.bdws_a_cm_cust.card_level is '持卡等级';
comment on column ${iol_schema}.bdws_a_cm_cust.lc_risk is '理财风险评级';
comment on column ${iol_schema}.bdws_a_cm_cust.jj_risk is '基金风险评级';
comment on column ${iol_schema}.bdws_a_cm_cust.bx_risk is '保险风险评级';
comment on column ${iol_schema}.bdws_a_cm_cust.zg_risk is '资管信托风险评级';
comment on column ${iol_schema}.bdws_a_cm_cust.clos_acct_dt is '销户日期';
comment on column ${iol_schema}.bdws_a_cm_cust.et_dt is '数据日期';
comment on column ${iol_schema}.bdws_a_cm_cust.political_outlook is '政治面貌';
comment on column ${iol_schema}.bdws_a_cm_cust.education is '学历';
comment on column ${iol_schema}.bdws_a_cm_cust.english_name is '英文名';
comment on column ${iol_schema}.bdws_a_cm_cust.corporate_name is '单位名称';
comment on column ${iol_schema}.bdws_a_cm_cust.industry is '行业';
comment on column ${iol_schema}.bdws_a_cm_cust.corporate_nature is '公司性质';
comment on column ${iol_schema}.bdws_a_cm_cust.duties is '职务';
comment on column ${iol_schema}.bdws_a_cm_cust.positional_titles is '职称';
comment on column ${iol_schema}.bdws_a_cm_cust.nationality is '国籍';
comment on column ${iol_schema}.bdws_a_cm_cust.religion is '宗教信仰';
comment on column ${iol_schema}.bdws_a_cm_cust.pinyin is '拼音';
comment on column ${iol_schema}.bdws_a_cm_cust.is_leader is '是否我行领导';
comment on column ${iol_schema}.bdws_a_cm_cust.kid_num is '小孩人数';
comment on column ${iol_schema}.bdws_a_cm_cust.kid_age is '小孩年龄';
comment on column ${iol_schema}.bdws_a_cm_cust.community is '所在社区';
comment on column ${iol_schema}.bdws_a_cm_cust.branch_bank is '网点';
comment on column ${iol_schema}.bdws_a_cm_cust.pet_type is '宠物类型';
comment on column ${iol_schema}.bdws_a_cm_cust.is_executive is '是否高管';
comment on column ${iol_schema}.bdws_a_cm_cust.type_of_operation is '经营方式';
comment on column ${iol_schema}.bdws_a_cm_cust.business_products is '经营产品';
comment on column ${iol_schema}.bdws_a_cm_cust.shop_location is '商铺地段';
comment on column ${iol_schema}.bdws_a_cm_cust.other is '其他';
comment on column ${iol_schema}.bdws_a_cm_cust.highest_card_rating is '最高持卡级别';
comment on column ${iol_schema}.bdws_a_cm_cust.is_pay_by_othre_cust is '是否代发工资客户';
comment on column ${iol_schema}.bdws_a_cm_cust.is_hx_staff is '是否我行员工';
comment on column ${iol_schema}.bdws_a_cm_cust.positional is '职位';
comment on column ${iol_schema}.bdws_a_cm_cust.is_shop is '是否商铺';
comment on column ${iol_schema}.bdws_a_cm_cust.pyhsical_card is '是否有实体卡';
comment on column ${iol_schema}.bdws_a_cm_cust.is_contiue_cust is '是否续保客户';
comment on column ${iol_schema}.bdws_a_cm_cust.family_addr is '家庭地址';
comment on column ${iol_schema}.bdws_a_cm_cust.elec_mail_addr is '电子邮件地址';
comment on column ${iol_schema}.bdws_a_cm_cust.resd_status_cd is '居住状态代码';
comment on column ${iol_schema}.bdws_a_cm_cust.estate_val_cd is '房产价值代码';
comment on column ${iol_schema}.bdws_a_cm_cust.nome_phone_num is '家庭电话号码';
comment on column ${iol_schema}.bdws_a_cm_cust.gg_org_id is '共管机构ID';
comment on column ${iol_schema}.bdws_a_cm_cust.gg_org_name is '共管机构';
comment on column ${iol_schema}.bdws_a_cm_cust.resdnt_addr is '常住地址';
comment on column ${iol_schema}.bdws_a_cm_cust.rpr_site is '户口所在地';
comment on column ${iol_schema}.bdws_a_cm_cust.posta_addr is '通讯地址';
comment on column ${iol_schema}.bdws_a_cm_cust.party_status_type_cd is '是否同意发送营销信息短信';
comment on column ${iol_schema}.bdws_a_cm_cust.qual_invtor_cert_flg is '合格投资者认证标志';
comment on column ${iol_schema}.bdws_a_cm_cust.qual_invtor_vlid_tenor is '合格投资者有效期限';
comment on column ${iol_schema}.bdws_a_cm_cust.lc_risk_date is '理财评级有效日期';
comment on column ${iol_schema}.bdws_a_cm_cust.is_new_risk is '新旧风评标志';
comment on column ${iol_schema}.bdws_a_cm_cust.high_risk_flag is '理财高风险及中高风险产品标识';
comment on column ${iol_schema}.bdws_a_cm_cust.is_lingui is '是否完成柜面风险评估标志';
comment on column ${iol_schema}.bdws_a_cm_cust.risk_level is '客户风险等级(新风评后级别)';
comment on column ${iol_schema}.bdws_a_cm_cust.new_rating_invalid_dt is '新风险评级有效期';
comment on column ${iol_schema}.bdws_a_cm_cust.jj_risk_date is '基金评级有效日期';
comment on column ${iol_schema}.bdws_a_cm_cust.bx_risk_date is '保险评级有效日期';
comment on column ${iol_schema}.bdws_a_cm_cust.zg_risk_date is '资管评级有效日期';
comment on column ${iol_schema}.bdws_a_cm_cust.cert_exp_dt is '证件到期日';
comment on column ${iol_schema}.bdws_a_cm_cust.gh_brch_org_id is '管户归属分行ID';
comment on column ${iol_schema}.bdws_a_cm_cust.gh_brch_org_name is '管户归属分行名称';
comment on column ${iol_schema}.bdws_a_cm_cust.gh_subbrch_org_id is '管户归属支行ID';
comment on column ${iol_schema}.bdws_a_cm_cust.gh_subbrch_org_name is '管户归属支行名称';
comment on column ${iol_schema}.bdws_a_cm_cust.gg_brch_org_id is '共管归属分行ID';
comment on column ${iol_schema}.bdws_a_cm_cust.gg_brch_org_name is '共管归属分行名称';
comment on column ${iol_schema}.bdws_a_cm_cust.gg_subbrch_org_id is '共管归属支行ID';
comment on column ${iol_schema}.bdws_a_cm_cust.gg_subbrch_org_name is '共管归属支行名称';
comment on column ${iol_schema}.bdws_a_cm_cust.new_citizen_flg is '新市民标志';
comment on column ${iol_schema}.bdws_a_cm_cust.first_open_i_acct_dt is '最早开通一类户时间';
comment on column ${iol_schema}.bdws_a_cm_cust.is_stop_no_counter_tran is '是否暂停非柜面交易';
comment on column ${iol_schema}.bdws_a_cm_cust.cust_max_aum is '客户历史最高AUM值';
comment on column ${iol_schema}.bdws_a_cm_cust.cust_max_aum_date is '客户历史最高AUM值对应日期';
comment on column ${iol_schema}.bdws_a_cm_cust.cust_avgm_aum is '客户历史最高AUM月日均';
comment on column ${iol_schema}.bdws_a_cm_cust.cust_avgm_aum_date is '客户历史最高AUM月日均对应日期';
comment on column ${iol_schema}.bdws_a_cm_cust.is_register_mgm is '是否登记mgm';
comment on column ${iol_schema}.bdws_a_cm_cust.sysbrch_id is '共管分行ID';
comment on column ${iol_schema}.bdws_a_cm_cust.sysbrch_name is '共管分行名称';
comment on column ${iol_schema}.bdws_a_cm_cust.syssubbrch_id is '共管归属机构ID';
comment on column ${iol_schema}.bdws_a_cm_cust.syssubbrch_name is '共管归属机构名称';
comment on column ${iol_schema}.bdws_a_cm_cust.if_bill is '是否收单';
comment on column ${iol_schema}.bdws_a_cm_cust.load_date is '分区字段';
comment on column ${iol_schema}.bdws_a_cm_cust.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdws_a_cm_cust.etl_timestamp is 'ETL处理时间戳';
