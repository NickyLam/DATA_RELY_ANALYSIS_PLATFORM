/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_crdt_lmt_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_crdt_lmt_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_crdt_lmt_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_crdt_lmt_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,lmt_id varchar2(100) -- 额度编号
    ,cust_id varchar2(100) -- 客户编号
    ,fit_prod_id varchar2(4000) -- 适用产品编号
    ,lmt_prod_id varchar2(250) -- 额度产品编号
    ,curr_crdt_stage_cd varchar2(30) -- 当前授信阶段代码
    ,init_src_sys_cd varchar2(30) -- 最初来源系统代码
    ,init_src_lmt_id varchar2(100) -- 最初来源额度编号
    ,happ_way_cd varchar2(30) -- 发生方式代码
    ,curr_cd varchar2(30) -- 币种代码
    ,aval_nmal_amt number(30,8) -- 可用名义金额
    ,aval_open_amt number(30,8) -- 可用敞口金额
    ,open_amt number(30,8) -- 敞口金额
    ,nmal_amt number(30,8) -- 名义金额
    ,exec_nmal_amt number(30,8) -- 执行名义金额
    ,exec_open_amt number(30,8) -- 执行敞口金额
    ,exec_dr_open_amt number(30,8) -- 执行可缓释敞口金额
    ,dr_open_curr_cd varchar2(30) -- 可缓释敞口币种代码
    ,dr_open_amt number(30,8) -- 可缓释敞口金额
    ,circl_flg varchar2(10) -- 可循环标志
    ,lmt_under_dir_draw_flg varchar2(10) -- 额度项下可直接提款标志
    ,effect_dt date -- 生效日期
    ,exp_dt date -- 到期日期
    ,ocup_idf_cd varchar2(30) -- 占用标识代码
    ,lock_flg varchar2(10) -- 锁定标志
    ,aldy_froz_flg varchar2(10) -- 已冻结标志
    ,status_cd varchar2(30) -- 状态代码
    ,crdt_nmal_bal number(30,8) -- 授信名义余额
    ,crdt_open_bal number(30,8) -- 授信敞口余额
    ,lower_ocup_up_level_crdt_open_amt number(30,8) -- 下层占用上层授信敞口金额
    ,lower_ocup_up_level_crdt_nmal_amt number(30,8) -- 下层占用上层授信名义金额
    ,spec_ocup_up_level_crdt_open_amt number(30,8) -- 指定占用上层授信敞口金额
    ,spec_ocup_up_level_crdt_nmal_amt number(30,8) -- 指定占用上层授信名义金额
    ,under_lower_crdt_latest_begin_dt date -- 项下下层授信最迟起始日期
    ,under_lower_crdt_earliest_begin_dt date -- 项下下层授信最早起始日期
    ,lmt_latest_use_dt date -- 额度最迟使用日期
    ,under_lower_crdt_latest_exp_dt date -- 项下下层授信最迟到期日期
    ,under_lower_crdt_lont_mon_tenor number(10) -- 项下下层授信最长月期限
    ,under_lower_crdt_lont_day_tenor number(10) -- 项下下层授信最长日期限
    ,lower_crdt_nmal_bal_ocup_tot number(30,8) -- 下层授信名义余额占用汇总
    ,lower_crdt_open_bal_ocup_tot number(30,8) -- 下层授信敞口余额占用汇总
    ,dtl_lmt_next_bus_sig_max_amt number(30,8) -- 明细额度下业务单笔最大金额
    ,lmt_next_bus_int_rat_lowt_flo_val number(18,6) -- 额度下业务利率最低浮动值
    ,lmt_next_bus_init_margin_ratio number(18,6) -- 额度下业务初始保证金比例
    ,lmt_next_bus_higt_pm_rat number(18,6) -- 额度下业务最高抵质押率
    ,lower_bus_ocup_nmal_amt_tot number(30,8) -- 下层业务占用名义金额汇总
    ,lower_bus_ocup_open_amt_tot number(30,8) -- 下层业务占用敞口金额汇总
    ,beads_nmal_amt number(30,8) -- 串用名义金额
    ,beads_open_amt number(30,8) -- 串用敞口金额
    ,pre_ocup_nmal_amt number(30,8) -- 预占名义金额
    ,pre_ocup_open_amt number(30,8) -- 预占敞口金额
    ,surp_pre_ocup_nmal_amt number(30,8) -- 剩余预占名义金额
    ,surp_pre_ocup_open_amt number(30,8) -- 剩余预占敞口金额
    ,froz_nmal_amt number(30,8) -- 冻结名义金额
    ,froz_open_amt number(30,8) -- 冻结敞口金额
    ,under_bus_curr_cd_range varchar2(250) -- 项下业务币种代码范围
    ,crdt_spec_flg varchar2(10) -- 授信专用标志
    ,aval_rsrv_amt number(30,2) -- 可用预留金额
    ,rsrv_amt number(30,2) -- 预留金额
    ,aval_amt_calc_flg varchar2(10) -- 可用金额计算标志
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,day_tenor number(10) -- 日期限
    ,mon_tenor number(10) -- 月期限
    ,acm_distr_amt number(30,8) -- 累计放款金额
    ,acm_repay_amt number(30,8) -- 累计还款金额
    ,actl_invalid_dt date -- 实际失效日期
    ,oper_teller_id varchar2(100) -- 业务经办人编号
    ,oper_org_id varchar2(100) -- 经办机构编号
    ,mgmt_teller_id varchar2(100) -- 管理柜员编号
    ,mgmt_org_id varchar2(100) -- 管理机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
    ,lmt_kind_cd varchar2(30) -- 额度种类代码
    ,public_crdt_flg varchar2(10) -- 公开授信标志
    ,usage_descb varchar2(2000) -- 用途描述
    ,other_cond_descb varchar2(2000) -- 其他条件描述
    ,gm_cust_id varchar2(2000) -- 集团成员客户编号
    ,init_onl_lmt number(30,8) -- 初始线上额度
    ,turn_crdt_flg varchar2(10) -- 转授信标志
    ,init_comn_open_amt number(30,8) -- 初始一般敞口金额
    ,comn_risk_aval_open_amt number(30,8) -- 一般风险可用敞口金额
    ,pmo_amt number(30,8) -- 抵质押物金额
    ,cap_sys_onl_bus_amt_tot number(30,8) -- 资金系统线上业务金额汇总
    ,cap_sys_onl_bus_bal_tot number(30,8) -- 资金系统线上业务余额汇总
    ,lower_ocup_onl_lmt_amt number(30,8) -- 下层占用线上额度金额
    ,lower_ocup_onl_open_amt number(30,8) -- 下层占用线上敞口金额
    ,fit_in_single_cust_or_group_lmt_flg varchar2(10) -- 纳入单一客户或集团限额标志
    ,intnal_contr_amt_degree_ocup_amt number(30,8) -- 内部管控额度占用金额
    ,risk_mgmt_apv_aval_amt number(30,8) -- 风控审批可用金额
    ,reply_id varchar2(100) -- 批复编号
    ,ocup_group_crdt_lmt_id varchar2(100) -- 占用集团授信额度编号
    ,risk_mgmt_annual_vrfction_apv_aval_amt number(30,8) -- 风控年审审批可用金额
    ,free_flg varchar2(10) -- 豁免标志
    ,comb_class_consmt_flg varchar2(10) -- 集合类代销标志
    ,remark varchar2(1000) -- 备注
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
grant select on ${iml_schema}.agt_crdt_lmt_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_crdt_lmt_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_crdt_lmt_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_crdt_lmt_info_h is '授信额度信息历史';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lmt_id is '额度编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.fit_prod_id is '适用产品编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lmt_prod_id is '额度产品编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.curr_crdt_stage_cd is '当前授信阶段代码';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.init_src_sys_cd is '最初来源系统代码';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.init_src_lmt_id is '最初来源额度编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.happ_way_cd is '发生方式代码';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.aval_nmal_amt is '可用名义金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.aval_open_amt is '可用敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.open_amt is '敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.nmal_amt is '名义金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.exec_nmal_amt is '执行名义金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.exec_open_amt is '执行敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.exec_dr_open_amt is '执行可缓释敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.dr_open_curr_cd is '可缓释敞口币种代码';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.dr_open_amt is '可缓释敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.circl_flg is '可循环标志';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lmt_under_dir_draw_flg is '额度项下可直接提款标志';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.ocup_idf_cd is '占用标识代码';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lock_flg is '锁定标志';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.aldy_froz_flg is '已冻结标志';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.status_cd is '状态代码';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.crdt_nmal_bal is '授信名义余额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.crdt_open_bal is '授信敞口余额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lower_ocup_up_level_crdt_open_amt is '下层占用上层授信敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lower_ocup_up_level_crdt_nmal_amt is '下层占用上层授信名义金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.spec_ocup_up_level_crdt_open_amt is '指定占用上层授信敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.spec_ocup_up_level_crdt_nmal_amt is '指定占用上层授信名义金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.under_lower_crdt_latest_begin_dt is '项下下层授信最迟起始日期';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.under_lower_crdt_earliest_begin_dt is '项下下层授信最早起始日期';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lmt_latest_use_dt is '额度最迟使用日期';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.under_lower_crdt_latest_exp_dt is '项下下层授信最迟到期日期';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.under_lower_crdt_lont_mon_tenor is '项下下层授信最长月期限';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.under_lower_crdt_lont_day_tenor is '项下下层授信最长日期限';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lower_crdt_nmal_bal_ocup_tot is '下层授信名义余额占用汇总';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lower_crdt_open_bal_ocup_tot is '下层授信敞口余额占用汇总';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.dtl_lmt_next_bus_sig_max_amt is '明细额度下业务单笔最大金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lmt_next_bus_int_rat_lowt_flo_val is '额度下业务利率最低浮动值';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lmt_next_bus_init_margin_ratio is '额度下业务初始保证金比例';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lmt_next_bus_higt_pm_rat is '额度下业务最高抵质押率';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lower_bus_ocup_nmal_amt_tot is '下层业务占用名义金额汇总';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lower_bus_ocup_open_amt_tot is '下层业务占用敞口金额汇总';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.beads_nmal_amt is '串用名义金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.beads_open_amt is '串用敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.pre_ocup_nmal_amt is '预占名义金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.pre_ocup_open_amt is '预占敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.surp_pre_ocup_nmal_amt is '剩余预占名义金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.surp_pre_ocup_open_amt is '剩余预占敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.froz_nmal_amt is '冻结名义金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.froz_open_amt is '冻结敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.under_bus_curr_cd_range is '项下业务币种代码范围';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.crdt_spec_flg is '授信专用标志';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.aval_rsrv_amt is '可用预留金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.rsrv_amt is '预留金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.aval_amt_calc_flg is '可用金额计算标志';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.day_tenor is '日期限';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.mon_tenor is '月期限';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.acm_distr_amt is '累计放款金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.acm_repay_amt is '累计还款金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.actl_invalid_dt is '实际失效日期';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.oper_teller_id is '业务经办人编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.mgmt_teller_id is '管理柜员编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lmt_kind_cd is '额度种类代码';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.public_crdt_flg is '公开授信标志';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.usage_descb is '用途描述';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.other_cond_descb is '其他条件描述';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.gm_cust_id is '集团成员客户编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.init_onl_lmt is '初始线上额度';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.turn_crdt_flg is '转授信标志';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.init_comn_open_amt is '初始一般敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.comn_risk_aval_open_amt is '一般风险可用敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.pmo_amt is '抵质押物金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.cap_sys_onl_bus_amt_tot is '资金系统线上业务金额汇总';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.cap_sys_onl_bus_bal_tot is '资金系统线上业务余额汇总';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lower_ocup_onl_lmt_amt is '下层占用线上额度金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.lower_ocup_onl_open_amt is '下层占用线上敞口金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.fit_in_single_cust_or_group_lmt_flg is '纳入单一客户或集团限额标志';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.intnal_contr_amt_degree_ocup_amt is '内部管控额度占用金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.risk_mgmt_apv_aval_amt is '风控审批可用金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.reply_id is '批复编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.ocup_group_crdt_lmt_id is '占用集团授信额度编号';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.risk_mgmt_annual_vrfction_apv_aval_amt is '风控年审审批可用金额';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.free_flg is '豁免标志';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.comb_class_consmt_flg is '集合类代销标志';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.remark is '备注';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_crdt_lmt_info_h.etl_timestamp is 'ETL处理时间戳';
