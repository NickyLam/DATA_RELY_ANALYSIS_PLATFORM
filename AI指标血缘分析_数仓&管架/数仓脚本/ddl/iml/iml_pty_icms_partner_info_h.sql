/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_icms_partner_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_icms_partner_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_icms_partner_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_icms_partner_info_h(
    party_id varchar2(100) -- 当事人编号
    ,lp_id varchar2(100) -- 法人编号
    ,partner_id varchar2(100) -- 合作方编号
    ,partner_name varchar2(500) -- 合作方名称
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,legal_rep_name varchar2(500) -- 法定代表人姓名
    ,legal_rep_cert_type_cd varchar2(30) -- 法定代表人证件类型代码
    ,legal_rep_cert_no varchar2(60) -- 法定代表人证件号码
    ,phys_addr varchar2(1000) -- 物理地址
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,crdt_lmt number(30,2) -- 授信额度
    ,co_start_dt date -- 合作开始日期
    ,co_end_dt date -- 合作结束日期
    ,coprator_char_cd varchar2(30) -- 合作商性质代码
    ,coprator_proj_type_cd varchar2(30) -- 合作商项目类型代码
    ,coprator_type_cd varchar2(30) -- 合作商类型代码
    ,partner_status_cd varchar2(30) -- 合作方状态代码
    ,partner_cotas_name varchar2(500) -- 合作方联系人姓名
    ,higt_co_lmt number(30,8) -- 最高合作额度
    ,co_mon_tenor number(30) -- 合作月期限
    ,cust_phone varchar2(100) -- 客户联系电话
    ,input_integy_flg varchar2(10) -- 已完善标志
    ,prep_appl_avg_lmt number(30) -- 拟申请平均额度
    ,fit_org_id varchar2(100) -- 适用机构编号
    ,invest_main_type_cd varchar2(30) -- 投资主体类型代码
    ,hold_type_cd varchar2(30) -- 控股类型代码
    ,indus_type_cd varchar2(30) -- 行业类型代码
    ,indus_name varchar2(500) -- 行业名称
    ,obtain_emply_number number(30) -- 从业人数
    ,asset_tot number(30) -- 资产总额
    ,bus_inco number(30) -- 营业收入
    ,corp_found_dt date -- 企业成立日期
    ,unify_soci_crdt_cd varchar2(100) -- 统一社会信用代码
    ,tax_num varchar2(100) -- 纳税人识别号
    ,orgnz_rgst_dt date -- 组织机构登记日期
    ,orgnz_rgst_exp_dt date -- 组织机构登记到期日期
    ,bus_lics_rgst_dt date -- 营业执照登记日期
    ,bus_lics_exp_dt date -- 营业执照到期日期
    ,basic_dep_open_acct_lics_id varchar2(100) -- 基本存款账户开户许可证编号
    ,fin_dept_princ varchar2(500) -- 财务部负责人
    ,fin_dept_cotas varchar2(500) -- 财务部联系人
    ,fin_dept_cotas_work_tel varchar2(60) -- 财务部联系人单位电话
    ,fin_dept_cont_mobile_no varchar2(60) -- 财务部联系手机号码
    ,corp_char_cd varchar2(30) -- 单位性质代码
    ,mailbox varchar2(100) -- 邮箱
    ,cust_and_hxb_incid_rela_cd varchar2(30) -- 客户与我行关联关系代码
    ,intnal_rating_rest_cd varchar2(30) -- 内部评级结果代码
    ,crdt_rating_dt date -- 信用评定日期
    ,guartor_flg varchar2(10) -- 担保人标志
    ,guar_ratio number(18,6) -- 担保比例
    ,higt_guar_amt number(30,8) -- 最高担保金额
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
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
grant select on ${iml_schema}.pty_icms_partner_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_icms_partner_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_icms_partner_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_icms_partner_info_h is '信贷合作方信息历史';
comment on column ${iml_schema}.pty_icms_partner_info_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_icms_partner_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_icms_partner_info_h.partner_id is '合作方编号';
comment on column ${iml_schema}.pty_icms_partner_info_h.partner_name is '合作方名称';
comment on column ${iml_schema}.pty_icms_partner_info_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.cert_no is '证件号码';
comment on column ${iml_schema}.pty_icms_partner_info_h.legal_rep_name is '法定代表人姓名';
comment on column ${iml_schema}.pty_icms_partner_info_h.legal_rep_cert_type_cd is '法定代表人证件类型代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.legal_rep_cert_no is '法定代表人证件号码';
comment on column ${iml_schema}.pty_icms_partner_info_h.phys_addr is '物理地址';
comment on column ${iml_schema}.pty_icms_partner_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.pty_icms_partner_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.pty_icms_partner_info_h.crdt_lmt is '授信额度';
comment on column ${iml_schema}.pty_icms_partner_info_h.co_start_dt is '合作开始日期';
comment on column ${iml_schema}.pty_icms_partner_info_h.co_end_dt is '合作结束日期';
comment on column ${iml_schema}.pty_icms_partner_info_h.coprator_char_cd is '合作商性质代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.coprator_proj_type_cd is '合作商项目类型代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.coprator_type_cd is '合作商类型代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.partner_status_cd is '合作方状态代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.partner_cotas_name is '合作方联系人姓名';
comment on column ${iml_schema}.pty_icms_partner_info_h.higt_co_lmt is '最高合作额度';
comment on column ${iml_schema}.pty_icms_partner_info_h.co_mon_tenor is '合作月期限';
comment on column ${iml_schema}.pty_icms_partner_info_h.cust_phone is '客户联系电话';
comment on column ${iml_schema}.pty_icms_partner_info_h.input_integy_flg is '已完善标志';
comment on column ${iml_schema}.pty_icms_partner_info_h.prep_appl_avg_lmt is '拟申请平均额度';
comment on column ${iml_schema}.pty_icms_partner_info_h.fit_org_id is '适用机构编号';
comment on column ${iml_schema}.pty_icms_partner_info_h.invest_main_type_cd is '投资主体类型代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.hold_type_cd is '控股类型代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.indus_type_cd is '行业类型代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.indus_name is '行业名称';
comment on column ${iml_schema}.pty_icms_partner_info_h.obtain_emply_number is '从业人数';
comment on column ${iml_schema}.pty_icms_partner_info_h.asset_tot is '资产总额';
comment on column ${iml_schema}.pty_icms_partner_info_h.bus_inco is '营业收入';
comment on column ${iml_schema}.pty_icms_partner_info_h.corp_found_dt is '企业成立日期';
comment on column ${iml_schema}.pty_icms_partner_info_h.unify_soci_crdt_cd is '统一社会信用代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.tax_num is '纳税人识别号';
comment on column ${iml_schema}.pty_icms_partner_info_h.orgnz_rgst_dt is '组织机构登记日期';
comment on column ${iml_schema}.pty_icms_partner_info_h.orgnz_rgst_exp_dt is '组织机构登记到期日期';
comment on column ${iml_schema}.pty_icms_partner_info_h.bus_lics_rgst_dt is '营业执照登记日期';
comment on column ${iml_schema}.pty_icms_partner_info_h.bus_lics_exp_dt is '营业执照到期日期';
comment on column ${iml_schema}.pty_icms_partner_info_h.basic_dep_open_acct_lics_id is '基本存款账户开户许可证编号';
comment on column ${iml_schema}.pty_icms_partner_info_h.fin_dept_princ is '财务部负责人';
comment on column ${iml_schema}.pty_icms_partner_info_h.fin_dept_cotas is '财务部联系人';
comment on column ${iml_schema}.pty_icms_partner_info_h.fin_dept_cotas_work_tel is '财务部联系人单位电话';
comment on column ${iml_schema}.pty_icms_partner_info_h.fin_dept_cont_mobile_no is '财务部联系手机号码';
comment on column ${iml_schema}.pty_icms_partner_info_h.corp_char_cd is '单位性质代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.mailbox is '邮箱';
comment on column ${iml_schema}.pty_icms_partner_info_h.cust_and_hxb_incid_rela_cd is '客户与我行关联关系代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.intnal_rating_rest_cd is '内部评级结果代码';
comment on column ${iml_schema}.pty_icms_partner_info_h.crdt_rating_dt is '信用评定日期';
comment on column ${iml_schema}.pty_icms_partner_info_h.guartor_flg is '担保人标志';
comment on column ${iml_schema}.pty_icms_partner_info_h.guar_ratio is '担保比例';
comment on column ${iml_schema}.pty_icms_partner_info_h.higt_guar_amt is '最高担保金额';
comment on column ${iml_schema}.pty_icms_partner_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.pty_icms_partner_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.pty_icms_partner_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.pty_icms_partner_info_h.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.pty_icms_partner_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_icms_partner_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_icms_partner_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_icms_partner_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_icms_partner_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_icms_partner_info_h.etl_timestamp is 'ETL处理时间戳';
