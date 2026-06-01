/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_gl_mult_flow_tglsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.fin_gl_mult_flow_tglsi1_tm purge;
alter table ${iml_schema}.fin_gl_mult_flow add partition p_tglsi1 values ('tglsi1')(
        subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.fin_gl_mult_flow modify partition p_tglsi1
    add subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_gl_mult_flow_tglsi1_tm
compress ${option_switch} for query high
as
select
    sob_id -- 账套编号
    ,sys_cd -- 系统代码
    ,acct_dt -- 账务日期
    ,gl_org_id -- 总账机构编号
    ,subj_id -- 科目编号
    ,curr_cd -- 币种代码
    ,gl_type_cd -- 总账类型代码
    ,chn_id -- 渠道编号
    ,sellbl_prod_id -- 可售产品编号
    ,lp_id -- 法人编号
    ,dr_ld_bal -- 借方上日余额
    ,cr_ld_bal -- 贷方上日余额
    ,dr_td_amt -- 借方本日发生额
    ,dr_td_happ_cnt -- 借方本日发生笔数
    ,cr_td_amt -- 贷方本日发生额
    ,cr_td_happ_cnt -- 贷方本日发生笔数
    ,dr_bal -- 借方余额
    ,cr_bal -- 贷方余额
    ,curr_bal_dir_cd -- 当前余额方向代码
    ,curr_bal -- 当前余额
    ,l_ped_bal_dir_cd -- 上期余额方向代码
    ,l_ped_bal -- 上期余额
    ,end_level_subj_flg -- 末级科目标志
    ,stand_mony_tm_bg_dr_bal -- 本位币期初借方余额
    ,stand_mony_tm_bg_cr_bal -- 本位币期初贷方余额
    ,dc_dr_amt -- 本币借方发生额
    ,dc_cr_amt -- 本币贷方发生额
    ,stand_mony_term_end_dr_bal -- 本位币期末借方余额
    ,stand_mony_term_end_cr_bal -- 本位币期末贷方余额
    ,bal_accum -- 余额积数
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_gl_mult_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- tgls_gla_mult_h-1
insert into ${iml_schema}.fin_gl_mult_flow_tglsi1_tm(
    sob_id -- 账套编号
    ,sys_cd -- 系统代码
    ,acct_dt -- 账务日期
    ,gl_org_id -- 总账机构编号
    ,subj_id -- 科目编号
    ,curr_cd -- 币种代码
    ,gl_type_cd -- 总账类型代码
    ,chn_id -- 渠道编号
    ,sellbl_prod_id -- 可售产品编号
    ,lp_id -- 法人编号
    ,dr_ld_bal -- 借方上日余额
    ,cr_ld_bal -- 贷方上日余额
    ,dr_td_amt -- 借方本日发生额
    ,dr_td_happ_cnt -- 借方本日发生笔数
    ,cr_td_amt -- 贷方本日发生额
    ,cr_td_happ_cnt -- 贷方本日发生笔数
    ,dr_bal -- 借方余额
    ,cr_bal -- 贷方余额
    ,curr_bal_dir_cd -- 当前余额方向代码
    ,curr_bal -- 当前余额
    ,l_ped_bal_dir_cd -- 上期余额方向代码
    ,l_ped_bal -- 上期余额
    ,end_level_subj_flg -- 末级科目标志
    ,stand_mony_tm_bg_dr_bal -- 本位币期初借方余额
    ,stand_mony_tm_bg_cr_bal -- 本位币期初贷方余额
    ,dc_dr_amt -- 本币借方发生额
    ,dc_cr_amt -- 本币贷方发生额
    ,stand_mony_term_end_dr_bal -- 本位币期末借方余额
    ,stand_mony_term_end_cr_bal -- 本位币期末贷方余额
    ,bal_accum -- 余额积数
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.STACID -- 套账编号
    ,P1.SYSTID -- 系统代码
    ,P1.ACCTDT -- 账务日期
    ,P1.BRCHCD -- 总账机构编号
    ,P1.ITEMCD -- 科目编号
    ,P1.CRCYCD -- 币种代码
    ,P1.GELDTP -- 总账类型代码
    ,P1.ASSIS0 -- 渠道编号
    ,P1.ASSIS1 -- 可售产品编号
    ,'9999' -- 法人编号
    ,P1.DRLTBL -- 借方上日余额
    ,P1.CRLTBL -- 贷方上日余额
    ,P1.DRTSAM -- 借方本日发生额
    ,P1.DRTSNM -- 借方本日发生笔数
    ,P1.CRTSAM -- 贷方本日发生额
    ,P1.CRTSNM -- 贷方本日发生笔数
    ,P1.DRCTBL -- 借方余额
    ,P1.CRCTBL -- 贷方余额
    ,P1.BLNCDN -- 当前余额方向代码
    ,P1.ONLNBL -- 当前余额
    ,P1.LASTDN -- 上期余额方向代码
    ,P1.LASTBL -- 上期余额
    ,P1.DETLTG -- 末级科目标志
    ,P1.DLFLCBL -- 本位币期初借方余额
    ,P1.CLFLCBL -- 本位币期初贷方余额
    ,P1.DTFLCAM -- 本币借方发生额
    ,P1.CTFLCAM -- 本币贷方发生额
    ,P1.DRFLCBL -- 本位币期末借方余额
    ,P1.CRFLCBL -- 本位币期末贷方余额
    ,P1.BLPROD -- 余额积数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_gla_mult_h' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_gla_mult_h p1
where p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.fin_gl_mult_flow truncate subpartition p_tglsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.fin_gl_mult_flow exchange subpartition p_tglsi1_${batch_date} with table ${iml_schema}.fin_gl_mult_flow_tglsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_gl_mult_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.fin_gl_mult_flow_tglsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_gl_mult_flow', partname => 'p_tglsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);