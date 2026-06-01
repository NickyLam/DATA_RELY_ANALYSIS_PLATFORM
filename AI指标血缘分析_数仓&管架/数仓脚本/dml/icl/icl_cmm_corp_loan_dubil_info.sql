/*
Purpose:    共性加工层-对公贷款借据信息，对公贷款借据主表，数据全部来源于信贷系统。包括所有的对公贷款业务。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220630 icl_cmm_corp_loan_dubil_info
Createdate: 20190808
Logs:       20200110 翟若平 调整字段[还款方式代码]的取数逻辑
            20200424 周沁晖 新增字段[关联借据编号],修改[借据状态代码]的取数逻辑
            20200724 周沁晖 调整【标准产品编号】的取数逻辑
            20200828 周沁晖 增加字段【国际贸易融资业务关联编号2】
            20200901 谢  宁 增加字段【资本占有比例】
            20200909 谢  宁 增加字段【本金余额,正常余额,逾期金额,呆滞余额,呆帐余额,表内欠息余额,表外欠息余额,本金罚息,利息罚息】
            20201113 谢  宁 增加字段【支小再贷款状态代码,人行普惠金融贷款标志】
            20201217 陈伟峰 增加字段【基准利率】
            20201219 陈伟峰 增加字段【征信报送业务品种代码】、【征信报送业务品种描述】
            20201219 谢  宁 增加字段【文教健康标志】
            20210126 陈伟峰 调整基准利率加工口径
            20210118 陈伟峰 增加字段【五级分类认定日期】
            20210118 谢  宁 调整【人行普惠标志】逻辑
            20210305 陈伟峰 增加字段【支小再贷款批次包编号、支小再贷款批次到期日期、支小再贷款使用利率】
            20210316 陈伟峰 增加字段【委托支付金额】
            20210414 谢  宁 调整【人行普惠标志】取数逻辑
            20210420 陈伟峰 增加字段【靠档计息标志】
            20210519 陈伟峰 增加字段【票据编号】
            20211230 陈伟峰 增加字段【境外贷款标志】
            20220126 李森辉 增加字段【票据唯一标示编号】
            20220303 孙得鑫 增加字段【保证金子户号】
            20220419 李森辉 1、取数数据源调整，由原对公信贷系统改成新的综合信贷系统
                            2、调整字段【业务品种编号】的取数口径（置空，新信贷整合到标准产品）
            20220606 李森辉 1、置空字段【支付方式代码-MODE_PAY_CD、征信报送业务品种代码-CRDTC_SUBM_BUS_BREED_CD、征信报送业务品种描述-CRDTC_SUBM_BUS_BREED_DESCB】
                            2、增加T1表的过滤条件【SUBSTR(T1.PRODUCTID, 1, 3) NOT IN ('201', '202')】
                            3、调整T2表的关联方式【INNER JOIN -> LEFT JOIN】
		        20220701 温旺清 增加字段【账务机构编号】
			      20220711 温旺清 1、调整字段【征信报送业务品种代码、征信报送业务品种描述】的加工口径
			      20220801 温旺清 1、调整【支小再贷款使用利率】口径 EXEC_INT_RAT --》 USE_INT_RAT 使用利率
			      20220810 温旺清 1、置空字段【累计欠款期数】【逾期利息】
			      20220908 黄俊杰 1、【还款方式】t3.repay_way_cd-》nvl(trim(t3.repay_way_cd),'-')
			      20220929 温旺清 1、调整字段【放款账号、还款账号、结算账号】的加工口径
                            2、置空字段【授信额度协议编号、维护标志、签署授信合同标志、贷款类型代码、贷款种类代码、贷款期限类型代码、贷款期限分段代码、补登复核柜员编号、受益人名称、受益行行号、受益行行名、借据注销流水号、借据开立流水号、下一期还本日期、下一期还息日期、欠息天数、贷款周期、下一期还本金额、下一期还息金额、每期扣款金额、呆滞本金、呆账本金】
            20221027 温旺清 1、增加字段【同业资产唯一标识编号】
            20221103 温旺清 调整字段【收款账户名称】取数逻辑，取消从AGT_LOAN_OUT_ACCT_LMT_ATTACH_INFO_H（已下线）取数。
			      20221107 陈伟峰 1、调整prd_loan_prod_info_h表为左关联
			      20221116 陈伟峰 调整支小再贷款agt_refac_dubil_pkg_rela_h关联条件
            20221117 曹永茂 调整【核销标志】加工口径 decode(trim(t1.bad_debt_wrt_off_status_cd), '2', '1', '0') -> decode(trim(t1.bad_debt_wrt_off_status_cd), 'Y', '1', '0')
            20221124 温旺清 新增字段【代偿金额】
            20221129 陈伟峰 调整字段【欠息天数】加工逻辑
            20221228 翟若平 调整字段【账务机构编号】的加工口径
            20221228 温旺清 置空字段【信贷发放还款计划标志】
            20230109 陈伟峰 新增字段【关联业务编号】
            20230110 陈伟峰 调整【人行普惠贷款标志】加工逻辑，使用business_duebill.belongdept判断小微业务（原使用ICMS_BAP_CL_INFO.ISSMEANDRETAIL）
            20230215 温旺清 置空字段【利率调整周期频率】，借据没有利率调整周期，新信贷不迁移，新一代全部为空
            20230420 陈伟峰 新增字段【账簿类别代码、交易机构编号】
            20230619 陈伟峰 过滤开户日期大于跑批日期的数据
            20230628 徐子豪 调整字段【人行普惠贷款标志】加工逻辑
            20230720 陈伟峰 调整字段【人行普惠贷款标志】加工逻辑，使用代码判断业务范围,增加业务逻辑判断，产品203030500015，借据金额小于等于1000万，企业规模（小型或微型企业），判定为小微
            20231030 徐子豪 新增字段【借据卖出状态代码】
            20231221 饶雅   新增字段【利率浮动类型代码】
            20231226 饶雅   新增字段【重组贷款标志、重组贷款类型代码】
            20240115 饶雅   新增字段【所属业务条线代码】
            20240226 饶雅   1、新增字段 【信用证开户行编号】、
                            2、调整【承兑行行号】取数逻辑，增加icms_bp_extend_d.acceptancebank的数据
                            3、调整逻辑：调整【支小再贷款状态代码】取数逻辑，从BD_EXTEND_DETAIL.LITTLECREDITSTATUS  改为BUSINESS_DUEBILL.ZXZFLAG,信贷会同步对BUSINESS_DUEBILL.ZXZFLAG刷数，使两者数据保持一致。
                            4、调整该字段代码引用，从CD2228支小再贷款状态代码调整成CD2829支小再贷款标识代码
            20240329 饶雅  新增字段【置换旧债标志】
            20240507 饶雅  修改利率浮动类型代码的逻辑，引用BP_EXTEND_D.RATESTARTMODE
            20240527 饶雅  新增字段 【登记日期】、【更新日期】
            20240627 饶雅  新增字段 【诉讼费余额】
            20240813 陈伟峰 新增字段【代理交单标志】
            20240828 陈伟峰 新增字段【问题资产标志】
            20241012 陈伟峰 新增字段【超短贷标志】
            20241113 谢  宁 新增字段【分润金额】
            20241218 陈伟峰 增加票据唯一标识号唯一性检查
            20241225 陈伟峰 调整【人行普惠贷款标志】加工逻辑，增加203030500001产品判断，
                            调整产品203030500015部分判断逻辑
			      20250407 陈  凭 新增字段【质押类型代码】
			      20250428 陈  凭 新增字段【绿色信贷客户标志、绿色信贷分类_旧版代码、绿色信贷分类_新版代码】
			      20250530 陈  凭 调整【绿色信贷分类_新版代码】、【绿色信贷分类_旧版代码】取值规则，取客户维度数据
			      20250708 陈伟峰 调整【借据开立日期】加工逻辑，取登记日期做补充
			      20250709 陈伟峰 增加同业唯一标识重复检查
		          20250919 谢  宁 新增字段【承兑汇票手续费金额】
			      20250919 谢  宁 新增字段【子产品名称】
			      20251023 谢  宁 新增字段【信用证开证行名称】
			      20251107 陈伟峰 新增字段【贷款使用备注】、【结清类型代码】
			      20260402 陈  凭 新增字段【专项再贷款标识代码】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_loan_dubil_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_corp_loan_dubil_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_corp_loan_dubil_info_ex purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_dubil_info_06 purge;
drop table ${icl_schema}.cmm_corp_loan_dubil_info_01_tmp purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_dubil_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_corp_loan_dubil_info where 0=1
;
commit;


create table  ${icl_schema}.tmp_cmm_corp_loan_dubil_info_06
nologging
compress ${option_switch} for query high
as
select t1.objectno
       ,t1.classifydate
       ,t1.inputdate
from (select cr.objectno as objectno,
             cr.finishdate as classifydate,
             cr.inputdate,
             row_number() over(partition by cr.objectno order by cr.serialno desc) as rn
        from ${iol_schema}.icms_classify_record cr
       where cr.inputdate =
       (select max(t.inputdate)
          from ${iol_schema}.icms_classify_record t
         where t.objecttype in ('AutoClassify', 'BusinessContract')
           and cr.objectno = t.objectno
           and t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and t.end_dt > to_date('${batch_date}', 'yyyymmdd'))
         and cr.start_dt <= to_date('${batch_date}', 'yyyymmdd')
         and cr.end_dt > to_date('${batch_date}', 'yyyymmdd')) t1
where t1.rn=1
;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_dubil_info_01_tmp
nologging
compress ${option_switch} for query high
as select bdserialno,
       sum(balance) as balance --诉讼费余额
from ${iol_schema}.icms_substitute_lawsuit_bill
where start_dt <= to_date('${batch_date}', 'yyyymmdd')
and end_dt > to_date('${batch_date}', 'yyyymmdd')
group by bdserialno
;
commit;

-- 第一组（共一组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_loan_dubil_info_ex(
       etl_dt                         -- 数据日期
       ,lp_id                         -- 法人编号
       ,dubil_id                      -- 借据编号
       ,cont_id                       -- 合同编号
       ,std_prod_id                   -- 标准产品编号
	     ,sub_prod_id                   -- 子产品编号
	     ,sub_prod_name                 -- 子产品名称
       ,out_acct_flow_num             -- 出账流水号
       ,rela_dubil_id                 -- 关联借据编号
       ,rela_bus_id                   -- 关联业务编号
       ,intnl_trad_fin_rela_id_2      -- 国际贸易融资业务关联编号2
       ,bill_num                      -- 票据号码
       ,bill_id                       -- 票据编号
       ,bill_uniq_mark_id             -- 票据唯一标示号
       ,ibank_asset_uniq_idf_id       -- 同业资产唯一标识编号
       ,cust_id                       -- 客户编号
       ,host_cust_id                  -- 主机客户编号
       ,distr_acct_num                -- 放款账号
       ,repay_num                     -- 还款账号
       ,secd_repay_num                -- 第二还款账号
       ,stl_acct_num                  -- 结算帐号
       ,manu_cont_id                  -- 人工合同编号
       ,crdt_lmt_agt_id               -- 授信额度协议编号
       ,advc_flg                      -- 垫款标志
       ,pre_recv_int_flg              -- 预收息标志
       ,attach_rgst_dubil_flg         -- 补登借据标志
       ,matn_flg                      -- 维护标志
       ,wrt_off_flg                   -- 核销标志
       ,comp_int_flg                  -- 复息标志
       ,stop_accr_int_flg             -- 停息标志
       ,sign_crdt_cont_flg            -- 签署授信合同标志
       ,pric_auto_rtn_flg             -- 本金自动归还标志
       ,int_auto_rtn_flg              -- 利息自动归还标志
       ,crdt_distr_repay_plan_flg     -- 信贷发放还款计划标志
       ,edu_hea_flg                   -- 文教健康标志
       ,pbc_inc_loan_flg              -- 人行普惠贷款标志
       ,file_int_accr_flg             -- 靠档计息标志
       ,overs_loan_flg                -- 境外贷款标志
       ,repl_old_bond_flg             -- 置换旧债标志
       ,agent_present_flg             -- 代理交单标志
       ,prob_asset_flg                -- 问题资产标志
       ,cdd_flg                       -- 超短贷标志
       ,bus_breed_id                  -- 业务品种编号
       ,dubil_status_cd               -- 借据状态代码
       ,refac_loan_status_cd          -- 支小再贷款状态代码
       ,spcl_refac_idf_cd             -- 专项再贷款标识代码
       ,loan_happ_type_cd             -- 贷款发生类型代码
       ,mode_pay_cd                   -- 支付方式代码
       ,curr_cd                       -- 币种代码
       ,int_accr_way_cd               -- 计息方式代码
       ,loan_type_cd                  -- 贷款类型代码
       ,asset_thd_cls_cd              -- 资产三分类代码
       ,loan_level4_cls_cd            -- 贷款四级分类代码
       ,loan_level5_cls_cd            -- 贷款五级分类代码
       ,loan_level10_cls_cd           -- 贷款十级分类代码
       ,loan_level12_cls_cd           -- 贷款十二级分类代码
       ,repay_way_cd                  -- 还款方式代码
       ,dir_indus_cd                  -- 贷款贷款贷款投向行业代码
       ,guar_way_cd                   -- 担保方式代码
       ,loan_kind_cd                  -- 贷款种类代码
       ,wrtoff_type_cd                -- 注销类型代码
       ,loan_tenor_type_cd            -- 贷款期限类型代码
       ,loan_tenor_seg_cd             -- 贷款期限分段代码
       ,bill_kind_cd                  -- 票据种类代码
       ,bill_med_cd                   -- 票据介质代码
       ,belong_bus_strip_line_cd      -- 所属业务条线代码
       ,data_src_flg                  -- 数据来源标志
       ,regroup_loan_flg              -- 重组贷款标志
       ,regroup_loan_type_cd          -- 重组贷款类型代码
       ,int_rat_adj_way_cd            -- 利率调整方式代码
       ,int_rat_float_type_cd         -- 利率浮动类型代码
       ,col_int_type_cd               -- 收息类型代码
       ,int_rat_adj_ped_corp_cd       -- 利率调整周期单位代码
       ,int_rat_adj_ped_freq          -- 利率调整周期频率
       ,inst_loan_repay_way_cd        -- 分期贷款还款方式代码
       ,money_use_type_cd             -- 款项使用类型代码
       ,crdtc_subm_bus_breed_cd       -- 征信报送业务品种代码
       ,crdtc_subm_bus_breed_descb    -- 征信报送业务品种描述
       ,loan_use_remark               -- 贷款使用备注
       ,acct_b_cate_cd                -- 账簿类别代码
       ,dubil_sell_status_cd          -- 借据卖出状态代码
	     ,inpwn_type_cd                 -- 质押类型代码
	     ,green_crdt_cust_flg           -- 绿色信贷客户标志
       ,green_crdt_cls_cd             -- 绿色信贷分类_旧版代码
       ,green_crdt_cls_new            -- 绿色信贷分类_新版代码
       ,payoff_type_cd                -- 结清类型代码	
       ,org_id                        -- 机构编号
	     ,acct_instit_id                -- 账务机构编号
       ,oper_org_id                   -- 经办机构编号
       ,oper_teller_id                -- 经办柜员编号
       ,rgst_org_id                   -- 登记机构编号
       ,rgst_teller_id                -- 登记柜员编号
       ,rgst_dt                       -- 登记日期
       ,attach_rgst_check_teller_id   -- 补登复核柜员编号
       ,tran_org_id                   -- 交易机构编号
       ,benefc_name                   -- 受益人名称
       ,bnft_bk_no                    -- 受益行行号
       ,bnft_bk_name                  -- 受益行行名
       ,acpt_bank_no                  -- 承兑行行号
       ,acpt_bank_name                -- 承兑行名称
       ,lc_open_bank_id               -- 信用证开户行编号
	     ,lc_open_bank_name             -- 信用证开证行名称
       ,margin_acct_num               -- 保证金账号
       ,margin_sub_acct_num           -- 保证金子户号
       ,margin_curr_cd                -- 保证金币种代码
       ,margin_amt                    -- 保证金金额
       ,margin_ratio                  -- 保证金比例
       ,refac_loan_batch_pkg_id       -- 支小再贷款批次包编号
       ,refac_loan_batch_exp_dt       -- 支小再贷款批次到期日期
       ,refac_loan_use_int_rat        -- 支小再贷款使用利率
       ,dubil_wrtoff_flow_num         -- 借据注销流水号
       ,dubil_open_flow_num           -- 借据开立流水号
       ,dubil_open_dt                 -- 借据开立日期
       ,distr_dt                      -- 放款日期
       ,apot_exp_dt                   -- 约定到期日期
       ,exec_exp_dt                   -- 执行到期日期
       ,next_int_set_dt               -- 下次结息日期
       ,loan_cls_dt                   -- 贷款分类日期
       ,level5_cls_idtfy_dt           -- 五级分类认定日期
       ,next_term_rpp_dt              -- 下一期还本日期
       ,next_term_repay_int_dt        -- 下一期还息日期
       ,payoff_dt                     -- 结清日期
       ,ovdue_dt                      -- 逾期日期
       ,over_int_dt                   -- 欠息日期
       ,ovdue_days                    -- 贷款贷款逾期天数
       ,over_int_days                 -- 欠息天数
       ,loan_ped                      -- 贷款周期
       ,inst_loan_tot_perds           -- 贷款期数
       ,surp_perds                    -- 剩余期数
       ,acm_debt_perds                -- 累计欠款期数
       ,base_rat                      -- 基准利率
       ,exec_int_rat                  -- 执行利率
       ,ovdue_int_rat                 -- 逾期利率
       ,comm_fee_fee_rat              -- 手续费费率
       ,next_term_rpp_amt             -- 下一期还本金额
       ,next_term_repay_int_amt       -- 下一期还息金额
       ,repay_num_bal                 -- 还款账号余额
       ,repay_num_aval_bal            -- 还款账号可用余额
       ,eh_issue_deduct_amt           -- 每期扣款金额
       ,entr_pay_amt                  -- 委托支付金额
	     ,comp_amt                      -- 代偿金额
	     ,prft_cut_amt                  -- 分润金额
	     ,suit_fee_bal                  -- 诉讼费余额
	     ,accpt_bil_comm_fee_amt	      -- 承兑汇票手续费金额
       ,ovdue_int                     -- 逾期利息
       ,dubil_amt                     -- 借据金额
       ,dubil_bal                     -- 借据余额
       ,nomal_pric                    -- 正常本金
       ,ovdue_pric                    -- 逾期本金
       ,idle_pric                     -- 呆滞本金
       ,bad_debt_pric                 -- 呆账本金
       ,in_bs_over_int_bal            -- 表内欠息余额
       ,off_bs_over_int_bal           -- 表外欠息余额
       ,pric_pnlt                     -- 本金罚息
       ,int_pnlt                      -- 利息罚息
       ,cap_ratio                     -- 资本占有比例
       ,recvbl_acct_name              -- 收款账户名称
       ,recvbl_bank_name              -- 收款银行名称
       ,update_dt                     -- 更新日期
       ,job_cd                        -- 任务代码
       ,etl_timestamp                 -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                        -- 数据日期
       ,t1.lp_id                                                                                  -- 法人编号
       ,t1.dubil_id                                                                               -- 借据编号
       ,t1.rela_cont_id                                                                           -- 合同编号
       ,t1.prod_id                                                                                -- 标准产品编号
	     ,t1.sub_prod_id                                                                            -- 子产品编号
	     ,t30.itemname                                                                              -- 子产品名称
       ,t1.rela_out_acct_flow_num                                                                 -- 出账流水号
       ,t1.init_dubil_id                                                                          -- 关联借据编号
       ,t1.init_bus_id                                                                            -- 关联业务编号
       ,t4.trade_fin_bus_id_two                                                                   -- 国际贸易融资业务关联编号2
       ,coalesce(trim(t5.bill_id),trim(t4.intstl_bus_id),trim(t4.trade_fin_bus_id_one))           -- 票据号码
       ,t5.bill_uniq_ind_no                                                                       -- 票据编号
       ,t4.bill_uniq_ind_no                                                                       -- 票据唯一标示号
       ,t5.asset_id                                                                               -- 同业资产唯一标识编号
       ,t1.cust_id                                                                                -- 客户编号
       ,t1.cust_id                                                                                -- 主机客户编号
       ,t1.distr_acct_id                                                                          -- 放款账号
       ,t1.repay_acct_id                                                                          -- 还款账号
       ,t3.secd_repay_acct_id                                                                     -- 第二还款账号
       ,t1.repay_acct_id                                                                          -- 结算帐号
       ,t3.text_cont_id                                                                           -- 人工合同编号
       ,''                                                                                        -- 授信额度协议编号
       ,nvl(decode(trim(t1.advc_flg),'-','0',t1.advc_flg),'0')                                -- 垫款标志
       ,nvl(trim(t5.pre_recv_int_flg ),'0')                                                     -- 预收息标志
       ,nvl(trim(t5.attach_rgst_dubil_flg),'0')                                                 -- 补登借据标志
       ,''                                                                                        -- 维护标志
       ,decode(trim(t1.bad_debt_wrt_off_status_cd), 'Y', '1', '0')                             -- 核销标志
       ,nvl(trim(t4.coll_comp_int_flg),'0')                                                     -- 复息标志
       ,nvl(trim(t4.stop_accr_int_flg),'0')                                                     -- 停息标志
       ,''                                                                                        -- 签署授信合同标志
       ,nvl(trim(t4.pric_auto_rtn_flg),'0')                                                     -- 本金自动归还标志
       ,nvl(trim(t4.int_auto_rtn_flg),'0')                                                      -- 利息自动归还标志
       ,''                                                                                        -- 信贷发放还款计划标志
       ,nvl(trim(t5.edu_hea_flg),'0')                                                           -- 文教健康标志
       ,case when t14.cust_id is not null and t14.nmal_amt <= 10000000 -- 客户授信总额小于等于1000万
              and t16.prod_gen_id||t16.prod_sclass_id  in ('203','204') -- 业务范围'一般性公司贷款', '票据融资'
             then (case when t15.corp_size_cd in ('3', '4') then '1'  -- 企业规模（小型或微型企业）
                        when t18.belong_indus_acct like 'P%' then '1' -- 客户所属行业门类：“教育”
                    else '0' end )
             when t1.prod_id ='203030500015' and t1.dubil_amt <=10000000 and t15.corp_size_cd in ('3', '4') then '1'
             when t1.prod_id ='203030500001' and t24.sum_curr_bal <=10000000 and t15.corp_size_cd in ('3', '4') then '1'   --兴链贷 1、【贸易融资项下兴链贷业务（可售产品编号：203030500001）】2、 按客户汇总借据余额小于等于1000万 3、【企业规模（小型或微型企业）】。
             else '0' end                                                                        -- 人行普惠贷款标志
       ,coalesce(trim(t4.file_int_flg), t13_1.file_int_flg, '0')                               -- 靠档计息标志
       ,t13.overs_loan_flg                                                                        -- 境外贷款标志
       ,t4.repl_old_bond_flg                                                                      -- 置换旧债标志
       ,t4.agent_present_flg                                                                      -- 代理交单标志
       ,t1.prob_asset_flg                                                                         -- 问题资产标志
       ,nvl(t23.tagvalue,'-')                                                                     -- 超短贷标志
       ,''                                                                                        -- 业务品种编号
       ,nvl(trim(t1.dubil_status_cd),'-')                                                         -- 借据状态代码
       ,t1.refac_loan_idf_cd                                                                      -- 支小再贷款状态代码
       ,t1.spcl_refac_idf_cd                                                                      -- 专项再贷款标识代码
       ,nvl(trim(t7.loan_distr_type_cd),'-')                                                      -- 贷款发生类型代码
       ,''                                                                                        -- 支付方式代码
       ,t1.curr_cd                                                                                -- 币种代码
       ,t5.int_accr_way_cd                                                                        -- 计息方式代码
       ,''                                                                                        -- 贷款类型代码
       ,nvl(trim(t1.asset_thd_cls_cd),'XXX')                                                      -- 资产三分类代码
       ,'01'                                                                                      -- 贷款四级分类代码
       ,nvl(trim(t1.level5_cls_cd), '99')                                                         -- 贷款五级分类代码
       ,nvl(trim(t1.level11_cls_cd), '99')                                                        -- 贷款十级分类代码
       ,'11'                                                                                      -- 贷款十二级分类代码
       ,nvl(trim(t3.repay_way_cd),'-')                                                            -- 还款方式代码
       ,t7.nat_std_indus_dir_cd                                                                   -- 贷款贷款贷款投向行业代码
       ,t7.main_guar_way_cd                                                                       -- 担保方式代码
       ,''                                                                                        -- 贷款种类代码
       ,t5.wrtoff_type_cd                                                                         -- 注销类型代码
       ,''                                                                                        -- 贷款期限类型代码
       ,''                                                                                        -- 贷款期限分段代码
       ,nvl(trim(t5.bill_type_cd),'-')                                                            -- 票据种类代码
       ,nvl(trim(t5.bill_kind_cd),'-')                                                            -- 票据介质代码
       ,nvl(trim(t1.belong_strip_line_cd),'-')                                                    -- 所属条线代码
       ,nvl(trim(t5.batch_data_src_cd),'-')                                                       -- 数据来源标志
       ,t1.regroup_loan_flg                                                                       -- 重组贷款标志
       ,t1.regroup_loan_type_cd                                                                   -- 重组贷款类型代码
       ,t1.int_rat_adj_way_cd                                                                     -- 利率调整方式代码
       ,t4.int_rat_start_use_way_cd                                                               -- 利率浮动类型代码
       ,nvl(trim(t3.int_accr_way_cd),'IP000')                                                     -- 收息类型代码
       ,t1.int_rat_adj_ped_cd                                                                     -- 利率调整周期单位代码，decode(t2.int_rat_reval_cd, 'RP001', 'O', 'RP002', 'D', 'RP003', 'Y', 'RP004', 'Y', 'RP005', 'O', 'RP006', 'M', 'RP007', 'Q', 'RP008', 'M', 'RP009', 'M', 'RP010', 'M', 'RP011', 'Q', 'RP012', 'M', 'RP013', 'Y','O')
       ,''                                                                                        -- 利率调整周期频率
       ,nvl(trim(t1.repay_way_cd),'-')                                                            -- 分期贷款还款方式代码
       ,nvl(trim(t3.distr_mode_pay_cd),'-')                                                       -- 款项使用类型代码
       ,t2.bus_breed_cd                                                                           -- 征信报送业务品种代码
       ,t11.cd_descb                                                                              -- 征信报送业务品种描述
       ,t25.servicecontent                                                                        -- 贷款使用备注
       ,t5.acct_b_cate_cd                                                                         -- 账簿类别代码
       ,nvl(trim(t5.sell_status_cd),'-')                                                          -- 借据卖出状态代码
       ,nvl(trim(t25.pledgetype),'-')                                                             -- 质押类型代码
	   ,decode(t27.itemname, '是', '1', '否','0','-')                                               -- 绿色信贷客户标志
       ,case when t27.itemname= '是' then t28.tagvalue else '' end                                -- 绿色信贷分类_旧版代码
       ,case when t27.itemname= '是' then t29.tagvalue else '' end                                -- 绿色信贷分类_新版代码
       ,t32.finishtype                                                                            -- 结清类型代码
       ,t1.accti_org_id                                                                           -- 机构编号
	   ,t1.accti_org_id																	                                            -- 账务机构编号
       ,t1.oper_org_id                                                                            -- 经办机构编号
       ,t1.bus_oper_teller_id                                                                     -- 经办柜员编号
       ,t1.rgst_org_id                                                                            -- 登记机构编号
       ,t1.rgst_teller_id                                                                         -- 登记柜员编号
       ,t1.rgst_dt                                                                                -- 登记日期
       ,''                                                                                        -- 补登复核柜员编号
       ,t5.tran_org_id                                                                            -- 交易机构编号
       ,''                                                                                        -- 受益人名称
       ,''                                                                                        -- 受益行行号
       ,''                                                                                        -- 受益行行名
       ,nvl(t5.acpt_bank_no,t4.fft_acpt_bank_no)                                                  -- 承兑行行号
       ,t5.acpt_bank_name                                                                         -- 承兑行名称
       ,t4.exp_lc_issue_bank_name                                                                 -- 信用证开户行编号
	   ,t31.bank_name                                                                               -- 信用证开证行名称
       ,t3.margin_acct_id                                                                         -- 保证金账号
       ,t3.margin_sub_acct_num                                                                    -- 保证金子户号
       ,nvl(trim(t3.margin_curr_cd),'CNY')                                                        -- 保证金币种代码
       ,nvl(t3.margin_amt,0.00)                                                                   -- 保证金金额
       ,nvl(t3.margin_ratio,0.00)                                                                 -- 保证金比例
       ,t9.batch_pkg_id                                                                           -- 支小再贷款批次包编号
       ,t9.refac_exp_dt                                                                           -- 支小再贷款批次到期日期
       ,t9.use_int_rat                                                                            -- 支小再贷款使用利率
       ,''                                                                                        -- 借据注销流水号
       ,''                                                                                        -- 借据开立流水号
       ,case when t5.open_dt is not null and t5.open_dt<> to_date('00010101','yyyymmdd') 
              then t5.open_dt
              else  t1.rgst_dt end                                                                -- 借据开立日期
       ,t1.distr_dt                                                                               -- 放款日期
       ,t1.apot_exp_dt                                                                            -- 约定到期日期
       ,t1.actl_exp_dt                                                                            -- 执行到期日期
       ,t1.next_int_set_dt                                                                        -- 下次结息日期
       ,t1.level5_cls_dt                                                                          -- 贷款分类日期
       ,t1.level5_cls_dt                                                                          -- 五级分类认定日期
       /*,nvl(case when t21.classifydate = to_date('00010101', 'yyyymmdd')  then decode(t21.inputdate, to_date('00010101', 'yyyymmdd'), to_date('29991231', 'yyyymmdd'), t21.inputdate)
                 else nvl(t21.classifydate, t1.level5_cls_dt)
             end, t1.distr_dt) as level5_cls_idtfy_dt */                                          -- 五级分类认定日期
       ,null                                                                                      -- 下一期还本日期
       ,null                                                                                      -- 下一期还息日期
       ,t1.termnt_dt                                                                              -- 结清日期
       ,t1.ovdue_dt                                                                               -- 逾期日期
       ,t1.over_int_dt                                                                            -- 欠息日期
       ,t1.loan_ovdue_days                                                                        -- 贷款贷款逾期天数
       ,t1.over_int_days                                                                          -- 欠息天数
       ,null                                                                                      -- 贷款周期
       ,nvl(t4.inst_loan_tot_perds,0)                                                             -- 贷款期数
       ,null                                                                                      -- 剩余期数
       ,null                                                                                      -- 累计欠款期数
       ,t1.base_rat                                                                               -- 基准利率
       ,t1.exec_year_int_rat                                                                      -- 执行利率
       ,t1.ovdue_int_rat                                                                          -- 逾期利率
       ,t5.fee_rat                                                                                -- 手续费费率
       ,0                                                                                         -- 下一期还本金额
       ,0                                                                                         -- 下一期还息金额
--       ,t5.repay_num_bal                                                                        -- 还款账号余额
--       ,t5.repay_num_aval_bal                                                                   -- 还款账号可用余额
       ,t1.repay_num_bal                                                                          -- 还款账号余额
       ,t1.repay_num_aval_bal                                                                     -- 还款账号可用余额
       ,0                                                                                         -- 每期扣款金额
       ,t3.entr_pay_amt                                                                           -- 委托支付金额
	   ,t1.repay_num_aval_bal                                                                       -- 代偿金额
	   ,nvl(t1.prft_cut_amt,0)                                                                      -- 分润金额
	   ,nvl(t22.balance,0)                                                                          -- 诉讼费余额
	   ,nvl(t4.accpt_bil_comm_fee_amt,0)                                                            -- 承兑汇票手续费金额
       ,''                                                                                        -- 逾期利息
       ,t1.dubil_amt                                                                              -- 借据金额
       ,t1.curr_bal                                                                               -- 借据余额
       ,t1.nomal_bal                                                                              -- 正常本金
       ,t1.ovdue_bal                                                                              -- 逾期本金
       ,0                                                                                         -- 呆滞本金
       ,0                                                                                         -- 呆账本金
       ,t1.in_bs_over_int_bal                                                                     -- 表内欠息余额
       ,t1.off_bs_over_int_bal                                                                    -- 表外欠息余额
       ,t1.ovdue_pnlt_bal                                                                         -- 本金罚息
       ,t1.comp_int_bal                                                                           -- 利息罚息
       ,''                                                                                        -- 资本占有比例
       ,nvl(trim(t4.accept_ps_name),trim(t10.recvbl_acct_name))                                   -- 收款账户名称
       ,t4.recver_open_bank_name                                                                  -- 收款银行名称
       ,t1.modif_dt
       ,t1.job_cd                                                                                 -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                           -- 处理日期
  from ${iml_schema}.agt_loan_dubil_info_h t1
  left join ${iml_schema}.prd_loan_prod_info_h t2
    on nvl(trim(t1.prod_id),'-') = t2.prod_id
   and t2.crdt_prod_cate_cd not in ('2','3','4')   -- 零售贷款,联合网贷,个人委托贷款
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_out_acct_appl_h t3
    on t1.rela_out_acct_flow_num = t3.out_acct_flow_num
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h t4
    on t1.rela_out_acct_flow_num = t4.out_acct_flow_num
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_dubil_non_retl_attach_info_h t5
    on t1.agt_id = t5.agt_id
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   and t5.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_cont_info_h t7
    on t1.rela_cont_id = t7.cont_id
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'icmsf1'
  left join (select dubil_id,batch_pkg_id,row_number() over(partition by dubil_id order by batch_pkg_id desc) as rn
               from ${iml_schema}.agt_refac_dubil_pkg_rela_h
              where start_dt <= to_date('${batch_date}','yyyymmdd')
                and end_dt > to_date('${batch_date}','yyyymmdd')
                and job_cd = 'icmsf1') t8
    on t1.dubil_id = t8.dubil_id
   and t8.rn=1
  left join ${iml_schema}.agt_refac_loan_batch_pkg_h t9
    on t8.batch_pkg_id = t9.batch_pkg_id
   and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t9.end_dt > to_date('${batch_date}','yyyymmdd')
   and t9.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h t10
    on t1.rela_out_acct_flow_num = t10.out_acct_flow_num
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'icmsf1'
  left join ${iml_schema}.ref_pub_cd t11
    on t2.bus_breed_cd = t11.cd_val
   and t11.cd_id = 'CD2815'
   and t11.valid_flg = 'Y'
  left join ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h t13
    on t1.rela_cont_id = t13.cont_id
   and t13.job_cd = 'icmsf1'
   and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h t13_1
    on t1.rela_out_acct_flow_num = t13_1.out_acct_flow_num
   and t13_1.job_cd = 'icmsf1'
   and t13_1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t13_1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select t1.cust_id,sum(t1.nmal_amt) as nmal_amt
             from (
             select t1.cust_id,sum(t1.crdt_lmt) as nmal_amt
               from ${iml_schema}.agt_wyd_lmt_h t1
               left join ${iml_schema}.agt_wyd_out_acct_appl t2
                 on t1.cust_id = t2.cust_id
                and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
              where t1.lmt_status_cd = '2'
                and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
              group by t1.cust_id
             union all
              select cust_id, sum(nmal_amt) as nmal_amt
               from ${iml_schema}.agt_crdt_lmt_info_h
              where lmt_prod_id not in '10000000001' --去掉单一最高授信额度
                and (status_cd = 'Effective' or crdt_nmal_bal > 0) --额度有效或有余额
                and substr(lmt_prod_id, 1, 7) = '1000101' --公司客户自用额度
                and job_cd = 'icmsf1'
                and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
              group by cust_id
			       ) t1 group by t1.cust_id
			) t14
    on t1.cust_id = t14.cust_id
  left join ${iml_schema}.pty_corp_cust t15
    on t1.cust_id = t15.cust_id
   and t15.job_cd = 'icmsf1'
   and t15.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t15.id_mark <> 'D'
  left join ${iml_schema}.prd_prod_catlg_h t16
    on nvl(trim(t1.prod_id),'-')= t16.sellbl_prod_id
   and t16.job_cd = 'ncbsf1'
   and t16.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t16.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.pty_party_name_h t17
    on t1.cust_id = t17.party_id
   and party_name_type_cd in ('01','02')
   and t17.job_cd = 'icmsf1'
   and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select t1.cust_num,t2.belong_indus_acct
               from ${iol_schema}.eifs_t00_party_pub_info t1
               left join ${iol_schema}.eifs_t01_corp_cust_info t2 on t1.party_id = t2.party_id
                     and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                     and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
                     and to_date(to_char(t2.updated_ts,'yyyymmdd'),'yyyymmdd')> to_date('${batch_date}','yyyymmdd')
              where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
            ) t18 on t1.cust_id = t18.cust_num
/*  left join(select t.cust_id,
                   row_number() over(partition by t.cust_id order by t.appl_flow_num desc) as rn
             from iml.agt_loan_appl_basic_info_h t
            inner join iml.agt_loan_apv_lmt_attach_info_h tt
               on t.appl_flow_num = tt.apv_flow_num
            where tt.sm_retl_flg = '1'
              and tt.job_cd = 'icmsf1'
              and t.job_cd = 'icmsf1'
              and t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and t.end_dt > to_date('${batch_date}', 'yyyymmdd')
              and tt.start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and tt.end_dt > to_date('${batch_date}', 'yyyymmdd')) t18
    on t1.cust_id = t18.cust_id
   and t18.rn =1   */
  left join ${icl_schema}.tmp_cmm_corp_loan_dubil_info_06 t21
    on t21.objectno = t1.rela_cont_id
  left join ${icl_schema}.cmm_corp_loan_dubil_info_01_tmp t22
    on t22.bdserialno = t1.dubil_id
  left join ${iol_schema}.icms_tag_term_final_data t23
    on t1.dubil_id = t23.objectno
   and t23.taghirearchy = '60'
   and t23.tagid = '2024101811000001'
   and t23.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t23.end_dt >to_date('${batch_date}','yyyymmdd')
  left join (select cust_id, sum(curr_bal) as sum_curr_bal
               from ${iml_schema}.agt_loan_dubil_info_h
              where job_cd = 'icmsf1'
                and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and prod_id ='203030500001'
              group by cust_id) t24
    on t1.cust_id = t24.cust_id
  left join ${iol_schema}.icms_bp_extend_d t25
    on t1.rela_out_acct_flow_num = t25.serialno
   and t25.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t25.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.icms_tag_term_final_data t26
    on t1.dubil_id = t26.objectno
   and t26.taghirearchy = '60'
   and t26.tagid= '2024111800000003'
   and t26.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t26.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.icms_tag_code_config t27
    on t27.tagid = t26.tagid
   and t27.itemno = t26.tagvalue
   and t27.etl_dt = to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.icms_tag_term_final_data t28
    on t1.cust_id = t28.objectno
   and t28.taghirearchy = '10'
   and t28.tagid= '2025041410000004'
   and t28.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t28.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.icms_tag_term_final_data t29
    on t1.cust_id = t29.objectno
   and t29.taghirearchy = '10'
   and t29.tagid= '2025041410000005'
   and t29.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t29.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.icms_code_library t30
    on t1.sub_prod_id = t30.itemno
   and t30.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t30.end_dt > to_date('${batch_date}','yyyymmdd')
   and t30.CODENO = 'SUBPRODUCTNAME'
  left join (select t.*,row_number() over(partition by bank_no order by effect_date desc) as rn
                  from ${iol_schema}.icms_union_bank_hxty t
                  where start_dt <= to_date('${batch_date}','yyyymmdd')
                    and end_dt > to_date('${batch_date}','yyyymmdd')) t31
    on t4.exp_lc_issue_bank_name = t31.bank_no
   and t31.rn=1
left join  ${iol_schema}.icms_business_duebill t32
    on t1.dubil_id = t32.serialno
   and t32.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t32.end_dt > to_date('${batch_date}','yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
   and (t2.prod_id is not null or trim(t1.prod_id) is null)
   and t1.distr_dt<= to_date('${batch_date}','yyyymmdd')
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_loan_dubil_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_loan_dubil_info_ex;

-- 3.1 票据唯一标识号唯一性检查
whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${icl_schema}.cmm_corp_loan_dubil_info
  	                                where etl_dt= to_date('${batch_date}','yyyymmdd')
  	                                  and trim(bill_uniq_mark_id) is not null
  	                                group by bill_uniq_mark_id
  	                               having count(1) > 1);
    if cnt = 0
      then
        continue;
      else
        raise_application_error(-20001,'bill_uniq_mark_id primary key is duplication');
    end if;
  end loop;
end;
/

-- 3.2 同业唯一标识号唯一性检查
whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${icl_schema}.cmm_corp_loan_dubil_info
  	                                where etl_dt= to_date('${batch_date}','yyyymmdd')
  	                                  and trim(ibank_asset_uniq_idf_id) is not null
  	                                group by ibank_asset_uniq_idf_id
  	                               having count(1) > 1);
    if cnt = 0
      then
        continue;
      else
        raise_application_error(-20001,'ibank_asset_uniq_idf_id primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_corp_loan_dubil_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
