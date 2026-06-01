/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_col_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_col_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_col_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_col_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,col_id varchar2(60) -- 押品编号
    ,col_type_id varchar2(60) -- 押品类型编号
    ,col_name varchar2(500) -- 押品名称
    ,guar_way_cd varchar2(10) -- 担保方式代码
    ,col_mgmt_id varchar2(60) -- 押品管理员工编号
    ,org_id varchar2(60) -- 机构编号
    ,prop_ps_id varchar2(100) -- 权利人客户编号
    ,prop_ps_name varchar2(150) -- 所有权人名称
    ,com_prot_flg varchar2(10) -- 共同财产标志
    ,asset_obg_lot number(18,6) -- 资产权利人所占份额
    ,prior_comp_weight_qtty number(30,8) -- 优先受偿权数额
    ,guar_effect_way_cd varchar2(10) -- 担保生效方式代码
    ,trast_insure_flg varchar2(10) -- 办理保险标志
    ,rgst_trast_status_cd varchar2(10) -- 登记办理状态代码
    ,insure_trast_status_cd varchar2(10) -- 保险办理状态代码
    ,insto_status_cd varchar2(10) -- 入库状态代码
    ,rela_status_cd varchar2(10) -- 关联状态代码
    ,espec_status_cd varchar2(15) -- 押品状态
    ,wt_md_cash_ability_cd varchar2(10) -- 权重法变现能力代码
    ,np_cash_ability_cd varchar2(10) -- 内评初级法变现能力代码
    ,obank_guar_flg varchar2(10) -- 他行担保标志
    ,gcust_flg varchar2(10) -- 代保管标志
    ,fst_flg varchar2(30) -- 我行第一顺位标志
    ,estim_curr_cd varchar2(10) -- 评估币种代码
    ,estim_val number(30,2) -- 评估价值
    ,estim_way_cd varchar2(10) -- 评估方式代码
    ,estim_dt date -- 估值日期
    ,estim_ps_name varchar2(300) -- 评估人名称
    ,estim_exp_dt date -- 评估到期日期
    ,col_val number(30,2) -- 押品价值
    ,hxb_cfm_val number(30,2) -- 我行确认价值
    ,mtged_val number(30,2) -- 已抵押价值
    ,right_rgst_dt date -- 权利登记日期
    ,estim_idtfy_dt date -- 评估基准日期
    ,hxb_pa_cfm_val number(30,2) -- 我行初次评估价值
    ,save_hxb_flg varchar2(10) -- 保存我行标志
    ,setup_dt date -- 登记日期
    ,check_guar_dt date -- 核保日期
    ,ctfer_name_1 varchar2(150) -- 核保人姓名1
    ,ctfer_name_2 varchar2(150) -- 核保人姓名2
    ,modif_emply_id varchar2(60) -- 修改员工编号
    ,main_col_flg varchar2(10) -- 主押品标志
    ,pmo_flg varchar2(10) -- 抵质押品标志
    ,col_modif_flg varchar2(10) -- 押品修改标志
    ,belong_cust_id varchar2(100) -- 权利人客户编号
    ,oper_org_id varchar2(100) -- 操作机构编号
    ,rgst_org_name varchar2(375) -- 登记机构名称
    ,enty_coll_dt date -- 实物收取日期
    ,pm_rat number(18,6) -- 抵质押率
    ,higt_mtg_rat number(18,6) -- 最高抵押率
    ,col_estim_curr_cd varchar2(30) -- 押品评估币种代码
    ,col_estim_val number(30,2) -- 押品评估价值
    ,col_store_addr varchar2(500) -- 押品存放地址
    ,col_belong_type_cd varchar2(30) -- 押品权属类型代码
    ,estim_org_name varchar2(300) -- 评估机构名称
    ,estim_org_orgnz_cd varchar2(100) -- 评估机构证件号码
    ,estim_org_rgst_org_name varchar2(150) -- 评估机构登记机关名称
    ,pledgor_name varchar2(300) -- 权属人名称
    ,pledgor_cert_type_cd varchar2(30) -- 出质人证件类型代码
    ,pledgor_cert_no varchar2(100) -- 出质人证件号码
    ,belong_cert_type varchar2(15) -- 权证类型代码
    ,belong_cert_no varchar2(500) -- 权证登记号码二
    ,belong_rgst_org varchar2(150) -- 权属登记机关
    ,wat_rgst_num varchar2(300) -- 权证登记号码
    ,wat_name varchar2(500) -- 权证名称
	,cmplt_flg varchar2(10) -- 竣工标志
    ,rent_flg varchar2(10) -- 租赁标志
    ,guara_tentry varchar2(300) -- 担保品承租人
    ,rent_begin_dt date -- 租赁起始日期
    ,rent_exp_dt date -- 租赁到期日期
    ,rent_situ_descb varchar2(300) -- 租赁情况描述
    ,rgst_exp_dt date -- 登记有效终止日期
    ,rgst_tenor varchar2(15) -- 登记期限
    ,rgstrat_id varchar2(100) -- 登记人编号
    ,insto_entry_org_id varchar2(100) -- 入库记账机构编号
    ,insto_entry_val number(30,2) -- 入库记账价值
    ,insto_entry_curr_cd varchar2(10) -- 入库记账币种代码
    ,insto_dt date -- 入库日期
    ,exp_dt date -- 到期日期
    ,dep_rcpt_vouch_id varchar2(100) -- 存单凭证编号
    ,hxb_dep_rcpt_flg varchar2(10) -- 我行存单标志
    ,dep_rcpt_effect_dt date -- 存单生效日期
    ,dep_rcpt_exp_dt date -- 存单到期日期
    ,dep_rcpt_term varchar2(45) -- 存单存期
    ,dep_rcpt_term_days number(10) -- 存单存期天数
    ,dep_rcpt_int_rat number(18,6) -- 存单利率
    ,dep_rcpt_curr_cd varchar2(10) -- 存单币种代码
    ,dep_rcpt_aval_amt number(30,2) -- 存单可用金额
    ,dep_rcpt_acct_bal number(30,2) -- 存单账户余额
    ,estate_mon_prop_fee number(30,2) -- 房产月物业费
    ,estate_arch_area number(30,2) -- 房产建筑面积
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
grant select on ${icl_schema}.cmm_col_info to ${idl_schema};
grant select on ${icl_schema}.cmm_col_info to ${iel_schema};
grant select on ${icl_schema}.cmm_col_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_col_info is '押品信息';
comment on column ${icl_schema}.cmm_col_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_col_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_col_info.col_id is '押品编号';
comment on column ${icl_schema}.cmm_col_info.col_type_id is '押品类型编号';
comment on column ${icl_schema}.cmm_col_info.col_name is '押品名称';
comment on column ${icl_schema}.cmm_col_info.guar_way_cd is '担保方式代码';
comment on column ${icl_schema}.cmm_col_info.col_mgmt_id is '押品管理员工编号';
comment on column ${icl_schema}.cmm_col_info.org_id is '机构编号';
comment on column ${icl_schema}.cmm_col_info.prop_ps_id is '权利人客户编号';
comment on column ${icl_schema}.cmm_col_info.prop_ps_name is '所有权人名称';
comment on column ${icl_schema}.cmm_col_info.com_prot_flg is '共同财产标志';
comment on column ${icl_schema}.cmm_col_info.asset_obg_lot is '资产权利人所占份额';
comment on column ${icl_schema}.cmm_col_info.prior_comp_weight_qtty is '优先受偿权数额';
comment on column ${icl_schema}.cmm_col_info.guar_effect_way_cd is '担保生效方式代码';
comment on column ${icl_schema}.cmm_col_info.trast_insure_flg is '办理保险标志';
comment on column ${icl_schema}.cmm_col_info.rgst_trast_status_cd is '登记办理状态代码';
comment on column ${icl_schema}.cmm_col_info.insure_trast_status_cd is '保险办理状态代码';
comment on column ${icl_schema}.cmm_col_info.insto_status_cd is '入库状态代码';
comment on column ${icl_schema}.cmm_col_info.rela_status_cd is '关联状态代码';
comment on column ${icl_schema}.cmm_col_info.espec_status_cd is '押品状态';
comment on column ${icl_schema}.cmm_col_info.wt_md_cash_ability_cd is '权重法变现能力代码';
comment on column ${icl_schema}.cmm_col_info.np_cash_ability_cd is '内评初级法变现能力代码';
comment on column ${icl_schema}.cmm_col_info.obank_guar_flg is '他行担保标志';
comment on column ${icl_schema}.cmm_col_info.gcust_flg is '代保管标志';
comment on column ${icl_schema}.cmm_col_info.fst_flg is '我行第一顺位标志';
comment on column ${icl_schema}.cmm_col_info.estim_curr_cd is '评估币种代码';
comment on column ${icl_schema}.cmm_col_info.estim_val is '评估价值';
comment on column ${icl_schema}.cmm_col_info.estim_way_cd is '评估方式代码';
comment on column ${icl_schema}.cmm_col_info.estim_dt is '估值日期';
comment on column ${icl_schema}.cmm_col_info.estim_ps_name is '评估人名称';
comment on column ${icl_schema}.cmm_col_info.estim_exp_dt is '评估到期日期';
comment on column ${icl_schema}.cmm_col_info.col_val is '押品价值';
comment on column ${icl_schema}.cmm_col_info.hxb_cfm_val is '我行确认价值';
comment on column ${icl_schema}.cmm_col_info.mtged_val is '已抵押价值';
comment on column ${icl_schema}.cmm_col_info.right_rgst_dt is '权利登记日期';
comment on column ${icl_schema}.cmm_col_info.estim_idtfy_dt is '评估基准日期';
comment on column ${icl_schema}.cmm_col_info.hxb_pa_cfm_val is '我行初次评估价值';
comment on column ${icl_schema}.cmm_col_info.save_hxb_flg is '保存我行标志';
comment on column ${icl_schema}.cmm_col_info.setup_dt is '登记日期';
comment on column ${icl_schema}.cmm_col_info.check_guar_dt is '核保日期';
comment on column ${icl_schema}.cmm_col_info.ctfer_name_1 is '核保人姓名1';
comment on column ${icl_schema}.cmm_col_info.ctfer_name_2 is '核保人姓名2';
comment on column ${icl_schema}.cmm_col_info.modif_emply_id is '修改员工编号';
comment on column ${icl_schema}.cmm_col_info.main_col_flg is '主押品标志';
comment on column ${icl_schema}.cmm_col_info.pmo_flg is '抵质押品标志';
comment on column ${icl_schema}.cmm_col_info.col_modif_flg is '押品修改标志';
comment on column ${icl_schema}.cmm_col_info.belong_cust_id is '权利人客户编号';
comment on column ${icl_schema}.cmm_col_info.oper_org_id is '操作机构编号';
comment on column ${icl_schema}.cmm_col_info.rgst_org_name is '登记机构名称';
comment on column ${icl_schema}.cmm_col_info.enty_coll_dt is '实物收取日期';
comment on column ${icl_schema}.cmm_col_info.pm_rat is '抵质押率';
comment on column ${icl_schema}.cmm_col_info.higt_mtg_rat is '最高抵押率';
comment on column ${icl_schema}.cmm_col_info.col_estim_curr_cd is '押品评估币种代码';
comment on column ${icl_schema}.cmm_col_info.col_estim_val is '押品评估价值';
comment on column ${icl_schema}.cmm_col_info.col_store_addr is '押品存放地址';
comment on column ${icl_schema}.cmm_col_info.col_belong_type_cd is '押品权属类型代码';
comment on column ${icl_schema}.cmm_col_info.estim_org_name is '评估机构名称';
comment on column ${icl_schema}.cmm_col_info.estim_org_orgnz_cd is '评估机构证件号码';
comment on column ${icl_schema}.cmm_col_info.estim_org_rgst_org_name is '评估机构登记机关名称';
comment on column ${icl_schema}.cmm_col_info.pledgor_name is '权属人名称';
comment on column ${icl_schema}.cmm_col_info.pledgor_cert_type_cd is '出质人证件类型代码';
comment on column ${icl_schema}.cmm_col_info.pledgor_cert_no is '出质人证件号码';
comment on column ${icl_schema}.cmm_col_info.belong_cert_type is '权证类型代码';
comment on column ${icl_schema}.cmm_col_info.belong_cert_no is '权证登记号码二';
comment on column ${icl_schema}.cmm_col_info.belong_rgst_org is '权属登记机关';
comment on column ${icl_schema}.cmm_col_info.wat_rgst_num is '权证登记号码';
comment on column ${icl_schema}.cmm_col_info.wat_name is '权证名称';
comment on column ${icl_schema}.cmm_col_info.cmplt_flg is '竣工标志';
comment on column ${icl_schema}.cmm_col_info.rent_flg is '租赁标志';
comment on column ${icl_schema}.cmm_col_info.guara_tentry is '担保品承租人';
comment on column ${icl_schema}.cmm_col_info.rent_begin_dt is '租赁起始日期';
comment on column ${icl_schema}.cmm_col_info.rent_exp_dt is '租赁到期日期';
comment on column ${icl_schema}.cmm_col_info.rent_situ_descb is '租赁情况描述';
comment on column ${icl_schema}.cmm_col_info.rgst_exp_dt is '登记有效终止日期';
comment on column ${icl_schema}.cmm_col_info.rgst_tenor is '登记期限';
comment on column ${icl_schema}.cmm_col_info.rgstrat_id is '登记人编号';
comment on column ${icl_schema}.cmm_col_info.insto_entry_org_id is '入库记账机构编号';
comment on column ${icl_schema}.cmm_col_info.insto_entry_val is '入库记账价值';
comment on column ${icl_schema}.cmm_col_info.insto_entry_curr_cd is '入库记账币种代码';
comment on column ${icl_schema}.cmm_col_info.insto_dt is '入库日期';
comment on column ${icl_schema}.cmm_col_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_col_info.dep_rcpt_vouch_id is '存单凭证编号';
comment on column ${icl_schema}.cmm_col_info.hxb_dep_rcpt_flg is '我行存单标志';
comment on column ${icl_schema}.cmm_col_info.dep_rcpt_effect_dt is '存单生效日期';
comment on column ${icl_schema}.cmm_col_info.dep_rcpt_exp_dt is '存单到期日期';
comment on column ${icl_schema}.cmm_col_info.dep_rcpt_term is '存单存期';
comment on column ${icl_schema}.cmm_col_info.dep_rcpt_term_days is '存单存期天数';
comment on column ${icl_schema}.cmm_col_info.dep_rcpt_int_rat is '存单利率';
comment on column ${icl_schema}.cmm_col_info.dep_rcpt_curr_cd is '存单币种代码';
comment on column ${icl_schema}.cmm_col_info.dep_rcpt_aval_amt is '存单可用金额';
comment on column ${icl_schema}.cmm_col_info.dep_rcpt_acct_bal is '存单账户余额';
comment on column ${icl_schema}.cmm_col_info.estate_mon_prop_fee is '房产月物业费';
comment on column ${icl_schema}.cmm_col_info.estate_arch_area is '房产建筑面积';
comment on column ${icl_schema}.cmm_col_info.remark is '备注';
comment on column ${icl_schema}.cmm_col_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_col_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_col_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_col_info.etl_timestamp is 'ETL处理时间戳';
