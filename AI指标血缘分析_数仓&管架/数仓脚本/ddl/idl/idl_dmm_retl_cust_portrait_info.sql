/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl dmm_retl_cust_portrait_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.dmm_retl_cust_portrait_info
whenever sqlerror continue none;
drop table ${idl_schema}.dmm_retl_cust_portrait_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_cust_portrait_info(
       etl_dt date -- 数据日期
      ,lp_id varchar2(60) -- 法人编号
      ,cust_id varchar2(4000) -- 客户号
      ,open_acct_tm timestamp(6) -- 开户时间
      ,cust_aging varchar2(4000) -- 账龄
      ,a_part_cust_flg varchar2(4000) -- 是否a端客户
      ,l_part_cust_flg varchar2(4000) -- 是否l端客户
      ,aum_bal number(22,6) -- aum余额
      ,aum_m_avg number(22,6) -- aum月日均
      ,curr_dep_m_avg number(22,6) -- 活期存款月日均
      ,time_dep_m_avg number(22,6) -- 定期存款月日均
      ,cds_m_avg number(22,6) -- 大额存单月日均
      ,insure_m_avg number(22,6) -- 保险月日均
      ,fund_m_avg number(22,6) -- 基金月日均
      ,finc_m_avg number(22,6) -- 理财月日均
      ,cust_tot_lum number(22,6) -- 客户总lum
      ,mtg_loan_lum number(22,6) -- 抵押贷款lum
      ,non_mtg_loan_lum number(22,6) -- 非抵押贷款lum
      ,lum_hibchy varchar2(4000) -- lum层级
      ,lum_hibchy_subdv varchar2(4000) -- lum层级细分
      ,tib_type varchar2(4000) -- tib
      ,last_mon_tib_type varchar2(4000) -- 上月tib
      ,last_year_tib_type varchar2(4000) -- 上年tib
      ,execu_brch_id varchar2(4000) -- 管户分行编号
      ,execu_ps_id varchar2(4000) -- 管户人编号
      ,execu_ps_name varchar2(4000) -- 管户人名称
      ,execu_subrch_id varchar2(4000) -- 管户支行编号
	  ,execu_org_id varchar2(4000) -- 管户机构编号
      ,co_ps_id varchar2(4000) -- 共管人编号
      ,co_ps_name varchar2(4000) -- 共管人名称
      ,co_ps_role varchar2(4000) -- 共管人角色
      ,co_ps_role_cls varchar2(4000) -- 共管人角色分类
      ,execu_ps_role_cls varchar2(4000) -- 管户人角色分类
      ,cust_hibchy varchar2(4000) -- 客户层级
      ,cust_asset_hibchy_subdv varchar2(4000) -- 客户资产层级细分
      ,eqty_level varchar2(4000) -- 权益等级
      ,eqty_level_subdv varchar2(4000) -- 权益等级细分
      ,is_sleep_acct varchar2(4000) -- 是否睡眠户
      ,is_long_hang_acct varchar2(4000) -- 是否久悬户
      ,is_hold_zero_lon varchar2(4000) -- 是否持有零贷
      ,is_sign_mbank varchar2(4000) -- 是否签约手机银行
      ,is_add_cop_tiny varchar2(4000) -- 是否添加企微
      ,is_agree_camp_st_msg varchar2(4000) -- 是否同意营销短信
      ,is_sign_finc_risk varchar2(4000) -- 是否签约风险测评
      ,is_bind_scut_pay varchar2(4000) -- 是否绑定快捷支付
      ,is_concern_tiny_bank_bd_card varchar2(4000) -- 是否关注微银行并绑卡
      ,is_real_execu varchar2(4000) -- 是否真实管户
      ,is_hold_loan varchar2(4000) -- 是否持有贷款
      ,is_hold_curr varchar2(4000) -- 是否持有活期
      ,is_hold_reg varchar2(4000) -- 是否持有定期
      ,is_hold_fund varchar2(4000) -- 是否持有基金
      ,is_hold_finc varchar2(4000) -- 是否持有理财
      ,is_hold_insure varchar2(4000) -- 是否持有保险
      ,is_hold_three_deposit varchar2(4000) -- 是否持有三方存管
      ,is_hold_noble_met varchar2(4000) -- 是否持有贵金属
      ,is_hold_am_trust varchar2(4000) -- 是否持有资管信托
      ,is_hold_indv_mortg_loan varchar2(4000) -- 是否持有个人按揭性贷款
      ,is_hold_indv_consm_loan varchar2(4000) -- 是否持有个人消费性贷款
      ,is_hold_indv_opering_loan varchar2(4000) -- 是否持有个人经营性贷款
      ,main_guar_way_crdt varchar2(4000) -- 主担保方式为信用
      ,main_guar_way_guar varchar2(4000) -- 主担保方式为保证
      ,main_guar_way_other varchar2(4000) -- 主担保方式为其他
      ,main_guar_way_pm varchar2(4000) -- 主担保方式为抵质押
      ,dep_ftp_cust_net_inco number(22,6) -- 存款ftp客户净收入
      ,loan_ftp_cust_net_inco number(22,6) -- 贷款ftp客户净收入
      ,loan_tot_risk_cost number(22,6) -- 贷款总风险成本
      ,dep_tot_eva number(22,6) -- 存款总eva
      ,loan_tot_eva number(22,6) -- 贷款总eva
      ,loan_ftp_net_margin number(22,6) -- 贷款ftp净利润
      ,dep_ftp_net_margin number(22,6) -- 存款ftp净利润
      ,inter_income_amt number(22,6) -- 中收营收
      ,career_cd varchar2(4000) -- 职业代码
      ,career_name varchar2(4000) -- 职业名称
      ,indus_cd varchar2(4000) -- 行业代码
      ,indus_name varchar2(4000) -- 行业名称
      ,custs varchar2(4000) -- 客群
      ,family_mon_inco number(22,6) -- 家庭月收入
      ,indv_mon_inco number(22,6) -- 个人月收入
      ,age varchar2(4000) -- 年龄
      ,gender varchar2(4000) -- 性别
      ,prov_cd varchar2(4000) -- 省代码
      ,prov_name varchar2(4000) -- 省名称
      ,city_cd varchar2(4000) -- 城市代码
      ,city_name varchar2(4000) -- 城市名称
      ,rg_cd varchar2(4000) -- 地区代码
      ,rg_name varchar2(4000) -- 地区名称
      ,level2_chn_lab varchar2(4000) -- 二级渠道标签
      ,level3_chn_lab varchar2(4000) -- 三级渠道标签
      ,eqty_exch_cnt varchar2(4000) -- 权益星兑换次数
      ,eqty_exch_score number(22,6) -- 权益星兑换分数
      ,point_exch_cnt varchar2(4000) -- 积分兑换次数
      ,point_exch_score number(22,6) -- 积分兑换分数
      ,half_y_tran_in_cnt varchar2(4000) -- 近半年转入笔数
      ,half_y_tran_in_amt number(22,6) -- 近半年转入金额
      ,half_y_tran_out_cnt varchar2(4000) -- 近半年转出笔数
      ,half_y_tran_out_amt number(22,6) -- 近半年转出金额
      ,half_y_bigamt_tran_in_cnt varchar2(4000) -- 近半年大额转入笔数
      ,half_y_bigamt_tran_in_amt number(22,6) -- 近半年大额转入金额
      ,half_y_bigamt_tran_out_cnt varchar2(4000) -- 近半年大额转出笔数
      ,half_y_bigamt_tran_out_amt number(22,6) -- 近半年大额转出金额
      ,half_y_mbank_prod_cnt varchar2(4000) -- 近半年手机银行产品交互次数
      ,half_y_cnter_prod_cnt varchar2(4000) -- 近半年柜面产品交互次数
      ,half_y_atm_cnt varchar2(4000) -- 近半年atm交互次数
      ,half_y_onl_bank_prod_cnt varchar2(4000) -- 近半年网上银行产品交互次数
      ,half_y_other_chn_prod_cnt varchar2(4000) -- 近半年其他渠道产品交互次数
      ,half_y_tiny_arrive_cnt varchar2(4000) -- 近半年企微触达次数
      ,half_y_sound_rec_tel_arrive_cnt varchar2(4000) -- 近半年录音电话触达次数
      ,half_y_indv_wx_arrive_cnt varchar2(4000) -- 近半年个人微信触达次数
      ,half_y_indv_tel_arrive_cnt varchar2(4000) -- 近半年个人电话触达次数
      ,half_y_arrive_cnt varchar2(4000) -- 近半年面访触达次数
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
grant select on ${idl_schema}.dmm_retl_cust_portrait_info to ${idl_schema};
grant select on ${idl_schema}.dmm_retl_cust_portrait_info to ${iel_schema};
grant select on ${idl_schema}.dmm_retl_cust_portrait_info to ${dqc_schema};
-- comment
comment on table ${idl_schema}.dmm_retl_cust_portrait_info is '零售客户画像基本信息';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.etl_dt is '数据日期';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.lp_id is '法人编号';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.cust_id is '客户号';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.open_acct_tm is '开户时间';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.cust_aging is '账龄';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.a_part_cust_flg is '是否a端客户';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.l_part_cust_flg is '是否l端客户';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.aum_bal is 'aum余额';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.aum_m_avg is 'aum月日均';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.curr_dep_m_avg is '活期存款月日均';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.time_dep_m_avg is '定期存款月日均';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.cds_m_avg is '大额存单月日均';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.insure_m_avg is '保险月日均';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.fund_m_avg is '基金月日均';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.finc_m_avg is '理财月日均';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.cust_tot_lum is '客户总lum';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.mtg_loan_lum is '抵押贷款lum';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.non_mtg_loan_lum is '非抵押贷款lum';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.lum_hibchy is 'lum层级';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.lum_hibchy_subdv is 'lum层级细分';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.tib_type is 'tib';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.last_mon_tib_type is '上月tib';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.last_year_tib_type is '上年tib';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.execu_brch_id is '管户分行编号';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.execu_ps_id is '管户人编号';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.execu_ps_name is '管户人名称';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.execu_subrch_id is '管户支行编号';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.execu_org_id is '管户机构编号';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.co_ps_id is '共管人编号';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.co_ps_name is '共管人名称';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.co_ps_role is '共管人角色';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.co_ps_role_cls is '共管人角色分类';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.execu_ps_role_cls is '管户人角色分类';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.cust_hibchy is '客户层级';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.cust_asset_hibchy_subdv is '客户资产层级细分';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.eqty_level is '权益等级';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.eqty_level_subdv is '权益等级细分';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_sleep_acct is '是否睡眠户';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_long_hang_acct is '是否久悬户';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_zero_lon is '是否持有零贷';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_sign_mbank is '是否签约手机银行';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_add_cop_tiny is '是否添加企微';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_agree_camp_st_msg is '是否同意营销短信';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_sign_finc_risk is '是否签约风险测评';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_bind_scut_pay is '是否绑定快捷支付';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_concern_tiny_bank_bd_card is '是否关注微银行并绑卡';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_real_execu is '是否真实管户';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_loan is '是否持有贷款';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_curr is '是否持有活期';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_reg is '是否持有定期';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_fund is '是否持有基金';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_finc is '是否持有理财';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_insure is '是否持有保险';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_three_deposit is '是否持有三方存管';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_noble_met is '是否持有贵金属';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_am_trust is '是否持有资管信托';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_indv_mortg_loan is '是否持有个人按揭性贷款';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_indv_consm_loan is '是否持有个人消费性贷款';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.is_hold_indv_opering_loan is '是否持有个人经营性贷款';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.main_guar_way_crdt is '主担保方式为信用';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.main_guar_way_guar is '主担保方式为保证';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.main_guar_way_other is '主担保方式为其他';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.main_guar_way_pm is '主担保方式为抵质押';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.dep_ftp_cust_net_inco is '存款ftp客户净收入';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.loan_ftp_cust_net_inco is '贷款ftp客户净收入';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.loan_tot_risk_cost is '贷款总风险成本';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.dep_tot_eva is '存款总eva';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.loan_tot_eva is '贷款总eva';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.loan_ftp_net_margin is '贷款ftp净利润';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.dep_ftp_net_margin is '存款ftp净利润';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.inter_income_amt is '中收营收';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.career_cd is '职业代码';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.career_name is '职业名称';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.indus_cd is '行业代码';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.indus_name is '行业名称';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.custs is '客群';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.family_mon_inco is '家庭月收入';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.indv_mon_inco is '个人月收入';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.age is '年龄';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.gender is '性别';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.prov_cd is '省代码';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.prov_name is '省名称';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.city_cd is '城市代码';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.city_name is '城市名称';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.rg_cd is '地区代码';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.rg_name is '地区名称';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.level2_chn_lab is '二级渠道标签';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.level3_chn_lab is '三级渠道标签';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.eqty_exch_cnt is '权益星兑换次数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.eqty_exch_score is '权益星兑换分数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.point_exch_cnt is '积分兑换次数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.point_exch_score is '积分兑换分数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_tran_in_cnt is '近半年转入笔数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_tran_in_amt is '近半年转入金额';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_tran_out_cnt is '近半年转出笔数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_tran_out_amt is '近半年转出金额';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_bigamt_tran_in_cnt is '近半年大额转入笔数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_bigamt_tran_in_amt is '近半年大额转入金额';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_bigamt_tran_out_cnt is '近半年大额转出笔数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_bigamt_tran_out_amt is '近半年大额转出金额';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_mbank_prod_cnt is '近半年手机银行产品交互次数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_cnter_prod_cnt is '近半年柜面产品交互次数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_atm_cnt is '近半年atm交互次数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_onl_bank_prod_cnt is '近半年网上银行产品交互次数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_other_chn_prod_cnt is '近半年其他渠道产品交互次数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_tiny_arrive_cnt is '近半年企微触达次数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_sound_rec_tel_arrive_cnt is '近半年录音电话触达次数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_indv_wx_arrive_cnt is '近半年个人微信触达次数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_indv_tel_arrive_cnt is '近半年个人电话触达次数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.half_y_arrive_cnt is '近半年面访触达次数';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.job_cd is '任务代码';
comment on column ${idl_schema}.dmm_retl_cust_portrait_info.etl_timestamp is '数据处理时间';
--comment on column ${idl_schema}.dmm_retl_cust_portrait_info.etl_dt is 'ETL处理日期';
--comment on column ${idl_schema}.dmm_retl_cust_portrait_info.etl_timestamp is 'ETL处理时间戳';
