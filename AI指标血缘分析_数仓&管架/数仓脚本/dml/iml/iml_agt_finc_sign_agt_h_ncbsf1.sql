/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_finc_sign_agt_h_ncbsf1
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
alter table ${iml_schema}.agt_finc_sign_agt_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_sign_agt_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,finc_prod_id -- 理财产品编号
    ,finc_prod_type_descb -- 理财产品类型描述
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,finc_amt -- 理财金额
    ,agt_retnd_amt -- 协议留存金额
    ,auto_delay_flg -- 自动延期标志
    ,sign_agt_status_cd -- 签约协议状态代码
    ,cust_id -- 客户编号
    ,final_modif_dt -- 最后修改日期
    ,min_init_amt -- 最小起存金额
    ,finc_fix_amt -- 理财固定金额
    ,dep_tenor -- 存款期限
    ,dep_tenor_type_cd -- 存款期限类型代码
    ,auto_redt_way_type_cd -- 自动转存方式类型代码
    ,conti_redt_fail_cnt -- 连续转存失败次数
    ,conti_redt_sucs_cnt -- 连续转存成功次数
    ,redt_fail_tot_cnt -- 转存失败总次数
    ,redt_sucs_tot_cnt -- 转存成功总次数
    ,last_redt_flow_id -- 上一转存流水编号
    ,tran_freq -- 划转频率
    ,tran_freq_cd -- 划转频率代码
    ,last_tran_dt -- 上次划转日期
    ,next_tran_dt -- 下次划转日期
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,sign_flow_id -- 签约流水编号
    ,rels_org_id -- 解约机构编号
    ,rels_teller_id -- 解约柜员编号
    ,rels_flow_id -- 解约流水编号
    ,a_try_redt_dt -- 重新尝试转存日期
    ,lmt_ped -- 限额周期
    ,max_lmt -- 最大限额
    ,occu_lmt -- 已占用额度
    ,next_calc_dt -- 下一计算日期
    ,curr_mon_acm_end_day_bal -- 当月累计日终余额
    ,cust_mgr_id -- 客户经理编号
    ,reg_acct_curr_cd -- 定期账户币种代码
    ,reg_acct_prod_id -- 定期账户产品编号
    ,reg_acct_sub_acct -- 定期账户子账号
    ,reg_acct_id -- 定期账户编号
    ,tran_day -- 划转日
    ,redt_begin_dt -- 转存起始日期
    ,redt_termnt_dt -- 转存终止日期
    ,auto_payoff_flg -- 自动结清标志
    ,core_dep_char_cd -- 核心存款性质代码
    ,fail_rs_descb -- 失败原因描述
    ,rels_dt -- 解约日期
    ,stl_sub_acct_acm_bal_dt -- 结算盈子户累计余额日期
    ,auto_scd_sign_flg -- 自动续签标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_sign_agt_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_sign_agt_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_sign_agt_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_agreement_financial-1
insert into ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,finc_prod_id -- 理财产品编号
    ,finc_prod_type_descb -- 理财产品类型描述
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,finc_amt -- 理财金额
    ,agt_retnd_amt -- 协议留存金额
    ,auto_delay_flg -- 自动延期标志
    ,sign_agt_status_cd -- 签约协议状态代码
    ,cust_id -- 客户编号
    ,final_modif_dt -- 最后修改日期
    ,min_init_amt -- 最小起存金额
    ,finc_fix_amt -- 理财固定金额
    ,dep_tenor -- 存款期限
    ,dep_tenor_type_cd -- 存款期限类型代码
    ,auto_redt_way_type_cd -- 自动转存方式类型代码
    ,conti_redt_fail_cnt -- 连续转存失败次数
    ,conti_redt_sucs_cnt -- 连续转存成功次数
    ,redt_fail_tot_cnt -- 转存失败总次数
    ,redt_sucs_tot_cnt -- 转存成功总次数
    ,last_redt_flow_id -- 上一转存流水编号
    ,tran_freq -- 划转频率
    ,tran_freq_cd -- 划转频率代码
    ,last_tran_dt -- 上次划转日期
    ,next_tran_dt -- 下次划转日期
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,sign_flow_id -- 签约流水编号
    ,rels_org_id -- 解约机构编号
    ,rels_teller_id -- 解约柜员编号
    ,rels_flow_id -- 解约流水编号
    ,a_try_redt_dt -- 重新尝试转存日期
    ,lmt_ped -- 限额周期
    ,max_lmt -- 最大限额
    ,occu_lmt -- 已占用额度
    ,next_calc_dt -- 下一计算日期
    ,curr_mon_acm_end_day_bal -- 当月累计日终余额
    ,cust_mgr_id -- 客户经理编号
    ,reg_acct_curr_cd -- 定期账户币种代码
    ,reg_acct_prod_id -- 定期账户产品编号
    ,reg_acct_sub_acct -- 定期账户子账号
    ,reg_acct_id -- 定期账户编号
    ,tran_day -- 划转日
    ,redt_begin_dt -- 转存起始日期
    ,redt_termnt_dt -- 转存终止日期
    ,auto_payoff_flg -- 自动结清标志
    ,core_dep_char_cd -- 核心存款性质代码
    ,fail_rs_descb -- 失败原因描述
    ,rels_dt -- 解约日期
    ,stl_sub_acct_acm_bal_dt -- 结算盈子户累计余额日期
    ,auto_scd_sign_flg -- 自动续签标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300003'||P1.AGREEMENT_ID -- 协议编号
    ,P1.AGREEMENT_ID -- 存款协议编号
    ,'9999' -- 法人编号
    ,P1.AGREEMENT_TYPE -- 签约协议类型代码
    ,P1.FIN_PROD_TYPE -- 理财产品编号
    ,P1.FIN_PROD_DESC -- 理财产品类型描述
    ,P1.INTERNAL_KEY -- 账户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_CCY -- 账户币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.START_DATE -- 生效日期
    ,P1.END_DATE -- 失效日期
    ,P1.FINANCIAL_AMOUNT -- 理财金额
    ,P1.REMAIN_AMT -- 协议留存金额
    ,decode(trim(p1.AUTO_EXTEND),'','-','Y','1','N','0',p1.AUTO_EXTEND) -- 自动延期标志
    ,P1.AGREEMENT_STATUS -- 签约协议状态代码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.INT_MIN_AMT -- 最小起存金额
    ,P1.FIN_FIXED_AMT -- 理财固定金额
    ,P1.TERM -- 存款期限
    ,P1.TERM_TYPE -- 存款期限类型代码
    ,P1.AUTO_RENEW_ROLLOVER -- 自动转存方式类型代码
    ,P1.FAILURE_TIMES -- 连续转存失败次数
    ,P1.SUCCESS_TIMES -- 连续转存成功次数
    ,P1.FAILURE_TOTAL_TIMES -- 转存失败总次数
    ,P1.SUCCESS_TOTAL_TIMES -- 转存成功总次数
    ,P1.LAST_TRANSFER_REFERENCE -- 上一转存流水编号
    ,to_number(nvl(trim(P1.TRANSFER_FREQ),0)) -- 划转频率
    ,nvl(trim(p1.TRANSFER_FREQ_TYPE),'-') -- 划转频率代码
    ,P1.LAST_TRANSFER_DATE -- 上次划转日期
    ,P1.NEXT_TRANSFER_DATE -- 下次划转日期
    ,P1.SIGN_BRANCH -- 签约机构编号
    ,P1.SIGN_USER_ID -- 签约柜员编号
    ,P1.SIGN_REFERENCE -- 签约流水编号
    ,P1.OUT_SIGN_BRANCH -- 解约机构编号
    ,P1.OUT_SIGN_USER_ID -- 解约柜员编号
    ,P1.UNSIGN_REFERENCE -- 解约流水编号
    ,P1.RETRY_TRANSFER_DATE -- 重新尝试转存日期
    ,P1.LIMIT_PERIOD_FREQ -- 限额周期
    ,P1.LIMIT_MAX_AMT -- 最大限额
    ,P1.HOLDING_LIMIT -- 已占用额度
    ,P1.NEXT_CALC_DATE -- 下一计算日期
    ,P1.MONTH_TOTAL_AMOUNT -- 当月累计日终余额
    ,P1.ACCT_EXEC -- 客户经理编号
    ,nvl(trim(P1.TDA_ACCT_CCY),'-') -- 定期账户币种代码
    ,P1.TDA_ACCT_PROD_TYPE -- 定期账户产品编号
    ,P1.TDA_ACCT_SEQ_NO -- 定期账户子账号
    ,P1.TDA_BASE_ACCT_NO -- 定期账户编号
    ,to_number(decode(trim(P1.TRANSFER_DAY),'','0','--','0',P1.TRANSFER_DAY)) -- 划转日
    ,P1.TRANSFER_START_DATE -- 转存起始日期
    ,P1.TRANSFER_END_DATE -- 转存终止日期
    ,decode(P1.AUTO_SETTLE_FLAG,'Y','1','N','0',' ','-',P1.AUTO_SETTLE_FLAG) -- 自动结清标志
    ,nvl(trim(P1.DEPOSIT_NATURE),'-') -- 核心存款性质代码
    ,P1.FAILURE_REASON -- 失败原因描述
    ,P1.UNSIGN_OPERATE_DATE -- 解约日期
    ,P1.BACKUP_DATE -- 结算盈子户累计余额日期
    ,decode(P1.IS_AUTO_SIGN,'Y','1','N','0',' ','-',P1.IS_AUTO_SIGN) -- 自动续签标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_agreement_financial' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_financial p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.base_acct_no = p8.base_acct_no
   and p8.base_acct_no like '0%'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,dep_agt_id
  	                                        ,lp_id
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
        into ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,finc_prod_id -- 理财产品编号
    ,finc_prod_type_descb -- 理财产品类型描述
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,finc_amt -- 理财金额
    ,agt_retnd_amt -- 协议留存金额
    ,auto_delay_flg -- 自动延期标志
    ,sign_agt_status_cd -- 签约协议状态代码
    ,cust_id -- 客户编号
    ,final_modif_dt -- 最后修改日期
    ,min_init_amt -- 最小起存金额
    ,finc_fix_amt -- 理财固定金额
    ,dep_tenor -- 存款期限
    ,dep_tenor_type_cd -- 存款期限类型代码
    ,auto_redt_way_type_cd -- 自动转存方式类型代码
    ,conti_redt_fail_cnt -- 连续转存失败次数
    ,conti_redt_sucs_cnt -- 连续转存成功次数
    ,redt_fail_tot_cnt -- 转存失败总次数
    ,redt_sucs_tot_cnt -- 转存成功总次数
    ,last_redt_flow_id -- 上一转存流水编号
    ,tran_freq -- 划转频率
    ,tran_freq_cd -- 划转频率代码
    ,last_tran_dt -- 上次划转日期
    ,next_tran_dt -- 下次划转日期
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,sign_flow_id -- 签约流水编号
    ,rels_org_id -- 解约机构编号
    ,rels_teller_id -- 解约柜员编号
    ,rels_flow_id -- 解约流水编号
    ,a_try_redt_dt -- 重新尝试转存日期
    ,lmt_ped -- 限额周期
    ,max_lmt -- 最大限额
    ,occu_lmt -- 已占用额度
    ,next_calc_dt -- 下一计算日期
    ,curr_mon_acm_end_day_bal -- 当月累计日终余额
    ,cust_mgr_id -- 客户经理编号
    ,reg_acct_curr_cd -- 定期账户币种代码
    ,reg_acct_prod_id -- 定期账户产品编号
    ,reg_acct_sub_acct -- 定期账户子账号
    ,reg_acct_id -- 定期账户编号
    ,tran_day -- 划转日
    ,redt_begin_dt -- 转存起始日期
    ,redt_termnt_dt -- 转存终止日期
    ,auto_payoff_flg -- 自动结清标志
    ,core_dep_char_cd -- 核心存款性质代码
    ,fail_rs_descb -- 失败原因描述
    ,rels_dt -- 解约日期
    ,stl_sub_acct_acm_bal_dt -- 结算盈子户累计余额日期
    ,auto_scd_sign_flg -- 自动续签标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,finc_prod_id -- 理财产品编号
    ,finc_prod_type_descb -- 理财产品类型描述
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,finc_amt -- 理财金额
    ,agt_retnd_amt -- 协议留存金额
    ,auto_delay_flg -- 自动延期标志
    ,sign_agt_status_cd -- 签约协议状态代码
    ,cust_id -- 客户编号
    ,final_modif_dt -- 最后修改日期
    ,min_init_amt -- 最小起存金额
    ,finc_fix_amt -- 理财固定金额
    ,dep_tenor -- 存款期限
    ,dep_tenor_type_cd -- 存款期限类型代码
    ,auto_redt_way_type_cd -- 自动转存方式类型代码
    ,conti_redt_fail_cnt -- 连续转存失败次数
    ,conti_redt_sucs_cnt -- 连续转存成功次数
    ,redt_fail_tot_cnt -- 转存失败总次数
    ,redt_sucs_tot_cnt -- 转存成功总次数
    ,last_redt_flow_id -- 上一转存流水编号
    ,tran_freq -- 划转频率
    ,tran_freq_cd -- 划转频率代码
    ,last_tran_dt -- 上次划转日期
    ,next_tran_dt -- 下次划转日期
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,sign_flow_id -- 签约流水编号
    ,rels_org_id -- 解约机构编号
    ,rels_teller_id -- 解约柜员编号
    ,rels_flow_id -- 解约流水编号
    ,a_try_redt_dt -- 重新尝试转存日期
    ,lmt_ped -- 限额周期
    ,max_lmt -- 最大限额
    ,occu_lmt -- 已占用额度
    ,next_calc_dt -- 下一计算日期
    ,curr_mon_acm_end_day_bal -- 当月累计日终余额
    ,cust_mgr_id -- 客户经理编号
    ,reg_acct_curr_cd -- 定期账户币种代码
    ,reg_acct_prod_id -- 定期账户产品编号
    ,reg_acct_sub_acct -- 定期账户子账号
    ,reg_acct_id -- 定期账户编号
    ,tran_day -- 划转日
    ,redt_begin_dt -- 转存起始日期
    ,redt_termnt_dt -- 转存终止日期
    ,auto_payoff_flg -- 自动结清标志
    ,core_dep_char_cd -- 核心存款性质代码
    ,fail_rs_descb -- 失败原因描述
    ,rels_dt -- 解约日期
    ,stl_sub_acct_acm_bal_dt -- 结算盈子户累计余额日期
    ,auto_scd_sign_flg -- 自动续签标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.dep_agt_id, o.dep_agt_id) as dep_agt_id -- 存款协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sign_agt_type_cd, o.sign_agt_type_cd) as sign_agt_type_cd -- 签约协议类型代码
    ,nvl(n.finc_prod_id, o.finc_prod_id) as finc_prod_id -- 理财产品编号
    ,nvl(n.finc_prod_type_descb, o.finc_prod_type_descb) as finc_prod_type_descb -- 理财产品类型描述
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.acct_curr_cd, o.acct_curr_cd) as acct_curr_cd -- 账户币种代码
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.finc_amt, o.finc_amt) as finc_amt -- 理财金额
    ,nvl(n.agt_retnd_amt, o.agt_retnd_amt) as agt_retnd_amt -- 协议留存金额
    ,nvl(n.auto_delay_flg, o.auto_delay_flg) as auto_delay_flg -- 自动延期标志
    ,nvl(n.sign_agt_status_cd, o.sign_agt_status_cd) as sign_agt_status_cd -- 签约协议状态代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.min_init_amt, o.min_init_amt) as min_init_amt -- 最小起存金额
    ,nvl(n.finc_fix_amt, o.finc_fix_amt) as finc_fix_amt -- 理财固定金额
    ,nvl(n.dep_tenor, o.dep_tenor) as dep_tenor -- 存款期限
    ,nvl(n.dep_tenor_type_cd, o.dep_tenor_type_cd) as dep_tenor_type_cd -- 存款期限类型代码
    ,nvl(n.auto_redt_way_type_cd, o.auto_redt_way_type_cd) as auto_redt_way_type_cd -- 自动转存方式类型代码
    ,nvl(n.conti_redt_fail_cnt, o.conti_redt_fail_cnt) as conti_redt_fail_cnt -- 连续转存失败次数
    ,nvl(n.conti_redt_sucs_cnt, o.conti_redt_sucs_cnt) as conti_redt_sucs_cnt -- 连续转存成功次数
    ,nvl(n.redt_fail_tot_cnt, o.redt_fail_tot_cnt) as redt_fail_tot_cnt -- 转存失败总次数
    ,nvl(n.redt_sucs_tot_cnt, o.redt_sucs_tot_cnt) as redt_sucs_tot_cnt -- 转存成功总次数
    ,nvl(n.last_redt_flow_id, o.last_redt_flow_id) as last_redt_flow_id -- 上一转存流水编号
    ,nvl(n.tran_freq, o.tran_freq) as tran_freq -- 划转频率
    ,nvl(n.tran_freq_cd, o.tran_freq_cd) as tran_freq_cd -- 划转频率代码
    ,nvl(n.last_tran_dt, o.last_tran_dt) as last_tran_dt -- 上次划转日期
    ,nvl(n.next_tran_dt, o.next_tran_dt) as next_tran_dt -- 下次划转日期
    ,nvl(n.sign_org_id, o.sign_org_id) as sign_org_id -- 签约机构编号
    ,nvl(n.sign_teller_id, o.sign_teller_id) as sign_teller_id -- 签约柜员编号
    ,nvl(n.sign_flow_id, o.sign_flow_id) as sign_flow_id -- 签约流水编号
    ,nvl(n.rels_org_id, o.rels_org_id) as rels_org_id -- 解约机构编号
    ,nvl(n.rels_teller_id, o.rels_teller_id) as rels_teller_id -- 解约柜员编号
    ,nvl(n.rels_flow_id, o.rels_flow_id) as rels_flow_id -- 解约流水编号
    ,nvl(n.a_try_redt_dt, o.a_try_redt_dt) as a_try_redt_dt -- 重新尝试转存日期
    ,nvl(n.lmt_ped, o.lmt_ped) as lmt_ped -- 限额周期
    ,nvl(n.max_lmt, o.max_lmt) as max_lmt -- 最大限额
    ,nvl(n.occu_lmt, o.occu_lmt) as occu_lmt -- 已占用额度
    ,nvl(n.next_calc_dt, o.next_calc_dt) as next_calc_dt -- 下一计算日期
    ,nvl(n.curr_mon_acm_end_day_bal, o.curr_mon_acm_end_day_bal) as curr_mon_acm_end_day_bal -- 当月累计日终余额
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.reg_acct_curr_cd, o.reg_acct_curr_cd) as reg_acct_curr_cd -- 定期账户币种代码
    ,nvl(n.reg_acct_prod_id, o.reg_acct_prod_id) as reg_acct_prod_id -- 定期账户产品编号
    ,nvl(n.reg_acct_sub_acct, o.reg_acct_sub_acct) as reg_acct_sub_acct -- 定期账户子账号
    ,nvl(n.reg_acct_id, o.reg_acct_id) as reg_acct_id -- 定期账户编号
    ,nvl(n.tran_day, o.tran_day) as tran_day -- 划转日
    ,nvl(n.redt_begin_dt, o.redt_begin_dt) as redt_begin_dt -- 转存起始日期
    ,nvl(n.redt_termnt_dt, o.redt_termnt_dt) as redt_termnt_dt -- 转存终止日期
    ,nvl(n.auto_payoff_flg, o.auto_payoff_flg) as auto_payoff_flg -- 自动结清标志
    ,nvl(n.core_dep_char_cd, o.core_dep_char_cd) as core_dep_char_cd -- 核心存款性质代码
    ,nvl(n.fail_rs_descb, o.fail_rs_descb) as fail_rs_descb -- 失败原因描述
    ,nvl(n.rels_dt, o.rels_dt) as rels_dt -- 解约日期
    ,nvl(n.stl_sub_acct_acm_bal_dt, o.stl_sub_acct_acm_bal_dt) as stl_sub_acct_acm_bal_dt -- 结算盈子户累计余额日期
    ,nvl(n.auto_scd_sign_flg, o.auto_scd_sign_flg) as auto_scd_sign_flg -- 自动续签标志
    ,case when
            n.agt_id is null
            and n.dep_agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.dep_agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.dep_agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.dep_agt_id = n.dep_agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.dep_agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.dep_agt_id is null
        and n.lp_id is null
    )
    or (
        o.sign_agt_type_cd <> n.sign_agt_type_cd
        or o.finc_prod_id <> n.finc_prod_id
        or o.finc_prod_type_descb <> n.finc_prod_type_descb
        or o.acct_id <> n.acct_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.prod_id <> n.prod_id
        or o.acct_curr_cd <> n.acct_curr_cd
        or o.sub_acct_num <> n.sub_acct_num
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.finc_amt <> n.finc_amt
        or o.agt_retnd_amt <> n.agt_retnd_amt
        or o.auto_delay_flg <> n.auto_delay_flg
        or o.sign_agt_status_cd <> n.sign_agt_status_cd
        or o.cust_id <> n.cust_id
        or o.final_modif_dt <> n.final_modif_dt
        or o.min_init_amt <> n.min_init_amt
        or o.finc_fix_amt <> n.finc_fix_amt
        or o.dep_tenor <> n.dep_tenor
        or o.dep_tenor_type_cd <> n.dep_tenor_type_cd
        or o.auto_redt_way_type_cd <> n.auto_redt_way_type_cd
        or o.conti_redt_fail_cnt <> n.conti_redt_fail_cnt
        or o.conti_redt_sucs_cnt <> n.conti_redt_sucs_cnt
        or o.redt_fail_tot_cnt <> n.redt_fail_tot_cnt
        or o.redt_sucs_tot_cnt <> n.redt_sucs_tot_cnt
        or o.last_redt_flow_id <> n.last_redt_flow_id
        or o.tran_freq <> n.tran_freq
        or o.tran_freq_cd <> n.tran_freq_cd
        or o.last_tran_dt <> n.last_tran_dt
        or o.next_tran_dt <> n.next_tran_dt
        or o.sign_org_id <> n.sign_org_id
        or o.sign_teller_id <> n.sign_teller_id
        or o.sign_flow_id <> n.sign_flow_id
        or o.rels_org_id <> n.rels_org_id
        or o.rels_teller_id <> n.rels_teller_id
        or o.rels_flow_id <> n.rels_flow_id
        or o.a_try_redt_dt <> n.a_try_redt_dt
        or o.lmt_ped <> n.lmt_ped
        or o.max_lmt <> n.max_lmt
        or o.occu_lmt <> n.occu_lmt
        or o.next_calc_dt <> n.next_calc_dt
        or o.curr_mon_acm_end_day_bal <> n.curr_mon_acm_end_day_bal
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.reg_acct_curr_cd <> n.reg_acct_curr_cd
        or o.reg_acct_prod_id <> n.reg_acct_prod_id
        or o.reg_acct_sub_acct <> n.reg_acct_sub_acct
        or o.reg_acct_id <> n.reg_acct_id
        or o.tran_day <> n.tran_day
        or o.redt_begin_dt <> n.redt_begin_dt
        or o.redt_termnt_dt <> n.redt_termnt_dt
        or o.auto_payoff_flg <> n.auto_payoff_flg
        or o.core_dep_char_cd <> n.core_dep_char_cd
        or o.fail_rs_descb <> n.fail_rs_descb
        or o.rels_dt <> n.rels_dt
        or o.stl_sub_acct_acm_bal_dt <> n.stl_sub_acct_acm_bal_dt
        or o.auto_scd_sign_flg <> n.auto_scd_sign_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,finc_prod_id -- 理财产品编号
    ,finc_prod_type_descb -- 理财产品类型描述
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,finc_amt -- 理财金额
    ,agt_retnd_amt -- 协议留存金额
    ,auto_delay_flg -- 自动延期标志
    ,sign_agt_status_cd -- 签约协议状态代码
    ,cust_id -- 客户编号
    ,final_modif_dt -- 最后修改日期
    ,min_init_amt -- 最小起存金额
    ,finc_fix_amt -- 理财固定金额
    ,dep_tenor -- 存款期限
    ,dep_tenor_type_cd -- 存款期限类型代码
    ,auto_redt_way_type_cd -- 自动转存方式类型代码
    ,conti_redt_fail_cnt -- 连续转存失败次数
    ,conti_redt_sucs_cnt -- 连续转存成功次数
    ,redt_fail_tot_cnt -- 转存失败总次数
    ,redt_sucs_tot_cnt -- 转存成功总次数
    ,last_redt_flow_id -- 上一转存流水编号
    ,tran_freq -- 划转频率
    ,tran_freq_cd -- 划转频率代码
    ,last_tran_dt -- 上次划转日期
    ,next_tran_dt -- 下次划转日期
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,sign_flow_id -- 签约流水编号
    ,rels_org_id -- 解约机构编号
    ,rels_teller_id -- 解约柜员编号
    ,rels_flow_id -- 解约流水编号
    ,a_try_redt_dt -- 重新尝试转存日期
    ,lmt_ped -- 限额周期
    ,max_lmt -- 最大限额
    ,occu_lmt -- 已占用额度
    ,next_calc_dt -- 下一计算日期
    ,curr_mon_acm_end_day_bal -- 当月累计日终余额
    ,cust_mgr_id -- 客户经理编号
    ,reg_acct_curr_cd -- 定期账户币种代码
    ,reg_acct_prod_id -- 定期账户产品编号
    ,reg_acct_sub_acct -- 定期账户子账号
    ,reg_acct_id -- 定期账户编号
    ,tran_day -- 划转日
    ,redt_begin_dt -- 转存起始日期
    ,redt_termnt_dt -- 转存终止日期
    ,auto_payoff_flg -- 自动结清标志
    ,core_dep_char_cd -- 核心存款性质代码
    ,fail_rs_descb -- 失败原因描述
    ,rels_dt -- 解约日期
    ,stl_sub_acct_acm_bal_dt -- 结算盈子户累计余额日期
    ,auto_scd_sign_flg -- 自动续签标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,finc_prod_id -- 理财产品编号
    ,finc_prod_type_descb -- 理财产品类型描述
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,finc_amt -- 理财金额
    ,agt_retnd_amt -- 协议留存金额
    ,auto_delay_flg -- 自动延期标志
    ,sign_agt_status_cd -- 签约协议状态代码
    ,cust_id -- 客户编号
    ,final_modif_dt -- 最后修改日期
    ,min_init_amt -- 最小起存金额
    ,finc_fix_amt -- 理财固定金额
    ,dep_tenor -- 存款期限
    ,dep_tenor_type_cd -- 存款期限类型代码
    ,auto_redt_way_type_cd -- 自动转存方式类型代码
    ,conti_redt_fail_cnt -- 连续转存失败次数
    ,conti_redt_sucs_cnt -- 连续转存成功次数
    ,redt_fail_tot_cnt -- 转存失败总次数
    ,redt_sucs_tot_cnt -- 转存成功总次数
    ,last_redt_flow_id -- 上一转存流水编号
    ,tran_freq -- 划转频率
    ,tran_freq_cd -- 划转频率代码
    ,last_tran_dt -- 上次划转日期
    ,next_tran_dt -- 下次划转日期
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,sign_flow_id -- 签约流水编号
    ,rels_org_id -- 解约机构编号
    ,rels_teller_id -- 解约柜员编号
    ,rels_flow_id -- 解约流水编号
    ,a_try_redt_dt -- 重新尝试转存日期
    ,lmt_ped -- 限额周期
    ,max_lmt -- 最大限额
    ,occu_lmt -- 已占用额度
    ,next_calc_dt -- 下一计算日期
    ,curr_mon_acm_end_day_bal -- 当月累计日终余额
    ,cust_mgr_id -- 客户经理编号
    ,reg_acct_curr_cd -- 定期账户币种代码
    ,reg_acct_prod_id -- 定期账户产品编号
    ,reg_acct_sub_acct -- 定期账户子账号
    ,reg_acct_id -- 定期账户编号
    ,tran_day -- 划转日
    ,redt_begin_dt -- 转存起始日期
    ,redt_termnt_dt -- 转存终止日期
    ,auto_payoff_flg -- 自动结清标志
    ,core_dep_char_cd -- 核心存款性质代码
    ,fail_rs_descb -- 失败原因描述
    ,rels_dt -- 解约日期
    ,stl_sub_acct_acm_bal_dt -- 结算盈子户累计余额日期
    ,auto_scd_sign_flg -- 自动续签标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.dep_agt_id -- 存款协议编号
    ,o.lp_id -- 法人编号
    ,o.sign_agt_type_cd -- 签约协议类型代码
    ,o.finc_prod_id -- 理财产品编号
    ,o.finc_prod_type_descb -- 理财产品类型描述
    ,o.acct_id -- 账户编号
    ,o.cust_acct_num -- 客户账号
    ,o.prod_id -- 产品编号
    ,o.acct_curr_cd -- 账户币种代码
    ,o.sub_acct_num -- 子账号
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.finc_amt -- 理财金额
    ,o.agt_retnd_amt -- 协议留存金额
    ,o.auto_delay_flg -- 自动延期标志
    ,o.sign_agt_status_cd -- 签约协议状态代码
    ,o.cust_id -- 客户编号
    ,o.final_modif_dt -- 最后修改日期
    ,o.min_init_amt -- 最小起存金额
    ,o.finc_fix_amt -- 理财固定金额
    ,o.dep_tenor -- 存款期限
    ,o.dep_tenor_type_cd -- 存款期限类型代码
    ,o.auto_redt_way_type_cd -- 自动转存方式类型代码
    ,o.conti_redt_fail_cnt -- 连续转存失败次数
    ,o.conti_redt_sucs_cnt -- 连续转存成功次数
    ,o.redt_fail_tot_cnt -- 转存失败总次数
    ,o.redt_sucs_tot_cnt -- 转存成功总次数
    ,o.last_redt_flow_id -- 上一转存流水编号
    ,o.tran_freq -- 划转频率
    ,o.tran_freq_cd -- 划转频率代码
    ,o.last_tran_dt -- 上次划转日期
    ,o.next_tran_dt -- 下次划转日期
    ,o.sign_org_id -- 签约机构编号
    ,o.sign_teller_id -- 签约柜员编号
    ,o.sign_flow_id -- 签约流水编号
    ,o.rels_org_id -- 解约机构编号
    ,o.rels_teller_id -- 解约柜员编号
    ,o.rels_flow_id -- 解约流水编号
    ,o.a_try_redt_dt -- 重新尝试转存日期
    ,o.lmt_ped -- 限额周期
    ,o.max_lmt -- 最大限额
    ,o.occu_lmt -- 已占用额度
    ,o.next_calc_dt -- 下一计算日期
    ,o.curr_mon_acm_end_day_bal -- 当月累计日终余额
    ,o.cust_mgr_id -- 客户经理编号
    ,o.reg_acct_curr_cd -- 定期账户币种代码
    ,o.reg_acct_prod_id -- 定期账户产品编号
    ,o.reg_acct_sub_acct -- 定期账户子账号
    ,o.reg_acct_id -- 定期账户编号
    ,o.tran_day -- 划转日
    ,o.redt_begin_dt -- 转存起始日期
    ,o.redt_termnt_dt -- 转存终止日期
    ,o.auto_payoff_flg -- 自动结清标志
    ,o.core_dep_char_cd -- 核心存款性质代码
    ,o.fail_rs_descb -- 失败原因描述
    ,o.rels_dt -- 解约日期
    ,o.stl_sub_acct_acm_bal_dt -- 结算盈子户累计余额日期
    ,o.auto_scd_sign_flg -- 自动续签标志
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
from ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_bk o
    left join ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.dep_agt_id = n.dep_agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.dep_agt_id = d.dep_agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_finc_sign_agt_h;
--alter table ${iml_schema}.agt_finc_sign_agt_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_finc_sign_agt_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_finc_sign_agt_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_finc_sign_agt_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_finc_sign_agt_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_cl;
alter table ${iml_schema}.agt_finc_sign_agt_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_finc_sign_agt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_finc_sign_agt_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_finc_sign_agt_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
