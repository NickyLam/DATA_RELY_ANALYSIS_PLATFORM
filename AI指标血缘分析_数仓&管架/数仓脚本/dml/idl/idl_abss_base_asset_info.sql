/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_abss_base_asset_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
    徐子豪 20221017 资产证券化重新确认贷款账户状态口径,如核心的账户状态为'C'关闭时,取账户状态,否则取核算状态。
    徐子豪 20230224 调整对公贷款账户状态口径,如核心的账户状态为'C'关闭时,取账户状态,否则取核算状态,调整当前逾期天数字段取账户表【本金逾期天数】【利息逾期天数】的最大值。
    陈伟峰 20251014 调整理财产品金额取数逻辑，从AST_GHB_FINC_PROD_INPWN_INFO取
    陈伟峰 20251219 新增字段【未偿息费余额】
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.abss_base_asset_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror continue none;
alter table ${idl_schema}.abss_base_asset_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 drop tmp table
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_abss_base_asset_info_01 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_02 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_03 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_04 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_05 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_06 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_07 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_08 purge;

-- 2.3 insert data to tmp table
-- 获取贷款借据还款明细信息（还款期数、应还款日期、逾期还款标志、提前还款标志）
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_abss_base_asset_info_01
nologging
compress ${option_switch} for query high
as
--零售贷款
select aa.dubil_id,          --借据编号
       aa.repay_perds,       --还款期数
       bb.repaybl_dt,        --应还款日期
       aa.ovdue_repay_flg,   --逾期还款标志
       aa.adv_repay_flg      --提前还款标志
  from (select dubil_id,     --借据编号
               min(ovdue_repay_flg) ovdue_repay_flg,   --逾期还款标志
               max(repay_perds) repay_perds,           --还款期数
               max(adv_repay_flg) adv_repay_flg        --提前还款标志
          from ${icl_schema}.cmm_retl_loan_repay_dtl
         where repay_dt <= to_date('${batch_date}','yyyymmdd')
         group by dubil_id
         ) aa
 inner join (select dubil_id,                      --借据编号
                    repay_perds,                   --还款期数
                    min(tot_perds) tot_perds,      --总期数
                    min(repaybl_dt) as repaybl_dt  --应还款日期
               from ${icl_schema}.cmm_retl_loan_repay_plan
              where etl_dt = to_date('${batch_date}', 'yyyymmdd')
              group by dubil_id, repay_perds
              ) bb
    on bb.dubil_id = aa.dubil_id
   and bb.repay_perds = aa.repay_perds
union all
--对公贷款
select aa.dubil_id,             --借据编号
       aa.repay_perds,          --还款期数
       bb.repaybl_dt,           --应还款日期
       aa.ovdue_repay_flg,      --逾期还款标志
       aa.adv_repay_flg         --提前还款标志
  from (select dubil_id,        --借据编号
               min(ovdue_repay_flg) ovdue_repay_flg,       --逾期还款标志
               max(repay_perds) repay_perds,               --还款期数
               max(adv_repay_flg) adv_repay_flg            --提前还款标志
          from ${icl_schema}.cmm_corp_loan_repay_dtl
         where repay_dt <= to_date('${batch_date}','yyyymmdd')
         group by dubil_id
         ) aa
 inner join (select dubil_id,                             --借据编号
                    repay_perds,                          --还款期数
                    min(tot_perds) tot_perds,             --总期数
                    min(repaybl_dt) as repaybl_dt         --应还款日期
               from ${icl_schema}.cmm_corp_loan_repay_plan
              where etl_dt = to_date('${batch_date}', 'yyyymmdd')
              group by dubil_id, repay_perds
              ) bb
    on bb.dubil_id = aa.dubil_id
   and bb.repay_perds = aa.repay_perds
;

-- 2.4 insert data to tmp table
-- 获取贷款合同信息（发放金额、贷款余额、逾期金额）
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_abss_base_asset_info_02
nologging
compress ${option_switch} for query high
as
--零售贷款
select a.cont_id                          --合同号
      ,sum(a.distr_amt) as distr_amt      --发放金额
      ,sum(a.cl_curr_currt_bal) as cl_curr_currt_bal      --贷款余额
      ,sum(a.ovdue_pric) as ovdue_pric    --逾期金额
     from ${icl_schema}.cmm_retl_loan_acct_info a--
    where a.etl_dt = to_date('${batch_date}','yyyymmdd')
 group by a.cont_id
union all
--对公贷款
select a.cont_id                          --合同号
      ,sum(a.distr_amt) as distr_amt      --发放金额
      ,sum(a.cl_curr_currt_bal) as cl_curr_currt_bal      --贷款余额
      ,sum(a.ovdue_pric) as ovdue_pric    --逾期金额
     from ${icl_schema}.cmm_corp_loan_acct_info a--
    where a.etl_dt = to_date('${batch_date}','yyyymmdd')
 group by a.cont_id
;

-- 2.5 insert data to tmp table
-- 获取贷款客户贷款余额
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_abss_base_asset_info_03
nologging
compress ${option_switch} for query high
as
select cust_id
      ,sum(cl_curr_currt_bal) as cl_curr_currt_bal
from
(
--零售贷款
select a.cust_id                   --客户号
      ,a.cl_curr_currt_bal         --贷款余额
     from ${icl_schema}.cmm_retl_loan_acct_info a--
where a.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
--对公贷款
select a.cust_id                   --客户号
      ,a.cl_curr_currt_bal         --贷款余额
     from ${icl_schema}.cmm_corp_loan_acct_info a--
where a.etl_dt = to_date('${batch_date}','yyyymmdd')
)
group by cust_id
;

-- 2.6 insert data to tmp table
-- 获取贷款合同的存单金额和理财产品金额
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_abss_base_asset_info_04
nologging
compress ${option_switch} for query high
as
--零售贷款
select a.cont_id                                                                              --合同号
      ,min(case when  c.guar_cont_type_cd='020' then '1' else '2' end) as guar_cont_type_cd   --是否涉及最高额担保
      ,sum(e.dep_rcpt_aval_amt) as dep_rcpt_aval_amt                                          --存单金额
      ,sum(nvl(f.tot_lot,0)) as col_cost             --理财产品金额
     from ${icl_schema}.cmm_retl_loan_cont_info a -- 零售贷款合同信息
left join ${icl_schema}.cmm_loan_guar_cont_rela b -- 贷款合同与担保合同关系
 on a.cont_id=b.loan_cont_id
 and a.lp_id = b.lp_id
 and b.etl_dt=to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_guar_cont c          -- 担保合同
 on b.guar_cont_id=c.guar_cont_id
 and b.lp_id = c.lp_id
 and c.etl_dt=to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_col_guar_cont_rela d -- 押品与担保合同关系
 on b.guar_cont_id=d.guar_cont_id
 and b.lp_id = d.lp_id
 and d.etl_dt=to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_col_info e           -- 押品信息
 on d.col_id=e.col_id
 and d.lp_id = e.lp_id
 and e.etl_dt=to_date('${batch_date}','yyyymmdd')
left join ${iml_schema}.ast_ghb_finc_prod_inpwn_info f
 on e.col_id=f.asset_id
 and e.lp_id = f.lp_id
 and f.job_cd ='icmsf1'
 and f.create_dt <=to_date('${batch_date}','yyyymmdd')
 and f.id_mark<>'D'
 where a.etl_dt=to_date('${batch_date}','yyyymmdd')
 group by a.cont_id
union all
--对公贷款
select a.cont_id                                                                              --合同号
      ,min(case when  c.guar_cont_type_cd='020' then '1' else '2' end) as guar_cont_type_cd   --是否涉及最高额担保
      ,sum(e.dep_rcpt_aval_amt) as dep_rcpt_aval_amt                                          --存单金额
      ,sum(nvl(f.tot_lot,0)) as col_cost             --理财产品金额
     from ${icl_schema}.cmm_corp_loan_cont_info a -- 对公贷款合同信息
left join ${icl_schema}.cmm_loan_guar_cont_rela b -- 贷款合同与担保合同关系
 on a.cont_id=b.loan_cont_id
 and a.lp_id = b.lp_id
 and b.etl_dt=to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_guar_cont c          -- 担保合同
 on b.guar_cont_id=c.guar_cont_id
 and b.lp_id = c.lp_id
 and c.etl_dt=to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_col_guar_cont_rela d -- 押品与担保合同关系
 on b.guar_cont_id=d.guar_cont_id
 and b.lp_id = d.lp_id
 and d.etl_dt=to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_col_info e           -- 押品信息
 on d.col_id=e.col_id
 and d.lp_id = e.lp_id
 and e.etl_dt=to_date('${batch_date}','yyyymmdd')
left join ${iml_schema}.ast_ghb_finc_prod_inpwn_info f
 on e.col_id=f.asset_id
 and e.lp_id = f.lp_id
 and f.job_cd ='icmsf1'
 and f.create_dt <=to_date('${batch_date}','yyyymmdd')
 and f.id_mark<>'D'
 where a.etl_dt=to_date('${batch_date}','yyyymmdd')
 group by a.cont_id
;

-- 2.7 insert data to tmp table
-- 获取贷款资产转让的封包日时点金额、封包交易日时点金额
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_abss_base_asset_info_05
nologging
compress ${option_switch} for query high
as
select t2.acct_id as acct_id
      ,sum(t1.pkg_day_tm_point_amt) as pkg_day_tm_point_amt -- 封包前应收利息余额
--      ,SUM(T1.pkg_day_tm_point_amt) + SUM(T1.pkg_tran_day_tm_point_amt) AS PACK_AMT2 --封包后应收利息总额
      ,sum(t1.pkg_tran_day_tm_point_amt) as pkg_tran_day_tm_point_amt --封包后应收利息余额
from ${iml_schema}.agt_abs_amt_dtl_h t1
inner join ${iml_schema}.agt_abs_cont_dtl_h t2
on t1.asset_bag_cont_dtl_seq_num = t2.asset_bag_cont_dtl_seq_num
and t2.start_dt < = to_date('${batch_date}','yyyymmdd')
and t2.end_dt > to_date('${batch_date}','yyyymmdd')
where t1.start_dt < = to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.amt_type_cd in ('INT','INTP','ODP','ODPP','ODI','ODIP')
--金额类型|bal-余额,dda-发放金额,intp-逾期利息,lim-额度金额,od-透支金额,odip-逾期复利,odpp-逾期罚息,osl-未到期本金,prd-逾期本金,pri-本金
group by t2.acct_id
;


-- 2.8 insert data to tmp table
-- 获取贷款资产转让的已归还封包后应收利息(应付行内金额-贷款剩余金额)
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_abss_base_asset_info_06
nologging
compress ${option_switch} for query high
as
select t2.acct_id as acct_id
      ,sum(t1.paybl_bank_int_amt)  as paybl_bank_int_amt
--      ,sum(t1.paybl_bank_int_amt) - sum(t1.loan_surp_amt) as cope_amount --已归还封包后应收利息
      ,sum(t1.loan_surp_amt) as loan_surp_amt
from ${iml_schema}.agt_abs_amt_dtl_splt_h t1
inner join ${iml_schema}.agt_abs_cont_dtl_h t2
on t1.asset_bag_cont_dtl_seq_num = t2.asset_bag_cont_dtl_seq_num
and t2.start_dt < = to_date('${batch_date}','yyyymmdd')
and t2.end_dt > to_date('${batch_date}','yyyymmdd')
where t1.start_dt < = to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.amt_type_cd in ('INT','INTP','ODP','ODPP','ODI','ODIP')
--金额类型|bal-余额,dda-发放金额,intp-逾期利息,lim-额度金额,od-透支金额,odip-逾期复利,odpp-逾期罚息,osl-未到期本金,prd-逾期本金,pri-本金
group by t2.acct_id
;

-- 2.9 insert data to tmp table
-- 获取客户证件类型和证件号码
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_abss_base_asset_info_07
nologging
compress ${option_switch} for query high
as
select party_id
      ,lp_id
      ,sorc_sys_cd
      ,cert_type_cd
      ,cert_num
      ,main_cert_no_flg
      ,cert_effect_dt
			,row_number() over(partition by s1.party_id order by nvl(trim(s1.main_cert_no_flg), '0') desc, s1.cert_effect_dt desc) as rn
 from ${iml_schema}.pty_party_cert_info_h s1
where s1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and s1.end_dt > to_date('${batch_date}','yyyymmdd')
  and s1.job_cd = 'eifsf1'
;



-- 3.0 insert data to tmp table
-- 获取每笔贷款的未偿息费余额
create table ${idl_schema}.tmp_abss_base_asset_info_08 
as 
select internal_key,sum(int)as int from (
select internal_key, nvl(int_accrued, 0) + nvl(int_adj, 0) int
  from ${iol_schema}.ncbs_cl_acct_int_detail --利息明细表   
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')
union all
select internal_key, nvl(outstanding, 0) int
  from ${iol_schema}.ncbs_cl_acct_schedule_detail --账户计划明细表  
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')
   and amt_type = 'INT'
union all
select internal_key, outstanding int
  from ${iol_schema}.ncbs_cl_invoice_od_detail --罚息复利出单明细表 
 where amt_type = 'ODP'
   and etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select internal_key, nvl(int_accrued, 0) + nvl(int_adj, 0) int
  from ${iol_schema}.ncbs_cl_acct_odp_detail --罚息计息表   
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')
union all
select internal_key, nvl(int_accrued, 0) + nvl(int_adj, 0) int
  from ${iol_schema}.ncbs_cl_acct_odi_detail --复利计息表   
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')
union all
select internal_key, outstanding int
  from ${iol_schema}.ncbs_cl_invoice_od_detail --罚息复利出单明细表  
 where amt_type = 'ODI'
   and etl_dt = to_date('${batch_date}','yyyymmdd')
)
group by internal_key
;

-- 3.1 create table for exchage and add partition

whenever sqlerror continue none ;
drop table ${idl_schema}.abss_base_asset_info_ex purge;
drop table ${idl_schema}.abss_base_asset_info_ex01 purge;
drop table ${idl_schema}.abss_base_asset_info_ex02 purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.abss_base_asset_info_ex
nologging
compress ${option_switch} for query high
as select * from ${idl_schema}.abss_base_asset_info where 0=1;

create table ${idl_schema}.abss_base_asset_info_ex01
nologging
compress ${option_switch} for query high
as select * from ${idl_schema}.abss_base_asset_info where 0=1;

create table ${idl_schema}.abss_base_asset_info_ex02
nologging
compress ${option_switch} for query high
as select * from ${idl_schema}.abss_base_asset_info where 0=1;

-- 3.2 insert data target table
whenever sqlerror exit sql.sqlcode;
--零售贷款
insert /*+ append */ into ${idl_schema}.abss_base_asset_info_ex01 (
    etl_dt                      --数据日期
   ,asset_src_cd                --资产来源代码
   ,asset_id                    --资产编号
   ,contr_id                    --合同编号
   ,asst_type_cd                --资产类型代码
   ,prod_id                     --产品编号
   ,prod_name                   --产品名称
   ,value_dt                    --起息日期
   ,exp_dt                      --到期日期
   ,loan_tenor_mon              --贷款期限（月）
   ,loan_tenor_day              --贷款期限（天）
   ,loan_tot_perds              --贷款总期数
   ,surp_perds                  --剩余期数
   ,repay_way_cd                --还款方式代码
   ,repay_ped_corp_cd           --还款周期单位代码
   ,curr_repaybl_dt             --当前应还款日期
   ,curr_cd                     --币种代码
   ,loan_amt                    --贷款金额
   ,loan_bal                    --贷款余额
   ,ovdue_pric_bal              --逾期本金余额
   ,fir_ovdue_dt                --首次逾期日期
   ,curr_ovdue_days             --当前逾期天数
   ,int_ovdue_days              --利息逾期天数
   ,curr_unexp_int              --当前未到期利息（计提利息）
   ,in_bs_over_int_bal          --表内欠息余额
   ,off_bs_over_int_bal         --表外欠息余额
   ,pric_pnlt                   --本金罚息
   ,int_pnlt                    --利息罚息
   ,loan_level5_cls_cd          --贷款五级分类代码
   ,int_rat_type_cd             --利率类型代码
   ,exec_int_rat                --执行利率
   ,int_rat_adj_way_cd          --利率调整方式代码
   ,base_rat_type_cd            --基准利率类型代码
   ,base_rat                    --基准利率
   ,int_rat_float_way_cd        --利率浮动方式代码
   ,int_rat_flo_val             --利率浮动值
   ,ovdue_int_rat_type_cd       --逾期利率类型代码
   ,ovdue_int_rat               --逾期利率
   ,bond_item_rating_cd         --债项评级代码
   ,loan_repay_num              --贷款还款账号
   ,loan_acct_status_cd         --贷款账户状态代码
   ,loan_proc_dt                --贷款处理日期
   ,operr_id                    --经办人编号
   ,oper_org_id                 --经办机构编号
   ,acct_instit_id              --账务机构编号
   ,acct_instit_name            --账务机构名称
   ,cust_type_cd                --客户类型代码
   ,cust_id                     --客户编号
   ,cust_name                   --客户名称
   ,cert_type_cd                --证件类型代码
   ,cert_no                     --证件号码
   ,unify_soci_crdt_cd          --统一社会信用代码
   ,resdnt_addr                 --常住地址
   ,brwer_crdt_lmt              --借款人授信额度
   ,cust_ghb_loan_bal           --客户在本行贷款余额
   ,ot_bank_loan_ovdue_perds    --在其他银行贷款的历史最长逾期期数
   ,crdt_score                  --信用评分
   ,cust_rating_cd              --客户评级代码
   ,gender_cd                   --性别代码
   ,age                         --年龄
   ,nationty_cd                 --民族代码
   ,birth_dt                    --出生日期
   ,nation_cd                   --国籍代码
   ,brwer_city_cd               --借款人所在城市（地级市）
   ,brwer_prov_cd               --借款人所在省份
   ,career_cd                   --职业代码
   ,degree_cd                   --学位代码
   ,edu_cd                      --学历代码
   ,marriage_situ_cd            --婚姻状况代码
   ,family_addr                 --家庭住址
   ,work_unit_name              --工作单位名称
   ,corp_bl_induty_type_cd      --单位所属行业类型代码
   ,indv_anl_inco               --个人年收入
   ,ghb_emply_flg               --本行员工标志
   ,orgnz_cd                    --组织机构代码
   ,econ_char_cd                --经济性质代码
   ,indus_cls_cd                --行业分类代码
   ,corp_size_cd                --企业规模代码
   ,list_corp_flg               --上市企业标志
   ,cty_rg_cd                   --国家和地区代码
   ,rgst_addr                   --注册地址
   ,group_cust_flg              --集团客户标志
   ,belong_group_name           --所属集团名称
   ,loan_happ_type_cd           --贷款发生类型代码
   ,cont_text_id                --合同文本编号
   ,cont_begin_dt               --合同起始日期
   ,cont_tenor_mon              --合同期限（月）
   ,cont_exp_dt                 --合同到期日期
   ,pm_rat                      --抵质押率
   ,cont_amt                    --合同金额
   ,actl_distrd_amt             --实际已发放金额
   ,cont_bal                    --合同余额
   ,cont_nomal_bal              --合同正常余额
   ,cont_ovdue_bal              --合同逾期余额
   ,indus_dir_cd                --行业投向代码
   ,circl_flg                   --循环标志
   ,brw_new_return_old_cnt      --借新还旧次数
   ,main_guar_way_cd            --主担保方式代码
   ,higt_lmt_guar_flg           --最高额担保标志
   ,loan_usage_type_cd          --贷款用途类型代码
   ,renew_cnt                   --展期次数
   ,margin_ratio                --保证金比例
   ,margin_amt                  --保证金金额
   ,dep_rcpt_amt                --存单金额
   ,tbond_amt                   --国债金额
   ,finc_prod_amt               --理财产品金额
   ,asset_tran_status_cd        --资产转让状态代码
   ,pkg_bf_int_recvbl_bal       --封包前应收利息余额
   ,pkg_post_int_recvbl_tot     --封包后应收利息总额
   ,pkg_post_int_recvbl_bal     --封包后应收利息余额
   ,rtn_pkg_post_int_recvbl     --已归还封包后应收利息
   ,tran_loan_int_tot           --转让贷款利息总额
   ,int_recvbl                  --应收利息
   ,unrepay_int_fee_bal         --未偿息费余额
   ,job_cd                      --任务代码
   ,etl_timestamp               --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')                                                                        as etl_dt                   --数据日期
   ,'10'                                                                                                       as asset_src_cd             --资产来源代码
   ,t1.dubil_num                                                                                               as asset_id                 --资产编号
   ,t1.cont_id                                                                                                 as contr_id                 --合同编号
   ,'001'                                                                                                      as asst_type_cd             --资产类型代码
   ,t1.std_prod_id                                                                                             as prod_id                  --产品编号
   ,t3.prod_name                                                                                               as prod_name                --产品名称
   ,t1.value_dt                                                                                                as value_dt                 --起息日期
   ,t1.exp_dt                                                                                                  as exp_dt                   --到期日期
   ,months_between(t1.exp_dt,t1.value_dt)                                                                      as loan_tenor_mon           --贷款期限（月）
   ,ceil(t1.exp_dt-t1.value_dt)                                                                                as loan_tenor_day           --贷款期限（天）
   ,t1.tot_perds                                                                                               as loan_tot_perds           --贷款总期数
   ,t1.tot_perds - t1.curr_issue_perds                                                                         as surp_perds               --剩余期数
   ,t1.repay_way_cd                                                                                            as repay_way_cd             --还款方式代码
   ,t1.repay_ped_corp_cd                                                                                       as repay_ped_corp_cd        --还款周期单位代码
   ,t5.repaybl_dt                                                                                              as curr_repaybl_dt          --当前应还款日期
   ,t1.curr_cd                                                                                                 as curr_cd                  --币种代码
   ,t1.distr_amt                                                                                               as loan_amt                 --贷款金额
   ,t1.currt_bal                                                                                               as loan_bal                 --贷款余额
   ,t1.ovdue_pric_bal                                                                                          as ovdue_pric_bal           --逾期本金余额
   ,t1.fir_ovdue_dt                                                                                            as fir_ovdue_dt             --首次逾期日期
   ,greatest(t1.pric_ovdue_days,t1.int_ovdue_days)                                                             as curr_ovdue_days          --当前逾期天数
   ,t1.int_ovdue_days                                                                                          as int_ovdue_days           --利息逾期天数
   ,t1.recvbl_acru_int + t1.coll_acru_int                                                                      as curr_unexp_int           --当前未到期利息（计提利息）
   ,t1.recvbl_over_int                                                                                         as in_bs_over_int_bal       --表内欠息余额
   ,t1.coll_over_int                                                                                           as off_bs_over_int_bal      --表外欠息余额
   ,t1.recvbl_acru_pnlt + t1.recvbl_pnlt + t1.coll_acru_pnlt + t1.coll_pnlt                                    as pric_pnlt                --本金罚息
   ,t1.acru_comp_int + t1.recvbl_comp_int                                                                      as int_pnlt                 --利息罚息
   ,nvl(t2.loan_level5_cls_cd,'90')                                                                            as loan_level5_cls_cd       --贷款五级分类代码
   ,t1.int_rat_base_type_cd                                                                                    as int_rat_type_cd          --利率类型代码
   ,t1.exec_int_rat                                                                                            as exec_int_rat             --执行利率
   ,t1.int_rat_adj_way_cd                                                                                      as int_rat_adj_way_cd       --利率调整方式代码
   ,t1.int_rat_base_type_cd                                                                                    as base_rat_type_cd         --基准利率类型代码
   ,t1.base_rat                                                                                                as base_rat                 --基准利率
   ,t1.int_rat_float_way_cd                                                                                    as int_rat_float_way_cd     --利率浮动方式代码
   ,t1.int_rat_flo_val                                                                                         as int_rat_flo_val          --利率浮动值
   ,'RAT02'                                                                                                    as ovdue_int_rat_type_cd    --逾期利率类型代码
   ,t1.ovdue_int_rat                                                                                           as ovdue_int_rat            --逾期利率
   ,''                                                                                                         as bond_item_rating_cd      --债项评级代码
   ,t1.loan_repay_num                                                                                          as loan_repay_num           --贷款还款账号
   ,case when t1.loan_acct_status_cd='C' then t1.loan_acct_status_cd else t1.loan_modal_cd end                 as loan_acct_status_cd      --贷款账户状态代码
   ,''                                                                                                         as loan_proc_dt             --贷款处理日期
   ,t2.cust_mgr_id                                                                                             as operr_id                 --经办人编号
   ,t2.mgmt_org_id                                                                                             as oper_org_id              --经办机构编号
   ,t1.acct_instit_id                                                                                          as acct_instit_id           --账务机构编号
   ,t4.org_abbr                                                                                                as acct_instit_name         --账务机构名称
   ,t6.cust_type_cd                                                                                            as cust_type_cd             --客户类型代码
   ,t1.cust_id                                                                                                 as cust_id                  --客户编号
   ,t1.acct_name                                                                                               as cust_name                --客户名称
   ,t6.cert_type_cd                                                                                            as cert_type_cd             --证件类型代码
   ,t6.cert_no                                                                                                 as cert_no                  --证件号码
   ,''                                                                                                         as unify_soci_crdt_cd       --统一社会信用代码
   ,t6.resdnt_addr                                                                                             as resdnt_addr              --常住地址
   ,nvl(nvl(nvl(t7.cont_amt,t9.crdt_lmt),t10.crdt_lmt),0)                                                      as brwer_crdt_lmt           --借款人授信额度
   ,nvl(t11.cl_curr_currt_bal,0)                                                                               as cust_ghb_loan_bal        --客户在本行贷款余额
   ,0                                                                                                          as ot_bank_loan_ovdue_perds --在其他银行贷款的历史最长逾期期数
   ,t12.score_val                                                                                              as crdt_score               --信用评分
   ,''                                                                                                         as cust_rating_cd           --客户评级代码
   ,t6.gender_cd                                                                                               as gender_cd                --性别代码
   ,(to_char(to_date('${batch_date}','yyyymmdd'),'yyyy')-to_char(t6.birth_dt,'yyyy'))                          as age                      --年龄
   ,t6.nationty_cd                                                                                             as nationty_cd              --民族代码
   ,t6.birth_dt                                                                                                as birth_dt                 --出生日期
   ,t6.nation_cd                                                                                               as nation_cd                --国籍代码
   ,''                                                                                                         as brwer_city_cd            --借款人所在城市（地级市）
   ,''                                                                                                         as brwer_prov_cd            --借款人所在省份
   ,t6.career_cd                                                                                               as career_cd                --职业代码
   ,t6.degree_cd                                                                                               as degree_cd                --学位代码
   ,t6.edu_cd                                                                                                  as edu_cd                   --学历代码
   ,t6.marriage_situ_cd                                                                                        as marriage_situ_cd         --婚姻状况代码
   ,t6.family_addr                                                                                             as family_addr              --家庭住址
   ,t6.work_unit_name                                                                                          as work_unit_name           --工作单位名称
   ,t6.corp_bl_induty_type_cd                                                                                  as corp_bl_induty_type_cd   --单位所属行业类型代码
   ,t6.indv_anl_inco                                                                                           as indv_anl_inco            --个人年收入
   ,t6.ghb_emply_flg                                                                                           as ghb_emply_flg            --本行员工标志
   ,''                                                                                                         as orgnz_cd                 --组织机构代码
   ,''                                                                                                         as econ_char_cd             --经济性质代码
   ,''                                                                                                         as indus_cls_cd             --行业分类代码
   ,''                                                                                                         as corp_size_cd             --企业规模代码
   ,''                                                                                                         as list_corp_flg            --上市企业标志
   ,''                                                                                                         as cty_rg_cd                --国家和地区代码
   ,t6.resdnt_addr                                                                                             as rgst_addr                --注册地址
   ,''                                                                                                         as group_cust_flg           --集团客户标志
   ,''                                                                                                         as belong_group_name        --所属集团名称
   ,t7.loan_happ_type_cd                                                                                       as loan_happ_type_cd        --贷款发生类型代码
   ,t7.cont_name                                                                                               as cont_text_id             --合同文本编号
   ,t7.start_dt                                                                                                as cont_begin_dt            --合同起始日期
   ,nvl(t7.tenor,0)                                                                                            as cont_tenor_mon           --合同期限（月）
   ,t7.termnt_dt                                                                                               as cont_exp_dt              --合同到期日期
   ,nvl(t7.avg_pm_rat,0)                                                                                       as pm_rat                   --抵质押率
   ,nvl(t7.cont_amt,0)                                                                                         as cont_amt                 --合同金额
   ,nvl(t7.acm_distr_amt,0)                                                                                    as actl_distrd_amt          --实际已发放金额
   ,nvl(t7.cont_amt,0) - nvl(t7.acm_distr_amt,0)                                                               as cont_bal                 --合同余额
   ,nvl(t8.cl_curr_currt_bal,0) - nvl(t8.ovdue_pric,0)                                                         as cont_nomal_bal           --合同正常余额
   ,nvl(t8.ovdue_pric,0)                                                                                       as cont_ovdue_bal           --合同逾期余额
   ,t7.dir_indus_cd                                                                                            as indus_dir_cd             --行业投向代码
   ,''                                                                                                         as circl_flg                --循环标志
   ,0                                                                                                          as brw_new_return_old_cnt   --借新还旧次数
   ,t7.major_guar_way_cd                                                                                       as main_guar_way_cd         --主担保方式代码
   ,t13.guar_cont_type_cd                                                                                      as higt_lmt_guar_flg        --最高额担保标志
   ,t7.borw_usage_type_cd                                                                                      as loan_usage_type_cd       --贷款用途类型代码
   ,0                                                                                                          as renew_cnt                --展期次数
   ,0                                                                                                          as margin_ratio             --保证金比例
   ,0                                                                                                          as margin_amt               --保证金金额
   ,nvl(t13.dep_rcpt_aval_amt,0)                                                                               as dep_rcpt_amt             --存单金额
   ,0                                                                                                          as tbond_amt                --国债金额
   ,t13.col_cost                                                                                               as finc_prod_amt            --理财产品金额
   ,t1.asset_tran_status_cd                                                                                    as asset_tran_status_cd     --资产转让状态代码
   ,nvl(t14.pkg_day_tm_point_amt,0)                                                                            as pkg_bf_int_recvbl_bal    --封包前应收利息余额
   ,nvl(t14.pkg_day_tm_point_amt,0) + nvl(t14.pkg_tran_day_tm_point_amt,0)                                     as pkg_post_int_recvbl_tot  --封包后应收利息总额
   ,nvl(t14.pkg_tran_day_tm_point_amt,0)                                                                       as pkg_post_int_recvbl_bal  --封包后应收利息余额
   ,nvl(t15.paybl_bank_int_amt,0) - nvl(t15.loan_surp_amt,0)                                                   as rtn_pkg_post_int_recvbl  --已归还封包后应收利息
   ,t1.tran_bf_int_recvbl                                                                                      as tran_loan_int_tot        --转让贷款利息总额
   ,nvl(t1.recvbl_over_int,0) + nvl(t1.coll_over_int,0)                                                        as int_recvbl               --应收利息
   ,t16.int                                                                                                   as unrepay_int_fee_bal    --未偿息费余额
   ,t1.job_cd as job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp
 from ${icl_schema}.cmm_retl_loan_acct_info t1
left join ${icl_schema}.cmm_retl_loan_dubil_info t2
on t1.dubil_num = t2.dubil_id
and t1.lp_id = t2.lp_id
and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_std_prod_info t3
on t1.std_prod_id = t3.prod_id
and t1.lp_id = t3.lp_id
and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_intnal_org_info t4
on t1.acct_instit_id = t4.org_id
and t1.lp_id = t4.lp_id
and t4.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${idl_schema}.tmp_abss_base_asset_info_01 t5
on t1.dubil_num = t5.dubil_id
left join ${icl_schema}.cmm_indv_cust_basic_info t6
on t1.cust_id = t6.cust_id
and t1.lp_id = t6.lp_id
and t6.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_retl_loan_cont_info t7
on t1.cont_id = t7.cont_id
and t1.lp_id = t7.lp_id
and t7.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${idl_schema}.tmp_abss_base_asset_info_02 t8
on t1.cont_id = t8.cont_id
left join ${icl_schema}.cmm_retl_loan_crdt_lmt_info t9
on t7.lmt_cont_id = t9.lmt_cont_id
and t7.lp_id = t9.lp_id
and t9.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_retl_loan_crdt_lmt_info t10
on t7.apv_flow_num = t10.lmt_cont_id
and t7.lp_id = t10.lp_id
and t10.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${idl_schema}.tmp_abss_base_asset_info_03 t11
on t1.cust_id = t11.cust_id
left join ${icl_schema}.cmm_retl_loan_appl_info t12
on t7.apv_flow_num = t12.loan_appl_flow_num
and t7.lp_id = t12.lp_id
and t12.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${idl_schema}.tmp_abss_base_asset_info_04 t13
on t1.cont_id = t13.cont_id
left join ${idl_schema}.tmp_abss_base_asset_info_05 t14
on t1.acct_id = t14.acct_id
left join ${idl_schema}.tmp_abss_base_asset_info_06 t15
on t1.acct_id = t15.acct_id
left join ${idl_schema}.tmp_abss_base_asset_info_08 t16
on t1.acct_id = t16.internal_key
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3.3 insert data target table
whenever sqlerror exit sql.sqlcode;
--对公贷款
insert /*+ append */ into ${idl_schema}.abss_base_asset_info_ex02 (
    etl_dt                      --数据日期
   ,asset_src_cd                --资产来源代码
   ,asset_id                    --资产编号
   ,contr_id                    --合同编号
   ,asst_type_cd                --资产类型代码
   ,prod_id                     --产品编号
   ,prod_name                   --产品名称
   ,value_dt                    --起息日期
   ,exp_dt                      --到期日期
   ,loan_tenor_mon              --贷款期限（月）
   ,loan_tenor_day              --贷款期限（天）
   ,loan_tot_perds              --贷款总期数
   ,surp_perds                  --剩余期数
   ,repay_way_cd                --还款方式代码
   ,repay_ped_corp_cd           --还款周期单位代码
   ,curr_repaybl_dt             --当前应还款日期
   ,curr_cd                     --币种代码
   ,loan_amt                    --贷款金额
   ,loan_bal                    --贷款余额
   ,ovdue_pric_bal              --逾期本金余额
   ,fir_ovdue_dt                --首次逾期日期
   ,curr_ovdue_days             --当前逾期天数
   ,int_ovdue_days              --利息逾期天数
   ,curr_unexp_int              --当前未到期利息（计提利息）
   ,in_bs_over_int_bal          --表内欠息余额
   ,off_bs_over_int_bal         --表外欠息余额
   ,pric_pnlt                   --本金罚息
   ,int_pnlt                    --利息罚息
   ,loan_level5_cls_cd          --贷款五级分类代码
   ,int_rat_type_cd             --利率类型代码
   ,exec_int_rat                --执行利率
   ,int_rat_adj_way_cd          --利率调整方式代码
   ,base_rat_type_cd            --基准利率类型代码
   ,base_rat                    --基准利率
   ,int_rat_float_way_cd        --利率浮动方式代码
   ,int_rat_flo_val             --利率浮动值
   ,ovdue_int_rat_type_cd       --逾期利率类型代码
   ,ovdue_int_rat               --逾期利率
   ,bond_item_rating_cd         --债项评级代码
   ,loan_repay_num              --贷款还款账号
   ,loan_acct_status_cd         --贷款账户状态代码
   ,loan_proc_dt                --贷款处理日期
   ,operr_id                    --经办人编号
   ,oper_org_id                 --经办机构编号
   ,acct_instit_id              --账务机构编号
   ,acct_instit_name            --账务机构名称
   ,cust_type_cd                --客户类型代码
   ,cust_id                     --客户编号
   ,cust_name                   --客户名称
   ,cert_type_cd                --证件类型代码
   ,cert_no                     --证件号码
   ,unify_soci_crdt_cd          --统一社会信用代码
   ,resdnt_addr                 --常住地址
   ,brwer_crdt_lmt              --借款人授信额度
   ,cust_ghb_loan_bal           --客户在本行贷款余额
   ,ot_bank_loan_ovdue_perds    --在其他银行贷款的历史最长逾期期数
   ,crdt_score                  --信用评分
   ,cust_rating_cd              --客户评级代码
   ,gender_cd                   --性别代码
   ,age                         --年龄
   ,nationty_cd                 --民族代码
   ,birth_dt                    --出生日期
   ,nation_cd                   --国籍代码
   ,brwer_city_cd               --借款人所在城市（地级市）
   ,brwer_prov_cd               --借款人所在省份
   ,career_cd                   --职业代码
   ,degree_cd                   --学位代码
   ,edu_cd                      --学历代码
   ,marriage_situ_cd            --婚姻状况代码
   ,family_addr                 --家庭住址
   ,work_unit_name              --工作单位名称
   ,corp_bl_induty_type_cd      --单位所属行业类型代码
   ,indv_anl_inco               --个人年收入
   ,ghb_emply_flg               --本行员工标志
   ,orgnz_cd                    --组织机构代码
   ,econ_char_cd                --经济性质代码
   ,indus_cls_cd                --行业分类代码
   ,corp_size_cd                --企业规模代码
   ,list_corp_flg               --上市企业标志
   ,cty_rg_cd                   --国家和地区代码
   ,rgst_addr                   --注册地址
   ,group_cust_flg              --集团客户标志
   ,belong_group_name           --所属集团名称
   ,loan_happ_type_cd           --贷款发生类型代码
   ,cont_text_id                --合同文本编号
   ,cont_begin_dt               --合同起始日期
   ,cont_tenor_mon              --合同期限（月）
   ,cont_exp_dt                 --合同到期日期
   ,pm_rat                      --抵质押率
   ,cont_amt                    --合同金额
   ,actl_distrd_amt             --实际已发放金额
   ,cont_bal                    --合同余额
   ,cont_nomal_bal              --合同正常余额
   ,cont_ovdue_bal              --合同逾期余额
   ,indus_dir_cd                --行业投向代码
   ,circl_flg                   --循环标志
   ,brw_new_return_old_cnt      --借新还旧次数
   ,main_guar_way_cd            --主担保方式代码
   ,higt_lmt_guar_flg           --最高额担保标志
   ,loan_usage_type_cd          --贷款用途类型代码
   ,renew_cnt                   --展期次数
   ,margin_ratio                --保证金比例
   ,margin_amt                  --保证金金额
   ,dep_rcpt_amt                --存单金额
   ,tbond_amt                   --国债金额
   ,finc_prod_amt               --理财产品金额
   ,asset_tran_status_cd        --资产转让状态代码
   ,pkg_bf_int_recvbl_bal       --封包前应收利息余额
   ,pkg_post_int_recvbl_tot     --封包后应收利息总额
   ,pkg_post_int_recvbl_bal     --封包后应收利息余额
   ,rtn_pkg_post_int_recvbl     --已归还封包后应收利息
   ,tran_loan_int_tot           --转让贷款利息总额
   ,int_recvbl                  --应收利息
   ,unrepay_int_fee_bal         --未偿息费余额
   ,job_cd                      --任务代码
   ,etl_timestamp               --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')                                                                         as etl_dt                   --数据日期
   ,'20'                                                                                                        as asset_src_cd             --资产来源代码
   ,t1.dubil_num                                                                                                as asset_id                 --资产编号
   ,t1.cont_id                                                                                                  as contr_id                 --合同编号
   ,'002'                                                                                                       as asst_type_cd             --资产类型代码
   ,t1.std_prod_id                                                                                              as prod_id                  --产品编号
   ,t3.prod_name                                                                                                as prod_name                --产品名称
   ,t1.value_dt                                                                                                 as value_dt                 --起息日期
   ,t1.exp_dt                                                                                                   as exp_dt                   --到期日期
   ,months_between(t1.exp_dt,t1.value_dt)                                                                       as loan_tenor_mon           --贷款期限（月）
   ,ceil(t1.exp_dt-t1.value_dt)                                                                                 as loan_tenor_day           --贷款期限（天）
   ,t1.tot_perds                                                                                                as loan_tot_perds           --贷款总期数
   ,nvl(t1.tot_perds,0) - nvl(t1.curr_issue_perds,0)                                                            as surp_perds               --剩余期数
   ,t1.repay_way_cd                                                                                             as repay_way_cd             --还款方式代码
   ,t1.repay_ped_corp_cd                                                                                        as repay_ped_corp_cd        --还款周期单位代码
   ,t5.repaybl_dt                                                                                               as curr_repaybl_dt          --当前应还款日期
   ,t1.curr_cd                                                                                                  as curr_cd                  --币种代码
   ,t1.distr_amt                                                                                                as loan_amt                 --贷款金额
   ,t1.currt_bal                                                                                                as loan_bal                 --贷款余额
   ,t1.ovdue_pric_bal                                                                                           as ovdue_pric_bal           --逾期本金余额
   ,t1.fir_ovdue_dt                                                                                             as fir_ovdue_dt             --首次逾期日期
   ,greatest(t1.pric_ovdue_days,t1.int_ovdue_days)                                                              as curr_ovdue_days          --当前逾期天数
   ,t1.int_ovdue_days                                                                                           as int_ovdue_days           --利息逾期天数
   ,0                                                                                                           as curr_unexp_int           --当前未到期利息（计提利息）
   ,t1.in_bs_over_int_bal                                                                                       as in_bs_over_int_bal       --表内欠息余额
   ,t1.off_bs_over_int_bal                                                                                      as off_bs_over_int_bal      --表外欠息余额
   ,nvl(t1.recvbl_pnlt,0) + nvl(t1.recvbl_comp_int,0)                                                           as pric_pnlt                --本金罚息
   ,t1.recvbl_comp_int                                                                                          as int_pnlt                 --利息罚息
   ,nvl(t2.loan_level5_cls_cd,'90')                                                                             as loan_level5_cls_cd       --贷款五级分类代码
   ,t1.int_rat_base_type_cd                                                                                     as int_rat_type_cd          --利率类型代码
   ,t1.exec_int_rat                                                                                             as exec_int_rat             --执行利率
   ,t1.int_rat_adj_way_cd                                                                                       as int_rat_adj_way_cd       --利率调整方式代码
   ,t1.int_rat_base_type_cd                                                                                     as base_rat_type_cd         --基准利率类型代码
   ,t1.base_rat                                                                                                 as base_rat                 --基准利率
   ,t1.int_rat_float_way_cd                                                                                     as int_rat_float_way_cd     --利率浮动方式代码
   ,t1.int_rat_flo_val                                                                                          as int_rat_flo_val          --利率浮动值
   ,'RAT02'                                                                                                     as ovdue_int_rat_type_cd    --逾期利率类型代码
   ,t1.ovdue_int_rat                                                                                            as ovdue_int_rat            --逾期利率
   ,''                                                                                                          as bond_item_rating_cd      --债项评级代码
   ,t1.loan_repay_num                                                                                           as loan_repay_num           --贷款还款账号
   ,case when t1.loan_acct_status_cd='C' then t1.loan_acct_status_cd else t1.loan_modal_cd end                  as loan_acct_status_cd      --贷款账户状态代码
   ,''                                                                                                          as loan_proc_dt             --贷款处理日期
   ,t1.cust_mgr_id                                                                                              as operr_id                 --经办人编号
   ,t1.mgmt_org_id                                                                                              as oper_org_id              --经办机构编号
   ,t1.acct_instit_id                                                                                           as acct_instit_id           --账务机构编号
   ,t4.org_abbr                                                                                                 as acct_instit_name         --账务机构名称
   ,t6.cust_type_cd                                                                                             as cust_type_cd             --客户类型代码
   ,t1.cust_id                                                                                                  as cust_id                  --客户编号
   ,t1.acct_name                                                                                                as cust_name                --客户名称
   ,t14.cert_type_cd                                                                                            as cert_type_cd             --证件类型代码
   ,t14.cert_num                                                                                                 as cert_no                  --证件号码
   ,t6.soci_crdt_cd                                                                                             as unify_soci_crdt_cd       --统一社会信用代码
   ,t6.rgst_addr                                                                                                as resdnt_addr              --常住地址
   ,nvl(t7.occu_crdt_lmt,0) + nvl(t7.surp_crdt_lmt,0)                                                           as brwer_crdt_lmt           --借款人授信额度
   ,nvl(t11.cl_curr_currt_bal,0)                                                                                as cust_ghb_loan_bal        --客户在本行贷款余额
   ,0                                                                                                           as ot_bank_loan_ovdue_perds --在其他银行贷款的历史最长逾期期数
   ,''                                                                                                          as crdt_score               --信用评分
   ,t15.rating_level_cd                                                                                         as cust_rating_cd           --客户评级代码
   ,''                                                                                                          as gender_cd                --性别代码
   ,''                                                                                                          as age                      --年龄
   ,''                                                                                                          as nationty_cd              --民族代码
   ,''                                                                                                          as birth_dt                 --出生日期
   ,''                                                                                                          as nation_cd                --国籍代码
   ,''                                                                                                          as brwer_city_cd            --借款人所在城市代码
   ,''                                                                                                          as brwer_prov_cd            --借款人所在省份代码
   ,''                                                                                                          as career_cd                --职业代码
   ,''                                                                                                          as degree_cd                --学位代码
   ,''                                                                                                          as edu_cd                   --学历代码
   ,''                                                                                                          as marriage_situ_cd         --婚姻状况代码
   ,''                                                                                                          as family_addr              --家庭住址
   ,''                                                                                                          as work_unit_name           --工作单位名称
   ,''                                                                                                          as corp_bl_induty_type_cd   --单位所属行业类型代码
   ,''                                                                                                          as indv_anl_inco            --个人年收入
   ,''                                                                                                          as ghb_emply_flg            --本行员工标志
   ,t6.orgnz_cd                                                                                                 as orgnz_cd                 --组织机构代码
   ,t6.econ_char_cd                                                                                             as econ_char_cd             --经济性质代码
   ,t6.indus_type_cd                                                                                            as indus_cls_cd             --行业分类代码
   ,t6.corp_size_cd                                                                                             as corp_size_cd             --企业规模代码
   ,t6.list_corp_flg                                                                                            as list_corp_flg            --上市企业标志
   ,t6.cty_rg_cd                                                                                                as cty_rg_cd                --国家和地区代码
   ,t6.rgst_addr                                                                                                as rgst_addr                --注册地址
   ,t6.group_cust_flg                                                                                           as group_cust_flg           --集团客户标志
   ,t16.cust_name                                                                                               as belong_group_name        --所属集团名称
   ,t7.loan_happ_type_cd                                                                                        as loan_happ_type_cd        --贷款发生类型代码
   ,t7.manu_cont_id                                                                                             as cont_text_id             --合同文本编号
   ,t7.start_dt                                                                                                 as cont_begin_dt            --合同起始日期
   ,nvl(t7.tenor,0)                                                                                             as cont_tenor_mon           --合同期限（月）
   ,t7.exp_dt                                                                                                   as cont_exp_dt              --合同到期日期
   ,''                                                                                                          as pm_rat                   --抵质押率
   ,nvl(t7.cont_amt,0)                                                                                          as cont_amt                 --合同金额
   ,nvl(t7.acm_distr_amt,0)                                                                                     as actl_distrd_amt          --实际已发放金额
   ,nvl(t7.cont_aval_bal,0)                                                                                     as cont_bal                 --合同余额
   ,nvl(t8.cl_curr_currt_bal,0) - nvl(t8.ovdue_pric,0)                                                          as cont_nomal_bal           --合同正常余额
   ,nvl(t8.ovdue_pric,0)                                                                                        as cont_ovdue_bal           --合同逾期余额
   ,t2.dir_indus_cd                                                                                             as indus_dir_cd             --行业投向代码
   ,''                                                                                                          as circl_flg                --循环标志
   ,0                                                                                                           as brw_new_return_old_cnt   --借新还旧次数
   ,t7.major_guar_way_cd                                                                                        as main_guar_way_cd         --主担保方式代码
   ,t13.guar_cont_type_cd                                                                                       as higt_lmt_guar_flg        --最高额担保标志
   ,case when t6.cust_type_cd='11' then    /*与历史数仓对公贷款合同取值方式保持一致*/
       case when t7.loan_usage_descb in ('40','60','65','70','99') then '199'
         when t7.loan_usage_descb = '1010' then '102'
         when t7.loan_usage_descb = '1020' then  '101'
         when t7.loan_usage_descb = '20' then '103'
         when t7.loan_usage_descb = '30' then '106'
         when t7.loan_usage_descb = '50' then '107'
         when t7.loan_usage_descb = '75' then '108'
         when t7.loan_usage_descb = '80' then '107'
       end
    end                                                                                                         as loan_usage_type_cd       --贷款用途类型代码
   ,0                                                                                                           as renew_cnt                --展期次数
   ,nvl(t7.margin_ratio,0)                                                                                      as margin_ratio             --保证金比例
   ,nvl(t7.margin_amt,0)                                                                                        as margin_amt               --保证金金额
   ,nvl(t13.dep_rcpt_aval_amt,0)                                                                                as dep_rcpt_amt             --存单金额
   ,0                                                                                                           as tbond_amt                --国债金额
   ,nvl(t13.col_cost,0)                                                                                         as finc_prod_amt            --理财产品金额
   ,t1.asset_tran_status_cd                                                                                     as asset_tran_status_cd     --资产转让状态代码
   ,nvl(t17.pkg_day_tm_point_amt,0)                                                                             as pkg_bf_int_recvbl_bal    --封包前应收利息余额
   ,nvl(t17.pkg_day_tm_point_amt,0) + nvl(t17.pkg_tran_day_tm_point_amt,0)                                      as pkg_post_int_recvbl_tot  --封包后应收利息总额
   ,nvl(t17.pkg_tran_day_tm_point_amt,0)                                                                        as pkg_post_int_recvbl_bal  --封包后应收利息余额
   ,nvl(t18.paybl_bank_int_amt,0) - nvl(t18.loan_surp_amt,0)                                                    as rtn_pkg_post_int_recvbl  --已归还封包后应收利息
   ,t1.tran_bf_int_recvbl                                                                                       as tran_loan_int_tot        --转让贷款利息总额
   ,nvl(t1.in_bs_over_int_bal,0) + nvl(t1.off_bs_over_int_bal,0) + nvl(t1.wrt_off_int,0)                        as int_recvbl               --应收利息
   ,t19.int                                                                                                        as unrepay_int_fee_bal         --未偿息费余额
   ,t1.job_cd as job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp
 from ${icl_schema}.cmm_corp_loan_acct_info t1
left join ${icl_schema}.cmm_corp_loan_dubil_info t2
on t1.dubil_num = t2.dubil_id
and t1.lp_id = t2.lp_id
and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_std_prod_info t3
on t1.std_prod_id = t3.prod_id
and t1.lp_id = t3.lp_id
and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_intnal_org_info t4
on t1.acct_instit_id = t4.org_id
and t1.lp_id = t4.lp_id
and t4.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${idl_schema}.tmp_abss_base_asset_info_01 t5
on t1.dubil_num = t5.dubil_id
left join ${icl_schema}.cmm_corp_cust_basic_info t6
on t1.cust_id = t6.cust_id
and t1.lp_id = t6.lp_id
and t6.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.cmm_corp_loan_cont_info t7
on t1.cont_id = t7.cont_id
and t1.lp_id = t7.lp_id
and t7.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${idl_schema}.tmp_abss_base_asset_info_02 t8
on t1.cont_id = t8.cont_id
left join ${idl_schema}.tmp_abss_base_asset_info_03 t11
on t1.cust_id = t11.cust_id
left join ${idl_schema}.tmp_abss_base_asset_info_04 t13
on t1.cont_id = t13.cont_id
left join ${idl_schema}.tmp_abss_base_asset_info_07 t14
on t1.cust_id = t14.party_id
and t1.lp_id = t14.lp_id
and t14.rn = 1
left join ${iml_schema}.pty_party_rating_h t15
on t1.cust_id = t15.party_id
and t1.lp_id = t15.lp_id
and t15.party_rating_type_cd = '01'  --本行评估即期信用等级
and t15.start_dt <= to_date('${batch_date}','yyyymmdd')
and t15.end_dt > to_date('${batch_date}','yyyymmdd')
and t15.job_cd='icmsf1'
left join ${icl_schema}.cmm_corp_cust_basic_info t16
on t6.group_cust_id = t16.cust_id
and t6.lp_id = t16.lp_id
and t16.etl_dt = to_date('${batch_date}','yyyymmdd')
left join ${idl_schema}.tmp_abss_base_asset_info_05 t17
on t1.acct_id = t17.acct_id
left join ${idl_schema}.tmp_abss_base_asset_info_06 t18
on t1.acct_id = t18.acct_id
left join ${idl_schema}.tmp_abss_base_asset_info_08 t19
on t1.acct_id = t19.internal_key
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');

commit;

-- 3.4 清洗数据
whenever sqlerror exit sql.sqlcode;
--对公贷款
insert /*+ append */ into ${idl_schema}.abss_base_asset_info_ex (
    etl_dt                      --数据日期
   ,asset_src_cd                --资产来源代码
   ,asset_id                    --资产编号
   ,contr_id                    --合同编号
   ,asst_type_cd                --资产类型代码
   ,prod_id                     --产品编号
   ,prod_name                   --产品名称
   ,value_dt                    --起息日期
   ,exp_dt                      --到期日期
   ,loan_tenor_mon              --贷款期限（月）
   ,loan_tenor_day              --贷款期限（天）
   ,loan_tot_perds              --贷款总期数
   ,surp_perds                  --剩余期数
   ,repay_way_cd                --还款方式代码
   ,repay_ped_corp_cd           --还款周期单位代码
   ,curr_repaybl_dt             --当前应还款日期
   ,curr_cd                     --币种代码
   ,loan_amt                    --贷款金额
   ,loan_bal                    --贷款余额
   ,ovdue_pric_bal              --逾期本金余额
   ,fir_ovdue_dt                --首次逾期日期
   ,curr_ovdue_days             --当前逾期天数
   ,int_ovdue_days              --利息逾期天数
   ,curr_unexp_int              --当前未到期利息（计提利息）
   ,in_bs_over_int_bal          --表内欠息余额
   ,off_bs_over_int_bal         --表外欠息余额
   ,pric_pnlt                   --本金罚息
   ,int_pnlt                    --利息罚息
   ,loan_level5_cls_cd          --贷款五级分类代码
   ,int_rat_type_cd             --利率类型代码
   ,exec_int_rat                --执行利率
   ,int_rat_adj_way_cd          --利率调整方式代码
   ,base_rat_type_cd            --基准利率类型代码
   ,base_rat                    --基准利率
   ,int_rat_float_way_cd        --利率浮动方式代码
   ,int_rat_flo_val             --利率浮动值
   ,ovdue_int_rat_type_cd       --逾期利率类型代码
   ,ovdue_int_rat               --逾期利率
   ,bond_item_rating_cd         --债项评级代码
   ,loan_repay_num              --贷款还款账号
   ,loan_acct_status_cd         --贷款账户状态代码
   ,loan_proc_dt                --贷款处理日期
   ,operr_id                    --经办人编号
   ,oper_org_id                 --经办机构编号
   ,acct_instit_id              --账务机构编号
   ,acct_instit_name            --账务机构名称
   ,cust_type_cd                --客户类型代码
   ,cust_id                     --客户编号
   ,cust_name                   --客户名称
   ,cert_type_cd                --证件类型代码
   ,cert_no                     --证件号码
   ,unify_soci_crdt_cd          --统一社会信用代码
   ,resdnt_addr                 --常住地址
   ,brwer_crdt_lmt              --借款人授信额度
   ,cust_ghb_loan_bal           --客户在本行贷款余额
   ,ot_bank_loan_ovdue_perds    --在其他银行贷款的历史最长逾期期数
   ,crdt_score                  --信用评分
   ,cust_rating_cd              --客户评级代码
   ,gender_cd                   --性别代码
   ,age                         --年龄
   ,nationty_cd                 --民族代码
   ,birth_dt                    --出生日期
   ,nation_cd                   --国籍代码
   ,brwer_city_cd               --借款人所在城市（地级市）
   ,brwer_prov_cd               --借款人所在省份
   ,career_cd                   --职业代码
   ,degree_cd                   --学位代码
   ,edu_cd                      --学历代码
   ,marriage_situ_cd            --婚姻状况代码
   ,family_addr                 --家庭住址
   ,work_unit_name              --工作单位名称
   ,corp_bl_induty_type_cd      --单位所属行业类型代码
   ,indv_anl_inco               --个人年收入
   ,ghb_emply_flg               --本行员工标志
   ,orgnz_cd                    --组织机构代码
   ,econ_char_cd                --经济性质代码
   ,indus_cls_cd                --行业分类代码
   ,corp_size_cd                --企业规模代码
   ,list_corp_flg               --上市企业标志
   ,cty_rg_cd                   --国家和地区代码
   ,rgst_addr                   --注册地址
   ,group_cust_flg              --集团客户标志
   ,belong_group_name           --所属集团名称
   ,loan_happ_type_cd           --贷款发生类型代码
   ,cont_text_id                --合同文本编号
   ,cont_begin_dt               --合同起始日期
   ,cont_tenor_mon              --合同期限（月）
   ,cont_exp_dt                 --合同到期日期
   ,pm_rat                      --抵质押率
   ,cont_amt                    --合同金额
   ,actl_distrd_amt             --实际已发放金额
   ,cont_bal                    --合同余额
   ,cont_nomal_bal              --合同正常余额
   ,cont_ovdue_bal              --合同逾期余额
   ,indus_dir_cd                --行业投向代码
   ,circl_flg                   --循环标志
   ,brw_new_return_old_cnt      --借新还旧次数
   ,main_guar_way_cd            --主担保方式代码
   ,higt_lmt_guar_flg           --最高额担保标志
   ,loan_usage_type_cd          --贷款用途类型代码
   ,renew_cnt                   --展期次数
   ,margin_ratio                --保证金比例
   ,margin_amt                  --保证金金额
   ,dep_rcpt_amt                --存单金额
   ,tbond_amt                   --国债金额
   ,finc_prod_amt               --理财产品金额
   ,asset_tran_status_cd        --资产转让状态代码
   ,pkg_bf_int_recvbl_bal       --封包前应收利息余额
   ,pkg_post_int_recvbl_tot     --封包后应收利息总额
   ,pkg_post_int_recvbl_bal     --封包后应收利息余额
   ,rtn_pkg_post_int_recvbl     --已归还封包后应收利息
   ,tran_loan_int_tot           --转让贷款利息总额
   ,int_recvbl                  --应收利息
   ,unrepay_int_fee_bal         --未偿息费余额
   ,job_cd                      --任务代码
   ,etl_timestamp               --数据处理时间
)
select
   to_date('${batch_date}','yyyymmdd') as etl_dt
   ,replace(replace(t1.asset_src_cd,chr(13),''),chr(10),'') as asset_src_cd
   ,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
   ,replace(replace(t1.contr_id,chr(13),''),chr(10),'') as contr_id
   ,replace(replace(t1.asst_type_cd,chr(13),''),chr(10),'') as asst_type_cd
   ,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
   ,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
   ,t1.value_dt as value_dt
   ,t1.exp_dt as exp_dt
   ,t1.loan_tenor_mon as loan_tenor_mon
   ,t1.loan_tenor_day as loan_tenor_day
   ,t1.loan_tot_perds as loan_tot_perds
   ,t1.surp_perds as surp_perds
   ,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
   ,replace(replace(t1.repay_ped_corp_cd,chr(13),''),chr(10),'') as repay_ped_corp_cd
   ,t1.curr_repaybl_dt as curr_repaybl_dt
   ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
   ,t1.loan_amt as loan_amt
   ,t1.loan_bal as loan_bal
   ,t1.ovdue_pric_bal as ovdue_pric_bal
   ,t1.fir_ovdue_dt as fir_ovdue_dt
   ,t1.curr_ovdue_days as curr_ovdue_days
   ,t1.int_ovdue_days as int_ovdue_days
   ,t1.curr_unexp_int as curr_unexp_int
   ,t1.in_bs_over_int_bal as in_bs_over_int_bal
   ,t1.off_bs_over_int_bal as off_bs_over_int_bal
   ,t1.pric_pnlt as pric_pnlt
   ,t1.int_pnlt as int_pnlt
   ,replace(replace(t1.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd
   ,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
   ,t1.exec_int_rat as exec_int_rat
   ,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
   ,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd
   ,t1.base_rat as base_rat
   ,replace(replace(t1.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd
   ,t1.int_rat_flo_val as int_rat_flo_val
   ,replace(replace(t1.ovdue_int_rat_type_cd,chr(13),''),chr(10),'') as ovdue_int_rat_type_cd
   ,t1.ovdue_int_rat as ovdue_int_rat
   ,replace(replace(t1.bond_item_rating_cd,chr(13),''),chr(10),'') as bond_item_rating_cd
   ,replace(replace(t1.loan_repay_num,chr(13),''),chr(10),'') as loan_repay_num
   ,replace(replace(t1.loan_acct_status_cd,chr(13),''),chr(10),'') as loan_acct_status_cd
   ,t1.loan_proc_dt as loan_proc_dt
   ,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
   ,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
   ,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
   ,replace(replace(t1.acct_instit_name,chr(13),''),chr(10),'') as acct_instit_name
   ,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
   ,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
   ,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
   ,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
   ,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
   ,replace(replace(t1.unify_soci_crdt_cd,chr(13),''),chr(10),'') as unify_soci_crdt_cd
   ,replace(replace(t1.resdnt_addr,chr(13),''),chr(10),'') as resdnt_addr
   ,t1.brwer_crdt_lmt as brwer_crdt_lmt
   ,t1.cust_ghb_loan_bal as cust_ghb_loan_bal
   ,t1.ot_bank_loan_ovdue_perds as ot_bank_loan_ovdue_perds
   ,replace(replace(t1.crdt_score,chr(13),''),chr(10),'') as crdt_score
   ,replace(replace(t1.cust_rating_cd,chr(13),''),chr(10),'') as cust_rating_cd
   ,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
   ,t1.age as age
   ,replace(replace(t1.nationty_cd,chr(13),''),chr(10),'') as nationty_cd
   ,t1.birth_dt as birth_dt
   ,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd
   ,replace(replace(t1.brwer_city_cd,chr(13),''),chr(10),'') as brwer_city_cd
   ,replace(replace(t1.brwer_prov_cd,chr(13),''),chr(10),'') as brwer_prov_cd
   ,replace(replace(t1.career_cd,chr(13),''),chr(10),'') as career_cd
   ,replace(replace(t1.degree_cd,chr(13),''),chr(10),'') as degree_cd
   ,replace(replace(t1.edu_cd,chr(13),''),chr(10),'') as edu_cd
   ,replace(replace(t1.marriage_situ_cd,chr(13),''),chr(10),'') as marriage_situ_cd
   ,replace(replace(t1.family_addr,chr(13),''),chr(10),'') as family_addr
   ,replace(replace(t1.work_unit_name,chr(13),''),chr(10),'') as work_unit_name
   ,replace(replace(t1.corp_bl_induty_type_cd,chr(13),''),chr(10),'') as corp_bl_induty_type_cd
   ,t1.indv_anl_inco as indv_anl_inco
   ,replace(replace(t1.ghb_emply_flg,chr(13),''),chr(10),'') as ghb_emply_flg
   ,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd
   ,replace(replace(t1.econ_char_cd,chr(13),''),chr(10),'') as econ_char_cd
   ,replace(replace(t1.indus_cls_cd,chr(13),''),chr(10),'') as indus_cls_cd
   ,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
   ,replace(replace(t1.list_corp_flg,chr(13),''),chr(10),'') as list_corp_flg
   ,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
   ,replace(replace(t1.rgst_addr,chr(13),''),chr(10),'') as rgst_addr
   ,replace(replace(t1.group_cust_flg,chr(13),''),chr(10),'') as group_cust_flg
   ,replace(replace(t1.belong_group_name,chr(13),''),chr(10),'') as belong_group_name
   ,replace(replace(t1.loan_happ_type_cd,chr(13),''),chr(10),'') as loan_happ_type_cd
   ,replace(replace(t1.cont_text_id,chr(13),''),chr(10),'') as cont_text_id
   ,t1.cont_begin_dt as cont_begin_dt
   ,t1.cont_tenor_mon as cont_tenor_mon
   ,t1.cont_exp_dt as cont_exp_dt
   ,t1.pm_rat as pm_rat
   ,t1.cont_amt as cont_amt
   ,t1.actl_distrd_amt as actl_distrd_amt
   ,t1.cont_bal as cont_bal
   ,t1.cont_nomal_bal as cont_nomal_bal
   ,t1.cont_ovdue_bal as cont_ovdue_bal
   ,replace(replace(t1.indus_dir_cd,chr(13),''),chr(10),'') as indus_dir_cd
   ,replace(replace(t1.circl_flg,chr(13),''),chr(10),'') as circl_flg
   ,t1.brw_new_return_old_cnt as brw_new_return_old_cnt
   ,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
   ,replace(replace(t1.higt_lmt_guar_flg,chr(13),''),chr(10),'') as higt_lmt_guar_flg
   ,replace(replace(t1.loan_usage_type_cd,chr(13),''),chr(10),'') as loan_usage_type_cd
   ,t1.renew_cnt as renew_cnt
   ,t1.margin_ratio as margin_ratio
   ,t1.margin_amt as margin_amt
   ,t1.dep_rcpt_amt as dep_rcpt_amt
   ,t1.tbond_amt as tbond_amt
   ,t1.finc_prod_amt as finc_prod_amt
   ,replace(replace(t1.asset_tran_status_cd,chr(13),''),chr(10),'') as asset_tran_status_cd
   ,t1.pkg_bf_int_recvbl_bal as pkg_bf_int_recvbl_bal
   ,t1.pkg_post_int_recvbl_tot as pkg_post_int_recvbl_tot
   ,t1.pkg_post_int_recvbl_bal as pkg_post_int_recvbl_bal
   ,t1.rtn_pkg_post_int_recvbl as rtn_pkg_post_int_recvbl
   ,t1.tran_loan_int_tot as tran_loan_int_tot
   ,t1.int_recvbl as int_recvbl
   ,t1.unrepay_int_fee_bal         --未偿息费余额
   ,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
   ,t1.etl_timestamp
 from ${idl_schema}.abss_base_asset_info_ex01 t1
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
   to_date('${batch_date}','yyyymmdd') as etl_dt
   ,replace(replace(t2.asset_src_cd,chr(13),''),chr(10),'') as asset_src_cd
   ,replace(replace(t2.asset_id,chr(13),''),chr(10),'') as asset_id
   ,replace(replace(t2.contr_id,chr(13),''),chr(10),'') as contr_id
   ,replace(replace(t2.asst_type_cd,chr(13),''),chr(10),'') as asst_type_cd
   ,replace(replace(t2.prod_id,chr(13),''),chr(10),'') as prod_id
   ,replace(replace(t2.prod_name,chr(13),''),chr(10),'') as prod_name
   ,t2.value_dt as value_dt
   ,t2.exp_dt as exp_dt
   ,t2.loan_tenor_mon as loan_tenor_mon
   ,t2.loan_tenor_day as loan_tenor_day
   ,t2.loan_tot_perds as loan_tot_perds
   ,t2.surp_perds as surp_perds
   ,replace(replace(t2.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
   ,replace(replace(t2.repay_ped_corp_cd,chr(13),''),chr(10),'') as repay_ped_corp_cd
   ,t2.curr_repaybl_dt as curr_repaybl_dt
   ,replace(replace(t2.curr_cd,chr(13),''),chr(10),'') as curr_cd
   ,t2.loan_amt as loan_amt
   ,t2.loan_bal as loan_bal
   ,t2.ovdue_pric_bal as ovdue_pric_bal
   ,t2.fir_ovdue_dt as fir_ovdue_dt
   ,t2.curr_ovdue_days as curr_ovdue_days
   ,t2.int_ovdue_days as int_ovdue_days
   ,t2.curr_unexp_int as curr_unexp_int
   ,t2.in_bs_over_int_bal as in_bs_over_int_bal
   ,t2.off_bs_over_int_bal as off_bs_over_int_bal
   ,t2.pric_pnlt as pric_pnlt
   ,t2.int_pnlt as int_pnlt
   ,replace(replace(t2.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd
   ,replace(replace(t2.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
   ,t2.exec_int_rat as exec_int_rat
   ,replace(replace(t2.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
   ,replace(replace(t2.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd
   ,t2.base_rat as base_rat
   ,replace(replace(t2.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd
   ,t2.int_rat_flo_val as int_rat_flo_val
   ,replace(replace(t2.ovdue_int_rat_type_cd,chr(13),''),chr(10),'') as ovdue_int_rat_type_cd
   ,t2.ovdue_int_rat as ovdue_int_rat
   ,replace(replace(t2.bond_item_rating_cd,chr(13),''),chr(10),'') as bond_item_rating_cd
   ,replace(replace(t2.loan_repay_num,chr(13),''),chr(10),'') as loan_repay_num
   ,replace(replace(t2.loan_acct_status_cd,chr(13),''),chr(10),'') as loan_acct_status_cd
   ,t2.loan_proc_dt as loan_proc_dt
   ,replace(replace(t2.operr_id,chr(13),''),chr(10),'') as operr_id
   ,replace(replace(t2.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
   ,replace(replace(t2.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
   ,replace(replace(t2.acct_instit_name,chr(13),''),chr(10),'') as acct_instit_name
   ,replace(replace(t2.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
   ,replace(replace(t2.cust_id,chr(13),''),chr(10),'') as cust_id
   ,replace(replace(t2.cust_name,chr(13),''),chr(10),'') as cust_name
   ,replace(replace(t2.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
   ,replace(replace(t2.cert_no,chr(13),''),chr(10),'') as cert_no
   ,replace(replace(t2.unify_soci_crdt_cd,chr(13),''),chr(10),'') as unify_soci_crdt_cd
   ,replace(replace(t2.resdnt_addr,chr(13),''),chr(10),'') as resdnt_addr
   ,t2.brwer_crdt_lmt as brwer_crdt_lmt
   ,t2.cust_ghb_loan_bal as cust_ghb_loan_bal
   ,t2.ot_bank_loan_ovdue_perds as ot_bank_loan_ovdue_perds
   ,replace(replace(t2.crdt_score,chr(13),''),chr(10),'') as crdt_score
   ,replace(replace(t2.cust_rating_cd,chr(13),''),chr(10),'') as cust_rating_cd
   ,replace(replace(t2.gender_cd,chr(13),''),chr(10),'') as gender_cd
   ,t2.age as age
   ,replace(replace(t2.nationty_cd,chr(13),''),chr(10),'') as nationty_cd
   ,t2.birth_dt as birth_dt
   ,replace(replace(t2.nation_cd,chr(13),''),chr(10),'') as nation_cd
   ,replace(replace(t2.brwer_city_cd,chr(13),''),chr(10),'') as brwer_city_cd
   ,replace(replace(t2.brwer_prov_cd,chr(13),''),chr(10),'') as brwer_prov_cd
   ,replace(replace(t2.career_cd,chr(13),''),chr(10),'') as career_cd
   ,replace(replace(t2.degree_cd,chr(13),''),chr(10),'') as degree_cd
   ,replace(replace(t2.edu_cd,chr(13),''),chr(10),'') as edu_cd
   ,replace(replace(t2.marriage_situ_cd,chr(13),''),chr(10),'') as marriage_situ_cd
   ,replace(replace(t2.family_addr,chr(13),''),chr(10),'') as family_addr
   ,replace(replace(t2.work_unit_name,chr(13),''),chr(10),'') as work_unit_name
   ,replace(replace(t2.corp_bl_induty_type_cd,chr(13),''),chr(10),'') as corp_bl_induty_type_cd
   ,t2.indv_anl_inco as indv_anl_inco
   ,replace(replace(t2.ghb_emply_flg,chr(13),''),chr(10),'') as ghb_emply_flg
   ,replace(replace(t2.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd
   ,replace(replace(t2.econ_char_cd,chr(13),''),chr(10),'') as econ_char_cd
   ,replace(replace(t2.indus_cls_cd,chr(13),''),chr(10),'') as indus_cls_cd
   ,replace(replace(t2.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
   ,replace(replace(t2.list_corp_flg,chr(13),''),chr(10),'') as list_corp_flg
   ,replace(replace(t2.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
   ,replace(replace(t2.rgst_addr,chr(13),''),chr(10),'') as rgst_addr
   ,replace(replace(t2.group_cust_flg,chr(13),''),chr(10),'') as group_cust_flg
   ,replace(replace(t2.belong_group_name,chr(13),''),chr(10),'') as belong_group_name
   ,replace(replace(t2.loan_happ_type_cd,chr(13),''),chr(10),'') as loan_happ_type_cd
   ,replace(replace(t2.cont_text_id,chr(13),''),chr(10),'') as cont_text_id
   ,t2.cont_begin_dt as cont_begin_dt
   ,t2.cont_tenor_mon as cont_tenor_mon
   ,t2.cont_exp_dt as cont_exp_dt
   ,t2.pm_rat as pm_rat
   ,t2.cont_amt as cont_amt
   ,t2.actl_distrd_amt as actl_distrd_amt
   ,t2.cont_bal as cont_bal
   ,t2.cont_nomal_bal as cont_nomal_bal
   ,t2.cont_ovdue_bal as cont_ovdue_bal
   ,replace(replace(t2.indus_dir_cd,chr(13),''),chr(10),'') as indus_dir_cd
   ,replace(replace(t2.circl_flg,chr(13),''),chr(10),'') as circl_flg
   ,t2.brw_new_return_old_cnt as brw_new_return_old_cnt
   ,replace(replace(t2.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
   ,replace(replace(t2.higt_lmt_guar_flg,chr(13),''),chr(10),'') as higt_lmt_guar_flg
   ,replace(replace(t2.loan_usage_type_cd,chr(13),''),chr(10),'') as loan_usage_type_cd
   ,t2.renew_cnt as renew_cnt
   ,t2.margin_ratio as margin_ratio
   ,t2.margin_amt as margin_amt
   ,t2.dep_rcpt_amt as dep_rcpt_amt
   ,t2.tbond_amt as tbond_amt
   ,t2.finc_prod_amt as finc_prod_amt
   ,replace(replace(t2.asset_tran_status_cd,chr(13),''),chr(10),'') as asset_tran_status_cd
   ,t2.pkg_bf_int_recvbl_bal as pkg_bf_int_recvbl_bal
   ,t2.pkg_post_int_recvbl_tot as pkg_post_int_recvbl_tot
   ,t2.pkg_post_int_recvbl_bal as pkg_post_int_recvbl_bal
   ,t2.rtn_pkg_post_int_recvbl as rtn_pkg_post_int_recvbl
   ,t2.tran_loan_int_tot as tran_loan_int_tot
   ,t2.int_recvbl as int_recvbl
   ,T2.unrepay_int_fee_bal         --未偿息费余额
   ,replace(replace(t2.job_cd,chr(13),''),chr(10),'') as job_cd
   ,t2.etl_timestamp
 from ${idl_schema}.abss_base_asset_info_ex02 t2
where t2.etl_dt = to_date('${batch_date}','yyyymmdd');

commit;


-- 4.1 exchage ex table and target table
alter table ${idl_schema}.abss_base_asset_info exchange partition p_${batch_date} with table ${idl_schema}.abss_base_asset_info_ex;

-- 4.2 drop ex table
drop table ${idl_schema}.abss_base_asset_info_ex purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_01 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_02 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_03 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_04 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_05 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_06 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_07 purge;
drop table ${idl_schema}.tmp_abss_base_asset_info_08 purge;


-- 5 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'abss_base_asset_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);