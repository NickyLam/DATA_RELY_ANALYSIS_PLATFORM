/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_corp_loan_bus_cont_attach_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_corp_loan_bus_cont_attach_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_loan_bus_cont_attach_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_bus_cont_attach_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(60) -- 合同编号
    ,lmt_cont_id varchar2(60) -- 额度合同编号
    ,lmt_id varchar2(100) -- 额度编号
    ,cont_name varchar2(250) -- 合同名称
    ,cont_type_cd varchar2(10) -- 合同类型代码
    ,margin_int_rat number(30,8) -- 保证金利率
    ,gover_crdt_flg varchar2(10) -- 政府授信标志
    ,gover_crdt_supt_way_cd varchar2(30) -- 政府授信支持方式代码
    ,gover_crdt_type_cd varchar2(30) -- 政府授信类型代码
    ,cdb_crdt_breed_cd varchar2(30) -- 国开授信品种代码
    ,loan_char_cd varchar2(30) -- 贷款性质代码
    ,invest_char_cd varchar2(30) -- 投资性质代码
    ,margin_int_rat_type_cd varchar2(30) -- 保证金利率类型代码
    ,margin_int_accr_method_cd varchar2(30) -- 保证金计息方法代码
    ,acct_recvbl_tran_way_cd varchar2(30) -- 应收账款转让方式代码
    ,ocup_open_lmt_risk_type_cd varchar2(30) -- 占用敞口额度风险类型代码
    ,m_l_claus_exist_flg varchar2(10) -- 溢短装条款存在标志
    ,obank_open_flg varchar2(10) -- 他行代开标志
    ,three_old_tf_or_city_update_proj_flg varchar2(10) -- 三旧改造或城市更新项目标志
    ,cont_begin_dt date -- 合同起始日期
    ,cont_exp_dt date -- 合同到期日期
    ,start_work_dt date -- 开工日期
    ,oper_start_dt date -- 运营开始日期
    ,batch_no varchar2(250) -- 批文文号
    ,plan_lics_id varchar2(1000) -- 规划许可证编号
    ,arch_land_lics_id varchar2(1000) -- 建设用地许可证编号
    ,envir_im_ass_lics_id varchar2(1000) -- 环评许可证编号
    ,cnstr_lics_id varchar2(1000) -- 施工许可证编号
    ,other_lics_id varchar2(1000) -- 其他许可证编号
    ,ncds_num varchar2(60) -- 同业存单号码
    ,margin_tran_out_acct_num varchar2(60) -- 保证金转出账号
    ,bus_info_desc varchar2(250) -- 业务信息描述
    ,back_info_descb varchar2(18) -- 背景信息描述
    ,cargo_name varchar2(250) -- 货物名称
    ,cls_freq number(30,8) -- 分类频率
    ,m_l_ratio number(30,8) -- 溢短装比例
    ,proj_tot_invest number(18,2) -- 项目总投资
    ,capital number(18,2) -- 资本金
    ,setup_proj_batch_file varchar2(250) -- 立项批文
    ,other_lics varchar2(250) -- 其他许可证
    ,ncds_abbr varchar2(100) -- 同业存单简称
    ,margin_int_rat_level varchar2(100) -- 保证金利率档次
    ,land_use_cert_id varchar2(1000) -- 土地使用证编号
    ,land_use_cert_dt date -- 土地使用证日期
    ,land_plan_lics_id varchar2(1000) -- 用地规划许可证编号
    ,land_plan_lics_dt date -- 用地规划许可证日期
    ,cnstr_lics_dt date -- 施工许可证日期
    ,proj_plan_lics_dt date -- 工程规划许可证日期
    ,buyer_name varchar2(1000) -- 购货方名称
    ,seller_name varchar2(1000) -- 销货方名称
    ,trade_tran_content varchar2(3000) -- 贸易交易内容
    ,stat_use_open_bal number(30,8) -- 统计用敞口余额
    ,commer_inv_info_desc varchar2(100) -- 商业发票信息描述
    ,commer_inv_curr_cd varchar2(10) -- 商业发票币种代码
    ,commer_inv_amt number(30,2) -- 商业发票金额
    ,commer_inv_kind_cd varchar2(100) -- 商业发票种类代码
    ,adv_man_indu_flg varchar2(10) -- 先进制造业标志
    ,spe_soph_unq_new_med_side_enter_flg varchar2(10) -- 专精特新中小企业标志
    ,spe_soph_unq_new_lte_gnt_corp_flg varchar2(10) -- 专精特新小巨人企业标志
    ,cul_property_flg varchar2(10) -- 文化产业标志
    ,indu_corp_tech_rem_ugd_flg varchar2(10) -- 工业企业技术改造升级标志
    ,strate_new_indus_type_cd varchar2(10) -- 战略性新兴产业类型代码
    ,high_new_tech_corp_flg varchar2(10) -- 高新技术企业标志
    ,sci_tech_corp_flg varchar2(10) -- 科技型企业标志
    ,sci_tech_inovt_corp_flg varchar2(10) -- 科创企业标志
    ,high_tech_property_flg varchar2(10) -- 投向高技术产业标志
    ,digit_econ_core_type_cd varchar2(30) -- 投向数字经济核心产业类型代码
    ,provi_for_aged_property_flg varchar2(10) -- 养老产业标志
    ,ppp_proj_flg varchar2(10) -- 投向政府和社会资本合作项目标志
    ,new_distr_flg varchar2(10) -- 新机制发放贷款标志
    ,cashflow_cover_bbal_flg varchar2(10) -- 预测现金流覆盖借款余额标志
    ,seed_loan_flg varchar2(10) -- 种业振兴贷款标志
    ,county_loan_flg varchar2(10) -- 县城区贷款标志
    ,high_tech_serv_loan_flg varchar2(10) --高技术服务业贷款标志
    ,high_tech_serv_loan_type_cd varchar2(60)  --高技术服务业贷款类型代码
    ,rela_peop_guar_loan_flg  varchar2(10) --关系人保证贷款标志
    ,rei_loan_flg  varchar2(10) --房地产开发贷款标志
	  ,buss_tiket_recs_flg varchar2(10) -- 商票保贴追索标志
	  ,discnter_margin_acct_flg varchar2(10) -- 贴现人保证金账户标志
    ,tran_asset_name varchar2(250) -- 交易资产名称
    ,abs_name varchar2(250) -- abs/abn名称
    ,cont_bal number(30,8) -- 合同余额
    ,tenor_days number(22) -- 期限天数
    ,remark varchar2(4000) -- 备注
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
grant select on ${icl_schema}.cmm_corp_loan_bus_cont_attach_info to ${idl_schema};
grant select on ${icl_schema}.cmm_corp_loan_bus_cont_attach_info to ${iel_schema};
grant select on ${icl_schema}.cmm_corp_loan_bus_cont_attach_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_corp_loan_bus_cont_attach_info is '对公贷款业务合同补充信息';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.lmt_cont_id is '额度合同编号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.lmt_id is '额度编号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cont_name is '合同名称';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cont_type_cd is '合同类型代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.margin_int_rat is '保证金利率';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.gover_crdt_flg is '政府授信标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.gover_crdt_supt_way_cd is '政府授信支持方式代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.gover_crdt_type_cd is '政府授信类型代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cdb_crdt_breed_cd is '国开授信品种代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.loan_char_cd is '贷款性质代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.invest_char_cd is '投资性质代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.margin_int_rat_type_cd is '保证金利率类型代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.margin_int_accr_method_cd is '保证金计息方法代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.acct_recvbl_tran_way_cd is '应收账款转让方式代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.ocup_open_lmt_risk_type_cd is '占用敞口额度风险类型代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.m_l_claus_exist_flg is '溢短装条款存在标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.obank_open_flg is '他行代开标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.three_old_tf_or_city_update_proj_flg is '三旧改造或城市更新项目标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cont_begin_dt is '合同起始日期';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cont_exp_dt is '合同到期日期';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.start_work_dt is '开工日期';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.oper_start_dt is '运营开始日期';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.batch_no is '批文文号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.plan_lics_id is '规划许可证编号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.arch_land_lics_id is '建设用地许可证编号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.envir_im_ass_lics_id is '环评许可证编号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cnstr_lics_id is '施工许可证编号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.other_lics_id is '其他许可证编号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.ncds_num is '同业存单号码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.margin_tran_out_acct_num is '保证金转出账号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.bus_info_desc is '业务信息描述';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.back_info_descb is '背景信息描述';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cargo_name is '货物名称';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cls_freq is '分类频率';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.m_l_ratio is '溢短装比例';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.proj_tot_invest is '项目总投资';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.capital is '资本金';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.setup_proj_batch_file is '立项批文';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.other_lics is '其他许可证';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.ncds_abbr is '同业存单简称';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.margin_int_rat_level is '保证金利率档次';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.land_use_cert_id is '土地使用证编号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.land_use_cert_dt is '土地使用证日期';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.land_plan_lics_id is '用地规划许可证编号';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.land_plan_lics_dt is '用地规划许可证日期';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cnstr_lics_dt is '施工许可证日期';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.proj_plan_lics_dt is '工程规划许可证日期';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.buyer_name is '购货方名称';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.seller_name is '销货方名称';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.trade_tran_content is '贸易交易内容';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.stat_use_open_bal is '统计用敞口余额';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.commer_inv_info_desc is '商业发票信息描述';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.commer_inv_curr_cd is '商业发票币种代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.commer_inv_amt is '商业发票金额';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.commer_inv_kind_cd is '商业发票种类代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.adv_man_indu_flg is '先进制造业标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.spe_soph_unq_new_med_side_enter_flg is '专精特新中小企业标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.spe_soph_unq_new_lte_gnt_corp_flg is '专精特新小巨人企业标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cul_property_flg is '文化产业标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.indu_corp_tech_rem_ugd_flg is '工业企业技术改造升级标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.strate_new_indus_type_cd is '战略性新兴产业类型代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.high_new_tech_corp_flg is '高新技术企业标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.sci_tech_corp_flg is '科技型企业标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.sci_tech_inovt_corp_flg is '科创企业标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.high_tech_property_flg is '投向高技术产业标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.digit_econ_core_type_cd is '投向数字经济核心产业类型代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.provi_for_aged_property_flg is '养老产业标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.ppp_proj_flg is '投向政府和社会资本合作项目标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.new_distr_flg is '新机制发放贷款标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cashflow_cover_bbal_flg is '预测现金流覆盖借款余额标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.seed_loan_flg is '种业振兴贷款标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.county_loan_flg is '县城区贷款标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.high_tech_serv_loan_flg is '高技术服务业贷款标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.high_tech_serv_loan_type_cd is '高技术服务业贷款类型代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.rela_peop_guar_loan_flg is '关系人保证贷款标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.rei_loan_flg is '房地产开发贷款标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.buss_tiket_recs_flg is '商票保贴追索标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.discnter_margin_acct_flg is '贴现人保证金账户标志';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.tran_asset_name is '交易资产名称';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.abs_name is 'ABS/ABN名称';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.cont_bal is '合同余额';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.tenor_days is '期限天数';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.remark is '备注';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_corp_loan_bus_cont_attach_info.etl_timestamp is '数据处理时间';