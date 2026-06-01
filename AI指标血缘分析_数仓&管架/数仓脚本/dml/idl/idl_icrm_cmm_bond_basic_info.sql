/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_cmm_bond_basic_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_cmm_bond_basic_info drop partition p_${last_date};
alter table ${idl_schema}.icrm_cmm_bond_basic_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_cmm_bond_basic_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_cmm_bond_basic_info (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,bond_id  -- 债券编号
    ,bond_name  -- 债券名称
    ,bond_abbr  -- 债券简称
    ,bond_type_cd  -- 债券类型代码
    ,issuer_name  -- 发行人名称
    ,curr_cd  -- 币种代码
    ,issue_corp  -- 发行单位
    ,issue_price  -- 发行价格
    ,issue_int_rat  -- 发行利率
    ,issue_size  -- 发行规模
    ,fac_val_int_rat  -- 票面利率
    ,int_rat_adj_way_cd  -- 利率调整方式代码
    ,base_rat_id  -- 基准利率编号
    ,int_rat_float_point  -- 利率浮动点数
    ,int_rat_float_dir_cd  -- 利率浮动方向代码
    ,int_rat_float_uplmi  -- 利率浮动上限
    ,int_rat_float_lolmi  -- 利率浮动下限
    ,int_accr_base_cd  -- 计息基准代码
    ,int_accr_curr_cd  -- 计息币种代码
    ,int_accr_ped_cd  -- 计息周期代码
    ,pay_int_ped_cd  -- 付息周期代码
    ,comp_int_ped_cd  -- 复利周期代码
    ,reval_ped_cd  -- 重定价周期代码
    ,fir_reval_dt  -- 首次重定价日期
    ,reval_way_cd  -- 重定价方式代码
    ,last_reval_dt  -- 上次重定价日期
    ,next_reval_dt  -- 下次重定价日期
    ,reval_start_dt  -- 重定价开始日期
    ,reval_end_dt  -- 重定价结束日期
    ,reval_int_rat  -- 重定价利率
    ,exp_yld_rat  -- 到期收益率
    ,issue_dt  -- 发行日期
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,list_dt  -- 上市日期
    ,fir_pay_int_dt  -- 首次付息日期
    ,last_pay_int_dt  -- 上次付息日期
    ,next_pay_int_dt  -- 下次付息日期
    ,next_rpp_amt  -- 下次还本金额
    ,next_pay_int_amt  -- 下次付息金额
    ,stop_circlt_dt  -- 停止流通日期
    ,tranbl_bond_flg  -- 可转换债券标志
    ,discnt_debt_vch_flg  -- 贴现债券标志
    ,acru_int_flg  -- 应计利息标志
    ,ex_choice_type_cd  -- 行权选择类型代码
    ,bond_market_type_cd  -- 债券市场类型代码
    ,guar_type_cd  -- 担保类型代码
    ,guartor_name  -- 担保人名称
    ,inpwned_ratio  -- 可质押比例
    ,asset_type_id  -- 资产类型编号
    ,bond_cls_name  -- 债券分类名称
    ,issuer_cd  -- 发行人代码
    ,fac_val  -- 票面面值
    ,tenor  -- 期限
    ,caption_type_cd  -- 资产化类型代码
    ,valuation_way_cd  -- 计价方式代码
    ,data_src_sys_idf  -- 数据来源系统标识
    ,trust_org_id                -- 托管机构编号      
    ,mgmt_mode_cd                -- 管理模式代码      
    ,issuer_cust_id              -- 发行人客户编号     
    ,issue_main_belong_cty_rg_cd -- 发行主体所属国家地区代码
    ,issue_rg_cd                 -- 发行地区代码      
    ,actl_mang_land_nation_cd    -- 实际经营地国别代码   
    ,src_pay_int_ped_cd          -- 源付息周期代码     
    ,subtn_bond_flg              -- 永续债标志       
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.bond_id,chr(13),''),chr(10),'')  -- 债券编号
    ,replace(replace(t1.bond_name,chr(13),''),chr(10),'')  -- 债券名称
    ,replace(replace(t1.bond_abbr,chr(13),''),chr(10),'')  -- 债券简称
    ,replace(replace(t1.bond_type_cd,chr(13),''),chr(10),'')  -- 债券类型代码
    ,replace(replace(t1.issuer_name,chr(13),''),chr(10),'')  -- 发行人名称
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.issue_corp  -- 发行单位
    ,t1.issue_price  -- 发行价格
    ,t1.issue_int_rat  -- 发行利率
    ,t1.issue_size  -- 发行规模
    ,t1.fac_val_int_rat  -- 票面利率
    ,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'')  -- 利率调整方式代码
    ,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'')  -- 基准利率编号
    ,t1.int_rat_float_point  -- 利率浮动点数
    ,replace(replace(t1.int_rat_float_dir_cd,chr(13),''),chr(10),'')  -- 利率浮动方向代码
    ,t1.int_rat_float_uplmi  -- 利率浮动上限
    ,t1.int_rat_float_lolmi  -- 利率浮动下限
    ,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'')  -- 计息基准代码
    ,replace(replace(t1.int_accr_curr_cd,chr(13),''),chr(10),'')  -- 计息币种代码
    ,replace(replace(t1.int_accr_ped_cd,chr(13),''),chr(10),'')  -- 计息周期代码
    ,replace(replace(t1.pay_int_ped_cd,chr(13),''),chr(10),'')  -- 付息周期代码
    ,replace(replace(t1.comp_int_ped_cd,chr(13),''),chr(10),'')  -- 复利周期代码
    ,replace(replace(t1.reval_ped_cd,chr(13),''),chr(10),'')  -- 重定价周期代码
    ,t1.fir_reval_dt  -- 首次重定价日期
    ,replace(replace(t1.reval_way_cd,chr(13),''),chr(10),'')  -- 重定价方式代码
    ,t1.last_reval_dt  -- 上次重定价日期
    ,t1.next_reval_dt  -- 下次重定价日期
    ,t1.reval_start_dt  -- 重定价开始日期
    ,t1.reval_end_dt  -- 重定价结束日期
    ,t1.reval_int_rat  -- 重定价利率
    ,t1.exp_yld_rat  -- 到期收益率
    ,t1.issue_dt  -- 发行日期
    ,t1.value_dt  -- 起息日期
    ,t1.exp_dt  -- 到期日期
    ,t1.list_dt  -- 上市日期
    ,t1.fir_pay_int_dt  -- 首次付息日期
    ,t1.last_pay_int_dt  -- 上次付息日期
    ,t1.next_pay_int_dt  -- 下次付息日期
    ,t1.next_rpp_amt  -- 下次还本金额
    ,t1.next_pay_int_amt  -- 下次付息金额
    ,t1.stop_circlt_dt  -- 停止流通日期
    ,replace(replace(t1.tranbl_bond_flg,chr(13),''),chr(10),'')  -- 可转换债券标志
    ,replace(replace(t1.discnt_debt_vch_flg,chr(13),''),chr(10),'')  -- 贴现债券标志
    ,replace(replace(t1.acru_int_flg,chr(13),''),chr(10),'')  -- 应计利息标志
    ,replace(replace(t1.ex_choice_type_cd,chr(13),''),chr(10),'')  -- 行权选择类型代码
    ,replace(replace(t1.bond_market_type_cd,chr(13),''),chr(10),'')  -- 债券市场类型代码
    ,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'')  -- 担保类型代码
    ,replace(replace(t1.guartor_name,chr(13),''),chr(10),'')  -- 担保人名称
    ,t1.inpwned_ratio  -- 可质押比例
    ,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'')  -- 资产类型编号
    ,replace(replace(t1.bond_cls_name,chr(13),''),chr(10),'')  -- 债券分类名称
    ,replace(replace(t1.issuer_cd,chr(13),''),chr(10),'')  -- 发行人代码
    ,t1.fac_val  -- 票面面值
    ,replace(replace(t1.tenor,chr(13),''),chr(10),'')  -- 期限
    ,replace(replace(t1.caption_type_cd,chr(13),''),chr(10),'')  -- 资产化类型代码
    ,replace(replace(t1.valuation_way_cd,chr(13),''),chr(10),'')  -- 计价方式代码
    ,replace(replace(t1.data_src_sys_idf,chr(13),''),chr(10),'')  -- 数据来源系统标识
    ,replace(replace(t1.trust_org_id,chr(13),''),chr(10),'') as trust_org_id                                 --托管机构编号      
    ,replace(replace(t1.mgmt_mode_cd,chr(13),''),chr(10),'') as mgmt_mode_cd                                 --管理模式代码      
    ,replace(replace(t1.issuer_cust_id,chr(13),''),chr(10),'') as issuer_cust_id                             --发行人客户编号     
    ,replace(replace(t1.issue_main_belong_cty_rg_cd,chr(13),''),chr(10),'') as issue_main_belong_cty_rg_cd   --发行主体所属国家地区代码
    ,replace(replace(t1.issue_rg_cd,chr(13),''),chr(10),'') as issue_rg_cd                                   --发行地区代码      
    ,replace(replace(t1.actl_mang_land_nation_cd,chr(13),''),chr(10),'') as actl_mang_land_nation_cd         --实际经营地国别代码   
    ,replace(replace(t1.src_pay_int_ped_cd,chr(13),''),chr(10),'') as src_pay_int_ped_cd                     --源付息周期代码     
    ,replace(replace(t1.subtn_bond_flg,chr(13),''),chr(10),'') as subtn_bond_flg                             --永续债标志       
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL数据处理时间
from ${icl_schema}.cmm_bond_basic_info t1    --债券基本信息
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_cmm_bond_basic_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);