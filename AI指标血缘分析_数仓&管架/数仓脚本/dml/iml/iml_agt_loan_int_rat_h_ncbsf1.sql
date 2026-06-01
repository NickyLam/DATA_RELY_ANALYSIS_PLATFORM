/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_int_rat_h_ncbsf1
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
alter table ${iml_schema}.agt_loan_int_rat_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_int_rat_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_set_freq_cd -- 结息频率代码
    ,next_int_set_dt -- 下一结息日期
    ,int_set_day -- 结息日
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,float_int_rat_point -- 浮动利率点数
    ,float_int_rat_ratio -- 浮动利率比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,exec_int_rat -- 执行利率
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,next_int_rat_modif_dt -- 下一利率变更日期
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,int_rat_modif_day -- 利率变更日
    ,int_accr_begin_dt -- 计息起始日期
    ,int_accr_exp_dt -- 计息到期日期
    ,lowt_exec_int_rat -- 最低执行利率
    ,higt_exec_int_rat -- 最高执行利率
    ,cap_flg -- 资本化标志
    ,pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_int_rat_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_int_rat_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_int_rat_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_loan_int_default-1
insert into ${iml_schema}.agt_loan_int_rat_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_set_freq_cd -- 结息频率代码
    ,next_int_set_dt -- 下一结息日期
    ,int_set_day -- 结息日
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,float_int_rat_point -- 浮动利率点数
    ,float_int_rat_ratio -- 浮动利率比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,exec_int_rat -- 执行利率
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,next_int_rat_modif_dt -- 下一利率变更日期
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,int_rat_modif_day -- 利率变更日
    ,int_accr_begin_dt -- 计息起始日期
    ,int_accr_exp_dt -- 计息到期日期
    ,lowt_exec_int_rat -- 最低执行利率
    ,higt_exec_int_rat -- 最高执行利率
    ,cap_flg -- 资本化标志
    ,pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300001'||P1.LOAN_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.LOAN_NO -- 贷款号
    ,P1.INT_CLASS -- 利息分类代码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.CYCLE_FREQ -- 结息频率代码
    ,P1.NEXT_CYCLE_DATE -- 下一结息日期
    ,NVL(TRIM(P1.INT_DAY),0) -- 结息日
    ,P1.INT_TYPE -- 利率类型代码
    ,P1.ACTUAL_RATE -- 行内利率
    ,P1.FLOAT_RATE -- 浮动利率
    ,P1.SPREAD_RATE -- 浮动利率点数
    ,P1.SPREAD_PERCENT -- 浮动利率比例
    ,P1.ACCT_FIXED_RATE -- 分户级固定利率
    ,P1.ACCT_SPREAD_RATE -- 分户级利率浮动点数
    ,P1.ACCT_PERCENT_RATE -- 分户级利率浮动比例
    ,P1.REAL_RATE -- 执行利率
    ,P1.YEAR_BASIS -- 年计息基准代码
    ,P1.MONTH_BASIS -- 月计息基准代码
    ,case when MONTH_BASIS='ACT' and YEAR_BASIS='360'  then 'A/360'
     when MONTH_BASIS='D30' and YEAR_BASIS='360'  then '30/360'
     when MONTH_BASIS='ACT' and YEAR_BASIS='365'  then 'A/365'
     when MONTH_BASIS='D30' and YEAR_BASIS='365'  then '30/365'
     when MONTH_BASIS='ACT' and YEAR_BASIS='366'  then  'A/366'
     else '-'  end -- 计息基准代码
    ,decode(trim(p1.INT_IND_FLAG),'','-','Y','1','N','0',p1.INT_IND_FLAG) -- 计息标志
    ,P1.INT_APPL_TYPE -- 利率启用方式代码
    ,P1.RATE_EFFECT_TYPE -- 利率生效方式代码
    ,decode(P1.NEXT_ROLL_DATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.NEXT_ROLL_DATE) -- 下一利率变更日期
    ,P1.ROLL_FREQ -- 利率变更周期代码
    ,NVL(TRIM(P1.ROLL_DAY),0) -- 利率变更日
    ,P1.CALC_BEGIN_DATE -- 计息起始日期
    ,P1.CALC_END_DATE -- 计息到期日期
    ,P1.MIN_INT_RATE -- 最低执行利率
    ,P1.MAX_INT_RATE -- 最高执行利率
    ,DECODE(P1.INT_CAP_FLAG,'Y','1','N','0') -- 资本化标志
    ,nvl(trim(P1.PENALTY_ODI_RATE_TYPE),'-') -- 罚息利率使用方式代码
    ,DECODE(P1.CALC_BY_INT,'Y','1','N','0') -- 按正常利率浮动标志
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_loan_int_default' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_loan_int_default p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_int_rat_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,loan_num
  	                                        ,int_cls_cd
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
        into ${iml_schema}.agt_loan_int_rat_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_set_freq_cd -- 结息频率代码
    ,next_int_set_dt -- 下一结息日期
    ,int_set_day -- 结息日
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,float_int_rat_point -- 浮动利率点数
    ,float_int_rat_ratio -- 浮动利率比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,exec_int_rat -- 执行利率
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,next_int_rat_modif_dt -- 下一利率变更日期
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,int_rat_modif_day -- 利率变更日
    ,int_accr_begin_dt -- 计息起始日期
    ,int_accr_exp_dt -- 计息到期日期
    ,lowt_exec_int_rat -- 最低执行利率
    ,higt_exec_int_rat -- 最高执行利率
    ,cap_flg -- 资本化标志
    ,pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_int_rat_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_set_freq_cd -- 结息频率代码
    ,next_int_set_dt -- 下一结息日期
    ,int_set_day -- 结息日
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,float_int_rat_point -- 浮动利率点数
    ,float_int_rat_ratio -- 浮动利率比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,exec_int_rat -- 执行利率
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,next_int_rat_modif_dt -- 下一利率变更日期
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,int_rat_modif_day -- 利率变更日
    ,int_accr_begin_dt -- 计息起始日期
    ,int_accr_exp_dt -- 计息到期日期
    ,lowt_exec_int_rat -- 最低执行利率
    ,higt_exec_int_rat -- 最高执行利率
    ,cap_flg -- 资本化标志
    ,pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.loan_num, o.loan_num) as loan_num -- 贷款号
    ,nvl(n.int_cls_cd, o.int_cls_cd) as int_cls_cd -- 利息分类代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.int_set_freq_cd, o.int_set_freq_cd) as int_set_freq_cd -- 结息频率代码
    ,nvl(n.next_int_set_dt, o.next_int_set_dt) as next_int_set_dt -- 下一结息日期
    ,nvl(n.int_set_day, o.int_set_day) as int_set_day -- 结息日
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.bank_int_int_rat, o.bank_int_int_rat) as bank_int_int_rat -- 行内利率
    ,nvl(n.float_int_rat, o.float_int_rat) as float_int_rat -- 浮动利率
    ,nvl(n.float_int_rat_point, o.float_int_rat_point) as float_int_rat_point -- 浮动利率点数
    ,nvl(n.float_int_rat_ratio, o.float_int_rat_ratio) as float_int_rat_ratio -- 浮动利率比例
    ,nvl(n.sub_acct_fix_int_rat, o.sub_acct_fix_int_rat) as sub_acct_fix_int_rat -- 分户级固定利率
    ,nvl(n.sub_acct_int_rat_float_point, o.sub_acct_int_rat_float_point) as sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,nvl(n.sub_acct_int_rat_float_ratio, o.sub_acct_int_rat_float_ratio) as sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.year_int_accr_base_cd, o.year_int_accr_base_cd) as year_int_accr_base_cd -- 年计息基准代码
    ,nvl(n.mon_int_accr_base_cd, o.mon_int_accr_base_cd) as mon_int_accr_base_cd -- 月计息基准代码
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.int_accr_flg, o.int_accr_flg) as int_accr_flg -- 计息标志
    ,nvl(n.int_rat_start_use_way_cd, o.int_rat_start_use_way_cd) as int_rat_start_use_way_cd -- 利率启用方式代码
    ,nvl(n.int_rat_effect_way_cd, o.int_rat_effect_way_cd) as int_rat_effect_way_cd -- 利率生效方式代码
    ,nvl(n.next_int_rat_modif_dt, o.next_int_rat_modif_dt) as next_int_rat_modif_dt -- 下一利率变更日期
    ,nvl(n.int_rat_modif_ped_cd, o.int_rat_modif_ped_cd) as int_rat_modif_ped_cd -- 利率变更周期代码
    ,nvl(n.int_rat_modif_day, o.int_rat_modif_day) as int_rat_modif_day -- 利率变更日
    ,nvl(n.int_accr_begin_dt, o.int_accr_begin_dt) as int_accr_begin_dt -- 计息起始日期
    ,nvl(n.int_accr_exp_dt, o.int_accr_exp_dt) as int_accr_exp_dt -- 计息到期日期
    ,nvl(n.lowt_exec_int_rat, o.lowt_exec_int_rat) as lowt_exec_int_rat -- 最低执行利率
    ,nvl(n.higt_exec_int_rat, o.higt_exec_int_rat) as higt_exec_int_rat -- 最高执行利率
    ,nvl(n.cap_flg, o.cap_flg) as cap_flg -- 资本化标志
    ,nvl(n.pnlt_int_rat_use_way_cd, o.pnlt_int_rat_use_way_cd) as pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,nvl(n.accrd_nomal_int_rat_float_flg, o.accrd_nomal_int_rat_float_flg) as accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.loan_num is null
            and n.int_cls_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.loan_num is null
            and n.int_cls_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.loan_num is null
            and n.int_cls_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_int_rat_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_int_rat_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.loan_num = n.loan_num
            and o.int_cls_cd = n.int_cls_cd
where (
        o.agt_id is null
        and o.lp_id is null
        and o.loan_num is null
        and o.int_cls_cd is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.loan_num is null
        and n.int_cls_cd is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.int_set_freq_cd <> n.int_set_freq_cd
        or o.next_int_set_dt <> n.next_int_set_dt
        or o.int_set_day <> n.int_set_day
        or o.int_rat_type_cd <> n.int_rat_type_cd
        or o.bank_int_int_rat <> n.bank_int_int_rat
        or o.float_int_rat <> n.float_int_rat
        or o.float_int_rat_point <> n.float_int_rat_point
        or o.float_int_rat_ratio <> n.float_int_rat_ratio
        or o.sub_acct_fix_int_rat <> n.sub_acct_fix_int_rat
        or o.sub_acct_int_rat_float_point <> n.sub_acct_int_rat_float_point
        or o.sub_acct_int_rat_float_ratio <> n.sub_acct_int_rat_float_ratio
        or o.exec_int_rat <> n.exec_int_rat
        or o.year_int_accr_base_cd <> n.year_int_accr_base_cd
        or o.mon_int_accr_base_cd <> n.mon_int_accr_base_cd
        or o.int_accr_base_cd <> n.int_accr_base_cd
        or o.int_accr_flg <> n.int_accr_flg
        or o.int_rat_start_use_way_cd <> n.int_rat_start_use_way_cd
        or o.int_rat_effect_way_cd <> n.int_rat_effect_way_cd
        or o.next_int_rat_modif_dt <> n.next_int_rat_modif_dt
        or o.int_rat_modif_ped_cd <> n.int_rat_modif_ped_cd
        or o.int_rat_modif_day <> n.int_rat_modif_day
        or o.int_accr_begin_dt <> n.int_accr_begin_dt
        or o.int_accr_exp_dt <> n.int_accr_exp_dt
        or o.lowt_exec_int_rat <> n.lowt_exec_int_rat
        or o.higt_exec_int_rat <> n.higt_exec_int_rat
        or o.cap_flg <> n.cap_flg
        or o.pnlt_int_rat_use_way_cd <> n.pnlt_int_rat_use_way_cd
        or o.accrd_nomal_int_rat_float_flg <> n.accrd_nomal_int_rat_float_flg
        or o.final_modif_teller_id <> n.final_modif_teller_id
        or o.final_modif_dt <> n.final_modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_int_rat_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_set_freq_cd -- 结息频率代码
    ,next_int_set_dt -- 下一结息日期
    ,int_set_day -- 结息日
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,float_int_rat_point -- 浮动利率点数
    ,float_int_rat_ratio -- 浮动利率比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,exec_int_rat -- 执行利率
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,next_int_rat_modif_dt -- 下一利率变更日期
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,int_rat_modif_day -- 利率变更日
    ,int_accr_begin_dt -- 计息起始日期
    ,int_accr_exp_dt -- 计息到期日期
    ,lowt_exec_int_rat -- 最低执行利率
    ,higt_exec_int_rat -- 最高执行利率
    ,cap_flg -- 资本化标志
    ,pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_int_rat_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,int_cls_cd -- 利息分类代码
    ,cust_id -- 客户编号
    ,int_set_freq_cd -- 结息频率代码
    ,next_int_set_dt -- 下一结息日期
    ,int_set_day -- 结息日
    ,int_rat_type_cd -- 利率类型代码
    ,bank_int_int_rat -- 行内利率
    ,float_int_rat -- 浮动利率
    ,float_int_rat_point -- 浮动利率点数
    ,float_int_rat_ratio -- 浮动利率比例
    ,sub_acct_fix_int_rat -- 分户级固定利率
    ,sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,exec_int_rat -- 执行利率
    ,year_int_accr_base_cd -- 年计息基准代码
    ,mon_int_accr_base_cd -- 月计息基准代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_accr_flg -- 计息标志
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_effect_way_cd -- 利率生效方式代码
    ,next_int_rat_modif_dt -- 下一利率变更日期
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,int_rat_modif_day -- 利率变更日
    ,int_accr_begin_dt -- 计息起始日期
    ,int_accr_exp_dt -- 计息到期日期
    ,lowt_exec_int_rat -- 最低执行利率
    ,higt_exec_int_rat -- 最高执行利率
    ,cap_flg -- 资本化标志
    ,pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.loan_num -- 贷款号
    ,o.int_cls_cd -- 利息分类代码
    ,o.cust_id -- 客户编号
    ,o.int_set_freq_cd -- 结息频率代码
    ,o.next_int_set_dt -- 下一结息日期
    ,o.int_set_day -- 结息日
    ,o.int_rat_type_cd -- 利率类型代码
    ,o.bank_int_int_rat -- 行内利率
    ,o.float_int_rat -- 浮动利率
    ,o.float_int_rat_point -- 浮动利率点数
    ,o.float_int_rat_ratio -- 浮动利率比例
    ,o.sub_acct_fix_int_rat -- 分户级固定利率
    ,o.sub_acct_int_rat_float_point -- 分户级利率浮动点数
    ,o.sub_acct_int_rat_float_ratio -- 分户级利率浮动比例
    ,o.exec_int_rat -- 执行利率
    ,o.year_int_accr_base_cd -- 年计息基准代码
    ,o.mon_int_accr_base_cd -- 月计息基准代码
    ,o.int_accr_base_cd -- 计息基准代码
    ,o.int_accr_flg -- 计息标志
    ,o.int_rat_start_use_way_cd -- 利率启用方式代码
    ,o.int_rat_effect_way_cd -- 利率生效方式代码
    ,o.next_int_rat_modif_dt -- 下一利率变更日期
    ,o.int_rat_modif_ped_cd -- 利率变更周期代码
    ,o.int_rat_modif_day -- 利率变更日
    ,o.int_accr_begin_dt -- 计息起始日期
    ,o.int_accr_exp_dt -- 计息到期日期
    ,o.lowt_exec_int_rat -- 最低执行利率
    ,o.higt_exec_int_rat -- 最高执行利率
    ,o.cap_flg -- 资本化标志
    ,o.pnlt_int_rat_use_way_cd -- 罚息利率使用方式代码
    ,o.accrd_nomal_int_rat_float_flg -- 按正常利率浮动标志
    ,o.final_modif_teller_id -- 最后修改柜员编号
    ,o.final_modif_dt -- 最后修改日期
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
from ${iml_schema}.agt_loan_int_rat_h_ncbsf1_bk o
    left join ${iml_schema}.agt_loan_int_rat_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.loan_num = n.loan_num
            and o.int_cls_cd = n.int_cls_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_int_rat_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.loan_num = d.loan_num
            and o.int_cls_cd = d.int_cls_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_int_rat_h;
--alter table ${iml_schema}.agt_loan_int_rat_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_int_rat_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_int_rat_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_int_rat_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_int_rat_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_cl;
alter table ${iml_schema}.agt_loan_int_rat_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_int_rat_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_int_rat_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_int_rat_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
