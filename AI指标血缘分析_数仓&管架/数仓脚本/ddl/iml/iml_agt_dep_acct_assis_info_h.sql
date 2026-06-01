/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_acct_assis_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_acct_assis_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_acct_assis_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_assis_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,pcp_de_int_flag varchar2(10) -- 产品细类代码
    ,cls_prod_id varchar2(100) -- 分类产品编号
    ,inside_acct_char_cd varchar2(30) -- 内部账户性质代码
    ,acct_char_cd varchar2(30) -- 外汇账户性质代码
    ,acct_vrif_status_cd varchar2(30) -- 账户核实状态代码
    ,last_acct_vrif_status_cd varchar2(30) -- 上一账户核实状态代码
    ,acct_chn_idf_cd varchar2(30) -- 账户渠道标识代码
    ,acct_bal_dir_cd varchar2(30) -- 账户余额方向代码
    ,bal_update_type_cd varchar2(30) -- 余额更新类型代码
    ,bal_linkg_chg_flg varchar2(10) -- 余额联动变动标志
    ,accrd_freq_pay_int_flg varchar2(10) -- 按频率付息标志
    ,tax_rat number(18,8) -- 税率
    ,ped varchar2(10) -- 周期
    ,ped_corp_cd varchar2(30) -- 周期单位代码
    ,sign_prod_cls_cd varchar2(30) -- 签约产品分类代码
    ,sign_agt_id varchar2(100) -- 签约协议编号
    ,sign_agt_status_cd varchar2(30) -- 签约协议状态代码
    ,dep_char_cd varchar2(30) -- 存款性质代码
    ,agt_dep_type_cd varchar2(30) -- 协议存款类型代码
    ,cap_char varchar2(30) -- 资金性质
    ,pd_cd varchar2(30) -- 期次编号
    ,verify_type_cd varchar2(30) -- 查证类型代码
    ,verify_amt number(30,2) -- 查证金额
    ,disp_way_cd varchar2(30) -- 处置方式代码
    ,st_msg_sign_status_cd varchar2(30) -- 短信签约状态代码
    ,cntpty_cust_id varchar2(100) -- 对手客户编号
    ,cntpty_acct_num varchar2(60) -- 对手账号
    ,cntpty_acct_num_name varchar2(500) -- 对手账号名称
    ,cntpty_acct_open_bank_name varchar2(500) -- 对手账户开户行名称
    ,cntpty_acct_open_acct_org_id varchar2(100) -- 对手账户开户机构编号
    ,cntpty_acct_open_acct_dt date -- 对手账户开户日期
    ,cntpty_bk_open_acct_org_belong_dist_cd varchar2(30) -- 对手行开户机构所属行政区域代码
    ,cntpty_bank_belong_cty_rg_cd varchar2(30) -- 对手行所属国家和地区代码
    ,non_i_class_acct_check_status_cd varchar2(30) -- 非I类户验证状态代码
    ,suspd_wrtoff_flg varchar2(10) -- 挂销账标志
    ,on_acct_tenor number(10) -- 挂账期限
    ,supv_flg varchar2(10) -- 监管标志
    ,supv_type_cd varchar2(30) -- 监管类型代码
    ,supv_content_descb varchar2(500) -- 监管内容描述
    ,open_acct_way_cd varchar2(30) -- 开户方式代码
    ,open_type_cd varchar2(30) -- 开立类型代码
    ,remote_open_acct_flg varchar2(10) -- 异地开户标志
    ,open_acct_city varchar2(100) -- 开户城市
    ,open_acct_prov varchar2(100) -- 开户省份
    ,can_od_flg varchar2(10) -- 可透支标志
    ,acm_can_wdraw_pric_amt number(30,2) -- 累计可支取本金金额
    ,int_tax_impose_flg varchar2(10) -- 利息税征收标志
    ,onl_flg varchar2(10) -- 联机标志
    ,final_blklist_dt date -- 最后黑名单日期
    ,blklist_status_cd varchar2(30) -- 黑名单状态代码
    ,legal_flg varchar2(10) -- 涉案标志
    ,legal_dt date -- 涉案日期
    ,legal_rs_descb varchar2(500) -- 涉案原因描述
    ,apv_odd_no varchar2(60) -- 审批单号
    ,general_exch_org_id varchar2(100) -- 通兑机构编号
    ,clos_acct_reop_dt date -- 销户重开日期
    ,wrtoff_way_cd varchar2(30) -- 销账方式代码
    ,check_fail_rs_descb varchar2(500) -- 验证失败原因描述
    ,cert_as_flg varchar2(10) -- 证件年检标志
    ,aldy_as_flg varchar2(10) -- 已年检标志
    ,last_as_closing_dt date -- 上一年检截止日期
    ,last_as_reset_dt date -- 上一年检重置日期
    ,bank_inter_id varchar2(100) -- 银行国际编号
    ,privavy_acct_flg varchar2(10) -- 隐私账户标志
    ,earliest_wdraw_dt date -- 最早可支取日期
    ,unexp_draw_dt date -- 提前支取日期
    ,precon_payoff_day date -- 预约结清日
    ,allow_sell_check_flg varchar2(10) -- 允许出售支票标志
    ,allow_cnter_cross_bank_depot_permit_flg varchar2(10) -- 允许柜面跨行存入许可标志
    ,allow_cnter_cross_bank_wdraw_permit_flg varchar2(10) -- 允许柜面跨行支取许可标志
    ,allow_manual_entry_flg varchar2(10) -- 允许手工记账标志
    ,allow_acct_turn_long_hang_flg varchar2(10) -- 允许账户转久悬标志
    ,acct_redt_tenor varchar2(10) -- 账户转存期限
    ,acct_redt_tenor_cd varchar2(30) -- 账户转存期限代码
    ,turn_back_dt date -- 转回日期
    ,next_renew_dep_day varchar2(10) -- 下一续存日
    ,ftz_cd varchar2(30) -- 自贸区代码
    ,ftz_acct_flg varchar2(10) -- 自贸区账户标志
    ,precon_wdraw_flg varchar2(10) -- 预约支取标志
    ,precon_wdraw_dt date -- 预约支取日期
    ,print_cert_flg varchar2(10) -- 打印证实书标志
    ,auto_renew_dep_flg varchar2(10) -- 自动续存标志
    ,one_key_open_acct_flg varchar2(10) -- 一键开户标志
    ,prefr_int_tax_rat_exp_dt date -- 优惠利息税率到期日期
    ,delay_pay_int_flg varchar2(10) -- 延期付息标志
    ,spec_day number(10) -- 指定日
    ,bi_lmt_lmt_flg varchar2(10) -- 双边限额限制标志
    ,cap_src_acct_id varchar2(100) -- 资金来源账户编号
    ,cap_src_acct_sub_acct_num varchar2(60) -- 资金来源账户子账号
    ,hold_valid_id_card_flg varchar2(10) -- 持有有效身份证件标志
    ,cds_prod_modif_flg varchar2(10) -- 大额存单产品变更标志
    ,cash_mgmt_prod_flg varchar2(10) -- 现金管理产品标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_dep_acct_assis_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_dep_acct_assis_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_dep_acct_assis_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_acct_assis_info_h is '存款账户附加信息历史';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.pcp_de_int_flag is '产品细类代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cls_prod_id is '分类产品编号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.inside_acct_char_cd is '内部账户性质代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.acct_char_cd is '外汇账户性质代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.acct_vrif_status_cd is '账户核实状态代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.last_acct_vrif_status_cd is '上一账户核实状态代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.acct_chn_idf_cd is '账户渠道标识代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.acct_bal_dir_cd is '账户余额方向代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.bal_update_type_cd is '余额更新类型代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.bal_linkg_chg_flg is '余额联动变动标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.accrd_freq_pay_int_flg is '按频率付息标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.tax_rat is '税率';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.ped is '周期';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.ped_corp_cd is '周期单位代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.sign_prod_cls_cd is '签约产品分类代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.sign_agt_id is '签约协议编号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.sign_agt_status_cd is '签约协议状态代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.dep_char_cd is '存款性质代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.agt_dep_type_cd is '协议存款类型代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cap_char is '资金性质';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.pd_cd is '期次编号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.verify_type_cd is '查证类型代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.verify_amt is '查证金额';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.disp_way_cd is '处置方式代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.st_msg_sign_status_cd is '短信签约状态代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cntpty_cust_id is '对手客户编号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cntpty_acct_num is '对手账号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cntpty_acct_num_name is '对手账号名称';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cntpty_acct_open_bank_name is '对手账户开户行名称';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cntpty_acct_open_acct_org_id is '对手账户开户机构编号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cntpty_acct_open_acct_dt is '对手账户开户日期';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cntpty_bk_open_acct_org_belong_dist_cd is '对手行开户机构所属行政区域代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cntpty_bank_belong_cty_rg_cd is '对手行所属国家和地区代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.non_i_class_acct_check_status_cd is '非I类户验证状态代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.suspd_wrtoff_flg is '挂销账标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.on_acct_tenor is '挂账期限';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.supv_flg is '监管标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.supv_type_cd is '监管类型代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.supv_content_descb is '监管内容描述';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.open_acct_way_cd is '开户方式代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.open_type_cd is '开立类型代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.remote_open_acct_flg is '异地开户标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.open_acct_city is '开户城市';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.open_acct_prov is '开户省份';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.can_od_flg is '可透支标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.acm_can_wdraw_pric_amt is '累计可支取本金金额';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.int_tax_impose_flg is '利息税征收标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.onl_flg is '联机标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.final_blklist_dt is '最后黑名单日期';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.blklist_status_cd is '黑名单状态代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.legal_flg is '涉案标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.legal_dt is '涉案日期';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.legal_rs_descb is '涉案原因描述';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.apv_odd_no is '审批单号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.general_exch_org_id is '通兑机构编号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.clos_acct_reop_dt is '销户重开日期';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.wrtoff_way_cd is '销账方式代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.check_fail_rs_descb is '验证失败原因描述';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cert_as_flg is '证件年检标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.aldy_as_flg is '已年检标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.last_as_closing_dt is '上一年检截止日期';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.last_as_reset_dt is '上一年检重置日期';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.bank_inter_id is '银行国际编号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.privavy_acct_flg is '隐私账户标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.earliest_wdraw_dt is '最早可支取日期';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.unexp_draw_dt is '提前支取日期';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.precon_payoff_day is '预约结清日';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.allow_sell_check_flg is '允许出售支票标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.allow_cnter_cross_bank_depot_permit_flg is '允许柜面跨行存入许可标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.allow_cnter_cross_bank_wdraw_permit_flg is '允许柜面跨行支取许可标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.allow_manual_entry_flg is '允许手工记账标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.allow_acct_turn_long_hang_flg is '允许账户转久悬标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.acct_redt_tenor is '账户转存期限';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.acct_redt_tenor_cd is '账户转存期限代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.turn_back_dt is '转回日期';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.next_renew_dep_day is '下一续存日';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.ftz_cd is '自贸区代码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.ftz_acct_flg is '自贸区账户标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.precon_wdraw_flg is '预约支取标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.precon_wdraw_dt is '预约支取日期';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.print_cert_flg is '打印证实书标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.auto_renew_dep_flg is '自动续存标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.one_key_open_acct_flg is '一键开户标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.prefr_int_tax_rat_exp_dt is '优惠利息税率到期日期';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.delay_pay_int_flg is '延期付息标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.spec_day is '指定日';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.bi_lmt_lmt_flg is '双边限额限制标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cap_src_acct_id is '资金来源账户编号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cap_src_acct_sub_acct_num is '资金来源账户子账号';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.hold_valid_id_card_flg is '持有有效身份证件标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cds_prod_modif_flg is '大额存单产品变更标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.cash_mgmt_prod_flg is '现金管理产品标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_acct_assis_info_h.etl_timestamp is 'ETL处理时间戳';
