/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl pty_corp_cust
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.pty_corp_cust
whenever sqlerror continue none;
drop table ${idl_schema}.pty_corp_cust purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.pty_corp_cust(
    etl_dt date -- 数据日期   
    ,cust_id varchar2(60) -- 客户编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,sorc_sys_cd varchar2(10) -- 源系统代码   
    ,corp_cust_type_cd varchar2(10) -- 公司客户类型代码   
    ,orgnz_cd varchar2(60) -- 组织机构代码   
    ,corp_name varchar2(500) -- 公司名称   
    ,org_type_cd varchar2(30) -- 机构类型代码   
    ,indus_type_cd varchar2(10) -- 行业类型代码   
    ,econ_type_cd varchar2(10) -- 经济类型代码   
    ,econ_orgnz_form_cd varchar2(30) -- 经济组织形式代码   
    ,oper_range varchar2(1000) -- 经营范围   
    ,corp_size_cd varchar2(10) -- 企业规模代码   
    ,corp_found_dt date -- 企业成立日期   
    ,emply_qtty number(10) -- 员工数量   
    ,high_new_tech_corp_flg varchar2(10) -- 高新技术企业标志   
    ,list_corp_flg varchar2(10) -- 上市企业标志   
    ,is_mx_mgmt_righ_flg varchar2(10) -- 有无进出口经营权标志   
    ,rela_group_type_cd varchar2(30) -- 关联集团类型代码   
    ,group_cust_flg varchar2(10) -- 集团客户标志   
    ,escp_debt_corp_flg varchar2(10) -- 逃废债企业标志   
    ,strtg_cust_flg varchar2(10) -- 战略客户标志   
    ,off_shore_cust_flg varchar2(10) -- 离岸客户标志   
    ,cust_sev_ugd_cls_cd varchar2(30) -- 客户服务升级分类代码   
    ,weight_risk_asset_cust_cls_cd varchar2(30) -- 加权风险资产客户分类代码   
    ,crdt_strategy_cd varchar2(30) -- 授信策略代码   
    ,nb_corp_flg varchar2(10) -- 新建企业标志   
    ,hxb_rela_tran_flg varchar2(10) -- 我行关联交易标志   
    ,mc_dept_mplize_cust_flg varchar2(10) -- 中小企业事业部专营客户标志   
    ,hxb_idtfy_small_bus_flg varchar2(10) -- 我行认定小企业标志   
    ,bel_thi_flg varchar2(10) -- 属于两高行业标志   
    ,prit_etp_flg varchar2(10) -- 民营企业标志   
    ,cbrc_sb_flg varchar2(10) -- 银监小企业标志   
    ,hold_type_cd varchar2(10) -- 控股类型代码   
    ,fin_subsidy_inco_src_cd varchar2(30) -- 财政补助收入来源代码   
    ,rela_party_flg varchar2(10) -- 关联方标志   
    ,rgst_dt date -- 注册日期   
    ,crdt_cust_flg varchar2(10) -- 授信客户标志   
    ,hxb_shard_flg varchar2(10) -- 我行股东标志   
    ,subj_org_name varchar2(100) -- 隶属机构名称   
    ,cty_rg_cd varchar2(10) -- 国家和地区代码   
    ,ctysd_corp_flg varchar2(10) -- 农村企业标志   
    ,ta_cust_size varchar2(200) -- 商圈客户规模   
    ,ta_cust_indus_status varchar2(250) -- 商圈客户行业地位   
    ,ins_adj_type_cd varchar2(10) -- 产业结构调整类型代码   
    ,itau_flg varchar2(10) -- 工业转型升级标志   
    ,strtg_new_indus_type_cd varchar2(10) -- 战略新兴产业类型代码   
    ,list_corp_type_cd varchar2(10) -- 上市公司类型代码   
    ,is_mx_oper_item_flg varchar2(10) -- 有无进出口经营项标志   
    ,orgnz_type_subdv_cd varchar2(30) -- 组织机构类型细分代码   
    ,org_status_cd varchar2(10) -- 机构状态代码   
    ,orgnz_type_cd varchar2(10) -- 组织机构类型代码   
    ,soci_crdt_cd varchar2(30) -- 社会信用代码   
    ,strategy_camp_cust_no varchar2(60) -- 策略营销客户号   
    ,single_lmt number(30,2) -- 单一限额   
    ,corp_size_cd_intnal varchar2(10) -- 企业规模代码_内部   
    ,green_crdt_cust_flg varchar2(10) -- 绿色信贷客户标志   
    ,single_lp_flg varchar2(10) -- 独立法人标志   
    ,cust_ownsp_type_cd varchar2(10) -- 客户所有制类型代码   
    ,belong_rela_group_id varchar2(60) -- 所属关联集团编号   
    ,araf_flg varchar2(10) -- 三农标志   
    ,prtcptr_cate_cd varchar2(10) -- 参与者类别代码   
    ,rgst_cap number(30,2) -- 注册资金   
    ,bank_no varchar2(60) -- 银行行号   
    ,bank_lev_cd varchar2(10) -- 银行级别代码   
    ,ibank_no varchar2(60) -- 银行联行号   
    ,cpes_corp_size_cd varchar2(10) -- 票交所企业规模代码   
    ,cpes_indus_type_cd varchar2(10) -- 票交所行业类型代码   
    ,edu_hea_flg varchar2(10) -- 文教健康标志   
    ,inc_flg varchar2(10) -- 普惠型标志   
    ,labor_inte_corp_flg varchar2(10) -- 劳动密集型企业标志   
    ,corp_grow_stage_cd varchar2(30) -- 企业成长阶段代码   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识
    ,job_cd varchar2(10) -- 任务编码   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.pty_corp_cust to ${iel_schema};

-- comment
comment on table ${idl_schema}.pty_corp_cust is '公司客户';
comment on column ${idl_schema}.pty_corp_cust.etl_dt is '数据日期';
comment on column ${idl_schema}.pty_corp_cust.cust_id is '客户编号';
comment on column ${idl_schema}.pty_corp_cust.lp_id is '法人编号';
comment on column ${idl_schema}.pty_corp_cust.sorc_sys_cd is '源系统代码';
comment on column ${idl_schema}.pty_corp_cust.corp_cust_type_cd is '公司客户类型代码';
comment on column ${idl_schema}.pty_corp_cust.orgnz_cd is '组织机构代码';
comment on column ${idl_schema}.pty_corp_cust.corp_name is '公司名称';
comment on column ${idl_schema}.pty_corp_cust.org_type_cd is '机构类型代码';
comment on column ${idl_schema}.pty_corp_cust.indus_type_cd is '行业类型代码';
comment on column ${idl_schema}.pty_corp_cust.econ_type_cd is '经济类型代码';
comment on column ${idl_schema}.pty_corp_cust.econ_orgnz_form_cd is '经济组织形式代码';
comment on column ${idl_schema}.pty_corp_cust.oper_range is '经营范围';
comment on column ${idl_schema}.pty_corp_cust.corp_size_cd is '企业规模代码';
comment on column ${idl_schema}.pty_corp_cust.corp_found_dt is '企业成立日期';
comment on column ${idl_schema}.pty_corp_cust.emply_qtty is '员工数量';
comment on column ${idl_schema}.pty_corp_cust.high_new_tech_corp_flg is '高新技术企业标志';
comment on column ${idl_schema}.pty_corp_cust.list_corp_flg is '上市企业标志';
comment on column ${idl_schema}.pty_corp_cust.is_mx_mgmt_righ_flg is '有无进出口经营权标志';
comment on column ${idl_schema}.pty_corp_cust.rela_group_type_cd is '关联集团类型代码';
comment on column ${idl_schema}.pty_corp_cust.group_cust_flg is '集团客户标志';
comment on column ${idl_schema}.pty_corp_cust.escp_debt_corp_flg is '逃废债企业标志';
comment on column ${idl_schema}.pty_corp_cust.strtg_cust_flg is '战略客户标志';
comment on column ${idl_schema}.pty_corp_cust.off_shore_cust_flg is '离岸客户标志';
comment on column ${idl_schema}.pty_corp_cust.cust_sev_ugd_cls_cd is '客户服务升级分类代码';
comment on column ${idl_schema}.pty_corp_cust.weight_risk_asset_cust_cls_cd is '加权风险资产客户分类代码';
comment on column ${idl_schema}.pty_corp_cust.crdt_strategy_cd is '授信策略代码';
comment on column ${idl_schema}.pty_corp_cust.nb_corp_flg is '新建企业标志';
comment on column ${idl_schema}.pty_corp_cust.hxb_rela_tran_flg is '我行关联交易标志';
comment on column ${idl_schema}.pty_corp_cust.mc_dept_mplize_cust_flg is '中小企业事业部专营客户标志';
comment on column ${idl_schema}.pty_corp_cust.hxb_idtfy_small_bus_flg is '我行认定小企业标志';
comment on column ${idl_schema}.pty_corp_cust.bel_thi_flg is '属于两高行业标志';
comment on column ${idl_schema}.pty_corp_cust.prit_etp_flg is '民营企业标志';
comment on column ${idl_schema}.pty_corp_cust.cbrc_sb_flg is '银监小企业标志';
comment on column ${idl_schema}.pty_corp_cust.hold_type_cd is '控股类型代码';
comment on column ${idl_schema}.pty_corp_cust.fin_subsidy_inco_src_cd is '财政补助收入来源代码';
comment on column ${idl_schema}.pty_corp_cust.rela_party_flg is '关联方标志';
comment on column ${idl_schema}.pty_corp_cust.rgst_dt is '注册日期';
comment on column ${idl_schema}.pty_corp_cust.crdt_cust_flg is '授信客户标志';
comment on column ${idl_schema}.pty_corp_cust.hxb_shard_flg is '我行股东标志';
comment on column ${idl_schema}.pty_corp_cust.subj_org_name is '隶属机构名称';
comment on column ${idl_schema}.pty_corp_cust.cty_rg_cd is '国家和地区代码';
comment on column ${idl_schema}.pty_corp_cust.ctysd_corp_flg is '农村企业标志';
comment on column ${idl_schema}.pty_corp_cust.ta_cust_size is '商圈客户规模';
comment on column ${idl_schema}.pty_corp_cust.ta_cust_indus_status is '商圈客户行业地位';
comment on column ${idl_schema}.pty_corp_cust.ins_adj_type_cd is '产业结构调整类型代码';
comment on column ${idl_schema}.pty_corp_cust.itau_flg is '工业转型升级标志';
comment on column ${idl_schema}.pty_corp_cust.strtg_new_indus_type_cd is '战略新兴产业类型代码';
comment on column ${idl_schema}.pty_corp_cust.list_corp_type_cd is '上市公司类型代码';
comment on column ${idl_schema}.pty_corp_cust.is_mx_oper_item_flg is '有无进出口经营项标志';
comment on column ${idl_schema}.pty_corp_cust.orgnz_type_subdv_cd is '组织机构类型细分代码';
comment on column ${idl_schema}.pty_corp_cust.org_status_cd is '机构状态代码';
comment on column ${idl_schema}.pty_corp_cust.orgnz_type_cd is '组织机构类型代码';
comment on column ${idl_schema}.pty_corp_cust.soci_crdt_cd is '社会信用代码';
comment on column ${idl_schema}.pty_corp_cust.strategy_camp_cust_no is '策略营销客户号';
comment on column ${idl_schema}.pty_corp_cust.single_lmt is '单一限额';
comment on column ${idl_schema}.pty_corp_cust.corp_size_cd_intnal is '企业规模代码_内部';
comment on column ${idl_schema}.pty_corp_cust.green_crdt_cust_flg is '绿色信贷客户标志';
comment on column ${idl_schema}.pty_corp_cust.single_lp_flg is '独立法人标志';
comment on column ${idl_schema}.pty_corp_cust.cust_ownsp_type_cd is '客户所有制类型代码';
comment on column ${idl_schema}.pty_corp_cust.belong_rela_group_id is '所属关联集团编号';
comment on column ${idl_schema}.pty_corp_cust.araf_flg is '三农标志';
comment on column ${idl_schema}.pty_corp_cust.prtcptr_cate_cd is '参与者类别代码';
comment on column ${idl_schema}.pty_corp_cust.rgst_cap is '注册资金';
comment on column ${idl_schema}.pty_corp_cust.bank_no is '银行行号';
comment on column ${idl_schema}.pty_corp_cust.bank_lev_cd is '银行级别代码';
comment on column ${idl_schema}.pty_corp_cust.ibank_no is '银行联行号';
comment on column ${idl_schema}.pty_corp_cust.cpes_corp_size_cd is '票交所企业规模代码';
comment on column ${idl_schema}.pty_corp_cust.cpes_indus_type_cd is '票交所行业类型代码';
comment on column ${idl_schema}.pty_corp_cust.edu_hea_flg is '文教健康标志';
comment on column ${idl_schema}.pty_corp_cust.inc_flg is '普惠型标志';
comment on column ${idl_schema}.pty_corp_cust.labor_inte_corp_flg is '劳动密集型企业标志';
comment on column ${idl_schema}.pty_corp_cust.corp_grow_stage_cd is '企业成长阶段代码';
comment on column ${idl_schema}.pty_corp_cust.create_dt is '创建日期';
comment on column ${idl_schema}.pty_corp_cust.update_dt is '更新日期';
comment on column ${idl_schema}.pty_corp_cust.id_mark is '删除标识';