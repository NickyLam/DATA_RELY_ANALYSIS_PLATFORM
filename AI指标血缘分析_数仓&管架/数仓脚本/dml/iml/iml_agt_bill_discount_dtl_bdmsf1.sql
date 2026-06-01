/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_discount_dtl_bdmsf1
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
drop table ${iml_schema}.agt_bill_discount_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_discount_dtl_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bill_discount_dtl add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bill_discount_dtl modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_discount_dtl_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_discount_dtl partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_discount_dtl_bdmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,discount_dtl_id -- 转贴现明细编号
    ,cont_id -- 合同编号
    ,bill_id -- 票据编号
    ,bill_amt -- 贴现票据金额
    ,bill_exp_dt -- 票据到期日期
    ,actl_exp_dt -- 实际到期日期
    ,surp_tenor -- 剩余期限
    ,exp_surp_tenor -- 到期剩余期限
    ,int_paybl -- 应付利息
    ,exp_int_paybl -- 到期应付利息
    ,stl_amt -- 转贴现金额
    ,exp_stl_amt -- 到期结算金额
    ,lmt_ocup_status_cd -- 额度占用状态代码
    ,proc_status_cd -- 处理状态代码
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_id -- 信用主体编号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,bf_split_intrv_id -- 拆前区间编号
    ,init_bill_amt -- 原始票据金额
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间号
    ,fir_buy_src_cd -- 首次买入来源代码
    ,fir_cntpty_cust_id -- 首次交易对手客户编号
    ,fir_cntpty_name -- 首次交易对手名称
    ,fir_cntpty_ibank_no -- 首次交易对手联行号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_discount_dtl
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bill_discount_dtl_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bill_discount_dtl partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_cpes_quote_details-
insert into ${iml_schema}.agt_bill_discount_dtl_bdmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,discount_dtl_id -- 转贴现明细编号
    ,cont_id -- 合同编号
    ,bill_id -- 票据编号
    ,bill_amt -- 贴现票据金额
    ,bill_exp_dt -- 票据到期日期
    ,actl_exp_dt -- 实际到期日期
    ,surp_tenor -- 剩余期限
    ,exp_surp_tenor -- 到期剩余期限
    ,int_paybl -- 应付利息
    ,exp_int_paybl -- 到期应付利息
    ,stl_amt -- 转贴现金额
    ,exp_stl_amt -- 到期结算金额
    ,lmt_ocup_status_cd -- 额度占用状态代码
    ,proc_status_cd -- 处理状态代码
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_id -- 信用主体编号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,bf_split_intrv_id -- 拆前区间编号
    ,init_bill_amt -- 原始票据金额
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间号
    ,fir_buy_src_cd -- 首次买入来源代码
    ,fir_cntpty_cust_id -- 首次交易对手客户编号
    ,fir_cntpty_name -- 首次交易对手名称
    ,fir_cntpty_ibank_no -- 首次交易对手联行号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223103'||P1.ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ID -- 转贴现明细编号
    ,P1.CONTRACT_ID -- 合同编号
    ,P1.DRAFT_ID -- 票据编号
    ,P1.DRAFT_AMOUNT -- 贴现票据金额
    ,${iml_schema}.DATEFORMAT_MAX2(P1.MATURITY_DATE) -- 票据到期日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.REAL_DUE_DATE) -- 实际到期日期
    ,P1.TENOR_DAYS -- 剩余期限
    ,P1.DUE_TENOR_DAYS -- 到期剩余期限
    ,P1.PAY_INTEREST -- 应付利息
    ,P1.DUE_PAY_INTEREST -- 到期应付利息
    ,P1.SETTLE_AMT -- 转贴现金额
    ,P1.DUE_SETTLE_AMT -- 到期结算金额
    ,NVL(TRIM(P1.CREDIT_STATUS),'-') -- 额度占用状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DETAILS_STATUS END -- 处理状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_STATUS END -- 记账状态代码
    ,NVL(TRIM(P1.VALID_FLAG),'-') -- 有效标志
    ,nvl(trim(P1.CREDIT_TYPE),'000') -- 信用主体类型代码
    ,P1.CREDIT_BRANCH -- 信用主体编号
    ,P1.STANDARD_AMT -- 票据区间标准金额
    ,P1.SPLIT_RANGE -- 拆前区间编号
    ,P1.ORG_DRAFT_AMOUNT -- 原始票据金额
    ,P1.DRAFT_NUMBER -- 票据号码
    ,P1.CD_RANGE -- 票据子区间号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||nvl(P2.FIRSTSOURCE,' ') END  -- 首次买入来源代码 
    ,nvl(trim(P2.FIRSTSOURCECUSTNO),' ') -- 首次交易对手客户编号
    ,nvl(trim(P2.FIRSTCUSTNAME),' ') -- 首次交易对手名称
    ,nvl(trim(P2.FRISTBANKNO),' ') -- 首次交易对手联行号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_quote_details' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_quote_details p1
    left join ${iol_schema}.bdms_view_buy_firstsource_info p2 
     on p1.draft_number = p2.draftnumber and p1.CD_RANGE = p2.CDRANGE
     and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DETAILS_STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CPES_QUOTE_DETAILS'
        AND R1.SRC_FIELD_EN_NAME= 'DETAILS_STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCOUNT_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PROC_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ACCOUNT_STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CPES_QUOTE_DETAILS'
        AND R2.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCOUNT_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on nvl(P2.FIRSTSOURCE,' ') = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_VIEW_BUY_FIRSTSOURCE_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'FIRSTSOURCE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_BILL_DISCOUNT_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'FIR_BUY_SRC_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_discount_dtl_bdmsf1_tm 
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_bill_discount_dtl_bdmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,discount_dtl_id -- 转贴现明细编号
    ,cont_id -- 合同编号
    ,bill_id -- 票据编号
    ,bill_amt -- 贴现票据金额
    ,bill_exp_dt -- 票据到期日期
    ,actl_exp_dt -- 实际到期日期
    ,surp_tenor -- 剩余期限
    ,exp_surp_tenor -- 到期剩余期限
    ,int_paybl -- 应付利息
    ,exp_int_paybl -- 到期应付利息
    ,stl_amt -- 转贴现金额
    ,exp_stl_amt -- 到期结算金额
    ,lmt_ocup_status_cd -- 额度占用状态代码
    ,proc_status_cd -- 处理状态代码
    ,entry_status_cd -- 记账状态代码
    ,valid_flg -- 有效标志
    ,crdt_main_type_cd -- 信用主体类型代码
    ,crdt_main_id -- 信用主体编号
    ,bill_intrv_std_amt -- 票据区间标准金额
    ,bf_split_intrv_id -- 拆前区间编号
    ,init_bill_amt -- 原始票据金额
    ,bill_num -- 票据号码
    ,bill_sub_intrv_id -- 票据子区间号
    ,fir_buy_src_cd -- 首次买入来源代码
    ,fir_cntpty_cust_id -- 首次交易对手客户编号
    ,fir_cntpty_name -- 首次交易对手名称
    ,fir_cntpty_ibank_no -- 首次交易对手联行号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.discount_dtl_id, o.discount_dtl_id) as discount_dtl_id -- 转贴现明细编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.bill_amt, o.bill_amt) as bill_amt -- 贴现票据金额
    ,nvl(n.bill_exp_dt, o.bill_exp_dt) as bill_exp_dt -- 票据到期日期
    ,nvl(n.actl_exp_dt, o.actl_exp_dt) as actl_exp_dt -- 实际到期日期
    ,nvl(n.surp_tenor, o.surp_tenor) as surp_tenor -- 剩余期限
    ,nvl(n.exp_surp_tenor, o.exp_surp_tenor) as exp_surp_tenor -- 到期剩余期限
    ,nvl(n.int_paybl, o.int_paybl) as int_paybl -- 应付利息
    ,nvl(n.exp_int_paybl, o.exp_int_paybl) as exp_int_paybl -- 到期应付利息
    ,nvl(n.stl_amt, o.stl_amt) as stl_amt -- 转贴现金额
    ,nvl(n.exp_stl_amt, o.exp_stl_amt) as exp_stl_amt -- 到期结算金额
    ,nvl(n.lmt_ocup_status_cd, o.lmt_ocup_status_cd) as lmt_ocup_status_cd -- 额度占用状态代码
    ,nvl(n.proc_status_cd, o.proc_status_cd) as proc_status_cd -- 处理状态代码
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.crdt_main_type_cd, o.crdt_main_type_cd) as crdt_main_type_cd -- 信用主体类型代码
    ,nvl(n.crdt_main_id, o.crdt_main_id) as crdt_main_id -- 信用主体编号
    ,nvl(n.bill_intrv_std_amt, o.bill_intrv_std_amt) as bill_intrv_std_amt -- 票据区间标准金额
    ,nvl(n.bf_split_intrv_id, o.bf_split_intrv_id) as bf_split_intrv_id -- 拆前区间编号
    ,nvl(n.init_bill_amt, o.init_bill_amt) as init_bill_amt -- 原始票据金额
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.bill_sub_intrv_id, o.bill_sub_intrv_id) as bill_sub_intrv_id -- 票据子区间号
    ,nvl(n.fir_buy_src_cd, o.fir_buy_src_cd) as fir_buy_src_cd -- 首次买入来源代码
    ,nvl(n.fir_cntpty_cust_id, o.fir_cntpty_cust_id) as fir_cntpty_cust_id -- 首次交易对手客户编号
    ,nvl(n.fir_cntpty_name, o.fir_cntpty_name) as fir_cntpty_name -- 首次交易对手名称
    ,nvl(n.fir_cntpty_ibank_no, o.fir_cntpty_ibank_no) as fir_cntpty_ibank_no -- 首次交易对手联行号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.discount_dtl_id <> n.discount_dtl_id
                or o.cont_id <> n.cont_id
                or o.bill_id <> n.bill_id
                or o.bill_amt <> n.bill_amt
                or o.bill_exp_dt <> n.bill_exp_dt
                or o.actl_exp_dt <> n.actl_exp_dt
                or o.surp_tenor <> n.surp_tenor
                or o.exp_surp_tenor <> n.exp_surp_tenor
                or o.int_paybl <> n.int_paybl
                or o.exp_int_paybl <> n.exp_int_paybl
                or o.stl_amt <> n.stl_amt
                or o.exp_stl_amt <> n.exp_stl_amt
                or o.lmt_ocup_status_cd <> n.lmt_ocup_status_cd
                or o.proc_status_cd <> n.proc_status_cd
                or o.entry_status_cd <> n.entry_status_cd
                or o.valid_flg <> n.valid_flg
                or o.crdt_main_type_cd <> n.crdt_main_type_cd
                or o.crdt_main_id <> n.crdt_main_id
                or o.bill_intrv_std_amt <> n.bill_intrv_std_amt
                or o.bf_split_intrv_id <> n.bf_split_intrv_id
                or o.init_bill_amt <> n.init_bill_amt
                or o.bill_num <> n.bill_num
                or o.bill_sub_intrv_id <> n.bill_sub_intrv_id
                or o.fir_buy_src_cd <> n.fir_buy_src_cd
                or o.fir_cntpty_cust_id <> n.fir_cntpty_cust_id
                or o.fir_cntpty_name <> n.fir_cntpty_name
                or o.fir_cntpty_ibank_no <> n.fir_cntpty_ibank_no
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_discount_dtl_bdmsf1_tm n
    full join ${iml_schema}.agt_bill_discount_dtl_bdmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bill_discount_dtl truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bill_discount_dtl exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_discount_dtl_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bill_discount_dtl drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_discount_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bill_discount_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_discount_dtl_bdmsf1_ex purge;
drop table ${iml_schema}.agt_bill_discount_dtl_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_discount_dtl', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);