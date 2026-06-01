/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wph_guar_cont_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wph_guar_cont_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wph_guar_cont_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wph_guar_cont_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,guar_cont_id varchar2(100) -- 担保合同编号
    ,guar_cont_type_cd varchar2(30) -- 担保合同类型代码
    ,guar_way_cd varchar2(30) -- 主担保方式代码
    ,sign_dt date -- 签订日期
    ,status_cd varchar2(30) -- 状态代码
    ,effect_dt date -- 生效日期
    ,exp_dt date -- 到期日期
    ,guartor_id varchar2(100) -- 担保人编号
    ,guartor_name varchar2(500) -- 担保人名称
    ,guar_curr_cd varchar2(30) -- 担保币种代码
    ,guar_tot_amt number(30,8) -- 担保总金额
    ,guar_survey varchar2(1000) -- 担保物概况
    ,guar_opinion_descb varchar2(1000) -- 担保意见描述
    ,guartor_cert_type_cd varchar2(30) -- 担保人证件类型代码
    ,guartor_cert_no varchar2(60) -- 担保人证件号码
    ,guartor_loan_card_no varchar2(100) -- 担保人贷款卡号
    ,guar_form_cd varchar2(30) -- 担保形式代码
    ,brwer_cust_id varchar2(100) -- 被担保客户编号
    ,loan_cont_id varchar2(100) -- 被担保合同编号
    ,guar_fee_rat number(18,6) -- 担保费率
    ,other_espec_apot varchar2(1000) -- 其它特别约定
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
grant select on ${iml_schema}.agt_wph_guar_cont_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_wph_guar_cont_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_wph_guar_cont_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wph_guar_cont_info_h is '唯品会担保合同信息历史';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guar_cont_id is '担保合同编号';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guar_cont_type_cd is '担保合同类型代码';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guar_way_cd is '主主担保方式代码';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.sign_dt is '签订日期';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.status_cd is '状态代码';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guartor_id is '担保人编号';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guartor_name is '担保人名称';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guar_curr_cd is '担保币种代码';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guar_tot_amt is '担保总金额';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guar_survey is '担保物概况';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guar_opinion_descb is '担保意见描述';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guartor_cert_type_cd is '担保人证件类型代码';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guartor_cert_no is '担保人证件号码';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guartor_loan_card_no is '担保人贷款卡号';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guar_form_cd is '担保形式代码';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.brwer_cust_id is '被担保客户编号';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.loan_cont_id is '被担保合同编号';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.guar_fee_rat is '担保费率';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.other_espec_apot is '其它特别约定';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wph_guar_cont_info_h.etl_timestamp is 'ETL处理时间戳';
