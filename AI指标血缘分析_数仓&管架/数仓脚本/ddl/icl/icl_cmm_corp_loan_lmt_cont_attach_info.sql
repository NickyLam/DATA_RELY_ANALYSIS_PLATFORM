/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_corp_loan_lmt_cont_attach_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cont_id varchar2(60) -- 合同编号
    ,lmt_id varchar2(100) -- 额度编号
    ,col_turn_margin_acct_num varchar2(60) -- 押品转保证金账号
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,lmt_kind_cd varchar2(30) -- 额度种类代码
    ,group_lmt_ctrl_mode_cd varchar2(30) -- 集团额度管控模式代码
    ,major_loan_cls_cd varchar2(30) -- 专业贷款分类代码
    ,prtcpt_way_cd varchar2(30) -- 参与方式代码
    ,crdt_rg_cd varchar2(30) -- 授信区域代码
    ,invest_way_cd varchar2(30) -- 投资方式代码
    ,lmt_under_sellbl_prod_id varchar2(100) -- 额度项下可售产品编号
    ,risk_expose_cls varchar2(100) -- 风险暴露分类
    ,public_crdt_flg varchar2(10) -- 公开授信标志
    ,fin_sys_cont_flg varchar2(10) -- 融资合同标志
    ,froz_flg varchar2(10) -- 冻结标志
    ,estate_fin_flg varchar2(10) -- 房地产融资标志
    ,invo_gover_class_fin_flg1 varchar2(10) -- 政府类融资标志
    ,consm_serv_class_fin_flg varchar2(10) -- 消费服务类融资标志
    ,br_build_ifin_flg varchar2(10) -- 一带一路建设投融资标志
    ,green_crdt_fin_flg varchar2(10) -- 绿色信贷融资标志
    ,class_crdt_flg varchar2(10) -- 类信贷标志
    ,distr_org_id varchar2(60) -- 放款机构编号
    ,passer_id varchar2(60) -- 通道方编号
    ,passer_name varchar2(500) -- 通道方名称
    ,lmt_invalid_dt date -- 额度失效日期
    ,lmt_under_bus_latest_exp_dt date -- 额度项下业务最迟到期日期
    ,lmt_next_bus_higt_pm_rat number(30,8) -- 额度下业务最高抵质押率
    ,lmt_next_bus_init_margin_ratio number(30,8) -- 额度下业务初始保证金比例
    ,lmt_next_bus_int_rat_lowt_flo_val number(30,8) -- 额度下业务利率最低浮动值
    ,lmt_next_bus_sig_max_amt number(30,6) -- 额度下业务单笔最大金额
    ,lmt_next_bus_lont_tenor number(22) -- 额度下业务最长期限
    ,lmt_next_bus_ext_tenor number(22) -- 额度下业务延展期限
    ,bus_curr_range varchar2(500) -- 业务币种范围
    ,lmt_use_cond_descb varchar2(4000) -- 额度使用条件描述
    ,syn_loan_tot_amt number(30,6) -- 银团贷款总金额
    ,onl_lmt number(30,6) -- 线上额度
    ,stat_use_open_bal number(30,8) -- 统计用敞口余额
    ,lmt_nmal_amt number(30,6) -- 额度名义金额
    ,lmt_open_amt number(30,6) -- 额度敞口金额
    ,used_nmal_amt number(30,6) -- 已用名义金额
    ,used_open_amt number(30,6) -- 已用敞口金额
    ,aval_nmal_amt number(30,6) -- 可用名义金额
    ,aval_open_amt number(30,6) -- 可用敞口金额
    ,lower_ocup_up_level_crdt_open_amt number(30,6) -- 下层占用上层授信敞口金额
    ,lower_ocup_up_level_crdt_nmal_amt number(30,6) -- 下层占用上层授信名义金额
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
grant select on ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info to ${idl_schema};
grant select on ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info to ${iel_schema};
grant select on ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info is '对公贷款额度合同补充信息';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_id is '额度编号';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.col_turn_margin_acct_num is '押品转保证金账号';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.tenor_type_cd is '期限类型代码';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_kind_cd is '额度种类代码';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.group_lmt_ctrl_mode_cd is '集团额度管控模式代码';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.major_loan_cls_cd is '专业贷款分类代码';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.prtcpt_way_cd is '参与方式代码';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.crdt_rg_cd is '授信区域代码';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.invest_way_cd is '投资方式代码';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_under_sellbl_prod_id is '额度项下可售产品编号';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.risk_expose_cls is '风险暴露分类';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.public_crdt_flg is '公开授信标志';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.fin_sys_cont_flg is '融资合同标志';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.froz_flg is '冻结标志';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.estate_fin_flg is '房地产融资标志';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.invo_gover_class_fin_flg1 is '政府类融资标志';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.consm_serv_class_fin_flg is '消费服务类融资标志';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.br_build_ifin_flg is '一带一路建设投融资标志';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.green_crdt_fin_flg is '绿色信贷融资标志';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.class_crdt_flg is '类信贷标志';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.distr_org_id is '放款机构编号';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.passer_id is '通道方编号';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.passer_name is '通道方名称';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_invalid_dt is '额度失效日期';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_under_bus_latest_exp_dt is '额度项下业务最迟到期日期';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_next_bus_higt_pm_rat is '额度下业务最高抵质押率';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_next_bus_init_margin_ratio is '额度下业务初始保证金比例';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_next_bus_int_rat_lowt_flo_val is '额度下业务利率最低浮动值';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_next_bus_sig_max_amt is '额度下业务单笔最大金额';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_next_bus_lont_tenor is '额度下业务最长期限';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_next_bus_ext_tenor is '额度下业务延展期限';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.bus_curr_range is '业务币种范围';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_use_cond_descb is '额度使用条件描述';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.syn_loan_tot_amt is '银团贷款总金额';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.onl_lmt is '线上额度';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.stat_use_open_bal is '统计用敞口余额';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_nmal_amt is '额度名义金额';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lmt_open_amt is '额度敞口金额';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.used_nmal_amt is '已用名义金额';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.used_open_amt is '已用敞口金额';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.aval_nmal_amt is '可用名义金额';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.aval_open_amt is '可用敞口金额';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lower_ocup_up_level_crdt_open_amt is '下层占用上层授信敞口金额';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.lower_ocup_up_level_crdt_nmal_amt is '下层占用上层授信名义金额';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info.etl_timestamp is 'ETL处理时间戳';
