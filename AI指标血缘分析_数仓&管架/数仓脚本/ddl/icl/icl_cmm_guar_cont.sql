/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_guar_cont
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_guar_cont
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_guar_cont purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_guar_cont(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,guar_cont_id varchar2(100) -- 担保合同编号
    ,guar_cont_type_cd varchar2(10) -- 担保合同类型代码
    ,guar_way_cd varchar2(10) -- 担保方式代码
    ,guar_type_cls_cd varchar2(10) -- 担保类型分类代码
    ,guar_kind_cd varchar2(10) -- 保证种类代码
    ,status_cd varchar2(10) -- 状态代码
    ,sign_dt date -- 签订日期
    ,effect_dt date -- 生效日期
    ,exp_dt date -- 到期日期
    ,cust_id varchar2(60) -- 客户编号
    ,guartor_id varchar2(60) -- 担保人编号
    ,guartor_name varchar2(500) -- 担保人名称
    ,guartor_cert_type_cd varchar2(10) -- 担保人证件类型代码
    ,guartor_cert_no varchar2(60) -- 担保人证件号码
    ,guartor_cate_cd varchar2(60) -- 担保人类别代码
    ,guartor_natnal_econ_dept_type_cd varchar2(60) -- 担保人国民经济部门类型代码
    ,guartor_indus_type_cd varchar2(60) -- 担保人行业类型代码
    ,guartor_dist_cd varchar2(60) -- 担保人行政区划代码
    ,guartor_corp_size_cd varchar2(60) -- 担保人企业规模代码
    ,guartor_cty_rg_cd varchar2(60) -- 担保人国家和地区代码
    ,guartor_net_asset number(30,2) -- 保证人净资产
    ,brwer_rela_cd varchar2(10) -- 与借款人关系代码
    ,curr_cd varchar2(10) -- 币种代码
    ,guar_amt number(30,2) -- 担保金额
    ,ocup_amt number(30,8) -- 占用金额
    ,guar_start_dt date -- 担保起始日期
    ,guar_exp_dt date -- 担保到期日期
    ,guar_tenor number(30) -- 担保期限
    ,pri_contr_id varchar2(100) -- 主合同编号
    ,pri_contr_type_cd varchar2(10) -- 主合同类型代码
    ,ocup_guar_lmt_flg varchar2(10) -- 占用担保额度标志
    ,guar_range_cd varchar2(10) -- 担保范围代码
    ,gcust_flg varchar2(10) -- 代保管标志
    ,rev_guar_flg varchar2(10) -- 反担保标志
    ,rev_guar_measure_flg varchar2(10) -- 反担保措施标志
    ,gover_fin_guar_corp_guar_flg varchar2(10) -- 政府性融资担保公司保证标志
    ,obg_id varchar2(60) -- 权利人编号
    ,obg_name varchar2(100) -- 权利人名称
    ,dir_guar_flg varchar2(10) -- 直接向我行担保标志
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,director_org_id varchar2(60) -- 主管机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,rgst_org_id varchar2(60) -- 登记机构编号
    ,rgstrat_id varchar2(60) -- 登记人员编号
    ,rgst_dt date -- 登记日期
    ,update_person_id varchar2(60) -- 更新人员编号
    ,update_dt date -- 更新日期
    ,guar_cont_name varchar2(250) -- 担保合同名称
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
grant select on ${icl_schema}.cmm_guar_cont to ${idl_schema};
grant select on ${icl_schema}.cmm_guar_cont to ${iel_schema};
grant select on ${icl_schema}.cmm_guar_cont to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_guar_cont is '担保合同';
comment on column ${icl_schema}.cmm_guar_cont.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_guar_cont.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_guar_cont.guar_cont_id is '担保合同编号';
comment on column ${icl_schema}.cmm_guar_cont.guar_cont_type_cd is '担保合同类型代码';
comment on column ${icl_schema}.cmm_guar_cont.guar_way_cd is '担保方式代码';
comment on column ${icl_schema}.cmm_guar_cont.guar_type_cls_cd is '担保类型分类代码';
comment on column ${icl_schema}.cmm_guar_cont.guar_kind_cd is '保证种类代码';
comment on column ${icl_schema}.cmm_guar_cont.status_cd is '状态代码';
comment on column ${icl_schema}.cmm_guar_cont.sign_dt is '签订日期';
comment on column ${icl_schema}.cmm_guar_cont.effect_dt is '生效日期';
comment on column ${icl_schema}.cmm_guar_cont.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_guar_cont.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_guar_cont.guartor_id is '担保人编号';
comment on column ${icl_schema}.cmm_guar_cont.guartor_name is '担保人名称';
comment on column ${icl_schema}.cmm_guar_cont.guartor_cert_type_cd is '担保人证件类型代码';
comment on column ${icl_schema}.cmm_guar_cont.guartor_cert_no is '担保人证件号码';
comment on column ${icl_schema}.cmm_guar_cont.guartor_cate_cd is '担保人类别代码';
comment on column ${icl_schema}.cmm_guar_cont.guartor_natnal_econ_dept_type_cd is '担保人国民经济部门类型代码';
comment on column ${icl_schema}.cmm_guar_cont.guartor_indus_type_cd is '担保人行业类型代码';
comment on column ${icl_schema}.cmm_guar_cont.guartor_dist_cd is '担保人行政区划代码';
comment on column ${icl_schema}.cmm_guar_cont.guartor_corp_size_cd is '担保人企业规模代码';
comment on column ${icl_schema}.cmm_guar_cont.guartor_cty_rg_cd is '担保人国家和地区代码';
comment on column ${icl_schema}.cmm_guar_cont.guartor_net_asset is '保证人净资产';
comment on column ${icl_schema}.cmm_guar_cont.brwer_rela_cd is '与借款人关系代码';
comment on column ${icl_schema}.cmm_guar_cont.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_guar_cont.guar_amt is '担保金额';
comment on column ${icl_schema}.cmm_guar_cont.ocup_amt is '占用金额';
comment on column ${icl_schema}.cmm_guar_cont.guar_start_dt is '担保起始日期';
comment on column ${icl_schema}.cmm_guar_cont.guar_exp_dt is '担保到期日期';
comment on column ${icl_schema}.cmm_guar_cont.guar_tenor is '担保期限';
comment on column ${icl_schema}.cmm_guar_cont.pri_contr_id is '主合同编号';
comment on column ${icl_schema}.cmm_guar_cont.pri_contr_type_cd is '主合同类型代码';
comment on column ${icl_schema}.cmm_guar_cont.ocup_guar_lmt_flg is '占用担保额度标志';
comment on column ${icl_schema}.cmm_guar_cont.guar_range_cd is '担保范围代码';
comment on column ${icl_schema}.cmm_guar_cont.gcust_flg is '代保管标志';
comment on column ${icl_schema}.cmm_guar_cont.rev_guar_flg is '反担保标志';
comment on column ${icl_schema}.cmm_guar_cont.rev_guar_measure_flg is '反担保措施标志';
comment on column ${icl_schema}.cmm_guar_cont.gover_fin_guar_corp_guar_flg is '政府性融资担保公司保证标志';
comment on column ${icl_schema}.cmm_guar_cont.obg_id is '权利人编号';
comment on column ${icl_schema}.cmm_guar_cont.obg_name is '权利人名称';
comment on column ${icl_schema}.cmm_guar_cont.dir_guar_flg is '直接向我行担保标志';
comment on column ${icl_schema}.cmm_guar_cont.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_guar_cont.director_org_id is '主管机构编号';
comment on column ${icl_schema}.cmm_guar_cont.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_guar_cont.rgst_org_id is '登记机构编号';
comment on column ${icl_schema}.cmm_guar_cont.rgstrat_id is '登记人员编号';
comment on column ${icl_schema}.cmm_guar_cont.rgst_dt is '登记日期';
comment on column ${icl_schema}.cmm_guar_cont.update_person_id is '更新人员编号';
comment on column ${icl_schema}.cmm_guar_cont.update_dt is '更新日期';
comment on column ${icl_schema}.cmm_guar_cont.guar_cont_name is '担保合同名称';
comment on column ${icl_schema}.cmm_guar_cont.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_guar_cont.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_guar_cont.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_guar_cont.etl_timestamp is 'ETL处理时间戳';
