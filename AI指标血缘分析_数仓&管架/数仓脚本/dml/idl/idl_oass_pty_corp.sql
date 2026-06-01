/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_corp
CreateDate: 20251225
FileType:   DML
Logs:
						许晓文	修改【DIRECTOR_CORP_RGST_AMT 主管单位注册金额】字段类型 varchar2(90) > number(30,2)	20260109版本
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_pty_corp drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_corp add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_corp (
etl_dt  --数据日期
,depositr_cate_cd  --存款人类别代码
,corp_name  --公司名称
,corp_en_name  --公司英文名称
,soci_crdt_cd  --统一社会信用代码
,curr_cd  --币种代码
,rgst_cap  --注册资金
,rgst_addr  --注册地址
,cty_rg_cd  --国家和地区代码
,indus_type_cd  --行业类型代码
,econ_char_cd  --经济性质代码
,taxpayer_idtfy_num  --纳税人识别号
,corp_type_cd  --企业类型代码
,tax_stament_flg  --取得税收居民取得自证声明标志
,tax_org_cate_cd  --税收机构类别代码
,tax_resdnt_cty_cd  --税收居民国家代码组合
,tax_resdnt_idti_cd  --税收居民身份代码
,emply_qtty  --企业员工人数
,fin_subsidy_inco_src_cd  --财政补助收入来源代码
,strategy_camp_cust_no  --策略营销客户号
,ins_adj_type_cd  --产业结构调整类型代码
,single_lmt  --单一限额
,single_lp_flg  --独立法人标志
,high_new_tech_corp_flg  --高新技术企业标志
,itau_flg  --工业转型升级标志
,rela_party_flg  --关联方标志
,rela_group_type_cd  --关联集团类型代码
,org_type_cd  --机构类型代码
,org_status_cd  --机构状态代码
,group_cust_flg  --集团客户标志
,weight_risk_asset_cust_cls_cd  --加权风险资产客户分类代码
,cbrc_sb_flg  --银监小企业标志
,econ_type_cd  --登记注册类型代码
,oper_range  --经营范围
,cust_sev_ugd_cls_cd  --客户服务升级分类代码
,hold_type_cd  --控股类型代码
,off_shore_cust_flg  --离岸客户标志
,subj_org_name  --隶属机构名称
,prit_etp_flg  --民营企业标志
,ctysd_corp_flg  --农村城市标志
,corp_found_dt  --企业成立日期
,corp_size_cd  --企业规模代码
,corp_size_cd_intnal  --企业规模代码_内部
,ta_cust_size  --商圈客户规模
,ta_cust_indus_status  --商圈客户行业地位
,list_corp_type_cd  --上市类型代码
,list_corp_flg  --上市企业标志
,crdt_strategy_cd  --授信策略代码
,crdt_cust_flg  --授信客户标志
,bel_thi_flg  --属于两高行业标志
,rgst_dt  --注册日期
,orgnz_type_cd  --组织机构类型代码
,orgnz_type_subdv_cd  --组织机构类型细分代码
,econ_orgnz_form_cd  --控股类型代码
,trast_tax_regi_cert_flg  --办理税务登记证标志
,fin_stat_type_cd  --财务报表类型代码
,jnor_cog_over_number  --大专以上人数
,cty_key_enterp_flg  --国家重点企业标志
,natnal_econ_dept_type_cd  --国民经济部门类型代码
,indus_type_cd_level5_cls  --行业类型代码_五级分类
,indus_type_cd_crdt_rating  --行业类型代码_信用评级
,org_subj  --机构隶属
,group_corp_flg  --集团公司标志
,group_cust_id  --集团编号
,resdnt_flg  --居民标志
,open_cap  --开办资金
,cust_lev_cd  --客户级别代码
,retire_number  --离退休人数
,super_director_dept  --上级主管部门
,cause_lp_size_or_lev_cd  --事业法人规模或级别代码
,cause_lp_cust_type_cd  --事业法人客户类型代码
,bal_pay_way_cd  --收支方式代码
,sys_in_cust_flg  --系统内客户标志
,lmt_or_encrge_indus_cd  --限制或鼓励行业代码
,have_hxb_share_qtty  --拥有我行股份数量
,have_bod_flg  --有董事会标志
,budget_form_cd  --预算形式代码
,green_crdt_cust_flg  --绿色信贷标志
,araf_flg  --三农标志
,corp_size_cd_cpes  --企业规模代码_票交所
,indus_type_cd_cpes  --行业类型代码_票交所
,orgnz_cd  --组织机构代码
,corp_party_type_cd  --对公当事人类型代码
,rg_cd  --注册行政区划代码
,indus_type_cd_crdtc  --行业类型代码_征信
,indus_categy_cd_crdtc  --行业门类代码_征信
,tax_num_null_rs_descb  --纳税人识别号空值原因描述
,non_rec_rs  --不良记录原因
,blklist_cust_flg  --黑名单客户标志
,blklist_rgst_dt  --上黑名单日期
,blklist_rs  --上黑名单原因
,loan_card_no  --贷款卡号
,stock_cd  --股票代码
,citizen_treat_flg  --国民待遇标志
,fir_setup_crdt_rela_dt  --首次建立信贷关系日期
,mger_member_number  --管理人员人数
,digit_econ_indus_cd  --数字经济行业代码
,strtg_new_indus_type_cd  --战略新兴产业类型代码
,share_ratio  --持股比例
,super_orgnz_cd  --上级机构组织机构代码
,super_unify_soci_crdt_cd  --上级机构统一社会信用代码
,director_corp_rgst_curr_cd  --主管单位注册币种代码
,director_corp_rgst_amt  --主管单位注册金额
,shard_type_cd  --股东类型代码
,ctrler_type_cd  --控制人类型代码
,property_type_cd  --产业类型代码
,role_type_cd  --角色类型代码
,lp_org_name  --法人机构名称
,lp_org_type_cd  --法人机构类型代码
,lp_org_cust_id  --法人机构客户编号
,super_org_cust_id  --上级机构客户编号
,open_acct_chn_cd  --开户渠道代码
,cust_ownsp_type_cd  --客户所有制类型代码
,mang_site_dist_cd  --经营所在地行政区划代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,party_id  --当事人编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.depositr_cate_cd,chr(13),''),chr(10),'') as depositr_cate_cd --存款人类别代码
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name --公司名称
,replace(replace(t1.corp_en_name,chr(13),''),chr(10),'') as corp_en_name --公司英文名称
,replace(replace(t1.soci_crdt_cd,chr(13),''),chr(10),'') as soci_crdt_cd --统一社会信用代码
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.rgst_cap as rgst_cap --注册资金
,replace(replace(t1.rgst_addr,chr(13),''),chr(10),'') as rgst_addr --注册地址
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd --国家和地区代码
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd --行业类型代码
,replace(replace(t1.econ_char_cd,chr(13),''),chr(10),'') as econ_char_cd --经济性质代码
,replace(replace(t1.taxpayer_idtfy_num,chr(13),''),chr(10),'') as taxpayer_idtfy_num --纳税人识别号
,replace(replace(t1.corp_type_cd,chr(13),''),chr(10),'') as corp_type_cd --企业类型代码
,replace(replace(t1.tax_stament_flg,chr(13),''),chr(10),'') as tax_stament_flg --取得税收居民取得自证声明标志
,replace(replace(t1.tax_org_cate_cd,chr(13),''),chr(10),'') as tax_org_cate_cd --税收机构类别代码
,replace(replace(t1.tax_resdnt_cty_cd,chr(13),''),chr(10),'') as tax_resdnt_cty_cd --税收居民国家代码组合
,replace(replace(t1.tax_resdnt_idti_cd,chr(13),''),chr(10),'') as tax_resdnt_idti_cd --税收居民身份代码
,t1.emply_qtty as emply_qtty --企业员工人数
,replace(replace(t1.fin_subsidy_inco_src_cd,chr(13),''),chr(10),'') as fin_subsidy_inco_src_cd --财政补助收入来源代码
,replace(replace(t1.strategy_camp_cust_no,chr(13),''),chr(10),'') as strategy_camp_cust_no --策略营销客户号
,replace(replace(t1.ins_adj_type_cd,chr(13),''),chr(10),'') as ins_adj_type_cd --产业结构调整类型代码
,t1.single_lmt as single_lmt --单一限额
,replace(replace(t1.single_lp_flg,chr(13),''),chr(10),'') as single_lp_flg --独立法人标志
,replace(replace(t1.high_new_tech_corp_flg,chr(13),''),chr(10),'') as high_new_tech_corp_flg --高新技术企业标志
,replace(replace(t1.itau_flg,chr(13),''),chr(10),'') as itau_flg --工业转型升级标志
,replace(replace(t1.rela_party_flg,chr(13),''),chr(10),'') as rela_party_flg --关联方标志
,replace(replace(t1.rela_group_type_cd,chr(13),''),chr(10),'') as rela_group_type_cd --关联集团类型代码
,replace(replace(t1.org_type_cd,chr(13),''),chr(10),'') as org_type_cd --机构类型代码
,replace(replace(t1.org_status_cd,chr(13),''),chr(10),'') as org_status_cd --机构状态代码
,replace(replace(t1.group_cust_flg,chr(13),''),chr(10),'') as group_cust_flg --集团客户标志
,replace(replace(t1.weight_risk_asset_cust_cls_cd,chr(13),''),chr(10),'') as weight_risk_asset_cust_cls_cd --加权风险资产客户分类代码
,replace(replace(t1.cbrc_sb_flg,chr(13),''),chr(10),'') as cbrc_sb_flg --银监小企业标志
,replace(replace(t1.econ_type_cd,chr(13),''),chr(10),'') as econ_type_cd --登记注册类型代码
,replace(replace(t1.oper_range,chr(13),''),chr(10),'') as oper_range --经营范围
,replace(replace(t1.cust_sev_ugd_cls_cd,chr(13),''),chr(10),'') as cust_sev_ugd_cls_cd --客户服务升级分类代码
,replace(replace(t1.hold_type_cd,chr(13),''),chr(10),'') as hold_type_cd --控股类型代码
,replace(replace(t1.off_shore_cust_flg,chr(13),''),chr(10),'') as off_shore_cust_flg --离岸客户标志
,replace(replace(t1.subj_org_name,chr(13),''),chr(10),'') as subj_org_name --隶属机构名称
,replace(replace(t1.prit_etp_flg,chr(13),''),chr(10),'') as prit_etp_flg --民营企业标志
,replace(replace(t1.ctysd_corp_flg,chr(13),''),chr(10),'') as ctysd_corp_flg --农村城市标志
,t1.corp_found_dt as corp_found_dt --企业成立日期
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd --企业规模代码
,replace(replace(t1.corp_size_cd_intnal,chr(13),''),chr(10),'') as corp_size_cd_intnal --企业规模代码_内部
,replace(replace(t1.ta_cust_size,chr(13),''),chr(10),'') as ta_cust_size --商圈客户规模
,replace(replace(t1.ta_cust_indus_status,chr(13),''),chr(10),'') as ta_cust_indus_status --商圈客户行业地位
,replace(replace(t1.list_corp_type_cd,chr(13),''),chr(10),'') as list_corp_type_cd --上市类型代码
,replace(replace(t1.list_corp_flg,chr(13),''),chr(10),'') as list_corp_flg --上市企业标志
,replace(replace(t1.crdt_strategy_cd,chr(13),''),chr(10),'') as crdt_strategy_cd --授信策略代码
,replace(replace(t1.crdt_cust_flg,chr(13),''),chr(10),'') as crdt_cust_flg --授信客户标志
,replace(replace(t1.bel_thi_flg,chr(13),''),chr(10),'') as bel_thi_flg --属于两高行业标志
,t1.rgst_dt as rgst_dt --注册日期
,replace(replace(t1.orgnz_type_cd,chr(13),''),chr(10),'') as orgnz_type_cd --组织机构类型代码
,replace(replace(t1.orgnz_type_subdv_cd,chr(13),''),chr(10),'') as orgnz_type_subdv_cd --组织机构类型细分代码
,replace(replace(t1.econ_orgnz_form_cd,chr(13),''),chr(10),'') as econ_orgnz_form_cd --控股类型代码
,replace(replace(t1.trast_tax_regi_cert_flg,chr(13),''),chr(10),'') as trast_tax_regi_cert_flg --办理税务登记证标志
,replace(replace(t1.fin_stat_type_cd,chr(13),''),chr(10),'') as fin_stat_type_cd --财务报表类型代码
,t1.jnor_cog_over_number as jnor_cog_over_number --大专以上人数
,replace(replace(t1.cty_key_enterp_flg,chr(13),''),chr(10),'') as cty_key_enterp_flg --国家重点企业标志
,replace(replace(t1.natnal_econ_dept_type_cd,chr(13),''),chr(10),'') as natnal_econ_dept_type_cd --国民经济部门类型代码
,replace(replace(t1.indus_type_cd_level5_cls,chr(13),''),chr(10),'') as indus_type_cd_level5_cls --行业类型代码_五级分类
,replace(replace(t1.indus_type_cd_crdt_rating,chr(13),''),chr(10),'') as indus_type_cd_crdt_rating --行业类型代码_信用评级
,replace(replace(t1.org_subj,chr(13),''),chr(10),'') as org_subj --机构隶属
,replace(replace(t1.group_corp_flg,chr(13),''),chr(10),'') as group_corp_flg --集团公司标志
,replace(replace(t1.group_cust_id,chr(13),''),chr(10),'') as group_cust_id --集团编号
,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg --居民标志
,t1.open_cap as open_cap --开办资金
,replace(replace(t1.cust_lev_cd,chr(13),''),chr(10),'') as cust_lev_cd --客户级别代码
,t1.retire_number as retire_number --离退休人数
,replace(replace(t1.super_director_dept,chr(13),''),chr(10),'') as super_director_dept --上级主管部门
,replace(replace(t1.cause_lp_size_or_lev_cd,chr(13),''),chr(10),'') as cause_lp_size_or_lev_cd --事业法人规模或级别代码
,replace(replace(t1.cause_lp_cust_type_cd,chr(13),''),chr(10),'') as cause_lp_cust_type_cd --事业法人客户类型代码
,replace(replace(t1.bal_pay_way_cd,chr(13),''),chr(10),'') as bal_pay_way_cd --收支方式代码
,replace(replace(t1.sys_in_cust_flg,chr(13),''),chr(10),'') as sys_in_cust_flg --系统内客户标志
,replace(replace(t1.lmt_or_encrge_indus_cd,chr(13),''),chr(10),'') as lmt_or_encrge_indus_cd --限制或鼓励行业代码
,t1.have_hxb_share_qtty as have_hxb_share_qtty --拥有我行股份数量
,replace(replace(t1.have_bod_flg,chr(13),''),chr(10),'') as have_bod_flg --有董事会标志
,replace(replace(t1.budget_form_cd,chr(13),''),chr(10),'') as budget_form_cd --预算形式代码
,replace(replace(t1.green_crdt_cust_flg,chr(13),''),chr(10),'') as green_crdt_cust_flg --绿色信贷标志
,replace(replace(t1.araf_flg,chr(13),''),chr(10),'') as araf_flg --三农标志
,replace(replace(t1.corp_size_cd_cpes,chr(13),''),chr(10),'') as corp_size_cd_cpes --企业规模代码_票交所
,replace(replace(t1.indus_type_cd_cpes,chr(13),''),chr(10),'') as indus_type_cd_cpes --行业类型代码_票交所
,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd --组织机构代码
,replace(replace(t1.corp_party_type_cd,chr(13),''),chr(10),'') as corp_party_type_cd --对公当事人类型代码
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd --注册行政区划代码
,replace(replace(t1.indus_type_cd_crdtc,chr(13),''),chr(10),'') as indus_type_cd_crdtc --行业类型代码_征信
,replace(replace(t1.indus_categy_cd_crdtc,chr(13),''),chr(10),'') as indus_categy_cd_crdtc --行业门类代码_征信
,replace(replace(t1.tax_num_null_rs_descb,chr(13),''),chr(10),'') as tax_num_null_rs_descb --纳税人识别号空值原因描述
,replace(replace(t1.non_rec_rs,chr(13),''),chr(10),'') as non_rec_rs --不良记录原因
,replace(replace(t1.blklist_cust_flg,chr(13),''),chr(10),'') as blklist_cust_flg --黑名单客户标志
,t1.blklist_rgst_dt as blklist_rgst_dt --上黑名单日期
,replace(replace(t1.blklist_rs,chr(13),''),chr(10),'') as blklist_rs --上黑名单原因
,replace(replace(t1.loan_card_no,chr(13),''),chr(10),'') as loan_card_no --贷款卡号
,replace(replace(t1.stock_cd,chr(13),''),chr(10),'') as stock_cd --股票代码
,replace(replace(t1.citizen_treat_flg,chr(13),''),chr(10),'') as citizen_treat_flg --国民待遇标志
,t1.fir_setup_crdt_rela_dt as fir_setup_crdt_rela_dt --首次建立信贷关系日期
,t1.mger_member_number as mger_member_number --管理人员人数
,replace(replace(t1.digit_econ_indus_cd,chr(13),''),chr(10),'') as digit_econ_indus_cd --数字经济行业代码
,replace(replace(t1.strtg_new_indus_type_cd,chr(13),''),chr(10),'') as strtg_new_indus_type_cd --战略新兴产业类型代码
,t1.share_ratio as share_ratio --持股比例
,replace(replace(t1.super_orgnz_cd,chr(13),''),chr(10),'') as super_orgnz_cd --上级机构组织机构代码
,replace(replace(t1.super_unify_soci_crdt_cd,chr(13),''),chr(10),'') as super_unify_soci_crdt_cd --上级机构统一社会信用代码
,replace(replace(t1.director_corp_rgst_curr_cd,chr(13),''),chr(10),'') as director_corp_rgst_curr_cd --主管单位注册币种代码
,t1.director_corp_rgst_amt as director_corp_rgst_amt --主管单位注册金额
,replace(replace(t1.shard_type_cd,chr(13),''),chr(10),'') as shard_type_cd --股东类型代码
,replace(replace(t1.ctrler_type_cd,chr(13),''),chr(10),'') as ctrler_type_cd --控制人类型代码
,replace(replace(t1.property_type_cd,chr(13),''),chr(10),'') as property_type_cd --产业类型代码
,replace(replace(t1.role_type_cd,chr(13),''),chr(10),'') as role_type_cd --角色类型代码
,replace(replace(t1.lp_org_name,chr(13),''),chr(10),'') as lp_org_name --法人机构名称
,replace(replace(t1.lp_org_type_cd,chr(13),''),chr(10),'') as lp_org_type_cd --法人机构类型代码
,replace(replace(t1.lp_org_cust_id,chr(13),''),chr(10),'') as lp_org_cust_id --法人机构客户编号
,replace(replace(t1.super_org_cust_id,chr(13),''),chr(10),'') as super_org_cust_id --上级机构客户编号
,replace(replace(t1.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd --开户渠道代码
,replace(replace(t1.cust_ownsp_type_cd,chr(13),''),chr(10),'') as cust_ownsp_type_cd --客户所有制类型代码
,replace(replace(t1.mang_site_dist_cd,chr(13),''),chr(10),'') as mang_site_dist_cd --经营所在地行政区划代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_corp t1    --公司当事人
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_corp',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
