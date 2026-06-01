/*
Purpose:    共性加工层-电子渠道交易明细，数据来源手机银行TBPS、MBSS
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_elec_chn_tran_dtl_change
Createdate: 20200424
Logs:	      20240314 饶雅 新增脚本用于更新渠道字段
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
--drop table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_03_1 purge;
commit;




-- 1.5 update data to target table
whenever sqlerror exit sql.sqlcode;
merge into ${icl_schema}.cmm_elec_chn_tran_dtl t1
using (select chn_id,flow_num,tran_dt from ${iml_schema}.evt_os_invest_finc_bus_flow 
       where trim(user_seq_id) is null
       and trim(tran_chn_cd) not in ('TBP','-')
       and tran_dt >= to_date('20240101','yyyymmdd')
       and job_cd = 'osbsi1')t2
on (t1.tran_flow_num =t2.flow_num and t1.tran_dt=t2.tran_dt and t1.olbk_tran_src_cd='08')
when matched then update set t1.chn_cd =t2.chn_id;
commit;

-- 1.5 update data to target table
whenever sqlerror exit sql.sqlcode;
merge into ${icl_schema}.cmm_elec_chn_tran_dtl t1
using (select chn_id,flow_num,tran_dt from ${iml_schema}.evt_onl_bank_tran_flow 
       where trim(user_seq_id) is null
             and job_cd = 'osbsf1'
             and trim(tran_type_code) <> 'BatchTransfer'
             and case when substr(tran_tm, 1, 8) > '19001231' and
                        (substr(tran_tm, 1, 4) >= 1900 and
                        substr(tran_tm, 1, 4) <= 2099) and
                       (substr(tran_tm, 5, 2) >= '01' and
                       substr(tran_tm, 5, 2) <= '12') and
                       substr(tran_tm, 7, 2) <= 31
		                  then to_date(substr(tran_tm, 1, 8), 'yyyymmdd')
                      else to_date('19000101', 'yyyymmdd') end >= to_date('20240101','yyyymmdd'))t2
on (t1.tran_flow_num =t2.flow_num and t1.tran_dt=t2.tran_dt and t1.olbk_tran_src_cd='05')
when matched then update set t1.chn_cd =t2.chn_id;
commit;


-- 1.5 update data to target table
whenever sqlerror exit sql.sqlcode;
merge into ${icl_schema}.cmm_elec_chn_tran_dtl t1
using (select b.chn_id,a.dtl_flow_num,a.tran_dt 
            from ${iml_schema}.evt_ponl_bk_batch_tran_dtl a
            inner join ${iml_schema}.evt_onl_bank_tran_flow b
            on a.onl_bank_tran_flow_num = b.flow_num
           and b.tran_type_code = 'BatchTransfer'
           and a.tran_dt >= to_date('20240101','yyyymmdd')
           and a.job_cd = 'osbsi1'
           and b.job_cd = 'osbsf1'
           and trim(b.user_seq_id) is null
           and case when substr(b.tran_tm, 1, 8) > '19001231' and
                        (substr(b.tran_tm, 1, 4) >= 1900 and
                        substr(b.tran_tm, 1, 4) <= 2099) and
                       (substr(b.tran_tm, 5, 2) >= '01' and
                       substr(b.tran_tm, 5, 2) <= '12') and
                       substr(b.tran_tm, 7, 2) <= 31
		                  then to_date(substr(b.tran_tm, 1, 8), 'yyyymmdd')
                      else to_date('19000101', 'yyyymmdd') end >= to_date('20240101','yyyymmdd'))t2
on (t1.tran_flow_num =t2.dtl_flow_num and t1.olbk_tran_src_cd='06' and t1.tran_dt=t2.tran_dt)
when matched then update set t1.chn_cd =t2.chn_id;
commit;



-- 1.5 update data to target table
whenever sqlerror exit sql.sqlcode;
merge into ${icl_schema}.cmm_elec_chn_tran_dtl t1
using (select chn_id,flow_num,tran_dt from ${iml_schema}.evt_os_priv_serv_bus_flow 
    where trim(user_seq_id) is null
   and tran_dt >= to_date('20240101','yyyymmdd')
   and job_cd = 'osbsi1')t2
on (t1.tran_flow_num =t2.flow_num and t1.tran_dt=t2.tran_dt and t1.olbk_tran_src_cd='07')
when matched then update set t1.chn_cd =t2.chn_id;
commit;


-- 1.5 update data to target table
whenever sqlerror exit sql.sqlcode;
merge into ${icl_schema}.cmm_elec_chn_tran_dtl t1
using (select chn_id,flow_num from ${iml_schema}.evt_ponl_bk_authen_flow 
    where  job_cd = 'osbsf1'
   and case  when substr(TRAN_TM, 1, 8) > '19001231' and
              (substr(TRAN_TM, 1, 4) >= 1900 and
               substr(TRAN_TM, 1, 4) <= 2099) and
              (substr(TRAN_TM, 5, 2) >= '01' and
               substr(TRAN_TM, 5, 2) <= '12') and
              substr(TRAN_TM, 7, 2) <= 31 then
          to_date(substr(TRAN_TM, 1, 8), 'YYYYMMDD')
         else
          to_date('19000101', 'YYYYMMDD')
       end >= to_date('20240101','yyyymmdd'))t2
on (t1.tran_flow_num =t2.flow_num and t1.olbk_tran_src_cd='09')
when matched then update set t1.chn_cd =t2.chn_id;
commit;


