/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_recs_agree_payoff_appl_h_bdmsf1
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
alter table ${iml_schema}.agt_recs_agree_payoff_appl_h add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_recs_agree_payoff_appl_h partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 票据金额
    ,agree_payoff_dt -- 同意清偿日期
    ,agree_payoff_curr_cd -- 同意清偿币种代码
    ,agree_payoff_amt -- 同意清偿金额
    ,agree_payoff_ps_cate_cd -- 同意清偿人类别代码
    ,agree_payoff_ps_name -- 同意清偿人名称
    ,agree_payoff_ps_orgnz_cd -- 同意清偿人组织机构代码
    ,agree_payoff_ps_acct_id -- 同意清偿人账户编号
    ,agree_payoff_ps_open_bank_no -- 同意清偿人开户行行号
    ,agree_payoff_ps_udtake_bk_bank_no -- 同意清偿人承接行行号
    ,payoff_appl_initor_cd -- 清偿申请发起端代码
    ,recs_agree_payoff_status_cd -- 追索同意清偿状态代码
    ,entry_status_cd -- 记账状态代码
    ,entry_dt -- 记账日期
    ,recv_dt -- 签收日期
    ,recv_opinion_type_cd -- 签收意见类型代码
    ,revo_dt -- 撤销日期
    ,send_out_recs_rgst_b_id -- 发出追索登记簿编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_teller_tm -- 最后修改柜员时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_recs_agree_payoff_appl_h partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_recs_agree_payoff_appl_h partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_recs_agree_payoff_appl_h partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_bms_recourse_agree_apply-
insert into ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 票据金额
    ,agree_payoff_dt -- 同意清偿日期
    ,agree_payoff_curr_cd -- 同意清偿币种代码
    ,agree_payoff_amt -- 同意清偿金额
    ,agree_payoff_ps_cate_cd -- 同意清偿人类别代码
    ,agree_payoff_ps_name -- 同意清偿人名称
    ,agree_payoff_ps_orgnz_cd -- 同意清偿人组织机构代码
    ,agree_payoff_ps_acct_id -- 同意清偿人账户编号
    ,agree_payoff_ps_open_bank_no -- 同意清偿人开户行行号
    ,agree_payoff_ps_udtake_bk_bank_no -- 同意清偿人承接行行号
    ,payoff_appl_initor_cd -- 清偿申请发起端代码
    ,recs_agree_payoff_status_cd -- 追索同意清偿状态代码
    ,entry_status_cd -- 记账状态代码
    ,entry_dt -- 记账日期
    ,recv_dt -- 签收日期
    ,recv_opinion_type_cd -- 签收意见类型代码
    ,revo_dt -- 撤销日期
    ,send_out_recs_rgst_b_id -- 发出追索登记簿编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_teller_tm -- 最后修改柜员时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 申请编号
    ,'9999' -- 法人编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,nvl(trim(P1.ISSE_CURCD),'-') -- 票据币种代码
    ,P1.ISSE_AMT -- 票据金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLY_DATE) -- 同意清偿日期
    ,nvl(trim(P1.RCRS_CURCD),'-') -- 同意清偿币种代码
    ,P1.RCRS_AMT -- 同意清偿金额
    ,nvl(trim(P1.RCRS_ROLE),'-') -- 同意清偿人类别代码
    ,P1.RCRS_NAME -- 同意清偿人名称
    ,P1.RCRS_CMONID -- 同意清偿人组织机构代码
    ,P1.RCRS_ACTNO -- 同意清偿人账户编号
    ,P1.RCRS_UBANK -- 同意清偿人开户行行号
    ,P1.RCRS_AGCY_UBANK -- 同意清偿人承接行行号
    ,nvl(trim(P1.PURPOSE),'-') -- 清偿申请发起端代码
    ,nvl(trim(P1.DETAILS_STATUS),'-') -- 追索同意清偿状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_FLAG END -- 记账状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.ACCOUNT_DATE) -- 记账日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.ENDST_DATE) -- 签收日期
    ,nvl(trim(P1.SIG_MK),'-') -- 签收意见类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.CANCEL_DATE) -- 撤销日期
    ,P1.RECOURSE_ID -- 发出追索登记簿编号
    ,P1.LAST_OPERATOR_NO -- 最后修改柜员编号
    ,${iml_schema}.TIMEFORMAT_MIN(P1.LAST_UPD_TIME) -- 最后修改柜员时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_recourse_agree_apply' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_recourse_agree_apply p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACCOUNT_FLAG = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_BMS_RECOURSE_AGREE_APPLY'
        AND R1.SRC_FIELD_EN_NAME= 'ACCOUNT_FLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_RECS_AGREE_PAYOFF_APPL_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_tm 
  	                                group by 
  	                                        appl_id
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
        into ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 票据金额
    ,agree_payoff_dt -- 同意清偿日期
    ,agree_payoff_curr_cd -- 同意清偿币种代码
    ,agree_payoff_amt -- 同意清偿金额
    ,agree_payoff_ps_cate_cd -- 同意清偿人类别代码
    ,agree_payoff_ps_name -- 同意清偿人名称
    ,agree_payoff_ps_orgnz_cd -- 同意清偿人组织机构代码
    ,agree_payoff_ps_acct_id -- 同意清偿人账户编号
    ,agree_payoff_ps_open_bank_no -- 同意清偿人开户行行号
    ,agree_payoff_ps_udtake_bk_bank_no -- 同意清偿人承接行行号
    ,payoff_appl_initor_cd -- 清偿申请发起端代码
    ,recs_agree_payoff_status_cd -- 追索同意清偿状态代码
    ,entry_status_cd -- 记账状态代码
    ,entry_dt -- 记账日期
    ,recv_dt -- 签收日期
    ,recv_opinion_type_cd -- 签收意见类型代码
    ,revo_dt -- 撤销日期
    ,send_out_recs_rgst_b_id -- 发出追索登记簿编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_teller_tm -- 最后修改柜员时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 票据金额
    ,agree_payoff_dt -- 同意清偿日期
    ,agree_payoff_curr_cd -- 同意清偿币种代码
    ,agree_payoff_amt -- 同意清偿金额
    ,agree_payoff_ps_cate_cd -- 同意清偿人类别代码
    ,agree_payoff_ps_name -- 同意清偿人名称
    ,agree_payoff_ps_orgnz_cd -- 同意清偿人组织机构代码
    ,agree_payoff_ps_acct_id -- 同意清偿人账户编号
    ,agree_payoff_ps_open_bank_no -- 同意清偿人开户行行号
    ,agree_payoff_ps_udtake_bk_bank_no -- 同意清偿人承接行行号
    ,payoff_appl_initor_cd -- 清偿申请发起端代码
    ,recs_agree_payoff_status_cd -- 追索同意清偿状态代码
    ,entry_status_cd -- 记账状态代码
    ,entry_dt -- 记账日期
    ,recv_dt -- 签收日期
    ,recv_opinion_type_cd -- 签收意见类型代码
    ,revo_dt -- 撤销日期
    ,send_out_recs_rgst_b_id -- 发出追索登记簿编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_teller_tm -- 最后修改柜员时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.bill_curr_cd, o.bill_curr_cd) as bill_curr_cd -- 票据币种代码
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 票据金额
    ,nvl(n.agree_payoff_dt, o.agree_payoff_dt) as agree_payoff_dt -- 同意清偿日期
    ,nvl(n.agree_payoff_curr_cd, o.agree_payoff_curr_cd) as agree_payoff_curr_cd -- 同意清偿币种代码
    ,nvl(n.agree_payoff_amt, o.agree_payoff_amt) as agree_payoff_amt -- 同意清偿金额
    ,nvl(n.agree_payoff_ps_cate_cd, o.agree_payoff_ps_cate_cd) as agree_payoff_ps_cate_cd -- 同意清偿人类别代码
    ,nvl(n.agree_payoff_ps_name, o.agree_payoff_ps_name) as agree_payoff_ps_name -- 同意清偿人名称
    ,nvl(n.agree_payoff_ps_orgnz_cd, o.agree_payoff_ps_orgnz_cd) as agree_payoff_ps_orgnz_cd -- 同意清偿人组织机构代码
    ,nvl(n.agree_payoff_ps_acct_id, o.agree_payoff_ps_acct_id) as agree_payoff_ps_acct_id -- 同意清偿人账户编号
    ,nvl(n.agree_payoff_ps_open_bank_no, o.agree_payoff_ps_open_bank_no) as agree_payoff_ps_open_bank_no -- 同意清偿人开户行行号
    ,nvl(n.agree_payoff_ps_udtake_bk_bank_no, o.agree_payoff_ps_udtake_bk_bank_no) as agree_payoff_ps_udtake_bk_bank_no -- 同意清偿人承接行行号
    ,nvl(n.payoff_appl_initor_cd, o.payoff_appl_initor_cd) as payoff_appl_initor_cd -- 清偿申请发起端代码
    ,nvl(n.recs_agree_payoff_status_cd, o.recs_agree_payoff_status_cd) as recs_agree_payoff_status_cd -- 追索同意清偿状态代码
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.entry_dt, o.entry_dt) as entry_dt -- 记账日期
    ,nvl(n.recv_dt, o.recv_dt) as recv_dt -- 签收日期
    ,nvl(n.recv_opinion_type_cd, o.recv_opinion_type_cd) as recv_opinion_type_cd -- 签收意见类型代码
    ,nvl(n.revo_dt, o.revo_dt) as revo_dt -- 撤销日期
    ,nvl(n.send_out_recs_rgst_b_id, o.send_out_recs_rgst_b_id) as send_out_recs_rgst_b_id -- 发出追索登记簿编号
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,nvl(n.final_modif_teller_tm, o.final_modif_teller_tm) as final_modif_teller_tm -- 最后修改柜员时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
where (
        o.appl_id is null
        and o.lp_id is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
    )
    or (
        o.bill_id <> n.bill_id
        or o.bill_num <> n.bill_num
        or o.bill_curr_cd <> n.bill_curr_cd
        or o.bill_amt <> n.bill_amt
        or o.agree_payoff_dt <> n.agree_payoff_dt
        or o.agree_payoff_curr_cd <> n.agree_payoff_curr_cd
        or o.agree_payoff_amt <> n.agree_payoff_amt
        or o.agree_payoff_ps_cate_cd <> n.agree_payoff_ps_cate_cd
        or o.agree_payoff_ps_name <> n.agree_payoff_ps_name
        or o.agree_payoff_ps_orgnz_cd <> n.agree_payoff_ps_orgnz_cd
        or o.agree_payoff_ps_acct_id <> n.agree_payoff_ps_acct_id
        or o.agree_payoff_ps_open_bank_no <> n.agree_payoff_ps_open_bank_no
        or o.agree_payoff_ps_udtake_bk_bank_no <> n.agree_payoff_ps_udtake_bk_bank_no
        or o.payoff_appl_initor_cd <> n.payoff_appl_initor_cd
        or o.recs_agree_payoff_status_cd <> n.recs_agree_payoff_status_cd
        or o.entry_status_cd <> n.entry_status_cd
        or o.entry_dt <> n.entry_dt
        or o.recv_dt <> n.recv_dt
        or o.recv_opinion_type_cd <> n.recv_opinion_type_cd
        or o.revo_dt <> n.revo_dt
        or o.send_out_recs_rgst_b_id <> n.send_out_recs_rgst_b_id
        or o.final_modif_teller_id <> n.final_modif_teller_id
        or o.final_modif_teller_tm <> n.final_modif_teller_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 票据金额
    ,agree_payoff_dt -- 同意清偿日期
    ,agree_payoff_curr_cd -- 同意清偿币种代码
    ,agree_payoff_amt -- 同意清偿金额
    ,agree_payoff_ps_cate_cd -- 同意清偿人类别代码
    ,agree_payoff_ps_name -- 同意清偿人名称
    ,agree_payoff_ps_orgnz_cd -- 同意清偿人组织机构代码
    ,agree_payoff_ps_acct_id -- 同意清偿人账户编号
    ,agree_payoff_ps_open_bank_no -- 同意清偿人开户行行号
    ,agree_payoff_ps_udtake_bk_bank_no -- 同意清偿人承接行行号
    ,payoff_appl_initor_cd -- 清偿申请发起端代码
    ,recs_agree_payoff_status_cd -- 追索同意清偿状态代码
    ,entry_status_cd -- 记账状态代码
    ,entry_dt -- 记账日期
    ,recv_dt -- 签收日期
    ,recv_opinion_type_cd -- 签收意见类型代码
    ,revo_dt -- 撤销日期
    ,send_out_recs_rgst_b_id -- 发出追索登记簿编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_teller_tm -- 最后修改柜员时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,bill_id -- 票据编号
    ,bill_num -- 票据号码
    ,bill_curr_cd -- 票据币种代码
    ,bill_amt -- 票据金额
    ,agree_payoff_dt -- 同意清偿日期
    ,agree_payoff_curr_cd -- 同意清偿币种代码
    ,agree_payoff_amt -- 同意清偿金额
    ,agree_payoff_ps_cate_cd -- 同意清偿人类别代码
    ,agree_payoff_ps_name -- 同意清偿人名称
    ,agree_payoff_ps_orgnz_cd -- 同意清偿人组织机构代码
    ,agree_payoff_ps_acct_id -- 同意清偿人账户编号
    ,agree_payoff_ps_open_bank_no -- 同意清偿人开户行行号
    ,agree_payoff_ps_udtake_bk_bank_no -- 同意清偿人承接行行号
    ,payoff_appl_initor_cd -- 清偿申请发起端代码
    ,recs_agree_payoff_status_cd -- 追索同意清偿状态代码
    ,entry_status_cd -- 记账状态代码
    ,entry_dt -- 记账日期
    ,recv_dt -- 签收日期
    ,recv_opinion_type_cd -- 签收意见类型代码
    ,revo_dt -- 撤销日期
    ,send_out_recs_rgst_b_id -- 发出追索登记簿编号
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_teller_tm -- 最后修改柜员时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.bill_id -- 票据编号
    ,o.bill_num -- 票据号码
    ,o.bill_curr_cd -- 票据币种代码
    ,o.bill_amt -- 票据金额
    ,o.agree_payoff_dt -- 同意清偿日期
    ,o.agree_payoff_curr_cd -- 同意清偿币种代码
    ,o.agree_payoff_amt -- 同意清偿金额
    ,o.agree_payoff_ps_cate_cd -- 同意清偿人类别代码
    ,o.agree_payoff_ps_name -- 同意清偿人名称
    ,o.agree_payoff_ps_orgnz_cd -- 同意清偿人组织机构代码
    ,o.agree_payoff_ps_acct_id -- 同意清偿人账户编号
    ,o.agree_payoff_ps_open_bank_no -- 同意清偿人开户行行号
    ,o.agree_payoff_ps_udtake_bk_bank_no -- 同意清偿人承接行行号
    ,o.payoff_appl_initor_cd -- 清偿申请发起端代码
    ,o.recs_agree_payoff_status_cd -- 追索同意清偿状态代码
    ,o.entry_status_cd -- 记账状态代码
    ,o.entry_dt -- 记账日期
    ,o.recv_dt -- 签收日期
    ,o.recv_opinion_type_cd -- 签收意见类型代码
    ,o.revo_dt -- 撤销日期
    ,o.send_out_recs_rgst_b_id -- 发出追索登记簿编号
    ,o.final_modif_teller_id -- 最后修改柜员编号
    ,o.final_modif_teller_tm -- 最后修改柜员时间
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
from ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_bk o
    left join ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_recs_agree_payoff_appl_h;
--alter table ${iml_schema}.agt_recs_agree_payoff_appl_h truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_recs_agree_payoff_appl_h') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_recs_agree_payoff_appl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_recs_agree_payoff_appl_h modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_recs_agree_payoff_appl_h exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_cl;
alter table ${iml_schema}.agt_recs_agree_payoff_appl_h exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_recs_agree_payoff_appl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_recs_agree_payoff_appl_h_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_recs_agree_payoff_appl_h', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
