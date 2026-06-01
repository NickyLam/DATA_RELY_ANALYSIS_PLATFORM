/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_guar_cont_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_guar_cont_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_guar_cont_info_h(
etl_dt date --数据日期
,guar_cont_type_cd varchar2(30) --担保合同类型代码
,guar_way_cd varchar2(30) --担保方式代码
,cont_status_cd varchar2(30) --合同状态代码
,cont_sign_dt date --合同签定日期
,cont_effect_dt date --合同生效日期
,cont_exp_dt date --合同到期日期
,cust_id varchar2(100) --客户编号
,guartor_cate_cd varchar2(30) --担保人类别代码
,guartor_id varchar2(100) --担保人编号
,guartor_name varchar2(1000) --担保人名称
,guar_curr_cd varchar2(30) --担保币种代码
,guar_tot_amt number(30,2) --担保总金额
,other_espec_apot_descb varchar2(1000) --其它特别约定描述
,guar_opinion_descb varchar2(1000) --担保意见描述
,check_guar_dt date --核保日期
,guartor_cert_type_cd varchar2(30) --担保人证件类型代码
,guartor_cert_no varchar2(60) --担保人证件号码
,guartor_loan_card_no varchar2(100) --担保人贷款卡号
,guar_guar_form_cd varchar2(30) --保证担保形式代码
,rgst_org_id varchar2(100) --登记机构编号
,rgst_teller_id varchar2(100) --登记柜员编号
,rgst_dt date --登记日期
,update_org_id varchar2(100) --更新机构编号
,update_teller_id varchar2(100) --更新柜员编号
,modif_dt date --变更日期
,lp_id varchar2(100) --法人编号
,auth_begin_dt date --授权起始日期
,rev_guar_measure_flg varchar2(10) --反担保措施标志
,nat_std_indus_dir_cd varchar2(30) --国标行业投向代码
,corp_size_cd varchar2(30) --企业规模代码
,natnal_econ_dept_type_cd varchar2(30) --国民经济部门类型代码
,rgst_dist_cd varchar2(30) --注册地行政区划代码
,dir_hxb_guar_flg varchar2(10) --直接向我行担保标志
,obg_name varchar2(500) --权属人名称
,obg_cust_id varchar2(100) --权利人客户编号
,gcust_flg varchar2(10) --代保管标志
,resdnt_flg varchar2(10) --居民标志
,rgst_cty_rg_cd varchar2(30) --注册地国家和地区代码
,guartor_net_asset number(18,6) --保证人净资产
,matn_flg varchar2(10) --维护标志
,lmt_cont_id varchar2(100) --额度合同编号
,ocup_guar_lmt_flg varchar2(10) --占用担保额度标志
,file_dt date --归档日期
,guar_type_cls_cd varchar2(30) --担保类型分类代码
,guar_exp_dt date --担保到期日期
,guar_begin_dt date --担保起始日期
,guar_range_cd varchar2(30) --担保范围代码
,pri_contr_id varchar2(100) --主合同编号
,brwer_name varchar2(500) --借款人名称
,text_cont_id varchar2(250) --文本合同编号
,ts_flg varchar2(10) --暂存标志
,elec_cont_type varchar2(60) --电子合同类型
,main_guar_way_cd varchar2(30) --主担保方式代码
,margin_ratio number(18,6) --保证金比例
,credt_org_name varchar2(500) --债权人机构名称
,credt_org_id varchar2(100) --债权人机构编号
,guar_mon_tenor number(30,0) --担保期限
,aldy_guar_amt number(30,8) --已担保金额
,aval_bal number(30,2) --可用余额
,auto_que_crdtc_rept_flg varchar2(10) --自动查询征信报告标志
,crdtc_que_auth_id varchar2(100) --征信查询授权书编号
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(250) --协议编号
,guar_cont_id varchar2(100) --担保合同编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_guar_cont_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_guar_cont_info_h is '担保合同信息历史';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guar_cont_type_cd is '担保合同类型代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guar_way_cd is '担保方式代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.cont_status_cd is '合同状态代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.cont_sign_dt is '合同签定日期';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.cont_effect_dt is '合同生效日期';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.cont_exp_dt is '合同到期日期';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guartor_cate_cd is '担保人类别代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guartor_id is '担保人编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guartor_name is '担保人名称';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guar_curr_cd is '担保币种代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guar_tot_amt is '担保总金额';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.other_espec_apot_descb is '其它特别约定描述';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guar_opinion_descb is '担保意见描述';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.check_guar_dt is '核保日期';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guartor_cert_type_cd is '担保人证件类型代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guartor_cert_no is '担保人证件号码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guartor_loan_card_no is '担保人贷款卡号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guar_guar_form_cd is '保证担保形式代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.rgst_org_id is '登记机构编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.rgst_dt is '登记日期';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.update_org_id is '更新机构编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.update_teller_id is '更新柜员编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.modif_dt is '变更日期';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.lp_id is '法人编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.auth_begin_dt is '授权起始日期';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.rev_guar_measure_flg is '反担保措施标志';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.nat_std_indus_dir_cd is '国标行业投向代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.corp_size_cd is '企业规模代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.natnal_econ_dept_type_cd is '国民经济部门类型代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.rgst_dist_cd is '注册地行政区划代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.dir_hxb_guar_flg is '直接向我行担保标志';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.obg_name is '权属人名称';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.obg_cust_id is '权利人客户编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.gcust_flg is '代保管标志';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.resdnt_flg is '居民标志';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.rgst_cty_rg_cd is '注册地国家和地区代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guartor_net_asset is '保证人净资产';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.matn_flg is '维护标志';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.lmt_cont_id is '额度合同编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.ocup_guar_lmt_flg is '占用担保额度标志';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.file_dt is '归档日期';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guar_type_cls_cd is '担保类型分类代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guar_exp_dt is '担保到期日期';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guar_begin_dt is '担保起始日期';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guar_range_cd is '担保范围代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.pri_contr_id is '主合同编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.brwer_name is '借款人名称';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.text_cont_id is '文本合同编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.ts_flg is '暂存标志';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.elec_cont_type is '电子合同类型';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.main_guar_way_cd is '主担保方式代码';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.margin_ratio is '保证金比例';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.credt_org_name is '债权人机构名称';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.credt_org_id is '债权人机构编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guar_mon_tenor is '担保期限';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.aldy_guar_amt is '已担保金额';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.aval_bal is '可用余额';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.auto_que_crdtc_rept_flg is '自动查询征信报告标志';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.crdtc_que_auth_id is '征信查询授权书编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_guar_cont_info_h.guar_cont_id is '担保合同编号';

