/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_myloan_asset_ccution_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_myloan_asset_ccution_appl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_myloan_asset_ccution_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_myloan_asset_ccution_appl(
    appl_id varchar2(60) -- 申请编号
    ,lp_id varchar2(60) -- 法人编号
    ,asset_ccution_id varchar2(60) -- 资产流转编号
    ,tran_batch_id varchar2(60) -- 转让批次编号
    ,disb_id varchar2(60) -- 支用编号
    ,brwer_name varchar2(500) -- 借款人名称
    ,brwer_cert_type_cd varchar2(60) -- 借款人证件类型代码
    ,brwer_cert_no varchar2(60) -- 借款人证件号码
    ,brwer_mobile_no varchar2(60) -- 借款人手机号码
    ,brwer_addr varchar2(250) -- 借款人住址
    ,solv_cd varchar2(60) -- 偿债能力代码
    ,l_six_m_ovdue_cnt_level_score varchar2(60) -- 最近六个月逾期笔数等级分数
    ,l_six_m_ovdue_amt_level_score varchar2(60) -- 最近六个月逾期金额等级分数
    ,l_six_m_ovdue_days_level_score varchar2(60) -- 最近六个月逾期天数等级分数
    ,recnt_yearly_perf_level_score varchar2(60) -- 最近一年履约等级分数
    ,crdt_duran_level_score varchar2(60) -- 信贷时长等级分数
    ,risk_score varchar2(60) -- 风险分数
    ,risk_level_cd varchar2(60) -- 风险等级代码
    ,six_m_ovdue_flg varchar2(60) -- 六个月逾期标志
    ,rg_prov_name varchar2(100) -- 地区省份名称
    ,age varchar2(60) -- 年龄
    ,loan_type_descb varchar2(100) -- 贷款类型描述
    ,loan_usage_descb varchar2(100) -- 贷款用途描述
    ,loan_level5_cls_cd varchar2(60) -- 贷款五级分类代码
    ,curr_cd varchar2(60) -- 币种代码
    ,cont_amt number(30,2) -- 合同金额
    ,loan_bal number(30,2) -- 贷款余额
    ,int_rat_adj_way_descb varchar2(60) -- 利率调整方式描述
    ,loan_year_int_rat number(18,8) -- 贷款年利率
    ,loan_value_dt date -- 贷款起息日期
    ,loan_exp_dt date -- 贷款到期日期
    ,loan_tenor varchar2(60) -- 贷款期限
    ,loan_surp_days varchar2(60) -- 贷款剩余天数
    ,repay_way_comnt varchar2(100) -- 还款方式说明
    ,guar_way_descb varchar2(60) -- 担保方式描述
    ,guara varchar2(60) -- 担保品
    ,single_acct_crdt_lmt number(30,2) -- 单户授信额度
    ,corp_rgst_type varchar2(60) -- 企业登记注册类型
    ,corp_name varchar2(250) -- 公司名称
    ,legal_rep_name varchar2(100) -- 法定代表人名称
    ,iac_rgst_no varchar2(60) -- 工商注册号
    ,rgst_tm timestamp -- 注册时间
    ,rgst_addr varchar2(250) -- 注册地址
    ,rgst_dist_id varchar2(60) -- 注册地行政区编号
    ,rgst_prov_city_rg varchar2(100) -- 注册地省市区
    ,thsnds_rgst_cap number(30,2) -- 万元注册资本
    ,indus_type_cd varchar2(60) -- 行业类型代码
    ,oper_range_comnt varchar2(250) -- 经营范围说明
    ,reg_iacb varchar2(100) -- 注册工商局
    ,oper_status_comnt varchar2(100) -- 经营状态说明
    ,final_as_year varchar2(60) -- 最后年检年度
    ,oper_start_tm timestamp -- 经营开始时间
    ,oper_end_tm timestamp -- 经营结束时间
    ,start_bus_tm timestamp -- 开业时间
    ,corp_type_descb varchar2(300) -- 公司类型描述
    ,dload_dt date -- 下载日期
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,apv_status_cd varchar2(20) -- 审批状态代码
    ,refuse_rs_comnt varchar2(500) -- 拒绝原因说明
    ,cust_id varchar2(60) -- 客户编号
    ,open_acct_sucs_flg varchar2(10) -- 开户成功标志
    ,netw_vrfction_pass_flg varchar2(10) -- 联网核查通过标志
    ,apv_end_tm timestamp -- 审批结束时间
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_myloan_asset_ccution_appl to ${icl_schema};
grant select on ${iml_schema}.agt_myloan_asset_ccution_appl to ${idl_schema};
grant select on ${iml_schema}.agt_myloan_asset_ccution_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_myloan_asset_ccution_appl is '网商贷资产流转申请';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.appl_id is '申请编号';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.asset_ccution_id is '资产流转编号';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.tran_batch_id is '转让批次编号';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.disb_id is '支用编号';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.brwer_name is '借款人名称';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.brwer_cert_type_cd is '借款人证件类型代码';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.brwer_cert_no is '借款人证件号码';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.brwer_mobile_no is '借款人手机号码';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.brwer_addr is '借款人住址';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.solv_cd is '偿债能力代码';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.l_six_m_ovdue_cnt_level_score is '最近六个月逾期笔数等级分数';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.l_six_m_ovdue_amt_level_score is '最近六个月逾期金额等级分数';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.l_six_m_ovdue_days_level_score is '最近六个月逾期天数等级分数';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.recnt_yearly_perf_level_score is '最近一年履约等级分数';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.crdt_duran_level_score is '信贷时长等级分数';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.risk_score is '风险分数';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.risk_level_cd is '风险等级代码';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.six_m_ovdue_flg is '六个月逾期标志';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.rg_prov_name is '地区省份名称';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.age is '年龄';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.loan_type_descb is '贷款类型描述';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.loan_usage_descb is '贷款用途描述';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.cont_amt is '合同金额';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.loan_bal is '贷款余额';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.int_rat_adj_way_descb is '利率调整方式描述';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.loan_year_int_rat is '贷款年利率';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.loan_value_dt is '贷款起息日期';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.loan_exp_dt is '贷款到期日期';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.loan_tenor is '贷款期限';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.loan_surp_days is '贷款剩余天数';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.repay_way_comnt is '还款方式说明';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.guar_way_descb is '担保方式描述';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.guara is '担保品';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.single_acct_crdt_lmt is '单户授信额度';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.corp_rgst_type is '企业登记注册类型';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.corp_name is '公司名称';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.legal_rep_name is '法定代表人名称';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.iac_rgst_no is '工商注册号';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.rgst_tm is '注册时间';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.rgst_addr is '注册地址';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.rgst_dist_id is '注册地行政区编号';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.rgst_prov_city_rg is '注册地省市区';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.thsnds_rgst_cap is '万元注册资本';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.indus_type_cd is '行业类型代码';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.oper_range_comnt is '经营范围说明';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.reg_iacb is '注册工商局';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.oper_status_comnt is '经营状态说明';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.final_as_year is '最后年检年度';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.oper_start_tm is '经营开始时间';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.oper_end_tm is '经营结束时间';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.start_bus_tm is '开业时间';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.corp_type_descb is '公司类型描述';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.dload_dt is '下载日期';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.refuse_rs_comnt is '拒绝原因说明';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.cust_id is '客户编号';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.open_acct_sucs_flg is '开户成功标志';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.netw_vrfction_pass_flg is '联网核查通过标志';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.apv_end_tm is '审批结束时间';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.create_dt is '创建日期';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.update_dt is '更新日期';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_myloan_asset_ccution_appl.etl_timestamp is 'ETL处理时间戳';
