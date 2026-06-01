/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_zjdk_crdt_appl_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_zjdk_crdt_appl_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_zjdk_crdt_appl_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_zjdk_crdt_appl_info_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,crdt_appl_flow_num varchar2(100) -- 授信申请流水号
    ,myloan_req_flow_num varchar2(100) -- 网商贷请求流水号
    ,stud_loan_req_flow_num varchar2(100) -- 助贷请求流水号
    ,crdt_appl_type_cd varchar2(30) -- 授信申请类型代码
    ,crdt_id varchar2(100) -- 授信编号
    ,prod_id varchar2(100) -- 产品编号
    ,prod_cate_cd varchar2(30) -- 产品类别代码
    ,curr_cd varchar2(30) -- 币种代码
    ,crdt_status_cd varchar2(60) -- 授信状态代码
    ,crdt_appl_sucs_flg varchar2(10) -- 授信申请成功标志
    ,crdt_chn_cd varchar2(60) -- 授信渠道代码
    ,crdt_lmt number(30,8) -- 授信额度
    ,crdt_day_int_rat number(30,8) -- 授信日利率
    ,crdt_year_int_rat number(30,8) -- 授信年利率
    ,crdt_exp_dt date -- 授信到期日期
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cust_char_cd varchar2(30) -- 客户性质代码
    ,cert_type_cd varchar2(60) -- 证件类型代码
    ,cert_no varchar2(250) -- 证件号码
    ,mobile_no varchar2(100) -- 手机号码
    ,gender_cd varchar2(30) -- 性别代码
    ,nation_cd varchar2(60) -- 国籍代码
    ,nome_phone_num varchar2(60) -- 家庭电话号码
    ,resdnt_addr varchar2(1000) -- 居住地址
    ,birth_dt date -- 出生日期
    ,id_card_addr_info varchar2(1000) -- 身份证地址信息
    ,id_card_effect_dt date -- 身份证生效日期
    ,id_card_exp_dt date -- 身份证到期日期
    ,nationty varchar2(60) -- 民族
    ,issue_org varchar2(500) -- 签发机关
    ,career_cd varchar2(30) -- 职业代码
    ,bank_card_num varchar2(100) -- 银行卡号
    ,bank_name varchar2(500) -- 银行名称
    ,bank_rsrv_mobile_no varchar2(100) -- 银行预留手机号
    ,corp_name varchar2(500) -- 企业名称
    ,soci_crdt_cd varchar2(100) -- 社会信用代码
    ,bus_lics_num varchar2(100) -- 营业执照号
    ,bl_induty_type_type_cd varchar2(100) -- 所属行业类型类型代码
    ,dss_flg varchar2(10) -- 董监高标志
    ,sm_lab varchar2(4000) -- 小微标签
    ,borw_usage_cd varchar2(60) -- 借款用途代码
    ,risk_mgmt_rest_cd varchar2(60) -- 风控结果代码
    ,risk_mgmt_crdt_lmt number(30,8) -- 风控授信额度
    ,risk_mgmt_int_year_int_rat number(30,8) -- 风控利息年利率
    ,risk_mgmt_refuse_code varchar2(250) -- 风控拒绝码
    ,risk_mgmt_refuse_rs varchar2(4000) -- 风控拒绝原因
    ,risk_mgmt_re_dt date -- 风控回调日期
    ,lmt_cont_flg varchar2(10) -- 额度合同标志
    ,lmt_cont_id varchar2(100) -- 额度合同编号
    ,intnal_dubil_id varchar2(100) -- 借据编号
    ,actl_lmt number(30,8) -- 实际额度
    ,aval_lmt number(30,8) -- 可用额度
    ,borw_tot_amt number(30,8) -- 借款总金额
    ,unite_bk_amt number(30,8) -- 联合行金额
    ,loan_perds number(10) -- 贷款期数
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,actl_day_int_rat number(30,8) -- 实际日利率
    ,actl_year_int_rat number(30,8) -- 实际年利率
    ,cap_code varchar2(100) -- 资金码
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
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
grant select on ${iml_schema}.agt_zjdk_crdt_appl_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_zjdk_crdt_appl_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_zjdk_crdt_appl_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_zjdk_crdt_appl_info_h is '字节小微贷授信申请信息历史';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.crdt_appl_flow_num is '授信申请流水号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.myloan_req_flow_num is '网商贷请求流水号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.stud_loan_req_flow_num is '助贷请求流水号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.crdt_appl_type_cd is '授信申请类型代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.crdt_id is '授信编号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.prod_cate_cd is '产品类别代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.crdt_status_cd is '授信状态代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.crdt_appl_sucs_flg is '授信申请成功标志';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.crdt_chn_cd is '授信渠道代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.crdt_lmt is '授信额度';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.crdt_day_int_rat is '授信日利率';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.crdt_year_int_rat is '授信年利率';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.crdt_exp_dt is '授信到期日期';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.cust_char_cd is '客户性质代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.mobile_no is '手机号码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.gender_cd is '性别代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.nation_cd is '国籍代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.nome_phone_num is '家庭电话号码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.resdnt_addr is '居住地址';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.birth_dt is '出生日期';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.id_card_addr_info is '身份证地址信息';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.id_card_effect_dt is '身份证生效日期';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.id_card_exp_dt is '身份证到期日期';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.nationty is '民族';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.issue_org is '签发机关';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.career_cd is '职业代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.bank_card_num is '银行卡号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.bank_name is '银行名称';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.bank_rsrv_mobile_no is '银行预留手机号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.corp_name is '企业名称';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.soci_crdt_cd is '社会信用代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.bus_lics_num is '营业执照号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.bl_induty_type_type_cd is '所属行业类型类型代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.dss_flg is '董监高标志';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.sm_lab is '小微标签';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.borw_usage_cd is '借款用途代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.risk_mgmt_rest_cd is '风控结果代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.risk_mgmt_crdt_lmt is '风控授信额度';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.risk_mgmt_int_year_int_rat is '风控利息年利率';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.risk_mgmt_refuse_code is '风控拒绝码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.risk_mgmt_refuse_rs is '风控拒绝原因';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.risk_mgmt_re_dt is '风控回调日期';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.lmt_cont_flg is '额度合同标志';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.lmt_cont_id is '额度合同编号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.intnal_dubil_id is '借据编号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.actl_lmt is '实际额度';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.aval_lmt is '可用额度';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.borw_tot_amt is '借款总金额';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.unite_bk_amt is '联合行金额';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.loan_perds is '贷款期数';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.actl_day_int_rat is '实际日利率';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.actl_year_int_rat is '实际年利率';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.cap_code is '资金码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_zjdk_crdt_appl_info_h.etl_timestamp is 'ETL处理时间戳';
