/*
Purpose:    共性加工层-联合存贷款产品分录信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_unite_dl_prod_entry_info
Createdate: 20190814
Logs:       20201209 陈伟峰 新增模型
            20210107 陈伟峰 调整零售联合贷款蚂蚁花呗产品号、产品名逻辑
            20210125 陈伟峰 调整存贷款组（第五组、第六组），增加过滤条件cbss_kns_tran.servtp IN ('CNT', 'LNT')
            20210616 陈伟峰 调整第六组核心贷款内部户主表逻辑，删掉union all 部分逻辑
            20210719 陈伟峰 调整第五组-核心存款内部户科目过滤逻辑，加入60110199的数据
            20210805 何桐金 调整etl_timestamp处理日期写死逻辑
            20210908 陈伟峰 调整第五组-核心存款内部户科目过滤逻辑，删除60110199的数据
            20210915 陈伟峰 调整核心贷款一组数据，增加科目('60110151', '60110152')
            20211012 陈伟峰 调整联合存款部分【标准产品编号、产品名称】加工逻辑，根据产品编号判断
            20211011 陈伟峰 增加同业手工台账部分数据
            20220718 李森辉 1、调整第一组【零售联合网贷】的取数源，由原零售信贷调整为新综合信贷系统
                            2、删除第四、五、六组映射
            20220722 李森辉 1、调整第二组、第三组的映射；
            20221209 陈伟峰 调整第五组【核心存贷款补账分录】，增加科目6421
			20230615 陈伟峰 调整tgls_loan_busi_h表取数逻辑，增加tgls_loan_busi表数据，用于支持月批
			20230705 翟若平 调整第二组【微粒贷】的字段【当日发生额】的加工口径
			20231205 徐子豪 经调研,因核算中台tgls_gla_vchr_h月末数据调账前存在当前表,M层表已对数据进行整合,故调整从M层表统计数据。
            20250306 陈伟峰 新增票据调账数据
            20250721 陈伟峰 调整存贷款一组逻辑，过滤字节小微贷和微业贷的正常记账流水
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_dl_prod_entry_info drop partition p_20200801;
alter table ${icl_schema}.cmm_unite_dl_prod_entry_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none;
drop table ${icl_schema}.cmm_unite_dl_prod_entry_info_ex purge;
drop table ${icl_schema}.tmp_cmm_unite_dl_prod_entry_info_01 purge;

-- 2.2 insert into ex table
create table ${icl_schema}.cmm_unite_dl_prod_entry_info_ex
nologging
compress -- for query high
as select * from ${icl_schema}.cmm_unite_dl_prod_entry_info where 0=1
;
commit;

 -- 第一组（共四组） 零售联合网贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_dl_prod_entry_info_ex(
       etl_dt           -- 数据日期
       ,lp_id           -- 法人编号
       ,prod_id         -- 产品编号
       ,prod_name       -- 产品名称
       ,std_prod_id     -- 标准产品编号
       ,prod_char       -- 产品性质
       ,subj_id         -- 科目编号
       ,curr_cd         -- 币种代码
       ,acct_instit_id  -- 账务机构编号
       ,td_amt          -- 当日发生额
       ,job_cd          -- 任务代码
       ,etl_timestamp   -- 数据处理时间
)
select to_date('${batch_date}', 'yyyymmdd')                             as etl_dt          -- 数据日期
       ,'9999'                                                          as lp_id           -- 法人编号
       ,t1.prducd                                                       as prod_id         -- 产品编号
       ,t2.sellbl_prod_name                                             as prod_name       -- 产品名称
       ,t1.prducd                                                       as std_prod_id     -- 标准产品编号
       ,'联合贷款'                                                      as prod_char       -- 产品性质
       ,t1.itemcd                                                       as subj_id         -- 科目编号
       ,t1.crcycd                                                       as curr_cd         -- 币种代码
       ,t1.acctbr                                                       as acct_instit_id  -- 账务机构编号
       ,sum(decode(t1.amntcd, 'C', t1.tranam, 'D', 0 - t1.tranam, 0))   as td_amt          -- 当日发生额  
       ,'icmsf1'                                                        as job_cd          -- 任务代码 
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   -- 数据处理时间
  from ${iol_schema}.icms_lhd_accounting_hsfile t1
  left join ${iml_schema}.prd_prod_catlg_h t2
    on t1.prducd = t2.sellbl_prod_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ncbsf1'
 where t1.sourdt = '${batch_date}'
 group by t1.prducd, t2.sellbl_prod_name, t1.itemcd, t1.crcycd, t1.acctbr
;
commit;

-- 第二组（共四组）微粒贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_dl_prod_entry_info_ex(
       etl_dt           -- 数据日期
       ,lp_id           -- 法人编号
       ,prod_id         -- 产品编号
       ,prod_name       -- 产品名称
       ,std_prod_id     -- 标准产品编号
       ,prod_char       -- 产品性质
       ,subj_id         -- 科目编号
       ,curr_cd         -- 币种代码
       ,acct_instit_id  -- 账务机构编号
       ,td_amt          -- 当日发生额
       ,job_cd          -- 任务代码
       ,etl_timestamp   -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd') as etl_dt            -- 数据日期
       ,'9999'                             as lp_id             -- 法人编号
       ,'202010100006'                     as prod_id           -- 产品编号
       ,'微粒贷'                           as prod_name         -- 产品名称
       ,'202010100006'                     as std_prod_id       -- 标准产品编号
       ,'联合贷款'                         as prod_char         -- 产品性质
       ,t1.itemcd                          as subj_id           -- 科目编号
       ,t1.crcycd                          as curr_cd           -- 币种代码
       ,t1.acctbr                          as acct_instit_id    -- 账务机构编号
       ,(sum((case when (t1.amntcd = 'C' and t1.chrex4 = '0') then t1.tranam
                     when (t1.amntcd = 'C' and t1.chrex4 = '1') then - t1.tranam
                     else 0
                end)-
             (case when (t1.amntcd = 'D' and t1.chrex4 = '0') then t1.tranam
                     when (t1.amntcd = 'D' and t1.chrex4 = '1') then - t1.tranam
                     else 0
                end)
            ))                      as td_amt                 -- 当日发生额
       ,'mpcsf1'                                 as job_cd    -- 任务代码 
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')-- 数据处理时间
 from ${iol_schema}.mpcs_a0n_hx_subject_flow t1
where t1.sourdt = '${batch_date}'
group by t1.itemcd, t1.crcycd,t1.acctbr
;
commit;

-- 第三组（共四组）微众存款
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_dl_prod_entry_info_ex(
       etl_dt           -- 数据日期
       ,lp_id           -- 法人编号
       ,prod_id         -- 产品编号
       ,prod_name       -- 产品名称
       ,std_prod_id     -- 标准产品编号
       ,prod_char       -- 产品性质
       ,subj_id         -- 科目编号
       ,curr_cd         -- 币种代码
       ,acct_instit_id  -- 账务机构编号
       ,td_amt          -- 当日发生额
       ,job_cd          -- 任务代码
       ,etl_timestamp   -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd') as etl_dt          -- 数据日期
       ,'9999'                             as lp_id           -- 法人编号
       ,t1.assis1                          as prod_id         -- 产品编号
       ,t2.sellbl_prod_name                as prod_name       -- 产品名称
       ,t1.assis1                          as std_prod_id     -- 标准产品编号
       ,'联合存款'                         as prod_char       -- 产品性质
       ,t3.itemcd                          as subj_id         -- 科目编号
       ,t1.crcycd                          as curr_cd         -- 币种代码
       ,t1.acctbr                          as acct_instit_id  -- 账务机构编号
       ,sum(t1.tranam)                     as td_amt          -- 当日发生额
       ,'ifcsf1'                           as job_cd          -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')-- 处理日期
  from ${iol_schema}.ifcs_tgls_prod_acct_tran_dtl t1
  left join ${iml_schema}.prd_prod_catlg_h t2
    on t1.assis1 = t2.sellbl_prod_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ncbsf1'
  left join (select sdp.prodp1
                    ,sd.trprcd
                    ,sd.itemcd
               from ${iol_schema}.tgls_sys_dtit sd
               left join ${iol_schema}.tgls_sys_dtit_map sdp
                 on sd.typecd = sdp.dtitcd
                and sd.stacid = sdp.stacid
                and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
              where sd.module = 'IFSX'
                and sd.stacid = 2
                and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')) t3
    on substr(t1.assis1,1, 7) = t3.prodp1
   and t1.trprcd = t3.trprcd
 where t1.trandt = '${batch_date}'
 group by t1.assis1, t2.sellbl_prod_name, t3.itemcd, t1.crcycd, t1.acctbr
;
commit;

-- 第四组（共四组）同业手工台账
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_dl_prod_entry_info_ex(
       etl_dt           -- 数据日期
       ,lp_id           -- 法人编号
       ,prod_id         -- 产品编号
       ,prod_name       -- 产品名称
       ,std_prod_id     -- 标准产品编号
       ,prod_char       -- 产品性质
       ,subj_id         -- 科目编号
       ,curr_cd         -- 币种代码
       ,acct_instit_id  -- 账务机构编号
       ,td_amt          -- 当日发生额
       ,job_cd          -- 任务代码
       ,etl_timestamp   -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')  as etl_dt                    -- 数据日期
       ,t1.lp_id                            as lp_id                     -- 法人编号
       ,t1.rec_id                           as prod_id                   -- 产品编号
       ,'同业手工台账'                      as prod_name                 -- 产品名称
       ,''                                  as std_prod_id               -- 标准产品编号
       ,'同业台账'                          as prod_char                 -- 产品性质
       ,t2.subj_id                          as subj_id                   -- 科目编号
       ,t2.curr_cd                          as curr_cd                   -- 币种代码
       ,t2.bus_org_id                       as acct_instit_id            -- 账务机构编号
       ,sum(t2.entry_amt)                   as td_amt                    -- 当日发生额
       ,t1.job_cd                           as job_cd                    -- 任务代码 
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.evt_ibank_manual_entry_evt t1
 inner join ${iml_schema}.evt_ibank_acct_ety_evt t2
    on t1.entry_flow_num = t2.entry_flow_num
   and t2.job_cd = 'ibmsi1'
 where t1.entry_dt = to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='ibmsi1'
   and t1.entry_status_cd = '03'
 group by t1.lp_id,t1.rec_id,t2.subj_id,t2.curr_cd,t2.bus_org_id,t1.job_cd
;
commit;

-- 第五组（共五组）核算中台手工账记录
-- 获取已经存在存贷款账户的流水
create table ${icl_schema}.tmp_cmm_unite_dl_prod_entry_info_01
nologging
compress ${option_switch} for query high
as 
select t.transq, t.assis1
  from ${iol_schema}.tgls_loan_busi_h t
  left join ${iml_schema}.agt_loan_acct_info_h t1
    on t.chrexj = t1.loan_num || t1.distr_flow_num
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='ncbsf1'
   and t1.auto_revs_flg <> '1'
 where t.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t.trandt = '${batch_date}'
   and t1.loan_num is not null
 union all
select t.transq, t.assis1
  from ${iol_schema}.tgls_loan_busi t
  left join ${iml_schema}.agt_loan_acct_info_h t1
    on t.chrexj = t1.loan_num || t1.distr_flow_num
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='ncbsf1'
   and t1.auto_revs_flg <> '1'
 where t.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t.trandt = '${batch_date}'
   and t.stacid = 2
   and t1.loan_num is not null
   and not exists (select 1 from ${iol_schema}.tgls_loan_busi_h tt 
                    where tt.transq=t.transq 
                     and tt.trandt=t.trandt 
                     and tt.bsnssq=t.bsnssq 
                     and tt.serino=t.serino
                     and tt.stacid = 1
                     and tt.trandt = '${batch_date}') 
 union all
select t.transq, t.assis1
  from ${iol_schema}.tgls_loan_busi_h t
  left join ${iol_schema}.ncbs_rb_acct t2
    on t.acctno = t2.base_acct_no || '_' || t2.acct_seq_no
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t.trandt = '${batch_date}'
   and t2.base_acct_no is not null
 union all
select t.transq, t.assis1
  from ${iol_schema}.tgls_loan_busi t
  left join ${iol_schema}.ncbs_rb_acct t2
    on t.acctno = t2.base_acct_no || '_' || t2.acct_seq_no
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t.trandt = '${batch_date}'
   and t.stacid = 2
   and t2.base_acct_no is not null
   and not exists (select 1 from ${iol_schema}.tgls_loan_busi_h tt 
                    where tt.transq=t.transq 
                     and tt.trandt=t.trandt 
                     and tt.bsnssq=t.bsnssq 
                     and tt.serino=t.serino
                     and tt.stacid = 1
                     and tt.trandt = '${batch_date}')  
 union all
select t.transq, t.assis1
  from ${iol_schema}.tgls_loan_busi_h t
  left join ${iol_schema}.ncbs_cl_ul_acct t1
    on t.chrexj = t1.loan_no || t1.dd_no
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t.trandt = '${batch_date}'
   and t1.loan_no is not null
 union all
select t.transq, t.assis1
  from ${iol_schema}.tgls_loan_busi t
  left join ${iol_schema}.ncbs_cl_ul_acct t1
    on t.chrexj = t1.loan_no || t1.dd_no
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t.trandt = '${batch_date}'
   and t.stacid = 2
   and t1.loan_no is not null
   and not exists (select 1 from ${iol_schema}.tgls_loan_busi_h tt 
                    where tt.transq=t.transq 
                     and tt.trandt=t.trandt 
                     and tt.bsnssq=t.bsnssq 
                     and tt.serino=t.serino
                     and tt.stacid = 1
                     and tt.trandt = '${batch_date}') 
;
commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_dl_prod_entry_info_ex(
       etl_dt           -- 数据日期
       ,lp_id           -- 法人编号
       ,prod_id         -- 产品编号
       ,prod_name       -- 产品名称
       ,std_prod_id     -- 标准产品编号
       ,prod_char       -- 产品性质
       ,subj_id         -- 科目编号
       ,curr_cd         -- 币种代码
       ,acct_instit_id  -- 账务机构编号
       ,td_amt          -- 当日发生额
       ,job_cd          -- 任务代码
       ,etl_timestamp   -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd') as etl_dt -- 数据日期
       ,'9999' as lp_id                              -- 法人编号
       ,t.sellbl_prod_id as prod_id
       ,t2.prod_descb as prod_name
       ,t.sellbl_prod_id as std_prod_id
       ,'存贷款补账' as prod_char
       ,t.subj_id as subj_id
       ,t.curr_cd as curr_cd
       ,t.fin_org_id as acct_instit_id
       ,sum(t.tran_amt) as td_amt
       ,'tglsi1' as job_cd                              -- 任务代码 
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- 处理日期
  from ${iml_schema}.evt_accti_midgrod_acct_ety t
  left join ${iml_schema}.prd_prod_catlg_h t2
    on t.sellbl_prod_id = t2.sellbl_prod_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ncbsf1'
 where t.tran_dt = to_date('${batch_date}','yyyymmdd')
   and substr(t.subj_id, 1, 4) in ('6411', '6011','6421')
   and t.sob_id = '1'
   and t.bus_sys_id = 'NCBS'
   and t.job_cd = 'tglsi1'
   and not exists (select 1 from ${icl_schema}.tmp_cmm_unite_dl_prod_entry_info_01 t1 where t.sorc_sys_flow_num = t1.transq and t.sellbl_prod_id = t1.assis1)
 group by t.fin_org_id, t.curr_cd, t.subj_id, t.sellbl_prod_id, t2.prod_descb;
commit;

-- 第七组（共七组）票据系统手工账记录
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_dl_prod_entry_info_ex(
       etl_dt           -- 数据日期
       ,lp_id           -- 法人编号
       ,prod_id         -- 产品编号
       ,prod_name       -- 产品名称
       ,std_prod_id     -- 标准产品编号
       ,prod_char       -- 产品性质
       ,subj_id         -- 科目编号
       ,curr_cd         -- 币种代码
       ,acct_instit_id  -- 账务机构编号
       ,td_amt          -- 当日发生额
       ,job_cd          -- 任务代码
       ,etl_timestamp   -- 数据处理时间
)
select 
       to_date('${batch_date}','yyyymmdd') as etl_dt -- 数据日期
       ,'9999' as lp_id                              -- 法人编号
       ,t2.prod_code as prod_id
       ,t2.prod_name as prod_name
       ,t2.prod_code as std_prod_id
       ,'票据调账' as prod_char
       ,t3.subj_id as subj_id
       ,'CNY' as curr_cd
       ,t1.brchcd as acct_instit_id
       ,sum(t1.tranam) as td_amt
       ,'bdmsf1' as job_cd                              -- 任务代码 
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- 处理日期
from ${iol_schema}.bdms_handmade_balance_contract  t1
left join ${iol_schema}.bdms_meta_deposit_define t2 
on t1.prcscd = t2.product_no
left join ${iml_schema}.evt_accti_midgrod_acct_ety t3 
on t1.bsnssq=t3.ova_flow_num
and to_date(t1.trandt,'yyyymmdd')=t3.tran_dt
and substr(t3.subj_id, 1, 4) in ('6411', '6011','6421')
and t3.etl_dt =to_date('${batch_date}','yyyymmdd')
and t3.sob_id='1'
and t3.bus_sys_id='BDMX'
where t1.balance_flag='01' 
and t1.trprcd in ('BDMX002','BDMX005', 'TYJE005', 'TYJE004')
and t1.trandt ='${batch_date}'
and t1.etl_dt =to_date('${batch_date}','yyyymmdd')
group by t2.prod_code,t2.prod_name,t3.subj_id,t1.brchcd;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_dl_prod_entry_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_dl_prod_entry_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_unite_dl_prod_entry_info_ex purge;


-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_dl_prod_entry_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);