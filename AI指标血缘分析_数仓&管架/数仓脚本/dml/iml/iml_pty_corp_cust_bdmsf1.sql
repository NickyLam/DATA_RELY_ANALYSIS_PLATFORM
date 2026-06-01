/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_corp_cust_bdmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_corp_cust_bdmsf1_tm purge;
drop table ${iml_schema}.pty_corp_cust_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_corp_cust add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_corp_cust modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_corp_cust_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_corp_cust partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_corp_cust_bdmsf1_tm
compress ${option_switch} for query high
as
select
    cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,corp_cust_type_cd -- 公司客户类型代码
    ,orgnz_cd -- 组织机构代码
    ,corp_name -- 公司名称
    ,org_type_cd -- 机构类型代码
    ,indus_type_cd -- 行业类型代码
    ,econ_type_cd -- 经济类型代码
    ,econ_orgnz_form_cd -- 经济组织形式代码
    ,oper_range -- 经营范围
    ,corp_size_cd -- 企业规模代码
    ,corp_found_dt -- 企业成立日期
    ,emply_qtty -- 员工数量
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,list_corp_flg -- 上市企业标志
    ,is_mx_mgmt_righ_flg -- 有无进出口经营权标志
    ,rela_group_type_cd -- 关联集团类型代码
    ,group_cust_flg -- 集团客户标志
    ,escp_debt_corp_flg -- 逃废债企业标志
    ,strtg_cust_flg -- 战略客户标志
    ,off_shore_cust_flg -- 离岸客户标志
    ,cust_sev_ugd_cls_cd -- 客户服务升级分类代码
    ,weight_risk_asset_cust_cls_cd -- 加权风险资产客户分类代码
    ,crdt_strategy_cd -- 授信策略代码
    ,nb_corp_flg -- 新建企业标志
    ,hxb_rela_tran_flg -- 我行关联交易标志
    ,mc_dept_mplize_cust_flg -- 中小企业事业部专营客户标志
    ,hxb_idtfy_small_bus_flg -- 我行认定小企业标志
    ,bel_thi_flg -- 属于两高行业标志
    ,prit_etp_flg -- 民营企业标志
    ,cbrc_sb_flg -- 银监小企业标志
    ,hold_type_cd -- 控股类型代码
    ,fin_subsidy_inco_src_cd -- 财政补助收入来源代码
    ,rela_party_flg -- 关联方标志
    ,rgst_dt -- 注册日期
    ,crdt_cust_flg -- 授信客户标志
    ,hxb_shard_flg -- 我行股东标志
    ,subj_org_name -- 隶属机构名称
    ,cty_rg_cd -- 国家和地区代码
    ,ctysd_corp_flg -- 农村企业标志
    ,ta_cust_size -- 商圈客户规模
    ,ta_cust_indus_status -- 商圈客户行业地位
    ,ins_adj_type_cd -- 产业结构调整类型代码
    ,itau_flg -- 工业转型升级标志
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,list_corp_type_cd -- 上市公司类型代码
    ,is_mx_oper_item_flg -- 有无进出口经营项标志
    ,orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,org_status_cd -- 部门状态代码
    ,orgnz_type_cd -- 组织机构类型代码
    ,soci_crdt_cd -- 社会信用代码
    ,strategy_camp_cust_no -- 策略营销客户号
    ,single_lmt -- 单一限额
    ,corp_size_cd_intnal -- 企业规模代码_内部
    ,green_crdt_cust_flg -- 绿色信贷客户标志
    ,single_lp_flg -- 独立法人标志
    ,cust_ownsp_type_cd -- 客户所有制类型代码
    ,belong_rela_group_id -- 所属关联集团编号
    ,araf_flg -- 三农标志
    ,prtcptr_cate_cd -- 参与者类别代码
    ,rgst_cap -- 注册资金
    ,bank_no -- 银行行号
    ,bank_lev_cd -- 银行级别代码
    ,ibank_no -- 银行联行号
    ,cpes_corp_size_cd -- 票交所企业规模代码
    ,cpes_indus_type_cd -- 票交所行业类型代码
    ,edu_hea_flg -- 文教健康标志
    ,inc_flg -- 普惠型标志
    ,labor_inte_corp_flg -- 劳动密集型企业标志
    ,corp_grow_stage_cd -- 企业成长阶段代码
    ,shard_stru_cors_dt -- 股东结构对应日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_cust
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_corp_cust_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_corp_cust partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_bms_customer_info-
insert into ${iml_schema}.pty_corp_cust_bdmsf1_tm(
    cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,corp_cust_type_cd -- 公司客户类型代码
    ,orgnz_cd -- 组织机构代码
    ,corp_name -- 公司名称
    ,org_type_cd -- 机构类型代码
    ,indus_type_cd -- 行业类型代码
    ,econ_type_cd -- 经济类型代码
    ,econ_orgnz_form_cd -- 经济组织形式代码
    ,oper_range -- 经营范围
    ,corp_size_cd -- 企业规模代码
    ,corp_found_dt -- 企业成立日期
    ,emply_qtty -- 员工数量
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,list_corp_flg -- 上市企业标志
    ,is_mx_mgmt_righ_flg -- 有无进出口经营权标志
    ,rela_group_type_cd -- 关联集团类型代码
    ,group_cust_flg -- 集团客户标志
    ,escp_debt_corp_flg -- 逃废债企业标志
    ,strtg_cust_flg -- 战略客户标志
    ,off_shore_cust_flg -- 离岸客户标志
    ,cust_sev_ugd_cls_cd -- 客户服务升级分类代码
    ,weight_risk_asset_cust_cls_cd -- 加权风险资产客户分类代码
    ,crdt_strategy_cd -- 授信策略代码
    ,nb_corp_flg -- 新建企业标志
    ,hxb_rela_tran_flg -- 我行关联交易标志
    ,mc_dept_mplize_cust_flg -- 中小企业事业部专营客户标志
    ,hxb_idtfy_small_bus_flg -- 我行认定小企业标志
    ,bel_thi_flg -- 属于两高行业标志
    ,prit_etp_flg -- 民营企业标志
    ,cbrc_sb_flg -- 银监小企业标志
    ,hold_type_cd -- 控股类型代码
    ,fin_subsidy_inco_src_cd -- 财政补助收入来源代码
    ,rela_party_flg -- 关联方标志
    ,rgst_dt -- 注册日期
    ,crdt_cust_flg -- 授信客户标志
    ,hxb_shard_flg -- 我行股东标志
    ,subj_org_name -- 隶属机构名称
    ,cty_rg_cd -- 国家和地区代码
    ,ctysd_corp_flg -- 农村企业标志
    ,ta_cust_size -- 商圈客户规模
    ,ta_cust_indus_status -- 商圈客户行业地位
    ,ins_adj_type_cd -- 产业结构调整类型代码
    ,itau_flg -- 工业转型升级标志
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,list_corp_type_cd -- 上市公司类型代码
    ,is_mx_oper_item_flg -- 有无进出口经营项标志
    ,orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,org_status_cd -- 部门状态代码
    ,orgnz_type_cd -- 组织机构类型代码
    ,soci_crdt_cd -- 社会信用代码
    ,strategy_camp_cust_no -- 策略营销客户号
    ,single_lmt -- 单一限额
    ,corp_size_cd_intnal -- 企业规模代码_内部
    ,green_crdt_cust_flg -- 绿色信贷客户标志
    ,single_lp_flg -- 独立法人标志
    ,cust_ownsp_type_cd -- 客户所有制类型代码
    ,belong_rela_group_id -- 所属关联集团编号
    ,araf_flg -- 三农标志
    ,prtcptr_cate_cd -- 参与者类别代码
    ,rgst_cap -- 注册资金
    ,bank_no -- 银行行号
    ,bank_lev_cd -- 银行级别代码
    ,ibank_no -- 银行联行号
    ,cpes_corp_size_cd -- 票交所企业规模代码
    ,cpes_indus_type_cd -- 票交所行业类型代码
    ,edu_hea_flg -- 文教健康标志
    ,inc_flg -- 普惠型标志
    ,labor_inte_corp_flg -- 劳动密集型企业标志
    ,corp_grow_stage_cd -- 企业成长阶段代码
    ,shard_stru_cors_dt -- 股东结构对应日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 客户编号
    ,'9999' -- 法人编号
    ,'BDMS' -- 源系统代码
    ,NVL(TRIM(P1.CUST_TYPE),'0') -- 公司客户类型代码
    ,P1.ORGAN_CODE -- 组织机构代码
    ,P1.CUST_NAME -- 公司名称
    ,' ' -- 机构类型代码
    ,'-' -- 行业类型代码
    ,'-' -- 经济类型代码
    ,'00' -- 经济组织形式代码
    ,' ' -- 经营范围
    ,'9' -- 企业规模代码
    ,TO_DATE('0001/01/01','YYYY/MM/DD') -- 企业成立日期
    ,0.0 -- 员工数量
    ,'-' -- 高新技术企业标志
    ,'-' -- 上市企业标志
    ,'-' -- 有无进出口经营权标志
    ,'-' -- 关联集团类型代码
    ,nvl(trim(P1.GROUP_FLAG),'-') -- 集团客户标志
    ,'-' -- 逃废债企业标志
    ,'-' -- 战略客户标志
    ,'-' -- 离岸客户标志
    ,' ' -- 客户服务升级分类代码
    ,' ' -- 加权风险资产客户分类代码
    ,' ' -- 授信策略代码
    ,'-' -- 新建企业标志
    ,'-' -- 我行关联交易标志
    ,'-' -- 中小企业事业部专营客户标志
    ,'-' -- 我行认定小企业标志
    ,'-' -- 属于两高行业标志
    ,'-' -- 民营企业标志
    ,'-' -- 银监小企业标志
    ,'00000' -- 控股类型代码
    ,' ' -- 财政补助收入来源代码
    ,'-' -- 关联方标志
    ,TO_DATE('0001/01/01','YYYY/MM/DD') -- 注册日期
    ,nvl(trim(P1.CREDIT_FLAG),'-') -- 授信客户标志
    ,'-' -- 我行股东标志
    ,' ' -- 隶属机构名称
    ,'XXX' -- 国家和地区代码
    ,'-' -- 农村企业标志
    ,' ' -- 商圈客户规模
    ,' ' -- 商圈客户行业地位
    ,' ' -- 产业结构调整类型代码
    ,'-' -- 工业转型升级标志
    ,' ' -- 战略新兴产业类型代码
    ,'-' -- 上市公司类型代码
    ,'-' -- 有无进出口经营项标志
    ,'00' -- 组织机构类型细分代码
    ,'X' -- 部门状态代码
    ,'00' -- 组织机构类型代码
    ,P1.SOCIAL_CREDIT_NO -- 社会信用代码
    ,' ' -- 策略营销客户号
    ,0.0 -- 单一限额
    ,'9' -- 企业规模代码_内部
    ,nvl(trim(P1.GRN_FLAG),'-') -- 绿色信贷客户标志
    ,'-' -- 独立法人标志
    ,'00' -- 客户所有制类型代码
    ,' ' -- 所属关联集团编号
    ,'-' -- 三农标志
    ,NVL(TRIM(P1.ROLE_TYPE),'-') -- 参与者类别代码
    ,to_number(nvl(trim(P1.REGISTER_FUND),0)) -- 注册资金
    ,P1.BANK_NO -- 银行行号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.BANK_LEVEL END  -- 银行级别代码
    ,' ' -- 银行联行号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CORP_SCALE END -- 票交所企业规模代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.IND_CLS END -- 票交所行业类型代码
    ,' ' -- 文教健康标志
    ,' ' -- 普惠型标志
    ,' ' -- 劳动密集型企业标志
    ,' ' -- 企业成长阶段代码
    ,TO_DATE('00010101','YYYYMMDD') -- 股东结构对应日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_customer_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_customer_info p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.BANK_LEVEL = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_BMS_CUSTOMER_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'BANK_LEVEL'
        AND R2.TARGET_TAB_EN_NAME= 'PTY_CORP_CUST'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BANK_LEV_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CORP_SCALE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_BMS_CUSTOMER_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'CORP_SCALE'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_CORP_CUST'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CPES_CORP_SIZE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.IND_CLS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_BMS_CUSTOMER_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'IND_CLS'
        AND R3.TARGET_TAB_EN_NAME= 'PTY_CORP_CUST'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CPES_INDUS_TYPE_CD' 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_corp_cust_bdmsf1_tm 
  	                                group by 
  	                                        cust_id
  	                                        ,lp_id
  	                                        ,sorc_sys_cd
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.pty_corp_cust_bdmsf1_ex(
    cust_id -- 客户编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,corp_cust_type_cd -- 公司客户类型代码
    ,orgnz_cd -- 组织机构代码
    ,corp_name -- 公司名称
    ,org_type_cd -- 机构类型代码
    ,indus_type_cd -- 行业类型代码
    ,econ_type_cd -- 经济类型代码
    ,econ_orgnz_form_cd -- 经济组织形式代码
    ,oper_range -- 经营范围
    ,corp_size_cd -- 企业规模代码
    ,corp_found_dt -- 企业成立日期
    ,emply_qtty -- 员工数量
    ,high_new_tech_corp_flg -- 高新技术企业标志
    ,list_corp_flg -- 上市企业标志
    ,is_mx_mgmt_righ_flg -- 有无进出口经营权标志
    ,rela_group_type_cd -- 关联集团类型代码
    ,group_cust_flg -- 集团客户标志
    ,escp_debt_corp_flg -- 逃废债企业标志
    ,strtg_cust_flg -- 战略客户标志
    ,off_shore_cust_flg -- 离岸客户标志
    ,cust_sev_ugd_cls_cd -- 客户服务升级分类代码
    ,weight_risk_asset_cust_cls_cd -- 加权风险资产客户分类代码
    ,crdt_strategy_cd -- 授信策略代码
    ,nb_corp_flg -- 新建企业标志
    ,hxb_rela_tran_flg -- 我行关联交易标志
    ,mc_dept_mplize_cust_flg -- 中小企业事业部专营客户标志
    ,hxb_idtfy_small_bus_flg -- 我行认定小企业标志
    ,bel_thi_flg -- 属于两高行业标志
    ,prit_etp_flg -- 民营企业标志
    ,cbrc_sb_flg -- 银监小企业标志
    ,hold_type_cd -- 控股类型代码
    ,fin_subsidy_inco_src_cd -- 财政补助收入来源代码
    ,rela_party_flg -- 关联方标志
    ,rgst_dt -- 注册日期
    ,crdt_cust_flg -- 授信客户标志
    ,hxb_shard_flg -- 我行股东标志
    ,subj_org_name -- 隶属机构名称
    ,cty_rg_cd -- 国家和地区代码
    ,ctysd_corp_flg -- 农村企业标志
    ,ta_cust_size -- 商圈客户规模
    ,ta_cust_indus_status -- 商圈客户行业地位
    ,ins_adj_type_cd -- 产业结构调整类型代码
    ,itau_flg -- 工业转型升级标志
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,list_corp_type_cd -- 上市公司类型代码
    ,is_mx_oper_item_flg -- 有无进出口经营项标志
    ,orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,org_status_cd -- 部门状态代码
    ,orgnz_type_cd -- 组织机构类型代码
    ,soci_crdt_cd -- 社会信用代码
    ,strategy_camp_cust_no -- 策略营销客户号
    ,single_lmt -- 单一限额
    ,corp_size_cd_intnal -- 企业规模代码_内部
    ,green_crdt_cust_flg -- 绿色信贷客户标志
    ,single_lp_flg -- 独立法人标志
    ,cust_ownsp_type_cd -- 客户所有制类型代码
    ,belong_rela_group_id -- 所属关联集团编号
    ,araf_flg -- 三农标志
    ,prtcptr_cate_cd -- 参与者类别代码
    ,rgst_cap -- 注册资金
    ,bank_no -- 银行行号
    ,bank_lev_cd -- 银行级别代码
    ,ibank_no -- 银行联行号
    ,cpes_corp_size_cd -- 票交所企业规模代码
    ,cpes_indus_type_cd -- 票交所行业类型代码
    ,edu_hea_flg -- 文教健康标志
    ,inc_flg -- 普惠型标志
    ,labor_inte_corp_flg -- 劳动密集型企业标志
    ,corp_grow_stage_cd -- 企业成长阶段代码
    ,shard_stru_cors_dt -- 股东结构对应日期
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sorc_sys_cd, o.sorc_sys_cd) as sorc_sys_cd -- 源系统代码
    ,nvl(n.corp_cust_type_cd, o.corp_cust_type_cd) as corp_cust_type_cd -- 公司客户类型代码
    ,nvl(n.orgnz_cd, o.orgnz_cd) as orgnz_cd -- 组织机构代码
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 公司名称
    ,nvl(n.org_type_cd, o.org_type_cd) as org_type_cd -- 机构类型代码
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
    ,nvl(n.econ_type_cd, o.econ_type_cd) as econ_type_cd -- 经济类型代码
    ,nvl(n.econ_orgnz_form_cd, o.econ_orgnz_form_cd) as econ_orgnz_form_cd -- 经济组织形式代码
    ,nvl(n.oper_range, o.oper_range) as oper_range -- 经营范围
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模代码
    ,nvl(n.corp_found_dt, o.corp_found_dt) as corp_found_dt -- 企业成立日期
    ,nvl(n.emply_qtty, o.emply_qtty) as emply_qtty -- 员工数量
    ,nvl(n.high_new_tech_corp_flg, o.high_new_tech_corp_flg) as high_new_tech_corp_flg -- 高新技术企业标志
    ,nvl(n.list_corp_flg, o.list_corp_flg) as list_corp_flg -- 上市企业标志
    ,nvl(n.is_mx_mgmt_righ_flg, o.is_mx_mgmt_righ_flg) as is_mx_mgmt_righ_flg -- 有无进出口经营权标志
    ,nvl(n.rela_group_type_cd, o.rela_group_type_cd) as rela_group_type_cd -- 关联集团类型代码
    ,nvl(n.group_cust_flg, o.group_cust_flg) as group_cust_flg -- 集团客户标志
    ,nvl(n.escp_debt_corp_flg, o.escp_debt_corp_flg) as escp_debt_corp_flg -- 逃废债企业标志
    ,nvl(n.strtg_cust_flg, o.strtg_cust_flg) as strtg_cust_flg -- 战略客户标志
    ,nvl(n.off_shore_cust_flg, o.off_shore_cust_flg) as off_shore_cust_flg -- 离岸客户标志
    ,nvl(n.cust_sev_ugd_cls_cd, o.cust_sev_ugd_cls_cd) as cust_sev_ugd_cls_cd -- 客户服务升级分类代码
    ,nvl(n.weight_risk_asset_cust_cls_cd, o.weight_risk_asset_cust_cls_cd) as weight_risk_asset_cust_cls_cd -- 加权风险资产客户分类代码
    ,nvl(n.crdt_strategy_cd, o.crdt_strategy_cd) as crdt_strategy_cd -- 授信策略代码
    ,nvl(n.nb_corp_flg, o.nb_corp_flg) as nb_corp_flg -- 新建企业标志
    ,nvl(n.hxb_rela_tran_flg, o.hxb_rela_tran_flg) as hxb_rela_tran_flg -- 我行关联交易标志
    ,nvl(n.mc_dept_mplize_cust_flg, o.mc_dept_mplize_cust_flg) as mc_dept_mplize_cust_flg -- 中小企业事业部专营客户标志
    ,nvl(n.hxb_idtfy_small_bus_flg, o.hxb_idtfy_small_bus_flg) as hxb_idtfy_small_bus_flg -- 我行认定小企业标志
    ,nvl(n.bel_thi_flg, o.bel_thi_flg) as bel_thi_flg -- 属于两高行业标志
    ,nvl(n.prit_etp_flg, o.prit_etp_flg) as prit_etp_flg -- 民营企业标志
    ,nvl(n.cbrc_sb_flg, o.cbrc_sb_flg) as cbrc_sb_flg -- 银监小企业标志
    ,nvl(n.hold_type_cd, o.hold_type_cd) as hold_type_cd -- 控股类型代码
    ,nvl(n.fin_subsidy_inco_src_cd, o.fin_subsidy_inco_src_cd) as fin_subsidy_inco_src_cd -- 财政补助收入来源代码
    ,nvl(n.rela_party_flg, o.rela_party_flg) as rela_party_flg -- 关联方标志
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 注册日期
    ,nvl(n.crdt_cust_flg, o.crdt_cust_flg) as crdt_cust_flg -- 授信客户标志
    ,nvl(n.hxb_shard_flg, o.hxb_shard_flg) as hxb_shard_flg -- 我行股东标志
    ,nvl(n.subj_org_name, o.subj_org_name) as subj_org_name -- 隶属机构名称
    ,nvl(n.cty_rg_cd, o.cty_rg_cd) as cty_rg_cd -- 国家和地区代码
    ,nvl(n.ctysd_corp_flg, o.ctysd_corp_flg) as ctysd_corp_flg -- 农村企业标志
    ,nvl(n.ta_cust_size, o.ta_cust_size) as ta_cust_size -- 商圈客户规模
    ,nvl(n.ta_cust_indus_status, o.ta_cust_indus_status) as ta_cust_indus_status -- 商圈客户行业地位
    ,nvl(n.ins_adj_type_cd, o.ins_adj_type_cd) as ins_adj_type_cd -- 产业结构调整类型代码
    ,nvl(n.itau_flg, o.itau_flg) as itau_flg -- 工业转型升级标志
    ,nvl(n.strtg_new_indus_type_cd, o.strtg_new_indus_type_cd) as strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,nvl(n.list_corp_type_cd, o.list_corp_type_cd) as list_corp_type_cd -- 上市公司类型代码
    ,nvl(n.is_mx_oper_item_flg, o.is_mx_oper_item_flg) as is_mx_oper_item_flg -- 有无进出口经营项标志
    ,nvl(n.orgnz_type_subdv_cd, o.orgnz_type_subdv_cd) as orgnz_type_subdv_cd -- 组织机构类型细分代码
    ,nvl(n.org_status_cd, o.org_status_cd) as org_status_cd -- 部门状态代码
    ,nvl(n.orgnz_type_cd, o.orgnz_type_cd) as orgnz_type_cd -- 组织机构类型代码
    ,nvl(n.soci_crdt_cd, o.soci_crdt_cd) as soci_crdt_cd -- 社会信用代码
    ,nvl(n.strategy_camp_cust_no, o.strategy_camp_cust_no) as strategy_camp_cust_no -- 策略营销客户号
    ,nvl(n.single_lmt, o.single_lmt) as single_lmt -- 单一限额
    ,nvl(n.corp_size_cd_intnal, o.corp_size_cd_intnal) as corp_size_cd_intnal -- 企业规模代码_内部
    ,nvl(n.green_crdt_cust_flg, o.green_crdt_cust_flg) as green_crdt_cust_flg -- 绿色信贷客户标志
    ,nvl(n.single_lp_flg, o.single_lp_flg) as single_lp_flg -- 独立法人标志
    ,nvl(n.cust_ownsp_type_cd, o.cust_ownsp_type_cd) as cust_ownsp_type_cd -- 客户所有制类型代码
    ,nvl(n.belong_rela_group_id, o.belong_rela_group_id) as belong_rela_group_id -- 所属关联集团编号
    ,nvl(n.araf_flg, o.araf_flg) as araf_flg -- 三农标志
    ,nvl(n.prtcptr_cate_cd, o.prtcptr_cate_cd) as prtcptr_cate_cd -- 参与者类别代码
    ,nvl(n.rgst_cap, o.rgst_cap) as rgst_cap -- 注册资金
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行行号
    ,nvl(n.bank_lev_cd, o.bank_lev_cd) as bank_lev_cd -- 银行级别代码
    ,nvl(n.ibank_no, o.ibank_no) as ibank_no -- 银行联行号
    ,nvl(n.cpes_corp_size_cd, o.cpes_corp_size_cd) as cpes_corp_size_cd -- 票交所企业规模代码
    ,nvl(n.cpes_indus_type_cd, o.cpes_indus_type_cd) as cpes_indus_type_cd -- 票交所行业类型代码
    ,nvl(n.edu_hea_flg, o.edu_hea_flg) as edu_hea_flg -- 文教健康标志
    ,nvl(n.inc_flg, o.inc_flg) as inc_flg -- 普惠型标志
    ,nvl(n.labor_inte_corp_flg, o.labor_inte_corp_flg) as labor_inte_corp_flg -- 劳动密集型企业标志
    ,nvl(n.corp_grow_stage_cd, o.corp_grow_stage_cd) as corp_grow_stage_cd -- 企业成长阶段代码
    ,nvl(n.shard_stru_cors_dt, o.shard_stru_cors_dt) as shard_stru_cors_dt -- 股东结构对应日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.cust_id is null
                and o.lp_id is null
                and o.sorc_sys_cd is null
            ) or (
                o.corp_cust_type_cd <> n.corp_cust_type_cd
                or o.orgnz_cd <> n.orgnz_cd
                or o.corp_name <> n.corp_name
                or o.org_type_cd <> n.org_type_cd
                or o.indus_type_cd <> n.indus_type_cd
                or o.econ_type_cd <> n.econ_type_cd
                or o.econ_orgnz_form_cd <> n.econ_orgnz_form_cd
                or o.oper_range <> n.oper_range
                or o.corp_size_cd <> n.corp_size_cd
                or o.corp_found_dt <> n.corp_found_dt
                or o.emply_qtty <> n.emply_qtty
                or o.high_new_tech_corp_flg <> n.high_new_tech_corp_flg
                or o.list_corp_flg <> n.list_corp_flg
                or o.is_mx_mgmt_righ_flg <> n.is_mx_mgmt_righ_flg
                or o.rela_group_type_cd <> n.rela_group_type_cd
                or o.group_cust_flg <> n.group_cust_flg
                or o.escp_debt_corp_flg <> n.escp_debt_corp_flg
                or o.strtg_cust_flg <> n.strtg_cust_flg
                or o.off_shore_cust_flg <> n.off_shore_cust_flg
                or o.cust_sev_ugd_cls_cd <> n.cust_sev_ugd_cls_cd
                or o.weight_risk_asset_cust_cls_cd <> n.weight_risk_asset_cust_cls_cd
                or o.crdt_strategy_cd <> n.crdt_strategy_cd
                or o.nb_corp_flg <> n.nb_corp_flg
                or o.hxb_rela_tran_flg <> n.hxb_rela_tran_flg
                or o.mc_dept_mplize_cust_flg <> n.mc_dept_mplize_cust_flg
                or o.hxb_idtfy_small_bus_flg <> n.hxb_idtfy_small_bus_flg
                or o.bel_thi_flg <> n.bel_thi_flg
                or o.prit_etp_flg <> n.prit_etp_flg
                or o.cbrc_sb_flg <> n.cbrc_sb_flg
                or o.hold_type_cd <> n.hold_type_cd
                or o.fin_subsidy_inco_src_cd <> n.fin_subsidy_inco_src_cd
                or o.rela_party_flg <> n.rela_party_flg
                or o.rgst_dt <> n.rgst_dt
                or o.crdt_cust_flg <> n.crdt_cust_flg
                or o.hxb_shard_flg <> n.hxb_shard_flg
                or o.subj_org_name <> n.subj_org_name
                or o.cty_rg_cd <> n.cty_rg_cd
                or o.ctysd_corp_flg <> n.ctysd_corp_flg
                or o.ta_cust_size <> n.ta_cust_size
                or o.ta_cust_indus_status <> n.ta_cust_indus_status
                or o.ins_adj_type_cd <> n.ins_adj_type_cd
                or o.itau_flg <> n.itau_flg
                or o.strtg_new_indus_type_cd <> n.strtg_new_indus_type_cd
                or o.list_corp_type_cd <> n.list_corp_type_cd
                or o.is_mx_oper_item_flg <> n.is_mx_oper_item_flg
                or o.orgnz_type_subdv_cd <> n.orgnz_type_subdv_cd
                or o.org_status_cd <> n.org_status_cd
                or o.orgnz_type_cd <> n.orgnz_type_cd
                or o.soci_crdt_cd <> n.soci_crdt_cd
                or o.strategy_camp_cust_no <> n.strategy_camp_cust_no
                or o.single_lmt <> n.single_lmt
                or o.corp_size_cd_intnal <> n.corp_size_cd_intnal
                or o.green_crdt_cust_flg <> n.green_crdt_cust_flg
                or o.single_lp_flg <> n.single_lp_flg
                or o.cust_ownsp_type_cd <> n.cust_ownsp_type_cd
                or o.belong_rela_group_id <> n.belong_rela_group_id
                or o.araf_flg <> n.araf_flg
                or o.prtcptr_cate_cd <> n.prtcptr_cate_cd
                or o.rgst_cap <> n.rgst_cap
                or o.bank_no <> n.bank_no
                or o.bank_lev_cd <> n.bank_lev_cd
                or o.ibank_no <> n.ibank_no
                or o.cpes_corp_size_cd <> n.cpes_corp_size_cd
                or o.cpes_indus_type_cd <> n.cpes_indus_type_cd
                or o.edu_hea_flg <> n.edu_hea_flg
                or o.inc_flg <> n.inc_flg
                or o.labor_inte_corp_flg <> n.labor_inte_corp_flg
                or o.corp_grow_stage_cd <> n.corp_grow_stage_cd
                or o.shard_stru_cors_dt <> n.shard_stru_cors_dt
            ) or (
                 case when (
                           n.cust_id is null
                           and n.lp_id is null
                           and n.sorc_sys_cd is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.cust_id is null
                and n.lp_id is null
                and n.sorc_sys_cd is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_corp_cust_bdmsf1_tm n
    full join ${iml_schema}.pty_corp_cust_bdmsf1_bk o
        on
            o.cust_id = n.cust_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_corp_cust truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_corp_cust exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.pty_corp_cust_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_corp_cust drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_corp_cust to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_corp_cust_bdmsf1_tm purge;
drop table ${iml_schema}.pty_corp_cust_bdmsf1_ex purge;
drop table ${iml_schema}.pty_corp_cust_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_corp_cust', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);