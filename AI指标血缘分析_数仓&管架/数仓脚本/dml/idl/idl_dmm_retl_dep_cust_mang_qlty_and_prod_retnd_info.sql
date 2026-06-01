/*
Purpose:    报表集市层-零售贷款日均余额信息表：包括所有的零售贷款日均余额。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info
CreateDate: 20220329
Logs:       20260127 陈伟峰 手工脚本
            20260304 陈伟峰 新增字段【是否所有账户已销户IF_ALLACCT_CLOSE】，调整存款账户开户时间临时表逻辑
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter seesion force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info drop partition p_${retain_day};
alter table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info drop partition p_${batch_date};
alter table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

---- 1.2 create table for exchage and add partition
--whenever sqlerror continue none;
drop table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex purge;
drop table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex01 purge;
drop table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex02 purge;
drop table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex03 purge;
drop table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex04 purge;
drop table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex05 purge;
drop table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex06 purge;
drop table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex07 purge;
drop table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex08 purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex
nologging
compress ${option_switch} for query high
as select * from ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info where 0=1;


-- 2.2 理财交易委托临时表
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex01
nologging
compress ${option_switch} for query high
as
select t1.*,row_number() over(partition by party_id order by tran_dt,tran_tm asc) as rn
  from ${iml_schema}.evt_finc_tran_entr_h t1
 where t1.tran_cd in ('100200')    --交易代码
    and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t1.end_dt > to_date('${batch_date}','yyyymmdd')
    and t1.tran_dt>= to_date('20250101','yyyymmdd')
    and t1.job_cd ='ifmsi1';

-- 2.3 基金交易委托临时表
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex02
nologging
compress ${option_switch} for query high
as
select t1.*,row_number() over(partition by cust_id order by appl_dt,appl_tm asc) as rn
          from ${iml_schema}.evt_consmt_fund_tran_entr_h t1
         where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
            and t1.end_dt > to_date('${batch_date}','yyyymmdd')
            and t1.job_cd ='nfssf1'
            and t1.appl_dt>= to_date('20250101','yyyymmdd');


-- 2.4 保险交易委托临时表
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex03
nologging
compress ${option_switch} for query high
as
select t1.*,row_number() over(partition by cust_id order by tran_dt,seq_num asc) as rn
  from ${iml_schema}.agt_insure_pl t1
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t1.end_dt > to_date('${batch_date}','yyyymmdd')
    and t1.job_cd ='inssf1'
    and t1.tran_dt>= to_date('20250101','yyyymmdd');


-- 2.5 核心存款交易临时表
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex04
nologging
compress ${option_switch} for query high
as
select t1.*,row_number() over(partition by cust_id order by tran_dt,tran_timestamp asc) as rn
  from ${icl_schema}.cmm_dep_acct_tran_dtl t1
 where t1.debit_crdt_dir_cd = 'C'
    and t1.tran_dt>= to_date('20250101','yyyymmdd')
    and t1.etl_dt >= to_date('20250101','yyyymmdd')
    and t1.bus_prod_id not in ('101010100003','101010100002','101010100001','101010100005');

-- 2.6 绩效贷款FTP临时表
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex05
nologging
compress ${option_switch} for query high
as
select a.*,row_number() over(partition by khh order by fkr asc) as rn
  from ${iol_schema}.pams_jxbb_dkftpmx a
  where (a.nrj > 0 or a.nlx <> 0 or a.ljftpzycb <> 0 or yqxyss <> 0 or nvl(fxjqzcje, 0) <> 0)
     and a.etl_dt =to_date('${batch_date}','yyyymmdd')
     and a.tjrq = '${batch_date}'
     and a.kmh not like '13020402%'
     and a.kmh not like '8%'
     and a.kmh not like '3007%'
     and a.kmh is not null
     and a.kmh <> ' '
     and a.fptx in ('2') --分配条线选零售2，公司1，同业3
     and ((a.zhbs = '1'
     and a.xwdkbs = '1'
     and nvl(a.gyljrywbz, '否') = '否') or a.zhbs = '2' or nvl(a.xbcxdbs, '否') = '是')
     and a.cpbh != '201020100061'
     and a.bwbs <> '1'
     and a.kmmc like '%个人%'
     and a.fkr>= '20250101'
     and not exists (select 1
                            from ${iol_schema}.pams_jxbb_dkftpmx tcxwdk
                           where tcxwdk.sfxw = '是'
                             and (tcxwdk.kmh not like '130301%' and  tcxwdk.kmh not like '130503%' and tcxwdk.zhbs <> '2')
                             and tcxwdk.tjrq = '${batch_date}'
                             and tcxwdk.etl_dt =to_date('${batch_date}','yyyymmdd')
                             and a.jjh = tcxwdk.jjh
                            and a.tjrq = tcxwdk.tjrq
                            and a.sfxw = tcxwdk.sfxw
                            and a.kmh = tcxwdk.kmh
                            and a.khjgkhdxdh = tcxwdk.khjgkhdxdh);
 
-- 2.7 数据日期临时表
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex06
nologging
compress ${option_switch} for query high
as
select last_day(add_months(to_date('20250101','yyyymmdd'),level-1)) as data_date  --固定日期，取25年1月以后的所有月末，后面再加一个小于跑批日期的逻辑，把期间的所有月末时点AUM拿出来
  from dual
  connect by level <=99
;

-- 2.8 开户数据临时表
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex07
nologging
compress ${option_switch} for query high
as
select cust_id,open_acct_tm from (
select cust_id,min(open_acct_dt) as open_acct_tm
  from (select
                 t1.cust_id                                                          -- 客户编号
                 ,case when t1.cust_acct_open_acct_dt <> to_date('29991231','yyyymmdd') then t1.cust_acct_open_acct_dt 
                         else to_date('00010101','yyyymmdd') end  as open_acct_dt                         -- 开户日
            from ${iml_schema}.agt_dep_main_acct_info_h t1
          left join (select 
                               t1.cust_acct_num as cust_acct_num              -- 客户账号
                               ,t1.acct_type_cd as acct_type_cd                -- 账户类型代码
                               ,row_number() over(partition by t1.cust_acct_num order by t1.sub_acct_num asc) as rn  -- 排序编号
                          from ${iml_schema}.agt_dep_acct_info_h t1
                         where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
                           and t1.end_dt > to_date('${batch_date}','yyyymmdd')
                           and t1.job_cd = 'ncbsf1') t2
              on t1.cust_acct_num = t2.cust_acct_num
             and t2.rn = 1
            left join (select row_number() over(partition by cust_acct_num, sub_acct_num order by t.vouch_status_cd, t.vouch_no) rn, t.*
                             from ${iml_schema}.agt_vouch_acct_rela_h t
                           where t.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
                              and t.end_dt > to_date('${batch_date}', 'yyyymmdd')
                              and t.job_cd = 'ncbsf1') var
              on t1.cust_acct_num = var.cust_acct_num
             and t1.acct_sub_acct_num = var.sub_acct_num
           where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
             and t1.end_dt > to_date('${batch_date}','yyyymmdd')
             and t1.job_cd = 'ncbsf1'
          and (t2.acct_type_cd  = '1' and substr(t1.cust_acct_num, 1, 1) <> '8'
                or (t2.acct_type_cd in ('2','3') and t1.open_acct_chn_id not in ('301004','901001','302006','302007'))
                or (nvl(var.dep_vouch_cate_cd, t1.dep_vouch_cate_cd) in ('735','737','731') and substr(t1.cust_acct_num, 1, 1) = '8'))
          union all
          select 
                 t1.cust_id                                                          -- 客户编号
                 ,case when t1.acct_init_open_acct_dt <> to_date('29991231','yyyymmdd') then t1.acct_init_open_acct_dt 
                        else to_date('00010101','yyyymmdd') end  as open_acct_dt       -- 开户日期
            from ${iml_schema}.agt_dep_acct_info_h t1
            left join (select row_number() over(partition by cust_acct_num, sub_acct_num order by t.vouch_status_cd, t.vouch_no) rn, t.*
                             from ${iml_schema}.agt_vouch_acct_rela_h t
                            where t.start_dt <= to_date('${batch_date}', 'yyyymmdd') 
                              and t.end_dt > to_date('${batch_date}', 'yyyymmdd')
                              and t.job_cd = 'ncbsf1') var
              on t1.cust_acct_num = var.cust_acct_num
             and t1.sub_acct_num = var.sub_acct_num
             and var.rn = 1
           where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
             and t1.end_dt > to_date('${batch_date}','yyyymmdd')
             and t1.job_cd = 'ncbsf1'
             and t1.main_acct_flg = '1'
          and (t1.acct_type_cd = '1' and substr(t1.cust_acct_num, 1, 1) <> '8'
                or (t1.acct_type_cd in ('2','3') and t1.open_acct_chn_id not in ('301004','901001','302006','302007'))
                or (var.dep_vouch_cate_cd in ('735','737','731') and substr(t1.cust_acct_num, 1, 1) = '8'))
          union all
          select t1.cust_id                              -- 客户编号
                   ,case when t1.open_acct_dt <> to_date('29991231','yyyymmdd') then t1.open_acct_dt 
                           else to_date('00010101','yyyymmdd') 
                            end  as open_acct_dt                   -- 开户日期
            from ${iml_schema}.agt_ifs_acct t1
           where t1.create_dt <= to_date('${batch_date}','yyyymmdd')
             and t1.id_mark <> 'D'
             and t1.job_cd = 'ifcsf1'
             and (t1.acct_type_cd = '1' and substr(t1.acct_id, 1, 1) <> '8'
                   or (t1.acct_type_cd in ('2','3') and t1.open_acct_chn_cd not in ('301004','901001','302006','302007'))
                   or (substr(t1.acct_id, 1, 1) = '8'))
)
group by cust_id)
where open_acct_tm >=to_date('20250101','yyyymmdd');

-- 2.9 AUM临时表
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex08
nologging
compress ${option_switch} for query high
as
select t2.cust_id
       ,t2.open_acct_tm                                     --开户时间
       ,to_char(t2.open_acct_tm,'yyyy-mm') as open_acct_mon               --开户月份
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=0 and months_between(t1.etl_dt,t2.open_acct_tm) <1 then t1.aum_acct_bal else 0 end) as zer_monend_aum      --第0个月末aum
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=1 and months_between(t1.etl_dt,t2.open_acct_tm) <2 then t1.aum_acct_bal else 0 end) as fir_monend_aum      --第1个月末aum
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=2 and months_between(t1.etl_dt,t2.open_acct_tm) <3 then t1.aum_acct_bal else 0 end) as sec_monend_aum      --第2个月末aum
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=3 and months_between(t1.etl_dt,t2.open_acct_tm) <4 then t1.aum_acct_bal else 0 end) as thi_monend_aum      --第3个月末aum
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=4 and months_between(t1.etl_dt,t2.open_acct_tm) <5 then t1.aum_acct_bal else 0 end) as fou_monend_aum      --第4个月末aum
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=5 and months_between(t1.etl_dt,t2.open_acct_tm) <6 then t1.aum_acct_bal else 0 end) as fif_monend_aum      --第5个月末aum
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=6 and months_between(t1.etl_dt,t2.open_acct_tm) <7 then t1.aum_acct_bal else 0 end) as six_monend_aum      --第6个月末aum
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=7 and months_between(t1.etl_dt,t2.open_acct_tm) <8 then t1.aum_acct_bal else 0 end) as sev_monend_aum      --第7个月末aum
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=8 and months_between(t1.etl_dt,t2.open_acct_tm) <9 then t1.aum_acct_bal else 0 end) as eig_monend_aum      --第8个月末aum
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=9 and months_between(t1.etl_dt,t2.open_acct_tm) <10 then t1.aum_acct_bal else 0 end) as nin_monend_aum      --第9个月末aum
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=10 and months_between(t1.etl_dt,t2.open_acct_tm) <11 then t1.aum_acct_bal else 0 end) as ten_monend_aum    --第10个月末aum
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=11 and months_between(t1.etl_dt,t2.open_acct_tm) <12 then t1.aum_acct_bal else 0 end) as ele_monend_aum    --第11个月末aum
       ,max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=12 and months_between(t1.etl_dt,t2.open_acct_tm) <13 then t1.aum_acct_bal else 0 end) as twe_monend_aum    --第12个月末aum
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=0  and months_between(t1.etl_dt,t2.open_acct_tm) <1  then t1.aum_acct_bal else 0 end) )>= 1000 then '是' else '否' end as zer_mon_retnd --第0个月留存
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=1  and months_between(t1.etl_dt,t2.open_acct_tm) <2  then t1.aum_acct_bal else 0 end) )>= 1000 then '是' else '否' end as fir_mon_retnd --第1个月留存
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=2  and months_between(t1.etl_dt,t2.open_acct_tm) <3  then t1.aum_acct_bal else 0 end) )>= 1000 then '是' else '否' end as sec_mon_retnd --第2个月留存
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=3  and months_between(t1.etl_dt,t2.open_acct_tm) <4  then t1.aum_acct_bal else 0 end) )>= 1000 then '是' else '否' end as thi_mon_retnd --第3个月留存
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=4  and months_between(t1.etl_dt,t2.open_acct_tm) <5  then t1.aum_acct_bal else 0 end) )>= 1000 then '是' else '否' end as fou_mon_retnd --第4个月留存
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=5  and months_between(t1.etl_dt,t2.open_acct_tm) <6  then t1.aum_acct_bal else 0 end) )>= 1000 then '是' else '否' end as fif_mon_retnd --第5个月留存
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=6  and months_between(t1.etl_dt,t2.open_acct_tm) <7  then t1.aum_acct_bal else 0 end) )>= 1000 then '是' else '否' end as six_mon_retnd --第6个月留存
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=7  and months_between(t1.etl_dt,t2.open_acct_tm) <8  then t1.aum_acct_bal else 0 end) )>= 1000 then '是' else '否' end as sev_mon_retnd --第7个月留存
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=8  and months_between(t1.etl_dt,t2.open_acct_tm) <9  then t1.aum_acct_bal else 0 end) )>= 1000 then '是' else '否' end as eig_mon_retnd --第8个月留存
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=9  and months_between(t1.etl_dt,t2.open_acct_tm) <10 then t1.aum_acct_bal else 0 end) )>= 1000 then '是' else '否' end as nin_mon_retnd --第9个月留存
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=10 and months_between(t1.etl_dt,t2.open_acct_tm) <11 then t1.aum_acct_bal else 0 end))>= 1000 then '是' else '否' end as ten_mon_retnd --第10个月留存
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=11 and months_between(t1.etl_dt,t2.open_acct_tm) <12 then t1.aum_acct_bal else 0 end))>= 1000 then '是' else '否' end as ele_mon_retnd --第11个月留存
       ,case when (max(case when months_between(t1.etl_dt,t2.open_acct_tm)>=12 and months_between(t1.etl_dt,t2.open_acct_tm) <13 then t1.aum_acct_bal else 0 end))>= 1000 then '是' else '否' end as twe_mon_retnd --第12个月留存*/
from ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex07 t2
left join ${iol_schema}.bdws_a_cm_aum_info t1
   on t1.cust_id=t2.cust_id
 and t1.etl_dt in (select data_date from ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex06)   --取跑批日前12个月末数据
 and t1.etl_dt <=to_date('${batch_date}','yyyymmdd')
where 1=1
 group by t2.cust_id,t2.open_acct_tm;




whenever sqlerror exit sql.sqlcode;
insert into ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex(
    etl_dt                                          --数据日期
    ,lp_id                                          --法人编号
    ,cust_id	                                     --客户号
    ,mas_belong_brch_id	                             --管户归属分行编号
    ,mas_belong_brch_name	                         --管户归属分行名称
    ,mas_belong_subrch_id	                         --管户归属支行编号
    ,mas_belong_subrch_name	                         --管户归属支行名称
    ,open_acct_tm	                                 --开户时间
    ,open_acct_mon	                                 --开户月份
    ,if_allacct_close                                --是否所有账户已销户
    ,zer_monend_aum	                                 --第0个月末aum
    ,fir_monend_aum	                                 --第1个月末aum
    ,sec_monend_aum	                                 --第2个月末aum
    ,thi_monend_aum	                                 --第3个月末aum
    ,fou_monend_aum	                                 --第4个月末aum
    ,fif_monend_aum	                                 --第5个月末aum
    ,six_monend_aum	                                 --第6个月末aum
    ,sev_monend_aum	                                 --第7个月末aum
    ,eig_monend_aum	                                 --第8个月末aum
    ,nin_monend_aum	                                 --第9个月末aum
    ,ten_monend_aum	                                 --第10个月末aum
    ,ele_monend_aum	                                 --第11个月末aum
    ,twe_monend_aum	                                 --第12个月末aum
    ,zer_mon_retnd	                                 --第0个月留存
    ,fir_mon_retnd	                                 --第1个月留存
    ,sec_mon_retnd	                                 --第2个月留存
    ,thi_mon_retnd	                                 --第3个月留存
    ,fou_mon_retnd	                                 --第4个月留存
    ,fif_mon_retnd	                                 --第5个月留存
    ,six_mon_retnd	                                 --第6个月留存
    ,sev_mon_retnd	                                 --第7个月留存
    ,eig_mon_retnd	                                 --第8个月留存
    ,nin_mon_retnd	                                 --第9个月留存
    ,ten_mon_retnd	                                 --第10个月留存
    ,ele_mon_retnd	                                 --第11个月留存
    ,twe_mon_retnd	                                 --第12个月留存
    ,fir_prod_dt	                                 --首单产品日期
    ,sec_prod_dt	                                 --二单产品日期
    ,fir_and_scd_tran_intrv_mon	                     --首次与二次交易间隔的月份
    ,fir_prod_type	                                 --首单产品类型
    ,sec_prod_type	                                 --二单产品类型
    ,fir_prod_id	                                 --首单产品编号
    ,sec_prod_id	                                 --二单产品编号
    ,fir_prod_name	                                 --首单产品名称
    ,sec_prod_name	                                 --二单产品名称
    ,sec_prod_cls	                                 --二单产品分类
    ,fir_prod_cls	                                 --首单产品分类
    ,fir_tran_prod_tenor	                         --首单交易产品期限
    ,sec_tran_prod_tenor	                         --二单交易产品期限
    ,fir_prod_risk_level	                         --首单产品风险等级
    ,sec_prod_risk_level	                         --二单产品风险等级
    ,job_cd                                          --任务代码
    ,etl_timestamp                                   --etl处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')               --数据日期
    ,'9999'                                              --法人编号
    ,t1.cust_id                                          --客户号
    ,t3.gh_brch_org_id                                   --管户归属分行编号
    ,t3.gh_brch_org_name                                 --管户归属分行名称
    ,t3.gh_subbrch_org_id                                --管户归属支行编号
    ,t3.gh_subbrch_org_name                              --管户归属支行名称
    ,t1.open_acct_tm                                     --开户时间
    ,t1.open_acct_mon                                    --开户月份
    ,nvl(t5.if_allacct_close,'-')                      --是否所有账户已销户
    ,t1.zer_monend_aum	                                 --第0个月末aum
    ,t1.fir_monend_aum	                                 --第1个月末aum
    ,t1.sec_monend_aum	                                 --第2个月末aum
    ,t1.thi_monend_aum	                                 --第3个月末aum
    ,t1.fou_monend_aum	                                 --第4个月末aum
    ,t1.fif_monend_aum	                                 --第5个月末aum
    ,t1.six_monend_aum	                                 --第6个月末aum
    ,t1.sev_monend_aum	                                 --第7个月末aum
    ,t1.eig_monend_aum	                                 --第8个月末aum
    ,t1.nin_monend_aum	                                 --第9个月末aum
    ,t1.ten_monend_aum	                                 --第10个月末aum
    ,t1.ele_monend_aum	                                 --第11个月末aum
    ,t1.twe_monend_aum	                                 --第12个月末aum
    ,t1.zer_mon_retnd	                                 --第0个月留存
    ,t1.fir_mon_retnd	                                 --第1个月留存
    ,t1.sec_mon_retnd	                                 --第2个月留存
    ,t1.thi_mon_retnd	                                 --第3个月留存
    ,t1.fou_mon_retnd	                                 --第4个月留存
    ,t1.fif_mon_retnd	                                 --第5个月留存
    ,t1.six_mon_retnd	                                 --第6个月留存
    ,t1.sev_mon_retnd	                                 --第7个月留存
    ,t1.eig_mon_retnd	                                 --第8个月留存
    ,t1.nin_mon_retnd	                                 --第9个月留存
    ,t1.ten_mon_retnd	                                 --第10个月留存
    ,t1.ele_mon_retnd	                                 --第11个月留存
    ,t1.twe_mon_retnd	                                 --第12个月留存
    ,min(case when t4.prod_seq = 1 then t4.tran_dt end)                                                                                   --首单产品日期
    ,min(case when t4.prod_seq = 2 then t4.tran_dt end)                                                                                   --二单产品日期
    ,case when min(case when t4.prod_seq = 1 then t4.tran_dt end) is null then '无首单交易'
           when min(case when t4.prod_seq = 2 then t4.tran_dt end) is null then '无二单交易'
           when (min(case when t4.prod_seq = 2 then t4.tran_dt end)) - ( min(case when t4.prod_seq = 1 then t4.tran_dt end)) <= 30 then '0'
           when (min(case when t4.prod_seq = 2 then t4.tran_dt end)) - ( min(case when t4.prod_seq = 1 then t4.tran_dt end)) <= 60 then '1'
           when (min(case when t4.prod_seq = 2 then t4.tran_dt end)) - ( min(case when t4.prod_seq = 1 then t4.tran_dt end)) <= 90 then '2'
           when (min(case when t4.prod_seq = 2 then t4.tran_dt end)) - ( min(case when t4.prod_seq = 1 then t4.tran_dt end)) <= 120 then '3'
           when (min(case when t4.prod_seq = 2 then t4.tran_dt end)) - ( min(case when t4.prod_seq = 1 then t4.tran_dt end)) <= 150 then '4'
           when (min(case when t4.prod_seq = 2 then t4.tran_dt end)) - ( min(case when t4.prod_seq = 1 then t4.tran_dt end)) <= 180 then '5'
           when (min(case when t4.prod_seq = 2 then t4.tran_dt end)) - ( min(case when t4.prod_seq = 1 then t4.tran_dt end)) <= 210 then '6'
           when (min(case when t4.prod_seq = 2 then t4.tran_dt end)) - ( min(case when t4.prod_seq = 1 then t4.tran_dt end)) <= 240 then '6+'
           else '其他' end             ----首次与二次交易间隔的月份
    ,min(case when t4.prod_seq = 1 then t4.prod_type end)       --首单产品类型
    ,min(case when t4.prod_seq = 2 then t4.prod_type end)       --二单产品类型
    ,min(case when t4.prod_seq = 1 then t4.prod_id end)         --首单产品编号
    ,min(case when t4.prod_seq = 2 then t4.prod_id end)         --二单产品编号
    ,min(case when t4.prod_seq = 1 then t4.prod_name end)       --首单产品名称
    ,min(case when t4.prod_seq = 2 then t4.prod_name end)       --二单产品名称
    ,min(case when t4.prod_seq = 2 then t4.prod_type end)       --二单产品分类
    ,min(case when t4.prod_seq = 1 then t4.prod_type end)       --首单产品分类
    ,min(case when t4.prod_seq = 1 then t4.prod_term end)       --首单交易产品期限
    ,min(case when t4.prod_seq = 2 then t4.prod_term end)       --二单交易产品期限
    ,min(case when t4.prod_seq = 1 then t4.prod_risk end)       --首单产品风险等级
    ,min(case when t4.prod_seq = 2 then t4.prod_risk end)       --二单产品风险等级
    ,'bdws'                                                                --任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   --etl处理时间戳
from ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex08 t1
left join ${iol_schema}.bdws_a_cm_cust t3
on t1.cust_id=t3.cust_id
and t3.etl_dt =to_date('${batch_date}','yyyymmdd')
left join (select
                  tran_dt,
                  cust_id,
                  prod_type,
                  prod_id,
                  prod_name,
                  prod_term,
                  prod_risk,
                  row_number() over(partition by cust_id order by tran_dt,seq asc)  as prod_seq-- 产品交易序号
                from ( --理财
                  select  a1.tran_dt               as tran_dt --交易日期
                           ,a1.party_id              as cust_id --客户号
                           ,'理财'                   as prod_type --产品类型
                           ,a1.prod_id               as prod_id   --产品编号
                           ,t.prod_name              as prod_name  --产品名称
                           ,t.ped_days               as prod_term  --交易产品期限
                           ,t.risk_level_cd          as prod_risk  --产品风险等级
                           ,'2'                      as seq --序号用于排序取优先级
                  from ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex01 a1
                  left join ${iml_schema}.prd_finc t
                    on t.finc_prod_id = a1.prod_id
                   and t.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and t.id_mark<>'D'
                   and t.job_cd ='ifmsf1'
                 where substr(t.ctrl_flg,3,1)='1'
                   and a1.rn<=2  --仅取最早两笔交易
                union all --基金
                 select a1.appl_dt          as tran_dt --交易日期
                          ,a1.cust_id          as cust_id --客户号
                          ,'基金'              as prod_type --产品类型
                          ,a1.finc_prod_id     as prod_id   --产品编号
                          ,a2.prod_name        as prod_name  --产品名称
                          ,a2.ped_days         as prod_term  --交易产品期限
                          ,a2.risk_level_cd    as prod_risk  --产品风险等级
                           ,'3'                as seq --序号用于排序取优先级
                  from ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex02 a1
                  left join ${iml_schema}.prd_consmt_fund_prod a2
                    on a1.finc_prod_id = a2.init_prod_id
                   and a1.ta_cd = a2.ta_cd
                   and a2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and a2.id_mark<>'D'
                   and a2.job_cd ='nfssf1'
                where a1.rn<=2  --仅取最早两笔交易
                union all --保险
                 select a1.tran_dt                         as tran_dt --交易日期
                         ,a1.cust_id                          as cust_id --客户号
                         ,'保险'                              as prod_type --产品类型
                         ,a1.prod_id                          as prod_id   --产品编号
                         ,a2.prod_name                        as prod_name  --产品名称
                         ,to_number(a1.insure_ped)        as prod_term  --交易产品期限
                         ,''                                  as prod_risk  --产品风险等级
                         ,'4'                as seq --序号用于排序取优先级
                  from ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex03 a1
                  left join ${iml_schema}.prd_insure_prod a2
                    on a1.prod_id = a2.prod_id
                   and a2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                   and a2.id_mark<>'D'
                   and a2.job_cd ='inssf1'
                where a1.rn<=2  --仅取最早两笔交易
                union all --存款
                  select a1.tran_dt                           as tran_dt --交易日期
                          ,a1.cust_id                           as cust_id --客户号
                          ,'存款'                               as prod_type --产品类型
                          ,a1.bus_prod_id                       as prod_id   --产品编号
                          ,nvl(t3.sellbl_prod_name, '活期')     as prod_name  --产品名称
                          ,a2.dep_term                          as prod_term  --交易产品期限
                          ,''                                   as prod_risk  --产品风险等级
                          ,'1'                                 as seq   --序号用于排序取优先级
                  from ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex04 a1
                 inner join ${iml_schema}.agt_dep_acct_info_h a2
                     on a1.dep_sub_acct_id = a2.acct_id
                    and a2.start_dt <= to_date('${batch_date}','yyyymmdd')
                    and a2.end_dt > to_date('${batch_date}','yyyymmdd')
                    and a2.job_cd ='ncbsf1'
                   left join ${iml_schema}.prd_prod_catlg_h t3
                     on a1.bus_prod_id=t3.prod_id
                    and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
                    and t3.end_dt > to_date('${batch_date}','yyyymmdd')
                    and t3.job_cd ='ncbsf1'
                 where a1.rn<=2  --仅取最早两笔交易
                 union all
                 select to_date(a.fkr,'yyyymmdd')                 as tran_dt --交易日期
                          ,a.khh                 as cust_id --客户号
                          ,a.kmmc                as prod_type --产品类型
                          ,a.cpbh                as prod_id   --产品编号
                          ,a.cpzwmc              as prod_name  --产品名称
                          ,0                     as prod_term  --交易产品期限     --a.qx
                          ,a.wjfl                as prod_risk  --产品风险等级
                          ,'5'                   as seq   --序号用于排序取优先级
                  from ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex05 a
                 where a.rn<=2  --仅取最早两笔交易
                ))t4
on t1.cust_id=t4.cust_id
left join ${iol_schema}.bdws_a_cust_acct_status_flg t5
  on t1.cust_id=t5.cust_id
-- and t5.etl_dt =to_date('${batch_date}','yyyymmdd')
where 1=1
--and t1.cust_id ='1202748030'
group by
    t1.cust_id
    ,t3.gh_brch_org_id
    ,t3.gh_brch_org_name
    ,t3.gh_subbrch_org_id
    ,t3.gh_subbrch_org_name
    ,t1.open_acct_tm
    ,t1.open_acct_mon
    ,t5.if_allacct_close
    ,t1.zer_monend_aum
    ,t1.fir_monend_aum
    ,t1.sec_monend_aum
    ,t1.thi_monend_aum
    ,t1.fou_monend_aum
    ,t1.fif_monend_aum
    ,t1.six_monend_aum
    ,t1.sev_monend_aum
    ,t1.eig_monend_aum
    ,t1.nin_monend_aum
    ,t1.ten_monend_aum
    ,t1.ele_monend_aum
    ,t1.twe_monend_aum
    ,t1.zer_mon_retnd
    ,t1.fir_mon_retnd
    ,t1.sec_mon_retnd
    ,t1.thi_mon_retnd
    ,t1.fou_mon_retnd
    ,t1.fif_mon_retnd
    ,t1.six_mon_retnd
    ,t1.sev_mon_retnd
    ,t1.eig_mon_retnd
    ,t1.nin_mon_retnd
    ,t1.ten_mon_retnd
    ,t1.ele_mon_retnd
    ,t1.twe_mon_retnd
;
commit;

-- 2.2 exchage ex table and target table
alter table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info exchange partition p_${batch_date} with table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex;

-- 3.1 drop ex table
drop table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_ex purge;
--drop table ${idl_schema}.tmp_dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_01 purge;
--drop table ${idl_schema}.tmp_dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info_02 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
