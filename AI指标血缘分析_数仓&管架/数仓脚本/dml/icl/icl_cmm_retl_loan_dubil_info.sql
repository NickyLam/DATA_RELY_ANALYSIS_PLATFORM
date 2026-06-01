/*
Purpose:    共性加工层-零售贷款借据信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_retl_loan_dubil_info
Createdate: 20190729
Logs:       20191206 翟若平 调整第四组网贷的[基准利率]取数逻辑 0 --〉AGT_WL_DUBIL_INFO.BASE_RAT
            20200110 翟若平 调整字段[还款方式代码]的取数逻辑
            20200313 翟若平 调整五级分类、十级分类的取数逻辑
            20200327 翟若平 调整取微贷工厂标准产品信息时关联表（协议产品关系历史）的分区[mpcsf1->crssf2]
            20200424 周沁晖 第四组网贷agt_prod_rela_h t9 t9.job_cd='mybkf1' 改为 t9.job_cd='ilssf2'
            20200729 谢  宁 增加字段[资产三分类]到每组
            20200803 谢  宁 增加字段[保险代偿标志]
			      20200828 陈伟峰 修改第二组、第四组的投放行业代码取数口径
			      20200925 陈伟峰 修改网贷平台的投向行业取值逻辑
			      20201113 谢  宁 各组增加字段 [人行普惠贷款标志]
			      20201116 谢  宁 各组增加字段 [支小再贷款状态标志]
			      20201219 陈伟峰 增加字段【宽限天数】、【宽限期到期日期】、【宽限期开始日期】
            20210305 陈伟峰 增加字段【支小再贷款批次包编号、支小再贷款批次到期日期、支小再贷款使用利率】
            20210705 何桐金 增加字段【上次五级分类变更日期、相关还款责任人客户号、相关还款责任人名称、相关还款责任人证件类型、相关还款责任人证件号码】
            20211103 陈伟峰 调整【本金逾期天数，利息逾期天数】加工逻辑，加入逾期日期不等于'0001-01-01'过滤
            20211108 何桐金 调整助贷网贷两【贷款类型代码】字段的加工逻辑
            20211215 陈伟峰 调整【贷款贷款贷款投向行业代码】加工逻辑,助贷产品粤海饲料个人经营贷、恒兴股份个人经营贷，默认投向为：A0412 内陆养殖
                            调整网贷平台部分投向行业，加入客群客户数据
            20211229 陈伟峰 新增字段【白户标志】
            20220412 陈伟峰 调整T13表关联条件
			      20220420 翟若平	1、取数数据源调整，由零售信贷系统调整为综合信贷管理系统
                            2、新信贷没有相关信息项而置空处理的字段【业务品种编号-BUS_BREED_ID、业务品种名称-BUS_BREED_NAME】
            20220606  温旺清1、调整字段【授信额度使用标志、气球贷标志、十级分类人工干预标志、人行普惠贷款标志、白户标志、贷款类型代码、贷款贷款贷款投向行业代码、贷款类型描述、管理机构编号、借据开立日期、上次五级分类变更日期、上次风险登记调整原因、风险登记审批人编号、逾期利率、本金逾期天数、利息逾期天数】的加工口径
                            2、置空字段【按揭标志-MORTG_FLG、不良贷款标志-NPL_FLG、违约标志-DEFLT_FLG、联保贷款标志-GRO_LEND_FLG、产品类型代码-PROD_TYPE_CD、贷款四级分类代码-LOAN_LEVEL4_CLS_CD、利率浮动期限代码-INT_RAT_FLOAT_TENOR_CD、入账账户支付工具类型代码-ENTER_ACCT_PT_TYPE_CD、还款账户支付工具类型代码-REPAY_ACCT_PT_TYPE_CD、扣款方式代码-DEDUCT_WAY_CD、托管客户经理-TRUST_CUST_MGR、最近还款日期-RECNT_REPAY_DT、宽限期开始日期-GRACE_PERIOD_START_DT、宽限期到期日期-GRACE_PERIOD_EXP_DT、最后一期保留金额-FINAL_PED_RESV_AMT】
                            3、增加T1表过滤条件【SUBSTR(T1.prod_id, 1, 3) IN ('201', '202') 】
                            4、调整T2表的关联方式【INNER JOIN -> LEFT JOIN】
            20220801 温旺清 1、调整【支小再贷款使用利率】口径 EXEC_INT_RAT --》 USE_INT_RAT 使用利率
            20220810 温旺清 1、调整【十级分类人工干预标志】【上次五级分类变更日期】取数逻辑
            20220811 李森辉 调整【贷款贷款贷款投向行业代码】口径，"BC_PERSONAL_LOAN.LOANDIRECTION资金投向"信贷不用使用，改取合同表的国标行业投向
            20220822 温旺清 调整【保险代偿标志】【人行普惠贷款标志】加工口径
            20220824 刘维勇 修改agt_loan_acct_info_h关联条件为t1.AGT_id = t8.AGT_id
			      20221011 温旺清 1、增加字段【农户标志】、【客户性质代码】
			      20221101 温旺清 1、新增字段【征信报送业务品种代码、征信报送业务品种描述、授信总额度】
                            2、调整字段【人行普惠贷款标志】的加工口径
            20221118 温旺清 新增字段【核销标志	WRT_OFF_FLG】
            20221228 翟若平 调整字段【账务机构编号】的加工口径
            20221228 温旺清 1、置空字段【贷款类型代码】
                            2、调整【贷款类型描述】取数口径
            20230215 陈伟峰 调整字段【核销标志	WRT_OFF_FLG】0否1是
            20230406 温旺清 置空字段【授信总额度】新一代改造置空给默认值0（于2023/4/6与信贷李龙龙确认无此信息项。）
            20230424 陈伟峰 新增字段【出账流水号】
            20230609 陈伟峰 过滤开户日期大于跑批日期的数据
            20231027 徐子豪 新增字段【执行到期日期】
            20231221 饶雅   新增字段 【利率浮动类型代码】
            20231226 饶雅   新增字段【重组贷款标志、重组贷款类型代码】
            20240116 饶雅   新增字段【借据余额】、【逾期余额】
            20240412 饶雅   新增字段【养老产业标志】
            20240527 饶雅   新增字段【代偿金额】
            20240627 饶雅   新增字段 【诉讼费余额】 
            20240828 陈伟峰 新增字段 【问题资产标志】
            20241113 谢  宁 新增字段 【分润金额】
            20241212 谢  宁 新增字段 【尽调标志】、【线下核身标志】
            20250722 陈伟峰 新增字段 【子产品编号】
		      	20251010 谢  宁 新增字段 【子产品名称】
            20251223 陈伟峰 调整【尽调标志】、【线下核身标志】逻辑，增加产品201020100060
		      	20260402 陈  凭 新增字段 【专项再贷款标识代码】

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_retl_loan_dubil_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_retl_loan_dubil_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none;
drop table ${icl_schema}.cmm_retl_loan_dubil_info_ex purge;
drop table ${icl_schema}.cmm_retl_loan_dubil_info_01_tmp purge;

whenever sqlerror exit sql.sqlcode;
-- 2.1 insert into ex table
create table ${icl_schema}.cmm_retl_loan_dubil_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_retl_loan_dubil_info where 0=1
;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_dubil_info_01_tmp
nologging
compress ${option_switch} for query high
as select bdserialno,
       sum(balance) as balance --诉讼费余额
from ${iol_schema}.icms_substitute_lawsuit_bill 
where start_dt <= to_date('${batch_date}', 'yyyymmdd')
and  end_dt > to_date('${batch_date}', 'yyyymmdd')
group by bdserialno
;
commit;





--信贷借据信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_retl_loan_dubil_info_ex(
   etl_dt                    --数据日期
   ,lp_id                    --法人编号
   ,dubil_id                 --借据编号
   ,cont_id                  --合同编号
   ,std_prod_id              --标准产品编号
   ,sub_prod_id              --子产品编号
   ,sub_prod_name            --子产品名称
   ,out_acct_flow_num        --出账流水号
   ,bus_breed_id             --业务品种编号
   ,bus_breed_name           --业务品种名称
   ,crdtc_subm_bus_breed_cd	 --征信报送业务品种代码
   ,crdtc_subm_bus_breed_descb	--征信报送业务品种描述
   ,cust_id                  --客户编号
   ,repay_num                --还款账号
   ,enter_acct_num           --入账账号
   ,mortg_flg                --按揭标志
   ,npl_flg                  --不良贷款标志
   ,deflt_flg                --违约标志
   ,crdt_lmt_use_flg         --授信额度使用标志
   ,gro_lend_flg             --联保贷款标志
   ,blon_loan_flg            --气球贷标志
   ,level10_cls_manu_med_flg --十级分类人工干预标志
   ,insure_comp_flg          --保险代偿标志
   ,pbc_inc_loan_flg         --人行普惠贷款标志
   ,white_list_cust_flg      --白户标志
   ,farm_flg                 --农户标志
   ,wrt_off_flg              --核销标志
   ,prob_asset_flg           --问题资产标志
   ,provi_for_aged_property_flg --养老产业标志
   ,due_diligence_flg        --尽调标志
	 ,outline_vrif_idti_flg  --线下核身标志
   ,regroup_loan_flg         --重组贷款标志
   ,regroup_loan_type_cd     --重组贷款类型代码
   ,prod_type_cd             --产品类型代码
   ,loan_happ_type_cd        --贷款发生类型代码
   ,loan_type_cd             --贷款类型代码
   ,asset_thd_cls_cd		 --资产三分类
   ,guar_way_cd              --担保方式代码
   ,sub_guar_way_cd          --子担保方式代码
   ,repay_way_cd             --还款方式代码
   ,dir_indus_cd             --贷款贷款贷款投向行业代码
   ,dubil_status_cd          --借据状态代码
   ,refac_loan_status_cd     --支小再贷款状态代码
   ,spcl_refac_idf_cd        --专项再贷款标识代码
   ,comp_int_calc_way_cd     --复利计算方式代码
   ,int_rat_adj_ped_corp_cd  --利率调整周期单位代码
   ,int_rat_adj_ped_freq     --利率调整周期频率
   ,loan_level4_cls_cd       --贷款四级分类代码
   ,loan_level5_cls_cd       --贷款五级分类代码
   ,loan_level10_cls_cd      --贷款十级分类代码
   ,loan_level12_cls_cd      --贷款十二级分类代码
   ,int_rat_adj_way_cd       --利率调整方式代码
   ,int_rat_float_type_cd    --利率浮动类型代码
   ,ovdue_int_rat_adj_way    --逾期利率调整方式
   ,int_rat_adj_effect_way   --利率调整生效方式
   ,int_rat_float_tenor_cd   --利率浮动期限代码
   ,enter_acct_pt_type_cd    --入账账户支付工具类型代码
   ,repay_acct_pt_type_cd    --还款账户支付工具类型代码
   ,deduct_way_cd            --扣款方式代码
   ,mode_pay_cd              --支付方式代码
   ,curr_cd                  --币种代码
   ,cust_char_cd             --客户性质代码
   ,cust_crdt_tot            --授信总额度
   ,loan_type_descb          --贷款类型描述
   ,enter_acct_name          --入账账户名称
   ,cust_mgr_id              --客户经理编号
   ,trust_cust_mgr           --托管客户经理
   ,rgst_teller_id           --登记柜员编号
   ,rgst_org_id              --登记机构编号
   ,acct_instit_id           --账务机构编号
   ,mgmt_org_id              --管理机构编号
   ,dubil_open_dt            --借据开立日期
   ,dubil_exp_dt             --借据到期日期
   ,fir_distr_dt             --首次放款日期
   ,recnt_repay_dt           --最近还款日期
   ,repay_day                --还款日
   ,payoff_dt                --结清日期
   ,exec_exp_dt              --执行到期日期
   ,pric_ovdue_dt            --本金逾期日期
   ,int_ovdue_dt             --利息逾期日期
   ,loan_level5_cls_dt       --贷款五级分类日期
   ,loan_level10_cls_dt      --贷款十级分类日期
   ,last_level5_cls_modif_dt --上次五级分类变更日期
   ,last_risk_rgst_adj_rs    --上次风险登记调整原因
   ,risk_rgst_apver_id		 --风险登记审批人编号
   ,base_rat                 --基准利率
   ,exec_int_rat             --执行利率
   ,ovdue_int_rat            --逾期利率
   ,ovdue_int_rat_flo_val    --逾期利率浮动值
   ,int_rat_flo_val          --利率浮动值
   ,pric_ovdue_days          --本金逾期天数
   ,int_ovdue_days           --利息逾期天数
   ,grace_days               --宽限天数
   ,grace_period_start_dt    --宽限期开始日期
   ,grace_period_exp_dt      --宽限期到期日期
   ,final_ped_resv_amt       --最后一期保留金额
   ,dubil_amt                --借据金额
   ,dubil_bal                --借据余额
   ,ovdue_bal                --逾期余额
   ,comp_amt                 --代偿金额
   ,prft_cut_amt             --分润金额
   ,suit_fee_bal             --诉讼费余额
   ,refac_loan_batch_pkg_id  --支小再贷款批次包编号
   ,refac_loan_batch_exp_dt  --支小再贷款批次到期日期
   ,refac_loan_use_int_rat   --支小再贷款使用利率
   ,job_cd                   --任务代码
   ,etl_timestamp
)
select
    to_date('${batch_date}','yyyymmdd')     --数据日期
   ,t1.lp_id                                --法人编号
   ,t1.dubil_id                             --借据编号
   ,t1.rela_cont_id                         --合同编号
   ,t1.prod_id                              --标准产品编号
   ,t1.sub_prod_id                          --子产品编号
   ,t19.itemname                            --子产品名称
   ,t1.rela_out_acct_flow_num               --出账流水号
   ,''                                      --业务品种编号
   ,''                                      --业务品种名称
   ,t14.claus_val                           --征信报送业务品种代码
   ,t15.itemname                            --征信报送业务品种描述
   ,t1.cust_id                              --客户编号
   ,t1.repay_acct_id                        --还款账号
   ,t1.distr_acct_id                        --入账账号
   ,''                                      --按揭标志
   ,''                                      --不良贷款标志
   ,''                                      --违约标志
   ,decode(t6.lmt_cont_flg, '01', '1', '0') --授信额度使用标志
   ,''                                      --联保贷款标志
   ,decode(t1.repay_way_cd, '6', '1', '0')  --气球贷标志
   ,t1.level10_cls_manu_med_flg             --十级分类人工干预标志
   ,t1.advc_flg                             --保险代偿标志
   ,case
         when t12.prod_group_name = '个人经营性贷款' and t8.abs_flg = 'N' and
              (case
                when t8.accti_status_modif_dt >
                     to_date('${batch_date}', 'yyyymmdd') then
                 t8.last_accti_status_cd
                else
                 t8.accti_status_cd
              end) <> 'WRN' and t7.cust_char_cd in ('01', '02') then
          '1'
         else
          '0'
       end                                  --人行普惠贷款标志
   /*,case when t12.prod_group_name = '个人经营性贷款' and t8.abs_flg = 'N' and (case when t8.accti_status_modif_dt > to_date('${batch_date}', 'yyyymmdd')
    then t8.last_accti_status_cd else t8.accti_status_cd end) <> 'wrn' then '1'
         else '0'
    end                                     --人行普惠贷款标志      */
   ,t7.white_list_cust_flg                  --白户标志
   ,t7.farm_flg                             --农户标志
   ,decode(trim(t1.bad_debt_wrt_off_status_cd), 'Y', '1', '0')          --核销标志
   ,t1.prob_asset_flg                       --问题资产标志
   ,t1.provi_for_aged_property_flg          --养老产业标志
   ,case when t1.belong_strip_line_cd = '030' and t1.prod_id in（'201010300040','201020100060','201010300035','201020100059') then t18.due_diligence_flg else '0' end        --尽调标志
   ,case when t1.belong_strip_line_cd = '030' and t1.prod_id in（'201010300040','201020100060','201010300035','201020100059') then t18.outline_vrif_idti_flg else '0' end    --线下核身标志
   ,t1.regroup_loan_flg                     --重组贷款标志
   ,t1.regroup_loan_type_cd                 --重组贷款类型代码
   ,''                                      --产品类型代码
   ,t1.loan_distr_type_cd                   --贷款发生类型代码
   ,''                                      --贷款类型代码
   ,t1.asset_thd_cls_cd                     --资产三分类
   ,t1.main_guar_way_cd                     --担保方式代码
   ,t1.guar_way_cd_two                      --子担保方式代码
   ,t1.repay_way_cd                         --还款方式代码
   ,t6.nat_std_indus_dir_cd                 --贷款贷款贷款投向行业代码 t9.cap_dir_cd
   ,nvl(trim(t1.dubil_status_cd),'-')       --借据状态代码
   ,t1.refac_loan_idf_cd                    --支小再贷款状态代码
   ,t1.spcl_refac_idf_cd                    --专项再贷款标识代码
   ,'IT01'                                  --复利计算方式代码
   ,decode(t1.int_rat_adj_way_cd, '3', 'Y', '4', 'M', '8', 'Q', '9', 'M', 'O')      --利率调整周期单位代码
   ,case when t1.int_rat_adj_way_cd in ('3', '4', '8') then 1
         when t1.int_rat_adj_way_cd in ('9') then 6
         else 0
    end                                     --利率调整周期频率
   ,''                                      --贷款四级分类代码
   ,nvl(trim(t1.level5_cls_cd), '99')       --贷款五级分类代码
   ,nvl(trim(t1.level11_cls_cd), '99')      --贷款十级分类代码
   ,'11'                                    --贷款十二级分类代码
   ,t1.int_rat_adj_way_cd                   --利率调整方式代码
   ,t1.int_rat_float_type_cd                --利率浮动类型代码
   ,t1.ovdue_int_rat_float_way_cd           --逾期利率调整方式
   ,t1.int_rat_adj_way_cd                   --利率调整生效方式
   ,''                                      --利率浮动期限代码
   ,''                                      --入账账户支付工具类型代码
   ,''                                      --还款账户支付工具类型代码
   ,''                                      --扣款方式代码
   ,nvl(t16.distr_mode_pay_cd,t1.distr_mode_pay_cd)--支付方式代码
   ,t1.curr_cd                              --币种代码
   ,t7.cust_char_cd                         --客户性质代码
   ,0                                       --授信总额度
   ,t2.prod_name                            --贷款类型描述
   ,t1.distr_acct_name                      --入账账户名称
   ,t1.rgst_teller_id                       --客户经理编号
   ,''                                      --托管客户经理
   ,t1.rgst_teller_id                       --登记柜员编号
   ,t1.rgst_org_id                          --登记机构编号
   ,t1.accti_org_id						              --账务机构编号
   ,t1.rgst_org_id                          --管理机构编号
   ,t1.distr_dt                             --借据开立日期
   ,t1.apot_exp_dt                          --借据到期日期
   ,t1.distr_dt                             --首次放款日期
   ,''                                      --最近还款日期
   ,t1.deflt_repay_day                      --还款日
   ,t1.termnt_dt                            --结清日期
   ,t1.actl_exp_dt                          --执行到期日期
   ,t1.ovdue_dt                             --本金逾期日期
   ,t1.over_int_dt                          --利息逾期日期
   ,t1.level5_cls_dt                        --贷款五级分类日期
   ,t1.level11_cls_dt                       --贷款十级分类日期
   ,t1.last_term_level5_cls_modif_dt        --上次五级分类变更日期
   ,t11.cls_adj_rs_descb                    --上次风险登记调整原因
   ,t11.oper_teller_id                      --风险登记审批人编号
   ,t1.base_rat                             --基准利率
   ,t1.exec_year_int_rat                    --执行利率
   ,t1.ovdue_int_rat                        --逾期利率
   ,t1.ovdue_int_rat_flo_val                --逾期利率浮动值
   ,t1.int_rat_float_range                  --利率浮动值
   ,t1.loan_ovdue_days                      --本金逾期天数
   ,T1.loan_ovdue_days                      --利息逾期天数
   ,t1.loan_grace_period                    --宽限天数
   ,''                                      --宽限期开始日期
   ,''                                      --宽限期到期日期
   ,''                                      --最后一期保留金额
   ,t1.dubil_amt                            --借据金额
   ,t1.curr_bal                             --借据余额
   ,t1.ovdue_bal                            --逾期余额
   ,nvl(t1.comp_amt,0)                      --代偿金额
   ,nvl(t1.prft_cut_amt,0)                  --分润金额
   ,nvl(t17.balance,0)                      --诉讼费余额
   ,t4.batch_pkg_id                         --支小再贷款批次包编号
   ,t4.refac_exp_dt                         --支小再贷款批次到期日期
   ,t4.use_int_rat                          --支小再贷款使用利率
   ,t1.job_cd                               --任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                     --ETL处理时间戳
 from ${iml_schema}.agt_loan_dubil_info_h t1
 inner join ${iml_schema}.prd_loan_prod_info_h t2
   on nvl(trim(t1.prod_id),'-') = t2.prod_id
  and t2.crdt_prod_cate_cd in ('2', '4')
  and t2.job_cd = 'icmsf1'
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.agt_refac_dubil_pkg_rela_h t3
   on t1.dubil_id = t3.dubil_id
  and t3.in_pool_idf_cd = '1'
  and t3.job_cd = 'icmsf1'
  and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  and exists (select 1 from  ${iol_schema}.icms_zxz_iqp_loan_info ii 
               where ii.serno = t3.apv_flow_num 
                 and ii.approvestatus = 'Finished'
                 and ii.start_dt <= to_date('${batch_date}','yyyymmdd')
                 and ii.end_dt > to_date('${batch_date}','yyyymmdd'))
 left join ${iml_schema}.agt_refac_loan_batch_pkg_h t4
   on t3.batch_pkg_id = t4.batch_pkg_id
  and t4.job_cd = 'icmsf1'
  and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t4.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.agt_refac_dubil_attach_info_h t5
   on t3.dubil_id = t5.dubil_id
  and t5.job_cd = 'icmsf1'
  and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t5.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.agt_loan_cont_info_h t6
   on t1.rela_cont_id = t6.cont_id
  and t6.job_cd = 'icmsf1'
  and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t6.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h t7
   on t1.dubil_id = t7.dubil_id
  and t7.job_cd = 'icmsf1'
  and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t7.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.agt_loan_acct_info_h t8
/*   on t1.dubil_id = t8.dubil_id*/
   on t1.AGT_id = t8.AGT_id --modify by liuweiyong
  and t8.job_cd = 'ncbsf1'
  and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t8.end_dt > to_date('${batch_date}','yyyymmdd')
 /* left join ${iml_schema}.agt_loan_cont_indv_loan_attach_info_h t9
   on t6.cont_id = t9.cont_id
  and t9.job_cd = 'icmsf1'
  and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t9.end_dt > to_date('${batch_date}','yyyymmdd') */
 left join (select ca.*,
                   row_number() over(partition by ca.obj_id order by ca.idtfy_cmplt_dt desc) rn
              from ${iml_schema}.agt_loan_risk_cls_adj_h ca
             where start_dt <= to_date('${batch_date}', 'YYYYMMDD')
               and end_dt > to_date('${batch_date}', 'YYYYMMDD')
               and ca.job_cd = 'icmsf1'
               and ca.obj_type_name = 'BusinessDuebill') t11
  on t1.dubil_id = t11.obj_id
 and t11.rn = 1
 left join ${iml_schema}.prd_prod_catlg_h t12
   on nvl(trim(t1.prod_id),'-')= t12.sellbl_prod_id
  and t12.job_cd = 'ncbsf1'
  and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.prd_loan_prod_policy_edit_h t13
   on t1.prod_id= t13.prod_id
  and t13.edit_status_cd = '1'
  and t13.job_cd = 'icmsf1'
  and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.prd_loan_prod_claus_data_h t14
   on t13.edit_id= t14.edit_id
  and t14.compnt_id = 'ZHENGXIN'
  and t14.claus_id = 'creditCode'
  and t14.job_cd = 'icmsf1'
  and t14.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t14.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.icms_code_library t15
   on t14.claus_val = t15.itemno
  and t15.codeno = 'IndCreditType'
  and t15.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t15.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${iml_schema}.agt_loan_out_acct_appl_h t16
   on t1.rela_out_acct_flow_num = t16.out_acct_flow_num
  and t16.job_cd = 'icmsf1'
  and t16.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t16.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${icl_schema}.cmm_retl_loan_dubil_info_01_tmp t17
   on t1.dubil_id = t17.bdserialno
 left join ${iml_schema}.agt_loan_out_acct_indv_loan_attach_info_h t18
   on t1.rela_out_acct_flow_num = t18.out_acct_flow_num
  and t18.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t18.end_dt > to_date('${batch_date}','yyyymmdd')
  and t18.job_cd = 'icmsf1'
 left join ${iol_schema}.icms_code_library t19
    on t1.sub_prod_id = t19.itemno
   and t19.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t19.end_dt > to_date('${batch_date}','yyyymmdd')
   and t19.codeno = 'SUBPRODUCTNAME'
where t1.job_cd = 'icmsf1'
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.distr_dt<= to_date('${batch_date}','yyyymmdd')
 ;
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_retl_loan_dubil_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_retl_loan_dubil_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_retl_loan_dubil_info_ex purge;
drop table ${icl_schema}.cmm_retl_loan_dubil_info_01_tmp purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_retl_loan_dubil_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);

