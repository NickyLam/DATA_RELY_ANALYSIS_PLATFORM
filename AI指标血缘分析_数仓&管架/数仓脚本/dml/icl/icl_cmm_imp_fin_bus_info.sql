/*
purpose:    共性加工层-进口融资业务信息 :
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_imp_fin_bus_info
createdate: 20200628
logs:
  20200629 温旺清 新增模型
  20230713 陈伟峰 新增字段【当日利息支出】
  20231122 徐子豪 新增字段【当期利息发生额、代付行客户编号、代付行客户名称】
  20240223 饶雅 调整【当日利息支出】加工口径，此前的【当日利息支出】实为【当日应计利息】，重新调研口径并调整、调整【应付本金余额】加工口径，修复总分不一致问题、
                新增字段【当日应计利息】TD_ACRU_INT，沿用原【当日利息支出】加工口径
  20240407 陈伟峰 调整字段加工逻辑【代付行客户编号】
  20240920 陈伟峰 新增字段【应计利息科目编号、利息收入科目编号】
  20241121 陈伟峰 调整字段加工逻辑【代付行客户编号】
*/


set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_imp_fin_bus_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_imp_fin_bus_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_imp_fin_bus_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_imp_fin_bus_info_ex purge;
drop table ${icl_schema}.tmp_cmm_imp_fin_bus_info_01 purge;
drop table ${icl_schema}.tmp_cmm_imp_fin_bus_info_02 purge;

-- 1.3 insert data to tmp table
-- 获取科目信息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_imp_fin_bus_info_01
nologging
compress ${option_switch} for query high
as
select coalesce(trim(t3.sellbl_prod_id), t4.sellbl_prod_id,t2.base_prod_id) as prod_id,
       t1.amt_type_cd as amt_type_cd,
       t1.subj_id as pric_subj_id
  from ${iml_schema}.fin_accti_subj_rela_h t1
 inner join ${iml_schema}.fin_accti_prod_rela_info t2
    on t1.accti_id = t2.accti_id
   and t1.sob_id = t2.sob_id
   and t2.etl_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'tglsi1'
  left join ${iml_schema}.prd_prod_catlg_h t3
    on t2.base_prod_id = t3.sellbl_prod_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'ncbsf1'
  left join ${iml_schema}.prd_prod_catlg_h t4
    on t2.base_prod_id = t4.base_prod_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'ncbsf1'
   and trim(t4.sellbl_prod_id) is not null
   and t4.sellbl_prod_id not in (select distinct pkp.paracd
                                  from ${iol_schema}.tgls_pcmc_knp_para pkp
                                 where pkp.subscd = 'RB'
                                   and pkp.paratp = 'RB_NCBS_LOANP1_ASSIS1'
                                   and pkp.paracd != '%'
                                   and pkp.start_dt <= to_date('${batch_date}', 'YYYYMMDD')
                                   and pkp.end_dt > to_date('${batch_date}', 'YYYYMMDD')
                                )
 where t1.sob_id = 2
   and t1.job_cd = 'tglsf1'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.bus_type_cd in ('NCBS', 'LN', 'BDMX', 'IFSX', 'ISBX')
   and t2.base_prod_id not like '5%'  --手续费
   and t1.bus_type_cd = 'ISBX'
   and t1.amt_type_cd in ('PRI', 'TYJE006', 'TYJE007', 'TYJE001', 'ISBX001', 'TYJE007', 'ISBX002','ISBX003', 'ISBX004', 'ISBX006', 'TYJE999', 'BAL');
commit;

-- 1.4 insert data to tmp table
-- 获取利息支出
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_imp_fin_bus_info_02
nologging
compress ${option_switch} for query high
as
select fipkey   --代付行申请人客户编号
       ,bnkref --代付行客户编号
       ,dfbnam --代付行客户名称
       ,acctno                --账号
       ,sum(dixamt) as dixamt --当期利息发生额
       ,sum(td_dixamt) as td_dixamt --当日应付利息
       ,sum(td_int_expns) as td_int_expns --当日利息支出
  from (select max(s.extkey) as fipkey,--代付行申请人客户编号
               max(y.bnkref) as bnkref,--代付行客户编号
               case when max(y.nam1) = ' ' then max(y.nam) else max(y.nam1) end dfbnam,
               h.acctno,h.credattim,
               case when h.trprcd='TYJE002' and h.evetdn = 'ADD' then nvl(sum(h.tranam),0)
                    when h.trprcd='TYJE002' and h.evetdn <> 'ADD' then nvl(-sum(h.tranam),0) 
                    else 0 end dixamt,  --当期利息发生额 
               case when h.trprcd='TYJE002' and h.evetdn = 'ADD' and trunc(h.credattim) = to_date('${batch_date}','yyyymmdd') then nvl(sum(h.tranam),0) 
                    when h.trprcd='TYJE002' and h.evetdn <> 'ADD' and trunc(h.credattim) = to_date('${batch_date}','yyyymmdd') then nvl(-sum(h.tranam),0) 
                    else 0 end  td_dixamt, --当日应计利息
               case when h.trprcd='TYJE005' and h.evetdn = 'ADD' and to_char(h.credattim,'yyyymmdd') = to_date('${batch_date}','yyyymmdd')  then nvl(sum(h.tranam),0) 
                    when h.trprcd='TYJE005' and h.evetdn <> 'ADD' and to_char(h.credattim,'yyyymmdd') = to_date('${batch_date}','yyyymmdd')  then nvl(-sum(h.tranam),0)
                    else 0 end td_int_expns  --当日利息支出 
          from ${iol_schema}.isbs_hszt_bz h
          left join ${iol_schema}.isbs_trn t
            on t.ownref = h.acctno
           and t.inifrm = 'TRTOPN'
           and t.relflg = 'R'
           and t.start_dt <= to_date('${batch_date}','yyyymmdd')
           and t.end_dt > to_date('${batch_date}','yyyymmdd')
          left join ${iol_schema}.isbs_pts s
            on s.objinr = t.objinr
           and s.objtyp = t.objtyp
           and s.rol = 'FIP'
           and s.start_dt <= to_date('${batch_date}','yyyymmdd')
           and s.end_dt > to_date('${batch_date}','yyyymmdd')
          left join ${iol_schema}.isbs_pts s2
            on s2.objinr = t.objinr
           and s2.objtyp = t.objtyp
           and s2.rol = 'DFB'
           and s2.start_dt <= to_date('${batch_date}','yyyymmdd')
           and s2.end_dt > to_date('${batch_date}','yyyymmdd')
          left join ${iol_schema}.isbs_pty y
            on s2.ptyinr = y.inr
           and y.start_dt <= to_date('${batch_date}','yyyymmdd')
           and y.end_dt > to_date('${batch_date}','yyyymmdd')
         where h.assis1 = '401020300001'
           and h.trprcd in ('TYJE002','TYJE005')
           and h.bzsta = 'D'
           and trunc(h.credattim) <= to_date('${batch_date}','yyyymmdd')
         group by h.acctno,h.evetdn,h.trprcd,h.credattim)
 group by acctno,fipkey,dfbnam,bnkref;
commit;

-- 2.1 create temporary table cmm_imp_fin_bus_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_imp_fin_bus_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_imp_fin_bus_info where 0=1;

-- 2.2 insert into data to temporary table cmm_imp_fin_bus_info_ex
--第一组（共一组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_imp_fin_bus_info_ex(
         etl_dt                   --数据日期
        ,lp_id                    --法人编号
        ,agt_id                   --协议编号
        ,bus_id                   --业务编号
        ,dubil_id                 --借据编号
        ,trust_name               --信托收据名称
        ,era_pay_bank_cust_id     --代付行客户编号
        ,era_pay_bank_cust_name   --代付行客户名称
        ,fin_acct_id              --融资账户编号
        ,subj_id                  --科目编号
        ,acru_int_subj_id         --应计利息科目编号
        ,int_income_subj_id       --利息收入科目编号
        ,std_prod_id              --标准产品编号
        ,oper_org_id              --经办机构编号
        ,belong_org_id            --所属机构编号
        ,fin_status_cd            --融资状态代码
        ,trust_create_dt          --信托收据创建日期
        ,trust_open_dt            --信托收据开立日期
        ,trust_exp_dt             --信托收据到期日期
        ,trust_effect_dt          --信托收据生效日期
        ,trust_revo_dt            --信托收据撤销日期
        ,actl_repay_dt            --实际还款日期
        ,negot_days               --押汇天数
        ,actl_negot_days          --实际押汇天数
        ,ovdue_flg                --逾期标志
        ,exec_int_rat             --执行利率
        ,ovdue_int_rat            --逾期利率
        ,int_accr_base_cd         --计息基准代码
        ,int_set_way_cd           --结息方式代码
        ,int_rat_adj_ped_cd       --利率调整周期代码
        ,payfan_int_amt           --代付利息金额
        ,payfan_pnlt_int_rat      --代付罚息利率
        ,payfan_comm_fee_amt      --代付手续费金额
        ,ths_tm_pay_amt           --本次付款金额
        ,curr_cd                  --币种代码
        ,paybl_pric_bal           --应付本金余额
        ,td_acru_int              --当日应计利息
        ,td_int_expns             --当日利息支出
        ,currt_int_amt            --当期利息发生额
        ,job_cd                   -- 任务代码
        ,etl_timestamp            -- 数据处理时间
  )
select to_date('${batch_date}','yyyymmdd')                                      -- 数据日期
       ,'9999'                                                                  -- 法人编号
       ,t1.inr                                                                  --协议编号
       ,t1.ownref                                                               --业务编号
       ,t1.fincod                                                               --借据编号
       ,t1.nam                                                                  --信托收据名称
       ,t8.bnkref                                                               --代付行客户编号
       ,t8.dfbnam                                                               --代付行客户名称
       ,t1.finact                                                               --融资账户编号
       ,t5.pric_subj_id                                                         --科目编号
       ,t10.recvbl_int_paybl_subj_id                                            --应计利息科目编号
       ,t10.int_bal_pay_subj_id                                                 --利息收入科目编号
       ,t5.pdtcod5                                                              --标准产品编号
       ,t3.branch                                                               --经办机构编号
       ,t4.branch                                                               --所属机构编号
       ,t1.ovdflg                                                               --融资状态代码
       ,t1.credat                                                               --信托收据创建日期
       ,t1.issdat                                                               --信托收据开立日期
       ,t1.matdat                                                               --信托收据到期日期
       ,t1.opndat                                                               --信托收据生效日期
       ,t1.clsdat                                                               --信托收据撤销日期
       ,t1.acthkdat                                                             --实际还款日期
       ,t1.tenday                                                               --押汇天数
       ,t1.actfinday                                                            --实际押汇天数
       ,t1.delflg                                                               --逾期标志
       ,t1.actrat                                                               --执行利率
       ,t1.dfrate                                                               --逾期利率
       ,decode(t1.irtmic, '360', 'A/360', '365', 'A/365', t1.irtmic)            --计息基准代码
       ,''--decode(t1.intsetway, '0', '07', '1', '01', '2', '02', t1.intsetway)     --结息方式代码
       ,''--decode(t1.ratadj, '0', '2', '1', '1', t1.ratadj)                        --利率调整周期代码
       ,t1.dfint                                                                --代付利息金额
       ,t1.dfdelrate                                                            --代付罚息利率
       ,t1.dffee                                                                --代付手续费金额
       ,t1.totalamt                                                             --本次付款金额
       ,t2.cur                                                                  --币种代码
       ,case when t9.objinr is not null then t2.amt else 0 end                  --应付本金余额
       ,nvl(t8.td_dixamt,0)                                                     --当日应计利息
       ,nvl(t8.td_int_expns,0)                                                  --当日利息支出
       ,nvl(t8.dixamt,0)                                                        --当期利息发生额
       ,'isbsf1'                                                                -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')         -- 数据处理时间
  from ${iol_schema}.isbs_trd t1
  left join ${iol_schema}.isbs_cbb t2
    on t1.inr = t2.objinr
   and t2.objtyp = 'TRD'
   and t2.cbc = 'OPN'
   and t2.extid = 'AMT1'
   and to_char(t2.enddat, 'yyyymmdd') = '22991231'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.isbs_bch t3
    on t1.bchkeyinr = t3.inr
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.isbs_bch t4
    on t1.branchinr = t4.inr
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select distinct bp.objinr,bp.pdtcod5,t7.pric_subj_id
               from ${iol_schema}.isbs_bus_pdt bp
              inner join ${icl_schema}.tmp_cmm_imp_fin_bus_info_01 t7
                 on bp.pdtcod5 = t7.prod_id
                and bp.amttypcod = t7.amt_type_cd
              where bp.objtyp = 'TRD'
                  --and t7.amt_type_cd is not null
                  ) t5    --同业代付和合作远期结售汇存在同一个产品同一个金额类型有多笔
    on t1.inr = t5.objinr
  left join ${icl_schema}.tmp_cmm_imp_fin_bus_info_02 t8
    on t8.acctno=t1.ownref
  left join ${iol_schema}.isbs_trn t9
    on t1.inr=t9.objinr 
   and t9.objtyp='TRD' 
   and t9.inifrm='TRTOPN' 
   and t9.relflg='R'
   and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.cmm_prod_and_subj_map_rela t10
    on t5.pdtcod5 = t10.sellbl_prod_id
   and t10.bus_type_cd = 'ISBX'
   and t10.etl_dt = to_date('${batch_date}', 'yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_imp_fin_bus_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_imp_fin_bus_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_imp_fin_bus_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_imp_fin_bus_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_imp_fin_bus_info_02 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_imp_fin_bus_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);