/*
Purpose:    共性加工层-同业金融工具表:数据来源于同业系统（IBMS）,包括所有同业系统所有的可投资的金融工具
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py 20210713 icl_cmm_ibank_fin_instm
Createdate: 20191025
Logs:
            20191220 翟若平 调整付息周期代码的取数逻辑pay_int_ped_corp_cd -> pay_int_ped_freq || pay_int_ped_corp_cd
            20200327 翟若平 增加字段[标准产品编号]
            20200627 周沁晖 调整【发行人机构编号】取数逻辑
            20210612 陈伟峰 增加字段【特定目的载体类型代码、特定目的载体编码、资管产品统计编码、发行人编号、发行人地区代码、运行方式代码】
            20210619 陈伟峰 增加字段【管理人编号、管理人名称、非底层资产分类代码、非底层资产细类代码】
            20210621 陈伟峰 增加字段【基金开放日期、管理模式代码、实际融资人客户编号、实际融资人名称、实际融资人集团名称】、
                            调整字段【管理人编号、管理人名称】的取数口径
                            增加字段【缓释录入频率代码、缓释生效日期、缓释到期日期、保证金缓释比例、我行存单缓释比例、国债缓释比例、我国政策性银行债券缓释比例、我国商业银行缓释比例、我国公共部门缓释比例、其他缓释比例、缓释品描述信息、缓释账户编号、缓释账户余额】
            20210626 陈伟峰 增加字段【发行人客户编号、管理人客户编号】、调整字段【票面利率】的取数口径
            20210706 何桐金 增加字段【定开期限开始日期、定开期限结束日期】
            20210708 何桐金 调整T15表过滤条件，增加int_rat_flow_id = (select t.cash_accid from ttrd_acc_cash_ext_map t where t.cash_ext_accid = '3080');
            20210721 陈伟峰 调整【缓释生效日期】取数逻辑，''-> to_date(trim(t8.start_date),'yyyy-mm-dd')
            20211021 何桐金 调整字段【管理模式代码】的取数逻辑
            20211227 陈伟峰 调整字段【管理人客户编号】的取数逻辑
                            新增字段【定开标志、定开周期代码、开放类型代码、用途描述、担保方式组合】
                            调整字段【定开标志】逻辑，decode(t17.open_type,'2','0','1') ->decode(t17.open_type,'2','1','0')
            20220126 李森辉 增加字段【信贷类项目标志】
            20220307 陈伟峰 调整字段【风险权重】加工逻辑
            20220402 陈伟峰 新增字段【增信方式代码、增信主体名称、源付息周期代码、含权标志、利率调整周期频率、利率调整周期单位代码】
                            调整字段【风险权重、管理人名称】加工逻辑
            20220413 陈伟峰 调整字段【增信方式代码、增信主体名称】加工逻辑
            20220422 陈伟峰 新增字段【缓释录入日期】，待M层入模型后继续开发
            20220506 陈伟峰 新增字段【资产支持证券标志、无评级资产证券化标志、再资产证券化标志】
            20220506 陈伟峰 调整字段【票面利率或利差】加工逻辑 --口径提供：徐鹏程，同业报表核算余额
                            修改字段中文名【资产支持证券标志】->【资产证券化产品标志】（英文名不修改）
            20220727 陈伟峰 新增字段【标的金融工具编号,标的资产类型编号,标的市场类型编号】
            20221213 温旺清 新增字段【上市日期】
            20221227 翟若平 调整字段【管理模式代码】的加工口径
            20230104 温旺清	新增字段【净值型投向行业类型代码】
            20231031 徐子豪 新增字段【托管人编号、托管人名称、基金杠杆率、产品当期总资产、有无独立第三方报告标志】
            20231215 饶雅   新增字段 【本周期开放终止日期、本周期持有到期日期】调整【开放类型代码】的取数逻辑
            20240125 饶雅   新增字段【产品类型名称】
            20240906 陈伟峰 新增字段【授信主体客户编号、授信主体名称】
			20250123 谢  宁 新增字段【现金管理类产品标志】
			20250718 陈  凭 新增字段【续期标志】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ibank_fin_instm drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ibank_fin_instm add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_ibank_fin_instm_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_fin_instm_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_ibank_fin_instm where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_fin_instm_ex(
     etl_dt                      --数据日期
    ,lp_id                       --法人编号
    ,fin_instm_id                --金融工具编号
    ,asset_type_id               --资产类型编号
    ,market_type_id              --市场类型编号
    ,fin_instm_name              --金融工具名称
    ,fin_instm_abbr              --金融工具简称
    ,std_prod_id                 --标准产品编号
    ,prod_type_cd                --产品类型代码
    ,prod_type_name              --产品类型名称
    ,asset_type_name             --资产类型名称
    ,prod_cls_tenor_cd           --产品分类期限代码
    ,underly_fin_instm_id        --标的金融工具编号
	  ,underly_asset_type_id       --标的资产类型编号
	  ,underly_market_type_id      --标的市场类型编号
    ,issuer_cust_id              --发行人客户编号
    ,issue_org_id                --发行机构编号
    ,discov_org_cls_name         --发现机构分类名称
    ,issue_dt                    --发行日期
    ,mger_cust_id                --管理人客户编号
    ,mger_id                     --管理人编号
    ,mger_name                   --管理人名称
    ,mgmt_mode_cd                --管理模式代码
    ,trustee_id                  --托管人编号
    ,trustee_name                --托管人名称
    ,value_dt                    --起息日期
    ,exp_dt                      --到期日期
    ,tenor_cd                    --期限代码
    ,base_rat_id                 --基准利率编号
    ,int_accr_base_cd            --计息基准代码
    ,int_rat_adj_way_cd          --利率调整方式代码
    ,int_rat_adj_ped_freq        --利率调整周期频率
    ,int_rat_adj_ped_corp_cd     --利率调整周期单位代码
    ,issue_way_cd                --发行方式代码
    ,cty_cd                      --国家代码
    ,curr_cd                     --币种代码
    ,fac_val_amt                 --票面金额
    ,fac_val_int_rat             --票面利率
    ,fwd_int_rat_curve           --远期利率曲线
    ,disct_int_rat_curve         --折现利率曲线
    ,risk_wt                     --风险权重
    ,contn_weight_flg            --含权标志
    ,pay_int_ped_cd              --付息周期代码
    ,src_pay_int_ped_cd          --源付息周期代码
    ,pay_int_freq                --付息频率
    ,fir_pay_int_dt              --首次付息日期
    ,belong_org_id               --所属机构编号
    ,cashflow_get_way_cd         --现金流获取方式代码
    ,spec_aim_vector_type_cd     --特定目的载体类型代码
    ,spec_aim_vector_code        --特定目的载体编码
    ,am_prod_stat_code	         --资管产品统计编码
    ,issuer_id	                 --发行人编号
    ,issuer_rg_cd	               --发行人地区代码
    ,move_way_cd	               --运行方式代码
    ,non_uder_asset_cls_cd       --非底层资产分类代码
    ,non_uder_asset_subclass_cd  --非底层资产细类代码
    ,dr_input_freq_cd            --缓释录入频率代码
    ,dr_input_dt                 --缓释录入日期
    ,dr_effect_dt                --缓释生效日期
    ,dr_exp_dt                   --缓释到期日期
    ,margin_dr_ratio             --保证金缓释比例
    ,hxb_dep_rcpt_dr_ratio       --我行存单缓释比例
    ,tbond_dr_ratio              --国债缓释比例
    ,chn_pb_bond_dr_ratio        --我国政策性银行债券缓释比例
    ,chn_cb_dr_ratio             --我国商业银行缓释比例
    ,chn_pub_dept_dr_ratio       --我国公共部门缓释比例
    ,other_dr_ratio              --其他缓释比例
    ,dr_prod_descb_info          --缓释品描述信息
    ,dr_acct_id                  --缓释账户编号
    ,dr_acct_bal                 --缓释账户余额
    ,prod_currt_tot_asset        --产品当期总资产
	,exp_stl_amt                 --到期结算金额
    ,fund_lever_rat              --基金杠杆率
    ,fund_open_dt                --基金开放日期
    ,actl_finer_cust_id          --实际融资人客户编号
    ,actl_finer_name             --实际融资人名称
    ,actl_finer_group_name       --实际融资人集团名称
    ,crdt_main_cust_id           --授信主体客户编号
    ,crdt_main_name              --授信主体名称
    ,set_open_flg                --定开标志
    ,set_open_ped_cd             --定开周期代码
    ,open_type_cd                --开放类型代码
    ,this_ped_open_termnt_dt     --本周期开放终止日期
    ,this_ped_hold_exp_dt        --本周期持有到期日期
    ,incre_crdt_way_cd           --增信方式代码
    ,incre_crdt_main_name        --增信主体名称
    ,set_open_tenor_start_dt     --定开期限开始日期
	  ,set_open_tenor_end_dt       --定开期限结束日期
	  ,usage_descb                 --用途描述
    ,guar_way_comb               --担保方式组合
    ,crdt_class_proj_flg         --信贷类项目标志
    ,asset_supt_secu_flg         --资产证券化产品标志
    ,noth_rating_abs_flg         --无评级资产证券化标志
    ,abs_flg                     --再资产证券化标志
    ,is_single_trdpty_rept_flg   --有无独立第三方报告标志
	,cash_manage_flg             --现金管理类产品标志
	,renew_flg                   --续期标志
	,green_fin_flg               --绿色融资标志
    ,list_dt                     --上市日期
    ,nv_type_dir_indus_type_cd   --净值型投向行业类型代码
    ,job_cd
    ,etl_timestamp               --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')           as etl_dt              --数据日期
      ,'9999'                                        as lp_id               --法人编号
      ,t1.fin_instm_id                               as fin_instm_id        --金融工具编号
      ,t1.asset_type_id                              as asset_type_id       --资产类型编号
      ,t1.market_type_id                             as market_type_id      --市场类型编号 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
      ,t1.fin_instm_name                             as fin_instm_name      --金融工具名称
      ,t1.cn_abbr                                    as fin_instm_abbr      --中文简写
      ,t1.std_prod_id                                as std_prod_id         --标准产品编号
      ,t1.prod_type_cd                               as prod_type_cd        --产品类型代码
      ,t20.prod_type_name                            as prod_type_name      --产品类型名称
      ,t1.prod_cls                                   as asset_type_name     --产品分类代码
      ,t1.prod_tenor_cls_cd                          as prod_cls_tenor_cd   --产品期限分类代码 区分是Long还是Short（L：long；S：Short）
      ,t1.underly_fin_instm_id                       as underly_fin_instm_id   --标的金融工具编号
	    ,t1.un_asset_type_id                           as underly_asset_type_id       --标的资产类型编号
	    ,t1.underly_market_type_id                     as underly_market_type_id --标的市场类型编号
      ,t14.cust_id                                   as issuer_cust_id      --发行人客户编号
      ,t1.issuer_id                     	           as issue_org_id        --发行机构编号
      ,t1.issuer_cust_cls_name                       as discov_org_cls_name --发行人客户分类名称
      ,''                                            as issue_dt            --发行日期 无该字段
      ,coalesce(t10.cust_id, t13.cust_id,t18.seat_no) as mger_cust_id       --管理人客户编号   --t18.seat_no
      ,nvl(trim(t7.manager_id), t1.issue_org_id)     as mger_id             --管理人编号
      ,coalesce(t10.party_fname, t6.party_fname,t13.party_fname)      as mger_name           --管理人名称
      ,case(case when trim(t11.fin_instm_id) is not null then t11.mgmt_mode_cd
                 when trim(t7.i_code) is not null then nvl(t7.management_model,'00')
                 else nvl(trim(t3.management_mode),'00') end)
       when '0' then '01'
       when '1' then '02'
       else (case when trim(t11.fin_instm_id) is not null then t11.mgmt_mode_cd
                  when trim(t7.i_code) is not null and t7.a_type = 'SPT_MMF' then '02'
                  when trim(t7.i_code) is not null and t7.a_type <> 'SPT_MMF' then nvl(t7.management_model,'00')
                  else nvl(t3.management_mode,'00') end
             ) end as mgmt_mode_cd                                              --管理模式代码
      ,t7.f_trustee_code                             as trustee_id          --托管人编号
      ,t7.f_trustee                                  as trustee_name        --托管人名称
      ,t1.value_dt                                   as value_dt            --起息日期
      ,t1.exp_dt                                     as exp_dt              --到期日期
      --,t1.tenor_type_cd                              as tenor_cd            --期限代码 --modify by fuxx 20191108 为期限类型非期限代码
      ,t1.tenor||t1.tenor_type_cd                    as tenor_cd            --期限代码
      ,t2.base_fin_instm_id                          as base_rat_id         --基准金融工具编号
      ,t1.int_accr_base_cd                           as int_accr_base_cd    --计息基准代码
      ,t1.coupon_type_cd                             as int_rat_adj_way_cd  --利率调整方式代码 息票类型：1－固定利率；2－浮动利率；3－零息票利率
      ,t2.int_rat_adj_ped_freq                       as int_rat_adj_ped_freq        --利率调整周期频率
      ,t2.int_rat_adj_ped_corp_cd                    as int_rat_adj_ped_corp_cd     --利率调整周期单位代码
      ,t1.issue_mode_cd                              as issue_way_cd        --发行模式代码 1－面值发行；2－贴现发行
      ,t2.cty_cd                                     as cty_cd              --国家代码
      ,t1.curr_cd                                    as curr_cd             --币种代码
      ,t1.issue_denom                                as fac_val_amt         --发行面额
      ,case when t2.fin_instm_id is not null and t2.prod_type_cd not in ('0170')
            then decode(t1.coupon_type_cd, '1', t1.fac_val_int_rat, '2', (t16.close_quot_price * 100)+ t2.fac_val_int_rat)
            when t11.fin_instm_id is not null then decode(t11.coupon_type_cd, '2', t15.actl_int_rat, t11.fac_val_int_rat)
            else t1.fac_val_int_rat
             end                                     as fac_val_int_rat     --票面利率或利差
      ,t1.fwd_int_rat_curve                          as fwd_int_rat_curve   --远期利率曲线
      ,t1.disct_int_rat_curve                        as disct_int_rat_curve --折现利率曲线
      ,to_number(nvl(trim(t3.risk_weight),'0'))      as risk_wt             --风险权重
      ,case when trim(t19.i_code) is not null
            then '1' else '0' end                    as contn_weight_flg    --含权标志
      ,t1.pay_int_ped_freq || t1.pay_int_ped_corp_cd as pay_int_ped_cd      --付息周期代码 付息周期,如 1Y，6M，8D
      ,t1.src_pay_int_ped_cd                         as src_pay_int_ped_cd  --源付息周期代码
      ,t1.pay_int_cnt                                as pay_int_freq        --付息次数（一年付息几次）
      ,t1.fir_pay_int_dt                             as fir_pay_int_dt      --首次付息日期
      ,t1.belong_org_id                              as belong_org_id       --所属机构编号
      ,t2.cashflow_get_way_cd                        as cashflow_get_way_cd --现金流获取方式代码
      ,coalesce(t3.special_purpose_vehicle_type, t4.special_purpose_vehicle_type, t5.special_purpose_vehicle_type)         as spec_aim_vector_type_cd --特定目的载体类型代码
      ,coalesce(t3.special_purpose_vehicle_code, t4.special_purpose_vehicle_code, t5.special_purpose_vehicle_code)         as spec_aim_vector_code    --特定目的载体编码
      ,coalesce(t3.asset_product_statistics_code, t4.asset_product_statistics_code, t5.asset_product_statistics_code)      as am_prod_stat_code	      --资管产品统计编码
      ,coalesce(t3.issuer_code, t4.issuer_code, t5.issuer_code)                                                            as issuer_id	              --发行人编号
      ,coalesce(t3.issuer_region_code, t4.issuer_region_code, t5.issuer_region_code)                                       as issuer_rg_cd	          --发行人地区代码
      ,coalesce(t3.excute_mode, t4.excute_mode, t5.excute_mode)                                                            as move_way_cd	            --运行方式代码
      ,t3.not_undasset_type                          as non_uder_asset_cls_cd       --非底层资产分类代码
      ,t3.not_undasset_type_two                      as non_uder_asset_subclass_cd  --非底层资产细类代码
      ,nvl(t7.mitigation_freq, t3.mitigation_freq)   as dr_input_freq_cd            --缓释录入频率代码
      ,t9.register_date                              as dr_input_dt                 --缓释录入日期
      ,t8.value_dt                                   as dr_effect_dt                --缓释生效日期
      ,t8.exp_dt                                     as dr_exp_dt                   --缓释到期日期
      ,t8.margin_amt                                 as margin_dr_ratio             --保证金缓释比例
      ,t8.dep_rcpt_amt                               as hxb_dep_rcpt_dr_ratio       --我行存单缓释比例
      ,t8.tbond_amt                                  as tbond_dr_ratio              --国债缓释比例
      ,t8.pb_amt                                     as chn_pb_bond_dr_ratio        --我国政策性银行债券缓释比例
      ,t8.cfb_amt                                    as chn_cb_dr_ratio             --我国商业银行缓释比例
      ,t8.pub_dept_enty_amt                          as chn_pub_dept_dr_ratio       --我国公共部门缓释比例
      ,t8.other_amt                                  as other_dr_ratio              --其他缓释比例
      ,t9.field1                                     as dr_prod_descb_info          --缓释品描述信息
      ,t9.field2                                     as dr_acct_id                  --缓释账户编号
      ,t9.amount                                     as dr_acct_bal                 --缓释账户余额
      ,nvl(t3.fund_current_asset,0)                  as prod_currt_tot_asset        --产品当期总资产
	  ,t2.exp_stl_amt                                as exp_stl_amt                 --到期结算金额
      ,nvl(t3.lever_ratio,0)                         as fund_lever_rat              --基金杠杆率
      ,to_date(trim(t7.f_opendate),'yyyy-mm-dd')     as fund_open_dt                --基金开放日期
      ,coalesce(trim(t3.actual_financier_id), trim(t12.actual_financier_id), t13.cust_id)  as actl_finer_cust_id--实际融资人客户编号
      ,coalesce(t12.financier_name, t3.final_use_comp, t13.party_fname)                    as actl_finer_name   --实际融资人名称
      ,case when t1.prod_type_cd='0170' then nvl(t3.parent_group, t12.parent_group)
            else substr(t13.party_cls_descb, instr(t13.party_cls_descb, '.', '-1') + 1)
            end                                      as actl_finer_group_name             --实际融资人集团名称
      ,t21.cust_id                                   as crdt_main_cust_id      --授信主体客户编号
      ,t21.party_fname                               as crdt_main_name --授信主体名称
      ,case when t1.prod_type_cd = '0170' then nvl(trim(t3.is_decide_openbusiness),'-')
            when t1.prod_type_cd = '0700' then decode(t17.open_type,'2','1','0')
            end                                      as set_open_flg                      --定开标志
      ,case when t1.prod_type_cd = '0170' and t3.is_decide_openbusiness = '1'
            then decode(t3.openbusiness_begdate,'0','D'  --每日
                                               ,'1','W'  --每周
                                               ,'2','HF' --每半月
                                               ,'3','TW' --每21天
                                               ,'4','M'  --每月
                                               ,'5','P'  --每季
                                               ,'6','B'  --每半年
                                               ,'7','Y'  --每年
                                               )
            when t1.prod_type_cd = '0700' then decode(t17.open_type,'0','D'  --每日
                                                                   ,'2','FP' --固定周期
                                                                   ,'3','W'  --每周
                                                                   ,'4','M'  --每月
                                                                   ,'5','P'  --每季
                                                                   ,'6','HF' --每半月
                                                                   ,'7','TW' --每21天
                                                                   ,'8','B'  --每半年
                                                                   ,'9','Y'  --每年
                                                                   )
            end                                      as set_open_ped_cd                   --定开周期代码
      ,nvl(trim(t17.open_type),trim(t7.open_type))   as open_type_cd                      --开放类型代码
      ,decode(iml.dateformat_max2(t17.curr_open_break_date),to_date('29991231', 'yyyymmdd'),iml.dateformat_max2(t7.this_open_end_date),iml.dateformat_max2(t17.curr_open_break_date))  as this_ped_open_termnt_dt --本周期开放终止日期   
      ,decode(iml.dateformat_max2(t17.curr_hold_end_date),to_date('29991231', 'yyyymmdd'),iml.dateformat_max2(t7.this_hold_end_date),iml.dateformat_max2(t17.curr_hold_end_date)) as this_ped_hold_exp_dt  --本周期持有到期日期   
      ,t3.add_credit_way                             as incre_crdt_way_cd                 --增信方式代码
      ,t3.add_credit_subject_name                    as incre_crdt_main_name              --增信主体名称
      ,to_date(trim(t17.closing_start_date),'yyyy-mm-dd')  as set_open_tenor_start_dt     --定开期限开始日期
	    ,to_date(trim(t17.closing_end_date),'yyyy-mm-dd')    as set_open_tenor_end_dt       --定开期限结束日期
	    ,t3.fund_use                                         as usage_descb                 --用途描述
      ,t3.ensure_codes                                     as guar_way_comb               --担保方式组合
      ,nvl(trim(t3.is_credit_item),'-')                    as crdt_class_proj_flg         --信贷类项目标志
      ,nvl(trim(t3.is_asset_base_securities),'0')          as asset_supt_secu_flg         --资产证券化产品标志
      ,t3.is_no_grade_secu                                 as noth_rating_abs_flg         --无评级资产证券化标志
      ,t11.abs_flg                                         as abs_flg                     --再资产证券化标志
      ,nvl(trim(t3.has_third_report),'-')                  as is_single_trdpty_rept_flg   --有无独立第三方报告标志
	  ,t17.is_cash_manage_type                               as cash_manage_flg           --现金管理类产品标志
	  ,t1.renew_flg                                                                       --续期标志
	  ,t3.is_green_finance                                 as green_fin_flg               --绿色融资标志
      ,decode(${iml_schema}.dateformat_max2(t7.f_date),to_date('29991231', 'yyyymmdd'),${iml_schema}.dateformat_max2(t17.list_date), ${iml_schema}.dateformat_max2(t7.f_date)) as list_dt      --上市日期
      ,t17.final_invest                                                       --净值型投向行业类型代码
	  ,t1.job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
  from ${iml_schema}.prd_fin_instm t1  --金融工具表
  left join ${iml_schema}.prd_ibank_cap_ld_fin_instm t2 --同业资金借贷金融工具
    on t1.fin_instm_id = t2.fin_instm_id
   and t1.asset_type_id = t2.asset_type_id
   and t1.market_type_id = t2.market_type_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ibmsf1'
   and t2.id_mark <> 'D'
  left join ${iol_schema}.ibms_ttrd_cashlb_manage_ele t3
    on t1.fin_instm_id = t3.i_code
   and t1.asset_type_id = t3.a_type
   and t1.market_type_id = t3.m_type
   and t3.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt >to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_tfnd_ext t4
    on t1.fin_instm_id = t4.i_code
   and t1.asset_type_id = t4.a_type
   and t1.market_type_id = t4.m_type
   and t4.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt >to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_equity_ext t5
    on t1.fin_instm_id = t5.i_code
   and t5.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt >to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.pty_ibank_cntpty_info t6
    on t1.belong_org_id =t6.org_id
   and t6.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'ibmsf1'
   and t6.id_mark <> 'D'
  left join ${iol_schema}.ibms_tfnd t7
    on t1.fin_instm_id = t7.i_code
   and t1.asset_type_id = t7.a_type
   and t1.market_type_id = t7.m_type
   and t7.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt >to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.prd_ibank_post_asset t8  --${iol_schema}.ibms_ttrd_position_asset_register t8  --调整为M层
    on t1.fin_instm_id = t8.prod_cd
   and t1.asset_type_id = t8.asset_type_cd
   and t1.market_type_id = t8.market_type_cd
   and t8.exp_dt > to_date('${batch_date}', 'yyyymmdd')
   and t8.rgst_type_cd = '5'
   and t8.effect_flg = '1'
   and t8.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.id_mark<>'D'
   and t8.job_cd ='ibmsf1'
  left join (select row_number() over (partition by i_code,a_type,m_type order by id desc) as rn,
                    id, i_code, a_type, m_type, field1, field2, amount,${iml_schema}.dateformat_min(register_date) as register_date
               from ${iol_schema}.ibms_ttrd_position_asset_register       --需调整为M层
              where register_type ='6'
                 ) t9
    on t1.fin_instm_id = t9.i_code
   and t1.asset_type_id = t9.a_type
   and t1.market_type_id = t9.m_type
   and t9.rn = 1
  left join ${iml_schema}.pty_ibank_cntpty_info t10
    on t7.manager_id =t10.src_party_id
   and t10.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.job_cd = 'ibmsf1'
   and t10.id_mark <> 'D'
   left join ${iml_schema}.prd_ibank_bond t11
   on t1.fin_instm_id = t11.fin_instm_id
   and t1.asset_type_id = t11.asset_type_id
   and t1.market_type_id = t11.market_type_id
   and t11.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.job_cd = 'ibmsf1'
   and t11.id_mark <> 'D'
   left join ${iol_schema}.ibms_ttrd_finance_body t12
   on t1.fin_instm_id = t12.i_code
   and t1.asset_type_id = t12.a_type
   and t1.market_type_id = t12.m_type
   and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.pty_ibank_cntpty_info t13
    on t1.issue_org_id =t13.src_party_id
   and t13.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t13.job_cd = 'ibmsf1'
   and t13.id_mark <> 'D'
  left join ${iml_schema}.pty_ibank_cntpty_info t14
    on t1.issuer_id =t14.src_party_id
   and t14.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t14.job_cd = 'ibmsf1'
   and t14.id_mark <> 'D'
  left join ${iml_schema}.prd_int_accr_dtl t15 
    on t1.fin_instm_id = t15.fin_instm_id
   and t1.asset_type_id = t15.asset_type_id
   and t1.market_type_id = t15.market_type_id
   and t15.asset_type_id <> 'SPT_DED'
   and t15.int_accr_start_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and t15.int_accr_end_dt>to_date('${batch_date}', 'yyyymmdd') 
   and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t15.job_cd = 'ibmsf1'
  left join ${iml_schema}.prd_fin_instm_int_rat_makt t16
    on t2.base_fin_instm_id = t16.fin_instm_id
   and t2.base_asset_type_id = t16.asset_type_id
   and t2.base_market_type_id = t16.market_type_id
   and t2.effect_dt >= t16.effect_dt
   and t2.effect_dt < t16.invalid_dt
   and t16.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t16.job_cd = 'ibmsf1'
   and t16.id_mark <> 'D'
  left join ${iol_schema}.ibms_ttrd_equity t17
    on t1.fin_instm_id = t17.i_code
   and t1.asset_type_id = t17.a_type
   and t1.market_type_id = t17.m_type
   and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_tree_node_info t18
    on to_char(t18.node_id) = t13.org_cls_cd
   and t18.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_instrument_extend t19
    on t1.fin_instm_id = t19.i_code
   and t1.asset_type_id = t19.a_type
   and t1.market_type_id = t19.m_type
   and to_date(trim(t19.beg_date),'yyyy-mm-dd') <=to_date('${batch_date}', 'yyyymmdd')
   and to_date(trim(t19.end_date),'yyyy-mm-dd') >to_date('${batch_date}', 'yyyymmdd')
   and t19.extend_type ='04'
  left join ${iml_schema}.ref_ibank_asset_prod_type t20
    on t1.prod_type_cd=t20.prod_type_cd
   and t20.job_cd = 'ibmsf1'
   and t20.id_mark <> 'D'
   and t20.create_dt <= to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.pty_ibank_cntpty_info t21
    on t2.crdt_cust_id =t21.src_party_id
   and t21.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t21.job_cd = 'ibmsf1'
   and t21.id_mark <> 'D'
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ibmsf1'
   and t1.id_mark <> 'D'
;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_ibank_fin_instm exchange partition p_${batch_date} with table ${icl_schema}.cmm_ibank_fin_instm_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_ibank_fin_instm_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_ibank_fin_instm', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);