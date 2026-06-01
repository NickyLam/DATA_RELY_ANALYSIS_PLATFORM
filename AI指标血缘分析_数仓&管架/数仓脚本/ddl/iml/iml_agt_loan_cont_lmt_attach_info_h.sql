/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_cont_lmt_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_cont_lmt_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_cont_lmt_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_cont_lmt_attach_info_h(
    agt_id varchar2(250) -- 协议编号
    ,cont_id varchar2(100) -- 合同编号
    ,lmt_next_bus_higt_pm_rat number(18,6) -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio number(18,6) -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val number(18,6) -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt number(30,2) -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor number(10) -- 额度下业务最长期限
    ,lmt_next_bus_delay_renew_tenor number(10) -- 额度下业务延展期限
    ,lmt_under_bus_latest_exp_dt date -- 额度项下业务最迟到期日期
    ,lmt_invalid_dt date -- 额度失效日期
    ,fin_cont_flg varchar2(10) -- 融资合同标志
    ,public_crdt_flg varchar2(10) -- 公开授信标志
    ,turn_crdt_flg varchar2(10) -- 转授信标志
    ,crdt_rg_cd varchar2(30) -- 授信区域代码
    ,crdt_bus_flow_type_cd varchar2(30) -- 授信业务流程类型代码
    ,lmt_dir_use_flg varchar2(10) -- 额度可直接使用标志
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,lmt_kind_cd varchar2(30) -- 额度种类代码
    ,group_lmt_crtl_mode_cd varchar2(30) -- 集团额度管控模式代码
    ,under_bus_curr_cd_range varchar2(250) -- 项下业务币种代码范围
    ,lmt_nmal_amt number(30,2) -- 额度名义金额
    ,lmt_open_amt number(30,2) -- 额度敞口金额
    ,used_nmal_amt number(30,2) -- 已用敞口金额
    ,used_open_amt number(30,2) -- 已用授信额度
    ,aval_nmal_amt number(30,2) -- 可用名义金额
    ,aval_open_amt number(30,2) -- 可用敞口金额
    ,syn_loan_tot_amt number(30,2) -- 银团贷款总金额
    ,major_loan_cls_cd varchar2(30) -- 专业贷款分类代码
    ,risk_expose_cls varchar2(100) -- 风险暴露分类代码
    ,invo_estate_fin_flg varchar2(10) -- 涉及房地产融资标志
    ,invo_gover_class_fin_flg varchar2(10) -- 涉及政府类融资标志
    ,br_build_ifin_flg varchar2(10) -- 一带一路建设投融资标志
    ,col_turn_margin_acct_id varchar2(100) -- 押品转保证金账户编号
    ,lmt_use_cond_descb varchar2(4000) -- 额度使用条件描述
    ,froz_flg varchar2(10) -- 冻结标志
    ,prtcptr_way_cd varchar2(30) -- 参与方式代码
    ,onl_lmt number(30,2) -- 线上额度
    ,consm_serv_class_fin_flg varchar2(10) -- 消费服务类融资标志
    ,green_crdt_fin_flg varchar2(10) -- 绿色信贷融资标志
    ,invest_way_cd varchar2(30) -- 投资方式代码
    ,class_crdt_flg varchar2(10) -- 类信贷标志
    ,distr_org_id varchar2(100) -- 放贷机构编号
    ,passer_id varchar2(100) -- 通道方编号
    ,passer_name varchar2(500) -- 通道方名称
    ,cap_src_cd varchar2(30) -- 资金来源代码
    ,ext_bond_item_rating_cd varchar2(30) -- 外部债项评级代码
    ,ext_rating_org_name varchar2(500) -- 外部评级机构名称
    ,ext_rating_dt date -- 外部评级日期
    ,col_turn_margin_sub_acct_num varchar2(60) -- 押品转保证金子户号
    ,lon_post_mgmt_teller_id varchar2(100) -- 贷后管理柜员编号
    ,lon_post_mgmt_org_id varchar2(100) -- 贷后管理机构编号
    ,debt_regroup_cnt number(10) -- 债务重组次数
    ,auto_que_lon_post_rept_flg varchar2(10) -- 自动查询贷后报告标志
    ,comn_risk_open_amt number(30,8) -- 一般风险敞口金额
    ,class_low_risk_open_amt number(30,8) -- 类低风险敞口金额
    ,ocup_o_use_lmt_flg varchar2(10) -- 占用他用额度标志
    ,single_higt_crdt_lmt_nmal_amt number(30,8) -- 单一最高授信额度名义金额
    ,single_higt_crdt_lmt_open_amt number(30,8) -- 单一最高授信额度敞口金额
    ,cent_mgmt_dept_id varchar2(100) -- 归口管理部门编号
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,have_incre_crdt_flg varchar2(10) -- 有增信标志
    ,ext_main_rating_cd varchar2(30) -- 外部主体评级代码
    ,main_rating_org_name varchar2(500) -- 主体评级机构名称
    ,main_rating_dt date -- 主体评级日期
    ,loan_usage_descb varchar2(1000) -- 贷款用途描述
    ,invest_underly_descb varchar2(500) -- 投资标的描述
    ,issuer_name varchar2(500) -- 发行人名称
    ,issuer_cust_id varchar2(100) -- 发行人客户编号
    ,mger_name varchar2(500) -- 管理人名称
    ,mger_cust_id varchar2(100) -- 管理人客户编号
    ,pente_flg varchar2(10) -- 可穿透标志
    ,sup_chain_bus_ocup_core_corp_lmt_flg varchar2(10) -- 供应链业务单占核心企业额度标志
    ,class_low_risk_flg varchar2(10) -- 类低风险标志
    ,inovt_bus_flg varchar2(10) -- 创新业务标志
    ,sup_chain_fin_bus_flg varchar2(10) -- 供应链金融业务标志
    ,ibank_lmt_type_cd varchar2(30) -- 同业额度类型代码
    ,appl_syn_loan_tot number(30,2) -- 申请银团贷款总额
    ,fit_in_single_cust_or_group_lmt_flg varchar2(10) -- 纳入单一客户或集团限额标志
    ,comb_class_consmt_flg varchar2(10) -- 集合类代销标志
    ,set_single_cust_lmt_flg varchar2(10) -- 设置单一客户限额标志
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
grant select on ${iml_schema}.agt_loan_cont_lmt_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_cont_lmt_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_cont_lmt_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_cont_lmt_attach_info_h is '贷款合同额度附属信息历史';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_next_bus_higt_pm_rat is '额度下业务最高抵质押率';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_next_bus_init_margin_ratio is '额度下业务初始保证金比例';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_next_bus_int_rat_lowt_flo_val is '额度下业务利率最低浮动值';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_next_bus_sig_max_amt is '额度下业务单笔最大金额';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_next_bus_lont_tenor is '额度下业务最长期限';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_next_bus_delay_renew_tenor is '额度下业务延展期限';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_under_bus_latest_exp_dt is '额度项下业务最迟到期日期';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_invalid_dt is '额度失效日期';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.fin_cont_flg is '融资合同标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.public_crdt_flg is '公开授信标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.turn_crdt_flg is '转授信标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.crdt_rg_cd is '授信区域代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.crdt_bus_flow_type_cd is '授信业务流程类型代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_dir_use_flg is '额度可直接使用标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_kind_cd is '额度种类代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.group_lmt_crtl_mode_cd is '集团额度管控模式代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.under_bus_curr_cd_range is '项下业务币种代码范围';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_nmal_amt is '额度名义金额';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_open_amt is '额度敞口金额';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.used_nmal_amt is '已用敞口金额';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.used_open_amt is '已用授信额度';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.aval_nmal_amt is '可用名义金额';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.aval_open_amt is '可用敞口金额';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.syn_loan_tot_amt is '银团贷款总金额';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.major_loan_cls_cd is '专业贷款分类代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.risk_expose_cls is '风险暴露分类代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.invo_estate_fin_flg is '涉及房地产融资标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.invo_gover_class_fin_flg is '涉及政府类融资标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.br_build_ifin_flg is '一带一路建设投融资标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.col_turn_margin_acct_id is '押品转保证金账户编号';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lmt_use_cond_descb is '额度使用条件描述';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.froz_flg is '冻结标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.prtcptr_way_cd is '参与方式代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.onl_lmt is '线上额度';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.consm_serv_class_fin_flg is '消费服务类融资标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.green_crdt_fin_flg is '绿色信贷融资标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.invest_way_cd is '投资方式代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.class_crdt_flg is '类信贷标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.distr_org_id is '放贷机构编号';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.passer_id is '通道方编号';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.passer_name is '通道方名称';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.cap_src_cd is '资金来源代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.ext_bond_item_rating_cd is '外部债项评级代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.ext_rating_org_name is '外部评级机构名称';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.ext_rating_dt is '外部评级日期';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.col_turn_margin_sub_acct_num is '押品转保证金子户号';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lon_post_mgmt_teller_id is '贷后管理柜员编号';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.lon_post_mgmt_org_id is '贷后管理机构编号';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.debt_regroup_cnt is '债务重组次数';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.auto_que_lon_post_rept_flg is '自动查询贷后报告标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.comn_risk_open_amt is '一般风险敞口金额';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.class_low_risk_open_amt is '类低风险敞口金额';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.ocup_o_use_lmt_flg is '占用他用额度标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.single_higt_crdt_lmt_nmal_amt is '单一最高授信额度名义金额';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.single_higt_crdt_lmt_open_amt is '单一最高授信额度敞口金额';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.cent_mgmt_dept_id is '归口管理部门编号';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.have_incre_crdt_flg is '有增信标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.ext_main_rating_cd is '外部主体评级代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.main_rating_org_name is '主体评级机构名称';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.main_rating_dt is '主体评级日期';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.loan_usage_descb is '贷款用途描述';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.invest_underly_descb is '投资标的描述';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.issuer_name is '发行人名称';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.issuer_cust_id is '发行人客户编号';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.mger_name is '管理人名称';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.mger_cust_id is '管理人客户编号';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.pente_flg is '可穿透标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.sup_chain_bus_ocup_core_corp_lmt_flg is '供应链业务单占核心企业额度标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.class_low_risk_flg is '类低风险标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.inovt_bus_flg is '创新业务标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.sup_chain_fin_bus_flg is '供应链金融业务标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.ibank_lmt_type_cd is '同业额度类型代码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.appl_syn_loan_tot is '申请银团贷款总额';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.fit_in_single_cust_or_group_lmt_flg is '纳入单一客户或集团限额标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.comb_class_consmt_flg is '集合类代销标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.set_single_cust_lmt_flg is '设置单一客户限额标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_cont_lmt_attach_info_h.etl_timestamp is 'ETL处理时间戳';
