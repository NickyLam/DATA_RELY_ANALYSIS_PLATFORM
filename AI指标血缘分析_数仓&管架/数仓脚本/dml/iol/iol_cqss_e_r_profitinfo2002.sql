/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_profitinfo2002
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cqss_e_r_profitinfo2002_ex purge;
alter table ${iol_schema}.cqss_e_r_profitinfo2002 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_profitinfo2002 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_profitinfo2002_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_profitinfo2002 where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_profitinfo2002_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,mainbsn_incm -- 主营业务收入:EG03BJ01
    ,exprt_pd_sale_incm -- （主营业务收入科目下）出口产品销售收入:EG03BJ02
    ,impr_pd_sale_incm -- （主营业务收入科目下）进口产品销售收入:EG03BJ03
    ,sale_dcn_with_dct -- 销售折扣与折让:EG03BJ04
    ,mainbsn_incm_netamt -- 主营业务收入净额:EG03BJ05
    ,mainbsn_cost -- 主营业务成本:EG03BJ06
    ,exprt_pd_sale_cost -- （主营业务成本科目下）出口产品销售成本:EG03BJ07
    ,mainbsn_tax_and_apd -- 主营业务税金及附加:EG03BJ08
    ,oprt_eps -- 经营费用:EG03BJ09
    ,othr_bcs -- 其他（业务成本）:EG03BJ10
    ,dfr_pft -- 递延收益:EG03BJ11
    ,prch_agnt_incm -- 代购代销收入:EG03BJ12
    ,oicm -- 其他（收入）:EG03BJ13
    ,mainbsn_pft -- 主营业务利润:EG03BJ14
    ,othr_bsn_pft -- 其他业务利润:EG03BJ15
    ,oprg_eps -- 营业费用:EG03BJ16
    ,mtex -- 管理费用:EG03BJ17
    ,fncex -- 财务费用:EG03BJ18
    ,orexp -- 其他（费用）:EG03BJ19
    ,oprg_pft -- 营业利润:EG03BJ20
    ,ispt -- 投资收益:EG03BJ21
    ,ftrs_pft -- 期货收益:EG03BJ22
    ,alwc_incm -- 补贴收入:EG03BJ23
    ,alwc_bfr_ls_entp_incm -- （补贴收入科目下）补贴前亏损的企业补贴收入:EG03BJ24
    ,nonoprgincm -- 营业外收入:EG03BJ25
    ,displ_fix_ast_netincm -- （营业外收入科目下）处置固定资产净收益:EG03BJ26
    ,non_mntr_txn_pft -- （营业外收入科目下）非货币性交易收益:EG03BJ27
    ,sell_intgbl_ast_pft -- （营业外收入科目下）出售无形资产收益:EG03BJ28
    ,fine_net_incm -- （营业外收入科目下）罚款净收入:EG03BJ29
    ,othr_pft -- 其他（利润）:EG03BJ30
    ,use_bfr_ys_sal_mkpft -- （其他科目下）用以前年度含量工资节余弥补利润:EG03BJ31
    ,nopex -- 营业外支出:EG03BJ32
    ,displ_fix_ast_netls -- （营业外支出科目下）处置固定资产净损失:EG03BJ33
    ,dbt_regrp_loss -- （营业外支出科目下）债务重组损失:EG03BJ34
    ,fine_expn -- （营业外支出科目下）罚款支出:EG03BJ35
    ,dntn_expn -- （营业外支出科目下）捐赠支出:EG03BJ36
    ,othexp -- 其他支出:EG03BJ37
    ,crrov_icl_num_wage_bag -- （其他支出）结转的含量工资包干节余:EG03BJ38
    ,pft_tamt -- 利润总额:EG03BJ39
    ,incmtax -- 所得税:EG03BJ40
    ,less_shrh_pftandloss -- 少数股东损益:EG03BJ41
    ,not_cfm_ivs_loss -- 未确认的投资损失:EG03BJ42
    ,net_pft -- 净利润:EG03BJ43
    ,begofyr_uspt -- 年初未分配利润:EG03BJ44
    ,splrsv_recloss -- 盈余公积补亏:EG03BJ45
    ,othr_adj_fctr -- 其他调整因素:EG03BJ46
    ,dstr_pft -- 可供分配的利润:EG03BJ47
    ,idv_use_pft -- 单项留用的利润:EG03BJ48
    ,splmt_lqud_cptl -- 补充流动资本:EG03BJ49
    ,rtrv_lgl_splrsv -- 提取法定盈余公积:EG03BJ50
    ,rtrv_lgl_pbwlf_gld -- 提取法定公益金:EG03BJ51
    ,exta_wk_rwd_wlf_fnd -- 提取职工奖励及福利基金:EG03BJ52
    ,rtrv_rsrv_fnd -- 提取储备基金:EG03BJ53
    ,rtrv_entp_dvlp_fnd -- 提取企业发展基金:EG03BJ54
    ,pft_ret_ivs -- 利润归还投资:EG03BJ55
    ,othr_dstr_pft -- （可供分配的利润科目下）其他:EG03BJ56
    ,avl_ivsr_alct_pft -- 可供投资者分配的利润:EG03BJ57
    ,pbl_prshr_dvdn -- 应付优先股股利:EG03BJ58
    ,rtrv_rndm_splrsv -- 提取任意盈余公积:EG03BJ59
    ,pbl_ord_shr_dvdn -- 应付普通股股利:EG03BJ60
    ,tfr_mk_cptl_ord_shr_dvdn -- 转作资本的普通股股利:EG03BJ61
    ,othr_avl_ivsr_alct_pft -- （可供投资者分配的利润科目下）其他:EG03BJ62
    ,uspt -- 未分配利润:EG03BJ63
    ,afr_anul_tax_bfr_pft_rmnls -- （未分配利润科目下）应由以后年度税前利润弥补的亏损:EG03BJ64
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,cr_supr_rcrd_id -- 征信上级记录编号(上级序号)
    ,mainbsn_incm -- 主营业务收入:EG03BJ01
    ,exprt_pd_sale_incm -- （主营业务收入科目下）出口产品销售收入:EG03BJ02
    ,impr_pd_sale_incm -- （主营业务收入科目下）进口产品销售收入:EG03BJ03
    ,sale_dcn_with_dct -- 销售折扣与折让:EG03BJ04
    ,mainbsn_incm_netamt -- 主营业务收入净额:EG03BJ05
    ,mainbsn_cost -- 主营业务成本:EG03BJ06
    ,exprt_pd_sale_cost -- （主营业务成本科目下）出口产品销售成本:EG03BJ07
    ,mainbsn_tax_and_apd -- 主营业务税金及附加:EG03BJ08
    ,oprt_eps -- 经营费用:EG03BJ09
    ,othr_bcs -- 其他（业务成本）:EG03BJ10
    ,dfr_pft -- 递延收益:EG03BJ11
    ,prch_agnt_incm -- 代购代销收入:EG03BJ12
    ,oicm -- 其他（收入）:EG03BJ13
    ,mainbsn_pft -- 主营业务利润:EG03BJ14
    ,othr_bsn_pft -- 其他业务利润:EG03BJ15
    ,oprg_eps -- 营业费用:EG03BJ16
    ,mtex -- 管理费用:EG03BJ17
    ,fncex -- 财务费用:EG03BJ18
    ,orexp -- 其他（费用）:EG03BJ19
    ,oprg_pft -- 营业利润:EG03BJ20
    ,ispt -- 投资收益:EG03BJ21
    ,ftrs_pft -- 期货收益:EG03BJ22
    ,alwc_incm -- 补贴收入:EG03BJ23
    ,alwc_bfr_ls_entp_incm -- （补贴收入科目下）补贴前亏损的企业补贴收入:EG03BJ24
    ,nonoprgincm -- 营业外收入:EG03BJ25
    ,displ_fix_ast_netincm -- （营业外收入科目下）处置固定资产净收益:EG03BJ26
    ,non_mntr_txn_pft -- （营业外收入科目下）非货币性交易收益:EG03BJ27
    ,sell_intgbl_ast_pft -- （营业外收入科目下）出售无形资产收益:EG03BJ28
    ,fine_net_incm -- （营业外收入科目下）罚款净收入:EG03BJ29
    ,othr_pft -- 其他（利润）:EG03BJ30
    ,use_bfr_ys_sal_mkpft -- （其他科目下）用以前年度含量工资节余弥补利润:EG03BJ31
    ,nopex -- 营业外支出:EG03BJ32
    ,displ_fix_ast_netls -- （营业外支出科目下）处置固定资产净损失:EG03BJ33
    ,dbt_regrp_loss -- （营业外支出科目下）债务重组损失:EG03BJ34
    ,fine_expn -- （营业外支出科目下）罚款支出:EG03BJ35
    ,dntn_expn -- （营业外支出科目下）捐赠支出:EG03BJ36
    ,othexp -- 其他支出:EG03BJ37
    ,crrov_icl_num_wage_bag -- （其他支出）结转的含量工资包干节余:EG03BJ38
    ,pft_tamt -- 利润总额:EG03BJ39
    ,incmtax -- 所得税:EG03BJ40
    ,less_shrh_pftandloss -- 少数股东损益:EG03BJ41
    ,not_cfm_ivs_loss -- 未确认的投资损失:EG03BJ42
    ,net_pft -- 净利润:EG03BJ43
    ,begofyr_uspt -- 年初未分配利润:EG03BJ44
    ,splrsv_recloss -- 盈余公积补亏:EG03BJ45
    ,othr_adj_fctr -- 其他调整因素:EG03BJ46
    ,dstr_pft -- 可供分配的利润:EG03BJ47
    ,idv_use_pft -- 单项留用的利润:EG03BJ48
    ,splmt_lqud_cptl -- 补充流动资本:EG03BJ49
    ,rtrv_lgl_splrsv -- 提取法定盈余公积:EG03BJ50
    ,rtrv_lgl_pbwlf_gld -- 提取法定公益金:EG03BJ51
    ,exta_wk_rwd_wlf_fnd -- 提取职工奖励及福利基金:EG03BJ52
    ,rtrv_rsrv_fnd -- 提取储备基金:EG03BJ53
    ,rtrv_entp_dvlp_fnd -- 提取企业发展基金:EG03BJ54
    ,pft_ret_ivs -- 利润归还投资:EG03BJ55
    ,othr_dstr_pft -- （可供分配的利润科目下）其他:EG03BJ56
    ,avl_ivsr_alct_pft -- 可供投资者分配的利润:EG03BJ57
    ,pbl_prshr_dvdn -- 应付优先股股利:EG03BJ58
    ,rtrv_rndm_splrsv -- 提取任意盈余公积:EG03BJ59
    ,pbl_ord_shr_dvdn -- 应付普通股股利:EG03BJ60
    ,tfr_mk_cptl_ord_shr_dvdn -- 转作资本的普通股股利:EG03BJ61
    ,othr_avl_ivsr_alct_pft -- （可供投资者分配的利润科目下）其他:EG03BJ62
    ,uspt -- 未分配利润:EG03BJ63
    ,afr_anul_tax_bfr_pft_rmnls -- （未分配利润科目下）应由以后年度税前利润弥补的亏损:EG03BJ64
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_profitinfo2002
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_profitinfo2002 exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_profitinfo2002_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_profitinfo2002 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_profitinfo2002_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_profitinfo2002',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);