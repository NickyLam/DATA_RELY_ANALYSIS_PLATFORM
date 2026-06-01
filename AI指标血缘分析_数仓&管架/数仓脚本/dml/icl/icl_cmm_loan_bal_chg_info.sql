/*
Purpose:    共性加工层-对公贷款借据信息，对公贷款借据主表，数据全部来源于信贷系统。包括所有的对公贷款业务。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220630 icl_cmm_loan_bal_chg_info
Createdate: 20190808
Logs:       20250625 谢  宁 增加模型
            20251209 陈伟峰 调整自营贷款还款明细部分逻辑
         
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_loan_bal_chg_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_loan_bal_chg_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_loan_bal_chg_info_ex purge;
drop table ${icl_schema}.tmp_cmm_loan_bal_chg_info_01 purge;
drop table ${icl_schema}.tmp_cmm_loan_bal_chg_info_02 purge;
drop table ${icl_schema}.tmp_cmm_loan_bal_chg_info_03 purge;
drop table ${icl_schema}.tmp_cmm_loan_bal_chg_info_04 purge;


-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_loan_bal_chg_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_loan_bal_chg_info where 0=1
;
commit;


create table  ${icl_schema}.tmp_cmm_loan_bal_chg_info_01
nologging
compress ${option_switch} for query high
as
select
      t1.dubil_id as dubil_id--借据号
    ,sum(case when substr(t2.subj_id, 1, 4) in ('1303', '1313') and t2.debit_crdt_dir_cd = 'C' then t2.stand_mony_amt else 0 end) as cr_pric_amt --贷方本金
    ,sum(case when t2.subj_id in ('11320101', '11320801','11320102','11320802', '60110101','60110102','22210202') and t2.debit_crdt_dir_cd = 'C' then t2.stand_mony_amt
              /*对公贷款应收利息、对公贷款应收未收利息、个人贷款应收利息、对公贷款应收未收利息、对公贷款利息收入、零售贷款利息收入、销项税额（一般）*/
              when t2.subj_id in ('11320801','11320802') then -t2.stand_mony_amt else 0 end) as cr_int_amt --贷方利息
    ,sum(case when t2.subj_id = '12210208' and t2.debit_crdt_dir_cd = 'C' then t2.stand_mony_amt else 0 end) as sub_cush_fee --代垫费用
    ,sum(case when t2.subj_id in ('20110101', '22419901','20110201', '12219901') and t2.debit_crdt_dir_cd = 'D' --对公活期存款、个人活期存款、其他应付款、其他应收款
              then t2.stand_mony_amt else 0 end) as callbk_amt --本位币金额
    -- 5
    ,sum(case when t2.subj_id = '19020101' and t2.debit_crdt_dir_cd = 'D' then t2.stand_mony_amt else 0 end) as dr_loan_impam_prep       --借方减值准备
    ,sum(case when t2.subj_id = '19020101' and t2.debit_crdt_dir_cd = 'C' then t2.stand_mony_amt else 0 end) as cr_loan_impam_prep       --贷方减值准备
    ,sum(case when t2.subj_id = '71070101' and t2.debit_crdt_dir_cd = 'R' then t2.stand_mony_amt else 0 end) as rec_wrt_off_pric_amt     --已核销贷款本金
    ,sum(case when t2.subj_id = '71070102' and t2.debit_crdt_dir_cd = 'R' then t2.stand_mony_amt else 0 end) as rec_wrt_off_int_amt      --已核销贷款利息
    ,sum(case when t2.subj_id = '71070301' and t2.debit_crdt_dir_cd = 'R' then t2.stand_mony_amt else 0 end) as rec_wrt_off_sub_cush_fee --已核销垫付款
    -- 10
    ,sum(case when t2.subj_id = '71070101' and t2.debit_crdt_dir_cd = 'P' then t2.stand_mony_amt else 0 end) as pay_wrt_off_pric_amt --本位币金额
    ,sum(case when t2.subj_id = '71070102' and t2.debit_crdt_dir_cd = 'P' then t2.stand_mony_amt else 0 end) as pay_wrt_off_int_amt --本位币金额
 from (select dubil_id, tran_flow_num,etl_dt as etl_dt
         from ${iml_schema}.evt_loan_sub_acct_bal_flow t1
        group by dubil_id, tran_flow_num ,etl_dt) t1 --贷款分户余额变动流水 
inner join ${iml_schema}.evt_accti_midgrod_acct_ety t2 --核算中台会计分录事件 
 on t1.tran_flow_num = t2.sorc_sys_flow_num
and t2.sob_id = '1'  --账套标志='1'
and t2.revs_status_cd = '0'  --非冲正交易
and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
group by t1.dubil_id
;
commit;

create table  ${icl_schema}.tmp_cmm_loan_bal_chg_info_02
nologging
compress ${option_switch} for query high
as
select t1.dubil_id
       ,min(start_dt) as wenti_dt
  from ${iml_schema}.agt_loan_dubil_info_h t1
where t1.prob_asset_flg = '1'
group by t1.dubil_id
;
commit;


create table  ${icl_schema}.tmp_cmm_loan_bal_chg_info_03
nologging
compress ${option_switch} for query high
as
select distinct 
    t2.rela_flow_num as dubil_id 
    ,t1.rgst_dt as rgst_dt
    ,case when t2.bus_type_cd = 'GivenessBeforApply' then 'DBR'
          when t2.bus_type_cd = 'VerificationApply' then 'WRO'
          when t2.bus_type_cd = 'BadLoansTransferApply' and t1.tran_type_cd = '01' then 'STR'
          when t2.bus_type_cd = 'BadLoansTransferApply' and t1.tran_type_cd = '02' then 'BTR'
     else '' end as disp_way_cd --业务类型代码
    ,case when t2.bus_type_cd = 'GivenessBeforApply' then '减免利息'
          when t2.bus_type_cd = 'VerificationApply' then '呆账核销'
          when t2.bus_type_cd = 'BadLoansTransferApply' and t1.tran_type_cd = '01' then '资产转让'   --单户问题资产转让
          when t2.bus_type_cd = 'BadLoansTransferApply' and t1.tran_type_cd = '02' then '资产转让'   --批量问题资产转让
     else '' end as disp_way_name --业务类型代码
    ,case when t2.bus_type_cd = 'BadLoansTransferApply' and t1.tran_type_cd = '01' then '单户转让' 
          when t2.bus_type_cd = 'BadLoansTransferApply' and t1.tran_type_cd = '02' then '批量转让' 
     else '' end as asset_tran_type --业务类型代码
    -- 5
 from ${iml_schema}.agt_astconsv_appl_info_h  t1 --资产保全（贷后）申请表 
inner join ${iml_schema}.agt_astconsv_dubil_rela_h  t2 --资产保全（贷后）关联表  
 on t1.appl_flow_num = t2.flow_num
and t2.bus_type_cd in ('GivenessBeforApply', 'BadLoansTransferApply', 'VerificationApply')
and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
and t2.end_dt > to_date('${batch_date}','yyyymmdd')
where t1.apv_status_cd = 'Finished'
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


create table  ${icl_schema}.tmp_cmm_loan_bal_chg_info_04
nologging
compress ${option_switch} for query high
as
/*花呗*/
select t1.dubil_id as dubil_id
      ,t1.cust_id  as cust_id
      ,t14.prod_id as prod_id
      ,(case when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) = 0 then '10'
           when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) >= 1
            and greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) <=89  then '20'
           when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) >= 90
            and greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) <=120 then '30'
           when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end))>= 121
            and greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) <=180 then '40'
           when greatest((case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.prin_ovdue_days,0) else 0  end)
                        ,(case when decode(nvl(t16.agt_status_cd, t1.cont_status_cd), 'OVD', '1', '0') = '1' then nvl(t6.int_ovdue_days,0)  else 0  end)) >= 181 then '50'end) as loan_level5_cls_cd
	  ,'897001' as org_id
from ${iml_schema}.agt_acp_dubil t1
 left join (
           select hb1.dubil_id,
                 (case when min(hb1.pric_turn_ovdue_dt) = to_date('29991231','yyyymmdd') then null else min(hb1.pric_turn_ovdue_dt) end) as prin_earliest_ovdue_dt, -- 首次本金逾期日期
                 (case when min(hb1.int_turn_ovdue_dt) = to_date('29991231','yyyymmdd') then null else min(hb1.int_turn_ovdue_dt) end) as int_earliest_ovdue_dt,   -- 首次利息逾期日期
                  case when min(hb1.pric_turn_ovdue_dt) = date'2999-12-31' then 0
                  else to_date('${batch_date}','yyyymmdd') -1 - trunc(min(hb1.pric_turn_ovdue_dt))+1 end as prin_ovdue_days, -- 本金逾期天数
                  case when min(hb1.int_turn_ovdue_dt) =  date'2999-12-31' then 0
                  else to_date('${batch_date}','yyyymmdd') -1 - trunc(min(hb1.int_turn_ovdue_dt)) +1 end as int_ovdue_days   -- 利息逾期天数
    from ${iml_schema}.agt_acp_repay_plan_h hb1
   where hb1.start_dt <= to_date('${batch_date}','yyyymmdd')-1
     and hb1.end_dt > to_date('${batch_date}','yyyymmdd')-1
     and hb1.inst_status_cd = 'OVD'
     and hb1.job_cd = 'myhbf1'
   group by hb1.dubil_id
		   ) t6
      on t1.dubil_id = t6.dubil_id 
  left join ${iml_schema}.agt_status_h t16
	 	  on t16.agt_id = t1.agt_id
	 	 and t16.agt_status_type_cd = 'CD1278'
	 	 and t16.start_dt <= to_date('${batch_date}', 'yyyymmdd')-1
     and t16.end_dt > to_date('${batch_date}', 'yyyymmdd')-1
     and t16.job_cd = 'myhbf1'
  left join ${iml_schema}.agt_prod_rela_h t14
      on t1.agt_id = t14.agt_id
     and t14.start_dt <= to_date('${batch_date}','yyyymmdd')-1
     and t14.end_dt > to_date('${batch_date}','yyyymmdd')-1
     and t14.job_cd ='myhbf1'
  left join ${iml_schema}.agt_status_h t10
	 	  on t10.agt_id = t1.agt_id
	 	 and t10.agt_status_type_cd = 'CD1261'
	 	 and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')-1
     and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')-1
     and t10.job_cd = 'myhbf1'
where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd') -1
  and t1.job_cd in ('myhbf1','myhbf2')
  and t1.id_mark <> 'D'
  and nvl(t10.agt_status_cd,t1.loan_status_cd) not in ('2','5')

union all
/*借呗*/
select
     t1.dubil_id	                                                                                  as dubil_id
    ,t1.cust_id                                                                                       as cust_id
    ,t16.prod_id	                                                                                  as prod_id
    ,(case when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) =0 then '10'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=1 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=89 then '20'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=90 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=120 then '30'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))>=121 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=180 then '40'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=181 then '50' end)     as loan_level5_cls_cd
    ,'897001'	                                                                                      as org_id
from ${iml_schema}.agt_ajb_dubil t1
	  left join (
	            select   jb1.agt_id,
         (case when min(jb1.pric_turn_ovdue_dt) = to_date('29991231','yyyymmdd') then null else min(jb1.pric_turn_ovdue_dt) end) as prin_earliest_ovdue_dt, -- 首次本金逾期日期
         (case when min(jb1.int_turn_ovdue_dt)  = to_date('29991231','yyyymmdd') then null else min(jb1.int_turn_ovdue_dt) end) as int_earliest_ovdue_dt,   -- 首次利息逾期日期
         case when min(jb1.pric_turn_ovdue_dt) = date'2999-12-31' then 0
         else to_date('${batch_date}','yyyymmdd') -1 - trunc(min(jb1.pric_turn_ovdue_dt))+1 end as prin_ovdue_days, --本金逾期天数
         case when min(jb1.int_turn_ovdue_dt) =  date'2999-12-31' then 0
         else to_date('${batch_date}','yyyymmdd') -1 - trunc(min(jb1.int_turn_ovdue_dt)) +1 end as int_ovdue_days   --利息逾期天数
    from ${iml_schema}.agt_ajb_repay_plan_h jb1
where jb1.job_cd = 'myjbf2'
    and jb1.start_dt <= to_date('${batch_date}','yyyymmdd') -1
    and jb1.end_dt >to_date('${batch_date}','yyyymmdd')-1
    and jb1.inst_status_cd = 'OVD'
   group by jb1.agt_id
				) t5
	     on t1.agt_id = t5.agt_id
    left join ${iml_schema}.agt_prod_rela_h t16
      on t1.agt_id = t16.agt_id
     and t16.start_dt <= to_date('${batch_date}','yyyymmdd')-1
     and t16.end_dt > to_date('${batch_date}','yyyymmdd')-1
     and t16.job_cd ='myjbf2'
left join ${iml_schema}.agt_status_h t12
    	 on t12.agt_id = t1.agt_id
    	and t12.agt_status_type_cd = 'CD1261'
    	and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')-1
      and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')-1
      and t12.job_cd = 'myjbf2'
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')-1
   and t1.job_cd = 'myjbf2'
   and t1.id_mark <> 'D'
   and nvl(t12.agt_status_cd,t1.loan_status_cd) not in ('2','5')
union all
/*网商贷*/ 
select
    t1.dubil_id	                                                                    as dubil_id
   ,t1.cust_id                                                                      as cust_id
   ,t15.prod_id	                                                                    as prod_id
   ,decode (t14.rating_result_cd,'1','10','2','20','3','30','4','40','5','50'
           ,t14.rating_result_cd) 	                                                as loan_level5_cls_cd
   ,'898001'                                                                        as org_id
from ${iml_schema}.agt_myloan_dubil t1
  left join ${iml_schema}.agt_status_h t11
  	on t1.agt_id = t11.agt_id
  	and t11.agt_status_type_cd = 'CD1261'
  	and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')-1
    and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')-1
    and t11.job_cd = 'mybkf1'
  left join ${iml_schema}.agt_rating_h t14
  	 on t14.agt_id = t1.agt_id
  	and t14.rating_type_cd = '2'
  	and t14.start_dt <= to_date('${batch_date}', 'yyyymmdd')-1
    and t14.end_dt > to_date('${batch_date}', 'yyyymmdd')-1
    and t14.job_cd = 'mybkf1'
  left join ${iml_schema}.agt_prod_rela_h t15
     on t1.agt_id = t15.agt_id
    and t15.start_dt <= to_date('${batch_date}','yyyymmdd')-1
    and t15.end_dt > to_date('${batch_date}','yyyymmdd')-1
    and t15.job_cd ='mybkf1'
/*  left join ${iml_schema}.agt_imp_dt_h t18
    	on t18.agt_id = t1.agt_id
    	and t18.dt_type_cd = '03'
    	and t18.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and t18.job_cd = 'mybkf1' */
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')-1
   and t1.job_cd = 'mybkf1'
   and t1.id_mark <> 'D'
   and nvl(t11.agt_status_cd, t1.loan_status_cd) not in ('2','5')

union all
/*微粒贷*/
select t1.dubil_id                       as dubil_id
   ,t1.cust_id                           as cust_id
   ,t15.prod_id                          as prod_id
   ,(case when nvl(t12.pric_ovdue_days, 0) = 0 then '10'
           when nvl(t12.pric_ovdue_days, 0) >= 1 and   nvl(t12.pric_ovdue_days, 0) <= 89 then '20'
           when nvl(t12.pric_ovdue_days, 0) >= 90 and  nvl(t12.pric_ovdue_days, 0) <= 120 then '30'
           when nvl(t12.pric_ovdue_days, 0) >= 121 and nvl(t12.pric_ovdue_days, 0) <= 180 then '40'
           when nvl(t12.pric_ovdue_days, 0) >= 181 then '50'
           else '99'
     end) as loan_level5_cls_cd         -- 贷款五级分类代码
   ,'897001'                            as org_id
from ${iml_schema}.agt_wld_dubil_info t1
   inner join ${iml_schema}.agt_wld_acct t2
      on t1.acct_id = t2.acct_id
     and t1.acct_type_cd = t2.acct_type_cd
     and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd') -1
     and t2.job_cd = 'mpcsf1'
     and t2.id_mark <> 'D'
   left join ${iml_schema}.agt_status_h t10
   	 on t1.agt_id = t10.agt_id
   	 and t10.agt_status_type_cd = 'CD1261'
   	 and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd') -1
     and t10.end_dt > to_date('${batch_date}', 'yyyymmdd') -1
     and t10.job_cd = 'mpcsf1'
   left join ${iml_schema}.agt_loan_ovdue_h t12
   	  on t1.agt_id = t12.agt_id
   	 and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')-1
     and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')-1
     and t12.job_cd = 'mpcsf1'
   left join ${iml_schema}.agt_prod_rela_h t15
     on t1.agt_id = t15.agt_id
    and t15.start_dt <= to_date('${batch_date}','yyyymmdd')-1
    and t15.end_dt > to_date('${batch_date}','yyyymmdd')-1
    and t15.job_cd = 'mpcsf1'
 /*  left join ${iml_schema}.agt_imp_dt_h t18
   	 on t1.agt_id = t18.agt_id
   	and t18.dt_type_cd = '03'
   	and t18.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t18.job_cd = 'mpcsf1'*/
where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')-1
    and t1.job_cd = 'mpcsf1'
    and t1.id_mark <> 'D'
	and nvl(t10.agt_status_cd, t1.loan_status_cd) not in ('2','5')
union all
/*借呗三期*/
select t1.dubil_id	                                                                    as dubil_id
       ,t1.cust_id                                                                      as cust_id
       ,t16.prod_id	                                                                    as prod_id
       ,(case when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) =0 then '10'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=1 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=89 then '20'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0)) >=90 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=120 then '30'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))>=121 and greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))<=180 then '40'
           when greatest(nvl(t5.prin_ovdue_days,0),nvl(t5.int_ovdue_days,0))>=181 then '50' end) as loan_level5_cls_cd                   --贷款五级分类代码
       ,'897001'	                                                                    as org_id
from ${iml_schema}.agt_ajb_ped_3_dubil t1
    left join (select jb32.dubil_id,
       (case when min(jb32.pric_turn_ovdue_dt) = to_date('29991231','yyyymmdd') then null else min(jb32.pric_turn_ovdue_dt) end) as prin_earliest_ovdue_dt, -- 首次本金逾期日期
       (case when min(jb32.int_turn_ovdue_dt) = to_date('29991231','yyyymmdd') then null else min(jb32.int_turn_ovdue_dt) end)  as int_earliest_ovdue_dt,   -- 首次利息逾期日期
       case when min(jb32.pric_turn_ovdue_dt) = date'2999-12-31' then 0
       else to_date('${batch_date}','yyyymmdd')-1 - trunc(min(jb32.pric_turn_ovdue_dt))+1 end as prin_ovdue_days, -- 本金逾期天数
       case when min(jb32.int_turn_ovdue_dt) =  date'2999-12-31' then 0
       else to_date('${batch_date}','yyyymmdd')-1 - trunc(min(jb32.int_turn_ovdue_dt)) +1 end as int_ovdue_days   -- 利息逾期天数
  from ${iml_schema}.agt_ajb_ped_3_repay_plan_h jb32
 where jb32.start_dt <= to_date('${batch_date}','yyyymmdd')-1
   and jb32.end_dt > to_date('${batch_date}','yyyymmdd')-1
   and jb32.inst_status_cd = 'OVD'
   and jb32.job_cd = 'myjbf3'
 group by jb32.dubil_id
	            ) t5
    	 on t1.dubil_id = t5.dubil_id
    left join ${iml_schema}.agt_status_h t14
      on t14.agt_id = t1.agt_id
     and t14.agt_status_type_cd = 'CD1261'
     and t14.start_dt <= to_date('${batch_date}', 'yyyymmdd')-1
     and t14.end_dt > to_date('${batch_date}', 'yyyymmdd')-1
     and t14.job_cd = 'myjbf3'
	left join ${iml_schema}.agt_status_h t10
    	on t10.agt_id = t1.agt_id
     and t10.agt_status_type_cd = 'CD1102'
     and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')-1
     and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')-1
     and t10.job_cd = 'myjbf3'
    left join ${iml_schema}.agt_imp_dt_h t11
      on t11.agt_id = t1.agt_id
     and t11.dt_type_cd = '03'
     and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')-1
     and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')-1
     and t11.job_cd = 'myjbf3'
	left join ${iml_schema}.agt_prod_rela_h t16
     on t1.agt_id = t16.agt_id
    and t16.start_dt <= to_date('${batch_date}','yyyymmdd')-1
    and t16.end_dt > to_date('${batch_date}','yyyymmdd')-1
    and t16.job_cd ='myjbf3'
where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')-1
 and t1.job_cd = 'myjbf3'
 and t1.id_mark <> 'D'
 and nvl(t14.agt_status_cd,t1.loan_status_cd) not in ('2','5')
union all
/*京东贷*/
select  t1.dubil_id	                                                                   as dubil_id
       ,t1.cust_id                                                                     as cust_id
       ,t2.prod_id	                                                                   as prod_id
       ,(case when nvl(trim(t24.prin_ovdue_days), 0) = 0 then '10'
              when nvl(trim(t24.prin_ovdue_days), 0) >= 1   and nvl(trim(t24.prin_ovdue_days), 0) <= 89 then '20'
              when nvl(trim(t24.prin_ovdue_days), 0) >= 90  and nvl(trim(t24.prin_ovdue_days), 0) <= 120 then '30'
              when nvl(trim(t24.prin_ovdue_days), 0) >= 121 and nvl(trim(t24.prin_ovdue_days), 0) <= 180 then '40'
              when nvl(trim(t24.prin_ovdue_days), 0) >= 181 then '50'
              else '10'
        end) as loan_level5_cls_cd  
       ,'897001'	                                                                   as org_id
  from ${iml_schema}.agt_jd_loan_dubil_info t1
  left join ${iml_schema}.agt_prod_rela_h t2
    on t1.agt_id = t2.agt_id
   and t1.lp_id = t2.lp_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')-1
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')-1
   and t2.agt_prod_rela_type_cd = '02'
   and t2.job_cd ='jdjrf1'
  left join  (select jd1.dubil_id,
         min(jd1.pric_exp_dt) as prin_earliest_ovdue_dt, -- 首次本金逾期日期
         min(jd1.int_exp_dt) as int_earliest_ovdue_dt,   -- 首次利息逾期日期
         case when min(jd1.pric_exp_dt) > to_date('${batch_date}','yyyymmdd') then 0
         else to_date('${batch_date}','yyyymmdd')-1- trunc(min(jd1.pric_exp_dt))+1 end as prin_ovdue_days, -- 本金逾期天数
         case when min(jd1.int_exp_dt) >  to_date('${batch_date}','yyyymmdd') then 0
         else to_date('${batch_date}','yyyymmdd')-1 - trunc(min(jd1.int_exp_dt)) +1 end as int_ovdue_days   -- 利息逾期天数
    from ${iml_schema}.agt_jd_repay_plan_h jd1
   where jd1.start_dt <= to_date('${batch_date}','yyyymmdd')-1
     and jd1.end_dt > to_date('${batch_date}','yyyymmdd')-1
     and jd1.curr_ovdue_status_cd = '1'
     and jd1.job_cd = 'jdjri1'
   group by jd1.dubil_id
              ) t24
    on t1.dubil_id = t24.dubil_id
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')-1
   and t1.job_cd = 'jdjrf1'
   and t1.id_mark <> 'D'
union all
/*微粒贷*/
select
    t1.dubil_id                        as dubil_id
   ,t1.cust_id                         as cust_id
   ,t1.prod_id                         as prod_id
   ,case when t1.curr_ovdue_days = 0 then '10'
         when t1.curr_ovdue_days >= 1 and t1.curr_ovdue_days <= 89 then '20'
         when t1.curr_ovdue_days >= 90 and t1.curr_ovdue_days <= 120 then'30'
         when t1.curr_ovdue_days >= 121 and t1.curr_ovdue_days <= 180 then '40'
         when t1.curr_ovdue_days >= 181 then '50'
         else '99' end                 as loan_level5_cls_cd  
   ,'805011'                           as org_id
 from (select t1.dubil_id ,t1.cust_id,t1.prod_id,t1.curr_ovdue_days,t1.acct_id,t1.acct_type_cd,t1.loan_status_cd
     from ${iml_schema}.agt_wld_dubil_info_h t1
    where t1.payoff_dt >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
      and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')-1
      and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')-1
      and t1.job_cd ='icmsf1'
    union all
   select t1.dubil_id ,t1.cust_id,t1.prod_id,t1.curr_ovdue_days,t1.acct_id,t1.acct_type_cd,t1.loan_status_cd
     from ${iml_schema}.agt_wld_dubil_info_h t1
    where t1.payoff_dt = ${iml_schema}.dateformat_min('')
      and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')-1
      and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')-1
      and t1.job_cd ='icmsf1'
       ) t1
inner join ${iml_schema}.agt_wld_acct_h t2
   on t1.acct_id =t2.acct_id
  and t1.acct_type_cd=t2.acct_type_cd
  and t2.start_dt <=to_date('${batch_date}', 'yyyymmdd')-1
  and t2.end_dt >to_date('${batch_date}', 'yyyymmdd')-1
  and t2.job_cd ='icmsf1'
where 1=1
  and t1.loan_status_cd not in ('2','5')
union all
/*字节小微贷*/
select  t1.intnal_dubil_id                   as dubil_id
       ,t1.cust_id                           as cust_id
       ,t1.prod_id                           as prod_id
       ,t1.loan_level5_cls_cd                as loan_level5_cls_cd  
       ,t1.fin_org_id                        as org_id
 from ${iml_schema}.agt_zjdk_dubil_info_h t1
where 1=1
  and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')-1
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')-1
  and t1.job_cd ='icmsf1'
  and t1.payoff_dt >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
union all 
/*微业贷*/
select t1.dubil_id   as dubil_id
   ,t1.cust_id       as cust_id
   ,t1.prod_id       as prod_id
   ,t1.level5_cls_cd as level5_cls_cd
   ,t1.fin_org_id  as org_id
 from ${iml_schema}.agt_wyd_dubil_h t1
 left join ${iml_schema}.agt_wyd_dubil_attach_info t2
   on t1.dubil_id = t2.dubil_id
  and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')-1
where 1 = 1
  and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')-1
  and t1.job_cd ='icmsf1'
 -- and t2.payoff_dt >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
;
commit;


-- 第一组 对公、自营零售资产转让（共五组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_loan_bal_chg_info_ex(
       etl_dt                         -- 数据日期
       ,lp_id                         -- 法人编号
       ,dubil_id                      -- 借据编号
       ,cust_id                       -- 客户编号
       ,std_prod_id                   -- 标准产品编号
       ,bus_line_cd                   -- 业务条线代码
       ,disp_type_cd                  -- 处置类型代码
       ,disp_way_cd                   -- 处置方式代码
       ,tran_type_cd                  -- 转让类型代码
       ,bal_chag_date                 -- 余额变动日期
       ,bal_tm_ear_lvl5_cls_cd        -- 余额时点年初五级分类代码
       ,bal_tm_lvl5_cls_cd            -- 余额时点五级分类代码
       ,tran_dt                       -- 转让日期
       ,wrt_off_dt                    -- 核销日期
       ,prob_loan_dt                  -- 问题贷款日期
       ,ear_y_pric_bal                -- 年初本金余额 
       ,pric_amt                      -- 本金金额
       ,int_amt                       -- 利息金额
       ,pnlt_amt                      -- 罚息金额
       ,comp_int_amt                  -- 复息金额
       ,fee_amt                       -- 费用金额
       ,open_acct_org_id              -- 开户机构编号
       ,mgmt_org_id                   -- 管理机构编号
       ,acct_instit_id                -- 账务机构编号
       ,job_cd                        -- 任务代码
       ,etl_timestamp                 -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                        -- 数据日期
       ,t1.lp_id                                                                                  -- 法人编号
       ,t1.dubil_id                                                                               -- 借据编号
       ,t1.cust_id                                                                                -- 客户编号
       ,t1.prod_id                                                                                -- 标准产品编号
       ,case when t2.crdt_prod_cate_cd in ('2','3','4') then '02' else '01' end                   -- 业务条线代码
       ,case when t1.bad_debt_wrt_off_status_cd = 'Y' then '01'
             when t1.prob_asset_flg = '1' then '02' else ' ' end                                  -- 处置类型代码 (核销、问题)
       ,'01'                                                                                      -- 处置方式代码(01转让、02呆账、03差额、04余额变动)
       ,case when t2.crdt_prod_cate_cd in ('2','3','4') then 'STR'
	    else t5.disp_way_cd end                                                                   -- 转让类型代码(单户、批量)
       ,to_date('${batch_date}','yyyymmdd')                                                       -- 余额变动日期
       ,nvl(trim(t4.level5_cls_cd), '99')                                                         -- 余额时点年初五级分类代码
       ,nvl(trim(t1.level5_cls_cd), '99')                                                         -- 余额时点五级分类代码
       ,to_date('${batch_date}','yyyymmdd')                                                       -- 转让日期
       ,t6.fir_wrt_off_dt                                                                         -- 核销日期
       ,case when (t1.prob_asset_flg = '1' and t3.prob_asset_flg <> '1' ) then to_date('${batch_date}','yyyymmdd') else null end -- 问题贷款日期
       ,t4.curr_bal                                                                               -- 年初本金余额 
       ,(t7.cr_pric_amt + t7.cr_loan_impam_prep - t7.dr_loan_impam_prep)                          -- 本金金额
       ,t1.int_bal                                                                                -- 利息金额
       ,t1.acru_pnlt                                                                              -- 罚息金额
       ,t1.acru_comp_int                                                                          -- 复息金额
       ,'0'                                                                                       -- 费用金额
       ,t1.oper_org_id                                                                            -- 开户机构编号
       ,t1.rgst_org_id                                                                            -- 管理机构编号
       ,t1.accti_org_id                                                                           -- 账务机构编号
       ,t1.job_cd                                                                                 -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                           -- 处理日期
  from ${iml_schema}.agt_loan_dubil_info_h t1 
left join ${iml_schema}.prd_loan_prod_info_h t2
    on nvl(trim(t1.prod_id),'-') = t2.prod_id
  -- and t2.crdt_prod_cate_cd not in ('2','3','4')
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_dubil_info_h t3 --上日批次
    on t1.dubil_id = t3.dubil_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd') -1
   and t3.end_dt > to_date('${batch_date}','yyyymmdd') -1
   and t3.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_dubil_info_h t4   --年初
    on t1.dubil_id = t4.dubil_id
   and t4.start_dt <= to_date('${year_start}','yyyymmdd') -1 
   and t4.end_dt > to_date('${year_start}','yyyymmdd') -1
   and t4.job_cd = 'icmsf1'
left join ${icl_schema}.tmp_cmm_loan_bal_chg_info_03 t5
    on t1.dubil_id = t5.dubil_id
left join ${icl_schema}.cmm_loan_wrt_off_info t6
    on t3.dubil_id = t6.dubil_id
   and t6.fir_wrt_off_dt = to_date('${batch_date}', 'yyyymmdd') -1
   and etl_dt = to_date(to_char(sysdate - 2,'yyyymmdd'),'yyyymmdd')
left join ${icl_schema}.tmp_cmm_loan_bal_chg_info_01 t7
    on t1.dubil_id = t7.dubil_id
left join ${iol_schema}.ncbs_cl_acct t8
    on t1.dubil_id = t8.cmisloan_no
   and t8.is_trf_flag = 'Y'
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and (t1.level5_cls_cd in ('30','40','50') 
       or nvl(trim(t4.level5_cls_cd), '99') in ('30','40','50') 
	   or t1.prob_asset_flg = '1')
  and t8.cmisloan_no is not null
  and (t7.cr_pric_amt + t7.cr_loan_impam_prep - t7.dr_loan_impam_prep) > 0
;
commit;

-- 第二组 对公、自营零售呆账核销（共五组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_loan_bal_chg_info_ex(
       etl_dt                         -- 数据日期
       ,lp_id                         -- 法人编号
       ,dubil_id                      -- 借据编号
       ,cust_id                       -- 客户编号
       ,std_prod_id                   -- 标准产品编号
       ,bus_line_cd                   -- 业务条线代码
       ,disp_type_cd                  -- 处置类型代码
       ,disp_way_cd                   -- 处置方式代码
       ,tran_type_cd                  -- 转让类型代码
       ,bal_chag_date                 -- 余额变动日期
       ,bal_tm_ear_lvl5_cls_cd        -- 余额时点年初五级分类代码
       ,bal_tm_lvl5_cls_cd            -- 余额时点五级分类代码
       ,tran_dt                       -- 转让日期
       ,wrt_off_dt                    -- 核销日期
       ,prob_loan_dt                  -- 问题贷款日期
       ,ear_y_pric_bal                -- 年初本金余额 
       ,pric_amt                      -- 本金金额
       ,int_amt                       -- 利息金额
       ,pnlt_amt                      -- 罚息金额
       ,comp_int_amt                  -- 复息金额
       ,fee_amt                       -- 费用金额
       ,open_acct_org_id              -- 开户机构编号
       ,mgmt_org_id                   -- 管理机构编号
       ,acct_instit_id                -- 账务机构编号
       ,job_cd                        -- 任务代码
       ,etl_timestamp                 -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                        -- 数据日期
       ,t1.lp_id                                                                                  -- 法人编号
       ,t1.dubil_id                                                                               -- 借据编号
       ,t1.cust_id                                                                                -- 客户编号
       ,t1.prod_id                                                                                -- 标准产品编号
       ,case when t2.crdt_prod_cate_cd in ('2','3','4') then '02' else '01' end                   -- 业务条线代码
       ,'01'                                                                                      -- 处置类型代码 (核销、问题)
       ,'02'                                                                                      -- 处置方式代码(01转让、02呆账、03差额、04余额变动)
       ,' ' 	                                                                                  -- 转让类型代码(单户、批量)
       ,t6.fir_wrt_off_dt                                                                         -- 余额变动日期
       ,nvl(trim(t4.level5_cls_cd), '99')                                                         -- 余额时点年初五级分类代码
       ,nvl(trim(t1.level5_cls_cd), '99')                                                         -- 余额时点五级分类代码
       ,null  --转让日期
       ,t6.fir_wrt_off_dt                                                                         -- 核销日期
       ,case when (t1.prob_asset_flg = '1' and t3.prob_asset_flg <> '1' ) then to_date('${batch_date}','yyyymmdd') else null end -- 问题贷款日期
       ,t4.curr_bal                                                                               -- 年初本金余额 
       ,case when t7.rec_wrt_off_pric_amt = 0 then t1.curr_bal
        else t7.rec_wrt_off_pric_amt end                                                          -- 本金金额
       ,t7.rec_wrt_off_int_amt                                                                    -- 利息金额
       ,t1.acru_pnlt                                                                              -- 罚息金额
       ,t1.recvbl_over_int                                                                        -- 复息金额
       ,t7.rec_wrt_off_sub_cush_fee                                                               -- 费用金额
       ,t1.oper_org_id                                                                            -- 开户机构编号
       ,t1.rgst_org_id                                                                            -- 管理机构编号
       ,t1.accti_org_id                                                                           -- 账务机构编号
       ,t1.job_cd                                                                                 -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                           -- 处理日期
  from ${iml_schema}.agt_loan_dubil_info_h t1 
left join ${iml_schema}.prd_loan_prod_info_h t2
    on nvl(trim(t1.prod_id),'-') = t2.prod_id
   --and t2.crdt_prod_cate_cd not in ('2','3','4')
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_dubil_info_h t3   --上日批次
    on t1.dubil_id = t3.dubil_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd') -1
   and t3.end_dt > to_date('${batch_date}','yyyymmdd') -1 
   and t3.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_dubil_info_h t4   --年初
    on t1.dubil_id = t4.dubil_id
   and t4.start_dt <= to_date('${year_start}','yyyymmdd') - 1
   and t4.end_dt > to_date('${year_start}','yyyymmdd') - 1
   and t4.job_cd = 'icmsf1'
left join ${icl_schema}.tmp_cmm_loan_bal_chg_info_03 t5
    on t1.dubil_id = t5.dubil_id
left join (select dubil_id as dubil_id,max(fir_wrt_off_dt)  as fir_wrt_off_dt
             from ${icl_schema}.cmm_loan_wrt_off_info
          group by dubil_id
          ) t6
    on t1.dubil_id = t6.dubil_id
left join ${icl_schema}.tmp_cmm_loan_bal_chg_info_01 t7
    on t1.dubil_id = t7.dubil_id
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and (t1.level5_cls_cd in ('30','40','50') 
       or nvl(trim(t4.level5_cls_cd), '99') in ('30','40','50') 
	   or t1.prob_asset_flg = '1')
  and t6.dubil_id is not null
  and t6.fir_wrt_off_dt = to_date('${batch_date}','yyyymmdd')

union all
/*同业*/
select to_date('${batch_date}','yyyymmdd')                                                        -- 数据日期
       ,t1.lp_id                                                                                  -- 法人编号
       ,t1.dubil_id                                                                               -- 借据编号
       ,t1.cust_id                                                                                -- 客户编号
       ,t1.prod_id                                                                                -- 标准产品编号
       ,'03'                                                                                      -- 业务条线代码
       ,'01'                                                                                      -- 处置类型代码 (核销、问题)
       ,'02'                                                                                      -- 处置方式代码(01转让、02呆账、03差额、04余额变动)
       ,' ' 	                                                                                  -- 转让类型代码(单户、批量)
       ,to_date('${batch_date}','yyyymmdd')                                                       -- 余额变动日期
       ,nvl(trim(t4.level5_cls_cd), '99')                                                         -- 余额时点年初五级分类代码
       ,nvl(trim(t1.level5_cls_cd), '99')                                                         -- 余额时点五级分类代码
       ,null                                                                                      -- 转让日期
       ,to_date('${batch_date}','yyyymmdd')                                                       -- 核销日期
       ,null                                                                                      -- 问题贷款日期
       ,t4.curr_bal                                                                               -- 年初本金余额 
       ,t1.curr_bal                                                                               -- 本金金额
       ,0                                                                                         -- 利息金额
       ,0                                                                                         -- 罚息金额
       ,0                                                                                         -- 复息金额
       ,0                                                                                         -- 费用金额
       ,t1.oper_org_id                                                                            -- 开户机构编号
       ,t1.rgst_org_id                                                                            -- 管理机构编号
       ,t1.accti_org_id                                                                           -- 账务机构编号
       ,t1.job_cd                                                                                 -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                           -- 处理日期
  from ${iml_schema}.agt_loan_dubil_info_h t1 
left join ${iml_schema}.prd_loan_prod_info_h t2
    on nvl(trim(t1.prod_id),'-') = t2.prod_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_dubil_info_h t3   --上日批次
    on t1.dubil_id = t3.dubil_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd') -1
   and t3.end_dt > to_date('${batch_date}','yyyymmdd') -1 
   and t3.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_dubil_info_h t4   --年初
    on t1.dubil_id = t4.dubil_id
   and t4.start_dt <= to_date('${year_start}','yyyymmdd') - 1
   and t4.end_dt > to_date('${year_start}','yyyymmdd') - 1
   and t4.job_cd = 'icmsf1'
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.bad_debt_wrt_off_status_cd = 'Y' 
  and t3.bad_debt_wrt_off_status_cd <> 'Y'
  and t1.prod_id like '3%'
;
commit;



-- 第三组 对公、自营零售差额核销（共五组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_loan_bal_chg_info_ex(
       etl_dt                         -- 数据日期
       ,lp_id                         -- 法人编号
       ,dubil_id                      -- 借据编号
       ,cust_id                       -- 客户编号
       ,std_prod_id                   -- 标准产品编号
       ,bus_line_cd                   -- 业务条线代码
       ,disp_type_cd                  -- 处置类型代码
       ,disp_way_cd                   -- 处置方式代码
       ,tran_type_cd                  -- 转让类型代码
       ,bal_chag_date                 -- 余额变动日期
       ,bal_tm_ear_lvl5_cls_cd        -- 余额时点年初五级分类代码
       ,bal_tm_lvl5_cls_cd            -- 余额时点五级分类代码
       ,tran_dt                       -- 转让日期
       ,wrt_off_dt                    -- 核销日期
       ,prob_loan_dt                  -- 问题贷款日期
       ,ear_y_pric_bal                -- 年初本金余额 
       ,pric_amt                      -- 本金金额
       ,int_amt                       -- 利息金额
       ,pnlt_amt                      -- 罚息金额
       ,comp_int_amt                  -- 复息金额
       ,fee_amt                       -- 费用金额
       ,open_acct_org_id              -- 开户机构编号
       ,mgmt_org_id                   -- 管理机构编号
       ,acct_instit_id                -- 账务机构编号
       ,job_cd                        -- 任务代码
       ,etl_timestamp                 -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                        -- 数据日期
       ,t1.lp_id                                                                                  -- 法人编号
       ,t1.dubil_id                                                                               -- 借据编号
       ,t1.cust_id                                                                                -- 客户编号
       ,t1.prod_id                                                                                -- 标准产品编号
       ,case when t2.crdt_prod_cate_cd in ('2','3','4') then '02' else '01' end                   -- 业务条线代码
       ,'01'                                                                                      -- 处置类型代码 (核销、问题)
       ,'03'                                                                                      -- 处置方式代码(01转让、02呆账、03差额、04余额变动)
       ,' ' 	                                                                                  -- 转让类型代码(单户、批量)
       ,to_date('${batch_date}','yyyymmdd')                                                       -- 余额变动日期
       ,nvl(trim(t4.level5_cls_cd), '99')                                                         -- 余额时点年初五级分类代码
       ,nvl(trim(t1.level5_cls_cd), '99')                                                         -- 余额时点五级分类代码
       ,null  --转让日期
       ,t6.fir_wrt_off_dt                                                                         -- 核销日期
       ,case when (t1.prob_asset_flg = '1' and t3.prob_asset_flg <> '1' ) then to_date('${batch_date}','yyyymmdd') else null end -- 问题贷款日期
       ,t4.curr_bal                                                                               -- 年初本金余额 
       ,case when (t7.cr_pric_amt + t7.cr_loan_impam_prep - t7.dr_loan_impam_prep) > 0 and t7.cr_pric_amt > 0
             then t7.dr_loan_impam_prep
             when t7.pay_wrt_off_pric_amt > 0  then t7.pay_wrt_off_pric_amt - t7.cr_loan_impam_prep end -- 本金金额
       ,nvl(t8.currt_repay_int,0)                                                                 -- 利息金额
       ,nvl(t8.currt_repay_pnlt,0)                                                                -- 罚息金额
       ,nvl(t8.currt_repay_comp_int,0)                                                            -- 复息金额
       ,nvl(t7.rec_wrt_off_sub_cush_fee,0)                                                        -- 费用金额
       ,t1.oper_org_id                                                                            -- 开户机构编号
       ,t1.rgst_org_id                                                                            -- 管理机构编号
       ,t1.accti_org_id                                                                           -- 账务机构编号
       ,t1.job_cd                                                                                 -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                           -- 处理日期
  from ${iml_schema}.agt_loan_dubil_info_h t1 
left join ${iml_schema}.prd_loan_prod_info_h t2
    on nvl(trim(t1.prod_id),'-') = t2.prod_id
 --  and t2.crdt_prod_cate_cd not in ('2','3','4')
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_dubil_info_h t3   --上日批次
    on t1.dubil_id = t3.dubil_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd') -1
   and t3.end_dt > to_date('${batch_date}','yyyymmdd') -1 
   and t3.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_dubil_info_h t4   --年初
    on t1.dubil_id = t4.dubil_id
   and t4.start_dt <= to_date('${year_start}','yyyymmdd') - 1
   and t4.end_dt > to_date('${year_start}','yyyymmdd') - 1
   and t4.job_cd = 'icmsf1'
left join ${icl_schema}.tmp_cmm_loan_bal_chg_info_03 t5
    on t1.dubil_id = t5.dubil_id
left join (select dubil_id as dubil_id,max(fir_wrt_off_dt) as fir_wrt_off_dt
             from icl.cmm_loan_wrt_off_info
           group by dubil_id
          ) t6
    on t1.dubil_id = t6.dubil_id
left join ${icl_schema}.tmp_cmm_loan_bal_chg_info_01 t7
    on t1.dubil_id = t7.dubil_id
left join (select dubil_id
                 ,abs(sum(currt_repay_int)) as currt_repay_int
                 ,abs(sum(currt_repay_pnlt)) as currt_repay_pnlt
                 ,abs(sum(currt_repay_comp_int)) as currt_repay_comp_int
            from ${icl_schema}.cmm_corp_loan_repay_dtl
           where etl_dt = to_date('${batch_date}','yyyymmdd')
             and strk_bal_flg = '0'
           group by dubil_id
           ) t8
    on t1.dubil_id = t8.dubil_id
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and (t1.level5_cls_cd in ('30','40','50') 
       or nvl(trim(t4.level5_cls_cd), '99') in ('30','40','50') 
	   or t1.prob_asset_flg = '1')
  and (((t7.cr_pric_amt + t7.cr_loan_impam_prep - t7.dr_loan_impam_prep) > 0 and t7.cr_pric_amt > 0 and t7.dr_loan_impam_prep > 0)
       or (t7.pay_wrt_off_pric_amt > 0 and t7.pay_wrt_off_pric_amt - t7.cr_loan_impam_prep > 0))
;
commit;

-- 第四组 对公、自营零售还款变动（共五组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_loan_bal_chg_info_ex(
       etl_dt                         -- 数据日期
       ,lp_id                         -- 法人编号
       ,dubil_id                      -- 借据编号
       ,cust_id                       -- 客户编号
       ,std_prod_id                   -- 标准产品编号
       ,bus_line_cd                   -- 业务条线代码
       ,disp_type_cd                  -- 处置类型代码
       ,disp_way_cd                   -- 处置方式代码
       ,tran_type_cd                  -- 转让类型代码
       ,bal_chag_date                 -- 余额变动日期
       ,bal_tm_ear_lvl5_cls_cd        -- 余额时点年初五级分类代码
       ,bal_tm_lvl5_cls_cd            -- 余额时点五级分类代码
       ,tran_dt                       -- 转让日期
       ,wrt_off_dt                    -- 核销日期
       ,prob_loan_dt                  -- 问题贷款日期
       ,ear_y_pric_bal                -- 年初本金余额 
       ,pric_amt                      -- 本金金额
       ,int_amt                       -- 利息金额
       ,pnlt_amt                      -- 罚息金额
       ,comp_int_amt                  -- 复息金额
       ,fee_amt                       -- 费用金额
       ,open_acct_org_id              -- 开户机构编号
       ,mgmt_org_id                   -- 管理机构编号
       ,acct_instit_id                -- 账务机构编号
       ,job_cd                        -- 任务代码
       ,etl_timestamp                 -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                        -- 数据日期
       ,t1.lp_id                                                                                  -- 法人编号
       ,t1.dubil_id                                                                               -- 借据编号
       ,t1.cust_id                                                                                -- 客户编号
       ,t1.prod_id                                                                                -- 标准产品编号
       ,case when t2.crdt_prod_cate_cd in ('2','3','4') then '02' else '01' end                   -- 业务条线代码
       ,' '                                                                                       -- 处置类型代码 (核销、问题)
       ,'04'                                                                                      -- 处置方式代码(01转让、02呆账、03差额、04余额变动)
       ,' ' 	                                                                                  -- 转让类型代码(单户、批量)
       ,to_date('${batch_date}','yyyymmdd')                                                       -- 余额变动日期
       ,nvl(trim(t4.level5_cls_cd), '99')                                                         -- 余额时点年初五级分类代码
       ,nvl(trim(t1.level5_cls_cd), '99')                                                         -- 余额时点五级分类代码
       ,null  --转让日期
       ,t6.fir_wrt_off_dt                                                                         -- 核销日期
       ,case when (t1.prob_asset_flg = '1' and t3.prob_asset_flg <> '1' ) then to_date('${batch_date}','yyyymmdd') else null end -- 问题贷款日期
       ,t4.curr_bal                                                                               -- 年初本金余额 
       ,t8.pric                                                                                   -- 本金金额
       ,t8.intt                                                                                   -- 利息金额
       ,t8.pnlt                                                                                   -- 罚息金额
       ,t8.compint                                                                                -- 复息金额
       ,t7.rec_wrt_off_sub_cush_fee                                                               -- 费用金额
       ,t1.oper_org_id                                                                            -- 开户机构编号
       ,t1.rgst_org_id                                                                            -- 管理机构编号
       ,t1.accti_org_id                                                                           -- 账务机构编号
       ,t1.job_cd                                                                                 -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                           -- 处理日期
  from ${iml_schema}.agt_loan_dubil_info_h t1 
left join ${iml_schema}.prd_loan_prod_info_h t2
    on nvl(trim(t1.prod_id),'-') = t2.prod_id
 --  and t2.crdt_prod_cate_cd not in ('2','3','4')
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_dubil_info_h t3   --上日批次
    on t1.dubil_id = t3.dubil_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd') -1
   and t3.end_dt > to_date('${batch_date}','yyyymmdd') -1 
   and t3.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_dubil_info_h t4   --年初
    on t1.dubil_id = t4.dubil_id
   and t4.start_dt <= to_date('${year_start}','yyyymmdd') - 1
   and t4.end_dt > to_date('${year_start}','yyyymmdd') - 1
   and t4.job_cd = 'icmsf1'
left join ${icl_schema}.tmp_cmm_loan_bal_chg_info_03 t5
    on t1.dubil_id = t5.dubil_id
left join (select dubil_id as dubil_id,max(fir_wrt_off_dt)  as fir_wrt_off_dt
             from ${icl_schema}.cmm_loan_wrt_off_info
          group by dubil_id
          ) t6
    on t1.dubil_id = t6.dubil_id
left join ${icl_schema}.tmp_cmm_loan_bal_chg_info_01 t7
    on t1.dubil_id = t7.dubil_id
left join (select dubil_id
                 ,repay_acct_id
                 ,sum(currt_repay_pric) as pric
                 ,sum(currt_repay_int) as intt
                 ,sum(currt_repay_pnlt) as pnlt 
                 ,sum(currt_repay_comp_int) as compint
                 ,sum(currt_repay_fee) as fee
             from ${icl_schema}.cmm_retl_loan_repay_dtl
            where strk_bal_flg = '0'
              and etl_dt = to_date('${batch_date}','yyyymmdd')
            group by dubil_id,repay_acct_id
            union all
           select dubil_id
                 ,repay_acct_id
                 ,sum(currt_repay_pric) as pric
                 ,sum(currt_repay_int) as intt
                 ,sum(currt_repay_pnlt) as pnlt 
                 ,sum(currt_repay_comp_int) as compint
                 ,sum(currt_repay_fee) as fee
             from ${icl_schema}.cmm_corp_loan_repay_dtl
            where strk_bal_flg = '0'
              and etl_dt = to_date('${batch_date}','yyyymmdd')
            group by dubil_id,repay_acct_id
           ) t8
    on t1.dubil_id = t8.dubil_id
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and (t1.level5_cls_cd in ('30','40','50') 
       or nvl(trim(t4.level5_cls_cd), '99') in ('30','40','50') 
	   or t1.prob_asset_flg = '1')
  and t8.dubil_id is not null
  and (t8.pric+T8.intt+T8.pnlt+T8.compint+T8.fee)>0

union all
/*同业*/
select to_date('${batch_date}','yyyymmdd')                                                        -- 数据日期
       ,t1.lp_id                                                                                  -- 法人编号
       ,t1.dubil_id                                                                               -- 借据编号
       ,t1.cust_id                                                                                -- 客户编号
       ,t1.prod_id                                                                                -- 标准产品编号
       ,'03'                                                                                      -- 业务条线代码
       ,' '                                                                                       -- 处置类型代码 (核销、问题)
       ,'04'                                                                                      -- 处置方式代码(01转让、02呆账、03差额、04余额变动)
       ,' ' 	                                                                                  -- 转让类型代码(单户、批量)
       ,to_date('${batch_date}','yyyymmdd')                                                       -- 余额变动日期
       ,nvl(trim(t4.level5_cls_cd), '99')                                                         -- 余额时点年初五级分类代码
       ,nvl(trim(t1.level5_cls_cd), '99')                                                         -- 余额时点五级分类代码
       ,null  --转让日期
       ,null  -- 核销日期
       ,case when (t1.prob_asset_flg = '1' and t3.prob_asset_flg <> '1' ) then to_date('${batch_date}','yyyymmdd') else null end -- 问题贷款日期
       ,t4.curr_bal                                                                               -- 年初本金余额 
       ,t3.curr_bal - t1.curr_bal                                                                 -- 本金金额
       ,0                                                                                         -- 利息金额
       ,0                                                                                         -- 罚息金额
       ,0                                                                                         -- 复息金额
       ,0                                                                                         -- 费用金额
       ,t1.oper_org_id                                                                            -- 开户机构编号
       ,t1.rgst_org_id                                                                            -- 管理机构编号
       ,t1.accti_org_id                                                                           -- 账务机构编号
       ,t1.job_cd                                                                                 -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                           -- 处理日期
  from ${iml_schema}.agt_loan_dubil_info_h t1 
left join ${iml_schema}.prd_loan_prod_info_h t2
    on nvl(trim(t1.prod_id),'-') = t2.prod_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_dubil_info_h t3   --上日批次
    on t1.dubil_id = t3.dubil_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd') -1
   and t3.end_dt > to_date('${batch_date}','yyyymmdd') -1 
   and t3.job_cd = 'icmsf1'
left join ${iml_schema}.agt_loan_dubil_info_h t4   --年初
    on t1.dubil_id = t4.dubil_id
   and t4.start_dt <= to_date('${year_start}','yyyymmdd') - 1
   and t4.end_dt > to_date('${year_start}','yyyymmdd') - 1
   and t4.job_cd = 'icmsf1'
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.curr_bal < t3.curr_bal
  and t1.level5_cls_cd in ('30','40','50')
  and t1.prod_id like '3%'
;
commit;


-- 第五组 联合贷款核销、还款明细（共五组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_loan_bal_chg_info_ex(
       etl_dt                         -- 数据日期
       ,lp_id                         -- 法人编号
       ,dubil_id                      -- 借据编号
       ,cust_id                       -- 客户编号
       ,std_prod_id                   -- 标准产品编号
       ,bus_line_cd                   -- 业务条线代码
       ,disp_type_cd                  -- 处置类型代码
       ,disp_way_cd                   -- 处置方式代码
       ,tran_type_cd                  -- 转让类型代码
       ,bal_chag_date                 -- 余额变动日期
       ,bal_tm_ear_lvl5_cls_cd        -- 余额时点年初五级分类代码
       ,bal_tm_lvl5_cls_cd            -- 余额时点五级分类代码
       ,tran_dt                       -- 转让日期
       ,wrt_off_dt                    -- 核销日期
       ,prob_loan_dt                  -- 问题贷款日期
       ,ear_y_pric_bal                -- 年初本金余额 
       ,pric_amt                      -- 本金金额
       ,int_amt                       -- 利息金额
       ,pnlt_amt                      -- 罚息金额
       ,comp_int_amt                  -- 复息金额
       ,fee_amt                       -- 费用金额
       ,open_acct_org_id              -- 开户机构编号
       ,mgmt_org_id                   -- 管理机构编号
       ,acct_instit_id                -- 账务机构编号
       ,job_cd                        -- 任务代码
       ,etl_timestamp                 -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                                        -- 数据日期
       ,t3.lp_id                                                                                  -- 法人编号
       ,t1.dubil_id                                                                               -- 借据编号
       ,t2.cust_id                                                                                -- 客户编号
       ,t2.prod_id                                                                                -- 标准产品编号
       ,'04'                                                                                      -- 业务条线代码
       ,case when t1.data_src = '核销明细' then '01' else '' end                                  -- 处置类型代码 (核销、问题)
       ,case when t1.data_src = '核销明细' then '02' 
             when t1.data_src = '还款明细' then '04' else '' end                                  -- 处置方式代码(01转让、02呆账、03差额、04余额变动)
       ,' ' 	                                                                                  -- 转让类型代码(单户、批量)
       ,t1.repay_dt                                                                               -- 余额变动日期
       ,nvl(trim(t3.loan_level5_cls_cd), '99')                                                    -- 余额时点年初五级分类代码
       ,nvl(trim(t2.loan_level5_cls_cd), '99')                                                    -- 余额时点五级分类代码
       ,null  --转让日期
       ,t1.repay_dt                                                                               -- 核销日期
       ,null                                                                                      -- 问题贷款日期
       ,t3.currt_bal                                                                              -- 年初本金余额 
       ,t1.currt_repay_pric                                                                       -- 本金金额
       ,t1.curr_repay_int                                                                         -- 利息金额
       ,t1.currt_repay_pnlt                                                                       -- 罚息金额
       ,0                                                                                         -- 复息金额
       ,t1.currt_repay_fee                                                                        -- 费用金额
       ,t2.org_id                                                                                 -- 开户机构编号
       ,t2.org_id                                                                                 -- 管理机构编号
       ,t2.org_id                                                                                 -- 账务机构编号
       ,'lhwd'                                                                                    -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                           -- 处理日期
  from (select dubil_id as dubil_id
               ,currt_repay_pric currt_repay_pric
               ,curr_repay_int curr_repay_int
               ,currt_repay_pnlt currt_repay_pnlt
               ,currt_repay_fee currt_repay_fee
               ,repay_dt as repay_dt
               ,'还款明细'  as data_src
               ,prod_id as prod_id
		 from ${icl_schema}.cmm_unite_wl_repay_dtl t
		 where repay_dt = to_date('${batch_date}', 'yyyymmdd') -1
		   and etl_dt = to_date('${batch_date}', 'yyyymmdd') -1
		 union all
		select  t4.dubil_id  as dubil_id
               ,t4.actl_wrtoff_loan_pric as currt_repay_pric
               ,0 as curr_repay_int
               ,0 as currt_repay_pnlt
               ,0 as currt_repay_fee
               ,t4.fir_wrt_off_dt as repay_dt
               ,'核销明细'  as data_src
               ,t4.std_prod_id as prod_id
         from ${icl_schema}.cmm_unite_wl_wrt_off_info t4    --贷款核销信息
         where t4.fir_wrt_off_dt = to_date('${batch_date}', 'yyyymmdd') -1
           and etl_dt = to_date(to_char(sysdate - 2,'yyyymmdd'),'yyyymmdd')
		) t1
 inner join ${icl_schema}.tmp_cmm_loan_bal_chg_info_04 t2 --当前借据状态
   on t1.dubil_id = t2.dubil_id 
 left join ${icl_schema}.cmm_unite_wl_dubil_info t3   --年初
   on t1.dubil_id = t3.dubil_id 
  and t3.etl_Dt = to_date('${year_start}','yyyymmdd') - 2
 where ((t1.data_src = '核销明细')
         or (t1.data_src = '还款明细' and substr(t2.org_id,1,3) <> '898' and t2.loan_level5_cls_cd in ('30','40','50'))
	   )

;
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_loan_bal_chg_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_loan_bal_chg_info_ex;

-- 3.1 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_loan_bal_chg_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
