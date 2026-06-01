/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_dep_acct_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_dep_acct_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_dep_acct_info_h(
etl_dt date --数据日期
,acct_id varchar2(100) --账户编号
,acct_name varchar2(500) --账户名称
,src_agt_id varchar2(100) --源协议编号
,realtm_chase_capt_flg varchar2(10) --实时追缴标志
,bal_type_cd varchar2(30) --钞汇余额代码
,acct_type_cd varchar2(30) --账户等级代码
,int_accr_flg varchar2(10) --计息标志
,open_acct_dt date --开户日期
,clos_acct_dt date --销户日期
,acct_status_cd varchar2(30) --账户状态代码
,curr_cd varchar2(30) --币种代码
,final_tran_dt date --最后交易日期
,open_acct_org_id varchar2(100) --开户机构编号
,open_acct_chn_id varchar2(100) --开户渠道编号
,belong_org_id varchar2(100) --所属机构编号
,vouch_type_cd varchar2(30) --凭证类型代码
,vouch_no varchar2(60) --凭证号码
,vouch_status_cd varchar2(30) --凭证状态代码
,cust_id varchar2(100) --客户编号
,priv_flg varchar2(10) --对私标志
,prod_id varchar2(100) --产品编号
,card_no varchar2(60) --卡号
,cust_acct_num varchar2(60) --客户账号
,sub_acct_num varchar2(60) --子账号
,effect_dt date --生效日期
,fir_tran_dt date --首次交易日期
,last_acct_status_cd varchar2(30) --上一账户状态代码
,status_modif_dt date --状态变更日期
,clos_acct_teller_id varchar2(100) --销户柜员编号
,clos_acct_rs varchar2(500) --销户原因
,core_acct_type_cd varchar2(30) --核心账户类型代码
,dep_term number(10,0) --存款期限
,tenor_type_cd varchar2(30) --期限类型代码
,exp_dt date --到期日期
,acct_init_exp_dt date --账户原始到期日期
,acct_init_open_acct_dt date --账户原始开户日期
,acct_attr_cd varchar2(30) --存款账户类型代码
,temp_acct_valid_dt date --临时户有效日期
,vtual_acct_flg varchar2(10) --虚户标志
,lmt_flg varchar2(10) --限制标志
,stop_pay_flg varchar2(10) --止付标志
,general_storage_flg varchar2(10) --通存标志
,general_exch_flg varchar2(10) --通兑标志
,reg_acct_type_cd varchar2(30) --定期账户类型代码
,main_acct_flg varchar2(10) --主账户标志
,acct_lics_issue_dt date --账户许可证签发日期
,acct_lics_num varchar2(60) --账户许可证号码
,card_prod_id varchar2(100) --卡产品编号
,main_acct_bal_flg varchar2(10) --主账户带余额标志
,main_acct_int_flg varchar2(10) --主账户带利息标志
,redt_way_type_cd varchar2(30) --自动转存方式代码
,part_pric_redt_flg varchar2(10) --部分本金转存标志
,aldy_pric_redt_cnt number(10,0) --已本金转存次数
,aldy_pric_int_redt_cnt number(10,0) --已本息转存次数
,max_pric_redt_cnt number(10,0) --最大本金转存次数
,max_pric_int_redt_cnt number(10,0) --最大本息转存次数
,reg_acct_last_status_cd varchar2(30) --定期账户上一状态代码
,allow_add_pric_flg varchar2(10) --允许增加本金标志
,turn_dormt_acct_dt date --转不动户日期
,tran_stl_dt date --交易结算日期
,acct_appl_org_id varchar2(100) --账户申请机构编号
,approval_id varchar2(100) --核准件编号
,acct_aldy_check_flg varchar2(10) --账户已复核标志
,auto_payoff_flg varchar2(10) --自动结清标志
,gl_type_cd varchar2(30) --总账类型代码
,multi_bal_flg varchar2(10) --多余额标志
,l_six_m_no_tran_flg varchar2(10) --最近六个月无交易标志
,off_shore_flg varchar2(10) --离岸标志
,ftz_flg varchar2(10) --自贸区标志
,cust_mgr_id varchar2(100) --客户经理编号
,free_annual_fee_flg varchar2(10) --免年费标志
,exch_way_cd varchar2(30) --汇兑方式代码
,init_prod_id varchar2(100) --原产品编号
,curr_pd number(10,0) --当前期次
,stl_flg varchar2(10) --结算标志
,stl_teller_id varchar2(100) --结算柜员编号
,src_module_type_cd varchar2(30) --源模块类型代码
,super_acct_id varchar2(100) --上级账户编号
,acct_usage_cd varchar2(30) --账户用途代码
,check_dt date --复核日期
,advise_dep_tenor number(10,0) --通知存款期限
,check_teller_id varchar2(100) --复核柜员编号
,acct_char_type_cd varchar2(30) --账户性质类型代码
,open_acct_teller_id varchar2(100) --开户柜员编号
,prod_modif_dt date --产品变更日期
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(250) --协议编号
,lp_id varchar2(100) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_dep_acct_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_dep_acct_info_h is '存款账户信息历史';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_id is '账户编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_name is '账户名称';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.src_agt_id is '源协议编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.realtm_chase_capt_flg is '实时追缴标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.bal_type_cd is '钞汇余额代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_type_cd is '账户等级代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.int_accr_flg is '计息标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.open_acct_dt is '开户日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.clos_acct_dt is '销户日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_status_cd is '账户状态代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.final_tran_dt is '最后交易日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.open_acct_chn_id is '开户渠道编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.belong_org_id is '所属机构编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.vouch_type_cd is '凭证类型代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.vouch_no is '凭证号码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.vouch_status_cd is '凭证状态代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.priv_flg is '对私标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.prod_id is '产品编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.card_no is '卡号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.cust_acct_num is '客户账号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.sub_acct_num is '子账号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.effect_dt is '生效日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.fir_tran_dt is '首次交易日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.last_acct_status_cd is '上一账户状态代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.status_modif_dt is '状态变更日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.clos_acct_teller_id is '销户柜员编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.clos_acct_rs is '销户原因';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.core_acct_type_cd is '核心账户类型代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.dep_term is '存款期限';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.tenor_type_cd is '期限类型代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.exp_dt is '到期日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_init_exp_dt is '账户原始到期日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_init_open_acct_dt is '账户原始开户日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_attr_cd is '存款账户类型代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.temp_acct_valid_dt is '临时户有效日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.vtual_acct_flg is '虚户标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.lmt_flg is '限制标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.stop_pay_flg is '止付标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.general_storage_flg is '通存标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.general_exch_flg is '通兑标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.reg_acct_type_cd is '定期账户类型代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.main_acct_flg is '主账户标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_lics_issue_dt is '账户许可证签发日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_lics_num is '账户许可证号码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.card_prod_id is '卡产品编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.main_acct_bal_flg is '主账户带余额标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.main_acct_int_flg is '主账户带利息标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.redt_way_type_cd is '自动转存方式代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.part_pric_redt_flg is '部分本金转存标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.aldy_pric_redt_cnt is '已本金转存次数';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.aldy_pric_int_redt_cnt is '已本息转存次数';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.max_pric_redt_cnt is '最大本金转存次数';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.max_pric_int_redt_cnt is '最大本息转存次数';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.reg_acct_last_status_cd is '定期账户上一状态代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.allow_add_pric_flg is '允许增加本金标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.turn_dormt_acct_dt is '转不动户日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.tran_stl_dt is '交易结算日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_appl_org_id is '账户申请机构编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.approval_id is '核准件编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_aldy_check_flg is '账户已复核标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.auto_payoff_flg is '自动结清标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.gl_type_cd is '总账类型代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.multi_bal_flg is '多余额标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.l_six_m_no_tran_flg is '最近六个月无交易标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.off_shore_flg is '离岸标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.ftz_flg is '自贸区标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.free_annual_fee_flg is '免年费标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.exch_way_cd is '汇兑方式代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.init_prod_id is '原产品编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.curr_pd is '当前期次';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.stl_flg is '结算标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.stl_teller_id is '结算柜员编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.src_module_type_cd is '源模块类型代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.super_acct_id is '上级账户编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_usage_cd is '账户用途代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.check_dt is '复核日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.advise_dep_tenor is '通知存款期限';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.check_teller_id is '复核柜员编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.acct_char_type_cd is '账户性质类型代码';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.open_acct_teller_id is '开户柜员编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.prod_modif_dt is '产品变更日期';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_dep_acct_info_h.lp_id is '法人编号';

