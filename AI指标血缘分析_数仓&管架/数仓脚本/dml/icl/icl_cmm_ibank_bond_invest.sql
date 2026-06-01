/*
Purpose:    共性加工层-同业债券投资表:数据来源于同业系统（IBMS）,包括所有同业账户持有的债券投资（交易所债券)
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py 20200630 icl_cmm_ibank_bond_invest
Createdate: 20191025
Logs:       20200424 周沁晖 1、调整资产四分类代码 acctnt_cls_cd ——> asset_four_cls_cd
            20200724 陈伟峰 增加标准产品编号字段
            20200828 周沁晖 增加字段【交易金额、对象编号、中债全价估值、中债净价估值、估价修正久期、基点价值、估价凸性、估价收益率、账面余额、利息科目编号、利息调整科目编号、资产三分类代码、基准利率资产类型编号、基准利率市场类型编号、基准利率、公允价值损益】
            				        调整字段【科目编号】取数口径
			      20200828 陈伟峰 增加字段【应收利息】，调整字段【应计利息】的取数口径
			      20201017 陈伟峰 修改资产三分类取数源表
			      20201021 陈伟峰 修改利息科目、利息调整科目取值字段
            20201027 翟若平 调整tmp_cmm_ibank_secu_post_01过滤条件，调整【持有面值】的口径
            20210108 周沁晖 调整【实际余额】取数逻辑
            20210122 周沁晖 新增字段【当期余额】
            20210429 陈伟峰 1、主键字段【数据日期、法人编号、外部证券账户编号、内部证券账户编号、金融工具编号、市场类型编号、业务编号】调整为【数据日期、法人编号、外部证券账户编号、内部证券账户编号、金融工具编号、资产类型编号、市场类型编号、业务编号、组合交易号、逾期状态、额外维度代码、结算日期】
                            2、新增字段【组合交易号、额外维度代码、结算日期、逾期状态、本金逾期日期、本金逾期天数、利息逾期日期、利息逾期天数】
            20210508 何桐金 增加字段【逾期标志】
            20210626 陈伟峰 增加字段【发行人客户编号】、调整字段【票面利率】的取数口径
            20210708 何桐金 调整T20表过滤条件，增加int_rat_flow_id = (select t.cash_accid from ttrd_acc_cash_ext_map t where t.cash_ext_accid = '3080');
            20210813 陈伟峰 删除字段【五级分类代码level5_cls_cd、审批单号apv_odd_no、交易金额tran_amt】
            20210830 何桐金 调整PRD_IBANK_BOND_EVLTION算法，从全量快照，改成全量流水
            20210914 何桐金 调整PRD_IBANK_BOND_EVLTION算法，从全量流水，改成增量流水，C层同步更改
            20210922 陈伟峰 调整利息科目逻辑，增加表外科目
            20211020 陈伟峰 调整科目字段逻辑，当为空时取前一天科目数据
            20220330 谢  宁 新增【底层资产类型编号、源付息周期代码、最终投向类型代码、最终投向行业大类】
            20221024 温旺清 1、增加字段【应收未收利息科目编号、授信金融工具编号、资产唯一标识编号】
                            2、调整字段【应计利息、应收利息、利息科目编号、公允价值变动】的加工口径
            20230518 翟若平 调整字段【公允价值变动】的加工口径
            20230602 陈伟峰 调整【资产唯一标识编号】加工逻辑，使用intnal_vch_acct_id 拼接
            20230612 陈伟峰 调整字段【应收利息】的加工口径
            20230707 徐子豪 调整字段【应收利息】的加工口径,增加receive_ai <> 0卡值条件。
            20230830 徐子豪 调整字段【逾期标志、本金逾期日期、本金逾期天数、利息逾期日期、利息逾期天数】的加工口径
            20240603 饶雅  修改同业资产唯一标识编号取数逻辑
            20240717 陈伟峰 调整【应收利息】取数逻辑，去除应收未收利息
            20240929 陈伟峰 调整【应收未收利息科目编号】取数逻辑，使用上日利息科目补充(徐银鹏确认口径)
            20250427 陈伟峰 过滤债券负债数据
            20250606 陈伟峰 调整【账面余额】中公允价值变动部分加工逻辑，与公允价值变动字段加工逻辑保持一致
            20250721 陈伟峰 调整【发行人名称】逻辑，为空时从交易对手信息表补充
            20251117 陈伟峰 调整【发行人名称】逻辑，优先从交易对手信息表取
            20260227 陈  凭 调整【应收未收应计利息、本金逾期日期、本金逾期天数、利息逾期日期、利息逾期天数】加工逻辑
                            增加t44的过滤条件：t44.is_si <> '1'
            
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ibank_bond_invest drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ibank_bond_invest add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_ibank_bond_invest_ex purge;
drop table ${icl_schema}.tmp_cmm_ibank_bond_invest_01 purge;
drop table ${icl_schema}.tmp_cmm_ibank_bond_invest_02 purge;
drop table ${icl_schema}.tmp_cmm_ibank_bond_invest_03 purge;
drop table ${icl_schema}.tmp_cmm_ibank_bond_invest_04 purge;


-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_bond_invest_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_ibank_bond_invest where 0=1;

--2.2 insert into tmp table
create table ${icl_schema}.tmp_cmm_ibank_bond_invest_01 as
select acctg_obj_id as obj_id,
       max(decode(gzb_type, '1', subj_code, '')) as subj_id1,
       max(decode(gzb_type, '1', subj_code, '9', subj_code, '')) as subj_id,
       max(decode(gzb_type, '3.1', subj_code, '')) as int_subj_id,
       max(decode(gzb_type, 'X', subj_code, '')) as int_subj_id2,
       max(decode(gzb_type, '2', subj_code, '')) as int_adj_subj_id,
       max(decode(gzb_type, '4.1', subj_code, '')) as evha_val_chag_subj_id,
       max(decode(gzb_type, '5.1.1', subj_code, '')) as acru_int_inco_subj_id,
       max(decode(gzb_type, '5.1.2', subj_code, '5.1', subj_code, ''))  as amort_int_income_subj_id,
       max(decode(gzb_type, '5.3', subj_code, '')) as evha_val_chag_pl_subj_id,
       max(decode(gzb_type, '5.2.1', subj_code, '')) as spd_pl_subj_id,
       max(decode(gzb_type, '5.1.1', '22210202', '')) as acru_int_inco_subj_id_1,
       max(decode(gzb_type, '5.1.2', '22210203', '')) as amort_int_income_subj_id_1,
       max(decode(gzb_type, '5.2.1', '22210203', '')) as spd_pl_subj_id_1,
       max(decode(gzb_type, '3.2', subj_code, '')) as un_int_subj_id
  from (select distinct a.subj_code, a.acctg_obj_id, b.gzb_type
          from ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg a
          left join ${iol_schema}.ibms_ttrd_accounting_entry_def b
            on a.subj_code = b.acting_code
           and b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and b.end_dt > to_date('${batch_date}', 'yyyymmdd')
         where a.start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and a.end_dt > to_date('${batch_date}', 'yyyymmdd')
           and replace(a.beg_date, '-', '') = '${batch_date}') -- 20201027 翟若平 新增
 group by acctg_obj_id;
commit;

--2.2 insert into tmp table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_bond_invest_02
nologging
compress ${option_switch} for query high
as
select *
  from (select t.*,
               row_number() over(partition by t.fin_instm_id, t.asset_type_id, t.market_type_id order by effect_dt desc) rn
          from iml.prd_ibank_bond_evltion t
         where effect_dt <= to_date('${batch_date}', 'yyyymmdd')
           and t.invalid_dt > to_date('${batch_date}', 'yyyymmdd')
           and t.job_cd = 'ibmsi1'
       )
 where rn = 1
;
commit;

--手工记账利息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_bond_invest_03 as
 select tt1.subj_code, tt1.gzb_type,sum(tt1.value) as value,tt1.core_acct_name,tt1.trade_id,tt1.typename
   from (select t1.subj_id as subj_code,
                case when t2.charge_type_cd='3.1'  --3利息，3.1应计利息
                     then case when coalesce(trim(t2.level5_subj_name),trim(t2.level4_subj_name),t2.level3_subj_name) like '%应收利息%' then '3.2'
                               when coalesce(trim(t2.level5_subj_name),trim(t2.level4_subj_name),t2.level3_subj_name) like '%应计利息%' then '3.1'
                               end
                     else t2.charge_type_cd
                      end as gzb_type,
                case when t1.debit_crdt_dir_cd = 'D' then t1.entry_amt
                     when t1.debit_crdt_dir_cd = 'C' then -1 * t1.entry_amt
                     end as value,
                t.tran_id as trade_id,
                t1.core_acct_name,
                case when t1.core_acct_name like '计入其他综合收益%' or t1.core_acct_name like '可供出售%' then 'FVOCI类'
                     when t1.core_acct_name like '交易性%' then 'FVTPL类'
                     when t1.core_acct_name like '以摊余成本计量%' or t1.core_acct_name like '应收款项%' then 'AC类'
                     else '' end  as typename
           from ${iml_schema}.evt_ibank_manual_entry_evt t --ttrd_manual_bk_record t
           left join ${iml_schema}.evt_ibank_acct_ety_evt t1 --ttrd_bookkeeping_entry_his t1
             on t.entry_flow_num = t1.entry_flow_num
            and t1.job_cd ='ibmsi1'
           left join ${iml_schema}.ref_ibank_accti_subj_para t2 --ttrd_accounting_entry_def t2
             on t1.subj_id=t2.accti_code
            and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
            and t2.job_cd = 'ibmsf1'
            and t2.id_mark <> 'D'
          where t.entry_status_cd = '03'
            and t2.charge_type_cd in ('2','3.1','4.1')
            and t.entry_type_cd<>'03'
            and trim(t.tran_id) is not null
            and t.entry_dt <= to_date('${batch_date}', 'yyyymmdd')
            and t.job_cd ='ibmsi1'
      ) tt1
 group by tt1.subj_code, tt1.trade_id, tt1.gzb_type,tt1.typename,tt1.core_acct_name;
commit;


--公允价值变动核算差额
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_ibank_bond_invest_04 as
select secu_chg.accti_obj_id,
       sum(-secu_chg.evha_val_chag) as chg_fv
  from ${iml_schema}.agt_secu_acct_accti_bal_chg_h secu_chg
 inner join ${iml_schema}.evt_ibank_tran_vch_instr_dtl inst_secu
    on inst_secu.secu_instr_seq_num = secu_chg.instr_id
   and inst_secu.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and inst_secu.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and inst_secu.job_cd='ibmsi1'
 inner join ${iml_schema}.evt_ibank_tran_main_instr_dtl inst
    on inst.main_instr_seq_num = inst_secu.main_instr_seq_num
   and inst.instr_status_cd = '04'
   and inst.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and inst.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and inst.job_cd ='ibmsi1'
 where secu_chg.revo_rela_chg_id = '-1'
   and (secu_chg.evha_val_chag <> 0 or secu_chg.fair_val_pl <> 0 or secu_chg.bs_pl <> 0)
   and secu_chg.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and secu_chg.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and secu_chg.job_cd='ibmsf1'
 group by secu_chg.accti_obj_id;


whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_bond_invest_ex(
     etl_dt                  --数据日期
    ,lp_id                   --法人编号
    ,ext_secu_acct_id        --外部证券账户编号
    ,intnal_secu_acct_id     --内部证券账户编号
    ,fin_instm_id            --金融工具编号
    ,asset_type_id           --资产类型编号
	  ,std_prod_id             --标准产品编号
    ,market_type_id          --市场类型编号
    ,bus_id                  --业务编号
    ,comb_tran_num           --组合交易号
    ,obj_id 				         --对象编号
    ,crdt_fin_instm_id       --授信金融工具编号
	  ,asset_uniq_idf_id       --资产唯一标识编号
    ,prod_type_cd            --产品类型代码
    ,asset_type_name         --资产类型名称
--    ,level5_cls_cd           --五级分类代码
    ,acct_name               --账户名称
    ,bond_name               --债券名称
    ,convbl_bond_flg         --可转债标志
    ,sub_debt_flg            --次级债标志
    ,abs_flg                 --ABS标志
    ,subj_id                 --科目编号
    ,int_subj_id			       --利息科目编号
    ,recvbl_uncol_int_subj_id --应收未收利息科目编号
    ,int_adj_subj_id		     --利息调整科目编号
    ,tran_market_id          --交易市场编号
    ,exchg_acct_id           --交易所账户编号
    ,issuer_cust_id          --发行人客户编号
    ,issuer_id               --发行人编号
    ,issuer_name             --发行人名称
    ,guartor_name            --担保人名称
    ,payoff_level_cd         --清偿等级代码
    ,issue_dt                --发行日期
    ,value_dt                --起息日期
    ,exp_dt                  --到期日期
    ,tenor_cd                --期限代码
    ,base_rat_id             --基准利率编号
    ,base_rat_asset_type_id  --基准利率资产类型编号
    ,base_rat_market_type_id --基准利率市场类型编号
    ,base_rat                --基准利率
    ,int_accr_base_cd        --计息基准代码
    ,int_rat_adj_way_cd      --利率调整方式代码
    ,issue_way_cd            --发行方式代码
    ,ex_type_cd              --行权类型代码
    ,fir_ex_dt               --首个行权日期
    ,fir_ex_price            --首个行权价格
    ,fir_compst_int_rat      --首个补偿利率
--    ,apv_odd_no              --审批单号
    ,cty_cd                  --国家代码
    ,curr_cd                 --币种代码
    ,fac_val_amt             --票面金额
    ,fac_val_int_rat         --票面利率
    ,pay_int_ped_cd          --付息周期代码
    ,src_pay_int_ped_cd      --源付息周期代码
    ,int_accr_ped_cd         --计息周期代码
    ,reset_ped_cd            --重置周期代码
    ,hold_pos                --持有仓位
    ,hold_fac_val            --持有面值
    ,pric_bal                --本金余额
    ,currt_bal               --当期余额
    ,acru_int                --应计利息
	  ,int_recvbl              --应收利息
    ,recvbl_uncol_pric       --应收未收本金
    ,recvbl_uncol_int        --应收未收利息
    ,int_adj_amt             --利息调整金额
    ,evha_val_chag           --公允价值变动
    ,fair_val_pl			       --公允价值损益
    ,actl_int_rat            --实际利率
    ,last_update_dt          --上次更新日期
    ,cap_type_cd             --资金类型代码
    ,asset_four_cls_cd       --资产四分类代码
    ,asset_thd_cls_cd		     --资产三分类代码
    ,belong_org_id           --所属机构编号
    ,cbond_full_price_evltion--中债全价估值
    ,cbond_net_price_evltion --中债净价估值
    ,estim_coret_duran       --估价修正久期
    ,bp_val                  --基点价值
    ,estim_cvty              --估价凸性
    ,estim_yld_rat           --估价收益率
--    ,tran_amt 				       --交易金额
    ,csecu_full_price_evltion--中证全价估值
    ,csecu_net_price_evltion --中证净价估值
    ,csecu_coret_duran       --中证修正久期
    ,csecu_bp_val            --中证基点价值
    ,csecu_estim_cvty        --中证估价凸性
    ,book_bal				         --账面余额
    ,extra_dimen_cd	         --额外维度代码
    ,stl_dt	                 --结算日期
    ,ovdue_status	           --逾期状态
    ,ovdue_flg               --逾期标志
    ,pric_ovdue_dt	         --本金逾期日期
    ,pric_ovdue_days         --本金逾期天数
    ,int_ovdue_dt	           --利息逾期日期
    ,int_ovdue_days	         --利息逾期天数
    ,uder_asset_type_id      --底层资产类型编号
    ,final_dir_type_descb    --最终投向类型描述
    ,final_dir_indus_gen     --最终投向行业大类
    ,job_cd
    ,etl_timestamp           --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')    as etl_dt              --数据日期
      ,'9999'                                 as lp_id               --法人编号
      ,t1.ext_vch_acct_id                     as ext_secu_acct_id    --外部券账户编号
      ,t1.intnal_vch_acct_id                  as intnal_secu_acct_id --内部券账户编号
      ,t1.fin_instm_id                        as fin_instm_id        --金融工具编号
      ,t1.asset_type_id                       as asset_type_id       --资产类型编号
	    ,t1.std_prod_id                         as std_prod_id         --标准产品编号
      ,t1.market_type_id                      as market_type_id      --市场类型编号 金融工具资产类型：XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
      ,t1.tran_num                            as bus_id              --交易号
      ,t1.comb_tran_id                        as comb_tran_num       --组合交易号
      ,t1.obj_id							                as obj_id  			       --对象编号
      ,nvl(trim(t32.approve_i_code), t1.fin_instm_id)     as crdt_fin_instm_id          --授信金融工具编号
	    ,nvl(trim(t32.approve_i_code), t1.fin_instm_id) ||case when t1.asset_type_id IN ('SPT_BD', 'SPT_ABS') AND t1.market_type_id = 'XSHG' THEN 'SH' WHEN t1.asset_type_id IN ('SPT_BD', 'SPT_ABS') AND t1.market_type_id = 'XSHE' THEN 'SZ' else '' END|| '_' || t1.asset_thd_cls_cd || '_' || t1.intnal_vch_acct_id    as asset_uniq_idf_id          --资产唯一标识编号
      ,t4.prod_type_cd                        as prod_type_cd        --产品类型代码
      ,t4.prod_cls                            as asset_type_name     --产品分类，默认为资产类型名称
--      ,nvl(trim(t5.level5_cls_cd),'90')       as level5_cls_cd       --五级分类代码
      --,t3.acct_name                                                -- 账户名称 --modify by fuxx 20191122 账户名称需要从内部证券账户取
      ,t2.acct_name                                                  -- 账户名称
      ,t6.bond_name                           as bond_name           --债券名称
      ,case when t6.prod_cls_name in ('可转换债券','可转债') then '1' else '0' end as convbl_bond_flg     --可转债标志
      ,case when t6.payoff_level_cd = 'SUB' then '1' else '0' end                  as sub_debt_flg        --次级债标志
      ,case when t6.prod_cls_name like '%资产支持证券%' then '1' else '0' end      as abs_flg             --ABS标志
      ,nvl(t11.subj_id1,t21.subj_id)                                                                as subj_id             --科目编号
/*      nvl(t11.subj_id1,(
       case when t4.prod_cls in ('国债') and t2.acctnt_cls_cd in ('116')
            then '1101011101'  --交易性国家债券投资成本
            when t4.prod_cls in ('央行票据') and t2.acctnt_cls_cd in ('116')
            then '1101011201'  --交易性中央银行债券投资成本
            when t4.prod_cls in ('政策银行债') and t2.acctnt_cls_cd in ('116')
            then '1101011301'  --交易性政策性银行债券投资成本
            when t4.prod_cls in ('商业银行债','商业银行次级债券','保险公司债','证券公司债','证券公司短期融资券','其它金融机构债','资产支持证券-金融债') and t2.acctnt_cls_cd in ('116')
            then '1101011401'  --交易性金融机构债券投资成本
            when t4.prod_cls in ('资产支持证券-企业债','一般企业债','集合企业债','一般公司债','私募债') and t2.acctnt_cls_cd in ('116')
            then '1101011601'  --交易性企业债券投资成本
            when t4.prod_cls in ('地方政府债') and t2.acctnt_cls_cd in ('116')
            then '1101011701'  --交易性地方政府债券投资成本
            when t4.prod_cls in ('国际机构债','政府支持机构债','其他债券') and t2.acctnt_cls_cd in ('116')
            then '1101011801'  --交易性其他债券投资成本
            when t4.prod_cls in ('同业存单') and t2.acctnt_cls_cd in ('116')
            then '1101011901'  --交易性同业存单投资成本
            when t4.prod_cls in ('国债') and t2.acctnt_cls_cd in ('118')
            then '15011101'  --持有至到期国家债券投资面值
            when t4.prod_cls in ('央行票据') and t2.acctnt_cls_cd in ('118')
            then '15011201'  --持有至到期中央银行债券投资面值
            when t4.prod_cls in ('政策银行债') and t2.acctnt_cls_cd in ('118')
            then '15011301'  --持有至到期政策性银行债券投资面值
            when t4.prod_cls in ('商业银行债','商业银行次级债券','保险公司债','证券公司债','证券公司短期融资券','其它金融机构债','资产支持证券-金融债') and t2.acctnt_cls_cd in ('118')
            then '15011401'  --持有至到期金融机构债券投资面值
            when t4.prod_cls in ('资产支持证券-企业债','一般企业债','集合企业债','一般公司债','私募债') and t2.acctnt_cls_cd in ('118')
            then '15011601'  --持有至到期企业债券投资面值
            when t4.prod_cls in ('地方政府债') and t2.acctnt_cls_cd in ('118')
            then '15011701'  --持有至到期地方政府债券投资面值
            when t4.prod_cls in ('国际机构债','政府支持机构债','其他债券') and t2.acctnt_cls_cd in ('118')
            then '15011801'  --持有至到期其他债券投资面值
            when t4.prod_cls in ('同业存单') and t2.acctnt_cls_cd in ('118')
            then '15011901'  --持有至到期同业存单投资面值
            when t4.prod_cls in ('国债') and t2.acctnt_cls_cd in ('117')
            then '15031101'  --可供出售国家债券面值
            when t4.prod_cls in ('央行票据') and t2.acctnt_cls_cd in ('117')
            then '15031201'  --可供出售中央银行债券面值
            when t4.prod_cls in ('政策银行债') and t2.acctnt_cls_cd in ('117')
            then '15031301'  --可供出售政策性银行债券面值
            when t4.prod_cls in ('商业银行债','商业银行次级债券','保险公司债','证券公司债','证券公司短期融资券','其它金融机构债','资产支持证券-金融债') and t2.acctnt_cls_cd in ('117')
            then '15031401'  --可供出售金融机构债券面值
            when t4.prod_cls in ('资产支持证券-企业债','一般企业债','集合企业债','一般公司债','私募债') and t2.acctnt_cls_cd in ('117')
            then '15031601'  --可供出售企业债券面值
            when t4.prod_cls in ('地方政府债') and t2.acctnt_cls_cd in ('117')
            then '15031701'  --可供出售地方政府债券面值
            when t4.prod_cls in ('国际机构债','政府支持机构债','其他债券') and t2.acctnt_cls_cd in ('117')
            then '15031801'  --可供出售其他债券面值
            when t4.prod_cls in ('同业存单') and t2.acctnt_cls_cd in ('117')
            then '15032001'  --可供出售同业存单面值
        end))                                 as subj_id             --科目编号  */
      ,coalesce(t11.int_subj_id, t11.int_subj_id2)   as int_subj_id      			    --利息科目编号
      ,nvl(trim(t11.un_int_subj_id),t21.int_subj_id)  as recvbl_uncol_int_subj_id       --应收未收利息科目编号
      ,nvl(t11.int_adj_subj_id,decode(t31.gzb_type,'2',t31.subj_code,''))  --利息调整科目编号
      ,t3.tran_market_id                      as tran_market_id      --交易市场编号
      ,t3.exchg_acct_id                       as exchg_acct_id       --交易所账户编号
      ,t19.cust_id                            as issuer_cust_id      --发行人客户编号
      ,t6.issuer_id                           as issuer_id           --发行人编号
      ,nvl(trim(t19.party_fname),t6.issuer_name)   as issuer_name         --发行人名称
      ,t6.guartor_name                        as guartor_name        --担保人名称
      ,t6.payoff_level_cd                     as payoff_level_cd     --清偿等级代码
      ,t6.issue_dt                            as issue_dt            --发行日期
      ,t6.value_dt                            as value_dt            --起息日期
      ,t6.exp_dt                              as exp_dt              --到期日期
      ,t6.tenor_cd                            as tenor_cd            --期限代码
      ,t6.base_rat_id                         as base_rat_id         --基准利率编号
      ,t6.base_asset_type_id 				          as base_rat_asset_type_id  --基准利率资产类型编号
      ,t6.base_market_type_id				          as base_rat_market_type_id --基准利率市场类型编号
      ,t13.dp_close * 100					            as base_rat        		 --基准利率
      ,t6.int_accr_base_cd                    as int_accr_base_cd    --计息基准
      ,t6.coupon_type_cd                      as int_rat_adj_way_cd  --票息类型代码
      ,t6.issue_way_cd                        as issue_way_cd        --发行方式
      ,t6.ex_type_cd                          as ex_type_cd          --行权类型，A：美式 B：百慕大 E：欧式
      ,t6.fir_ex_dt                           as fir_ex_dt           --首个行权日，含权债有效
      ,t6.fir_exec_price                      as fir_ex_price        --首个执行价格，含权债有效
      ,t6.fir_compst_int_rat                  as fir_compst_int_rat  --首个补偿利率，含权债有效
--      ,trim(t5.apv_odd_no)                    as apv_odd_no          --审批单号
      ,t6.cty_or_rg_cd                        as cty_cd              --国家或地区代码
      ,t1.curr_cd                             as curr_cd             --币种代码
      ,t6.bond_fac_val                        as fac_val_amt         --债券面值
      ,decode(t6.coupon_type_cd, '2', t20.actl_int_rat, t6.fac_val_int_rat)      as fac_val_int_rat     --票面利率
      ,t6.pay_int_ped_cd                      as pay_int_ped_cd      --付息周期代码
      ,t6.src_pay_int_ped_cd                  as src_pay_int_ped_cd  --源付息周期代码
      ,t6.int_accr_ped_cd                     as int_accr_ped_cd     --计息周期代码
      ,t6.int_rat_adj_ped_cd                  as reset_ped_cd        --利率调整周期代码
      ,t1.actl_qtty                           as hold_pos            --实际数量
      --,nvl(t1.actl_bal,0)+nvl(t1.recvbl_uncol_bal,0)                            as hold_fac_val        --实际余额
      ,nvl(t1.net_price_cost,0)+nvl(t1.recvbl_uncol_net_price_cost,0)  as hold_fac_val        --实际余额
      ,t1.net_price_cost                      as pric_bal            --净价成本
      ,nvl(t1.net_price_cost,0)+nvl(t1.recvbl_uncol_net_price_cost,0)  as currt_bal           --当期余额
     ,case when t4.prod_type_cd in ('0000', '0005', '1100', '1200', '0170') then
                   case when t4.src_pay_int_ped_cd = '0D' then
                          case when t31.gzb_type = '3.1' then t1.acru_int + nvl(t31.value, 0)
                               else t1.acru_int
                           end
                        else 0
                    end
                 else 0
             end as acru_int                       -- 应计利息
       ,case when t4.prod_type_cd in ('0702','0703','0704','0705') then nvl(t43.receive_ai,0)
             when t4.prod_type_cd in ('0000', '0005', '1100', '1200', '0170') then
               case when t4.src_pay_int_ped_cd <>'0D' then
                      case when t31.gzb_type = '3.2' then t1.acru_int + nvl(t31.value, 0)
                           else t1.acru_int
                       end
                    else 0
                end
             else t1.acru_int  + nvl(t31.value, 0)
         end as int_recvbl                    -- 应收利息
	    /*,case when t4.src_pay_int_ped_cd = '0D'
	          then t1.acru_int + t1.recvbl_uncol_acru_int
			 else 0 end                             as int_recvbl          --应计利息
      ,case when t4.src_pay_int_ped_cd <> '0D'
	        then t1.acru_int + t1.recvbl_uncol_acru_int
			 else 0 end                             as acru_int            --应收利息*/
      ,t1.recvbl_uncol_net_price_cost         as recvbl_uncol_pric   --应收未收净价成本
      ,case when t1.bal_type_cd = '1' then 0 
            else t1.recvbl_uncol_acru_int 
         end                                  as recvbl_uncol_int    --应收未收利息 t1.recvbl_uncol_acru_int 
      ,t1.int_adj_amt                         as int_adj_amt         --利息调整金额
      ,case when t31.gzb_type='4.1' then t1.evha_val_chag+t31.value+nvl(t42.chg_fv,0)
       else t1.evha_val_chag+nvl(t42.chg_fv,0) end   as evha_val_chag       --公允价值变动
      ,t1.fair_val_pl						              as fair_val_pl 		     --公允价值损益
      ,t1.actl_int_rat                        as actl_int_rat        --实际利率
      ,t1.last_update_dt                      as last_update_dt      --上次更新日期
      ,t2.cap_type_cd                         as cap_type_cd         --资金类型代码 0自有资产（自营业务）、1客户资产（代客、理财）
      ,t2.asset_four_cls_cd                   as asset_four_cls_cd   --会计分类代码 1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
      ,t1.asset_thd_cls_cd  				          as asset_thd_cls_cd    --资产三分类
      ,t3.belong_org_id                       as belong_org_id       --所属机构编号
      ,t10.full_price_amt					            as cbond_full_price_evltion 	--中债全价估值
      ,t10.net_price_amt 					            as cbond_net_price_evltion  	--中债净价估值
      ,t10.estim_coret_duran				          as estim_coret_duran        	--估价修正久期
	    ,t10.full_price_amt * t1.actl_qtty * t10.estim_coret_duran/10000 as bp_val      	--基点价值
      ,t10.estim_cvty						              as estim_cvty               	--估价凸性
      ,t10.estim_yld_rat					            as estim_yld_rat            	--估价收益率
      ,t16.price                              as csecu_full_price_evltion   --中证全价估值
      ,t16.dirty_price                        as csecu_net_price_evltion    --中证净价估值
      ,t16.mk_duration                        as csecu_coret_duran          --中证修正久期
      ,t16.mk_mdvbp                           as csecu_bp_val               --中证基点价值
      ,t16.mk_convexity                       as csecu_estim_cvty           --中证估价凸性
--      ,t5.tran_amt 							              as tran_amt										--交易金额
      ,t1.net_price_cost + t1.recvbl_uncol_net_price_cost + t1.int_adj_amt 
        + (case when t31.gzb_type='4.1' then t1.evha_val_chag+t31.value+nvl(t42.chg_fv,0)
       else t1.evha_val_chag+nvl(t42.chg_fv,0) end) 
        + decode(t4.src_pay_int_ped_cd, '0D', t1.recvbl_uncol_acru_int + t1.acru_int, 0)   as book_bal-- 账面余额
      ,t1.extra_dimen_cd	                    as extra_dimen_cd             --额外维度代码
      ,t1.stl_dt	                            as stl_dt                     --结算日期
      ,t1.ext_dimen_info	                    as ovdue_status               --逾期状态
      ,case when t44.is_ai_overdue = '1' or t44.is_cp_overdue = '1' then '1' else '0' end  as ovdue_flg   --逾期标志
      ,case when t44.is_cp_overdue = '1' then ${iml_schema}.dateformat_max(t44.beg_date_cp_overdue) else null end           as pric_ovdue_dt   -- 本金逾期日期 
      ,case when t44.is_cp_overdue = '1' then  decode(${iml_schema}.dateformat_max2(t44.beg_date_cp_overdue),to_date('29991231', 'yyyymmdd'),'0',
        to_date('${batch_date}', 'yyyymmdd') - ${iml_schema}.dateformat_max(t44.beg_date_cp_overdue))  else '0' end         as pric_ovdue_days -- 本金逾期天数
      ,case when t44.is_ai_overdue = '1' then ${iml_schema}.dateformat_max(t44.beg_date_ai_overdue) else null end                as int_ovdue_dt    -- 利息逾期日期
      ,case when t44.is_ai_overdue = '1' then decode(${iml_schema}.dateformat_max2(t44.beg_date_ai_overdue),to_date('29991231', 'yyyymmdd'),'0',
        to_date('${batch_date}', 'yyyymmdd')-${iml_schema}.dateformat_max(t44.beg_date_ai_overdue)) else '0' end            as int_ovdue_days   --利息逾期天数
      ,nvl(trim(t34.hx_undatype),t33.hx_undatype) as uder_asset_type_id     --底层资产类型编号
      ,case when coalesce(t6.prod_type_cd,t4.prod_type_cd) in ('0000','1100','1200') then coalesce(t34.hx_undatype,t33.hx_undatype)
            when t4.prod_type_cd = '0703' then '债券及债券公募基金'
            when t4.prod_type_cd = '0706' then '货币市场工具及货币市场公募基金'
            when t4.prod_type_cd = '0700' then t37.dict_value
            when t4.prod_type_cd = '0170' then t39.dict_value
            end                               as final_dir_type_descb          --最终投向类型描述
      ,case when coalesce(t6.prod_type_cd,t4.prod_type_cd) in ('0000','1100','1200') then t36.dict_value
            when t4.prod_type_cd in ('0703','0706') then '公开募集证券投资基金'
            when t4.prod_type_cd in ('0700','0170') then t41.dict_value
        end                  as final_dir_indus_gen        --最终投向行业大类
      ,t1.job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
  from ${iml_schema}.agt_secu_acct_accti_bal_h t1  --证券账户核算余额历史
 inner join ${iml_schema}.agt_intnal_secu_acct t2 --内部证券账户
    on t1.intnal_vch_acct_id = t2.acct_id
   and t2.acctnt_cls_cd <>'596'
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ibmsf1'
  left join ${iml_schema}.agt_ext_secu_acct t3 --外部证券账户
    on t1.ext_vch_acct_id = t3.acct_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'ibmsf1'
   and t3.id_mark <> 'D'
 inner join ${iml_schema}.prd_fin_instm t4 --金融工具表
    on t1.fin_instm_id = t4.fin_instm_id
   and t1.asset_type_id = t4.asset_type_id
   and t1.market_type_id = t4.market_type_id
   and t4.prod_type_cd in ('1100','0000')
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ibmsf1'
   and t4.prod_cls <> '同业存单'
   and t4.id_mark <> 'D'
/*left join ${iml_schema}.evt_ibank_tran t5 --同业交易表
    on t1.tran_num = t5.intnal_tran_num
   --and t5.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'ibmsi1'
   20210813 删除
   */
   left join (select fin_instm_id
                    ,asset_type_id
                    ,tran_market_id
                    ,final_dir_type_cd
                    ,row_number() over(partition by fin_instm_id,asset_type_id,tran_market_id order by stl_dt) as rn
                from ${iml_schema}.evt_ibank_tran
               where job_cd = 'ibmsi1'
                 and stl_status_cd = '999'
                 and tran_status_cd = '4'
                 and tran_type_id = '0170000'
                ) t5
    on t1.fin_instm_id = t5.fin_instm_id
   and t1.asset_type_id = t5.asset_type_id
   and t1.market_type_id = t5.tran_market_id
   and t5.rn = 1
 inner join ${iml_schema}.prd_ibank_bond t6 --同业债券
    on t1.fin_instm_id = t6.fin_instm_id
   and t1.asset_type_id = t6.asset_type_id
   and t1.market_type_id = t6.market_type_id
   and t6.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'ibmsf1'
   and t6.id_mark <> 'D'
  left join ${icl_schema}.tmp_cmm_ibank_bond_invest_02 t10
  	on t1.fin_instm_id = t10.fin_instm_id
   and t1.asset_type_id = t10.asset_type_id
   and t1.market_type_id = t10.market_type_id
   and t10.job_cd = 'ibmsi1'
  left join ${icl_schema}.tmp_cmm_ibank_bond_invest_01 t11
  	on t1.obj_id = t11.obj_id
  left join ${iml_schema}.ref_ibank_acctnt_type_cd t12
  	on t12.cls_id = t2.acctnt_cls_cd
   and t12.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t12.job_cd = 'ibmsf1'
   and t12.id_mark <> 'D'
  left join ${iol_schema}.ibms_tir_series t13
  	on t6.base_rat_id = t13.i_code
   and t6.base_asset_type_id = t13.a_type
   and t6.base_market_type_id = t13.m_type
   and to_date(t13.beg_date,'yyyy-mm-dd') <= to_date('${batch_date}', 'yyyymmdd')
   and to_date(t13.end_date,'yyyy-mm-dd') > to_date('${batch_date}', 'yyyymmdd')
  left join (select me.*,
                    row_number() over(partition by  me.i_code,me.a_type,me.m_type order by me.beg_date desc ) rn
               from ${iol_schema}.ibms_tbnd_manual_eval me
              where to_date(me.beg_date,'yyyy-mm-dd') <= to_date('${batch_date}', 'yyyymmdd')) t16
    on t1.fin_instm_id = t16.i_code
   and t1.asset_type_id = t16.a_type
   and t1.market_type_id = t16.m_type
   and t16.rn = 1
  left join ${iml_schema}.pty_ibank_cntpty_info t19
    on t6.issuer_id = t19.src_party_id
   and t19.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t19.job_cd = 'ibmsf1'
   and t19.id_mark <> 'D'
left join (select a.fin_instm_id ,a.asset_type_id,a.market_type_id,a.actl_int_rat
              from ${iml_schema}.prd_int_accr_dtl a
            left join  ${iol_schema}.ibms_ttrd_acc_cash_ext_map t
            	  on a.int_rat_flow_id = t.cash_accid
             where t.cash_ext_accid = '3080'
               and a.int_accr_start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and a.int_accr_end_dt>to_date('${batch_date}', 'yyyymmdd')
               and a.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and a.end_dt > to_date('${batch_date}', 'yyyymmdd')
               and a.job_cd = 'ibmsf1'
           ) t20
    on t6.fin_instm_id = t20.fin_instm_id
   and t6.asset_type_id = t20.asset_type_id
   and t6.market_type_id = t20.market_type_id
  left join ${icl_schema}.cmm_ibank_bond_invest t21
    on t1.obj_id = t21.obj_id
   and t21.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
  left join  ${iol_schema}.ibms_trpt_tbnd_ext t33
    on t4.fin_instm_id   = t33.i_code
   and t4.asset_type_id  = t33.a_type
   and t4.market_type_id = t33.m_type
   and t33.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t33.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join  ${iol_schema}.ibms_trpt_tbnd_ext t34
    on t6.fin_instm_id   = t34.i_code
   and t6.asset_type_id  = t34.a_type
   and t6.market_type_id = t34.m_type
   and t34.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t34.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_equity t35
    on t35.i_code = t4.fin_instm_id
   and t35.a_type = t4.asset_type_id
   and t35.m_type = t4.market_type_id
   and t35.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t35.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_dict_mult_lang t36
    on t36.dict_sub_type = 'Industry4HuaXing_'||coalesce(t34.hx_investcategory,t33.hx_investcategory)
   and t36.dict_key = coalesce(t34.hx_investbroheading,t33.hx_investbroheading)
   and t36.dict_type = 'dict'
   and t36.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t36.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_dict_mult_lang t37
    on t37.dict_key = t35.final_invest
   AND T37.dict_type = 'dict'
   AND T37.dict_lang = 'zh_CN'
   AND T37.dict_sub_type='FinalInvest'
   and t37.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t37.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_dict_mult_lang t39
    on t39.dict_key = t5.final_dir_type_cd
   AND T39.dict_type = 'dict'
   AND T39.dict_lang = 'zh_CN'
   AND T39.dict_sub_type='FinalInvest'
   and t39.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t39.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_cashlb_manage_ele t40
    on t4.fin_instm_id = t40.i_code
   and t4.asset_type_id = t40.a_type
   and t4.market_type_id = t40.m_type
   and t40.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t40.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ibms_ttrd_dict_mult_lang t41
   on t41.dict_key = t40.business_category_min
  AND T41.dict_type = 'dict'
  AND T41.dict_lang = 'zh_CN'
  AND T41.dict_sub_type='businessCategoryMin'
  left join ${icl_schema}.tmp_cmm_ibank_bond_invest_03 t31
   on  t31.trade_id=t1.tran_num
   and t31.typename=t12.cls_name
  left join ${iol_schema}.ibms_ttrd_credit_instrument_mapping t32
    on t1.fin_instm_id = t32.confirm_i_code
   and t1.asset_type_id = t32.confirm_a_type
   and t1.market_type_id = t32.confirm_m_type
   and t32.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t32.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_ibank_bond_invest_04 t42
    on t1.obj_id =t42.accti_obj_id
  left join (select inst_i_code,inst_a_type,inst_m_type,receive_ai
               from ${iol_schema}.ibms_ttrd_accounting_due_obj
              where start_dt <=to_date('${batch_date}', 'yyyymmdd')
                and end_dt >to_date('${batch_date}', 'yyyymmdd')
                and	to_date(beg_date, 'yyyy-mm-dd') = to_date('${batch_date}', 'yyyymmdd')
                and receive_ai <> 0
              union all 
             select inst_i_code,inst_a_type,inst_m_type,receive_ai
               from ${iol_schema}.ibms_ttrd_accounting_due_obj_his
              where to_date(beg_date, 'yyyy-mm-dd') = to_date('${batch_date}', 'yyyymmdd')
                and receive_ai <> 0
             ) t43
    on t1.fin_instm_id = t43.inst_i_code  
   and t1.asset_type_id = t43.inst_a_type 
   and t1.market_type_id = t43.inst_m_type
  left join ${iol_schema}.ibms_ttrd_overdue_handle t44
    on t1.fin_instm_id = t44.i_code  
   and t1.asset_type_id = t44.a_type 
   and t1.market_type_id = t44.m_type
   and t44.statu = '2'
   and t44.is_si <> '1'
   and t44.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t44.end_dt > to_date('${batch_date}','yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ibmsf1'
   and t4.prod_type_cd not in ('0121', '0300', '0304')
;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_ibank_bond_invest exchange partition p_${batch_date} with table ${icl_schema}.cmm_ibank_bond_invest_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_ibank_bond_invest_ex purge;
drop table ${icl_schema}.tmp_cmm_ibank_bond_invest_01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_ibank_bond_invest',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
