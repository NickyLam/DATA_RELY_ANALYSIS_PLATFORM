/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_corp_cust_attach_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_corp_cust_attach_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_cust_attach_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_cust_attach_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_type_cd varchar2(20) -- 客户类型代码
    ,cust_name varchar2(500) -- 客户名称
    ,adv_man_indu_flg varchar2(10) -- 先进制造业标志
    ,spe_soph_unq_new_med_side_enter_flg varchar2(10) -- 专精特新中小企业标志
    ,spe_soph_unq_new_lte_gnt_corp_flg varchar2(10) -- 专精特新小巨人企业标志
    ,high_new_tech_corp_flg varchar2(10) -- 高新技术企业标志
    ,agri_property_lead_enterp_flg varchar2(10) -- 农业产业化龙头企业标志
    ,farm_and_new_agri_mang_main_loan_flg varchar2(10) -- 农户及新型农业经营主体贷款标志
    ,cty_tech_inovt_corp_flg varchar2(10) -- 国家技术创新示范企业标志
    ,item_corp_flg varchar2(10) -- 制造业单项冠军企业标志
    ,inovt_med_side_enter_flg varchar2(10) --创新型中小企业标志	
    ,scen_tech_med_side_enter_flg varchar2(10) --科技型中小企业标志	
    ,cty_corp_tech_center_flg varchar2(10) --国家企业技术中心标志	
    ,each_class_scen_tech_list_corp_flg varchar2(10) --各类科技名单企业标志	
    ,ex_servisman_corp_flg varchar2(10) --退役军人创办企业标志	
    ,invest_cust_flg varchar2(10) -- 投资级客户标志
    ,asset_liab_ratio number(30,6) -- 投资级资产负债率
    ,major_foul_behav_flg varchar2(10) -- 投资级重大违法违规行为标志
    ,fin_data_update_flg varchar2(10) -- 投资级财务数据及时更新标志
    ,fin_data_report_prd varchar2(60) -- 投资级财务数据报告期
    ,fin_data_rept_type_cd varchar2(10) -- 投资级财务数据报表类型代码
    ,fin_stat_dt date -- 投资级财务报表日期
    ,only_public_market_bus_flg varchar2(10) -- 仅公开市场业务标志
    ,indust_park_corp_flg varchar2(10) -- 产业园企业标志
    ,sel_sup_cust_flg_cd varchar2(10) -- 自营客户标志代码
    ,cross_bor_cust_flg varchar2(10) -- 跨境电商客户标
    ,chain_proj_cust_flg varchar2(10) -- 1+n供应链项目客户标志
    ,open_acct_lics_id varchar2(60) -- 开户许可证编号
    ,open_acct_lics_apprv_dt date -- 开户许可证核准日期
    ,digit_econ_type_cd varchar2(10) -- 数字经济类型代码
    ,role_type_cd varchar2(10) -- 角色类型代码
    ,risk_dist_cd varchar2(10) -- 风险预警行政区划代码
    ,work_rg_dist_cd varchar2(10) -- 办公地区行政区划代码
    ,basic_open_bank_no varchar2(100) -- 基本开户行行号
    ,lei_id varchar2(100) -- LEI编号
    ,bnft_owner_type_cd varchar2(60) -- 受益所有人类型代码
    ,bnft_owner_idtfy_status_cd varchar2(60) -- 受益所有人识别状态代码
    ,bnft_owner_attr_cd_comb varchar2(30) -- 受益所有人属性代码组合
    ,mger_member_number number(10) -- 管理人员人数
    ,non_rec_rs varchar2(500) -- 不良记录原因
    ,blklist_cust_flg varchar2(30) -- 黑名单客户标志
    ,up_blklist_dt date -- 上黑名单日期
    ,up_blklist_rs varchar2(500) -- 上黑名单原因
    ,tax_auth_proof_descb varchar2(60) -- 税务机关证明描述
    ,latest_update_teller_id varchar2(60) -- 最新更新柜员编号
    ,latest_update_org_id varchar2(60) -- 最新更新机构编号
    ,latest_update_chn_cd varchar2(30) -- 最新更新渠道代码
    ,latest_update_tm timestamp(6) -- 最新更新时间
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
grant select on ${icl_schema}.cmm_corp_cust_attach_info to ${idl_schema};
grant select on ${icl_schema}.cmm_corp_cust_attach_info to ${iel_schema};
grant select on ${icl_schema}.cmm_corp_cust_attach_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_corp_cust_attach_info is '对公客户补充信息';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.cust_type_cd is '客户类型代码';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.cust_name is '客户名称';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.adv_man_indu_flg is '先进制造业标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.spe_soph_unq_new_med_side_enter_flg is '专精特新中小企业标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.spe_soph_unq_new_lte_gnt_corp_flg is '专精特新小巨人企业标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.high_new_tech_corp_flg is '高新技术企业标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.agri_property_lead_enterp_flg is '农业产业化龙头企业标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.farm_and_new_agri_mang_main_loan_flg is '农户及新型农业经营主体贷款标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.cty_tech_inovt_corp_flg is '国家技术创新示范企业标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.item_corp_flg is '制造业单项冠军企业标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.inovt_med_side_enter_flg is '创新型中小企业标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.scen_tech_med_side_enter_flg is '科技型中小企业标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.cty_corp_tech_center_flg is '国家企业技术中心标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.each_class_scen_tech_list_corp_flg is '各类科技名单企业标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.ex_servisman_corp_flg is '退役军人创办企业标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.invest_cust_flg is '投资级客户标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.asset_liab_ratio is '投资级资产负债率';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.major_foul_behav_flg is '投资级重大违法违规行为标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.fin_data_update_flg is '投资级财务数据及时更新标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.fin_data_report_prd is '投资级财务数据报告期';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.fin_data_rept_type_cd is '投资级财务数据报表类型代码';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.fin_stat_dt is '投资级财务报表日期';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.only_public_market_bus_flg is '仅公开市场业务标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.indust_park_corp_flg is '产业园企业标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.sel_sup_cust_flg_cd is '自营客户标志代码';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.cross_bor_cust_flg is '跨境电商客户标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.chain_proj_cust_flg is '1+n供应链项目客户标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.open_acct_lics_id is '开户许可证编号';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.open_acct_lics_apprv_dt is '开户许可证核准日期';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.digit_econ_type_cd is '数字经济类型代码';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.role_type_cd is '角色类型代码';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.risk_dist_cd is '风险预警行政区划代码';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.work_rg_dist_cd is '办公地区行政区划代码';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.basic_open_bank_no is '基本开户行行号';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.lei_id is 'LEI编号';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.bnft_owner_type_cd is '受益所有人类型代码';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.bnft_owner_idtfy_status_cd is '受益所有人识别状态代码';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.bnft_owner_attr_cd_comb is '受益所有人属性代码组合';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.mger_member_number is '管理人员人数';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.non_rec_rs is '不良记录原因';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.blklist_cust_flg is '黑名单客户标志';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.up_blklist_dt is '上黑名单日期';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.up_blklist_rs is '上黑名单原因';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.tax_auth_proof_descb is '税务机关证明描述';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.latest_update_teller_id is '最新更新柜员编号';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.latest_update_org_id is '最新更新机构编号';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.latest_update_chn_cd is '最新更新渠道代码';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.latest_update_tm is '最新更新时间';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_corp_cust_attach_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_corp_cust_attach_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_corp_cust_attach_info.etl_timestamp is 'ETL处理时间戳';
