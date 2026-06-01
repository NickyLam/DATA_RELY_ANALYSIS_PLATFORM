/*
Purpose:    共性加工层-存款账户交易明细补充信息:包括所有行内存款账户的金融交易明细，数据来源于新核心系统。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_dep_acct_tran_dtl_attach_info
Createdate: 20200424
Logs:       20240228 陈伟峰 新增模型
            20240314 陈伟峰 调整内部户交易对手账户名称逻辑，不使用科目名称，改用机构名称
            20240605 陈伟峰 调整票据交易对手信息逻辑，去掉DQ存息过滤
                            调整国结交易对手信息，增加对pty_acct_num进行ltrim去0操作
                            调整存息、转账收费、增加tgls_gla_vchr取数
                            调整久悬户激活对手信息，增加交易类型2201转久悬，增加tgls_gla_vchr取数
            20240722 陈伟峰 调整国结交易对手信息
            20240828 陈伟峰 调整字段【交易时间戳TRAN_TIMESTAMP】为优先取核心【EXTRA_TRAN_TIMESTAMP反洗钱加工时间戳】，后取核心【ORIG_TRAN_TIMESTAMP原始时间戳】
            20241031 陈伟峰 调整临时表字段cntpty_acct_name、cntpty_open_bank_name长度为varchar2(1000)
            20241230 陈伟峰 新增字段【附言】
		      	20250516 陈  凭 新增字段【离境退税交易标志】
            20251121 陈伟峰 调整【离境退税交易标志】加工逻辑，添加内部户账户范围640000032113、610001936927
            20251216 陈伟峰 新增字段【交易备注TRAN_REMARK】
			      20260407 何俊良 临时表创建规则调整
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


-- 1.2 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01 purge;
drop table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_02 purge;
drop table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_03 purge;
drop table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 purge;
drop table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_05 purge;

-- 1.3 insert data to tmp table
--交易对手临时表
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num               varchar2(4000)    --交易流水号
       ,tran_dt                    date            --交易日期
       ,acct_bill_flow_num         varchar2(4000)    --账单流水号
       ,src_tran_flow_num          varchar2(4000)    --源交易流水号
       ,src_seq_no                 varchar2(4000)    --源交易序号
       ,cntpty_acct_id             varchar2(4000)    --交易对手账户编号
       ,cntpty_acct_name           varchar2(4000)   --交易对手账户名称
       ,cntpty_open_bank_id        varchar2(4000)    --交易对手账户开户行编号
       ,cntpty_acct_open_bank_cd   varchar2(4000)    --交易对手账户开户行代码
       ,cntpty_open_bank_name      varchar2(4000)   --交易对手账户开户行名称
       ,cntpty_subj_id             varchar2(4000)    --交易对手科目编号
       ,cntpty_subj_name           varchar2(4000)   --交易对手科目名称
       ,src_sys_id                 varchar2(4000)    --系统来源标识
)
nologging
compress ${option_switch} for query high
;


--现转标志交易临时表
create table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04
as
 select  t1.tran_ref_no                           --交易流水号
         ,t1.tran_dt                              --交易日期
         ,t1.tran_flow_num                        --账单流水号
  from ${iml_schema}.evt_dep_fin_tran_flow T1 --存款账户交易明细
  left join ${iml_schema}.ref_tran_code_para t2
    on t1.tran_cd = t2.tran_code
   and t2.bus_cls_cd = 'RB'
   and t2.job_cd ='ncbsf1'
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.cbss_kns_extd t3
    on t1.tran_ref_no = t3.trandt||t3.transq
   and t3.dttrcd like 'cs%'
 where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
   and (case when t1.tran_dt <= to_date('20230501', 'yyyymmdd') and t1.tran_cd like 'C%' then '1' --现金
             when t1.tran_dt <= to_date('20230501', 'yyyymmdd') and t1.tran_cd like 'T%' then '0' --转账
             when t1.tran_dt <= to_date('20230501', 'yyyymmdd') and substr(t1.tran_cd, 0, 1) not in ('C', 'T') and t3.trandt is not null then '1' --有现金记账(账单)
             when t1.tran_dt <= to_date('20230501', 'yyyymmdd') and substr(t1.tran_cd, 0, 1) not in ('C', 'T') and t3.trantp is not null and t3.trandt is null then  '0' --无现金记账(账单)
             when t1.tran_cd in ('UC01','UC02','UC34','UC35','UC36','UC95','TB01','TB05','TB07','TB13','TB15','TB18','TB19','TB21','TB22'
                                  ,'DC17','DC18','DC19','DC20','DC21','DC22','DC23','DC24') then '1'
             when t2.cash_tran_flg = '1' then '1'
             when t2.cash_tran_flg = '0' then '0'
             when t2.tran_cls_cd = '002' then '0'
             else '-' end) <>'1' --现   --现转标志逻辑
;

--票据系统交易对手信息
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num                  --交易流水号
       ,tran_dt                       --交易日期
       ,acct_bill_flow_num            --账单流水号
       ,src_tran_flow_num             --源交易流水号
       ,src_seq_no                    --源交易序号
       ,cntpty_acct_id                --交易对手账户编号
       ,cntpty_acct_name              --交易对手账户名称
       ,cntpty_acct_open_bank_cd      --交易对手账户开户行代码
       ,cntpty_open_bank_name         --交易对手账户开户行名称
       ,cntpty_subj_id                --交易对手科目编号
       ,cntpty_subj_name              --交易对手科目名称
       ,src_sys_id                    --系统来源标识
)
select  t1.tran_ref_no                as tran_flow_num             --交易流水号
       ,t1.tran_dt                    as tran_dt                   --交易日期
       ,t1.tran_flow_num              as acct_bill_flow_num        --账单流水号
       ,t2.transq                     as src_tran_flow_num         --源系统流水号
       ,t2.serino                     as src_seq_no                --源系统交易序号
       ,t2.cust_acct                  as cntpty_acct_id            --交易对手账号
       ,t2.cust_name                  as cntpty_acct_name          --交易对手名称
       ,t2.cust_bank_no               as cntpty_acct_open_bank_cd  --交易对手行号
       ,t2.cust_bank_name             as cntpty_open_bank_name     --交易对手行名
       ,''                            as cntpty_subj_id            --交易对手科目编号
       ,''                            as cntpty_subj_name          --交易对手科目名称
       ,'BDMS'                        as src_sys_id                --系统来源标识
  from ${iml_schema}.evt_dep_fin_tran_flow t1
 inner join (select t1.*
                    ,row_number() over(partition by bsnssq order by serino desc) as rn
               from ${iol_schema}.bdms_view_trans_opponent_info t1
              where t1.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                and t1.end_dt >to_date('${batch_date}', 'yyyymmdd')) t2
    on t2.bsnssq=t1.ova_flow_num
   and t2.rn=1
 where t1.tran_dt=to_date('${batch_date}', 'yyyymmdd')
   and t1.etl_dt =to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
   and t1.memo_code not in ('IN','DQI') --存息 --票据解付  20240605去掉DQ过滤
   and t1.tran_descb not in ('转账收费'/*,'久悬户激活'*/)
   and t1.tran_descb not like '%费用收入%'
   and t1.tran_descb not like '%费用支出%'
   and t1.tran_cd not like 'FEE%'
   and t1.tran_cd not in ('CK01','DK01','2204','FX64') --现金长短款的和存息类似,久悬户激活，在核算中台中取数,结售汇收益借方
   and t1.tran_cd not in ('5001','FX72','FX67','2201') --MOD BY LIP 20231208 5001贷方利息调整入账(单户结息) FX72 市场平盘收益借方 FX67 市场平盘损失贷方
   and t1.tran_cd not in ('Z099','Z021') --票据业务资金清算往来款-贷记,银承兑付专户-借记
   and exists (select 1 from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 tt
                       where tt.tran_ref_no=t1.tran_ref_no and tt.tran_dt=t1.tran_dt and tt.tran_flow_num=t1.tran_flow_num)
;
commit;


--国结交易对手信息
create table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_05
nologging
compress ${option_switch} for query high
as
  select 
         t.inidattim tx_dt                                                --交易日期
         ,nvl(trim(t.qjls),trim(fe.itfinr)) ticd                          --全局流水号
         ,case when t.inifrm in('BDTSET') then 'D' when t.inifrm in('BMTSET') then 'C' end cr_dr_ind  --借贷方向
         ,o.biz_seq_num                                                   --源系统流水号
         ,o.biz_seq_no                                                    --源系统交易序号
         ,nvl(trim(s3.extkey),s4.extkey) part_bank_code                   --交易对方行代码
         ,nvl(trim(s3.nam),s4.nam) part_bank_name                         --交易对方行名称
         ,nvl(nvl(trim(ss.extact),trim(ss2.extact)),o.tx_cntpty_acct_num) part_acc_no --交易对方账号
         ,nvl(nvl(trim(ss.nam),trim(ss2.nam)),o.tx_cntpty_name) part_acc_name         --交易对方户名
    from ${iol_schema}.isbs_trn t
    left join (select t.inr tinr,b.inr binr,d.inr dinr,m.inr minr,nvl(d2.inr,e.inr) einr,nvl2(d2.inr,'DID','DED') etyp 
                 from ${iol_schema}.isbs_trn t
                 left join ${iol_schema}.isbs_bdd b 
                   on t.objinr=b.inr 
                  and t.objtyp='BDD' 
                  and b.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
                  and b.end_dt >to_date('${batch_date}', 'yyyymmdd')
                 left join ${iol_schema}.isbs_did d 
                   on d.inr=b.pntinr 
                  and b.pnttyp='DID' 
                  and d.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
                  and d.end_dt >to_date('${batch_date}', 'yyyymmdd')
                 left join ${iol_schema}.isbs_bmd m 
                   on t.objinr=m.inr 
                  and t.objtyp='BMD' 
                  and m.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
                  and m.end_dt >to_date('${batch_date}', 'yyyymmdd')
                 left join ${iol_schema}.isbs_ded e 
                   on e.inr=m.pntinr 
                  and m.pnttyp='DED' 
                  and e.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
                  and e.end_dt >to_date('${batch_date}', 'yyyymmdd')
                 left join ${iol_schema}.isbs_did d2 
                   on trim(e.kzref)=trim(d2.ownref) 
                  and  d2.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
                  and d2.end_dt >to_date('${batch_date}', 'yyyymmdd')
                where t.inifrm in('BMTSET','BDTSET') 
                  and t.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
                  and t.end_dt >to_date('${batch_date}', 'yyyymmdd')) tb 
      on tb.tinr=t.inr
    left join ${iol_schema}.isbs_pts ss 
      on ss.objinr=tb.dinr 
     and ss.objtyp='DID' 
     and ss.rol in('BEN')  
     and ss.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
     and ss.end_dt >to_date('${batch_date}', 'yyyymmdd')
    left join ${iol_schema}.isbs_pts ss2 
      on ss2.objinr=tb.einr 
     and ss2.objtyp=tb.etyp 
     and ss2.rol in('APL')  
     and ss2.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
     and ss2.end_dt >to_date('${batch_date}', 'yyyymmdd')
    left join ${iol_schema}.isbs_pts s3 
      on s3.objinr=tb.binr 
     and s3.objtyp='BDD' 
     and s3.rol in('PRB')  
     and s3.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
     and s3.end_dt >to_date('${batch_date}', 'yyyymmdd')
    left join ${iol_schema}.isbs_pts s4 
      on s4.objinr=tb.minr 
     and s4.objtyp='BMD' 
     and s4.rol in('OTH')  
     and s4.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
     and s4.end_dt >to_date('${batch_date}', 'yyyymmdd')
    left join ${iol_schema}.isbs_oppnet o 
      on t.inr=o.trninr 
     and (case when t.inifrm in('BDTSET') then 'D' when t.inifrm in('BMTSET') then 'C' end)= o.tran_type  
     and o.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
     and o.end_dt >to_date('${batch_date}', 'yyyymmdd')
    left join ${iol_schema}.isbs_wfs fs 
      on fs.objinr=t.inr 
     and fs.objtyp='TRN'  
     and fs.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
     and fs.end_dt >to_date('${batch_date}', 'yyyymmdd')
    left join ${iol_schema}.isbs_wfe fe 
      on fe.wfsinr=fs.inr 
     and fe.srv in('SHA','STZ','ACT','JHA')  
     and fe.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
     and fe.end_dt >to_date('${batch_date}', 'yyyymmdd')
   where t.relflg='R' 
     and t.inifrm in('BDTSET','BMTSET')   
     and t.start_dt <=to_date('${batch_date}', 'yyyymmdd') 
     and t.end_dt >to_date('${batch_date}', 'yyyymmdd')
;


--国结系统交易对手信息 第一部分
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num                  --交易流水号
       ,tran_dt                       --交易日期
       ,acct_bill_flow_num            --账单流水号
       ,src_tran_flow_num             --源交易流水号
       ,src_seq_no                    --源交易序号
       ,cntpty_acct_id                --交易对手账户编号
       ,cntpty_acct_name              --交易对手账户名称
       ,cntpty_acct_open_bank_cd      --交易对手账户开户行代码
       ,cntpty_open_bank_name         --交易对手账户开户行名称
       ,cntpty_subj_id                --交易对手科目编号
       ,cntpty_subj_name              --交易对手科目名称
       ,src_sys_id                    --系统来源标识
)
select  t1.tran_ref_no                as tran_flow_num             --交易流水号
       ,t1.tran_dt                    as tran_dt                   --交易日期
       ,t1.tran_flow_num              as acct_bill_flow_num        --账单流水号
       ,t2.biz_seq_num                as src_tran_flow_num         --源系统流水号
       ,t2.biz_seq_no                 as src_seq_no                --源系统交易序号
       ,t2.tx_cntpty_acct_num         as cntpty_acct_id            --交易对手账号
       ,t2.tx_cntpty_name             as cntpty_acct_name          --交易对手名称
       ,t2.cntpty_fin_inst_brac_cd    as cntpty_acct_open_bank_cd  --交易对手行号
       ,t2.cntpty_fin_inst_brac_name  as cntpty_open_bank_name     --交易对手行名
       ,''                            as cntpty_subj_id            --交易对手科目编号
       ,''                            as cntpty_subj_name          --交易对手科目名称
       ,'ISBS'                        as src_sys_id                --系统来源标识
  from ${iml_schema}.evt_dep_fin_tran_flow t1
 inner join ${iol_schema}.isbs_oppnet t2
    on t2.core_tran_flow_num = t1.ova_flow_num    --全局流水号
   and t2.gldate = to_char(t1.tran_dt,'yyyymmdd') --交易时间
   and ltrim(t2.pty_acct_num,'0') = t1.cust_acct_num   --交易账号
   and t2.tran_type = t1.debit_crdt_flg --交易方向
   and t2.biz_ccy = t1.tran_curr_cd        --交易币种
   and t2.biz_amt = t1.tran_amt            --交易金额
   and t2.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt >to_date('${batch_date}', 'yyyymmdd')
 where t1.tran_dt=to_date('${batch_date}', 'yyyymmdd')
   and t1.etl_dt =to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
   and t1.memo_code not in ('IN','DQI','DQ') --存息 --票据解付
   and t1.tran_descb not in ('转账收费'/*,'久悬户激活'*/)
   and t1.tran_descb not like '%费用收入%'
   and t1.tran_descb not like '%费用支出%'
   and t1.tran_cd not like 'FEE%'
   and t1.tran_cd not in ('CK01','DK01','2204','FX64') --现金长短款的和存息类似,久悬户激活，在核算中台中取数,结售汇收益借方
   and t1.tran_cd not in ('5001','FX72','FX67','2201') --MOD BY LIP 20231208 5001贷方利息调整入账(单户结息) FX72 市场平盘收益借方 FX67 市场平盘损失贷方
   and t1.tran_cd not in ('Z099','Z021') --票据业务资金清算往来款-贷记,银承兑付专户-借记
   and exists (select 1 from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 tt
                       where tt.tran_ref_no=t1.tran_ref_no and tt.tran_dt=t1.tran_dt and tt.tran_flow_num=t1.tran_flow_num)
;
commit;



--国结系统交易对手信息 第二部分
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num                  --交易流水号
       ,tran_dt                       --交易日期
       ,acct_bill_flow_num            --账单流水号
       ,src_tran_flow_num             --源交易流水号
       ,src_seq_no                    --源交易序号
       ,cntpty_acct_id                --交易对手账户编号
       ,cntpty_acct_name              --交易对手账户名称
       ,cntpty_acct_open_bank_cd      --交易对手账户开户行代码
       ,cntpty_open_bank_name         --交易对手账户开户行名称
       ,cntpty_subj_id                --交易对手科目编号
       ,cntpty_subj_name              --交易对手科目名称
       ,src_sys_id                    --系统来源标识
)
select  t1.tran_ref_no                as tran_flow_num             --交易流水号
       ,t1.tran_dt                    as tran_dt                   --交易日期
       ,t1.tran_flow_num              as acct_bill_flow_num        --账单流水号
       ,''                            as src_tran_flow_num         --源系统流水号
       ,''                            as src_seq_no                --源系统交易序号
       ,t3.part_acc_no                as cntpty_acct_id            --交易对手账号
       ,t3.part_acc_name              as cntpty_acct_name          --交易对手名称
       ,t3.part_bank_code             as cntpty_acct_open_bank_cd  --交易对手行号
       ,t3.part_bank_name             as cntpty_open_bank_name     --交易对手行名
       ,''                            as cntpty_subj_id            --交易对手科目编号
       ,''                            as cntpty_subj_name          --交易对手科目名称
       ,'ISBS'                        as src_sys_id                --系统来源标识
  from ${iml_schema}.evt_dep_fin_tran_flow t1
 inner join ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_05 t3
    on t3.ticd = (case when t1.tran_dt <to_date('20230501', 'yyyymmdd') then t1.tran_ref_no else t1.ova_flow_num end )    --全局流水号
   and trunc(t3.tx_dt) = trunc(t1.tran_dt)   --交易时间
   and t3.cr_dr_ind = t1.debit_crdt_flg --交易方向
 where t1.tran_dt=to_date('${batch_date}', 'yyyymmdd')
   and t1.etl_dt =to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
   and t1.memo_code not in ('IN','DQI','DQ') --存息 --票据解付
   and t1.tran_descb not in ('转账收费'/*,'久悬户激活'*/)
   and t1.tran_descb not like '%费用收入%'
   and t1.tran_descb not like '%费用支出%'
   and t1.tran_cd not like 'FEE%'
   and t1.tran_cd not in ('CK01','DK01','2204','FX64') --现金长短款的和存息类似,久悬户激活，在核算中台中取数,结售汇收益借方
   and t1.tran_cd not in ('5001','FX72','FX67','2201') --MOD BY LIP 20231208 5001贷方利息调整入账(单户结息) FX72 市场平盘收益借方 FX67 市场平盘损失贷方
   and t1.tran_cd not in ('Z099','Z021') --票据业务资金清算往来款-贷记,银承兑付专户-借记
   and exists (select 1 from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 tt
                       where tt.tran_ref_no=t1.tran_ref_no and tt.tran_dt=t1.tran_dt and tt.tran_flow_num=t1.tran_flow_num)
;
commit;


--资管系统交易对手信息
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num                  --交易流水号
       ,tran_dt                       --交易日期
       ,acct_bill_flow_num            --账单流水号
       ,src_tran_flow_num             --源交易流水号
       ,src_seq_no                    --源交易序号
       ,cntpty_acct_id                --交易对手账户编号
       ,cntpty_acct_name              --交易对手账户名称
       ,cntpty_acct_open_bank_cd      --交易对手账户开户行代码
       ,cntpty_open_bank_name         --交易对手账户开户行名称
       ,cntpty_subj_id                --交易对手科目编号
       ,cntpty_subj_name              --交易对手科目名称
       ,src_sys_id                    --系统来源标识
)
select  t1.tran_ref_no                as tran_flow_num             --交易流水号
       ,t1.tran_dt                    as tran_dt                   --交易日期
       ,t1.tran_flow_num              as acct_bill_flow_num        --账单流水号
       ,t2.biz_seq_num                as src_tran_flow_num         --源系统流水号
       ,t2.tran_num                   as src_seq_no                --源系统交易序号
       ,t2.tx_cntpty_acct_num         as cntpty_acct_id            --交易对手账号
       ,t2.tx_cntpty_name             as cntpty_acct_name          --交易对手名称
       ,t2.cntpty_fin_inst_brac_cd    as cntpty_acct_open_bank_cd  --交易对手行号
       ,t2.cntpty_fin_inst_brac_name  as cntpty_open_bank_name     --交易对手行名
       ,''                            as cntpty_subj_id            --交易对手科目编号
       ,''                            as cntpty_subj_name          --交易对手科目名称
       ,'FAMS'                        as src_sys_id                --系统来源标识
  from ${iml_schema}.evt_dep_fin_tran_flow t1
 inner join (select zg.*
                   ,row_number() over(partition by zg.core_tran_flow_num order by zg.tran_num desc) as rn
               from ${iol_schema}.fams_fam_tx_cntpty_info zg    --资管系统交易对手信息
            ) t2
    on t2.core_tran_flow_num = t1.ova_flow_num
   and t2.rn = 1
 where t1.tran_dt=to_date('${batch_date}', 'yyyymmdd')
   and t1.etl_dt =to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
   and t1.memo_code not in ('IN','DQI','DQ') --存息 --票据解付
   and t1.tran_descb not in ('转账收费'/*,'久悬户激活'*/)
   and t1.tran_descb not like '%费用收入%'
   and t1.tran_descb not like '%费用支出%'
   and t1.tran_cd not like 'FEE%'
   and t1.tran_cd not in ('CK01','DK01','2204','FX64') --现金长短款的和存息类似,久悬户激活，在核算中台中取数,结售汇收益借方
   and t1.tran_cd not in ('5001','FX72','FX67','2201') --MOD BY LIP 20231208 5001贷方利息调整入账(单户结息) FX72 市场平盘收益借方 FX67 市场平盘损失贷方
   and t1.tran_cd not in ('Z099','Z021') --票据业务资金清算往来款-贷记,银承兑付专户-借记
   and exists (select 1 from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 tt
                       where tt.tran_ref_no=t1.tran_ref_no and tt.tran_dt=t1.tran_dt and tt.tran_flow_num=t1.tran_flow_num)
;
commit;

--同业系统交易对手信息
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num                  --交易流水号
       ,tran_dt                       --交易日期
       ,acct_bill_flow_num            --账单流水号
       ,src_tran_flow_num             --源交易流水号
       ,src_seq_no                    --源交易序号
       ,cntpty_acct_id                --交易对手账户编号
       ,cntpty_acct_name              --交易对手账户名称
       ,cntpty_acct_open_bank_cd      --交易对手账户开户行代码
       ,cntpty_open_bank_name         --交易对手账户开户行名称
       ,cntpty_subj_id                --交易对手科目编号
       ,cntpty_subj_name              --交易对手科目名称
       ,src_sys_id                    --系统来源标识
)
select  t1.tran_ref_no                as tran_flow_num             --交易流水号
       ,t1.tran_dt                    as tran_dt                   --交易日期
       ,t1.tran_flow_num              as acct_bill_flow_num        --账单流水号
       ,t2.flow_no                    as src_tran_flow_num         --源系统流水号
       ,t2.flow_inner_sn              as src_seq_no                --源系统交易序号
       ,t2.party_acct_code            as cntpty_acct_id            --交易对手账号
       ,t2.party_acct_name            as cntpty_acct_name          --交易对手名称
       ,t2.party_bank_code            as cntpty_acct_open_bank_cd  --交易对手行号
       ,t2.party_bank_name            as cntpty_open_bank_name     --交易对手行名
       ,''                            as cntpty_subj_id            --交易对手科目编号
       ,''                            as cntpty_subj_name          --交易对手科目名称
       ,'IBMS'                        as src_sys_id                --系统来源标识
  from ${iml_schema}.evt_dep_fin_tran_flow t1
 inner join (select ty.*
                   ,case when ty.debit_credit_flag = '1' then 'D'  --借
                         when ty.debit_credit_flag = '2' then 'C'  --贷
                         else ty.debit_credit_flag
                    end as debit_crdt_dir_cd
                   ,row_number() over(partition by ty.global_flow_no,ty.entry_date,ty.currency,ty.value,ty.debit_credit_flag order by ty.flow_inner_sn desc) as rn
              from ${iol_schema}.ibms_ttrd_hx_counterparty_registry ty  --同业系统华兴交易对手登记簿
             where ty.start_dt <=to_date('${batch_date}', 'yyyymmdd')
               and ty.end_dt >to_date('${batch_date}', 'yyyymmdd')
               and exists (select 1 
                             from ${iol_schema}.ibms_ttrd_bookkeeping_entry_his book 
                            where ty.entry_id=book.entry_id
                              and ty.entry_date=book.entry_date 
                              and book.is_sending_core=1)   --同业王佳能确认，加上上送核心标志
            ) t2
    on t2.global_flow_no = t1.ova_flow_num    --全局流水号
   and t2.entry_date = to_char(t1.tran_dt,'yyyy-mm-dd') --交易时间
   and t2.currency = t1.tran_curr_cd        --交易币种
   and t2.value = t1.tran_amt            --交易金额
   and t2.debit_crdt_dir_cd = t1.debit_crdt_flg --交易方向
   and t2.rn = 1
 where t1.tran_dt=to_date('${batch_date}', 'yyyymmdd')
   and t1.etl_dt =to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
   and t1.memo_code not in ('IN','DQI','DQ') --存息 --票据解付
   and t1.tran_descb not in ('转账收费'/*,'久悬户激活'*/)
   and t1.tran_descb not like '%费用收入%'
   and t1.tran_descb not like '%费用支出%'
   and t1.tran_cd not like 'FEE%'
   and t1.tran_cd not in ('CK01','DK01','2204','FX64') --现金长短款的和存息类似,久悬户激活，在核算中台中取数,结售汇收益借方
   and t1.tran_cd not in ('5001','FX72','FX67','2201') --MOD BY LIP 20231208 5001贷方利息调整入账(单户结息) FX72 市场平盘收益借方 FX67 市场平盘损失贷方
   and t1.tran_cd not in ('Z099','Z021') --票据业务资金清算往来款-贷记,银承兑付专户-借记
   and exists (select 1 from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 tt
                       where tt.tran_ref_no=t1.tran_ref_no and tt.tran_dt=t1.tran_dt and tt.tran_flow_num=t1.tran_flow_num)
;
commit;

--资金系统(本币&外币)交易对手信息
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num                  --交易流水号
       ,tran_dt                       --交易日期
       ,acct_bill_flow_num            --账单流水号
       ,src_tran_flow_num             --源交易流水号
       ,src_seq_no                    --源交易序号
       ,cntpty_acct_id                --交易对手账户编号
       ,cntpty_acct_name              --交易对手账户名称
       ,cntpty_acct_open_bank_cd      --交易对手账户开户行代码
       ,cntpty_open_bank_name         --交易对手账户开户行名称
       ,cntpty_subj_id                --交易对手科目编号
       ,cntpty_subj_name              --交易对手科目名称
       ,src_sys_id                    --系统来源标识
)
select  t1.tran_ref_no                as tran_flow_num             --交易流水号
       ,t1.tran_dt                    as tran_dt                   --交易日期
       ,t1.tran_flow_num              as acct_bill_flow_num        --账单流水号
       ,t2.biz_seq_num                as src_tran_flow_num         --源系统流水号
       ,t2.seq                        as src_seq_no                --源系统交易序号
       ,t2.tx_cntpty_acct_num         as cntpty_acct_id            --交易对手账号
       ,t2.tx_cntpty_name             as cntpty_acct_name          --交易对手名称
       ,t2.cntpty_fin_inst_brac_cd    as cntpty_acct_open_bank_cd  --交易对手行号
       ,t2.cntpty_fin_inst_brac_name  as cntpty_open_bank_name     --交易对手行名
       ,''                            as cntpty_subj_id            --交易对手科目编号
       ,''                            as cntpty_subj_name          --交易对手科目名称
       ,'CTMS'                        as src_sys_id                --系统来源标识
 from ${iml_schema}.evt_dep_fin_tran_flow t1
inner join (select zjbb.core_tran_flow_num
                  ,zjbb.biz_seq_num
                  ,zjbb.seq
                  ,zjbb.tx_cntpty_acct_num
                  ,zjbb.tx_cntpty_name
                  ,zjbb.cntpty_fin_inst_brac_cd
                  ,zjbb.cntpty_fin_inst_brac_name
                  ,row_number() over(partition by zjbb.core_tran_flow_num order by zjbb.seq desc) as rn
              from ${iol_schema}.ctms_vi_tbs_account_cptys_info zjbb --资金系统交易对手_本币
             where zjbb.start_dt <=to_date('${batch_date}', 'yyyymmdd')
               and zjbb.end_dt >to_date('${batch_date}', 'yyyymmdd')
             union all
            select zjwb.core_tran_flow_num
                   ,zjwb.biz_seq_num
                   ,to_char(zjwb.seq)
                   ,zjwb.tx_cntpty_acct_num
                   ,zjwb.tx_cntpty_name
                   ,zjwb.cntpty_fin_inst_brac_cd
                   ,zjwb.cntpty_fin_inst_brac_name
                   ,row_number() over(partition by zjwb.core_tran_flow_num order by zjwb.seq desc) as rn
              from ${iol_schema}.ctms_vi_fbs_account_cptys_info zjwb --资金系统交易对手_外币
             where zjwb.start_dt <=to_date('${batch_date}', 'yyyymmdd')
               and zjwb.end_dt >to_date('${batch_date}', 'yyyymmdd')) t2
   on t2.core_tran_flow_num = t1.ova_flow_num    --全局流水号
  and t2.rn = 1
where t1.tran_dt=to_date('${batch_date}', 'yyyymmdd')
  and t1.etl_dt =to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
  and t1.memo_code not in ('IN','DQI','DQ') --存息 --票据解付
  and t1.tran_descb not in ('转账收费'/*,'久悬户激活'*/)
  and t1.tran_descb not like '%费用收入%'
  and t1.tran_descb not like '%费用支出%'
  and t1.tran_cd not like 'FEE%'
  and t1.tran_cd not in ('CK01','DK01','2204','FX64') --现金长短款的和存息类似,久悬户激活，在核算中台中取数,结售汇收益借方
  and t1.tran_cd not in ('5001','FX72','FX67','2201') --MOD BY LIP 20231208 5001贷方利息调整入账(单户结息) FX72 市场平盘收益借方 FX67 市场平盘损失贷方
  and t1.tran_cd not in ('Z099','Z021') --票据业务资金清算往来款-贷记,银承兑付专户-借记
  and exists (select 1 from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 tt
                      where tt.tran_ref_no=t1.tran_ref_no and tt.tran_dt=t1.tran_dt and tt.tran_flow_num=t1.tran_flow_num)
;
commit;

--核心交易对手登记簿交易对手信息
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num                  --交易流水号
       ,tran_dt                       --交易日期
       ,acct_bill_flow_num            --账单流水号
       ,src_tran_flow_num             --源交易流水号
       ,src_seq_no                    --源交易序号
       ,cntpty_acct_id                --交易对手账户编号
       ,cntpty_acct_name              --交易对手账户名称
       ,cntpty_acct_open_bank_cd      --交易对手账户开户行代码
       ,cntpty_open_bank_name         --交易对手账户开户行名称
       ,cntpty_subj_id                --交易对手科目编号
       ,cntpty_subj_name              --交易对手科目名称
       ,src_sys_id                    --系统来源标识
)
select    t1.tran_ref_no                as tran_flow_num             --交易流水号
         ,t1.tran_dt                    as tran_dt                   --交易日期
         ,t1.tran_flow_num              as acct_bill_flow_num        --账单流水号
         ,t1.tran_ref_no                as src_tran_flow_num         --源系统流水号
         ,t1.tran_flow_num              as src_seq_no                --源系统交易序号
         ,t2.oth_real_base_acct_no      as cntpty_acct_id            --交易对手账号
         ,t2.oth_real_tran_name         as cntpty_acct_name          --交易对手名称
         ,t2.contra_bank_code           as cntpty_acct_open_bank_cd  --交易对手行号
         ,t2.cntpty_fin_inst_brac_name  as cntpty_open_bank_name     --交易对手行名
         ,''                            as cntpty_subj_id            --交易对手科目编号
         ,''                            as cntpty_subj_name          --交易对手科目名称
         ,'NCBS_CP'                     as src_sys_id                --系统来源标识
from ${iml_schema}.evt_dep_fin_tran_flow t1
inner join (select t1.seq_no,
                       t1.reference,
                       t1.channel_seq_no,
                       t1.sub_seq_no,
                       t1.oth_real_base_acct_no,
                       t1.oth_real_tran_name,
                       nvl(trim(t3.bankcode),t3.pbocfinancialcode) as contra_bank_code,
                       nvl(trim(t2.bkname),t3.organcnfullname) as cntpty_fin_inst_brac_name,
                       row_number() over(partition by t1.seq_no,t1.reference,t1.channel_seq_no,t1.sub_seq_no order by t1.tran_amt desc) as rn
                 from ${iol_schema}.ncbs_rb_tran_contra_reg t1
               left join ${iol_schema}.mpcs_a08tbankinfo t2
                   on trim(t1.contra_bank_code) =t2.bkcd
                  and t2.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                  and t2.end_dt >to_date('${batch_date}', 'yyyymmdd')
                 left join ${iol_schema}.uuss_uus_organ t3
                   on trim(t1.contra_bank_code)=t3.organcode
                  and t3.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                  and t3.end_dt >to_date('${batch_date}', 'yyyymmdd')
                 left join ${iol_schema}.uuss_uus_organ t4
                   on t3.zoneno = t4.organcode
                  and t4.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                  and t4.end_dt >to_date('${batch_date}', 'yyyymmdd')
                where t1.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                  and t1.end_dt >to_date('${batch_date}', 'yyyymmdd')) t2
  on t2.seq_no = t1.tran_flow_num
 and t2.reference = t1.tran_ref_no
 and t2.channel_seq_no = t1.ova_flow_num
 and t2.sub_seq_no = t1.core_flow_num
 and t2.rn = 1
where t1.tran_dt=to_date('${batch_date}', 'yyyymmdd')
 and t1.etl_dt =to_date('${batch_date}', 'yyyymmdd')
 and t1.job_cd = 'ncbsi1'
 and t1.memo_code not in ('IN','DQI','DQ') --存息 --票据解付
 and t1.tran_descb not in ('转账收费'/*,'久悬户激活'*/)
 and t1.tran_descb not like '%费用收入%'
 and t1.tran_descb not like '%费用支出%'
 and t1.tran_cd not like 'FEE%'
 and t1.tran_cd not in ('CK01','DK01','2204','FX64') --现金长短款的和存息类似,久悬户激活，在核算中台中取数,结售汇收益借方
 and t1.tran_cd not in ('5001','FX72','FX67','2201') --MOD BY LIP 20231208 5001贷方利息调整入账(单户结息) FX72 市场平盘收益借方 FX67 市场平盘损失贷方
 and t1.tran_cd not in ('Z099','Z021') --票据业务资金清算往来款-贷记,银承兑付专户-借记
 and exists (select 1 from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 tt
                     where tt.tran_ref_no=t1.tran_ref_no and tt.tran_dt=t1.tran_dt and tt.tran_flow_num=t1.tran_flow_num)
;
commit;

--贷款交易对手信息
create table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_02
nologging
compress ${option_switch} for query high
as
select decode(sdp.prodp2,' ','*',sdp.prodp2) as prod_attr_cd,
         coalesce(pc1.prod_type, pc2.prod_type, sdp.prodp1) as sellbl_prod_id,
         max(decode(sd.trprcd, 'NCBS018', sd.itemcd, '')) as normpr_subjid,
         max(decode(sd.trprcd, 'BAL', sd.itemcd, '')) as reacin_subjid,
         max(decode(sd.trprcd, 'NCBS025', sd.itemcd, '')) as veripr_subjid
  from ${iol_schema}.tgls_sys_dtit sd
 inner join ${iol_schema}.tgls_sys_dtit_map sdp
    on sd.typecd = sdp.dtitcd
   and sd.stacid = sdp.stacid
   and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ncbs_mb_prod_catalog pc1
    on sdp.prodp1 = pc1.prod_type
   and pc1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and pc1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ncbs_mb_prod_catalog pc2
    on sdp.prodp1 = pc2.base_prod
   and pc2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and pc2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and trim(pc2.prod_type) is not null
   and pc2.prod_type not in (select distinct pkp.paracd
                                  from ${iol_schema}.tgls_pcmc_knp_para pkp
                                 where pkp.subscd = 'RB'
                                   and pkp.paratp = 'RB_NCBS_LOANP1_ASSIS1'
                                   and pkp.paracd != '%'
                                   and pkp.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                                   and pkp.end_dt > to_date('${batch_date}', 'yyyymmdd'))
 where sd.stacid = 2
   and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and sd.usedtp = '1'
   and sd.module in ('LN','NCBS')
 group by sdp.prodp1,sdp.prodp2, coalesce(pc1.prod_type, pc2.prod_type, sdp.prodp1);


create table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_03
nologging
compress ${option_switch} for query high
as
select t1.REFERENCE
       ,t1.CHANNEL_SEQ_NO
       ,t1.INTERNAL_KEY
       ,nvl(trim(t1.acct_desc),t2.acct_name) as acct_name
       ,nvl(trim(t1.acct_branch),t2.branch) as open_acct_org_id
       ,case when t2.marketing_prod in ('203010400001','602060100002') then t2.cmisloan_no||t2.dd_no
              else t2.cmisloan_no end as dubil_num
       ,(case when t7.asset_acct_status = 'S' then nvl(t3.veripr_subjid,t3_1.veripr_subjid）
       else coalesce(trim(t3.normpr_subjid),trim(t3_1.normpr_subjid), trim(t3.reacin_subjid),trim(t3_1.reacin_subjid))
       end ) as subj_id
       ,nvl(trim(t5.bankcode),t5.pbocfinancialcode) as fin_inst_code
       ,t5.organcnfullname as org_name
       ,row_number() over(partition by t1.REFERENCE,t1.CHANNEL_SEQ_NO order by t1.tran_amt desc) as rn
from ${iol_schema}.ncbs_cl_tran_hist t1
left join ${iol_schema}.ncbs_cl_acct t2
  on t1.internal_key = t2.internal_key
 and t2.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t2.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.ncbs_cl_loan t4
  on t2.loan_no = t4.loan_no
 and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join cmm_dep_acct_tran_dtl_attach_info_02 t3
  on t2.prod_type =t3.sellbl_prod_id
 and t2.prod_type like '4%'
 and nvl(decode(trim(t4.amount_nature),'0000','*',trim(t4.amount_nature)),'*') = nvl(trim(replace(t3.prod_attr_cd,'-',null)),'*')
left join cmm_dep_acct_tran_dtl_attach_info_02 t3_1
  on t2.prod_type =t3_1.sellbl_prod_id
 and t2.prod_type not like '4%'
left join ${iol_schema}.uuss_uus_organ t5
  on t5.organcode = nvl(trim(t1.acct_branch),t2.branch)
 and t5.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t5.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.uuss_uus_organ t6
  on t5.zoneno = t6.organcode
 and t6.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t6.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join (select internal_key
                   ,t1.asset_acct_status
                   ,row_number() over(partition by t1.internal_key order by t1.tran_timestamp desc) rn
              from ${iol_schema}.ncbs_cl_transfer_detail t1
             where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
               and t1.asset_acct_status not in ('C', 'E', 'I') -- p-封包、s-发行、c-撤包、e-发行撤销、b-赎回
               and exists (select 1
                              from ${iol_schema}.ncbs_cl_transfer_contract ctc
                             where t1.asset_contract_seq_no = ctc.asset_contract_seq_no
                               and ctc.asset_contract_status in ('YP', 'YS', 'PB')
                               and ctc.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                               and ctc.end_dt > to_date('${batch_date}', 'yyyymmdd'))) t7
  on t1.internal_key = t7.internal_key
 and t7.rn = 1;

whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num                  --交易流水号
       ,tran_dt                       --交易日期
       ,acct_bill_flow_num            --账单流水号
       ,src_tran_flow_num             --源交易流水号
       ,src_seq_no                    --源交易序号
       ,cntpty_acct_id                --交易对手账户编号
       ,cntpty_acct_name              --交易对手账户名称
       ,cntpty_acct_open_bank_cd      --交易对手账户开户行代码
       ,cntpty_open_bank_name         --交易对手账户开户行名称
       ,cntpty_subj_id                --交易对手科目编号
       ,cntpty_subj_name              --交易对手科目名称
       ,src_sys_id                    --系统来源标识
)
select  t1.tran_ref_no                  as tran_flow_num             --交易流水号
         ,t1.tran_dt                    as tran_dt                   --交易日期
         ,t1.tran_flow_num              as acct_bill_flow_num        --账单流水号
         ,t1.tran_ref_no                as src_tran_flow_num         --源系统流水号
         ,t1.tran_flow_num              as src_seq_no                --源系统交易序号
         ,t2.dubil_num                  as cntpty_acct_id            --交易对手账号
         ,t2.acct_name                  as cntpty_acct_name          --交易对手名称
         ,t2.fin_inst_code              as cntpty_acct_open_bank_cd  --交易对手行号
         ,t2.org_name                   as cntpty_open_bank_name     --交易对手行名
         ,t2.subj_id                    as cntpty_subj_id            --交易对手科目编号
         ,t3.itemna                     as cntpty_subj_name          --交易对手科目名称
         ,'NCBS_DK'                     as src_sys_id                --系统来源标识
from ${iml_schema}.evt_dep_fin_tran_flow t1
inner join cmm_dep_acct_tran_dtl_attach_info_03 t2
  on t2.reference = t1.tran_ref_no
 and t2.channel_seq_no = t1.ova_flow_num
 and t2.rn = 1
left join ${iol_schema}.tgls_com_item t3
  on t3.itemcd =t2.subj_id
 and t3.stacid='1'
 and t3.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t3.end_dt >to_date('${batch_date}', 'yyyymmdd')
where t1.tran_dt=to_date('${batch_date}', 'yyyymmdd')
 and t1.etl_dt =to_date('${batch_date}', 'yyyymmdd')
 and t1.job_cd = 'ncbsi1'
 and t1.memo_code not in ('IN','DQI','DQ') --存息 --票据解付
 and t1.tran_descb not in ('转账收费'/*,'久悬户激活'*/)
 and t1.tran_descb not like '%费用收入%'
 and t1.tran_descb not like '%费用支出%'
 and t1.tran_cd not like 'FEE%'
 and t1.tran_cd not in ('CK01','DK01','2204','FX64') --现金长短款的和存息类似,久悬户激活，在核算中台中取数,结售汇收益借方
 and t1.tran_cd not in ('5001','FX72','FX67','2201') --5001贷方利息调整入账(单户结息) FX72 市场平盘收益借方 FX67 市场平盘损失贷方
 and t1.tran_cd not in ('Z099','Z021') --票据业务资金清算往来款-贷记,银承兑付专户-借记
 and exists (select 1 from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 tt
                     where tt.tran_ref_no=t1.tran_ref_no and tt.tran_dt=t1.tran_dt and tt.tran_flow_num=t1.tran_flow_num)

;
commit;

--内部户手续费对手信息
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num                  --交易流水号
       ,tran_dt                       --交易日期
       ,acct_bill_flow_num            --账单流水号
       ,src_tran_flow_num             --源交易流水号
       ,src_seq_no                    --源交易序号
       ,cntpty_acct_id                --交易对手账户编号
       ,cntpty_acct_name              --交易对手账户名称
       ,cntpty_acct_open_bank_cd      --交易对手账户开户行代码
       ,cntpty_open_bank_name         --交易对手账户开户行名称
       ,cntpty_subj_id                --交易对手科目编号
       ,cntpty_subj_name              --交易对手科目名称
       ,src_sys_id                    --系统来源标识
)
select  t1.tran_ref_no                  as tran_flow_num             --交易流水号
         ,t1.tran_dt                    as tran_dt                   --交易日期
         ,t1.tran_flow_num              as acct_bill_flow_num        --账单流水号
         ,t1.tran_ref_no                as src_tran_flow_num         --源系统流水号
         ,t1.tran_flow_num              as src_seq_no                --源系统交易序号
         ,t1.tran_org_id||nvl(t1.cntpty_cust_acct_num ,t1.real_cntpty_acct_id)||t1.tran_curr_cd         as cntpty_acct_id            --交易对手账号
         ,t3.organcnfullname            as cntpty_acct_name          --交易对手名称
         ,nvl(trim(t3.bankcode),t3.pbocfinancialcode)                                                   as cntpty_acct_open_bank_cd  --交易对手行号
         ,t3.organcnfullname            as cntpty_open_bank_name     --交易对手行名
         ,t2.itemcd                     as cntpty_subj_id            --交易对手科目编号
         ,t2.itemna                     as cntpty_subj_name          --交易对手科目名称
         ,'NCBS_NBH'                    as src_sys_id                --系统来源标识
from ${iml_schema}.evt_dep_fin_tran_flow t1
inner join ${iol_schema}.tgls_com_item t2
  on t2.itemcd = nvl(trim(t1.cntpty_cust_acct_num ),t1.real_cntpty_acct_id)
 and t2.stacid='1'
 and t2.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t2.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.uuss_uus_organ t3
  on trim(t1.tran_org_id)=t3.organcode
 and t3.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t3.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.uuss_uus_organ t4
  on t3.zoneno = t4.organcode
 and t4.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t4.end_dt >to_date('${batch_date}', 'yyyymmdd')
where t1.tran_dt=to_date('${batch_date}', 'yyyymmdd')
 and t1.etl_dt =to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
 and t1.memo_code not in ('IN','DQI','DQ') --存息 --票据解付
 and t1.tran_descb not in ('转账收费'/*,'久悬户激活'*/)
 and t1.tran_descb not like '%费用收入%'
 and t1.tran_descb not like '%费用支出%'
 and t1.tran_cd not like 'FEE%'
 and t1.tran_cd not in ('CK01','DK01','2204','FX64') --现金长短款的和存息类似,久悬户激活，在核算中台中取数,结售汇收益借方
 and t1.tran_cd not in ('5001','FX72','FX67','2201') --5001贷方利息调整入账(单户结息) FX72 市场平盘收益借方 FX67 市场平盘损失贷方
 and t1.tran_cd not in ('Z099','Z021') --票据业务资金清算往来款-贷记,银承兑付专户-借记
 and exists (select 1 from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 tt
                     where tt.tran_ref_no=t1.tran_ref_no and tt.tran_dt=t1.tran_dt and tt.tran_flow_num=t1.tran_flow_num)
;
commit;


--存息
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num                  --交易流水号
       ,tran_dt                       --交易日期
       ,acct_bill_flow_num            --账单流水号
       ,src_tran_flow_num             --源交易流水号
       ,src_seq_no                    --源交易序号
       ,cntpty_acct_id                --交易对手账户编号
       ,cntpty_acct_name              --交易对手账户名称
       ,cntpty_acct_open_bank_cd      --交易对手账户开户行代码
       ,cntpty_open_bank_name         --交易对手账户开户行名称
       ,cntpty_subj_id                --交易对手科目编号
       ,cntpty_subj_name              --交易对手科目名称
       ,src_sys_id                    --系统来源标识
)
select   t1.tran_ref_no                 as tran_flow_num             --交易流水号
         ,t1.tran_dt                    as tran_dt                   --交易日期
         ,t1.tran_flow_num              as acct_bill_flow_num        --账单流水号
         ,t1.tran_ref_no                as src_tran_flow_num         --源系统流水号
         ,t1.tran_flow_num              as src_seq_no                --源系统交易序号
         ,coalesce(trim(t1.real_cntpty_acct_id),trim(t1.cntpty_cust_acct_num),trim(t4.opp_acc))                       as cntpty_acct_id            --交易对手账号
         ,coalesce(trim(t1.real_cntpty_name),trim(t1.cntpty_name),trim(t1.cntpty_acct_name),trim(t4.opp_acc_nm))      as cntpty_acct_name          --交易对手名称
         ,coalesce(trim(t1.real_cntpty_fin_inst_id),trim(t1.cntpty_unionpay_num),trim(t4.opp_pbc_no))                 as cntpty_acct_open_bank_cd  --交易对手行号
         ,coalesce(trim(t1.real_cntpty_fin_inst_name),trim(t1.cntpty_bank_name),trim(t4.opp_bank_nm))                 as cntpty_open_bank_name     --交易对手行名
         ,t4.subj_id                    as cntpty_subj_id            --交易对手科目编号
         ,t4.subj_name                  as cntpty_subj_name          --交易对手科目名称
         ,'NCBS_CX'                     as src_sys_id                --系统来源标识
  from ${iml_schema}.evt_dep_fin_tran_flow T1 --存款账户交易明细
 inner join (select t1.sorc_sys_flow_num
                    ,regexp_substr(t1.src_tran_flow_seq_num,'[0-9]+') as src_tran_flow_seq_num
                    ,t1.ova_flow_num
                    ,decode(t1.debit_crdt_dir_cd,'C','D','D','C') as debit_crdt_dir_cd
                    ,t1.tran_amt
                    ,t1.subj_id
                    ,t1.subj_name
                    ,t1.fin_org_id || t1.subj_id || t1.curr_cd as opp_acc
                    ,t4.organcnfullname as opp_acc_nm
                    ,nvl(trim(t3.bankcode),t3.pbocfinancialcode) as opp_pbc_no
                    ,t4.organcnfullname        as opp_bank_nm
                 from (select t1.sorc_sys_flow_num,t1.src_tran_flow_seq_num,t1.ova_flow_num,t1.debit_crdt_dir_cd,t1.tran_amt,t1.subj_id,t1.subj_name,t1.fin_org_id,t1.curr_cd
                          from ${iml_schema}.evt_accti_midgrod_acct_ety t1
                         where t1.sob_id = '1'
                           and t1.bus_sys_id = 'NCBS'
                           and t1.sellbl_prod_id <> '999999999999'   --1.存期操作过滤
                           and t1.subj_id not in ('22210203','22210202') --排除税收科目 武亚宁提供
                           and t1.tran_dt = to_date('${batch_date}', 'yyyymmdd')
                           and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                       ) t1
                 left join ${iol_schema}.uuss_uus_organ t3
                   on trim(t1.fin_org_id)=t3.organcode
                  and t3.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                  and t3.end_dt >to_date('${batch_date}', 'yyyymmdd')
                 left join ${iol_schema}.uuss_uus_organ t4
                   on t3.zoneno = t4.organcode
                  and t4.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                  and t4.end_dt >to_date('${batch_date}', 'yyyymmdd')
                where 1=1) t4
    on t1.ova_flow_num = t4.ova_flow_num
   and t1.tran_flow_num = t4.src_tran_flow_seq_num
   and t1.tran_ref_no = t4.sorc_sys_flow_num
   and t1.debit_crdt_flg=t4.debit_crdt_dir_cd
 where ((t1.memo_code IN ('IN','DQI') or t1.tran_cd in ('CK01','DK01','5001','2201')) --长款处理交易类型CK01， 短款处理交易类型DK01 5001贷方利息调整入账(单户结息)   --1.存期操作过滤
         )  
   and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
   and exists (select 1 from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 tt
                       where tt.tran_ref_no=t1.tran_ref_no and tt.tran_dt=t1.tran_dt and tt.tran_flow_num=t1.tran_flow_num)
   ;
commit;


--转账收费
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num                  --交易流水号
       ,tran_dt                       --交易日期
       ,acct_bill_flow_num            --账单流水号
       ,src_tran_flow_num             --源交易流水号
       ,src_seq_no                    --源交易序号
       ,cntpty_acct_id                --交易对手账户编号
       ,cntpty_acct_name              --交易对手账户名称
       ,cntpty_acct_open_bank_cd      --交易对手账户开户行代码
       ,cntpty_open_bank_name         --交易对手账户开户行名称
       ,cntpty_subj_id                --交易对手科目编号
       ,cntpty_subj_name              --交易对手科目名称
       ,src_sys_id                    --系统来源标识
)
select   t1.tran_ref_no                 as tran_flow_num             --交易流水号
         ,t1.tran_dt                    as tran_dt                   --交易日期
         ,t1.tran_flow_num              as acct_bill_flow_num        --账单流水号
         ,t1.tran_ref_no                as src_tran_flow_num         --源系统流水号
         ,t1.tran_flow_num              as src_seq_no                --源系统交易序号
         ,coalesce(trim(t1.real_cntpty_acct_id),trim(t1.cntpty_cust_acct_num),trim(t4.opp_acc))                       as cntpty_acct_id            --交易对手账号
         ,coalesce(trim(t1.real_cntpty_name),trim(t1.cntpty_name),trim(t1.cntpty_acct_name),trim(t4.opp_acc_nm))      as cntpty_acct_name          --交易对手名称
         ,coalesce(trim(t1.real_cntpty_fin_inst_id),trim(t1.cntpty_unionpay_num),trim(t4.opp_pbc_no))                 as cntpty_acct_open_bank_cd  --交易对手行号
         ,coalesce(trim(t1.real_cntpty_fin_inst_name),trim(t1.cntpty_bank_name),trim(t4.opp_bank_nm))                 as cntpty_open_bank_name     --交易对手行名
         ,t4.subj_id                     as cntpty_subj_id            --交易对手科目编号
         ,t4.subj_name                     as cntpty_subj_name          --交易对手科目名称
         ,'NCBS_SF'                     as src_sys_id                --系统来源标识
  from ${iml_schema}.evt_dep_fin_tran_flow T1 --存款账户交易明细
 inner join (select t1.sorc_sys_flow_num
                    ,regexp_substr(t1.src_tran_flow_seq_num,'[0-9]+') as src_tran_flow_seq_num
                    ,t1.ova_flow_num
                    ,t1.debit_crdt_dir_cd as debit_crdt_dir_cd
                    ,t1.tran_amt
                    ,t1.subj_id
                    ,t1.subj_name
                    ,t1.fin_org_id || t1.subj_id || t1.curr_cd as opp_acc
                    ,t4.organcnfullname as opp_acc_nm
                    ,nvl(trim(t3.bankcode),t3.pbocfinancialcode) as opp_pbc_no
                    ,t4.organcnfullname        as opp_bank_nm
                    ,row_number() over (partition by t1.sorc_sys_flow_num,t1.debit_crdt_dir_cd order by t1.tran_amt desc) as rn
                 from ( select t1.sorc_sys_flow_num,t1.src_tran_flow_seq_num,t1.ova_flow_num,t1.debit_crdt_dir_cd,t1.tran_amt,t1.subj_id,t1.subj_name,t1.fin_org_id,t1.curr_cd
                           from ${iml_schema}.evt_accti_midgrod_acct_ety t1
                          where t1.sob_id = 1
                            and t1.bus_sys_id = 'NCBS'
                            and (t1.sellbl_prod_id like '5%' or t1.sellbl_prod_id like '9990501%' or t1.sellbl_prod_id like '963%' or t1.subj_id like '6%')   --5开头的产品为收费产品  --提前还款违约金 --票据清算 --损益    --2.转账收费借方对手信息
                            and t1.subj_id not in ('22210203','22210202') --排除税收科目 武亚宁提供
                            and t1.tran_dt = to_date('${batch_date}', 'yyyymmdd')
                            and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                         ) t1
                 left join ${iol_schema}.uuss_uus_organ t3
                   on trim(t1.fin_org_id)=t3.organcode
                  and t3.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                  and t3.end_dt >to_date('${batch_date}', 'yyyymmdd')
                 left join ${iol_schema}.uuss_uus_organ t4
                   on t3.zoneno = t4.organcode
                  and t4.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                  and t4.end_dt >to_date('${batch_date}', 'yyyymmdd')
                where 1=1) t4
    on t1.ova_flow_num = t4.ova_flow_num
--  and t1.seq_no = t4.src_tran_flow_seq_num  --存息、收费交易不适用账单流水号关联
   and t1.tran_ref_no = t4.sorc_sys_flow_num
   and (case when t1.tran_cd = 'FEER' then t1.debit_crdt_flg else decode(t1.debit_crdt_flg,'C','D','C') end)=t4.debit_crdt_dir_cd   --FEER当发生费用冲正时，核算中台流水借贷方向跟核心一致，不需要转换
   and t4.rn=1
 where ((t1.tran_cd like 'FEE%' or t1.tran_cd in ('FX64','FX72','FX67','Z099','Z021') or t1.memo_code in ('DQ')) --FX72 市场平盘收益借方 FX67 市场平盘损失贷方  增加承兑解付的取数  --2.转账收费借方对手信息
         )  
   and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
   and exists (select 1 from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 tt
                       where tt.tran_ref_no=t1.tran_ref_no and tt.tran_dt=t1.tran_dt and tt.tran_flow_num=t1.tran_flow_num)
   ;
commit;



--久悬户激活对手信息
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01(
       tran_flow_num                  --交易流水号
       ,tran_dt                       --交易日期
       ,acct_bill_flow_num            --账单流水号
       ,src_tran_flow_num             --源交易流水号
       ,src_seq_no                    --源交易序号
       ,cntpty_acct_id                --交易对手账户编号
       ,cntpty_acct_name              --交易对手账户名称
       ,cntpty_acct_open_bank_cd      --交易对手账户开户行代码
       ,cntpty_open_bank_name         --交易对手账户开户行名称
       ,cntpty_subj_id                --交易对手科目编号
       ,cntpty_subj_name              --交易对手科目名称
       ,src_sys_id                    --系统来源标识
)
select   t1.tran_ref_no                 as tran_flow_num             --交易流水号
         ,t1.tran_dt                    as tran_dt                   --交易日期
         ,t1.tran_flow_num              as acct_bill_flow_num        --账单流水号
         ,t1.tran_ref_no                as src_tran_flow_num         --源系统流水号
         ,t1.tran_flow_num              as src_seq_no                --源系统交易序号
         ,coalesce(trim(t1.real_cntpty_acct_id),trim(t1.cntpty_cust_acct_num),trim(t4.opp_acc))                       as cntpty_acct_id            --交易对手账号
         ,coalesce(trim(t1.real_cntpty_name),trim(t1.cntpty_name),trim(t1.cntpty_acct_name),trim(t4.opp_acc_nm))      as cntpty_acct_name          --交易对手名称
         ,coalesce(trim(t1.real_cntpty_fin_inst_id),trim(t1.cntpty_unionpay_num),trim(t4.opp_pbc_no))                 as cntpty_acct_open_bank_cd  --交易对手行号
         ,coalesce(trim(t1.real_cntpty_fin_inst_name),trim(t1.cntpty_bank_name),trim(t4.opp_bank_nm))                 as cntpty_open_bank_name     --交易对手行名
         ,t4.subj_id                     as cntpty_subj_id            --交易对手科目编号
         ,t4.subj_name                     as cntpty_subj_name          --交易对手科目名称
         ,'NCBS_JX'                     as src_sys_id                --系统来源标识
  from ${iml_schema}.evt_dep_fin_tran_flow T1 --存款账户交易明细
 inner join (select t1.sorc_sys_flow_num
                    ,regexp_substr(t1.src_tran_flow_seq_num,'[0-9]+') as src_tran_flow_seq_num
                    ,t1.ova_flow_num
                    ,t1.debit_crdt_dir_cd
                    ,t1.tran_amt
                    ,t1.subj_id
                    ,t1.subj_name
                    ,t1.fin_org_id || t1.subj_id || t1.curr_cd as opp_acc
                    ,t4.organcnfullname as opp_acc_nm
                    ,nvl(trim(t3.bankcode),t3.pbocfinancialcode) as opp_pbc_no
                    ,t4.organcnfullname        as opp_bank_nm
                    ,row_number() over (partition by t1.sorc_sys_flow_num,t1.src_tran_flow_seq_num,t1.ova_flow_num order by t1.sellbl_prod_id) as rn
                 from (select t1.sorc_sys_flow_num,t1.src_tran_flow_seq_num,t1.ova_flow_num,t1.debit_crdt_dir_cd,t1.tran_amt,t1.subj_id,t1.fin_org_id,t1.curr_cd,t1.subj_name,t1.sellbl_prod_id
                          from ${iml_schema}.evt_accti_midgrod_acct_ety t1
                         where t1.sob_id = 1
                           and t1.bus_sys_id = 'NCBS'
                           and t1.debit_crdt_dir_cd='D'
                           and t1.tran_dt = to_date('${batch_date}', 'yyyymmdd')
                           and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                    ) t1
                 left join ${iol_schema}.uuss_uus_organ t3
                   on trim(t1.fin_org_id)=t3.organcode
                  and t3.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                  and t3.end_dt >to_date('${batch_date}', 'yyyymmdd')
                 left join ${iol_schema}.uuss_uus_organ t4
                   on t3.zoneno = t4.organcode
                  and t4.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                  and t4.end_dt >to_date('${batch_date}', 'yyyymmdd')
                where 1=1) t4
    on t1.ova_flow_num = t4.ova_flow_num
   and t1.tran_flow_num = t4.src_tran_flow_seq_num
   and t1.tran_ref_no = t4.sorc_sys_flow_num
--   and t1.debit_crdt_flg=t4.debit_crdt_dir_cd
   and t4.rn=1
 where t1.debit_crdt_flg = 'C'  
   and T1.tran_cd in ('2204','2201')   --费用支出和上面的FEE有冲突，注释该部分   --3.久悬户激活对手信息
   and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsi1'
   and exists (select 1 from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_04 tt
                       where tt.tran_ref_no=t1.tran_ref_no and tt.tran_dt=t1.tran_dt and tt.tran_flow_num=t1.tran_flow_num)
   ;
commit;

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info where 0=1;

--第一组（共一组）新核心存款金融交易流水
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_ex(
        etl_dt                                             -- 数据日期
       ,lp_id                                              -- 法人编号
       ,tran_flow_num                                      -- 交易流水号
       ,tran_dt                                            -- 交易日期
       ,tran_timestamp                                     -- 交易时间戳
       ,acct_bill_flow_num                                 -- 账单流水号
       ,ova_flow_num                                       -- 全局流水号
       ,src_tran_flow_num                                  -- 源交易流水号
       ,src_seq_no                                         -- 源交易序号
       ,cust_id                                            -- 客户编号
       ,cust_name                                          -- 客户名称
       ,dep_sub_acct_id                                    -- 存款分户编号
       ,cust_acct_id                                       -- 客户账户编号
       ,sub_acct_id                                        -- 子户编号
       ,tran_memo_descb                                    -- 附言
       ,tran_kind_cd                                       -- 交易类型代码
       ,debit_crdt_dir_cd                                  -- 借贷方向代码
       ,tran_org_id                                        -- 交易机构编号
       ,cntpty_acct_id                                     -- 交易对手账户编号
       ,cntpty_acct_name                                   -- 交易对手账户名称
       ,cntpty_acct_open_bank_cd                           -- 交易对手账户开户行代码
       ,cntpty_open_bank_name                              -- 交易对手账户开户行名称
       ,cntpty_subj_id                                     -- 交易对手科目编号
       ,cntpty_subj_name                                   -- 交易对手科目名称
       ,tran_curr_cd                                       -- 交易币种代码
       ,tran_amt                                           -- 交易金额
	   ,lev_tax_rebate_tran_flg                            -- 离境退税交易标志
       ,src_sys_id                                         -- 系统来源标识
       ,tran_remark                                        -- 交易备注
       ,job_cd                                             -- 任务代码
       ,etl_timestamp                                      -- etl处理时间戳
)                                                          
select to_date('${batch_date}','yyyymmdd')                 -- 数据日期
       ,t1.lp_id                                           -- 法人编号
       ,t1.tran_ref_no                                     -- 交易流水号
       ,t1.tran_dt                                         -- 交易日期
       ,nvl(decode(trim(t4.extra_tran_timestamp),'','',${iml_schema}.timeformat_max(t4.extra_tran_timestamp)),t1.init_tran_tm)    -- 交易时间戳
       ,t1.tran_flow_num                                   -- 账单流水号
       ,t1.ova_flow_num                                    -- 全局流水号
       ,coalesce(trim(t2.src_tran_flow_num),trim(t3.src_tran_flow_num),t1.tran_ref_no)           -- 源交易流水号
       ,coalesce(trim(t2.src_seq_no),trim(t3.src_seq_no))                                        -- 源交易序号
       ,t1.cust_id                                         -- 客户编号
       ,t1.cust_name                                       -- 客户名称
       ,t1.acct_id                                         -- 存款分户编号
       ,t1.cust_acct_num                                   -- 客户账户编号
       ,t1.sub_acct_num                                    -- 子户编号
       ,t1.tran_memo_descb                                 -- 附言
       ,t1.tran_cd                                         -- 交易类型代码
       ,t1.debit_crdt_flg                                  -- 借贷方向代码
       ,t1.tran_org_id                                     -- 交易机构编号
       ,coalesce(trim(t2.cntpty_acct_id),trim(t1.real_cntpty_acct_id),trim(t1.cntpty_cust_acct_num),trim(t3.cntpty_acct_id))                                -- 交易对手账户编号
       ,coalesce(trim(t2.cntpty_acct_name),trim(t1.real_cntpty_name),trim(t1.cntpty_name),trim(t1.cntpty_acct_name),trim(t3.cntpty_acct_name))              -- 交易对手账户名称
       ,coalesce(trim(t2.cntpty_acct_open_bank_cd),trim(t1.real_cntpty_fin_inst_id),trim(t1.cntpty_open_acct_org_id),trim(t3.cntpty_acct_open_bank_cd))     -- 交易对手账户开户行代码
       ,coalesce(trim(t2.cntpty_open_bank_name),trim(t1.real_cntpty_fin_inst_name),trim(t1.cntpty_bank_name),trim(t3.cntpty_open_bank_name))                -- 交易对手账户开户行名称
       ,coalesce(trim(t2.cntpty_subj_id),trim(t3.cntpty_subj_id))                                 -- 交易对手科目编号
       ,coalesce(trim(t2.cntpty_subj_name),trim(t3.cntpty_subj_name))                             -- 交易对手科目名称
       ,t1.tran_curr_cd                                                       -- 交易币种代码
       ,t1.tran_amt                                                           -- 交易金额
	   ,case when (t1.cust_acct_num in ('640000032113','610001936927') 
              or coalesce(trim(t2.cntpty_acct_id),trim(t1.real_cntpty_acct_id),trim(t1.cntpty_cust_acct_num),trim(t3.cntpty_acct_id)) in ('640000032113','610001936927'))
              and t5.ebf_operater = '1' then '1' else '0' end                   -- 离境退税交易标志
       ,coalesce(t2.src_sys_id,t3.src_sys_id,'NCBS_HX')                       -- 系统来源标识
       ,t1.remark                                                                 -- 交易备注 
       ,t1.job_cd
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')
 from ${iml_schema}.evt_dep_fin_tran_flow t1
 left join (select t.*,
 				           row_number() over(partition by t.tran_flow_num,t.tran_dt,t.acct_bill_flow_num order by t.tran_flow_num,t.tran_dt,t.acct_bill_flow_num) as rn
              from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01 t
             where t.src_sys_id in ('NCBS_CP','NCBS_NBH')  --优先取内部户、核心交易对手登记簿，第二取核心交易流水，最后取外围流水交易对手
               and (t.cntpty_acct_id is not null or t.cntpty_acct_name is not null or t.cntpty_acct_open_bank_cd is not null or t.cntpty_open_bank_name is not null)
           ) t2
   on t1.tran_ref_no=t2.tran_flow_num
  and t1.tran_dt=t2.tran_dt
  and t1.tran_flow_num = t2.acct_bill_flow_num
  and t2.rn=1
 left join (select t.*,
 				           row_number() over(partition by t.tran_flow_num,t.tran_dt,t.acct_bill_flow_num order by t.tran_flow_num,t.tran_dt,t.acct_bill_flow_num) as rn
              from ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_01 t
             where t.src_sys_id not in ('NCBS_CP','NCBS_NBH')
               and (t.cntpty_acct_id is not null or t.cntpty_acct_name is not null or t.cntpty_acct_open_bank_cd is not null or t.cntpty_open_bank_name is not null)
           ) t3
   on t1.tran_ref_no=t3.tran_flow_num
  and t1.tran_dt=t3.tran_dt
  and t1.tran_flow_num = t3.acct_bill_flow_num
  and t3.rn=1
 left join ${iol_schema}.ncbs_rb_tran_hist_extra_time t4
   on t1.tran_ref_no=t4.reference  
  and t1.tran_dt=t4.tran_date  
  and t1.tran_flow_num = t4.seq_no
left join (select distinct t2.ctf_src_sendflowno,t1.ebf_operater
             from ${iol_schema}.tbps_cpr_ecomplex_batch_flow t1
             left join ${iol_schema}.tbps_cpr_trade_flow t2 
               on t2.ctf_trade_flowno = t1.ebf_flowno 
			  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
            where t2.ctf_transdate = '${batch_date}'
              and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
		) t5
 on t1.ova_flow_num = t5.ctf_src_sendflowno
where t1.job_cd = 'ncbsi1'
  and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  and t1.tran_dt = to_date('${batch_date}', 'yyyymmdd')
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_dep_acct_tran_dtl_attach_info_ex purge;

-- 3.2 drop temp table
--drop table ${icl_schema}.tmp_cmm_dep_acct_tran_dtl_attach_info_01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_dep_acct_tran_dtl_attach_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
