/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol hgls_supm_entity_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.hgls_supm_entity_info
whenever sqlerror continue none;
drop table ${iol_schema}.hgls_supm_entity_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_supm_entity_info(
    id number(22,0) -- 
    ,code varchar2(4000) -- 
    ,req_code varchar2(4000) -- 进件code
    ,biz_due_day date -- 营业到期日
    ,wthr_tech_inovt_corp varchar2(4000) -- 是否科创类企业xdfhs
    ,wthr_high_tech_corp varchar2(4000) -- 是否高新技术企业xdfhs
    ,wthr_tech_corp varchar2(4000) -- 是否科技型企业xdfhs
    ,wthr_inovt_smc varchar2(4000) -- 是否创新型中小企业xdfhs
    ,wthr_spec_giant_corp varchar2(4000) -- 是否专精特新“小巨人”企业xdfhs
    ,wthr_spec_small_mdl_corp varchar2(4000) -- 是否“专精特新”中小企业
    ,wthr_tech_small_mdl_corp varchar2(4000) -- 是否科技型中小企业xdfhs
    ,wthr_indu_sing_chmpn_corp varchar2(4000) -- 是否制造业单项冠军企业xdfhs
    ,wthr_natn_tech_inovt_corp varchar2(4000) -- 是否国家技术创新示范企业xdfhs
    ,create_date date -- 
    ,update_date date -- 更新时间
    ,is_del number(22,0) -- 
    ,biz_start_day date -- 营业起始日
    ,cit_num varchar2(4000) -- 中征码
    ,corp_email varchar2(4000) -- 公司E－Mail：必填，字段上限200位
    ,cont_tel varchar2(4000) -- 联系电话：必填，字段上限13位
    ,zipcode varchar2(4000) -- 邮政编码：必填，字段上限10位
    ,frame_org_categ varchar2(4000) -- 组织机构类别
    ,main_oper_biz varchar2(4000) -- 主营业务：必填，字段上限20位
    ,wthr_invt_type_pty varchar2(4000) -- 是否为投资类客户：必选，是/否
    ,go_pub_corp_typ varchar2(4000) -- 上市类型：必选，单选
    ,pty_ml_risk_class varchar2(4000) -- 反洗钱风险等级：必选，单选
    ,strg_emg_indu_typ varchar2(4000) -- 战略新兴产业类型：必选，单选
    ,wthr_blng_two_high_one_rema_indus varchar2(4000) -- 是否属于两高一剩行业：必选，是/否
    ,wthr_gover_fin_platf varchar2(4000) -- 是否政府融资平台：必选，是/否
    ,wthr_assoc varchar2(4000) -- 是否关联方：必选，是/否
    ,wthr_rural_corp varchar2(4000) -- 是否农村企业：必选，是/否
    ,wthr_ipo_corp varchar2(4000) -- 是否上市公司：必选，是/否
    ,corp_reg_typ varchar2(4000) -- 登记注册类型：必选
    ,loan_usage_cd varchar2(4000) -- 贷款用途类型：必选
    ,oper_corp_wthr_spec_new varchar2(4000) -- 经营企业是否涉及专精特新
    ,wthr_scntf_crea_corp varchar2(4000) -- 是否科创企业
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
grant select on ${iol_schema}.hgls_supm_entity_info to ${iml_schema};
grant select on ${iol_schema}.hgls_supm_entity_info to ${icl_schema};
grant select on ${iol_schema}.hgls_supm_entity_info to ${idl_schema};
grant select on ${iol_schema}.hgls_supm_entity_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.hgls_supm_entity_info is '信贷补录经营实体信息';
comment on column ${iol_schema}.hgls_supm_entity_info.id is '';
comment on column ${iol_schema}.hgls_supm_entity_info.code is '';
comment on column ${iol_schema}.hgls_supm_entity_info.req_code is '进件code';
comment on column ${iol_schema}.hgls_supm_entity_info.biz_due_day is '营业到期日';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_tech_inovt_corp is '是否科创类企业xdfhs';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_high_tech_corp is '是否高新技术企业xdfhs';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_tech_corp is '是否科技型企业xdfhs';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_inovt_smc is '是否创新型中小企业xdfhs';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_spec_giant_corp is '是否专精特新“小巨人”企业xdfhs';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_spec_small_mdl_corp is '是否“专精特新”中小企业';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_tech_small_mdl_corp is '是否科技型中小企业xdfhs';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_indu_sing_chmpn_corp is '是否制造业单项冠军企业xdfhs';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_natn_tech_inovt_corp is '是否国家技术创新示范企业xdfhs';
comment on column ${iol_schema}.hgls_supm_entity_info.create_date is '';
comment on column ${iol_schema}.hgls_supm_entity_info.update_date is '更新时间';
comment on column ${iol_schema}.hgls_supm_entity_info.is_del is '';
comment on column ${iol_schema}.hgls_supm_entity_info.biz_start_day is '营业起始日';
comment on column ${iol_schema}.hgls_supm_entity_info.cit_num is '中征码';
comment on column ${iol_schema}.hgls_supm_entity_info.corp_email is '公司E－Mail：必填，字段上限200位';
comment on column ${iol_schema}.hgls_supm_entity_info.cont_tel is '联系电话：必填，字段上限13位';
comment on column ${iol_schema}.hgls_supm_entity_info.zipcode is '邮政编码：必填，字段上限10位';
comment on column ${iol_schema}.hgls_supm_entity_info.frame_org_categ is '组织机构类别';
comment on column ${iol_schema}.hgls_supm_entity_info.main_oper_biz is '主营业务：必填，字段上限20位';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_invt_type_pty is '是否为投资类客户：必选，是/否';
comment on column ${iol_schema}.hgls_supm_entity_info.go_pub_corp_typ is '上市类型：必选，单选';
comment on column ${iol_schema}.hgls_supm_entity_info.pty_ml_risk_class is '反洗钱风险等级：必选，单选';
comment on column ${iol_schema}.hgls_supm_entity_info.strg_emg_indu_typ is '战略新兴产业类型：必选，单选';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_blng_two_high_one_rema_indus is '是否属于两高一剩行业：必选，是/否';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_gover_fin_platf is '是否政府融资平台：必选，是/否';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_assoc is '是否关联方：必选，是/否';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_rural_corp is '是否农村企业：必选，是/否';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_ipo_corp is '是否上市公司：必选，是/否';
comment on column ${iol_schema}.hgls_supm_entity_info.corp_reg_typ is '登记注册类型：必选';
comment on column ${iol_schema}.hgls_supm_entity_info.loan_usage_cd is '贷款用途类型：必选';
comment on column ${iol_schema}.hgls_supm_entity_info.oper_corp_wthr_spec_new is '经营企业是否涉及专精特新';
comment on column ${iol_schema}.hgls_supm_entity_info.wthr_scntf_crea_corp is '是否科创企业';
comment on column ${iol_schema}.hgls_supm_entity_info.start_dt is '开始时间';
comment on column ${iol_schema}.hgls_supm_entity_info.end_dt is '结束时间';
comment on column ${iol_schema}.hgls_supm_entity_info.id_mark is '增删标志';
comment on column ${iol_schema}.hgls_supm_entity_info.etl_timestamp is 'ETL处理时间戳';
