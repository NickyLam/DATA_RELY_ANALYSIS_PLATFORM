/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_corp_eifsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_corp add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_corp_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp partition for ('eifsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_corp_eifsf1_tm purge;
drop table ${iml_schema}.pty_corp_eifsf1_op purge;
drop table ${iml_schema}.pty_corp_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,depositr_cate_cd -- 存款人类别代码
    ,corp_name -- 公司名称
    ,corp_en_name -- 公司英文名称
    ,soci_crdt_cd -- 统一社会信用代码
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
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,emply_qtty -- 企业员工人数
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
    ,ctysd_corp_flg -- 农村城市标志
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,corp_size_cd_intnal -- 企业规模代码_内部
    ,ta_cust_size -- 商圈客户规模
    ,ta_cust_indus_status -- 商圈客户行业地位
    ,list_corp_type_cd -- 上市类型代码
    ,list_corp_flg -- 上市企业标志
    ,crdt_strategy_cd -- 授信策略代码
    ,crdt_cust_flg -- 授信客户标志
    ,bel_thi_flg -- 属于两高行业标志
    ,rgst_dt -- 注册日期
    ,orgnz_type_cd -- 组织机构类型代码
    ,orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,econ_orgnz_form_cd -- 控股类型代码
    ,trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,fin_stat_type_cd -- 财务报表类型代码
    ,jnor_cog_over_number -- 大专以上人数
    ,cty_key_enterp_flg -- 国家重点企业标志
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,indus_type_cd_level5_cls -- 行业类型代码_五级分类
    ,indus_type_cd_crdt_rating -- 行业类型代码_信用评级
    ,org_subj -- 机构隶属
    ,group_corp_flg -- 集团公司标志
    ,group_cust_id -- 集团编号
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
    ,green_crdt_cust_flg -- 绿色信贷标志
    ,araf_flg -- 三农标志
    ,corp_size_cd_cpes -- 企业规模代码_票交所
    ,indus_type_cd_cpes -- 行业类型代码_票交所
    ,orgnz_cd -- 组织机构代码
    ,corp_party_type_cd -- 对公当事人类型代码
    ,rg_cd -- 注册行政区划代码
    ,indus_type_cd_crdtc -- 行业类型代码_征信
    ,indus_categy_cd_crdtc -- 行业门类代码_征信
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,non_rec_rs -- 不良记录原因
    ,blklist_cust_flg -- 黑名单客户标志
    ,blklist_rgst_dt -- 上黑名单日期
    ,blklist_rs -- 上黑名单原因
    ,loan_card_no -- 贷款卡号
    ,stock_cd -- 股票代码
    ,citizen_treat_flg -- 国民待遇标志
    ,fir_setup_crdt_rela_dt -- 首次建立信贷关系日期
    ,mger_member_number -- 管理人员人数
    ,digit_econ_indus_cd -- 数字经济行业代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,share_ratio -- 持股比例
    ,super_orgnz_cd -- 上级机构组织机构代码
    ,super_unify_soci_crdt_cd -- 上级机构统一社会信用代码
    ,director_corp_rgst_curr_cd -- 主管单位注册币种代码
    ,director_corp_rgst_amt -- 主管单位注册金额
    ,shard_type_cd -- 股东类型代码
    ,ctrler_type_cd -- 控制人类型代码
    ,property_type_cd -- 产业类型代码
    ,role_type_cd -- 角色类型代码
    ,lp_org_name -- 法人机构名称
    ,lp_org_type_cd -- 法人机构类型代码
    ,lp_org_cust_id -- 法人机构客户编号
    ,super_org_cust_id -- 上级机构客户编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,cust_ownsp_type_cd -- 客户所有制类型代码
    ,mang_site_dist_cd -- 经营所在地行政区划代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_corp_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_corp_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_t01_corp_cust_info-1
insert into ${iml_schema}.pty_corp_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,depositr_cate_cd -- 存款人类别代码
    ,corp_name -- 公司名称
    ,corp_en_name -- 公司英文名称
    ,soci_crdt_cd -- 统一社会信用代码
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
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,emply_qtty -- 企业员工人数
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
    ,ctysd_corp_flg -- 农村城市标志
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,corp_size_cd_intnal -- 企业规模代码_内部
    ,ta_cust_size -- 商圈客户规模
    ,ta_cust_indus_status -- 商圈客户行业地位
    ,list_corp_type_cd -- 上市类型代码
    ,list_corp_flg -- 上市企业标志
    ,crdt_strategy_cd -- 授信策略代码
    ,crdt_cust_flg -- 授信客户标志
    ,bel_thi_flg -- 属于两高行业标志
    ,rgst_dt -- 注册日期
    ,orgnz_type_cd -- 组织机构类型代码
    ,orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,econ_orgnz_form_cd -- 控股类型代码
    ,trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,fin_stat_type_cd -- 财务报表类型代码
    ,jnor_cog_over_number -- 大专以上人数
    ,cty_key_enterp_flg -- 国家重点企业标志
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,indus_type_cd_level5_cls -- 行业类型代码_五级分类
    ,indus_type_cd_crdt_rating -- 行业类型代码_信用评级
    ,org_subj -- 机构隶属
    ,group_corp_flg -- 集团公司标志
    ,group_cust_id -- 集团编号
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
    ,green_crdt_cust_flg -- 绿色信贷标志
    ,araf_flg -- 三农标志
    ,corp_size_cd_cpes -- 企业规模代码_票交所
    ,indus_type_cd_cpes -- 行业类型代码_票交所
    ,orgnz_cd -- 组织机构代码
    ,corp_party_type_cd -- 对公当事人类型代码
    ,rg_cd -- 注册行政区划代码
    ,indus_type_cd_crdtc -- 行业类型代码_征信
    ,indus_categy_cd_crdtc -- 行业门类代码_征信
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,non_rec_rs -- 不良记录原因
    ,blklist_cust_flg -- 黑名单客户标志
    ,blklist_rgst_dt -- 上黑名单日期
    ,blklist_rs -- 上黑名单原因
    ,loan_card_no -- 贷款卡号
    ,stock_cd -- 股票代码
    ,citizen_treat_flg -- 国民待遇标志
    ,fir_setup_crdt_rela_dt -- 首次建立信贷关系日期
    ,mger_member_number -- 管理人员人数
    ,digit_econ_indus_cd -- 数字经济行业代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,share_ratio -- 持股比例
    ,super_orgnz_cd -- 上级机构组织机构代码
    ,super_unify_soci_crdt_cd -- 上级机构统一社会信用代码
    ,director_corp_rgst_curr_cd -- 主管单位注册币种代码
    ,director_corp_rgst_amt -- 主管单位注册金额
    ,ctrler_type_cd -- 股东类型代码
    ,shard_type_cd -- 控制人类型代码
    ,property_type_cd -- 产业类型代码
    ,role_type_cd -- 角色类型代码
    ,lp_org_name -- 法人机构名称
    ,lp_org_type_cd -- 法人机构类型代码
    ,lp_org_cust_id -- 法人机构客户编号
    ,super_org_cust_id -- 上级机构客户编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,cust_ownsp_type_cd -- 客户所有制类型代码
    ,mang_site_dist_cd -- 经营所在地行政区划代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,nvl(trim(P1.DEPOSITOR_TYPE_CD),'299')  -- 存款人类别代码
    ,P1.CUST_NAME -- 公司名称
    ,NVL(P3.EN_NAME,' ') -- 公司英文名称
    ,NVL(P16.CERT_NUM,' ') -- 统一社会信用代码
    ,NVL(TRIM(P1.REG_CAPITAL_CURRENCY),'CNY') -- 币种代码
    ,P1.RGST_CAP -- 注册资金
    ,NVL(P4.ADDR_DETAIL,' ') -- 注册地址
    ,NVL(TRIM(P3.NATION_CD),'XXX') -- 国家和地区代码
    ,NVL(TRIM(P5.INDUS_TYPE_CD_NAT_STAN),'-') -- 行业类型代码
    ,NVL(TRIM(P5.ECO_TYPE),'000')  -- 经济性质代码
    ,NVL(P15.TAX_NUMBER,' ') -- 纳税人识别号
    ,NVL(TRIM(P1.ENTERPRISE_TYPE),'0') -- 企业类型代码
    ,NVL(TRIM(P15.TAX_SELF_DECLARE),' ') -- 取得税收居民取得自证声明标志
    ,NVL(TRIM(P1.ORG_TYPE),'-') -- 税收机构类别代码
    ,NVL(TRIM(P15.TAX_COUNTRY),'XXX') -- 税收居民国家代码组合
    ,NVL(TRIM(P3.TAX_PAY_CTZN_IDNT),'5') -- 税收居民身份代码
    ,P1.CORP_EMPLY_PERSON_CNT -- 企业员工人数
    ,' ' -- 财政补助收入来源代码
    ,' ' -- 策略营销客户号
    ,' ' -- 产业结构调整类型代码
    ,'0' -- 单一限额
    ,NVL(TRIM(P6.LABEL_VALUE),' ') -- 独立法人标志
    ,NVL(TRIM(P19.LABEL_VALUE),'0') -- 高新技术企业标志
    ,NVL(TRIM(P11.LABEL_VALUE),' ') -- 工业转型升级标志
    ,NVL(TRIM(P7.LABEL_VALUE),' ') -- 关联方标志
    ,' ' -- 关联集团类型代码
    ,' ' -- 机构类型代码
    ,case when  length(NVL(TRIM(P5.ORG_STATUS_CD),'0'))<30 then    NVL(TRIM(P5.ORG_STATUS_CD),'X') else  '@'||substr(P5.ORG_STATUS_CD,1,29) end  -- 机构状态代码
    , NVL(TRIM(p13.GROUP_FLAG),'0') -- 集团客户标志
    ,' ' -- 加权风险资产客户分类代码
    ,NVL(TRIM(P20.LABEL_VALUE),'0') -- 银监小企业标志
    ,NVL(TRIM(P5.ECO_TYPE_CD),'-') -- 经济类型代码
    ,P1.OPER_BIZ -- 经营范围
    ,' ' -- 客户服务升级分类代码
    ,'Z9999' -- 控股类型代码
    ,NVL(TRIM(P22.LABEL_VALUE),' ') -- 离岸客户标志
    ,NVL(P12.ORGANCNFULLNAME,' ') -- 隶属机构名称
    ,NVL(TRIM(P8.LABEL_VALUE),' ') -- 民营企业标志
    ,decode(TRIM(P3.FARMER_FLAG),'0','1','1','2','-')  -- 农村城市标志
    ,${iml_schema}.DATEFORMAT_MIN(P1.CORP_FOUND_DT) -- 企业成立日期
    ,NVL(TRIM(P1.CORP_SIZE_CD),'0')  -- 企业规模代码
    ,' ' -- 企业规模代码_内部
    ,' ' -- 商圈客户规模
    ,' ' -- 商圈客户行业地位
    ,'-' -- 上市类型代码
    ,P5.LIST_CORP_IND -- 上市企业标志
    ,' ' -- 授信策略代码
    ,NVL(TRIM(P9.LABEL_VALUE),'-') -- 授信客户标志
    ,NVL(TRIM(P21.LABEL_VALUE),' ') -- 属于两高行业标志
    ,${iml_schema}.DATEFORMAT_MIN(P5.Rgst_Dt) -- 注册日期
    ,'00' -- 组织机构类型代码
    ,NVL(TRIM(P1.Org_Type_Cd),'00') -- 组织机构类型细分代码
    ,NVL(TRIM(P1.ECONOMIC_ORG_FORM),'Z9999') -- 控股类型代码
    ,NVL(TRIM(P1.TAX_REGISTER_FLAG),' ') -- 办理税务登记证标志
    ,'-' -- 财务报表类型代码
    ,0 -- 大专以上人数
    ,NVL(TRIM(P23.LABEL_VALUE),'0') -- 国家重点企业标志
    ,NVL(TRIM(P1.NATION_ECO_DEPT_CD),'000') -- 国民经济部门类型代码
    ,NVL(TRIM(P5.INDUS_TYPE_CD_LEVEL5_CLS),'-') -- 行业类型代码_五级分类
    ,NVL(TRIM(P5.INDUS_TYPE_CD_CRDT_RATING),'-') -- 行业类型代码_信用评级
    ,NVL(P3.MGMT_ORG_NUM,' ') -- 机构隶属
    ,NVL(TRIM(P5.Group_Cust_Ind),'0') -- 集团公司标志
    ,NVL(TRIM(P5.BELONG_GROUP_NUM),' ') -- 集团编号
    ,CASE WHEN  P5.RESDNT_CHAR_CD ='1' THEN '1' WHEN P5.RESDNT_CHAR_CD ='2' THEN '0' ELSE '-' END -- 居民标志
    ,NVL(P5.OPEN_CAP,0) -- 开办资金
    ,NVL(TRIM(P5.CUST_CARD_LEVEL_CD),'0') -- 客户级别代码
    ,0 -- 离退休人数
    ,'-' -- 上级主管部门
    ,'0' -- 事业法人规模或级别代码
    ,'-' -- 事业法人客户类型代码
    ,'-' -- 收支方式代码
    ,'0' -- 系统内客户标志
    ,NVL(TRIM(P5.LMT_OR_ENCRGE_INDUS_CD),'-') -- 限制或鼓励行业代码
    ,0 -- 拥有我行股份数量
    ,'0' -- 有董事会标志
    ,'-' -- 预算形式代码
    ,NVL(TRIM(P13.GRN_FLAG),'-') -- 绿色信贷标志
    ,NVL(TRIM(P13.ARC_FLAG),'0') -- 三农标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P13.CORP_SCALE  END  -- 企业规模代码_票交所
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P13.IND_CLS  END   -- 行业类型代码_票交所
    ,NVL(TRIM(P14.CERT_NUM),'-') -- 组织机构代码
    ,nvl(trim(P3.Cust_Type_Cd),'-') -- 对公当事人类型代码
    ,NVL(TRIM(P1.REG_AREA_CODE),'000000') -- 注册行政区划代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.BELONG_INDUS_CD  END -- 行业类型代码_征信
    ,NVL(TRIM(P1.BELONG_INDUS_ACCT),'-') -- 行业门类代码_征信
    ,NVL(P15.TAX_NULL_REASON,' ') -- 纳税人识别号空值原因描述
    ,NVL(TRIM(P5.BAD_REC_REASON),'-') -- 不良记录原因
    ,NVL(TRIM(P5.BLKLIST_CUST_IND),'-') -- 黑名单客户标志
    ,${iml_schema}.DATEFORMAT_MIN(P5.UP_BLKLIST_DT) -- 上黑名单日期
    ,NVL(TRIM(P5.BLKLIST_TYPE),'-') -- 上黑名单原因
    ,NVL(TRIM(P5.LOAN_CARD_NUM),' ') -- 贷款卡号
    ,NVL(TRIM(P5.SHARES_CODE),' ') -- 股票代码
    ,NVL(TRIM(P5.NATIONAL_TREATMENT),'-') -- 国民待遇标志
    ,${iml_schema}.DATEFORMAT_MIN(P5.FIRST_CREDIT_RELA_TIME) -- 首次建立信贷关系日期
    ,NVL(P5.ADMIN_NUMBER,0) -- 管理人员人数
    ,P5.DIG_ECON -- 数字经济行业代码
    ,NVL(TRIM(P5.NEW_STR_EME),'-') -- 战略新兴产业类型代码
    ,'0' -- 持股比例
    ,' ' -- 上级机构组织机构代码
    ,' ' -- 上级机构统一社会信用代码
    ,'-' -- 主管单位注册币种代码
    ,0 -- 主管单位注册金额
    ,'-' -- 股东类型代码
    ,'-' -- 控制人类型代码
    ,NVL(TRIM(P5.INDUSTRY_TYPE),'-') -- 产业类型代码
    ,CASE WHEN R10.TARGET_CD_VAL IS NOT NULL THEN R10.TARGET_CD_VAL ELSE '@'||NVL(TRIM(P1.PARTY_ROLE),' ')  END -- 角色类型代码
    ,P5.LEGAL_NAME -- 法人机构名称
    ,CASE WHEN R11.TARGET_CD_VAL IS NOT NULL THEN R11.TARGET_CD_VAL ELSE '@'||NVL(TRIM(P5.LEGAL_ORG_TYPE),' ')  END -- 法人机构类型代码
    ,P5.LEGAL_CUST_NUM -- 法人机构客户编号
    ,P5.SUPERIOR_CUST_NUM -- 上级机构客户编号
    ,P1.INIT_SYSTEM_ID -- 开户渠道代码
    ,CASE WHEN TRIM(P5.OWNER_TYPE) IS NULL THEN '00'
     WHEN LENGTH(P5.OWNER_TYPE)=1 THEN '0'||P5.OWNER_TYPE
ELSE P5.OWNER_TYPE
END -- 客户所有制类型代码
    ,nvl(trim(P3.ADDR_DIST_CD),'000000') -- 经营所在地行政区划代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_cust_info p1
    left join ${iol_schema}.eifs_t00_corp_cust_no_ref p2 on P1.PARTY_ID=P2.PARTY_ID AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t00_party_pub_info p3 on P1.PARTY_ID=P3.PARTY_ID AND P3.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P3.end_dt > to_date('${batch_date}','yyyymmdd') 
    left join (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY party_id ORDER BY updated_ts DESC) RN
               FROM ${iol_schema}.eifs_t01_corp_cust_ext_info T
					     where t.start_dt<= to_date('${batch_date}','yyyymmdd') 
               and t.end_dt > to_date('${batch_date}','yyyymmdd')) p5 
        on P1.PARTY_ID=P5.PARTY_ID 
        AND P5.rn=1
    left join (select t1.*,row_number() over(partition by party_id,cert_type_cd order by t1.updated_ts desc) as rid from ${iol_schema}.eifs_t00_corp_cust_cert_ref t1 where  t1.cert_type_cd='2313' and t1.start_dt<= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd')  ) p16 on P1.PARTY_ID=P16.PARTY_ID  AND P16.RID=1
    left join (select t1.*,row_number() over(partition by party_id,phys_addr_type_cd order by last_updated_ts desc) as rid from ${iol_schema}.eifs_t03_corp_addr_info t1  where    t1.phys_addr_type_cd='05' and t1.start_dt<= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd') ) p4 on P1.PARTY_ID=P4.PARTY_ID  AND p4.RID=1
    left join ${iol_schema}.eifs_t01_corp_tax_info p15 on P1.PARTY_ID=P15.PARTY_ID AND P15.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P15.end_dt > to_date('${batch_date}','yyyymmdd') and p15.updated_ts = to_date('99991231', 'yyyymmdd') 
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p6 on P1.PARTY_ID=P6.PARTY_ID AND P6.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P6.end_dt > to_date('${batch_date}','yyyymmdd') AND P6.LABEL_TYPE_CD='C0004' 
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p19 on P1.PARTY_ID=P19.PARTY_ID AND P19.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P19.end_dt > to_date('${batch_date}','yyyymmdd') AND P19.LABEL_TYPE_CD='C0021' 
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p11 on P1.PARTY_ID=P11.PARTY_ID AND P11.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P11.end_dt > to_date('${batch_date}','yyyymmdd') AND P11.LABEL_TYPE_CD='C0006' 
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p7 on P1.PARTY_ID=P7.PARTY_ID AND P7.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P7.end_dt > to_date('${batch_date}','yyyymmdd') AND P7.LABEL_TYPE_CD='C0018' 
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p20 on P1.PARTY_ID=P20.PARTY_ID AND P20.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P20.end_dt > to_date('${batch_date}','yyyymmdd') AND P20.LABEL_TYPE_CD='C0026' 
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p22 on P1.PARTY_ID=P22.PARTY_ID AND P22.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P22.end_dt > to_date('${batch_date}','yyyymmdd') AND P22.LABEL_TYPE_CD='C0033' 
    left join ${iol_schema}.uuss_uus_organ p12 on P3.MGMT_ORG_NUM=P12.ORGANCODE AND P12.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P12.end_dt > to_date('${batch_date}','yyyymmdd') 
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p8 on P1.PARTY_ID=P8.PARTY_ID AND P8.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P8.end_dt > to_date('${batch_date}','yyyymmdd') AND P8.LABEL_TYPE_CD='C0005' 
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p9 on P1.PARTY_ID=P9.PARTY_ID AND P9.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P9.end_dt > to_date('${batch_date}','yyyymmdd') AND P9.LABEL_TYPE_CD='C0007'  
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p21 on P1.PARTY_ID=P21.PARTY_ID AND P21.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P21.end_dt > to_date('${batch_date}','yyyymmdd') AND P21.LABEL_TYPE_CD='C0025' 
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p23 on P1.PARTY_ID=P23.PARTY_ID AND P23.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P23.end_dt > to_date('${batch_date}','yyyymmdd') AND P23.LABEL_TYPE_CD='C0020' 
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p17 on P1.PARTY_ID=P17.PARTY_ID AND P17.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P17.end_dt > to_date('${batch_date}','yyyymmdd') AND P17.LABEL_TYPE_CD='C0014'  
    left join ( select cust_no,group_flag,GRN_FLAG,ARC_FLAG,start_dt,end_dt,IND_CLS,CORP_SCALE,
                       row_number() over(partition by cust_no order by id desc) as rn
                  from ${iol_schema}.BDMS_BMS_CUSTOMER_INFO
                 where start_dt<= to_date('${batch_date}','yyyymmdd')
                   and end_dt > to_date('${batch_date}','yyyymmdd')) p13 on P13.CUST_NO=P2.CUST_NUM
and P13.rn = 1
    left join (select t1.*,row_number() over(partition by party_id,cert_type_cd order by t1.updated_ts desc) as rid from ${iol_schema}.eifs_t00_corp_cust_cert_ref t1 where  t1.cert_type_cd='2020' and t1.start_dt<= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd')  ) p14 on P1.PARTY_ID=P14.PARTY_ID  AND P14.RID=1
    left join ${iml_schema}.ref_pub_cd_map r7 on NVL(TRIM(P1.BELONG_INDUS_CD),' ') = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'EIFS2'
        AND R7.SRC_TAB_EN_NAME= 'EIFS_T01_CORP_CUST_INFO'
        AND R7.SRC_FIELD_EN_NAME= 'BELONG_INDUS_CD'
        AND R7.TARGET_TAB_EN_NAME= 'PTY_CORP'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'INDUS_TYPE_CD_CRDTC'
    left join ${iml_schema}.ref_pub_cd_map r10 on NVL(TRIM(P1.PARTY_ROLE),' ') = R10.SRC_CODE_VAL
        AND R10.SORC_SYS_CD= 'EIFS2'
        AND R10.SRC_TAB_EN_NAME= 'EIFS_T01_CORP_CUST_INFO'
        AND R10.SRC_FIELD_EN_NAME= 'PARTY_ROLE'
        AND R10.TARGET_TAB_EN_NAME= 'PTY_CORP'
        AND R10.TARGET_TAB_FIELD_EN_NAME= 'ROLE_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r11 on NVL(TRIM(P5.LEGAL_ORG_TYPE),' ') = R11.SRC_CODE_VAL
        AND R11.SORC_SYS_CD= 'EIFS2'
        AND R11.SRC_TAB_EN_NAME= 'EIFS_T01_CORP_CUST_EXT_INFO'
        AND R11.SRC_FIELD_EN_NAME= 'LEGAL_ORG_TYPE'
        AND R11.TARGET_TAB_EN_NAME= 'PTY_CORP'
        AND R11.TARGET_TAB_FIELD_EN_NAME= 'LP_ORG_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on NVL(TRIM(P13.CORP_SCALE),' ') = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_BMS_CUSTOMER_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'CORP_SCALE'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_CORP'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CORP_SIZE_CD_CPES'  
    left join ${iml_schema}.ref_pub_cd_map r3 on NVL(TRIM(P13.IND_CLS),' ') = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_BMS_CUSTOMER_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'IND_CLS'
        AND R3.TARGET_TAB_EN_NAME= 'PTY_CORP'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'INDUS_TYPE_CD_CPES' 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- eifs_t01_corp_rel_corp_info-1
insert into ${iml_schema}.pty_corp_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,depositr_cate_cd -- 存款人类别代码
    ,corp_name -- 公司名称
    ,corp_en_name -- 公司英文名称
    ,soci_crdt_cd -- 统一社会信用代码
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
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,emply_qtty -- 企业员工人数
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
    ,ctysd_corp_flg -- 农村城市标志
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,corp_size_cd_intnal -- 企业规模代码_内部
    ,ta_cust_size -- 商圈客户规模
    ,ta_cust_indus_status -- 商圈客户行业地位
    ,list_corp_type_cd -- 上市类型代码
    ,list_corp_flg -- 上市企业标志
    ,crdt_strategy_cd -- 授信策略代码
    ,crdt_cust_flg -- 授信客户标志
    ,bel_thi_flg -- 属于两高行业标志
    ,rgst_dt -- 注册日期
    ,orgnz_type_cd -- 组织机构类型代码
    ,orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,econ_orgnz_form_cd -- 控股类型代码
    ,trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,fin_stat_type_cd -- 财务报表类型代码
    ,jnor_cog_over_number -- 大专以上人数
    ,cty_key_enterp_flg -- 国家重点企业标志
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,indus_type_cd_level5_cls -- 行业类型代码_五级分类
    ,indus_type_cd_crdt_rating -- 行业类型代码_信用评级
    ,org_subj -- 机构隶属
    ,group_corp_flg -- 集团公司标志
    ,group_cust_id -- 集团编号
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
    ,green_crdt_cust_flg -- 绿色信贷标志
    ,araf_flg -- 三农标志
    ,corp_size_cd_cpes -- 企业规模代码_票交所
    ,indus_type_cd_cpes -- 行业类型代码_票交所
    ,orgnz_cd -- 组织机构代码
    ,corp_party_type_cd -- 对公当事人类型代码
    ,rg_cd -- 注册行政区划代码
    ,indus_type_cd_crdtc -- 行业类型代码_征信
    ,indus_categy_cd_crdtc -- 行业门类代码_征信
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,non_rec_rs -- 不良记录原因
    ,blklist_cust_flg -- 黑名单客户标志
    ,blklist_rgst_dt -- 上黑名单日期
    ,blklist_rs -- 上黑名单原因
    ,loan_card_no -- 贷款卡号
    ,stock_cd -- 股票代码
    ,citizen_treat_flg -- 国民待遇标志
    ,fir_setup_crdt_rela_dt -- 首次建立信贷关系日期
    ,mger_member_number -- 管理人员人数
    ,digit_econ_indus_cd -- 数字经济行业代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,share_ratio -- 持股比例
    ,super_orgnz_cd -- 上级机构组织机构代码
    ,super_unify_soci_crdt_cd -- 上级机构统一社会信用代码
    ,director_corp_rgst_curr_cd -- 主管单位注册币种代码
    ,director_corp_rgst_amt -- 主管单位注册金额
    ,ctrler_type_cd -- 股东类型代码
    ,shard_type_cd -- 控制人类型代码
    ,property_type_cd -- 产业类型代码
    ,role_type_cd -- 角色类型代码
    ,lp_org_name -- 法人机构名称
    ,lp_org_type_cd -- 法人机构类型代码
    ,lp_org_cust_id -- 法人机构客户编号
    ,super_org_cust_id -- 上级机构客户编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,cust_ownsp_type_cd -- 客户所有制类型代码
    ,mang_site_dist_cd -- 经营所在地行政区划代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.REL_ENTERP_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,'299' -- 存款人类别代码
    ,P1.RELA_NAME -- 公司名称
    ,' ' -- 公司英文名称
    ,' ' -- 统一社会信用代码
    ,'-' -- 币种代码
    ,'0' -- 注册资金
    ,NVL(P6.ADDR_DETAIL,' ') -- 注册地址
    ,NVL(trim(P1.RELA_NATION_CD),'XXX') -- 国家和地区代码
    ,NVL(TRIM(P4.INDUS_TYPE_CD_NAT_STAN),'-') -- 行业类型代码
    ,NVL(TRIM(P4.ECO_TYPE),'000')  -- 经济性质代码
    ,' ' -- 纳税人识别号
    ,'0' -- 企业类型代码
    ,p1.LNKM_SELF_CERT_DECL_FLG -- 取得税收居民取得自证声明标志
    ,'-' -- 税收机构类别代码
    ,'XXX' -- 税收居民国家代码组合
    ,NVL(trim(P1.TAX_PAY_CTZN_IDNT),'5') -- 税收居民身份代码
    ,'0' -- 企业员工人数
    ,' ' -- 财政补助收入来源代码
    ,' ' -- 策略营销客户号
    ,' ' -- 产业结构调整类型代码
    ,'0' -- 单一限额
    ,' ' -- 独立法人标志
    ,NVL(TRIM(P7.LABEL_VALUE),'0') -- 高新技术企业标志
    ,' ' -- 工业转型升级标志
    ,' ' -- 关联方标志
    ,' ' -- 关联集团类型代码
    ,' ' -- 机构类型代码
    ,case when  length(NVL(TRIM(P4.ORG_STATUS_CD),'0'))<30 then    NVL(TRIM(P4.ORG_STATUS_CD),'X') else  '@'||substr(P4.ORG_STATUS_CD,1,29) end  -- 机构状态代码
    ,'0' -- 集团客户标志
    ,' ' -- 加权风险资产客户分类代码
    ,NVL(TRIM(P8.LABEL_VALUE),'0') -- 银监小企业标志
    ,NVL(TRIM(P4.ECO_TYPE_CD),'-') -- 经济类型代码
    ,' ' -- 经营范围
    ,' ' -- 客户服务升级分类代码
    ,'Z9999' -- 控股类型代码
    ,' ' -- 离岸客户标志
    ,' ' -- 隶属机构名称
    ,' ' -- 民营企业标志
    ,'-' -- 农村城市标志
    ,${iml_schema}.DATEFORMAT_MIN(P1.CORP_FOUND_DT) -- 企业成立日期
    ,'0' -- 企业规模代码
    ,' ' -- 企业规模代码_内部
    ,' ' -- 商圈客户规模
    ,' ' -- 商圈客户行业地位
    ,'-' -- 上市类型代码
    ,P4.LIST_CORP_IND -- 上市企业标志
    ,' ' -- 授信策略代码
    ,'-' -- 授信客户标志
    ,' ' -- 属于两高行业标志
    ,${iml_schema}.DATEFORMAT_MIN(P4.Rgst_Dt) -- 注册日期
    ,'00' -- 组织机构类型代码
    ,NVL(TRIM(P2.Org_Type_Cd),'00') -- 组织机构类型细分代码
    ,NVL(TRIM(P2.ECONOMIC_ORG_FORM),'Z9999') -- 控股类型代码
    ,NVL(TRIM(P9.LABEL_VALUE),'0') -- 办理税务登记证标志
    ,'-' -- 财务报表类型代码
    ,0 -- 大专以上人数
    ,NVL(TRIM(P10.LABEL_VALUE),'0') -- 国家重点企业标志
    ,NVL(TRIM(p2.nation_eco_dept_cd),'000') -- 国民经济部门类型代码
    ,NVL(TRIM(P4.INDUS_TYPE_CD_LEVEL5_CLS),'-') -- 行业类型代码_五级分类
    ,NVL(TRIM(P4.INDUS_TYPE_CD_CRDT_RATING),'-') -- 行业类型代码_信用评级
    ,' ' -- 机构隶属
    ,NVL(TRIM(P4.Group_Cust_Ind),'0') -- 集团公司标志
    ,NVL(TRIM(P4.BELONG_GROUP_NUM),' ') -- 集团编号
    ,CASE WHEN  P4.RESDNT_CHAR_CD ='1' THEN '1' WHEN P4.RESDNT_CHAR_CD ='2' THEN '0' ELSE '-' END -- 居民标志
    ,NVL(P4.OPEN_CAP,0) -- 开办资金
    ,NVL(TRIM(P4.CUST_CARD_LEVEL_CD),'0') -- 客户级别代码
    ,0 -- 离退休人数
    ,'-' -- 上级主管部门
    ,'0' -- 事业法人规模或级别代码
    ,'-' -- 事业法人客户类型代码
    ,'-' -- 收支方式代码
    ,'0' -- 系统内客户标志
    ,NVL(TRIM(P4.LMT_OR_ENCRGE_INDUS_CD),'-') -- 限制或鼓励行业代码
    ,0 -- 拥有我行股份数量
    ,'0' -- 有董事会标志
    ,'-' -- 预算形式代码
    ,'0' -- 绿色信贷标志
    ,'0' -- 三农标志
    ,'-' -- 企业规模代码_票交所
    ,'-' -- 行业类型代码_票交所
    ,NVL(TRIM(P11.CERT_NUM),'-') -- 组织机构代码
    ,'-' -- 对公当事人类型代码
    ,NVL(TRIM(P2.REG_AREA_CODE),'000000') -- 注册行政区划代码
    ,'-' -- 行业类型代码_征信
    ,NVL(TRIM(P2.BELONG_INDUS_ACCT),'-') -- 行业门类代码_征信
    ,' ' -- 纳税人识别号空值原因描述
    ,NVL(TRIM(P4.BAD_REC_REASON),'-') -- 不良记录原因
    ,NVL(TRIM(P4.BLKLIST_CUST_IND),'-') -- 黑名单客户标志
    ,${iml_schema}.DATEFORMAT_MIN(P4.UP_BLKLIST_DT) -- 上黑名单日期
    ,NVL(TRIM(P4.BLKLIST_TYPE),'-') -- 上黑名单原因
    ,NVL(TRIM(P4.LOAN_CARD_NUM),' ') -- 贷款卡号
    ,NVL(TRIM(P4.SHARES_CODE),' ') -- 股票代码
    ,NVL(TRIM(P4.NATIONAL_TREATMENT),'-') -- 国民待遇标志
    ,${iml_schema}.DATEFORMAT_MIN(P4.FIRST_CREDIT_RELA_TIME) -- 首次建立信贷关系日期
    ,NVL(P4.ADMIN_NUMBER,0) -- 管理人员人数
    ,P4.DIG_ECON -- 数字经济行业代码
    ,NVL(TRIM(P4.NEW_STR_EME),'-') -- 战略新兴产业类型代码
    ,P1.HOLD_STOCK_RATIO -- 持股比例
    ,P1.SUPERIOR_ORG_CODE -- 上级机构组织机构代码
    ,P1.SUPERIOR_ORG_CREDIT_CODE -- 上级机构统一社会信用代码
    ,NVL(TRIM(P1.COMPETENT_ORG_REG_CURRENCY),'CNY') -- 主管单位注册币种代码
    ,P1.COMPETENT_ORG_REG_AMT -- 主管单位注册金额
    ,case when length(NVL(TRIM(P1.Ctrler_Typ_Cd),'-') )>29 then '@'|| NVL(TRIM(P1.Ctrler_Typ_Cd),'-')  else  NVL(TRIM(P1.Ctrler_Typ_Cd),'-')  end -- 股东类型代码
    ,case when length(NVL(TRIM(P1.SHRH_TYP_CD),'-'))>29 then '@'|| NVL(TRIM(P1.SHRH_TYP_CD),'-') else  NVL(TRIM(P1.SHRH_TYP_CD),'-') end -- 控制人类型代码
    ,NVL(TRIM(P4.INDUSTRY_TYPE),'-') -- 产业类型代码
    ,' ' -- 角色类型代码
    ,P4.LEGAL_NAME -- 法人机构名称
    ,CASE WHEN R11.TARGET_CD_VAL IS NOT NULL THEN R11.TARGET_CD_VAL ELSE '@'||NVL(TRIM(P4.LEGAL_ORG_TYPE),' ')  END -- 法人机构类型代码
    ,P4.LEGAL_CUST_NUM -- 法人机构客户编号
    ,P4.SUPERIOR_CUST_NUM -- 上级机构客户编号
    ,P1.INIT_SYSTEM_ID -- 开户渠道代码
    ,CASE WHEN TRIM(P4.OWNER_TYPE) IS NULL THEN '00'
     WHEN LENGTH(P4.OWNER_TYPE)=1 THEN '0'||P4.OWNER_TYPE
ELSE P4.OWNER_TYPE
END -- 客户所有制类型代码
    ,nvl(trim(P5.ADDR_DIST_CD),'000000') -- 经营所在地行政区划代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_rel_corp_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_rel_corp_info p1
    left join ${iol_schema}.eifs_t00_corp_cust_no_ref p3 on p1.rela_num=p3.cust_num and p3.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p3.end_dt > to_date('${batch_date}','yyyymmdd')   -- 用于取关联人的party_id
    left join (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY party_id ORDER BY updated_ts DESC) RN
               FROM ${iol_schema}.eifs_t01_corp_cust_ext_info T
					     where t.start_dt<= to_date('${batch_date}','yyyymmdd') 
               and t.end_dt > to_date('${batch_date}','yyyymmdd'))  p4 
    on P3.PARTY_ID=P4.PARTY_ID 
    AND P4.rn=1
    left join ${iol_schema}.eifs_t01_corp_cust_info p2 on p3.party_id=p2.party_id and p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
    left join (select t1.*,row_number() over(partition by party_id,phys_addr_type_cd order by last_updated_ts desc) as rid from ${iol_schema}.eifs_t03_corp_addr_info t1  where    t1.phys_addr_type_cd='05' and t1.start_dt<= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd') ) p6 on P1.PARTY_ID=P6.PARTY_ID  AND p6.RID=1
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p7 on P1.PARTY_ID=P7.PARTY_ID AND P7.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P7.end_dt > to_date('${batch_date}','yyyymmdd') AND P7.LABEL_TYPE_CD='C0021' 
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p8 on P1.PARTY_ID=P8.PARTY_ID AND P8.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P8.end_dt > to_date('${batch_date}','yyyymmdd') AND P8.LABEL_TYPE_CD='C0026' 
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p9 on P1.PARTY_ID=P9.PARTY_ID AND P9.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P9.end_dt > to_date('${batch_date}','yyyymmdd') AND P9.LABEL_TYPE_CD='C0022'
    left join ${iol_schema}.eifs_t08_corp_cust_tag_info p10 on P1.PARTY_ID=P10.PARTY_ID AND P10.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P10.end_dt > to_date('${batch_date}','yyyymmdd') AND P10.LABEL_TYPE_CD='C0020' 
    left join (select t1.*,row_number() over(partition by party_id,cert_type_cd order by t1.updated_ts desc) as rid from ${iol_schema}.eifs_t00_corp_cust_cert_ref t1 where  t1.cert_type_cd='2020' and t1.start_dt<= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd')  ) p11 on P1.PARTY_ID=P11.PARTY_ID  AND P11.RID=1
    left join ${iml_schema}.ref_pub_cd_map r11 on NVL(TRIM(P4.LEGAL_ORG_TYPE),' ') = R11.SRC_CODE_VAL
        AND R11.SORC_SYS_CD= 'EIFS2'
        AND R11.SRC_TAB_EN_NAME= 'EIFS_T01_CORP_CUST_EXT_INFO'
        AND R11.SRC_FIELD_EN_NAME= 'LEGAL_ORG_TYPE'
        AND R11.TARGET_TAB_EN_NAME= 'PTY_CORP'
        AND R11.TARGET_TAB_FIELD_EN_NAME= 'LP_ORG_TYPE_CD'
    left join ${iol_schema}.eifs_t00_party_pub_info p5 on P1.PARTY_ID=P5.PARTY_ID AND P5.start_dt<= to_date('${batch_date}','yyyymmdd') 
and P5.end_dt > to_date('${batch_date}','yyyymmdd') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_corp_eifsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_corp_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,depositr_cate_cd -- 存款人类别代码
    ,corp_name -- 公司名称
    ,corp_en_name -- 公司英文名称
    ,soci_crdt_cd -- 统一社会信用代码
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
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,emply_qtty -- 企业员工人数
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
    ,ctysd_corp_flg -- 农村城市标志
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,corp_size_cd_intnal -- 企业规模代码_内部
    ,ta_cust_size -- 商圈客户规模
    ,ta_cust_indus_status -- 商圈客户行业地位
    ,list_corp_type_cd -- 上市类型代码
    ,list_corp_flg -- 上市企业标志
    ,crdt_strategy_cd -- 授信策略代码
    ,crdt_cust_flg -- 授信客户标志
    ,bel_thi_flg -- 属于两高行业标志
    ,rgst_dt -- 注册日期
    ,orgnz_type_cd -- 组织机构类型代码
    ,orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,econ_orgnz_form_cd -- 控股类型代码
    ,trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,fin_stat_type_cd -- 财务报表类型代码
    ,jnor_cog_over_number -- 大专以上人数
    ,cty_key_enterp_flg -- 国家重点企业标志
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,indus_type_cd_level5_cls -- 行业类型代码_五级分类
    ,indus_type_cd_crdt_rating -- 行业类型代码_信用评级
    ,org_subj -- 机构隶属
    ,group_corp_flg -- 集团公司标志
    ,group_cust_id -- 集团编号
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
    ,green_crdt_cust_flg -- 绿色信贷标志
    ,araf_flg -- 三农标志
    ,corp_size_cd_cpes -- 企业规模代码_票交所
    ,indus_type_cd_cpes -- 行业类型代码_票交所
    ,orgnz_cd -- 组织机构代码
    ,corp_party_type_cd -- 对公当事人类型代码
    ,rg_cd -- 注册行政区划代码
    ,indus_type_cd_crdtc -- 行业类型代码_征信
    ,indus_categy_cd_crdtc -- 行业门类代码_征信
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,non_rec_rs -- 不良记录原因
    ,blklist_cust_flg -- 黑名单客户标志
    ,blklist_rgst_dt -- 上黑名单日期
    ,blklist_rs -- 上黑名单原因
    ,loan_card_no -- 贷款卡号
    ,stock_cd -- 股票代码
    ,citizen_treat_flg -- 国民待遇标志
    ,fir_setup_crdt_rela_dt -- 首次建立信贷关系日期
    ,mger_member_number -- 管理人员人数
    ,digit_econ_indus_cd -- 数字经济行业代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,share_ratio -- 持股比例
    ,super_orgnz_cd -- 上级机构组织机构代码
    ,super_unify_soci_crdt_cd -- 上级机构统一社会信用代码
    ,director_corp_rgst_curr_cd -- 主管单位注册币种代码
    ,director_corp_rgst_amt -- 主管单位注册金额
    ,shard_type_cd -- 股东类型代码
    ,ctrler_type_cd -- 控制人类型代码
    ,property_type_cd -- 产业类型代码
    ,role_type_cd -- 角色类型代码
    ,lp_org_name -- 法人机构名称
    ,lp_org_type_cd -- 法人机构类型代码
    ,lp_org_cust_id -- 法人机构客户编号
    ,super_org_cust_id -- 上级机构客户编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,cust_ownsp_type_cd -- 客户所有制类型代码
    ,mang_site_dist_cd -- 经营所在地行政区划代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_corp_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,depositr_cate_cd -- 存款人类别代码
    ,corp_name -- 公司名称
    ,corp_en_name -- 公司英文名称
    ,soci_crdt_cd -- 统一社会信用代码
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
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,emply_qtty -- 企业员工人数
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
    ,ctysd_corp_flg -- 农村城市标志
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,corp_size_cd_intnal -- 企业规模代码_内部
    ,ta_cust_size -- 商圈客户规模
    ,ta_cust_indus_status -- 商圈客户行业地位
    ,list_corp_type_cd -- 上市类型代码
    ,list_corp_flg -- 上市企业标志
    ,crdt_strategy_cd -- 授信策略代码
    ,crdt_cust_flg -- 授信客户标志
    ,bel_thi_flg -- 属于两高行业标志
    ,rgst_dt -- 注册日期
    ,orgnz_type_cd -- 组织机构类型代码
    ,orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,econ_orgnz_form_cd -- 控股类型代码
    ,trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,fin_stat_type_cd -- 财务报表类型代码
    ,jnor_cog_over_number -- 大专以上人数
    ,cty_key_enterp_flg -- 国家重点企业标志
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,indus_type_cd_level5_cls -- 行业类型代码_五级分类
    ,indus_type_cd_crdt_rating -- 行业类型代码_信用评级
    ,org_subj -- 机构隶属
    ,group_corp_flg -- 集团公司标志
    ,group_cust_id -- 集团编号
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
    ,green_crdt_cust_flg -- 绿色信贷标志
    ,araf_flg -- 三农标志
    ,corp_size_cd_cpes -- 企业规模代码_票交所
    ,indus_type_cd_cpes -- 行业类型代码_票交所
    ,orgnz_cd -- 组织机构代码
    ,corp_party_type_cd -- 对公当事人类型代码
    ,rg_cd -- 注册行政区划代码
    ,indus_type_cd_crdtc -- 行业类型代码_征信
    ,indus_categy_cd_crdtc -- 行业门类代码_征信
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,non_rec_rs -- 不良记录原因
    ,blklist_cust_flg -- 黑名单客户标志
    ,blklist_rgst_dt -- 上黑名单日期
    ,blklist_rs -- 上黑名单原因
    ,loan_card_no -- 贷款卡号
    ,stock_cd -- 股票代码
    ,citizen_treat_flg -- 国民待遇标志
    ,fir_setup_crdt_rela_dt -- 首次建立信贷关系日期
    ,mger_member_number -- 管理人员人数
    ,digit_econ_indus_cd -- 数字经济行业代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,share_ratio -- 持股比例
    ,super_orgnz_cd -- 上级机构组织机构代码
    ,super_unify_soci_crdt_cd -- 上级机构统一社会信用代码
    ,director_corp_rgst_curr_cd -- 主管单位注册币种代码
    ,director_corp_rgst_amt -- 主管单位注册金额
    ,shard_type_cd -- 股东类型代码
    ,ctrler_type_cd -- 控制人类型代码
    ,property_type_cd -- 产业类型代码
    ,role_type_cd -- 角色类型代码
    ,lp_org_name -- 法人机构名称
    ,lp_org_type_cd -- 法人机构类型代码
    ,lp_org_cust_id -- 法人机构客户编号
    ,super_org_cust_id -- 上级机构客户编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,cust_ownsp_type_cd -- 客户所有制类型代码
    ,mang_site_dist_cd -- 经营所在地行政区划代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.depositr_cate_cd, o.depositr_cate_cd) as depositr_cate_cd -- 存款人类别代码
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 公司名称
    ,nvl(n.corp_en_name, o.corp_en_name) as corp_en_name -- 公司英文名称
    ,nvl(n.soci_crdt_cd, o.soci_crdt_cd) as soci_crdt_cd -- 统一社会信用代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.rgst_cap, o.rgst_cap) as rgst_cap -- 注册资金
    ,nvl(n.rgst_addr, o.rgst_addr) as rgst_addr -- 注册地址
    ,nvl(n.cty_rg_cd, o.cty_rg_cd) as cty_rg_cd -- 国家和地区代码
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
    ,nvl(n.econ_char_cd, o.econ_char_cd) as econ_char_cd -- 经济性质代码
    ,nvl(n.taxpayer_idtfy_num, o.taxpayer_idtfy_num) as taxpayer_idtfy_num -- 纳税人识别号
    ,nvl(n.corp_type_cd, o.corp_type_cd) as corp_type_cd -- 企业类型代码
    ,nvl(n.tax_stament_flg, o.tax_stament_flg) as tax_stament_flg -- 取得税收居民取得自证声明标志
    ,nvl(n.tax_org_cate_cd, o.tax_org_cate_cd) as tax_org_cate_cd -- 税收机构类别代码
    ,nvl(n.tax_resdnt_cty_cd, o.tax_resdnt_cty_cd) as tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,nvl(n.tax_resdnt_idti_cd, o.tax_resdnt_idti_cd) as tax_resdnt_idti_cd -- 税收居民身份代码
    ,nvl(n.emply_qtty, o.emply_qtty) as emply_qtty -- 企业员工人数
    ,nvl(n.fin_subsidy_inco_src_cd, o.fin_subsidy_inco_src_cd) as fin_subsidy_inco_src_cd -- 财政补助收入来源代码
    ,nvl(n.strategy_camp_cust_no, o.strategy_camp_cust_no) as strategy_camp_cust_no -- 策略营销客户号
    ,nvl(n.ins_adj_type_cd, o.ins_adj_type_cd) as ins_adj_type_cd -- 产业结构调整类型代码
    ,nvl(n.single_lmt, o.single_lmt) as single_lmt -- 单一限额
    ,nvl(n.single_lp_flg, o.single_lp_flg) as single_lp_flg -- 独立法人标志
    ,nvl(n.high_new_tech_corp_flg, o.high_new_tech_corp_flg) as high_new_tech_corp_flg -- 高新技术企业标志
    ,nvl(n.itau_flg, o.itau_flg) as itau_flg -- 工业转型升级标志
    ,nvl(n.rela_party_flg, o.rela_party_flg) as rela_party_flg -- 关联方标志
    ,nvl(n.rela_group_type_cd, o.rela_group_type_cd) as rela_group_type_cd -- 关联集团类型代码
    ,nvl(n.org_type_cd, o.org_type_cd) as org_type_cd -- 机构类型代码
    ,nvl(n.org_status_cd, o.org_status_cd) as org_status_cd -- 机构状态代码
    ,nvl(n.group_cust_flg, o.group_cust_flg) as group_cust_flg -- 集团客户标志
    ,nvl(n.weight_risk_asset_cust_cls_cd, o.weight_risk_asset_cust_cls_cd) as weight_risk_asset_cust_cls_cd -- 加权风险资产客户分类代码
    ,nvl(n.cbrc_sb_flg, o.cbrc_sb_flg) as cbrc_sb_flg -- 银监小企业标志
    ,nvl(n.econ_type_cd, o.econ_type_cd) as econ_type_cd -- 经济类型代码
    ,nvl(n.oper_range, o.oper_range) as oper_range -- 经营范围
    ,nvl(n.cust_sev_ugd_cls_cd, o.cust_sev_ugd_cls_cd) as cust_sev_ugd_cls_cd -- 客户服务升级分类代码
    ,nvl(n.hold_type_cd, o.hold_type_cd) as hold_type_cd -- 控股类型代码
    ,nvl(n.off_shore_cust_flg, o.off_shore_cust_flg) as off_shore_cust_flg -- 离岸客户标志
    ,nvl(n.subj_org_name, o.subj_org_name) as subj_org_name -- 隶属机构名称
    ,nvl(n.prit_etp_flg, o.prit_etp_flg) as prit_etp_flg -- 民营企业标志
    ,nvl(n.ctysd_corp_flg, o.ctysd_corp_flg) as ctysd_corp_flg -- 农村城市标志
    ,nvl(n.corp_found_dt, o.corp_found_dt) as corp_found_dt -- 企业成立日期
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模代码
    ,nvl(n.corp_size_cd_intnal, o.corp_size_cd_intnal) as corp_size_cd_intnal -- 企业规模代码_内部
    ,nvl(n.ta_cust_size, o.ta_cust_size) as ta_cust_size -- 商圈客户规模
    ,nvl(n.ta_cust_indus_status, o.ta_cust_indus_status) as ta_cust_indus_status -- 商圈客户行业地位
    ,nvl(n.list_corp_type_cd, o.list_corp_type_cd) as list_corp_type_cd -- 上市类型代码
    ,nvl(n.list_corp_flg, o.list_corp_flg) as list_corp_flg -- 上市企业标志
    ,nvl(n.crdt_strategy_cd, o.crdt_strategy_cd) as crdt_strategy_cd -- 授信策略代码
    ,nvl(n.crdt_cust_flg, o.crdt_cust_flg) as crdt_cust_flg -- 授信客户标志
    ,nvl(n.bel_thi_flg, o.bel_thi_flg) as bel_thi_flg -- 属于两高行业标志
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 注册日期
    ,nvl(n.orgnz_type_cd, o.orgnz_type_cd) as orgnz_type_cd -- 组织机构类型代码
    ,nvl(n.orgnz_type_subdv_cd, o.orgnz_type_subdv_cd) as orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,nvl(n.econ_orgnz_form_cd, o.econ_orgnz_form_cd) as econ_orgnz_form_cd -- 控股类型代码
    ,nvl(n.trast_tax_regi_cert_flg, o.trast_tax_regi_cert_flg) as trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,nvl(n.fin_stat_type_cd, o.fin_stat_type_cd) as fin_stat_type_cd -- 财务报表类型代码
    ,nvl(n.jnor_cog_over_number, o.jnor_cog_over_number) as jnor_cog_over_number -- 大专以上人数
    ,nvl(n.cty_key_enterp_flg, o.cty_key_enterp_flg) as cty_key_enterp_flg -- 国家重点企业标志
    ,nvl(n.natnal_econ_dept_type_cd, o.natnal_econ_dept_type_cd) as natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,nvl(n.indus_type_cd_level5_cls, o.indus_type_cd_level5_cls) as indus_type_cd_level5_cls -- 行业类型代码_五级分类
    ,nvl(n.indus_type_cd_crdt_rating, o.indus_type_cd_crdt_rating) as indus_type_cd_crdt_rating -- 行业类型代码_信用评级
    ,nvl(n.org_subj, o.org_subj) as org_subj -- 机构隶属
    ,nvl(n.group_corp_flg, o.group_corp_flg) as group_corp_flg -- 集团公司标志
    ,nvl(n.group_cust_id, o.group_cust_id) as group_cust_id -- 集团编号
    ,nvl(n.resdnt_flg, o.resdnt_flg) as resdnt_flg -- 居民标志
    ,nvl(n.open_cap, o.open_cap) as open_cap -- 开办资金
    ,nvl(n.cust_lev_cd, o.cust_lev_cd) as cust_lev_cd -- 客户级别代码
    ,nvl(n.retire_number, o.retire_number) as retire_number -- 离退休人数
    ,nvl(n.super_director_dept, o.super_director_dept) as super_director_dept -- 上级主管部门
    ,nvl(n.cause_lp_size_or_lev_cd, o.cause_lp_size_or_lev_cd) as cause_lp_size_or_lev_cd -- 事业法人规模或级别代码
    ,nvl(n.cause_lp_cust_type_cd, o.cause_lp_cust_type_cd) as cause_lp_cust_type_cd -- 事业法人客户类型代码
    ,nvl(n.bal_pay_way_cd, o.bal_pay_way_cd) as bal_pay_way_cd -- 收支方式代码
    ,nvl(n.sys_in_cust_flg, o.sys_in_cust_flg) as sys_in_cust_flg -- 系统内客户标志
    ,nvl(n.lmt_or_encrge_indus_cd, o.lmt_or_encrge_indus_cd) as lmt_or_encrge_indus_cd -- 限制或鼓励行业代码
    ,nvl(n.have_hxb_share_qtty, o.have_hxb_share_qtty) as have_hxb_share_qtty -- 拥有我行股份数量
    ,nvl(n.have_bod_flg, o.have_bod_flg) as have_bod_flg -- 有董事会标志
    ,nvl(n.budget_form_cd, o.budget_form_cd) as budget_form_cd -- 预算形式代码
    ,nvl(n.green_crdt_cust_flg, o.green_crdt_cust_flg) as green_crdt_cust_flg -- 绿色信贷标志
    ,nvl(n.araf_flg, o.araf_flg) as araf_flg -- 三农标志
    ,nvl(n.corp_size_cd_cpes, o.corp_size_cd_cpes) as corp_size_cd_cpes -- 企业规模代码_票交所
    ,nvl(n.indus_type_cd_cpes, o.indus_type_cd_cpes) as indus_type_cd_cpes -- 行业类型代码_票交所
    ,nvl(n.orgnz_cd, o.orgnz_cd) as orgnz_cd -- 组织机构代码
    ,nvl(n.corp_party_type_cd, o.corp_party_type_cd) as corp_party_type_cd -- 对公当事人类型代码
    ,nvl(n.rg_cd, o.rg_cd) as rg_cd -- 注册行政区划代码
    ,nvl(n.indus_type_cd_crdtc, o.indus_type_cd_crdtc) as indus_type_cd_crdtc -- 行业类型代码_征信
    ,nvl(n.indus_categy_cd_crdtc, o.indus_categy_cd_crdtc) as indus_categy_cd_crdtc -- 行业门类代码_征信
    ,nvl(n.tax_num_null_rs_descb, o.tax_num_null_rs_descb) as tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,nvl(n.non_rec_rs, o.non_rec_rs) as non_rec_rs -- 不良记录原因
    ,nvl(n.blklist_cust_flg, o.blklist_cust_flg) as blklist_cust_flg -- 黑名单客户标志
    ,nvl(n.blklist_rgst_dt, o.blklist_rgst_dt) as blklist_rgst_dt -- 上黑名单日期
    ,nvl(n.blklist_rs, o.blklist_rs) as blklist_rs -- 上黑名单原因
    ,nvl(n.loan_card_no, o.loan_card_no) as loan_card_no -- 贷款卡号
    ,nvl(n.stock_cd, o.stock_cd) as stock_cd -- 股票代码
    ,nvl(n.citizen_treat_flg, o.citizen_treat_flg) as citizen_treat_flg -- 国民待遇标志
    ,nvl(n.fir_setup_crdt_rela_dt, o.fir_setup_crdt_rela_dt) as fir_setup_crdt_rela_dt -- 首次建立信贷关系日期
    ,nvl(n.mger_member_number, o.mger_member_number) as mger_member_number -- 管理人员人数
    ,nvl(n.digit_econ_indus_cd, o.digit_econ_indus_cd) as digit_econ_indus_cd -- 数字经济行业代码
    ,nvl(n.strtg_new_indus_type_cd, o.strtg_new_indus_type_cd) as strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,nvl(n.share_ratio, o.share_ratio) as share_ratio -- 持股比例
    ,nvl(n.super_orgnz_cd, o.super_orgnz_cd) as super_orgnz_cd -- 上级机构组织机构代码
    ,nvl(n.super_unify_soci_crdt_cd, o.super_unify_soci_crdt_cd) as super_unify_soci_crdt_cd -- 上级机构统一社会信用代码
    ,nvl(n.director_corp_rgst_curr_cd, o.director_corp_rgst_curr_cd) as director_corp_rgst_curr_cd -- 主管单位注册币种代码
    ,nvl(n.director_corp_rgst_amt, o.director_corp_rgst_amt) as director_corp_rgst_amt -- 主管单位注册金额
    ,nvl(n.shard_type_cd, o.shard_type_cd) as shard_type_cd -- 股东类型代码
    ,nvl(n.ctrler_type_cd, o.ctrler_type_cd) as ctrler_type_cd -- 控制人类型代码
    ,nvl(n.property_type_cd, o.property_type_cd) as property_type_cd -- 产业类型代码
    ,nvl(n.role_type_cd, o.role_type_cd) as role_type_cd -- 角色类型代码
    ,nvl(n.lp_org_name, o.lp_org_name) as lp_org_name -- 法人机构名称
    ,nvl(n.lp_org_type_cd, o.lp_org_type_cd) as lp_org_type_cd -- 法人机构类型代码
    ,nvl(n.lp_org_cust_id, o.lp_org_cust_id) as lp_org_cust_id -- 法人机构客户编号
    ,nvl(n.super_org_cust_id, o.super_org_cust_id) as super_org_cust_id -- 上级机构客户编号
    ,nvl(n.open_acct_chn_cd, o.open_acct_chn_cd) as open_acct_chn_cd -- 开户渠道代码
    ,nvl(n.cust_ownsp_type_cd, o.cust_ownsp_type_cd) as cust_ownsp_type_cd -- 客户所有制类型代码
    ,nvl(n.mang_site_dist_cd, o.mang_site_dist_cd) as mang_site_dist_cd -- 经营所在地行政区划代码
    ,case when
            n.party_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_corp_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
where (
        o.party_id is null
        and o.lp_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
    )
    or (
        o.depositr_cate_cd <> n.depositr_cate_cd
        or o.corp_name <> n.corp_name
        or o.corp_en_name <> n.corp_en_name
        or o.soci_crdt_cd <> n.soci_crdt_cd
        or o.curr_cd <> n.curr_cd
        or o.rgst_cap <> n.rgst_cap
        or o.rgst_addr <> n.rgst_addr
        or o.cty_rg_cd <> n.cty_rg_cd
        or o.indus_type_cd <> n.indus_type_cd
        or o.econ_char_cd <> n.econ_char_cd
        or o.taxpayer_idtfy_num <> n.taxpayer_idtfy_num
        or o.corp_type_cd <> n.corp_type_cd
        or o.tax_stament_flg <> n.tax_stament_flg
        or o.tax_org_cate_cd <> n.tax_org_cate_cd
        or o.tax_resdnt_cty_cd <> n.tax_resdnt_cty_cd
        or o.tax_resdnt_idti_cd <> n.tax_resdnt_idti_cd
        or o.emply_qtty <> n.emply_qtty
        or o.fin_subsidy_inco_src_cd <> n.fin_subsidy_inco_src_cd
        or o.strategy_camp_cust_no <> n.strategy_camp_cust_no
        or o.ins_adj_type_cd <> n.ins_adj_type_cd
        or o.single_lmt <> n.single_lmt
        or o.single_lp_flg <> n.single_lp_flg
        or o.high_new_tech_corp_flg <> n.high_new_tech_corp_flg
        or o.itau_flg <> n.itau_flg
        or o.rela_party_flg <> n.rela_party_flg
        or o.rela_group_type_cd <> n.rela_group_type_cd
        or o.org_type_cd <> n.org_type_cd
        or o.org_status_cd <> n.org_status_cd
        or o.group_cust_flg <> n.group_cust_flg
        or o.weight_risk_asset_cust_cls_cd <> n.weight_risk_asset_cust_cls_cd
        or o.cbrc_sb_flg <> n.cbrc_sb_flg
        or o.econ_type_cd <> n.econ_type_cd
        or o.oper_range <> n.oper_range
        or o.cust_sev_ugd_cls_cd <> n.cust_sev_ugd_cls_cd
        or o.hold_type_cd <> n.hold_type_cd
        or o.off_shore_cust_flg <> n.off_shore_cust_flg
        or o.subj_org_name <> n.subj_org_name
        or o.prit_etp_flg <> n.prit_etp_flg
        or o.ctysd_corp_flg <> n.ctysd_corp_flg
        or o.corp_found_dt <> n.corp_found_dt
        or o.corp_size_cd <> n.corp_size_cd
        or o.corp_size_cd_intnal <> n.corp_size_cd_intnal
        or o.ta_cust_size <> n.ta_cust_size
        or o.ta_cust_indus_status <> n.ta_cust_indus_status
        or o.list_corp_type_cd <> n.list_corp_type_cd
        or o.list_corp_flg <> n.list_corp_flg
        or o.crdt_strategy_cd <> n.crdt_strategy_cd
        or o.crdt_cust_flg <> n.crdt_cust_flg
        or o.bel_thi_flg <> n.bel_thi_flg
        or o.rgst_dt <> n.rgst_dt
        or o.orgnz_type_cd <> n.orgnz_type_cd
        or o.orgnz_type_subdv_cd <> n.orgnz_type_subdv_cd
        or o.econ_orgnz_form_cd <> n.econ_orgnz_form_cd
        or o.trast_tax_regi_cert_flg <> n.trast_tax_regi_cert_flg
        or o.fin_stat_type_cd <> n.fin_stat_type_cd
        or o.jnor_cog_over_number <> n.jnor_cog_over_number
        or o.cty_key_enterp_flg <> n.cty_key_enterp_flg
        or o.natnal_econ_dept_type_cd <> n.natnal_econ_dept_type_cd
        or o.indus_type_cd_level5_cls <> n.indus_type_cd_level5_cls
        or o.indus_type_cd_crdt_rating <> n.indus_type_cd_crdt_rating
        or o.org_subj <> n.org_subj
        or o.group_corp_flg <> n.group_corp_flg
        or o.group_cust_id <> n.group_cust_id
        or o.resdnt_flg <> n.resdnt_flg
        or o.open_cap <> n.open_cap
        or o.cust_lev_cd <> n.cust_lev_cd
        or o.retire_number <> n.retire_number
        or o.super_director_dept <> n.super_director_dept
        or o.cause_lp_size_or_lev_cd <> n.cause_lp_size_or_lev_cd
        or o.cause_lp_cust_type_cd <> n.cause_lp_cust_type_cd
        or o.bal_pay_way_cd <> n.bal_pay_way_cd
        or o.sys_in_cust_flg <> n.sys_in_cust_flg
        or o.lmt_or_encrge_indus_cd <> n.lmt_or_encrge_indus_cd
        or o.have_hxb_share_qtty <> n.have_hxb_share_qtty
        or o.have_bod_flg <> n.have_bod_flg
        or o.budget_form_cd <> n.budget_form_cd
        or o.green_crdt_cust_flg <> n.green_crdt_cust_flg
        or o.araf_flg <> n.araf_flg
        or o.corp_size_cd_cpes <> n.corp_size_cd_cpes
        or o.indus_type_cd_cpes <> n.indus_type_cd_cpes
        or o.orgnz_cd <> n.orgnz_cd
        or o.corp_party_type_cd <> n.corp_party_type_cd
        or o.rg_cd <> n.rg_cd
        or o.indus_type_cd_crdtc <> n.indus_type_cd_crdtc
        or o.indus_categy_cd_crdtc <> n.indus_categy_cd_crdtc
        or o.tax_num_null_rs_descb <> n.tax_num_null_rs_descb
        or o.non_rec_rs <> n.non_rec_rs
        or o.blklist_cust_flg <> n.blklist_cust_flg
        or o.blklist_rgst_dt <> n.blklist_rgst_dt
        or o.blklist_rs <> n.blklist_rs
        or o.loan_card_no <> n.loan_card_no
        or o.stock_cd <> n.stock_cd
        or o.citizen_treat_flg <> n.citizen_treat_flg
        or o.fir_setup_crdt_rela_dt <> n.fir_setup_crdt_rela_dt
        or o.mger_member_number <> n.mger_member_number
        or o.digit_econ_indus_cd <> n.digit_econ_indus_cd
        or o.strtg_new_indus_type_cd <> n.strtg_new_indus_type_cd
        or o.share_ratio <> n.share_ratio
        or o.super_orgnz_cd <> n.super_orgnz_cd
        or o.super_unify_soci_crdt_cd <> n.super_unify_soci_crdt_cd
        or o.director_corp_rgst_curr_cd <> n.director_corp_rgst_curr_cd
        or o.director_corp_rgst_amt <> n.director_corp_rgst_amt
        or o.shard_type_cd <> n.shard_type_cd
        or o.ctrler_type_cd <> n.ctrler_type_cd
        or o.property_type_cd <> n.property_type_cd
        or o.role_type_cd <> n.role_type_cd
        or o.lp_org_name <> n.lp_org_name
        or o.lp_org_type_cd <> n.lp_org_type_cd
        or o.lp_org_cust_id <> n.lp_org_cust_id
        or o.super_org_cust_id <> n.super_org_cust_id
        or o.open_acct_chn_cd <> n.open_acct_chn_cd
        or o.cust_ownsp_type_cd <> n.cust_ownsp_type_cd
        or o.mang_site_dist_cd <> n.mang_site_dist_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_corp_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,depositr_cate_cd -- 存款人类别代码
    ,corp_name -- 公司名称
    ,corp_en_name -- 公司英文名称
    ,soci_crdt_cd -- 统一社会信用代码
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
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,emply_qtty -- 企业员工人数
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
    ,ctysd_corp_flg -- 农村城市标志
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,corp_size_cd_intnal -- 企业规模代码_内部
    ,ta_cust_size -- 商圈客户规模
    ,ta_cust_indus_status -- 商圈客户行业地位
    ,list_corp_type_cd -- 上市类型代码
    ,list_corp_flg -- 上市企业标志
    ,crdt_strategy_cd -- 授信策略代码
    ,crdt_cust_flg -- 授信客户标志
    ,bel_thi_flg -- 属于两高行业标志
    ,rgst_dt -- 注册日期
    ,orgnz_type_cd -- 组织机构类型代码
    ,orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,econ_orgnz_form_cd -- 控股类型代码
    ,trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,fin_stat_type_cd -- 财务报表类型代码
    ,jnor_cog_over_number -- 大专以上人数
    ,cty_key_enterp_flg -- 国家重点企业标志
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,indus_type_cd_level5_cls -- 行业类型代码_五级分类
    ,indus_type_cd_crdt_rating -- 行业类型代码_信用评级
    ,org_subj -- 机构隶属
    ,group_corp_flg -- 集团公司标志
    ,group_cust_id -- 集团编号
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
    ,green_crdt_cust_flg -- 绿色信贷标志
    ,araf_flg -- 三农标志
    ,corp_size_cd_cpes -- 企业规模代码_票交所
    ,indus_type_cd_cpes -- 行业类型代码_票交所
    ,orgnz_cd -- 组织机构代码
    ,corp_party_type_cd -- 对公当事人类型代码
    ,rg_cd -- 注册行政区划代码
    ,indus_type_cd_crdtc -- 行业类型代码_征信
    ,indus_categy_cd_crdtc -- 行业门类代码_征信
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,non_rec_rs -- 不良记录原因
    ,blklist_cust_flg -- 黑名单客户标志
    ,blklist_rgst_dt -- 上黑名单日期
    ,blklist_rs -- 上黑名单原因
    ,loan_card_no -- 贷款卡号
    ,stock_cd -- 股票代码
    ,citizen_treat_flg -- 国民待遇标志
    ,fir_setup_crdt_rela_dt -- 首次建立信贷关系日期
    ,mger_member_number -- 管理人员人数
    ,digit_econ_indus_cd -- 数字经济行业代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,share_ratio -- 持股比例
    ,super_orgnz_cd -- 上级机构组织机构代码
    ,super_unify_soci_crdt_cd -- 上级机构统一社会信用代码
    ,director_corp_rgst_curr_cd -- 主管单位注册币种代码
    ,director_corp_rgst_amt -- 主管单位注册金额
    ,shard_type_cd -- 股东类型代码
    ,ctrler_type_cd -- 控制人类型代码
    ,property_type_cd -- 产业类型代码
    ,role_type_cd -- 角色类型代码
    ,lp_org_name -- 法人机构名称
    ,lp_org_type_cd -- 法人机构类型代码
    ,lp_org_cust_id -- 法人机构客户编号
    ,super_org_cust_id -- 上级机构客户编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,cust_ownsp_type_cd -- 客户所有制类型代码
    ,mang_site_dist_cd -- 经营所在地行政区划代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_corp_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,depositr_cate_cd -- 存款人类别代码
    ,corp_name -- 公司名称
    ,corp_en_name -- 公司英文名称
    ,soci_crdt_cd -- 统一社会信用代码
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
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_cd -- 税收居民身份代码
    ,emply_qtty -- 企业员工人数
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
    ,ctysd_corp_flg -- 农村城市标志
    ,corp_found_dt -- 企业成立日期
    ,corp_size_cd -- 企业规模代码
    ,corp_size_cd_intnal -- 企业规模代码_内部
    ,ta_cust_size -- 商圈客户规模
    ,ta_cust_indus_status -- 商圈客户行业地位
    ,list_corp_type_cd -- 上市类型代码
    ,list_corp_flg -- 上市企业标志
    ,crdt_strategy_cd -- 授信策略代码
    ,crdt_cust_flg -- 授信客户标志
    ,bel_thi_flg -- 属于两高行业标志
    ,rgst_dt -- 注册日期
    ,orgnz_type_cd -- 组织机构类型代码
    ,orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,econ_orgnz_form_cd -- 控股类型代码
    ,trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,fin_stat_type_cd -- 财务报表类型代码
    ,jnor_cog_over_number -- 大专以上人数
    ,cty_key_enterp_flg -- 国家重点企业标志
    ,natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,indus_type_cd_level5_cls -- 行业类型代码_五级分类
    ,indus_type_cd_crdt_rating -- 行业类型代码_信用评级
    ,org_subj -- 机构隶属
    ,group_corp_flg -- 集团公司标志
    ,group_cust_id -- 集团编号
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
    ,green_crdt_cust_flg -- 绿色信贷标志
    ,araf_flg -- 三农标志
    ,corp_size_cd_cpes -- 企业规模代码_票交所
    ,indus_type_cd_cpes -- 行业类型代码_票交所
    ,orgnz_cd -- 组织机构代码
    ,corp_party_type_cd -- 对公当事人类型代码
    ,rg_cd -- 注册行政区划代码
    ,indus_type_cd_crdtc -- 行业类型代码_征信
    ,indus_categy_cd_crdtc -- 行业门类代码_征信
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,non_rec_rs -- 不良记录原因
    ,blklist_cust_flg -- 黑名单客户标志
    ,blklist_rgst_dt -- 上黑名单日期
    ,blklist_rs -- 上黑名单原因
    ,loan_card_no -- 贷款卡号
    ,stock_cd -- 股票代码
    ,citizen_treat_flg -- 国民待遇标志
    ,fir_setup_crdt_rela_dt -- 首次建立信贷关系日期
    ,mger_member_number -- 管理人员人数
    ,digit_econ_indus_cd -- 数字经济行业代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,share_ratio -- 持股比例
    ,super_orgnz_cd -- 上级机构组织机构代码
    ,super_unify_soci_crdt_cd -- 上级机构统一社会信用代码
    ,director_corp_rgst_curr_cd -- 主管单位注册币种代码
    ,director_corp_rgst_amt -- 主管单位注册金额
    ,shard_type_cd -- 股东类型代码
    ,ctrler_type_cd -- 控制人类型代码
    ,property_type_cd -- 产业类型代码
    ,role_type_cd -- 角色类型代码
    ,lp_org_name -- 法人机构名称
    ,lp_org_type_cd -- 法人机构类型代码
    ,lp_org_cust_id -- 法人机构客户编号
    ,super_org_cust_id -- 上级机构客户编号
    ,open_acct_chn_cd -- 开户渠道代码
    ,cust_ownsp_type_cd -- 客户所有制类型代码
    ,mang_site_dist_cd -- 经营所在地行政区划代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.depositr_cate_cd -- 存款人类别代码
    ,o.corp_name -- 公司名称
    ,o.corp_en_name -- 公司英文名称
    ,o.soci_crdt_cd -- 统一社会信用代码
    ,o.curr_cd -- 币种代码
    ,o.rgst_cap -- 注册资金
    ,o.rgst_addr -- 注册地址
    ,o.cty_rg_cd -- 国家和地区代码
    ,o.indus_type_cd -- 行业类型代码
    ,o.econ_char_cd -- 经济性质代码
    ,o.taxpayer_idtfy_num -- 纳税人识别号
    ,o.corp_type_cd -- 企业类型代码
    ,o.tax_stament_flg -- 取得税收居民取得自证声明标志
    ,o.tax_org_cate_cd -- 税收机构类别代码
    ,o.tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,o.tax_resdnt_idti_cd -- 税收居民身份代码
    ,o.emply_qtty -- 企业员工人数
    ,o.fin_subsidy_inco_src_cd -- 财政补助收入来源代码
    ,o.strategy_camp_cust_no -- 策略营销客户号
    ,o.ins_adj_type_cd -- 产业结构调整类型代码
    ,o.single_lmt -- 单一限额
    ,o.single_lp_flg -- 独立法人标志
    ,o.high_new_tech_corp_flg -- 高新技术企业标志
    ,o.itau_flg -- 工业转型升级标志
    ,o.rela_party_flg -- 关联方标志
    ,o.rela_group_type_cd -- 关联集团类型代码
    ,o.org_type_cd -- 机构类型代码
    ,o.org_status_cd -- 机构状态代码
    ,o.group_cust_flg -- 集团客户标志
    ,o.weight_risk_asset_cust_cls_cd -- 加权风险资产客户分类代码
    ,o.cbrc_sb_flg -- 银监小企业标志
    ,o.econ_type_cd -- 经济类型代码
    ,o.oper_range -- 经营范围
    ,o.cust_sev_ugd_cls_cd -- 客户服务升级分类代码
    ,o.hold_type_cd -- 控股类型代码
    ,o.off_shore_cust_flg -- 离岸客户标志
    ,o.subj_org_name -- 隶属机构名称
    ,o.prit_etp_flg -- 民营企业标志
    ,o.ctysd_corp_flg -- 农村城市标志
    ,o.corp_found_dt -- 企业成立日期
    ,o.corp_size_cd -- 企业规模代码
    ,o.corp_size_cd_intnal -- 企业规模代码_内部
    ,o.ta_cust_size -- 商圈客户规模
    ,o.ta_cust_indus_status -- 商圈客户行业地位
    ,o.list_corp_type_cd -- 上市类型代码
    ,o.list_corp_flg -- 上市企业标志
    ,o.crdt_strategy_cd -- 授信策略代码
    ,o.crdt_cust_flg -- 授信客户标志
    ,o.bel_thi_flg -- 属于两高行业标志
    ,o.rgst_dt -- 注册日期
    ,o.orgnz_type_cd -- 组织机构类型代码
    ,o.orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,o.econ_orgnz_form_cd -- 控股类型代码
    ,o.trast_tax_regi_cert_flg -- 办理税务登记证标志
    ,o.fin_stat_type_cd -- 财务报表类型代码
    ,o.jnor_cog_over_number -- 大专以上人数
    ,o.cty_key_enterp_flg -- 国家重点企业标志
    ,o.natnal_econ_dept_type_cd -- 国民经济部门类型代码
    ,o.indus_type_cd_level5_cls -- 行业类型代码_五级分类
    ,o.indus_type_cd_crdt_rating -- 行业类型代码_信用评级
    ,o.org_subj -- 机构隶属
    ,o.group_corp_flg -- 集团公司标志
    ,o.group_cust_id -- 集团编号
    ,o.resdnt_flg -- 居民标志
    ,o.open_cap -- 开办资金
    ,o.cust_lev_cd -- 客户级别代码
    ,o.retire_number -- 离退休人数
    ,o.super_director_dept -- 上级主管部门
    ,o.cause_lp_size_or_lev_cd -- 事业法人规模或级别代码
    ,o.cause_lp_cust_type_cd -- 事业法人客户类型代码
    ,o.bal_pay_way_cd -- 收支方式代码
    ,o.sys_in_cust_flg -- 系统内客户标志
    ,o.lmt_or_encrge_indus_cd -- 限制或鼓励行业代码
    ,o.have_hxb_share_qtty -- 拥有我行股份数量
    ,o.have_bod_flg -- 有董事会标志
    ,o.budget_form_cd -- 预算形式代码
    ,o.green_crdt_cust_flg -- 绿色信贷标志
    ,o.araf_flg -- 三农标志
    ,o.corp_size_cd_cpes -- 企业规模代码_票交所
    ,o.indus_type_cd_cpes -- 行业类型代码_票交所
    ,o.orgnz_cd -- 组织机构代码
    ,o.corp_party_type_cd -- 对公当事人类型代码
    ,o.rg_cd -- 注册行政区划代码
    ,o.indus_type_cd_crdtc -- 行业类型代码_征信
    ,o.indus_categy_cd_crdtc -- 行业门类代码_征信
    ,o.tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,o.non_rec_rs -- 不良记录原因
    ,o.blklist_cust_flg -- 黑名单客户标志
    ,o.blklist_rgst_dt -- 上黑名单日期
    ,o.blklist_rs -- 上黑名单原因
    ,o.loan_card_no -- 贷款卡号
    ,o.stock_cd -- 股票代码
    ,o.citizen_treat_flg -- 国民待遇标志
    ,o.fir_setup_crdt_rela_dt -- 首次建立信贷关系日期
    ,o.mger_member_number -- 管理人员人数
    ,o.digit_econ_indus_cd -- 数字经济行业代码
    ,o.strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,o.share_ratio -- 持股比例
    ,o.super_orgnz_cd -- 上级机构组织机构代码
    ,o.super_unify_soci_crdt_cd -- 上级机构统一社会信用代码
    ,o.director_corp_rgst_curr_cd -- 主管单位注册币种代码
    ,o.director_corp_rgst_amt -- 主管单位注册金额
    ,o.shard_type_cd -- 股东类型代码
    ,o.ctrler_type_cd -- 控制人类型代码
    ,o.property_type_cd -- 产业类型代码
    ,o.role_type_cd -- 角色类型代码
    ,o.lp_org_name -- 法人机构名称
    ,o.lp_org_type_cd -- 法人机构类型代码
    ,o.lp_org_cust_id -- 法人机构客户编号
    ,o.super_org_cust_id -- 上级机构客户编号
    ,o.open_acct_chn_cd -- 开户渠道代码
    ,o.cust_ownsp_type_cd -- 客户所有制类型代码
    ,o.mang_site_dist_cd -- 经营所在地行政区划代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_eifsf1_bk o
    left join ${iml_schema}.pty_corp_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_corp_eifsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_corp;
--alter table ${iml_schema}.pty_corp truncate partition for ('eifsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_corp') 
               and substr(subpartition_name,1,8)=upper('p_eifsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_corp drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_corp modify partition p_eifsf1 
add subpartition p_eifsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_corp exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_corp_eifsf1_cl;
alter table ${iml_schema}.pty_corp exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_corp_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_corp to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_corp_eifsf1_tm purge;
drop table ${iml_schema}.pty_corp_eifsf1_op purge;
drop table ${iml_schema}.pty_corp_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_corp_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_corp', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
