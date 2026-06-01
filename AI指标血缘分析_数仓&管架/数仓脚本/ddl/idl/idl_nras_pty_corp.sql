/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl nras_pty_corp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.nras_pty_corp
whenever sqlerror continue none;
drop table ${idl_schema}.nras_pty_corp purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.nras_pty_corp(
    etl_dt date -- 数据日期
    ,party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,depositr_cate_cd varchar2(10) -- 存款人类别代码
    ,corp_name varchar2(100) -- 公司名称
    ,corp_en_name varchar2(100) -- 公司英文名称
    ,soci_crdt_cd varchar2(30) -- 社会信用代码
    ,curr_cd varchar2(10) -- 币种代码
    ,rgst_cap number(30,2) -- 注册资金
    ,rgst_addr varchar2(100) -- 注册地址
    ,cty_rg_cd varchar2(10) -- 国家和地区代码
    ,indus_type_cd varchar2(10) -- 行业类型代码
    ,econ_char_cd varchar2(10) -- 经济性质代码
    ,taxpayer_idtfy_num varchar2(60) -- 纳税人识别号
    ,corp_type_cd varchar2(10) -- 企业类型代码
    ,tax_stament_flg varchar2(10) -- 取得税收居民取得自证声明标志
    ,tax_org_cate_cd varchar2(10) -- 税收机构类别代码
    ,tax_resdnt_cty_cd varchar2(20) -- 税收居民国家代码
    ,tax_resdnt_idti_cd varchar2(10) -- 税收居民身份代码
    ,emply_qtty number(10) -- 员工数量
    ,fin_subsidy_inco_src_cd varchar2(10) -- 财政补助收入来源代码
    ,strategy_camp_cust_no varchar2(60) -- 策略营销客户号
    ,ins_adj_type_cd varchar2(10) -- 产业结构调整类型代码
    ,single_lmt number(30,2) -- 单一限额
    ,single_lp_flg varchar2(10) -- 独立法人标志
    ,high_new_tech_corp_flg varchar2(10) -- 高新技术企业标志
    ,itau_flg varchar2(10) -- 工业转型升级标志
    ,rela_party_flg varchar2(10) -- 关联方标志
    ,rela_group_type_cd varchar2(10) -- 关联集团类型代码
    ,org_type_cd varchar2(10) -- 机构类型代码
    ,org_status_cd varchar2(10) -- 机构状态代码
    ,group_cust_flg varchar2(10) -- 集团客户标志
    ,weight_risk_asset_cust_cls_cd varchar2(10) -- 加权风险资产客户分类代码
    ,cbrc_sb_flg varchar2(10) -- 银监小企业标志
    ,econ_type_cd varchar2(10) -- 经济类型代码
    ,oper_range varchar2(250) -- 经营范围
    ,cust_sev_ugd_cls_cd varchar2(10) -- 客户服务升级分类代码
    ,hold_type_cd varchar2(10) -- 控股类型代码
    ,off_shore_cust_flg varchar2(10) -- 离岸客户标志
    ,subj_org_name varchar2(100) -- 隶属机构名称
    ,prit_etp_flg varchar2(10) -- 民营企业标志
    ,ctysd_corp_flg varchar2(10) -- 农村企业标志
    ,corp_found_dt date -- 企业成立日期
    ,corp_size_cd varchar2(10) -- 企业规模代码
    ,corp_size_cd_intnal varchar2(10) -- 企业规模代码_内部
    ,ta_cust_size varchar2(250) -- 商圈客户规模
    ,ta_cust_indus_status varchar2(250) -- 商圈客户行业地位
    ,list_corp_type_cd varchar2(10) -- 上市公司类型代码
    ,list_corp_flg varchar2(10) -- 上市企业标志
    ,crdt_strategy_cd varchar2(10) -- 授信策略代码
    ,crdt_cust_flg varchar2(10) -- 授信客户标志
    ,bel_thi_flg varchar2(10) -- 属于两高行业标志
    ,rgst_dt date -- 注册日期
    ,orgnz_type_cd varchar2(10) -- 组织机构类型代码
    ,orgnz_type_subdv_cd varchar2(10) -- 组织机构类型细分代码
    ,econ_orgnz_form_cd varchar2(10) -- 经济组织形式代码
    ,trast_tax_regi_cert_flg varchar2(10) -- 办理税务登记证标志
    ,fin_stat_type_cd varchar2(10) -- 财务报表类型代码
    ,jnor_cog_over_number number(10) -- 大专以上人数
    ,cty_key_enterp_flg varchar2(10) -- 国家重点企业标志
    ,natnal_econ_dept_type_cd varchar2(10) -- 国民经济部门类型代码
    ,indus_type_cd_level5_cls varchar2(10) -- 行业类型代码_五级分类
    ,indus_type_cd_crdt_rating varchar2(10) -- 行业类型代码_信用评级
    ,org_subj varchar2(100) -- 机构隶属
    ,group_corp_flg varchar2(10) -- 集团公司标志
    ,group_cust_id varchar2(60) -- 补录集团客户编号
    ,resdnt_flg varchar2(10) -- 居民标志
    ,open_cap number(30,2) -- 开办资金
    ,cust_lev_cd varchar2(10) -- 客户级别代码
    ,retire_number number(10) -- 离退休人数
    ,super_director_dept varchar2(100) -- 上级主管部门
    ,cause_lp_size_or_lev_cd varchar2(10) -- 事业法人规模或级别代码
    ,cause_lp_cust_type_cd varchar2(10) -- 事业法人客户类型代码
    ,bal_pay_way_cd varchar2(10) -- 收支方式代码
    ,sys_in_cust_flg varchar2(10) -- 系统内客户标志
    ,lmt_or_encrge_indus_cd varchar2(10) -- 限制或鼓励行业代码
    ,have_hxb_share_qtty number(10) -- 拥有我行股份数量
    ,have_bod_flg varchar2(10) -- 有董事会标志
    ,budget_form_cd varchar2(10) -- 预算形式代码
    ,green_crdt_cust_flg varchar2(10) -- 绿色信贷客户标志
    ,araf_flg varchar2(10) -- 三农标志
    ,corp_size_cd_cpes varchar2(10) -- 企业规模代码_票交所
    ,indus_type_cd_cpes varchar2(10) -- 行业类型代码_票交所
    ,orgnz_cd varchar2(20) -- 组织机构代码
    ,corp_party_type_cd varchar2(20) -- 对公当事人类型代码
    ,rg_cd varchar2(10) -- 地区代码
    ,indus_type_cd_crdtc varchar2(10) -- 行业类型代码_征信
    ,indus_categy_cd_crdtc varchar2(10) -- 行业门类代码_征信
    ,tax_num_null_rs_descb varchar2(1000) -- 纳税人识别号空值原因描述
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.nras_pty_corp to ${iel_schema};

-- comment
comment on table ${idl_schema}.nras_pty_corp is '公司当事人';
comment on column ${idl_schema}.nras_pty_corp.etl_dt is '数据日期';
comment on column ${idl_schema}.nras_pty_corp.party_id is '当事人编号';
comment on column ${idl_schema}.nras_pty_corp.lp_id is '法人编号';
comment on column ${idl_schema}.nras_pty_corp.depositr_cate_cd is '存款人类别代码';
comment on column ${idl_schema}.nras_pty_corp.corp_name is '公司名称';
comment on column ${idl_schema}.nras_pty_corp.corp_en_name is '公司英文名称';
comment on column ${idl_schema}.nras_pty_corp.soci_crdt_cd is '社会信用代码';
comment on column ${idl_schema}.nras_pty_corp.curr_cd is '币种代码';
comment on column ${idl_schema}.nras_pty_corp.rgst_cap is '注册资金';
comment on column ${idl_schema}.nras_pty_corp.rgst_addr is '注册地址';
comment on column ${idl_schema}.nras_pty_corp.cty_rg_cd is '国家和地区代码';
comment on column ${idl_schema}.nras_pty_corp.indus_type_cd is '行业类型代码';
comment on column ${idl_schema}.nras_pty_corp.econ_char_cd is '经济性质代码';
comment on column ${idl_schema}.nras_pty_corp.taxpayer_idtfy_num is '纳税人识别号';
comment on column ${idl_schema}.nras_pty_corp.corp_type_cd is '企业类型代码';
comment on column ${idl_schema}.nras_pty_corp.tax_stament_flg is '取得税收居民取得自证声明标志';
comment on column ${idl_schema}.nras_pty_corp.tax_org_cate_cd is '税收机构类别代码';
comment on column ${idl_schema}.nras_pty_corp.tax_resdnt_cty_cd is '税收居民国家代码';
comment on column ${idl_schema}.nras_pty_corp.tax_resdnt_idti_cd is '税收居民身份代码';
comment on column ${idl_schema}.nras_pty_corp.emply_qtty is '员工数量';
comment on column ${idl_schema}.nras_pty_corp.fin_subsidy_inco_src_cd is '财政补助收入来源代码';
comment on column ${idl_schema}.nras_pty_corp.strategy_camp_cust_no is '策略营销客户号';
comment on column ${idl_schema}.nras_pty_corp.ins_adj_type_cd is '产业结构调整类型代码';
comment on column ${idl_schema}.nras_pty_corp.single_lmt is '单一限额';
comment on column ${idl_schema}.nras_pty_corp.single_lp_flg is '独立法人标志';
comment on column ${idl_schema}.nras_pty_corp.high_new_tech_corp_flg is '高新技术企业标志';
comment on column ${idl_schema}.nras_pty_corp.itau_flg is '工业转型升级标志';
comment on column ${idl_schema}.nras_pty_corp.rela_party_flg is '关联方标志';
comment on column ${idl_schema}.nras_pty_corp.rela_group_type_cd is '关联集团类型代码';
comment on column ${idl_schema}.nras_pty_corp.org_type_cd is '机构类型代码';
comment on column ${idl_schema}.nras_pty_corp.org_status_cd is '机构状态代码';
comment on column ${idl_schema}.nras_pty_corp.group_cust_flg is '集团客户标志';
comment on column ${idl_schema}.nras_pty_corp.weight_risk_asset_cust_cls_cd is '加权风险资产客户分类代码';
comment on column ${idl_schema}.nras_pty_corp.cbrc_sb_flg is '银监小企业标志';
comment on column ${idl_schema}.nras_pty_corp.econ_type_cd is '经济类型代码';
comment on column ${idl_schema}.nras_pty_corp.oper_range is '经营范围';
comment on column ${idl_schema}.nras_pty_corp.cust_sev_ugd_cls_cd is '客户服务升级分类代码';
comment on column ${idl_schema}.nras_pty_corp.hold_type_cd is '控股类型代码';
comment on column ${idl_schema}.nras_pty_corp.off_shore_cust_flg is '离岸客户标志';
comment on column ${idl_schema}.nras_pty_corp.subj_org_name is '隶属机构名称';
comment on column ${idl_schema}.nras_pty_corp.prit_etp_flg is '民营企业标志';
comment on column ${idl_schema}.nras_pty_corp.ctysd_corp_flg is '农村企业标志';
comment on column ${idl_schema}.nras_pty_corp.corp_found_dt is '企业成立日期';
comment on column ${idl_schema}.nras_pty_corp.corp_size_cd is '企业规模代码';
comment on column ${idl_schema}.nras_pty_corp.corp_size_cd_intnal is '企业规模代码_内部';
comment on column ${idl_schema}.nras_pty_corp.ta_cust_size is '商圈客户规模';
comment on column ${idl_schema}.nras_pty_corp.ta_cust_indus_status is '商圈客户行业地位';
comment on column ${idl_schema}.nras_pty_corp.list_corp_type_cd is '上市公司类型代码';
comment on column ${idl_schema}.nras_pty_corp.list_corp_flg is '上市企业标志';
comment on column ${idl_schema}.nras_pty_corp.crdt_strategy_cd is '授信策略代码';
comment on column ${idl_schema}.nras_pty_corp.crdt_cust_flg is '授信客户标志';
comment on column ${idl_schema}.nras_pty_corp.bel_thi_flg is '属于两高行业标志';
comment on column ${idl_schema}.nras_pty_corp.rgst_dt is '注册日期';
comment on column ${idl_schema}.nras_pty_corp.orgnz_type_cd is '组织机构类型代码';
comment on column ${idl_schema}.nras_pty_corp.orgnz_type_subdv_cd is '组织机构类型细分代码';
comment on column ${idl_schema}.nras_pty_corp.econ_orgnz_form_cd is '经济组织形式代码';
comment on column ${idl_schema}.nras_pty_corp.trast_tax_regi_cert_flg is '办理税务登记证标志';
comment on column ${idl_schema}.nras_pty_corp.fin_stat_type_cd is '财务报表类型代码';
comment on column ${idl_schema}.nras_pty_corp.jnor_cog_over_number is '大专以上人数';
comment on column ${idl_schema}.nras_pty_corp.cty_key_enterp_flg is '国家重点企业标志';
comment on column ${idl_schema}.nras_pty_corp.natnal_econ_dept_type_cd is '国民经济部门类型代码';
comment on column ${idl_schema}.nras_pty_corp.indus_type_cd_level5_cls is '行业类型代码_五级分类';
comment on column ${idl_schema}.nras_pty_corp.indus_type_cd_crdt_rating is '行业类型代码_信用评级';
comment on column ${idl_schema}.nras_pty_corp.org_subj is '机构隶属';
comment on column ${idl_schema}.nras_pty_corp.group_corp_flg is '集团公司标志';
comment on column ${idl_schema}.nras_pty_corp.group_cust_id is '补录集团客户编号';
comment on column ${idl_schema}.nras_pty_corp.resdnt_flg is '居民标志';
comment on column ${idl_schema}.nras_pty_corp.open_cap is '开办资金';
comment on column ${idl_schema}.nras_pty_corp.cust_lev_cd is '客户级别代码';
comment on column ${idl_schema}.nras_pty_corp.retire_number is '离退休人数';
comment on column ${idl_schema}.nras_pty_corp.super_director_dept is '上级主管部门';
comment on column ${idl_schema}.nras_pty_corp.cause_lp_size_or_lev_cd is '事业法人规模或级别代码';
comment on column ${idl_schema}.nras_pty_corp.cause_lp_cust_type_cd is '事业法人客户类型代码';
comment on column ${idl_schema}.nras_pty_corp.bal_pay_way_cd is '收支方式代码';
comment on column ${idl_schema}.nras_pty_corp.sys_in_cust_flg is '系统内客户标志';
comment on column ${idl_schema}.nras_pty_corp.lmt_or_encrge_indus_cd is '限制或鼓励行业代码';
comment on column ${idl_schema}.nras_pty_corp.have_hxb_share_qtty is '拥有我行股份数量';
comment on column ${idl_schema}.nras_pty_corp.have_bod_flg is '有董事会标志';
comment on column ${idl_schema}.nras_pty_corp.budget_form_cd is '预算形式代码';
comment on column ${idl_schema}.nras_pty_corp.green_crdt_cust_flg is '绿色信贷客户标志';
comment on column ${idl_schema}.nras_pty_corp.araf_flg is '三农标志';
comment on column ${idl_schema}.nras_pty_corp.corp_size_cd_cpes is '企业规模代码_票交所';
comment on column ${idl_schema}.nras_pty_corp.indus_type_cd_cpes is '行业类型代码_票交所';
comment on column ${idl_schema}.nras_pty_corp.orgnz_cd is '组织机构代码';
comment on column ${idl_schema}.nras_pty_corp.corp_party_type_cd is '对公当事人类型代码';
comment on column ${idl_schema}.nras_pty_corp.rg_cd is '地区代码';
comment on column ${idl_schema}.nras_pty_corp.indus_type_cd_crdtc is '行业类型代码_征信';
comment on column ${idl_schema}.nras_pty_corp.indus_categy_cd_crdtc is '行业门类代码_征信';
comment on column ${idl_schema}.nras_pty_corp.tax_num_null_rs_descb is '纳税人识别号空值原因描述';
comment on column ${idl_schema}.nras_pty_corp.job_cd is '任务代码';
comment on column ${idl_schema}.nras_pty_corp.etl_timestamp is '数据处理时间';
