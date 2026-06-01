/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lx_crdt_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lx_crdt_appl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lx_crdt_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lx_crdt_appl(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,src_appl_flow_num varchar2(100) -- 源申请流水号
    ,prod_id varchar2(100) -- 产品编号
    ,org_id varchar2(100) -- 机构编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,appl_type_cd varchar2(30) -- 申请类型代码
    ,appl_lmt number(30,8) -- 申请额度
    ,appl_status_cd varchar2(60) -- 申请状态代码
    ,crdt_status_cd varchar2(30) -- 授信状态代码
    ,guar_way_cd varchar2(30) -- 主担保方式代码
    ,guar_id varchar2(100) -- 担保编号
    ,mode_pay_cd varchar2(30) -- 支付方式代码
    ,asset_crdt_id varchar2(100) -- 资方授信编号
    ,asset_type_cd varchar2(30) -- 资产类型代码
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,fix_out_acct_day varchar2(10) -- 固定出账日
    ,fix_repay_day varchar2(10) -- 固定还款日
    ,loan_tenor number(10) -- 贷款期限
    ,year_int_rat number(30,2) -- 年利率
    ,loan_usage varchar2(500) -- 贷款用途
    ,enter_acct_bank_card_num varchar2(100) -- 入账银行卡号
    ,enter_name varchar2(500) -- 入账账户名称
    ,enter_acct_card_open_bank_no varchar2(100) -- 入账银行卡开户行
    ,enter_acct_card_ibank_no varchar2(100) -- 入账银行卡联行号
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,id_card_effect_dt date -- 身份证生效日期
    ,id_card_exp_dt date -- 身份证到期日期
    ,id_card_addr_info varchar2(4000) -- 身份证地址信息
    ,issue_org varchar2(4000) -- 签发机关
    ,birth_dt date -- 出生日期
    ,marriage_status_cd varchar2(30) -- 婚姻状态代码
    ,age number(10) -- 年龄
    ,gender_cd varchar2(30) -- 性别代码
    ,nation_cd varchar2(100) -- 国籍代码
    ,nationty varchar2(30) -- 民族
    ,mobile_no varchar2(60) -- 手机号码
    ,user_bank_card_num varchar2(60) -- 用户银行卡号
    ,user_rating_cd varchar2(30) -- 用户评级代码
    ,fst_cotas_name varchar2(500) -- 第一联系人名称
    ,fst_cotas_mobile_no varchar2(60) -- 第一联系人手机号码
    ,fst_cotas_rela_cd varchar2(30) -- 第一联系人关系代码
    ,resdnt_addr varchar2(4000) -- 居住地址
    ,career_cd varchar2(30) -- 职业代码
    ,indus_type_cd varchar2(30) -- 行业类型代码
    ,edu_cd varchar2(30) -- 学历代码
    ,mon_inco number(30,8) -- 月收入
    ,provi_fund_payment_base number(30,8) -- 公积金缴纳基数
    ,soci_secu_payment_base number(30,8) -- 社保缴纳基数
    ,provi_fund_payment_corp varchar2(500) -- 公积金缴纳单位名称
    ,corp_addr varchar2(4000) -- 单位地址
    ,manu_apv_flg varchar2(10) -- 人工审批标志
    ,final_decis_rest_cd varchar2(30) -- 最终决策结果代码
    ,final_jud_apv_lmt number(30,8) -- 终审审批额度
    ,final_jud_apv_tenor number(10) -- 终审审批期限
    ,final_jud_estim_price number(30,8) -- 终审评估价格
    ,risk_mgmt_remark varchar2(4000) -- 风控备注
    ,risk_mgmt_warn varchar2(4000) -- 风控预警
    ,apv_cmplt_dt date -- 审批完成日期
    ,sugst_tenor number(10) -- 建议期限
    ,remark varchar2(4000) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
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
grant select on ${iml_schema}.agt_lx_crdt_appl to ${icl_schema};
grant select on ${iml_schema}.agt_lx_crdt_appl to ${idl_schema};
grant select on ${iml_schema}.agt_lx_crdt_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lx_crdt_appl is '乐信授信申请';
comment on column ${iml_schema}.agt_lx_crdt_appl.appl_id is '申请编号';
comment on column ${iml_schema}.agt_lx_crdt_appl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lx_crdt_appl.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_lx_crdt_appl.src_appl_flow_num is '源申请流水号';
comment on column ${iml_schema}.agt_lx_crdt_appl.prod_id is '产品编号';
comment on column ${iml_schema}.agt_lx_crdt_appl.org_id is '机构编号';
comment on column ${iml_schema}.agt_lx_crdt_appl.cust_id is '客户编号';
comment on column ${iml_schema}.agt_lx_crdt_appl.cust_name is '客户名称';
comment on column ${iml_schema}.agt_lx_crdt_appl.appl_type_cd is '申请类型代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.appl_lmt is '申请额度';
comment on column ${iml_schema}.agt_lx_crdt_appl.appl_status_cd is '申请状态代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.crdt_status_cd is '授信状态代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.guar_way_cd is '主担保方式代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.guar_id is '担保编号';
comment on column ${iml_schema}.agt_lx_crdt_appl.mode_pay_cd is '支付方式代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.asset_crdt_id is '资方授信编号';
comment on column ${iml_schema}.agt_lx_crdt_appl.asset_type_cd is '资产类型代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.fix_out_acct_day is '固定出账日';
comment on column ${iml_schema}.agt_lx_crdt_appl.fix_repay_day is '固定还款日';
comment on column ${iml_schema}.agt_lx_crdt_appl.loan_tenor is '贷款期限';
comment on column ${iml_schema}.agt_lx_crdt_appl.year_int_rat is '年利率';
comment on column ${iml_schema}.agt_lx_crdt_appl.loan_usage is '贷款用途';
comment on column ${iml_schema}.agt_lx_crdt_appl.enter_acct_bank_card_num is '入账银行卡号';
comment on column ${iml_schema}.agt_lx_crdt_appl.enter_name is '入账账户名称';
comment on column ${iml_schema}.agt_lx_crdt_appl.enter_acct_card_open_bank_no is '入账银行卡开户行';
comment on column ${iml_schema}.agt_lx_crdt_appl.enter_acct_card_ibank_no is '入账银行卡联行号';
comment on column ${iml_schema}.agt_lx_crdt_appl.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.cert_no is '证件号码';
comment on column ${iml_schema}.agt_lx_crdt_appl.id_card_effect_dt is '身份证生效日期';
comment on column ${iml_schema}.agt_lx_crdt_appl.id_card_exp_dt is '身份证到期日期';
comment on column ${iml_schema}.agt_lx_crdt_appl.id_card_addr_info is '身份证地址信息';
comment on column ${iml_schema}.agt_lx_crdt_appl.issue_org is '签发机关';
comment on column ${iml_schema}.agt_lx_crdt_appl.birth_dt is '出生日期';
comment on column ${iml_schema}.agt_lx_crdt_appl.marriage_status_cd is '婚姻状态代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.age is '年龄';
comment on column ${iml_schema}.agt_lx_crdt_appl.gender_cd is '性别代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.nation_cd is '国籍代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.nationty is '民族';
comment on column ${iml_schema}.agt_lx_crdt_appl.mobile_no is '手机号码';
comment on column ${iml_schema}.agt_lx_crdt_appl.user_bank_card_num is '用户银行卡号';
comment on column ${iml_schema}.agt_lx_crdt_appl.user_rating_cd is '用户评级代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.fst_cotas_name is '第一联系人名称';
comment on column ${iml_schema}.agt_lx_crdt_appl.fst_cotas_mobile_no is '第一联系人手机号码';
comment on column ${iml_schema}.agt_lx_crdt_appl.fst_cotas_rela_cd is '第一联系人关系代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.resdnt_addr is '居住地址';
comment on column ${iml_schema}.agt_lx_crdt_appl.career_cd is '职业代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.indus_type_cd is '行业类型代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.edu_cd is '学历代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.mon_inco is '月收入';
comment on column ${iml_schema}.agt_lx_crdt_appl.provi_fund_payment_base is '公积金缴纳基数';
comment on column ${iml_schema}.agt_lx_crdt_appl.soci_secu_payment_base is '社保缴纳基数';
comment on column ${iml_schema}.agt_lx_crdt_appl.provi_fund_payment_corp is '公积金缴纳单位名称';
comment on column ${iml_schema}.agt_lx_crdt_appl.corp_addr is '单位地址';
comment on column ${iml_schema}.agt_lx_crdt_appl.manu_apv_flg is '人工审批标志';
comment on column ${iml_schema}.agt_lx_crdt_appl.final_decis_rest_cd is '最终决策结果代码';
comment on column ${iml_schema}.agt_lx_crdt_appl.final_jud_apv_lmt is '终审审批额度';
comment on column ${iml_schema}.agt_lx_crdt_appl.final_jud_apv_tenor is '终审审批期限';
comment on column ${iml_schema}.agt_lx_crdt_appl.final_jud_estim_price is '终审评估价格';
comment on column ${iml_schema}.agt_lx_crdt_appl.risk_mgmt_remark is '风控备注';
comment on column ${iml_schema}.agt_lx_crdt_appl.risk_mgmt_warn is '风控预警';
comment on column ${iml_schema}.agt_lx_crdt_appl.apv_cmplt_dt is '审批完成日期';
comment on column ${iml_schema}.agt_lx_crdt_appl.sugst_tenor is '建议期限';
comment on column ${iml_schema}.agt_lx_crdt_appl.remark is '备注';
comment on column ${iml_schema}.agt_lx_crdt_appl.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_lx_crdt_appl.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_lx_crdt_appl.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_lx_crdt_appl.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_lx_crdt_appl.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_lx_crdt_appl.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_lx_crdt_appl.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lx_crdt_appl.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lx_crdt_appl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lx_crdt_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lx_crdt_appl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lx_crdt_appl.etl_timestamp is 'ETL处理时间戳';
