/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cds_transf_appl_h_ncbsf1
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
alter table ${iml_schema}.agt_cds_transf_appl_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_transf_appl_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 协议编号
    ,lp_id -- 法人编号
    ,transf_id -- 转让编号
    ,tran_ref_no -- 交易参考号
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,core_teller_id -- 核心柜员编号
    ,lmt_id -- 限制编号
    ,pd_cd -- 期次编号
    ,tran_tm -- 交易时间
    ,dep_days -- 存款天数
    ,int_accr_surp_days -- 计息剩余天数
    ,transf_tot_cosdetn -- 转让总对价
    ,transf_exp_dt -- 转让到期日期
    ,dir_transf_flg -- 定向转让标志
    ,order_begin_dt -- 挂单起始日期
    ,tran_in_fee -- 转入费用
    ,order_end_dt -- 挂单结束日期
    ,transf_pric -- 转让本金
    ,transf_int_rat -- 转让利率
    ,cds_transf_type_cd -- 大额存单转让类型代码
    ,transf_status_cd -- 转让状态代码
    ,benefc_cust_id -- 受益人客户编号
    ,transf_dt -- 转让日期
    ,asign_yld_rat -- 受让人收益率
    ,tran_out_fee -- 转出费用
    ,final_modif_dt -- 最后修改日期
    ,tran_in_cust_acct_num -- 转入客户账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_cust_acct_num -- 结算客户账号
    ,tran_dt -- 交易日期
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cds_transf_appl_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_transf_appl_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_transf_appl_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_dc_change_apply_info-1
insert into ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_tm(
    evt_id -- 协议编号
    ,lp_id -- 法人编号
    ,transf_id -- 转让编号
    ,tran_ref_no -- 交易参考号
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,core_teller_id -- 核心柜员编号
    ,lmt_id -- 限制编号
    ,pd_cd -- 期次编号
    ,tran_tm -- 交易时间
    ,dep_days -- 存款天数
    ,int_accr_surp_days -- 计息剩余天数
    ,transf_tot_cosdetn -- 转让总对价
    ,transf_exp_dt -- 转让到期日期
    ,dir_transf_flg -- 定向转让标志
    ,order_begin_dt -- 挂单起始日期
    ,tran_in_fee -- 转入费用
    ,order_end_dt -- 挂单结束日期
    ,transf_pric -- 转让本金
    ,transf_int_rat -- 转让利率
    ,cds_transf_type_cd -- 大额存单转让类型代码
    ,transf_status_cd -- 转让状态代码
    ,benefc_cust_id -- 受益人客户编号
    ,transf_dt -- 转让日期
    ,asign_yld_rat -- 受让人收益率
    ,tran_out_fee -- 转出费用
    ,final_modif_dt -- 最后修改日期
    ,tran_in_cust_acct_num -- 转入客户账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_cust_acct_num -- 结算客户账号
    ,tran_dt -- 交易日期
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101063'||P1.TRF_NO||P1.TRAN_DATE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.TRF_NO -- 转让编号
    ,P1.REFERENCE -- 交易参考号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.CLIENT_NO -- 客户编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.USER_ID -- 核心柜员编号
    ,P1.RES_SEQ_NO -- 限制编号
    ,P1.STAGE_CODE -- 期次编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.DEP_KEEP_DAYS -- 存款天数
    ,P1.INT_REM_DAYS -- 计息剩余天数
    ,P1.TRF_TOTAL_SETTLE_AMT -- 转让总对价
    ,P1.TRF_END_DATE -- 转让到期日期
    ,DECODE(TRIM(P1.DIRECTION_TRF_FLAG),'','-','Y','1','N','0',P1.DIRECTION_TRF_FLAG) -- 定向转让标志
    ,P1.ORDER_START_DATE -- 挂单起始日期
    ,P1.TRF_IN_FEE_AMT -- 转入费用
    ,P1.ORDER_END_DATE -- 挂单结束日期
    ,P1.TRF_PRI_AMT -- 转让本金
    ,P1.TRF_RATE -- 转让利率
    ,nvl(trim(P1.TRF_TYPE),'-') -- 大额存单转让类型代码
    ,P1.TRF_STATUS -- 转让状态代码
    ,P1.BENEFICIARY_CLIENT_NO -- 受益人客户编号
    ,P1.TRF_DATE -- 转让日期
    ,P1.BENEFICIARY_PROFIT_RATE -- 受让人收益率
    ,P1.TRF_OUT_FEE_AMT -- 转出费用
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,nvl(trim(p9.card_no),p1.INNER_BASE_ACCT_NO) -- 转入客户账号
    ,P1.SETTLE_ACCT_SEQ_NO -- 结算账户子账号
    ,nvl(trim(p10.card_no),p1.SETTLE_BASE_ACCT_NO) -- 结算客户账号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.PROD_TYPE -- 产品编号
    ,iml.dateformat_min(P1.REC_TIME) -- 申请日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_dc_change_apply_info' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_dc_change_apply_info p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p9 on p1.INNER_BASE_ACCT_NO=p9.BASE_ACCT_NO and p9.BASE_ACCT_NO LIKE '0%' 
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p10 on p1.SETTLE_BASE_ACCT_NO=p10.BASE_ACCT_NO and p10.BASE_ACCT_NO LIKE '0%'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                                        ,transf_id
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
        into ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_cl(
            evt_id -- 协议编号
    ,lp_id -- 法人编号
    ,transf_id -- 转让编号
    ,tran_ref_no -- 交易参考号
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,core_teller_id -- 核心柜员编号
    ,lmt_id -- 限制编号
    ,pd_cd -- 期次编号
    ,tran_tm -- 交易时间
    ,dep_days -- 存款天数
    ,int_accr_surp_days -- 计息剩余天数
    ,transf_tot_cosdetn -- 转让总对价
    ,transf_exp_dt -- 转让到期日期
    ,dir_transf_flg -- 定向转让标志
    ,order_begin_dt -- 挂单起始日期
    ,tran_in_fee -- 转入费用
    ,order_end_dt -- 挂单结束日期
    ,transf_pric -- 转让本金
    ,transf_int_rat -- 转让利率
    ,cds_transf_type_cd -- 大额存单转让类型代码
    ,transf_status_cd -- 转让状态代码
    ,benefc_cust_id -- 受益人客户编号
    ,transf_dt -- 转让日期
    ,asign_yld_rat -- 受让人收益率
    ,tran_out_fee -- 转出费用
    ,final_modif_dt -- 最后修改日期
    ,tran_in_cust_acct_num -- 转入客户账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_cust_acct_num -- 结算客户账号
    ,tran_dt -- 交易日期
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_op(
            evt_id -- 协议编号
    ,lp_id -- 法人编号
    ,transf_id -- 转让编号
    ,tran_ref_no -- 交易参考号
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,core_teller_id -- 核心柜员编号
    ,lmt_id -- 限制编号
    ,pd_cd -- 期次编号
    ,tran_tm -- 交易时间
    ,dep_days -- 存款天数
    ,int_accr_surp_days -- 计息剩余天数
    ,transf_tot_cosdetn -- 转让总对价
    ,transf_exp_dt -- 转让到期日期
    ,dir_transf_flg -- 定向转让标志
    ,order_begin_dt -- 挂单起始日期
    ,tran_in_fee -- 转入费用
    ,order_end_dt -- 挂单结束日期
    ,transf_pric -- 转让本金
    ,transf_int_rat -- 转让利率
    ,cds_transf_type_cd -- 大额存单转让类型代码
    ,transf_status_cd -- 转让状态代码
    ,benefc_cust_id -- 受益人客户编号
    ,transf_dt -- 转让日期
    ,asign_yld_rat -- 受让人收益率
    ,tran_out_fee -- 转出费用
    ,final_modif_dt -- 最后修改日期
    ,tran_in_cust_acct_num -- 转入客户账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_cust_acct_num -- 结算客户账号
    ,tran_dt -- 交易日期
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.transf_id, o.transf_id) as transf_id -- 转让编号
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.core_teller_id, o.core_teller_id) as core_teller_id -- 核心柜员编号
    ,nvl(n.lmt_id, o.lmt_id) as lmt_id -- 限制编号
    ,nvl(n.pd_cd, o.pd_cd) as pd_cd -- 期次编号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.dep_days, o.dep_days) as dep_days -- 存款天数
    ,nvl(n.int_accr_surp_days, o.int_accr_surp_days) as int_accr_surp_days -- 计息剩余天数
    ,nvl(n.transf_tot_cosdetn, o.transf_tot_cosdetn) as transf_tot_cosdetn -- 转让总对价
    ,nvl(n.transf_exp_dt, o.transf_exp_dt) as transf_exp_dt -- 转让到期日期
    ,nvl(n.dir_transf_flg, o.dir_transf_flg) as dir_transf_flg -- 定向转让标志
    ,nvl(n.order_begin_dt, o.order_begin_dt) as order_begin_dt -- 挂单起始日期
    ,nvl(n.tran_in_fee, o.tran_in_fee) as tran_in_fee -- 转入费用
    ,nvl(n.order_end_dt, o.order_end_dt) as order_end_dt -- 挂单结束日期
    ,nvl(n.transf_pric, o.transf_pric) as transf_pric -- 转让本金
    ,nvl(n.transf_int_rat, o.transf_int_rat) as transf_int_rat -- 转让利率
    ,nvl(n.cds_transf_type_cd, o.cds_transf_type_cd) as cds_transf_type_cd -- 大额存单转让类型代码
    ,nvl(n.transf_status_cd, o.transf_status_cd) as transf_status_cd -- 转让状态代码
    ,nvl(n.benefc_cust_id, o.benefc_cust_id) as benefc_cust_id -- 受益人客户编号
    ,nvl(n.transf_dt, o.transf_dt) as transf_dt -- 转让日期
    ,nvl(n.asign_yld_rat, o.asign_yld_rat) as asign_yld_rat -- 受让人收益率
    ,nvl(n.tran_out_fee, o.tran_out_fee) as tran_out_fee -- 转出费用
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.tran_in_cust_acct_num, o.tran_in_cust_acct_num) as tran_in_cust_acct_num -- 转入客户账号
    ,nvl(n.stl_acct_sub_acct_num, o.stl_acct_sub_acct_num) as stl_acct_sub_acct_num -- 结算账户子账号
    ,nvl(n.stl_cust_acct_num, o.stl_cust_acct_num) as stl_cust_acct_num -- 结算客户账号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.appl_dt, o.appl_dt) as appl_dt -- 申请日期
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.transf_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.transf_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.transf_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.transf_id = n.transf_id
where (
        o.evt_id is null
        and o.lp_id is null
        and o.transf_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
        and n.transf_id is null
    )
    or (
        o.tran_ref_no <> n.tran_ref_no
        or o.sub_acct_num <> n.sub_acct_num
        or o.cust_acct_num <> n.cust_acct_num
        or o.cust_name <> n.cust_name
        or o.cust_id <> n.cust_id
        or o.acct_id <> n.acct_id
        or o.core_teller_id <> n.core_teller_id
        or o.lmt_id <> n.lmt_id
        or o.pd_cd <> n.pd_cd
        or o.tran_tm <> n.tran_tm
        or o.dep_days <> n.dep_days
        or o.int_accr_surp_days <> n.int_accr_surp_days
        or o.transf_tot_cosdetn <> n.transf_tot_cosdetn
        or o.transf_exp_dt <> n.transf_exp_dt
        or o.dir_transf_flg <> n.dir_transf_flg
        or o.order_begin_dt <> n.order_begin_dt
        or o.tran_in_fee <> n.tran_in_fee
        or o.order_end_dt <> n.order_end_dt
        or o.transf_pric <> n.transf_pric
        or o.transf_int_rat <> n.transf_int_rat
        or o.cds_transf_type_cd <> n.cds_transf_type_cd
        or o.transf_status_cd <> n.transf_status_cd
        or o.benefc_cust_id <> n.benefc_cust_id
        or o.transf_dt <> n.transf_dt
        or o.asign_yld_rat <> n.asign_yld_rat
        or o.tran_out_fee <> n.tran_out_fee
        or o.final_modif_dt <> n.final_modif_dt
        or o.tran_in_cust_acct_num <> n.tran_in_cust_acct_num
        or o.stl_acct_sub_acct_num <> n.stl_acct_sub_acct_num
        or o.stl_cust_acct_num <> n.stl_cust_acct_num
        or o.tran_dt <> n.tran_dt
        or o.prod_id <> n.prod_id
        or o.appl_dt <> n.appl_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_cl(
            evt_id -- 协议编号
    ,lp_id -- 法人编号
    ,transf_id -- 转让编号
    ,tran_ref_no -- 交易参考号
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,core_teller_id -- 核心柜员编号
    ,lmt_id -- 限制编号
    ,pd_cd -- 期次编号
    ,tran_tm -- 交易时间
    ,dep_days -- 存款天数
    ,int_accr_surp_days -- 计息剩余天数
    ,transf_tot_cosdetn -- 转让总对价
    ,transf_exp_dt -- 转让到期日期
    ,dir_transf_flg -- 定向转让标志
    ,order_begin_dt -- 挂单起始日期
    ,tran_in_fee -- 转入费用
    ,order_end_dt -- 挂单结束日期
    ,transf_pric -- 转让本金
    ,transf_int_rat -- 转让利率
    ,cds_transf_type_cd -- 大额存单转让类型代码
    ,transf_status_cd -- 转让状态代码
    ,benefc_cust_id -- 受益人客户编号
    ,transf_dt -- 转让日期
    ,asign_yld_rat -- 受让人收益率
    ,tran_out_fee -- 转出费用
    ,final_modif_dt -- 最后修改日期
    ,tran_in_cust_acct_num -- 转入客户账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_cust_acct_num -- 结算客户账号
    ,tran_dt -- 交易日期
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_op(
            evt_id -- 协议编号
    ,lp_id -- 法人编号
    ,transf_id -- 转让编号
    ,tran_ref_no -- 交易参考号
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_name -- 客户名称
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,core_teller_id -- 核心柜员编号
    ,lmt_id -- 限制编号
    ,pd_cd -- 期次编号
    ,tran_tm -- 交易时间
    ,dep_days -- 存款天数
    ,int_accr_surp_days -- 计息剩余天数
    ,transf_tot_cosdetn -- 转让总对价
    ,transf_exp_dt -- 转让到期日期
    ,dir_transf_flg -- 定向转让标志
    ,order_begin_dt -- 挂单起始日期
    ,tran_in_fee -- 转入费用
    ,order_end_dt -- 挂单结束日期
    ,transf_pric -- 转让本金
    ,transf_int_rat -- 转让利率
    ,cds_transf_type_cd -- 大额存单转让类型代码
    ,transf_status_cd -- 转让状态代码
    ,benefc_cust_id -- 受益人客户编号
    ,transf_dt -- 转让日期
    ,asign_yld_rat -- 受让人收益率
    ,tran_out_fee -- 转出费用
    ,final_modif_dt -- 最后修改日期
    ,tran_in_cust_acct_num -- 转入客户账号
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_cust_acct_num -- 结算客户账号
    ,tran_dt -- 交易日期
    ,prod_id -- 产品编号
    ,appl_dt -- 申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.transf_id -- 转让编号
    ,o.tran_ref_no -- 交易参考号
    ,o.sub_acct_num -- 子账号
    ,o.cust_acct_num -- 客户账号
    ,o.cust_name -- 客户名称
    ,o.cust_id -- 客户编号
    ,o.acct_id -- 账户编号
    ,o.core_teller_id -- 核心柜员编号
    ,o.lmt_id -- 限制编号
    ,o.pd_cd -- 期次编号
    ,o.tran_tm -- 交易时间
    ,o.dep_days -- 存款天数
    ,o.int_accr_surp_days -- 计息剩余天数
    ,o.transf_tot_cosdetn -- 转让总对价
    ,o.transf_exp_dt -- 转让到期日期
    ,o.dir_transf_flg -- 定向转让标志
    ,o.order_begin_dt -- 挂单起始日期
    ,o.tran_in_fee -- 转入费用
    ,o.order_end_dt -- 挂单结束日期
    ,o.transf_pric -- 转让本金
    ,o.transf_int_rat -- 转让利率
    ,o.cds_transf_type_cd -- 大额存单转让类型代码
    ,o.transf_status_cd -- 转让状态代码
    ,o.benefc_cust_id -- 受益人客户编号
    ,o.transf_dt -- 转让日期
    ,o.asign_yld_rat -- 受让人收益率
    ,o.tran_out_fee -- 转出费用
    ,o.final_modif_dt -- 最后修改日期
    ,o.tran_in_cust_acct_num -- 转入客户账号
    ,o.stl_acct_sub_acct_num -- 结算账户子账号
    ,o.stl_cust_acct_num -- 结算客户账号
    ,o.tran_dt -- 交易日期
    ,o.prod_id -- 产品编号
    ,o.appl_dt -- 申请日期
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
from ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_bk o
    left join ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.transf_id = n.transf_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
            and o.transf_id = d.transf_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_cds_transf_appl_h;
--alter table ${iml_schema}.agt_cds_transf_appl_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_cds_transf_appl_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_cds_transf_appl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_cds_transf_appl_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_cds_transf_appl_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_cl;
alter table ${iml_schema}.agt_cds_transf_appl_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cds_transf_appl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cds_transf_appl_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cds_transf_appl_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
