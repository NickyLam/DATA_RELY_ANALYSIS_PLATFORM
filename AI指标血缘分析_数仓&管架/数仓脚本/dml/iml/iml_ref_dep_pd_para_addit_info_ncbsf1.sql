/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_dep_pd_para_addit_info_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_dep_pd_para_addit_info add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_dep_pd_para_addit_info partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_tm purge;
drop table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_op purge;
drop table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    lp_id -- 法人编号
    ,pd_cd -- 期次编号
    ,min_chg_amt -- 最小变动金额
    ,int_rat_type_cd -- 利率类型代码
    ,stl_acct_type_cd -- 结算账户类型代码
    ,core_tran_teller_id -- 核心交易柜员编号
    ,dom_flg -- 境内标志
    ,transf_flg -- 转让标志
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,aval_lmt -- 可用额度
    ,min_retnd_amt -- 最小留存金额
    ,exec_int_rat -- 执行利率
    ,float_int_rat -- 浮动利率
    ,float_ratio -- 浮动比例
    ,redem_int_rat -- 赎回利率
    ,sellbl_chn_id -- 可售渠道编号
    ,redem_int_rat_type_cd -- 赎回利率类型代码
    ,tran_in_fee -- 转入费用
    ,allow_cap_src_inside_acct_flg -- 允许资金来源为内部户标志
    ,redem_int_rat_idf -- 赎回利率标识
    ,value_idf_cd -- 起息标识代码
    ,spec_col_int_flg -- 指定收息标志
    ,init_apot_redem_dt -- 原约定赎回日期
    ,tran_out_fee -- 转出费用
    ,tran_out_fee_type_cd -- 转出费用类型编号
    ,sell_org_id -- 出售机构编号
    ,sig_min_wdraw_amt -- 单次最小支取金额
    ,sig_subscr_max_amt -- 单笔认购最大金额
    ,tran_in_fee_type_cd -- 转入费用类型编号
    ,cust_type_cd -- 客户类型代码
    ,mailbox -- 邮箱
    ,comb_prod_flg -- 组合产品标志
    ,non_cust_visib_flg -- 非专享客户可见标志
    ,modif_id -- OM变更编号
    ,roll_issue_flg -- 滚动发行标志
    ,roll_begin_dt -- 滚动起始日期
    ,roll_termnt_dt -- 滚动终止日期
    ,redem_freq_corp_cd -- 赎回频率单位代码
    ,redem_freq -- 赎回频率
    ,white_list_modif_flg -- 白名单变更标志
    ,supt_modif_white_list_brch_org_id -- 支持变更白名单分行机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_dep_pd_para_addit_info partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_dep_pd_para_addit_info partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_dep_pd_para_addit_info partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_dc_stage_define_attach-1
insert into ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_tm(
    lp_id -- 法人编号
    ,pd_cd -- 期次编号
    ,min_chg_amt -- 最小变动金额
    ,int_rat_type_cd -- 利率类型代码
    ,stl_acct_type_cd -- 结算账户类型代码
    ,core_tran_teller_id -- 核心交易柜员编号
    ,dom_flg -- 境内标志
    ,transf_flg -- 转让标志
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,aval_lmt -- 可用额度
    ,min_retnd_amt -- 最小留存金额
    ,exec_int_rat -- 执行利率
    ,float_int_rat -- 浮动利率
    ,float_ratio -- 浮动比例
    ,redem_int_rat -- 赎回利率
    ,sellbl_chn_id -- 可售渠道编号
    ,redem_int_rat_type_cd -- 赎回利率类型代码
    ,tran_in_fee -- 转入费用
    ,allow_cap_src_inside_acct_flg -- 允许资金来源为内部户标志
    ,redem_int_rat_idf -- 赎回利率标识
    ,value_idf_cd -- 起息标识代码
    ,spec_col_int_flg -- 指定收息标志
    ,init_apot_redem_dt -- 原约定赎回日期
    ,tran_out_fee -- 转出费用
    ,tran_out_fee_type_cd -- 转出费用类型编号
    ,sell_org_id -- 出售机构编号
    ,sig_min_wdraw_amt -- 单次最小支取金额
    ,sig_subscr_max_amt -- 单笔认购最大金额
    ,tran_in_fee_type_cd -- 转入费用类型编号
    ,cust_type_cd -- 客户类型代码
    ,mailbox -- 邮箱
    ,comb_prod_flg -- 组合产品标志
    ,non_cust_visib_flg -- 非专享客户可见标志
    ,modif_id -- OM变更编号
    ,roll_issue_flg -- 滚动发行标志
    ,roll_begin_dt -- 滚动起始日期
    ,roll_termnt_dt -- 滚动终止日期
    ,redem_freq_corp_cd -- 赎回频率单位代码
    ,redem_freq -- 赎回频率
    ,white_list_modif_flg -- 白名单变更标志
    ,supt_modif_white_list_brch_org_id -- 支持变更白名单分行机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '9999' -- 法人编号
    ,P1.STAGE_CODE -- 期次编号
    ,P1.CHANGE_MIN_AMT -- 最小变动金额
    ,nvl(trim(P1.INT_TYPE),'-') -- 利率类型代码
    ,nvl(trim(P1.SETTLE_ACCT_TYPE),'-') -- 结算账户类型代码
    ,P1.USER_ID -- 核心交易柜员编号
    ,decode(trim(p1.INLAND_OFFSHORE),'','-','I','1','O','0',p1.INLAND_OFFSHORE) -- 境内标志
    ,decode(trim(p1.TRF_FLAG),'','-','Y','1','N','0',p1.TRF_FLAG) -- 转让标志
    ,P1.INT_START_DATE -- 起息日期
    ,P1.MATURITY_DATE -- 到期日期
    ,P1.AVAILABLE_LIMIT -- 可用额度
    ,P1.KEEP_MIN_BAL -- 最小留存金额
    ,P1.REAL_RATE -- 执行利率
    ,nvl(trim(P1.FLOAT_RATE),0) -- 浮动利率
    ,P1.SPREAD_PERCENT -- 浮动比例
    ,P1.TOHONOR_RATE -- 赎回利率
    ,nvl(trim(P1.ON_SALE_CHANNEL),'-') -- 可售渠道编号
    ,nvl(trim(P1.REDEMPTION_INT_TYPE),'-') -- 赎回利率类型代码
    ,P1.TRF_IN_FEE_AMT -- 转入费用
    ,decode(trim(p1.ALLOW_FUND_SOURCE_INNER_FLAG),'','-','Y','1','N','0',p1.ALLOW_FUND_SOURCE_INNER_FLAG) -- 允许资金来源为内部户标志
    ,P1.REDEMPTION_INT_FLAG -- 赎回利率标识
    ,nvl(trim(P1.INT_START_FLAG),'-') -- 起息标识代码
    ,decode(trim(p1.DIRECTION_CHARGE_INT_FLAG),'','-','Y','1','N','0',p1.DIRECTION_CHARGE_INT_FLAG) -- 指定收息标志
    ,P1.PROMISSORY_REDEEM_DATE -- 原约定赎回日期
    ,P1.TRF_OUT_FEE_AMT -- 转出费用
    ,P1.TRF_OUT_FEE_TYPE -- 转出费用类型编号
    ,P1.SELL_BRANCH -- 出售机构编号
    ,P1.SG_MIN_AMT -- 单次最小支取金额
    ,nvl(trim(P1.SG_MAX_AMT),0) -- 单笔认购最大金额
    ,P1.TRF_IN_FEE_TYPE -- 转入费用类型编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.EMAIL -- 邮箱
    ,nvl(trim(P1.COMB_PROD_FLAG),'-') -- 组合产品标志
    ,decode(P1.UN_WHITE_VIEW_FLAG,'Y','1','N','0',' ','-',P1.UN_WHITE_VIEW_FLAG) -- 非专享客户可见标志
    ,P1.OM_APPLY_NO -- OM变更编号
    ,decode(P1.ROLL_ISSUE_FLAG,'Y','1','N','0',' ','-',P1.ROLL_ISSUE_FLAG) -- 滚动发行标志
    ,P1.ROLL_START_DATE -- 滚动起始日期
    ,P1.ROLL_END_DATE -- 滚动终止日期
    ,nvl(trim(P1.REDEEM_TERM_TYPE),'-') -- 赎回频率单位代码
    ,to_number(nvl(trim(P1.REDEEM_TERM),'0')) -- 赎回频率
    ,decode(P1.WHITE_CHANGE_FLAG,'Y','1','N','0',' ','-',P1.WHITE_CHANGE_FLAG) -- 白名单变更标志
    ,P1.WHITE_SUPPORT_BRANCH -- 支持变更白名单分行机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_dc_stage_define_attach' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_dc_stage_define_attach p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_RB_DC_STAGE_DEFINE_ATTACH'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'REF_DEP_PD_PARA_ADDIT_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_tm 
  	                                group by 
  	                                        lp_id
  	                                        ,pd_cd
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_cl(
            lp_id -- 法人编号
    ,pd_cd -- 期次编号
    ,min_chg_amt -- 最小变动金额
    ,int_rat_type_cd -- 利率类型代码
    ,stl_acct_type_cd -- 结算账户类型代码
    ,core_tran_teller_id -- 核心交易柜员编号
    ,dom_flg -- 境内标志
    ,transf_flg -- 转让标志
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,aval_lmt -- 可用额度
    ,min_retnd_amt -- 最小留存金额
    ,exec_int_rat -- 执行利率
    ,float_int_rat -- 浮动利率
    ,float_ratio -- 浮动比例
    ,redem_int_rat -- 赎回利率
    ,sellbl_chn_id -- 可售渠道编号
    ,redem_int_rat_type_cd -- 赎回利率类型代码
    ,tran_in_fee -- 转入费用
    ,allow_cap_src_inside_acct_flg -- 允许资金来源为内部户标志
    ,redem_int_rat_idf -- 赎回利率标识
    ,value_idf_cd -- 起息标识代码
    ,spec_col_int_flg -- 指定收息标志
    ,init_apot_redem_dt -- 原约定赎回日期
    ,tran_out_fee -- 转出费用
    ,tran_out_fee_type_cd -- 转出费用类型编号
    ,sell_org_id -- 出售机构编号
    ,sig_min_wdraw_amt -- 单次最小支取金额
    ,sig_subscr_max_amt -- 单笔认购最大金额
    ,tran_in_fee_type_cd -- 转入费用类型编号
    ,cust_type_cd -- 客户类型代码
    ,mailbox -- 邮箱
    ,comb_prod_flg -- 组合产品标志
    ,non_cust_visib_flg -- 非专享客户可见标志
    ,modif_id -- OM变更编号
    ,roll_issue_flg -- 滚动发行标志
    ,roll_begin_dt -- 滚动起始日期
    ,roll_termnt_dt -- 滚动终止日期
    ,redem_freq_corp_cd -- 赎回频率单位代码
    ,redem_freq -- 赎回频率
    ,white_list_modif_flg -- 白名单变更标志
    ,supt_modif_white_list_brch_org_id -- 支持变更白名单分行机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_op(
            lp_id -- 法人编号
    ,pd_cd -- 期次编号
    ,min_chg_amt -- 最小变动金额
    ,int_rat_type_cd -- 利率类型代码
    ,stl_acct_type_cd -- 结算账户类型代码
    ,core_tran_teller_id -- 核心交易柜员编号
    ,dom_flg -- 境内标志
    ,transf_flg -- 转让标志
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,aval_lmt -- 可用额度
    ,min_retnd_amt -- 最小留存金额
    ,exec_int_rat -- 执行利率
    ,float_int_rat -- 浮动利率
    ,float_ratio -- 浮动比例
    ,redem_int_rat -- 赎回利率
    ,sellbl_chn_id -- 可售渠道编号
    ,redem_int_rat_type_cd -- 赎回利率类型代码
    ,tran_in_fee -- 转入费用
    ,allow_cap_src_inside_acct_flg -- 允许资金来源为内部户标志
    ,redem_int_rat_idf -- 赎回利率标识
    ,value_idf_cd -- 起息标识代码
    ,spec_col_int_flg -- 指定收息标志
    ,init_apot_redem_dt -- 原约定赎回日期
    ,tran_out_fee -- 转出费用
    ,tran_out_fee_type_cd -- 转出费用类型编号
    ,sell_org_id -- 出售机构编号
    ,sig_min_wdraw_amt -- 单次最小支取金额
    ,sig_subscr_max_amt -- 单笔认购最大金额
    ,tran_in_fee_type_cd -- 转入费用类型编号
    ,cust_type_cd -- 客户类型代码
    ,mailbox -- 邮箱
    ,comb_prod_flg -- 组合产品标志
    ,non_cust_visib_flg -- 非专享客户可见标志
    ,modif_id -- OM变更编号
    ,roll_issue_flg -- 滚动发行标志
    ,roll_begin_dt -- 滚动起始日期
    ,roll_termnt_dt -- 滚动终止日期
    ,redem_freq_corp_cd -- 赎回频率单位代码
    ,redem_freq -- 赎回频率
    ,white_list_modif_flg -- 白名单变更标志
    ,supt_modif_white_list_brch_org_id -- 支持变更白名单分行机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.pd_cd, o.pd_cd) as pd_cd -- 期次编号
    ,nvl(n.min_chg_amt, o.min_chg_amt) as min_chg_amt -- 最小变动金额
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.stl_acct_type_cd, o.stl_acct_type_cd) as stl_acct_type_cd -- 结算账户类型代码
    ,nvl(n.core_tran_teller_id, o.core_tran_teller_id) as core_tran_teller_id -- 核心交易柜员编号
    ,nvl(n.dom_flg, o.dom_flg) as dom_flg -- 境内标志
    ,nvl(n.transf_flg, o.transf_flg) as transf_flg -- 转让标志
    ,nvl(n.value_dt, o.value_dt) as value_dt -- 起息日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.aval_lmt, o.aval_lmt) as aval_lmt -- 可用额度
    ,nvl(n.min_retnd_amt, o.min_retnd_amt) as min_retnd_amt -- 最小留存金额
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.float_int_rat, o.float_int_rat) as float_int_rat -- 浮动利率
    ,nvl(n.float_ratio, o.float_ratio) as float_ratio -- 浮动比例
    ,nvl(n.redem_int_rat, o.redem_int_rat) as redem_int_rat -- 赎回利率
    ,nvl(n.sellbl_chn_id, o.sellbl_chn_id) as sellbl_chn_id -- 可售渠道编号
    ,nvl(n.redem_int_rat_type_cd, o.redem_int_rat_type_cd) as redem_int_rat_type_cd -- 赎回利率类型代码
    ,nvl(n.tran_in_fee, o.tran_in_fee) as tran_in_fee -- 转入费用
    ,nvl(n.allow_cap_src_inside_acct_flg, o.allow_cap_src_inside_acct_flg) as allow_cap_src_inside_acct_flg -- 允许资金来源为内部户标志
    ,nvl(n.redem_int_rat_idf, o.redem_int_rat_idf) as redem_int_rat_idf -- 赎回利率标识
    ,nvl(n.value_idf_cd, o.value_idf_cd) as value_idf_cd -- 起息标识代码
    ,nvl(n.spec_col_int_flg, o.spec_col_int_flg) as spec_col_int_flg -- 指定收息标志
    ,nvl(n.init_apot_redem_dt, o.init_apot_redem_dt) as init_apot_redem_dt -- 原约定赎回日期
    ,nvl(n.tran_out_fee, o.tran_out_fee) as tran_out_fee -- 转出费用
    ,nvl(n.tran_out_fee_type_cd, o.tran_out_fee_type_cd) as tran_out_fee_type_cd -- 转出费用类型编号
    ,nvl(n.sell_org_id, o.sell_org_id) as sell_org_id -- 出售机构编号
    ,nvl(n.sig_min_wdraw_amt, o.sig_min_wdraw_amt) as sig_min_wdraw_amt -- 单次最小支取金额
    ,nvl(n.sig_subscr_max_amt, o.sig_subscr_max_amt) as sig_subscr_max_amt -- 单笔认购最大金额
    ,nvl(n.tran_in_fee_type_cd, o.tran_in_fee_type_cd) as tran_in_fee_type_cd -- 转入费用类型编号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.mailbox, o.mailbox) as mailbox -- 邮箱
    ,nvl(n.comb_prod_flg, o.comb_prod_flg) as comb_prod_flg -- 组合产品标志
    ,nvl(n.non_cust_visib_flg, o.non_cust_visib_flg) as non_cust_visib_flg -- 非专享客户可见标志
    ,nvl(n.modif_id, o.modif_id) as modif_id -- OM变更编号
    ,nvl(n.roll_issue_flg, o.roll_issue_flg) as roll_issue_flg -- 滚动发行标志
    ,nvl(n.roll_begin_dt, o.roll_begin_dt) as roll_begin_dt -- 滚动起始日期
    ,nvl(n.roll_termnt_dt, o.roll_termnt_dt) as roll_termnt_dt -- 滚动终止日期
    ,nvl(n.redem_freq_corp_cd, o.redem_freq_corp_cd) as redem_freq_corp_cd -- 赎回频率单位代码
    ,nvl(n.redem_freq, o.redem_freq) as redem_freq -- 赎回频率
    ,nvl(n.white_list_modif_flg, o.white_list_modif_flg) as white_list_modif_flg -- 白名单变更标志
    ,nvl(n.supt_modif_white_list_brch_org_id, o.supt_modif_white_list_brch_org_id) as supt_modif_white_list_brch_org_id -- 支持变更白名单分行机构编号
    ,case when
            n.lp_id is null
            and n.pd_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lp_id is null
            and n.pd_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lp_id is null
            and n.pd_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.lp_id = n.lp_id
            and o.pd_cd = n.pd_cd
where (
        o.lp_id is null
        and o.pd_cd is null
    )
    or (
        n.lp_id is null
        and n.pd_cd is null
    )
    or (
        o.min_chg_amt <> n.min_chg_amt
        or o.int_rat_type_cd <> n.int_rat_type_cd
        or o.stl_acct_type_cd <> n.stl_acct_type_cd
        or o.core_tran_teller_id <> n.core_tran_teller_id
        or o.dom_flg <> n.dom_flg
        or o.transf_flg <> n.transf_flg
        or o.value_dt <> n.value_dt
        or o.exp_dt <> n.exp_dt
        or o.aval_lmt <> n.aval_lmt
        or o.min_retnd_amt <> n.min_retnd_amt
        or o.exec_int_rat <> n.exec_int_rat
        or o.float_int_rat <> n.float_int_rat
        or o.float_ratio <> n.float_ratio
        or o.redem_int_rat <> n.redem_int_rat
        or o.sellbl_chn_id <> n.sellbl_chn_id
        or o.redem_int_rat_type_cd <> n.redem_int_rat_type_cd
        or o.tran_in_fee <> n.tran_in_fee
        or o.allow_cap_src_inside_acct_flg <> n.allow_cap_src_inside_acct_flg
        or o.redem_int_rat_idf <> n.redem_int_rat_idf
        or o.value_idf_cd <> n.value_idf_cd
        or o.spec_col_int_flg <> n.spec_col_int_flg
        or o.init_apot_redem_dt <> n.init_apot_redem_dt
        or o.tran_out_fee <> n.tran_out_fee
        or o.tran_out_fee_type_cd <> n.tran_out_fee_type_cd
        or o.sell_org_id <> n.sell_org_id
        or o.sig_min_wdraw_amt <> n.sig_min_wdraw_amt
        or o.sig_subscr_max_amt <> n.sig_subscr_max_amt
        or o.tran_in_fee_type_cd <> n.tran_in_fee_type_cd
        or o.cust_type_cd <> n.cust_type_cd
        or o.mailbox <> n.mailbox
        or o.comb_prod_flg <> n.comb_prod_flg
        or o.non_cust_visib_flg <> n.non_cust_visib_flg
        or o.modif_id <> n.modif_id
        or o.roll_issue_flg <> n.roll_issue_flg
        or o.roll_begin_dt <> n.roll_begin_dt
        or o.roll_termnt_dt <> n.roll_termnt_dt
        or o.redem_freq_corp_cd <> n.redem_freq_corp_cd
        or o.redem_freq <> n.redem_freq
        or o.white_list_modif_flg <> n.white_list_modif_flg
        or o.supt_modif_white_list_brch_org_id <> n.supt_modif_white_list_brch_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_cl(
            lp_id -- 法人编号
    ,pd_cd -- 期次编号
    ,min_chg_amt -- 最小变动金额
    ,int_rat_type_cd -- 利率类型代码
    ,stl_acct_type_cd -- 结算账户类型代码
    ,core_tran_teller_id -- 核心交易柜员编号
    ,dom_flg -- 境内标志
    ,transf_flg -- 转让标志
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,aval_lmt -- 可用额度
    ,min_retnd_amt -- 最小留存金额
    ,exec_int_rat -- 执行利率
    ,float_int_rat -- 浮动利率
    ,float_ratio -- 浮动比例
    ,redem_int_rat -- 赎回利率
    ,sellbl_chn_id -- 可售渠道编号
    ,redem_int_rat_type_cd -- 赎回利率类型代码
    ,tran_in_fee -- 转入费用
    ,allow_cap_src_inside_acct_flg -- 允许资金来源为内部户标志
    ,redem_int_rat_idf -- 赎回利率标识
    ,value_idf_cd -- 起息标识代码
    ,spec_col_int_flg -- 指定收息标志
    ,init_apot_redem_dt -- 原约定赎回日期
    ,tran_out_fee -- 转出费用
    ,tran_out_fee_type_cd -- 转出费用类型编号
    ,sell_org_id -- 出售机构编号
    ,sig_min_wdraw_amt -- 单次最小支取金额
    ,sig_subscr_max_amt -- 单笔认购最大金额
    ,tran_in_fee_type_cd -- 转入费用类型编号
    ,cust_type_cd -- 客户类型代码
    ,mailbox -- 邮箱
    ,comb_prod_flg -- 组合产品标志
    ,non_cust_visib_flg -- 非专享客户可见标志
    ,modif_id -- OM变更编号
    ,roll_issue_flg -- 滚动发行标志
    ,roll_begin_dt -- 滚动起始日期
    ,roll_termnt_dt -- 滚动终止日期
    ,redem_freq_corp_cd -- 赎回频率单位代码
    ,redem_freq -- 赎回频率
    ,white_list_modif_flg -- 白名单变更标志
    ,supt_modif_white_list_brch_org_id -- 支持变更白名单分行机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_op(
            lp_id -- 法人编号
    ,pd_cd -- 期次编号
    ,min_chg_amt -- 最小变动金额
    ,int_rat_type_cd -- 利率类型代码
    ,stl_acct_type_cd -- 结算账户类型代码
    ,core_tran_teller_id -- 核心交易柜员编号
    ,dom_flg -- 境内标志
    ,transf_flg -- 转让标志
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,aval_lmt -- 可用额度
    ,min_retnd_amt -- 最小留存金额
    ,exec_int_rat -- 执行利率
    ,float_int_rat -- 浮动利率
    ,float_ratio -- 浮动比例
    ,redem_int_rat -- 赎回利率
    ,sellbl_chn_id -- 可售渠道编号
    ,redem_int_rat_type_cd -- 赎回利率类型代码
    ,tran_in_fee -- 转入费用
    ,allow_cap_src_inside_acct_flg -- 允许资金来源为内部户标志
    ,redem_int_rat_idf -- 赎回利率标识
    ,value_idf_cd -- 起息标识代码
    ,spec_col_int_flg -- 指定收息标志
    ,init_apot_redem_dt -- 原约定赎回日期
    ,tran_out_fee -- 转出费用
    ,tran_out_fee_type_cd -- 转出费用类型编号
    ,sell_org_id -- 出售机构编号
    ,sig_min_wdraw_amt -- 单次最小支取金额
    ,sig_subscr_max_amt -- 单笔认购最大金额
    ,tran_in_fee_type_cd -- 转入费用类型编号
    ,cust_type_cd -- 客户类型代码
    ,mailbox -- 邮箱
    ,comb_prod_flg -- 组合产品标志
    ,non_cust_visib_flg -- 非专享客户可见标志
    ,modif_id -- OM变更编号
    ,roll_issue_flg -- 滚动发行标志
    ,roll_begin_dt -- 滚动起始日期
    ,roll_termnt_dt -- 滚动终止日期
    ,redem_freq_corp_cd -- 赎回频率单位代码
    ,redem_freq -- 赎回频率
    ,white_list_modif_flg -- 白名单变更标志
    ,supt_modif_white_list_brch_org_id -- 支持变更白名单分行机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.lp_id -- 法人编号
    ,o.pd_cd -- 期次编号
    ,o.min_chg_amt -- 最小变动金额
    ,o.int_rat_type_cd -- 利率类型代码
    ,o.stl_acct_type_cd -- 结算账户类型代码
    ,o.core_tran_teller_id -- 核心交易柜员编号
    ,o.dom_flg -- 境内标志
    ,o.transf_flg -- 转让标志
    ,o.value_dt -- 起息日期
    ,o.exp_dt -- 到期日期
    ,o.aval_lmt -- 可用额度
    ,o.min_retnd_amt -- 最小留存金额
    ,o.exec_int_rat -- 执行利率
    ,o.float_int_rat -- 浮动利率
    ,o.float_ratio -- 浮动比例
    ,o.redem_int_rat -- 赎回利率
    ,o.sellbl_chn_id -- 可售渠道编号
    ,o.redem_int_rat_type_cd -- 赎回利率类型代码
    ,o.tran_in_fee -- 转入费用
    ,o.allow_cap_src_inside_acct_flg -- 允许资金来源为内部户标志
    ,o.redem_int_rat_idf -- 赎回利率标识
    ,o.value_idf_cd -- 起息标识代码
    ,o.spec_col_int_flg -- 指定收息标志
    ,o.init_apot_redem_dt -- 原约定赎回日期
    ,o.tran_out_fee -- 转出费用
    ,o.tran_out_fee_type_cd -- 转出费用类型编号
    ,o.sell_org_id -- 出售机构编号
    ,o.sig_min_wdraw_amt -- 单次最小支取金额
    ,o.sig_subscr_max_amt -- 单笔认购最大金额
    ,o.tran_in_fee_type_cd -- 转入费用类型编号
    ,o.cust_type_cd -- 客户类型代码
    ,o.mailbox -- 邮箱
    ,o.comb_prod_flg -- 组合产品标志
    ,o.non_cust_visib_flg -- 非专享客户可见标志
    ,o.modif_id -- OM变更编号
    ,o.roll_issue_flg -- 滚动发行标志
    ,o.roll_begin_dt -- 滚动起始日期
    ,o.roll_termnt_dt -- 滚动终止日期
    ,o.redem_freq_corp_cd -- 赎回频率单位代码
    ,o.redem_freq -- 赎回频率
    ,o.white_list_modif_flg -- 白名单变更标志
    ,o.supt_modif_white_list_brch_org_id -- 支持变更白名单分行机构编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_bk o
    left join ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_op n
        on
            o.lp_id = n.lp_id
            and o.pd_cd = n.pd_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_cl d
        on
            o.lp_id = d.lp_id
            and o.pd_cd = d.pd_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_dep_pd_para_addit_info;
--alter table ${iml_schema}.ref_dep_pd_para_addit_info truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_dep_pd_para_addit_info') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_dep_pd_para_addit_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_dep_pd_para_addit_info modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_dep_pd_para_addit_info exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_cl;
alter table ${iml_schema}.ref_dep_pd_para_addit_info exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_dep_pd_para_addit_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_tm purge;
drop table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_op purge;
drop table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_dep_pd_para_addit_info_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_dep_pd_para_addit_info', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
