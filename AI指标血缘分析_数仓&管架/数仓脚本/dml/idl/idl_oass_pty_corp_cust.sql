/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_corp_cust
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_pty_corp_cust drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_corp_cust add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_corp_cust (
etl_dt  --ETL处理日期
,sorc_sys_cd  --源系统代码
,corp_cust_type_cd  --公司客户类型代码
,orgnz_cd  --组织机构代码
,corp_name  --公司名称
,org_type_cd  --机构类型代码
,indus_type_cd  --行业类型代码
,econ_type_cd  --经济类型代码
,econ_orgnz_form_cd  --经济组织形式代码
,oper_range  --经营范围
,corp_size_cd  --企业规模代码
,corp_found_dt  --企业成立日期
,emply_qtty  --企业员工人数
,high_new_tech_corp_flg  --高新技术企业标志
,list_corp_flg  --上市企业标志
,is_mx_mgmt_righ_flg  --有无进出口经营权标志
,rela_group_type_cd  --关联集团类型代码
,group_cust_flg  --集团客户标志
,escp_debt_corp_flg  --逃废债企业标志
,strtg_cust_flg  --战略客户标志
,off_shore_cust_flg  --离岸客户标志
,cust_sev_ugd_cls_cd  --客户服务升级分类代码
,weight_risk_asset_cust_cls_cd  --加权风险资产客户分类代码
,crdt_strategy_cd  --授信策略代码
,nb_corp_flg  --新建企业标志
,hxb_rela_tran_flg  --我行关联交易标志
,mc_dept_mplize_cust_flg  --中小企业事业部专营客户标志
,hxb_idtfy_small_bus_flg  --我行认定小企业标志
,bel_thi_flg  --属于两高行业标志
,prit_etp_flg  --民营企业标志
,cbrc_sb_flg  --银监小企业标志
,hold_type_cd  --控股类型代码
,fin_subsidy_inco_src_cd  --财政补助收入来源代码
,rela_party_flg  --关联方标志
,rgst_dt  --注册日期
,crdt_cust_flg  --授信客户标志
,hxb_shard_flg  --我行股东标志
,subj_org_name  --隶属机构名称
,cty_rg_cd  --国家和地区代码
,ctysd_corp_flg  --农村城市标志
,ta_cust_size  --商圈客户规模
,ta_cust_indus_status  --商圈客户行业地位
,ins_adj_type_cd  --产业结构调整类型代码
,itau_flg  --工业转型升级标志
,strtg_new_indus_type_cd  --战略新兴产业类型代码
,list_corp_type_cd  --上市公司类型代码
,is_mx_oper_item_flg  --有无进出口经营项标志
,orgnz_type_subdv_cd  --组织机构类型细分代码
,org_status_cd  --机构状态代码
,orgnz_type_cd  --组织机构类型代码
,soci_crdt_cd  --社会信用代码
,strategy_camp_cust_no  --策略营销客户号
,single_lmt  --单一限额
,corp_size_cd_intnal  --企业规模代码_内部
,green_crdt_cust_flg  --绿色信贷客户标志
,single_lp_flg  --独立法人标志
,cust_ownsp_type_cd  --客户所有制类型代码
,belong_rela_group_id  --所属关联集团编号
,araf_flg  --三农标志
,prtcptr_cate_cd  --参与者类别代码
,rgst_cap  --注册资金
,bank_no  --银行行号
,bank_lev_cd  --银行级别代码
,ibank_no  --银行联行号
,cpes_corp_size_cd  --票交所企业规模代码
,cpes_indus_type_cd  --票交所行业类型代码
,edu_hea_flg  --文教健康标志
,inc_flg  --普惠型标志
,labor_inte_corp_flg  --劳动密集型企业标志
,corp_grow_stage_cd  --企业成长阶段代码
,shard_stru_cors_dt  --股东结构对应日期
,nation_tax_tax_regi_cert_num  --国税税务登记证号
,local_tax_tax_regi_cert_num  --地税税务登记证号
,fin_dept_phone  --财务部联系电话
,oper_field_area  --经营场地面积
,oper_field_prop_cd  --经营场地所有权代码
,fin_inst_lics  --金融机构许可证
,rgst_land_dist_cd  --登记地行政区划代码
,fir_lon_dt  --首贷日期
,crdtc_subm_corp_idti_idf_type_cd  --征信报送企业身份标识类型代码
,actl_ctrler_cnt  --实际控制人数
,major_contrior_cnt  --主要出资人数
,green_crdt_subclass_cd  --绿色贷款用途代码
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,cust_id  --客户编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd --源系统代码
,replace(replace(t1.corp_cust_type_cd,chr(13),''),chr(10),'') as corp_cust_type_cd --公司客户类型代码
,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd --组织机构代码
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name --公司名称
,replace(replace(t1.org_type_cd,chr(13),''),chr(10),'') as org_type_cd --机构类型代码
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd --行业类型代码
,replace(replace(t1.econ_type_cd,chr(13),''),chr(10),'') as econ_type_cd --经济类型代码
,replace(replace(t1.econ_orgnz_form_cd,chr(13),''),chr(10),'') as econ_orgnz_form_cd --经济组织形式代码
,replace(replace(t1.oper_range,chr(13),''),chr(10),'') as oper_range --经营范围
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd --企业规模代码
,t1.corp_found_dt as corp_found_dt --企业成立日期
,t1.emply_qtty as emply_qtty --企业员工人数
,replace(replace(t1.high_new_tech_corp_flg,chr(13),''),chr(10),'') as high_new_tech_corp_flg --高新技术企业标志
,replace(replace(t1.list_corp_flg,chr(13),''),chr(10),'') as list_corp_flg --上市企业标志
,replace(replace(t1.is_mx_mgmt_righ_flg,chr(13),''),chr(10),'') as is_mx_mgmt_righ_flg --有无进出口经营权标志
,replace(replace(t1.rela_group_type_cd,chr(13),''),chr(10),'') as rela_group_type_cd --关联集团类型代码
,replace(replace(t1.group_cust_flg,chr(13),''),chr(10),'') as group_cust_flg --集团客户标志
,replace(replace(t1.escp_debt_corp_flg,chr(13),''),chr(10),'') as escp_debt_corp_flg --逃废债企业标志
,replace(replace(t1.strtg_cust_flg,chr(13),''),chr(10),'') as strtg_cust_flg --战略客户标志
,replace(replace(t1.off_shore_cust_flg,chr(13),''),chr(10),'') as off_shore_cust_flg --离岸客户标志
,replace(replace(t1.cust_sev_ugd_cls_cd,chr(13),''),chr(10),'') as cust_sev_ugd_cls_cd --客户服务升级分类代码
,replace(replace(t1.weight_risk_asset_cust_cls_cd,chr(13),''),chr(10),'') as weight_risk_asset_cust_cls_cd --加权风险资产客户分类代码
,replace(replace(t1.crdt_strategy_cd,chr(13),''),chr(10),'') as crdt_strategy_cd --授信策略代码
,replace(replace(t1.nb_corp_flg,chr(13),''),chr(10),'') as nb_corp_flg --新建企业标志
,replace(replace(t1.hxb_rela_tran_flg,chr(13),''),chr(10),'') as hxb_rela_tran_flg --我行关联交易标志
,replace(replace(t1.mc_dept_mplize_cust_flg,chr(13),''),chr(10),'') as mc_dept_mplize_cust_flg --中小企业事业部专营客户标志
,replace(replace(t1.hxb_idtfy_small_bus_flg,chr(13),''),chr(10),'') as hxb_idtfy_small_bus_flg --我行认定小企业标志
,replace(replace(t1.bel_thi_flg,chr(13),''),chr(10),'') as bel_thi_flg --属于两高行业标志
,replace(replace(t1.prit_etp_flg,chr(13),''),chr(10),'') as prit_etp_flg --民营企业标志
,replace(replace(t1.cbrc_sb_flg,chr(13),''),chr(10),'') as cbrc_sb_flg --银监小企业标志
,replace(replace(t1.hold_type_cd,chr(13),''),chr(10),'') as hold_type_cd --控股类型代码
,replace(replace(t1.fin_subsidy_inco_src_cd,chr(13),''),chr(10),'') as fin_subsidy_inco_src_cd --财政补助收入来源代码
,replace(replace(t1.rela_party_flg,chr(13),''),chr(10),'') as rela_party_flg --关联方标志
,t1.rgst_dt as rgst_dt --注册日期
,replace(replace(t1.crdt_cust_flg,chr(13),''),chr(10),'') as crdt_cust_flg --授信客户标志
,replace(replace(t1.hxb_shard_flg,chr(13),''),chr(10),'') as hxb_shard_flg --我行股东标志
,replace(replace(t1.subj_org_name,chr(13),''),chr(10),'') as subj_org_name --隶属机构名称
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd --国家和地区代码
,replace(replace(t1.ctysd_corp_flg,chr(13),''),chr(10),'') as ctysd_corp_flg --农村城市标志
,replace(replace(t1.ta_cust_size,chr(13),''),chr(10),'') as ta_cust_size --商圈客户规模
,replace(replace(t1.ta_cust_indus_status,chr(13),''),chr(10),'') as ta_cust_indus_status --商圈客户行业地位
,replace(replace(t1.ins_adj_type_cd,chr(13),''),chr(10),'') as ins_adj_type_cd --产业结构调整类型代码
,replace(replace(t1.itau_flg,chr(13),''),chr(10),'') as itau_flg --工业转型升级标志
,replace(replace(t1.strtg_new_indus_type_cd,chr(13),''),chr(10),'') as strtg_new_indus_type_cd --战略新兴产业类型代码
,replace(replace(t1.list_corp_type_cd,chr(13),''),chr(10),'') as list_corp_type_cd --上市公司类型代码
,replace(replace(t1.is_mx_oper_item_flg,chr(13),''),chr(10),'') as is_mx_oper_item_flg --有无进出口经营项标志
,replace(replace(t1.orgnz_type_subdv_cd,chr(13),''),chr(10),'') as orgnz_type_subdv_cd --组织机构类型细分代码
,replace(replace(t1.org_status_cd,chr(13),''),chr(10),'') as org_status_cd --机构状态代码
,replace(replace(t1.orgnz_type_cd,chr(13),''),chr(10),'') as orgnz_type_cd --组织机构类型代码
,replace(replace(t1.soci_crdt_cd,chr(13),''),chr(10),'') as soci_crdt_cd --社会信用代码
,replace(replace(t1.strategy_camp_cust_no,chr(13),''),chr(10),'') as strategy_camp_cust_no --策略营销客户号
,t1.single_lmt as single_lmt --单一限额
,replace(replace(t1.corp_size_cd_intnal,chr(13),''),chr(10),'') as corp_size_cd_intnal --企业规模代码_内部
,replace(replace(t1.green_crdt_cust_flg,chr(13),''),chr(10),'') as green_crdt_cust_flg --绿色信贷客户标志
,replace(replace(t1.single_lp_flg,chr(13),''),chr(10),'') as single_lp_flg --独立法人标志
,replace(replace(t1.cust_ownsp_type_cd,chr(13),''),chr(10),'') as cust_ownsp_type_cd --客户所有制类型代码
,replace(replace(t1.belong_rela_group_id,chr(13),''),chr(10),'') as belong_rela_group_id --所属关联集团编号
,replace(replace(t1.araf_flg,chr(13),''),chr(10),'') as araf_flg --三农标志
,replace(replace(t1.prtcptr_cate_cd,chr(13),''),chr(10),'') as prtcptr_cate_cd --参与者类别代码
,t1.rgst_cap as rgst_cap --注册资金
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no --银行行号
,replace(replace(t1.bank_lev_cd,chr(13),''),chr(10),'') as bank_lev_cd --银行级别代码
,replace(replace(t1.ibank_no,chr(13),''),chr(10),'') as ibank_no --银行联行号
,replace(replace(t1.cpes_corp_size_cd,chr(13),''),chr(10),'') as cpes_corp_size_cd --票交所企业规模代码
,replace(replace(t1.cpes_indus_type_cd,chr(13),''),chr(10),'') as cpes_indus_type_cd --票交所行业类型代码
,replace(replace(t1.edu_hea_flg,chr(13),''),chr(10),'') as edu_hea_flg --文教健康标志
,replace(replace(t1.inc_flg,chr(13),''),chr(10),'') as inc_flg --普惠型标志
,replace(replace(t1.labor_inte_corp_flg,chr(13),''),chr(10),'') as labor_inte_corp_flg --劳动密集型企业标志
,replace(replace(t1.corp_grow_stage_cd,chr(13),''),chr(10),'') as corp_grow_stage_cd --企业成长阶段代码
,t1.shard_stru_cors_dt as shard_stru_cors_dt --股东结构对应日期
,replace(replace(t1.nation_tax_tax_regi_cert_num,chr(13),''),chr(10),'') as nation_tax_tax_regi_cert_num --国税税务登记证号
,replace(replace(t1.local_tax_tax_regi_cert_num,chr(13),''),chr(10),'') as local_tax_tax_regi_cert_num --地税税务登记证号
,replace(replace(t1.fin_dept_phone,chr(13),''),chr(10),'') as fin_dept_phone --财务部联系电话
,t1.oper_field_area as oper_field_area --经营场地面积
,replace(replace(t1.oper_field_prop_cd,chr(13),''),chr(10),'') as oper_field_prop_cd --经营场地所有权代码
,replace(replace(t1.fin_inst_lics,chr(13),''),chr(10),'') as fin_inst_lics --金融机构许可证
,replace(replace(t1.rgst_land_dist_cd,chr(13),''),chr(10),'') as rgst_land_dist_cd --登记地行政区划代码
,t1.fir_lon_dt as fir_lon_dt --首贷日期
,replace(replace(t1.crdtc_subm_corp_idti_idf_type_cd,chr(13),''),chr(10),'') as crdtc_subm_corp_idti_idf_type_cd --征信报送企业身份标识类型代码
,t1.actl_ctrler_cnt as actl_ctrler_cnt --实际控制人数
,t1.major_contrior_cnt as major_contrior_cnt --主要出资人数
,replace(replace(t1.green_crdt_subclass_cd,chr(13),''),chr(10),'') as green_crdt_subclass_cd --绿色贷款用途代码
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_corp_cust t1    --公司客户
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_corp_cust',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
