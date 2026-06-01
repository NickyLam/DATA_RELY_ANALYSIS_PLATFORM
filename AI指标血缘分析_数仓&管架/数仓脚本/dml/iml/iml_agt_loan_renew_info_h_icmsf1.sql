/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_renew_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_renew_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_renew_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_renew_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_renew_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_renew_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_renew_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_renew_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,renew_flow_num -- 展期流水号
    ,precon_id -- 预约编号
    ,rela_dubil_id -- 关联借据编号
    ,out_acct_flow_num -- 出账流水号
    ,renew_status_cd -- 展期状态代码
    ,happ_dt -- 发生日期
    ,init_int_rat -- 原利率
    ,init_exp_dt -- 原到期日期
    ,renew_amt -- 展期金额
    ,b_renew_amt -- 展期前金额
    ,renew_year_tenor -- 展期年期限
    ,renew_mon_tenor -- 展期月期限
    ,renew_day_tenor -- 展期日期限
    ,a_renew_int_rat -- 展期后利率
    ,a_renew_exp_dt -- 展期后到期日期
    ,entr_pay_dt -- 受托支付日期
    ,org_id -- 机构编号
    ,oper_teller_id -- 操作柜员编号
    ,update_flg -- 更新标志
    ,remark -- 备注
    ,renew_cont_id -- 展期合同编号
    ,a_renew_repay_plan_effect_dt -- 展期后还款计划生效日期
    ,a_renew_int_rat_effect_dt -- 展期后利率的生效日期
    ,renew_effect_dt -- 展期生效日期
    ,new_repay_way_cd -- 新还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,base_rat -- 基准利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_reval_way_cd -- 利率重定价方式代码
    ,OVDUE_LOAN_INT_RAT_FLOAT_RATIO -- 逾期贷款利率浮动比例
    ,ovdue_loan_exec_int_rat -- 逾期贷款执行利率
    ,next_int_set_dt -- 下一结息日期
    ,mortg_repay_day -- 按揭还款日
    ,late_merge_flg -- 末期合并标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_renew_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_renew_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_renew_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_renew_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_renew_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_business_extension-1
insert into ${iml_schema}.agt_loan_renew_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,renew_flow_num -- 展期流水号
    ,precon_id -- 预约编号
    ,rela_dubil_id -- 关联借据编号
    ,out_acct_flow_num -- 出账流水号
    ,renew_status_cd -- 展期状态代码
    ,happ_dt -- 发生日期
    ,init_int_rat -- 原利率
    ,init_exp_dt -- 原到期日期
    ,renew_amt -- 展期金额
    ,b_renew_amt -- 展期前金额
    ,renew_year_tenor -- 展期年期限
    ,renew_mon_tenor -- 展期月期限
    ,renew_day_tenor -- 展期日期限
    ,a_renew_int_rat -- 展期后利率
    ,a_renew_exp_dt -- 展期后到期日期
    ,entr_pay_dt -- 受托支付日期
    ,org_id -- 机构编号
    ,oper_teller_id -- 操作柜员编号
    ,update_flg -- 更新标志
    ,remark -- 备注
    ,renew_cont_id -- 展期合同编号
    ,a_renew_repay_plan_effect_dt -- 展期后还款计划生效日期
    ,a_renew_int_rat_effect_dt -- 展期后利率的生效日期
    ,renew_effect_dt -- 展期生效日期
    ,new_repay_way_cd -- 新还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,base_rat -- 基准利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_reval_way_cd -- 利率重定价方式代码
    ,OVDUE_LOAN_INT_RAT_FLOAT_RATIO -- 逾期贷款利率浮动比例
    ,ovdue_loan_exec_int_rat -- 逾期贷款执行利率
    ,next_int_set_dt -- 下一结息日期
    ,mortg_repay_day -- 按揭还款日
    ,late_merge_flg -- 末期合并标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300004'||P1.SERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 展期流水号
    ,P1.ORDERNO -- 预约编号
    ,P1.RELATIVEDUEBILLNO -- 关联借据编号
    ,P1.PUTOUTNO -- 出账流水号
    ,nvl(trim(P1.TRANSACTIONFLAG),'-') -- 展期状态代码
    ,P1.OCCURDATE -- 发生日期
    ,P1.LASTRATE -- 原利率
    ,P1.LASTMATURITY -- 原到期日期
    ,P1.EXTENSIONSUM -- 展期金额
    ,P1.LASTSUM -- 展期前金额
    ,P1.EXTENDTERMYEAR -- 展期年期限
    ,P1.EXTENDTERMMONTH -- 展期月期限
    ,P1.EXTENDTERMDAY -- 展期日期限
    ,P1.EXTENDRATE -- 展期后利率
    ,P1.EXTENDMATURITY -- 展期后到期日期
    ,decode(P1.EXTENDPUTOUTDATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.EXTENDPUTOUTDATE) -- 受托支付日期
    ,P1.ORGID -- 机构编号
    ,P1.USERID -- 操作柜员编号
    ,P1.EXTENDFLAG -- 更新标志
    ,P1.REMARK -- 备注
    ,P1.CONTRACTNO -- 展期合同编号
    ,P1.EXTENDREPAYPLANEFFECTDATE -- 展期后还款计划生效日期
    ,P1.EXTENDRATEEFFECTDATE -- 展期后利率的生效日期
    ,P1.EXTENDEFFECTDATE -- 展期生效日期
    ,nvl(trim(P1.NEWREPAYTYPE),'-') -- 新还款方式代码
    ,nvl(trim(P1.REPAYCYCLE),'-') -- 还款周期代码
    ,P1.BASERATE -- 基准利率
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,nvl(trim(P1.RATEADJUSTFREQUENCY),'-') -- 利率调整周期代码
    ,nvl(trim(P1.RATEGENRE),'-') -- 利率重定价方式代码
    ,P1.OVERDUEFLOAT -- 逾期贷款利率浮动比例
    ,P1.OVERDUERATE -- 逾期贷款执行利率
    ,${iml_schema}.dateformat_max2(P1.NEXTSETTLEMENTDATE) -- 下一结息日期
    ,${iml_schema}.dateformat_max2(P1.REPAYDATE) -- 按揭还款日
    ,nvl(trim(P1.FINALMERGER),'-') -- 末期合并标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_business_extension' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_business_extension p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_renew_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
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
        into ${iml_schema}.agt_loan_renew_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,renew_flow_num -- 展期流水号
    ,precon_id -- 预约编号
    ,rela_dubil_id -- 关联借据编号
    ,out_acct_flow_num -- 出账流水号
    ,renew_status_cd -- 展期状态代码
    ,happ_dt -- 发生日期
    ,init_int_rat -- 原利率
    ,init_exp_dt -- 原到期日期
    ,renew_amt -- 展期金额
    ,b_renew_amt -- 展期前金额
    ,renew_year_tenor -- 展期年期限
    ,renew_mon_tenor -- 展期月期限
    ,renew_day_tenor -- 展期日期限
    ,a_renew_int_rat -- 展期后利率
    ,a_renew_exp_dt -- 展期后到期日期
    ,entr_pay_dt -- 受托支付日期
    ,org_id -- 机构编号
    ,oper_teller_id -- 操作柜员编号
    ,update_flg -- 更新标志
    ,remark -- 备注
    ,renew_cont_id -- 展期合同编号
    ,a_renew_repay_plan_effect_dt -- 展期后还款计划生效日期
    ,a_renew_int_rat_effect_dt -- 展期后利率的生效日期
    ,renew_effect_dt -- 展期生效日期
    ,new_repay_way_cd -- 新还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,base_rat -- 基准利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_reval_way_cd -- 利率重定价方式代码
    ,OVDUE_LOAN_INT_RAT_FLOAT_RATIO -- 逾期贷款利率浮动比例
    ,ovdue_loan_exec_int_rat -- 逾期贷款执行利率
    ,next_int_set_dt -- 下一结息日期
    ,mortg_repay_day -- 按揭还款日
    ,late_merge_flg -- 末期合并标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_renew_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,renew_flow_num -- 展期流水号
    ,precon_id -- 预约编号
    ,rela_dubil_id -- 关联借据编号
    ,out_acct_flow_num -- 出账流水号
    ,renew_status_cd -- 展期状态代码
    ,happ_dt -- 发生日期
    ,init_int_rat -- 原利率
    ,init_exp_dt -- 原到期日期
    ,renew_amt -- 展期金额
    ,b_renew_amt -- 展期前金额
    ,renew_year_tenor -- 展期年期限
    ,renew_mon_tenor -- 展期月期限
    ,renew_day_tenor -- 展期日期限
    ,a_renew_int_rat -- 展期后利率
    ,a_renew_exp_dt -- 展期后到期日期
    ,entr_pay_dt -- 受托支付日期
    ,org_id -- 机构编号
    ,oper_teller_id -- 操作柜员编号
    ,update_flg -- 更新标志
    ,remark -- 备注
    ,renew_cont_id -- 展期合同编号
    ,a_renew_repay_plan_effect_dt -- 展期后还款计划生效日期
    ,a_renew_int_rat_effect_dt -- 展期后利率的生效日期
    ,renew_effect_dt -- 展期生效日期
    ,new_repay_way_cd -- 新还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,base_rat -- 基准利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_reval_way_cd -- 利率重定价方式代码
    ,OVDUE_LOAN_INT_RAT_FLOAT_RATIO -- 逾期贷款利率浮动比例
    ,ovdue_loan_exec_int_rat -- 逾期贷款执行利率
    ,next_int_set_dt -- 下一结息日期
    ,mortg_repay_day -- 按揭还款日
    ,late_merge_flg -- 末期合并标志
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
    ,nvl(n.renew_flow_num, o.renew_flow_num) as renew_flow_num -- 展期流水号
    ,nvl(n.precon_id, o.precon_id) as precon_id -- 预约编号
    ,nvl(n.rela_dubil_id, o.rela_dubil_id) as rela_dubil_id -- 关联借据编号
    ,nvl(n.out_acct_flow_num, o.out_acct_flow_num) as out_acct_flow_num -- 出账流水号
    ,nvl(n.renew_status_cd, o.renew_status_cd) as renew_status_cd -- 展期状态代码
    ,nvl(n.happ_dt, o.happ_dt) as happ_dt -- 发生日期
    ,nvl(n.init_int_rat, o.init_int_rat) as init_int_rat -- 原利率
    ,nvl(n.init_exp_dt, o.init_exp_dt) as init_exp_dt -- 原到期日期
    ,nvl(n.renew_amt, o.renew_amt) as renew_amt -- 展期金额
    ,nvl(n.b_renew_amt, o.b_renew_amt) as b_renew_amt -- 展期前金额
    ,nvl(n.renew_year_tenor, o.renew_year_tenor) as renew_year_tenor -- 展期年期限
    ,nvl(n.renew_mon_tenor, o.renew_mon_tenor) as renew_mon_tenor -- 展期月期限
    ,nvl(n.renew_day_tenor, o.renew_day_tenor) as renew_day_tenor -- 展期日期限
    ,nvl(n.a_renew_int_rat, o.a_renew_int_rat) as a_renew_int_rat -- 展期后利率
    ,nvl(n.a_renew_exp_dt, o.a_renew_exp_dt) as a_renew_exp_dt -- 展期后到期日期
    ,nvl(n.entr_pay_dt, o.entr_pay_dt) as entr_pay_dt -- 受托支付日期
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 操作柜员编号
    ,nvl(n.update_flg, o.update_flg) as update_flg -- 更新标志
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.renew_cont_id, o.renew_cont_id) as renew_cont_id -- 展期合同编号
    ,nvl(n.a_renew_repay_plan_effect_dt, o.a_renew_repay_plan_effect_dt) as a_renew_repay_plan_effect_dt -- 展期后还款计划生效日期
    ,nvl(n.a_renew_int_rat_effect_dt, o.a_renew_int_rat_effect_dt) as a_renew_int_rat_effect_dt -- 展期后利率的生效日期
    ,nvl(n.renew_effect_dt, o.renew_effect_dt) as renew_effect_dt -- 展期生效日期
    ,nvl(n.new_repay_way_cd, o.new_repay_way_cd) as new_repay_way_cd -- 新还款方式代码
    ,nvl(n.repay_ped_cd, o.repay_ped_cd) as repay_ped_cd -- 还款周期代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_adj_ped_cd, o.int_rat_adj_ped_cd) as int_rat_adj_ped_cd -- 利率调整周期代码
    ,nvl(n.int_rat_reval_way_cd, o.int_rat_reval_way_cd) as int_rat_reval_way_cd -- 利率重定价方式代码
    ,nvl(n.OVDUE_LOAN_INT_RAT_FLOAT_RATIO, o.OVDUE_LOAN_INT_RAT_FLOAT_RATIO) as OVDUE_LOAN_INT_RAT_FLOAT_RATIO -- 逾期贷款利率浮动比例
    ,nvl(n.ovdue_loan_exec_int_rat, o.ovdue_loan_exec_int_rat) as ovdue_loan_exec_int_rat -- 逾期贷款执行利率
    ,nvl(n.next_int_set_dt, o.next_int_set_dt) as next_int_set_dt -- 下一结息日期
    ,nvl(n.mortg_repay_day, o.mortg_repay_day) as mortg_repay_day -- 按揭还款日
    ,nvl(n.late_merge_flg, o.late_merge_flg) as late_merge_flg -- 末期合并标志
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_renew_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_renew_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.renew_flow_num <> n.renew_flow_num
        or o.precon_id <> n.precon_id
        or o.rela_dubil_id <> n.rela_dubil_id
        or o.out_acct_flow_num <> n.out_acct_flow_num
        or o.renew_status_cd <> n.renew_status_cd
        or o.happ_dt <> n.happ_dt
        or o.init_int_rat <> n.init_int_rat
        or o.init_exp_dt <> n.init_exp_dt
        or o.renew_amt <> n.renew_amt
        or o.b_renew_amt <> n.b_renew_amt
        or o.renew_year_tenor <> n.renew_year_tenor
        or o.renew_mon_tenor <> n.renew_mon_tenor
        or o.renew_day_tenor <> n.renew_day_tenor
        or o.a_renew_int_rat <> n.a_renew_int_rat
        or o.a_renew_exp_dt <> n.a_renew_exp_dt
        or o.entr_pay_dt <> n.entr_pay_dt
        or o.org_id <> n.org_id
        or o.oper_teller_id <> n.oper_teller_id
        or o.update_flg <> n.update_flg
        or o.remark <> n.remark
        or o.renew_cont_id <> n.renew_cont_id
        or o.a_renew_repay_plan_effect_dt <> n.a_renew_repay_plan_effect_dt
        or o.a_renew_int_rat_effect_dt <> n.a_renew_int_rat_effect_dt
        or o.renew_effect_dt <> n.renew_effect_dt
        or o.new_repay_way_cd <> n.new_repay_way_cd
        or o.repay_ped_cd <> n.repay_ped_cd
        or o.base_rat <> n.base_rat
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.int_rat_adj_ped_cd <> n.int_rat_adj_ped_cd
        or o.int_rat_reval_way_cd <> n.int_rat_reval_way_cd
        or o.OVDUE_LOAN_INT_RAT_FLOAT_RATIO <> n.OVDUE_LOAN_INT_RAT_FLOAT_RATIO
        or o.ovdue_loan_exec_int_rat <> n.ovdue_loan_exec_int_rat
        or o.next_int_set_dt <> n.next_int_set_dt
        or o.mortg_repay_day <> n.mortg_repay_day
        or o.late_merge_flg <> n.late_merge_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_renew_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,renew_flow_num -- 展期流水号
    ,precon_id -- 预约编号
    ,rela_dubil_id -- 关联借据编号
    ,out_acct_flow_num -- 出账流水号
    ,renew_status_cd -- 展期状态代码
    ,happ_dt -- 发生日期
    ,init_int_rat -- 原利率
    ,init_exp_dt -- 原到期日期
    ,renew_amt -- 展期金额
    ,b_renew_amt -- 展期前金额
    ,renew_year_tenor -- 展期年期限
    ,renew_mon_tenor -- 展期月期限
    ,renew_day_tenor -- 展期日期限
    ,a_renew_int_rat -- 展期后利率
    ,a_renew_exp_dt -- 展期后到期日期
    ,entr_pay_dt -- 受托支付日期
    ,org_id -- 机构编号
    ,oper_teller_id -- 操作柜员编号
    ,update_flg -- 更新标志
    ,remark -- 备注
    ,renew_cont_id -- 展期合同编号
    ,a_renew_repay_plan_effect_dt -- 展期后还款计划生效日期
    ,a_renew_int_rat_effect_dt -- 展期后利率的生效日期
    ,renew_effect_dt -- 展期生效日期
    ,new_repay_way_cd -- 新还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,base_rat -- 基准利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_reval_way_cd -- 利率重定价方式代码
    ,OVDUE_LOAN_INT_RAT_FLOAT_RATIO -- 逾期贷款利率浮动比例
    ,ovdue_loan_exec_int_rat -- 逾期贷款执行利率
    ,next_int_set_dt -- 下一结息日期
    ,mortg_repay_day -- 按揭还款日
    ,late_merge_flg -- 末期合并标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_renew_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,renew_flow_num -- 展期流水号
    ,precon_id -- 预约编号
    ,rela_dubil_id -- 关联借据编号
    ,out_acct_flow_num -- 出账流水号
    ,renew_status_cd -- 展期状态代码
    ,happ_dt -- 发生日期
    ,init_int_rat -- 原利率
    ,init_exp_dt -- 原到期日期
    ,renew_amt -- 展期金额
    ,b_renew_amt -- 展期前金额
    ,renew_year_tenor -- 展期年期限
    ,renew_mon_tenor -- 展期月期限
    ,renew_day_tenor -- 展期日期限
    ,a_renew_int_rat -- 展期后利率
    ,a_renew_exp_dt -- 展期后到期日期
    ,entr_pay_dt -- 受托支付日期
    ,org_id -- 机构编号
    ,oper_teller_id -- 操作柜员编号
    ,update_flg -- 更新标志
    ,remark -- 备注
    ,renew_cont_id -- 展期合同编号
    ,a_renew_repay_plan_effect_dt -- 展期后还款计划生效日期
    ,a_renew_int_rat_effect_dt -- 展期后利率的生效日期
    ,renew_effect_dt -- 展期生效日期
    ,new_repay_way_cd -- 新还款方式代码
    ,repay_ped_cd -- 还款周期代码
    ,base_rat -- 基准利率
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_reval_way_cd -- 利率重定价方式代码
    ,OVDUE_LOAN_INT_RAT_FLOAT_RATIO -- 逾期贷款利率浮动比例
    ,ovdue_loan_exec_int_rat -- 逾期贷款执行利率
    ,next_int_set_dt -- 下一结息日期
    ,mortg_repay_day -- 按揭还款日
    ,late_merge_flg -- 末期合并标志
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
    ,o.renew_flow_num -- 展期流水号
    ,o.precon_id -- 预约编号
    ,o.rela_dubil_id -- 关联借据编号
    ,o.out_acct_flow_num -- 出账流水号
    ,o.renew_status_cd -- 展期状态代码
    ,o.happ_dt -- 发生日期
    ,o.init_int_rat -- 原利率
    ,o.init_exp_dt -- 原到期日期
    ,o.renew_amt -- 展期金额
    ,o.b_renew_amt -- 展期前金额
    ,o.renew_year_tenor -- 展期年期限
    ,o.renew_mon_tenor -- 展期月期限
    ,o.renew_day_tenor -- 展期日期限
    ,o.a_renew_int_rat -- 展期后利率
    ,o.a_renew_exp_dt -- 展期后到期日期
    ,o.entr_pay_dt -- 受托支付日期
    ,o.org_id -- 机构编号
    ,o.oper_teller_id -- 操作柜员编号
    ,o.update_flg -- 更新标志
    ,o.remark -- 备注
    ,o.renew_cont_id -- 展期合同编号
    ,o.a_renew_repay_plan_effect_dt -- 展期后还款计划生效日期
    ,o.a_renew_int_rat_effect_dt -- 展期后利率的生效日期
    ,o.renew_effect_dt -- 展期生效日期
    ,o.new_repay_way_cd -- 新还款方式代码
    ,o.repay_ped_cd -- 还款周期代码
    ,o.base_rat -- 基准利率
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.int_rat_adj_ped_cd -- 利率调整周期代码
    ,o.int_rat_reval_way_cd -- 利率重定价方式代码
    ,o.OVDUE_LOAN_INT_RAT_FLOAT_RATIO -- 逾期贷款利率浮动比例
    ,o.ovdue_loan_exec_int_rat -- 逾期贷款执行利率
    ,o.next_int_set_dt -- 下一结息日期
    ,o.mortg_repay_day -- 按揭还款日
    ,o.late_merge_flg -- 末期合并标志
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
from ${iml_schema}.agt_loan_renew_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_renew_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_renew_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_renew_info_h;
--alter table ${iml_schema}.agt_loan_renew_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_renew_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_renew_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_renew_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_renew_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_renew_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_renew_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_renew_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_renew_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_renew_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_renew_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_renew_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_renew_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_renew_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
