whenever sqlerror exit sql.sqlcode;

----1.1 drop temp table
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_corp_tm_eifs_${batch_date} purge;


----2.1 add partition for target table after re-create new table
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_corp add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_corp modify partition p_eifsf1
    add subpartition p_eifsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;



-- 3.1 create temp table
whenever sqlerror exit sql.sqlcode;
CREATE TABLE ${iml_schema}.pty_corp_tm_eifs_${batch_date} nologging
compress ${option_switch} for query high 
as select * from  ${iml_schema}.pty_corp where 0=1;


-- 4.1 get bk data into temp table
insert into ${iml_schema}.pty_corp_tm_eifs_${batch_date}(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,depositr_cate_cd -- 存款人类别代码
    ,corp_name -- 公司名称
    ,corp_en_name -- 公司英文名称
    ,soci_crdt_cd -- 社会信用代码
    ,curr_cd -- 币种代码
    ,rgst_cap -- 注册资金
    ,rgst_addr -- 注册地址
    ,cty_rg_cd -- 国家和地区代码
    ,indus_type_cd -- 行业类型代码
    ,econ_char_cd -- 经济性质代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,corp_type_cd -- 企业类型代码
    ,tax_stament_flg -- 取得税收居民取得自证声明标志
    ,tax_org_cate_cd -- 税收机构类别代码
    ,tax_resdnt_cty_cd -- 税收居民国家代码
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,emply_qtty -- 员工数量
    ,fin_subsidy_inco_src_cd -- 财政补助收入来源代码
    ,strategy_camp_cust_no -- 策略营销客户号
    ,ins_adj_type_cd -- 产业结构调整类型代码
    ,single_lmt -- 单一限额
    ,single_lp_flg -- 独立法人标志
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,itau_flg -- 工业转型升级标志
    ,rela_party_flg -- 关联方标志
    ,rela_group_type_cd -- 关联集团类型代码
    ,org_type_cd -- 机构类型代码
    ,org_status_cd -- 机构状态代码
    ,group_cust_flg -- 集团客户标志
    ,weight_risk_asset_cust_cls_cd -- 加权风险资产客户分类代码
    ,cbrc_sb_flg -- 银监小企业标志
    ,econ_type_cd -- 经济类型代码
    ,oper_range -- 经营范围
    ,cust_sev_ugd_cls_cd -- 客户服务升级分类代码
    ,hold_type_cd -- 控股类型代码
    ,off_shore_cust_flg -- 离岸客户标志
    ,subj_org_name -- 隶属机构名称
    ,prit_etp_flg -- 民营企业标志
    ,ctysd_corp_flg -- 农村企业标志
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,corp_size_cd_intnal -- 企业规模代码_内部
    ,ta_cust_size -- 商圈客户规模
    ,ta_cust_indus_status -- 商圈客户行业地位
    ,list_corp_type_cd -- 上市公司类型代码
    ,list_corp_flg -- 上市企业标志
    ,crdt_strategy_cd -- 授信策略代码
    ,crdt_cust_flg -- 授信客户标志
    ,bel_thi_flg -- 属于两高行业标志
    ,rgst_dt -- 注册日期
    ,orgnz_type_cd -- 组织机构类型代码
    ,orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,econ_orgnz_form_cd -- 经济组织形式代码
    ,trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,fin_stat_type_cd -- 财务报表类型代码
    ,jnor_cog_over_number -- 大专以上人数
    ,cty_key_enterp_flg -- 国家重点企业标志
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,indus_type_cd_level5_cls -- 行业类型代码_五级分类
    ,indus_type_cd_crdt_rating -- 行业类型代码_信用评级
    ,org_subj -- 机构隶属
    ,group_corp_flg -- 集团公司标志
    ,group_cust_id -- 集团客户编号
    ,resdnt_flg -- 居民标志
    ,open_cap -- 开办资金
    ,cust_lev_cd -- 客户级别代码
    ,retire_number -- 离退休人数
    ,super_director_dept -- 上级主管部门
    ,cause_lp_size_or_lev_cd -- 事业法人规模或级别代码
    ,cause_lp_cust_type_cd -- 事业法人客户类型代码
    ,bal_pay_way_cd -- 收支方式代码
    ,sys_in_cust_flg -- 系统内客户标志
    ,lmt_or_encrge_indus_cd -- 限制或鼓励行业代码
    ,have_hxb_share_qtty -- 拥有我行股份数量
    ,have_bod_flg -- 有董事会标志
    ,budget_form_cd -- 预算形式代码
    ,green_crdt_cust_flg -- 绿色信贷客户标志
    ,araf_flg -- 三农标志
    ,corp_size_cd_cpes -- 企业规模代码_票交所
    ,indus_type_cd_cpes -- 行业类型代码_票交所
    ,orgnz_cd -- 组织机构代码
    ,corp_party_type_cd -- 对公当事人类型代码
    ,rg_cd -- 地区代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
) 
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,depositr_cate_cd -- 存款人类别代码
    ,corp_name -- 公司名称
    ,corp_en_name -- 公司英文名称
    ,soci_crdt_cd -- 社会信用代码
    ,curr_cd -- 币种代码
    ,rgst_cap -- 注册资金
    ,rgst_addr -- 注册地址
    ,cty_rg_cd -- 国家和地区代码
    ,indus_type_cd -- 行业类型代码
    ,econ_char_cd -- 经济性质代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,corp_type_cd -- 企业类型代码
    ,tax_stament_flg -- 取得税收居民取得自证声明标志
    ,tax_org_cate_cd -- 税收机构类别代码
    ,tax_resdnt_cty_cd -- 税收居民国家代码
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,emply_qtty -- 员工数量
    ,fin_subsidy_inco_src_cd -- 财政补助收入来源代码
    ,strategy_camp_cust_no -- 策略营销客户号
    ,ins_adj_type_cd -- 产业结构调整类型代码
    ,single_lmt -- 单一限额
    ,single_lp_flg -- 独立法人标志
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,itau_flg -- 工业转型升级标志
    ,rela_party_flg -- 关联方标志
    ,rela_group_type_cd -- 关联集团类型代码
    ,org_type_cd -- 机构类型代码
    ,org_status_cd -- 机构状态代码
    ,group_cust_flg -- 集团客户标志
    ,weight_risk_asset_cust_cls_cd -- 加权风险资产客户分类代码
    ,cbrc_sb_flg -- 银监小企业标志
    ,econ_type_cd -- 经济类型代码
    ,oper_range -- 经营范围
    ,cust_sev_ugd_cls_cd -- 客户服务升级分类代码
    ,hold_type_cd -- 控股类型代码
    ,off_shore_cust_flg -- 离岸客户标志
    ,subj_org_name -- 隶属机构名称
    ,prit_etp_flg -- 民营企业标志
    ,ctysd_corp_flg -- 农村企业标志
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,corp_size_cd_intnal -- 企业规模代码_内部
    ,ta_cust_size -- 商圈客户规模
    ,ta_cust_indus_status -- 商圈客户行业地位
    ,list_corp_type_cd -- 上市公司类型代码
    ,list_corp_flg -- 上市企业标志
    ,crdt_strategy_cd -- 授信策略代码
    ,crdt_cust_flg -- 授信客户标志
    ,bel_thi_flg -- 属于两高行业标志
    ,rgst_dt -- 注册日期
    ,orgnz_type_cd -- 组织机构类型代码
    ,orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,econ_orgnz_form_cd -- 经济组织形式代码
    ,trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,fin_stat_type_cd -- 财务报表类型代码
    ,jnor_cog_over_number -- 大专以上人数
    ,cty_key_enterp_flg -- 国家重点企业标志
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,indus_type_cd_level5_cls -- 行业类型代码_五级分类
    ,indus_type_cd_crdt_rating -- 行业类型代码_信用评级
    ,org_subj -- 机构隶属
    ,group_corp_flg -- 集团公司标志
    ,group_cust_id -- 集团客户编号
    ,resdnt_flg -- 居民标志
    ,open_cap -- 开办资金
    ,cust_lev_cd -- 客户级别代码
    ,retire_number -- 离退休人数
    ,super_director_dept -- 上级主管部门
    ,cause_lp_size_or_lev_cd -- 事业法人规模或级别代码
    ,cause_lp_cust_type_cd -- 事业法人客户类型代码
    ,bal_pay_way_cd -- 收支方式代码
    ,sys_in_cust_flg -- 系统内客户标志
    ,lmt_or_encrge_indus_cd -- 限制或鼓励行业代码
    ,have_hxb_share_qtty -- 拥有我行股份数量
    ,have_bod_flg -- 有董事会标志
    ,budget_form_cd -- 预算形式代码
    ,green_crdt_cust_flg -- 绿色信贷客户标志
    ,araf_flg -- 三农标志
    ,corp_size_cd_cpes -- 企业规模代码_票交所
    ,indus_type_cd_cpes -- 行业类型代码_票交所
    ,orgnz_cd -- 组织机构代码
    ,corp_party_type_cd -- 对公当事人类型代码
    ,' ' as rg_cd -- 地区代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_eifsf1_bk_20191121 p1;
commit;


-- 5.1 truncate target table
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_corp truncate partition for ('eifsf1') reuse storage;

-- 5.2 exchange partition
alter table ${iml_schema}.pty_corp exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_corp_tm_eifs_${batch_date};


-- 6.1 drop temp table
drop table ${iml_schema}.pty_corp_tm_eifs_${batch_date} purge;



