/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wsd_guar_cont_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wsd_guar_cont_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wsd_guar_cont_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wsd_guar_cont_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,guar_cont_id varchar2(100) -- 担保合同编号
    ,guar_cont_type_cd varchar2(30) -- 担保合同类型代码
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,guar_cont_status_cd varchar2(30) -- 担保合同状态代码
    ,curr_cd varchar2(30) -- 币种代码
    ,guar_amt number(30,2) -- 担保金额
    ,agt_sign_dt date -- 协议签定日期
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,vouchee_cust_id varchar2(100) -- 被担保人客户编号
    ,guartor_cust_id varchar2(100) -- 担保人客户编号
    ,guartor_name varchar2(500) -- 担保人名称
    ,guartor_cert_type_cd varchar2(30) -- 担保人证件类型代码
    ,guartor_cert_no varchar2(60) -- 担保人证件号码
    ,guar_guar_form_cd varchar2(30) -- 保证担保形式代码
    ,guar_org_name varchar2(500) -- 担保机构名称
    ,guar_item_promis_id varchar2(100) -- 担保事项承诺书编号
    ,gover_fin_guar_corp_guar_flg varchar2(10) -- 政府性融资担保公司保证标志
    ,rev_guar_flg varchar2(10) -- 反担保标志
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_dt date -- 登记日期
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
grant select on ${iml_schema}.agt_wsd_guar_cont_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_wsd_guar_cont_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_wsd_guar_cont_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wsd_guar_cont_info_h is '网商贷担保合同信息历史';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.guar_cont_id is '担保合同编号';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.guar_cont_type_cd is '担保合同类型代码';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.guar_cont_status_cd is '担保合同状态代码';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.guar_amt is '担保金额';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.agt_sign_dt is '协议签定日期';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.vouchee_cust_id is '被担保人客户编号';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.guartor_cust_id is '担保人客户编号';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.guartor_name is '担保人名称';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.guartor_cert_type_cd is '担保人证件类型代码';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.guartor_cert_no is '担保人证件号码';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.guar_guar_form_cd is '保证担保形式代码';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.guar_org_name is '担保机构名称';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.guar_item_promis_id is '担保事项承诺书编号';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.gover_fin_guar_corp_guar_flg is '政府性融资担保公司保证标志';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.rev_guar_flg is '反担保标志';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wsd_guar_cont_info_h.etl_timestamp is 'ETL处理时间戳';
