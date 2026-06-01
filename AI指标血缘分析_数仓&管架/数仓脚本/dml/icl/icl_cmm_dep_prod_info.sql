/*
Purpose:    共性加工层-存款产品信息：包括储蓄产品化平台定义的存款产品的基础属性、利率属性等相关信息，数据来源于储蓄产品系统（DPSS）
Author:     Sunline/
Usage:      python $ETL_HOME/script/main.py 20200630 icl_cmm_dep_prod_info
Createdate: 20201106
Logs:       20210726 何桐金 增加字段【基准利率、利率浮动值、约定赎回日期、赎回利率类型】
            20211115 陈伟峰 增加字段【支持购买方式代码】
            20211216 陈伟峰 调整【支持购买方式代码】码值，统一引用CD1582-产品属性代码
			      20220502 翟若平 新增字段【起存金额、增量金额、最小留存金额】
			                      置空字段【会计核算编号、存款种类代码、收费事件方式代码、产品形态转移标志、总账同步标志、预约取款标志、开户限制标志、允许零余额标志、
                                    转存标志、员工产品标志、衍生产品标志、允许质押标志、续存方式代码、允许多次认购标志、允许支取最大金额、推广利率、统计产品认购额度标志、产品发行总额下限】
            20220930 翟若平 调整字段【产品名称】的加工口径
            20221008 温旺清 1、调整字段【起存金额、最小留存金额】的加工口径
                            2、置空字段【基准利率编号、基准利率】
            20221101 翟若平 调整字段【基准利率编号、基准利率】的加工口径
            20221104 翟若平 调整字段【基准利率编号、基准利率、支持购买方式代码】的加工口径
            20230529 陈伟峰 新增字段【业务管理分类代码】
            20230926 徐子豪 新增字段【赎回利率、可提前支取标志】
            20230928 陈伟峰 调整字段【起存金额、最小留存金额】加工逻辑，取期次维度的数据，调整字段【基准利率】加工逻辑，增加取产品表的利率类型做关联
            20240527 饶雅   新增字段【期次产品类别代码】
            20240919 陈伟峰 新增字段【期次状态代码】
            20250218 陈伟峰 新增字段【期次期限类型代码】
			20251023 谢宁   新增字段【存款期限】

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;
 
-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_dep_prod_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_dep_prod_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_dep_prod_info_ex purge;
drop table ${icl_schema}.tmp_cmm_dep_prod_info_01 purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_prod_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_dep_prod_info where 0=1;

-- 获取产品基准利率
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_dep_prod_info_01
nologging
compress ${option_switch} for query high
as
select pdp.prod_id, pdp.pd_cd, ppa.value_dt, br.base_rat_id, br.base_rat,
       row_number() over(partition by pdp.prod_id, pdp.pd_cd, br.base_rat_id, br.curr_cd order by br.effect_dt desc) rn
  from ${iml_schema}.ref_dep_pd_def_para pdp
  left join ${iml_schema}.ref_dep_pd_para_addit_info ppa 
    on pdp.pd_cd = ppa.pd_cd	
   and ppa.start_dt <= to_date('${batch_date}','yyyymmdd')
   and ppa.end_dt > to_date('${batch_date}','yyyymmdd')
   and ppa.job_cd = 'ncbsf1'
  left join ${iml_schema}.prd_prod_int_rat_info_h mb
    on pdp.prod_id =mb.prod_id
   and mb.int_cls_cd  ='INT'
   and mb.evt_cate_id ='OPEN'
   and mb.start_dt <= to_date('${batch_date}','yyyymmdd')
   and mb.end_dt > to_date('${batch_date}','yyyymmdd')
   and mb.job_cd = 'ncbsf1'
  left join ${iml_schema}.ref_bank_int_ladr_h bil		
    on nvl(decode(ppa.int_rat_type_cd,'-',''),mb.int_rat_type_cd) = bil.bank_int_int_rat_type_cd 
   and bil.ped_freq_cd = pdp.tenor_type_cd || pdp.dep_tenor
   and bil.curr_cd = pdp.curr_cd
   and bil.effect_dt <= to_date('${batch_date}', 'yyyymmdd') 
   and bil.invalid_dt > to_date('${batch_date}', 'yyyymmdd')
   and bil.start_dt <= to_date('${batch_date}','yyyymmdd')
   and bil.end_dt > to_date('${batch_date}','yyyymmdd')
   and bil.job_cd = 'ncbsf1'
  left join ${iml_schema}.ref_base_rat_h br
    on bil.base_rat_type_id = br.base_rat_id 
   and bil.curr_cd = br.curr_cd 
   and br.start_dt <= to_date('${batch_date}','yyyymmdd')
   and br.end_dt > to_date('${batch_date}','yyyymmdd')
   and br.job_cd = 'ncbsf1'
   and br.effect_dt <= decode(ppa.value_dt, to_date('00010101', 'yyyymmdd'), to_date('29991231', 'yyyymmdd'), ppa.value_dt)
 where pdp.start_dt <= to_date('${batch_date}','yyyymmdd')
   and pdp.end_dt > to_date('${batch_date}','yyyymmdd')
   and pdp.job_cd = 'ncbsf1'
;
commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_dep_prod_info_ex(
     etl_dt                     --数据日期
     ,lp_id                     --法人编号
     ,prod_id                   --产品编号
     ,prod_name                 --产品名称
     ,intnal_prod_id            --内部产品编号
     ,accting_id                --会计核算编号
     ,prod_cate_cd              --产品类别代码
     ,pd_prod_cate_cd           --期次产品类别代码
     ,sell_obj_cd               --销售对象代码
     ,dep_kind_cd               --存款种类代码
     ,charge_evt_way_cd         --收费事件方式代码
     ,supt_buy_way_cd           --支持购买方式代码
     ,status_cd                 --状态代码
     ,pd_status_cd              --期次状态代码
     ,pd_tenor_type_cd              --期次期限类型代码
     ,curr_type_cd              --货币类型代码
     ,prod_modal_tran_flg       --产品形态转移标志
     ,gl_sync_flg               --总账同步标志
     ,precon_draw_flg           --预约取款标志
     ,open_lmt_flg              --开户限制标志
     ,rela_vouch_flg            --关联凭证标志
     ,allow_zero_bal_flg        --允许零余额标志
     ,redt_flg                  --转存标志
     ,margin_dep_flg            --保证金存款标志
     ,allow_od_flg              --允许透支标志
     ,emply_prod_flg            --员工产品标志
     ,deriv_prod_flg            --衍生产品标志
     ,mpr_flg                   --利随本清标志
     ,allow_redem_flg           --允许赎回标志
     ,allow_tran_flg            --允许转让标志
     ,allow_spec_col_int_flg    --允许指定收息标志
     ,allow_inpwn_flg           --允许质押标志
     ,renew_dep_way_cd          --续存方式代码
     ,allow_multi_subscr_flg    --允许多次认购标志
     ,advd_draw_flg             --可提前支取标志
     ,unexp_draw_way_cd         --提前支取方式代码
     ,allow_tran_wdraw_flg      --允许转帐支取标志
     ,allow_wdraw_cnt           --允许支取次数
     ,allow_wdraw_max_amt       --允许支取最大金额
     ,base_rat_id               --基准利率编号
     ,int_rat_file_type_cd      --利率靠档类型代码
     ,base_rat                  --基准利率
     ,int_rat_flo_val           --利率浮动值
     ,pay_int_freq              --付息频率
     ,spread_int_rat            --推广利率
     ,redem_int_rat             --赎回利率
     ,matn_teller_id            --维护柜员编号
     ,matn_org_id               --维护机构编号
	 ,dep_tenor                 --存款期限
     ,effect_dt                 --生效日期
     ,invalid_dt                --失效日期
     ,value_dt                  --起息日期
     ,exp_dt                    --到期日期
     ,stat_prod_subscr_lmt_flg  --统计产品认购额度标志
     ,value_way_cd              --起息方式代码
     ,bus_mgmt_cls_cd           --业务管理分类代码
     ,prod_issue_tot_uplmi      --产品发行总额上限
     ,prod_issue_tot_lolmi      --产品发行总额下限
     ,sell_begin_dt_tm          --销售起始日期时间
     ,sell_termnt_dt_tm         --销售终止日期时间
     ,apot_redem_dt             --约定赎回日期
     ,redem_int_rat_type        --赎回利率类型
     ,init_amt                  --起存金额
     ,incremt_amt               --增量金额
     ,min_retnd_amt             --最小留存金额
     ,job_cd                    --任务代码
     ,etl_timestamp             --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')             --数据日期
      ,t1.lp_id                                        --法人编号
      ,t1.prod_id                                      --产品编号
      ,nvl(trim(t3.pd_descb), t1.prod_name)            --产品名称
      ,t3.pd_cd                                        --内部产品编号
      ,''                                              --会计核算编号
      ,t5.acct_type_value                              --产品类别代码
      ,t3.pd_prod_cate_cd                              --期次产品类别代码
      ,t5.client_type_value                            --销售对象代码
      ,''                                              --存款种类代码
      ,''                                              --收费事件方式代码
      ,t3.supt_buy_way_cd                              --支持购买方式代码
      ,t1.prod_status_cd                               --状态代码
      ,t3.pd_status_cd                                 --期次状态代码
      ,t3.tenor_type_cd              --期次期限类型代码
      ,t5.ccy_value                                    --货币类型代码
      ,''                                              --产品形态转移标志
      ,''                                              --总账同步标志
      ,''                                              --预约取款标志
      ,''                                              --开户限制标志
      ,t5.doc_flag_value                               --关联凭证标志
      ,''                                              --允许零余额标志
      ,''                                              --转存标志
      ,decode(t5.acct_nature_value, '0009', '1', '0')  --保证金存款标志
      ,t5.od_facility_value                            --允许透支标志
      ,''                                              --员工产品标志
      ,''                                              --衍生产品标志
      ,decode(t5.int_pat_type_value, 'P3', '1', '0')   --利随本清标志
      ,t3.redembl_flg                                  --允许赎回标志
      ,t4.transf_flg                                   --允许转让标志
      ,t4.spec_col_int_flg                             --允许指定收息标志
      ,''                                              --允许质押标志
      ,''                                              --续存方式代码
      ,''                                              --允许多次认购标志
      ,t3.allow_unexp_draw_flg                         --可提前支取标志
      ,t5.pre_withdraw_flag_value                      --提前支取方式代码
      ,t5.tt_tran_flag_value                           --允许转帐支取标志
      ,t5.pre_withdraw_num_value                       --允许支取次数
      ,null                                            --允许支取最大金额
      ,t8.base_rat_id                                  --基准利率编号
      ,nvl(t6.amt_file_dir_cd,t6.days_file_dir_cd)     --利率靠档类型代码
      ,t8.base_rat                                     --基准利率
      ,nvl(t4.float_int_rat, 0)                        --利率浮动值
      ,t3.get_int_freq_cd                              --付息频率
      ,t4.exec_int_rat                                 --推广利率
      ,t4.redem_int_rat                                --赎回利率
      ,t3.tran_teller_id                               --维护柜员编号
      ,t3.tran_org_id                                  --维护机构编号
	  ,t3.dep_tenor                                    --存款期限
      ,t3.cds_issue_begin_dt                           --生效日期
      ,t3.issue_termnt_dt                              --失效日期
      ,t4.value_dt                                     --起息日期
      ,t4.exp_dt                                       --到期日期
      ,''                                              --统计产品认购额度标志
      ,t4.value_idf_cd                                 --起息方式代码
      ,t5.manage_class                                 --业务管理分类代码
      ,nvl(t3.tot_lmt_lmt, 0)                          --产品发行总额上限
      ,null                                            --产品发行总额下限
      ,t3.start_sell_tm                                --销售起始日期时间
      ,t3.end_sell_tm                                  --销售终止日期时间
      ,t4.init_apot_redem_dt                           --约定赎回日期
      ,t4.redem_int_rat_type_cd                        --赎回利率类型
      ,nvl(t3.init_amt, 0)                             --起存金额
      ,nvl(t4.min_chg_amt, 0)                          --增量金额
      ,nvl(t4.min_retnd_amt, 0)                        --最小留存金额
      ,t1.job_cd                                       --任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    --数据处理时间
  from ${iml_schema}.prd_std_prod_info_h t1						
  inner join ${iml_schema}.prd_prod_catlg_h t2 
     on t1.prod_id = t2.sellbl_prod_id 
    and t2.prod_gen_id = '1'
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
    and t2.job_cd = 'ncbsf1'	
  left join ${iml_schema}.ref_dep_pd_def_para t3 
    on t1.prod_id = t3.prod_id	
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'ncbsf1'		
  left join ${iml_schema}.ref_dep_pd_para_addit_info t4 
    on t3.pd_cd = t4.pd_cd	
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'ncbsf1'		
  left join (select prod_id,
                    max(decode(attr_key, 'ACCT_TYPE', attr_val, '')) as acct_type_value,
                    max(decode(attr_key, 'CLIENT_TYPE', attr_val, '')) as client_type_value,
                    max(decode(attr_key, 'CCY', attr_val, '')) as ccy_value,
                    max(decode(attr_key, 'DOC_FLAG', attr_val, '')) as doc_flag_value,
                    max(decode(attr_key, 'ACCT_NATURE', attr_val, '')) as acct_nature_value,
                    max(decode(attr_key, 'OD_FACILITY', attr_val, '')) as od_facility_value,
                    max(decode(attr_key, 'INT_PAT_TYPE', attr_val, '')) as int_pat_type_value,
                    max(decode(attr_key, 'PRE_WITHDRAW_FLAG', attr_val, '')) as pre_withdraw_flag_value,
                    max(decode(attr_key, 'TT_TRAN_FLAG', attr_val, '')) as tt_tran_flag_value,
                    max(decode(attr_key, 'PRE_WITHDRAW_NUM', attr_val, '')) as pre_withdraw_num_value,
                    max(decode(attr_key, 'INT_TYPE', attr_val, '')) as int_type_value,
                    max(decode(attr_key, 'PAYINT_FREQ', attr_val, '')) as payint_freq_value,
                    max(decode(attr_key, 'INIT_AMT', attr_val, '')) as init_amt_value,
                    max(decode(attr_key, 'LOWEST_AMT', attr_val, '')) as lowest_amt_value,
                    max(decode(attr_key, 'MANAGE_CLASS', attr_val, '')) as manage_class
               from (select prod_id,
                            attr_key,
                            attr_val,
                            seq_num,
                            row_number() over(partition by prod_id, attr_key order by seq_num desc) rn
                       from ${iml_schema}.prd_prod_def_h
                      where prod_status_cd = '1'
                        and attr_key in ('ACCT_TYPE', 'CLIENT_TYPE', 'CCY', 'DOC_FLAG', 'ACCT_NATURE', 'OD_FACILITY', 'INT_PAT_TYPE', 'PRE_WITHDRAW_FLAG', 
						                 'TT_TRAN_FLAG', 'PRE_WITHDRAW_NUM', 'INT_TYPE','PAYINT_FREQ', 'INIT_AMT', 'LOWEST_AMT','MANAGE_CLASS')
  					            and start_dt <= to_date('${batch_date}','yyyymmdd')
                        and end_dt > to_date('${batch_date}','yyyymmdd')
                        and job_cd = 'ncbsf1')
              group by prod_id) t5			
    on t1.prod_id = t5.prod_id			
  left join ${iml_schema}.prd_prod_int_rat_info_h t6			
    on t3.prod_id = t6.prod_id
   and t6.evt_cate_id = 'OPEN' 
   and t6.int_cls_cd = 'INT'
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'ncbsf1'	
  left join ${icl_schema}.tmp_cmm_dep_prod_info_01 t8	
    on t3.prod_id = t8.prod_id
   and t3.pd_cd = t8.pd_cd
   and t8.rn = 1
/*  left join ${iml_schema}.prd_prod_init_amt_def_h t9
    on t1.prod_id = t9.prod_id
   and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t9.end_dt > to_date('${batch_date}','yyyymmdd')
   and t9.job_cd = 'ncbsf1'
*/
  where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'ncbsf1'
   --and t1.prod_id like '1%'  -- 2022-6-1 19:56:30 临时处理，后续要启用t2表逻辑过滤
  ;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_dep_prod_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_dep_prod_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_dep_prod_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_dep_prod_info_01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_dep_prod_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
