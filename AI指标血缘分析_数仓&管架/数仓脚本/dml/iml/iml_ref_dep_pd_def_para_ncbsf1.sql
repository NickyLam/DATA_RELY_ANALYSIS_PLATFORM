/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_dep_pd_def_para_ncbsf1
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
alter table ${iml_schema}.ref_dep_pd_def_para add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_dep_pd_def_para partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    pd_cd -- 期次编号
    ,lp_id -- 法人编号
    ,pd_descb -- 期次描述
    ,cds_issue_year -- 大额存单发行年度
    ,cds_issue_begin_dt -- 大额存单发行起始日期
    ,issue_termnt_dt -- 发行终止日期
    ,precon_start_tm -- 预约开始时间
    ,precon_end_tm -- 预约结束时间
    ,start_sell_tm -- 开起销售时间
    ,end_sell_tm -- 停止销售时间
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,lmt_deduct_type_cd -- 额度扣减类型代码
    ,pd_dtl_remark -- 期次详细备注
    ,pd_status_cd -- 期次状态代码
    ,sell_way_cd -- 销售方式代码
    ,assign_lmt_type_cd -- 配额类型代码
    ,tot_lmt_lmt -- 总限制额度
    ,cds_surp_lmt -- 大额存单剩余额度
    ,asigned_lmt -- 已分配额度
    ,cds_occu_lmt -- 大额存单已占用额度
    ,lmt_callbk_status_cd -- 额度回收状态代码
    ,ration_way_cd -- 配售方式代码
    ,tran_acct_flg -- 转账标志
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,int_rat_reset_freq_cd -- 利率重置频率代码
    ,max_buy_amt -- 最大购买金额
    ,init_amt -- 起存金额
    ,get_int_freq_cd -- 取息频率代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,cds_pay_int_way -- 大额存单付息方式代码
    ,allow_unexp_draw_flg -- 允许提前支取标志
    ,pa_ext_cnt -- 部提次数
    ,redembl_flg -- 可赎回标志
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auto_payoff_flg -- 自动结清标志
    ,white_list_sale_flg -- 白名单发售标志
    ,supt_buy_way_cd -- 支持购买方式代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_dep_pd_def_para partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_dep_pd_def_para partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_dep_pd_def_para partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_dc_stage_define-1
insert into ${iml_schema}.ref_dep_pd_def_para_ncbsf1_tm(
    pd_cd -- 期次编号
    ,lp_id -- 法人编号
    ,pd_descb -- 期次描述
    ,cds_issue_year -- 大额存单发行年度
    ,cds_issue_begin_dt -- 大额存单发行起始日期
    ,issue_termnt_dt -- 发行终止日期
    ,precon_start_tm -- 预约开始时间
    ,precon_end_tm -- 预约结束时间
    ,start_sell_tm -- 开起销售时间
    ,end_sell_tm -- 停止销售时间
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,lmt_deduct_type_cd -- 额度扣减类型代码
    ,pd_dtl_remark -- 期次详细备注
    ,pd_status_cd -- 期次状态代码
    ,sell_way_cd -- 销售方式代码
    ,assign_lmt_type_cd -- 配额类型代码
    ,tot_lmt_lmt -- 总限制额度
    ,cds_surp_lmt -- 大额存单剩余额度
    ,asigned_lmt -- 已分配额度
    ,cds_occu_lmt -- 大额存单已占用额度
    ,lmt_callbk_status_cd -- 额度回收状态代码
    ,ration_way_cd -- 配售方式代码
    ,tran_acct_flg -- 转账标志
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,int_rat_reset_freq_cd -- 利率重置频率代码
    ,max_buy_amt -- 最大购买金额
    ,init_amt -- 起存金额
    ,get_int_freq_cd -- 取息频率代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,cds_pay_int_way -- 大额存单付息方式代码
    ,allow_unexp_draw_flg -- 允许提前支取标志
    ,pa_ext_cnt -- 部提次数
    ,redembl_flg -- 可赎回标志
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auto_payoff_flg -- 自动结清标志
    ,white_list_sale_flg -- 白名单发售标志
    ,supt_buy_way_cd -- 支持购买方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.STAGE_CODE -- 期次编号
    ,'9999' -- 法人编号
    ,P1.STAGE_CODE_DESC -- 期次描述
    ,P1.ISSUE_YEAR -- 大额存单发行年度
    ,P1.ISSUE_START_DATE -- 大额存单发行起始日期
    ,P1.ISSUE_END_DATE -- 发行终止日期
    ,${iml_schema}.timeformat_min(P1.PRECONTRACT_START_TIME) -- 预约开始时间
    ,${iml_schema}.timeformat_max2(P1.PRECONTRACT_END_TIME) -- 预约结束时间
    ,${iml_schema}.timeformat_min(P1.SALE_START_TIME) -- 开起销售时间
    ,${iml_schema}.timeformat_max2(P1.SALE_END_TIME) -- 停止销售时间
    ,P1.STAGE_PROD_CLASS -- 期次产品类别代码
    ,nvl(trim(P1.STAGE_LIMIT_CLASS),'-') -- 额度扣减类型代码
    ,P1.STAGE_REMARK -- 期次详细备注
    ,nvl(trim(P1.STAGE_STATUS),'-') -- 期次状态代码
    ,nvl(trim(P1.SALE_TYPE),'-') -- 销售方式代码
    ,nvl(trim(P1.OPERATE_METHOD),'-') -- 配额类型代码
    ,P1.TOTAL_LIMIT -- 总限制额度
    ,P1.LEAVE_LIMIT -- 大额存单剩余额度
    ,P1.DISTRIBUTE_LIMIT -- 已分配额度
    ,P1.HOLDING_LIMIT -- 大额存单已占用额度
    ,nvl(trim(P1.BACK_STATUS),'-') -- 额度回收状态代码
    ,nvl(trim(P1.RATION_TYPE),'-') -- 配售方式代码
    ,decode(trim(p1.TRANSFER_FLAG),'','-','Y','1','N','0',p1.TRANSFER_FLAG) -- 转账标志
    ,P1.PROD_TYPE -- 产品编号
    ,P1.CCY -- 币种代码
    ,NVL(TRIM(P1.TERM),0) -- 存款期限
    ,P1.TERM_TYPE -- 期限类型代码
    ,nvl(trim(P1.RESET_INT_FREQ),'-') -- 利率重置频率代码
    ,P1.STAGE_MAX_AMT -- 最大购买金额
    ,P1.STAGE_MIN_AMT -- 起存金额
    ,nvl(trim(P1.GET_INT_FREQ),'-') -- 取息频率代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.INT_CALC_TYPE END -- 利率调整方式代码
    ,nvl(trim(P1.PAY_INT_TYPE),'-') -- 大额存单付息方式代码
    ,DECODE(P1.PRE_WITHDRAW_FLAG,'Y','1','N','0') -- 允许提前支取标志
    ,P1.PART_WITHDRAW_NUM -- 部提次数
    ,decode(trim(p1.REDEMPTION_FLAG),'','-','Y','1','N','0',p1.REDEMPTION_FLAG) -- 可赎回标志
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,decode(trim(p1.AUTO_SETTLE_FLAG),'','-','Y','1','N','0',p1.AUTO_SETTLE_FLAG) -- 自动结清标志
    ,decode(trim(p1.WHITE_SELL_FLAG),'','-','Y','1','N','0',p1.WHITE_SELL_FLAG) -- 白名单发售标志
    ,NVL(trim(P1.ALLOW_BUY_WAY_CD),'-') -- 支持购买方式代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_dc_stage_define' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_dc_stage_define p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.INT_CALC_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_RB_DC_STAGE_DEFINE'
        AND R1.SRC_FIELD_EN_NAME= 'INT_CALC_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'REF_DEP_PD_DEF_PARA'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_dep_pd_def_para_ncbsf1_tm 
  	                                group by 
  	                                        pd_cd
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
        into ${iml_schema}.ref_dep_pd_def_para_ncbsf1_cl(
            pd_cd -- 期次编号
    ,lp_id -- 法人编号
    ,pd_descb -- 期次描述
    ,cds_issue_year -- 大额存单发行年度
    ,cds_issue_begin_dt -- 大额存单发行起始日期
    ,issue_termnt_dt -- 发行终止日期
    ,precon_start_tm -- 预约开始时间
    ,precon_end_tm -- 预约结束时间
    ,start_sell_tm -- 开起销售时间
    ,end_sell_tm -- 停止销售时间
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,lmt_deduct_type_cd -- 额度扣减类型代码
    ,pd_dtl_remark -- 期次详细备注
    ,pd_status_cd -- 期次状态代码
    ,sell_way_cd -- 销售方式代码
    ,assign_lmt_type_cd -- 配额类型代码
    ,tot_lmt_lmt -- 总限制额度
    ,cds_surp_lmt -- 大额存单剩余额度
    ,asigned_lmt -- 已分配额度
    ,cds_occu_lmt -- 大额存单已占用额度
    ,lmt_callbk_status_cd -- 额度回收状态代码
    ,ration_way_cd -- 配售方式代码
    ,tran_acct_flg -- 转账标志
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,int_rat_reset_freq_cd -- 利率重置频率代码
    ,max_buy_amt -- 最大购买金额
    ,init_amt -- 起存金额
    ,get_int_freq_cd -- 取息频率代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,cds_pay_int_way -- 大额存单付息方式代码
    ,allow_unexp_draw_flg -- 允许提前支取标志
    ,pa_ext_cnt -- 部提次数
    ,redembl_flg -- 可赎回标志
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auto_payoff_flg -- 自动结清标志
    ,white_list_sale_flg -- 白名单发售标志
    ,supt_buy_way_cd -- 支持购买方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_dep_pd_def_para_ncbsf1_op(
            pd_cd -- 期次编号
    ,lp_id -- 法人编号
    ,pd_descb -- 期次描述
    ,cds_issue_year -- 大额存单发行年度
    ,cds_issue_begin_dt -- 大额存单发行起始日期
    ,issue_termnt_dt -- 发行终止日期
    ,precon_start_tm -- 预约开始时间
    ,precon_end_tm -- 预约结束时间
    ,start_sell_tm -- 开起销售时间
    ,end_sell_tm -- 停止销售时间
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,lmt_deduct_type_cd -- 额度扣减类型代码
    ,pd_dtl_remark -- 期次详细备注
    ,pd_status_cd -- 期次状态代码
    ,sell_way_cd -- 销售方式代码
    ,assign_lmt_type_cd -- 配额类型代码
    ,tot_lmt_lmt -- 总限制额度
    ,cds_surp_lmt -- 大额存单剩余额度
    ,asigned_lmt -- 已分配额度
    ,cds_occu_lmt -- 大额存单已占用额度
    ,lmt_callbk_status_cd -- 额度回收状态代码
    ,ration_way_cd -- 配售方式代码
    ,tran_acct_flg -- 转账标志
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,int_rat_reset_freq_cd -- 利率重置频率代码
    ,max_buy_amt -- 最大购买金额
    ,init_amt -- 起存金额
    ,get_int_freq_cd -- 取息频率代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,cds_pay_int_way -- 大额存单付息方式代码
    ,allow_unexp_draw_flg -- 允许提前支取标志
    ,pa_ext_cnt -- 部提次数
    ,redembl_flg -- 可赎回标志
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auto_payoff_flg -- 自动结清标志
    ,white_list_sale_flg -- 白名单发售标志
    ,supt_buy_way_cd -- 支持购买方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pd_cd, o.pd_cd) as pd_cd -- 期次编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.pd_descb, o.pd_descb) as pd_descb -- 期次描述
    ,nvl(n.cds_issue_year, o.cds_issue_year) as cds_issue_year -- 大额存单发行年度
    ,nvl(n.cds_issue_begin_dt, o.cds_issue_begin_dt) as cds_issue_begin_dt -- 大额存单发行起始日期
    ,nvl(n.issue_termnt_dt, o.issue_termnt_dt) as issue_termnt_dt -- 发行终止日期
    ,nvl(n.precon_start_tm, o.precon_start_tm) as precon_start_tm -- 预约开始时间
    ,nvl(n.precon_end_tm, o.precon_end_tm) as precon_end_tm -- 预约结束时间
    ,nvl(n.start_sell_tm, o.start_sell_tm) as start_sell_tm -- 开起销售时间
    ,nvl(n.end_sell_tm, o.end_sell_tm) as end_sell_tm -- 停止销售时间
    ,nvl(n.pd_prod_cate_cd, o.pd_prod_cate_cd) as pd_prod_cate_cd -- 期次产品类别代码
    ,nvl(n.lmt_deduct_type_cd, o.lmt_deduct_type_cd) as lmt_deduct_type_cd -- 额度扣减类型代码
    ,nvl(n.pd_dtl_remark, o.pd_dtl_remark) as pd_dtl_remark -- 期次详细备注
    ,nvl(n.pd_status_cd, o.pd_status_cd) as pd_status_cd -- 期次状态代码
    ,nvl(n.sell_way_cd, o.sell_way_cd) as sell_way_cd -- 销售方式代码
    ,nvl(n.assign_lmt_type_cd, o.assign_lmt_type_cd) as assign_lmt_type_cd -- 配额类型代码
    ,nvl(n.tot_lmt_lmt, o.tot_lmt_lmt) as tot_lmt_lmt -- 总限制额度
    ,nvl(n.cds_surp_lmt, o.cds_surp_lmt) as cds_surp_lmt -- 大额存单剩余额度
    ,nvl(n.asigned_lmt, o.asigned_lmt) as asigned_lmt -- 已分配额度
    ,nvl(n.cds_occu_lmt, o.cds_occu_lmt) as cds_occu_lmt -- 大额存单已占用额度
    ,nvl(n.lmt_callbk_status_cd, o.lmt_callbk_status_cd) as lmt_callbk_status_cd -- 额度回收状态代码
    ,nvl(n.ration_way_cd, o.ration_way_cd) as ration_way_cd -- 配售方式代码
    ,nvl(n.tran_acct_flg, o.tran_acct_flg) as tran_acct_flg -- 转账标志
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.dep_tenor, o.dep_tenor) as dep_tenor -- 存款期限
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.int_rat_reset_freq_cd, o.int_rat_reset_freq_cd) as int_rat_reset_freq_cd -- 利率重置频率代码
    ,nvl(n.max_buy_amt, o.max_buy_amt) as max_buy_amt -- 最大购买金额
    ,nvl(n.init_amt, o.init_amt) as init_amt -- 起存金额
    ,nvl(n.get_int_freq_cd, o.get_int_freq_cd) as get_int_freq_cd -- 取息频率代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.cds_pay_int_way, o.cds_pay_int_way) as cds_pay_int_way -- 大额存单付息方式代码
    ,nvl(n.allow_unexp_draw_flg, o.allow_unexp_draw_flg) as allow_unexp_draw_flg -- 允许提前支取标志
    ,nvl(n.pa_ext_cnt, o.pa_ext_cnt) as pa_ext_cnt -- 部提次数
    ,nvl(n.redembl_flg, o.redembl_flg) as redembl_flg -- 可赎回标志
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.auto_payoff_flg, o.auto_payoff_flg) as auto_payoff_flg -- 自动结清标志
    ,nvl(n.white_list_sale_flg, o.white_list_sale_flg) as white_list_sale_flg -- 白名单发售标志
    ,nvl(n.supt_buy_way_cd, o.supt_buy_way_cd) as supt_buy_way_cd -- 支持购买方式代码
    ,case when
            n.pd_cd is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pd_cd is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pd_cd is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_dep_pd_def_para_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_dep_pd_def_para_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.pd_cd = n.pd_cd
            and o.lp_id = n.lp_id
where (
        o.pd_cd is null
        and o.lp_id is null
    )
    or (
        n.pd_cd is null
        and n.lp_id is null
    )
    or (
        o.pd_descb <> n.pd_descb
        or o.cds_issue_year <> n.cds_issue_year
        or o.cds_issue_begin_dt <> n.cds_issue_begin_dt
        or o.issue_termnt_dt <> n.issue_termnt_dt
        or o.precon_start_tm <> n.precon_start_tm
        or o.precon_end_tm <> n.precon_end_tm
        or o.start_sell_tm <> n.start_sell_tm
        or o.end_sell_tm <> n.end_sell_tm
        or o.pd_prod_cate_cd <> n.pd_prod_cate_cd
        or o.lmt_deduct_type_cd <> n.lmt_deduct_type_cd
        or o.pd_dtl_remark <> n.pd_dtl_remark
        or o.pd_status_cd <> n.pd_status_cd
        or o.sell_way_cd <> n.sell_way_cd
        or o.assign_lmt_type_cd <> n.assign_lmt_type_cd
        or o.tot_lmt_lmt <> n.tot_lmt_lmt
        or o.cds_surp_lmt <> n.cds_surp_lmt
        or o.asigned_lmt <> n.asigned_lmt
        or o.cds_occu_lmt <> n.cds_occu_lmt
        or o.lmt_callbk_status_cd <> n.lmt_callbk_status_cd
        or o.ration_way_cd <> n.ration_way_cd
        or o.tran_acct_flg <> n.tran_acct_flg
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.dep_tenor <> n.dep_tenor
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.int_rat_reset_freq_cd <> n.int_rat_reset_freq_cd
        or o.max_buy_amt <> n.max_buy_amt
        or o.init_amt <> n.init_amt
        or o.get_int_freq_cd <> n.get_int_freq_cd
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.cds_pay_int_way <> n.cds_pay_int_way
        or o.allow_unexp_draw_flg <> n.allow_unexp_draw_flg
        or o.pa_ext_cnt <> n.pa_ext_cnt
        or o.redembl_flg <> n.redembl_flg
        or o.tran_dt <> n.tran_dt
        or o.tran_org_id <> n.tran_org_id
        or o.tran_teller_id <> n.tran_teller_id
        or o.auto_payoff_flg <> n.auto_payoff_flg
        or o.white_list_sale_flg <> n.white_list_sale_flg
        or o.supt_buy_way_cd <> n.supt_buy_way_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_dep_pd_def_para_ncbsf1_cl(
            pd_cd -- 期次编号
    ,lp_id -- 法人编号
    ,pd_descb -- 期次描述
    ,cds_issue_year -- 大额存单发行年度
    ,cds_issue_begin_dt -- 大额存单发行起始日期
    ,issue_termnt_dt -- 发行终止日期
    ,precon_start_tm -- 预约开始时间
    ,precon_end_tm -- 预约结束时间
    ,start_sell_tm -- 开起销售时间
    ,end_sell_tm -- 停止销售时间
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,lmt_deduct_type_cd -- 额度扣减类型代码
    ,pd_dtl_remark -- 期次详细备注
    ,pd_status_cd -- 期次状态代码
    ,sell_way_cd -- 销售方式代码
    ,assign_lmt_type_cd -- 配额类型代码
    ,tot_lmt_lmt -- 总限制额度
    ,cds_surp_lmt -- 大额存单剩余额度
    ,asigned_lmt -- 已分配额度
    ,cds_occu_lmt -- 大额存单已占用额度
    ,lmt_callbk_status_cd -- 额度回收状态代码
    ,ration_way_cd -- 配售方式代码
    ,tran_acct_flg -- 转账标志
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,int_rat_reset_freq_cd -- 利率重置频率代码
    ,max_buy_amt -- 最大购买金额
    ,init_amt -- 起存金额
    ,get_int_freq_cd -- 取息频率代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,cds_pay_int_way -- 大额存单付息方式代码
    ,allow_unexp_draw_flg -- 允许提前支取标志
    ,pa_ext_cnt -- 部提次数
    ,redembl_flg -- 可赎回标志
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auto_payoff_flg -- 自动结清标志
    ,white_list_sale_flg -- 白名单发售标志
    ,supt_buy_way_cd -- 支持购买方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_dep_pd_def_para_ncbsf1_op(
            pd_cd -- 期次编号
    ,lp_id -- 法人编号
    ,pd_descb -- 期次描述
    ,cds_issue_year -- 大额存单发行年度
    ,cds_issue_begin_dt -- 大额存单发行起始日期
    ,issue_termnt_dt -- 发行终止日期
    ,precon_start_tm -- 预约开始时间
    ,precon_end_tm -- 预约结束时间
    ,start_sell_tm -- 开起销售时间
    ,end_sell_tm -- 停止销售时间
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,lmt_deduct_type_cd -- 额度扣减类型代码
    ,pd_dtl_remark -- 期次详细备注
    ,pd_status_cd -- 期次状态代码
    ,sell_way_cd -- 销售方式代码
    ,assign_lmt_type_cd -- 配额类型代码
    ,tot_lmt_lmt -- 总限制额度
    ,cds_surp_lmt -- 大额存单剩余额度
    ,asigned_lmt -- 已分配额度
    ,cds_occu_lmt -- 大额存单已占用额度
    ,lmt_callbk_status_cd -- 额度回收状态代码
    ,ration_way_cd -- 配售方式代码
    ,tran_acct_flg -- 转账标志
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,dep_tenor -- 存款期限
    ,tenor_type_cd -- 期限类型代码
    ,int_rat_reset_freq_cd -- 利率重置频率代码
    ,max_buy_amt -- 最大购买金额
    ,init_amt -- 起存金额
    ,get_int_freq_cd -- 取息频率代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,cds_pay_int_way -- 大额存单付息方式代码
    ,allow_unexp_draw_flg -- 允许提前支取标志
    ,pa_ext_cnt -- 部提次数
    ,redembl_flg -- 可赎回标志
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,auto_payoff_flg -- 自动结清标志
    ,white_list_sale_flg -- 白名单发售标志
    ,supt_buy_way_cd -- 支持购买方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pd_cd -- 期次编号
    ,o.lp_id -- 法人编号
    ,o.pd_descb -- 期次描述
    ,o.cds_issue_year -- 大额存单发行年度
    ,o.cds_issue_begin_dt -- 大额存单发行起始日期
    ,o.issue_termnt_dt -- 发行终止日期
    ,o.precon_start_tm -- 预约开始时间
    ,o.precon_end_tm -- 预约结束时间
    ,o.start_sell_tm -- 开起销售时间
    ,o.end_sell_tm -- 停止销售时间
    ,o.pd_prod_cate_cd -- 期次产品类别代码
    ,o.lmt_deduct_type_cd -- 额度扣减类型代码
    ,o.pd_dtl_remark -- 期次详细备注
    ,o.pd_status_cd -- 期次状态代码
    ,o.sell_way_cd -- 销售方式代码
    ,o.assign_lmt_type_cd -- 配额类型代码
    ,o.tot_lmt_lmt -- 总限制额度
    ,o.cds_surp_lmt -- 大额存单剩余额度
    ,o.asigned_lmt -- 已分配额度
    ,o.cds_occu_lmt -- 大额存单已占用额度
    ,o.lmt_callbk_status_cd -- 额度回收状态代码
    ,o.ration_way_cd -- 配售方式代码
    ,o.tran_acct_flg -- 转账标志
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.dep_tenor -- 存款期限
    ,o.tenor_type_cd -- 期限类型代码
    ,o.int_rat_reset_freq_cd -- 利率重置频率代码
    ,o.max_buy_amt -- 最大购买金额
    ,o.init_amt -- 起存金额
    ,o.get_int_freq_cd -- 取息频率代码
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.cds_pay_int_way -- 大额存单付息方式代码
    ,o.allow_unexp_draw_flg -- 允许提前支取标志
    ,o.pa_ext_cnt -- 部提次数
    ,o.redembl_flg -- 可赎回标志
    ,o.tran_dt -- 交易日期
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.auto_payoff_flg -- 自动结清标志
    ,o.white_list_sale_flg -- 白名单发售标志
    ,o.supt_buy_way_cd -- 支持购买方式代码
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
from ${iml_schema}.ref_dep_pd_def_para_ncbsf1_bk o
    left join ${iml_schema}.ref_dep_pd_def_para_ncbsf1_op n
        on
            o.pd_cd = n.pd_cd
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_dep_pd_def_para_ncbsf1_cl d
        on
            o.pd_cd = d.pd_cd
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_dep_pd_def_para;
--alter table ${iml_schema}.ref_dep_pd_def_para truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_dep_pd_def_para') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_dep_pd_def_para drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ref_dep_pd_def_para modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_dep_pd_def_para exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_cl;
alter table ${iml_schema}.ref_dep_pd_def_para exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_dep_pd_def_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_dep_pd_def_para_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_dep_pd_def_para', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
