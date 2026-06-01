/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lhwd_guar_cont_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lhwd_guar_cont_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lhwd_guar_cont_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lhwd_guar_cont_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,guar_cont_id varchar2(100) -- 担保合同编号
    ,guar_cont_type_cd varchar2(30) -- 担保合同类型代码
    ,guar_cont_status_cd varchar2(30) -- 担保合同状态代码
    ,sign_dt date -- 签订日期
    ,effect_dt date -- 生效日期
    ,exp_dt date -- 到期日期
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,guar_guar_form_cd varchar2(30) -- 保证担保形式代码
    ,guar_cust_id varchar2(100) -- 被担保客户编号
    ,guartor_id varchar2(100) -- 担保人编号
    ,guartor_name varchar2(500) -- 担保人名称
    ,guartor_type_cd varchar2(30) -- 担保人类型代码
    ,guartor_cert_type_cd varchar2(30) -- 担保人证件类型代码
    ,guartor_cert_no varchar2(100) -- 担保人证件号码
    ,guartor_loan_card_no varchar2(100) -- 担保人贷款卡号
    ,guartor_fax_num varchar2(100) -- 担保人传真号码
    ,guartor_tel_num varchar2(100) -- 担保人电话号码
    ,guartor_addr varchar2(500) -- 担保人地址
    ,guartor_guar_ability_uplmi number(30,8) -- 担保人保证能力上限
    ,curr_cd varchar2(30) -- 币种代码
    ,guar_amt number(30,8) -- 担保金额
    ,guar_tenor number(22) -- 担保期限
    ,aldy_guar_amt number(30,2) -- 已担保金额
    ,aval_bal number(30,2) -- 可用余额
    ,cust_risk_actl_pm_rat number(30,8) -- 客户风险实际抵质押率
    ,apv_pm_rat number(18,8) -- 审批抵质押率
    ,guar_survey varchar2(2000) -- 担保物概况
    ,other_espec_apot varchar2(2000) -- 其它特别约定
    ,guar_opinion varchar2(2000) -- 担保意见
    ,gover_fin_guar_corp_guar_flg varchar2(10) -- 政府性融资担保公司保证标志
    ,rev_guar_flg varchar2(10) -- 反担保标志
    ,check_guar_dt date -- 核保日期
    ,fst_ctfer_name varchar2(500) -- 第一核保人名称
    ,secd_ctfer_name varchar2(500) -- 第二核保人名称
    ,crdt_chn_cd varchar2(60) -- 授信渠道代码
    ,col_id varchar2(100) -- 押品编号
    ,lmt_id varchar2(100) -- 额度编号
    ,remark varchar2(2000) -- 备注
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
grant select on ${iml_schema}.agt_lhwd_guar_cont_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_lhwd_guar_cont_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_lhwd_guar_cont_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lhwd_guar_cont_info_h is '联合网贷担保合同信息历史';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guar_cont_id is '担保合同编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guar_cont_type_cd is '担保合同类型代码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guar_cont_status_cd is '担保合同状态代码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.sign_dt is '签订日期';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guar_guar_form_cd is '保证担保形式代码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guar_cust_id is '被担保客户编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guartor_id is '担保人编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guartor_name is '担保人名称';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guartor_type_cd is '担保人类型代码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guartor_cert_type_cd is '担保人证件类型代码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guartor_cert_no is '担保人证件号码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guartor_loan_card_no is '担保人贷款卡号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guartor_fax_num is '担保人传真号码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guartor_tel_num is '担保人电话号码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guartor_addr is '担保人地址';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guartor_guar_ability_uplmi is '担保人保证能力上限';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guar_amt is '担保金额';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guar_tenor is '担保期限';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.aldy_guar_amt is '已担保金额';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.aval_bal is '可用余额';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.cust_risk_actl_pm_rat is '客户风险实际抵质押率';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.apv_pm_rat is '审批抵质押率';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guar_survey is '担保物概况';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.other_espec_apot is '其它特别约定';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.guar_opinion is '担保意见';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.gover_fin_guar_corp_guar_flg is '政府性融资担保公司保证标志';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.rev_guar_flg is '反担保标志';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.check_guar_dt is '核保日期';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.fst_ctfer_name is '第一核保人名称';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.secd_ctfer_name is '第二核保人名称';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.crdt_chn_cd is '授信渠道代码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.col_id is '押品编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.lmt_id is '额度编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.remark is '备注';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lhwd_guar_cont_info_h.etl_timestamp is 'ETL处理时间戳';
