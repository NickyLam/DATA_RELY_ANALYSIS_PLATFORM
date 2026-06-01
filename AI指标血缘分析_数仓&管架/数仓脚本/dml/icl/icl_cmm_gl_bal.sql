/*
purpose:    共性加工层-总账余额:包括所有总账科目余额信息，目前只有明细科目和明细机构的科目余额信息。数据来源于核算中台系统。
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_gl_bal

logs:       20200110 翟若平 增加字段[科目名称]
            20211125 陈伟峰	增加字段[预算科目编号]
            20220318 翟若平 1、主键字段调整【数据日期,法人编号,账套编号,账务期间,账户组合编号,币种代码】--》【数据日期,法人编号,账套编号,账务期间,标准产品编号,交易渠道代码，币种代码，机构编号，科目编号，数据来源代码，本日余额方向代码】
                            2、新增字段【标准产品编号、交易渠道代码、本日余额方向代码、本日原币余额、旬原币借方发生额、旬原币贷方发生额、旬本币借方发生额、旬本币贷方发生额、明细科目标志】
                            3、置空字段【账户组合编号、预算科目编号】
            20220601 温旺清 交换【标准产品编号、交易渠道代码】取数逻辑
			      20220714 温旺清 新增字段【半年期初借方原币余额,半年期初贷方原币余额,半年期初借方本币余额,半年期初贷方本币余额,半年原币借方发生额,半年原币贷方发生额,半年本币借方发生额,半年本币贷方发生额】
            20230113 陈伟峰 增加字段【新一代迁移科目编号】
            20231201 陈伟峰 调整fin_gl_mult_flow取数条件
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_gl_bal drop partition p_${retain_day};
alter table ${icl_schema}.cmm_gl_bal add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create tmp table
whenever sqlerror continue none;
drop table ${icl_schema}.tmp_cmm_gl_bal_01 purge;
drop table ${icl_schema}.tmp_cmm_gl_bal_02 purge;
drop table ${icl_schema}.tmp_cmm_gl_bal_03 purge;
drop table ${icl_schema}.tmp_cmm_gl_bal_04 purge;
drop table ${icl_schema}.tmp_cmm_gl_bal_05 purge;
drop table ${icl_schema}.tmp_cmm_gl_bal_06 purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_gl_bal_01
nologging
compress ${option_switch} for query high
as
select
	 t1.sob_id                                                        --账套编号
    ,t1.acct_dt                                                     --账务期间
    ,t1.chn_id                                                      --标准产品编号
    ,t1.sellbl_prod_id                                              --交易渠道代码
    ,t1.curr_cd                                                     --币种代码
    ,t1.gl_org_id                                                   --机构编号
    ,t1.subj_id                                                     --科目编号
    ,t1.sys_cd                                                      --数据来源代码
    ,max(t1.curr_bal_dir_cd)            as td_bal_dir_cd            --本日余额方向代码
    ,max(t1.end_level_subj_flg)         as dtl_subj_flg             --明细科目标志
    ,sum(t1.dr_ld_bal)                  as yd_oc_dr_bal             --昨日原币借方余额
    ,sum(t1.cr_ld_bal)                  as yd_oc_cr_bal             --昨日原币贷方余额
    ,sum(t1.stand_mony_tm_bg_dr_bal)    as yd_dc_dr_bal             --昨日本币借方余额
    ,sum(t1.stand_mony_tm_bg_cr_bal)    as yd_dc_cr_bal             --昨日本币贷方余额
    ,sum(t1.curr_bal)                   as td_oc_bal                --本日原币余额
    ,sum(t1.dr_bal)                     as td_oc_dr_bal             --本日原币借方余额
    ,sum(t1.cr_bal)                     as td_oc_cr_bal             --本日原币贷方余额
    ,sum(t1.stand_mony_term_end_dr_bal) as td_dc_dr_bal             --本日本币借方余额
    ,sum(t1.stand_mony_term_end_cr_bal) as td_dc_cr_bal             --本日本币贷方余额
    ,sum(t1.dr_td_amt)                  as td_oc_dr_amt             --本日原币借方发生额
    ,sum(t1.cr_td_amt)                  as td_oc_cr_amt             --本日原币贷方发生额
    ,sum(t1.dc_dr_amt)                  as td_dc_dr_amt             --本日本币借方发生额
    ,sum(t1.dc_cr_amt)                  as td_dc_cr_amt             --本日本币贷方发生额
	  ,max(t1.job_cd)                     as job_cd                   --任务代码
from ${iml_schema}.fin_gl_mult_flow t1
where t1.gl_type_cd ='D'
  and (t1.acct_dt = '${batch_date}' or substr(t1.acct_dt, 5, 4) = '1301')
  and t1.job_cd = 'tglsi1'
  and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
group by t1.sob_id, t1.acct_dt, t1.chn_id, t1.sellbl_prod_id, t1.curr_cd, t1.gl_org_id, t1.subj_id, t1.sys_cd;


create table ${icl_schema}.tmp_cmm_gl_bal_02
nologging
compress ${option_switch} for query high
as
select
    t3.sob_id                                                   --账套编号
    ,t3.acct_dt                                                 --账务期间
    ,t3.chn_id                                                  --标准产品编号
    ,t3.sellbl_prod_id                                          --交易渠道代码
    ,t3.curr_cd                                                 --币种代码
    ,t3.gl_org_id                                               --机构编号
    ,t3.subj_id                                                 --科目编号
    ,t3.sys_cd                                                  --数据来源代码
    ,sum(t3.dr_ld_bal)               as ten_dys_bg_dr_oc_bal    --旬初借方原币余额
    ,sum(t3.cr_ld_bal)               as ten_dys_bg_cr_oc_bal    --旬初贷方原币余额
    ,sum(t3.stand_mony_tm_bg_dr_bal) as ten_dys_bg_dr_dc_bal    --旬初借方本币余额
    ,sum(t3.stand_mony_tm_bg_cr_bal) as ten_dys_bg_cr_dc_bal    --旬初贷方本币余额
    ,sum(t3.dr_td_amt)               as ten_dys_bg_oc_dr_amt    --旬原币借方发生额
    ,sum(t3.cr_td_amt)               as ten_dys_bg_oc_cr_amt    --旬原币贷方发生额
    ,sum(t3.dc_dr_amt)               as ten_dys_bg_dc_dr_amt    --旬本币借方发生额
    ,sum(t3.dc_cr_amt)               as ten_dys_bg_dc_cr_amt    --旬本币贷方发生额
from ${iml_schema}.fin_gl_mult_flow t3
where t3.gl_type_cd = 'T'
  and (t3.acct_dt = '${batch_date}' or substr(t3.acct_dt, 5, 4) = '1301')
  and t3.job_cd = 'tglsi1'
  and t3.etl_dt = to_date('${batch_date}','yyyymmdd')
group by t3.sob_id, t3.acct_dt, t3.CHN_ID, t3.sellbl_prod_id, t3.curr_cd, t3.gl_org_id, t3.subj_id, t3.sys_cd;

create table ${icl_schema}.tmp_cmm_gl_bal_03
nologging
compress ${option_switch} for query high
as
select
    t4.sob_id                                            --账套编号
    ,t4.acct_dt                                          --账务期间
    ,t4.chn_id                                           --标准产品编号
    ,t4.sellbl_prod_id                                   --交易渠道代码
    ,t4.curr_cd                                          --币种代码
    ,t4.gl_org_id                                        --机构编号
    ,t4.subj_id                                          --科目编号
    ,t4.sys_cd                                           --数据来源代码
    ,sum(t4.dr_ld_bal)               as ear_m_dr_oc_bal  --月初借方原币余额
    ,sum(t4.cr_ld_bal)               as ear_m_cr_oc_bal  --月初贷方原币余额
    ,sum(t4.stand_mony_tm_bg_dr_bal) as ear_m_dr_dc_bal  --月初借方本币余额
    ,sum(t4.stand_mony_tm_bg_cr_bal) as ear_m_cr_dc_bal  --月初贷方本币余额
    ,sum(t4.dr_td_amt)               as mon_oc_dr_amt    --月原币借方发生额
    ,sum(t4.cr_td_amt)               as mon_oc_cr_amt    --月原币贷方发生额
    ,sum(t4.dc_dr_amt)               as mon_dc_dr_amt    --月本币借方发生额
    ,sum(t4.dc_cr_amt)               as mon_dc_cr_amt    --月本币贷方发生额
from ${iml_schema}.fin_gl_mult_flow t4
where t4.gl_type_cd = 'M'
  and (t4.acct_dt = '${batch_date}' or substr(t4.acct_dt, 5, 4) = '1301')
  and t4.job_cd = 'tglsi1'
  and t4.etl_dt = to_date('${batch_date}','yyyymmdd')
group by t4.sob_id, t4.acct_dt, t4.chn_id, t4.sellbl_prod_id, t4.curr_cd, t4.gl_org_id, t4.subj_id, t4.sys_cd;

create table ${icl_schema}.tmp_cmm_gl_bal_04
nologging
compress ${option_switch} for query high
as
select
    t5.sob_id                                             --账套编号
    ,t5.acct_dt                                           --账务期间
    ,t5.chn_id                                            --标准产品编号
    ,t5.sellbl_prod_id                                    --交易渠道代码
    ,t5.curr_cd                                           --币种代码
    ,t5.gl_org_id                                         --机构编号
    ,t5.subj_id                                           --科目编号
    ,t5.sys_cd                                            --数据来源代码
    ,sum(t5.dr_ld_bal)               as ear_s_dr_oc_bal   --季初借方原币余额
    ,sum(t5.cr_ld_bal)               as ear_s_cr_oc_bal   --季初贷方原币余额
    ,sum(t5.stand_mony_tm_bg_dr_bal) as ear_s_dr_dc_bal   --季初借方本币余额
    ,sum(t5.stand_mony_tm_bg_cr_bal) as ear_s_cr_dc_bal   --季初贷方本币余额
    ,sum(t5.dr_td_amt)               as ssn_oc_dr_amt     --季原币借方发生额
    ,sum(t5.cr_td_amt)               as ssn_oc_cr_amt     --季原币贷方发生额
    ,sum(t5.dc_dr_amt)               as ssn_dc_dr_amt     --季本币借方发生额
    ,sum(t5.dc_cr_amt)               as ssn_dc_cr_amt     --季本币贷方发生额
from ${iml_schema}.fin_gl_mult_flow t5
where t5.gl_type_cd = 'Q'
  and (t5.acct_dt = '${batch_date}' or substr(t5.acct_dt, 5, 4) = '1301')
  and t5.job_cd = 'tglsi1'
  and t5.etl_dt = to_date('${batch_date}','yyyymmdd')
group by t5.sob_id, t5.acct_dt, t5.chn_id, t5.sellbl_prod_id, t5.curr_cd, t5.gl_org_id, t5.subj_id, t5.sys_cd;

create table ${icl_schema}.tmp_cmm_gl_bal_05
nologging
compress ${option_switch} for query high
as
select
    t6.sob_id                                                 --账套编号
    ,t6.acct_dt                                               --账务期间
    ,t6.chn_id                                                --标准产品编号
    ,t6.sellbl_prod_id                                        --交易渠道代码
    ,t6.curr_cd                                               --币种代码
    ,t6.gl_org_id                                             --机构编号
    ,t6.subj_id                                               --科目编号
    ,t6.sys_cd                                                --数据来源代码
    ,sum(t6.dr_ld_bal)                 as ear_y_dr_oc_bal     --年初借方原币余额
    ,sum(t6.cr_ld_bal)                 as ear_y_cr_oc_bal     --年初贷方原币余额
    ,sum(t6.stand_mony_tm_bg_dr_bal)   as ear_y_dr_dc_bal     --年初借方本币余额
    ,sum(t6.stand_mony_tm_bg_cr_bal)   as ear_y_cr_dc_bal     --年初贷方本币余额
    ,sum(t6.dr_td_amt)                 as year_oc_dr_amt      --年原币借方发生额
    ,sum(t6.cr_td_amt)                 as year_oc_cr_amt      --年原币贷方发生额
    ,sum(t6.dc_dr_amt)                 as year_dc_dr_amt      --年本币借方发生额
    ,sum(t6.dc_cr_amt)                 as year_dc_cr_amt      --年本币贷方发生额
from ${iml_schema}.fin_gl_mult_flow t6
where t6.gl_type_cd = 'Y'
  and (t6.acct_dt = '${batch_date}' or substr(t6.acct_dt, 5, 4) = '1301')
  and t6.job_cd = 'tglsi1'
  and t6.etl_dt = to_date('${batch_date}','yyyymmdd')
group by t6.sob_id, t6.acct_dt, t6.chn_id, t6.sellbl_prod_id, t6.curr_cd, t6.gl_org_id, t6.subj_id, t6.sys_cd;

--半年期初
create table ${icl_schema}.tmp_cmm_gl_bal_06
nologging
compress ${option_switch} for query high
as
select
     t7.sob_id                                                       --账套编号
    ,t7.acct_dt                                                      --账务期间
    ,t7.chn_id                                                       --标准产品编号
    ,t7.sellbl_prod_id                                               --交易渠道代码
    ,t7.curr_cd                                                      --币种代码
    ,t7.gl_org_id                                                    --机构编号
    ,t7.subj_id                                                      --科目编号
    ,t7.sys_cd                                                       --数据来源代码
    ,sum(t7.dr_ld_bal)                 as half_y_tm_bg_dr_oc_bal     --半年期初借方原币余额
    ,sum(t7.cr_ld_bal)                 as half_y_tm_bg_cr_oc_bal     --半年期初贷方原币余额
    ,sum(t7.stand_mony_tm_bg_dr_bal)   as half_y_tm_bg_dr_dc_bal     --半年期初借方本币余额
    ,sum(t7.stand_mony_tm_bg_cr_bal)   as half_y_tm_bg_cr_dc_bal     --半年期初贷方本币余额
    ,sum(t7.dr_td_amt)                 as half_y_oc_dr_amt           --半年期原币借方发生额
    ,sum(t7.cr_td_amt)                 as half_y_oc_cr_amt           --半年期原币贷方发生额
    ,sum(t7.dc_dr_amt)                 as half_y_dc_dr_amt           --半年期本币借方发生额
    ,sum(t7.dc_cr_amt)                 as half_y_dc_cr_amt           --半年期本币贷方发生额
from ${iml_schema}.fin_gl_mult_flow t7
where t7.gl_type_cd = 'H'
  and (t7.acct_dt = '${batch_date}' or substr(t7.acct_dt, 5, 4) = '1301')
  and t7.job_cd = 'tglsi1'
  and t7.etl_dt = to_date('${batch_date}','yyyymmdd')
group by t7.sob_id, t7.acct_dt, t7.chn_id, t7.sellbl_prod_id, t7.curr_cd, t7.gl_org_id, t7.subj_id, t7.sys_cd;

-- 2.1 insert data to ex table
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_gl_bal_ex purge;

create table ${icl_schema}.cmm_gl_bal_ex
nologging
compress
as select * from ${icl_schema}.cmm_gl_bal where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_gl_bal_ex(
   etl_dt                                --数据日期
   ,lp_id                                --法人编号
   ,acct_set_id                          --账套编号
   ,acct_duran                           --账务期间
   ,acct_comb_id                         --账户组合编号
   ,std_prod_id                          --标准产品编号
   ,tran_CHN_CD                          --交易渠道代码
   ,curr_cd                              --币种代码
   ,org_id                               --机构编号
   ,subj_id                              --科目编号
   ,subj_name                            --科目名称
   ,budget_subj_id                       --预算科目编号
   ,subj_lev_cd                          --科目级别代码
   ,subj_dir_cd                          --科目方向代码
   ,subj_char_cd                         --科目性质代码
   ,data_src_cd                          --数据来源代码
   ,td_bal_dir_cd                        --本日余额方向代码
   ,in_out_tab_flg                       --表内外标志
   ,dtl_subj_flg                         --明细科目标志
   ,yd_oc_dr_bal                         --昨日原币借方余额
   ,yd_oc_cr_bal                         --昨日原币贷方余额
   ,yd_dc_dr_bal                         --昨日本币借方余额
   ,yd_dc_cr_bal                         --昨日本币贷方余额
   ,td_oc_bal                            --本日原币余额
   ,td_oc_dr_bal                         --本日原币借方余额
   ,td_oc_cr_bal                         --本日原币贷方余额
   ,td_dc_dr_bal                         --本日本币借方余额
   ,td_dc_cr_bal                         --本日本币贷方余额
   ,td_oc_dr_amt                         --本日原币借方发生额
   ,td_oc_cr_amt                         --本日原币贷方发生额
   ,td_dc_dr_amt                         --本日本币借方发生额
   ,td_dc_cr_amt                         --本日本币贷方发生额
   ,ten_dys_bg_dr_oc_bal                 --旬初借方原币余额
   ,ten_dys_bg_cr_oc_bal                 --旬初贷方原币余额
   ,ten_dys_bg_dr_dc_bal                 --旬初借方本币余额
   ,ten_dys_bg_cr_dc_bal                 --旬初贷方本币余额
   ,ten_dys_bg_oc_dr_amt                 --旬原币借方发生额
   ,ten_dys_bg_oc_cr_amt                 --旬原币贷方发生额
   ,ten_dys_bg_dc_dr_amt                 --旬本币借方发生额
   ,ten_dys_bg_dc_cr_amt                 --旬本币贷方发生额
   ,ear_m_dr_oc_bal                      --月初借方原币余额
   ,ear_m_cr_oc_bal                      --月初贷方原币余额
   ,ear_m_dr_dc_bal                      --月初借方本币余额
   ,ear_m_cr_dc_bal                      --月初贷方本币余额
   ,mon_oc_dr_amt                        --月原币借方发生额
   ,mon_oc_cr_amt                        --月原币贷方发生额
   ,mon_dc_dr_amt                        --月本币借方发生额
   ,mon_dc_cr_amt                        --月本币贷方发生额
   ,ear_s_dr_oc_bal                      --季初借方原币余额
   ,ear_s_cr_oc_bal                      --季初贷方原币余额
   ,ear_s_dr_dc_bal                      --季初借方本币余额
   ,ear_s_cr_dc_bal                      --季初贷方本币余额
   ,ssn_oc_dr_amt                        --季原币借方发生额
   ,ssn_oc_cr_amt                        --季原币贷方发生额
   ,ssn_dc_dr_amt                        --季本币借方发生额
   ,ssn_dc_cr_amt                        --季本币贷方发生额
   ,half_y_tm_bg_dr_oc_bal               --半年期初借方原币余额
   ,half_y_tm_bg_cr_oc_bal               --半年期初贷方原币余额
   ,half_y_tm_bg_dr_dc_bal               --半年期初借方本币余额
   ,half_y_tm_bg_cr_dc_bal               --半年期初贷方本币余额
   ,half_y_oc_dr_amt                     --半年原币借方发生额
   ,half_y_oc_cr_amt                     --半年原币贷方发生额
   ,half_y_dc_dr_amt                     --半年本币借方发生额
   ,half_y_dc_cr_amt                     --半年本币贷方发生额
   ,ear_y_dr_oc_bal                      --年初借方原币余额
   ,ear_y_cr_oc_bal                      --年初贷方原币余额
   ,ear_y_dr_dc_bal                      --年初借方本币余额
   ,ear_y_cr_dc_bal                      --年初贷方本币余额
   ,year_oc_dr_amt                       --年原币借方发生额
   ,year_oc_cr_amt                       --年原币贷方发生额
   ,year_dc_dr_amt                       --年本币借方发生额
   ,year_dc_cr_amt                       --年本币贷方发生额
   ,job_cd                               --任务代码
   ,etl_timestamp                        --etl处理时间戳
)
select
  to_date('${batch_date}','yyyymmdd')    --数据日期
  ,'9999'           as lp_id             --法人编号
  ,t1.sob_id                             --账套编号
  ,substr(t1.acct_dt,1,4)||'-'||substr(t1.acct_dt,5,2)  --账务期间
  ,''                                    --账户组合编号
  ,t1.sellbl_prod_id                     --标准产品编号
  ,t1.chn_id                             --交易渠道代码
  ,t1.curr_cd                            --币种代码
  ,t1.gl_org_id                          --机构编号
  ,t1.subj_id                            --科目编号
  ,t2.subj_name                          --科目名称
  ,''                                    --预算科目编号
  ,t2.subj_level_cd                      --科目级别代码
  ,t2.subj_bal_dir_cd                    --科目方向代码
  ,t2.subj_type_cd                       --科目性质代码
  ,t1.sys_cd                             --数据来源代码
  ,t1.td_bal_dir_cd                      --本日余额方向代码
  ,t2.in_bs_flg                          --表内外标志
  ,t1.dtl_subj_flg                       --明细科目标志
  ,t1.yd_oc_dr_bal                       --昨日原币借方余额
  ,t1.yd_oc_cr_bal                       --昨日原币贷方余额
  ,t1.yd_dc_dr_bal                       --昨日本币借方余额
  ,t1.yd_dc_cr_bal                       --昨日本币贷方余额
  ,t1.td_oc_bal                          --本日原币余额
  ,t1.td_oc_dr_bal                       --本日原币借方余额
  ,t1.td_oc_cr_bal                       --本日原币贷方余额
  ,t1.td_dc_dr_bal                       --本日本币借方余额
  ,t1.td_dc_cr_bal                       --本日本币贷方余额
  ,t1.td_oc_dr_amt                       --本日原币借方发生额
  ,t1.td_oc_cr_amt                       --本日原币贷方发生额
  ,t1.td_dc_dr_amt                       --本日本币借方发生额
  ,t1.td_dc_cr_amt                       --本日本币贷方发生额
  ,t3.ten_dys_bg_dr_oc_bal               --旬初借方原币余额
  ,t3.ten_dys_bg_cr_oc_bal               --旬初贷方原币余额
  ,t3.ten_dys_bg_dr_dc_bal               --旬初借方本币余额
  ,t3.ten_dys_bg_cr_dc_bal               --旬初贷方本币余额
  ,t3.ten_dys_bg_oc_dr_amt               --旬原币借方发生额
  ,t3.ten_dys_bg_oc_cr_amt               --旬原币贷方发生额
  ,t3.ten_dys_bg_dc_dr_amt               --旬本币借方发生额
  ,t3.ten_dys_bg_dc_cr_amt               --旬本币贷方发生额
  ,t4.ear_m_dr_oc_bal                    --月初借方原币余额
  ,t4.ear_m_cr_oc_bal                    --月初贷方原币余额
  ,t4.ear_m_dr_dc_bal                    --月初借方本币余额
  ,t4.ear_m_cr_dc_bal                    --月初贷方本币余额
  ,t4.mon_oc_dr_amt                      --月原币借方发生额
  ,t4.mon_oc_cr_amt                      --月原币贷方发生额
  ,t4.mon_dc_dr_amt                      --月本币借方发生额
  ,t4.mon_dc_cr_amt                      --月本币贷方发生额
  ,t5.ear_s_dr_oc_bal                    --季初借方原币余额
  ,t5.ear_s_cr_oc_bal                    --季初贷方原币余额
  ,t5.ear_s_dr_dc_bal                    --季初借方本币余额
  ,t5.ear_s_cr_dc_bal                    --季初贷方本币余额
  ,t5.ssn_oc_dr_amt                      --季原币借方发生额
  ,t5.ssn_oc_cr_amt                      --季原币贷方发生额
  ,t5.ssn_dc_dr_amt                      --季本币借方发生额
  ,t5.ssn_dc_cr_amt                      --季本币贷方发生额
  ,t7.half_y_tm_bg_dr_oc_bal             --半年期初借方原币余额
  ,t7.half_y_tm_bg_cr_oc_bal             --半年期初贷方原币余额
  ,t7.half_y_tm_bg_dr_dc_bal             --半年期初借方本币余额
  ,t7.half_y_tm_bg_cr_dc_bal             --半年期初贷方本币余额
  ,t7.half_y_oc_dr_amt                   --半年期原币借方发生额
  ,t7.half_y_oc_cr_amt                   --半年期原币贷方发生额
  ,t7.half_y_dc_dr_amt                   --半年期本币借方发生额
  ,t7.half_y_dc_cr_amt                   --半年期本币贷方发生额
  ,t6.ear_y_dr_oc_bal                    --年初借方原币余额
  ,t6.ear_y_cr_oc_bal                    --年初贷方原币余额
  ,t6.ear_y_dr_dc_bal                    --年初借方本币余额
  ,t6.ear_y_cr_dc_bal                    --年初贷方本币余额
  ,t6.year_oc_dr_amt                     --年原币借方发生额
  ,t6.year_oc_cr_amt                     --年原币贷方发生额
  ,t6.year_dc_dr_amt                     --年本币借方发生额
  ,t6.year_dc_cr_amt                     --年本币贷方发生额
  ,t1.job_cd                             --任务代码
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
 from ${icl_schema}.tmp_cmm_gl_bal_01 t1			--总账余额历史_日
 left join ${iml_schema}.fin_subj_info_h t2 --科目信息历史
   on t1.subj_id = t2.subj_id
  and t2.sob_id = '2'
  and t2.job_cd = 'tglsf1'
  and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t2.end_dt > to_date('${batch_date}','yyyymmdd')
 left join ${icl_schema}.tmp_cmm_gl_bal_02 t3 --总账余额历史_旬
   on t1.sob_id = t3.sob_id
  and t1.acct_dt = t3.acct_dt
  and t1.chn_id = t3.chn_id
  and t1.sellbl_prod_id = t3.sellbl_prod_id
  and t1.curr_cd = t3.curr_cd
  and t1.gl_org_id = t3.gl_org_id
  and t1.subj_id = t3.subj_id
  and t1.sys_cd = t3.sys_cd
 left join ${icl_schema}.tmp_cmm_gl_bal_03 t4 --总账余额历史_月
   on t1.sob_id = t4.sob_id
  and t1.acct_dt = t4.acct_dt
  and t1.chn_id = t4.chn_id
  and t1.sellbl_prod_id = t4.sellbl_prod_id
  and t1.curr_cd = t4.curr_cd
  and t1.gl_org_id = t4.gl_org_id
  and t1.subj_id = t4.subj_id
  and t1.sys_cd = t4.sys_cd
 left join ${icl_schema}.tmp_cmm_gl_bal_04 t5 --总账余额历史_季
   on t1.sob_id = t5.sob_id
  and t1.acct_dt = t5.acct_dt
  and t1.chn_id = t5.chn_id
  and t1.sellbl_prod_id = t5.sellbl_prod_id
  and t1.curr_cd = t5.curr_cd
  and t1.gl_org_id = t5.gl_org_id
  and t1.subj_id = t5.subj_id
  and t1.sys_cd = t5.sys_cd
 left join ${icl_schema}.tmp_cmm_gl_bal_05 t6 --总账余额历史_年
   on t1.sob_id = t6.sob_id
  and t1.acct_dt = t6.acct_dt
  and t1.chn_id = t6.chn_id
  and t1.sellbl_prod_id = t6.sellbl_prod_id
  and t1.curr_cd  = t6.curr_cd
  and t1.gl_org_id = t6.gl_org_id
  and t1.subj_id = t6.subj_id
  and t1.sys_cd = t6.sys_cd
 left join ${icl_schema}.tmp_cmm_gl_bal_06 t7 --总账余额历史_半年
   on t1.sob_id = t7.sob_id
  and t1.acct_dt = t7.acct_dt
  and t1.chn_id = t7.chn_id
  and t1.sellbl_prod_id = t7.sellbl_prod_id
  and t1.curr_cd  = t7.curr_cd
  and t1.gl_org_id = t7.gl_org_id
  and t1.subj_id = t7.subj_id
  and t1.sys_cd = t7.sys_cd
where 1=1
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_gl_bal exchange partition p_${batch_date} with table ${icl_schema}.cmm_gl_bal_ex;

-- 3.1 drop ex table
--drop table ${icl_schema}.cmm_gl_bal_ex purge;
--drop table ${icl_schema}.tmp_cmm_gl_bal_01 purge;
--drop table ${icl_schema}.tmp_cmm_gl_bal_02 purge;
--drop table ${icl_schema}.tmp_cmm_gl_bal_03 purge;
--drop table ${icl_schema}.tmp_cmm_gl_bal_04 purge;
--drop table ${icl_schema}.tmp_cmm_gl_bal_05 purge;
--drop table ${icl_schema}.tmp_cmm_gl_bal_06 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_gl_bal',partname => 'p_${batch_date}', degree => 8, cascade => true);