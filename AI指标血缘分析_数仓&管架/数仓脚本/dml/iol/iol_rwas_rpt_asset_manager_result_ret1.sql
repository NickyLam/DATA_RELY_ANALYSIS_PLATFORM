/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_rpt_asset_manager_result
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

declare
     v_flag   number(10) :=0;
          
begin
	for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt 
	             from user_tab_partitions 
	            where table_name = upper('rwas_rpt_asset_manager_result_BAK_${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('rwas_rpt_asset_manager_result')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table rwas_rpt_asset_manager_result drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table rwas_rpt_asset_manager_result add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.rwas_rpt_asset_manager_result(
    data_date -- 数据日期
    ,pk_col -- PK_COL
    ,loan_ref_no -- 债项编号
    ,fund_cd -- 资产管理产品编号
    ,fund_name -- 资产管理产品名称
    ,sa_calculate_id -- 标准法计量方法标识
    ,sa_calculate_name -- 标准法计量方法名称
    ,on_off_id -- 表内外标志
    ,accorg_no -- 入账机构
    ,accorg_name -- 入账机构名称
    ,product_cd -- 产品编号
    ,product_name -- 产品名称
    ,five_class_name -- 五级分类名称
    ,overdue_days -- 逾期天数
    ,std_default_flag -- 逾期标志
    ,cust_no -- 客户号
    ,cust_name -- 客户名称
    ,ccp_type_cd -- 交易对手类型
    ,ccp_type_name -- 交易对手类型名称
    ,scale_cd -- 企业规模代码
    ,scale_name -- 企业规模代码名称
    ,ead_tot -- 客户总风险暴露(万)
    ,fm_asset_amt -- 资管产品总资产
    ,fm_hold_ratio -- 资管产品持有比例
    ,fm_fin_product_amt -- 资管产品净资产
    ,fm_lvg -- 资管产品杠杆率
    ,fm_rwa_ccp -- 资管产品CCP风险加权资产
    ,fm_rwa_cva -- 资管产品CVA
    ,fm_flag -- 资管产品标志
    ,fm_avg_rw -- 资管产品基础资产平均权重
    ,fm_alvg_rw -- 资管产品调整杠杆率后的权重
    ,ccf -- 表外信用风险转换系数
    ,ccy_cd -- 币种代码
    ,subject_cd -- 本金科目代码
    ,subject_name -- 本金科目名称
    ,pric_bal_origcurr -- 本金余额（原币）
    ,pric_bal -- 本金余额（本币）
    ,asset_balance -- 资产余额（本币）
    ,accrued_subject_cd -- 应计利息科目
    ,accrued_subject_name -- 应计利息科目名称
    ,accrued_int -- 应计利息（本币）
    ,receivable_subject_cd -- 应收利息科目
    ,receivable_subject_name -- 应收利息科目名称
    ,receivable_int -- 应收利息（本币）
    ,accrued_receiv_subject_cd -- 应收未收利息科目
    ,accrued_receiv_subject_name -- 应收未收利息名称
    ,accrued_receiv_int -- 应收未收利息（本币）
    ,intadj_subject_cd -- 利息调整科目
    ,intadj_subject_name -- 利息调整科目名称
    ,int_adj -- 利息调整（本币）
    ,fairchange_subject_cd -- 公允价值变动科目
    ,fairchange_subject_name -- 公允价值变动科目名称
    ,fairvalue_changes -- 公允价值变动（本币）
    ,provision_subject_cd -- 准备金科目代码
    ,provision_subject_name -- 准备金科目名称
    ,provision -- 准备金（本币）
    ,provesion_ratio -- 准备金计提比例
    ,ead_orig -- 原始风险暴露本币
    ,ead_pen -- 穿透法扣减准备金后EAD
    ,rwa_pen -- 穿透法RWA
    ,ead_pen_third -- 第三方穿透法EAD
    ,rwa_pen_third -- 第三方穿透法RWA
    ,ead_abl -- 授权基础法扣减准备金后EAD
    ,rwa_abl -- 授权基础法RWA
    ,ead_pullb -- 适用于1250%部分扣减准备金后EAD
    ,rwa_pullb -- 适用于1250%部分RWA
    ,rwa_before_adj -- 调整前风险加权资产
    ,rwa_after_adj -- 调整后风险加权资产
    ,adj_flag -- 是否调整标志
    ,g4b_r_item_code -- G4B-5项目
    ,investment_vaild_flag -- 投资级认定是否在有效期内
    ,recognition_date -- 认定日期
    ,load_date -- 加载日期
    ,final_weight -- 最终风险权重
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_date -- 数据日期
    ,pk_col -- PK_COL
    ,loan_ref_no -- 债项编号
    ,fund_cd -- 资产管理产品编号
    ,fund_name -- 资产管理产品名称
    ,sa_calculate_id -- 标准法计量方法标识
    ,sa_calculate_name -- 标准法计量方法名称
    ,on_off_id -- 表内外标志
    ,accorg_no -- 入账机构
    ,accorg_name -- 入账机构名称
    ,product_cd -- 产品编号
    ,product_name -- 产品名称
    ,five_class_name -- 五级分类名称
    ,overdue_days -- 逾期天数
    ,std_default_flag -- 逾期标志
    ,cust_no -- 客户号
    ,cust_name -- 客户名称
    ,ccp_type_cd -- 交易对手类型
    ,ccp_type_name -- 交易对手类型名称
    ,scale_cd -- 企业规模代码
    ,scale_name -- 企业规模代码名称
    ,ead_tot -- 客户总风险暴露(万)
    ,fm_asset_amt -- 资管产品总资产
    ,fm_hold_ratio -- 资管产品持有比例
    ,fm_fin_product_amt -- 资管产品净资产
    ,fm_lvg -- 资管产品杠杆率
    ,fm_rwa_ccp -- 资管产品CCP风险加权资产
    ,fm_rwa_cva -- 资管产品CVA
    ,fm_flag -- 资管产品标志
    ,fm_avg_rw -- 资管产品基础资产平均权重
    ,fm_alvg_rw -- 资管产品调整杠杆率后的权重
    ,ccf -- 表外信用风险转换系数
    ,ccy_cd -- 币种代码
    ,subject_cd -- 本金科目代码
    ,subject_name -- 本金科目名称
    ,pric_bal_origcurr -- 本金余额（原币）
    ,pric_bal -- 本金余额（本币）
    ,asset_balance -- 资产余额（本币）
    ,accrued_subject_cd -- 应计利息科目
    ,accrued_subject_name -- 应计利息科目名称
    ,accrued_int -- 应计利息（本币）
    ,receivable_subject_cd -- 应收利息科目
    ,receivable_subject_name -- 应收利息科目名称
    ,receivable_int -- 应收利息（本币）
    ,accrued_receiv_subject_cd -- 应收未收利息科目
    ,accrued_receiv_subject_name -- 应收未收利息名称
    ,accrued_receiv_int -- 应收未收利息（本币）
    ,intadj_subject_cd -- 利息调整科目
    ,intadj_subject_name -- 利息调整科目名称
    ,int_adj -- 利息调整（本币）
    ,fairchange_subject_cd -- 公允价值变动科目
    ,fairchange_subject_name -- 公允价值变动科目名称
    ,fairvalue_changes -- 公允价值变动（本币）
    ,provision_subject_cd -- 准备金科目代码
    ,provision_subject_name -- 准备金科目名称
    ,provision -- 准备金（本币）
    ,provesion_ratio -- 准备金计提比例
    ,ead_orig -- 原始风险暴露本币
    ,ead_pen -- 穿透法扣减准备金后EAD
    ,rwa_pen -- 穿透法RWA
    ,ead_pen_third -- 第三方穿透法EAD
    ,rwa_pen_third -- 第三方穿透法RWA
    ,ead_abl -- 授权基础法扣减准备金后EAD
    ,rwa_abl -- 授权基础法RWA
    ,ead_pullb -- 适用于1250%部分扣减准备金后EAD
    ,rwa_pullb -- 适用于1250%部分RWA
    ,rwa_before_adj -- 调整前风险加权资产
    ,rwa_after_adj -- 调整后风险加权资产
    ,adj_flag -- 是否调整标志
    ,g4b_r_item_code -- G4B-5项目
    ,investment_vaild_flag -- 投资级认定是否在有效期内
    ,recognition_date -- 认定日期
    ,load_date -- 加载日期
    ,' ' as final_weight -- 最终风险权重
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from rwas_rpt_asset_manager_result_BAK_${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/