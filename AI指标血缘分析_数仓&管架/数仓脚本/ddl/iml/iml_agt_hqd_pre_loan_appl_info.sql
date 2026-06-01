/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_hqd_pre_loan_appl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_hqd_pre_loan_appl_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_hqd_pre_loan_appl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_hqd_pre_loan_appl_info(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,crdt_appl_flow_num varchar2(100) -- 信贷申请流水号
    ,prod_id varchar2(100) -- 产品编号
    ,prod_name varchar2(500) -- 产品名称
    ,prod_abbr varchar2(500) -- 产品简称
    ,access_chn_id varchar2(100) -- 接入渠道编号
    ,apv_lmt number(30,8) -- 审批额度
    ,apv_appl_dt date -- 审批申请日期
    ,apv_end_dt date -- 审批结束日期
    ,task_status_cd varchar2(30) -- 任务状态代码
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,warn_info varchar2(4000) -- 预警信息
    ,refuse_rs_descb varchar2(4000) -- 拒绝原因描述
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,belong_brch_org_id varchar2(100) -- 所属分行机构编号
    ,lp_cust_id varchar2(100) -- 法人客户编号
    ,issue_dt date -- 签发日期
    ,brwer_cert_exp_dt date -- 借款人证件到期日期
    ,resd_local_prov varchar2(100) -- 居住所在省份
    ,resd_city varchar2(100) -- 居住所在城市
    ,resd_local_rg varchar2(100) -- 居住所在区域
    ,resd_dtl_addr varchar2(500) -- 居住详细地址
    ,career_cd varchar2(30) -- 职业代码
    ,nation_cd varchar2(250) -- 国籍代码
    ,corp_name varchar2(500) -- 企业名称
    ,unify_soci_crdt_cd varchar2(30) -- 统一社会信用代码
    ,tax_num varchar2(100) -- 纳税人识别号
    ,tax_type_cd varchar2(30) -- 涉税类型代码
    ,tax_que_auth_flow_num varchar2(100) -- 税务查询授权流水号
    ,que_appl_type_cd varchar2(30) -- 查询申请类型代码
    ,data_src_cd varchar2(30) -- 数据来源代码
    ,auth_flg varchar2(10) -- 授权标志
    ,auth_way_cd varchar2(60) -- 授权方式代码
    ,biome_trics varchar2(30) -- 生物识别方式代码
    ,auth_dt date -- 授权日期
    ,auth_effect_dt date -- 授权生效日期
    ,auth_invalid_dt date -- 授权失效日期
    ,corp_rgst_dt date -- 企业注册日期
    ,mang_range varchar2(4000) -- 经营范围
    ,bus_lics_vp date -- 营业执照有效期
    ,rgst_addr varchar2(500) -- 注册地址
    ,sm_corp_flg varchar2(10) -- 小微企业标志
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,asset_sum number(30,2) -- 资产合计
    ,mang_inco number(30,2) -- 经营收入
    ,pre_scd_year_sell_inco number(30,2) -- 预测次年销售收入
    ,other_chn_provi_oper_cap number(30,2) -- 其他渠道提供的营运资金
    ,mon_rent_lmt number(30,2) -- 月租金额
    ,corp_in_mons number(30) -- 企业入驻月份数
    ,score_val varchar2(10) -- 评分分值
    ,netw_vrfction_rest_cd varchar2(30) -- 联网核查结果代码
    ,crdtc_rest_cd varchar2(30) -- 征信检验结果代码
    ,indus_type_cd varchar2(60) -- 行业类型代码
    ,advise_flg varchar2(10) -- 通知展业标志
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
grant select on ${iml_schema}.agt_hqd_pre_loan_appl_info to ${icl_schema};
grant select on ${iml_schema}.agt_hqd_pre_loan_appl_info to ${idl_schema};
grant select on ${iml_schema}.agt_hqd_pre_loan_appl_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_hqd_pre_loan_appl_info is '好企贷预审批贷款申请信息';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.appl_id is '申请编号';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.crdt_appl_flow_num is '信贷申请流水号';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.prod_id is '产品编号';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.prod_name is '产品名称';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.prod_abbr is '产品简称';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.access_chn_id is '接入渠道编号';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.apv_lmt is '审批额度';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.apv_appl_dt is '审批申请日期';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.apv_end_dt is '审批结束日期';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.task_status_cd is '任务状态代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.warn_info is '预警信息';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.refuse_rs_descb is '拒绝原因描述';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.belong_brch_org_id is '所属分行机构编号';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.lp_cust_id is '法人客户编号';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.issue_dt is '签发日期';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.brwer_cert_exp_dt is '借款人证件到期日期';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.resd_local_prov is '居住所在省份';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.resd_city is '居住所在城市';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.resd_local_rg is '居住所在区域';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.resd_dtl_addr is '居住详细地址';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.career_cd is '职业代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.nation_cd is '国籍代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.corp_name is '企业名称';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.unify_soci_crdt_cd is '统一社会信用代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.tax_num is '纳税人识别号';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.tax_type_cd is '涉税类型代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.tax_que_auth_flow_num is '税务查询授权流水号';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.que_appl_type_cd is '查询申请类型代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.data_src_cd is '数据来源代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.auth_flg is '授权标志';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.auth_way_cd is '授权方式代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.biome_trics is '生物识别方式代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.auth_dt is '授权日期';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.auth_effect_dt is '授权生效日期';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.auth_invalid_dt is '授权失效日期';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.corp_rgst_dt is '企业注册日期';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.mang_range is '经营范围';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.bus_lics_vp is '营业执照有效期';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.rgst_addr is '注册地址';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.sm_corp_flg is '小微企业标志';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.asset_sum is '资产合计';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.mang_inco is '经营收入';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.pre_scd_year_sell_inco is '预测次年销售收入';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.other_chn_provi_oper_cap is '其他渠道提供的营运资金';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.mon_rent_lmt is '月租金额';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.corp_in_mons is '企业入驻月份数';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.score_val is '评分分值';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.netw_vrfction_rest_cd is '联网核查结果代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.crdtc_rest_cd is '征信检验结果代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.indus_type_cd is '行业类型代码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.advise_flg is '通知展业标志';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.start_dt is '开始时间';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.end_dt is '结束时间';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_hqd_pre_loan_appl_info.etl_timestamp is 'ETL处理时间戳';
